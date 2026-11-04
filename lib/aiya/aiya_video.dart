import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aiya_face.dart';

/// 艾婭的影片全息像（概念頁 docs/concepts/aiya-face.html 的 App 版）
///
/// 每支片段事先處理成逐格小圖（assets/aiya/clips/*.aiya，200×189 JPEG，已調好全息光色、乘上遮罩）。
/// 粒子位置固定在網格上，畫的時候每顆粒子直接從目前那一格圖片取色（drawRawAtlas 以影格當圖集），
/// 所以手機不用逐格分析影片；眨眼、嘴型、轉頭都是影片裡的真實動作。
/// 片段都從同一個姿勢開始，播完再倒著播回來，所以結束時剛好回到起點，可以無縫接下一支。

const _dir = 'assets/aiya/clips/';
const _fps = 24.0;
const _imgW = 200, _imgH = 189;

/// 伺服器的表情 → 影片片段
const aiyaExprClip = {'calm': 'idle', 'smile': 'idle', 'surprise': 'surprise', 'think': 'think', 'shy': 'shy', 'worry': 'worry', 'wink': 'wink', 'laugh': 'laugh'};
const aiyaTalkClips = ['talk1', 'talk_soft', 'talk_slow'];

/// 一支片段：所有影格的 JPEG（解碼留到要用時）
class _Clip {
  final List<Uint8List> frames;
  _Clip(this.frames);
  static Future<_Clip> load(String name) async {
    final data = await rootBundle.load('$_dir$name.aiya');
    final bd = data.buffer.asByteData(data.offsetInBytes, data.lengthInBytes);
    final n = bd.getUint32(0, Endian.little);
    var o = 4 + 4 * n;
    final frames = <Uint8List>[];
    for (var i = 0; i < n; i++) {
      final len = bd.getUint32(4 + 4 * i, Endian.little);
      frames.add(data.buffer.asUint8List(data.offsetInBytes + o, len));
      o += len;
    }
    return _Clip(frames);
  }
}

/// 一次播放：哪一支、從什麼時候開始、要不要一直循環
class _Play {
  final String name;
  final _Clip clip;
  final double start;
  final bool loop;
  _Play(this.name, this.clip, this.start, this.loop);
  int get n => clip.frames.length;
  /// 播完再倒回的總格數
  int get cycle => max(1, 2 * n - 2);
  bool ended(double t) => !loop && (t - start) * _fps >= cycle;
  int index(double t) {
    var k = ((t - start) * _fps).floor();
    if (!loop) k = min(k, cycle - 1);
    k %= cycle;
    return k < n ? k : cycle - k;
  }
}

/// 片段播放器：解碼目前和接下來幾格，切換時淡入 0.3 秒
class AiyaVideo {
  final _clips = <String, _Clip>{};
  final _loading = <String, Future<_Clip>>{};
  final _images = <String, ui.Image>{};
  final _decoding = <String>{};
  _Play? _cur, _prev;
  double _fadeStart = 0;
  bool _endSent = false;
  ui.Image? _lastCur, _lastPrev;
  /// 一支非循環片段播完時（通常接回 idle）
  void Function(String name)? onEnd;
  bool _disposed = false;

  Future<void> preload(Iterable<String> names) => Future.wait(names.map(_load));
  Future<_Clip> _load(String name) => _clips[name] != null ? Future.value(_clips[name]) : (_loading[name] ??= _Clip.load(name).then((c) => _clips[name] = c));

  String? get current => _cur?.name;

  /// 播一支片段；time 是動畫時鐘（AiyaAnimator.time）
  Future<void> play(String name, double time, {bool loop = false}) async {
    if (_cur?.name == name && loop && _cur!.loop) return;
    final clip = await _load(name);
    if (_disposed) return;
    _prev = _cur;
    _lastPrev = _lastCur;
    _fadeStart = time;
    _cur = _Play(name, clip, time, loop);
    _lastCur = null;
    _endSent = false;
  }

