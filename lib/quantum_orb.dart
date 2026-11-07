import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 量子化身：量子世界裡的光球頭像（規格：docs/quantum-world-spec.md §5.5，伺服器：geo-service/orbs.js）。
/// 光球的主色永遠跟著心情；款式只改變紋路和光暈，不影響任何權益。
/// 基本款免費；特殊款用 Apple / Google 內購買斷，買過的款式跟著帳號（orbOwned/{uid}，只有伺服器寫得進去）。

const _orbsUrl = String.fromEnvironment('ORBS_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/orbs');

/// 所有款式，依面板上的順序；和 geo-service/orbs.js 的 STYLES 相同
const orbStyles = ['glow', 'ring', 'rainbow', 'startrail', 'rings', 'pair', 'passport', 'xmas', 'newyear', 'valentine', 'sakura'];
const orbDefaultStyle = 'glow';

/// 特殊款的商店商品代號（App Store Connect 與 Play Console 都用同一個代號）
const orbProducts = {'rainbow': 'orb_rainbow', 'startrail': 'orb_startrail', 'rings': 'orb_rings', 'xmas': 'orb_xmas', 'newyear': 'orb_newyear', 'valentine': 'orb_valentine', 'sakura': 'orb_sakura', 'aiya_xmas': 'aiya_skin_xmas', 'aiya_newyear': 'aiya_skin_newyear'};

/// 艾婭節日造型：和光球共用購買與擁有紀錄（orbOwned），但不是光球款式，只有買的人看得到自己的艾婭換造型
const aiyaSkins = ['aiya_xmas', 'aiya_newyear'];

/// 限定款的最後販售時間（台北時間，和 orbs.js 相同）：過了就不再賣，買過的人永久保留
final orbLimitedUntil = {
  'xmas': DateTime.utc(2026, 12, 25, 15, 59, 59), // 12/25 23:59:59 台北
  'newyear': DateTime.utc(2027, 1, 1, 15, 59, 59), // 1/1 23:59:59 台北
  'valentine': DateTime.utc(2027, 2, 14, 15, 59, 59), // 2/14 23:59:59 台北
  'sakura': DateTime.utc(2027, 4, 10, 15, 59, 59), // 4/10 23:59:59 台北
  'aiya_xmas': DateTime.utc(2026, 12, 25, 15, 59, 59),
  'aiya_newyear': DateTime.utc(2027, 1, 1, 15, 59, 59),
};

/// 量子跨年那一刻（量子中心午夜）：跨年款在之後 5 分鐘綻開得特別大
final _newYearBloom = DateTime.utc(2026, 12, 31, 16);

/// 只能透過禮物取得的款式（糾纏款）：不是免費款，面板上只有擁有的人看得到
const orbGrantedStyles = {'pair', 'passport'};
bool orbIsFree(String style) => !orbProducts.containsKey(style) && !orbGrantedStyles.contains(style);
bool orbIsLimited(String style) => orbLimitedUntil.containsKey(style);
bool orbOnSale(String style, [DateTime? now]) {
  if (orbIsFree(style) || orbGrantedStyles.contains(style)) return false;
  final until = orbLimitedUntil[style];
  return until == null || !(now ?? DateTime.now()).toUtc().isAfter(until);
}

/// 限定款的截止日（台北的月/日），例如 12/25
String orbUntilLabel(String style) {
  final until = orbLimitedUntil[style];
  if (until == null) return '';
  final tpe = until.add(const Duration(hours: 8));
  return '${tpe.month}/${tpe.day}';
}
/// 會長大的光球：星軌（每完成一張量子相遇卡多一顆星）、年輪（在量子世界累積待滿 3 小時多一圈）
const orbGrowingStyles = {'startrail', 'rings'};

/// 自己的成長紀錄（伺服器每次心跳回傳）；不管有沒有買、用哪一款都一直累積
class OrbGrowth {
  OrbGrowth._();
  static final mine = ValueNotifier<({int stars, int rings})>((stars: 0, rings: 0));
  /// 自己收到光之花束的 24 小時內（伺服器每次心跳回傳）
  static final myBouquet = ValueNotifier<bool>(false);

  static void apply(Object? raw) {
    if (raw is! Map) return;
    final stars = (raw['stars'] as num?)?.toInt() ?? 0, rings = (raw['rings'] as num?)?.toInt() ?? 0;
    if (stars != mine.value.stars || rings != mine.value.rings) mine.value = (stars: stars, rings: rings);
  }

  /// 附近的人的成長：伺服器給 [星星, 圈數]，只有會長大的款式才有
  static ({int stars, int rings})? parse(Object? raw) =>
      raw is List && raw.length == 2 && raw[0] is num && raw[1] is num ? (stars: (raw[0] as num).toInt(), rings: (raw[1] as num).toInt()) : null;
}

String orbStyleOf(Object? raw) => raw is String && orbStyles.contains(raw) ? raw : orbDefaultStyle;

String orbStyleName(String style) => switch (style) {
      'ring' => tr.orbStyleRing,
      'rainbow' => tr.orbStyleRainbow,
      'startrail' => tr.orbStyleStarTrail,
      'rings' => tr.orbStyleRings,
      'pair' => tr.orbStylePair,
      'passport' => tr.orbStylePassport,
      'xmas' => tr.orbStyleXmas,
      'newyear' => tr.orbStyleNewYear,
      'valentine' => tr.orbStyleValentine,
      'sakura' => tr.orbStyleSakura,
      'aiya_xmas' => tr.aiyaSkinXmas,
      'aiya_newyear' => tr.aiyaSkinNewYear,
      _ => tr.orbStyleGlow,
    };

// ---------- 光球 ----------

/// 大頭貼網址 → 球型頭像用的圖；沒有大頭貼時是 null（畫成一顆心情色的光球）
ImageProvider? orbImage(String? url) => url == null || url.isEmpty ? null : NetworkImage(url);

