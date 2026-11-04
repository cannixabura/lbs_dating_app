import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

/// 艾婭的粒子全息像（規格 docs/aiya-spec.md §4）
///
/// 粒子的位置與顏色來自人像圖片（assets/aiya/aiya_cut.png，Vision 去背）的像素；
/// 五官座標（aiya_landmarks.json）決定哪些粒子屬於眼睛、眉毛、嘴巴，表情時把它們變形。
/// 數學與概念頁 docs/concepts/aiya-face.html 一致：細粒子、間距 2.8 像素、亮度補償 1.3。
class AiyaParticles {
  static const double step = 2.8;
  static const double gain = 1.3;
  static const int pillarCount = 1800;

  /// 0 一般、1 左眼、2 右眼、3 左眉、4 右眉、5 嘴巴與下巴、9 光柱（永遠是光柱）
  final Uint8List region;
  final Float32List base, pillar, local, extra, rgb;
  final Float32List seed, head, size;
  final int count;
  final double neckY;
  /// 一顆粒子在世界座標的精靈直徑
  final double dotWorld;

  AiyaParticles._(this.region, this.base, this.pillar, this.local, this.extra, this.rgb, this.seed, this.head, this.size, this.count, this.neckY, this.dotWorld);

  static AiyaParticles? _cached;
  static Future<AiyaParticles>? _loading;

  /// 第一次打開時產生一次，之後共用
  static Future<AiyaParticles> load() {
    if (_cached != null) return Future.value(_cached);
    return _loading ??= _build().then((p) => _cached = p);
  }

  static Future<AiyaParticles> _build() async {
    final lm = jsonDecode(await rootBundle.loadString('assets/aiya/aiya_landmarks.json')) as Map<String, dynamic>;
    final bytes = await rootBundle.load('assets/aiya/aiya_cut.png');
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final image = (await codec.getNextFrame()).image;
    final w = image.width, h = image.height;
    final px = (await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba))!.buffer.asUint8List();
    image.dispose();

    // ---------- 五官座標換成世界座標（臉高 0.9） ----------
    final size0 = (lm['size'] as List).first as List;
    final sx = w / (size0[0] as num), sy = h / (size0[1] as num); // 圖片與座標檔的比例（通常是 1）
    final fb = ((lm['faceBox'] as List).first as List).map((v) => (v as num).toDouble()).toList();
    final k = 0.9 / (fb[3] * sy), fcx = (fb[0] + fb[2] / 2) * sx, fcy = (fb[1] + fb[3] / 2) * sy;
    const lift = 0.42;
    (double, double) toW(double x, double y) => ((x - fcx) * k, -(y - fcy) * k + lift);
    ({double minX, double maxX, double minY, double maxY, double cx}) bounds(String name) {
      final pts = [for (final p in lm[name] as List) toW(((p as List)[0] as num) * sx, (p[1] as num) * sy)];
      final xs = pts.map((p) => p.$1), ys = pts.map((p) => p.$2);
      return (minX: xs.reduce(min), maxX: xs.reduce(max), minY: ys.reduce(min), maxY: ys.reduce(max), cx: xs.reduce((a, b) => a + b) / pts.length);
    }

    final eyes = [for (final (n, b) in [('leftEye', 'leftBrow'), ('rightEye', 'rightBrow')]) () {
      final e = bounds(n), br = bounds(b);
      final hh = max(0.012, e.maxY - e.minY);
      final bottom = e.minY - hh * 0.15, top = e.maxY + hh * 0.2;
      return (cx: e.cx, w: e.maxX - e.minX, bottom: bottom, h: top - bottom, top: top, browLow: br.minY, brow: br);
    }()];
    final lipsO = bounds('outerLips'), lipsI = bounds('innerLips'), contour = bounds('contour');
    final mouthCx = lipsO.cx, mouthHw = (lipsO.maxX - lipsO.minX) / 2, innerTop = lipsI.maxY, innerBot = lipsI.minY, chin = contour.minY;
    final faceCx = contour.cx, faceCy = (contour.minY + eyes[0].browLow) / 2 + 0.02;
    final faceRx = (contour.maxX - contour.minX) / 2 * 1.02, faceRy = (eyes[0].browLow - contour.minY) / 2 * 1.45;
    final neckY = contour.minY - 0.04;
    final botY = toW(0, h.toDouble()).$2;
    double sm(double a, double b, double x) { final t = ((x - a) / (b - a)).clamp(0.0, 1.0); return t * t * (3 - 2 * t); }

