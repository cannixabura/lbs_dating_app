import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'quantum_live.dart';
import 'ui/night.dart';

/// 量子世界第三期：量子相遇卡（規格 docs/quantum-world-spec.md 5.4）。
/// 雙方都同意時，把這次相遇做成一張分享卡：暱稱、席位代號、雙方當地時間與晝夜色、心情。不含任何位置。
/// 邀請放在 quantumMeet/{收到的人}/{送出的人} = { op: 'ask' | 'yes', tz: 時區偏移（分鐘）, at }

class QuantumMeetPerson {
  final String nickname, code, mood;
  final int? tz; // 分鐘；沒有就不顯示當地時間
  const QuantumMeetPerson({required this.nickname, required this.code, required this.mood, this.tz});

  int get ring => int.tryParse(RegExp(r'^Q(\d+)-').firstMatch(code)?.group(1) ?? '') ?? 99;
}

class QuantumMeetCards {
  QuantumMeetCards._();
  static DatabaseReference get _root => FirebaseDatabase.instance.ref('quantumMeet');
  static const askMs = 2 * 60 * 1000; // 邀請 2 分鐘內有效

  static int get _myTz => DateTime.now().timeZoneOffset.inMinutes;

  static Future<bool> _write(String path, String op) async {
    try {
      await _root.child(path).set({'op': op, 'tz': _myTz, 'at': ServerValue.timestamp});
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> ask(String myUid, String target) => _write('$target/$myUid', 'ask');
  static Future<bool> accept(String myUid, String asker) => _write('$asker/$myUid', 'yes');

  static List<StreamSubscription<DatabaseEvent>> listen(String myUid,
      {required void Function(String sender, int? tz) onAsk, required void Function(String sender, int? tz) onYes}) {
    void handle(DatabaseEvent e) {
      final v = e.snapshot.value;
      final sender = e.snapshot.key;
      if (v is! Map || sender == null) return;
      final at = v['at'], tz = v['tz'];
      if (at is! num || DateTime.now().millisecondsSinceEpoch - at > askMs) return;
      final zone = tz is num ? tz.toInt() : null;
      if (v['op'] == 'ask') onAsk(sender, zone);
      if (v['op'] == 'yes') onYes(sender, zone);
    }
    final ref = _root.child(myUid);
    return [ref.onChildAdded.listen(handle), ref.onChildChanged.listen(handle)];
  }

  /// 離開量子世界：收到的邀請全部清掉
  static Future<void> clear(String myUid) async {
    try {
      final snap = await _root.child(myUid).get();
      if (snap.value is! Map) return;
      await _root.child(myUid).update({for (final k in (snap.value as Map).keys) '$k': null});
    } catch (_) {}
  }
}

/// 收到製作相遇卡的邀請
Future<bool> showQuantumMeetAsk(BuildContext context, {required String name, required String code}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99070B1F),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(
        glow: true,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.style_outlined, color: Night.cityAmber, size: 36),
          const SizedBox(height: Night.space3),
          Text(tr.quantumMeetAskTitle, style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          Text(tr.quantumMeetAskBody(name, code), style: Night.body),
          const SizedBox(height: Night.space4),
          Row(children: [
            Expanded(child: NightButton(tr.decline, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext, false))),
            const SizedBox(width: Night.space2),
            Expanded(child: NightButton(tr.quantumMeetAccept, kind: NightButtonKind.warm, icon: Icons.style_outlined, onPressed: () => Navigator.pop(dialogContext, true))),
          ]),
        ]),
      ),
    ),
  );
  return ok == true;
}

/// 主人的當地時間 → 晝夜色調（和伺服器的 dayPart 相同）
String quantumDayPartOf(int tz) {
  final h = DateTime.now().toUtc().add(Duration(minutes: tz)).hour;
  return h >= 5 && h < 8 ? 'dawn' : h >= 8 && h < 17 ? 'day' : h >= 17 && h < 20 ? 'dusk' : 'night';
}

/// 相遇卡的三種配色：極光、金色、粉紫（可以按「換一張」）
const quantumMeetThemes = [
  (Night.auroraViolet, Night.auroraBlue),
  (Color(0xFFFFD54F), Night.cityAmber),
  (Night.knockPink, Night.auroraViolet),
];

/// 量子相遇卡本體（360×640）：深色蜂巢為底，101 原點的光柱、兩顆相連的光點，下面是兩個人
class QuantumMeetCard extends StatelessWidget {
  final QuantumMeetPerson a, b;
  final DateTime at;
  final int theme;
  const QuantumMeetCard({super.key, required this.a, required this.b, required this.at, this.theme = 0});

  /// 席位離原點越近越顯眼：第 4 圈金色、第 5～9 圈銀藍
  static Color seatColor(int ring) => ring <= 4 ? const Color(0xFFFFD54F) : ring <= 9 ? const Color(0xFFBFD4FF) : Night.inkMuted;

