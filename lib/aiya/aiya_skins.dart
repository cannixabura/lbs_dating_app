import 'dart:math';

import 'package:flutter/material.dart';

/// 艾婭的節日造型（只有買的人看得到自己的艾婭換造型）。
/// 艾婭本身是金色光粒子組成的全息影像，所以造型也一律用光粒子畫（加法混色，像光一樣疊亮），不用卡通圖案。
/// stage 是艾婭的舞台：全螢幕寬，上方約 48% 高；她的頭頂約在舞台 12% 高、臉在中間、頭髮佔寬度 22%～78%。
/// 裝飾都在她周圍，臉的範圍留空。

double _h(int i, [double salt = 0]) {
  final x = sin(i * 127.1 + 311.7 + salt) * 43758.5453;
  return x - x.floorToDouble();
}

/// 一顆光粒子：外圈淡淡的光暈＋亮核（加法混色）
void _dot(Canvas canvas, Offset p, double r, Color color, double alpha, {double halo = 2.6}) {
  if (alpha <= 0.02) return;
  canvas.drawCircle(p, r * halo, Paint()..color = color.withValues(alpha: 0.14 * alpha)..blendMode = BlendMode.plus);
  canvas.drawCircle(p, r, Paint()..color = Color.lerp(color, Colors.white, 0.45)!.withValues(alpha: alpha)..blendMode = BlendMode.plus);
}

/// 背景的光塵：兩側慢慢往上飄的細小金色粒子（和艾婭身上的粒子同色）
void _dust(Canvas canvas, Rect stage, double t, Color color, int n, double salt) {
  final w = stage.width, h = stage.height;
  for (var i = 0; i < n; i++) {
    final y = 1 - (_h(i, salt) + t * (0.02 + 0.02 * _h(i, salt + 1))) % 1.0;
    final side = _h(i, salt + 2);
    final x = stage.left + w * (side < 0.5 ? side * 0.46 : 0.77 + (side - 0.5) * 0.46) + sin(t * 0.7 + i) * 6;
    final tw = 0.5 + 0.5 * sin(t * (1.5 + _h(i, salt + 3) * 2) + i);
    _dot(canvas, Offset(x, stage.top + y * h * 1.05), 0.7 + 0.9 * _h(i, salt + 4), color, 0.6 * tw * sin(y * pi));
  }
}

// ============================================================================
// 聖誕：光粒子聖誕樹
// ============================================================================

/// 聖誕：她兩側各一棵光粒子聖誕樹（兩條螺旋光帶繞著圓錐往上轉，有立體的前後明暗，頂端一顆粒子星星會閃），
/// 幾朵光粒子排成的大雪花在她身邊慢慢飄、旋轉，散景雪從上面飄下來，粒子從樹梢飄上去。
class AiyaXmasSkinPainter extends CustomPainter {
  final Rect stage;
  final double Function() clock;
  AiyaXmasSkinPainter({required this.stage, required Listenable repaint, required this.clock}) : super(repaint: repaint);

  static const _gold = Color(0xFFFFD98A);
  static const _red = Color(0xFFFF4D6A);
  static const _green = Color(0xFF5CFFA0);
  static const _ice = Color(0xFFBFE8FF);

