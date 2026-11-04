import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 量子化身：量子世界裡的光球頭像（規格：docs/quantum-world-spec.md §5.5，伺服器：geo-service/orbs.js）。
/// 光球的主色永遠跟著心情；款式只改變紋路和光暈，不影響任何權益。
/// 基本款免費；特殊款用 Apple / Google 內購買斷，買過的款式跟著帳號（orbOwned/{uid}，只有伺服器寫得進去）。

const _orbsUrl = String.fromEnvironment('ORBS_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/orbs');

/// 所有款式，依面板上的順序；和 geo-service/orbs.js 的 STYLES 相同
const orbStyles = ['glow', 'ring', 'rainbow'];
const orbDefaultStyle = 'glow';

/// 特殊款的商店商品代號（App Store Connect 與 Play Console 都用同一個代號）
const orbProducts = {'rainbow': 'orb_rainbow'};

bool orbIsFree(String style) => !orbProducts.containsKey(style);
String orbStyleOf(Object? raw) => raw is String && orbStyles.contains(raw) ? raw : orbDefaultStyle;

String orbStyleName(String style) => switch (style) {
      'ring' => tr.orbStyleRing,
      'rainbow' => tr.orbStyleRainbow,
      _ => tr.orbStyleGlow,
    };

// ---------- 光球 ----------

/// 大頭貼網址 → 球型頭像用的圖；沒有大頭貼時是 null（畫成一顆心情色的光球）
ImageProvider? orbImage(String? url) => url == null || url.isEmpty ? null : NetworkImage(url);

/// 球型頭像：大頭貼包在一顆玻璃球裡，球緣透出心情色、左上有高光，外面一圈呼吸光暈。
/// 星環款外面多一圈傾斜的環（後半圈在球後面，看起來是立體的），彩虹款是整圈繞著頭像、慢慢轉的正圓虹光。
/// 用 2D 漸層畫出立體感，不跑 3D 模型，蜂巢裡幾百顆也不會卡。沒有大頭貼時是一顆心情色的光球。
class QuantumOrb extends StatelessWidget {
  final String style;
  final Color color;
  final double size;
  final double glow; // 0～1：呼吸光暈
  final bool dim; // 殘影、休息中
  final ImageProvider? image; // 大頭貼
  const QuantumOrb({super.key, required this.style, required this.color, this.size = 30, this.glow = 0.5, this.dim = false, this.image});

  /// 球的直徑佔畫布的比例：光暈和環都畫在畫布裡面（超出的部分在某些容器裡會被切成方形）。
  /// 付費的彩虹款球比較大（地圖上約 31，免費款約 26），畫布一樣大，換款式不會讓版面跳動。
  static double sphereRatio(String style) => style == 'rainbow' ? 0.56 : 0.465;

  @override
  Widget build(BuildContext context) {
    // 彩虹光環會轉：用時間算角度，跟著氣泡的呼吸動畫一起重畫
    final spin = style == 'rainbow' ? (DateTime.now().millisecondsSinceEpoch % 6000) / 6000 * 2 * pi : 0.0;
    final d = size * sphereRatio(style);
    final photo = image;
    painter(bool front) => QuantumOrbPainter(style: style, color: color, glow: glow, dim: dim, spin: spin, front: front, photo: photo != null);
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: CustomPaint(painter: painter(false))),
        if (photo != null)
          ClipOval(
            child: ColorFiltered(
              // 殘影的大頭貼去色，和活躍的人一眼分得出來
              colorFilter: dim
                  ? const ColorFilter.matrix(<double>[0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0,0,0,1,0])
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image(image: photo, width: d, height: d, fit: BoxFit.cover, errorBuilder: (_, __, ___) => SizedBox(width: d, height: d)),
            ),
          ),
        Positioned.fill(child: CustomPaint(painter: painter(true))),
      ]),
    );
  }
}

