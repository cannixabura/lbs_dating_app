import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'assembly_live.dart';
import 'l10n/l10n.dart';
import 'mood_card.dart';
import 'quantum_world.dart';
import 'report_sheet.dart';
import 'translate.dart';
import 'ui/night.dart';

// ============================================================================
// 量子集會（規格：docs/quantum-assembly-spec.md）
// Q3：主持人坐進第 3 圈的保留席；參加者留在自己的席位自願加入。
// Q2：主持席在第 2 圈，另外有語音直播與文字提問（assembly_live.dart）。
// 主持人發公告、觸發「量子應援」（所有參加者的光球在同一刻閃成同一個顏色）；結束後有匿名紀念卡。
// 資料：qAssemblies/{id}（公開、不含 uid）、qAssemblyActive/{id}、qAssemblyVouchers/{uid}（主辦券）
// ============================================================================

const assemblyColors = [Color(0xFFB79CFF), Color(0xFFFF8AD8), Color(0xFF7FD8FF), Color(0xFFFFD27A), Color(0xFF8AFFC8), Color(0xFFFF7F7F)];
const assemblyEmojis = ['🎉', '🎵', '💜', '🌈', '🎂', '🌙', '✨', '🔥', '🌸', '🎄'];
const assemblyCountdowns = [0, 3, 5, 10];
const assemblyMaxTitle = 20;
const assemblyMaxAnnounce = 100;

String colorHex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
Color colorOfHex(Object? hex) {
  final s = '$hex'.replaceFirst('#', '');
  final v = int.tryParse(s, radix: 16);
  return v == null ? assemblyColors.first : Color(0xFF000000 | v);
}

class QAssembly {
  final String id, title, emoji, plan, tier, host, code, status;
  /// Q2：台上來賓（房間身分 → 暱稱）、舉手人數
  final Map<String, String> speakers;
  final int hands;
  final Color color;
  final double lat, lng;
  final int startAt, endAt, cap, count;
  final ({String text, int at})? announce;
  final ({Color color, int fireAt, int at})? cheer;
  final ({int count, Map<String, int> regions})? summary;
  const QAssembly({required this.id, required this.title, required this.emoji, required this.plan, required this.host, required this.code,
      required this.status, required this.color, required this.lat, required this.lng, required this.startAt, required this.endAt,
      required this.cap, required this.count, this.announce, this.cheer, this.summary, this.tier = 'q3', this.speakers = const {}, this.hands = 0});

  bool get active => status == 'active';
  bool get isQ2 => tier == 'q2';

  static QAssembly? parse(String id, Object? v) {
    if (v is! Map) return null;
    int n(Object? x) => x is num ? x.toInt() : 0;
    double d(Object? x) => x is num ? x.toDouble() : 0;
    final a = v['announce'], c = v['cheer'], s = v['summary'];
    return QAssembly(
      id: id,
      title: '${v['title'] ?? ''}',
      emoji: '${v['emoji'] ?? '✨'}',
      plan: '${v['plan'] ?? 'free'}',
      tier: '${v['tier'] ?? 'q3'}',
      speakers: {for (final e in ((v['speakers'] is Map ? v['speakers'] : const {}) as Map).entries) '${e.key}': '${e.value}'},
      hands: n(v['hands']),
      host: '${v['host'] ?? ''}',
      code: '${v['code'] ?? ''}',
      status: '${v['status'] ?? 'ended'}',
      color: colorOfHex(v['color']),
      lat: d(v['lat']), lng: d(v['lng']),
      startAt: n(v['startAt']), endAt: n(v['endAt']), cap: n(v['cap']), count: n(v['count']),
      announce: a is Map ? (text: '${a['text'] ?? ''}', at: n(a['at'])) : null,
      cheer: c is Map ? (color: colorOfHex(c['color']), fireAt: n(c['fireAt']), at: n(c['at'])) : null,
      summary: s is Map
          ? (count: n(s['count']), regions: {for (final e in ((s['regions'] as Map?) ?? const {}).entries) '${e.key}': n(e.value)})
          : null,
    );
  }
}

/// 量子世界裡進行中的集會（即時同步）、自己加入／主持中的集會、應援與紀念卡事件
class AssemblyState {
  static final active = ValueNotifier<Map<String, QAssembly>>(const {});
  static final myAsm = ValueNotifier<String?>(null); // 加入中的集會
  static final hostAsm = ValueNotifier<String?>(null); // 主持中的集會
  /// 最新一次應援（參加者與主持人才會收到）：全螢幕倒數與光爆
  static final cheer = ValueNotifier<({String id, Color color, int fireAt})?>(null);
  /// 剛結束、自己有參加或主持的集會：顯示紀念卡
  static final memorial = ValueNotifier<QAssembly?>(null);
  static final options = ValueNotifier<AsmOptions?>(null);

  static int _offset = 0; // 伺服器時間 − 手機時間（毫秒）
  static StreamSubscription<DatabaseEvent>? _offsetSub, _addSub, _removeSub;
  static final Map<String, StreamSubscription<DatabaseEvent>> _subs = {};
  static final Map<String, int> _seenCheer = {};
  static final Set<String> _involved = {}; // 這次入場參加或主持過的集會（結束時要不要顯示紀念卡）