/// 球型頭像：大頭貼包在一顆玻璃球裡，球緣透出心情色、左上有高光，外面一圈呼吸光暈。
/// 星環款外面多一圈傾斜的環（後半圈在球後面，看起來是立體的），彩虹款是整圈繞著頭像、慢慢轉的正圓虹光。
/// 用 2D 漸層畫出立體感，不跑 3D 模型，蜂巢裡幾百顆也不會卡。沒有大頭貼時是一顆心情色的光球。
class QuantumOrb extends StatelessWidget {
  final String style;
  final Color color;
  final double size;
  final double glow; // 0～1：呼吸光暈
  final bool dim; // 殘影、休息中
  final ImageProvider? image; // 大頭貼
  final int stars, rings; // 會長大的光球：星軌的星星數、年輪的圈數
  final bool bouquet; // 收到光之花束的 24 小時內：一圈花瓣光點
  const QuantumOrb({super.key, required this.style, required this.color, this.size = 30, this.glow = 0.5, this.dim = false, this.image, this.stars = 0, this.rings = 0, this.bouquet = false});

  /// 球的直徑佔畫布的比例：光暈和環都畫在畫布裡面（超出的部分在某些容器裡會被切成方形）。
  /// 付費的彩虹款球比較大（地圖上約 31，免費款約 26），畫布一樣大，換款式不會讓版面跳動。
  /// 限定款外面有花圈、煙火，球稍微小一點讓裝飾畫得下。
  static double sphereRatio(String style) => switch (style) { 'rainbow' => 0.56, 'xmas' || 'newyear' || 'startrail' || 'rings' || 'pair' || 'passport' || 'valentine' || 'sakura' => 0.5, _ => 0.465 };

  @override
  Widget build(BuildContext context) {
    // 彩虹光環會轉、雪花會飄、煙火會綻開：用時間算，跟著氣泡的呼吸動畫一起重畫
    final ms = DateTime.now().millisecondsSinceEpoch;
    final spin = style == 'rainbow' ? (ms % 6000) / 6000 * 2 * pi : 0.0;
    final t = style == 'xmas' || style == 'newyear' || style == 'startrail' || style == 'pair' || style == 'passport' || style == 'valentine' || style == 'sakura' || bouquet ? (ms % 600000) / 1000.0 : 0.0;
    final bloom = style == 'newyear' && ms >= _newYearBloom.millisecondsSinceEpoch && ms < _newYearBloom.millisecondsSinceEpoch + 5 * 60 * 1000;
    final d = size * sphereRatio(style);
    final photo = image;
    painter(bool front) => QuantumOrbPainter(style: style, color: color, glow: glow, dim: dim, spin: spin, t: t, bloom: bloom, front: front, photo: photo != null, stars: stars, rings: rings, bouquet: bouquet);
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: CustomPaint(painter: painter(false))),
        if (photo != null)
          ClipOval(
            child: ColorFiltered(
              // 殘影的大頭貼去色，和活躍的人一眼分得出來
              colorFilter: dim
                  ? const ColorFilter.matrix(<double>[0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0,0,0,1,0])
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image(image: photo, width: d, height: d, fit: BoxFit.cover, errorBuilder: (_, __, ___) => SizedBox(width: d, height: d)),
            ),
          ),
        Positioned.fill(child: CustomPaint(painter: painter(true))),
      ]),
    );
  }
}

/// 分兩層畫：後層（光暈、環的後半圈、球底色）在大頭貼下面，前層（球面光澤、環的前半圈）在大頭貼上面
class QuantumOrbPainter extends CustomPainter {
  final String style;
  final Color color;
  final double glow;
  final bool dim;
  final double spin;
  final double t; // 秒：限定款的雪花、煙火
  final bool bloom; // 量子跨年那一刻之後 5 分鐘
  final bool front;
  final bool photo;
  final int stars, rings;
  final bool bouquet;
  QuantumOrbPainter({required this.style, required this.color, this.glow = 0.5, this.dim = false, this.spin = 0, this.t = 0, this.bloom = false, this.front = false, this.photo = false, this.stars = 0, this.rings = 0, this.bouquet = false});

  static double _hash(int i) {
    final x = sin(i * 127.1 + 311.7) * 43758.5453;
    return x - x.floorToDouble();
  }

  static const _gold = Color(0xFFFFD166);

