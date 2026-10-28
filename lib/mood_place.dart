import 'l10n/l10n.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kReleaseMode, visibleForTesting;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'legal.dart';
import 'translate.dart';
import 'ui/night.dart';

/// 心情據點：合作的獨立咖啡店。規劃見 docs/mood-places-plan.md。
/// 整份清單從網站下載到手機（tool/build_places.py 產生 hosting/places/v1.json），
/// 「是否在店門口 150 公尺內」「現在有沒有營業」都只在手機上判斷，位置不會傳出去。

// 開發時可以用 --dart-define=PLACES_URL=http://localhost:8000/places/v1.json 指向本機的 hosting 資料夾
final _listUrl = Uri.parse(const String.fromEnvironment('PLACES_URL', defaultValue: 'https://mood-whisper-f7de9.web.app/places/v1.json'));
const placeColor = Night.cityAmber;

/// 台灣時間（UTC+8），不管手機設在哪個時區。回傳的 DateTime 是 UTC，但年月日時分就是台灣的牆上時間。
DateTime taiwanTime(DateTime now) => now.toUtc().add(const Duration(hours: 8));

String _dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

const _days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

int _minutes(String t) {
  final parts = t.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

class MoodPlace {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String address;
  final String phone;
  final Map<int, List<(int, int)>> hours; // 星期一=1…星期日=7 → [(開始分鐘, 結束分鐘)]，結束可以超過 24:00
  final Set<String> closed;
  final String story;
  final String photo;
  final bool test;

  MoodPlace.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        lat = (j['lat'] as num).toDouble(),
        lng = (j['lng'] as num).toDouble(),
        address = j['address'] ?? '',
        phone = j['phone'] ?? '',
        hours = {
          for (var i = 0; i < 7; i++)
            i + 1: [for (final r in ((j['hours'] as Map?)?[_days[i]] as List? ?? const [])) (_minutes(r[0]), _minutes(r[1]))],
        },
        closed = Set<String>.from(j['closed'] ?? const []),
        story = j['story'] ?? '',
        photo = j['photo'] ?? '',
        test = j['test'] == true;

  /// 營業中就回傳今天幾點打烊（從今天 00:00 起算的分鐘，可能超過 1440）；沒營業回傳 null。
  /// 前一天營業到凌晨（例如 26:00）的時段也算；公休日看的是時段開始的那一天。
  int? closingMinute(DateTime now) {
    final tw = taiwanTime(now);
    final m = tw.hour * 60 + tw.minute;
    if (!closed.contains(_dateKey(tw))) {
      for (final (start, end) in hours[tw.weekday]!) {
        if (start <= m && m < end) return end;
      }
    }
    final yesterday = tw.subtract(const Duration(days: 1));
    if (!closed.contains(_dateKey(yesterday))) {
      for (final (_, end) in hours[yesterday.weekday]!) {
        if (end > 1440 && m + 1440 < end) return end - 1440;
      }
    }
    return null;
  }

  bool isOpen(DateTime now) => closingMinute(now) != null;

  /// 「營業到 22:00」；凌晨打烊顯示 02:00，整天營業顯示 24:00
  String? openUntilText(DateTime now) {
    final end = closingMinute(now);
    if (end == null) return null;
    final shown = end == 1440 ? end : end % 1440;
    return tr.placeOpenUntil('${(shown ~/ 60).toString().padLeft(2, '0')}:${(shown % 60).toString().padLeft(2, '0')}');
  }

  String get photoUrl => photo.isEmpty ? '' : _listUrl.resolve('../$photo').toString();
}

/// 清單：先讀手機上的快取，再向網站要新的（有 ETag，沒變就不重抓）。打開 App 時一次，之後每 6 小時一次。
class MoodPlaces {
  MoodPlaces._();

  static const nearMeters = 150.0;
  static const leaveMeters = 170.0; // 進入 150 公尺才亮，走出 170 公尺才熄，避免定位飄動時一直閃
  static const minRadiusPx = 72.0; // 雷達上離中心至少這麼遠，不會壓在自己的頭像上
  static const _refreshEvery = Duration(hours: 6);
  static const _cacheKey = 'places_json_v1';
  static const _etagKey = 'places_etag_v1';

  static List<MoodPlace> places = const [];
  static DateTime? _fetchedAt;
  static bool _loading = false;

  /// 正式版看不到 test 店
  static List<MoodPlace> _parse(String body) {
    final list = (jsonDecode(body) as Map<String, dynamic>)['places'] as List? ?? const [];
    return [
      for (final e in list)
        if (e['test'] != true || !kReleaseMode) MoodPlace.fromJson(Map<String, dynamic>.from(e)),
    ];
  }

  /// 清單有變就回傳 true
  static Future<bool> refresh({bool force = false}) async {
    final last = _fetchedAt;
    if (_loading || (!force && last != null && DateTime.now().difference(last) < _refreshEvery)) return false;
    _loading = true;
    var changed = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (places.isEmpty && cached != null) {
        try { places = _parse(cached); changed = places.isNotEmpty; } catch (_) {}
      }
      final etag = cached == null ? null : prefs.getString(_etagKey);
      final response = await http.get(_listUrl, headers: {'If-None-Match': ?etag}).timeout(const Duration(seconds: 15));
      _fetchedAt = DateTime.now();
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        places = _parse(body);
        changed = true;
        await prefs.setString(_cacheKey, body);
        final newTag = response.headers['etag'];
        if (newTag != null) { await prefs.setString(_etagKey, newTag); } else { await prefs.remove(_etagKey); }
      }
    } catch (e) {
      debugPrint('mood places refresh failed: $e');
    } finally {
      _loading = false;
    }
    return changed;
  }
}

