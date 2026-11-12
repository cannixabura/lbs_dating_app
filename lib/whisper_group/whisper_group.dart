import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/l10n.dart';
import '../ui/night.dart';

/// 低語團：私人的團體（規格 docs/whisper-group-spec.md；伺服器 geo-service/whispergroup.js、exports.whisperGroup）。
/// 團主可以集合呼叫、點名、放集合點；團員只回覆狀態，位置不會給團主。
/// 只有在團裡（團主或團員）時，地圖下方才出現低語團按鈕。

const _url = String.fromEnvironment('WGROUP_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/whisperGroup');

const wgColors = {
  'violet': Color(0xFFB44CFF), 'pink': Color(0xFFFF5FD2), 'blue': Color(0xFF4F8BFF), 'teal': Color(0xFF3FD8E0),
  'green': Color(0xFF4DE3A0), 'gold': Color(0xFFFFD166), 'orange': Color(0xFFFF9F45), 'red': Color(0xFFFF6B7A),
};
Color wgColor(String? c) => wgColors[c] ?? Night.auroraViolet;

// ---------- 資料 ----------

class WgMember {
  final String uid, name, note;
  final int no;
  final String state; // 集合：ack / seen / none；點名：here / 5min / help / none
  WgMember(this.uid, this.no, this.name, this.note, this.state);
}

class WgLost {
  final String uid, name, note;
  final int no, at;
  final double lat, lng;
  WgLost(this.uid, this.no, this.name, this.note, this.lat, this.lng, this.at);
}

class WgCall {
  final String id, place;
  final int at;
  final double lat, lng;
  final String? mine; // seen / ack
  WgCall(this.id, this.at, this.place, this.lat, this.lng, this.mine);
}

class WgGroup {
  final String code, name, color, role, hostName;
  final int endsAt, limit, count;
  final int? myNo;
  final bool paid;
  final String? qr;
  final WgCall? call;
  final String? rollId, rollMine;
  final List<WgMember> members, callRoster, rollRoster;
  final int acked, here, help;
  final List<WgLost> lost; // 團主：迷路的團員（自己按「我迷路了」才有）
  final bool lostSent; // 團員：我已經傳過迷路位置
  WgGroup.fromJson(Map<String, dynamic> j)
      : code = '${j['code']}', name = '${j['name']}', color = '${j['color']}', role = '${j['role']}', hostName = '${j['hostName'] ?? ''}',
        endsAt = (j['endsAt'] as num).toInt(), limit = (j['limit'] as num).toInt(), count = (j['count'] as num).toInt(),
        myNo = (j['myNo'] as num?)?.toInt(), paid = j['paid'] == true, qr = j['qr'] as String?,
        call = j['call'] is Map
            ? WgCall('${j['call']['id']}', (j['call']['at'] as num).toInt(), '${j['call']['place'] ?? ''}', (j['call']['lat'] as num).toDouble(), (j['call']['lng'] as num).toDouble(), j['call']['mine'] as String?)
            : null,
        rollId = j['roll'] is Map ? '${j['roll']['id']}' : null,
        rollMine = j['roll'] is Map ? j['roll']['mine'] as String? : null,
        members = [for (final m in (j['members'] as List? ?? const [])) WgMember('${m['uid']}', (m['no'] as num).toInt(), '${m['name'] ?? ''}', '${m['note'] ?? ''}', '')],
        callRoster = [for (final m in ((j['callRoster'] as Map?)?['rows'] as List? ?? const [])) WgMember('${m['uid']}', (m['no'] as num).toInt(), '${m['name'] ?? ''}', '${m['note'] ?? ''}', '${m['state']}')],
        rollRoster = [for (final m in ((j['rollRoster'] as Map?)?['rows'] as List? ?? const [])) WgMember('${m['uid']}', (m['no'] as num).toInt(), '${m['name'] ?? ''}', '${m['note'] ?? ''}', '${m['answer']}')],
        acked = ((j['callRoster'] as Map?)?['acked'] as num?)?.toInt() ?? 0,
        here = ((j['rollRoster'] as Map?)?['here'] as num?)?.toInt() ?? 0,
        help = ((j['rollRoster'] as Map?)?['help'] as num?)?.toInt() ?? 0,
        lost = [for (final m in (j['lost'] as List? ?? const [])) WgLost('${m['uid']}', (m['no'] as num).toInt(), '${m['name'] ?? ''}', '${m['note'] ?? ''}', (m['lat'] as num).toDouble(), (m['lng'] as num).toDouble(), (m['at'] as num).toInt())],
        lostSent = j['lostSent'] == true;
  bool get isHost => role == 'host';
  Color get tint => wgColor(color);
}

// ---------- 伺服器 ----------

class WhisperGroup {
  WhisperGroup._();
  static final current = ValueNotifier<WgGroup?>(null);
  static Timer? _poll;
  /// 前景收到集合呼叫時要跳出的卡片（main.dart 監聽）
  static final incomingCall = ValueNotifier<WgCall?>(null);
  /// 前景收到點名時要跳出的卡片（點名 id）
  static final incomingRoll = ValueNotifier<String?>(null);

