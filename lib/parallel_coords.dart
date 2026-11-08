import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'l10n/l10n.dart';
import 'mood_card.dart';
import 'parallel_universe.dart';
import 'passport.dart';
import 'ui/night.dart';

const _coordsUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/parallelCoords';

/// 一座平行城市裡，你對到的那一點（outside = 落在城市範圍外，不給座標）
class ParallelMirror {
  final String id, name, country;
  final double? lat, lng;
  const ParallelMirror({required this.id, required this.name, required this.country, this.lat, this.lng});
  bool get outside => lat == null || lng == null;
}

class ParallelCoords {
  final String homeName;
  final double east, north; // 離自家城市中心幾公里（已模糊化）
  final List<ParallelMirror> list;
  const ParallelCoords({required this.homeName, required this.east, required this.north, required this.list});
  double get km => sqrt(east * east + north * north);
}

/// 向伺服器要你在每座平行城市的位置；不在支援的城市回傳 null，失敗丟例外
Future<ParallelCoords?> fetchParallelCoords(double lat, double lng) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  final response = await http
      .post(Uri.parse(_coordsUrl),
          headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
          body: jsonEncode({'lat': lat, 'lng': lng, 'lang': currentLanguageTag}))
      .timeout(const Duration(seconds: 20));
  final data = jsonDecode(response.body);
  if (data is! Map || data['success'] != true) throw Exception('parallelCoords failed');
  final home = data['home'];
  if (home is! Map) return null;
  return ParallelCoords(
    homeName: '${home['name'] ?? ''}',
    east: (data['east'] as num?)?.toDouble() ?? 0,
    north: (data['north'] as num?)?.toDouble() ?? 0,
    list: [
      for (final c in (data['list'] as List? ?? const []))
        if (c is Map)
          ParallelMirror(
            id: '${c['id']}', name: '${c['name']}', country: '${c['country']}',
            lat: (c['lat'] as num?)?.toDouble(), lng: (c['lng'] as num?)?.toDouble(),
          ),
    ],
  );
}

/// 國家旗幟（城市分組用）
const _flags = {
  'tw': '🇹🇼', 'jp': '🇯🇵', 'kr': '🇰🇷', 'hk': '🇭🇰', 'mo': '🇲🇴', 'sg': '🇸🇬', 'my': '🇲🇾',
  'id': '🇮🇩', 'vn': '🇻🇳', 'th': '🇹🇭', 'ph': '🇵🇭', 'au': '🇦🇺',
  'nz': '🇳🇿', 'in': '🇮🇳', 'br': '🇧🇷', 'ar': '🇦🇷', 'za': '🇿🇦',
};

Locale _geocodeLocale() => switch (currentLanguageTag) {
      'zh-Hant' => const Locale('zh', 'TW'),
      'zh-Hans' => const Locale('zh', 'CN'),
      final tag => Locale(tag),
    };

final _placeCache = <String, String>{};

/// 用手機內建的地址查詢，把座標變成「那一帶」的地名（不經過我們的伺服器）
Future<String> _placeName(ParallelMirror m) async {
  if (m.outside) return tr.parallelCoordsOutside;
  final key = '${m.lat},${m.lng},$currentLanguageTag';
  final cached = _placeCache[key];
  if (cached != null) return cached;
  final marks = await Geocoding(locale: _geocodeLocale()).placemarkFromCoordinates(m.lat!, m.lng!);
  String label = tr.parallelCoordsSea;
  for (final p in marks) {
    // 永遠不顯示中國大陸的地名（例如香港、澳門邊界）
    if ((p.isoCountryCode ?? '').toUpperCase() == 'CN') {
      label = tr.parallelCoordsOutside;
      break;
    }
    final parts = <String>[];
    for (final s in [p.subLocality, p.locality ?? p.subAdministrativeArea]) {
      final t = (s ?? '').trim();
      if (t.isNotEmpty && !parts.contains(t)) parts.add(t);
    }
    if (parts.isNotEmpty) {
      label = parts.join(' · ');
      break;
    }
    // 海上：沒有行政區時，用海灣或海的名稱
    final name = (p.name ?? '').trim();
    if (name.isNotEmpty && (p.street ?? '').trim().isEmpty) {
      label = name;
      break;
    }
  }
  _placeCache[key] = label;
  return label;
}

/// 平行座標面板：你現在的位置，在每座平行城市大約是哪一帶
Future<void> showParallelCoords(BuildContext context, {required double lat, required double lng}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(Night.space3),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: GlassCard(child: _ParallelCoordsSheet(lat: lat, lng: lng)),
      ),
    ),
  );
}

class _ParallelCoordsSheet extends StatefulWidget {
  final double lat, lng;
  const _ParallelCoordsSheet({required this.lat, required this.lng});

  @override
  State<_ParallelCoordsSheet> createState() => _ParallelCoordsSheetState();
}