/// App 內提示的頻率與「今天看過了」：只記在手機上
class PlaceHints {
  PlaceHints._();

  static const _historyKey = 'place_hints_v1'; // id → 上次提示的時間（毫秒）
  static const _seenKey = 'place_seen_v1'; // id → 最後一次打開名片的台灣日期
  static const _enabledKey = 'place_hints_enabled';
  static const samePlaceGap = Duration(days: 7);
  static const perDay = 2;

  static Map<String, int> _history = {};
  static Map<String, String> _seen = {};
  static bool enabled = true;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_enabledKey) ?? true;
    try { _history = Map<String, int>.from(jsonDecode(prefs.getString(_historyKey) ?? '{}')); } catch (_) {}
    try { _seen = Map<String, String>.from(jsonDecode(prefs.getString(_seenKey) ?? '{}')); } catch (_) {}
  }

  static Future<void> setEnabled(bool v) async {
    enabled = v;
    await (await SharedPreferences.getInstance()).setBool(_enabledKey, v);
  }

  /// 同一家店 7 天內只提示一次；所有店合計一天（台灣日期）最多 2 次
  @visibleForTesting
  static bool allowed(Map<String, int> history, String id, DateTime now) {
    final last = history[id];
    if (last != null && now.difference(DateTime.fromMillisecondsSinceEpoch(last)) < samePlaceGap) return false;
    final today = _dateKey(taiwanTime(now));
    final todayCount = history.values.where((t) => _dateKey(taiwanTime(DateTime.fromMillisecondsSinceEpoch(t))) == today).length;
    return todayCount < perDay;
  }

  static bool canHint(String id, DateTime now) => enabled && allowed(_history, id, now);

  static Future<void> recordHint(String id, DateTime now) async {
    // 超過 7 天的紀錄已經不影響判斷，順手清掉
    _history.removeWhere((_, t) => now.difference(DateTime.fromMillisecondsSinceEpoch(t)) >= samePlaceGap);
    _history[id] = now.millisecondsSinceEpoch;
    await (await SharedPreferences.getInstance()).setString(_historyKey, jsonEncode(_history));
  }

  static bool seenToday(String id, DateTime now) => _seen[id] == _dateKey(taiwanTime(now));

  static Future<void> markSeen(String id, DateTime now) async {
    final today = _dateKey(taiwanTime(now));
    _seen.removeWhere((_, d) => d != today);
    _seen[id] = today;
    await (await SharedPreferences.getInstance()).setString(_seenKey, jsonEncode(_seen));
  }
}

/// 用手機的地圖 App 走路導航過去
Future<void> openPlaceDirections(MoodPlace p) {
  final url = Platform.isIOS
      ? Uri.parse('https://maps.apple.com/?daddr=${p.lat},${p.lng}&dirflg=w')
      : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${p.lat},${p.lng}&travelmode=walking');
  return launchUrl(url, mode: LaunchMode.externalApplication);
}

/// 雷達上的小燈：150 公尺內慢慢呼吸（約 4 秒一次，亮度 60%～100%）；今天看過名片、或系統減少動態效果時靜止
class MoodPlaceLamp extends StatefulWidget {
  final MoodPlace place;
  final bool breathing;
  final VoidCallback onTap;
  const MoodPlaceLamp({super.key, required this.place, required this.breathing, required this.onTap});