/// 分兩層畫：後層（光暈、環的後半圈、球底色）在大頭貼下面，前層（球面光澤、環的前半圈）在大頭貼上面
class QuantumOrbPainter extends CustomPainter {
  final String style;
  final Color color;
  final double glow;
  final bool dim;
  final double spin;
  final bool front;
  final bool photo;
  QuantumOrbPainter({required this.style, required this.color, this.glow = 0.5, this.dim = false, this.spin = 0, this.front = false, this.photo = false});

  static const _rainbow = [Color(0xFFFF6B6B), Color(0xFFFFD166), Color(0xFF6BE38E), Color(0xFF4FC3F7), Color(0xFF9C7BFF), Color(0xFFFF7BD5), Color(0xFFFF6B6B)];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * QuantumOrb.sphereRatio(style) / 2;
    final base = dim ? Color.lerp(color, Night.shadowInk, 0.6)! : color;
    final sphere = Rect.fromCircle(center: c, radius: r);

    // 星環：傾斜的橢圓，後半圈在球後面、前半圈在球前面
    void ring(bool back) {
      if (style != 'ring') return;
      final rect = Rect.fromCenter(center: c, width: r * 3.05, height: r * 0.95);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(1.4, r * 0.13)
        ..color = Color.lerp(base, Colors.white, 0.45)!.withOpacity(dim ? 0.4 : 0.9);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(-0.38);
      canvas.translate(-c.dx, -c.dy);
      if (!dim) {
        canvas.drawArc(rect, back ? pi : 0, pi, false, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth * 2.2
          ..color = base.withOpacity(0.25)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.1));
      }
      canvas.drawArc(rect, back ? pi : 0, pi, false, paint);
      canvas.restore();
    }

    // 彩虹款：整圈繞著頭像的正圓虹光，顏色慢慢轉
    void halo() {
      if (style != 'rainbow') return;
      final rect = Rect.fromCircle(center: c, radius: r * 1.36);
      final shader = SweepGradient(colors: [for (final k in _rainbow) k.withOpacity(dim ? 0.35 : 0.95)], transform: GradientRotation(spin)).createShader(rect);
      if (!dim) {
        canvas.drawCircle(c, r * 1.36, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.32
          ..shader = shader
          ..color = Colors.white.withOpacity(0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.14));
      }
      canvas.drawCircle(c, r * 1.36, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(2.0, r * 0.14)
        ..shader = shader);
    }

    if (!front) {
      // 光暈
      if (!dim) {
        canvas.drawCircle(c, r * (1.12 + 0.15 * glow),
            Paint()..color = base.withOpacity(0.3 + 0.25 * glow)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.25));
      }
      ring(true);
      halo();
      // 球的底色：沒有大頭貼時就是一顆心情色的光球
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.05,
          colors: [Color.lerp(base, Colors.white, 0.65)!, base, Color.lerp(base, const Color(0xFF070B1F), 0.55)!],
          stops: const [0, 0.5, 1],
        ).createShader(sphere));
      return;
    }

    if (photo) {
      // 玻璃球：中間清楚看得到大頭貼，越往球緣越透出心情色，右下偏暗
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.25),
          radius: 1.0,
          colors: [Colors.transparent, base.withOpacity(0.18), base.withOpacity(dim ? 0.4 : 0.75)],
          stops: const [0, 0.55, 1],
        ).createShader(sphere));
      canvas.drawCircle(c, r, Paint()
        ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.transparent, const Color(0xFF070B1F).withOpacity(0.5)], stops: const [0, 0.5, 1]).createShader(sphere));
      // 球緣一圈心情色的細邊
      canvas.drawCircle(c, r - 0.6, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = base.withOpacity(dim ? 0.5 : 0.9));
    }

    // 水晶球：球緣一圈厚玻璃的亮邊、上方一片窗光倒影、底部聚光、左上一點銳利的反光
    final k = dim ? 0.4 : 1.0;
    canvas.save();
    canvas.clipPath(Path()..addOval(sphere));
    canvas.drawCircle(c, r, Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.transparent, Colors.white.withOpacity(0.22 * k), Colors.white.withOpacity(0.55 * k)],
        stops: const [0, 0.78, 0.94, 1],
      ).createShader(sphere));
    final window = Rect.fromCenter(center: c + Offset(-r * 0.05, -r * 0.5), width: r * 1.45, height: r * 0.85);
    canvas.drawOval(window, Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.6 * k), Colors.white.withOpacity(0.12 * k), Colors.transparent], stops: const [0, 0.55, 1]).createShader(window));
    final caustic = Rect.fromCenter(center: c + Offset(r * 0.05, r * 0.78), width: r * 1.3, height: r * 0.6);
    canvas.drawOval(caustic, Paint()
      ..shader = RadialGradient(colors: [Color.lerp(base, Colors.white, 0.6)!.withOpacity(0.6 * k), Colors.transparent]).createShader(caustic)
      ..blendMode = BlendMode.screen);
    canvas.restore();
    // 球緣：左上亮、右下淡的細光邊
    canvas.drawCircle(c, r - 0.5, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.0, r * 0.05)
      ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.85 * k), Colors.white.withOpacity(0.15 * k), Colors.white.withOpacity(0.5 * k)]).createShader(sphere));
    canvas.drawOval(Rect.fromCenter(center: c + Offset(-r * 0.5, -r * 0.42), width: r * 0.26, height: r * 0.16),
        Paint()..color = Colors.white.withOpacity(0.9 * k)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.03));

    ring(false);
  }

  @override
  bool shouldRepaint(QuantumOrbPainter old) =>
      old.style != style || old.color != color || old.glow != glow || old.dim != dim || old.spin != spin || old.front != front || old.photo != photo;
}

