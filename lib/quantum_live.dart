import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'l10n/l10n.dart';
import 'nightly_reminder.dart';
import 'quantum_newyear.dart';
import 'quantum_orb.dart';
import 'quantum_world.dart';
import 'ui/night.dart';

/// 量子世界第二期：讓世界活起來（規格 docs/quantum-world-spec.md 第 4 節）。
/// 整點報時、量子糾纏、量子穿隧、晝夜蜂巢、量子共振、量子訊號、量子同頻。
/// 所有公開內容離開量子世界就消失；個人設定（主題、是否顯示當地時間、報時提醒）只存在手機上，入場時才送給伺服器。

// ---------- 個人設定 ----------

class QuantumPrefs {
  QuantumPrefs._();
  static const _topicsKey = 'quantum_topics';
  static const _showTimeKey = 'quantum_show_time';
  static const _chimeKey = 'quantum_chime_reminder';

  static final topics = ValueNotifier<List<int>>(const []);
  static final showTime = ValueNotifier<bool>(false); // 預設只顯示晝夜色調
  static final chimeReminder = ValueNotifier<bool>(true); // 預設打開

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    topics.value = (prefs.getStringList(_topicsKey) ?? const []).map(int.tryParse).whereType<int>().where((t) => t >= 0 && t < quantumTopicEmoji.length).take(3).toList();
    showTime.value = prefs.getBool(_showTimeKey) ?? false;
    chimeReminder.value = prefs.getBool(_chimeKey) ?? true;
  }

  static Future<void> setTopics(List<int> list) async {
    topics.value = List.unmodifiable(list.take(3));
    (await SharedPreferences.getInstance()).setStringList(_topicsKey, [for (final t in topics.value) '$t']);
  }

  static Future<void> setShowTime(bool on) async {
    showTime.value = on;
    (await SharedPreferences.getInstance()).setBool(_showTimeKey, on);
  }

  static Future<void> setChimeReminder(bool on) async {
    chimeReminder.value = on;
    (await SharedPreferences.getInstance()).setBool(_chimeKey, on);
    await QuantumChimeReminder.reschedule();
  }

  /// 送給伺服器的個人欄位：時區偏移（晝夜色調）、是否顯示當地時間、主題、量子化身的款式
  static Map<String, dynamic> get payload =>
      {'tz': DateTime.now().timeZoneOffset.inMinutes, 'showTime': showTime.value, 'topics': topics.value, 'orb': OrbPrefs.style.value};
}

// ---------- 量子同頻、量子訊號、晝夜蜂巢 ----------

const quantumTopicEmoji = ['🎵', '🎬', '💻', '🚶', '🍜', '✈️', '📚', '⚽'];
const quantumSignalEmoji = ['👋', '☕', '🌙', '🎵', '🌧️', '✨'];

String quantumTopicName(int i) => switch (i) {
      0 => tr.quantumTopicMusic,
      1 => tr.quantumTopicMovies,
      2 => tr.quantumTopicTech,
      3 => tr.quantumTopicWalks,
      4 => tr.quantumTopicFood,
      5 => tr.quantumTopicTravel,
      6 => tr.quantumTopicReading,
      _ => tr.quantumTopicSports,
    };

List<int> quantumTopicsOf(Object? raw) => raw is List ? [for (final t in raw) if (t is num && t >= 0 && t < quantumTopicEmoji.length) t.toInt()] : const [];

/// 晝夜色調：清晨淡金、白天亮白、黃昏橘紫、深夜深藍
Color? quantumDayTint(Object? part) => switch (part) {
      'dawn' => const Color(0xFFF3D98B),
      'day' => const Color(0xFFF5F7FF),
      'dusk' => const Color(0xFFE88AA8),
      'night' => const Color(0xFF4D6BFF),
      _ => null,
    };

String quantumDayName(String part) => switch (part) {
      'dawn' => tr.quantumDawn,
      'day' => tr.quantumDay,
      'dusk' => tr.quantumDusk,
      _ => tr.quantumNight,
    };

/// 地球時間窗：「當地 07:12・清晨」（只有對方同意時，伺服器才會給時區）
String? quantumLocalTimeLabel(Object? tzMinutes, Object? part) {
  if (tzMinutes is! num || part is! String) return null;
  final local = DateTime.now().toUtc().add(Duration(minutes: tzMinutes.toInt()));
  final hh = local.hour.toString().padLeft(2, '0'), mm = local.minute.toString().padLeft(2, '0');
  return tr.quantumLocalTime('$hh:$mm', quantumDayName(part));
}

// ---------- 量子共振 ----------

/// 24 小時內互送微光就共振。收到的微光本來就在 resonance/{我}；送出的只記在手機上。
class QuantumResonance {
  QuantumResonance._();
  static const _key = 'glimmers_sent';
  static const _day = 86400000;

