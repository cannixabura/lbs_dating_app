import 'l10n/l10n.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'ui/night.dart';

/// 城市燈塔：附近 2 公里內的友善公廁（性別友善／無障礙／親子）。
/// 資料來自環境部「全國公廁建檔資料」，每月同步；伺服器：geo-service/index.js 的 beacon 端點。

const _beaconUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/beacon';
const beaconColor = Night.auroraBlue;

enum BeaconFeature { gender, accessible, family }

extension BeaconFeatureInfo on BeaconFeature {
  String get label => switch (this) {
        BeaconFeature.gender => tr.beaconGender,
        BeaconFeature.accessible => tr.beaconAccessible,
        BeaconFeature.family => tr.beaconFamily,
      };
  IconData get icon => switch (this) {
        BeaconFeature.gender => Icons.diversity_3,
        BeaconFeature.accessible => Icons.accessible,
        BeaconFeature.family => Icons.child_friendly,
      };
}

Map<String, String> get beaconReportReasons => {
  'not_gender': tr.beaconReportNotGender,
  'closed': tr.beaconReportClosed,
  'missing': tr.beaconReportMissing,
};

Map<String, String> get _flagText => {
  'not_gender': tr.beaconFlagNotGender,
  'closed': tr.beaconFlagClosed,
  'missing': tr.beaconFlagMissing,
};

class BeaconToilet {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int distance;
  final bool gender;
  final bool accessible;
  final bool family;
  final bool night;
  final List<String> rooms;
  final List<String> flags;

  BeaconToilet.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'] ?? tr.beaconDefaultName,
        address = j['address'] ?? '',
        lat = (j['lat'] as num).toDouble(),
        lng = (j['lng'] as num).toDouble(),
        distance = (j['distance'] as num?)?.toInt() ?? 0,
        gender = j['gender'] == true,
        accessible = j['accessible'] == true,
        family = j['family'] == true,
        night = j['night'] == true,
        rooms = List<String>.from(j['rooms'] ?? const []),
        flags = List<String>.from(j['flags'] ?? const []);

  bool has(BeaconFeature f) => switch (f) {
        BeaconFeature.gender => gender,
        BeaconFeature.accessible => accessible,
        BeaconFeature.family => family,
      };

  List<BeaconFeature> get features => BeaconFeature.values.where(has).toList();

  /// 標記上的圖示：有性別友善就優先顯示，其次無障礙、親子
  IconData get icon => features.first.icon;
}

String beaconDistance(int m) => m < 1000 ? tr.meters(m) : tr.kilometers((m / 1000).toStringAsFixed(1));

class BeaconApi {
  BeaconApi._();

  static Future<(Map<String, dynamic>?, String?)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_beaconUrl),
        headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) return (data, null);
      return (null, (data['error'] as String?) ?? tr.beaconUnavailable);
    } catch (_) {
      return (null, tr.notConnectedCheckNetwork);
    }
  }

  static Future<List<BeaconToilet>?> nearby(double lat, double lng) async {
    final (data, error) = await _call({'action': 'nearby', 'lat': lat, 'lng': lng});
    if (error != null) return null;
    return ((data!['data'] as List?) ?? const []).map((e) => BeaconToilet.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<String?> report(String id, String reason) async => (await _call({'action': 'report', 'id': id, 'reason': reason})).$2;
}

/// 用手機的地圖 App 走路導航過去
Future<void> openBeaconDirections(BeaconToilet t) {
  final url = Platform.isIOS
      ? Uri.parse('https://maps.apple.com/?daddr=${t.lat},${t.lng}&dirflg=w')
      : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${t.lat},${t.lng}&travelmode=walking');
  return launchUrl(url, mode: LaunchMode.externalApplication);
}

/// 雷達上的燈塔標記：畫在信封與氣泡底下，小而安靜
class BeaconMarker extends StatelessWidget {
  final BeaconToilet toilet;
  final VoidCallback onTap;
  const BeaconMarker({super.key, required this.toilet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = toilet.flags.isEmpty ? beaconColor : Night.inkFaint;
    return Semantics(
      button: true,
      label: tr.beaconMarkerLabel(toilet.features.map((f) => f.label).join(tr.listSeparator), toilet.name, beaconDistance(toilet.distance)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 40, height: 40,
          child: Center(
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Night.night800.withOpacity(0.9),
                border: Border.all(color: color, width: 1.2),
                boxShadow: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 8)],
              ),
              child: Icon(toilet.icon, color: color, size: 15),
            ),
          ),
        ),
      ),
    );
  }
}