// ---------- 選擇的款式 ----------

class OrbPrefs {
  OrbPrefs._();
  static const _key = 'quantum_orb';
  static final style = ValueNotifier<String>(orbDefaultStyle);

  static Future<void> load() async => style.value = orbStyleOf((await SharedPreferences.getInstance()).getString(_key));

  static Future<void> set(String s) async {
    style.value = orbStyleOf(s);
    (await SharedPreferences.getInstance()).setString(_key, style.value);
  }
}

// ---------- 內購 ----------

/// 特殊款的購買：向商店付款 → 交給伺服器驗證 → 伺服器記到帳號上 → 才通知商店交易完成
class OrbStore {
  OrbStore._();

  static final owned = ValueNotifier<Set<String>>(const {});
  static final products = ValueNotifier<Map<String, ProductDetails>>(const {});
  static final busy = ValueNotifier<bool>(false);
  /// 購買結果的提示文字（面板顯示一次後清掉）
  static final notice = ValueNotifier<String?>(null);

  static StreamSubscription<List<PurchaseDetails>>? _sub;
  /// 啟動時的背景補送：只補驗證沒完成的交易，不顯示提示
  static bool _silent = false;

  /// App 啟動時呼叫一次：開始聽購買結果（包含上次沒完成的交易）
  static void init() {
    if (_sub != null) return;
    _sub = InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (_) => busy.value = false);
    // iOS 會自己重送沒完成的交易；Android 不會，3 天內沒確認就自動退款，所以啟動時主動查一次
    if (Platform.isAndroid) {
      _silent = true;
      InAppPurchase.instance.restorePurchases().catchError((_) {});
      Future.delayed(const Duration(seconds: 15), () => _silent = false);
    }
  }

  /// 讀自己買過的款式；選了沒買過的特殊款（例如換了帳號）就回到基本款
  static Future<void> loadOwned() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final snap = await FirebaseDatabase.instance.ref('orbOwned/$uid').get();
      final value = snap.value;
      owned.value = value is Map ? {for (final k in value.keys) '$k'} : const {};
    } catch (_) {}
    if (!orbIsFree(OrbPrefs.style.value) && !owned.value.contains(OrbPrefs.style.value)) await OrbPrefs.set(orbDefaultStyle);
  }

  /// 打開面板時查價格（當地貨幣，由商店決定）
  static Future<void> loadProducts() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) return;
      final response = await InAppPurchase.instance.queryProductDetails(orbProducts.values.toSet());
      products.value = {for (final p in response.productDetails) p.id: p};
    } catch (_) {}
  }

  static Future<void> buy(String style) async {
    _silent = false;
    final product = products.value[orbProducts[style]];
    if (product == null) { notice.value = tr.orbStoreUnavailable; return; }
    busy.value = true;
    try {
      final started = await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.orbPurchaseFailed;
    }
  }

  static Future<void> restore() async {
    _silent = false;
    busy.value = true;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (_) {
      notice.value = tr.orbPurchaseFailed;
    }
    // 沒有可恢復的購買時商店不會回傳任何東西：稍後重新讀一次擁有的款式就結束
    Future.delayed(const Duration(seconds: 4), () async {
      await loadOwned();
      busy.value = false;
    });
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    if (_silent) return _verifyPending(list);
    final toVerify = <PurchaseDetails>[];
    for (final p in list) {
      // 同一個購買串流也會收到艾婭時光包，那些交給 AiyaStore 處理
      if (!orbProducts.containsValue(p.productID)) continue;
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled:
          busy.value = false;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.error:
          busy.value = false;
          notice.value = tr.orbPurchaseFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          if (orbProducts.containsValue(p.productID)) toVerify.add(p);
      }
    }
    if (toVerify.isEmpty) return;
    final (granted, owner) = await _verify(toVerify);
    // 伺服器確認過（或這筆已經屬於別的帳號、不必再試）才結束交易；連不上時留著，下次啟動會再送一次
    for (final p in toVerify) {
      final style = orbProducts.entries.firstWhere((e) => e.value == p.productID).key;
      if ((granted.contains(style) || owner.contains(p.productID)) && p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
    }
    busy.value = false;
    if (granted.isNotEmpty) {
      notice.value = tr.orbPurchased(orbStyleName(granted.first));
      // 剛買的款式直接換上
      if (toVerify.any((p) => p.status == PurchaseStatus.purchased)) await OrbPrefs.set(granted.first);
    } else if (owner.isNotEmpty) {
      notice.value = tr.orbOwnedElsewhere;
    } else {
      notice.value = tr.orbPurchaseFailed;
    }
  }

  /// 背景補送：伺服器確認過才結束交易，已經確認過的不再送
  static Future<void> _verifyPending(List<PurchaseDetails> list) async {
    final pending = [for (final p in list) if (p.pendingCompletePurchase && orbProducts.containsValue(p.productID) && (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)) p];
    if (pending.isEmpty) return;
    final (granted, owner) = await _verify(pending);
    for (final p in pending) {
      final style = orbProducts.entries.firstWhere((e) => e.value == p.productID).key;
      if (granted.contains(style) || owner.contains(p.productID)) await InAppPurchase.instance.completePurchase(p);
    }
  }

  /// 回傳 (伺服器確認的款式, 已經屬於別的帳號的商品)
  static Future<(Set<String>, Set<String>)> _verify(List<PurchaseDetails> list) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final purchases = [
        for (final p in list)
          Platform.isIOS
              ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
              : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
      ];
      final response = await http.post(Uri.parse(_orbsUrl),
          headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
          body: jsonEncode({'action': 'verify', 'purchases': purchases}));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['owned'] is List) owned.value = {for (final s in data['owned'] as List) '$s'};
      final failed = (data['failed'] as List? ?? const []).whereType<Map>();
      return (
        {for (final s in data['granted'] as List? ?? const []) '$s'},
        {for (final f in failed) if (f['code'] == 'owned_elsewhere') '${f['productId']}'},
      );
    } catch (_) {
      return (<String>{}, <String>{});
    }
  }
}

