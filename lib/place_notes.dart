import 'l10n/l10n.dart';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'hidden_content.dart';
import 'mood_place.dart';
import 'report_sheet.dart';
import 'translate.dart';
import 'ui/night.dart';

/// 店內留言本（心情據點第三階段）：人在店裡（約 40 公尺內）才讀得到、寫得了。
/// 伺服器：geo-service/index.js 的 placeNote 端點，再確認一次距離；作者永遠匿名，30 天後消失，同一家店每人每天 1 則。
/// 只有打開名片、而且手機判斷已經在店裡時，才會把位置送到伺服器確認，伺服器不保存。

const _noteUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/placeNote';
const placeNoteMaxLength = 60;
const placeNoteRadiusMeters = 40.0;

class PlaceNote {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool mine;

  PlaceNote.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        text = j['text'],
        createdAt = DateTime.fromMillisecondsSinceEpoch((j['createdAt'] as num).toInt()),
        mine = j['mine'] == true;
}

class PlaceNotesApi {
  PlaceNotesApi._();

  /// 回傳 (資料, 錯誤訊息)
  static Future<(Map<String, dynamic>?, String?)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_noteUrl),
        headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) return (data, null);
      return (null, (data['error'] as String?) ?? tr.placeGuestbookUnavailable);
    } catch (_) {
      return (null, tr.placeGuestbookUnavailable);
    }
  }

  static Future<(List<PlaceNote>?, String?)> list(String place, double lat, double lng) async {
    final (data, error) = await _call({'action': 'list', 'place': place, 'lat': lat, 'lng': lng});
    if (data == null) return (null, error);
    final items = (data['data'] as List?) ?? const [];
    return (items.map((e) => PlaceNote.fromJson(Map<String, dynamic>.from(e))).toList(), null);
  }

  static Future<(PlaceNote?, String?)> post(String place, double lat, double lng, String text) async {
    final (data, error) = await _call({'action': 'post', 'place': place, 'lat': lat, 'lng': lng, 'text': text});
    if (data == null) return (null, error);
    return (PlaceNote.fromJson(Map<String, dynamic>.from(data['data'])), null);
  }

  static Future<String?> delete(String id) async {
    final (_, error) = await _call({'action': 'delete', 'id': id});
    return error;
  }
}

/// 兩點之間的公尺數
double metersBetween(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371000.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final s = pow(sin(dLat / 2), 2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * pow(sin(dLng / 2), 2);
  return 2 * r * asin(sqrt(s));
}

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return tr.justNow;
  if (d.inHours < 1) return tr.minutesAgo(d.inMinutes);
  if (d.inDays < 1) return tr.hoursAgo(d.inHours);
  return tr.daysAgo(d.inDays);
}

/// 名片裡的留言本區塊。[here] 是目前位置（沒有就當作不在店裡）。
class PlaceGuestbook extends StatefulWidget {
  final MoodPlace place;
  final ({double lat, double lng})? here;
  final String myUid;
  const PlaceGuestbook({super.key, required this.place, required this.here, required this.myUid});

  @override
  State<PlaceGuestbook> createState() => _PlaceGuestbookState();
}

class _PlaceGuestbookState extends State<PlaceGuestbook> {
  List<PlaceNote>? _notes;
  String? _error;
  bool _loading = false;
  final Map<String, String> _translated = {};
  final Set<String> _showTranslated = {};
  final Set<String> _translating = {};

  bool get _inside {
    final h = widget.here;
    return h != null && metersBetween(h.lat, h.lng, widget.place.lat, widget.place.lng) <= placeNoteRadiusMeters;
  }

  @override
  void initState() {
    super.initState();
    if (_inside) _load();
  }

  Future<void> _load() async {
    final h = widget.here!;
    setState(() { _loading = true; _error = null; });
    final (notes, error) = await PlaceNotesApi.list(widget.place.id, h.lat, h.lng);
    if (!mounted) return;
    setState(() { _loading = false; _notes = notes; _error = error; });
  }

  Future<void> _write() async {
    final h = widget.here!;
    final note = await showModalBottomSheet<PlaceNote>(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent, barrierColor: const Color(0x99070B1F),
      builder: (_) => _NoteComposer(place: widget.place, lat: h.lat, lng: h.lng),
    );
    if (note == null || !mounted) return;
    setState(() => _notes = [note, ...?_notes]);
    showGlassToast(context, tr.placeGuestbookSent, icon: Icons.check);
  }

  Future<void> _toggleTranslation(PlaceNote n) async {
    if (_translating.contains(n.id)) return;
    if (_translated.containsKey(n.id)) {
      setState(() => _showTranslated.contains(n.id) ? _showTranslated.remove(n.id) : _showTranslated.add(n.id));
      return;
    }
    final locale = Localizations.localeOf(context);
    if (!await ChatTranslator.needsTranslation(n.text, locale) || !mounted) return;
    setState(() => _translating.add(n.id));
    String? out;
    try { out = await ChatTranslator.translate(context, n.text, locale); } catch (_) {}
    if (!mounted) return;
    setState(() {
      _translating.remove(n.id);
      if (out != null) { _translated[n.id] = out; _showTranslated.add(n.id); }
    });
    if (out == null) showGlassToast(context, tr.translateFailed, icon: Icons.error_outline, danger: true);
  }

