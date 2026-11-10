import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'l10n/l10n.dart';
import 'quantum_assembly.dart';
import 'quantum_world.dart';
import 'report_sheet.dart';
import 'ui/night.dart';

// ============================================================================
// 量子集會 Q2：語音直播（自架 LiveKit）與文字提問。規格：docs/quantum-assembly-spec.md「Q2」
// - 加入 Q2 集會（或主持中）就自動連進直播房間收聽；離開集會、離開量子世界就斷線。
// - 主持人一直可以講話；參加者舉手、主持人同意後上台（最多 3 人）。聽眾不需要麥克風權限。
// - 不錄音：App 和伺服器都不保存聲音。
// ============================================================================

/// 本機測試用：flutter run --dart-define=ASM_LIVE_TEST=ws://<Mac IP>:7880 --dart-define=ASM_LIVE_TOKEN=<lk token create 產生>
/// App 直接打開直播測試畫面，不經過正式伺服器；上架版本不會帶
const liveTestUrl = String.fromEnvironment('ASM_LIVE_TEST');
const liveTestToken = String.fromEnvironment('ASM_LIVE_TOKEN');

/// 直播測試畫面（只在 ASM_LIVE_TEST 有值時使用）
class AssemblyLiveTestScreen extends StatefulWidget {
  const AssemblyLiveTestScreen({super.key});
  @override
  State<AssemblyLiveTestScreen> createState() => _AssemblyLiveTestScreenState();
}

class _AssemblyLiveTestScreenState extends State<AssemblyLiveTestScreen> {
  static const _a = QAssembly(id: 'test', title: '量子音樂會', emoji: '🎵', plan: 'q2_1h', tier: 'q2', host: '測試主持人', code: 'Q2-1',
      status: 'active', color: Color(0xFF7FD8FF), lat: 25.0336, lng: 121.5648, startAt: 0, endAt: 0, cap: 200, count: 1);

  @override
  void initState() {
    super.initState();
    AssemblyState.active.value = {'test': _a};
    AssemblyLive.connect('test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Night.night900,
      body: SafeArea(
        child: Stack(children: [
          ListView(padding: const EdgeInsets.all(Night.space4), children: [
            Text('${_a.emoji} ${_a.title}', style: const TextStyle(color: Night.ink, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: Night.space3),
            const AssemblyLivePanel(a: _a, isHost: true),
          ]),
          Positioned(left: Night.space4, right: Night.space4, bottom: 24, child: AssemblyLiveBar(onOpen: (_) {})),
        ]),
      ),
    );
  }
}

class AssemblyLive {
  static final state = ValueNotifier<LiveState>(const LiveState());
  static Room? _room;
  static EventsListener<RoomEvent>? _events;
  static String? _id; // 連線中的集會
  static bool _connecting = false;
  static bool _hooked = false;

  /// 跟著「加入中／主持中的集會」自動連線或斷線（量子世界入場時呼叫一次）
  static void hook() {
    if (_hooked) return;
    _hooked = true;
    AssemblyState.myAsm.addListener(_sync);
    AssemblyState.hostAsm.addListener(_sync);
    AssemblyState.active.addListener(_sync);
  }

  /// 目前應該連線的 Q2 集會（主持中優先）
  static String? get _wanted {
    for (final id in [AssemblyState.hostAsm.value, AssemblyState.myAsm.value]) {
      final a = id == null ? null : AssemblyState.active.value[id];
      if (a != null && a.active && a.isQ2) return id;
    }
    return null;
  }

  static void _sync() {
    final want = _wanted;
    if (want == _id) return;
    if (_id != null) disconnect();
    if (want != null) connect(want);
  }

