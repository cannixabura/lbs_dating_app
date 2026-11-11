import 'dart:async';

import 'l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'ui/night.dart';

/// 導覽頁：單頁自動輪播（11/11 改版）。
/// 全螢幕插畫每 4.5 秒淡入淡出換一張，換的同時慢慢推近；標題與說明跟著換。
/// 左右滑或點畫面可以手動切換；底下只有一個「開始探索」，隨時都能進入登入。
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  static const _slideTime = Duration(milliseconds: 4500);
  static const _fadeTime = Duration(milliseconds: 900);
  static const _gold = Color(0xFFFFC861);
  late final AnimationController _clock = AnimationController(vsync: this, duration: _slideTime)
    ..addStatusListener((st) {
      if (st == AnimationStatus.completed) _go(_page + 1);
    });
  int _page = 0;
  bool _precached = false;

  // 8 張導覽：圖片不含文字（多語言共用），文字在 lib/l10n/app_*.arb 的 intro<頁>Title／Body
  late final List<Map<String, String>> _introData = [
    {
      "image": "assets/images/intro_1.webp",
      "title": tr.intro1Title,
      "description": tr.intro1Body
    },
    {
      "image": "assets/images/intro_2.webp",
      "title": tr.intro2Title,
      "description": tr.intro2Body
    },
    {
      "image": "assets/images/intro_3.webp",
      "title": tr.intro3Title,
      "description": tr.intro3Body
    },
    {
      "image": "assets/images/intro_4.webp",
      "title": tr.intro4Title,
      "description": tr.intro4Body
    },
    {
      "image": "assets/images/intro_time_whisper.webp",
      "title": tr.intro6Title,
      "description": tr.intro6Body
    },
    {
      "image": "assets/images/intro_gathering.webp",
      "title": tr.intro7Title,
      "description": tr.intro7Body
    },
    {
      "image": "assets/images/intro_parallel.webp",
      "title": tr.intro8Title,
      "description": tr.intro8Body
    },
    {
      "image": "assets/images/intro_5.webp",
      "title": tr.intro5Title,
      "description": tr.intro5Body
    },
  ];


  @override
  void initState() {
    super.initState();
    _clock.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final d in _introData) {
      precacheImage(AssetImage(d['image']!), context);
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _go(int i) {
    if (!mounted) return;
    setState(() => _page = (i + _introData.length) % _introData.length);
    _clock.forward(from: 0);
  }

  Future<void> _completeIntro() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final still = mq.disableAnimations;
    final d = _introData[_page];
    return Scaffold(
      backgroundColor: Night.night900,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _go(_page + 1),
        onHorizontalDragEnd: (e) {
          final v = e.primaryVelocity ?? 0;
          if (v < -150) _go(_page + 1);
          if (v > 150) _go(_page - 1);
        },
        child: Stack(fit: StackFit.expand, children: [
          // 全螢幕插畫：淡入淡出，每張自己慢慢推近
          AnimatedSwitcher(
            duration: _fadeTime,
            layoutBuilder: (cur, prev) => Stack(fit: StackFit.expand, children: [...prev, if (cur != null) cur]),
            child: _KenBurns(key: ValueKey(_page), image: d['image']!, duration: _slideTime + _fadeTime, still: still, drift: _page.isEven ? 1 : -1),
          ),
          // 上下壓暗，讓標誌與文字清楚
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  stops: [0, 0.16, 0.42, 0.68, 1],
                  colors: [Color(0xB3070B1F), Color(0x00070B1F), Color(0x00070B1F), Color(0xCC070B1F), Color(0xF5070B1F)],
                ),
              ),
            ),
          ),
          // 左上：App 標誌與名稱
          Positioned(
            left: Night.space6, top: mq.padding.top + Night.space3,
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(7), child: Image.asset('assets/images/app_icon.png', width: 26, height: 26, cacheWidth: 78)),
              const SizedBox(width: Night.space2),
              Text(tr.appName, style: TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: ls(2))),
            ]),
          ),
          // 下方：進度、標題、說明、開始探索
          Positioned(
            left: Night.space6, right: Night.space6, bottom: mq.padding.bottom + Night.space6,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Progress(count: _introData.length, page: _page, clock: _clock),
              const SizedBox(height: Night.space4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(position: Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)), child: child),
                ),
                layoutBuilder: (cur, prev) => Stack(alignment: Alignment.bottomLeft, children: [...prev, if (cur != null) cur]),
                child: Column(
                  key: ValueKey(_page),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${(_page + 1).toString().padLeft(2, '0')} / ${_introData.length.toString().padLeft(2, '0')}',
                        style: TextStyle(color: _gold.withValues(alpha: 0.85), fontSize: 12, letterSpacing: ls(2), fontFeatures: const [FontFeature.tabularFigures()])),
                    const SizedBox(height: Night.space2),
                    Text(d['title']!, style: TextStyle(color: Colors.white, fontSize: 30, height: 1.3, fontWeight: FontWeight.w700, letterSpacing: ls(1.5))),
                    const SizedBox(height: Night.space2),
                    // 金色細線：跟著每張慢慢畫出來
                    _GoldLine(still: still, color: _gold),
                    const SizedBox(height: Night.space3),
                    Text(d['description']!, style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 15, height: 1.65)),
                  ],
                ),
              ),
              const SizedBox(height: Night.space6),
              NightButton(tr.startExploring, onPressed: _completeIntro, expand: true),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// 一張插畫：鋪滿螢幕，在它出現的這段時間裡慢慢推近、微微橫移
class _KenBurns extends StatefulWidget {
  final String image;
  final Duration duration;
  final bool still;
  final int drift;
  const _KenBurns({super.key, required this.image, required this.duration, required this.still, required this.drift});
  @override
  State<_KenBurns> createState() => _KenBurnsState();
}

class _KenBurnsState extends State<_KenBurns> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
    if (!widget.still) _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(widget.image, fit: BoxFit.cover, filterQuality: FilterQuality.medium, gaplessPlayback: true);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        child: img,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_c.value);
          return Transform.scale(
            scale: 1.04 + 0.08 * t,
            alignment: Alignment(0.3 * widget.drift * (t - 0.5), -0.2),
            child: child,
          );
        },
      ),
    );
  }
}

/// 頂部分段進度：已看過的亮著，目前這張跟著時間填滿
class _Progress extends StatelessWidget {
  final int count, page;
  final Animation<double> clock;
  const _Progress({required this.count, required this.page, required this.clock});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var i = 0; i < count; i++) ...[
        if (i > 0) const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 2.5,
              child: i == page
                  ? AnimatedBuilder(animation: clock, builder: (_, _) => LinearProgressIndicator(value: clock.value, backgroundColor: const Color(0x33FFFFFF), color: Colors.white))
                  : ColoredBox(color: i < page ? const Color(0xCCFFFFFF) : const Color(0x33FFFFFF)),
            ),
          ),
        ),
      ],
    ]);
  }
}

/// 標題下的金色細線，出現時由左往右畫出
class _GoldLine extends StatelessWidget {
  final bool still;
  final Color color;
  const _GoldLine({required this.still, required this.color});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: still ? 1 : 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Container(
        width: 56 * v, height: 2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.2)])),
      ),
    );
  }
}
