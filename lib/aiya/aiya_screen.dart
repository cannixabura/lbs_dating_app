import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../l10n/l10n.dart';
import '../legal.dart';
import '../quantum_orb.dart';
import '../ui/night.dart';
import 'aiya_face.dart';
import 'aiya_particles.dart';
import 'aiya_store.dart';
import 'aiya_video.dart';

/// 實測用：--dart-define=AIYA_FPS=true 在畫面上顯示每秒張數與每張花的時間
const _showFps = bool.fromEnvironment('AIYA_FPS');

/// 打開艾婭（量子世界中央光柱）
Future<void> openAiya(BuildContext context) => Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierColor: const Color(0xCC070B1F),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const AiyaScreen(),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    ));

/// 量子世界光柱底下的小標籤，點了就敲門
class AiyaPillarChip extends StatelessWidget {
  final VoidCallback onTap;
  const AiyaPillarChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => Center(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          // 外圍多留一點可以點的範圍，標籤本身很小
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Night.glassFill.withOpacity(Night.glassFill.opacity * 0.67),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0x66FFC861), width: 0.6),
                boxShadow: const [BoxShadow(color: Color(0x39FFC861), blurRadius: 7)],
              ),
              child: Text(tr.aiyaChip, style: TextStyle(color: Night.ink.withOpacity(0.67), fontSize: 6.5, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            ),
          ),
        ),
      );
}

class _Msg {
  final bool mine;
  String text;
  final bool system; // 提示（不是艾婭說的，不能檢舉）
  _Msg(this.text, {this.mine = false, this.system = false});
}

class AiyaScreen extends StatefulWidget {
  const AiyaScreen({super.key});
  @override
  State<AiyaScreen> createState() => _AiyaScreenState();
}

class _AiyaScreenState extends State<AiyaScreen> with SingleTickerProviderStateMixin {
  final _anim = AiyaAnimator();
  final _frame = ValueNotifier<int>(0);
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  AiyaHolo? _holo;
  ui.Image? _sprite;
  AiyaHoloBuffers? _buf;
  final _video = AiyaVideo();
  final _rnd = Random();
  // 效能顯示
  final _fpsText = ValueNotifier<String>('');
  final _frameTimes = <double>[];
  final _rasterMs = <double>[], _buildMs = <double>[];

  final _msgs = <_Msg>[];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  String? _sessionId;
  DateTime? _endsAt;
  int _turnsLeft = 0;
  int _freeLeft = 0, _credits = 0;
  bool _sending = false, _ended = false, _opening = true;
  Timer? _clock, _typer;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((now) {
      // 影片本身每秒 24 格：畫面最多每秒畫 30 張就夠順，不跟著 120Hz 螢幕一直重畫（省電、不發燙）
      final elapsed = (now - _last).inMicroseconds / 1e6;
      if (elapsed < 1 / 30 - 0.002) return;
      final dt = elapsed.clamp(0.0, 0.05);
      _last = now;
      _anim.update(dt);
      _frame.value++;
      if (_showFps) _countFrame(dt);
    })..start();
    if (_showFps) SchedulerBinding.instance.addTimingsCallback(_onTimings);
    _video.onEnd = (_) => _video.play('idle', _anim.time, loop: true);
    AiyaStore.notice.addListener(_onNotice);
    AiyaStore.credits.addListener(_onCredits);
    AiyaStore.friendExp.addListener(_onFriend);
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anim.reduceMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void dispose() {
    _ticker.dispose();
    if (_showFps) SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _video.dispose();
    _fpsText.dispose();
    _clock?.cancel();
    _typer?.cancel();
    AiyaStore.notice.removeListener(_onNotice);
    AiyaStore.credits.removeListener(_onCredits);
    AiyaStore.friendExp.removeListener(_onFriend);
    _input.dispose();
    _scroll.dispose();
    _frame.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final results = await Future.wait([AiyaHolo.load(), aiyaDotSprite(), _video.preload(['idle', 'hello', 'think'])]);
    if (!mounted) return;
    await _video.play('idle', _anim.time, loop: true);
    unawaited(_video.preload(aiyaExprClip.values.toSet().union(aiyaTalkClips.toSet())));
    setState(() {
      _holo = results[0] as AiyaHolo;
      _sprite = results[1] as ui.Image;
      _buf = AiyaHoloBuffers(_holo!.faceCount, _holo!.count - _holo!.faceCount);
    });
    final status = await aiyaCall('status');
    if (!mounted) return;
    _applyStatus(status);
    if (status['consented'] != true) {
      final agreed = await _askConsent();
      if (!mounted) return;
      if (!agreed) { Navigator.of(context).pop(); return; }
      await aiyaCall('consent');
    }
    await _open();
  }