  static Future<Map<String, dynamic>> call(String action, [Map<String, dynamic> body = const {}]) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final r = await http
          .post(Uri.parse(_url),
              headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
              body: jsonEncode({'action': action, ...body}))
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(r.body);
      if (data is! Map<String, dynamic>) return {'success': false, 'code': 'busy'};
      if (data.containsKey('group')) _apply(data['group']);
      return data;
    } catch (_) {
      return {'success': false, 'code': 'busy'};
    }
  }

  static void _apply(Object? g) {
    final before = current.value;
    current.value = g is Map<String, dynamic> ? WgGroup.fromJson(g) : null;
    final after = current.value;
    // 團員：出現新的集合呼叫、還沒按收到 → 跳出卡片
    if (after != null && !after.isHost && after.call != null && after.call!.mine != 'ack' && before?.call?.id != after.call!.id) {
      incomingCall.value = after.call;
    }
    // 團員：出現新的點名、還沒回答 → 跳出點名卡片
    if (after != null && !after.isHost && after.rollId != null && after.rollMine == null && before?.rollId != after.rollId) {
      incomingRoll.value = after.rollId;
    }
    _schedulePoll();
  }

  /// 在團裡時每 15 秒更新一次（團主看名單狀態、團員看集合點）；App 在背景時不更新
  static void _schedulePoll() {
    _poll?.cancel();
    if (current.value == null) return;
    _poll = Timer(Duration(seconds: current.value!.call != null || current.value!.rollId != null ? 10 : 30), refresh);
  }

  static Future<void> refresh() => call('status');

  /// Android：集合呼叫的專屬通知頻道（高優先、專屬音效、震動「短 短 長」）。推播的 channelId 是 group_call
  static Future<void> createAndroidChannel() async {
    if (!Platform.isAndroid) return;
    try {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(AndroidNotificationChannel(
            'group_call', tr.wgChannelName,
            description: tr.wgChannelDesc,
            importance: Importance.high,
            sound: const RawResourceAndroidNotificationSound('group_call'),
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 150, 100, 150, 100, 600]),
          ));
    } catch (_) {}
  }
  static void pause() => _poll?.cancel();

  /// 收到推播（前景）：重新整理，集合呼叫會由 _apply 跳出卡片
  static void onPush(Map<String, dynamic> data) {
    if ('${data['type']}'.startsWith('wgroup_')) refresh();
  }

  /// 分享連結或 QR code：https://mood-whisper-f7de9.web.app/g/<團代碼>?v=<版本>
  static (String, int)? parseLink(Uri uri) {
    if (uri.pathSegments.length < 2 || uri.pathSegments.first != 'g') return null;
    final code = uri.pathSegments[1].toUpperCase();
    if (!RegExp(r'^[A-HJ-NP-Z2-9]{8}$').hasMatch(code)) return null;
    return (code, int.tryParse(uri.queryParameters['v'] ?? '') ?? 1);
  }
}

String wgError(String code) => switch (code) {
      'in_group' => tr.wgErrInGroup,
      'full' => tr.wgErrFull,
      'paid_full' => tr.wgErrPaidFull,
      'qr' => tr.wgErrQr,
      'ended' || 'not_found' || 'no_group' => tr.wgErrEnded,
      'filtered' => tr.wgErrFiltered,
      'host' => tr.wgErrHostLeave,
      _ => tr.wgErrBusy,
    };

// ---------- 低語團 7 天方案（消耗型） ----------

class GroupPassStore {
  GroupPassStore._();
  static const product = 'group_pass_7d';
  static final details = ValueNotifier<ProductDetails?>(null);
  static final busy = ValueNotifier<bool>(false);
  static final notice = ValueNotifier<String?>(null);
  static StreamSubscription<List<PurchaseDetails>>? _sub;

  static void init() {
    _sub ??= InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (_) => busy.value = false);
  }

  static Future<void> load() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) return;
      final r = await InAppPurchase.instance.queryProductDetails({product});
      if (r.productDetails.isNotEmpty) details.value = r.productDetails.first;
    } catch (_) {}
  }

  static Future<void> buy() async {
    final p = details.value;
    if (p == null) { notice.value = tr.wgPassUnavailable; return; }
    busy.value = true;
    try {
      final started = await InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: p), autoConsume: true);
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.wgPassFailed;
    }
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list.where((p) => p.productID == product)) {
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled || PurchaseStatus.error:
          busy.value = false;
          if (p.status == PurchaseStatus.error) notice.value = tr.wgPassFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          final data = await WhisperGroup.call('verify', {
            'purchase': Platform.isIOS
                ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
                : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
          });
          busy.value = false;
          final code = '${data['code'] ?? ''}';
          // 驗證成功、或這筆已經用過（不必再試）才結束交易；連不上時留著，下次啟動再送
          if (data['success'] == true || code == 'used' || code == 'unknown_product' || code == 'revoked') {
            if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
          }
          notice.value = data['success'] == true ? tr.wgPassDone : tr.wgPassFailed;
      }
    }
  }
}

// ---------- 開團 ----------

Future<void> showCreateWhisperGroup(BuildContext context) {
  final name = TextEditingController();
  var color = 'violet';
  var days = 1.0;
  var busy = false;
  return showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr.wgCreateTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            Text(tr.wgCreateBody, style: Night.caption, textAlign: TextAlign.center),
            if (_showTourChip) ...[const SizedBox(height: Night.space3), const _TourChipCard()],
            const SizedBox(height: Night.space4),
            TextField(
              controller: name, maxLength: 20, style: const TextStyle(color: Night.ink),
              decoration: InputDecoration(labelText: tr.wgNameLabel, labelStyle: Night.caption, counterStyle: Night.caption),
            ),
            const SizedBox(height: Night.space2),
            Text(tr.wgColorLabel, style: Night.caption),
            const SizedBox(height: Night.space2),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final e in wgColors.entries)
                GestureDetector(
                  onTap: () => setS(() => color = e.key),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: e.value, shape: BoxShape.circle, border: Border.all(color: color == e.key ? Colors.white : Colors.transparent, width: 3)),
                  ),
                ),
            ]),
            const SizedBox(height: Night.space4),
            Text(tr.wgDaysLabel(days.round()), style: Night.caption),
            Slider(value: days, min: 1, max: 7, divisions: 6, activeColor: wgColor(color), onChanged: (v) => setS(() => days = v)),
            Text(tr.wgFreeNote, style: Night.caption.copyWith(fontSize: 11)),
            const SizedBox(height: Night.space3),
            NightButton(tr.wgCreateButton, icon: Icons.groups_2_outlined, onPressed: busy ? null : () async {
              setS(() => busy = true);
              final r = await WhisperGroup.call('create', {'name': name.text, 'color': color, 'days': days.round()});
              setS(() => busy = false);
              if (!ctx.mounted) return;
              if (r['success'] == true) {
                Navigator.pop(ctx);
                showWhisperGroupPanel(context);
              } else {
                showGlassToast(ctx, r['code'] == 'name' ? tr.wgErrName : wgError('${r['code']}'), danger: true, icon: Icons.error_outline);
              }
            }),
          ])),
        ),
      ),
    )),
  );
}

// ---------- 旅行團 TourChip 導流 ----------
// 只在 iOS 顯示：TourChip 目前只上架 App Store（Google Play 還沒上架，上架後再開 Android）
// TourChip 1.0.2 起已有城市低語全部的介面語言（含 pt / es / hi），不再限制語言
const _tourChipAppStore = 'https://apps.apple.com/app/id6832215611';
bool get _showTourChip => Platform.isIOS;

