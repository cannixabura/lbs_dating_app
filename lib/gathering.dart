import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'gathering_keys.dart';
import 'report_sheet.dart';
import 'hidden_content.dart';
import 'ui/night.dart';

/// 集會：任何人都能以自己的位置為中心，開一場 5 公里內的活動，用一個表情符號識別。
/// 把這個符號放進城市稱呼、人又在範圍內，就是參加者：看得到置頂公告、收得到推播、可以回答提問。
/// 伺服器：geo-service/index.js 的 gathering 端點；資料在 RTDB 的 gatherings/。

const _gatheringUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/gathering';
const gatheringRadiusKm = 5.0;
const _maxDuration = Duration(hours: 24);

class Gathering {
  final String id;
  final String name;
  final String emoji;
  final String emojiKey;
  final DateTime startAt;
  final DateTime endAt;
  final String hostUid;
  final double lat;
  final double lng;
  final String? latestId;
  final String? latestText;
  final DateTime? latestAt;
  final String? questionId;
  final String? questionText;
  final DateTime? handoffAt; // 公開交棒的時間（安靜交棒不記）
  final String? pendingHandoffTo; // 等待對方回覆中的交棒對象
  final DateTime? pendingHandoffUntil;

  Gathering.fromMap(this.id, Map m)
      : name = (m['name'] ?? '').toString(),
        emoji = (m['emoji'] ?? '').toString(),
        emojiKey = (m['emojiKey'] ?? '').toString(),
        startAt = DateTime.fromMillisecondsSinceEpoch(((m['startAt'] ?? 0) as num).toInt()),
        endAt = DateTime.fromMillisecondsSinceEpoch(((m['endAt'] ?? 0) as num).toInt()),
        hostUid = (m['hostUid'] ?? '').toString(),
        lat = ((m['lat'] ?? 0) as num).toDouble(),
        lng = ((m['lng'] ?? 0) as num).toDouble(),
        latestId = (m['latest'] as Map?)?['id']?.toString(),
        latestText = (m['latest'] as Map?)?['text']?.toString(),
        latestAt = (m['latest'] as Map?)?['at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(((m['latest'] as Map)['at'] as num).toInt()),
        questionId = (m['question'] as Map?)?['id']?.toString(),
        questionText = (m['question'] as Map?)?['text']?.toString(),
        handoffAt = m['handoffAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch((m['handoffAt'] as num).toInt()),
        pendingHandoffTo = (m['pendingHandoff'] as Map?)?['toName']?.toString(),
        pendingHandoffUntil = (m['pendingHandoff'] as Map?)?['expiresAt'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(((m['pendingHandoff'] as Map)['expiresAt'] as num).toInt());

  /// 等待對方回覆中（還沒過期）
  bool get handoffPending => pendingHandoffUntil != null && pendingHandoffUntil!.isAfter(DateTime.now());

  double distanceKmFrom(double fromLat, double fromLng) {
    const r = 6371.0;
    final dLat = (lat - fromLat) * pi / 180;
    final dLng = (lng - fromLng) * pi / 180;
    final s = pow(sin(dLat / 2), 2) + cos(fromLat * pi / 180) * cos(lat * pi / 180) * pow(sin(dLng / 2), 2);
    return 2 * r * asin(sqrt(s));
  }

  /// 我是不是參加者：稱呼裡有圖標、人在 5 公里內
  bool includes(String nickname, double myLat, double myLng) =>
      emojiKeysIn(nickname).contains(emojiKey) && distanceKmFrom(myLat, myLng) <= gatheringRadiusKm;
}

class GatheringApi {
  GatheringApi._();

  /// 回傳 (資料, 錯誤訊息)
  static Future<(Map<String, dynamic>?, String?)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_gatheringUrl),
        headers: {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) return (data, null);
      return (null, (data['error'] as String?) ?? '活動功能暫時無法使用，請稍後再試。');
    } catch (_) {
      return (null, '沒有送出，請檢查網路後再試一次。');
    }
  }