  /// 聖誕款：一圈冬青花圈（深淺綠葉、紅莓、頂端一顆會閃的金星），雪花慢慢飄過光球
  void _xmas(Canvas canvas, Size size, Offset c, double r) {
    final k = dim ? 0.4 : 1.0;
    final rr = r * 1.34;
    canvas.drawCircle(c, rr, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.12..color = const Color(0xFF17583A).withOpacity(0.9 * k));
    const leaves = 22;
    for (var i = 0; i < leaves; i++) {
      final a = i / leaves * 2 * pi + 0.1;
      final at = c + Offset(cos(a), sin(a)) * rr;
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(a + (i.isEven ? 0.6 : -0.6));
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: r * 0.38, height: r * 0.17),
          Paint()..color = (i.isEven ? const Color(0xFF2FA866) : const Color(0xFF1E7A4A)).withOpacity(0.95 * k));
      canvas.restore();
    }
    // 紅莓：三顆一組，五組
    for (var g = 0; g < 5; g++) {
      final a = g / 5 * 2 * pi + pi / 2 + 0.35;
      for (var j = 0; j < 3; j++) {
        final aa = a + (j - 1) * 0.11;
        final at = c + Offset(cos(aa), sin(aa)) * (rr + (j == 1 ? r * 0.07 : 0));
        canvas.drawCircle(at, r * 0.075, Paint()..color = const Color(0xFFE53950).withOpacity(k));
        canvas.drawCircle(at + Offset(-r * 0.02, -r * 0.02), r * 0.025, Paint()..color = Colors.white.withOpacity(0.7 * k));
      }
    }
    // 頂端的金星：慢慢閃
    final tw = 0.75 + 0.25 * sin(t * 2.4);
    final top = c + Offset(0, -rr);
    if (!dim) canvas.drawCircle(top, r * 0.3, Paint()..color = _gold.withOpacity(0.35 * tw)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.12));
    final star = Path();
    for (var i = 0; i < 10; i++) {
      final a = -pi / 2 + i * pi / 5;
      final len = (i.isEven ? r * 0.24 : r * 0.1) * (0.9 + 0.1 * tw);
      final pt = top + Offset(cos(a), sin(a)) * len;
      i == 0 ? star.moveTo(pt.dx, pt.dy) : star.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(star..close(), Paint()..color = _gold.withOpacity(k));
    // 雪花：從上往下飄、左右輕輕擺
    if (dim) return;
    for (var i = 0; i < 9; i++) {
      final speed = 0.06 + 0.05 * _hash(i + 7);
      final y = ((_hash(i) + t * speed) % 1.0);
      final x = c.dx + (_hash(i + 31) - 0.5) * size.width * 0.9 + sin(t * 0.8 + i) * r * 0.15;
      final fade = sin(y * pi);
      canvas.drawCircle(Offset(x, y * size.height), r * (0.04 + 0.03 * _hash(i + 3)), Paint()..color = Colors.white.withOpacity(0.85 * fade));
    }
  }

  /// 跨年款：一圈金色的時鐘刻度（12 點最長），一顆光點像秒針繞圈，外面輪流綻開小煙火；
  /// 量子跨年那一刻之後 5 分鐘煙火更多、更大
  void _newYear(Canvas canvas, Size size, Offset c, double r) {
    final k = dim ? 0.4 : 1.0;
    final rr = r * 1.3;
    for (var i = 0; i < 12; i++) {
      final a = -pi / 2 + i / 12 * 2 * pi;
      final dir = Offset(cos(a), sin(a));
      final len = i == 0 ? r * 0.24 : r * 0.12;
      canvas.drawLine(c + dir * (rr - len / 2), c + dir * (rr + len / 2),
          Paint()..color = _gold.withOpacity((i == 0 ? 1.0 : 0.75) * k)..strokeWidth = i == 0 ? r * 0.08 : r * 0.05..strokeCap = StrokeCap.round);
    }
    canvas.drawCircle(c, rr, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.025..color = _gold.withOpacity(0.45 * k));
    final sa = -pi / 2 + (t % 10) / 10 * 2 * pi;
    final sec = c + Offset(cos(sa), sin(sa)) * rr;
    if (!dim) canvas.drawCircle(sec, r * 0.16, Paint()..color = Colors.white.withOpacity(0.4)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.08));
    canvas.drawCircle(sec, r * 0.07, Paint()..color = Colors.white.withOpacity(k));
    if (dim) return;
    const colors = [_gold, Color(0xFFFF7BD5), Color(0xFF7FD8FF)];
    final bursts = bloom ? 5 : 3;
    const period = 3.0;
    for (var b = 0; b < bursts; b++) {
      final local = t + b * period / bursts;
      final cycle = (local / period).floor();
      final p = (local % period) / period;
      if (p > 0.7) continue; // 每次綻開之間停一下
      final q = p / 0.7;
      final a = _hash(cycle * 13 + b) * 2 * pi;
      final center = c + Offset(cos(a), sin(a)) * r * (bloom ? 1.55 : 1.62);
      final color = colors[(cycle + b) % colors.length];
      final sparks = bloom ? 12 : 8;
      final reach = r * (bloom ? 0.55 : 0.44) * Curves.easeOut.transform(q);
      final alpha = (1 - q) * 0.95;
      for (var j = 0; j < sparks; j++) {
        final sa2 = j / sparks * 2 * pi + a;
        final d2 = Offset(cos(sa2), sin(sa2));
        canvas.drawLine(center + d2 * reach * 0.45, center + d2 * reach,
            Paint()..color = color.withOpacity(alpha)..strokeWidth = r * 0.065..strokeCap = StrokeCap.round);
      }
      canvas.drawCircle(center, r * 0.06 * (1 - q), Paint()..color = Colors.white.withOpacity(alpha));
    }
  }

  /// 星軌款：一條傾斜的軌道，每顆星是一張完成的量子相遇卡，跟著軌道繞（後半圈在球後面）；還沒有星星時只有淡淡的軌道
  void _starTrail(Canvas canvas, Offset c, double r, Color base, {required bool back}) {
    final k = dim ? 0.4 : 1.0;
    final rx = r * 1.45, ry = r * 0.5;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.32);
    final orbit = Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2);
    canvas.drawArc(orbit, back ? pi : 0, pi, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(0.8, r * 0.03)
      ..color = Color.lerp(base, Colors.white, 0.6)!.withOpacity((stars == 0 ? 0.35 : 0.5) * k));
    final n = stars.clamp(0, 24);
    for (var i = 0; i < n; i++) {
      final a = i / n * 2 * pi + t * 0.35;
      final behind = sin(a) < 0;
      if (behind != back) continue;
      final p = Offset(cos(a) * rx, sin(a) * ry);
      final tw = 0.7 + 0.3 * sin(t * 3 + i * 1.7);
      final sr = r * (0.09 + 0.03 * _hash(i + 50)) * (behind ? 0.8 : 1.0);
      if (!dim) canvas.drawCircle(p, sr * 2.4, Paint()..color = _gold.withOpacity(0.28 * tw)..maskFilter = MaskFilter.blur(BlurStyle.normal, sr));
      final star = Path();
      for (var j = 0; j < 8; j++) {
        final aa = -pi / 2 + j * pi / 4;
        final len = j.isEven ? sr * 1.5 : sr * 0.5;
        final pt = p + Offset(cos(aa), sin(aa)) * len;
        j == 0 ? star.moveTo(pt.dx, pt.dy) : star.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(star..close(), Paint()..color = Color.lerp(_gold, Colors.white, 0.4)!.withOpacity((behind ? 0.6 : 1.0) * tw * k));
    }
    canvas.restore();
  }

  /// 年輪款：從球緣往外一圈一圈的細紋，每圈是在量子世界累積待滿的 3 小時；越外圈越淡。還沒有年輪時只有一圈淡淡的輪廓
  void _rings(Canvas canvas, Offset c, double r, Color base) {
    final k = dim ? 0.4 : 1.0;
    final n = rings.clamp(0, 12);
    final wood = Color.lerp(base, const Color(0xFFE8C48A), 0.55)!;
    if (n == 0) {
      canvas.drawCircle(c, r * 1.12, Paint()..style = PaintingStyle.stroke..strokeWidth = max(0.8, r * 0.025)..color = wood.withOpacity(0.35 * k));
      return;
    }
    for (var i = 0; i < n; i++) {
      final f = i / 11; // 固定間距：圈數越多長得越寬，像真的樹
      // 年輪不是正圓：每圈輕輕起伏，像真的木紋
      final path = Path();
      final rr = r * (1.07 + 0.03 * i);
      for (var j = 0; j <= 48; j++) {
        final a = j / 48 * 2 * pi;
        final wob = 1 + 0.008 * sin(a * 3 + i * 1.3) + 0.005 * sin(a * 5 + i);
        final pt = c + Offset(cos(a), sin(a)) * rr * wob;
        j == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path..close(), Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(0.8, r * (i == n - 1 ? 0.04 : 0.022))
        ..color = wood.withOpacity((0.9 - 0.45 * f) * k));
    }
  }

  /// 糾纏款：粉、藍兩條光環像原子軌道一樣交叉傾斜，各有一顆光點沿著跑（後半圈在球後面）
  void _pair(Canvas canvas, Offset c, double r, {required bool back}) {
    final k = dim ? 0.4 : 1.0;
    const colors = [Color(0xFFFF8AD8), Color(0xFF7FD8FF)];
    for (var j = 0; j < 2; j++) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(j == 0 ? -0.55 : 0.55);
      final rect = Rect.fromCenter(center: Offset.zero, width: r * 2.9, height: r * 0.9);
      final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = max(1.0, r * 0.07)..color = colors[j].withOpacity(0.85 * k);
      if (!dim) {
        canvas.drawArc(rect, back ? pi : 0, pi, false, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.2..color = colors[j].withOpacity(0.22)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.08));
      }
      canvas.drawArc(rect, back ? pi : 0, pi, false, paint);
      // 跑動的光點：兩條環的光點方向相反，像兩股纏繞的光
      final a = (j == 0 ? 1 : -1) * t * 1.4 + j * pi;
      final behind = sin(a) < 0;
      if (behind == back) {
        final p = Offset(cos(a) * rect.width / 2, sin(a) * rect.height / 2);
        if (!dim) canvas.drawCircle(p, r * 0.2, Paint()..color = colors[j].withOpacity(0.4)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.1));
        canvas.drawCircle(p, r * 0.08, Paint()..color = Colors.white.withOpacity((behind ? 0.6 : 1.0) * k));
      }
      canvas.restore();
    }
  }

  /// 護照款（平行護照集滿 5 座城市）：外圈是郵票齒孔般的一圈光點慢慢轉，
  /// 球面上有兩條經線像地球儀，一顆金色光點沿著傾斜的航線繞球飛（後半圈在球後面）
  void _passport(Canvas canvas, Offset c, double r, {required bool back}) {
    final k = dim ? 0.4 : 1.0;
    const violet = Color(0xFFB79CFF), gold = Color(0xFFFFD27A);
    if (back) {
      // 郵票齒孔：24 顆光點，每隔一顆亮一點
      for (var i = 0; i < 24; i++) {
        final a = i / 24 * 2 * pi + t * 0.15;
        final p = c + Offset(cos(a), sin(a)) * r * 1.42;
        final big = i.isEven;
        if (!dim && big) canvas.drawCircle(p, r * 0.11, Paint()..color = violet.withOpacity(0.3)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.06));
        canvas.drawCircle(p, r * (big ? 0.06 : 0.04), Paint()..color = (big ? Colors.white : violet).withOpacity(0.85 * k));
      }
    } else {
      // 經線：兩條窄橢圓，像地球儀
      final line = Paint()..style = PaintingStyle.stroke..strokeWidth = max(0.8, r * 0.035)..color = Colors.white.withOpacity(0.35 * k);
      canvas.drawOval(Rect.fromCenter(center: c, width: r * 0.9, height: r * 2), line);
      canvas.drawLine(c + Offset(-r, 0), c + Offset(r, 0), line);
    }
    // 航線上的金色光點
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-0.4);
    final rect = Rect.fromCenter(center: Offset.zero, width: r * 2.6, height: r * 0.8);
    final a = t * 1.1;
    final behind = sin(a) < 0;
    if (!back) {
      canvas.drawArc(rect, 0, pi, false, Paint()..style = PaintingStyle.stroke..strokeWidth = max(0.8, r * 0.03)..color = gold.withOpacity(0.5 * k));
    } else {
      canvas.drawArc(rect, pi, pi, false, Paint()..style = PaintingStyle.stroke..strokeWidth = max(0.8, r * 0.03)..color = gold.withOpacity(0.3 * k));
    }
    if (behind == back) {
      final p = Offset(cos(a) * rect.width / 2, sin(a) * rect.height / 2);
      if (!dim) canvas.drawCircle(p, r * 0.18, Paint()..color = gold.withOpacity(0.45)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.08));
      canvas.drawCircle(p, r * 0.07, Paint()..color = Colors.white.withOpacity((behind ? 0.6 : 1.0) * k));
    }
    canvas.restore();
  }

  /// 光之花束：光球外一圈慢慢轉的花瓣光點（五瓣一朵、粉白色），中間散著金色小光點
  void _petals(Canvas canvas, Offset c, double r) {
    if (dim) return;
    const petal = [Color(0xFFFF8AD8), Color(0xFFFFB3C7), Color(0xFFFFE0EE)];
    for (var f = 0; f < 6; f++) {
      final a = f / 6 * 2 * pi + t * 0.35;
      final center = c + Offset(cos(a), sin(a)) * r * 1.42;
      for (var i = 0; i < 5; i++) {
        final pa = i / 5 * 2 * pi + t * 0.8 + f;
        final at = center + Offset(cos(pa), sin(pa)) * r * 0.12;
        canvas.drawCircle(at, r * 0.075, Paint()..color = petal[(i + f) % 3].withOpacity(0.9));
      }
      canvas.drawCircle(center, r * 0.05, Paint()..color = _gold);
    }
  }

  static Path _heart(Offset c, double s) {
    // 以 c 為中心、寬約 2s 的愛心
    return Path()
      ..moveTo(c.dx, c.dy + s * 0.9)
      ..cubicTo(c.dx - s * 1.3, c.dy + s * 0.1, c.dx - s * 1.0, c.dy - s * 1.0, c.dx, c.dy - s * 0.35)
      ..cubicTo(c.dx + s * 1.0, c.dy - s * 1.0, c.dx + s * 1.3, c.dy + s * 0.1, c.dx, c.dy + s * 0.9)
      ..close();
  }

  /// 情人節款：一圈粉紅與玫瑰金的心形光粒子繞著轉（後半圈淡），跟著「撲通、撲通」的心跳一縮一放，小愛心從球頂往上飄
  void _valentine(Canvas canvas, Size size, Offset c, double r, {required bool back}) {
    final k = dim ? 0.4 : 1.0;
    // 心跳：每 1.2 秒兩下
    final beatT = t % 1.2;
    final beat = 1 + 0.12 * (exp(-pow((beatT - 0.1) / 0.06, 2).toDouble()) + 0.7 * exp(-pow((beatT - 0.35) / 0.06, 2).toDouble()));
    const colors = [Color(0xFFFF4D7D), Color(0xFFFF8AB3), Color(0xFFFFC2A8), Color(0xFFFF6FA0)];
    const n = 12;
    for (var i = 0; i < n; i++) {
      final a = i / n * 2 * pi + t * 0.5;
      final depth = sin(a);
      if ((depth < 0) != back) continue;
      final p = c + Offset(cos(a) * r * 1.42, depth * r * 0.55 - r * 0.05);
      final sz = r * (0.15 + 0.05 * depth) * beat;
      final color = colors[i % colors.length];
      if (!dim) canvas.drawPath(_heart(p, sz * 1.6), Paint()..color = color.withOpacity(0.25 * (0.6 + 0.4 * depth))..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.08));
      canvas.drawPath(_heart(p, sz), Paint()..color = Color.lerp(color, Colors.white, depth > 0 ? 0.15 : 0)!.withOpacity((back ? 0.45 : 0.95) * k));
    }
    if (back || dim) return;
    // 往上飄的小愛心
    for (var i = 0; i < 4; i++) {
      final life = (t * 0.32 + i * 0.25) % 1.0;
      final p = c + Offset(sin(life * 5 + i * 2) * r * 0.35 + (i - 1.5) * r * 0.25, -r * 1.05 - life * r * 0.9);
      canvas.drawPath(_heart(p, r * 0.1 * (1 - life * 0.4)), Paint()..color = colors[i].withOpacity(0.9 * sin(life * pi)));
    }
    // 球面上一點粉色光暈
    canvas.drawCircle(c, r * 1.05, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.06..color = const Color(0xFFFF8AB3).withOpacity(0.55 * beat.clamp(0, 1.2) / 1.2));
  }

  /// 櫻花季款：左上方伸出一段櫻花枝（深褐枝幹、五瓣花、花苞），花瓣從枝頭慢慢飄落、翻轉，風一吹往右下飄
  void _sakura(Canvas canvas, Size size, Offset c, double r) {
    final k = dim ? 0.4 : 1.0;
    const petal = Color(0xFFFFC1D9), petalDeep = Color(0xFFFF8FB8), center = Color(0xFFFFE08A);
    // 枝幹：沿著球的左上外緣的一道弧
    final branch = Path()
      ..moveTo(c.dx - r * 1.55, c.dy + r * 0.2)
      ..quadraticBezierTo(c.dx - r * 1.45, c.dy - r * 1.2, c.dx + r * 0.1, c.dy - r * 1.42)
      ..quadraticBezierTo(c.dx + r * 0.6, c.dy - r * 1.5, c.dx + r * 0.95, c.dy - r * 1.25);
    canvas.drawPath(branch, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.09..strokeCap = StrokeCap.round..color = const Color(0xFF6B4A3A).withOpacity(0.95 * k));
    canvas.drawLine(c + Offset(-r * 1.2, -r * 0.85), c + Offset(-r * 0.85, -r * 0.75), Paint()..strokeWidth = r * 0.06..strokeCap = StrokeCap.round..color = const Color(0xFF6B4A3A).withOpacity(0.9 * k));
    void flower(Offset at, double s, double rot, double open) {
      for (var j = 0; j < 5; j++) {
        final a = rot + j * 2 * pi / 5;
        final pc = at + Offset(cos(a), sin(a)) * s * 0.55 * open;
        canvas.save();
        canvas.translate(pc.dx, pc.dy);
        canvas.rotate(a + pi / 2);
        final shape = Path()
          ..moveTo(0, s * 0.55)
          ..quadraticBezierTo(-s * 0.5, s * 0.1, -s * 0.2, -s * 0.45)
          ..lineTo(0, -s * 0.32) // 花瓣尖端的小缺口
          ..lineTo(s * 0.2, -s * 0.45)
          ..quadraticBezierTo(s * 0.5, s * 0.1, 0, s * 0.55)
          ..close();
        canvas.drawPath(shape, Paint()..shader = RadialGradient(colors: [Colors.white, petal, petalDeep], stops: const [0, 0.6, 1]).createShader(Rect.fromCircle(center: Offset.zero, radius: s * 0.6))..color = Colors.white.withOpacity(k));
        canvas.restore();
      }
      canvas.drawCircle(at, s * 0.14, Paint()..color = center.withOpacity(k));
    }
    final sway = sin(t * 0.9) * 0.08;
    flower(c + Offset(-r * 1.38, -r * 0.55), r * 0.36, 0.3 + sway, 1);
    flower(c + Offset(-r * 0.75, -r * 1.3), r * 0.42, 1.1 - sway, 1);
    flower(c + Offset(r * 0.25, -r * 1.48), r * 0.32, 0.6 + sway, 0.9);
    flower(c + Offset(-r * 1.05, -r * 0.8), r * 0.24, 2.0, 0.8);
    // 花苞
    for (final b in [Offset(r * 0.9, -r * 1.28), Offset(-r * 1.55, r * 0.1)]) {
      canvas.drawOval(Rect.fromCenter(center: c + b, width: r * 0.16, height: r * 0.22), Paint()..color = petalDeep.withOpacity(k));
    }
    if (dim) return;
    // 飄落的花瓣：從枝頭往右下飄、翻轉
    for (var i = 0; i < 7; i++) {
      final life = (t * 0.16 + _hash(i + 40)) % 1.0;
      final start = c + Offset(-r * 1.3 + _hash(i + 41) * r * 2.0, -r * 1.4);
      final p = start + Offset(life * r * 1.2 + sin(life * 6 + i) * r * 0.25, life * r * 3.0);
      if (p.dy > size.height) continue;
      final flip = cos(t * 2.5 + i * 1.7);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(t * 1.2 + i);
      canvas.scale(1, flip.abs() * 0.8 + 0.2);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: r * 0.2, height: r * 0.13), Paint()..color = (i.isEven ? petal : petalDeep).withOpacity(0.95 * sin(life * pi)));
      canvas.restore();
    }
  }

  static const _rainbow = [Color(0xFFFF6B6B), Color(0xFFFFD166), Color(0xFF6BE38E), Color(0xFF4FC3F7), Color(0xFF9C7BFF), Color(0xFFFF7BD5), Color(0xFFFF6B6B)];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * QuantumOrb.sphereRatio(style) / 2;
    final base = dim ? Color.lerp(color, Night.shadowInk, 0.6)! : color;
    final sphere = Rect.fromCircle(center: c, radius: r);

    // 星環：傾斜的橢圓，後半圈在球後面、前半圈在球前面
    void ring(bool back) {
      if (style != 'ring') return;
      final rect = Rect.fromCenter(center: c, width: r * 3.05, height: r * 0.95);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(1.4, r * 0.13)
        ..color = Color.lerp(base, Colors.white, 0.45)!.withOpacity(dim ? 0.4 : 0.9);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(-0.38);
      canvas.translate(-c.dx, -c.dy);
      if (!dim) {
        canvas.drawArc(rect, back ? pi : 0, pi, false, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth * 2.2
          ..color = base.withOpacity(0.25)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.1));
      }
      canvas.drawArc(rect, back ? pi : 0, pi, false, paint);
      canvas.restore();
    }

    // 彩虹款：整圈繞著頭像的正圓虹光，顏色慢慢轉
    void halo() {
      if (style != 'rainbow') return;
      final rect = Rect.fromCircle(center: c, radius: r * 1.36);
      final shader = SweepGradient(colors: [for (final k in _rainbow) k.withOpacity(dim ? 0.35 : 0.95)], transform: GradientRotation(spin)).createShader(rect);
      if (!dim) {
        canvas.drawCircle(c, r * 1.36, Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.32
          ..shader = shader
          ..color = Colors.white.withOpacity(0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.14));
      }
      canvas.drawCircle(c, r * 1.36, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(2.0, r * 0.14)
        ..shader = shader);
    }

    if (!front) {
      // 光暈
      if (!dim) {
        canvas.drawCircle(c, r * (1.12 + 0.15 * glow),
            Paint()..color = base.withOpacity(0.3 + 0.25 * glow)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.25));
      }
      ring(true);
      halo();
      if (style == 'rings') _rings(canvas, c, r, base);
      if (style == 'startrail') _starTrail(canvas, c, r, base, back: true);
      if (style == 'pair') _pair(canvas, c, r, back: true);
      if (style == 'passport') _passport(canvas, c, r, back: true);
      if (style == 'valentine') _valentine(canvas, size, c, r, back: true);
      // 球的底色：沒有大頭貼時就是一顆心情色的光球
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.05,
          colors: [Color.lerp(base, Colors.white, 0.65)!, base, Color.lerp(base, const Color(0xFF070B1F), 0.55)!],
          stops: const [0, 0.5, 1],
        ).createShader(sphere));
      return;
    }

    if (photo) {
      // 玻璃球：中間清楚看得到大頭貼，越往球緣越透出心情色，右下偏暗
      canvas.drawCircle(c, r, Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.25),
          radius: 1.0,
          colors: [Colors.transparent, base.withOpacity(0.18), base.withOpacity(dim ? 0.4 : 0.75)],
          stops: const [0, 0.55, 1],
        ).createShader(sphere));
      canvas.drawCircle(c, r, Paint()
        ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.transparent, const Color(0xFF070B1F).withOpacity(0.5)], stops: const [0, 0.5, 1]).createShader(sphere));
      // 球緣一圈心情色的細邊
      canvas.drawCircle(c, r - 0.6, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = base.withOpacity(dim ? 0.5 : 0.9));
    }

    // 水晶球：球緣一圈厚玻璃的亮邊、上方一片窗光倒影、底部聚光、左上一點銳利的反光
    final k = dim ? 0.4 : 1.0;
    canvas.save();
    canvas.clipPath(Path()..addOval(sphere));
    canvas.drawCircle(c, r, Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.transparent, Colors.white.withOpacity(0.22 * k), Colors.white.withOpacity(0.55 * k)],
        stops: const [0, 0.78, 0.94, 1],
      ).createShader(sphere));
    final window = Rect.fromCenter(center: c + Offset(-r * 0.05, -r * 0.5), width: r * 1.45, height: r * 0.85);
    canvas.drawOval(window, Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.6 * k), Colors.white.withOpacity(0.12 * k), Colors.transparent], stops: const [0, 0.55, 1]).createShader(window));
    final caustic = Rect.fromCenter(center: c + Offset(r * 0.05, r * 0.78), width: r * 1.3, height: r * 0.6);
    canvas.drawOval(caustic, Paint()
      ..shader = RadialGradient(colors: [Color.lerp(base, Colors.white, 0.6)!.withOpacity(0.6 * k), Colors.transparent]).createShader(caustic)
      ..blendMode = BlendMode.screen);
    canvas.restore();
    // 球緣：左上亮、右下淡的細光邊
    canvas.drawCircle(c, r - 0.5, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.0, r * 0.05)
      ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.85 * k), Colors.white.withOpacity(0.15 * k), Colors.white.withOpacity(0.5 * k)]).createShader(sphere));
    canvas.drawOval(Rect.fromCenter(center: c + Offset(-r * 0.5, -r * 0.42), width: r * 0.26, height: r * 0.16),
        Paint()..color = Colors.white.withOpacity(0.9 * k)..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.03));

    ring(false);
    if (style == 'startrail') _starTrail(canvas, c, r, base, back: false);
    if (style == 'pair') _pair(canvas, c, r, back: false);
    if (style == 'passport') _passport(canvas, c, r, back: false);
    if (style == 'valentine') _valentine(canvas, size, c, r, back: false);
    if (style == 'sakura') _sakura(canvas, size, c, r);
    if (bouquet) _petals(canvas, c, r);
    if (style == 'xmas') _xmas(canvas, size, c, r);
    if (style == 'newyear') _newYear(canvas, size, c, r);
  }

  @override
  bool shouldRepaint(QuantumOrbPainter old) =>
      old.style != style || old.color != color || old.glow != glow || old.dim != dim || old.spin != spin || old.t != t || old.bloom != bloom || old.front != front || old.photo != photo || old.stars != stars || old.rings != rings || old.bouquet != bouquet;
}