class _TourChipCard extends StatelessWidget {
  const _TourChipCard();

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => launchUrl(Uri.parse(_tourChipAppStore), mode: LaunchMode.externalApplication),
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        child: Row(children: [
          const Icon(Icons.tour_outlined, color: Night.ink, size: 26),
          const SizedBox(width: Night.space3),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr.wgTourChipTitle, style: Night.caption.copyWith(color: Night.ink, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(tr.wgTourChipBody, style: Night.caption.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(tr.wgTourChipButton, style: Night.caption.copyWith(fontSize: 12, decoration: TextDecoration.underline)),
          ])),
          const Icon(Icons.open_in_new, color: Night.ink, size: 16),
        ]),
      ),
    ),
  );
}

// ---------- 入團 ----------

/// 從 QR code／分享連結進來，或在設定裡輸入團代碼
Future<void> joinWhisperGroup(BuildContext context, String code, int version) async {
  final r = await WhisperGroup.call('join', {'code': code, 'v': version});
  if (!context.mounted) return;
  if (r['success'] == true) {
    final g = WhisperGroup.current.value;
    showGlassToast(context, tr.wgJoined(g?.name ?? '', g?.myNo ?? 0), icon: Icons.groups_2_outlined);
  } else {
    showGlassToast(context, wgError('${r['code']}'), danger: true, icon: Icons.error_outline);
  }
}

Future<void> showJoinByCode(BuildContext context) {
  final ctl = TextEditingController();
  return showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr.wgJoinTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            Text(tr.wgJoinBody, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            TextField(
              controller: ctl, maxLength: 8, textCapitalization: TextCapitalization.characters, autofocus: true,
              style: TextStyle(color: Night.ink, fontSize: 22, letterSpacing: ls(4)), textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'))],
            ),
            const SizedBox(height: Night.space2),
            NightButton(tr.wgJoinButton, onPressed: () async {
              Navigator.pop(ctx);
              await joinWhisperGroup(context, ctl.text.toUpperCase(), 1);
            }),
          ])),
        ),
      ),
    ),
  );
}

// ---------- 地圖上的按鈕 ----------

/// 地圖下方、城市燈塔旁的低語團按鈕：只有在團裡才顯示；有集合呼叫還沒按收到時外圈閃團色
class WhisperGroupButton extends StatefulWidget {
  const WhisperGroupButton({super.key});
  @override
  State<WhisperGroupButton> createState() => _WhisperGroupButtonState();
}

class _WhisperGroupButtonState extends State<WhisperGroupButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<WgGroup?>(
        valueListenable: WhisperGroup.current,
        builder: (context, g, _) {
          if (g == null) return const SizedBox.shrink();
          final alert = !g.isHost && ((g.call != null && g.call!.mine != 'ack') || (g.rollId != null && g.rollMine == null));
          return Semantics(
            button: true, label: tr.wgButtonLabel(g.name),
            child: GestureDetector(
              onTap: () => showWhisperGroupPanel(context),
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) => Container(
                  height: 44, padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Night.glassFill, borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: g.tint.withValues(alpha: alert ? 0.5 + 0.5 * _pulse.value : 0.8), width: alert ? 2.5 : 1.4),
                    boxShadow: alert ? [BoxShadow(color: g.tint.withValues(alpha: 0.5 * _pulse.value), blurRadius: 14)] : null,
                  ),
                  child: child,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.groups_2_outlined, color: g.tint, size: 20),
                  const SizedBox(width: 6),
                  ConstrainedBox(constraints: const BoxConstraints(maxWidth: 110), child: Text(g.name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Night.ink, fontSize: 13))),
                ]),
              ),
            ),
          );
        },
      );
}

// ---------- 面板 ----------

/// 團主：集合、點名、團員、QR code、交棒、解散、方案；團員：集合、點名回覆、團資訊、退出
Future<void> showWhisperGroupPanel(BuildContext context, {Position? Function()? position}) {
  WhisperGroup.refresh();
  return showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true, useSafeArea: true,
    builder: (ctx) => ValueListenableBuilder<WgGroup?>(
      valueListenable: WhisperGroup.current,
      builder: (ctx, g, _) {
        if (g == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: _SolidCard(child: SingleChildScrollView(child: g.isHost ? _HostPanel(g: g) : _MemberPanel(g: g))),
        );
      },
    ),
  );
}

class _Header extends StatelessWidget {
  final WgGroup g;
  const _Header({required this.g});
  @override
  Widget build(BuildContext context) {
    final end = DateTime.fromMillisecondsSinceEpoch(g.endsAt);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: g.tint, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Flexible(child: Text(g.name, style: Night.title, overflow: TextOverflow.ellipsis)),
      ]),
      const SizedBox(height: 4),
      Text(
        [tr.wgCount(g.count, g.limit), tr.wgUntil('${end.month}/${end.day}'), if (!g.isHost && g.myNo != null) tr.wgMyNo(g.myNo!)].join('  ·  '),
        style: Night.caption, textAlign: TextAlign.center,
      ),
    ]);
  }
}