  void _applyStatus(Map<String, dynamic> s) {
    AiyaStore.applyStatus(s);
    if (s['freeLeft'] is num) _freeLeft = (s['freeLeft'] as num).toInt();
    if (s['credits'] is num) _credits = (s['credits'] as num).toInt();
    final session = s['session'];
    if (session is Map) {
      _sessionId = '${session['id']}';
      _turnsLeft = (session['turnsLeft'] as num?)?.toInt() ?? 0;
      _endsAt = DateTime.now().add(Duration(milliseconds: (session['remainingMs'] as num?)?.toInt() ?? 0));
    }
    if (mounted) setState(() {});
  }

  Future<void> _open() async {
    setState(() => _opening = true);
    final r = await aiyaCall('open');
    if (!mounted) return;
    _applyStatus(r);
    setState(() => _opening = false);
    if (r['success'] != true) {
      final code = '${r['code']}';
      if (code == 'no_quota') { _showPacks(); return; }
      _system(switch (code) { 'resting' => tr.aiyaResting, 'daily_max' => tr.aiyaDailyMax, _ => tr.aiyaBusy });
      return;
    }
    _ended = false;
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    // 叩叩叩 → 聚成人像 → 開場白（固定台詞，不呼叫 AI）
    _anim.knock();
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    _anim.formTarget = 1;
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    if (r['resumed'] != true || _msgs.isEmpty) _speak(tr.aiyaGreeting, 'smile', talkClip: 'hello');
    // 假資料模式：自動送一句測試，確認思考表情、回覆與嘴型
    if (aiyaDirect) Future.delayed(const Duration(seconds: 7), () { if (mounted) { _input.text = '今天好累'; _send(); } });
  }

  void _tick() {
    if (!mounted || _endsAt == null) return;
    setState(() {});
    if (!_ended && DateTime.now().isAfter(_endsAt!)) _finish();
  }