// ---------- 艾婭的造型 ----------

/// 艾婭的造型：auto（艾婭之友是星光，否則原本）、none、starlight、aiya_xmas、aiya_newyear
class AiyaSkinPrefs {
  AiyaSkinPrefs._();
  static const _key = 'aiya_skin';
  static final selected = ValueNotifier<String>('auto');
  static Future<void> load() async {
    try { selected.value = (await SharedPreferences.getInstance()).getString(_key) ?? 'auto'; } catch (_) {}
  }
  static Future<void> set(String v) async {
    selected.value = v;
    try { await (await SharedPreferences.getInstance()).setString(_key, v); } catch (_) {}
  }

  /// 實際要顯示的造型（買過、或艾婭之友才有星光）
  static String effective({required bool friend, required Set<String> owned}) {
    final v = selected.value;
    if (aiyaSkins.contains(v) && owned.contains(v)) return v;
    if (v == 'starlight' && friend) return 'starlight';
    if (v == 'auto' && friend) return 'starlight';
    return 'none';
  }
}

// ---------- 選擇的款式 ----------

class OrbPrefs {
  OrbPrefs._();
  static const _key = 'quantum_orb';
  static final style = ValueNotifier<String>(orbDefaultStyle);

  static Future<void> load() async => style.value = orbStyleOf((await SharedPreferences.getInstance()).getString(_key));