class _HostPanel extends StatelessWidget {
  final WgGroup g;
  const _HostPanel({required this.g});

  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _Header(g: g),
        if (g.lost.isNotEmpty) ...[
          const SizedBox(height: Night.space3),
          _LostList(g: g),
        ],
        const SizedBox(height: Night.space4),
        if (g.call == null)
          NightButton(tr.wgCallButton, icon: Icons.campaign_outlined, onPressed: () => _showCallSheet(context, g))
        else ...[
          _CallSummary(g: g),
          const SizedBox(height: Night.space2),
          NightButton(tr.wgCallDone, kind: NightButtonKind.ghost, icon: Icons.check, onPressed: () => WhisperGroup.call('call_done')),
        ],
        const SizedBox(height: Night.space2),
        NightButton(tr.wgRollButton, kind: NightButtonKind.ghost, icon: Icons.how_to_reg_outlined, onPressed: () async {
          final r = await WhisperGroup.call('rollcall');
          if (context.mounted && r['success'] != true) showGlassToast(context, wgError('${r['code']}'), danger: true);
        }),
        if (g.rollId != null) ...[
          const SizedBox(height: Night.space3),
          Text(tr.wgRollSummary(g.here, g.rollRoster.length), style: const TextStyle(color: Night.ink, fontSize: 15)),
          for (final m in g.rollRoster) _RosterRow(m: m, color: g.tint, rollMode: true),
        ],
        const SizedBox(height: Night.space4),
        Text(tr.wgMembersTitle(g.members.length), style: Night.caption),
        if (g.members.isEmpty) Padding(padding: const EdgeInsets.all(Night.space2), child: Text(tr.wgNoMembers, style: Night.caption)),
        if (g.call == null && g.rollId == null) for (final m in g.members) _RosterRow(m: m, color: g.tint, onTap: () => _memberMenu(context, g, m)),
        if (g.call != null || g.rollId != null) for (final m in g.members) _RosterRow(m: m, color: g.tint, compact: true, onTap: () => _memberMenu(context, g, m)),
        const SizedBox(height: Night.space4),
        // 7 天方案：沒開通的團主都看得到（審查人員一個人也找得到購買入口）
        if (!g.paid) ...[
          _PassCard(g: g),
          const SizedBox(height: Night.space3),
        ],
        Wrap(alignment: WrapAlignment.center, spacing: 4, children: [
          TextButton.icon(onPressed: () => _showQr(context, g), icon: const Icon(Icons.qr_code_2, size: 18), label: Text(tr.wgQrButton), style: TextButton.styleFrom(foregroundColor: Night.ink)),
          TextButton.icon(onPressed: () => showWgFlag(context, g), icon: const Icon(Icons.flag_outlined, size: 18), label: Text(tr.wgFlagButton), style: TextButton.styleFrom(foregroundColor: Night.ink)),
          TextButton.icon(onPressed: () => _confirm(context, tr.wgDissolveAsk, () => WhisperGroup.call('dissolve')), icon: const Icon(Icons.logout, size: 18), label: Text(tr.wgDissolve), style: TextButton.styleFrom(foregroundColor: Night.danger)),
        ]),
      ]);
}

class _CallSummary extends StatelessWidget {
  final WgGroup g;
  const _CallSummary({required this.g});
  @override
  Widget build(BuildContext context) {
    final c = g.call!;
    final mins = max(0, ((c.at - DateTime.now().millisecondsSinceEpoch) / 60000).round());
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(mins > 0 ? tr.wgCallIn(mins) : tr.wgCallNow, style: TextStyle(color: g.tint, fontSize: 18, fontWeight: FontWeight.w500)),
      if (c.place.isNotEmpty) Text(c.place, style: Night.body),
      const SizedBox(height: Night.space2),
      Text(tr.wgAckSummary(g.acked, g.callRoster.length), style: const TextStyle(color: Night.ink, fontSize: 15)),
      for (final m in g.callRoster) _RosterRow(m: m, color: g.tint),
    ]);
  }
}

class _RosterRow extends StatelessWidget {
  final WgMember m;
  final Color color;
  final bool rollMode, compact;
  final VoidCallback? onTap;
  const _RosterRow({required this.m, required this.color, this.rollMode = false, this.compact = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    final (icon, label, tint) = rollMode
        ? switch (m.state) {
            'here' => (Icons.check_circle, tr.wgAnswerHere, Night.moodCalm),
            '5min' => (Icons.schedule, tr.wgAnswer5min, Night.cityAmber),
            'help' => (Icons.sos, tr.wgAnswerHelp, Night.danger),
            _ => (Icons.radio_button_unchecked, tr.wgNoReply, Night.inkFaint),
          }
        : switch (m.state) {
            'ack' => (Icons.check_circle, tr.wgStateAck, Night.moodCalm),
            'seen' => (Icons.visibility_outlined, tr.wgStateSeen, Night.cityAmber),
            '' => (Icons.person_outline, '', Night.inkMuted),
            _ => (Icons.radio_button_unchecked, tr.wgStateNone, Night.inkFaint),
          };
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: compact ? 4 : 8),
        child: Row(children: [
          Container(
            width: 30, height: 30, alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color.withValues(alpha: 0.7))),
            child: Text('${m.no}', style: const TextStyle(color: Night.ink, fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text([if (m.note.isNotEmpty) m.note, if (m.name.isNotEmpty) m.name].join(' · '), style: const TextStyle(color: Night.ink, fontSize: 14), overflow: TextOverflow.ellipsis)),
          if (label.isNotEmpty) ...[Icon(icon, size: 16, color: tint), const SizedBox(width: 4), Text(label, style: TextStyle(color: tint, fontSize: 12))],
        ]),
      ),
    );
  }
}

class _PassCard extends StatelessWidget {
  final WgGroup g;
  const _PassCard({required this.g});
  @override
  Widget build(BuildContext context) {
    GroupPassStore.load();
    return Container(
      padding: const EdgeInsets.all(Night.space3),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: g.tint.withValues(alpha: 0.6))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(tr.wgPassTitle, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(tr.wgPassBody, style: Night.caption),
        const SizedBox(height: Night.space2),
        AnimatedBuilder(
          animation: Listenable.merge([GroupPassStore.details, GroupPassStore.busy]),
          builder: (context, _) => NightButton(
            GroupPassStore.details.value == null ? tr.wgPassButton : '${tr.wgPassButton}  ·  ${GroupPassStore.details.value!.price}',
            kind: NightButtonKind.warm, icon: Icons.group_add_outlined,
            onPressed: GroupPassStore.busy.value ? null : GroupPassStore.buy,
          ),
        ),
      ]),
    );
  }
}

class _MemberPanel extends StatelessWidget {
  final WgGroup g;
  const _MemberPanel({required this.g});
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _Header(g: g),
        if (g.hostName.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(tr.wgHostIs(g.hostName), style: Night.caption, textAlign: TextAlign.center)),
        const SizedBox(height: Night.space4),
        if (g.call != null) WgCallCard(g: g, call: g.call!) else Text(tr.wgNoCall, style: Night.caption, textAlign: TextAlign.center),
        if (g.rollId != null) ...[
          const SizedBox(height: Night.space4),
          Text(tr.wgRollAsk, style: const TextStyle(color: Night.ink, fontSize: 15), textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          _RollButtons(g: g),
        ],
        const SizedBox(height: Night.space4),
        Row(children: [
          Expanded(child: NightButton(tr.wgFlagButton, kind: NightButtonKind.ghost, icon: Icons.flag_outlined, onPressed: () => showWgFlag(context, g))),
          const SizedBox(width: Night.space2),
          Expanded(child: g.lostSent
              ? NightButton(tr.wgFound, kind: NightButtonKind.ghost, icon: Icons.check, onPressed: () => WhisperGroup.call('found'))
              : NightButton(tr.wgLostButton, kind: NightButtonKind.danger, icon: Icons.wrong_location_outlined, onPressed: () => _askLost(context))),
        ]),
        if (g.lostSent) Padding(padding: const EdgeInsets.only(top: Night.space2), child: Text(tr.wgLostSent, style: Night.caption, textAlign: TextAlign.center)),
        const SizedBox(height: Night.space3),
        TextButton.icon(
          onPressed: () => _confirm(context, tr.wgLeaveAsk, () => WhisperGroup.call('leave')),
          icon: const Icon(Icons.logout, size: 18), label: Text(tr.wgLeave), style: TextButton.styleFrom(foregroundColor: Night.danger),
        ),
      ]);
}