  @override
  State<MoodPlaceLamp> createState() => _MoodPlaceLampState();
}

class _MoodPlaceLampState extends State<MoodPlaceLamp> with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

  bool get _animate => widget.breathing && !MediaQuery.of(context).disableAnimations;

  void _sync() {
    if (_animate) {
      if (!_breath.isAnimating) _breath.repeat(reverse: true);
    } else {
      _breath.stop();
      _breath.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(MoodPlaceLamp old) {
    super.didUpdateWidget(old);
    if (old.breathing != widget.breathing) _sync();
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    return Semantics(
      button: true,
      label: tr.placeLampLabel(p.name, p.openUntilText(DateTime.now()) ?? ''),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        // 走進範圍時慢慢浮現
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: MediaQuery.of(context).disableAnimations ? Duration.zero : const Duration(milliseconds: 900),
          builder: (context, appear, child) => Opacity(opacity: appear, child: child),
          child: SizedBox(
          width: 44, height: 44,
          child: Center(
            child: AnimatedBuilder(
              animation: _breath,
              builder: (context, child) {
                final glow = 0.6 + 0.4 * Curves.easeInOut.transform(_breath.value);
                return Opacity(
                  opacity: glow,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Night.night800.withOpacity(0.9),
                      border: Border.all(color: placeColor, width: 1.2),
                      boxShadow: [BoxShadow(color: placeColor.withOpacity(0.55 * glow), blurRadius: 6 + 10 * glow, spreadRadius: 1)],
                    ),
                    child: child,
                  ),
                );
              },
              child: const Icon(Icons.local_cafe_outlined, color: placeColor, size: 15),
            ),
          ),
          ),
        ),
      ),
    );
  }
}

/// 據點名片：照片、店名、今天營業到幾點、心情故事（點一下翻譯）、地址、電話、導航、回報資料有誤
Future<void> showMoodPlaceCard(BuildContext context, MoodPlace p) {
  PlaceHints.markSeen(p.id, DateTime.now());
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(Night.space4),
      // 不用半透明的玻璃：照片與文字底下透出地圖會很亂
      child: Container(
        decoration: BoxDecoration(
          color: Night.night800,
          borderRadius: BorderRadius.circular(Night.radiusLg),
          border: Border.all(color: Night.glassLine),
          boxShadow: const [Night.lift],
        ),
        child: _PlaceCard(place: p),
      ),
    ),
  );
}

class _PlaceCard extends StatefulWidget {
  final MoodPlace place;
  const _PlaceCard({required this.place});
  @override
  State<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<_PlaceCard> {
  bool _canTranslate = false;
  bool _translating = false;
  String? _translated;
  bool _showTranslated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    ChatTranslator.needsTranslation(widget.place.story, locale).then((v) { if (mounted && v) setState(() => _canTranslate = true); });
  }

  Future<void> _toggleTranslation() async {
    if (!_canTranslate || _translating) return;
    if (_translated != null) { setState(() => _showTranslated = !_showTranslated); return; }
    setState(() => _translating = true);
    String? out;
    try { out = await ChatTranslator.translate(context, widget.place.story, Localizations.localeOf(context)); } catch (_) {}
    if (!mounted) return;
    setState(() { _translating = false; _translated = out; _showTranslated = out != null; });
    if (out == null) showGlassToast(context, tr.translateFailed, icon: Icons.error_outline, danger: true);
  }