  static Future<void> set(String s) async {
    style.value = orbStyleOf(s);
    (await SharedPreferences.getInstance()).setString(_key, style.value);
  }
}

// ---------- 內購 ----------

/// 特殊款的購買：向商店付款 → 交給伺服器驗證 → 伺服器記到帳號上 → 才通知商店交易完成
class OrbStore {
  OrbStore._();

  static final owned = ValueNotifier<Set<String>>(const {});
  static final products = ValueNotifier<Map<String, ProductDetails>>(const {});
  static final busy = ValueNotifier<bool>(false);
  /// 購買結果的提示文字（面板顯示一次後清掉）
  static final notice = ValueNotifier<String?>(null);

  static StreamSubscription<List<PurchaseDetails>>? _sub;
  /// 啟動時的背景補送：只補驗證沒完成的交易，不顯示提示
  static bool _silent = false;

  /// App 啟動時呼叫一次：開始聽購買結果（包含上次沒完成的交易）
  static void init() {
    if (_sub != null) return;
    _sub = InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (_) => busy.value = false);
    // iOS 會自己重送沒完成的交易；Android 不會，3 天內沒確認就自動退款，所以啟動時主動查一次
    if (Platform.isAndroid) {
      _silent = true;
      InAppPurchase.instance.restorePurchases().catchError((_) {});
      Future.delayed(const Duration(seconds: 15), () => _silent = false);
    }
  }

  /// 讀自己買過的款式；選了沒買過的特殊款（例如換了帳號）就回到基本款
  static Future<void> loadOwned() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final snap = await FirebaseDatabase.instance.ref('orbOwned/$uid').get();
      final value = snap.value;
      owned.value = value is Map ? {for (final k in value.keys) '$k'} : const {};
    } catch (_) {}
    if (!orbIsFree(OrbPrefs.style.value) && !owned.value.contains(OrbPrefs.style.value)) await OrbPrefs.set(orbDefaultStyle);
  }

  /// 打開面板時查價格（當地貨幣，由商店決定）
  static Future<void> loadProducts() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) return;
      final response = await InAppPurchase.instance.queryProductDetails(orbProducts.values.toSet());
      products.value = {for (final p in response.productDetails) p.id: p};
    } catch (_) {}
  }

  static Future<void> buy(String style) async {
    _silent = false;
    final product = products.value[orbProducts[style]];
    if (product == null) { notice.value = tr.orbStoreUnavailable; return; }
    busy.value = true;
    try {
      final started = await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.orbPurchaseFailed;
    }
  }

  static Future<void> restore() async {
    _silent = false;
    busy.value = true;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (_) {
      notice.value = tr.orbPurchaseFailed;
    }
    // 沒有可恢復的購買時商店不會回傳任何東西：稍後重新讀一次擁有的款式就結束
    Future.delayed(const Duration(seconds: 4), () async {
      await loadOwned();
      busy.value = false;
    });
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    if (_silent) return _verifyPending(list);
    final toVerify = <PurchaseDetails>[];
    for (final p in list) {
      // 同一個購買串流也會收到艾婭時光包，那些交給 AiyaStore 處理
      if (!orbProducts.containsValue(p.productID)) continue;
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled:
          busy.value = false;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.error:
          busy.value = false;
          notice.value = tr.orbPurchaseFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          if (orbProducts.containsValue(p.productID)) toVerify.add(p);
      }
    }
    if (toVerify.isEmpty) return;
    final (granted, owner) = await _verify(toVerify);
    // 伺服器確認過（或這筆已經屬於別的帳號、不必再試）才結束交易；連不上時留著，下次啟動會再送一次
    for (final p in toVerify) {
      final style = orbProducts.entries.firstWhere((e) => e.value == p.productID).key;
      if ((granted.contains(style) || owner.contains(p.productID)) && p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
    }
    busy.value = false;
    if (granted.isNotEmpty) {
      notice.value = tr.orbPurchased(orbStyleName(granted.first));
      // 剛買的款式直接換上
      if (toVerify.any((p) => p.status == PurchaseStatus.purchased)) {
        if (orbStyles.contains(granted.first)) await OrbPrefs.set(granted.first);
        if (aiyaSkins.contains(granted.first)) AiyaSkinPrefs.set(granted.first);
      }
    } else if (owner.isNotEmpty) {
      notice.value = tr.orbOwnedElsewhere;
    } else {
      notice.value = tr.orbPurchaseFailed;
    }
  }

  /// 背景補送：伺服器確認過才結束交易，已經確認過的不再送
  static Future<void> _verifyPending(List<PurchaseDetails> list) async {
    final pending = [for (final p in list) if (p.pendingCompletePurchase && orbProducts.containsValue(p.productID) && (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)) p];
    if (pending.isEmpty) return;
    final (granted, owner) = await _verify(pending);
    for (final p in pending) {
      final style = orbProducts.entries.firstWhere((e) => e.value == p.productID).key;
      if (granted.contains(style) || owner.contains(p.productID)) await InAppPurchase.instance.completePurchase(p);
    }
  }

  /// 回傳 (伺服器確認的款式, 已經屬於別的帳號的商品)
  static Future<(Set<String>, Set<String>)> _verify(List<PurchaseDetails> list) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final purchases = [
        for (final p in list)
          Platform.isIOS
              ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
              : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
      ];
      final response = await http.post(Uri.parse(_orbsUrl),
          headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
          body: jsonEncode({'action': 'verify', 'purchases': purchases}));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['owned'] is List) owned.value = {for (final s in data['owned'] as List) '$s'};
      final failed = (data['failed'] as List? ?? const []).whereType<Map>();
      return (
        {for (final s in data['granted'] as List? ?? const []) '$s'},
        {for (final f in failed) if (f['code'] == 'owned_elsewhere') '${f['productId']}'},
      );
    } catch (_) {
      return (<String>{}, <String>{});
    }
  }
}