class _RollButtons extends StatelessWidget {
  final WgGroup g;
  const _RollButtons({required this.g});
  @override
  Widget build(BuildContext context) {
    Widget b(String value, String label, IconData icon, Color c) => Expanded(
          child: GestureDetector(
            onTap: () { HapticFeedback.mediumImpact(); WhisperGroup.call('answer', {'rollId': g.rollId, 'answer': value}); },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: g.rollMine == value ? c.withValues(alpha: 0.25) : Night.night700,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: g.rollMine == value ? c : Night.glassLine, width: g.rollMine == value ? 2 : 1),
              ),
              child: Column(children: [Icon(icon, color: c), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Night.ink, fontSize: 13), textAlign: TextAlign.center)]),
            ),
          ),
        );
    return Row(children: [
      b('here', tr.wgAnswerHere, Icons.check_circle_outline, Night.moodCalm),
      const SizedBox(width: 8),
      b('5min', tr.wgAnswer5min, Icons.schedule, Night.cityAmber),
      const SizedBox(width: 8),
      b('help', tr.wgAnswerHelp, Icons.sos, Night.danger),
    ]);
  }
}

/// 團員的集合卡片：倒數、集合點說明、距離與方向（用自己的位置在手機上算，不會傳出去）、「收到」
class WgCallCard extends StatefulWidget {
  final WgGroup g;
  final WgCall call;
  final bool big;
  const WgCallCard({super.key, required this.g, required this.call, this.big = false});
  @override
  State<WgCallCard> createState() => _WgCallCardState();
}

class _WgCallCardState extends State<WgCallCard> {
  Timer? _tick;
  Position? _pos;
  StreamSubscription<Position>? _sub;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); });
    _sub = Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5)).listen((p) { if (mounted) setState(() => _pos = p); }, onError: (_) {});
    if (widget.call.mine == null) WhisperGroup.call('seen', {'callId': widget.call.id});
  }

  @override
  void dispose() { _tick?.cancel(); _sub?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.call;
    final left = Duration(milliseconds: max(0, c.at - DateTime.now().millisecondsSinceEpoch));
    final pos = _pos;
    final dist = pos == null ? null : Geolocator.distanceBetween(pos.latitude, pos.longitude, c.lat, c.lng);
    final bearing = pos == null ? null : Geolocator.bearingBetween(pos.latitude, pos.longitude, c.lat, c.lng);
    final heading = pos?.heading ?? 0;
    final acked = (WhisperGroup.current.value?.call?.mine ?? c.mine) == 'ack';
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(tr.wgCallTitle, style: TextStyle(color: widget.g.tint, fontSize: widget.big ? 22 : 17, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      const SizedBox(height: Night.space2),
      Text(left.inSeconds > 0 ? '${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}' : tr.wgCallNow,
          style: TextStyle(color: Night.ink, fontSize: widget.big ? 44 : 30, fontWeight: FontWeight.w300, fontFeatures: const [FontFeature.tabularFigures()]), textAlign: TextAlign.center),
      if (c.place.isNotEmpty) Text(c.place, style: Night.body, textAlign: TextAlign.center),
      if (dist != null && bearing != null) ...[
        const SizedBox(height: Night.space3),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform.rotate(angle: (bearing - heading) * pi / 180, child: Icon(Icons.navigation, color: widget.g.tint, size: 34)),
          const SizedBox(width: 10),
          Text(dist < 1000 ? '${dist.round()} m' : '${(dist / 1000).toStringAsFixed(1)} km', style: const TextStyle(color: Night.ink, fontSize: 20)),
        ]),
      ],
      const SizedBox(height: Night.space4),
      acked
          ? Text(tr.wgAcked, style: TextStyle(color: Night.moodCalm, fontSize: 15), textAlign: TextAlign.center)
          : NightButton(tr.wgAckButton, icon: Icons.check, onPressed: () { HapticFeedback.heavyImpact(); WhisperGroup.call('ack', {'callId': c.id}); }),
    ]);
  }
}

/// 前景收到集合呼叫：全螢幕卡片＋震動「短 短 長」
Future<void> showWgCallOverlay(BuildContext context, WgCall call) async {
  final g = WhisperGroup.current.value;
  if (g == null) return;
  await wgBuzz();
  if (!context.mounted) return;
  await showDialog(
    context: context, barrierColor: g.tint.withValues(alpha: 0.35),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space4),
      child: _SolidCard(child: ValueListenableBuilder<WgGroup?>(
        valueListenable: WhisperGroup.current,
        builder: (ctx, cur, _) {
          if (cur?.call?.mine == 'ack') Future.microtask(() { if (ctx.mounted && Navigator.canPop(ctx)) Navigator.pop(ctx); });
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Text(g.name, style: Night.caption),
            const SizedBox(height: Night.space2),
            WgCallCard(g: cur ?? g, call: cur?.call ?? call, big: true),
          ]);
        },
      )),
    ),
  );
}

/// App 開著時推播不會響：自己播一次專屬音效（集合、點名、迷路、需要幫忙共用）
final _alertPlayer = AudioPlayer();
Future<void> wgAlertSound() async {
  try {
    await _alertPlayer.stop();
    await _alertPlayer.play(AssetSource('audio/group_call.wav'), volume: 1.0);
  } catch (_) {}
}

/// 震動「短 短 長」＋專屬音效：集合、點名、迷路、需要幫忙共用
Future<void> wgBuzz() async {
  wgAlertSound();
  HapticFeedback.heavyImpact();
  await Future.delayed(const Duration(milliseconds: 250));
  HapticFeedback.heavyImpact();
  await Future.delayed(const Duration(milliseconds: 250));
  HapticFeedback.heavyImpact();
  await Future.delayed(const Duration(milliseconds: 120));
  HapticFeedback.vibrate();
}

