import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/night.dart';

/// 我的心情軌跡：只存在這支手機上（SharedPreferences），永遠不上傳。
class MoodTrailEntry {
  final String mood;
  final double lat;
  final double lng;
  final DateTime at;
  const MoodTrailEntry(this.mood, this.lat, this.lng, this.at);

  Map<String, dynamic> toJson() => {'m': mood, 'a': lat, 'o': lng, 't': at.millisecondsSinceEpoch};
  factory MoodTrailEntry.fromJson(Map<String, dynamic> j) =>
      MoodTrailEntry(j['m'] as String, (j['a'] as num).toDouble(), (j['o'] as num).toDouble(), DateTime.fromMillisecondsSinceEpoch(j['t'] as int));
}

class MoodTrail {
  MoodTrail._();

  static const _key = 'mood_trail_v1';
  static const _enabledKey = 'mood_trail_enabled';
  static const _maxEntries = 400;
  static const _samePlaceMeters = 300.0;
  static const _samePlaceWindow = Duration(hours: 3);

  static Future<bool> isEnabled() async => (await SharedPreferences.getInstance()).getBool(_enabledKey) ?? true;

  static Future<void> setEnabled(bool enabled) async => (await SharedPreferences.getInstance()).setBool(_enabledKey, enabled);

  static Future<List<MoodTrailEntry>> entries() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).map((e) => MoodTrailEntry.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clear() async => (await SharedPreferences.getInstance()).remove(_key);

  /// 記一筆：心情改變、或離開上一個地點 300 公尺以上、或距上一筆超過 3 小時才記，避免同地點重複
  static Future<void> record(String mood, double lat, double lng) async {
    if (mood.trim().isEmpty || !await isEnabled()) return;
    final list = await entries();
    final now = DateTime.now();
    if (list.isNotEmpty) {
      final last = list.last;
      final samePlace = Geolocator.distanceBetween(last.lat, last.lng, lat, lng) < _samePlaceMeters;
      if (last.mood == mood && samePlace && now.difference(last.at) < _samePlaceWindow) return;
    }
    // 只在手機上，存到約 10 公尺的精度就夠了
    list.add(MoodTrailEntry(mood, double.parse(lat.toStringAsFixed(4)), double.parse(lng.toStringAsFixed(4)), now));
    final trimmed = list.length > _maxEntries ? list.sublist(list.length - _maxEntries) : list;
    await (await SharedPreferences.getInstance()).setString(_key, jsonEncode(trimmed.map((e) => e.toJson()).toList()));
  }

  /// 週回顧：最常出現的心情、次數、不同地點數（約 300 公尺內算同一個地方）
  static ({String? topMood, int topCount, int places, int total}) weeklyRecap(List<MoodTrailEntry> all) {
    final since = DateTime.now().subtract(const Duration(days: 7));
    final week = all.where((e) => e.at.isAfter(since)).toList();
    final counts = <String, int>{};
    for (final e in week) {
      final label = moodStyleOf(e.mood).$1;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    String? top;
    int topCount = 0;
    counts.forEach((k, v) { if (v > topCount) { top = k; topCount = v; } });
    final places = week.map((e) => '${(e.lat / 0.003).round()}:${(e.lng / 0.003).round()}').toSet().length;
    return (topMood: top, topCount: topCount, places: places, total: week.length);
  }
}

String _colorHex(Color c) => '#${(c.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

class MoodTrailScreen extends StatefulWidget {
  const MoodTrailScreen({super.key});

  @override
  State<MoodTrailScreen> createState() => _MoodTrailScreenState();
}

class _MoodTrailScreenState extends State<MoodTrailScreen> {
  List<MoodTrailEntry> _entries = [];
  bool _enabled = true;
  String? _style;
  MapLibreMapController? _map;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await MoodTrail.entries();
    final enabled = await MoodTrail.isEnabled();
    final style = await rootBundle.loadString('assets/map/night_style.json');
    if (mounted) setState(() { _entries = entries; _enabled = enabled; _style = style; });
  }

  Future<void> _drawTrail() async {
    final map = _map;
    if (map == null || _entries.isEmpty) return;
    // 每個心情一個發光點：外層大而模糊的光暈 + 內層實心點
    for (final e in _entries) {
      final hex = _colorHex(moodStyleOf(e.mood).$2);
      final p = LatLng(e.lat, e.lng);
      await map.addCircle(CircleOptions(geometry: p, circleRadius: 16, circleColor: hex, circleOpacity: 0.25, circleBlur: 1));
      await map.addCircle(CircleOptions(geometry: p, circleRadius: 5, circleColor: hex, circleOpacity: 0.95, circleStrokeWidth: 1, circleStrokeColor: '#070b1f'));
    }
    final lats = _entries.map((e) => e.lat), lngs = _entries.map((e) => e.lng);
    final sw = LatLng(lats.reduce(min) - 0.002, lngs.reduce(min) - 0.002);
    final ne = LatLng(lats.reduce(max) + 0.002, lngs.reduce(max) + 0.002);
    await map.moveCamera(CameraUpdate.newLatLngBounds(LatLngBounds(southwest: sw, northeast: ne), left: 40, top: 40, right: 40, bottom: 40));
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (c) => Dialog(
        backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
        child: GlassCard(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('清除心情軌跡', style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            const Text('這支手機上的所有心情軌跡都會刪除，無法復原。', style: Night.body, textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
            Row(children: [
              Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(c, false))),
              const SizedBox(width: Night.space2),
              Expanded(child: NightButton('清除', kind: NightButtonKind.danger, onPressed: () => Navigator.pop(c, true))),
            ]),
          ]),
        ),
      ),
    );
    if (ok != true) return;
    await MoodTrail.clear();
    await _map?.clearCircles();
    if (mounted) setState(() => _entries = []);
  }

  @override
  Widget build(BuildContext context) {
    final recap = MoodTrail.weeklyRecap(_entries);
    final byDay = <String, List<MoodTrailEntry>>{};
    for (final e in _entries.reversed) {
      byDay.putIfAbsent('${e.at.month} 月 ${e.at.day} 日', () => []).add(e);
    }

    return Scaffold(
      backgroundColor: Night.night900,
      appBar: AppBar(
        backgroundColor: Night.night900,
        foregroundColor: Night.ink,
        elevation: 0,
        title: const Text('我的心情軌跡', style: TextStyle(fontSize: 17, letterSpacing: 1)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Night.space4, 0, Night.space4, Night.space8),
        children: [
          const Text('只存在你的手機上，不會上傳到任何地方。', style: Night.caption, textAlign: TextAlign.center),
          const SizedBox(height: Night.space4),
          GlassCard(
            child: recap.total == 0
                ? const Text('這週還沒有心情軌跡。每次寫下心情、或走到新的地方，這裡都會多一道光。', style: Night.body, textAlign: TextAlign.center)
                : Column(children: [
                    const Text('這週的你', style: Night.caption),
                    const SizedBox(height: Night.space2),
                    Text.rich(
                      TextSpan(style: const TextStyle(color: Night.ink, fontSize: 17, height: 1.6), children: [
                        const TextSpan(text: '最常感到「'),
                        TextSpan(text: recap.topMood, style: TextStyle(color: moodStyleOf(recap.topMood ?? '').$2, fontWeight: FontWeight.w600)),
                        TextSpan(text: '」，共 ${recap.topCount} 次'),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Night.space1),
                    Text('在 ${recap.places} 個不同的地方，留下了 ${recap.total} 道心情', style: Night.body, textAlign: TextAlign.center),
                  ]),
          ),
          const SizedBox(height: Night.space4),
          if (_entries.isNotEmpty && _style != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(Night.radiusLg),
              child: SizedBox(
                height: 300,
                child: MapLibreMap(
                  styleString: _style!,
                  initialCameraPosition: CameraPosition(target: LatLng(_entries.last.lat, _entries.last.lng), zoom: 13),
                  onMapCreated: (c) => _map = c,
                  onStyleLoadedCallback: _drawTrail,
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  logoViewMargins: const Point(-100, -100),
                  attributionButtonMargins: const Point(-100, -100),
                ),
              ),
            ),
          if (_entries.isNotEmpty) const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text('© OpenMapTiles © OpenStreetMap', style: TextStyle(color: Night.inkFaint, fontSize: 10)),
          ),
          for (final day in byDay.entries) ...[
            Padding(padding: const EdgeInsets.only(top: Night.space6, bottom: Night.space2), child: Text(day.key, style: Night.caption)),
            for (final e in day.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: moodStyleOf(e.mood).$2,
                      boxShadow: [BoxShadow(color: moodStyleOf(e.mood).$2.withOpacity(0.6), blurRadius: 6)])),
                  const SizedBox(width: Night.space3),
                  Expanded(child: Text(e.mood, style: const TextStyle(color: Night.ink, fontSize: 15), overflow: TextOverflow.ellipsis)),
                  Text('${e.at.hour.toString().padLeft(2, '0')}:${e.at.minute.toString().padLeft(2, '0')}', style: Night.caption),
                ]),
              ),
          ],
          const SizedBox(height: Night.space6),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space2),
            child: Row(children: [
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('記錄我的心情軌跡', style: TextStyle(color: Night.ink, fontSize: 15)),
                  SizedBox(height: 2),
                  Text('關閉後不再記錄新的軌跡', style: Night.caption),
                ]),
              ),
              Switch(
                value: _enabled,
                activeThumbColor: Night.onDeep,
                activeTrackColor: Night.deepViolet,
                inactiveTrackColor: Night.night700,
                onChanged: (v) { setState(() => _enabled = v); MoodTrail.setEnabled(v); },
              ),
            ]),
          ),
          if (_entries.isNotEmpty) ...[
            const SizedBox(height: Night.space3),
            NightButton('清除心情軌跡', kind: NightButtonKind.danger, icon: Icons.delete_outline, onPressed: _confirmClear),
          ],
        ],
      ),
    );
  }
}
