import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ui/night.dart';

/// 低語穿越：寫給未來的自己。只有作者看得到，一個月或一年後解封，
/// 時間到推播一次，回到 100 公尺內才能打開。伺服器：geo-service/index.js 的 timeWhisper 端點。

const _timeWhisperUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/timeWhisper';
const timeWhisperMaxLength = 120;
const timeWhisperOpenMeters = 100.0;

class TimeWhisper {
  final String id;
  final double lat;
  final double lng;
  final DateTime createdAt;
  final DateTime unlockAt;
  final bool unlocked;
  final bool opened;
  final String? text;

  TimeWhisper.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        lat = (j['lat'] as num).toDouble(),
        lng = (j['lng'] as num).toDouble(),
        createdAt = DateTime.fromMillisecondsSinceEpoch((j['createdAt'] as num).toInt()),
        unlockAt = DateTime.fromMillisecondsSinceEpoch((j['unlockAt'] as num).toInt()),
        unlocked = j['unlocked'] == true,
        opened = j['opened'] == true,
        text = j['text'] as String?;

  /// 解封時間已到（以手機時間判斷，伺服器會再檢查一次）
  bool get isUnlocked => unlocked || !DateTime.now().isBefore(unlockAt);

  double metersFrom(double fromLat, double fromLng) {
    const r = 6371000.0;
    final dLat = (lat - fromLat) * pi / 180;
    final dLng = (lng - fromLng) * pi / 180;
    final s = pow(sin(dLat / 2), 2) + cos(fromLat * pi / 180) * cos(lat * pi / 180) * pow(sin(dLng / 2), 2);
    return 2 * r * asin(sqrt(s));
  }
}

String timeWhisperDate(DateTime t) => '${t.year}/${t.month}/${t.day}';

/// 「一年前」「一個月前」：依寫下到解封的間隔
String timeWhisperAgo(TimeWhisper w) => w.unlockAt.difference(w.createdAt).inDays >= 365 ? '一年前' : '一個月前';

class TimeWhisperApi {
  TimeWhisperApi._();

  static Future<(Map<String, dynamic>?, String?)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_timeWhisperUrl),
        headers: {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) return (data, null);
      return (null, (data['error'] as String?) ?? '低語穿越暫時無法使用，請稍後再試。');
    } catch (_) {
      return (null, '沒有送出，請檢查網路後再試一次。');
    }
  }

  /// delay：'month' 或 'year'
  static Future<String?> create(double lat, double lng, String text, String delay) async =>
      (await _call({'action': 'create', 'lat': lat, 'lng': lng, 'text': text, 'delay': delay})).$2;

  static Future<List<TimeWhisper>> list() async {
    final (data, _) = await _call({'action': 'list'});
    final items = (data?['data'] as List?) ?? const [];
    return items.map((e) => TimeWhisper.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<(TimeWhisper?, String?)> open(String id, double lat, double lng) async {
    final (data, error) = await _call({'action': 'open', 'id': id, 'lat': lat, 'lng': lng});
    if (error != null) return (null, error);
    return (TimeWhisper.fromJson(Map<String, dynamic>.from(data!['data'])), null);
  }

  static Future<String?> delete(String id) async => (await _call({'action': 'delete', 'id': id})).$2;
}

/// 打開（或重讀）一封低語穿越。回傳 true 表示刪除了它。
Future<bool> showTimeWhisperReader(BuildContext context, TimeWhisper w, {bool justOpened = false}) async {
  final deleted = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0xCC070B1F),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(
        glow: true,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.hourglass_bottom, color: Night.auroraViolet, size: 32),
          const SizedBox(height: Night.space2),
          Text(justOpened ? '${timeWhisperAgo(w)}的你，在這裡說' : '你在這裡留下的低語穿越', style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space1),
          Text('寫於 ${timeWhisperDate(w.createdAt)}', style: Night.caption, textAlign: TextAlign.center),
          const SizedBox(height: Night.space4),
          Container(
            padding: const EdgeInsets.all(Night.space4),
            decoration: BoxDecoration(
              color: Night.night700,
              borderRadius: BorderRadius.circular(Night.radiusMd),
              border: Border.all(color: Night.auroraViolet.withOpacity(0.6)),
              boxShadow: [BoxShadow(color: Night.auroraViolet.withOpacity(0.25), blurRadius: 18)],
            ),
            child: Text(w.text ?? '', style: const TextStyle(color: Night.ink, fontSize: 18, height: 1.7), textAlign: TextAlign.center),
          ),
          const SizedBox(height: Night.space4),
          Row(children: [
            Expanded(
              child: NightButton('刪除', kind: NightButtonKind.ghost, icon: Icons.delete_outline, onPressed: () async {
                final error = await TimeWhisperApi.delete(w.id);
                if (!dialogContext.mounted) return;
                if (error == null) {
                  Navigator.pop(dialogContext, true);
                } else {
                  showGlassToast(dialogContext, error, icon: Icons.error_outline, danger: true);
                }
              }),
            ),
            const SizedBox(width: Night.space2),
            Expanded(child: NightButton('收好', onPressed: () => Navigator.pop(dialogContext, false))),
          ]),
        ]),
      ),
    ),
  );
  return deleted == true;
}