  static Future<Map<String, int>> _sent() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      return raw == null ? {} : Map<String, int>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {};
    }
  }

  static Future<void> recordSent(String uid) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final map = await _sent()..removeWhere((_, at) => now - at > _day);
    map[uid] = now;
    (await SharedPreferences.getInstance()).setString(_key, jsonEncode(map));
  }

  static Future<bool> sentRecently(String uid) async {
    final at = (await _sent())[uid];
    return at != null && DateTime.now().millisecondsSinceEpoch - at <= _day;
  }
}

// ---------- 量子訊號 ----------

/// quantumSignals/{收到的人}/{送出的人} = { s, at }；同一人 30 秒一次（資料庫規則把關）
class QuantumSignals {
  QuantumSignals._();
  static DatabaseReference get _root => FirebaseDatabase.instance.ref('quantumSignals');

  static Future<bool> send(String myUid, String target, int signal) async {
    try {
      await _root.child('$target/$myUid').set({'s': signal, 'at': ServerValue.timestamp});
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 只通知剛送來的訊號（10 秒內）
  static List<StreamSubscription<DatabaseEvent>> listen(String myUid, void Function(String sender, int signal) onSignal) {
    void handle(DatabaseEvent e) {
      final v = e.snapshot.value;
      if (v is! Map || e.snapshot.key == null) return;
      final s = v['s'], at = v['at'];
      if (s is! num || at is! num || DateTime.now().millisecondsSinceEpoch - at > 10000) return;
      onSignal(e.snapshot.key!, s.toInt().clamp(0, quantumSignalEmoji.length - 1));
    }
    final ref = _root.child(myUid);
    return [ref.onChildAdded.listen(handle), ref.onChildChanged.listen(handle)];
  }

  /// 離開量子世界：收到的訊號全部清掉
  static Future<void> clear(String myUid) async {
    try {
      final snap = await _root.child(myUid).get();
      if (snap.value is! Map) return;
      await _root.child(myUid).update({for (final k in (snap.value as Map).keys) '$k': null});
    } catch (_) {}
  }
}

// ---------- 整點報時 ----------

/// Q0 天文鐘：整點前 1 分鐘光柱變亮，整點約 15 秒的報時（光之使者、鐘聲、光波）
class QuantumChime {
  QuantumChime._();
  static const lead = 60.0; // 整點前幾秒開始
  static const show = 15.0;
  static const send = 60.0; // 整點後 1 分鐘內都能送報時微光
  static const tail = 330.0; // 報時後的光環儀式維持 5 分鐘以上

  static DateTime _top(DateTime now) {
    final ms = now.millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch((ms / 3600000).round() * 3600000);
  }

  /// 離最近的整點幾秒（整點前是負的）
  static double offset(DateTime now) => now.difference(_top(now)).inMilliseconds / 1000;
  static bool active(DateTime now) { final t = offset(now); return t >= -lead && t <= tail; }
  static int hourKey(DateTime now) => _top(now).millisecondsSinceEpoch ~/ 3600000;

  /// 台北時間的點數：1 點 1 聲、23 點 23 聲、0 點 24 聲
  static int strikes(DateTime now) {
    final h = _top(now).toUtc().add(const Duration(hours: 8)).hour;
    return h == 0 ? 24 : h;
  }

  /// 每一聲在整點後第幾秒：越敲越快，最多 12 秒結束
  static List<double> strikeTimes(int n) {
    if (n <= 1) return const [1.5];
    final span = min(10.5, 0.9 * (n - 1));
    return [for (var k = 0; k < n; k++) 1.5 + span * pow(k / (n - 1), 0.7)];
  }
}

/// 鐘聲：幾個播放器輪流敲，前一聲的餘音不會被切掉；跟著靜音開關
class QuantumChimeBell {
  final _players = List.generate(4, (_) => AudioPlayer());
  final _timers = <Timer>[];
  var _next = 0;

  QuantumChimeBell() {
    final ctx = AudioContextConfig(respectSilence: true, focus: AudioContextConfigFocus.mixWithOthers).build();
    for (final p in _players) {
      p.setAudioContext(ctx);
      p.setReleaseMode(ReleaseMode.stop);
    }
  }

  /// 從報時開始後第 elapsed 秒起，把還沒敲的鐘聲排好
  void schedule(List<double> times, double elapsed, {VoidCallback? onStrike}) {
    cancel();
    for (final t in times) {
      if (t < elapsed - 0.2) continue;
      _timers.add(Timer(Duration(milliseconds: max(0, ((t - elapsed) * 1000).round())), () {
        final p = _players[_next++ % _players.length];
        p.play(AssetSource('audio/chime.m4a'), volume: 0.8);
        onStrike?.call();
      }));
    }
  }

  void cancel() {
    for (final t in _timers) { t.cancel(); }
    _timers.clear();
  }

  void dispose() {
    cancel();
    for (final p in _players) { p.dispose(); }
  }
}

/// 整點報時提醒：整點前 2 分鐘一則通知，在手機上排好接下來 24 小時，預設打開
class QuantumChimeReminder {
  QuantumChimeReminder._();
  static const _baseId = 2200; // 2200–2223

  static Future<void> reschedule() async {
    try {
      final plugin = await NightlyReminder.plugin();
      for (var i = 0; i < 24; i++) { await plugin.cancel(id: _baseId + i); }
      if (!QuantumPrefs.chimeReminder.value) return;
      final now = tz.TZDateTime.now(tz.local);
      var first = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour).add(const Duration(minutes: 58));
      if (!first.isAfter(now)) first = first.add(const Duration(hours: 1));
      for (var i = 0; i < 24; i++) {
        await plugin.zonedSchedule(
          id: _baseId + i,
          scheduledDate: first.add(Duration(hours: i)),
          title: tr.quantumWorld,
          body: tr.quantumChimeNotifyBody,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails('quantum_chime', tr.quantumChimeChannel, channelDescription: tr.quantumChimeChannelDesc),
            iOS: const DarwinNotificationDetails(presentBanner: true, presentList: true, presentSound: false),
          ),
        );
      }
    } catch (e) {
      debugPrint('quantum chime reminder failed: $e');
    }
  }
}