  void _tree(Canvas canvas, Offset base, double height, double radius, double t, int seed) {
    final dir = seed.isEven ? 1.0 : -1.0;
    // 樹幹的淡光
    canvas.drawLine(base, base - Offset(0, height * 0.12), Paint()..color = _gold.withValues(alpha: 0.25)..strokeWidth = 2..blendMode = BlendMode.plus);
    // 兩條螺旋光帶：一條金白、一條紅綠交錯
    for (var strand = 0; strand < 2; strand++) {
      const n = 190;
      for (var i = 0; i < n; i++) {
        final f = i / n; // 0 樹底，1 樹梢
        final a = f * 7 * 2 * pi + strand * pi + dir * t * 0.9;
        final r = radius * (1 - f) * (0.95 + 0.08 * sin(i * 1.7 + t * 3));
        final depth = sin(a); // 1 在前面
        final p = base + Offset(cos(a) * r, -height * (0.08 + 0.92 * f) + depth * r * 0.18);
        final k = 0.35 + 0.65 * (depth * 0.5 + 0.5);
        final color = strand == 0 ? (i % 7 == 0 ? Colors.white : _gold) : (i % 2 == 0 ? _red : _green);
        final tw = 0.75 + 0.25 * sin(t * 4 + i * 0.8 + strand);
        _dot(canvas, p, (strand == 0 ? 1.5 : 1.3) * (0.6 + 0.5 * k), color, k * tw);
      }
    }
    // 散在樹身裡的小光點（像樹葉上的露光）
    for (var i = 0; i < 110; i++) {
      final f = sqrt(_h(i, seed * 9.0)) * 0.97; // 樹底比較密
      final a = _h(i, seed * 9.0 + 1) * 2 * pi + dir * t * 0.9;
      final r = radius * (1 - f) * _h(i, seed * 9.0 + 2);
      final depth = sin(a);
      final p = base + Offset(cos(a) * r, -height * (0.08 + 0.92 * f) + depth * r * 0.18);
      _dot(canvas, p, 1.0, i % 9 == 0 ? _gold : _green, (0.3 + 0.4 * (depth * 0.5 + 0.5)) * (0.6 + 0.4 * sin(t * 2.5 + i)));
    }
    // 樹梢的星星：五角星的輪廓由粒子組成，一閃一閃
    final top = base - Offset(0, height * 1.04);
    final pulse = 0.75 + 0.25 * sin(t * 3 + seed);
    canvas.drawCircle(top, radius * 0.45, Paint()..color = _gold.withValues(alpha: 0.35 * pulse)..blendMode = BlendMode.plus..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.25));
    final pts = <Offset>[];
    for (var j = 0; j < 10; j++) {
      final a = -pi / 2 + j * pi / 5 + sin(t * 0.8) * 0.15;
      pts.add(top + Offset(cos(a), sin(a)) * (j.isEven ? radius * 0.28 : radius * 0.12) * pulse);
    }
    for (var j = 0; j < 10; j++) {
      final a = pts[j], b = pts[(j + 1) % 10];
      for (var s = 0; s < 4; s++) {
        _dot(canvas, Offset.lerp(a, b, s / 4)!, 1.3, j.isEven ? Colors.white : _gold, pulse, halo: 2);
      }
    }
    _dot(canvas, top, 2.4, Colors.white, pulse, halo: 3.5);
    // 從樹梢飄上去的粒子
    for (var i = 0; i < 10; i++) {
      final life = (t * 0.35 + _h(i, seed + 40.0)) % 1.0;
      final p = top + Offset(sin(life * 6 + i) * radius * 0.3, -life * height * 0.35);
      _dot(canvas, p, 1.1, i.isEven ? _gold : _ice, (1 - life) * 0.8);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock();
    final w = stage.width, h = stage.height;

    _dust(canvas, stage, t, _gold, 30, 5);

    // 兩棵樹：在頭髮外側，樹底在她肩膀的高度
    _tree(canvas, Offset(stage.left + w * 0.115, stage.top + h * 0.92), h * 0.62, w * 0.11, t, 0);
    _tree(canvas, Offset(stage.left + w * 0.885, stage.top + h * 0.92), h * 0.62, w * 0.11, t, 1);

    // 粒子雪花：幾朵由光粒子排成的大雪花，慢慢飄落、旋轉（避開臉）
    for (var f = 0; f < 4; f++) {
      final life = (t * 0.045 + f * 0.25) % 1.0;
      final side = f.isEven ? 0.26 + 0.05 * _h(f, 70) : 0.7 + 0.05 * _h(f, 70);
      final top = f < 2;
      final center = Offset(stage.left + w * side + sin(t * 0.5 + f) * 8, stage.top + h * (top ? -0.02 + 0.2 * life : 0.62 + 0.3 * life));
      final fade = sin(life * pi);
      final size = w * (0.03 + 0.012 * (f % 2));
      final rot = t * 0.3 + f;
      for (var arm = 0; arm < 6; arm++) {
        final a = rot + arm * pi / 3;
        final d = Offset(cos(a), sin(a));
        for (var k = 1; k <= 6; k++) {
          _dot(canvas, center + d * (size * k / 6), 0.95, k == 6 ? Colors.white : _ice, fade * 0.9, halo: 2.0);
        }
        for (final at in [0.5, 0.75]) {
          final base = center + d * size * at;
          for (final sgn in [-1.0, 1.0]) {
            final b = a + sgn * pi / 4;
            for (var k = 1; k <= 2; k++) {
              _dot(canvas, base + Offset(cos(b), sin(b)) * (size * 0.12 * k), 0.8, _ice, fade * 0.8, halo: 2.0);
            }
          }
        }
      }
      _dot(canvas, center, 1.6, Colors.white, fade, halo: 3);
    }

    // 散景雪：大小不一的柔光圓點，近的大而淡、遠的小而亮
    for (var i = 0; i < 56; i++) {
      final near = i % 4 == 0;
      final y = (_h(i, 80) + t * (near ? 0.07 : 0.035) * (0.7 + 0.6 * _h(i, 81))) % 1.0;
      final x = stage.left + _h(i, 82) * w + sin(t * 0.6 + i) * (near ? 16 : 7);
      final p = Offset(x, stage.top - h * 0.05 + y * h * 1.15);
      final fade = sin(y * pi);
      if (near) {
        canvas.drawCircle(p, w * 0.011, Paint()..color = _ice.withValues(alpha: 0.22 * fade)..blendMode = BlendMode.plus..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.006));
      } else {
        _dot(canvas, p, 0.8 + 0.8 * _h(i, 83), Colors.white, 0.75 * fade);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AiyaXmasSkinPainter old) => old.stage != stage;
}

// ============================================================================
// 量子跨年：光粒子光冠與粒子煙火
// ============================================================================

/// 5×7 點陣數字，用來讓煙火的粒子排出「2027」
const _digits = {
  '2': ['01110', '10001', '00001', '00010', '00100', '01000', '11111'],
  '0': ['01110', '10001', '10011', '10101', '11001', '10001', '01110'],
  '7': ['11111', '00001', '00010', '00100', '01000', '01000', '01000'],
};

List<Offset> _textDots(String text) {
  final dots = <Offset>[];
  for (var d = 0; d < text.length; d++) {
    final rows = _digits[text[d]]!;
    for (var r = 0; r < 7; r++) {
      for (var c = 0; c < 5; c++) {
        if (rows[r][c] == '1') dots.add(Offset(d * 6.0 + c - (text.length * 6 - 1) / 2, r - 3.0));
      }
    }
  }
  return dots;
}

final _year = _textDots('2027');

/// 量子跨年：頭頂一頂由幾百顆光粒子組成的光冠（傾斜的粒子環慢慢轉、12 顆比較亮的粒子當刻度、一顆彗星粒子拖著尾巴繞圈、
/// 粒子火花從光冠往上飄），兩側輪流升空的粒子煙火（爆開後受重力下墜、化成光塵），其中一發會在空中排成「2027」再散掉。
class AiyaNewYearSkinPainter extends CustomPainter {
  final Rect stage;
  final double Function() clock;
  AiyaNewYearSkinPainter({required this.stage, required Listenable repaint, required this.clock}) : super(repaint: repaint);