/// 前景收到點名：全螢幕卡片＋震動，三個大按鈕；回答後自動關閉
Future<void> showWgRollOverlay(BuildContext context, String rollId) async {
  final g = WhisperGroup.current.value;
  if (g == null) return;
  await wgBuzz();
  if (!context.mounted) return;
  await showDialog(
    context: context, barrierColor: g.tint.withValues(alpha: 0.35),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space4),
      child: _SolidCard(child: ValueListenableBuilder<WgGroup?>(
        valueListenable: WhisperGroup.current,
        builder: (ctx, cur, _) {
          final now = cur ?? g;
          if (now.rollId != rollId || now.rollMine != null) Future.microtask(() { if (ctx.mounted && Navigator.canPop(ctx)) Navigator.pop(ctx); });
          return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(now.name, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            Text(tr.wgRollAsk, style: TextStyle(color: now.tint, fontSize: 22, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
            _RollButtons(g: now),
          ]);
        },
      )),
    ),
  );
}

// ---------- 團主的操作 ----------

void _showCallSheet(BuildContext context, WgGroup g) {
  var minutes = 15;
  final place = TextEditingController();
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr.wgCallSheetTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
              for (final m in [0, 10, 15, 30, 60])
                ChoiceChip(
                  label: Text(m == 0 ? tr.wgNow : tr.wgInMinutes(m)), selected: minutes == m,
                  selectedColor: g.tint.withValues(alpha: 0.35), labelStyle: const TextStyle(color: Night.ink),
                  onSelected: (_) => setS(() => minutes = m),
                ),
            ]),
            const SizedBox(height: Night.space3),
            TextField(
              controller: place, maxLength: 30, style: const TextStyle(color: Night.ink),
              decoration: InputDecoration(labelText: tr.wgPlaceLabel, hintText: tr.wgPlaceHint, labelStyle: Night.caption, hintStyle: Night.caption, counterStyle: Night.caption),
            ),
            Text(tr.wgPlaceNote, style: Night.caption.copyWith(fontSize: 11)),
            const SizedBox(height: Night.space3),
            NightButton(tr.wgSendCall, icon: Icons.campaign_outlined, onPressed: () async {
              Position? pos;
              try { pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 8)); } catch (_) {
                try { pos = await Geolocator.getLastKnownPosition(); } catch (_) {}
              }
              if (pos == null) { if (ctx.mounted) showGlassToast(ctx, tr.wgNoLocation, danger: true); return; }
              final r = await WhisperGroup.call('call', {
                'at': DateTime.now().millisecondsSinceEpoch + minutes * 60000, 'place': place.text, 'lat': pos.latitude, 'lng': pos.longitude,
              });
              if (!ctx.mounted) return;
              if (r['success'] == true) Navigator.pop(ctx); else showGlassToast(ctx, wgError('${r['code']}'), danger: true);
            }),
          ])),
        ),
      ),
    )),
  );
}

void _showQr(BuildContext context, WgGroup g) {
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => ValueListenableBuilder<WgGroup?>(
      valueListenable: WhisperGroup.current,
      builder: (ctx, cur, _) {
        final qr = cur?.qr ?? g.qr ?? '';
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Night.space4),
            child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(tr.wgQrTitle, style: Night.title),
              const SizedBox(height: Night.space2),
              Text(tr.wgQrBody, style: Night.caption, textAlign: TextAlign.center),
              const SizedBox(height: Night.space3),
              Container(
                padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: QrImageView(data: qr, size: 220, backgroundColor: Colors.white),
              ),
              const SizedBox(height: Night.space2),
              SelectableText(cur?.code ?? g.code, style: TextStyle(color: Night.ink, fontSize: 22, letterSpacing: ls(4))),
              const SizedBox(height: Night.space2),
              Wrap(alignment: WrapAlignment.center, children: [
                TextButton.icon(onPressed: () => SharePlus.instance.share(ShareParams(text: tr.wgShareText(g.name, qr))), icon: const Icon(Icons.ios_share, size: 18), label: Text(tr.wgShare), style: TextButton.styleFrom(foregroundColor: Night.ink)),
                TextButton.icon(onPressed: () => _confirm(ctx, tr.wgRotateAsk, () => WhisperGroup.call('rotate_qr')), icon: const Icon(Icons.refresh, size: 18), label: Text(tr.wgRotate), style: TextButton.styleFrom(foregroundColor: Night.inkMuted)),
              ]),
            ])),
          ),
        );
      },
    ),
  );
}

void _memberMenu(BuildContext context, WgGroup g, WgMember m) {
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(tr.wgMemberTitle(m.no), style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space3),
          NightButton(tr.wgEditNote, kind: NightButtonKind.ghost, icon: Icons.edit_outlined, onPressed: () { Navigator.pop(ctx); _editNote(context, m); }),
          const SizedBox(height: Night.space2),
          NightButton(tr.wgHandoff, kind: NightButtonKind.ghost, icon: Icons.swap_horiz, onPressed: () { Navigator.pop(ctx); _confirm(context, tr.wgHandoffAsk(m.no), () => WhisperGroup.call('handoff', {'uid': m.uid})); }),
          const SizedBox(height: Night.space2),
          NightButton(tr.wgKick, kind: NightButtonKind.danger, icon: Icons.person_remove_outlined, onPressed: () { Navigator.pop(ctx); _confirm(context, tr.wgKickAsk(m.no), () => WhisperGroup.call('kick', {'uid': m.uid})); }),
        ])),
      ),
    ),
  );
}

void _editNote(BuildContext context, WgMember m) {
  final ctl = TextEditingController(text: m.note);
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr.wgEditNote, style: Night.title, textAlign: TextAlign.center),
            Text(tr.wgNotePrivate, style: Night.caption, textAlign: TextAlign.center),
            TextField(controller: ctl, maxLength: 20, autofocus: true, style: const TextStyle(color: Night.ink)),
            NightButton(tr.wgSave, onPressed: () async {
              final r = await WhisperGroup.call('note', {'uid': m.uid, 'note': ctl.text});
              if (!ctx.mounted) return;
              if (r['success'] == true) Navigator.pop(ctx); else showGlassToast(ctx, wgError('${r['code']}'), danger: true);
            }),
          ])),
        ),
      ),
    ),
  );
}

