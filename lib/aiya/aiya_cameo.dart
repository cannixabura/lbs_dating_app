import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../quantum_live.dart';
import '../ui/night.dart';
import 'aiya_face.dart';
import 'aiya_particles.dart';
import 'aiya_video.dart';

/// 艾婭偶爾在量子中心的光柱裡現身（不呼叫 AI，只用影片片段和固定台詞）：
/// ① 整點報時：鐘聲前幾秒聚成她，說「N 點了」，報時結束散回光柱
/// ② 每天第一次進入量子世界：揮手打招呼
/// ③ 偶遇：每 10～20 分鐘隨機出現幾秒（眨眼、看旁邊、害羞、微笑）
/// 點她就等於敲門。設定裡關掉艾婭時整個不顯示（由外層決定要不要放這個 widget）。
class AiyaCameo extends StatefulWidget {
  /// 光柱底部的畫面位置與光柱高度；光柱不在畫面上時回傳 null
  final (Offset, double)? Function() anchor;
  final VoidCallback onTap;
  const AiyaCameo({super.key, required this.anchor, required this.onTap});

  @override
  State<AiyaCameo> createState() => _AiyaCameoState();
}

enum _Kind { chime, hello, random }

/// 本機測試：--dart-define=AIYA_CAMEO_TEST=true，App 直接打開一根測試光柱；
/// 時鐘快轉到整點前 40 秒，依序看到：打招呼 → 整點 → 偶遇
const aiyaCameoTest = bool.fromEnvironment('AIYA_CAMEO_TEST');
Duration _testShift = Duration.zero;
DateTime _now() => DateTime.now().add(_testShift);

class _AiyaCameoState extends State<AiyaCameo> with SingleTickerProviderStateMixin {
  static const _dayKey = 'aiyaCameoDay';
  final _anim = AiyaAnimator();
  final _video = AiyaVideo();
  final _frame = ValueNotifier<int>(0);
  final _rnd = Random();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  Timer? _clock, _hide;
  final _timers = <Timer>[];
  AiyaHolo? _holo;
  ui.Image? _dot;
  AiyaHoloBuffers? _buf;
  bool _visible = false;
  String? _caption;
  int _lastChimeHour = -1;
  DateTime _nextRandom = _now().add(const Duration(minutes: 12));

  @override
  void initState() {
    super.initState();
    _anim.reduceMotion = false;
    _ticker = createTicker(_onTick);
    _video.onEnd = (_) => _video.play('idle', _anim.time, loop: true);
    if (aiyaCameoTest) {
      final n = DateTime.now(), ms = n.millisecondsSinceEpoch;
      final top = ((ms / 3600000).floor() + 1) * 3600000;
      _testShift = Duration(milliseconds: top - 40000 - ms);
      _nextRandom = _now().add(const Duration(seconds: 75));
    }
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _check());
    // 入場儀式約 3 秒，之後才打招呼
    _timers.add(Timer(const Duration(milliseconds: 3800), _maybeHello));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _clock?.cancel();
    _hide?.cancel();
    for (final t in _timers) { t.cancel(); }
    _video.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _onTick(Duration now) {
    final elapsed = (now - _last).inMicroseconds / 1e6;
    if (elapsed < 1 / 30 - 0.002) return; // 最多每秒 30 張
    _last = now;
    _anim.update(elapsed.clamp(0.0, 0.05));
    _frame.value++;
    // 散回光柱之後就停下來，不再耗電
    if (_anim.formTarget == 0 && _anim.form <= 0) {
      _ticker.stop();
      _last = Duration.zero;
      if (mounted) setState(() { _visible = false; _caption = null; });
    }
  }

  /// 這個畫面是不是使用者正在看的（聊天畫面蓋在上面時不現身）
  bool get _onScreen => mounted && (ModalRoute.of(context)?.isCurrent ?? true);

  void _check() {
    if (!_onScreen || _visible) return;
    final now = _now();
    final t = QuantumChime.offset(now), hour = QuantumChime.hourKey(now);
    // ① 整點：鐘聲前 9 秒開始聚，報時（15 秒）結束後散回
    if (t >= -9 && t < 8 && hour != _lastChimeHour) {
      _lastChimeHour = hour;
      _show(_Kind.chime, Duration(milliseconds: ((14 - t) * 1000).round()));
      return;
    }
    // ③ 偶遇：避開整點前後
    if (now.isAfter(_nextRandom)) {
      _nextRandom = now.add(Duration(minutes: 10 + _rnd.nextInt(11)));
      if (t.abs() > 120 || aiyaCameoTest) _show(_Kind.random, const Duration(seconds: 9));
    }
  }