  static final Set<String> _shownMemorials = {}; // 這次開 App 已經顯示過的紀念卡（不重複跳）

  /// 主持人不在量子世界時結束的集會：入場時伺服器補給的紀念卡
  static Future<void> showMissedMemorial(String? id) async {
    if (id == null || id.isEmpty || _shownMemorials.contains(id)) return;
    try {
      final snap = await FirebaseDatabase.instance.ref('qAssemblies/$id').get();
      final a = QAssembly.parse(id, snap.value);
      if (a != null && a.summary != null && _shownMemorials.add(id)) memorial.value = a;
    } catch (_) {}
  }

  static int get serverNow => DateTime.now().millisecondsSinceEpoch + _offset;

  static Timer? _soonTimer;
  static final Map<String, int> _soonWarned = {}; // 集會 id → 已提醒過的結束時間（延長後會再提醒）

  /// 主持人：集會剩不到 10 分鐘時提醒一次可以延長
  static void _checkEndingSoon() {
    final id = hostAsm.value;
    final a = id == null ? null : active.value[id];
    if (a == null || !a.active) return;
    final left = a.endAt - serverNow;
    if (left > 0 && left <= 10 * 60 * 1000 && _soonWarned[a.id] != a.endAt) {
      _soonWarned[a.id] = a.endAt;
      AssemblyStore.notice.value = tr.asmEndingSoon;
    }
  }

  /// 進入量子世界時開始聽；離開時停止
  static void start() {
    if (_addSub != null) return;
    AssemblyLive.hook();
    _soonTimer ??= Timer.periodic(const Duration(seconds: 20), (_) => _checkEndingSoon());
    final db = FirebaseDatabase.instance;
    _offsetSub = db.ref('.info/serverTimeOffset').onValue.listen((e) => _offset = (e.snapshot.value as num?)?.toInt() ?? 0, onError: (_) {});
    _addSub = db.ref('qAssemblyActive').onChildAdded.listen((e) => _watch(e.snapshot.key), onError: (_) {});
    _removeSub = db.ref('qAssemblyActive').onChildRemoved.listen((e) {
      final id = e.snapshot.key;
      if (id == null) return;
      // 結束後再讀一次（拿到紀念卡數據），然後停止聽
      Future.delayed(const Duration(seconds: 2), () async {
        try {
          final snap = await db.ref('qAssemblies/$id').get();
          final a = QAssembly.parse(id, snap.value);
          if (a != null && a.summary != null && _involved.contains(id) && _shownMemorials.add(id)) memorial.value = a;
        } catch (_) {}
        _involved.remove(id);
        if (myAsm.value == id) myAsm.value = null;
        if (hostAsm.value == id) hostAsm.value = null;
        _subs.remove(id)?.cancel();
        active.value = {...active.value}..remove(id);
      });
    }, onError: (_) {});
  }

  static void stop() {
    AssemblyLive.disconnect();
    for (final s in _subs.values) {
      s.cancel();
    }
    _subs.clear();
    _addSub?.cancel();
    _removeSub?.cancel();
    _offsetSub?.cancel();
    _addSub = _removeSub = _offsetSub = null;
    _soonTimer?.cancel();
    _soonTimer = null;
    active.value = const {};
    myAsm.value = null;
    hostAsm.value = null;
    _involved.clear();
  }

  static void _watch(String? id) {
    if (id == null || _subs.containsKey(id)) return;
    _subs[id] = FirebaseDatabase.instance.ref('qAssemblies/$id').onValue.listen((e) {
      final a = QAssembly.parse(id, e.snapshot.value);
      if (a == null) return;
      active.value = {...active.value, id: a};
      final c = a.cheer;
      if (c != null && (_seenCheer[id] ?? 0) < c.at) {
        final first = !_seenCheer.containsKey(id);
        _seenCheer[id] = c.at;
        // 剛開始聽時的舊應援不播；只播還沒到、或剛發生的
        final mine = myAsm.value == id || hostAsm.value == id;
        if (mine && (!first || c.fireAt > serverNow - 1000) && c.fireAt > serverNow - 3000) cheer.value = (id: id, color: c.color, fireAt: c.fireAt);
      }
    }, onError: (_) {});
  }

  /// 心跳回來的 me：加入中的集會、主持中的集會
  static void setMe(Map<String, dynamic>? me) {
    final asm = me?['asm'] as String?, host = me?['hostAsm'] as String?;
    if (myAsm.value != asm) myAsm.value = asm;
    if (hostAsm.value != host) hostAsm.value = host;
    if (asm != null) _involved.add(asm);
    if (host != null) _involved.add(host);
  }

  static Future<void> refreshOptions() async {
    final (status, data) = await QuantumApi.assembly('asmStatus');
    if (status == 200 && data['success'] == true) _setOptions(data);
  }

  static void _setOptions(Map<String, dynamic> data) {
    final v = (data['vouchers'] as Map?) ?? const {};
    options.value = AsmOptions(
      free: data['free'] == true,
      q2: data['q2'] == true,
      vouchers: {for (final e in v.entries) '${e.key}': (e.value as num?)?.toInt() ?? 0},
    );
  }