// ---------- 面板 ----------

/// 量子化身面板：預覽每一款（用自己現在的心情色），免費款直接換，特殊款購買
Future<void> showOrbSheet(BuildContext context, {required Color moodColor, String avatarUrl = ''}) {
  OrbStore.loadProducts();
  OrbStore.loadOwned();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => _OrbSheet(moodColor: moodColor, image: orbImage(avatarUrl)),
  );
}

class _OrbSheet extends StatefulWidget {
  final Color moodColor;
  final ImageProvider? image;
  const _OrbSheet({required this.moodColor, this.image});
  @override
  State<_OrbSheet> createState() => _OrbSheetState();
}

class _OrbSheetState extends State<_OrbSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  String? _notice; // 購買結果：顯示在面板裡（SnackBar 會被面板蓋住）
  Timer? _noticeTimer;

  @override
  void initState() {
    super.initState();
    OrbStore.notice.addListener(_showNotice);
  }

  @override
  void dispose() {
    OrbStore.notice.removeListener(_showNotice);
    _noticeTimer?.cancel();
    _breath.dispose();
    super.dispose();
  }

  void _showNotice() {
    final text = OrbStore.notice.value;
    if (text == null || !mounted) return;
    OrbStore.notice.value = null;
    setState(() => _notice = text);
    _noticeTimer?.cancel();
    _noticeTimer = Timer(const Duration(seconds: 5), () { if (mounted) setState(() => _notice = null); });
  }

  Widget _tile(String style, String selected, Set<String> owned, Map<String, ProductDetails> products, bool busy) {
    final free = orbIsFree(style);
    final has = free || owned.contains(style);
    final isSelected = selected == style;
    final price = products[orbProducts[style]]?.price;
    return GestureDetector(
      onTap: busy ? null : () => has ? OrbPrefs.set(style) : OrbStore.buy(style),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: Night.space3, horizontal: Night.space2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x332A2F6A) : Night.night700.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Night.auroraViolet : Night.glassLine, width: isSelected ? 1.6 : 1),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
            animation: _breath,
            builder: (context, _) => QuantumOrb(style: style, color: widget.moodColor, size: 84, glow: _breath.value, image: widget.image),
          ),
          const SizedBox(height: Night.space2),
          Text(orbStyleName(style), style: const TextStyle(color: Night.ink, fontSize: 14)),
          const SizedBox(height: 2),
          Text(
            isSelected ? tr.orbInUse : (free ? tr.orbFree : (has ? tr.orbOwned : (price ?? '—'))),
            style: Night.caption.copyWith(color: isSelected ? Night.auroraViolet : (has ? Night.inkMuted : Night.knockPink)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        // 面板疊在量子世界設定上面：先墊一層實心底色，後面的文字才不會透出來
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr.orbTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space1),
            Text(tr.orbSubtitle, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
            AnimatedBuilder(
              animation: Listenable.merge([OrbPrefs.style, OrbStore.owned, OrbStore.products, OrbStore.busy]),
              builder: (context, _) => Row(children: [
                for (final (i, style) in orbStyles.indexed) ...[
                  if (i > 0) const SizedBox(width: Night.space2),
                  Expanded(child: _tile(style, OrbPrefs.style.value, OrbStore.owned.value, OrbStore.products.value, OrbStore.busy.value)),
                ],
              ]),
            ),
            if (_notice case final notice?) ...[
              const SizedBox(height: Night.space3),
              Text(notice, style: const TextStyle(color: Night.knockPink, fontSize: 14), textAlign: TextAlign.center),
            ],
            const SizedBox(height: Night.space3),
            Text(tr.orbCosmeticNote, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            ValueListenableBuilder<bool>(
              valueListenable: OrbStore.busy,
              builder: (context, busy, _) => busy
                  ? const Center(child: Padding(padding: EdgeInsets.all(Night.space2), child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Night.auroraViolet))))
                  : TextButton(onPressed: OrbStore.restore, style: TextButton.styleFrom(foregroundColor: Night.inkMuted, minimumSize: const Size(44, 44)), child: Text(tr.orbRestore)),
            ),
          ]),
          ),
        ),
      ),
    );
  }
}
