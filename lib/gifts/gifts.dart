import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../quantum_orb.dart';
import '../ui/night.dart';

/// 送禮與糾纏款（規格 docs/gifting-spec.md）。
/// 三種禮物在商店上都是消耗性商品：光之花束 NT$30、送一款光球 NT$90、糾纏款 NT$90（一組兩顆）。
/// 對方可以收下或婉拒；婉拒、7 天沒回應、或送出時對方收不了，禮物都會退回給送的人，變成可以再送別人的禮券。

const _giftsUrl = String.fromEnvironment('GIFTS_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/gifts');

Future<Map<String, dynamic>> giftCall(String action, [Map<String, dynamic> body = const {}]) async {
  try {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http
        .post(Uri.parse(_giftsUrl),
            headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
            body: jsonEncode({'action': action, 'lang': currentLanguageTag, ...body}))
        .timeout(const Duration(seconds: 25));
    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : {'success': false};
  } catch (_) {
    return {'success': false};
  }
}

class Gift {
  final String id, kind, fromName;
  final String? style;
  const Gift({required this.id, required this.kind, required this.fromName, this.style});
  static Gift? fromJson(Object? raw) {
    if (raw is! Map || raw['id'] is! String || raw['kind'] is! String) return null;
    return Gift(id: raw['id'] as String, kind: raw['kind'] as String, fromName: '${raw['fromName'] ?? ''}', style: raw['style'] as String?);
  }

  String get title => switch (kind) {
        'bouquet' => tr.giftFromBouquet(fromName),
        'orb' => tr.giftFromOrb(fromName, orbStyleName(style ?? '')),
        _ => tr.giftFromPair(fromName),
      };
}

class GiftVoucher {
  final String id, kind;
  final String? style;
  const GiftVoucher({required this.id, required this.kind, this.style});
  static GiftVoucher? fromJson(Object? raw) {
    if (raw is! Map || raw['id'] is! String || raw['kind'] is! String) return null;
    return GiftVoucher(id: raw['id'] as String, kind: raw['kind'] as String, style: raw['style'] as String?);
  }

  String get name => switch (kind) {
        'bouquet' => tr.giftBouquetName,
        'orb' => style == null ? tr.giftOrbName : '${tr.giftOrbName}「${orbStyleName(style!)}」',
        _ => tr.giftPairName,
      };
}

/// 伺服器上的送禮狀態：收到的禮物、退回的禮券、接收開關、糾纏款配對、花束
class GiftState {
  GiftState._();
  static final inbox = ValueNotifier<List<Gift>>(const []);
  static final vouchers = ValueNotifier<List<GiftVoucher>>(const []);
  static final off = ValueNotifier<bool>(false);
  static final pair = ValueNotifier<({String uid, String nickname})?>(null);
  static final bouquetUntil = ValueNotifier<int>(0);
  static bool get hasBouquet => bouquetUntil.value > DateTime.now().millisecondsSinceEpoch;

  static Future<void> refresh() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    final r = await giftCall('status');
    if (r['success'] != true) return;
    inbox.value = [for (final g in (r['inbox'] as List? ?? const [])) if (Gift.fromJson(g) case final gift?) gift];
    vouchers.value = [for (final v in (r['vouchers'] as List? ?? const [])) if (GiftVoucher.fromJson(v) case final voucher?) voucher];
    off.value = r['off'] == true;
    final p = r['pair'];
    pair.value = p is Map && p['uid'] is String ? (uid: p['uid'] as String, nickname: '${p['nickname'] ?? ''}') : null;
    bouquetUntil.value = (r['bouquetUntil'] as num?)?.toInt() ?? 0;
  }

  static Future<void> setReceive(bool on) async {
    off.value = !on;
    await giftCall('prefs', {'off': !on});
  }

  static Future<void> unpair() async {
    await giftCall('unpair');
    pair.value = null;
  }
}