  static Future<String?> join(String id) async {
    final (_, data) = await QuantumApi.assembly('asmJoin', {'id': id});
    if (data['success'] == true) {
      myAsm.value = id;
      _involved.add(id);
      return null;
    }
    return data['code'] as String? ?? 'error';
  }

  static Future<void> leave(String id) async {
    await QuantumApi.assembly('asmLeave', {'id': id});
    if (myAsm.value == id) myAsm.value = null;
    _involved.remove(id);
  }
}

/// 這個人可以用的方案：本月免費場、各方案還沒用的主辦券、Q2 是否開放（直播主機設定好才開放）
class AsmOptions {
  final bool free, q2;
  final Map<String, int> vouchers;
  const AsmOptions({required this.free, required this.q2, required this.vouchers});
  int v(String plan) => vouchers[plan] ?? 0;
}

/// 主辦券的內購（消耗性）：驗證後伺服器發一張券；買完自動開剛才填好的集會
class AssemblyStore {
  static const products = {'1h': 'assembly_q3_1h', '2h': 'assembly_q3_2h', 'q2_1h': 'assembly_q2_1h', 'q2_2h': 'assembly_q2_2h'};
  static final details = ValueNotifier<Map<String, ProductDetails>>(const {});
  static final busy = ValueNotifier<bool>(false);
  static final notice = ValueNotifier<String?>(null);
  static StreamSubscription<List<PurchaseDetails>>? _sub;
  /// 買完要做的事（開集會或延長），回傳錯誤代碼或 null；沒有就只是多買一張券
  static Future<String?> Function()? _after;
  static String? _afterOk;

  static void init() {
    _sub ??= InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (_) => busy.value = false);
  }

  static Future<void> loadProducts() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) return;
      final response = await InAppPurchase.instance.queryProductDetails(products.values.toSet());
      details.value = {for (final p in response.productDetails) p.id: p};
    } catch (_) {}
  }

  static String? price(String plan) => details.value[products[plan]]?.price;

  static Future<bool> buy(String plan, {Future<String?> Function()? after, String? ok}) async {
    final product = details.value[products[plan]];
    if (product == null) return false;
    _after = after;
    _afterOk = ok;
    busy.value = true;
    try {
      final started = await InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: product), autoConsume: true);
      if (!started) busy.value = false;
      return started;
    } catch (_) {
      busy.value = false;
      return false;
    }
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    final mine = [for (final p in list) if (products.containsValue(p.productID)) p];
    for (final p in mine) {
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled || PurchaseStatus.error:
          busy.value = false;
          _after = null;
          if (p.status == PurchaseStatus.error) notice.value = tr.asmBuyFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          final (status, data) = await QuantumApi.assembly('asmVerify', {
            'purchases': [
              Platform.isIOS
                  ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
                  : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
            ],
          });
          if (status != 200 || data['success'] != true) {
            busy.value = false;
            notice.value = tr.asmBuyFailed; // 交易留著，下次啟動再驗證
            continue;
          }
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
          AssemblyState._setOptions(data);
          final after = _after, ok = _afterOk;
          _after = _afterOk = null;
          if (after != null) {
            final err = await after();
            notice.value = err == null ? (ok ?? tr.asmStarted) : asmErrorText(err);
          } else {
            notice.value = tr.asmVoucherReady;
          }
          busy.value = false;
      }
    }
  }
}

/// 多買主辦券：只買不用，之後開場或延長時直接扣
class AssemblyBuyMore extends StatelessWidget {
  /// 只顯示這一級的主辦券（主持人控制台）；null 表示全部（開集會面板）
  final String? tier;
  const AssemblyBuyMore({super.key, this.tier});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AssemblyStore.details, AssemblyStore.busy]),
      builder: (context, _) {
        final buying = AssemblyStore.busy.value;
        Widget chip(String plan, String label) {
          final price = AssemblyStore.price(plan);
          return ActionChip(
            avatar: const Icon(Icons.add_shopping_cart, size: 16, color: Night.inkMuted),
            label: Text('$label · ${price ?? '—'}', style: const TextStyle(fontSize: 12)),
            onPressed: buying || price == null ? null : () => AssemblyStore.buy(plan),
          );
        }
        return Column(children: [
          Text('${tr.asmBuyMore} · ${tr.asmBuyMoreHint}', style: Night.caption, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Wrap(alignment: WrapAlignment.center, spacing: Night.space2, runSpacing: 4, children: [
            if (tier != 'q2') ...[chip('1h', tr.asmPlan1h), chip('2h', tr.asmPlan2h)],
            if (tier == 'q2' || (tier == null && AssemblyState.options.value?.q2 == true)) ...[chip('q2_1h', tr.asmPlanQ2_1h), chip('q2_2h', tr.asmPlanQ2_2h)],
          ]),
        ]);
      },
    );
  }
}

/// 開集會；成功回傳 null，失敗回傳錯誤代碼
Future<String?> createAssembly(Map<String, dynamic> body) async {
  final (status, data) = await QuantumApi.assembly('asmCreate', body);
  if (status == 200 && data['success'] == true) {
    AssemblyState.hostAsm.value = data['id'] as String?;
    AssemblyState._involved.add('${data['id']}');
    AssemblyState.refreshOptions();
    return null;
  }
  return data['code'] as String? ?? 'error';
}