  static Future<String?> create({required String name, required String emoji, required DateTime startAt, required DateTime endAt, required double lat, required double lng}) async {
    final (_, error) = await _call({
      'action': 'create', 'name': name, 'emoji': emoji, 'lat': lat, 'lng': lng,
      'startAt': startAt.millisecondsSinceEpoch, 'endAt': endAt.millisecondsSinceEpoch,
    });
    return error;
  }

  static Future<String?> end(String gid) async => (await _call({'action': 'end', 'gid': gid})).$2;
  static Future<String?> announce(String gid, String text) async => (await _call({'action': 'announce', 'gid': gid, 'text': text})).$2;
  static Future<String?> ask(String gid, String text) async => (await _call({'action': 'ask', 'gid': gid, 'text': text})).$2;
  static Future<String?> answer(String gid, String qid, String text) async => (await _call({'action': 'answer', 'gid': gid, 'qid': qid, 'text': text})).$2;
  static Future<String?> handoff(String gid, String toUid, {required bool quiet}) async => (await _call({'action': 'handoff', 'gid': gid, 'toUid': toUid, 'quiet': quiet})).$2;
  static Future<String?> cancelHandoff(String gid) async => (await _call({'action': 'cancel-handoff', 'gid': gid})).$2;
  static Future<String?> acceptHandoff() async => (await _call({'action': 'accept-handoff'})).$2;
  static Future<String?> declineHandoff() async => (await _call({'action': 'decline-handoff'})).$2;
}

/// 所有進行中的活動（數量不多，直接整份監聽）
Stream<List<Gathering>> activeGatherings() => FirebaseDatabase.instance
    .ref('gatherings')
    .orderByChild('status')
    .equalTo('active')
    .onValue
    .map((e) {
      final raw = e.snapshot.value;
      if (raw is! Map) return <Gathering>[];
      return raw.entries.map((en) => Gathering.fromMap(en.key.toString(), en.value as Map)).toList();
    });

String _hm(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
String _timeRange(Gathering g) {
  final sameDay = g.startAt.day == g.endAt.day;
  return '${_hm(g.startAt)} – ${sameDay ? '' : '隔天 '}${_hm(g.endAt)}';
}

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return '剛剛';
  if (d.inHours < 1) return '${d.inMinutes} 分鐘前';
  return '${d.inHours} 小時前';
}

InputDecoration _nightInput(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Night.inkFaint, fontSize: 14),
      counterStyle: Night.caption,
      filled: true,
      fillColor: Night.night700,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.glassLine)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.auroraViolet, width: 2)),
    );

// ============================================================================
// 主持人：開活動 / 管理進行中的活動
// ============================================================================

/// 設定 › 集會主持人。hosting 是自己正在主持的活動（沒有就是開新活動）。
Future<void> showGatheringHostSheet(BuildContext context, {required Gathering? hosting, required double lat, required double lng}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true, // 面板比螢幕高時，關閉鈕不能被狀態列蓋住
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: Stack(children: [
            GlassCard(
              padding: const EdgeInsets.fromLTRB(Night.space6, Night.space4, Night.space6, Night.space6),
              child: hosting == null ? _CreateGatheringForm(lat: lat, lng: lng) : _HostPanel(gathering: hosting),
            ),
            // 面板比螢幕還高時點不到外面，右上角一定要有關閉鈕
            Positioned(
              top: Night.space1, right: Night.space1,
              child: Builder(builder: (sheetContext) => IconButton(
                tooltip: '關閉',
                icon: const Icon(Icons.close, color: Night.inkMuted),
                onPressed: () => Navigator.pop(sheetContext),
              )),
            ),
          ]),
        ),
      ),
    ),
  );
}

class _CreateGatheringForm extends StatefulWidget {
  final double lat;
  final double lng;
  const _CreateGatheringForm({required this.lat, required this.lng});
  @override
  State<_CreateGatheringForm> createState() => _CreateGatheringFormState();
}