/// 退回原因 → 給送禮的人看的說明
String giftReturnedText(String? code) => switch (code) {
      'off' => tr.giftReturnedOff,
      'blocked' => tr.giftReturnedBlocked,
      'owned' => tr.giftReturnedOwned,
      'paired' => tr.giftReturnedPaired,
      'you_paired' => tr.giftReturnedYouPaired,
      _ => tr.giftReturnedGeneric,
    };

/// 付款前檢查不通過時的說明（還沒付錢）
String giftBlockedText(String? code) => switch (code) {
      'off' => tr.giftBlockedOff,
      'blocked' => tr.giftBlockedBlocked,
      'owned' => tr.giftBlockedOwned,
      'paired' => tr.giftBlockedPaired,
      'you_paired' => tr.giftPairYouHave,
      _ => tr.giftFailed,
    };

/// 禮物的商店購買（消耗性）。和量子化身、艾婭共用同一個購買串流，只處理自己的商品。
class GiftStore {
  GiftStore._();
  static const products = {'bouquet': 'gift_bouquet', 'orb': 'gift_orb', 'pair': 'gift_pair'};
  static final details = ValueNotifier<Map<String, ProductDetails>>(const {});
  static final busy = ValueNotifier<bool>(false);
  static final notice = ValueNotifier<String?>(null);
  static StreamSubscription<List<PurchaseDetails>>? _sub;
  static const _intentKey = 'gift_intent';

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

  static String? price(String kind) => details.value[products[kind]]?.price;

  /// 買一份禮物送給 to。先記下要送給誰（App 中途被關掉也不會弄丟：沒有對象的禮物會變成禮券）
  static Future<void> buy(String kind, {required String to, required String toName, String? style}) async {
    final product = details.value[products[kind]];
    if (product == null) { notice.value = tr.giftStoreUnavailable; return; }
    busy.value = true;
    // 付款前先問伺服器對方收不收得到（已經有這款光球、關掉接收、已經配對），收不到就不讓付款
    final check = await giftCall('check', {'to': to, 'kind': kind, if (style != null) 'style': style});
    if (check['success'] == true && check['ok'] == false) {
      busy.value = false;
      notice.value = giftBlockedText(check['code'] as String?);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_intentKey, jsonEncode({'kind': kind, 'to': to, 'name': toName, if (style != null) 'style': style}));
      final started = await InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: product), autoConsume: true);
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.giftFailed;
    }
  }

  /// 用退回的禮券送給 to（不用再付錢）
  static Future<void> sendVoucher(GiftVoucher v, {required String to, required String toName, String? style}) async {
    busy.value = true;
    final r = await giftCall('send', {'voucherId': v.id, 'to': to, if (style != null) 'style': style});
    busy.value = false;
    if (r['success'] == true) {
      notice.value = r['delivered'] == true ? tr.giftSent(toName) : giftReturnedText(r['code'] as String?);
    } else {
      notice.value = r['code'] != null ? giftReturnedText(r['code'] as String?) : tr.giftFailed;
    }
    await GiftState.refresh();
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    final mine = [for (final p in list) if (products.containsValue(p.productID)) p];
    if (mine.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    for (final p in mine) {
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled || PurchaseStatus.error:
          busy.value = false;
          if (p.status == PurchaseStatus.error) notice.value = tr.giftFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
          await prefs.remove(_intentKey);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          Map<String, dynamic> intent = const {};
          try { intent = jsonDecode(prefs.getString(_intentKey) ?? '{}') as Map<String, dynamic>; } catch (_) {}
          // 記下的對象是這種禮物才用；不然（例如上次沒送完的交易）就變成禮券
          final matches = products[intent['kind']] == p.productID;
          final r = await giftCall('send', {
            'purchase': Platform.isIOS
                ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
                : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
            if (matches) 'to': intent['to'],
            if (matches && intent['style'] != null) 'style': intent['style'],
          });
          busy.value = false;
          if (r['success'] != true) { notice.value = tr.giftFailed; continue; } // 交易留著，下次啟動再送
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
          if (matches) await prefs.remove(_intentKey);
          if (r['already'] == true) continue;
          notice.value = r['delivered'] == true ? tr.giftSent('${intent['name'] ?? ''}') : giftReturnedText(r['code'] as String?);
          await GiftState.refresh();
      }
    }
  }
}

