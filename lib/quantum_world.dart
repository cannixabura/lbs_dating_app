import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 量子世界：全世界共用的同一個房間（規格：docs/quantum-world-spec.md，伺服器：geo-service/quantum.js）。
/// 以台北 101 為原點排成蜂巢；畫面上的位置只有「入場席位＋入場後走了多遠」，不是任何人的真實位置。
/// 每次打開 App 都是關閉；進入時暫時離開一般雷達和平行宇宙。
// 本機開發可以用 --dart-define=QUANTUM_URL=http://localhost:8787 指向自己電腦上的伺服器
const _quantumUrl = String.fromEnvironment('QUANTUM_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/quantum');

const quantumOrigin = (lat: 25.033964, lng: 121.564468); // 台北 101
const quantumSpacingMeters = 100.0;
const quantumHostRings = 3; // 第 1～3 圈保留給量子集會主持人
const _metersPerDegLat = 111320.0;

/// 這次入場的狀態：席位、顯示位置（101 附近）、在線人數
class QuantumSession {
  final String code;
  final int ring;
  final double lat, lng; // 自己在量子世界的顯示位置
  final double east, north; // 伺服器累計的位移（公尺）
  final bool quiet;
  final int online;
  final Map<String, int> regions;
  const QuantumSession({required this.code, required this.ring, required this.lat, required this.lng,
      this.east = 0, this.north = 0, this.quiet = false, this.online = 0, this.regions = const {}});

  /// 席位中心（不含走過的位移）
  ({double east, double north}) get seatCenter {
    final here = quantumLocal(lat, lng);
    return (east: here.east - east, north: here.north - north);
  }

  QuantumSession copyWith({Map<String, dynamic>? me, bool? quiet, int? online, Map<String, int>? regions}) => QuantumSession(
        code: me?['code'] as String? ?? code,
        ring: (me?['ring'] as num?)?.toInt() ?? ring,
        lat: (me?['lat'] as num?)?.toDouble() ?? lat,
        lng: (me?['lng'] as num?)?.toDouble() ?? lng,
        east: (me?['east'] as num?)?.toDouble() ?? east,
        north: (me?['north'] as num?)?.toDouble() ?? north,
        quiet: quiet ?? this.quiet,
        online: online ?? this.online,
        regions: regions ?? this.regions,
      );

  static QuantumSession fromMe(Map<String, dynamic> me, {bool quiet = false}) =>
      const QuantumSession(code: '', ring: 0, lat: 0, lng: 0).copyWith(me: me, quiet: quiet);
}

final quantumSession = ValueNotifier<QuantumSession?>(null);
bool get quantumOn => quantumSession.value != null;

// ---------- 蜂巢 ----------

/// 第 ring 圈、第 index 號（0 起算，從正北順時針）的席位中心：離 101 往東、往北幾公尺（和伺服器同一套公式）
({double east, double north}) quantumSeatOffset(int ring, int index) {
  final side = index ~/ ring, step = index % ring;
  ({double east, double north}) corner(int k) {
    final bearing = (k % 6) * pi / 3;
    return (east: sin(bearing) * ring * quantumSpacingMeters, north: cos(bearing) * ring * quantumSpacingMeters);
  }
  final a = corner(side), b = corner(side + 1);
  return (east: a.east + (b.east - a.east) * step / ring, north: a.north + (b.north - a.north) * step / ring);
}

({double east, double north}) quantumLocal(double lat, double lng) => (
      east: (lng - quantumOrigin.lng) * _metersPerDegLat * cos(quantumOrigin.lat * pi / 180),
      north: (lat - quantumOrigin.lat) * _metersPerDegLat,
    );

/// 從 from 走到 to 的位移（往東、往北幾公尺）
({double east, double north}) metersBetween(double fromLat, double fromLng, double toLat, double toLng) => (
      east: (toLng - fromLng) * _metersPerDegLat * cos(fromLat * pi / 180),
      north: (toLat - fromLat) * _metersPerDegLat,
    );

