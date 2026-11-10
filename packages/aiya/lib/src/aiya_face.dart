import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'aiya_particles.dart';

/// 表情（伺服器回傳的名稱與這裡一致）。照片本身是露齒笑，所以「閉嘴」用 open 負值。
class AiyaExpr {
  final double open, brow, frown, blinkL, blinkR, gx, gy, yaw, pitch, roll;
  const AiyaExpr({this.open = -0.85, this.brow = 0, this.frown = 0, this.blinkL = 0, this.blinkR = 0, this.gx = 0, this.gy = 0, this.yaw = 0, this.pitch = 0, this.roll = 0});

  static const presets = <String, AiyaExpr>{
    'calm': AiyaExpr(),
    'smile': AiyaExpr(open: 0, brow: 0.15, roll: 0.03),
    'surprise': AiyaExpr(open: 0.9, brow: 1, blinkL: -0.25, blinkR: -0.25, pitch: -0.05),
    'think': AiyaExpr(open: -1, frown: 0.35, brow: 0.3, gx: 0.8, gy: 0.7, yaw: 0.14, roll: -0.05),
    'shy': AiyaExpr(open: -0.6, gx: -0.4, gy: -0.8, pitch: 0.12, roll: 0.08, yaw: -0.08, blinkL: 0.25, blinkR: 0.25),
    'worry': AiyaExpr(open: -0.95, frown: -0.8, brow: 0.35, gy: -0.25),
    'wink': AiyaExpr(open: -0.2, blinkR: 1, brow: 0.15, roll: 0.05),
  };
}

/// 臉的動畫狀態：聚散、表情、自動眨眼、視線跳動、微表情、說話嘴型
class AiyaAnimator {
  final _rnd = Random();
  double time = 0, form = 0, formTarget = 0, pulse = 0;
  final List<double> _knocks = [];
  // 目前與目標表情（平滑過渡）
  final cur = <String, double>{}, target = <String, double>{};
  String expr = 'calm';
  // 輸出給畫家的值
  double open = -0.85, brow = 0, frown = 0, blinkL = 0, blinkR = 0, gazeX = 0, gazeY = 0, breath = 0;
  final head = Float64List(9);
  // 自動行為
  double _nextBlink = 2, _blinkT = -1, _nextSacc = 1, _saccX = 0, _saccY = 0, _saccTX = 0, _saccTY = 0;
  double _nextMicro = 3, _micro = 0, _microT = 0, _microEnd = 0;
  // 說話
  double _talk = 0, _talkTarget = 0;
  bool reduceMotion = false;
  Offset pointer = Offset.zero; // -1～1，手指的位置（眼睛跟著看）

  AiyaAnimator() { setExpr('calm'); _copy(cur, target); }

  void _copy(Map<String, double> to, Map<String, double> from) => to..clear()..addAll(from);

  void setExpr(String name) {
    expr = AiyaExpr.presets.containsKey(name) ? name : 'calm';
    final e = AiyaExpr.presets[expr]!;
    target..['open'] = e.open..['brow'] = e.brow..['frown'] = e.frown..['blinkL'] = e.blinkL..['blinkR'] = e.blinkR
      ..['gx'] = e.gx..['gy'] = e.gy..['yaw'] = e.yaw..['pitch'] = e.pitch..['roll'] = e.roll;
  }

  /// 叩叩叩：光柱脈動三下
  void knock() => _knocks..clear()..addAll([time, time + 0.38, time + 0.76]);

  /// 說了一個字：嘴巴張開一下；標點就閉上
  void speakChar(String ch) => _talkTarget = '，。？！、「」…：,.?!:;'.contains(ch) ? 0 : 0.35 + _rnd.nextDouble() * 0.6;