/// 設定 › 我的低語穿越：所有寫給未來的信
Future<void> showTimeWhisperList(BuildContext context, {required double? lat, required double? lng}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(Night.space4),
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(Night.space4, Night.space3, Night.space4, Night.space4),
        child: _TimeWhisperList(lat: lat, lng: lng),
      ),
    ),
  );
}

class _TimeWhisperList extends StatefulWidget {
  final double? lat;
  final double? lng;
  const _TimeWhisperList({required this.lat, required this.lng});
  @override
  State<_TimeWhisperList> createState() => _TimeWhisperListState();
}

class _TimeWhisperListState extends State<_TimeWhisperList> {
  List<TimeWhisper>? _items;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final list = await TimeWhisperApi.list();
    if (mounted) setState(() => _items = list);
  }

  String _status(TimeWhisper w) {
    if (w.opened) return '已打開 · 寫於 ${timeWhisperDate(w.createdAt)}';
    if (!w.isUnlocked) return '${timeWhisperDate(w.unlockAt)} 解封 · 寫於 ${timeWhisperDate(w.createdAt)}';
    final m = widget.lat == null ? null : w.metersFrom(widget.lat!, widget.lng!);
    return m == null ? '已解封，回到那裡就能打開' : '已解封 · 距離你 ${m < 1000 ? '${m.round()} 公尺' : '${(m / 1000).toStringAsFixed(1)} 公里'}';
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Stack(alignment: Alignment.center, children: [
        const Text('我的低語穿越', style: Night.title, textAlign: TextAlign.center),
        Align(alignment: Alignment.centerRight, child: IconButton(tooltip: '關閉', icon: const Icon(Icons.close, color: Night.inkMuted), onPressed: () => Navigator.pop(context))),
      ]),
      const Text('寫給未來的自己，只有你看得到。時間到了，回到那裡 100 公尺內就能打開。', style: Night.body, textAlign: TextAlign.center),
      const SizedBox(height: Night.space3),
      if (items == null)
        const Padding(padding: EdgeInsets.all(Night.space6), child: Center(child: CircularProgressIndicator(color: Night.auroraViolet)))
      else if (items.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Night.space6),
          child: Text('還沒有寫給未來的信。按底部選單的筆記圖示，選「寄給未來的自己」。', style: Night.caption, textAlign: TextAlign.center),
        )
      else
        Flexible(
          child: ListView(shrinkWrap: true, children: [
            for (final w in items)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: Night.space2),
                leading: Icon(w.opened ? Icons.drafts_outlined : (w.isUnlocked ? Icons.mark_email_unread_outlined : Icons.lock_clock), color: w.isUnlocked ? Night.auroraViolet : Night.inkMuted),
                title: Text(w.opened ? (w.text ?? '') : (w.isUnlocked ? '已經可以打開了' : '封存中'), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Night.ink, fontSize: 15)),
                subtitle: Text(_status(w), style: Night.caption),
                onTap: w.opened
                    ? () async {
                        final deleted = await showTimeWhisperReader(context, w);
                        if (deleted) _load();
                      }
                    : null,
                trailing: w.opened
                    ? null
                    : IconButton(
                        tooltip: '刪除',
                        icon: const Icon(Icons.delete_outline, color: Night.inkFaint),
                        onPressed: () async {
                          final error = await TimeWhisperApi.delete(w.id);
                          if (!mounted) return;
                          if (error != null) {
                            showGlassToast(context, error, icon: Icons.error_outline, danger: true);
                          } else {
                            _load();
                          }
                        },
                      ),
              ),
          ]),
        ),
    ]);
  }
}
