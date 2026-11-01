import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 量子世界第三期：量子跨年（規格 docs/quantum-world-spec.md 5.2）。
/// 12/31 各時區跨年時，那裡的氣泡一波波亮起金色光環；量子中心（台北）午夜，
/// 全蜂巢一起倒數 10 秒，101 原點放出全世界最大的光爆和煙火，顯示一起跨年的人數。

class QuantumNewYear {
  QuantumNewYear._();
  static const _taipeiTz = 480;

  /// 跨年期間伺服器回傳的台北午夜（測試時伺服器可以改）；沒有就用今年的 12/31 16:00 UTC
  static int? serverAt;

  /// 預演用：--dart-define=QUANTUM_NY_TEST_AT=毫秒，把某個整點當成量子中心午夜（上架版本不會帶）
  static const testAt = int.fromEnvironment('QUANTUM_NY_TEST_AT');

  static int defaultAt(DateTime now) {
    final u = now.toUtc();
    final year = u.month >= 7 ? u.year + 1 : u.year;
    return DateTime.utc(year - 1, 12, 31, 16).millisecondsSinceEpoch;
  }

  static int at(DateTime now) => serverAt ?? defaultAt(now);

  /// 新的一年是哪一年（量子中心的日期）
  static int year(int at) => DateTime.fromMillisecondsSinceEpoch(at, isUtc: true).add(const Duration(hours: 8)).year;

  /// 某個時區的當地午夜
  static int zoneMidnight(int at, int tz) => at + (_taipeiTz - tz) * 60000;

  /// 剛跨年（90 秒內）的時區；量子中心有自己的大秀，不算在這裡
  static int? zoneJustCrossed(int at, int nowMs) {
    for (final tz in _zones.keys) {
      if (tz == _taipeiTz) continue;
      final d = nowMs - zoneMidnight(at, tz);
      if (d >= 0 && d < 90000) return tz;
    }
    return null;
  }

  /// 12/31 當地時間的跨年時區與代表城市（12 月是南半球夏令時間）；不列中國大陸
  static const _zones = <int, Map<String, String>>{
    840: {'en': 'Kiribati', 'zh': '吉里巴斯', 'zh_Hans': '基里巴斯', 'ja': 'キリバス', 'ko': '키리바시'},
    780: {'en': 'New Zealand, Tonga', 'zh': '紐西蘭、東加', 'zh_Hans': '新西兰、汤加', 'ja': 'ニュージーランド、トンガ', 'ko': '뉴질랜드, 통가'},
    660: {'en': 'Sydney, Melbourne', 'zh': '雪梨、墨爾本', 'zh_Hans': '悉尼、墨尔本', 'ja': 'シドニー、メルボルン', 'ko': '시드니, 멜버른'},
    600: {'en': 'Brisbane, Guam', 'zh': '布里斯本、關島', 'zh_Hans': '布里斯班、关岛', 'ja': 'ブリスベン、グアム', 'ko': '브리즈번, 괌'},
    540: {'en': 'Tokyo, Seoul', 'zh': '東京、首爾', 'zh_Hans': '东京、首尔', 'ja': '東京、ソウル', 'ko': '도쿄, 서울'},
    480: {'en': 'Taipei', 'zh': '台北', 'zh_Hans': '台北', 'ja': '台北', 'ko': '타이베이'},
    420: {'en': 'Bangkok, Jakarta, Hanoi', 'zh': '曼谷、雅加達、河內', 'zh_Hans': '曼谷、雅加达、河内', 'ja': 'バンコク、ジャカルタ、ハノイ', 'ko': '방콕, 자카르타, 하노이'},
    330: {'en': 'India', 'zh': '印度', 'zh_Hans': '印度', 'ja': 'インド', 'ko': '인도'},
    240: {'en': 'Dubai', 'zh': '杜拜', 'zh_Hans': '迪拜', 'ja': 'ドバイ', 'ko': '두바이'},
    180: {'en': 'Istanbul, Moscow', 'zh': '伊斯坦堡、莫斯科', 'zh_Hans': '伊斯坦布尔、莫斯科', 'ja': 'イスタンブール、モスクワ', 'ko': '이스탄불, 모스크바'},
    120: {'en': 'Athens, Cairo', 'zh': '雅典、開羅', 'zh_Hans': '雅典、开罗', 'ja': 'アテネ、カイロ', 'ko': '아테네, 카이로'},
    60: {'en': 'Paris, Berlin', 'zh': '巴黎、柏林', 'zh_Hans': '巴黎、柏林', 'ja': 'パリ、ベルリン', 'ko': '파리, 베를린'},
    0: {'en': 'London', 'zh': '倫敦', 'zh_Hans': '伦敦', 'ja': 'ロンドン', 'ko': '런던'},
    -180: {'en': 'São Paulo, Buenos Aires', 'zh': '聖保羅、布宜諾斯艾利斯', 'zh_Hans': '圣保罗、布宜诺斯艾利斯', 'ja': 'サンパウロ、ブエノスアイレス', 'ko': '상파울루, 부에노스아이레스'},
    -300: {'en': 'New York, Toronto', 'zh': '紐約、多倫多', 'zh_Hans': '纽约、多伦多', 'ja': 'ニューヨーク、トロント', 'ko': '뉴욕, 토론토'},
    -360: {'en': 'Chicago, Mexico City', 'zh': '芝加哥、墨西哥城', 'zh_Hans': '芝加哥、墨西哥城', 'ja': 'シカゴ、メキシコシティ', 'ko': '시카고, 멕시코시티'},
    -420: {'en': 'Denver', 'zh': '丹佛', 'zh_Hans': '丹佛', 'ja': 'デンバー', 'ko': '덴버'},
    -480: {'en': 'Los Angeles, Vancouver', 'zh': '洛杉磯、溫哥華', 'zh_Hans': '洛杉矶、温哥华', 'ja': 'ロサンゼルス、バンクーバー', 'ko': '로스앤젤레스, 밴쿠버'},
    -600: {'en': 'Honolulu', 'zh': '檀香山', 'zh_Hans': '檀香山', 'ja': 'ホノルル', 'ko': '호놀룰루'},
  };