  static Future<void> connect(String id) async {
    if (_connecting) return;
    _connecting = true;
    _id = id;
    state.value = LiveState(id: id, connecting: true);
    try {
      final (status, data) = liveTestUrl.isNotEmpty
          ? (200, {'success': true, 'url': liveTestUrl, 'token': liveTestToken, 'identity': 'test', 'canPublish': true})
          : await QuantumApi.assembly('asmAudio', {'id': id});
      if (status != 200 || data['success'] != true || _id != id) {
        if (_id == id) state.value = LiveState(id: id, error: data['code'] as String? ?? 'error');
        return;
      }
      final room = Room(roomOptions: const RoomOptions(
        adaptiveStream: false,
        dynacast: false,
        // 講話用一般音質；主持人切到音樂模式時另外用高音質重新發聲
        defaultAudioPublishOptions: AudioPublishOptions(encoding: AudioEncoding.presetSpeech, dtx: true),
      ));
      _room = room;
      _events = room.createListener()
        ..on<ParticipantPermissionsUpdatedEvent>((e) {
          if (e.participant is LocalParticipant) _onPermission(e.permissions.canPublish);
        })
        ..on<ActiveSpeakersChangedEvent>((e) => _update(talking: {for (final p in e.speakers) p.identity}))
        ..on<RoomDisconnectedEvent>((_) {
          if (_id == id) state.value = state.value.copy(connected: false);
        })
        ..on<RoomReconnectedEvent>((_) => _update(connected: true))
        ..on<TrackSubscribedEvent>((e) {
          // 自己按了「靜音直播」：新上台的人也一起靜音
          if (state.value.listenMuted) e.publication.disable();
        });
      await room.connect('${data['url']}', '${data['token']}');
      if (_id != id) { await room.disconnect(); return; }
      try {
        await Hardware.instance.setSpeakerphoneOn(true); // 收聽用喇叭，不是聽筒
      } catch (_) {}
      state.value = LiveState(id: id, connected: true, identity: '${data['identity']}', canPublish: data['canPublish'] == true,
          isHost: AssemblyState.hostAsm.value == id || liveTestUrl.isNotEmpty);
    } catch (e) {
      if (_id == id) state.value = LiveState(id: id, error: 'connect');
    } finally {
      _connecting = false;
      // 連線期間集會換了：重新對齊
      if (liveTestUrl.isEmpty && _wanted != _id) _sync();
    }
  }

  static Future<void> disconnect() async {
    final room = _room;
    _room = null;
    _id = null;
    await _events?.dispose();
    _events = null;
    state.value = const LiveState();
    try {
      await room?.disconnect();
      await room?.dispose();
    } catch (_) {}
  }

  static void _update({bool? connected, Set<String>? talking}) {
    state.value = state.value.copy(connected: connected, talking: talking);
  }

  /// 主持人同意上台／請下台後，伺服器改了權限
  static void _onPermission(bool canPublish) {
    final s = state.value;
    if (!canPublish && s.micOn) _room?.localParticipant?.setMicrophoneEnabled(false);
    state.value = s.copy(canPublish: canPublish, micOn: canPublish ? s.micOn : false, handUp: canPublish ? false : s.handUp);
    if (canPublish && !s.isHost) AssemblyStore.notice.value = tr.asmLiveOnStage;
  }

  /// 開／關麥克風（第一次會問麥克風權限；不同意就只能收聽）
  static Future<String?> toggleMic() async {
    final room = _room;
    final s = state.value;
    if (room == null || !s.canPublish) return 'not_on_stage';
    // Android 先問權限；iOS 由 WebRTC 開麥克風時系統自己詢問（跟艾婭通話一樣）
    if (!s.micOn && Platform.isAndroid) {
      final perm = await Permission.microphone.request();
      if (!perm.isGranted) return 'mic_denied';
    }
    try {
      await room.localParticipant?.setMicrophoneEnabled(!s.micOn, audioCaptureOptions: _capture(s.musicMode));
      final on = room.localParticipant?.isMicrophoneEnabled() ?? false;
      state.value = state.value.copy(micOn: on);
      // 想開卻沒開成：多半是沒有麥克風權限
      return !s.micOn && !on ? 'mic_denied' : null;
    } catch (_) {
      return s.micOn ? 'error' : 'mic_denied';
    }
  }

  /// 主持人的音樂模式：較高音質，關掉降噪與回音消除（自己演奏或播放自有音樂時用）
  static Future<void> setMusicMode(bool on) async {
    final room = _room;
    final s = state.value;
    state.value = s.copy(musicMode: on);
    if (room == null || !s.micOn) return;
    final lp = room.localParticipant;
    if (lp == null) return;
    // 重新發聲才會換音質與處理方式
    await lp.setMicrophoneEnabled(false);
    for (final pub in [...lp.audioTrackPublications]) {
      await lp.removePublishedTrack(pub.sid);
    }
    final track = await LocalAudioTrack.create(_capture(on));
    await lp.publishAudioTrack(track, publishOptions: AudioPublishOptions(
      encoding: on ? AudioEncoding.presetMusicHighQuality : AudioEncoding.presetSpeech,
      dtx: !on,
      name: AudioPublishOptions.defaultMicrophoneName,
    ));
  }