void _confirm(BuildContext context, String text, Future<Object?> Function() action) {
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(text, style: Night.body, textAlign: TextAlign.center),
          const SizedBox(height: Night.space4),
          NightButton(tr.wgConfirm, kind: NightButtonKind.danger, onPressed: () async {
            Navigator.pop(ctx);
            final r = await action();
            if (context.mounted && r is Map && r['success'] != true) showGlassToast(context, wgError('${r['code']}'), danger: true);
          }),
          const SizedBox(height: Night.space2),
          NightButton(tr.wgCancel, kind: NightButtonKind.text, onPressed: () => Navigator.pop(ctx)),
        ])),
      ),
    ),
  );
}

/// 實心底的玻璃卡：面板疊在地圖上，後面的字不能透出來
class _SolidCard extends StatelessWidget {
  final Widget child;
  const _SolidCard({required this.child});
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: GlassCard(child: child),
      );
}

@visibleForTesting
(String, int)? debugParseLink(String s) => WhisperGroup.parseLink(Uri.parse(s));

/// 地圖上的集合點：團色光柱＋底部光環＋集合點說明與距離；集合點在畫面外時，畫面邊緣出現指向它的箭頭。
/// 座標是團主放的集合點，不是任何人的位置；距離用自己的位置在手機上算。
class WgPillarPainter extends CustomPainter {
  final Offset at; // 光柱底部（或畫面邊緣的箭頭位置）
  final bool offscreen;
  final Offset center; // 自己在畫面上的位置（箭頭方向用）
  final Color color;
  final String label;
  final double glow; // 0～1 呼吸
  WgPillarPainter({required this.at, required this.offscreen, required this.center, required this.color, required this.label, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    if (offscreen) {
      // 邊緣箭頭：從自己指向集合點
      final dir = at - center;
      final a = atan2(dir.dy, dir.dx);
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(a);
      canvas.drawCircle(Offset.zero, 22, Paint()..color = color.withValues(alpha: 0.25 + 0.15 * glow));
      final path = Path()..moveTo(14, 0)..lineTo(-8, -10)..lineTo(-3, 0)..lineTo(-8, 10)..close();
      canvas.drawPath(path, Paint()..color = color);
      canvas.restore();
      _label(canvas, size, at + const Offset(0, 26), center: true);
      return;
    }
    const h = 150.0, w = 14.0;
    final top = at - const Offset(0, h);
    // 光柱：底部最亮、往上淡出
    final beam = Rect.fromLTRB(at.dx - w / 2, top.dy, at.dx + w / 2, at.dy);
    canvas.drawRect(beam.inflate(10), Paint()
      ..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [color.withValues(alpha: 0.35 + 0.15 * glow), color.withValues(alpha: 0)]).createShader(beam.inflate(10))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    canvas.drawRect(beam, Paint()
      ..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.white.withValues(alpha: 0.9), color.withValues(alpha: 0.6), color.withValues(alpha: 0)], stops: const [0, 0.35, 1]).createShader(beam));
    // 底部光環
    final ring = Rect.fromCenter(center: at, width: 46 + 10 * glow, height: 16 + 4 * glow);
    canvas.drawOval(ring, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = color.withValues(alpha: 0.9));
    canvas.drawOval(ring.inflate(8), Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = color.withValues(alpha: 0.35 * (1 - glow)));
    _label(canvas, size, top - const Offset(0, 6), center: true, above: true);
  }

  void _label(Canvas canvas, Size size, Offset anchor, {bool center = false, bool above = false}) {
    if (label.isEmpty) return;
    final tp = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(color: Night.ink, fontSize: 12, fontWeight: FontWeight.w500)),
      textDirection: TextDirection.ltr, maxLines: 2, textAlign: TextAlign.center,
    )..layout(maxWidth: 180);
    var x = anchor.dx - tp.width / 2;
    var y = above ? anchor.dy - tp.height - 8 : anchor.dy;
    x = x.clamp(8.0, size.width - tp.width - 8);
    y = y.clamp(8.0, size.height - tp.height - 8);
    final bg = RRect.fromRectAndRadius(Rect.fromLTWH(x - 10, y - 5, tp.width + 20, tp.height + 10), const Radius.circular(12));
    canvas.drawRRect(bg, Paint()..color = Night.night900.withValues(alpha: 0.82));
    canvas.drawRRect(bg, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = color.withValues(alpha: 0.8));
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant WgPillarPainter old) => old.at != at || old.offscreen != offscreen || old.glow != glow || old.label != label || old.color != color;
}


// ---------- 第二版：光之團旗、我迷路了 ----------

/// 光之團旗：整個螢幕變成團色並閃爍，中間是團號（團主是「團主」）。舉起手機讓彼此在人群裡找到你；不需要定位，也不送任何資料
Future<void> showWgFlag(BuildContext context, WgGroup g) {
  return Navigator.of(context).push(PageRouteBuilder(
    opaque: true, pageBuilder: (_, __, ___) => _FlagPage(g: g),
    transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
  ));
}

class _FlagPage extends StatefulWidget {
  final WgGroup g;
  const _FlagPage({required this.g});
  @override
  State<_FlagPage> createState() => _FlagPageState();
}