  /// 每個畫面呼叫：回傳 (目前影格, 前一支的影格, 新片段的比重)
  (ui.Image?, ui.Image?, double) frame(double time) {
    final cur = _cur;
    if (cur == null) return (null, null, 1);
    if (!_endSent && cur.ended(time)) { _endSent = true; onEnd?.call(cur.name); }
    final img = _image(cur, time) ?? _lastCur;
    if (img != null) _lastCur = img;
    var mix = ((time - _fadeStart) / 0.3).clamp(0.0, 1.0);
    ui.Image? prevImg;
    if (_prev != null && mix < 1 && _lastPrev != null) {
      prevImg = _image(_prev!, time) ?? _lastPrev;
      _lastPrev = prevImg;
    } else {
      _prev = null;
      mix = 1;
    }
    if (img == null && prevImg != null) return (prevImg, null, 1);
    _gc(time);
    return (img, prevImg, mix);
  }

  ui.Image? _image(_Play p, double time) {
    final i = p.index(time);
    // 先解碼接下來幾格
    for (var k = 0; k < 4; k++) {
      final j = p.index(time + k / _fps);
      _decode(p, j);
    }
    return _images['${p.name}:$i'];
  }

  void _decode(_Play p, int i) {
    final key = '${p.name}:$i';
    if (_images.containsKey(key) || _decoding.contains(key)) return;
    _decoding.add(key);
    ui.instantiateImageCodec(p.clip.frames[i]).then((c) => c.getNextFrame()).then((f) {
      _decoding.remove(key);
      if (_disposed) { f.image.dispose(); return; }
      _images[key] = f.image;
    }, onError: (_) { _decoding.remove(key); });
  }

  /// 只留目前和下一段要用的影格
  void _gc(double time) {
    if (_images.length < 16) return;
    final keep = <String>{};
    for (final p in [_cur, _prev]) {
      if (p == null) continue;
      for (var k = -1; k < 6; k++) { keep.add('${p.name}:${p.index(time + k / _fps)}'); }
    }
    for (final img in [_lastCur, _lastPrev]) {
      if (img == null) continue;
      _images.forEach((k, v) { if (identical(v, img)) keep.add(k); });
    }
    _images.removeWhere((k, v) { if (keep.contains(k)) return false; v.dispose(); return true; });
  }

  void dispose() {
    _disposed = true;
    for (final i in _images.values) { i.dispose(); }
    _images.clear();
  }
}

/// 粒子：固定網格（只留任何片段裡曾經亮過的位置），深度來自第一格的深度圖
class AiyaHolo {
  static const step = 3.6, panelW = 2.4, yOff = 0.05, depthScale = 0.8, pillarCount = 1800;
  static const cols = 160, rows = 151; // 576/3.6、544/3.6
  static const panelH = panelW * 544 / 576;

  final int faceCount, count;
  /// 前 faceCount 顆是人像，後面是光柱
  final Float32List base, pillar, src, seed, size, edge;

  AiyaHolo._(this.faceCount, this.count, this.base, this.pillar, this.src, this.seed, this.size, this.edge);

  static AiyaHolo? _cached;
  static Future<AiyaHolo>? _building;
  static Future<AiyaHolo> load() => _cached != null ? Future.value(_cached) : (_building ??= _build().then((h) => _cached = h));

  static Future<Uint8List> _gray(String path) async {
    final bytes = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
    final img = (await codec.getNextFrame()).image;
    final px = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    img.dispose();
    return Uint8List.fromList([for (var i = 0; i < px.length; i += 4) px[i]]);
  }