  Widget _person(QuantumMeetPerson p, Color accent) {
    final part = p.tz == null ? null : quantumDayPartOf(p.tz!);
    final local = p.tz == null ? null : DateTime.now().toUtc().add(Duration(minutes: p.tz!));
    final time = local == null ? null : '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')} · ${quantumDayName(part!)}';
    final seat = seatColor(p.ring);
    return Column(children: [
      Text(p.nickname, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          style: TextStyle(color: Night.ink, fontSize: 22, fontWeight: FontWeight.w600, shadows: [Shadow(color: accent.withOpacity(0.6), blurRadius: 14)])),
      const SizedBox(height: 6),
      Text('⬡ ${p.code}', style: TextStyle(color: seat, fontSize: p.ring <= 4 ? 19 : 16, fontWeight: FontWeight.w600, letterSpacing: 2,
          shadows: [Shadow(color: seat.withOpacity(0.7), blurRadius: p.ring <= 4 ? 14 : 6)])),
      if (time != null) ...[
        const SizedBox(height: 8),
        Text(time, style: TextStyle(color: quantumDayTint(part) ?? Night.inkMuted, fontSize: 13, letterSpacing: 1)),
      ],
      if (p.mood.isNotEmpty) ...[
        const SizedBox(height: 10),
        Text('「${p.mood}」', maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: const TextStyle(color: Night.ink, fontSize: 13, height: 1.5)),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final (accent, accent2) = quantumMeetThemes[theme % quantumMeetThemes.length];
    final date = '${at.year}.${at.month.toString().padLeft(2, '0')}.${at.day.toString().padLeft(2, '0')}';
    return SizedBox(
      width: 360,
      height: 640,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _MeetBackdrop(accent, accent2))),
          Positioned(
            left: 28, right: 28, top: 48,
            child: Column(children: [
              // 中日韓字距寬才好看；拉丁字母字距收小，並縮放成一行
              FittedBox(fit: BoxFit.scaleDown, child: Text(tr.quantumMeetEyebrow, maxLines: 1,
                  style: TextStyle(color: accent, fontSize: 26, fontWeight: FontWeight.w600,
                      letterSpacing: RegExp(r'[\u3040-\u30ff\u3400-\u9fff\uac00-\ud7af]').hasMatch(tr.quantumMeetEyebrow) ? 6 : 1.5,
                      shadows: [Shadow(color: accent.withOpacity(0.6), blurRadius: 16)]))),
              const SizedBox(height: 6),
              Text(date, style: const TextStyle(color: Night.inkMuted, fontSize: 12, letterSpacing: 2)),
            ]),
          ),
          Positioned(
            left: 20, right: 20, top: 300,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _person(a, accent)),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
                child: Text('×', style: TextStyle(color: accent, fontSize: 24, fontWeight: FontWeight.w300)),
              ),
              Expanded(child: _person(b, accent2)),
            ]),
          ),
          Positioned(
            left: 28, right: 28, bottom: 70,
            child: Text(tr.quantumMeetFooter, textAlign: TextAlign.center, style: const TextStyle(color: Night.inkMuted, fontSize: 12, letterSpacing: 2)),
          ),
          Positioned(
            left: 24, right: 24, bottom: 22,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ShaderMask(
                shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                child: Text(tr.appName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 3)),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('mood-whisper-f7de9.web.app', textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Night.ink, fontSize: 10, letterSpacing: 0.5))),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// 卡片背景：夜色漸層、淡淡的六角格點、遠方 101 原點的光柱、兩顆相連的光點
class _MeetBackdrop extends CustomPainter {
  final Color a, b;
  _MeetBackdrop(this.a, this.b);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Night.night900, Color(0xFF14123A), Night.night900]).createShader(rect));
    // 六角格點：越往下越亮，像從高處看蜂巢
    const step = 22.0;
    for (var row = 0; row * step * 0.87 < size.height; row++) {
      final y = row * step * 0.87;
      for (var col = -1; col * step < size.width + step; col++) {
        final x = col * step + (row.isOdd ? step / 2 : 0);
        final k = (y / size.height).clamp(0.0, 1.0);
        canvas.drawCircle(Offset(x, y), 1.1, Paint()..color = Night.auroraBlue.withOpacity(0.06 + 0.12 * k));
      }
    }
    // 101 原點的光柱
    final beam = Rect.fromLTWH(size.width / 2 - 1.5, 116, 3, 124);
    canvas.drawRect(beam.inflate(6), Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.transparent, Night.auroraBlue.withOpacity(0.25)]).createShader(beam.inflate(6))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawRect(beam, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.white.withOpacity(0.7)]).createShader(beam));
    // 兩顆光點與連線
    final p1 = Offset(size.width * 0.25, 262), p2 = Offset(size.width * 0.75, 262);
    final line = Rect.fromPoints(p1, p2);
    canvas.drawLine(p1, p2, Paint()..strokeWidth = 8..shader = LinearGradient(colors: [a, b]).createShader(line)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    canvas.drawLine(p1, p2, Paint()..strokeWidth = 1.6..shader = LinearGradient(colors: [a, b]).createShader(line));
    for (final (p, c) in [(p1, a), (p2, b)]) {
      canvas.drawCircle(p, 22, Paint()..color = c.withOpacity(0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
      canvas.drawCircle(p, 7, Paint()..color = Colors.white);
      canvas.drawCircle(p, 11, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = c);
    }
    // 中間一顆小星芒
    final mid = Offset.lerp(p1, p2, 0.5)!;
    for (var i = 0; i < 4; i++) {
      final ang = i * pi / 2;
      canvas.drawLine(mid, mid + Offset(cos(ang), sin(ang)) * 9, Paint()..strokeWidth = 1.4..color = Colors.white.withOpacity(0.8));
    }
  }

  @override
  bool shouldRepaint(covariant _MeetBackdrop old) => old.a != a || old.b != b;
}