  static const _gold = Color(0xFFFFD166);
  static const _palette = [Color(0xFFFFD166), Color(0xFFFF7BD5), Color(0xFF7FD8FF), Color(0xFFB59CFF), Color(0xFFFF9A5B), Color(0xFF8CFFB8)];

  void _crown(Canvas canvas, double t) {
    final w = stage.width, h = stage.height;
    final c = Offset(stage.center.dx, stage.top + h * 0.085);
    final rx = w * 0.2, ry = w * 0.045;
    // 粒子環：兩圈（外圈密、內圈疏），每顆粒子微微抖動，像艾婭身上的光
    for (var ring = 0; ring < 2; ring++) {
      final n = ring == 0 ? 220 : 110;
      final scale = ring == 0 ? 1.0 : 0.86;
      for (var i = 0; i < n; i++) {
        final a = i / n * 2 * pi + t * (ring == 0 ? 0.35 : -0.25);
        final depth = sin(a);
        final wob = Offset(sin(t * 3 + i * 1.3) * w * 0.003, cos(t * 2.6 + i) * w * 0.002);
        final p = c + Offset(cos(a) * rx * scale, depth * ry * scale) + wob;
        final k = 0.3 + 0.7 * (depth * 0.5 + 0.5);
        final color = i % 23 == 0 ? _palette[(i ~/ 23) % _palette.length] : (i % 3 == 0 ? Colors.white : _gold);
        _dot(canvas, p, (ring == 0 ? 1.2 : 0.9) * (0.7 + 0.4 * k), color, k * (0.65 + 0.35 * sin(t * 4 + i * 0.7)));
      }
    }
    // 12 顆刻度粒子：比較大、輪流變亮；12 點那顆最亮
    for (var i = 0; i < 12; i++) {
      final a = -pi / 2 + i / 12 * 2 * pi + t * 0.35;
      final depth = sin(a);
      final k = 0.35 + 0.65 * (depth * 0.5 + 0.5);
      final beat = 0.6 + 0.4 * sin(t * 2 - i * 0.52);
      _dot(canvas, c + Offset(cos(a) * rx, depth * ry), (i == 0 ? 3.0 : 2.0) * (0.7 + 0.4 * k), i == 0 ? Colors.white : _palette[i % _palette.length], k * beat, halo: 3.2);
    }
    // 彗星粒子：拖著一串越來越淡的粒子繞外圈
    for (var j = 18; j >= 0; j--) {
      final a = t * 1.5 - j * 0.06;
      final depth = sin(a);
      final f = 1 - j / 19;
      _dot(canvas, c + Offset(cos(a) * rx * 1.05, depth * ry * 1.05), 0.5 + 1.0 * f, Colors.white, f * f * (0.5 + 0.5 * (depth * 0.5 + 0.5)));
    }
    // 從光冠往上飄的火花粒子
    for (var i = 0; i < 36; i++) {
      final life = (t * 0.4 + _h(i, 10)) % 1.0;
      final a = _h(i, 11) * 2 * pi + t * 0.35;
      final start = c + Offset(cos(a) * rx, sin(a) * ry);
      final p = start + Offset(sin(life * 5 + i) * w * 0.01, -life * h * 0.1);
      _dot(canvas, p, 0.9 + 0.6 * _h(i, 12), i % 4 == 0 ? _palette[i % _palette.length] : _gold, (1 - life) * 0.85);
    }
  }