    final rnd = Random(20261104); // 固定種子：每次產生的粒子都一樣
    final reg = <int>[], bas = <double>[], pil = <double>[], loc = <double>[], ext = <double>[], col = <double>[], sed = <double>[], hd = <double>[], sz = <double>[];

    for (double y = 0; y < h; y += step) {
      for (double x = 0; x < w; x += step) {
        final jx = x + (rnd.nextDouble() - 0.5) * step * 0.9, jy = y + (rnd.nextDouble() - 0.5) * step * 0.9;
        final (wx0, wy0) = toW(jx, jy);
        if (wy0 < botY + 0.45 && rnd.nextDouble() > sm(botY, botY + 0.45, wy0)) continue; // 底部慢慢消散
        final ix = jx.round().clamp(0, w - 1), iy = jy.round().clamp(0, h - 1);
        final o = (iy * w + ix) * 4;
        if (px[o + 3] < 140) continue;
        var r = px[o] / 255, g = px[o + 1] / 255, b = px[o + 2] / 255;
        final lum = 0.3 * r + 0.59 * g + 0.11 * b;
        if (lum < 0.16 || (b > r - 0.02 && lum < 0.5)) continue; // 麥克風
        r = min(1.6, r * gain); g = min(1.6, g * gain); b = min(1.6, b * gain);
        final X = wx0, Y = wy0;

        // 深度：臉是橢球、頭髮在後、身體更後，之間平順過渡
        final fx = (X - faceCx) / faceRx, fy = (Y - faceCy) / faceRy, fq = 1 - fx * fx - fy * fy;
        final hx = (X - faceCx) / (faceRx * 1.9), hy = (Y - faceCy) / (faceRy * 1.5);
        final zHair = 0.32 * sqrt(max(0, 1 - hx * hx - hy * hy)) - 0.12;
        final bx = X / 1.5, zBody = 0.2 * sqrt(max(0, 1 - bx * bx)) - 0.28;
        var zFace = 0.42 * sqrt(max(0, fq));
        { final nx = X - faceCx, ny = Y - (eyes[0].bottom - 0.16); zFace += 0.07 * exp(-(nx * nx / 0.0015 + ny * ny / 0.012)); }
        final blend = sm(0, 0.3, fq);
        final zHead = max(zHair, zFace * blend + zHair * (1 - blend));
        var Z = zBody + (zHead - zBody) * sm(neckY - 0.12, neckY + 0.04, Y);
        Z += (lum - 0.5) * 0.02;

        // 部位
        var rg = 0;
        var l = const [0.0, 0.0, 0.0], e = const [0.0, 0.0, 0.0];
        for (var i = 0; i < 2; i++) {
          final ey = eyes[i], dx = X - ey.cx, hl = max(0.01, ey.browLow - ey.top);
          if (dx.abs() < ey.w * 0.8 && Y > ey.bottom - ey.h * 0.4 && Y < ey.browLow - 0.004) {
            final v = (Y - ey.bottom) / ey.h;
            final wx = (1 - pow(dx.abs() / (ey.w * 0.8), 4)).clamp(0.0, 1.0).toDouble();
            final inside = max(0.0, 1 - pow(dx / (ey.w * 0.5), 2)) * (v > 0 && v < 1 ? sin(pi * v) : 0);
            rg = 1 + i; l = [v, ey.h, hl]; e = [wx, inside.toDouble(), ey.w];
          }
          final br = ey.brow, bw = br.maxX - br.minX;
          if (rg == 0 && X > br.minX - 0.01 && X < br.maxX + 0.01 && Y > br.minY - 0.012 && Y < br.maxY + 0.02) {
            final inner = i == 0 ? (X - br.minX) / bw : (br.maxX - X) / bw;
            rg = 3 + i; l = [(eyes[0].cx < eyes[1].cx ? inner : 1 - inner).clamp(0.0, 1.0), 0, 0]; e = const [1, 0, 0];
          }
        }
        if (rg == 0) {
          final dx = X - mouthCx, d = max(0.012, innerTop - innerBot);
          if (Y < innerTop && Y > chin - 0.25 && dx.abs() < faceRx * 0.95) {
            final double m = Y > innerBot ? (innerTop - Y) / d : (Y > chin ? 1 : 1 - (chin - Y) / 0.25);
            final wMouth = Y > innerBot - 0.03 ? (1 - pow(dx / (mouthHw * 1.15), 2)).clamp(0.0, 1.0).toDouble() : (1 - pow(dx / (faceRx * 0.9), 2)).clamp(0.0, 1.0).toDouble();
            if (m > 0 && wMouth > 0) { rg = 5; l = [m, d, Y > innerBot ? 1 : 0]; e = [wMouth, 0, 0]; }
          }
        }
        reg.add(rg); bas.addAll([X, Y, Z]); loc.addAll(l); ext.addAll(e); col.addAll([r, g, b]);
        sed.add(rnd.nextDouble()); hd.add(sm(neckY - 0.25, neckY + 0.05, Y)); sz.add(1);
        final pr = 0.03 + 0.3 * pow(rnd.nextDouble(), 2), pa = rnd.nextDouble() * 2 * pi;
        pil.addAll([cos(pa) * pr, rnd.nextDouble() * 8 - 4, sin(pa) * pr]);
      }
    }
    // 光柱本身
    for (var i = 0; i < pillarCount; i++) {
      final pr = 0.02 + 0.25 * pow(rnd.nextDouble(), 3), pa = rnd.nextDouble() * 2 * pi;
      reg.add(9); bas.addAll([0, 0, 0]); loc.addAll([0, 0, 0]); ext.addAll([0, 0, 0]); col.addAll([0, 0, 0]);
      sed.add(rnd.nextDouble()); hd.add(0); sz.add(1.1 + rnd.nextDouble() * 0.9);
      pil.addAll([cos(pa) * pr, rnd.nextDouble() * 8 - 4, sin(pa) * pr]);
    }
    const dot = 0.6, spacingPx = 1.6;
    return AiyaParticles._(Uint8List.fromList(reg), Float32List.fromList(bas), Float32List.fromList(pil), Float32List.fromList(loc), Float32List.fromList(ext),
        Float32List.fromList(col), Float32List.fromList(sed), Float32List.fromList(hd), Float32List.fromList(sz), reg.length, neckY, spacingPx * k * dot * 3.2 * 1.9);
  }
}

/// 一顆柔光圓點（細亮點＋淡光暈），所有粒子共用
Future<ui.Image> aiyaDotSprite() async {
  const s = 64;
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const c = ui.Offset(s / 2, s / 2);
  canvas.drawCircle(c, s / 2, ui.Paint()..shader = ui.Gradient.radial(c, s / 2, [const ui.Color(0x29FFFFFF), const ui.Color(0x0AFFFFFF), const ui.Color(0x00FFFFFF)], [0, 0.55, 1]));
  canvas.drawCircle(c, s * 0.15, ui.Paint()..shader = ui.Gradient.radial(c, s * 0.15, [const ui.Color(0xFFFFFFFF), const ui.Color(0xFFFFFFFF), const ui.Color(0x00FFFFFF)], [0, 0.55, 1]));
  return recorder.endRecording().toImage(s, s);
}