// ---------- 糾纏的人 ----------

class QuantumPartner {
  final String uid, nickname, code;
  final double lat, lng;
  const QuantumPartner({required this.uid, required this.nickname, required this.code, required this.lat, required this.lng});

  static QuantumPartner? fromJson(Object? raw) {
    if (raw is! Map || raw['uid'] is! String || raw['lat'] is! num || raw['lng'] is! num) return null;
    return QuantumPartner(uid: raw['uid'] as String, nickname: '${raw['nickname'] ?? ''}', code: '${raw['code'] ?? ''}',
        lat: (raw['lat'] as num).toDouble(), lng: (raw['lng'] as num).toDouble());
  }
}

/// 一道飛向原點的報時微光
class QuantumFlight {
  final double east, north; // 出發點（離 101 幾公尺）
  final int startMs;
  const QuantumFlight(this.east, this.north, this.startMs);
  static const durationMs = 2400;
}

/// 浮在氣泡旁的量子訊號
class QuantumSignalFloat {
  final String uid;
  final int signal;
  final int startMs;
  const QuantumSignalFloat(this.uid, this.signal, this.startMs);
  static const durationMs = 3000;
}

// ---------- 畫面 ----------

/// 整點報時：光之使者繞原點一圈、每一聲的光圈、最後的光波、飛向原點的報時微光
class QuantumChimePainter extends CustomPainter {
  final QuantumProjector p;
  final double t; // 整點後第幾秒（整點前是負的）
  final List<double> strikes;
  final int count; // 送出報時微光的人數：越多光波越大越亮
  final List<QuantumFlight> flights;
  final int nowMs;

  QuantumChimePainter({required this.p, required this.t, required this.strikes, required this.count, required this.flights, required this.nowMs});