/// 主持人用主辦券延長集會；成功回傳 null
Future<String?> extendAssembly(String id, String plan) async {
  final (status, data) = await QuantumApi.assembly('asmExtend', {'id': id, 'plan': plan});
  if (status == 200 && data['success'] == true) {
    AssemblyState._setOptions(data);
    return null;
  }
  return data['code'] as String? ?? 'error';
}

/// 有券就直接用，沒有就先買再用（買完由購買流程接著做）。回傳 null＝已完成或已開始購買
Future<String?> useOrBuyPass(String plan, Future<String?> Function() use, {String? ok}) async {
  final have = AssemblyState.options.value?.v(plan) ?? 0;
  if (have > 0) return use();
  final started = await AssemblyStore.buy(plan, after: use, ok: ok);
  return started ? 'buying' : 'error';
}

String asmErrorText(String? code) => switch (code) {
      'too_long' => tr.asmErrTooLong,
      'free_used' => tr.asmErrFreeUsed,
      'seats_full' => tr.asmErrSeatsFull,
      'blocked_words' => tr.asmErrBlocked,
      'full' => tr.asmErrFull,
      'removed' => tr.asmErrRemoved,
      'ended' => tr.asmErrEnded,
      'too_soon' => tr.asmErrTooSoon,
      'hidden' => tr.asmErrHidden,
      'already_hosting' => tr.asmErrHosting,
      'q2_unavailable' => tr.asmErrQ2Unavailable,
      _ => tr.asmErrGeneric,
    };

// ============================================================================
// 開集會
// ============================================================================

Future<void> showAssemblyCreate(BuildContext context) {
  AssemblyStore.loadProducts();
  AssemblyState.refreshOptions();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(left: Night.space3, right: Night.space3, top: Night.space3, bottom: Night.space3 + MediaQuery.of(ctx).viewInsets.bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: const GlassCard(child: _CreateSheet()),
      ),
    ),
  );
}

class _CreateSheet extends StatefulWidget {
  const _CreateSheet();
  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _title = TextEditingController();
  String _emoji = assemblyEmojis.first;
  Color _color = assemblyColors.first;
  String? _plan;
  bool _sending = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final title = _title.text.trim();
    final plan = _plan;
    if (title.isEmpty || plan == null || _sending) return;
    final body = {'plan': plan, 'title': title, 'emoji': _emoji, 'color': colorHex(_color)};
    final hasVoucher = plan == 'free' || (AssemblyState.options.value?.v(plan) ?? 0) > 0;
    setState(() => _sending = true);
    if (plan != 'free' && !hasVoucher) {
      final started = await AssemblyStore.buy(plan, after: () => createAssembly(body));
      if (!mounted) return;
      setState(() => _sending = false);
      if (started) Navigator.pop(context); // 買完會自動開場，結果在主畫面提示
      return;
    }
    final err = await createAssembly(body);
    if (!mounted) return;
    setState(() => _sending = false);
    if (err == null) {
      Navigator.pop(context);
      showGlassToast(context, tr.asmStarted, icon: Icons.celebration_outlined);
    } else {
      showGlassToast(context, asmErrorText(err), icon: Icons.error_outline, danger: true);
    }
  }

  Widget _planTile(String plan, String title, String subtitle, {bool enabled = true}) {
    final selected = _plan == plan;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? () => setState(() => _plan = plan) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: Night.space2),
        padding: const EdgeInsets.all(Night.space3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? _color : Night.glassLine, width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: enabled ? Night.ink : Night.inkFaint, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: Night.caption),
            ]),
          ),
          if (selected) Icon(Icons.check_circle, color: _color),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AssemblyState.options, AssemblyStore.details, AssemblyStore.busy]),
      builder: (context, _) {
        final o = AssemblyState.options.value;
        String paid(String plan, int vouchers) => vouchers > 0 ? tr.asmVoucherCount(vouchers) : (AssemblyStore.price(plan) ?? '—');
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SheetTitle(tr.asmCreateTitle, closeTooltip: tr.close),
            const SizedBox(height: Night.space2),
            Text(tr.asmCreateIntro, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            TextField(
              controller: _title,
              maxLength: assemblyMaxTitle,
              style: const TextStyle(color: Night.ink),
              decoration: InputDecoration(hintText: tr.asmTitleHint, hintStyle: const TextStyle(color: Night.inkFaint), counterStyle: Night.caption),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Night.space2),
            Wrap(spacing: Night.space2, runSpacing: Night.space2, children: [
              for (final e in assemblyEmojis)
                ChoiceChip(label: Text(e, style: const TextStyle(fontSize: 20)), selected: e == _emoji, onSelected: (_) => setState(() => _emoji = e)),
            ]),
            const SizedBox(height: Night.space3),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (final c in assemblyColors)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: c, shape: BoxShape.circle,
                      border: Border.all(color: c == _color ? Colors.white : Colors.transparent, width: 3),
                      boxShadow: [BoxShadow(color: c.withOpacity(0.6), blurRadius: c == _color ? 12 : 4)],
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: Night.space4),
            _planTile('free', tr.asmPlanFree, o?.free == false ? tr.asmPlanFreeUsed : tr.asmPlanFreeSub, enabled: o?.free != false),
            _planTile('1h', '${tr.asmPlan1h} · ${paid('1h', o?.v('1h') ?? 0)}', tr.asmPlan1hSub),
            _planTile('2h', '${tr.asmPlan2h} · ${paid('2h', o?.v('2h') ?? 0)}', tr.asmPlan2hSub),
            // Q2：主持席在第 2 圈，多了語音直播與提問（直播主機設定好才出現）
            if (o?.q2 == true) ...[
              const SizedBox(height: Night.space2),
              Text(tr.asmQ2Section, style: const TextStyle(color: Night.ink, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(tr.asmQ2Intro, style: Night.caption),
              const SizedBox(height: Night.space2),
              _planTile('q2_1h', '${tr.asmPlanQ2_1h} · ${paid('q2_1h', o?.v('q2_1h') ?? 0)}', tr.asmPlanQ2_1hSub),
              _planTile('q2_2h', '${tr.asmPlanQ2_2h} · ${paid('q2_2h', o?.v('q2_2h') ?? 0)}', tr.asmPlanQ2_2hSub),
            ],
            const SizedBox(height: Night.space2),
            const AssemblyBuyMore(),
            const SizedBox(height: Night.space2),
            Text(tr.asmRules, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            NightButton(
              _sending || AssemblyStore.busy.value ? tr.preparing : tr.asmStart,
              icon: Icons.celebration_outlined,
              onPressed: _title.text.trim().isEmpty || _plan == null || _sending || AssemblyStore.busy.value ? null : _start,
            ),
          ]),
        );
      },
    );
  }
}

