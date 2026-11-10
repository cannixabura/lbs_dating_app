import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'aiya_api.dart';

enum AiyaCallState { idle, connecting, live, ending }

/// 跟艾婭語音通話（艾婭之友）：OpenAI GPT-Live，跟 ChatGPT 語音同一個模型。
///
/// 流程：手機建立 WebRTC（麥克風＋資料通道 oai-events）→ 把 SDP offer 交給我們的伺服器（action: call）
/// → 伺服器用 API 金鑰向 OpenAI 建立通話、回傳 SDP answer → 手機直接跟 OpenAI 通話。
/// 每通最長 maxMs（伺服器給，5 分鐘），時間到自動掛斷。
class AiyaCall {
  AiyaCall(this.api);

  final AiyaApi api;
  final state = ValueNotifier<AiyaCallState>(AiyaCallState.idle);

  /// 艾婭正在說話（用遠端聲音的音量判斷），畫面用來切說話的片段
  final aiyaSpeaking = ValueNotifier<bool>(false);

  /// 這一輪艾婭說的話（逐字稿），給畫面顯示與檢舉用
  final aiyaLine = ValueNotifier<String>('');

  /// 通話開始時間
  DateTime? startedAt;

  /// 這通最晚到什麼時候（剩下的通話時間用完、或 60 分鐘上限）
  DateTime? endsAt;

  /// 麥克風靜音中
  final muted = ValueNotifier<bool>(false);

  /// 通話結束時呼叫（reason：time_up / idle / hangup / closed）
  void Function(String reason)? onEnded;

  RTCPeerConnection? _pc;
  MediaStream? _mic;
  RTCDataChannel? _dc;
  Timer? _limit, _levels, _beat;
  DateTime _lastActivity = DateTime.now();
  Duration _idle = const Duration(minutes: 3);
  String? _callId;
  DateTime? _startedAt;
  Completer<void>? _closed;
  bool _userSpoke = false;

  /// 開始通話。成功回 null；失敗回伺服器或本機的 code（mic_denied / friend_only / voice_consent / call_daily_max …）
  Future<String?> start({String? voice}) async {
    if (state.value != AiyaCallState.idle) return 'busy';
    state.value = AiyaCallState.connecting;
    aiyaLine.value = '';
    try {
      try {
        _mic = await navigator.mediaDevices.getUserMedia({
          'audio': {'echoCancellation': true, 'noiseSuppression': true, 'autoGainControl': true},
          'video': false,
        });
      } catch (_) {
        await _cleanup();
        return 'mic_denied';
      }
      _pc = await createPeerConnection({'sdpSemantics': 'unified-plan'});
      for (final t in _mic!.getAudioTracks()) {
        await _pc!.addTrack(t, _mic!);
      }
      _dc = await _pc!.createDataChannel('oai-events', RTCDataChannelInit()..ordered = true);
      _dc!.onMessage = (m) => _onEvent(m.text);
      _pc!.onConnectionState = (s) {
        if ((s == RTCPeerConnectionState.RTCPeerConnectionStateFailed || s == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) && state.value == AiyaCallState.live) {
          _end('closed');
        }
      };
      final offer = await _pc!.createOffer({'offerToReceiveAudio': true, 'offerToReceiveVideo': false});
      await _pc!.setLocalDescription(offer);
      final r = await api.call('call', {'sdp': offer.sdp, if (voice != null) 'voice': voice, ...?api.extra?.call()});
      if (r['success'] != true || r['sdp'] is! String) {
        await _cleanup();
        return '${r['code'] ?? 'busy'}';
      }
      await _pc!.setRemoteDescription(RTCSessionDescription(r['sdp'] as String, 'answer'));
      // 喇叭播放（不是聽筒）
      await Helper.setSpeakerphoneOn(true);
      _callId = r['callId'] as String?;
      _startedAt = DateTime.now();
      startedAt = _startedAt;
      _lastActivity = _startedAt!;
      muted.value = false;
      // 防呆：一通最長 maxMs（伺服器給，60 分鐘）；雙方都沒說話超過 idleMs（3 分鐘）就掛斷，避免忘了掛一直計費
      final maxMs = (r['maxMs'] as num?)?.toInt() ?? 3600000;
      endsAt = _startedAt!.add(Duration(milliseconds: maxMs));
      _idle = Duration(milliseconds: (r['idleMs'] as num?)?.toInt() ?? 180000);
      _limit = Timer(Duration(milliseconds: maxMs), () => hangUp(reason: 'time_up'));
      _levels = Timer.periodic(const Duration(milliseconds: 150), (_) => _pollLevel());
      // 計時：每 beatMs（20 秒）告訴伺服器還在通話中；伺服器依此計算秒數
      final beatMs = (r['beatMs'] as num?)?.toInt() ?? 20000;
      _beat = Timer.periodic(Duration(milliseconds: beatMs), (_) async {
        final id = _callId;
        if (id == null) return;
        final b = await api.call('callBeat', {'callId': id});
        if (b['code'] == 'ended' && state.value == AiyaCallState.live) unawaited(hangUp(reason: 'time_up'));
      });
      state.value = AiyaCallState.live;
      return null;
    } catch (_) {
      await _cleanup();
      return 'busy';
    }
  }