  static AudioCaptureOptions _capture(bool music) => music
      ? const AudioCaptureOptions(noiseSuppression: false, echoCancellation: false, autoGainControl: false, voiceIsolation: false, typingNoiseDetection: false)
      : const AudioCaptureOptions();

  /// 只影響自己：把整場直播靜音／取消
  static Future<void> setListenMuted(bool muted) async {
    state.value = state.value.copy(listenMuted: muted);
    for (final p in _room?.remoteParticipants.values ?? const <RemoteParticipant>[]) {
      for (final pub in p.audioTrackPublications) {
        muted ? await pub.disable() : await pub.enable();
      }
    }
  }

  /// 舉手／放下
  static Future<String?> setHand(bool up) async {
    final id = _id;
    if (id == null) return 'error';
    final (status, data) = await QuantumApi.assembly('asmHand', {'id': id, 'up': up});
    if (status == 200 && data['success'] == true) {
      state.value = state.value.copy(handUp: up);
      return null;
    }
    return data['code'] as String? ?? 'error';
  }

  /// 主持人：同意上台／請下台／禁音
  static Future<String?> host(String action, String identity, {bool? on}) async {
    final id = _id;
    if (id == null) return 'error';
    final (status, data) = await QuantumApi.assembly(action, {'id': id, 'identity': identity, 'on': ?on});
    return status == 200 && data['success'] == true ? null : (data['code'] as String? ?? 'error');
  }
}

class LiveState {
  final String? id, identity, error;
  final bool connecting, connected, canPublish, micOn, musicMode, listenMuted, handUp, isHost;
  final Set<String> talking; // 正在講話的人（房間身分）
  const LiveState({this.id, this.identity, this.error, this.connecting = false, this.connected = false, this.canPublish = false, this.micOn = false,
      this.musicMode = false, this.listenMuted = false, this.handUp = false, this.isHost = false, this.talking = const {}});

  LiveState copy({bool? connected, bool? canPublish, bool? micOn, bool? musicMode, bool? listenMuted, bool? handUp, Set<String>? talking}) => LiveState(
        id: id, identity: identity, error: error, connecting: connecting, isHost: isHost,
        connected: connected ?? this.connected, canPublish: canPublish ?? this.canPublish, micOn: micOn ?? this.micOn,
        musicMode: musicMode ?? this.musicMode, listenMuted: listenMuted ?? this.listenMuted, handUp: handUp ?? this.handUp, talking: talking ?? this.talking);
}

String asmLiveErrorText(String? code) => switch (code) {
      'mic_denied' => tr.asmLiveMicDenied,
      'stage_full' => tr.asmLiveStageFull,
      'gone' => tr.asmLiveGone,
      'too_many' => tr.asmAskTooMany,
      'too_soon' => tr.asmErrTooSoon,
      'blocked_words' => tr.asmErrBlocked,
      'q2_unavailable' => tr.asmErrGeneric,
      _ => asmErrorText(code),
    };

// ============================================================================
// 集會卡裡的「直播」區
// ============================================================================

class AssemblyLivePanel extends StatelessWidget {
  final QAssembly a;
  final bool isHost;
  const AssemblyLivePanel({super.key, required this.a, required this.isHost});

