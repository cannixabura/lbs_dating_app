import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'aiya_api.dart';

/// 艾婭的語音朗讀（艾婭之友）。伺服器用 OpenAI 語音合成產生 AAC，這裡播放。
///
/// `speaking` 在播放時為 true，畫面可以用它切到說話的影片片段、讓嘴巴動。
class AiyaVoice {
  AiyaVoice(this.api);

  final AiyaApi api;
  final speaking = ValueNotifier<bool>(false);
  final AudioPlayer _player = AudioPlayer(playerId: 'aiya_voice');
  StreamSubscription<void>? _done;

  /// 念艾婭剛說的那一句。回傳伺服器的 code（成功是 null），讓畫面顯示對應的提示
  Future<String?> speakLast(String sessionId) async {
    final r = await api.speak(sessionId);
    if (r['success'] != true || r['audio'] is! String) return '${r['code'] ?? 'busy'}';
    try {
      final bytes = base64Decode(r['audio'] as String);
      await _player.stop();
      _done ??= _player.onPlayerComplete.listen((_) => speaking.value = false);
      speaking.value = true;
      await _player.play(BytesSource(bytes, mimeType: 'audio/aac'));
      return null;
    } catch (_) {
      speaking.value = false;
      return 'busy';
    }
  }

  Future<void> stop() async {
    speaking.value = false;
    await _player.stop();
  }

  Future<void> dispose() async {
    await _done?.cancel();
    await _player.dispose();
    speaking.dispose();
  }
}
