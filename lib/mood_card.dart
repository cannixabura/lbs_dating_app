import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'ui/night.dart';

/// 心情卡與邀請：分享出去的連結都指向落地頁，?ref= 讓落地頁顯示對應的歡迎詞。
const _landingUrl = 'https://mood-whisper-f7de9.web.app/';

/// 邀請朋友「點亮你的街區」
Future<void> shareInvite(BuildContext context) async {
  final origin = _shareOrigin(context);
  await SharePlus.instance.share(ShareParams(
    text: '我在城市低語點亮了一道光。附近的人越多，街區就越亮——一起來點亮我們的街區吧：\n$_landingUrl?ref=invite',
    subject: '一起來點亮我們的街區',
    sharePositionOrigin: origin,
  ));
}

/// 開啟心情卡預覽，按「分享」時輸出 1080×1920 圖片（IG 限時動態比例）
Future<void> showMoodCard(BuildContext context, {required String mood, required Color moodColor}) {
  final boundaryKey = GlobalKey();
  bool sharing = false;
  return showDialog(
    context: context,
    barrierColor: const Color(0xCC070B1F),
    builder: (dialogContext) => StatefulBuilder(builder: (dialogContext, setState) {
      Future<void> share() async {
        setState(() => sharing = true);
        try {
          final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
          // 卡片以 360×640 繪製，3 倍輸出成 1080×1920
          final ui.Image image = await boundary.toImage(pixelRatio: 3);
          final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/city_whisper_mood_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(bytes);
          if (!dialogContext.mounted) return;
          await SharePlus.instance.share(ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            text: '我在城市低語留下了此刻的心情：「$mood」\n今晚，你的心情也在城市裡發光嗎？$_landingUrl?ref=card',
            sharePositionOrigin: _shareOrigin(dialogContext),
          ));
        } catch (e) {
          debugPrint('mood card share failed: $e');
          if (dialogContext.mounted) showGlassToast(dialogContext, '心情卡沒有分享出去，請再試一次。', icon: Icons.error_outline, danger: true);
        } finally {
          if (dialogContext.mounted) setState(() => sharing = false);
        }
      }

      final maxH = MediaQuery.of(dialogContext).size.height * 0.62;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(Night.space6),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: FittedBox(
              child: RepaintBoundary(
                key: boundaryKey,
                child: MoodCard(mood: mood, moodColor: moodColor, at: DateTime.now()),
              ),
            ),
          ),
          const SizedBox(height: Night.space4),
          Row(mainAxisSize: MainAxisSize.min, children: [
            NightButton('關閉', kind: NightButtonKind.ghost, onPressed: sharing ? null : () => Navigator.pop(dialogContext)),
            const SizedBox(width: Night.space3),
            NightButton(sharing ? '準備中…' : '分享心情卡', icon: Icons.ios_share, onPressed: sharing ? null : share),
          ]),
        ]),
      );
    }),
  );
}

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

/// 心情卡本體（360×640 邏輯尺寸）。不放任何位置資訊。
class MoodCard extends StatelessWidget {
  final String mood;
  final Color moodColor;
  final DateTime at;
  const MoodCard({super.key, required this.mood, required this.moodColor, required this.at});

  @override
  Widget build(BuildContext context) {
    final date = '${at.year}.${at.month.toString().padLeft(2, '0')}.${at.day.toString().padLeft(2, '0')}';
    return SizedBox(
      width: 360,
      height: 640,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          const Positioned.fill(child: ColoredBox(color: Night.night900)),
          // 下半部：夜景插畫，向上淡入夜空
          Positioned(
            left: 0, right: 0, bottom: 0, height: 400,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black, Colors.black],
                stops: [0.0, 0.35, 1.0],
              ).createShader(rect),
              child: Image.asset('assets/images/intro_1.png', fit: BoxFit.cover, alignment: Alignment.bottomCenter),
            ),
          ),
          // 上半部：心情
          Positioned(
            left: 28, right: 28, top: 56,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('此刻的心情', style: TextStyle(color: moodColor, fontSize: 13, letterSpacing: 3, fontWeight: FontWeight.w500)),
              const SizedBox(height: 14),
              Text(
                mood,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Night.ink, fontSize: 30, height: 1.4, fontWeight: FontWeight.w600, letterSpacing: 1,
                  shadows: [Shadow(color: moodColor.withOpacity(0.75), blurRadius: 24)],
                ),
              ),
              const SizedBox(height: 18),
              Container(width: 72, height: 2, decoration: BoxDecoration(color: moodColor, boxShadow: [BoxShadow(color: moodColor, blurRadius: 8)])),
              const SizedBox(height: 14),
              Text('$date · ${_partOfDay(at)}\n在城市的某個角落', style: const TextStyle(color: Night.inkMuted, fontSize: 13, height: 1.7, letterSpacing: 1)),
            ]),
          ),
          // 底部：品牌
          Positioned(
            left: 28, right: 28, bottom: 28,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ShaderMask(
                shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                child: const Text('城市低語', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 3)),
              ),
              const Spacer(),
              const Text('mood-whisper-f7de9.web.app', style: TextStyle(color: Night.inkMuted, fontSize: 10, letterSpacing: 0.5,
                  shadows: [Shadow(color: Night.night900, blurRadius: 6)])),
            ]),
          ),
        ]),
      ),
    );
  }
}