  Future<void> _finish() async {
    if (_ended) return;
    _ended = true;
    _clock?.cancel();
    _speak(tr.aiyaFarewell, 'smile');
    unawaited(aiyaCall('close'));
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) setState(() => _anim.formTarget = 0);
  }

  Future<void> _close() async {
    if (!_ended && _sessionId != null) unawaited(aiyaCall('close'));
    _anim.formTarget = 0;
    _clock?.cancel();
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) Navigator.of(context).pop();
  }

  void _system(String text) {
    setState(() => _msgs.add(_Msg(text, system: true)));
    _scrollDown();
  }

  /// 艾婭說一句：播說話的片段，一個字一個字打出來；說完換成這句的表情，再回到平常的微笑
  void _speak(String text, String expression, {String? talkClip}) {
    _typer?.cancel();
    _anim.setExpr(expression);
    _video.play(talkClip ?? aiyaTalkClips[_rnd.nextInt(aiyaTalkClips.length)], _anim.time);
    final after = aiyaExprClip[expression] ?? 'idle';
    final msg = _Msg('');
    setState(() => _msgs.add(msg));
    final chars = text.characters.toList();
    var i = 0;
    _typer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i >= chars.length) {
        t.cancel();
        // 打招呼的片段本身就是一整段，讓它播完；其他說完就換表情
        if (talkClip == null) _video.play(after, _anim.time, loop: after == 'idle');
        return;
      }
      _anim.speakChar(chars[i]);
      setState(() => msg.text += chars[i]);
      i++;
      _scrollDown();
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending || _ended || _sessionId == null) return;
    _input.clear();
    setState(() { _msgs.add(_Msg(text, mine: true)); _sending = true; });
    _scrollDown();
    _anim.setExpr('think');
    _video.play('think', _anim.time, loop: true);
    final r = await aiyaCall('say', {'sessionId': _sessionId, 'text': text});
    if (!mounted) return;
    setState(() => _sending = false);
    final session = r['session'];
    if (session is Map) _turnsLeft = (session['turnsLeft'] as num?)?.toInt() ?? _turnsLeft;
    if (r['success'] == true) {
      _speak('${r['reply']}', '${r['expression']}');
      if (_turnsLeft <= 0) Future.delayed(const Duration(seconds: 6), _finish);
      return;
    }
    _anim.setExpr('calm');
    if (r['code'] == 'filtered' || r['code'] == 'ended') _video.play('idle', _anim.time, loop: true);
    switch ('${r['code']}') {
      case 'filtered': _system(tr.aiyaFiltered);
      case 'refused': _speak(tr.aiyaRefused, 'worry');
      case 'ended': _ended = true; _system(tr.aiyaEnded);
      default: _speak(tr.aiyaBusy, 'shy');
    }
  }

  void _scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      });

  void _onNotice() {
    final n = AiyaStore.notice.value;
    if (n == null || !mounted) return;
    AiyaStore.notice.value = null;
    showGlassToast(context, n, icon: Icons.auto_awesome);
  }

  void _onCredits() {
    final c = AiyaStore.credits.value;
    if (c == null || !mounted) return;
    final had = _credits;
    setState(() => _credits = c);
    // 買完時光包、還沒開始聊天：直接敲門
    if (c > had && _sessionId == null && !_opening) {
      if (Navigator.of(context).canPop()) Navigator.of(context).popUntil((r) => r.settings.name != 'aiyaPacks');
      _open();
    }
  }

  /// 成為艾婭之友：次數多了，問伺服器今天剩幾次；還沒開始聊天就直接敲門
  Future<void> _onFriend() async {
    if (!mounted) return;
    setState(() {});
    if (!AiyaStore.isFriend) return;
    _applyStatus(await aiyaCall('status'));
    if (!mounted) return;
    if (_sessionId == null && !_opening) {
      if (Navigator.of(context).canPop()) Navigator.of(context).popUntil((r) => r.settings.name != 'aiyaPacks' && r.settings.name != 'aiyaFriend');
      _open();
    }
  }

  Future<bool> _askConsent() async {
    final ok = await showModalBottomSheet<bool>(
      context: context, isDismissible: false, enableDrag: false, backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFFFC861), size: 32),
              const SizedBox(height: Night.space3),
              Text(tr.aiyaConsentTitle, style: Night.title, textAlign: TextAlign.center),
              const SizedBox(height: Night.space3),
              Text(tr.aiyaConsentBody, style: Night.body),
              const SizedBox(height: Night.space4),
              NightButton(tr.aiyaConsentAgree, onPressed: () => Navigator.pop(ctx, true)),
              const SizedBox(height: Night.space2),
              NightButton(tr.aiyaConsentLater, kind: NightButtonKind.text, onPressed: () => Navigator.pop(ctx, false)),
            ]),
          ),
        ),
      ),
    );
    return ok == true;
  }

  /// [browse]：從「＋ 時光包」自己打開（免費次數可能還沒用完），標題與說明換成一般的介紹
  void _showPacks({bool browse = false}) {
    AiyaStore.loadProducts();
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, routeSettings: const RouteSettings(name: 'aiyaPacks'),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            child: ValueListenableBuilder(
              valueListenable: AiyaStore.details,
              builder: (context, details, _) => ValueListenableBuilder(
                valueListenable: AiyaStore.busy,
                builder: (context, busy, _) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(browse ? tr.aiyaPacksTitle : tr.aiyaNoQuotaTitle, style: Night.title, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space3),
                  Text(browse ? tr.aiyaPacksBody : tr.aiyaNoQuotaBody, style: Night.body),
                  const SizedBox(height: Night.space4),
                  if (!AiyaStore.isFriend) ...[
                    NightButton(tr.aiyaFriendEntry, kind: NightButtonKind.warm, icon: Icons.auto_awesome, onPressed: () { Navigator.pop(ctx); _showFriend(); }),
                    const SizedBox(height: Night.space2),
                  ],
                  for (final e in AiyaStore.products.entries) ...[
                    NightButton(
                      '${tr.aiyaPackTimes(e.value)}${details[e.key] != null ? '  ·  ${details[e.key]!.price}' : ''}',
                      kind: e.value == 20 ? NightButtonKind.primary : NightButtonKind.ghost,
                      icon: Icons.hourglass_bottom,
                      onPressed: busy ? null : () => AiyaStore.buy(e.key),
                    ),
                    const SizedBox(height: Night.space2),
                  ],
                  if (busy) const Padding(padding: EdgeInsets.all(Night.space2), child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))),
                  Text(tr.aiyaPackNote, style: Night.caption, textAlign: TextAlign.center),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _date(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${d.year}/${d.month}/${d.day}';
  }

  /// 艾婭之友（自動續訂月費）：Apple 3.1.2 要的價格、期間、自動續訂說明、條款與隱私權連結、恢復購買、管理訂閱都在這裡
  void _showFriend() {
    AiyaStore.loadProducts();
    Widget perk(String text) => Padding(
          padding: const EdgeInsets.only(bottom: Night.space2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.auto_awesome, size: 16, color: Color(0xFFFFC861))),
            const SizedBox(width: Night.space2),
            Expanded(child: Text(text, style: Night.body)),
          ]),
        );
    Widget link(String text, Uri url) => TextButton(
          onPressed: () => Legal.open(url),
          style: TextButton.styleFrom(foregroundColor: Night.inkMuted, minimumSize: const Size(44, 36), padding: const EdgeInsets.symmetric(horizontal: 8)),
          child: Text(text, style: const TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
        );
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true, routeSettings: const RouteSettings(name: 'aiyaFriend'),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            child: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: Listenable.merge([AiyaStore.details, AiyaStore.busy, AiyaStore.friendExp]),
                builder: (context, _) {
                  final product = AiyaStore.details.value[AiyaStore.friendProduct];
                  final busy = AiyaStore.busy.value;
                  final active = AiyaStore.isFriend;
                  return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(tr.aiyaFriendTitle, style: Night.title, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space1),
                    Text(tr.aiyaFriendSubtitle, style: Night.caption, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    perk(tr.aiyaFriendPerk1),
                    perk(tr.aiyaFriendPerk2),
                    perk(tr.aiyaFriendPerk3),
                    perk(tr.aiyaFriendPerk4),
                    const SizedBox(height: Night.space2),
                    if (active)
                      Text(tr.aiyaFriendActive(_date(AiyaStore.friendExp.value!)), style: const TextStyle(color: Color(0xFFFFC861), fontSize: 15), textAlign: TextAlign.center)
                    else ...[
                      if (product != null)
                        Text(tr.aiyaFriendPrice(product.price), style: const TextStyle(color: Night.ink, fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      const SizedBox(height: Night.space3),
                      NightButton(tr.aiyaFriendSubscribe, kind: NightButtonKind.warm, icon: Icons.auto_awesome, onPressed: busy || product == null ? null : AiyaStore.buyFriend),
                    ],
                    if (busy) const Padding(padding: EdgeInsets.all(Night.space2), child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))),
                    const SizedBox(height: Night.space3),
                    Text(tr.aiyaFriendTerms, style: Night.caption.copyWith(fontSize: 11)),
                    const SizedBox(height: Night.space2),
                    Wrap(alignment: WrapAlignment.center, children: [
                      link(tr.termsOfUse, Legal.termsUrl),
                      link(tr.privacyPolicy, Legal.privacyUrl),
                      TextButton(
                        onPressed: busy ? null : AiyaStore.restore,
                        style: TextButton.styleFrom(foregroundColor: Night.inkMuted, minimumSize: const Size(44, 36), padding: const EdgeInsets.symmetric(horizontal: 8)),
                        child: Text(tr.aiyaFriendRestore, style: const TextStyle(fontSize: 12)),
                      ),
                      link(tr.aiyaFriendManage, AiyaStore.manageUrl),
                    ]),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 艾婭的造型：原本、星光（艾婭之友）、聖誕、跨年（節日造型買斷，只有自己看得到）
  void _showSkins() {
    OrbStore.loadProducts();
    OrbStore.loadOwned();
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
            child: GlassCard(
              child: AnimatedBuilder(
                animation: Listenable.merge([AiyaSkinPrefs.selected, OrbStore.owned, OrbStore.products, OrbStore.busy, AiyaStore.friendExp]),
                builder: (context, _) {
                  final owned = OrbStore.owned.value;
                  final current = AiyaSkinPrefs.effective(friend: AiyaStore.isFriend, owned: owned);
                  Widget row(String key, String name, String sub, {required bool has, String? price, VoidCallback? onBuy}) {
                    final selected = current == key;
                    return InkWell(
                      onTap: OrbStore.busy.value ? null : () => has ? AiyaSkinPrefs.set(key) : onBuy?.call(),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: Night.space2),
                        padding: const EdgeInsets.all(Night.space3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: selected ? const Color(0xFFFFC861) : Night.glassLine, width: selected ? 1.6 : 1),
                        ),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(name, style: const TextStyle(color: Night.ink, fontSize: 15)),
                            if (sub.isNotEmpty) Text(sub, style: Night.caption.copyWith(fontSize: 12)),
                          ])),
                          Text(selected ? tr.orbInUse : (has ? tr.orbOwned : (price ?? '—')),
                              style: TextStyle(color: selected ? const Color(0xFFFFC861) : (has ? Night.inkMuted : Night.knockPink), fontSize: 13)),
                        ]),
                      ),
                    );
                  }
                  final products = OrbStore.products.value;
                  return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(tr.aiyaSkinTitle, style: Night.title, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space1),
                    Text(tr.aiyaSkinSubtitle, style: Night.caption, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    row('none', tr.aiyaSkinNone, '', has: true),
                    row('starlight', tr.aiyaSkinStarlight, tr.aiyaSkinStarlightSub, has: AiyaStore.isFriend, price: tr.aiyaFriendTitle, onBuy: () { Navigator.pop(ctx); _showFriend(); }),
                    for (final k in aiyaSkins)
                      if (owned.contains(k) || orbOnSale(k))
                        row(k, orbStyleName(k), owned.contains(k) ? tr.orbLimited : tr.orbLimitedUntil(orbUntilLabel(k)),
                            has: owned.contains(k), price: products[orbProducts[k]]?.price, onBuy: () => OrbStore.buy(k)),
                    if (OrbStore.busy.value) const Padding(padding: EdgeInsets.all(Night.space2), child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))),
                    const SizedBox(height: Night.space2),
                    Text(tr.aiyaSkinNote, style: Night.caption.copyWith(fontSize: 11), textAlign: TextAlign.center),
                    TextButton(onPressed: OrbStore.busy.value ? null : OrbStore.restore, style: TextButton.styleFrom(foregroundColor: Night.inkMuted), child: Text(tr.orbRestore)),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _report(_Msg m) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            child: NightButton(tr.aiyaReport, kind: NightButtonKind.danger, icon: Icons.flag_outlined, onPressed: () async {
              Navigator.pop(ctx);
              await aiyaCall('report', {'reply': m.text, 'reason': 'user'});
              if (mounted) showGlassToast(context, tr.aiyaReported, icon: Icons.flag_outlined);
            }),
          ),
        ),
      ),
    );
  }

  void _countFrame(double dt) {
    _frameTimes.add(dt);
    if (_frameTimes.length < 60) return;
    final avg = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length, worst = _frameTimes.reduce(max);
    double mean(List<double> l) => l.isEmpty ? 0 : l.reduce((a, b) => a + b) / l.length;
    double top(List<double> l) => l.isEmpty ? 0 : l.reduce(max);
    _fpsText.value = '每秒 ${(1 / avg).toStringAsFixed(1)} 張　最慢一張 ${(worst * 1000).toStringAsFixed(0)} 毫秒\n'
        '計算 ${mean(_buildMs).toStringAsFixed(1)}／${top(_buildMs).toStringAsFixed(1)} 毫秒　繪圖 ${mean(_rasterMs).toStringAsFixed(1)}／${top(_rasterMs).toStringAsFixed(1)} 毫秒\n'
        '粒子 ${_holo?.faceCount ?? 0}＋${(_holo?.count ?? 0) - (_holo?.faceCount ?? 0)}　片段 ${_clipNames[_video.current] ?? '-'}';
    _frameTimes.clear(); _rasterMs.clear(); _buildMs.clear();
  }

  static const _clipNames = {'idle': '安靜微笑', 'hello': '打招呼', 'think': '思考', 'talk1': '看著你說話', 'talk_soft': '輕輕說', 'talk_slow': '輕輕慢慢說',
    'surprise': '驚訝', 'shy': '害羞', 'worry': '擔心', 'wink': '眨眼', 'laugh': '開心大笑'};

  void _onTimings(List<ui.FrameTiming> timings) {
    for (final t in timings) {
      _buildMs.add(t.buildDuration.inMicroseconds / 1000);
      _rasterMs.add(t.rasterDuration.inMicroseconds / 1000);
    }
  }

  String _timeLeft() {
    if (_endsAt == null) return '';
    final s = _endsAt!.difference(DateTime.now()).inSeconds.clamp(0, 3600);
    return tr.aiyaTimeLeft('${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final keyboard = mq.viewInsets.bottom;
    final stageTop = mq.padding.top + 56;
    final stageH = (size.height - keyboard) * 0.48 - stageTop + mq.padding.top;
    final stage = Rect.fromLTWH(0, stageTop, size.width, stageH.clamp(160.0, size.height));

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        // 金色光暈
        Positioned.fill(child: IgnorePointer(child: DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(center: Alignment(0, -0.45), radius: 0.8, colors: [const Color(0x33FFC861), const Color(0x228E2DE2), Night.night900.withValues(alpha: 0)]))))),
        if (_holo != null && _sprite != null)
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (d) => _anim.pointer = Offset((d.localPosition.dx / size.width * 2 - 1).clamp(-1.0, 1.0), -((d.localPosition.dy - stage.center.dy) / stage.height * 2).clamp(-1.0, 1.0)),
              onPanEnd: (_) => _anim.pointer = Offset.zero,
              child: CustomPaint(painter: AiyaHoloPainter(_holo!, _anim, _video, _sprite!, stage: stage, repaint: _frame, buf: _buf!)),
            ),
          ),
        // 艾婭之友：艾婭身邊多了一圈閃爍的星光（只有訂閱的人看得到）
        // 艾婭的造型（只有自己看得到）：艾婭之友的星光、聖誕、跨年
        if (_holo != null)
          Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
            animation: Listenable.merge([AiyaSkinPrefs.selected, OrbStore.owned, AiyaStore.friendExp]),
            builder: (context, _) => switch (AiyaSkinPrefs.effective(friend: AiyaStore.isFriend, owned: OrbStore.owned.value)) {
              'starlight' => CustomPaint(painter: _StarlightPainter(stage: stage, repaint: _frame, clock: () => _anim.time)),
              'aiya_xmas' => CustomPaint(painter: _XmasSkinPainter(stage: stage, repaint: _frame, clock: () => _anim.time)),
              'aiya_newyear' => CustomPaint(painter: _NewYearSkinPainter(stage: stage, repaint: _frame, clock: () => _anim.time)),
              _ => const SizedBox.shrink(),
            },
          ))),
        if (_showFps)
          Positioned(
            left: Night.space4, top: mq.padding.top + 48,
            child: IgnorePointer(child: ValueListenableBuilder(valueListenable: _fpsText, builder: (_, v, __) => Text(v, style: const TextStyle(color: Color(0xFF7CFFB2), fontSize: 11, fontFamily: 'monospace')))),
          ),
        // 上方：名稱、AI 標示、剩餘時間、結束
        Positioned(
          left: 0, right: 0, top: mq.padding.top + 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Night.space4),
            child: Row(children: [
              Text(tr.aiyaName, style: const TextStyle(color: Night.ink, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 2)),
              const SizedBox(width: Night.space2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: Night.glassLine)),
                child: const Text('AI', style: TextStyle(color: Night.auroraBlue, fontSize: 11, letterSpacing: 1.5)),
              ),
              const SizedBox(width: Night.space2),
              Text(_timeLeft(), style: Night.caption),
              const Spacer(),
              TextButton(onPressed: _close, child: Text(tr.aiyaEnd, style: const TextStyle(color: Night.inkMuted))),
            ]),
          ),
        ),
        // 下方：對話與輸入
        Positioned(
          left: 0, right: 0, bottom: keyboard,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Night.space4, 0, Night.space4, Night.space3),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: (size.height - keyboard) * 0.34),
                  child: ListView.builder(
                    controller: _scroll, shrinkWrap: true, itemCount: _msgs.length,
                    itemBuilder: (context, i) => _bubble(_msgs[i]),
                  ),
                ),
                const SizedBox(height: Night.space2),
                // 剩餘次數＋隨時可以買時光包的入口（不必等免費次數用完）
                Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, spacing: Night.space2, children: [
                  Text(
                    [
                      if (AiyaStore.isFriend) tr.aiyaFriendLeft(_freeLeft) else if (_freeLeft > 0) tr.aiyaFreeLeft(_freeLeft),
                      if (_credits > 0) tr.aiyaCreditsLeft(_credits),
                    ].join('  ·  '),
                    style: Night.caption, textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => _showPacks(browse: true),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0x66FFC861))),
                      child: Text(tr.aiyaPackEntry, style: const TextStyle(color: Color(0xFFFFC861), fontSize: 12, letterSpacing: 0.5)),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showSkins,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0x66FFC861))),
                      child: Text(tr.aiyaSkinEntry, style: const TextStyle(color: Color(0xFFFFC861), fontSize: 12, letterSpacing: 0.5)),
                    ),
                  ),
                ]),
                const SizedBox(height: Night.space2),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      enabled: !_ended && _sessionId != null && !_opening,
                      maxLength: 200,
                      minLines: 1, maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(color: Night.ink),
                      decoration: InputDecoration(
                        hintText: tr.aiyaInputHint, hintStyle: const TextStyle(color: Night.inkFaint), counterText: '',
                        filled: true, fillColor: Night.night700,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusMd), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: Night.space2),
                  IconButton.filled(
                    tooltip: tr.aiyaSend,
                    onPressed: _sending || _ended || _sessionId == null ? null : _send,
                    style: IconButton.styleFrom(backgroundColor: Night.deepViolet),
                    icon: _sending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ]),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _bubble(_Msg m) {
    final align = m.mine ? Alignment.centerRight : Alignment.centerLeft;
    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: m.mine ? Night.deepViolet.withValues(alpha: 0.85) : (m.system ? Colors.transparent : Night.glassFill),
        borderRadius: BorderRadius.circular(Night.radiusMd),
        border: m.mine || m.system ? null : Border.all(color: const Color(0x66FFC861)),
      ),
      child: Text(m.text, style: TextStyle(color: m.system ? Night.inkMuted : Night.ink, fontSize: 15, height: 1.45)),
    );
    return Align(
      alignment: m.system ? Alignment.center : align,
      child: m.mine || m.system ? bubble : GestureDetector(onLongPress: () => _report(m), child: bubble),
    );
  }
}