  void update(double dt) {
    time += dt;
    final fs = dt / 1.9;
    form += (formTarget - form).clamp(-fs, fs);
    var p = 0.0;
    for (final k in _knocks) { final d = time - k; if (d > 0 && d < 0.6) p = max(p, sin(d / 0.6 * pi) * (1 - d / 0.6)); }
    pulse = p * 0.6;

    var blink = 0.0;
    if (time > _nextBlink && _blinkT < 0) _blinkT = 0;
    if (_blinkT >= 0) {
      _blinkT += dt; final d = _blinkT;
      blink = d < 0.07 ? d / 0.07 : d < 0.12 ? 1 : d < 0.28 ? 1 - (d - 0.12) / 0.16 : 0;
      if (d > 0.28) { _blinkT = -1; _nextBlink = time + 2 + _rnd.nextDouble() * 4 + (_rnd.nextDouble() < 0.15 ? -1.7 : 0); }
    }
    if (time > _nextSacc) { _saccTX = (_rnd.nextDouble() - 0.5) * 0.5; _saccTY = (_rnd.nextDouble() - 0.5) * 0.3; _nextSacc = time + 0.5 + _rnd.nextDouble() * 2.2; }
    final es = 1 - exp(-dt * 30);
    _saccX += (_saccTX - _saccX) * es; _saccY += (_saccTY - _saccY) * es;
    if (time > _nextMicro) { _microT = 0.2 + _rnd.nextDouble() * 0.15; _microEnd = time + 0.26 + _rnd.nextDouble() * 0.3; _nextMicro = time + 2.5 + _rnd.nextDouble() * 4; }
    if (time > _microEnd) _microT = 0;
    _micro += (_microT - _micro) * (1 - exp(-dt * 14));

    _talkTarget *= exp(-dt * 7);
    _talk += (_talkTarget - _talk) * (1 - exp(-dt * 26));

    for (final k in target.keys) {
      final rate = k == 'open' ? 14.0 : 6.0;
      cur[k] = cur[k]! + (target[k]! - cur[k]!) * (1 - exp(-dt * rate));
    }
    final m = reduceMotion ? 0.15 : 1.0;
    breath = sin(time * 1.25) * m;
    open = cur['open']! + _talk * 1.3;
    brow = cur['brow']! + _micro + _talk * 0.15;
    frown = cur['frown']!;
    blinkL = min(1, cur['blinkL']! + blink * (1 - max(0, cur['blinkL']!)));
    blinkR = min(1, cur['blinkR']! + blink * (1 - max(0, cur['blinkR']!)));
    gazeX = (cur['gx']! + _saccX + pointer.dx * 0.8).clamp(-1.0, 1.0);
    gazeY = (cur['gy']! + _saccY + pointer.dy * 0.8).clamp(-1.0, 1.0);
    // 頭部旋轉矩陣（YXZ）
    final pitch = cur['pitch']! - pointer.dy * 0.08 + sin(time * 0.37) * 0.025 * m;
    final yaw = cur['yaw']! + pointer.dx * 0.18 + sin(time * 0.23) * 0.04 * m;
    final roll = cur['roll']! + sin(time * 0.31) * 0.015 * m;
    final cx = cos(pitch), sx = sin(pitch), cy = cos(yaw), sy = sin(yaw), cz = cos(roll), sz = sin(roll);
    // R = Ry * Rx * Rz
    head[0] = cy * cz + sy * sx * sz; head[1] = -cy * sz + sy * sx * cz; head[2] = sy * cx;
    head[3] = cx * sz;                head[4] = cx * cz;                 head[5] = -sx;
    head[6] = -sy * cz + cy * sx * sz; head[7] = sy * sz + cy * sx * cz; head[8] = cy * cx;
  }
}

/// 城市心情的四種顏色與比例（光柱與粒子的淡淡色調）
class AiyaMood {
  final List<Color> colors;
  final List<double> cumulative; // 前三個累積比例
  const AiyaMood(this.colors, this.cumulative);
  static const night = AiyaMood([Color(0xFFA99CFF), Color(0xFF5AB8FF), Color(0xFF4DE3A0), Color(0xFFFF6BD6)], [0.38, 0.65, 0.87]);
  Color at(double m) => m < cumulative[0] ? colors[0] : m < cumulative[1] ? colors[1] : m < cumulative[2] ? colors[2] : colors[3];
}