// ---------- 面板 ----------

/// 量子化身面板：預覽每一款（用自己現在的心情色），免費款直接換，特殊款購買
Future<void> showOrbSheet(BuildContext context, {required Color moodColor, String avatarUrl = ''}) {
  OrbStore.loadProducts();
  OrbStore.loadOwned();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true, // 款式多、比螢幕高時，面板不能蓋到狀態列
    builder: (sheetContext) => _OrbSheet(moodColor: moodColor, image: orbImage(avatarUrl)),
  );
}

class _OrbSheet extends StatefulWidget {
  final Color moodColor;
  final ImageProvider? image;
  const _OrbSheet({required this.moodColor, this.image});
  @override
  State<_OrbSheet> createState() => _OrbSheetState();
}

class _OrbSheetState extends State<_OrbSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  String? _notice; // 購買結果：顯示在面板裡（SnackBar 會被面板蓋住）
  Timer? _noticeTimer;

  @override
  void initState() {
    super.initState();
    OrbStore.notice.addListener(_showNotice);
  }

  @override
  void dispose() {
    OrbStore.notice.removeListener(_showNotice);
    _noticeTimer?.cancel();
    _breath.dispose();
    super.dispose();
  }

  void _showNotice() {
    final text = OrbStore.notice.value;
    if (text == null || !mounted) return;
    OrbStore.notice.value = null;
    setState(() => _notice = text);
    _noticeTimer?.cancel();
    _noticeTimer = Timer(const Duration(seconds: 5), () { if (mounted) setState(() => _notice = null); });
  }

  Widget _tile(String style, String selected, Set<String> owned, Map<String, ProductDetails> products, bool busy) {
    final free = orbIsFree(style);
    final has = free || owned.contains(style);
    final isSelected = selected == style;
    final price = products[orbProducts[style]]?.price;
    final limited = orbIsLimited(style);
    return GestureDetector(
      onTap: busy ? null : () => has ? OrbPrefs.set(style) : OrbStore.buy(style),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: Night.space3, horizontal: Night.space2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x332A2F6A) : Night.night700.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Night.auroraViolet : Night.glassLine, width: isSelected ? 1.6 : 1),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedBuilder(
            animation: Listenable.merge([_breath, OrbGrowth.mine]),
            builder: (context, _) => QuantumOrb(style: style, color: widget.moodColor, size: 84, glow: _breath.value, image: widget.image,
                stars: OrbGrowth.mine.value.stars, rings: OrbGrowth.mine.value.rings),
          ),
          const SizedBox(height: Night.space2),
          Text(orbStyleName(style), style: const TextStyle(color: Night.ink, fontSize: 14)),
          // 會長大的光球：顯示自己已經累積了多少（還沒買也一直在累積）
          if (orbGrowingStyles.contains(style)) ...[
            const SizedBox(height: 2),
            FittedBox(fit: BoxFit.scaleDown, child: Text(
              style == 'startrail' ? tr.orbGrowStars(OrbGrowth.mine.value.stars) : tr.orbGrowRings(OrbGrowth.mine.value.rings),
              maxLines: 1, style: Night.caption.copyWith(color: const Color(0xFFFFD166), fontSize: 11))),
          ],
          if (limited) ...[
            const SizedBox(height: 2),
            FittedBox(fit: BoxFit.scaleDown, child: Text(has ? tr.orbLimited : tr.orbLimitedUntil(orbUntilLabel(style)), maxLines: 1, style: Night.caption.copyWith(color: const Color(0xFFFFD166), fontSize: 11))),
          ],
          const SizedBox(height: 2),
          Text(
            isSelected ? tr.orbInUse : (free ? tr.orbFree : (has ? tr.orbOwned : (price ?? '—'))),
            style: Night.caption.copyWith(color: isSelected ? Night.auroraViolet : (has ? Night.inkMuted : Night.knockPink)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(Night.space3),
        // 面板疊在量子世界設定上面：先墊一層實心底色，後面的文字才不會透出來
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
          // 款式越來越多：整個面板可以捲動，說明文字不會跑到面板外面
          child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SheetTitle(tr.orbTitle, closeTooltip: tr.close),
            const SizedBox(height: Night.space1),
            Text(tr.orbSubtitle, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space4),
            AnimatedBuilder(
              animation: Listenable.merge([OrbPrefs.style, OrbStore.owned, OrbStore.products, OrbStore.busy]),
              // 一排三格；限定款過了販售期、又沒買過的就不顯示
              builder: (context, _) => LayoutBuilder(builder: (context, box) {
                final owned = OrbStore.owned.value;
                final shown = [for (final s in orbStyles) if ((!orbIsLimited(s) || owned.contains(s) || orbOnSale(s)) && (!orbGrantedStyles.contains(s) || owned.contains(s))) s];
                final w = (box.maxWidth - Night.space2 * 2) / 3;
                return Wrap(spacing: Night.space2, runSpacing: Night.space2, children: [
                  for (final style in shown)
                    SizedBox(width: w, child: _tile(style, OrbPrefs.style.value, owned, OrbStore.products.value, OrbStore.busy.value)),
                ]);
              }),
            ),
            if (_notice case final notice?) ...[
              const SizedBox(height: Night.space3),
              Text(notice, style: const TextStyle(color: Night.knockPink, fontSize: 14), textAlign: TextAlign.center),
            ],
            const SizedBox(height: Night.space3),
            Text(tr.orbCosmeticNote, style: Night.caption, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            Text(tr.orbGrowNote, style: Night.caption.copyWith(fontSize: 11), textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            ValueListenableBuilder<bool>(
              valueListenable: OrbStore.busy,
              builder: (context, busy, _) => busy
                  ? const Center(child: Padding(padding: EdgeInsets.all(Night.space2), child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Night.auroraViolet))))
                  : TextButton(onPressed: OrbStore.restore, style: TextButton.styleFrom(foregroundColor: Night.inkMuted, minimumSize: const Size(44, 44)), child: Text(tr.orbRestore)),
            ),
          ]),
          ),
          ),
        ),
      ),
    );
  }
}