  void _toast(BuildContext context, String? err) {
    if (err != null && context.mounted) showGlassToast(context, asmLiveErrorText(err), icon: Icons.error_outline, danger: true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LiveState>(
      valueListenable: AssemblyLive.state,
      builder: (context, s, _) {
        final live = s.id == a.id && s.connected;
        final stage = [a.host, ...a.speakers.values];
        return Container(
          padding: const EdgeInsets.all(Night.space3),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: a.color.withOpacity(0.5))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(live ? Icons.graphic_eq_rounded : Icons.headset_off_outlined, color: live ? a.color : Night.inkFaint, size: 20),
              const SizedBox(width: Night.space2),
              Expanded(
                child: Text(
                  live ? tr.asmLiveOn : (s.id == a.id && s.connecting ? tr.asmLiveConnecting : (s.id == a.id && s.error != null ? tr.asmLiveError : tr.asmLiveOff)),
                  style: TextStyle(color: live ? Night.ink : Night.inkMuted, fontWeight: FontWeight.w600),
                ),
              ),
              if (s.id == a.id && s.error != null)
                TextButton(onPressed: () => AssemblyLive.connect(a.id), child: Text(tr.tryAgain)),
            ]),
            const SizedBox(height: Night.space2),
            Text(tr.asmLiveStage(stage.join('、')), style: Night.caption),
            if (live) ...[
              const SizedBox(height: Night.space3),
              Wrap(spacing: Night.space2, runSpacing: Night.space2, alignment: WrapAlignment.center, children: [
                if (s.canPublish)
                  FilledButton.tonalIcon(
                    onPressed: () async => _toast(context, await AssemblyLive.toggleMic()),
                    icon: Icon(s.micOn ? Icons.mic : Icons.mic_off),
                    label: Text(s.micOn ? tr.asmLiveMicOff : tr.asmLiveMicOn),
                  ),
                if (!isHost && !s.canPublish)
                  OutlinedButton.icon(
                    onPressed: () async => _toast(context, await AssemblyLive.setHand(!s.handUp)),
                    icon: Icon(s.handUp ? Icons.back_hand : Icons.back_hand_outlined),
                    label: Text(s.handUp ? tr.asmLiveHandDown : tr.asmLiveHandUp),
                  ),
                OutlinedButton.icon(
                  onPressed: () => AssemblyLive.setListenMuted(!s.listenMuted),
                  icon: Icon(s.listenMuted ? Icons.volume_off : Icons.volume_up),
                  label: Text(s.listenMuted ? tr.asmLiveUnmute : tr.asmLiveMute),
                ),
              ]),
              if (isHost) ...[
                const SizedBox(height: Night.space2),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: s.musicMode,
                  onChanged: (v) => AssemblyLive.setMusicMode(v),
                  title: Text(tr.asmLiveMusicMode, style: const TextStyle(color: Night.ink, fontSize: 14)),
                  subtitle: Text(tr.asmLiveMusicHint, style: Night.caption),
                ),
                if (a.speakers.isNotEmpty) ...[
                  Text(tr.asmLiveSpeakers, style: Night.caption),
                  for (final e in a.speakers.entries)
                    Row(children: [
                      Icon(s.talking.contains(e.key) ? Icons.graphic_eq_rounded : Icons.person_outline, size: 18, color: a.color),
                      const SizedBox(width: Night.space2),
                      Expanded(child: Text(e.value.isEmpty ? '—' : e.value, style: const TextStyle(color: Night.ink))),
                      IconButton(tooltip: tr.asmLiveMuteGuest, icon: const Icon(Icons.mic_off_outlined, size: 20, color: Night.inkMuted),
                          onPressed: () async => _toast(context, await AssemblyLive.host('asmMute', e.key))),
                      IconButton(tooltip: tr.asmLiveOffStage, icon: const Icon(Icons.arrow_downward, size: 20, color: Night.inkMuted),
                          onPressed: () async => _toast(context, await AssemblyLive.host('asmStage', e.key, on: false))),
                    ]),
                ],
                _HandsList(id: a.id, color: a.color, onError: (err) => _toast(context, err)),
              ],
            ],
            const SizedBox(height: Night.space2),
            Text(tr.asmLiveNoRecording, style: Night.caption, textAlign: TextAlign.center),
          ]),
        );
      },
    );
  }
}