class _CreateGatheringFormState extends State<_CreateGatheringForm> {
  final _name = TextEditingController();
  final _emoji = TextEditingController();
  late DateTime _start = DateTime.now();
  late DateTime _end = _start.add(const Duration(hours: 3));
  bool _busy = false;
  String? _error;

  @override
  void dispose() { _name.dispose(); _emoji.dispose(); super.dispose(); }

  Future<void> _pick(bool isStart) async {
    final now = DateTime.now();
    final min = isStart ? now.subtract(const Duration(minutes: 1)) : _start.add(const Duration(minutes: 15));
    final max = isStart ? now.add(_maxDuration) : _start.add(_maxDuration);
    DateTime value = isStart ? _start : _end;
    if (value.isBefore(min)) value = min;
    if (value.isAfter(max)) value = max;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Night.night800,
      builder: (_) => SizedBox(
        height: 260,
        child: CupertinoTheme(
          data: const CupertinoThemeData(brightness: Brightness.dark, textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: TextStyle(color: Night.ink, fontSize: 20))),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            minimumDate: min,
            maximumDate: max,
            initialDateTime: value,
            minuteInterval: 1,
            onDateTimeChanged: (v) => setState(() {
              if (isStart) {
                final length = _end.difference(_start);
                _start = v;
                _end = v.add(length > _maxDuration ? _maxDuration : length);
              } else {
                _end = v;
              }
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final emoji = singleEmoji(_emoji.text);
    if (_name.text.trim().isEmpty) return setState(() => _error = '請幫活動取個名字。');
    if (emoji == null) return setState(() => _error = '活動圖標要剛好是一個表情符號。');
    setState(() { _busy = true; _error = null; });
    final error = await GatheringApi.create(name: _name.text.trim(), emoji: emoji, startAt: _start, endAt: _end, lat: widget.lat, lng: widget.lng);
    if (!mounted) return;
    if (error != null) return setState(() { _busy = false; _error = error; });
    Navigator.of(context).pop();
    showGlassToast(context, '$emoji ${_name.text.trim()} 開始了。請參加的人把 $emoji 加進城市稱呼。', icon: Icons.campaign_outlined);
  }

  @override
  Widget build(BuildContext context) {
    final emoji = singleEmoji(_emoji.text);
    Widget timeRow(String label, DateTime t, bool isStart) => InkWell(
          onTap: _busy ? null : () => _pick(isStart),
          borderRadius: BorderRadius.circular(Night.radiusSm),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: 10),
            decoration: BoxDecoration(color: Night.night700, borderRadius: BorderRadius.circular(Night.radiusSm), border: Border.all(color: Night.glassLine)),
            child: Row(children: [
              Text(label, style: Night.caption),
              const Spacer(),
              Text('${t.month}/${t.day} ${_hm(t)}', style: const TextStyle(color: Night.ink, fontSize: 15, fontFeatures: [FontFeature.tabularFigures()])),
            ]),
          ),
        );
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Icon(Icons.campaign_outlined, color: Night.auroraViolet, size: 32),
        const SizedBox(height: Night.space2),
        const Text('開一場集會', style: Night.title, textAlign: TextAlign.center),
        const SizedBox(height: Night.space2),
        const Text('以你的位置為中心 5 公里。你走到哪，範圍就跟到哪。', style: Night.body, textAlign: TextAlign.center),
        const SizedBox(height: Night.space6),
        TextField(controller: _name, maxLength: 20, style: const TextStyle(color: Night.ink, fontSize: 15), cursorColor: Night.auroraViolet, decoration: _nightInput('活動名稱，例如：台北101跨年煙火秀')),
        const SizedBox(height: Night.space2),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 96,
            child: TextField(
              controller: _emoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26),
              cursorColor: Night.auroraViolet,
              onChanged: (_) => setState(() {}),
              decoration: _nightInput('圖標'), // 不放預設圖標，避免大家都用同一個
            ),
          ),
          const SizedBox(width: Night.space3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                emoji == null
                    ? '活動圖標：一個表情符號。附近沒人在用才能選。'
                    : '參加的人把 $emoji 加進自己的城市稱呼，就會看到你的公告、收到推播。',
                style: Night.caption.copyWith(color: Night.inkMuted, height: 1.5),
              ),
            ),
          ),
        ]),
        const SizedBox(height: Night.space4),
        timeRow('開始', _start, true),
        const SizedBox(height: Night.space2),
        timeRow('結束', _end, false),
        const SizedBox(height: Night.space1),
        const Text('整場最長 24 小時，時間到自動結束。', style: Night.caption),
        if (_error != null) ...[
          const SizedBox(height: Night.space3),
          Text(_error!, style: const TextStyle(color: Night.danger, fontSize: 13)),
        ],
        const SizedBox(height: Night.space6),
        NightButton(_busy ? '開始中…' : '開始活動', onPressed: _busy ? null : _submit, expand: true),
      ]),
    );
  }
}