// ============================================================================
// 送禮選單
// ============================================================================

/// 從地圖、量子世界或聊天裡點了某個人 →「送禮物」
Future<void> showGiftSheet(BuildContext context, {required String toUid, required String toName}) {
  GiftStore.loadProducts();
  GiftState.refresh();
  return showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (ctx) => _GiftSheet(toUid: toUid, toName: toName),
  );
}

class _GiftSheet extends StatefulWidget {
  final String toUid, toName;
  const _GiftSheet({required this.toUid, required this.toName});
  @override
  State<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<_GiftSheet> {
  bool _pickingStyle = false;
  GiftVoucher? _voucherForStyle; // 用一張沒指定款式的光球禮券送：先挑款式

  @override
  void initState() {
    super.initState();
    GiftStore.notice.addListener(_onNotice);
  }

  @override
  void dispose() {
    GiftStore.notice.removeListener(_onNotice);
    super.dispose();
  }

  /// 有結果就關掉選單（提示由主畫面顯示）。只關自己：選單已經不在最上層時不動，避免關到主畫面
  void _onNotice() {
    if (GiftStore.notice.value == null || !mounted) return;
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) Navigator.of(context).pop();
  }

  List<String> get _giftable => [for (final s in orbStyles) if (!orbIsFree(s) && s != 'pair' && orbOnSale(s)) s];

