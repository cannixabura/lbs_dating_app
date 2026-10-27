import '../l10n/l10n.dart';
import 'dart:math';

import 'package:flutter/material.dart';

import 'night.dart';

/// 敲門儀式的三個視覺元件：流動的虛線弧、等待倒數條、粒子消散。

/// 從自己的位置到對方氣泡的一道弧，虛線沿著弧往對方流動（[phase] 0→1 循環）。
class KnockArcPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final double phase;
  KnockArcPainter({required this.from, required this.to, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
    final d = to - from;
    if (d.distance < 24) return;
    // 弧頂往上拱，高度隨距離增加
    final normal = Offset(d.dy, -d.dx) / d.distance;
    final lift = min(120.0, d.distance * 0.35);
    final control = mid + (normal.dy < 0 ? normal : -normal) * lift;
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);

    final glow = Paint()
      ..color = Night.knockPink.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glow);

    final dot = Paint()..color = Night.knockPink.withOpacity(0.9);
    const gap = 14.0;
    for (final metric in path.computeMetrics()) {
      for (double t = phase * gap; t < metric.length; t += gap) {
        final pos = metric.getTangentForOffset(t)?.position;
        if (pos == null) continue;
        // 越接近對方越亮
        final k = t / metric.length;
        canvas.drawCircle(pos, 1.6 + 0.8 * k, dot..color = Night.knockPink.withOpacity(0.35 + 0.6 * k));
      }
    }
  }

  @override
  bool shouldRepaint(covariant KnockArcPainter old) => old.phase != phase || old.from != from || old.to != to;
}

/// 粒子消散：一束光在 [origin] 化成粒子往上飄散（[progress] 0→1）。
class ParticleBurstPainter extends CustomPainter {
  final Offset origin;
  final double progress;
  final Color color;
  static final List<_Particle> _particles = List.generate(22, (i) {
    final r = Random(i * 7919);
    return _Particle(
      angle: -pi / 2 + (r.nextDouble() - 0.5) * pi * 1.1,
      speed: 40 + r.nextDouble() * 70,
      size: 1.2 + r.nextDouble() * 2.2,
      drift: (r.nextDouble() - 0.5) * 30,
    );
  });

  ParticleBurstPainter({required this.origin, required this.progress, this.color = Night.knockPink});

  @override
  void paint(Canvas canvas, Size size) {
    final ease = Curves.easeOutCubic.transform(progress);
    final fade = (1 - progress).clamp(0.0, 1.0);
    final paint = Paint();
    for (final p in _particles) {
      final dist = p.speed * ease;
      final pos = origin + Offset(cos(p.angle) * dist + p.drift * ease, sin(p.angle) * dist - 20 * ease);
      paint
        ..color = color.withOpacity(0.85 * fade)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1 + 2 * ease);
      canvas.drawCircle(pos, p.size * (1 - 0.5 * ease), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBurstPainter old) => old.progress != progress || old.origin != origin || old.color != color;
}

class _Particle {
  final double angle, speed, size, drift;
  const _Particle({required this.angle, required this.speed, required this.size, required this.drift});
}

/// 等待回音的倒數條：mm:ss ＋ 逐漸縮短的進度條；最後 60 秒轉為警示色。
class KnockCountdownPill extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;
  final String targetName;
  const KnockCountdownPill({super.key, required this.secondsLeft, required this.totalSeconds, required this.targetName});

  @override
  Widget build(BuildContext context) {
    final bool warn = secondsLeft <= 60;
    final Color c = warn ? Night.danger : Night.knockPink;
    final mm = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (secondsLeft % 60).toString().padLeft(2, '0');
    return Semantics(
      liveRegion: false,
      label: tr.knockWaitingSemantic(targetName, mm, ss),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space2),
        decoration: BoxDecoration(
          color: Night.glassFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Night.glassLine),
          boxShadow: const [Night.lift],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.hourglass_bottom_rounded, color: c, size: 18),
          const SizedBox(width: Night.space2),
          Flexible(
            child: Text(tr.knockWaiting(targetName), style: const TextStyle(color: Night.inkMuted, fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: Night.space2),
          Text('$mm:$ss', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w600, fontFeatures: const [FontFeature.tabularFigures()])),
          const SizedBox(width: Night.space3),
          SizedBox(
            width: 56, height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: secondsLeft / totalSeconds, backgroundColor: Night.night600, color: c),
            ),
          ),
        ]),
      ),
    );
  }
}