/// 入場後走了多遠：記住入場那一刻的真實位置，只把位移公尺數送給伺服器
class QuantumWalk {
  final double anchorLat, anchorLng;
  final double baseEast, baseNorth; // 回到原本席位時，接著伺服器的累計位移
  const QuantumWalk(this.anchorLat, this.anchorLng, {this.baseEast = 0, this.baseNorth = 0});

  /// Apple 5.1.2(i)：每次顯示位置都要使用者自己打卡，不能自動更新。
  /// 所以席位固定在入場那一刻，走路不會移動；想換位置要離開再進入（再打卡一次）。
  /// [lat]、[lng] 保留參數只為了相容呼叫端，不再使用。
  ({double east, double north}) at(double lat, double lng) => (east: baseEast, north: baseNorth);
}

// ---------- 不開放的地區 ----------

// 中國大陸的簡化外框（經度, 緯度），和 geo-service/quantum.js 的 MAINLAND_CHINA 相同（測試會比對）
const _mainlandChina = [
  [135.2, 48.5], [134.0, 47.4], [133.3, 45.6], [131.9, 45.3], [131.0, 44.9], [131.3, 44.0], [130.7, 42.3],
  [129.9, 43.0], [129.0, 42.3], [128.0, 41.9], [126.6, 41.7], [124.3, 39.8], [123.0, 37.6], [122.9, 35.0],
  [122.5, 32.0], [123.0, 30.5], [122.0, 28.5], [120.6, 27.0], [119.9, 25.5], [119.0, 24.9], [117.3, 23.4],
  [116.2, 22.4], [114.4, 22.1], [113.6, 21.9], [111.6, 21.3], [111.3, 19.6], [110.3, 17.8], [108.4, 18.1],
  [108.3, 20.6], [108.1, 21.5], [107.35, 21.65], [106.75, 22.0], [106.8, 22.9], [105.9, 23.0], [105.3, 23.4],
  [104.6, 22.9], [104.0, 22.6], [103.0, 22.8], [102.14, 22.45], [101.75, 22.45], [101.6, 21.2], [101.15, 21.1],
  [100.1, 21.45], [99.2, 22.1], [99.5, 22.9], [98.7, 23.9], [97.6, 23.9], [97.6, 24.8], [98.7, 25.8],
  [98.7, 27.5], [97.4, 28.3], [96.1, 29.5], [95.4, 29.1], [94.0, 29.0], [92.0, 27.8], [91.6, 27.9],
  [90.0, 28.3], [89.1, 27.3], [88.8, 28.1], [88.0, 27.9], [86.9, 27.9], [85.0, 28.6], [84.0, 29.2],
  [81.5, 30.4], [81.0, 30.2], [79.0, 31.3], [78.7, 32.5], [79.5, 32.7], [78.0, 35.5], [75.4, 36.9],
  [74.8, 37.2], [74.9, 38.4], [73.5, 39.4], [73.9, 39.8], [75.4, 40.6], [78.0, 41.1], [80.2, 42.2],
  [80.2, 44.9], [82.6, 45.2], [82.5, 46.4], [83.1, 47.2], [85.5, 47.0], [86.0, 48.5], [87.4, 49.2],
  [88.0, 49.3], [90.0, 47.9], [91.0, 46.6], [90.8, 45.3], [93.5, 44.9], [95.4, 44.2], [96.4, 42.7],
  [100.0, 42.6], [105.0, 41.6], [107.0, 42.3], [110.4, 42.8], [111.9, 43.75], [113.6, 44.8], [116.5, 46.0],
  [117.4, 46.6], [119.9, 46.75], [118.5, 47.9], [117.4, 47.7], [115.6, 47.9], [116.7, 49.9], [117.8, 49.6],
  [119.3, 50.3], [120.8, 52.6], [122.4, 53.6], [125.5, 53.2], [127.6, 50.3], [130.6, 48.9], [132.5, 47.8],
  [134.7, 48.4],
];

bool _insidePolygon(double lat, double lng, List<List<double>> polygon) {
  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final xi = polygon[i][0], yi = polygon[i][1], xj = polygon[j][0], yj = polygon[j][1];
    if ((yi > lat) != (yj > lat) && lng < (xj - xi) * (lat - yi) / (yj - yi) + xi) inside = !inside;
  }
  return inside;
}

