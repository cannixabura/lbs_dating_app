import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'report_sheet.dart';
import 'ui/night.dart';

/// 低語（城市漂流瓶）：在某個地方留一句話，之後經過的人會收到。
/// 伺服器：geo-service/index.js 的 whisper 端點。作者永遠匿名。

const _whisperUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/whisper';
const whisperMaxLength = 60;

class Whisper {
  final String id;
  final String text;
  final String mood;
  final DateTime createdAt;
  final int reads;
  final double lat;
  final double lng;
  final bool mine;

  Whisper.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        text = j['text'],
        mood = j['mood'] ?? 'other',
        createdAt = DateTime.fromMillisecondsSinceEpoch((j['createdAt'] as num).toInt()),
        reads = (j['reads'] as num?)?.toInt() ?? 0,
        lat = (j['lat'] as num).toDouble(),
        lng = (j['lng'] as num).toDouble(),
        mine = j['mine'] == true;
}

class WhisperApi {
  WhisperApi._();

  /// 回傳 (資料, 錯誤訊息)
  static Future<(Map<String, dynamic>?, String?)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_whisperUrl),
        headers: {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) return (data, null);
      return (null, (data['error'] as String?) ?? '低語暫時無法使用，請稍後再試。');
    } catch (_) {
      return (null, '低語沒有送出，請檢查網路後再試一次。');
    }
  }

  static Future<String?> post(double lat, double lng, String text, String mood) async {
    final (_, error) = await _call({'action': 'post', 'lat': lat, 'lng': lng, 'text': text, 'mood': mood});
    return error;
  }

  static Future<List<Whisper>> list(double lat, double lng) async {
    final (data, _) = await _call({'action': 'list', 'lat': lat, 'lng': lng});
    final items = (data?['data'] as List?) ?? const [];
    return items.map((e) => Whisper.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<void> collect(String id) => _call({'action': 'collect', 'id': id});

  static Future<String?> delete(String id) async {
    final (_, error) = await _call({'action': 'delete', 'id': id});
    return error;
  }
}

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return '剛剛';
  if (d.inHours < 1) return '${d.inMinutes} 分鐘前';
  if (d.inDays < 1) return '${d.inHours} 小時前';
  return '${d.inDays} 天前';
}

/// 留下低語。成功回傳 true。
Future<bool> showWhisperComposer(BuildContext context, {required double lat, required double lng, required String mood}) async {
  final posted = await showModalBottomSheet<bool>(
    context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: const Color(0x99070B1F),
    builder: (_) => _WhisperComposer(lat: lat, lng: lng, mood: mood),
  );
  return posted == true;
}

/// 輸入框的 controller 由這個 widget 持有，等面板關閉動畫結束、真正移除時才釋放。
/// 若在 showModalBottomSheet 回傳後就 dispose，關閉動畫期間的 TextField 會用到已釋放的 controller。
class _WhisperComposer extends StatefulWidget {
  final double lat;
  final double lng;
  final String mood;
  const _WhisperComposer({required this.lat, required this.lng, required this.mood});

  @override
  State<_WhisperComposer> createState() => _WhisperComposerState();
}

class _WhisperComposerState extends State<_WhisperComposer> {
  final TextEditingController controller = TextEditingController();
  bool sending = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty || sending) return;
    setState(() => sending = true);
    final error = await WhisperApi.post(widget.lat, widget.lng, text, widget.mood);
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() => sending = false);
      showGlassToast(context, error, icon: Icons.mail_outline, danger: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            glow: true,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Icon(Icons.mail_outline, color: Night.auroraBlue, size: 30),
              const SizedBox(height: Night.space2),
              const Text('留下一則低語', style: Night.title, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              const Text('寫給下一個經過這裡的人。', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              TextField(
                controller: controller,
                autofocus: true,
                maxLength: whisperMaxLength,
                minLines: 2,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                cursorColor: Night.auroraViolet,
                style: const TextStyle(color: Night.ink, fontSize: 16, height: 1.6),
                decoration: InputDecoration(
                  hintText: '例如：這裡的夕陽很美，記得抬頭看看。',
                  hintStyle: const TextStyle(color: Night.inkFaint, fontSize: 14),
                  counterStyle: Night.caption,
                  filled: true,
                  fillColor: Night.night700,
                  contentPadding: const EdgeInsets.all(Night.space4),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.glassLine)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.auroraViolet, width: 2)),
                ),
              ),
              const SizedBox(height: Night.space2),
              const Text('7 天後消散 · 不會顯示你是誰 · 只透露你曾在這一帶', style: Night.caption, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: sending ? null : () => Navigator.pop(context, false))),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton(sending ? '送出中…' : '留在這裡', onPressed: controller.text.trim().isEmpty || sending ? null : send)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

/// 閱讀一則低語。回傳 true 表示作者收回了它。
Future<bool> showWhisperReader(BuildContext context, Whisper w, {required Color color, required String myUid}) async {
  if (!w.mine) WhisperApi.collect(w.id); // 讀到就算「收下」，每人只算一次
  final deleted = await showModalBottomSheet<bool>(
    context: context, backgroundColor: Colors.transparent, barrierColor: const Color(0x99070B1F),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        child: GlassCard(
          glow: true,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.mail_outline, color: color, size: 20),
              const SizedBox(width: Night.space2),
              Text(w.mine ? '你留下的低語' : '一則低語', style: Night.title),
            ]),
            const SizedBox(height: Night.space1),
            Text('${_ago(w.createdAt)}留在這一帶', style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
            Container(
              padding: const EdgeInsets.all(Night.space4),
              decoration: BoxDecoration(
                color: Night.night700,
                borderRadius: BorderRadius.circular(Night.radiusMd),
                border: Border.all(color: color.withOpacity(0.6)),
                boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 18)],
              ),
              child: Text(w.text, style: const TextStyle(color: Night.ink, fontSize: 18, height: 1.7), textAlign: TextAlign.center),
            ),
            const SizedBox(height: Night.space4),
            if (w.mine) ...[
              Text(w.reads > 0 ? '已被 ${w.reads} 個人收下' : '還沒有人經過', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space3),
              NightButton('收回這則低語', kind: NightButtonKind.danger, icon: Icons.delete_outline, onPressed: () async {
                final error = await WhisperApi.delete(w.id);
                if (!sheetContext.mounted) return;
                if (error == null) {
                  Navigator.pop(sheetContext, true);
                } else {
                  showGlassToast(sheetContext, error, icon: Icons.error_outline, danger: true);
                }
              }),
            ] else ...[
              const Text('你收下了這則低語。', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              Text(w.reads > 0 ? '在你之前，已經有 ${w.reads} 個人經過這裡。' : '你是第一個經過這裡的人。', style: Night.caption, textAlign: TextAlign.center),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Night.inkFaint, minimumSize: const Size(44, 44)),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('檢舉這則低語', style: Night.caption),
                onPressed: () {
                  Navigator.pop(sheetContext, false);
                  showReportSheet(context, myUid: myUid, targetUid: 'whisper:${w.id}', targetName: '這則低語',
                      reportContext: ReportContext.whisper, allowBlock: false);
                },
              ),
            ],
          ]),
        ),
      ),
    ),
  );
  return deleted == true;
}