/// 艾婭之友的「星光」造型：艾婭四周幾十顆金色星光輪流閃爍、慢慢往上飄，幾顆十字星芒
class _StarlightPainter extends CustomPainter {
  final Rect stage;
  final double Function() clock;
  _StarlightPainter({required this.stage, required Listenable repaint, required this.clock}) : super(repaint: repaint);

  static double _h(int i) {
    final x = sin(i * 91.7 + 13.3) * 43758.5453;
    return x - x.floorToDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock();
    final c = stage.center;
    final rx = stage.width * 0.36, ry = stage.height * 0.46;
    const gold = Color(0xFFFFD98A);
    for (var i = 0; i < 36; i++) {
      // 散在艾婭周圍的橢圓帶上，中間（臉）留空
      final a = _h(i) * 2 * pi;
      final rad = 0.55 + 0.45 * _h(i + 50);
      final drift = ((t * (0.02 + 0.02 * _h(i + 9)) + _h(i + 70)) % 1.0);
      final p = c + Offset(cos(a) * rx * rad, sin(a) * ry * rad - drift * stage.height * 0.12);
      final tw = 0.5 + 0.5 * sin(t * (1.5 + 2 * _h(i + 20)) + i);
      final alpha = tw * tw * sin(drift * pi);
      if (alpha < 0.03) continue;
      final r = 1.0 + 1.6 * _h(i + 33);
      canvas.drawCircle(p, r * 2.4, Paint()..color = gold.withValues(alpha: 0.18 * alpha));
      canvas.drawCircle(p, r, Paint()..color = Colors.white.withValues(alpha: 0.9 * alpha));
      if (i % 6 == 0) {
        final len = r * 5 * tw;
        final paint = Paint()..color = gold.withValues(alpha: 0.7 * alpha)..strokeWidth = 0.8..strokeCap = StrokeCap.round;
        canvas.drawLine(p - Offset(len, 0), p + Offset(len, 0), paint);
        canvas.drawLine(p - Offset(0, len), p + Offset(0, len), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarlightPainter old) => old.stage != stage;
}


/// 聖誕造型：雪花慢慢飄過艾婭，身後一圈冬青花圈與閃爍的小燈
class _XmasSkinPainter extends CustomPainter {
  final Rect stage;
  final double Function() clock;
  _XmasSkinPainter({required this.stage, required Listenable repaint, required this.clock}) : super(repaint: repaint);
  static double _h(int i) { final x = sin(i * 71.3 + 4.1) * 43758.5453; return x - x.floorToDouble(); }

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock();
    final c = stage.center;
    final rx = stage.width * 0.46, ry = stage.height * 0.5;
    // 花圈：沿著橢圓排葉子，下半圈藏在她身後所以淡一點
    for (var i = 0; i < 40; i++) {
      final a = i / 40 * 2 * pi;
      final p = c + Offset(cos(a) * rx, sin(a) * ry);
      final back = sin(a) > 0.2 ? 0.35 : 0.85;
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(a + (i.isEven ? 0.7 : -0.7));
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 6), Paint()..color = (i.isEven ? const Color(0xFF2FA866) : const Color(0xFF1E7A4A)).withValues(alpha: back));
      canvas.restore();
      if (i % 4 == 0) {
        // 小燈：紅、金、白輪流閃
        final tw = 0.5 + 0.5 * sin(t * 3 + i);
        final col = const [Color(0xFFFF5A6E), Color(0xFFFFD166), Colors.white][(i ~/ 4) % 3];
        canvas.drawCircle(p, 5, Paint()..color = col.withValues(alpha: 0.25 * tw * back));
        canvas.drawCircle(p, 2.2, Paint()..color = col.withValues(alpha: (0.5 + 0.5 * tw) * back));
      }
    }
    // 雪花
    for (var i = 0; i < 46; i++) {
      final speed = 0.04 + 0.04 * _h(i + 9);
      final y = (_h(i) + t * speed) % 1.0;
      final x = stage.left - stage.width * 0.2 + _h(i + 30) * stage.width * 1.4 + sin(t * 0.7 + i) * 8;
      final fade = sin(y * pi);
      final r = 1.2 + 2.2 * _h(i + 3);
      canvas.drawCircle(Offset(x, stage.top - stage.height * 0.1 + y * stage.height * 1.25), r, Paint()..color = Colors.white.withValues(alpha: 0.75 * fade));
    }
  }