  void _onEvent(String text) {
    Map<String, dynamic>? e;
    try {
      final d = jsonDecode(text);
      if (d is Map<String, dynamic>) e = d;
    } catch (_) {}
    if (e == null) return;
    switch (e['type']) {
      case 'session.input_transcript.delta':
        // 使用者開口：艾婭下一次說話開新的一行
        _userSpoke = true;
        _lastActivity = DateTime.now();
      case 'session.output_transcript.delta':
        if (_userSpoke) {
          aiyaLine.value = '';
          _userSpoke = false;
        }
        aiyaLine.value += '${e['delta'] ?? ''}';
        _lastActivity = DateTime.now();
      case 'session.closed':
        // 自己掛斷時 hangUp 會收尾；OpenAI 那邊結束（時間上限、內容審核、斷線）才在這裡收尾
        if (_closed != null && !_closed!.isCompleted) {
          _closed!.complete();
        } else if (state.value == AiyaCallState.live) {
          _end('closed');
        }
    }
  }

  Future<void> _pollLevel() async {
    final pc = _pc;
    if (pc == null) return;
    try {
      var level = 0.0;
      for (final r in await pc.getStats()) {
        if (r.type == 'inbound-rtp' && (r.values['kind'] == 'audio' || r.values['mediaType'] == 'audio')) {
          level = (r.values['audioLevel'] as num?)?.toDouble() ?? level;
        }
      }
      final speaking = level > 0.02;
      if (aiyaSpeaking.value != speaking) aiyaSpeaking.value = speaking;
      if (speaking) _lastActivity = DateTime.now();
      if (state.value == AiyaCallState.live && DateTime.now().difference(_lastActivity) > _idle) unawaited(hangUp(reason: 'idle'));
    } catch (_) {}
  }

  /// 麥克風靜音／取消靜音（通話繼續計費，只是艾婭聽不到）
  void setMuted(bool v) {
    for (final t in _mic?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      t.enabled = !v;
    }
    muted.value = v;
    _lastActivity = DateTime.now();
  }

  /// 掛斷：先請 OpenAI 結束（等最多 1.5 秒收到 session.closed），再關掉連線和麥克風
  Future<void> hangUp({String reason = 'hangup'}) async {
    if (state.value != AiyaCallState.live && state.value != AiyaCallState.connecting) return;
    state.value = AiyaCallState.ending;
    try {
      if (_dc?.state == RTCDataChannelState.RTCDataChannelOpen) {
        _closed = Completer<void>();
        await _dc!.send(RTCDataChannelMessage(jsonEncode({'type': 'session.close'})));
        await _closed!.future.timeout(const Duration(milliseconds: 1500), onTimeout: () {});
      }
    } catch (_) {}
    await _end(reason);
  }

  bool _ending = false;

  Future<void> _end(String reason) async {
    if (state.value == AiyaCallState.idle || _ending) return;
    _ending = true;
    final seconds = _startedAt == null ? 0 : DateTime.now().difference(_startedAt!).inSeconds;
    final id = _callId;
    await _cleanup();
    if (id != null) unawaited(api.call('callEnd', {'callId': id, 'seconds': seconds, 'reason': reason}));
    _ending = false;
    _closed = null;
    onEnded?.call(reason);
  }

  Future<void> _cleanup() async {
    _limit?.cancel();
    _levels?.cancel();
    _beat?.cancel();
    _beat = null;
    _limit = null;
    _levels = null;
    aiyaSpeaking.value = false;
    try {
      for (final t in _mic?.getTracks() ?? const <MediaStreamTrack>[]) {
        await t.stop();
      }
      await _mic?.dispose();
    } catch (_) {}
    try {
      await _dc?.close();
      await _pc?.close();
    } catch (_) {}
    _mic = null;
    _dc = null;
    _pc = null;
    _callId = null;
    _startedAt = null;
    startedAt = null;
    endsAt = null;
    muted.value = false;
    state.value = AiyaCallState.idle;
  }
}