class _HostPanel extends StatefulWidget {
  final Gathering gathering;
  const _HostPanel({required this.gathering});
  @override
  State<_HostPanel> createState() => _HostPanelState();
}

class _HostPanelState extends State<_HostPanel> {
  final _announcement = TextEditingController();
  final _question = TextEditingController();
  bool _busy = false;
  bool _confirmEnd = false;
  String? _error;
  late final Stream<DatabaseEvent> _tally = FirebaseDatabase.instance.ref('gatheringTally/${widget.gathering.id}').onValue;
  late final Stream<DatabaseEvent> _recent = FirebaseDatabase.instance.ref('gatheringAnnouncements/${widget.gathering.id}').orderByChild('at').limitToLast(3).onValue;
  late final Stream<DatabaseEvent> _live = FirebaseDatabase.instance.ref('gatherings/${widget.gathering.id}/question').onValue;

  @override
  void dispose() { _announcement.dispose(); _question.dispose(); super.dispose(); }

  Future<void> _run(Future<String?> Function() call, {TextEditingController? clear, String? done}) async {
    setState(() { _busy = true; _error = null; });
    final error = await call();
    if (!mounted) return;
    setState(() { _busy = false; _error = error; });
    if (error == null) {
      clear?.clear();
      if (done != null) showGlassToast(context, done, icon: Icons.campaign_outlined);
    }
  }

  Future<void> _end() async {
    if (!_confirmEnd) return setState(() => _confirmEnd = true);
    final g = widget.gathering;
    setState(() { _busy = true; _error = null; });
    final error = await GatheringApi.end(g.id);
    if (!mounted) return;
    if (error != null) return setState(() { _busy = false; _error = error; });
    Navigator.of(context).pop();
    showGlassToast(context, '${g.emoji} ${g.name} 已結束，你回到了城市裡。', icon: Icons.nights_stay_outlined);
  }

  Widget _section(String text) => Padding(
        padding: const EdgeInsets.only(top: Night.space6, bottom: Night.space2),
        child: Text(text, style: Night.caption.copyWith(color: Night.inkMuted)),
      );