  @override
  bool shouldRepaint(covariant _XmasSkinPainter old) => old.stage != stage;
}

/// 跨年造型：艾婭身邊輪流綻開金色、粉色、藍色的小煙火，頭頂一圈金色光環
class _NewYearSkinPainter extends CustomPainter {
  final Rect stage;
  final double Function() clock;
  _NewYearSkinPainter({required this.stage, required Listenable repaint, required this.clock}) : super(repaint: repaint);
  static double _h(int i) { final x = sin(i * 53.7 + 9.2) * 43758.5453; return x - x.floorToDouble(); }

  @override
  void paint(Canvas canvas, Size size) {
    final t = clock();
    final c = stage.center;
    // 頭頂的金色光環
    final halo = Rect.fromCenter(center: Offset(c.dx, stage.top + stage.height * 0.08), width: stage.width * 0.42, height: stage.width * 0.1);
    canvas.drawOval(halo, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = const Color(0xFFFFD166).withValues(alpha: 0.75 + 0.2 * sin(t * 2)));
    const colors = [Color(0xFFFFD166), Color(0xFFFF7BD5), Color(0xFF7FD8FF)];
    const bursts = 4, period = 2.6;
    for (var b = 0; b < bursts; b++) {
      final local = t + b * period / bursts;
      final cycle = (local / period).floor();
      final p = (local % period) / period;
      if (p > 0.75) continue;
      final q = p / 0.75;
      // 煙火在她兩側和頭頂，避開臉
      final side = _h(cycle * 7 + b) < 0.5 ? -1.0 : 1.0;
      final center = Offset(c.dx + side * stage.width * (0.32 + 0.18 * _h(cycle * 3 + b)), stage.top + stage.height * (0.05 + 0.5 * _h(cycle * 5 + b)));
      final color = colors[(cycle + b) % colors.length];
      final reach = stage.width * 0.13 * Curves.easeOut.transform(q);
      final alpha = (1 - q) * 0.95;
      for (var j = 0; j < 12; j++) {
        final a = j / 12 * 2 * pi;
        final d = Offset(cos(a), sin(a));
        canvas.drawLine(center + d * reach * 0.4, center + d * reach, Paint()..color = color.withValues(alpha: alpha)..strokeWidth = 2..strokeCap = StrokeCap.round);
      }
      canvas.drawCircle(center, 3 * (1 - q), Paint()..color = Colors.white.withValues(alpha: alpha));
    }
  }

  @override
  bool shouldRepaint(covariant _NewYearSkinPainter old) => old.stage != stage;
}