  static Future<AiyaHolo> _build() async {
    final union = await _gray('${_dir}union.png'), depth = await _gray('${_dir}depth.png');
    final rnd = Random(20261104);
    final bas = <double>[], pil = <double>[], src = <double>[], sed = <double>[], sz = <double>[], edg = <double>[];
    double sm(double a, double b, double x) { final t = ((x - a) / (b - a)).clamp(0.0, 1.0); return t * t * (3 - 2 * t); }
    final botY = -panelH / 2 + yOff;
    for (var j = 0; j < rows; j++) {
      for (var i = 0; i < cols; i++) {
        final u = (i + 0.5 + (rnd.nextDouble() - 0.5) * 0.9) / cols, v = (j + 0.5 + (rnd.nextDouble() - 0.5) * 0.9) / rows;
        final s = rnd.nextDouble();
        final pr = 0.03 + 0.3 * pow(rnd.nextDouble(), 2), pa = rnd.nextDouble() * 2 * pi;
        final ix = (u * _imgW).floor().clamp(0, _imgW - 1), iy = (v * _imgH).floor().clamp(0, _imgH - 1);
        if (union[iy * _imgW + ix] < 20) continue; // 從來沒亮過的背景
        final x = (u - 0.5) * panelW, y = (0.5 - v) * panelH + yOff;
        // 底部和左右用隨機門檻消散，不留直邊
        final e = sm(botY + 0.02, botY + 0.55, y) * sm(0, 0.1, u) * sm(1, 0.9, u);
        if (s * 0.98 > e) continue;
        final z = depth[iy * _imgW + ix] / 255 * depthScale - depthScale / 2;
        bas.addAll([x, y, z]);
        src.addAll([u * _imgW - 0.5, v * _imgH - 0.5]);
        sed.add(s); sz.add(1); edg.add(e);
        pil.addAll([cos(pa) * pr, rnd.nextDouble() * 8 - 4, sin(pa) * pr]);
      }
    }
    final faceCount = sed.length;
    for (var i = 0; i < pillarCount; i++) {
      final pr = 0.02 + 0.25 * pow(rnd.nextDouble(), 3), pa = rnd.nextDouble() * 2 * pi;
      bas.addAll([0, 0, 0]); src.addAll([0, 0]); sed.add(rnd.nextDouble()); sz.add(1.1 + rnd.nextDouble() * 0.9); edg.add(1);
      pil.addAll([cos(pa) * pr, rnd.nextDouble() * 8 - 4, sin(pa) * pr]);
    }
    return AiyaHolo._(faceCount, sed.length, Float32List.fromList(bas), Float32List.fromList(pil), Float32List.fromList(src), Float32List.fromList(sed), Float32List.fromList(sz), Float32List.fromList(edg));
  }
}

/// 畫光柱和影片人像：光柱用柔光點，人像的每顆粒子從影格取色，再疊一層模糊的影格當光暈
class AiyaHoloPainter extends CustomPainter {
  final AiyaHolo h;
  final AiyaAnimator a;
  final AiyaVideo video;
  final ui.Image dot;
  final AiyaMood mood;
  final Rect stage;
  /// 光柱上的小尺寸版：不畫自己的光柱粒子（地圖上已經有光柱），人像粒子每 stride 顆取一顆
  final bool drawPillar;
  final int stride;
  final Float32List _xf, _rect, _pxf, _prect;
  final Int32List _col, _pcol;

  AiyaHoloPainter(this.h, this.a, this.video, this.dot, {required this.stage, this.mood = AiyaMood.night, this.drawPillar = true, this.stride = 1, required Listenable repaint, required AiyaHoloBuffers buf})
      : _xf = buf.xf, _rect = buf.rect, _col = buf.col, _pxf = buf.pxf, _prect = buf.prect, _pcol = buf.pcol, super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    const camD = 6.0, figureH = 3.1;
    final focal = stage.height * camD / figureH;
    final cx = stage.center.dx, cy = stage.center.dy;
    final t = a.time, motion = a.reduceMotion ? 0.15 : 1.0;
    // 整個人像輕輕左右轉，手指拖動可以看到一點側面
    final yaw = sin(t * 0.23) * 0.05 * motion + a.pointer.dx * 0.25, cyw = cos(yaw), syw = sin(yaw);
    final pitch = -a.pointer.dy * 0.08, cp = cos(pitch), sp = sin(pitch);
    final pillarDot = max(1.4, size.height * 0.0032);
    final (img, prevImg, mix) = video.frame(t);
    final dotWorld = AiyaHolo.panelW / AiyaHolo.cols * 0.55 * sqrt(stride); // 細亮點（光暈另外疊）；抽樣時點放大一點
    var n = 0, np = 0;