  Future<void> _maybeHello() async {
    if (!_onScreen || _visible) return;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    if (prefs.getString(_dayKey) == today && !aiyaCameoTest) return;
    // 剛好遇上整點就讓整點那次代替
    if (QuantumChime.active(now) && !aiyaCameoTest) return;
    await prefs.setString(_dayKey, today);
    _show(_Kind.hello, const Duration(seconds: 9));
  }

  Future<void> _show(_Kind kind, Duration stay) async {
    if (_holo == null) {
      final r = await Future.wait([AiyaHolo.load(), aiyaDotSprite(), _video.preload(['idle', 'hello', 'talk_soft', 'wink', 'think', 'shy'])]);
      _holo = r[0] as AiyaHolo;
      _dot = r[1] as ui.Image;
      _buf = AiyaHoloBuffers(_holo!.faceCount, 1);
    }
    if (!_onScreen || _visible) return;
    setState(() { _visible = true; _caption = null; });
    _anim.formTarget = 1;
    if (!_ticker.isActive) _ticker.start();
    final clip = switch (kind) {
      _Kind.chime => 'talk_soft',
      _Kind.hello => 'hello',
      _Kind.random => const ['wink', 'think', 'shy', 'idle'][_rnd.nextInt(4)],
    };
    await _video.play('idle', _anim.time, loop: true);
    // 聚好之後才開始動作和說話
    _timers.add(Timer(const Duration(milliseconds: 1600), () {
      if (!mounted || !_visible) return;
      _video.play(clip, _anim.time, loop: false);
      final text = switch (kind) {
        _Kind.chime => tr.aiyaCameoChime(QuantumChime.strikes(_now().add(const Duration(seconds: 10))) % 24),
        _Kind.hello => tr.aiyaCameoHello,
        _Kind.random => null,
      };
      setState(() => _caption = text);
    }));
    _hide?.cancel();
    _hide = Timer(stay, () {
      if (!mounted) return;
      _anim.formTarget = 0;
      setState(() => _caption = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible || _holo == null || _dot == null) return const SizedBox.shrink();
    return ValueListenableBuilder<int>(
      valueListenable: _frame,
      builder: (context, _, __) {
        final a = widget.anchor();
        if (a == null) return const SizedBox.shrink();
        final (base, pillarH) = a;
        // 人像浮在光柱中段，大小跟著光柱
        final figH = (pillarH * 0.95).clamp(150.0, 280.0);
        final stage = Rect.fromCenter(center: Offset(base.dx, base.dy - pillarH * 0.5), width: figH, height: figH);
        final hit = Rect.fromCenter(center: stage.center, width: figH * 0.6, height: figH * 0.8);
        return Stack(children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: AiyaHoloPainter(_holo!, _anim, _video, _dot!, stage: stage, drawPillar: false, stride: 2, repaint: _frame, buf: _buf!)),
            ),
          ),
          Positioned.fromRect(rect: hit, child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: widget.onTap)),
          if (_caption != null)
            Positioned(
              left: base.dx - 120, width: 240, top: stage.top - 34,
              child: IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _anim.form > 0.9 ? 1 : 0, duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(color: Night.glassFill, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x66FFC861))),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '${tr.aiyaName} · AI  ', style: const TextStyle(color: Color(0xFFFFC861), fontSize: 11, letterSpacing: 1)),
                          TextSpan(text: _caption, style: const TextStyle(color: Night.ink, fontSize: 13, height: 1.4)),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ]);
      },
    );
  }
}

/// 測試畫面：一根簡單的光柱，艾婭照時機現身
class AiyaCameoTestScreen extends StatelessWidget {
  const AiyaCameoTestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final base = Offset(size.width / 2, size.height * 0.72), h = 360.0;
    return Scaffold(
      backgroundColor: Night.night900,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _TestPillar(base, h))),
        Positioned.fill(child: AiyaCameo(anchor: () => (base, h), onTap: () {})),
      ]),
    );
  }
}

class _TestPillar extends CustomPainter {
  final Offset base;
  final double h;
  _TestPillar(this.base, this.h);
  @override
  void paint(Canvas canvas, Size size) {
    // 偏亮的格線背景：看得出艾婭身後有沒有暗色方框（真實地圖也有建築和街道）
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF2A3570));
    final grid = Paint()..color = const Color(0xFF5566AA)..strokeWidth = 2;
    for (var x = 0.0; x < size.width; x += 40) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid); }
    for (var y = 0.0; y < size.height; y += 40) { canvas.drawLine(Offset(0, y), Offset(size.width, y), grid); }
    final beam = Rect.fromLTWH(base.dx - 9, base.dy - h, 18, h);
    canvas.drawRect(beam, Paint()
      ..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.white.withValues(alpha: 0.85), Night.auroraViolet.withValues(alpha: 0.5), Night.auroraViolet.withValues(alpha: 0)]).createShader(beam)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(base, 12, Paint()..color = Night.auroraViolet.withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
  }
  @override
  bool shouldRepaint(covariant _TestPillar old) => false;
}