double _km(double lat1, double lng1, double lat2, double lng2) => Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;

/// 外框裡屬於台灣、香港、澳門的地方（和 geo-service/parallel.js 的城市範圍相同）
bool _openInsideOutline(double lat, double lng) {
  if (lat >= 24.38 && lat <= 24.535 && lng >= 118.21 && lng <= 118.48) return true; // 金門
  const matsu = [[26.155, 119.935, 4.0], [26.225, 119.995, 3.0], [25.965, 119.95, 3.0], [26.365, 120.49, 3.0]];
  if (matsu.any((c) => _km(c[0], c[1], lat, lng) <= c[2])) return true;
  if (_km(23.5667, 119.5660, lat, lng) <= 35) return true; // 澎湖
  if (lat >= 21.85 && lat <= 25.35 && lng >= 119.95 && lng <= 122.1) return true; // 台灣本島
  // 香港、澳門：北邊的深圳、珠海、橫琴不算
  final border = (lng > 113.75 && lng < 114.65 && lat > 22.505) ||
      (lng > 113.45 && lng < 113.70 && lat > 22.214) ||
      (lng > 113.45 && lng < 113.556 && lat > 22.08 && lat < 22.17);
  if (border) return false;
  return _km(22.3193, 114.1694, lat, lng) <= 26 || _km(22.1757, 113.5560, lat, lng) <= 7;
}

/// 中國大陸一律不開放量子世界；在場期間移動進去也會自動離開
bool isQuantumClosedAt(double lat, double lng) => _insidePolygon(lat, lng, _mainlandChina) && !_openInsideOutline(lat, lng);

// ---------- API ----------

class QuantumApi {
  QuantumApi._();

  /// 回傳 (HTTP 狀態碼, 資料)；連不上時狀態碼是 0
  static Future<(int, Map<String, dynamic>)> _call(Map<String, dynamic> body) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await http.post(
        Uri.parse(_quantumUrl),
        headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );
      return (response.statusCode, jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      return (0, <String, dynamic>{});
    }
  }

  /// 入場：真實位置只用來排除中國大陸，伺服器不存
  static Future<(int, Map<String, dynamic>)> enter({required double lat, required double lng, required String mood, required String nickname,
          Map<String, dynamic> extra = const {}}) =>
      _call({'action': 'enter', 'lat': lat, 'lng': lng, 'mood': mood, 'nickname': nickname, ...extra});

  /// 心跳＋掃描：送出位移（公尺）、心情；radiusKM 超過 5 公里時順便拿世界視角的光點
  static Future<(int, Map<String, dynamic>)> beat({required double east, required double north, required String mood,
          required String nickname, required bool quiet, required double radiusKM, Map<String, dynamic> extra = const {}}) =>
      _call({'action': 'beat', 'east': east, 'north': north, 'mood': mood, 'nickname': nickname, 'quiet': quiet, 'radiusKM': radiusKM, ...extra});

  static Future<void> leave() => _call({'action': 'leave'});

  /// 量子穿隧：每次入場一次
  static Future<(int, Map<String, dynamic>)> tunnel() => _call({'action': 'tunnel'});

  /// 整點報時：送出一道報時微光
  static Future<(int, Map<String, dynamic>)> chime() => _call({'action': 'chime'});

  /// 量子集會：action = asmCreate / asmJoin / asmLeave / asmAnnounce / asmCheer / asmRemove / asmEnd / asmStatus / asmVerify
  static Future<(int, Map<String, dynamic>)> assembly(String action, [Map<String, dynamic> body = const {}]) => _call({'action': action, ...body});

  /// 量子糾纏：op = invite / accept / decline / cut
  static Future<(int, Map<String, dynamic>)> entangle(String op, String uid) => _call({'action': 'entangle', 'op': op, 'uid': uid});
}

// ---------- 介面 ----------

