import 'l10n/l10n.dart';
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
List<String> get _inviteTexts => [
  tr.invite1,
  tr.invite2,
  tr.invite3,
  tr.invite4,
  tr.invite5,
  tr.invite6,
  tr.invite7,
  tr.invite8,
  tr.invite9,
  tr.invite10,
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
    shareLabel: tr.shareInvite,
    fileName: 'city_whisper_invite',
    build: (i) => ShareCard(image: _invites[i].$1, poster: _invites[i].$2, accent: Night.auroraBlue, at: DateTime.now(), kind: ShareCardKind.invite),
    shareText: (i) => '$text\n${_landingUrl}i/${i + 1}.html',
    asLink: true,
    subject: tr.inviteSubject,
  );
}

/// 開啟心情卡預覽，按「分享」時輸出 1080×1920 圖片（IG 限時動態比例）
Future<void> showMoodCard(BuildContext context, {required String mood, required Color moodColor}) {
  return _showShareCard(
    context,
    random: Random(),
    count: _scenes.length,
    image: (i) => _scenes[i],
    shareLabel: tr.shareMoodCardButton,
    fileName: 'city_whisper_mood',
    build: (i) => ShareCard(image: _scenes[i], accent: moodColor, at: DateTime.now(), mood: mood),
    shareText: (_) => '${tr.moodShareText(mood)}$_landingUrl?ref=card',
    // LINE、Messenger 收到圖片時會丟掉文字：另外提供只傳文字與連結，預覽圖是這張插畫（hosting/m/<插畫編號>.html）
    linkText: (i) => '${tr.moodShareText(mood)}\n${_landingUrl}m/${_sceneNumber(_scenes[i])}.html',
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
          if (dialogContext.mounted) showGlassToast(dialogContext, tr.shareFailed, icon: Icons.error_outline, danger: true);
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
            label: Text(tr.shuffleCard(index + 1, count), style: const TextStyle(color: Night.inkMuted, fontSize: 14, letterSpacing: 1)),
          ),
          const SizedBox(height: Night.space2),
          Row(mainAxisSize: MainAxisSize.min, children: [
            NightButton(tr.close, kind: NightButtonKind.ghost, onPressed: sharing ? null : () => Navigator.pop(dialogContext)),
            const SizedBox(width: Night.space3),
            NightButton(sharing ? tr.preparing : shareLabel, icon: Icons.ios_share, onPressed: sharing ? null : share),
          ]),
          if (linkText != null)
            TextButton.icon(
              onPressed: sharing ? null : () => share(link: true),
              icon: const Icon(Icons.link, size: 18, color: Night.inkMuted),
              label: Text(tr.sendLinkToFriends, style: TextStyle(color: Night.inkMuted, fontSize: 13, letterSpacing: 0.5)),
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
  if (h < 5) return tr.partLateNight;
  if (h < 11) return tr.partMorning;
  if (h < 17) return tr.partAfternoon;
  if (h < 19) return tr.partDusk;
  return tr.partNight;
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
                Text(invite ? tr.cardInviteEyebrow : tr.cardMoodEyebrow, style: TextStyle(color: accent, fontSize: 13, letterSpacing: 3, fontWeight: FontWeight.w500,
                    shadows: const [Shadow(color: Night.night900, blurRadius: 6)])),
                const SizedBox(height: 12),
                Text(
                  invite ? tr.cardInviteTitle : mood,
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
                  invite ? tr.cardInviteBody : tr.cardMoodFooter(date, _partOfDay(at)),
                  style: const TextStyle(color: Night.ink, fontSize: 13, height: 1.7, letterSpacing: 1, shadows: [Shadow(color: Night.night900, blurRadius: 6)]),
                ),
              ]),
            ),
          Positioned(
            left: 24, right: 24, bottom: 22,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ShaderMask(
                shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                child: Text(tr.appName, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 3)),
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