/// 用 drawRawAtlas 一次畫完所有粒子，疊加發光
class AiyaPainter extends CustomPainter {
  final AiyaParticles p;
  final AiyaAnimator a;
  final ui.Image sprite;
  final AiyaMood mood;
  /// 人像要落在的區域（畫面座標）
  final Rect stage;
  final Float32List _xf, _rect;
  final Int32List _col;

  AiyaPainter(this.p, this.a, this.sprite, {required this.stage, this.mood = AiyaMood.night, required Listenable repaint, required Float32List xf, required Float32List rect, required Int32List col})
      : _xf = xf, _rect = rect, _col = col, super(repaint: repaint);

  /// 每個畫面重複使用的陣列
  static (Float32List, Float32List, Int32List) buffers(int n) {
    final rect = Float32List(n * 4);
    for (var i = 0; i < n; i++) { rect[i * 4 + 2] = 64; rect[i * 4 + 3] = 64; }
    return (Float32List(n * 4), rect, Int32List(n));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const camD = 6.0, figureH = 3.1;
    final focal = stage.height * camD / figureH;
    final cx = stage.center.dx, cy = stage.center.dy;
    final t = a.time, motion = a.reduceMotion ? 0.15 : 1.0;
    final h = a.head;
    final pivY = p.neckY, pivZ = -0.15;
    final pillarDot = max(1.4, size.height * 0.0032);
    var n = 0;

    for (var i = 0; i < p.count; i++) {
      final r = p.region[i], seed = p.seed[i];
      final i3 = i * 3;
      // 光柱上的位置：往上流動、繞著轉
      double px = 0, py = 0, pz = 0;
      final f0 = r == 9 ? 0.0 : ((a.form * 1.7 - seed * 0.7).clamp(0.0, 1.0));
      final f = f0 * f0 * (3 - 2 * f0);
      if (f < 1) {
        var yy = p.pillar[i3 + 1] + t * (0.25 + seed * 0.55) * motion + 4;
        yy = yy - (yy / 8).floorToDouble() * 8 - 4;
        final ang = t * (0.2 + seed * 0.3) * motion;
        final ca = cos(ang), sa = sin(ang), spread = 1 + a.pulse * (1.2 + seed);
        px = (ca * p.pillar[i3] - sa * p.pillar[i3 + 2]) * spread;
        pz = (sa * p.pillar[i3] + ca * p.pillar[i3 + 2]) * spread;
        py = yy;
      }
      double x, y, z, alpha;
      if (r == 9) {
        x = px; y = py; z = pz;
        alpha = 0.5 * (1 - 0.85 * a.form) * (1 + a.pulse * 1.5) * (1 - _smooth(2.6, 4.0, y.abs())) * (0.78 + 0.22 * sin(t * 3 + seed * 60));
      } else {
        // 表情變形
        var fx = p.base[i3], fy = p.base[i3 + 1], fz = p.base[i3 + 2];
        if (r == 1 || r == 2) {
          final b = r == 1 ? a.blinkL : a.blinkR;
          final v = p.local[i3], eh = p.local[i3 + 1], hl = p.local[i3 + 2];
          final bottom = fy - v * eh, hb = eh * (1 - b);
          double ny;
          if (v <= 1) {
            ny = bottom + max(v, 0) * hb + min(v, 0) * eh;
          } else {
            final tt = ((v * eh - eh) / hl).clamp(0.0, 1.0);
            ny = bottom + hb + tt * (hl + eh * b) + max(v * eh - eh - hl, 0);
          }
          final wx = p.extra[i3];
          fy = fy + (ny - fy) * wx;
          fx += a.gazeX * p.extra[i3 + 2] * 0.12 * p.extra[i3 + 1];
          fy += a.gazeY * eh * 0.12 * p.extra[i3 + 1] * (1 - max(b, 0));
          if (v > 1) fy += a.brow * 0.012 * wx;
        } else if (r == 3 || r == 4) {
          final tt = p.local[i3];
          fy += a.brow * 0.028 - a.frown * 0.02 * tt + a.frown * 0.006;
        } else if (r == 5) {
          fy -= a.open * p.local[i3 + 1] * p.local[i3] * p.extra[i3];
        }
        final hw = p.head[i];
        fy += a.breath * 0.006 * (1 - hw) + a.breath * 0.004;
        // 頭部轉動（以脖子為軸；身體只跟著轉三成）
        final qx = fx, qy = fy - pivY, qz = fz - pivZ;
        final rx = h[0] * qx + h[1] * qy + h[2] * qz, ry = h[3] * qx + h[4] * qy + h[5] * qz, rz = h[6] * qx + h[7] * qy + h[8] * qz;
        final wgt = 0.3 + 0.7 * hw;
        fx = qx + (rx - qx) * wgt; fy = qy + (ry - qy) * wgt + pivY; fz = qz + (rz - qz) * wgt + pivZ;
        if (f >= 1) {
          x = fx; y = fy; z = fz;
        } else {
          final sw = sin(f * pi) * 0.7 * motion;
          x = px + (fx - px) * f + cos(seed * 30 + t) * sw;
          y = py + (fy - py) * f + sin(seed * 12) * 0.5 * sw;
          z = pz + (fz - pz) * f + sin(seed * 30 + t) * sw;
        }
        alpha = 0.55 + 0.41 * f;
        if (r == 5 && p.local[i3 + 2] > 0.5) alpha *= 1 + ((1 + a.open).clamp(0.08, 1.0) - 1) * p.extra[i3]; // 閉嘴時擠在一起的牙齒淡出
      }
      if (alpha <= 0.01) continue;
      final depth = camD - z;
      if (depth < 0.5) continue;
      final s = focal / depth;
      final sxp = cx + x * s, syp = cy - y * s;
      if (syp < -20 || syp > size.height + 20 || sxp < -20 || sxp > size.width + 20) continue;
      final diam = r == 9 ? pillarDot * p.size[i] * 2.2 : p.dotWorld * s;
      final scale = diam / 64;
      final o = n * 4;
      _xf[o] = scale; _xf[o + 1] = 0; _xf[o + 2] = sxp - 32 * scale; _xf[o + 3] = syp - 32 * scale;
      // 顏色：光柱是心情色，聚成人像後是她本人的顏色
      final mc = mood.at((seed * 7.13) % 1);
      double cr, cg, cb;
      if (r == 9) {
        final pr = 0.72 + (0.45 - 0.72) * seed, pg = 0.55 + (0.82 - 0.55) * seed;
        cr = pr * 0.65 + mc.r * 0.35; cg = pg * 0.65 + mc.g * 0.35; cb = 1.0 * 0.65 + mc.b * 0.35;
      } else {
        final scan = 0.94 + 0.06 * sin(p.base[i3 + 1] * 160 - t * 3);
        final pr = (p.rgb[i3] * 0.92 + mc.r * 0.08) * scan, pg = (p.rgb[i3 + 1] * 0.92 + mc.g * 0.08) * scan, pb = (p.rgb[i3 + 2] * 0.92 + mc.b * 0.08) * scan;
        final lr = 0.75 * 0.5 + mc.r * 0.5, lg = 0.6 * 0.5 + mc.g * 0.5, lb = 1.0 * 0.5 + mc.b * 0.5;
        cr = lr + (pr - lr) * f; cg = lg + (pg - lg) * f; cb = lb + (pb - lb) * f;
      }
      _col[n] = (((alpha.clamp(0.0, 1.0) * 255).round()) << 24) | (((cr.clamp(0.0, 1.0) * 255).round()) << 16) | (((cg.clamp(0.0, 1.0) * 255).round()) << 8) | ((cb.clamp(0.0, 1.0) * 255).round());
      n++;
    }
    if (n == 0) return;
    canvas.drawRawAtlas(sprite, Float32List.sublistView(_xf, 0, n * 4), Float32List.sublistView(_rect, 0, n * 4), Int32List.sublistView(_col, 0, n),
        BlendMode.modulate, null, Paint()..blendMode = BlendMode.plus..filterQuality = FilterQuality.low);
  }

  static double _smooth(double a, double b, double x) { final t = ((x - a) / (b - a)).clamp(0.0, 1.0); return t * t * (3 - 2 * t); }

  @override
  bool shouldRepaint(covariant AiyaPainter old) => true;
}