  @override
  Widget build(BuildContext context) {
    final g = widget.gathering;
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(g.emoji, style: const TextStyle(fontSize: 40), textAlign: TextAlign.center),
        const SizedBox(height: Night.space1),
        Text(g.name, style: Night.title, textAlign: TextAlign.center),
        const SizedBox(height: Night.space1),
        Text('${_timeRange(g)} · 你正在主持', style: Night.caption, textAlign: TextAlign.center),
        const SizedBox(height: Night.space2),
        Text('5 公里內、稱呼裡有 ${g.emoji} 的人會看到公告並收到推播。你看不到他們是誰。', style: Night.body.copyWith(fontSize: 13), textAlign: TextAlign.center),

        _section('發布公告'),
        TextField(controller: _announcement, maxLength: 200, minLines: 2, maxLines: 4, style: const TextStyle(color: Night.ink, fontSize: 15), cursorColor: Night.auroraViolet, decoration: _nightInput('例如：隊伍在忠孝東路口集合')),
        NightButton('發布公告', onPressed: _busy ? null : () => _run(() => GatheringApi.announce(g.id, _announcement.text.trim()), clear: _announcement, done: '公告已送出'), expand: true),
        StreamBuilder<DatabaseEvent>(
          stream: _recent,
          builder: (context, snap) {
            final raw = snap.data?.snapshot.value;
            if (raw is! Map || raw.isEmpty) return const SizedBox.shrink();
            final items = raw.values.cast<Map>().toList()..sort((a, b) => (b['at'] as num).compareTo(a['at'] as num));
            return Padding(
              padding: const EdgeInsets.only(top: Night.space3),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (final a in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Night.space2),
                    child: Text(
                      '${_ago(DateTime.fromMillisecondsSinceEpoch((a['at'] as num).toInt()))}　${a['text']}${a['hidden'] == true ? '（已因多人檢舉隱藏）' : ''}',
                      style: Night.caption.copyWith(color: a['hidden'] == true ? Night.danger : Night.inkMuted, height: 1.5),
                    ),
                  ),
              ]),
            );
          },
        ),

        _section('全場提問'),
        TextField(controller: _question, maxLength: 40, style: const TextStyle(color: Night.ink, fontSize: 15), cursorColor: Night.auroraViolet, decoration: _nightInput('例如：此刻的你？')),
        NightButton('送出提問', kind: NightButtonKind.ghost, onPressed: _busy ? null : () => _run(() => GatheringApi.ask(g.id, _question.text.trim()), clear: _question, done: '提問已送出，大家會用心情回答'), expand: true),
        StreamBuilder<DatabaseEvent>(
          stream: _live,
          builder: (context, qSnap) {
            final q = qSnap.data?.snapshot.value;
            if (q is! Map) return const SizedBox.shrink();
            return StreamBuilder<DatabaseEvent>(
              stream: _tally,
              builder: (context, snap) => Padding(
                padding: const EdgeInsets.only(top: Night.space4),
                child: _TallyView(question: q['text'].toString(), tally: snap.data?.snapshot.value),
              ),
            );
          },
        ),

        _section('交棒'),
        if (g.handoffPending)
          Row(children: [
            Expanded(child: Text('已邀請 ${g.pendingHandoffTo?.isNotEmpty == true ? g.pendingHandoffTo : '對方'} 接下主持，等待回覆中…', style: Night.body.copyWith(fontSize: 14))),
            NightButton('取消', kind: NightButtonKind.text, onPressed: _busy ? null : () => _run(() => GatheringApi.cancelHandoff(g.id), done: '已取消交棒邀請')),
          ])
        else
          Text('長按雷達上參加者的氣泡 →「轉移主持人」，對方同意後就由他主持，活動與公告都不會中斷。', style: Night.caption.copyWith(color: Night.inkMuted, height: 1.5)),
        if (_error != null) ...[
          const SizedBox(height: Night.space4),
          Text(_error!, style: const TextStyle(color: Night.danger, fontSize: 13)),
        ],
        const SizedBox(height: Night.space6),
        NightButton(_confirmEnd ? '確定結束？再按一次' : '結束活動', kind: NightButtonKind.danger, onPressed: _busy ? null : _end, expand: true),
      ]),
    );
  }
}

/// 全場提問的比例：只有比例，少於 10 人不顯示
class _TallyView extends StatelessWidget {
  final String question;
  final Object? tally;
  const _TallyView({required this.question, required this.tally});

  static const _colors = {
    'joy': Night.moodJoy, 'sad': Night.moodSad, 'angry': Night.moodAngry, 'calm': Night.moodCalm,
    'passion': Night.moodPassion, 'love': Night.moodLove, 'other': Night.moodDefault,
  };