  Widget _option({required IconData icon, required Color color, required String name, required String desc, String? price, bool enabled = true, required VoidCallback onTap}) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled && !GiftStore.busy.value ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: Night.space2),
          padding: const EdgeInsets.all(Night.space3),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.glassLine), color: Night.night700.withValues(alpha: 0.5)),
          child: Row(children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: Night.space3),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(desc, style: Night.caption.copyWith(fontSize: 12)),
            ])),
            const SizedBox(width: Night.space2),
            Text(price ?? '—', style: const TextStyle(color: Night.knockPink, fontSize: 14)),
          ]),
        ),
      ),
    );
  }

  Widget _stylePicker() {
    return LayoutBuilder(builder: (context, box) {
      final w = (box.maxWidth - Night.space2 * 2) / 3;
      return Wrap(spacing: Night.space2, runSpacing: Night.space2, children: [
        for (final s in _giftable)
          SizedBox(
            width: w,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: GiftStore.busy.value ? null : () {
                final v = _voucherForStyle;
                if (v != null) {
                  GiftStore.sendVoucher(v, to: widget.toUid, toName: widget.toName, style: s);
                } else {
                  GiftStore.buy('orb', to: widget.toUid, toName: widget.toName, style: s);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: Night.space2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.glassLine)),
                child: Column(children: [
                  QuantumOrb(style: s, color: Night.auroraViolet, size: 64, stars: 6, rings: 4),
                  const SizedBox(height: Night.space1),
                  Text(orbStyleName(s), style: const TextStyle(color: Night.ink, fontSize: 13)),
                ]),
              ),
            ),
          ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
            child: AnimatedBuilder(
              animation: Listenable.merge([GiftStore.details, GiftStore.busy, GiftState.vouchers, GiftState.pair]),
              builder: (context, _) {
                final paired = GiftState.pair.value != null;
                return SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    SheetTitle(_pickingStyle ? tr.giftPickStyle(widget.toName) : tr.giftSheetTitle(widget.toName), closeTooltip: tr.close),
                    const SizedBox(height: Night.space4),
                    if (_pickingStyle) ...[
                      _stylePicker(),
                      const SizedBox(height: Night.space2),
                      if (_voucherForStyle == null) Text(GiftStore.price('orb') ?? '—', style: const TextStyle(color: Night.knockPink, fontSize: 14), textAlign: TextAlign.center),
                      TextButton(onPressed: () => setState(() { _pickingStyle = false; _voucherForStyle = null; }), child: Text(tr.cancel)),
                    ] else ...[
                      // 退回的禮券：不用再付錢
                      if (GiftState.vouchers.value.isNotEmpty) ...[
                        Text(tr.giftVouchersTitle, style: Night.caption.copyWith(color: Night.cityAmber)),
                        const SizedBox(height: Night.space1),
                        for (final v in GiftState.vouchers.value)
                          Padding(
                            padding: const EdgeInsets.only(bottom: Night.space1),
                            child: Row(children: [
                              const Icon(Icons.card_giftcard, color: Night.cityAmber, size: 20),
                              const SizedBox(width: Night.space2),
                              Expanded(child: Text(v.name, style: const TextStyle(color: Night.ink, fontSize: 14))),
                              TextButton(
                                onPressed: GiftStore.busy.value || (v.kind == 'pair' && paired) ? null : () {
                                  if (v.kind == 'orb') { setState(() { _pickingStyle = true; _voucherForStyle = v; }); return; } // 光球禮券：重新挑款式
                                  GiftStore.sendVoucher(v, to: widget.toUid, toName: widget.toName);
                                },
                                child: Text(tr.giftSendVoucher),
                              ),
                            ]),
                          ),
                        const SizedBox(height: Night.space2),
                      ],
                      _option(icon: Icons.local_florist, color: const Color(0xFFFF8AD8), name: tr.giftBouquetName, desc: tr.giftBouquetDesc, price: GiftStore.price('bouquet'),
                          onTap: () => GiftStore.buy('bouquet', to: widget.toUid, toName: widget.toName)),
                      _option(icon: Icons.blur_circular, color: Night.auroraViolet, name: tr.giftOrbName, desc: tr.giftOrbDesc, price: GiftStore.price('orb'),
                          onTap: () => setState(() => _pickingStyle = true)),
                      _option(icon: Icons.all_inclusive, color: Night.knockPink, name: tr.giftPairName, desc: paired ? tr.giftPairYouHave : tr.giftPairDesc, price: GiftStore.price('pair'),
                          enabled: !paired, onTap: () => GiftStore.buy('pair', to: widget.toUid, toName: widget.toName)),
                    ],
                    if (GiftStore.busy.value)
                      const Padding(padding: EdgeInsets.all(Night.space2), child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))),
                    const SizedBox(height: Night.space2),
                    Text(tr.giftNote, style: Night.caption.copyWith(fontSize: 11), textAlign: TextAlign.center),
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 設定裡「退回的禮物」：列出可以再送的禮券
Future<void> showGiftVouchers(BuildContext context) {
  return showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
            child: ValueListenableBuilder<List<GiftVoucher>>(
              valueListenable: GiftState.vouchers,
              builder: (context, vouchers, _) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.redeem, color: Night.cityAmber, size: 32),
                const SizedBox(height: Night.space2),
                Text(tr.giftVouchersTitle, style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space3),
                if (vouchers.isEmpty) Text(tr.giftInboxEmpty, style: Night.caption, textAlign: TextAlign.center),
                for (final v in vouchers)
                  Container(
                    margin: const EdgeInsets.only(bottom: Night.space2),
                    padding: const EdgeInsets.all(Night.space3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.glassLine)),
                    child: Row(children: [
                      if (v.kind == 'orb' && v.style != null)
                        QuantumOrb(style: v.style!, color: Night.auroraViolet, size: 40, stars: 6, rings: 4)
                      else
                        Icon(v.kind == 'bouquet' ? Icons.local_florist : (v.kind == 'pair' ? Icons.all_inclusive : Icons.blur_circular), color: Night.cityAmber, size: 28),
                      const SizedBox(width: Night.space3),
                      Expanded(child: Text(v.name, style: const TextStyle(color: Night.ink, fontSize: 15))),
                    ]),
                  ),
                const SizedBox(height: Night.space1),
                Text(tr.giftVouchersHint, style: Night.caption, textAlign: TextAlign.center),
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(tr.close)),
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}

// ============================================================================
// 收到的禮物
// ============================================================================

/// 收到的禮物清單：收下或婉拒
Future<void> showGiftInbox(BuildContext context) {
  return showModalBottomSheet(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (ctx) => const _GiftInbox(),
  );
}

class _GiftInbox extends StatefulWidget {
  const _GiftInbox();
  @override
  State<_GiftInbox> createState() => _GiftInboxState();
}

class _GiftInboxState extends State<_GiftInbox> {
  final _busy = <String>{};

  Future<void> _answer(Gift g, bool accept) async {
    setState(() => _busy.add(g.id));
    final r = await giftCall(accept ? 'accept' : 'decline', {'id': g.id});
    await GiftState.refresh();
    if (!mounted) return;
    setState(() => _busy.remove(g.id));
    final nav = Navigator.of(context);
    final root = nav.context;
    if (!accept) { showGlassToast(root, tr.giftDeclined, icon: Icons.card_giftcard); return; }
    if (r['success'] != true) {
      showGlassToast(root, r['code'] == 'owned' ? tr.giftAlreadyOwned : (r['code'] == 'paired' ? tr.giftAlreadyPaired : tr.giftFailed), icon: Icons.card_giftcard);
      return;
    }
    if (GiftState.inbox.value.isEmpty) nav.pop();
    switch (g.kind) {
      case 'bouquet':
        await showBouquetBloom(root);
        if (root.mounted) showGlassToast(root, tr.giftAcceptedBouquet, icon: Icons.local_florist);
      case 'orb':
        OrbStore.loadOwned();
        showGlassToast(root, tr.giftAcceptedOrb, icon: Icons.blur_circular);
      default:
        OrbStore.loadOwned();
        showGlassToast(root, tr.giftAcceptedPair(g.fromName), icon: Icons.all_inclusive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
            child: ValueListenableBuilder<List<Gift>>(
              valueListenable: GiftState.inbox,
              builder: (context, inbox, _) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.card_giftcard, color: Night.cityAmber, size: 32),
                const SizedBox(height: Night.space2),
                SheetTitle(tr.giftInboxTitle, closeTooltip: tr.close),
                const SizedBox(height: Night.space3),
                if (inbox.isEmpty) Text(tr.giftInboxEmpty, style: Night.caption, textAlign: TextAlign.center),
                for (final g in inbox)
                  Container(
                    margin: const EdgeInsets.only(bottom: Night.space2),
                    padding: const EdgeInsets.all(Night.space3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.glassLine)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Row(children: [
                        if (g.kind == 'orb' && g.style != null)
                          QuantumOrb(style: g.style!, color: Night.auroraViolet, size: 44, stars: 6, rings: 4)
                        else
                          Icon(g.kind == 'bouquet' ? Icons.local_florist : Icons.all_inclusive, color: g.kind == 'bouquet' ? const Color(0xFFFF8AD8) : Night.knockPink, size: 32),
                        const SizedBox(width: Night.space3),
                        Expanded(child: Text(g.title, style: const TextStyle(color: Night.ink, fontSize: 15))),
                      ]),
                      const SizedBox(height: Night.space2),
                      if (_busy.contains(g.id))
                        const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
                      else
                        Row(children: [
                          Expanded(child: OutlinedButton(onPressed: () => _answer(g, false), child: Text(tr.giftDecline))),
                          const SizedBox(width: Night.space2),
                          Expanded(child: FilledButton(onPressed: () => _answer(g, true), child: Text(tr.giftAccept))),
                        ]),
                    ]),
                  ),
                const SizedBox(height: Night.space1),
                Text(tr.giftInboxNote, style: Night.caption.copyWith(fontSize: 11), textAlign: TextAlign.center),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 光之花束綻放
// ============================================================================

/// 收下花束時：一束光粒子花從中間綻開（五片花瓣、金色花蕊），再慢慢散成光塵；點一下就關掉
Future<void> showBouquetBloom(BuildContext context) {
  return Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    barrierDismissible: true,
    pageBuilder: (_, __, ___) => const _BloomPage(),
    transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
  ));
}

class _BloomPage extends StatefulWidget {
  const _BloomPage();
  @override
  State<_BloomPage> createState() => _BloomPageState();
}

class _BloomPageState extends State<_BloomPage> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 4200))..forward();

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) { if (s == AnimationStatus.completed && mounted) Navigator.of(context).maybePop(); });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        color: const Color(0x88070B1F),
        child: AnimatedBuilder(animation: _c, builder: (context, _) => CustomPaint(size: Size.infinite, painter: BouquetBloomPainter(_c.value))),
      ),
    );
  }
}