  void _call() {
    final digits = widget.place.phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.isNotEmpty) launchUrl(Uri(scheme: 'tel', path: digits));
  }

  void _reportWrong() {
    final p = widget.place;
    launchUrl(Uri(scheme: 'mailto', path: Legal.contactEmail, query: 'subject=${Uri.encodeComponent(tr.placeReportSubject('${p.name} (${p.id})'))}'));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    final openUntil = p.openUntilText(DateTime.now());
    final story = _showTranslated ? _translated! : p.story;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Night.radiusLg),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Stack(children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: p.photoUrl.isEmpty
                  ? const _PhotoFallback()
                  : Image.network(p.photoUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const _PhotoFallback(), semanticLabel: p.name),
            ),
            // 照片底部漸層，讓店名下方的卡片自然接上
            const Positioned(
              left: 0, right: 0, bottom: 0, height: 56,
              child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x000E1433), Night.night800]))),
            ),
            Positioned(
              top: Night.space1, right: Night.space1,
              child: IconButton(
                tooltip: tr.close,
                style: IconButton.styleFrom(backgroundColor: const Color(0x99070B1F)),
                icon: const Icon(Icons.close, color: Night.ink),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(Night.space4, Night.space2, Night.space4, Night.space4),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(p.name, style: Night.title, textAlign: TextAlign.center),
              if (openUntil != null) ...[
                const SizedBox(height: Night.space1),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.nightlight_round, size: 14, color: placeColor),
                  const SizedBox(width: Night.space1),
                  Text(openUntil, style: Night.caption.copyWith(color: Night.inkMuted)),
                ]),
              ],
              if (p.story.isNotEmpty) ...[
                const SizedBox(height: Night.space4),
                Semantics(
                  button: _canTranslate,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggleTranslation,
                    child: Column(children: [
                      Text('「$story」', style: Night.body.copyWith(color: Night.ink, fontSize: 16), textAlign: TextAlign.center),
                      if (_canTranslate) ...[
                        const SizedBox(height: Night.space1),
                        Text(_translating ? tr.translating : (_showTranslated ? tr.translateShowOriginal : tr.translateTap), style: Night.caption, textAlign: TextAlign.center),
                      ],
                    ]),
                  ),
                ),
              ],
              const SizedBox(height: Night.space4),
              _InfoRow(icon: Icons.place_outlined, text: p.address, onTap: () => openPlaceDirections(p)),
              if (p.phone.isNotEmpty) _InfoRow(icon: Icons.call_outlined, text: p.phone, onTap: _call),
              const SizedBox(height: Night.space3),
              NightButton(tr.walkThere, icon: Icons.directions_walk, expand: true, onPressed: () => openPlaceDirections(p)),
              const SizedBox(height: Night.space2),
              Center(
                child: TextButton(
                  onPressed: _reportWrong,
                  child: Text(tr.placeWrongData, style: const TextStyle(color: Night.inkFaint, fontSize: 13)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _InfoRow({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Night.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Night.space2, horizontal: Night.space1),
        child: Row(children: [
          Icon(icon, size: 18, color: placeColor),
          const SizedBox(width: Night.space3),
          Expanded(child: Text(text, style: Night.body.copyWith(fontSize: 14))),
        ]),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Night.night700, Night.night900])),
        child: Center(child: Icon(Icons.local_cafe_outlined, color: placeColor, size: 40)),
      );
}

/// App 內提示（不是系統推播）：上方浮出一張玻璃小卡，點了打開名片，約 6 秒後自動消失。不響、不震動。
OverlayEntry? _currentHint;

void showPlaceHint(BuildContext context, MoodPlace p, {required VoidCallback onOpen}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  _currentHint?.remove();
  late final OverlayEntry entry;
  void close() {
    if (_currentHint == entry) _currentHint = null;
    if (entry.mounted) entry.remove();
  }
  entry = OverlayEntry(builder: (_) => _PlaceHint(place: p, onDone: close, onOpen: () { close(); onOpen(); }));
  _currentHint = entry;
  overlay.insert(entry);
}

class _PlaceHint extends StatefulWidget {
  final MoodPlace place;
  final VoidCallback onDone;
  final VoidCallback onOpen;
  const _PlaceHint({required this.place, required this.onDone, required this.onOpen});
  @override
  State<_PlaceHint> createState() => _PlaceHintState();
}

class _PlaceHintState extends State<_PlaceHint> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 6400))..forward().whenComplete(widget.onDone);
  late final Animation<double> _shown = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 8),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 84),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 8),
  ]).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + Night.space2;
    return Positioned(
      top: top, left: Night.space4, right: Night.space4,
      child: AnimatedBuilder(
        animation: _shown,
        builder: (context, child) => Opacity(
          opacity: _shown.value,
          child: Transform.translate(offset: Offset(0, -16 * (1 - _shown.value)), child: child),
        ),
        child: Material(
          color: Colors.transparent,
          child: Semantics(
            liveRegion: true,
            button: true,
            child: GestureDetector(
              onTap: widget.onOpen,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space3),
                decoration: BoxDecoration(
                  color: Night.night700,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: placeColor.withOpacity(0.6)),
                  boxShadow: [Night.lift, BoxShadow(color: placeColor.withOpacity(0.25), blurRadius: 16)],
                ),
                child: Row(children: [
                  const Icon(Icons.local_cafe_outlined, size: 20, color: placeColor),
                  const SizedBox(width: Night.space3),
                  Expanded(child: Text(tr.placeHint(widget.place.name), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Night.ink, fontSize: 14, height: 1.4))),
                  const Icon(Icons.chevron_right, size: 18, color: Night.inkFaint),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