  @override
  Widget build(BuildContext context) {
    final t = tally is Map ? tally as Map : const {};
    final total = (t['total'] as num?)?.toInt() ?? 0;
    final moods = (t['moods'] as List?) ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('「$question」· $total 人回答', style: const TextStyle(color: Night.ink, fontSize: 14)),
      const SizedBox(height: Night.space2),
      if (t['quiet'] != false || moods.isEmpty)
        const Text('滿 10 人回答才顯示比例，避免人少時猜得出是誰。', style: Night.caption)
      else
        for (final m in moods.cast<Map>())
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              SizedBox(width: 40, child: Text('${m['label']}', style: const TextStyle(color: Night.inkMuted, fontSize: 13))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ((m['percent'] as num?) ?? 0) / 100,
                    minHeight: 8,
                    backgroundColor: Night.night700,
                    valueColor: AlwaysStoppedAnimation(_colors[m['key']] ?? Night.moodDefault),
                  ),
                ),
              ),
              SizedBox(width: 44, child: Text('${m['percent']}%', textAlign: TextAlign.right, style: const TextStyle(color: Night.ink, fontSize: 13, fontFeatures: [FontFeature.tabularFigures()]))),
            ]),
          ),
    ]);
  }
}

// ============================================================================
// 雷達頂端的置頂公告（參加者與主持人都看得到）
// ============================================================================

class GatheringBanner extends StatefulWidget {
  final Gathering gathering;
  final String myUid;
  final bool isHost;
  final VoidCallback onManage;
  const GatheringBanner({super.key, required this.gathering, required this.myUid, required this.isHost, required this.onManage});
  @override
  State<GatheringBanner> createState() => _GatheringBannerState();
}

class _GatheringBannerState extends State<GatheringBanner> {
  bool _collapsed = false;
  final _answer = TextEditingController();

  void _refresh() { if (mounted) setState(() {}); }
  bool _busy = false;
  String? _answeredQid; // 這次開啟期間已回答的問題
  StreamSubscription<DatabaseEvent>? _answeredSub;

  @override
  void initState() { super.initState(); _watchAnswered(); HiddenContent.instance.addListener(_refresh); }

  @override
  void didUpdateWidget(GatheringBanner old) {
    super.didUpdateWidget(old);
    if (old.gathering.questionId != widget.gathering.questionId) _watchAnswered();
    // 有新公告或新問題就自動展開
    if (old.gathering.latestAt != widget.gathering.latestAt || old.gathering.questionId != widget.gathering.questionId) _collapsed = false;
  }

  void _watchAnswered() {
    _answeredSub?.cancel();
    final qid = widget.gathering.questionId;
    if (qid == null || widget.isHost) return;
    _answeredSub = FirebaseDatabase.instance.ref('gatheringAnswers/${widget.gathering.id}/$qid/${widget.myUid}').onValue.listen((e) {
      if (mounted && e.snapshot.exists) setState(() => _answeredQid = qid);
    });
  }

  @override
  void dispose() { HiddenContent.instance.removeListener(_refresh); _answeredSub?.cancel(); _answer.dispose(); super.dispose(); }

  Future<void> _send() async {
    final g = widget.gathering;
    final text = _answer.text.trim();
    if (text.isEmpty || g.questionId == null) return;
    setState(() => _busy = true);
    final error = await GatheringApi.answer(g.id, g.questionId!, text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      showGlassToast(context, error, icon: Icons.error_outline, danger: true);
    } else {
      _answer.clear();
      FocusScope.of(context).unfocus();
      setState(() => _answeredQid = g.questionId);
    }
  }

  /// 檢舉針對目前置頂的那則公告（沒有公告時檢舉整場，只進人工審查）
  void _report() {
    final g = widget.gathering;
    final target = g.latestId == null ? 'gathering:${g.id}' : 'gathering:${g.id}:${g.latestId}';
    showReportSheet(context, myUid: widget.myUid, targetUid: target, targetName: '${g.emoji} ${g.name}', reportContext: ReportContext.gathering, allowBlock: false);
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.gathering;
    final header = Row(children: [
      Text(g.emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: Night.space2),
      Expanded(
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: g.name, style: const TextStyle(color: Night.ink, fontSize: 14, fontWeight: FontWeight.w600)),
            TextSpan(text: widget.isHost ? '  · 你正在主持' : '  · 主持人公告', style: Night.caption),
          ]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      if (widget.isHost)
        _iconButton(Icons.tune, '管理活動', widget.onManage)
      else
        _iconButton(Icons.flag_outlined, '檢舉這則公告', _report, color: Night.danger),
      _iconButton(_collapsed ? Icons.expand_more : Icons.expand_less, _collapsed ? '展開公告' : '收起公告', () => setState(() => _collapsed = !_collapsed)),
    ]);