  Path _ring(double radiusMeters) {
    final path = Path();
    var open = false;
    for (var i = 0; i <= 72; i++) {
      final a = i * 2 * pi / 72;
      final hit = p.project(sin(a) * radiusMeters, cos(a) * radiusMeters);
      if (hit == null) { open = false; continue; }
      open ? path.lineTo(hit.$1.dx, hit.$1.dy) : path.moveTo(hit.$1.dx, hit.$1.dy);
      open = true;
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final origin = p.project(0, 0);
    if (t >= 0 && t <= QuantumChime.show) {
      // 1. 光之使者：從光柱底部浮出，拖著光尾繞原點走一圈；離得再遠畫面上也至少 80 像素寬
      final rise = Curves.easeOut.transform((t / 1.5).clamp(0.0, 1.0));
      final fade = t > 13 ? (1 - (t - 13) / 2).clamp(0.0, 1.0) : 1.0;
      var radius = 90.0;
      final east = p.project(100, 0);
      if (origin != null && east != null) {
        final px100 = (east.$1 - origin.$1).distance;
        if (px100 > 0) radius = max(90.0, 80 * 100 / px100);
      }
      final turn = (t / 13) * 2 * pi; // 13 秒走完一圈
      final glow = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      final core = Paint();
      for (var k = 0; k < 12; k++) {
        final color = Color.lerp(Colors.white, Night.cityAmber, k.isEven ? 0.15 : 0.65)!;
        // 光尾：往回 0.5 弧度的一串漸淡光點
        for (var j = 6; j >= 0; j--) {
          final a = k * 2 * pi / 12 + turn - j * 0.08;
          final hit = p.project(sin(a) * radius * rise, cos(a) * radius * rise);
          if (hit == null) continue;
          final depth = hit.$2.clamp(0.7, 1.4);
          if (j == 0) {
            glow.color = color.withOpacity(0.85 * fade);
            canvas.drawCircle(hit.$1, 9 * depth, glow);
            core.color = Colors.white.withOpacity(fade);
            canvas.drawCircle(hit.$1, 3.6 * depth, core);
          } else {
            core.color = color.withOpacity(0.55 * fade * (1 - j / 7));
            canvas.drawCircle(hit.$1, (3.4 - j * 0.35) * depth, core);
          }
        }
      }
      // 使者走過的軌道：一圈淡淡的光環
      final orbit = _ring(radius * rise);
      canvas.drawPath(orbit, Paint()..style = PaintingStyle.stroke..strokeWidth = 6..color = Night.cityAmber.withOpacity(0.18 * fade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      // 2. 每一聲：原點迸出一圈光
      if (origin != null) {
        for (final s in strikes) {
          final k = (t - s) / 0.7;
          if (k < 0 || k > 1) continue;
          canvas.drawCircle(origin.$1, 8 + 46 * k, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.white.withOpacity(0.7 * (1 - k)));
        }
      }
    }
    // 3. 最後一聲之後的光環儀式：第一道光波擴散到整個蜂巢，之後每 8 秒從原點再送出一道，
    //    外圍留著一圈呼吸的光環；送報時微光的人越多，光波越大越亮（人數一直更新），維持 5 分鐘以上
    final last = strikes.isEmpty ? 1.5 : strikes.last;
    if (t >= last && t <= QuantumChime.tail) {
      final reach = min(3000.0, 700 + 160 * sqrt(count.toDouble()));
      final bright = 0.45 + 0.5 * min(1.0, count / 50);
      final end = (QuantumChime.tail - t) / 30; // 最後 30 秒慢慢退場
      final fadeOut = end.clamp(0.0, 1.0);
      final since = t - last;
      void wave(double k, double strength) {
        final path = _ring(reach * Curves.easeOut.transform(k));
        canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 10..color = Night.auroraViolet.withOpacity(bright * 0.5 * (1 - k) * strength)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
        canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.white.withOpacity(bright * (1 - k) * strength));
      }
      if (since <= 2.6) {
        wave(since / 2.6, 1);
      } else {
        final k = ((since - 2.6) % 8) / 4; // 4 秒擴散、4 秒休息
        if (k <= 1) wave(k, 0.75 * fadeOut);
        // 外圍呼吸的光環：在光波到達的地方
        final settle = ((since - 2.6) / 2).clamp(0.0, 1.0);
        final breathe = 0.75 + 0.25 * sin(t * 2 * pi / 4);
        final halo = _ring(reach);
        canvas.drawPath(halo, Paint()..style = PaintingStyle.stroke..strokeWidth = 14..color = Night.auroraViolet.withOpacity(bright * 0.35 * breathe * settle * fadeOut)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
        canvas.drawPath(halo, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.6..color = Night.cityAmber.withOpacity(bright * 0.8 * breathe * settle * fadeOut));
        // 原點的餘暉
        if (origin != null) {
          canvas.drawCircle(origin.$1, 26 + 6 * breathe, Paint()..color = Night.cityAmber.withOpacity(0.35 * bright * fadeOut)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
        }
      }
    }
    // 報時微光：從各自的席位飛向原點，拖著一小段光尾
    for (final f in flights) {
      final k = (nowMs - f.startMs) / QuantumFlight.durationMs;
      if (k < 0 || k > 1) continue;
      // 出發：席位迸出一圈金光
      final start = p.project(f.east, f.north);
      if (start != null && k < 0.3) {
        final q = k / 0.3;
        canvas.drawCircle(start.$1, 6 + 34 * Curves.easeOut.transform(q), Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Night.cityAmber.withOpacity(0.9 * (1 - q))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        canvas.drawCircle(start.$1, 14 * (1 - q), Paint()..color = Colors.white.withOpacity(0.8 * (1 - q))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      }
      final fly = (k / 0.82).clamp(0.0, 1.0); // 前 82% 飛過去，剩下的時間在原點綻開
      final e = Curves.easeInOut.transform(fly);
      Offset? at(double v) => p.project(f.east * (1 - v), f.north * (1 - v))?.$1;
      final head = at(e);
      if (head != null && fly < 1) {
        // 光尾：一串由粗到細、越後面越淡的光點，像流星
        for (var j = 14; j >= 1; j--) {
          final pt = at(max(0, e - j * 0.018));
          if (pt == null) continue;
          final w = 1 - j / 15;
          canvas.drawCircle(pt, 1.2 + 4 * w, Paint()..color = Color.lerp(Night.cityAmber, Colors.white, w * 0.6)!.withOpacity(0.75 * w)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        }
        canvas.drawCircle(head, 18, Paint()..color = Night.cityAmber.withOpacity(0.55)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
        canvas.drawCircle(head, 6, Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
      }
      // 抵達：原點閃一下，往外擴散兩圈光
      if (origin != null && k > 0.78) {
        final q = ((k - 0.78) / 0.22).clamp(0.0, 1.0);
        canvas.drawCircle(origin.$1, 30 * (1 - q) + 8, Paint()..color = Colors.white.withOpacity(0.85 * (1 - q))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
        for (final d in const [0.0, 0.25]) {
          final r = ((q - d) / (1 - d)).clamp(0.0, 1.0);
          if (r <= 0) continue;
          canvas.drawCircle(origin.$1, 10 + 70 * Curves.easeOut.transform(r), Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Night.cityAmber.withOpacity(0.85 * (1 - r))
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant QuantumChimePainter old) => true;
}

/// 量子糾纏：自己和對方之間兩股光（粉、藍）像麻繩一樣互相纏繞，不管相隔多遠都看得到（對方在畫面外時，繩子指向他的方向）。
/// 兩端收攏進氣泡、中間繞得最開；轉到前面的一股亮、繞到後面的一股暗，整條繩子慢慢旋轉。
class QuantumEntanglePainter extends CustomPainter {
  final Offset me;
  final List<(Offset, String)> ends; // 繩子的另一端與暱稱（對方在畫面外時才標名字）
  final List<bool> offscreen;
  final double phase; // 0～1，繩子轉一圈
  final List<List<Color>?>? colors; // 每條繩子兩股的顏色；沒給就是粉、藍（糾纏款配對用金、粉）

  QuantumEntanglePainter({required this.me, required this.ends, required this.offscreen, required this.phase, this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < ends.length; i++) {
      final (end, name) = ends[i];
      final d = end - me;
      final len = d.distance;
      if (len < 8) continue;
      final nrm = Offset(-d.dy, d.dx) / len;
      final far = offscreen[i] ? 0.2 : 0.85; // 對方在畫面外：遠端淡出
      final rect = Rect.fromPoints(me, end);

      // 底下一層柔光（整條只模糊一次）
      canvas.drawLine(me, end, Paint()
        ..shader = LinearGradient(colors: [((colors != null && i < colors!.length ? colors![i] : null)?[0] ?? Night.knockPink).withOpacity(0.35), ((colors != null && i < colors!.length ? colors![i] : null)?[1] ?? Night.auroraBlue).withOpacity(0.35 * far)]).createShader(rect)
        ..strokeWidth = 12
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));

      final turns = max(2.0, len / 30); // 大約每 30 點繞一圈
      final steps = (len / 3).round().clamp(24, 260);
      final spin = phase * 2 * pi + i * 1.3;
      const amp = 5.5;
      final strands = (colors != null && i < colors!.length ? colors![i] : null) ?? const [Night.knockPink, Night.auroraBlue];
      final backs = [Path(), Path()], fronts = [Path(), Path()];
      for (var k = 0; k < 2; k++) {
        bool? wasFront;
        for (var j = 0; j <= steps; j++) {
          final s = j / steps;
          final taper = min(1.0, min(s, 1 - s) * 5); // 兩端收攏
          final theta = s * turns * 2 * pi - spin + k * pi;
          final pt = me + d * s + nrm * (amp * taper * sin(theta));
          final isFront = cos(theta) >= 0;
          final path = isFront ? fronts[k] : backs[k];
          if (wasFront != isFront) {
            // 換到另一層：從上一點接起，線才不會斷
            final prevS = max(0, j - 1) / steps;
            final pt0 = me + d * prevS + nrm * (amp * min(1.0, min(prevS, 1 - prevS) * 5) * sin(prevS * turns * 2 * pi - spin + k * pi));
            path.moveTo(pt0.dx, pt0.dy);
            wasFront = isFront;
          }
          path.lineTo(pt.dx, pt.dy);
        }
      }
      Shader strandShader(Color c, double a) =>
          LinearGradient(colors: [c.withOpacity(a), c.withOpacity(a * far)]).createShader(rect);
      final round = Paint()..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
      for (var k = 0; k < 2; k++) {
        canvas.drawPath(backs[k], Paint.from(round)..shader = strandShader(strands[k], 0.35)..strokeWidth = 1.3);
      }
      for (var k = 0; k < 2; k++) {
        canvas.drawPath(fronts[k], Paint.from(round)..shader = strandShader(strands[k], 0.95)..strokeWidth = 2.2);
        canvas.drawPath(fronts[k], Paint.from(round)..shader = strandShader(Colors.white, 0.55)..strokeWidth = 0.6);
      }

      // 沿著繩子流動的光點
      final k = (phase + i / max(1, ends.length)) % 1.0;
      canvas.drawCircle(Offset.lerp(me, end, k)!, 2.4, Paint()..color = Colors.white.withOpacity(0.9)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
      if (offscreen[i] && name.isNotEmpty) {
        final tp = TextPainter(
          text: TextSpan(text: '∞ $name', style: const TextStyle(color: Night.ink, fontSize: 11, shadows: [Shadow(color: Night.night900, blurRadius: 6)])),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: 120);
        final at = Offset((end.dx - tp.width / 2).clamp(4.0, size.width - tp.width - 4), (end.dy + 6).clamp(4.0, size.height - tp.height - 4));
        tp.paint(canvas, at);
      }
    }
  }

  @override
  bool shouldRepaint(covariant QuantumEntanglePainter old) => true;
}

/// 量子共振：兩顆氣泡之間一道流動的光橋，各自亮起光暈和往外擴散的光環，持續 10 秒
class QuantumResonancePainter extends CustomPainter {
  final List<(Offset, Offset?)> pairs; // 自己的氣泡、對方的氣泡（對方在畫面外時是 null）
  final double t; // 0～1
  QuantumResonancePainter({required this.pairs, required this.t});

  void _bubble(Canvas canvas, Offset c, double alpha) {
    final beat = 0.5 + 0.5 * sin(t * 10 * 2 * pi); // 每秒脈動一次
    // 光暈
    canvas.drawCircle(c, 46 + 8 * beat, Paint()..shader = RadialGradient(colors: [
      Night.knockPink.withOpacity(0.55 * alpha), Night.cityAmber.withOpacity(0.25 * alpha), Colors.transparent,
    ], stops: const [0.35, 0.7, 1]).createShader(Rect.fromCircle(center: c, radius: 54)));
    // 往外擴散的三圈光環
    for (var j = 0; j < 3; j++) {
      final k = ((t * 10) + j / 3) % 1.0;
      final color = Color.lerp(Night.knockPink, Night.cityAmber, k)!;
      canvas.drawCircle(c, 26 + 64 * k, Paint()..style = PaintingStyle.stroke..strokeWidth = 7..color = color.withOpacity(alpha * (1 - k) * 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawCircle(c, 26 + 64 * k, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = color.withOpacity(alpha * (1 - k)));
    }
    // 貼著氣泡的亮框
    canvas.drawCircle(c, 25, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.white.withOpacity(alpha * (0.6 + 0.4 * beat))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    // 一開始迸出的星芒
    if (t < 0.12) {
      final k = t / 0.12;
      for (var i = 0; i < 10; i++) {
        final a = i * 2 * pi / 10;
        final from = c + Offset(cos(a), sin(a)) * (28 + 20 * k), to = c + Offset(cos(a), sin(a)) * (40 + 50 * k);
        canvas.drawLine(from, to, Paint()..strokeWidth = 2.5..strokeCap = StrokeCap.round..color = Colors.white.withOpacity(1 - k));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = t < 0.05 ? t / 0.05 : t > 0.85 ? (1 - t) / 0.15 : 1.0;
    for (final (me, them) in pairs) {
      if (them != null) {
        final shader = LinearGradient(colors: [Night.knockPink.withOpacity(alpha), Night.cityAmber.withOpacity(alpha), Night.knockPink.withOpacity(alpha)])
            .createShader(Rect.fromPoints(me, them));
        canvas.drawLine(me, them, Paint()..shader = shader..strokeWidth = 10..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
        canvas.drawLine(me, them, Paint()..shader = shader..strokeWidth = 2.5);
        // 光橋上來回流動的光點
        for (var i = 0; i < 4; i++) {
          final k = ((t * 5) + i / 4) % 1.0;
          canvas.drawCircle(Offset.lerp(me, them, i.isEven ? k : 1 - k)!, 4, Paint()..color = Colors.white.withOpacity(alpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        }
      }
      _bubble(canvas, me, alpha);
      if (them != null) _bubble(canvas, them, alpha);
    }
  }

  @override
  bool shouldRepaint(covariant QuantumResonancePainter old) => true;
}

/// 整點前 10 秒的大倒數：和入場時席位代號亮起同一種字（白字、藍色光暈），每一秒淡入、放大、淡出
class QuantumCountdownPainter extends CustomPainter {
  final double t; // 整點前是負的，-10～0
  QuantumCountdownPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    if (t < -10 || t >= 0) return;
    final n = (-t).ceil(); // 10、9、…、1
    final k = 1 - ((-t) - (n - 1)); // 這一秒過了多少：0～1
    final alpha = sin(k * pi).clamp(0.0, 1.0);
    final tp = TextPainter(
      text: TextSpan(text: '$n', style: TextStyle(color: Colors.white.withOpacity(alpha), fontSize: 44, fontWeight: FontWeight.w600, letterSpacing: 3,
          shadows: const [Shadow(color: Night.auroraBlue, blurRadius: 18)])),
      textDirection: TextDirection.ltr,
    )..layout();
    final c = size.center(Offset.zero) - const Offset(0, 90);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    final scale = 0.85 + 0.3 * Curves.easeOut.transform(k);
    canvas.scale(scale);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant QuantumCountdownPainter old) => old.t != t;
}

/// 整點前 1 分鐘：倒數＋「大家都在看原點」＋看原點；報時中：台北幾點＋送出報時微光
class QuantumChimeBanner extends StatelessWidget {
  final double t;
  final int hour;
  final bool sent;
  final int count; // 送出報時微光的人數
  final VoidCallback onLook;
  final VoidCallback onSend;
  const QuantumChimeBanner({super.key, required this.t, required this.hour, required this.sent, required this.count, required this.onLook, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final before = t < 0;
    final pill = BoxDecoration(color: Night.glassFill, borderRadius: BorderRadius.circular(999), border: Border.all(color: Night.cityAmber.withOpacity(0.7)),
        boxShadow: [BoxShadow(color: Night.cityAmber.withOpacity(0.25), blurRadius: 14)]);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.only(left: Night.space3, right: Night.space1, top: 4, bottom: 4),
        decoration: pill,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.notifications_active_outlined, color: Night.cityAmber, size: 18),
          const SizedBox(width: Night.space2),
          Flexible(
            child: Text(before ? '${tr.quantumChimeCountdown((-t).ceil())} · ${tr.quantumChimeLookOrigin}'
                : count > 0 ? '${tr.quantumChimeNow(hour)} · ✨ $count' : tr.quantumChimeNow(hour),
                style: const TextStyle(color: Night.ink, fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: Night.space1),
          if (before)
            TextButton(onPressed: onLook, style: TextButton.styleFrom(foregroundColor: Night.cityAmber, minimumSize: const Size(44, 36)), child: Text(tr.quantumChimeLook))
          else if (!sent && t <= QuantumChime.send)
            TextButton.icon(
              onPressed: onSend,
              style: TextButton.styleFrom(foregroundColor: Night.cityAmber, minimumSize: const Size(44, 36)),
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: Text(tr.quantumChimeSend),
            )
          else
            const SizedBox(width: Night.space2, height: 36),
        ]),
      ),
    );
  }
}

/// 收到糾纏邀請
Future<bool> showQuantumEntangleInvite(BuildContext context, {required String name, required String code}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99070B1F),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(
        glow: true,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.all_inclusive, color: Night.knockPink, size: 36),
          const SizedBox(height: Night.space3),
          Text(tr.quantumEntangleAskTitle, style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          Text(tr.quantumEntangleAskBody(name, code), style: Night.body),
          const SizedBox(height: Night.space4),
          Row(children: [
            Expanded(child: NightButton(tr.decline, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext, false))),
            const SizedBox(width: Night.space2),
            Expanded(child: NightButton(tr.quantumEntangleAccept, kind: NightButtonKind.warm, icon: Icons.all_inclusive, onPressed: () => Navigator.pop(dialogContext, true))),
          ]),
        ]),
      ),
    ),
  );
  return ok == true;
}

/// 量子世界面板的第二期區塊：穿隧、糾纏中的人、量子同頻、當地時間、報時提醒
class QuantumSheetExtras extends StatelessWidget {
  final bool tunneled;
  final List<QuantumPartner> partners;
  final VoidCallback onTunnel;
  final ValueChanged<QuantumPartner> onCut;
  final VoidCallback onPrefsChanged;
  final Color moodColor; // 量子化身的預覽用自己現在的心情色
  final String avatarUrl; // 和自己的大頭貼合成球型頭像
  final VoidCallback? onAssembly; // 量子集會：開集會（主持中就打開自己的集會卡）
  const QuantumSheetExtras({super.key, this.onAssembly, required this.tunneled, required this.partners, required this.onTunnel, required this.onCut, required this.onPrefsChanged,
      required this.moodColor, this.avatarUrl = ''});

  Widget _switchRow(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) => Row(children: [
        Icon(icon, color: Night.inkMuted, size: 22),
        const SizedBox(width: Night.space4),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Night.ink, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: Night.caption),
          ]),
        ),
        Switch(value: value, activeThumbColor: Night.onDeep, activeTrackColor: Night.deepViolet, inactiveTrackColor: Night.night700, onChanged: onChanged),
      ]);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const QuantumNewYearTeaser(),
      if (onAssembly != null) ...[
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onAssembly,
          child: Row(children: [
            const Icon(Icons.celebration_outlined, color: Night.auroraViolet, size: 22),
            const SizedBox(width: Night.space4),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr.asmOpenEntry, style: const TextStyle(color: Night.ink, fontSize: 15)),
                const SizedBox(height: 2),
                Text(tr.asmOpenEntrySub, style: Night.caption),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Night.inkFaint),
          ]),
        ),
        const SizedBox(height: Night.space4),
      ],
      if (partners.isNotEmpty) ...[
        Text(tr.quantumEntangledTitle, style: const TextStyle(color: Night.ink, fontSize: 15)),
        const SizedBox(height: Night.space1),
        for (final partner in partners)
          Row(children: [
            const Icon(Icons.all_inclusive, color: Night.knockPink, size: 18),
            const SizedBox(width: Night.space2),
            Expanded(child: Text('${partner.nickname} · ⬡ ${partner.code}', style: Night.body, overflow: TextOverflow.ellipsis)),
            TextButton(onPressed: () => onCut(partner), style: TextButton.styleFrom(foregroundColor: Night.inkMuted, minimumSize: const Size(44, 44)), child: Text(tr.quantumEntangleCut)),
          ]),
        const SizedBox(height: Night.space3),
      ],
      Row(children: [
        const Icon(Icons.blur_on, color: Night.inkMuted, size: 22),
        const SizedBox(width: Night.space4),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr.quantumTunnel, style: const TextStyle(color: Night.ink, fontSize: 15)),
            const SizedBox(height: 2),
            Text(tunneled ? tr.quantumTunnelUsed : tr.quantumTunnelSubtitle, style: Night.caption),
          ]),
        ),
        const SizedBox(width: Night.space2),
        NightButton(tr.quantumTunnel, kind: NightButtonKind.ghost, onPressed: tunneled ? null : onTunnel),
      ]),
      const SizedBox(height: Night.space4),
      // 量子化身：目前的光球，點一下打開款式面板；關掉面板時把新款式送給伺服器
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final before = OrbPrefs.style.value;
          await showOrbSheet(context, moodColor: moodColor, avatarUrl: avatarUrl);
          if (OrbPrefs.style.value != before) onPrefsChanged();
        },
        child: Row(children: [
          AnimatedBuilder(
            animation: Listenable.merge([OrbPrefs.style, OrbGrowth.mine]),
            builder: (context, _) => QuantumOrb(style: OrbPrefs.style.value, color: moodColor, size: 52, image: orbImage(avatarUrl),
                stars: OrbGrowth.mine.value.stars, rings: OrbGrowth.mine.value.rings),
          ),
          const SizedBox(width: Night.space3),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.quantumOrbEntry, style: const TextStyle(color: Night.ink, fontSize: 15)),
              const SizedBox(height: 2),
              Text(tr.quantumOrbEntrySubtitle, style: Night.caption),
            ]),
          ),
          const Icon(Icons.chevron_right, color: Night.inkMuted),
        ]),
      ),
      const SizedBox(height: Night.space4),
      Text(tr.quantumTopicsTitle, style: const TextStyle(color: Night.ink, fontSize: 15)),
      const SizedBox(height: 2),
      Text(tr.quantumTopicsSubtitle, style: Night.caption),
      const SizedBox(height: Night.space2),
      ValueListenableBuilder<List<int>>(
        valueListenable: QuantumPrefs.topics,
        builder: (context, chosen, _) => Wrap(spacing: Night.space2, runSpacing: Night.space2, children: [
          for (var i = 0; i < quantumTopicEmoji.length; i++)
            FilterChip(
              label: Text('${quantumTopicEmoji[i]} ${quantumTopicName(i)}'),
              selected: chosen.contains(i),
              showCheckmark: false,
              labelStyle: TextStyle(color: chosen.contains(i) ? Night.onDeep : Night.inkMuted, fontSize: 13),
              backgroundColor: Night.night700,
              selectedColor: Night.deepViolet,
              side: BorderSide(color: chosen.contains(i) ? Night.auroraViolet : Night.glassLine),
              onSelected: (on) {
                if (on && chosen.length >= 3) return;
                QuantumPrefs.setTopics(on ? [...chosen, i] : chosen.where((t) => t != i).toList()).then((_) => onPrefsChanged());
              },
            ),
        ]),
      ),
      const SizedBox(height: Night.space4),
      ValueListenableBuilder<bool>(
        valueListenable: QuantumPrefs.showTime,
        builder: (context, on, _) => _switchRow(Icons.schedule, tr.quantumShowTime, tr.quantumShowTimeSubtitle, on,
            (v) => QuantumPrefs.setShowTime(v).then((_) => onPrefsChanged())),
      ),
      const SizedBox(height: Night.space3),
      ValueListenableBuilder<bool>(
        valueListenable: QuantumPrefs.chimeReminder,
        builder: (context, on, _) => _switchRow(Icons.notifications_none, tr.quantumChimeReminder, tr.quantumChimeReminderSubtitle, on, QuantumPrefs.setChimeReminder),
      ),
    ]);
  }
}