class BouquetBloomPainter extends CustomPainter {
  final double p; // 0～1
  BouquetBloomPainter(this.p);

  static double _h(int i, [double salt = 0]) {
    final x = sin(i * 127.1 + 311.7 + salt) * 43758.5453;
    return x - x.floorToDouble();
  }

  static const _petal = [Color(0xFFFF8AD8), Color(0xFFFFB3C7), Color(0xFFFFD1E8), Color(0xFFE6A8FF)];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * 0.32;
    final open = Curves.easeOutBack.transform((p / 0.45).clamp(0.0, 1.0));
    final scatter = ((p - 0.65) / 0.35).clamp(0.0, 1.0);
    final fade = 1 - scatter;
    final spin = p * 0.8;
    void dot(Offset at, double rad, Color color, double a) {
      if (a <= 0.02) return;
      canvas.drawCircle(at, rad * 2.6, Paint()..color = color.withValues(alpha: 0.16 * a)..blendMode = BlendMode.plus);
      canvas.drawCircle(at, rad, Paint()..color = Color.lerp(color, Colors.white, 0.4)!.withValues(alpha: a)..blendMode = BlendMode.plus);
    }

    // 花瓣：玫瑰線 r = cos(5θ/2) 上的粒子，兩層，外層粉、內層白粉
    for (var layer = 0; layer < 2; layer++) {
      const n = 360;
      for (var i = 0; i < n; i++) {
        final theta = i / n * 4 * pi;
        final rr = r * (layer == 0 ? 1.0 : 0.62) * cos(2.5 * theta).abs() * open;
        final jitter = (_h(i, layer * 3.0) - 0.5) * r * 0.06;
        var at = c + Offset(cos(theta + spin + layer * 0.3), sin(theta + spin + layer * 0.3)) * (rr + jitter);
        // 散開：往外飄、往上升
        at += Offset((_h(i, 9) - 0.5) * size.width * 0.5, -_h(i, 10) * size.height * 0.35) * scatter;
        dot(at, 1.4 + 0.8 * _h(i, layer + 4.0), _petal[(i + layer) % _petal.length], (0.55 + 0.45 * _h(i, 7)) * fade);
      }
    }
    // 花蕊：金色粒子
    for (var i = 0; i < 70; i++) {
      final a = _h(i, 20) * 2 * pi;
      final d = sqrt(_h(i, 21)) * r * 0.16 * open;
      final at = c + Offset(cos(a), sin(a)) * d + Offset(0, -size.height * 0.2 * scatter * _h(i, 22));
      dot(at, 1.6, const Color(0xFFFFD166), fade * (0.7 + 0.3 * sin(p * 30 + i)));
    }
    // 綻開那一下的光
    if (p < 0.25) canvas.drawCircle(c, r * 0.6 * (p / 0.25), Paint()..color = Colors.white.withValues(alpha: 0.25 * (1 - p / 0.25))..blendMode = BlendMode.plus);
  }

  @override
  bool shouldRepaint(covariant BouquetBloomPainter old) => old.p != p;
}