class _ParallelCoordsSheetState extends State<_ParallelCoordsSheet> {
  ParallelCoords? _coords;
  bool _loading = true, _failed = false, _noCity = false;
  String? _country;
  ParallelMirror? _city;
  String? _place;
  bool _placeLoading = false;
  int _lookup = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _failed = false; });
    try {
      final c = await fetchParallelCoords(widget.lat, widget.lng);
      if (!mounted) return;
      if (c == null || c.list.isEmpty) {
        setState(() { _loading = false; _noCity = true; });
        return;
      }
      setState(() { _coords = c; _loading = false; });
      _pickCountry(c.list.first.country);
    } catch (_) {
      if (mounted) setState(() { _loading = false; _failed = true; });
    }
  }

  List<String> get _countries {
    final out = <String>[];
    for (final c in _coords?.list ?? const <ParallelMirror>[]) {
      if (!out.contains(c.country)) out.add(c.country);
    }
    return out;
  }

  void _pickCountry(String country) {
    final first = _coords!.list.firstWhere((c) => c.country == country);
    setState(() => _country = country);
    _pickCity(first);
  }

  Future<void> _pickCity(ParallelMirror m) async {
    final n = ++_lookup;
    setState(() { _city = m; _place = null; _placeLoading = true; });
    String place;
    try {
      place = await _placeName(m);
    } catch (_) {
      place = tr.parallelCoordsFailed;
    }
    if (!mounted || n != _lookup) return;
    setState(() { _place = place; _placeLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final c = _coords;
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SheetTitle(tr.parallelCoords, closeTooltip: tr.close),
        const SizedBox(height: Night.space3),
        if (_loading)
          const Padding(padding: EdgeInsets.all(Night.space6), child: Center(child: CircularProgressIndicator(color: Night.auroraViolet)))
        else if (_noCity)
          Text(tr.parallelUniverseNoCity, style: Night.body, textAlign: TextAlign.center)
        else if (_failed || c == null)
          Column(children: [
            Text(tr.parallelCoordsFailed, style: Night.body, textAlign: TextAlign.center),
            TextButton(onPressed: _load, child: Text(tr.tryAgain)),
          ])
        else ...[
          // 離自家城市中心多遠、往哪個方向（箭頭指向你所在的方向）
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Transform.rotate(
              angle: atan2(c.east, c.north),
              child: const Icon(Icons.navigation, color: Night.auroraViolet, size: 18),
            ),
            const SizedBox(width: Night.space2),
            Flexible(child: Text(tr.parallelCoordsHome(c.homeName, c.km.toStringAsFixed(1)), style: Night.body, textAlign: TextAlign.center)),
          ]),
          const SizedBox(height: Night.space3),
          // 結果放在最上面：日本城市很多，放在清單下面會被擠出畫面
          if (_city != null)
            Container(
              padding: const EdgeInsets.all(Night.space4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.auroraViolet.withOpacity(0.5))),
              child: Column(children: [
                Text(tr.parallelCoordsIn(_city!.name), style: Night.body, textAlign: TextAlign.center),
                const SizedBox(height: Night.space2),
                _placeLoading
                    ? const SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 2, color: Night.auroraViolet))
                    : Text('📍 ${_place ?? ''}', style: Night.title.copyWith(color: Night.auroraViolet), textAlign: TextAlign.center),
              ]),
            ),
          const SizedBox(height: Night.space3),
          if (_city != null) Text(tr.parallelCoordsNote(_city!.name), style: Night.caption, textAlign: TextAlign.center),
          // 分享卡只寫城市、不寫地名：從卡片推不回你在哪一區
          if (_city != null) ...[
            const SizedBox(height: Night.space3),
            Center(child: NightButton(tr.parallelCoordsShare, icon: Icons.ios_share, onPressed: () => showParallelCityCard(context, city: _city!.name))),
          ],
          // 平行護照的入口
          Center(
            child: TextButton.icon(
              onPressed: () => showPassport(context),
              icon: const Icon(Icons.verified_outlined, size: 18, color: Night.auroraViolet),
              label: ValueListenableBuilder<List<PassportStamp>>(
                valueListenable: PassportState.stamps,
                builder: (context, stamps, _) => Text('${tr.passportTitle} · ${tr.passportCount(stamps.length)}', style: const TextStyle(color: Night.auroraViolet)),
              ),
            ),
          ),
          const SizedBox(height: Night.space2),
          SizedBox(
            height: 40,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final k in _countries)
                Padding(
                  padding: const EdgeInsets.only(right: Night.space2),
                  child: ChoiceChip(
                    label: Text(_flags[k] ?? k, style: const TextStyle(fontSize: 20)),
                    selected: k == _country,
                    onSelected: (_) => _pickCountry(k),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: Night.space2),
          Wrap(spacing: Night.space2, runSpacing: Night.space2, alignment: WrapAlignment.center, children: [
            for (final m in c.list.where((m) => m.country == _country))
              ChoiceChip(
                label: Text(m.name),
                selected: m.id == _city?.id,
                onSelected: (_) => _pickCity(m),
              ),
          ]),
        ],
      ]),
    );
  }
}

/// 雷達右上角、平行宇宙開關左邊的小按鈕：只在開啟平行宇宙且身在支援的城市時出現
class ParallelCoordsButton extends StatelessWidget {
  final Position position;
  const ParallelCoordsButton({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: parallelUniverseOn,
      builder: (context, on, _) => ValueListenableBuilder<String?>(
        valueListenable: parallelHomeCity,
        builder: (context, city, _) {
          if (!on || city == null || city.isEmpty) return const SizedBox.shrink();
          return Semantics(
            button: true,
            label: tr.parallelCoords,
            child: Tooltip(
              message: tr.parallelCoords,
              child: GestureDetector(
                onTap: () => showParallelCoords(context, lat: position.latitude, lng: position.longitude),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: Night.glassFill, shape: BoxShape.circle, border: Border.all(color: Night.auroraViolet.withOpacity(0.6))),
                  child: const Icon(Icons.travel_explore, size: 22, color: Night.auroraViolet),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