    if (_collapsed) {
      return GestureDetector(
        onTap: () => setState(() => _collapsed = false),
        child: _glass(child: header, padding: const EdgeInsets.fromLTRB(Night.space3, 2, Night.space1, 2)),
      );
    }

    final hasQuestion = g.questionId != null && g.questionText != null;
    final answered = _answeredQid != null && _answeredQid == g.questionId;
    return _glass(
      padding: const EdgeInsets.fromLTRB(Night.space4, 4, Night.space1, Night.space3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        header,
        Padding(
          padding: const EdgeInsets.only(right: Night.space3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
            if (g.handoffAt != null && DateTime.now().difference(g.handoffAt!) < const Duration(minutes: 30)) ...[
              Text('主持人已交棒 · ${_ago(g.handoffAt!)}', style: Night.caption.copyWith(color: Night.auroraBlue)),
              const SizedBox(height: 4),
            ],
            if (g.latestText != null) ...[
              HiddenContent.instance.isAnnouncementHidden(g.id, g.latestId)
                  ? const Text('你檢舉了這則公告，已從你的畫面移除。', style: Night.caption)
                  : Text(g.latestText!, style: const TextStyle(color: Night.ink, fontSize: 15, height: 1.5), maxLines: 4, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(g.latestAt == null ? '' : _ago(g.latestAt!), style: Night.caption),
            ] else
              Text(widget.isHost ? '還沒有公告。按右上角的調整鈕發布第一則。' : '主持人還沒有發公告。', style: Night.caption),
            if (hasQuestion && !widget.isHost) ...[
              const SizedBox(height: Night.space3),
              Text('主持人問：${g.questionText}', style: const TextStyle(color: Night.auroraBlue, fontSize: 14)),
              const SizedBox(height: Night.space2),
              if (answered)
                const Text('已回答。主持人只會看到全場的心情比例。', style: Night.caption)
              else
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _answer,
                      maxLength: 20,
                      style: const TextStyle(color: Night.ink, fontSize: 14),
                      cursorColor: Night.auroraViolet,
                      decoration: _nightInput('用一句心情回答').copyWith(counterText: ''),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: Night.space2),
                  _iconButton(Icons.send_rounded, '送出回答', _busy ? null : _send, color: Night.auroraViolet),
                ]),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback? onTap, {Color color = Night.inkMuted}) => Semantics(
        button: true,
        label: label,
        child: InkResponse(
          onTap: onTap,
          radius: 22,
          child: SizedBox(width: 44, height: 44, child: Icon(icon, size: 20, color: color)),
        ),
      );

  Widget _glass({required Widget child, required EdgeInsets padding}) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Night.glassFill,
          borderRadius: BorderRadius.circular(Night.radiusLg),
          border: Border.all(color: Night.glassLine),
          boxShadow: const [Night.lift],
        ),
        child: child,
      );
}


// ============================================================================
// 交棒：主持人把活動交給現場的另一位參加者
// ============================================================================

/// 主持人長按參加者的氣泡 →「轉移主持人」：選公開或安靜交棒，送出邀請
Future<void> showHandoffDialog(BuildContext context, {required Gathering gathering, required String toUid, required String toName}) {
  return showDialog(
    context: context,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(child: _HandoffForm(gathering: gathering, toUid: toUid, toName: toName)),
    ),
  );
}

class _HandoffForm extends StatefulWidget {
  final Gathering gathering;
  final String toUid;
  final String toName;
  const _HandoffForm({required this.gathering, required this.toUid, required this.toName});
  @override
  State<_HandoffForm> createState() => _HandoffFormState();
}

class _HandoffFormState extends State<_HandoffForm> {
  bool _quiet = false;
  bool _busy = false;
  String? _error;