// ============================================================================
// 集會卡：所有人都能看；參加者可以加入／離開；主持人另外有控制台
// ============================================================================

Future<void> showAssemblyCard(BuildContext context, String id) {
  if (AssemblyState.hostAsm.value == id) {
    // 主持人：準備延長用的價格與主辦券張數
    AssemblyStore.loadProducts();
    AssemblyState.refreshOptions();
  }
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(left: Night.space3, right: Night.space3, top: Night.space3, bottom: Night.space3 + MediaQuery.of(ctx).viewInsets.bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: GlassCard(child: _AssemblyCard(id: id)),
      ),
    ),
  );
}

class _AssemblyCard extends StatefulWidget {
  final String id;
  const _AssemblyCard({required this.id});
  @override
  State<_AssemblyCard> createState() => _AssemblyCardState();
}

class _AssemblyCardState extends State<_AssemblyCard> {
  final _announce = TextEditingController();
  Color? _cheerColor;
  int _countdown = 3;
  bool _busy = false;
  String? _translated;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _announce.dispose();
    super.dispose();
  }

  Future<void> _run(Future<String?> Function() f, {String? ok}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final err = await f();
    if (!mounted) return;
    setState(() => _busy = false);
    if (err != null) {
      showGlassToast(context, asmErrorText(err), icon: Icons.error_outline, danger: true);
    } else if (ok != null) {
      showGlassToast(context, ok, icon: Icons.check_circle_outline);
    }
  }

  Future<String?> _call(String action, Map<String, dynamic> body) async {
    final (status, data) = await QuantumApi.assembly(action, {'id': widget.id, ...body});
    return status == 200 && data['success'] == true ? null : (data['code'] as String? ?? 'error');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AssemblyState.active, AssemblyState.myAsm, AssemblyState.hostAsm]),
      builder: (context, _) {
        final a = AssemblyState.active.value[widget.id];
        if (a == null || !a.active) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SheetTitle(tr.asmTitle, closeTooltip: tr.close),
            const SizedBox(height: Night.space4),
            Text(tr.asmErrEnded, style: Night.body, textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
          ]);
        }
        final isHost = AssemblyState.hostAsm.value == a.id;
        final joined = AssemblyState.myAsm.value == a.id;
        final left = max(0, a.endAt - AssemblyState.serverNow) ~/ 1000;
        String two(int n) => n.toString().padLeft(2, '0');
        final timeLeft = left >= 3600 ? '${left ~/ 3600}:${two(left % 3600 ~/ 60)}:${two(left % 60)}' : '${left ~/ 60}:${two(left % 60)}';
        final ann = a.announce;
        final cheerColor = _cheerColor ?? a.color;
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SheetTitle('${a.emoji} ${a.title}', closeTooltip: tr.close),
            const SizedBox(height: Night.space2),
            Text(tr.asmHostLine(a.host, a.code), style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.groups_2_outlined, color: a.color, size: 18),
              const SizedBox(width: 4),
              Text('${a.count} / ${a.cap}', style: TextStyle(color: a.color, fontWeight: FontWeight.w600)),
              const SizedBox(width: Night.space4),
              const Icon(Icons.timer_outlined, color: Night.inkMuted, size: 18),
              const SizedBox(width: 4),
              Text(timeLeft, style: const TextStyle(color: Night.inkMuted)),
            ]),
            if (ann != null && ann.text.isNotEmpty) ...[
              const SizedBox(height: Night.space3),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  if (_translated != null) { setState(() => _translated = null); return; }
                  final t = await ChatTranslator.translate(context, ann.text, Localizations.localeOf(context));
                  if (mounted && t != null) setState(() => _translated = t);
                },
                child: Container(
                  padding: const EdgeInsets.all(Night.space3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: a.color.withOpacity(0.12), border: Border.all(color: a.color.withOpacity(0.5))),
                  child: Row(children: [
                    Icon(Icons.campaign_outlined, color: a.color, size: 20),
                    const SizedBox(width: Night.space2),
                    Expanded(child: Text(_translated ?? ann.text, style: const TextStyle(color: Night.ink, fontSize: 14, height: 1.5))),
                    const Icon(Icons.translate, color: Night.inkFaint, size: 16),
                  ]),
                ),
              ),
            ],
            const SizedBox(height: Night.space4),
            if (!isHost)
              NightButton(
                joined ? tr.asmLeave : tr.asmJoin,
                icon: joined ? Icons.logout : Icons.celebration_outlined,
                kind: joined ? NightButtonKind.ghost : NightButtonKind.primary,
                onPressed: _busy ? null : () => _run(() async {
                  if (joined) { await AssemblyState.leave(a.id); return null; }
                  return AssemblyState.join(a.id);
                }, ok: joined ? null : tr.asmJoined),
              ),
            // Q2：語音直播與提問（參加者加入後、主持人）
            if (a.isQ2 && (joined || isHost)) ...[
              const SizedBox(height: Night.space3),
              AssemblyLivePanel(a: a, isHost: isHost),
              const SizedBox(height: Night.space2),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: a.color, side: BorderSide(color: a.color.withOpacity(0.7)),
                    padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () => showAssemblyQuestions(context, a, isHost: isHost),
                icon: const Icon(Icons.forum_outlined, size: 18),
                label: Text(tr.asmAskOpen),
              ),
              const SizedBox(height: Night.space3),
            ],
            if (a.isQ2 && !joined && !isHost) ...[
              const SizedBox(height: Night.space2),
              Text(tr.asmQ2JoinHint, style: Night.caption, textAlign: TextAlign.center),
            ],
            if (isHost) ...[
              // 主持人控制台：公告、應援、結束
              Text(tr.asmHostPanel, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: Night.space2),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _announce,
                    maxLength: assemblyMaxAnnounce,
                    style: const TextStyle(color: Night.ink),
                    decoration: InputDecoration(hintText: tr.asmAnnounceHint, hintStyle: const TextStyle(color: Night.inkFaint), counterText: ''),
                  ),
                ),
                IconButton(
                  tooltip: tr.asmAnnounceSend,
                  onPressed: _busy ? null : () => _run(() async {
                    final text = _announce.text.trim();
                    if (text.isEmpty) return null;
                    final err = await _call('asmAnnounce', {'text': text});
                    if (err == null) _announce.clear();
                    return err;
                  }, ok: tr.asmAnnounced),
                  icon: Icon(Icons.send, color: a.color),
                ),
              ]),
              const SizedBox(height: Night.space3),
              Text(tr.asmCheerTitle, style: Night.caption),
              const SizedBox(height: Night.space2),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                for (final c in assemblyColors)
                  GestureDetector(
                    onTap: () => setState(() => _cheerColor = c),
                    child: Container(width: 32, height: 32, decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                        border: Border.all(color: c == cheerColor ? Colors.white : Colors.transparent, width: 3))),
                  ),
              ]),
              const SizedBox(height: Night.space2),
              Wrap(alignment: WrapAlignment.center, spacing: Night.space2, children: [
                for (final n in assemblyCountdowns)
                  ChoiceChip(label: Text(n == 0 ? tr.asmCheerNow : tr.asmCheerIn(n)), selected: n == _countdown, onSelected: (_) => setState(() => _countdown = n)),
              ]),
              const SizedBox(height: Night.space2),
              // 按下應援後關掉集會卡，主持人也看得到全螢幕的倒數與綻放
              NightButton(tr.asmCheer, icon: Icons.flare, onPressed: _busy ? null : () => _run(() async {
                final err = await _call('asmCheer', {'color': colorHex(cheerColor), 'countdown': _countdown});
                if (err == null && context.mounted) Navigator.pop(context);
                return err;
              })),
              const SizedBox(height: Night.space4),
              // 臨時續購：有券直接延長，沒有就先買再延長
              Text(tr.asmExtendTitle, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(tr.asmExtendHint, style: Night.caption),
              const SizedBox(height: Night.space2),
              AnimatedBuilder(
                animation: Listenable.merge([AssemblyState.options, AssemblyStore.details, AssemblyStore.busy]),
                builder: (context, _) {
                  final o = AssemblyState.options.value;
                  final buying = AssemblyStore.busy.value;
                  Widget btn(String plan, int hours, int owned) => Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: a.color, side: BorderSide(color: a.color.withOpacity(0.7)),
                              padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                          onPressed: _busy || buying ? null : () => _run(() async {
                            final err = await useOrBuyPass(plan, () => extendAssembly(a.id, plan), ok: tr.asmExtended);
                            if (err == 'buying') return null; // 買完會自動延長，結果在主畫面提示
                            return err;
                          }, ok: owned > 0 ? tr.asmExtended : null),
                          child: Text(tr.asmExtendPlan(hours, owned > 0 ? tr.asmVoucherCount(owned) : (AssemblyStore.price(plan) ?? '—')),
                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                        ),
                      );
                  // Q2 集會只能用 Q2 主辦券延長
                  final p1 = a.isQ2 ? 'q2_1h' : '1h', p2 = a.isQ2 ? 'q2_2h' : '2h';
                  return Row(children: [btn(p1, 1, o?.v(p1) ?? 0), const SizedBox(width: Night.space2), btn(p2, 2, o?.v(p2) ?? 0)]);
                },
              ),
              const SizedBox(height: Night.space2),
              AssemblyBuyMore(tier: a.tier),
              const SizedBox(height: Night.space2),
              Text(tr.asmRemoveHint, style: Night.caption, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              NightButton(tr.asmEnd, kind: NightButtonKind.ghost, onPressed: _busy ? null : () => _run(() async {
                final err = await _call('asmEnd', const {});
                if (err == null && context.mounted) Navigator.pop(context);
                return err;
              })),
            ],
            if (!isHost)
              TextButton.icon(
                onPressed: () {
                  final me = FirebaseAuth.instance.currentUser?.uid;
                  if (me == null) return;
                  showReportSheet(context, myUid: me, targetUid: 'assembly:${a.id}', targetName: '${a.emoji} ${a.title}',
                      reportContext: ReportContext.assembly, allowBlock: false);
                },
                icon: const Icon(Icons.flag_outlined, size: 18, color: Night.inkFaint),
                label: Text(tr.asmReport, style: Night.caption),
              ),
          ]),
        );
      },
    );
  }
}

