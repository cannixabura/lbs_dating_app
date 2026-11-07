import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'mood_card.dart';
import 'quantum_orb.dart';
import 'ui/night.dart';

/// 平行護照：跟一座平行城市的人聊天（雙方都至少說過一句話），伺服器就在那座城市蓋一個章。
/// 只記「哪座城市、哪一天」，不記對方是誰。集滿 [passportRewardCities] 座城市得到「護照款」光球。
/// 資料：passport/{uid}/{cityId} = { at, country, names: [9 種語言] }（只有伺服器寫得進去）
const passportRewardCities = 5;

/// 名稱順序與伺服器 parallel.js 的 LANGS 相同
const _langs = ['zh-Hant', 'zh-Hans', 'en', 'ja', 'ko', 'ms', 'id', 'vi', 'th'];

/// 國旗與國家的顏色（印章用）；顏色只是裝飾，不代表任何意思
const passportFlags = {
  'tw': '🇹🇼', 'jp': '🇯🇵', 'kr': '🇰🇷', 'hk': '🇭🇰', 'mo': '🇲🇴', 'sg': '🇸🇬', 'my': '🇲🇾',
  'id': '🇮🇩', 'vn': '🇻🇳', 'th': '🇹🇭', 'ph': '🇵🇭', 'au': '🇦🇺',
};
const _countryColors = {
  'tw': Color(0xFF7FD8FF), 'jp': Color(0xFFFF8AD8), 'kr': Color(0xFF9CB8FF), 'hk': Color(0xFFFF9C8A), 'mo': Color(0xFF8AFFC8),
  'sg': Color(0xFFFFB37F), 'my': Color(0xFFFFD27A), 'id': Color(0xFFFF7FA0), 'vn': Color(0xFFFFE07F), 'th': Color(0xFFB79CFF),
  'ph': Color(0xFF7FFFE8), 'au': Color(0xFF9CFF8A),
};
Color passportColor(String country) => _countryColors[country] ?? Night.auroraViolet;

class PassportStamp {
  final String id, country;
  final List<String> names;
  final DateTime at;
  const PassportStamp({required this.id, required this.country, required this.names, required this.at});

  String get name {
    final i = _langs.indexOf(currentLanguageTag);
    if (names.isEmpty) return id;
    return names[i >= 0 && i < names.length ? i : 0];
  }

  String get date => '${at.year}.${at.month.toString().padLeft(2, '0')}.${at.day.toString().padLeft(2, '0')}';
}

class PassportState {
  static final stamps = ValueNotifier<List<PassportStamp>>(const []);

  /// 新蓋的章（主畫面顯示提示後清掉）
  static final notice = ValueNotifier<String?>(null);

  static StreamSubscription<DatabaseEvent>? _sub;
  static String? _uid;
  static bool _loaded = false;

  static StreamSubscription<User?>? _auth;
  static VoidCallback? _onReward;

  /// 開始聽自己的護照：App 啟動時可能還沒登入完成，所以跟著登入狀態，登入（或換帳號）後才開始聽
  static void listen({VoidCallback? onReward}) {
    if (onReward != null) _onReward = onReward;
    _auth ??= FirebaseAuth.instance.authStateChanges().listen((_) => _listenUid());
    _listenUid();
  }

  static void _listenUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid == _uid) return;
    _sub?.cancel();
    _uid = uid;
    _loaded = false;
    _sub = FirebaseDatabase.instance.ref('passport/$uid').onValue.listen((event) {
      final before = {for (final s in stamps.value) s.id};
      final next = parse(event.snapshot.value);
      stamps.value = next;
      if (_loaded) {
        final added = next.where((s) => !before.contains(s.id)).toList();
        if (added.isNotEmpty) {
          final reached = before.length < passportRewardCities && next.length >= passportRewardCities;
          notice.value = reached ? tr.passportRewardToast : tr.passportNewStamp(added.map((s) => s.name).join('、'));
          if (reached) _onReward?.call();
        }
      }
      _loaded = true;
    }, onError: (_) {});
  }

  static List<PassportStamp> parse(Object? value) {
    if (value is! Map) return const [];
    final out = <PassportStamp>[];
    value.forEach((k, v) {
      if (v is! Map) return;
      final at = v['at'];
      out.add(PassportStamp(
        id: '$k',
        country: '${v['country'] ?? ''}',
        names: [for (final n in (v['names'] as List? ?? const [])) '$n'],
        at: DateTime.fromMillisecondsSinceEpoch(at is num ? at.toInt() : 0),
      ));
    });
    out.sort((a, b) => a.at.compareTo(b.at));
    return out;
  }
}

