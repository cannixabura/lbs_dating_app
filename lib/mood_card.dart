import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'ui/night.dart';

/// 心情卡與邀請卡：每次隨機一張夜景插畫，可以按「換一張」。
/// 分享出去的連結都指向落地頁，?ref= 讓落地頁顯示對應的歡迎詞。
const _landingUrl = 'https://mood-whisper-f7de9.web.app/';

/// 沒有文字的夜景：心情卡的背景，上方深色的夜空留給心情文字
const _scenes = [
  'assets/cards/scene_01.webp', 'assets/cards/scene_02.webp', 'assets/cards/scene_03.webp', 'assets/cards/scene_04.webp',
  'assets/cards/scene_05.webp', 'assets/cards/scene_06.webp', 'assets/cards/scene_07.webp', 'assets/cards/scene_08.webp',
  'assets/cards/scene_09.webp', 'assets/cards/scene_10.webp', 'assets/cards/scene_12.webp',
];

/// 邀請卡：八張功能海報（圖上已經有標題），加上兩張夜景配「一起來點亮我們的街區」
const _invites = <(String, bool)>[
  ('assets/cards/poster_01.webp', true), ('assets/cards/poster_02.webp', true), ('assets/cards/poster_03.webp', true),
  ('assets/cards/poster_04.webp', true), ('assets/cards/poster_05.webp', true), ('assets/cards/poster_06.webp', true),
  ('assets/cards/poster_07.webp', true), ('assets/cards/poster_08.webp', true),
  ('assets/cards/scene_01.webp', false), ('assets/cards/scene_02.webp', false),
];

/// 邀請文案：每次隨機一則，結尾都附上邀請連結
const _inviteTexts = [
  '我在城市低語點亮了一道光。附近的人越多，街區就越亮，一起來點亮我們的街區吧：',
  '今晚的城市有點安靜。來城市低語寫下一句心情，讓我們的街區亮起來：',
  '不用加好友、不用真名，只要一句此刻的心情。來城市低語找我：',
  '我在城市低語留了一盞燈給你。打開 App，看看今晚附近的人都在想什麼：',
  '每週五晚上九點是城市低語的點亮之夜，一起上線，讓雷達亮成一片吧：',
  '想找個地方說說今天的心情嗎？城市低語是匿名的，說完就消散：',
  '走在路上的時候，你會好奇擦肩而過的人在想什麼嗎？來城市低語看看：',
  '我在這條街留下了一則低語，經過的人才讀得到。你也來留一則吧：',
  '城市低語是一張夜裡的心情地圖。人越多越好玩，來幫我們的街區多點一道光：',
  '今晚的你，心情是什麼顏色？來城市低語寫下來，我在附近等你的光：',
];

/// 邀請朋友「點亮你的街區」：選好一張邀請卡後只傳文字與連結。
/// LINE、Messenger 收到「圖片＋文字」時會丟掉文字，所以改用每張卡專屬的網址
/// （hosting/i/1.html…10.html），預覽圖就是那張卡，點了直接到官網。
Future<void> shareInvite(BuildContext context) {
  final random = Random();
  final text = _inviteTexts[random.nextInt(_inviteTexts.length)];
  return _showShareCard(
    context,
    random: random,
    count: _invites.length,
    image: (i) => _invites[i].$1,
    shareLabel: '分享邀請',
    fileName: 'city_whisper_invite',
    build: (i) => ShareCard(image: _invites[i].$1, poster: _invites[i].$2, accent: Night.auroraBlue, at: DateTime.now(), kind: ShareCardKind.invite),
    shareText: (i) => '$text\n${_landingUrl}i/${i + 1}.html',
    asLink: true,
    subject: '一起來點亮我們的街區',
  );
}

