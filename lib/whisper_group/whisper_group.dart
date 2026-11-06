import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

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
        help = ((j['rollRoster'] as Map?)?['help'] as num?)?.toInt() ?? 0;
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
              style: const TextStyle(color: Night.ink, fontSize: 22, letterSpacing: 4), textAlign: TextAlign.center,
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
        if (!g.paid && g.count >= g.limit - 2) ...[
          _PassCard(g: g),
          const SizedBox(height: Night.space3),
        ],
        Wrap(alignment: WrapAlignment.center, spacing: 4, children: [
          TextButton.icon(onPressed: () => _showQr(context, g), icon: const Icon(Icons.qr_code_2, size: 18), label: Text(tr.wgQrButton), style: TextButton.styleFrom(foregroundColor: Night.ink)),
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

/// 震動「短 短 長」：集合與點名共用
Future<void> wgBuzz() async {
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
              SelectableText(cur?.code ?? g.code, style: const TextStyle(color: Night.ink, fontSize: 22, letterSpacing: 4)),
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