    for (var i = 0; i < h.count; i += i < h.faceCount ? stride : 1) {
      if (!drawPillar && i >= h.faceCount) break;
      final face = i < h.faceCount, seed = h.seed[i], i3 = i * 3;
      final f0 = face ? ((a.form * 1.7 - seed * 0.7).clamp(0.0, 1.0)) : 0.0;
      final f = f0 * f0 * (3 - 2 * f0);
      double px = 0, py = 0, pz = 0;
      if (f < 1) {
        var yy = h.pillar[i3 + 1] + t * (0.25 + seed * 0.55) * motion + 4;
        yy = yy - (yy / 8).floorToDouble() * 8 - 4;
        final ang = t * (0.2 + seed * 0.3) * motion, ca = cos(ang), sa = sin(ang), spread = 1 + a.pulse * (1.2 + seed);
        px = (ca * h.pillar[i3] - sa * h.pillar[i3 + 2]) * spread;
        pz = (sa * h.pillar[i3] + ca * h.pillar[i3 + 2]) * spread;
        py = yy;
      }
      double x, y, z, alpha;
      if (!face) {
        x = px; y = py; z = pz;
        alpha = 0.5 * (1 - 0.85 * a.form) * (1 + a.pulse * 1.5) * (1 - _smooth(2.6, 4.0, y.abs())) * (0.78 + 0.22 * sin(t * 3 + seed * 60));
      } else {
        if (img == null && f > 0.5) continue;
        var fx = h.base[i3], fy = h.base[i3 + 1] + a.breath * 0.004, fz = h.base[i3 + 2];
        final rx = fx * cyw + fz * syw, rz = -fx * syw + fz * cyw;
        final ry = fy * cp - rz * sp; fz = fy * sp + rz * cp; fx = rx; fy = ry;
        if (f >= 1) {
          x = fx; y = fy; z = fz;
        } else {
          final sw = sin(f * pi) * 0.7 * motion;
          x = px + (fx - px) * f + cos(seed * 30 + t) * sw;
          y = py + (fy - py) * f + sin(seed * 12) * 0.5 * sw;
          z = pz + (fz - pz) * f + sin(seed * 30 + t) * sw;
        }
        alpha = (0.55 + 0.45 * f) * (f < 0.02 ? 0 : 1);
      }
      if (alpha <= 0.01) continue;
      final depth = camD - z;
      if (depth < 0.5) continue;
      final s = focal / depth;
      final sx = cx + x * s, sy = cy - y * s;
      if (sy < -20 || sy > size.height + 20 || sx < -20 || sx > size.width + 20) continue;
      if (!face) {
        final diam = pillarDot * h.size[i] * 2.2, scale = diam / 64, o = np * 4;
        _pxf[o] = scale; _pxf[o + 1] = 0; _pxf[o + 2] = sx - 32 * scale; _pxf[o + 3] = sy - 32 * scale;
        final mc = mood.at((seed * 7.13) % 1);
        final pr = 0.72 + (0.45 - 0.72) * seed, pg = 0.55 + (0.82 - 0.55) * seed;
        _pcol[np] = _argb(alpha, pr * 0.65 + mc.r * 0.35, pg * 0.65 + mc.g * 0.35, 0.65 + mc.b * 0.35);
        np++;
      } else {
        // 影格上一個像素放大成一顆細點
        final diam = max(1.0, dotWorld * s), o = n * 4, i2 = i * 2;
        _xf[o] = diam; _xf[o + 1] = 0; _xf[o + 2] = sx - diam / 2; _xf[o + 3] = sy - diam / 2;
        _rect[o] = h.src[i2]; _rect[o + 1] = h.src[i2 + 1]; _rect[o + 2] = h.src[i2] + 1; _rect[o + 3] = h.src[i2 + 1] + 1;
        final scan = 0.94 + 0.06 * sin(h.base[i3 + 1] * 160 - t * 3);
        _col[n] = _argb(alpha, scan, scan, scan);
        n++;
      }
    }
    final add = Paint()..blendMode = BlendMode.plus..filterQuality = FilterQuality.low;
    if (np > 0) {
      canvas.drawRawAtlas(dot, Float32List.sublistView(_pxf, 0, np * 4), Float32List.sublistView(_prect, 0, np * 4), Int32List.sublistView(_pcol, 0, np), BlendMode.modulate, null, add);
    }
    if (n == 0 || img == null) return;
    final xf = Float32List.sublistView(_xf, 0, n * 4), rect = Float32List.sublistView(_rect, 0, n * 4), col = Int32List.sublistView(_col, 0, n);
    // 光暈：整張影格模糊後淡淡疊上去（取代每顆粒子的柔光）
    final s0 = focal / camD;
    final glowRect = Rect.fromCenter(center: Offset(cx + yaw * 0.6 * s0, cy - AiyaHolo.yOff * s0), width: AiyaHolo.panelW * s0, height: AiyaHolo.panelH * s0);
    final form = _smooth(0.5, 1.0, a.form);
    void layer(ui.Image im, double w) {
      if (w <= 0.01) return;
      if (form > 0.01) {
        canvas.drawImageRect(im, Rect.fromLTWH(0, 0, _imgW.toDouble(), _imgH.toDouble()), glowRect,
            Paint()..blendMode = BlendMode.plus..filterQuality = FilterQuality.low..colorFilter = _lumaToAlpha..imageFilter = ui.ImageFilter.blur(sigmaX: s0 * 0.02, sigmaY: s0 * 0.02)..color = Color.fromRGBO(255, 255, 255, 0.35 * w * form));
      }
      canvas.drawRawAtlas(im, xf, rect, w >= 0.99 ? col : Int32List.fromList([for (final c in col) _scaleAlpha(c, w)]), BlendMode.modulate, null, add);
    }
    if (prevImg != null && mix < 1) layer(prevImg, 1 - mix);
    layer(img, mix);
  }

  /// 影格是不透明的 JPEG（背景是黑色）：把亮度變成透明度，黑色背景完全透明，疊在地圖上才不會有一塊暗色方框
  static const _lumaToAlpha = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0.3, 0.59, 0.11, 0, 0,
  ]);

  static int _scaleAlpha(int c, double w) => ((((c >> 24) & 0xFF) * w).round() << 24) | (c & 0xFFFFFF);
  static int _argb(double a, double r, double g, double b) =>
      ((a.clamp(0.0, 1.0) * 255).round() << 24) | ((r.clamp(0.0, 1.0) * 255).round() << 16) | ((g.clamp(0.0, 1.0) * 255).round() << 8) | (b.clamp(0.0, 1.0) * 255).round();
  static double _smooth(double a, double b, double x) { final t = ((x - a) / (b - a)).clamp(0.0, 1.0); return t * t * (3 - 2 * t); }

  @override
  bool shouldRepaint(covariant AiyaHoloPainter old) => true;
}

/// 每個畫面重複使用的陣列
class AiyaHoloBuffers {
  final Float32List xf, rect, pxf, prect;
  final Int32List col, pcol;
  AiyaHoloBuffers(int face, int pillar)
      : xf = Float32List(face * 4), rect = Float32List(face * 4), col = Int32List(face),
        pxf = Float32List(pillar * 4), prect = Float32List.fromList([for (var i = 0; i < pillar; i++) ...[0, 0, 64, 64]]), pcol = Int32List(pillar);
}