class _FlagPageState extends State<_FlagPage> with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable().catchError((_) {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _blink.dispose();
    WakelockPlus.disable().catchError((_) {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.g;
    final label = g.isHost ? tr.wgFlagHost : '${g.myNo ?? ''}';
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AnimatedBuilder(
        animation: _blink,
        builder: (context, _) {
          final bg = Color.lerp(g.tint, Colors.white, 0.15 + 0.55 * _blink.value)!;
          return Scaffold(
            backgroundColor: bg,
            body: SafeArea(
              child: Column(children: [
                const Spacer(),
                Text(g.name, style: const TextStyle(color: Colors.black87, fontSize: 28, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                FittedBox(child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 260, fontWeight: FontWeight.w800, height: 1.0))),
                const Spacer(),
                Padding(padding: const EdgeInsets.all(24), child: Text(tr.wgFlagHint, style: const TextStyle(color: Colors.black54, fontSize: 15), textAlign: TextAlign.center)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

/// 我迷路了：先說明只傳這一次、30 分鐘後刪除，同意才傳
void _askLost(BuildContext context) {
  showModalBottomSheet(
    context: context, backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.wrong_location_outlined, color: Night.danger, size: 32),
          const SizedBox(height: Night.space2),
          Text(tr.wgLostTitleAsk, style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          Text(tr.wgLostAsk, style: Night.body),
          const SizedBox(height: Night.space4),
          NightButton(tr.wgLostSend, kind: NightButtonKind.danger, icon: Icons.send, onPressed: () async {
            Navigator.pop(ctx);
            Position? pos;
            try { pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10)); } catch (_) {
              try { pos = await Geolocator.getLastKnownPosition(); } catch (_) {}
            }
            if (!context.mounted) return;
            if (pos == null) { showGlassToast(context, tr.wgNoLocation, danger: true); return; }
            final r = await WhisperGroup.call('lost', {'lat': pos.latitude, 'lng': pos.longitude});
            if (context.mounted) showGlassToast(context, r['success'] == true ? tr.wgLostSent : wgError('${r['code']}'), danger: r['success'] != true, icon: Icons.wrong_location_outlined);
          }),
          const SizedBox(height: Night.space2),
          NightButton(tr.wgCancel, kind: NightButtonKind.text, onPressed: () => Navigator.pop(ctx)),
        ])),
      ),
    ),
  );
}

/// 團主：迷路的團員（距離用團主自己的位置算）＋導航過去＋找到了
class _LostList extends StatefulWidget {
  final WgGroup g;
  const _LostList({required this.g});
  @override
  State<_LostList> createState() => _LostListState();
}

class _LostListState extends State<_LostList> {
  Position? _me;
  @override
  void initState() {
    super.initState();
    Geolocator.getLastKnownPosition().then((p) { if (mounted && p != null) setState(() => _me = p); }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Night.space3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.danger.withValues(alpha: 0.7))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(tr.wgLostTitle(widget.g.lost.length), style: const TextStyle(color: Night.danger, fontSize: 15, fontWeight: FontWeight.w500)),
          for (final m in widget.g.lost)
            Padding(
              padding: const EdgeInsets.only(top: Night.space2),
              child: Row(children: [
                Expanded(child: Text([
                  tr.wgMemberTitle(m.no), if (m.note.isNotEmpty) m.note,
                  tr.wgMinutesAgo(max(0, ((DateTime.now().millisecondsSinceEpoch - m.at) / 60000).round())),
                  if (_me != null) () { final d = Geolocator.distanceBetween(_me!.latitude, _me!.longitude, m.lat, m.lng); return d < 1000 ? '${d.round()} m' : '${(d / 1000).toStringAsFixed(1)} km'; }(),
                ].join(' · '), style: const TextStyle(color: Night.ink, fontSize: 14))),
                IconButton(
                  tooltip: tr.wgNavigate, icon: const Icon(Icons.directions, color: Night.auroraBlue),
                  onPressed: () => launchUrl(
                    Platform.isIOS ? Uri.parse('http://maps.apple.com/?daddr=${m.lat},${m.lng}&dirflg=w') : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${m.lat},${m.lng}&travelmode=walking'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                IconButton(tooltip: tr.wgFoundThem, icon: const Icon(Icons.check_circle_outline, color: Night.moodCalm), onPressed: () => WhisperGroup.call('found', {'uid': m.uid})),
              ]),
            ),
        ]),
      );
}

/// 團主地圖上的迷路團員：紅色圖釘＋團號（畫面外就在邊緣出現紅色箭頭）
class WgLostPinPainter extends CustomPainter {
  final List<(Offset, bool, int)> pins; // 位置、是否在畫面外、團號
  final Offset center;
  WgLostPinPainter({required this.pins, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    for (final (at, out, no) in pins) {
      if (out) {
        final a = atan2(at.dy - center.dy, at.dx - center.dx);
        canvas.save();
        canvas.translate(at.dx, at.dy);
        canvas.rotate(a);
        canvas.drawCircle(Offset.zero, 18, Paint()..color = Night.danger.withValues(alpha: 0.3));
        canvas.drawPath(Path()..moveTo(12, 0)..lineTo(-7, -9)..lineTo(-2, 0)..lineTo(-7, 9)..close(), Paint()..color = Night.danger);
        canvas.restore();
      } else {
        canvas.drawCircle(at, 4, Paint()..color = Night.danger);
        final head = at - const Offset(0, 30);
        canvas.drawLine(at, head, Paint()..color = Night.danger..strokeWidth = 2);
        canvas.drawCircle(head, 14, Paint()..color = Night.danger);
      }
      final tp = TextPainter(text: TextSpan(text: '$no', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout();
      final c = out ? at : at - const Offset(0, 30);
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant WgLostPinPainter old) => true;
}


/// 團主在前景收到「我迷路了」或「需要幫忙」：音效＋震動＋全螢幕提醒，按「查看」打開低語團面板（迷路名單在最上面）
Future<void> showWgLeaderAlert(BuildContext context, {required bool lost}) async {
  await WhisperGroup.refresh();
  final g = WhisperGroup.current.value;
  if (g == null || !g.isHost || !context.mounted) return;
  await wgBuzz();
  if (!context.mounted) return;
  final latest = lost && g.lost.isNotEmpty ? g.lost.first : null;
  final helpers = [for (final m in g.rollRoster) if (m.state == 'help') m.no];
  final title = latest != null ? tr.wgLostAlert(latest.no) : (helpers.isNotEmpty ? tr.wgHelpAlert(helpers.join('、')) : g.name);
  final open = await showDialog<bool>(
    context: context, barrierColor: Night.danger.withValues(alpha: 0.3),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space4),
      child: _SolidCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(lost ? Icons.wrong_location_outlined : Icons.sos, color: Night.danger, size: 40),
        const SizedBox(height: Night.space2),
        Text(g.name, style: Night.caption, textAlign: TextAlign.center),
        const SizedBox(height: Night.space2),
        Text(title, style: const TextStyle(color: Night.ink, fontSize: 22, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        const SizedBox(height: Night.space4),
        if (latest != null) ...[
          NightButton(tr.wgNavigate, icon: Icons.directions, onPressed: () {
            Navigator.pop(ctx, false);
            launchUrl(
              Platform.isIOS ? Uri.parse('http://maps.apple.com/?daddr=${latest.lat},${latest.lng}&dirflg=w') : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${latest.lat},${latest.lng}&travelmode=walking'),
              mode: LaunchMode.externalApplication,
            );
          }),
          const SizedBox(height: Night.space2),
        ],
        NightButton(tr.wgViewList, kind: NightButtonKind.ghost, icon: Icons.list_alt, onPressed: () => Navigator.pop(ctx, true)),
      ])),
    ),
  );
  if (open == true && context.mounted) showWhisperGroupPanel(context);
}