String quantumRegionName(String id) => switch (id) {
      'tw' => tr.quantumRegionTw,
      'jp' => tr.quantumRegionJp,
      'kr' => tr.quantumRegionKr,
      'hkmo' => tr.quantumRegionHkmo,
      'sea' => tr.quantumRegionSea,
      _ => tr.quantumRegionOther,
    };

/// 進入前先說明；按「進入」就是這次的打卡
Future<bool> confirmQuantumWorld(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99070B1F),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.hive_outlined, color: Night.auroraBlue, size: 36),
          const SizedBox(height: Night.space3),
          Text(tr.quantumIntroTitle, style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          Flexible(child: SingleChildScrollView(child: Text(tr.quantumIntroBody, style: Night.body))),
          const SizedBox(height: Night.space4),
          Row(children: [
            Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext, false))),
            const SizedBox(width: Night.space2),
            Expanded(child: NightButton(tr.quantumEnter, icon: Icons.hive_outlined, onPressed: () => Navigator.pop(dialogContext, true))),
          ]),
        ]),
      ),
    ),
  );
  return ok == true;
}

/// 雷達右上角的量子世界開關（平行宇宙開關下方）：只有圖標，在場時發藍光
class QuantumWorldButton extends StatelessWidget {
  final VoidCallback onTap;
  const QuantumWorldButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QuantumSession?>(
      valueListenable: quantumSession,
      builder: (context, s, _) {
        final on = s != null;
        final status = on ? tr.quantumYourSeat(s.code) : tr.quantumWorldSubtitle;
        return Semantics(
          button: true,
          toggled: on,
          label: '${tr.quantumWorld}，$status',
          child: Tooltip(
            message: status,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Night.glassFill,
                  shape: BoxShape.circle,
                  border: Border.all(color: on ? Night.auroraBlue : Night.glassLine),
                  boxShadow: on ? [BoxShadow(color: Night.auroraBlue.withOpacity(0.45), blurRadius: 14)] : null,
                ),
                child: Icon(Icons.hive_outlined, size: 22, color: on ? Night.auroraBlue : Night.inkMuted),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 左上角：席位代號＋世界在線人數（取代城市心情）
class QuantumOnlineChip extends StatelessWidget {
  final VoidCallback onTap;
  const QuantumOnlineChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QuantumSession?>(
      valueListenable: quantumSession,
      builder: (context, s, _) {
        if (s == null) return const SizedBox.shrink();
        final text = '${s.code} · ${tr.quantumOnlineChip(max(1, s.online))}';
        return Semantics(
          button: true,
          label: text,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: 7),
              decoration: BoxDecoration(color: Night.glassFill, borderRadius: BorderRadius.circular(999), border: Border.all(color: Night.auroraBlue.withOpacity(0.6))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Night.auroraBlue, boxShadow: [BoxShadow(color: Night.auroraBlue.withOpacity(0.7), blurRadius: 6)])),
                const SizedBox(width: Night.space2),
                Text(text, style: const TextStyle(color: Night.ink, fontSize: 13)),
              ]),
            ),
          ),
        );
      },
    );
  }
}