  Future<void> _delete(PlaceNote n) async {
    final error = await PlaceNotesApi.delete(n.id);
    if (!mounted) return;
    if (error != null) {
      showGlassToast(context, error, icon: Icons.error_outline, danger: true);
    } else {
      setState(() => _notes = _notes?.where((e) => e.id != n.id).toList());
    }
  }

  Future<void> _report(PlaceNote n) async {
    await showReportSheet(context, myUid: widget.myUid, targetUid: 'place_note:${n.id}', targetName: tr.thisPlaceNote,
        reportContext: ReportContext.placeNote, allowBlock: false);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hidden = HiddenContent.instance.placeNotes;
    final notes = _notes?.where((n) => !hidden.contains(n.id)).toList();
    return Container(
      padding: const EdgeInsets.all(Night.space3),
      decoration: BoxDecoration(
        color: Night.night700.withOpacity(0.6),
        borderRadius: BorderRadius.circular(Night.radiusMd),
        border: Border.all(color: placeColor.withOpacity(0.35)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.menu_book_outlined, size: 18, color: placeColor),
          const SizedBox(width: Night.space2),
          Expanded(child: Text(tr.placeGuestbook, style: Night.body.copyWith(color: Night.ink, fontWeight: FontWeight.w500))),
        ]),
        const SizedBox(height: Night.space1),
        if (!_inside)
          Text(tr.placeGuestbookLocked(placeNoteRadiusMeters.round()), style: Night.caption)
        else ...[
          Text(tr.placeGuestbookAbout, style: Night.caption),
          const SizedBox(height: Night.space2),
          if (_loading)
            const Padding(padding: EdgeInsets.all(Night.space3), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: placeColor))))
          else if (_error != null)
            Text(_error!, style: Night.caption.copyWith(color: Night.inkMuted))
          else if (notes != null && notes.isEmpty)
            Text(tr.placeGuestbookEmpty, style: Night.body.copyWith(fontSize: 14))
          else if (notes != null)
            for (final n in notes) _noteTile(n),
          const SizedBox(height: Night.space2),
          if (_error == null && !_loading) NightButton(tr.placeGuestbookWrite, icon: Icons.edit_outlined, kind: NightButtonKind.ghost, expand: true, onPressed: _write),
        ],
      ]),
    );
  }

  Widget _noteTile(PlaceNote n) {
    final translated = _showTranslated.contains(n.id);
    final caption = _translating.contains(n.id) ? tr.translating : (translated ? tr.translateShowOriginal : null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Night.space1),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _toggleTranslation(n),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Night.space1),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(translated ? _translated[n.id]! : n.text, style: Night.body.copyWith(color: Night.ink, fontSize: 15)),
                const SizedBox(height: 2),
                Text([if (n.mine) tr.placeNoteMine, _ago(n.createdAt), ?caption].join(' · '), style: Night.caption),
              ]),
            ),
          ),
        ),
        IconButton(
          tooltip: n.mine ? tr.withdrawPlaceNote : tr.reportPlaceNote,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          icon: Icon(n.mine ? Icons.delete_outline : Icons.flag_outlined, size: 18, color: Night.inkFaint),
          onPressed: () => n.mine ? _delete(n) : _report(n),
        ),
      ]),
    );
  }
}

class _NoteComposer extends StatefulWidget {
  final MoodPlace place;
  final double lat;
  final double lng;
  const _NoteComposer({required this.place, required this.lat, required this.lng});
  @override
  State<_NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends State<_NoteComposer> {
  final _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final (note, error) = await PlaceNotesApi.post(widget.place.id, widget.lat, widget.lng, text);
    if (!mounted) return;
    if (note != null) {
      Navigator.pop(context, note);
    } else {
      setState(() => _sending = false);
      showGlassToast(context, error ?? tr.placeGuestbookUnavailable, icon: Icons.error_outline, danger: true);
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
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.menu_book_outlined, color: placeColor, size: 20),
                const SizedBox(width: Night.space2),
                Flexible(child: Text(widget.place.name, style: Night.title, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: Night.space1),
              Text(tr.placeGuestbookAbout, style: Night.caption, textAlign: TextAlign.center),
              const SizedBox(height: Night.space3),
              TextField(
                controller: _text,
                autofocus: true,
                maxLength: placeNoteMaxLength,
                maxLines: 3,
                minLines: 2,
                style: const TextStyle(color: Night.ink, fontSize: 16),
                decoration: InputDecoration(hintText: tr.placeGuestbookHint),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: Night.space2),
              NightButton(_sending ? tr.sending : tr.send, icon: Icons.send, expand: true, onPressed: _sending || _text.text.trim().isEmpty ? null : _send),
            ]),
          ),
        ),
      ),
    );
  }
}