  Future<void> _send() async {
    setState(() { _busy = true; _error = null; });
    final error = await GatheringApi.handoff(widget.gathering.id, widget.toUid, quiet: _quiet);
    if (!mounted) return;
    if (error != null) return setState(() { _busy = false; _error = error; });
    Navigator.of(context).pop();
    showGlassToast(context, '已邀請 ${widget.toName} 接下主持，等對方回覆（5 分鐘內有效）。', icon: Icons.campaign_outlined);
  }

  Widget _option(bool quiet, String title, String subtitle) => InkWell(
        onTap: _busy ? null : () => setState(() => _quiet = quiet),
        borderRadius: BorderRadius.circular(Night.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(Night.space3),
          decoration: BoxDecoration(
            color: Night.night700,
            borderRadius: BorderRadius.circular(Night.radiusSm),
            border: Border.all(color: _quiet == quiet ? Night.auroraViolet : Night.glassLine, width: _quiet == quiet ? 2 : 1),
          ),
          child: Row(children: [
            Icon(_quiet == quiet ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _quiet == quiet ? Night.auroraViolet : Night.inkFaint, size: 20),
            const SizedBox(width: Night.space3),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: Night.caption.copyWith(color: Night.inkMuted, height: 1.5)),
              ]),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final g = widget.gathering;
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(g.emoji, style: const TextStyle(fontSize: 32), textAlign: TextAlign.center),
      const SizedBox(height: Night.space2),
      Text('把活動交給 ${widget.toName}', style: Night.title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      const SizedBox(height: Night.space2),
      const Text('對方同意後，由他主持這場活動；名稱、公告與提問都會留著。你會變回參加者。', style: Night.body, textAlign: TextAlign.center),
      const SizedBox(height: Night.space4),
      _option(false, '公開交棒', '通知所有參加者「主持人已交棒」'),
      const SizedBox(height: Night.space2),
      _option(true, '安靜交棒', '不通知任何人，只有雷達上的「主持」光環換人'),
      if (_error != null) ...[
        const SizedBox(height: Night.space3),
        Text(_error!, style: const TextStyle(color: Night.danger, fontSize: 13), textAlign: TextAlign.center),
      ],
      const SizedBox(height: Night.space4),
      Row(children: [
        Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: _busy ? null : () => Navigator.of(context).pop())),
        const SizedBox(width: Night.space2),
        Expanded(child: NightButton(_busy ? '送出中…' : '送出邀請', onPressed: _busy ? null : _send)),
      ]),
    ]);
  }
}

/// 被邀請接下主持：同意或婉拒
Future<void> showHandoffOffer(BuildContext context, Map offer) {
  final emoji = (offer['emoji'] ?? '').toString();
  final name = (offer['name'] ?? '').toString();
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color(0x99070B1F),
    builder: (dialogContext) {
      var busy = false;
      return StatefulBuilder(builder: (context, setState) {
        Future<void> reply(bool accept) async {
          setState(() => busy = true);
          final error = accept ? await GatheringApi.acceptHandoff() : await GatheringApi.declineHandoff();
          if (!dialogContext.mounted) return;
          Navigator.of(dialogContext).pop();
          if (error != null) {
            showGlassToast(context, error, icon: Icons.error_outline, danger: true);
          } else if (accept) {
            showGlassToast(context, '你現在是 $emoji $name 的主持人。', icon: Icons.campaign_outlined);
          }
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(Night.space6),
          child: GlassCard(
            glow: true,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(emoji, style: const TextStyle(fontSize: 36), textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              const Text('想請你接下主持', style: Night.title, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              Text('主持人想把「$name」交給你。接下後，你可以發公告、提問與結束活動，也要對公告內容負責。', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton('婉拒', kind: NightButtonKind.ghost, onPressed: busy ? null : () => reply(false))),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton(busy ? '處理中…' : '接下主持', onPressed: busy ? null : () => reply(true))),
              ]),
            ]),
          ),
        );
      });
    },
  );
}