// ============================================================================
// 地圖上的集會光環（主持席的位置），點一下打開集會卡
// ============================================================================

class AssemblyBeaconChip extends StatelessWidget {
  final QAssembly a;
  final VoidCallback onTap;
  const AssemblyBeaconChip({super.key, required this.a, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Night.night900.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: a.color, width: 1.5),
          boxShadow: [BoxShadow(color: a.color.withOpacity(0.5), blurRadius: 12)],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(a.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Flexible(child: Text(a.title, style: const TextStyle(color: Night.ink, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          Text('${a.count}', style: TextStyle(color: a.color, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

/// 集會光環：主持席上一圈慢慢擴散的光環；應援時，參加者的光球位置一起綻放
class AssemblyHaloPainter extends CustomPainter {
  final List<(Offset, Color)> beacons; // 主持席的畫面位置與光色
  final List<(Offset, Color, double)> bursts; // 應援：參加者的位置、光色、進度 0～1
  final double phase; // 0～1，光環擴散的進度
  AssemblyHaloPainter({required this.beacons, required this.bursts, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    for (final (at, color) in beacons) {
      for (var k = 0; k < 3; k++) {
        final t = (phase + k / 3) % 1.0;
        canvas.drawCircle(at, 18 + t * 46, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * (1 - t) + 0.5
          ..color = color.withOpacity(0.7 * (1 - t)));
      }
      canvas.drawCircle(at, 14, Paint()..color = color.withOpacity(0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    }
    for (final (at, color, t) in bursts) {
      final r = 10 + t * 60;
      canvas.drawCircle(at, r, Paint()..color = color.withOpacity(0.5 * (1 - t))..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + t * 10));
      canvas.drawCircle(at, r * 0.6, Paint()..style = PaintingStyle.stroke..strokeWidth = 3 * (1 - t) + 0.5..color = Colors.white.withOpacity(0.8 * (1 - t)));
    }
  }

  @override
  bool shouldRepaint(AssemblyHaloPainter old) => true;
}

/// 應援的時間進度：還沒到回傳負的秒數；綻放期間（2.5 秒）回傳 0～1；過了回傳 null
double? cheerProgress(int fireAt, int now) {
  final d = now - fireAt;
  if (d < -10500) return null;
  if (d < 0) return d / 1000;
  if (d <= 2500) return d / 2500;
  return null;
}

/// 參加者與主持人的全螢幕應援：大倒數，歸零時整個畫面綻放成那個顏色
class AssemblyCheerOverlay extends StatefulWidget {
  const AssemblyCheerOverlay({super.key});
  @override
  State<AssemblyCheerOverlay> createState() => _AssemblyCheerOverlayState();
}

class _AssemblyCheerOverlayState extends State<AssemblyCheerOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<({String id, Color color, int fireAt})?>(
      valueListenable: AssemblyState.cheer,
      builder: (context, cheer, _) {
        if (cheer == null) return const SizedBox.shrink();
        return AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final p = cheerProgress(cheer.fireAt, AssemblyState.serverNow);
            if (p == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) { if (AssemblyState.cheer.value == cheer) AssemblyState.cheer.value = null; });
              return const SizedBox.shrink();
            }
            if (p < 0) {
              final n = (-p).ceil();
              return IgnorePointer(
                child: Center(
                  child: Text('$n', style: TextStyle(color: cheer.color, fontSize: 120, fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: cheer.color, blurRadius: 40), const Shadow(color: Colors.black54, blurRadius: 8)])),
                ),
              );
            }
            return IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  // 整個畫面綻放：從中間往外，光色蓋滿螢幕再慢慢退去
                  gradient: RadialGradient(radius: 1.3, colors: [
                    Colors.white.withOpacity(0.55 * (1 - p)),
                    cheer.color.withOpacity(0.8 * (1 - p)),
                    cheer.color.withOpacity(0.45 * (1 - p)),
                  ], stops: const [0, 0.35, 1]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// 參加者畫面上方的公告橫幅（公告後 60 秒內），點一下打開集會卡
class AssemblyAnnounceBanner extends StatelessWidget {
  final ValueChanged<String> onOpen;
  const AssemblyAnnounceBanner({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AssemblyState.active, AssemblyState.myAsm, AssemblyState.hostAsm]),
      builder: (context, _) {
        final id = AssemblyState.myAsm.value ?? AssemblyState.hostAsm.value;
        final a = id == null ? null : AssemblyState.active.value[id];
        final ann = a?.announce;
        if (a == null || ann == null || AssemblyState.serverNow - ann.at > 60000) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => onOpen(a.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: Night.space2),
            decoration: BoxDecoration(
              color: Night.night900.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: a.color),
              boxShadow: [BoxShadow(color: a.color.withOpacity(0.4), blurRadius: 14)],
            ),
            child: Row(children: [
              Text(a.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: Night.space2),
              Expanded(child: Text(ann.text, style: const TextStyle(color: Night.ink, fontSize: 13, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 紀念卡：主題、參加人數、各大區分布（不寫任何人的名字）
// ============================================================================

Future<void> showAssemblyMemorial(BuildContext context, QAssembly a) {
  return showDrawnShareCard(
    context,
    fileName: 'city_whisper_assembly',
    shareLabel: tr.asmShareCard,
    build: () => AssemblyMemorialCard(a: a),
    shareText: tr.asmShareText(a.title, (a.summary?.count ?? 0) + 1), // 加上主持人
    ref: 'assembly',
  );
}

class AssemblyMemorialCard extends StatelessWidget {
  final QAssembly a;
  const AssemblyMemorialCard({super.key, required this.a});

  @override
  Widget build(BuildContext context) {
    final s = a.summary;
    final date = DateTime.fromMillisecondsSinceEpoch(a.startAt);
    final dateText = '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    final regions = (s?.regions.entries.toList() ?? [])..sort((x, y) => y.value.compareTo(x.value));
    final rnd = Random(a.id.hashCode);
    return SizedBox(
      width: 360, height: 640,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color.lerp(const Color(0xFF0B0F2E), a.color, 0.25)!, const Color(0xFF0B0F2E), const Color(0xFF070B1F)])),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _SparklePainter([for (var i = 0; i < 80; i++) Offset(rnd.nextDouble(), rnd.nextDouble())], a.color))),
          Positioned(
            left: 28, right: 28, top: 52,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.asmMemorialEyebrow, style: TextStyle(color: a.color, fontSize: 13, letterSpacing: ls(3), fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Text('${a.emoji} ${a.title}', style: TextStyle(color: Night.ink, fontSize: 30, height: 1.35, fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: a.color.withOpacity(0.75), blurRadius: 24)])),
              const SizedBox(height: 16),
              Container(width: 72, height: 2, decoration: BoxDecoration(color: a.color, boxShadow: [BoxShadow(color: a.color, blurRadius: 8)])),
              const SizedBox(height: 12),
              Text('$dateText · ⬡ ${a.code}', style: TextStyle(color: Night.ink, fontSize: 13, letterSpacing: ls(1))),
            ]),
          ),
          Positioned(
            left: 0, right: 0, top: 260,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                Text('${(s?.count ?? 0) + 1}', style: TextStyle(color: a.color, fontSize: 72, fontWeight: FontWeight.w800, shadows: [Shadow(color: a.color, blurRadius: 30)])),
                const SizedBox(width: 6),
                Text(tr.asmMemorialUnit, style: const TextStyle(color: Night.ink, fontSize: 20, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 4),
              Text(tr.asmMemorialTogether, textAlign: TextAlign.center, style: TextStyle(color: Night.ink, fontSize: 15, letterSpacing: ls(2))),
            ]),
          ),
          Positioned(
            left: 28, right: 28, top: 430,
            child: Wrap(alignment: WrapAlignment.center, spacing: 16, runSpacing: 10, children: [
              for (final e in regions)
                Text('${quantumRegionName(e.key)} ${e.value}', style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w600)),
            ]),
          ),
          const Positioned(left: 24, right: 24, bottom: 22, child: ShareCardBrand()),
        ]),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final List<Offset> dots;
  final Color color;
  _SparklePainter(this.dots, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < dots.length; i++) {
      final p = Offset(dots[i].dx * size.width, dots[i].dy * size.height);
      canvas.drawCircle(p, i % 9 == 0 ? 1.6 : 0.8, Paint()..color = (i % 4 == 0 ? color : Colors.white).withOpacity(i % 3 == 0 ? 0.8 : 0.4));
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => false;
}