/// 開啟心情卡預覽，按「分享」時輸出 1080×1920 圖片（IG 限時動態比例）
Future<void> showMoodCard(BuildContext context, {required String mood, required Color moodColor}) {
  return _showShareCard(
    context,
    random: Random(),
    count: _scenes.length,
    image: (i) => _scenes[i],
    shareLabel: '分享心情卡',
    fileName: 'city_whisper_mood',
    build: (i) => ShareCard(image: _scenes[i], accent: moodColor, at: DateTime.now(), mood: mood),
    shareText: (_) => '我在城市低語留下了此刻的心情：「$mood」\n今晚，你的心情也在城市裡發光嗎？$_landingUrl?ref=card',
    // LINE、Messenger 收到圖片時會丟掉文字：另外提供只傳文字與連結，預覽圖是這張插畫（hosting/m/<插畫編號>.html）
    linkText: (i) => '我在城市低語留下了此刻的心情：「$mood」\n今晚，你的心情也在城市裡發光嗎？\n${_landingUrl}m/${_sceneNumber(_scenes[i])}.html',
  );
}

Future<void> _showShareCard(
  BuildContext context, {
  required Random random,
  required int count,
  required String Function(int index) image,
  required String shareLabel,
  required String fileName,
  required Widget Function(int index) build,
  required String Function(int index) shareText,
  bool asLink = false,
  String Function(int index)? linkText,
  String? subject,
}) {
  final boundaryKey = GlobalKey();
  bool sharing = false;
  int index = random.nextInt(count);
  return showDialog(
    context: context,
    barrierColor: const Color(0xCC070B1F),
    builder: (dialogContext) => StatefulBuilder(builder: (dialogContext, setState) {
      Future<void> share({bool link = false}) async {
        setState(() => sharing = true);
        try {
          if (asLink || link) {
            final text = link ? linkText!(index) : shareText(index);
            await SharePlus.instance.share(ShareParams(text: text, subject: subject, sharePositionOrigin: _shareOrigin(dialogContext)));
            return;
          }
          // 圖還沒解碼完就截圖會是一片黑，先確定載入好
          await precacheImage(AssetImage(image(index)), dialogContext);
          await WidgetsBinding.instance.endOfFrame;
          final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
          // 卡片以 360×640 繪製，3 倍輸出成 1080×1920
          final ui.Image shot = await boundary.toImage(pixelRatio: 3);
          final bytes = (await shot.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/${fileName}_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(bytes);
          if (!dialogContext.mounted) return;
          await SharePlus.instance.share(ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            text: shareText(index),
            subject: subject,
            sharePositionOrigin: _shareOrigin(dialogContext),
          ));
        } catch (e) {
          debugPrint('share card failed: $e');
          if (dialogContext.mounted) showGlassToast(dialogContext, '沒有分享出去，請再試一次。', icon: Icons.error_outline, danger: true);
        } finally {
          if (dialogContext.mounted) setState(() => sharing = false);
        }
      }

      void next() {
        final n = random.nextInt(count - 1);
        setState(() => index = n >= index ? n + 1 : n);
      }

      final maxH = MediaQuery.of(dialogContext).size.height * 0.62;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(Night.space6),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: FittedBox(
              child: RepaintBoundary(key: boundaryKey, child: build(index)),
            ),
          ),
          const SizedBox(height: Night.space2),
          TextButton.icon(
            onPressed: sharing ? null : next,
            icon: const Icon(Icons.shuffle, size: 18, color: Night.inkMuted),
            label: Text('換一張 · ${index + 1} / $count', style: const TextStyle(color: Night.inkMuted, fontSize: 14, letterSpacing: 1)),
          ),
          const SizedBox(height: Night.space2),
          Row(mainAxisSize: MainAxisSize.min, children: [
            NightButton('關閉', kind: NightButtonKind.ghost, onPressed: sharing ? null : () => Navigator.pop(dialogContext)),
            const SizedBox(width: Night.space3),
            NightButton(sharing ? '準備中…' : shareLabel, icon: Icons.ios_share, onPressed: sharing ? null : share),
          ]),
          if (linkText != null)
            TextButton.icon(
              onPressed: sharing ? null : () => share(link: true),
              icon: const Icon(Icons.link, size: 18, color: Night.inkMuted),
              label: const Text('傳連結給朋友（LINE、Messenger）', style: TextStyle(color: Night.inkMuted, fontSize: 13, letterSpacing: 0.5)),
            ),
        ]),
      );
    }),
  );
}

