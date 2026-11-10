import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// 艾婭伺服器 API。兩個 App 打同一個網址，用 app 區分次數、會員、預算與角色設定：
/// 城市低語 `AiyaApi(app: 'mw')`（伺服器預設）、旅行團 `AiyaApi(app: 'tour')`。
///
/// 回應都是 Map；連不上時回 {success: false, code: 'busy'}。
class AiyaApi {
  AiyaApi({
    required this.app,
    required this.language,
    this.url = defaultUrl,
    this.extra,
    this.signInAnonymously = false,
  });

  static const defaultUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/aiya';

  /// 'mw'（城市低語）或 'tour'（旅行團）
  final String app;

  /// App 目前的語言代號（zh-Hant、en、ja、pt…），送到伺服器決定艾婭用什麼語言回、朗讀用什麼口音
  final String Function() language;

  final String url;

  /// 每次 say 額外送的欄位。旅行團用來送團主公布的行程與集合資訊、使用者時區：
  /// `{'tourContext': '…', 'tzOffsetMin': 540}`（不要放任何人的位置）
  final Map<String, dynamic> Function()? extra;

  /// 本機測試用：還沒登入就先匿名登入
  final bool signInAnonymously;

  Future<Map<String, String>> _headers() async {
    final auth = FirebaseAuth.instance;
    if (signInAnonymously && auth.currentUser == null) await auth.signInAnonymously();
    final token = await auth.currentUser?.getIdToken();
    return {'Content-Type': 'application/json', 'Accept-Language': language(), if (token != null) 'Authorization': 'Bearer $token'};
  }

  Map<String, dynamic> _body(String action, Map<String, dynamic> body) =>
      {'action': action, 'app': app, 'lang': language(), ...body};

  /// 一般呼叫：status / consent / open / close / report / verify / speak
  Future<Map<String, dynamic>> call(String action, [Map<String, dynamic> body = const {}]) async {
    try {
      final response = await http
          .post(Uri.parse(url), headers: await _headers(), body: jsonEncode(_body(action, body)))
          .timeout(const Duration(seconds: 40));
      final data = jsonDecode(response.body);
      return data is Map<String, dynamic> ? data : {'success': false, 'code': 'busy'};
    } catch (_) {
      return {'success': false, 'code': 'busy'};
    }
  }

  /// 跟艾婭說一句（串流）：一邊收一邊吐出 {t: 'delta', text: 到目前為止的回覆}，最後一筆是完整結果。
  /// 伺服器還沒更新時會直接回一整個 JSON，當成最後一筆。
  Stream<Map<String, dynamic>> say(Map<String, dynamic> body) async* {
    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse(url))
        ..headers.addAll(await _headers())
        ..body = jsonEncode(_body('say', {'stream': true, ...?extra?.call(), ...body}));
      final response = await client.send(request).timeout(const Duration(seconds: 20));
      Map<String, dynamic>? last;
      await for (final line in response.stream.transform(utf8.decoder).transform(const LineSplitter()).timeout(const Duration(seconds: 40))) {
        if (line.trim().isEmpty) continue;
        final m = jsonDecode(line);
        if (m is! Map<String, dynamic>) continue;
        if (m['t'] == 'delta') {
          yield m;
          continue;
        }
        last = m;
        break;
      }
      yield last ?? {'success': false, 'code': 'busy'};
    } catch (_) {
      yield {'success': false, 'code': 'busy'};
    } finally {
      client.close();
    }
  }

  /// 艾婭之友：把艾婭剛說的那一句念出來。成功時回 {success: true, audio: base64 AAC, speechCharsLeft}
  /// 失敗 code：friend_only / speech_daily_max / speech_resting / speech_repeat / ended / busy
  Future<Map<String, dynamic>> speak(String sessionId) => call('speak', {'sessionId': sessionId});
}