  void _firework(Canvas canvas, int slot, double t) {
    final w = stage.width, h = stage.height;
    final period = 3.8 + slot * 0.4;
    final local = t + slot * 1.21;
    final cycle = (local / period).floor();
    final p = (local % period) / period;
    final seed = cycle * 17 + slot * 5;
    final left = (cycle + slot).isEven;
    final writesYear = slot == 0 && cycle.isEven; // 這一發會排成 2027
    final burst = Offset(
      stage.left + w * (left ? 0.06 + (writesYear ? 0.05 : 0.12 * _h(seed, 1)) : 0.82 + (writesYear ? 0.07 : 0.12 * _h(seed, 1))),
      stage.top + h * (writesYear ? 0.3 : 0.1 + 0.42 * _h(seed, 2)),
    );
    final c1 = _palette[seed % _palette.length], c2 = _palette[(seed + 3) % _palette.length];
    if (p < 0.2) {
      // 升空：一顆亮粒子拖著火花粒子
      final q = Curves.easeOut.transform(p / 0.2);
      final from = Offset(burst.dx + (left ? -1 : 1) * w * 0.025, stage.bottom);
      for (var j = 0; j < 10; j++) {
        final tp = Offset.lerp(from, burst, max(0, q - j * 0.022))!;
        _dot(canvas, tp + Offset(sin(j * 3.0 + t * 20) * 1.2, 0), 1.4 * (1 - j / 10), const Color(0xFFFFE6A8), 0.85 * (1 - j / 10));
      }
      _dot(canvas, Offset.lerp(from, burst, q)!, 2.0, Colors.white, 1, halo: 3);
      return;
    }
    final q = (p - 0.2) / 0.8;
    if (q < 0.1) canvas.drawCircle(burst, w * 0.05 * (1 - q / 0.1), Paint()..color = Colors.white.withValues(alpha: 0.3 * (1 - q / 0.1))..blendMode = BlendMode.plus);

    if (writesYear) {
      // 粒子飛到點陣位置排出 2027，停一下閃爍，再像光塵一樣落下
      final cell = w * 0.0072;
      for (var j = 0; j < _year.length; j++) {
        final target = burst + _year[j] * cell;
        final a = j / _year.length * 2 * pi;
        final scatter = burst + Offset(cos(a), sin(a)) * w * 0.06;
        Offset pos;
        double alpha;
        if (q < 0.3) {
          final s = Curves.easeOutCubic.transform(q / 0.3);
          pos = Offset.lerp(Offset.lerp(burst, scatter, min(1, s * 2))!, target, s)!;
          alpha = 1;
        } else if (q < 0.72) {
          pos = target + Offset(sin(t * 6 + j) * 0.4, cos(t * 5 + j) * 0.4);
          alpha = 0.8 + 0.2 * sin(t * 8 + j);
        } else {
          final s = (q - 0.72) / 0.28;
          pos = target + Offset((_h(j, 30) - 0.5) * w * 0.03 * s, h * 0.12 * s * s);
          alpha = 1 - s;
        }
        _dot(canvas, pos, 1.25, j % 5 == 0 ? Colors.white : _gold, alpha, halo: 2.2);
      }
      return;
    }

    // 一般的粒子煙火：kind 0 菊花（一圈）、1 雙色兩層、2 金色垂柳（慢、垂得長）
    final kind = (cycle + slot) % 3;
    final reach = w * (kind == 2 ? 0.12 : 0.1) * Curves.easeOutCubic.transform(min(1, q * 1.4));
    final gravity = h * (kind == 2 ? 0.15 : 0.07) * q * q;
    final fade = q < 0.65 ? 1.0 : (1 - q) / 0.35;
    final sparks = kind == 1 ? 44 : 36;
    for (var j = 0; j < sparks; j++) {
      final inner = kind == 1 && j.isOdd;
      final a = j / sparks * 2 * pi + _h(seed, 3) * pi;
      final dist = reach * (inner ? 0.55 : 1.0) * (0.82 + 0.18 * _h(seed + j, 4));
      final color = inner ? c2 : (kind == 2 ? _gold : c1);
      // 每道火花是一串粒子：頭最亮、往爆點方向越來越淡
      final trail = kind == 2 ? 6 : 4;
      for (var k = 0; k < trail; k++) {
        final back = k / trail * (kind == 2 ? 0.5 : 0.3);
        final d = dist * (1 - back);
        final pos = burst + Offset(cos(a) * d, sin(a) * d + gravity * (1 - back * 0.6));
        _dot(canvas, pos, (k == 0 ? 1.5 : 1.0) * (1 - k / trail * 0.5), color, fade * (1 - k / trail), halo: k == 0 ? 2.8 : 1.8);
      }
      // 尾聲：火花化成閃爍的光塵
      if (q > 0.5 && (j + cycle) % 2 == 0) {
        final tw = 0.5 + 0.5 * sin(t * 22 + j);
        _dot(canvas, burst + Offset(cos(a) * dist, sin(a) * dist + gravity + h * 0.03 * q), 0.9, Colors.white, tw * fade);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock();
    _dust(canvas, stage, t, _gold, 44, 7);
    for (var slot = 0; slot < 5; slot++) {
      _firework(canvas, slot, t);
    }
    _crown(canvas, t);
  }

  @override
  bool shouldRepaint(covariant AiyaNewYearSkinPainter old) => old.stage != stage;
}