/// 量子世界面板：席位、在線人數（各大區只顯示匿名總數）、量子寧靜、離開
void showQuantumSheet(BuildContext context, {required ValueChanged<bool> onQuietChanged, required VoidCallback onLeave, WidgetBuilder? extras}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => ValueListenableBuilder<QuantumSession?>(
      valueListenable: quantumSession,
      builder: (context, s, _) {
        if (s == null) return const SizedBox.shrink();
        final regions = s.regions.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Night.space4),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
              child: GlassCard(
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Stack(alignment: Alignment.center, children: [
                  Text(tr.quantumWorld, style: Night.caption, textAlign: TextAlign.center),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Night.inkMuted),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ),
                ]),
                const SizedBox(height: Night.space1),
                ShaderMask(
                  shaderCallback: (r) => Night.brightGradient.createShader(r),
                  child: Text(s.code, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600, letterSpacing: ls(2))),
                ),
                Text(tr.quantumSeatHint(s.ring), style: Night.caption, textAlign: TextAlign.center),
                const SizedBox(height: Night.space4),
                Text(tr.quantumOnlineTitle(max(1, s.online)), style: const TextStyle(color: Night.ink, fontSize: 15)),
                const SizedBox(height: Night.space2),
                Wrap(spacing: Night.space2, runSpacing: Night.space2, children: [
                  for (final r in regions)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: 6),
                      decoration: BoxDecoration(color: Night.night700, borderRadius: BorderRadius.circular(999)),
                      child: Text('${quantumRegionName(r.key)} ${r.value}', style: const TextStyle(color: Night.inkMuted, fontSize: 13)),
                    ),
                ]),
                const SizedBox(height: Night.space4),
                Row(children: [
                  const Icon(Icons.do_not_disturb_on_outlined, color: Night.inkMuted, size: 22),
                  const SizedBox(width: Night.space4),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(tr.quantumQuiet, style: const TextStyle(color: Night.ink, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(tr.quantumQuietSubtitle, style: Night.caption),
                    ]),
                  ),
                  Switch(
                    value: s.quiet,
                    activeThumbColor: Night.onDeep,
                    activeTrackColor: Night.deepViolet,
                    inactiveTrackColor: Night.night700,
                    onChanged: onQuietChanged,
                  ),
                ]),
                if (extras != null) ...[const SizedBox(height: Night.space4), extras(context)],
                const SizedBox(height: Night.space4),
                NightButton(tr.quantumLeave, kind: NightButtonKind.ghost, icon: Icons.logout, expand: true, onPressed: () {
                  Navigator.pop(sheetContext);
                  onLeave();
                }),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// 把量子世界的一個點（離 101 往東、往北幾公尺）投影到雷達畫面上，和氣泡用同一套透視
class QuantumProjector {
  final double centerEast, centerNorth; // 雷達中心（自己的顯示位置）
  final double heading, pitch, scale, screenHeight;
  final Offset center;
  static const double maxVisibleDistance = 2000.0; // 和 WhisperEngine 相同

  const QuantumProjector({required this.centerEast, required this.centerNorth, required this.heading, required this.pitch,
      required this.scale, required this.screenHeight, required this.center});

  /// 回傳畫面位置與景深（越小越遠）；在地平線後面就回傳 null
  (Offset, double)? project(double east, double north) {
    final dE = east - centerEast, dN = north - centerNorth;
    final distance = sqrt(dE * dE + dN * dN);
    final d = (distance / maxVisibleDistance) * (screenHeight * 0.6) * scale;
    final a = (atan2(dE, dN) * 180 / pi - heading) * pi / 180;
    final rx = d * sin(a), ry = -d * cos(a) * cos(pitch), rz = -d * cos(a) * sin(pitch);
    final w = 1.0 + rz * 0.002;
    if (w < 0.15) return null;
    return (Offset(center.dx + rx / w, center.dy + ry / w), w);
  }
}

/// 蜂巢底圖：淡淡的六角格點、自己的席位、101 原點光柱、世界視角的遠方光點
class QuantumHivePainter extends CustomPainter {
  final QuantumProjector p;
  final ({double east, double north}) seat;
  final List<List<double>> dots; // 世界視角：[lat, lng]，已經跨年的多一個 1
  final double glow; // 0～1，光柱呼吸
  final double boost; // 0～1，整點報時前光柱慢慢變亮
  final double cameo; // 0～1，艾婭在光柱裡現身：她身後的粒子讓開，不擋到她