/// 主持人看到的舉手名單（只有主持人讀得到 qAssemblyHands/{id}）
class _HandsList extends StatelessWidget {
  final String id;
  final Color color;
  final void Function(String?) onError;
  const _HandsList({required this.id, required this.color, required this.onError});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('qAssemblyHands/$id').onValue,
      builder: (context, snap) {
        final v = snap.data?.snapshot.value;
        final hands = <(String, String, int)>[
          if (v is Map)
            for (final e in v.entries)
              if (e.value is Map) ('${e.key}', '${(e.value as Map)['name'] ?? ''}', ((e.value as Map)['at'] as num?)?.toInt() ?? 0),
        ]..sort((x, y) => x.$3.compareTo(y.$3));
        if (hands.isEmpty) return const SizedBox.shrink();
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: Night.space2),
          Text(tr.asmLiveHands(hands.length), style: Night.caption),
          for (final h in hands)
            Row(children: [
              Icon(Icons.back_hand_outlined, size: 18, color: color),
              const SizedBox(width: Night.space2),
              Expanded(child: Text(h.$2.isEmpty ? '—' : h.$2, style: const TextStyle(color: Night.ink))),
              TextButton(onPressed: () async => onError(await AssemblyLive.host('asmStage', h.$1, on: true)), child: Text(tr.asmLiveInvite)),
            ]),
        ]);
      },
    );
  }
}

// ============================================================================
// 量子世界畫面上的直播小列：連線中才出現，隨時開關麥克風／靜音，點一下打開集會卡
// ============================================================================