  /// 時區的城市名稱：繁中、簡中、日、韓用自己的寫法，其他語言用英文
  static String places(int tz) {
    final names = _zones[tz] ?? const {};
    final lang = tr.localeName;
    return names[lang] ?? names[lang.split('_').first] ?? names['en'] ?? 'UTC${tz >= 0 ? '+' : ''}${tz ~/ 60}';
  }
}

/// 量子中心午夜：一道全畫面的光爆，新的一年的數字亮起，接著天空放 5 分鐘的煙火
class QuantumFireworksPainter extends CustomPainter {
  final double t; // 午夜後第幾秒
  final int year;
  final double intensity; // 0～1：一起跨年的人越多，煙火越密
  QuantumFireworksPainter({required this.t, required this.year, required this.intensity});

  static const duration = 330.0;
  static const _colors = [Night.cityAmber, Night.knockPink, Night.auroraViolet, Night.auroraBlue, Colors.white, Color(0xFFFFD54F)];

  // 每一發煙火的位置、顏色、大小都用編號算出來：每一格畫面都一樣，不用存狀態
  static double _rand(int i, int salt) {
    final x = sin(i * 12.9898 + salt * 78.233) * 43758.5453;
    return x - x.floorToDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (t < 0 || t > duration) return;
    final fade = t > duration - 30 ? (duration - t) / 30 : 1.0;
    final center = size.center(Offset.zero);

    // 1. 光爆：全畫面一閃，一圈光從中心擴散到畫面外
    if (t < 1.2) {
      final k = t / 1.2;
      canvas.drawRect(Offset.zero & size, Paint()..color = Color.lerp(Colors.white, Night.cityAmber, k)!.withOpacity(0.75 * (1 - k)));
    }
    if (t < 3.5) {
      final k = Curves.easeOut.transform(t / 3.5);
      final r = size.longestSide * 1.1 * k;
      canvas.drawCircle(center, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 26 * (1 - k) + 2..color = Night.cityAmber.withOpacity(0.7 * (1 - k))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
      canvas.drawCircle(center, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.white.withOpacity(1 - k));
    }

    // 2. 煙火：前 1 分鐘最密，之後一直放到 5 分鐘；人越多越密
    final busy = t < 60 ? 1.0 : 0.55;
    final interval = (0.85 - 0.5 * intensity) / busy;
    const life = 2.4;
    final last = (t / interval).floor();
    for (var i = max(0, last - (life / interval).ceil()); i <= last; i++) {
      final start = i * interval + 0.4; // 光爆之後才開始
      final k = (t - start) / life;
      if (k < 0 || k > 1) continue;
      final at = Offset(size.width * (0.12 + 0.76 * _rand(i, 1)), size.height * (0.12 + 0.42 * _rand(i, 2)));
      final color = _colors[(_rand(i, 3) * _colors.length).floor() % _colors.length];
      final radius = 55 + 70 * _rand(i, 4) + 30 * intensity;
      final rays = 22 + (_rand(i, 5) * 14).floor();
      final spread = Curves.easeOut.transform(min(1.0, k * 1.6));
      final alpha = (1 - k) * fade;
      final drop = 28 * k * k; // 慢慢往下垂
      final spark = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      final trail = Paint()..strokeWidth = 2.4..strokeCap = StrokeCap.round;
      for (var j = 0; j < rays; j++) {
        final a = j * 2 * pi / rays + _rand(i, 6);
        final dir = Offset(cos(a), sin(a));
        final head = at + dir * radius * spread + Offset(0, drop);
        final tail = at + dir * radius * max(0.0, spread - 0.25) + Offset(0, drop * 0.6);
        trail.color = color.withOpacity(0.75 * alpha);
        canvas.drawLine(tail, head, trail);
        spark.color = Color.lerp(Colors.white, color, k)!.withOpacity(alpha);
        canvas.drawCircle(head, 3.4 * (1 - k * 0.4), spark);
        canvas.drawCircle(head, 7 * (1 - k * 0.4), Paint()..color = color.withOpacity(0.25 * alpha)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      }
      if (k < 0.15) {
        canvas.drawCircle(at, 16 * (1 - k / 0.15) + 4, Paint()..color = Colors.white.withOpacity(0.8 * fade)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      }
    }

    // 3. 新的一年的數字：和席位代號同一種字，大一號，漸層加藍色光暈，下面一行「新年快樂」
    if (t < 9) {
      final alpha = (t < 0.6 ? t / 0.6 : t > 7 ? (9 - t) / 2 : 1.0).clamp(0.0, 1.0);
      final scale = 0.9 + 0.1 * Curves.easeOut.transform(min(1.0, t / 1.5));
      final yearText = TextPainter(
        text: TextSpan(text: '$year', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w600, letterSpacing: 6,
            foreground: Paint()..shader = Night.brightGradient.createShader(const Rect.fromLTWH(-100, -32, 200, 64))..color = Colors.white.withOpacity(alpha),
            shadows: [Shadow(color: Night.auroraBlue.withOpacity(alpha), blurRadius: 22)])),
        textDirection: TextDirection.ltr,
      )..layout();
      final happy = TextPainter(
        text: TextSpan(text: tr.quantumNyHappy, style: TextStyle(color: Colors.white.withOpacity(alpha), fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 4,
            shadows: const [Shadow(color: Night.auroraBlue, blurRadius: 14)])),
        textDirection: TextDirection.ltr,
      )..layout();
      final c = center - const Offset(0, 90);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.scale(scale);
      yearText.paint(canvas, Offset(-yearText.width / 2, -yearText.height / 2));
      happy.paint(canvas, Offset(-happy.width / 2, yearText.height / 2 + 6));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant QuantumFireworksPainter old) => true;
}

/// 量子世界面板：量子跨年的預告（12/31 前 75 天開始）
class QuantumNewYearTeaser extends StatelessWidget {
  const QuantumNewYearTeaser({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final left = QuantumNewYear.at(now) - now.millisecondsSinceEpoch;
    if (left <= 0 || left > 75 * 86400000) return const SizedBox.shrink();
    final days = (left / 86400000).ceil();
    return Padding(
      padding: const EdgeInsets.only(bottom: Night.space4),
      child: Row(children: [
        const Icon(Icons.celebration_outlined, color: Night.cityAmber, size: 22),
        const SizedBox(width: Night.space4),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr.quantumNyTitle, style: const TextStyle(color: Night.ink, fontSize: 15)),
            const SizedBox(height: 2),
            Text(days <= 1 ? tr.quantumNyTonight : tr.quantumNyDays(days), style: Night.caption),
          ]),
        ),
      ]),
    );
  }
}