/// 'assets/cards/scene_07.webp' → 7，對應 hosting/m/7.html
int _sceneNumber(String asset) => int.parse(RegExp(r'scene_(\d+)').firstMatch(asset)!.group(1)!);

Rect? _shareOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  return box == null ? null : box.localToGlobal(Offset.zero) & box.size;
}

String _partOfDay(DateTime t) {
  final h = t.hour;
  if (h < 5) return '深夜';
  if (h < 11) return '早晨';
  if (h < 17) return '午後';
  if (h < 19) return '黃昏';
  return '夜晚';
}

enum ShareCardKind { mood, invite }

/// 分享卡本體（360×640 邏輯尺寸）：夜景插畫為底，上方文字，下方品牌。不放任何位置資訊。
/// poster 為 true 時插畫本身已有標題，只加上品牌與網址。
class ShareCard extends StatelessWidget {
  final String image;
  final bool poster;
  final Color accent;
  final DateTime at;
  final ShareCardKind kind;
  final String mood;
  const ShareCard({super.key, required this.image, required this.accent, required this.at, this.poster = false, this.kind = ShareCardKind.mood, this.mood = ''});

  @override
  Widget build(BuildContext context) {
    final date = '${at.year}.${at.month.toString().padLeft(2, '0')}.${at.day.toString().padLeft(2, '0')}';
    final invite = kind == ShareCardKind.invite;
    return SizedBox(
      width: 360,
      height: 640,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          const Positioned.fill(child: ColoredBox(color: Night.night900)),
          Positioned.fill(child: Image.asset(image, fit: BoxFit.cover, gaplessPlayback: true)),
          // 上方：夜空再壓暗一點，任何插畫上的文字都讀得清楚（海報自己有標題，不需要）
          if (!poster)
            const Positioned(
              left: 0, right: 0, top: 0, height: 300,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC070B1F), Color(0x80070B1F), Color(0x00070B1F)], stops: [0.0, 0.6, 1.0]),
                ),
              ),
            ),
          // 下方：品牌列後面的暗帶
          const Positioned(
            left: 0, right: 0, bottom: 0, height: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xD9070B1F), Color(0x00070B1F)]),
              ),
            ),
          ),
          if (!poster)
            Positioned(
              left: 28, right: 28, top: 52,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(invite ? '邀請你' : '此刻的心情', style: TextStyle(color: accent, fontSize: 13, letterSpacing: 3, fontWeight: FontWeight.w500,
                    shadows: const [Shadow(color: Night.night900, blurRadius: 6)])),
                const SizedBox(height: 12),
                Text(
                  invite ? '一起來點亮\n我們的街區' : mood,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Night.ink, fontSize: 30, height: 1.4, fontWeight: FontWeight.w600, letterSpacing: 1,
                    shadows: [Shadow(color: accent.withOpacity(0.75), blurRadius: 24), const Shadow(color: Night.night900, blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 16),
                Container(width: 72, height: 2, decoration: BoxDecoration(color: accent, boxShadow: [BoxShadow(color: accent, blurRadius: 8)])),
                const SizedBox(height: 12),
                Text(
                  invite ? '我在城市低語點亮了一道光。\n附近的人越多，街區就越亮。' : '$date · ${_partOfDay(at)}\n在城市的某個角落',
                  style: const TextStyle(color: Night.ink, fontSize: 13, height: 1.7, letterSpacing: 1, shadows: [Shadow(color: Night.night900, blurRadius: 6)]),
                ),
              ]),
            ),
          Positioned(
            left: 24, right: 24, bottom: 22,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ShaderMask(
                shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                child: const Text('城市低語', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 3)),
              ),
              const Spacer(),
              const Text('mood-whisper-f7de9.web.app', style: TextStyle(color: Night.ink, fontSize: 10, letterSpacing: 0.5,
                  shadows: [Shadow(color: Night.night900, blurRadius: 6)])),
            ]),
          ),
        ]),
      ),
    );
  }
}