class AssemblyLiveBar extends StatelessWidget {
  final void Function(String id) onOpen;
  const AssemblyLiveBar({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LiveState>(
      valueListenable: AssemblyLive.state,
      builder: (context, s, _) {
        final a = s.id == null ? null : AssemblyState.active.value[s.id];
        if (a == null || !s.connected) return const SizedBox.shrink();
        final talking = s.talking.isNotEmpty;
        return Center(
          child: Material(
            color: Night.night900.withOpacity(0.85),
            shape: StadiumBorder(side: BorderSide(color: a.color.withOpacity(0.7))),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onOpen(a.id),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 4),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(talking ? Icons.graphic_eq_rounded : Icons.headphones, color: a.color, size: 18),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text('${a.emoji} ${a.title}', overflow: TextOverflow.ellipsis, style: const TextStyle(color: Night.ink, fontSize: 13)),
                  ),
                  if (s.canPublish)
                    IconButton(
                      tooltip: s.micOn ? tr.asmLiveMicOff : tr.asmLiveMicOn,
                      icon: Icon(s.micOn ? Icons.mic : Icons.mic_off, color: s.micOn ? a.color : Night.inkMuted, size: 20),
                      onPressed: () async {
                        final err = await AssemblyLive.toggleMic();
                        if (err != null && context.mounted) showGlassToast(context, asmLiveErrorText(err), icon: Icons.error_outline, danger: true);
                      },
                    ),
                  IconButton(
                    tooltip: s.listenMuted ? tr.asmLiveUnmute : tr.asmLiveMute,
                    icon: Icon(s.listenMuted ? Icons.volume_off : Icons.volume_up, color: Night.inkMuted, size: 20),
                    onPressed: () => AssemblyLive.setListenMuted(!s.listenMuted),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 提問：文字提問、按讚、主持人標已回答或隱藏、檢舉
// ============================================================================

class _Question {
  final String id, text;
  final int at, votes;
  final bool answered;
  const _Question(this.id, this.text, this.at, this.votes, this.answered);
}

Future<void> showAssemblyQuestions(BuildContext context, QAssembly a, {required bool isHost}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(left: Night.space3, right: Night.space3, top: Night.space3, bottom: Night.space3 + MediaQuery.of(ctx).viewInsets.bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: GlassCard(child: _QuestionsSheet(a: a, isHost: isHost)),
      ),
    ),
  );
}

class _QuestionsSheet extends StatefulWidget {
  final QAssembly a;
  final bool isHost;
  const _QuestionsSheet({required this.a, required this.isHost});
  @override
  State<_QuestionsSheet> createState() => _QuestionsSheetState();
}

class _QuestionsSheetState extends State<_QuestionsSheet> {
  static final Map<String, Set<String>> _voted = {}; // 集會 id → 這次開 App 按過讚的題目
  final _text = TextEditingController();
  bool _sending = false;

  Set<String> get _mine => _voted.putIfAbsent(widget.a.id, () => {});

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final text = _text.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final (status, data) = await QuantumApi.assembly('asmAsk', {'id': widget.a.id, 'text': text});
    if (!mounted) return;
    setState(() => _sending = false);
    if (status == 200 && data['success'] == true) {
      _text.clear();
      showGlassToast(context, tr.asmAskSent, icon: Icons.check_circle_outline);
    } else {
      showGlassToast(context, asmLiveErrorText(data['code'] as String?), icon: Icons.error_outline, danger: true);
    }
  }

  Future<void> _vote(_Question q) async {
    final up = !_mine.contains(q.id);
    setState(() => up ? _mine.add(q.id) : _mine.remove(q.id));
    await QuantumApi.assembly('asmVote', {'id': widget.a.id, 'qid': q.id, 'up': up});
  }

  Future<void> _mark(_Question q, String state) async {
    await QuantumApi.assembly('asmQMark', {'id': widget.a.id, 'qid': q.id, 'state': state});
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.a;
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('qAssemblyQuestions/${a.id}').onValue,
      builder: (context, snap) {
        final v = snap.data?.snapshot.value;
        final qs = <_Question>[
          if (v is Map)
            for (final e in v.entries)
              if (e.value is Map)
                _Question('${e.key}', '${(e.value as Map)['text'] ?? ''}', ((e.value as Map)['at'] as num?)?.toInt() ?? 0,
                    ((e.value as Map)['votes'] as num?)?.toInt() ?? 0, (e.value as Map)['answered'] == true),
        ]..sort((x, y) => x.answered != y.answered ? (x.answered ? 1 : -1) : (y.votes != x.votes ? y.votes - x.votes : x.at - y.at));
        return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SheetTitle(tr.asmAskTitle, closeTooltip: tr.close),
          const SizedBox(height: Night.space2),
          Text(widget.isHost ? tr.asmAskHostHint : tr.asmAskHint, style: Night.caption, textAlign: TextAlign.center),
          const SizedBox(height: Night.space3),
          if (!widget.isHost)
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  maxLength: 80,
                  style: const TextStyle(color: Night.ink),
                  decoration: InputDecoration(hintText: tr.asmAskInput, hintStyle: const TextStyle(color: Night.inkFaint), counterText: ''),
                  onSubmitted: (_) => _ask(),
                ),
              ),
              IconButton(tooltip: tr.asmAskSend, onPressed: _sending ? null : _ask, icon: Icon(Icons.send, color: a.color)),
            ]),
          const SizedBox(height: Night.space2),
          Flexible(
            child: qs.isEmpty
                ? Padding(padding: const EdgeInsets.all(Night.space4), child: Text(tr.asmAskEmpty, style: Night.caption, textAlign: TextAlign.center))
                : ListView(shrinkWrap: true, children: [
                    for (final q in qs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Night.space2),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(Night.space3, Night.space2, Night.space1, Night.space2),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Night.glassLine)),
                          child: Row(children: [
                            Expanded(
                              child: Text(q.text, style: TextStyle(color: q.answered ? Night.inkFaint : Night.ink, height: 1.4,
                                  decoration: q.answered ? TextDecoration.lineThrough : null)),
                            ),
                            TextButton.icon(
                              onPressed: widget.isHost || q.answered ? null : () => _vote(q),
                              icon: Icon(_mine.contains(q.id) ? Icons.thumb_up : Icons.thumb_up_outlined, size: 16, color: a.color),
                              label: Text('${q.votes}', style: TextStyle(color: a.color)),
                            ),
                            if (widget.isHost)
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: Night.inkMuted, size: 20),
                                onSelected: (s) => _mark(q, s),
                                itemBuilder: (_) => [
                                  PopupMenuItem(value: q.answered ? 'open' : 'answered', child: Text(q.answered ? tr.asmAskReopen : tr.asmAskAnswered)),
                                  PopupMenuItem(value: 'hidden', child: Text(tr.asmAskHide)),
                                ],
                              )
                            else
                              IconButton(
                                tooltip: tr.asmReport,
                                icon: const Icon(Icons.flag_outlined, size: 18, color: Night.inkFaint),
                                onPressed: () {
                                  final me = FirebaseAuth.instance.currentUser?.uid;
                                  if (me == null) return;
                                  showReportSheet(context, myUid: me, targetUid: 'asmq:${a.id}:${q.id}', targetName: q.text,
                                      reportContext: ReportContext.assemblyQuestion, allowBlock: false);
                                },
                              ),
                          ]),
                        ),
                      ),
                  ]),
          ),
        ]);
      },
    );
  }
}