/// 地圖左下角的燈塔開關：關閉時只有圖示與橢圓外框，打開後顯示圖示與數量，上方列出三種篩選（只有圖示）
class BeaconControls extends StatelessWidget {
  final bool on;
  final Set<BeaconFeature> filters;
  final int count;
  final VoidCallback onToggle;
  final ValueChanged<BeaconFeature> onFilter;
  const BeaconControls({super.key, required this.on, required this.filters, required this.count, required this.onToggle, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      if (on)
        for (final f in BeaconFeature.values) ...[
          _FilterButton(feature: f, selected: filters.contains(f), onTap: () => onFilter(f)),
          const SizedBox(height: Night.space2),
        ],
      Semantics(
        button: true,
        toggled: on,
        label: on ? tr.beaconToggleOff(count) : tr.beaconToggleOn,
        child: GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 44,
            constraints: const BoxConstraints(minWidth: 56),
            padding: const EdgeInsets.symmetric(horizontal: Night.space3),
            decoration: BoxDecoration(
              color: Night.glassFill,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: on ? beaconColor : Night.glassLine),
              boxShadow: on ? [BoxShadow(color: beaconColor.withOpacity(0.4), blurRadius: 14)] : null,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.wc, size: 20, color: on ? beaconColor : Night.inkMuted),
              if (on) ...[
                const SizedBox(width: Night.space1),
                Text('· $count', style: const TextStyle(color: Night.ink, fontSize: 14, letterSpacing: 1)),
              ],
            ]),
          ),
        ),
      ),
    ]);
  }
}

class _FilterButton extends StatelessWidget {
  final BeaconFeature feature;
  final bool selected;
  final VoidCallback onTap;
  const _FilterButton({required this.feature, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: tr.beaconFilterOnly(feature.label),
      child: Tooltip(
        message: feature.label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? beaconColor.withOpacity(0.22) : Night.glassFill,
              border: Border.all(color: selected ? beaconColor : Night.glassLine),
            ),
            child: Icon(feature.icon, size: 20, color: selected ? beaconColor : Night.inkMuted),
          ),
        ),
      ),
    );
  }
}

/// 點標記：地點、設施、晚上是否可能有開、導航與回報
Future<void> showBeaconSheet(BuildContext context, BeaconToilet t) {
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
        child: _BeaconDetail(toilet: t),
      ),
    ),
  );
}

class _BeaconDetail extends StatefulWidget {
  final BeaconToilet toilet;
  const _BeaconDetail({required this.toilet});
  @override
  State<_BeaconDetail> createState() => _BeaconDetailState();
}

class _BeaconDetailState extends State<_BeaconDetail> {
  bool _reporting = false;
  String? _reported;

  Future<void> _report(String reason) async {
    setState(() => _reporting = true);
    final error = await BeaconApi.report(widget.toilet.id, reason);
    if (!mounted) return;
    setState(() { _reporting = false; if (error == null) _reported = reason; });
    if (error != null) showGlassToast(context, error, icon: Icons.error_outline, danger: true);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.toilet;
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Stack(alignment: Alignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Text(t.name, style: Night.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Align(alignment: Alignment.centerRight, child: IconButton(tooltip: tr.close, icon: const Icon(Icons.close, color: Night.inkMuted), onPressed: () => Navigator.pop(context))),
        ]),
        Text('${beaconDistance(t.distance)} · ${t.address}', style: Night.caption, textAlign: TextAlign.center),
        const SizedBox(height: Night.space3),
        Wrap(alignment: WrapAlignment.center, spacing: Night.space2, runSpacing: Night.space2, children: [
          for (final f in t.features)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: beaconColor)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(f.icon, size: 16, color: beaconColor),
                const SizedBox(width: Night.space1),
                Text(f.label, style: const TextStyle(color: Night.ink, fontSize: 13)),
              ]),
            ),
        ]),
        const SizedBox(height: Night.space3),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(t.night ? Icons.nightlight_round : Icons.wb_sunny_outlined, size: 16, color: t.night ? Night.cityAmber : Night.inkFaint),
          const SizedBox(width: Night.space1),
          Text(t.night ? tr.beaconMaybeOpenNight : tr.beaconMaybeDaytime, style: Night.body.copyWith(fontSize: 14)),
        ]),
        if (t.rooms.isNotEmpty) ...[
          const SizedBox(height: Night.space2),
          Text(t.rooms.join(tr.listSeparator), style: Night.caption, textAlign: TextAlign.center),
        ],
        for (final f in t.flags) ...[
          const SizedBox(height: Night.space2),
          Text(_flagText[f] ?? '', style: Night.caption.copyWith(color: Night.danger), textAlign: TextAlign.center),
        ],
        const SizedBox(height: Night.space4),
        NightButton(tr.walkThere, icon: Icons.directions_walk, expand: true, onPressed: () => openBeaconDirections(t)),
        const SizedBox(height: Night.space4),
        Text(tr.beaconWrongData, style: Night.caption, textAlign: TextAlign.center),
        const SizedBox(height: Night.space1),
        if (_reported != null)
          Text(tr.beaconThanks(beaconReportReasons[_reported] ?? ''), style: Night.caption.copyWith(color: Night.inkMuted), textAlign: TextAlign.center)
        else
          Wrap(alignment: WrapAlignment.center, spacing: Night.space2, children: [
            for (final e in beaconReportReasons.entries)
              if (e.key != 'not_gender' || t.gender)
                TextButton(
                  onPressed: _reporting ? null : () => _report(e.key),
                  child: Text(e.value, style: const TextStyle(color: Night.inkMuted, fontSize: 13)),
                ),
          ]),
        const SizedBox(height: Night.space2),
        Text(tr.beaconSource, style: Night.caption, textAlign: TextAlign.center),
      ]),
    );
  }
}