/// 平行護照頁：收集進度、護照款光球、依國家分頁的印章，可以分享（只寫數量和國旗）
Future<void> showPassport(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(Night.space3),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
        child: const GlassCard(child: _PassportSheet()),
      ),
    ),
  );
}

class _PassportSheet extends StatefulWidget {
  const _PassportSheet();
  @override
  State<_PassportSheet> createState() => _PassportSheetState();
}

class _PassportSheetState extends State<_PassportSheet> {
  String? _country;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PassportStamp>>(
      valueListenable: PassportState.stamps,
      builder: (context, stamps, _) {
        final countries = <String>[];
        for (final s in stamps) {
          if (!countries.contains(s.country)) countries.add(s.country);
        }
        final country = countries.contains(_country) ? _country : (countries.isEmpty ? null : countries.first);
        final left = max(0, passportRewardCities - stamps.length);
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SheetTitle(tr.passportTitle, closeTooltip: tr.close),
            const SizedBox(height: Night.space2),
            Text(tr.passportCount(stamps.length), style: Night.title.copyWith(color: Night.auroraViolet), textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            // 獎勵：護照款光球
            Container(
              padding: const EdgeInsets.all(Night.space3),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Night.glassLine)),
              child: Row(children: [
                QuantumOrb(style: 'passport', color: Night.auroraViolet, size: 56, dim: left > 0),
                const SizedBox(width: Night.space3),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(tr.orbStylePassport, style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(left > 0 ? tr.passportRewardProgress(left) : tr.passportRewardDone, style: Night.caption),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: min(1.0, stamps.length / passportRewardCities),
                        minHeight: 4,
                        backgroundColor: Night.glassLine,
                        color: Night.auroraViolet,
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: Night.space4),
            if (stamps.isEmpty)
              Text(tr.passportEmpty, style: Night.body, textAlign: TextAlign.center)
            else ...[
              SizedBox(
                height: 40,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (final k in countries)
                    Padding(
                      padding: const EdgeInsets.only(right: Night.space2),
                      child: ChoiceChip(
                        label: Text('${passportFlags[k] ?? k} ${stamps.where((s) => s.country == k).length}', style: const TextStyle(fontSize: 16)),
                        selected: k == country,
                        onSelected: (_) => setState(() => _country = k),
                      ),
                    ),
                ]),
              ),
              const SizedBox(height: Night.space3),
              Wrap(spacing: Night.space3, runSpacing: Night.space3, alignment: WrapAlignment.center, children: [
                for (final s in stamps.where((s) => s.country == country)) PassportStampView(stamp: s),
              ]),
              const SizedBox(height: Night.space3),
              Text(tr.passportEmpty, style: Night.caption, textAlign: TextAlign.center),
              const SizedBox(height: Night.space3),
              Center(child: NightButton(tr.passportShare, icon: Icons.ios_share, onPressed: () => showPassportCard(context, stamps))),
            ],
          ]),
        );
      },
    );
  }
}

/// 一個印章：圓形郵戳，國家的顏色，中間是城市名稱，下面是日期
class PassportStampView extends StatelessWidget {
  final PassportStamp stamp;
  final double size;
  const PassportStampView({super.key, required this.stamp, this.size = 92});

