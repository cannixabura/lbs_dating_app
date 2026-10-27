import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 操作說明：設定 › 關於 › 操作說明。內容與 App 的實際規則一致，規則改了這裡也要改。
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  // 每一節的文字在 lib/l10n/app_*.arb 的 guideS<節>Title、guideS<節>L<句>；官網 tool/build_guide_page.py 也讀同一份
  static List<(IconData, String, List<String>)> get _sections => [
    (Icons.edit_outlined, tr.guideS1Title, [
      tr.guideS1L1,
      tr.guideS1L2,
      tr.guideS1L3,
      tr.guideS1L4,
    ]),
    (Icons.space_dashboard_outlined, tr.guideS2Title, [
      tr.guideS2L1,
      tr.guideS2L2,
      tr.guideS2L3,
      tr.guideS2L4,
    ]),
    (Icons.radar, tr.guideS3Title, [
      tr.guideS3L1,
      tr.guideS3L2,
      tr.guideS3L3,
      tr.guideS3L4,
      tr.guideS3L5,
      tr.guideS3L6,
    ]),
    (Icons.back_hand_outlined, tr.guideS4Title, [
      tr.guideS4L1,
      tr.guideS4L2,
      tr.guideS4L3,
      tr.guideS4L4,
    ]),
    (Icons.auto_awesome, tr.guideS5Title, [
      tr.guideS5L1,
      tr.guideS5L2,
    ]),
    (Icons.mail_outline, tr.guideS6Title, [
      tr.guideS6L1,
      tr.guideS6L2,
      tr.guideS6L3,
      tr.guideS6L4,
    ]),
    (Icons.wb_twilight, tr.guideS7Title, [
      tr.guideS7L1,
      tr.guideS7L2,
    ]),
    (Icons.campaign_outlined, tr.guideS8Title, [
      tr.guideS8L1,
      tr.guideS8L2,
      tr.guideS8L3,
      tr.guideS8L4,
      tr.guideS8L5,
      tr.guideS8L6,
      tr.guideS8L7,
    ]),
    (Icons.wc, tr.guideS9Title, [
      tr.guideS9L1,
      tr.guideS9L2,
      tr.guideS9L3,
      tr.guideS9L4,
    ]),
    (Icons.ios_share, tr.guideS10Title, [
      tr.guideS10L1,
      tr.guideS10L2,
    ]),
    (Icons.tune, tr.guideS11Title, [
      tr.guideS11L1,
      tr.guideS11L2,
      tr.guideS11L3,
    ]),
    (Icons.flag_outlined, tr.guideS12Title, [
      tr.guideS12L1,
      tr.guideS12L2,
      tr.guideS12L3,
      tr.guideS12L4,
    ]),
    (Icons.lock_outline, tr.guideS13Title, [
      tr.guideS13L1,
      tr.guideS13L2,
      tr.guideS13L3,
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Night.night900,
      appBar: AppBar(
        backgroundColor: Night.night900,
        foregroundColor: Night.ink,
        elevation: 0,
        title: Text(tr.guide, style: TextStyle(color: Night.ink, fontSize: 17, fontWeight: FontWeight.w500, letterSpacing: 1)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Night.space4, Night.space2, Night.space4, Night.space8),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Night.space4),
            child: Text(tr.guideIntro, style: Night.body),
          ),
          for (final (icon, title, lines) in _sections)
            Padding(
              padding: const EdgeInsets.only(bottom: Night.space3),
              child: _GuideSection(icon: icon, title: title, lines: lines),
            ),
        ],
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  const _GuideSection({required this.icon, required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Night.night800,
        borderRadius: BorderRadius.circular(Night.radiusMd),
        border: Border.all(color: Night.night600),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Night.auroraViolet),
          title: Text(title, style: const TextStyle(color: Night.ink, fontSize: 16, fontWeight: FontWeight.w500)),
          iconColor: Night.inkMuted,
          collapsedIconColor: Night.inkFaint,
          childrenPadding: const EdgeInsets.fromLTRB(Night.space4, 0, Night.space4, Night.space4),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: Night.space2),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 9, right: Night.space2),
                    child: SizedBox(width: 5, height: 5, child: DecoratedBox(decoration: BoxDecoration(color: Night.auroraBlue, shape: BoxShape.circle))),
                  ),
                  Expanded(child: Text(line, style: Night.body)),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