  QuantumHivePainter({required this.p, required this.seat, required this.dots, required this.glow, this.boost = 0, this.cameo = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // 格點：鏡頭拉得夠近才畫，不然太密
    final pxPer100m = (quantumSpacingMeters / QuantumProjector.maxVisibleDistance) * p.screenHeight * 0.6 * p.scale;
    if (pxPer100m >= 9) {
      // 只畫身邊一圈，越遠越淡；靠近地平線（景深太小）的不畫，免得擠成一片
      final reach = min(1200.0, (p.screenHeight * 0.6) / pxPer100m * quantumSpacingMeters);
      final fromCenter = sqrt(p.centerEast * p.centerEast + p.centerNorth * p.centerNorth);
      final minRing = max(1, ((fromCenter - reach) / quantumSpacingMeters).floor());
      final maxRing = ((fromCenter + reach) / quantumSpacingMeters).ceil();
      final dot = Paint();
      for (var ring = minRing; ring <= maxRing; ring++) {
        for (var i = 0; i < 6 * ring; i++) {
          final o = quantumSeatOffset(ring, i);
          final dE = o.east - p.centerEast, dN = o.north - p.centerNorth;
          final d2 = dE * dE + dN * dN;
          if (d2 > reach * reach) continue;
          final hit = p.project(o.east, o.north);
          if (hit == null || hit.$2 < 0.55 || !rect.inflate(8).contains(hit.$1)) continue;
          final fade = 1 - sqrt(d2) / reach;
          dot.color = (ring <= quantumHostRings ? Night.cityAmber : Night.auroraBlue).withOpacity(0.32 * fade);
          canvas.drawCircle(hit.$1, 1.6 * hit.$2.clamp(0.5, 1.4), dot);
        }
      }
    }

    // 世界視角的遠方光點：不帶心情，只看得到有人
    // 量子跨年：已經跨年的人是金色、大一點
    final dotPaint = Paint()..color = Night.auroraBlue.withOpacity(0.8)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    final goldPaint = Paint()..color = const Color(0xFFFFD54F)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    for (final d in dots) {
      final o = quantumLocal(d[0], d[1]);
      final hit = p.project(o.east, o.north);
      if (hit == null || !rect.contains(hit.$1)) continue;
      final gold = d.length > 2;
      canvas.drawCircle(hit.$1, gold ? 3.2 : 2.2, gold ? goldPaint : dotPaint);
    }

    // 自己的席位：一圈淡藍色的六角形
    final mine = p.project(seat.east, seat.north);
    if (mine != null) {
      final r = max(10.0, pxPer100m * 0.45);
      final path = Path();
      for (var k = 0; k < 6; k++) {
        final a = k * pi / 3;
        final pt = mine.$1 + Offset(sin(a) * r, -cos(a) * r * cos(p.pitch));
        k == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.4..color = Night.auroraBlue.withOpacity(0.7));
    }

    // 101 原點：一道光柱，走得再遠也看得到方向
    final origin = p.project(0, 0);
    if (origin != null) {
      final base = origin.$1;
      final height = (180 + 120 * p.scale).clamp(120.0, 420.0) * (0.6 + 0.4 * sin(p.pitch).abs()) * (1 + 0.5 * boost);
      final half = (7 + 7 * boost) * 1.5; // 比原本的光柱粗一半
      final beam = Rect.fromLTWH(base.dx - half, base.dy - height, half * 2, height);
      final tint = Color.lerp(Night.auroraViolet, Night.cityAmber, boost * 0.5)!;
      // 底下一層很淡的光霧，讓粒子看起來是一根柱子
      canvas.drawRect(beam, Paint()
        ..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
            colors: [Colors.white.withOpacity(0.22), tint.withOpacity(0.12 + 0.1 * boost), tint.withOpacity(0)]).createShader(beam)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      // 光粒子：從底部往上飄，越高越淡；靠近中心的比較亮
      final t = DateTime.now().millisecondsSinceEpoch / 1000.0;
      // 省電：粒子不用模糊濾鏡（每顆都模糊會讓手機發燙），光暈用一顆淡淡的大圓代替
      final n = (90 + 50 * boost).round();
      final core = Paint();
      final halo = Paint();
      for (var i = 0; i < n; i++) {
        final r1 = _hash(i * 3 + 1), r2 = _hash(i * 3 + 2), r3 = _hash(i * 3 + 3);
        final speed = 0.10 + 0.22 * r2 + 0.12 * boost; // 每秒爬升柱高的比例
        final y = (r1 + t * speed) % 1.0;
        final lane = (r3 * 2 - 1);
        final x = base.dx + lane * lane.abs() * half * 0.6 + lane * half * 0.4 + sin(t * (0.8 + r2) + i) * half * 0.12;
        final fade = (1 - y) * min(1.0, y * 8); // 底部淡入、往上淡出
        final center = 1 - lane.abs() * 0.5;
        // 艾婭的人像在光柱中段（約 25%～75% 高）：那一段的粒子跟著她現身淡掉
        final behind = cameo > 0 ? cameo * (1 - ((y - 0.5).abs() / 0.3).clamp(0.0, 1.0)) : 0.0;
        final a = (0.4 + 0.2 * glow + 0.4 * boost).clamp(0.0, 1.0) * fade * center * (1 - 0.9 * behind);
        if (a < 0.03) continue;
        final pos = Offset(x, base.dy - y * height);
        final rad = (1.0 + 1.4 * r3 * r1) * (1 + 0.3 * boost);
        halo.color = tint.withOpacity(a * 0.22);
        canvas.drawCircle(pos, rad * 2.6, halo);
        core.color = Color.lerp(Colors.white, Night.cityAmber, r2 * 0.4 * (0.3 + boost))!.withOpacity(a);
        canvas.drawCircle(pos, rad, core);
      }
      canvas.drawCircle(base, 10 + 4 * glow + 14 * boost, Paint()..color = Night.auroraViolet.withOpacity(0.45 + 0.3 * boost)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
      canvas.drawCircle(base, 3, Paint()..color = Colors.white);
    }
  }

  static double _hash(int i) { final v = sin(i * 12.9898) * 43758.5453; return v - v.floorToDouble(); }

  @override
  bool shouldRepaint(covariant QuantumHivePainter old) => true;
}

/// 入場儀式（約 3 秒）：真實地圖縮成光點 → 黑幕中光點飛向東方 → 從 101 展開蜂巢 → 自己的席位亮起
class QuantumEntryPainter extends CustomPainter {
  final double t; // 0～1
  final String code;
  QuantumEntryPainter({required this.t, required this.code});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final full = size.longestSide;
    final dark = Paint()..color = Night.night900;
    if (t < 0.3) {
      // 1. 地圖縮成一個光點：黑幕從四周往中心收
      final k = Curves.easeIn.transform(t / 0.3);
      final hole = Path()..addOval(Rect.fromCircle(center: c, radius: full * (1 - k) + 4));
      canvas.drawPath(Path.combine(PathOperation.difference, Path()..addRect(Offset.zero & size), hole), dark);
      canvas.drawCircle(c, 4 + 6 * k, Paint()..color = Colors.white.withOpacity(k)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    } else if (t < 0.62) {
      // 2. 黑幕，光點飛向東方，拖著一條光尾
      final k = Curves.easeInOut.transform((t - 0.3) / 0.32);
      canvas.drawRect(Offset.zero & size, dark);
      final x = c.dx + (size.width * 0.6) * k;
      final tail = Rect.fromLTRB(x - 120 * sin(k * pi), c.dy - 2, x, c.dy + 2);
      canvas.drawRect(tail, Paint()..shader = LinearGradient(colors: [Night.auroraBlue.withOpacity(0), Night.auroraBlue]).createShader(tail));
      canvas.drawCircle(Offset(x, c.dy), 6, Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    } else {
      // 3. 從中心展開：黑幕往外退開，露出 101 的光柱與蜂巢；4. 席位代號亮起
      final k = Curves.easeOut.transform((t - 0.62) / 0.38);
      final hole = Path()..addOval(Rect.fromCircle(center: c, radius: full * k));
      canvas.drawPath(Path.combine(PathOperation.difference, Path()..addRect(Offset.zero & size), hole), dark..color = Night.night900.withOpacity(1 - k));
      final tp = TextPainter(
        text: TextSpan(text: code, style: TextStyle(color: Colors.white.withOpacity(sin(k * pi).clamp(0.0, 1.0)), fontSize: 44, fontWeight: FontWeight.w600, letterSpacing: ls(3),
            shadows: const [Shadow(color: Night.auroraBlue, blurRadius: 18)])),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2 + 90));
    }
  }

  @override
  bool shouldRepaint(covariant QuantumEntryPainter old) => old.t != t || old.code != code;
}