  @override
  Widget build(BuildContext context) {
    final color = passportColor(stamp.country);
    // 每個章稍微歪一點（固定角度，跟城市代號綁在一起），像真的蓋上去
    final tilt = ((stamp.id.codeUnits.fold<int>(0, (a, b) => a + b) % 17) - 8) / 100;
    return Transform.rotate(
      angle: tilt,
      child: SizedBox(
        width: size, height: size,
        child: CustomPaint(
          painter: _StampPainter(color),
          child: Padding(
            padding: EdgeInsets.all(size * 0.16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(passportFlags[stamp.country] ?? '', style: TextStyle(fontSize: size * 0.16)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(stamp.name, style: TextStyle(color: color, fontSize: size * 0.17, fontWeight: FontWeight.w700, letterSpacing: 1)),
              ),
              Text(stamp.date, style: TextStyle(color: color.withOpacity(0.8), fontSize: size * 0.1, letterSpacing: 0.5)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _StampPainter extends CustomPainter {
  final Color color;
  _StampPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawCircle(c, r * 0.95, Paint()..color = color.withOpacity(0.2)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.12));
    canvas.drawCircle(c, r * 0.92, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.05..color = color.withOpacity(0.9));
    canvas.drawCircle(c, r * 0.8, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.02..color = color.withOpacity(0.6));
    // 外圈的光點（郵戳的齒孔）
    for (var i = 0; i < 28; i++) {
      final a = i / 28 * 2 * pi;
      canvas.drawCircle(c + Offset(cos(a), sin(a)) * r * 0.86, r * 0.018, Paint()..color = color.withOpacity(0.8));
    }
  }

  @override
  bool shouldRepaint(_StampPainter old) => old.color != color;
}

/// 護照分享卡：只寫城市數量和國旗，不寫城市名稱與日期（推不回去過哪裡、什麼時候）
Future<void> showPassportCard(BuildContext context, List<PassportStamp> stamps) {
  final byCountry = <String, int>{};
  for (final s in stamps) {
    byCountry[s.country] = (byCountry[s.country] ?? 0) + 1;
  }
  return showDrawnShareCard(
    context,
    fileName: 'city_whisper_passport',
    shareLabel: tr.passportShare,
    build: () => PassportCard(count: stamps.length, byCountry: byCountry),
    shareText: tr.passportCardShareText(stamps.length),
    ref: 'passport',
  );
}

/// 護照分享卡本體（360×640）
class PassportCard extends StatelessWidget {
  final int count;
  final Map<String, int> byCountry;
  const PassportCard({super.key, required this.count, required this.byCountry});

  @override
  Widget build(BuildContext context) {
    final rnd = Random(count * 31 + byCountry.length);
    return SizedBox(
      width: 360, height: 640,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1B1446), Color(0xFF0B0F2E), Color(0xFF070B1F)]),
              ),
            ),
          ),
          // 星空
          Positioned.fill(
            child: CustomPaint(painter: _StarsPainter([for (var i = 0; i < 70; i++) Offset(rnd.nextDouble(), rnd.nextDouble())])),
          ),
          Positioned(
            left: 28, right: 28, top: 52,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.passportTitle, style: const TextStyle(color: Night.auroraViolet, fontSize: 13, letterSpacing: 3, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Text(tr.passportCardTitle(count),
                  style: const TextStyle(color: Night.ink, fontSize: 30, height: 1.4, fontWeight: FontWeight.w600, letterSpacing: 1,
                      shadows: [Shadow(color: Color(0xBFB79CFF), blurRadius: 24)])),
              const SizedBox(height: 16),
              Container(width: 72, height: 2, decoration: const BoxDecoration(color: Night.auroraViolet, boxShadow: [BoxShadow(color: Night.auroraViolet, blurRadius: 8)])),
            ]),
          ),
          // 中間：大顆的護照款光球
          const Positioned(
            left: 0, right: 0, top: 220,
            child: Center(child: QuantumOrb(style: 'passport', color: Night.auroraViolet, size: 170)),
          ),
          // 國旗與每國的城市數
          Positioned(
            left: 24, right: 24, top: 430,
            child: Wrap(spacing: 18, runSpacing: 14, alignment: WrapAlignment.center, children: [
              for (final e in byCountry.entries)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(passportFlags[e.key] ?? '', style: const TextStyle(fontSize: 34)),
                  const SizedBox(width: 6),
                  Text('${e.value}', style: TextStyle(color: passportColor(e.key), fontSize: 26, fontWeight: FontWeight.w700,
                      shadows: [Shadow(color: passportColor(e.key).withOpacity(0.7), blurRadius: 12)])),
                ]),
            ]),
          ),
          Positioned(left: 24, right: 24, bottom: 22, child: const ShareCardBrand()),
        ]),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  final List<Offset> stars;
  _StarsPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < stars.length; i++) {
      final p = Offset(stars[i].dx * size.width, stars[i].dy * size.height * 0.75);
      canvas.drawCircle(p, i % 7 == 0 ? 1.4 : 0.8, Paint()..color = Colors.white.withOpacity(i % 3 == 0 ? 0.8 : 0.4));
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => false;
}
