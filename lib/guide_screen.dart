import 'package:flutter/material.dart';

import 'ui/night.dart';

/// 使用說明：設定 › 關於 › 使用說明。內容與 App 的實際規則一致，規則改了這裡也要改。
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static const _sections = <(IconData, String, List<String>)>[
    (Icons.edit_outlined, '走進城市', [
      '寫下一句此刻的心情（最多 20 個字），按「走進城市低語」。',
      '不需要手機號碼、Email 或真名。城市稱呼與大頭貼都是選填，之後可以在底部選單點自己的頭像修改。',
      '心情的顏色由字裡的關鍵字決定，例如「開心」是金黃、「平靜」是綠、「難過」是藍。',
    ]),
    (Icons.radar, '雷達與氣泡', [
      '雷達上會浮現 5 公里內其他人的心情氣泡，只顯示分級的距離（例如「100m 內」）。',
      '氣泡會呼吸代表對方正在使用；變暗並標示「休息中」代表對方鎖了螢幕；灰色、沒有名字的是「歷史殘影」，是剛離開的人留下的，會慢慢淡去。',
      '雙指可以放大縮小地圖、轉動方向。',
      '氣泡太密集時會合成一顆光球「這裡有 N 個心情」，點一下就展開成一圈，每顆都點得到；點空白處收起。',
      '名字前有「示範」的是示範對象，由程式自動回應，可以用來體驗所有功能。',
    ]),
    (Icons.back_hand_outlined, '敲門與聊天', [
      '長按別人的氣泡 →「敲門」。對方有 5 分鐘可以回應：同意、婉拒或略過。',
      '對方同意後開始對話，倒數 10 分鐘；任何一方傳新訊息就重新倒數，安靜下來就結束。',
      '對話結束後，訊息會從伺服器刪除。',
    ]),
    (Icons.auto_awesome, '微光', [
      '雙擊別人的氣泡，送出一道微光，讓對方知道有人看見了，不需要開口。',
      '對方只會看到「今晚 N 道微光與你共鳴」，永遠不知道是誰送的。同一個人 24 小時內只能送一次。',
    ]),
    (Icons.mail_outline, '低語', [
      '按底部選單的筆記圖示，在你所在的地方留下一句話（最多 60 個字）。',
      '接下來 7 天，經過那一帶 300 公尺內的人會在雷達上看到信封，打開就能讀到。',
      '低語永遠匿名；每人同時最多留 3 則，可以隨時收回。',
    ]),
    (Icons.wb_twilight, '城市心情天氣', [
      '左上角的標籤顯示 20 公里內、24 小時內大家最多的心情；點一下看完整比例。',
      '少於 10 人時不顯示比例，避免猜得出是誰。',
    ]),
    (Icons.campaign_outlined, '集會', [
      '開活動：設定 → 集會主持人 → 填活動名稱、一個表情符號當圖標、開始與結束時間（最長 24 小時）→ 開始活動。',
      '範圍是以主持人為中心 5 公里，主持人走到哪，範圍就跟到哪。主持人在雷達上有一圈光環和「主持」標示。',
      '參加：把活動的圖標加進你的城市稱呼（例如「遊蕩的貓🌈」），人在範圍內就會看到雷達上方的置頂公告，並收到推播。把圖標移除就退出。',
      '全場提問：主持人可以問一個問題，大家用一句心情回答；主持人只看得到全場的心情比例，看不到誰回答了什麼。',
      '同一個圖標在同一區域同時只能有一場活動；活動結束後，任何人都可以用。',
    ]),
    (Icons.ios_share, '心情卡與心情軌跡', [
      '底部選單的分享鈕可以把此刻的心情做成一張夜景卡片，適合 IG 限時動態；卡片上不會有你的位置。',
      '設定 →「我的心情軌跡」可以回顧你寫過的心情與地點，資料只存在你的手機上。',
    ]),
    (Icons.flag_outlined, '檢舉與封鎖', [
      '長按氣泡、敲門卡片、聊天室右上角、低語與集會公告都可以檢舉。我們會在 24 小時內處理。',
      '封鎖後，雙方會從彼此的雷達上消失，也不能再敲門或送微光。設定 →「管理封鎖名單」可以解除。',
      '遇到立即的危險，請直接撥打 110。',
    ]),
    (Icons.lock_outline, '隱私', [
      '帳號是匿名的。附近的人看得到你的心情、城市稱呼、大頭貼與大概的距離。',
      '只有在你使用 App 時才會取得位置。',
      '設定 →「刪除帳號與資料」可以隨時永久刪除你在城市留下的一切。',
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
        title: const Text('使用說明', style: TextStyle(color: Night.ink, fontSize: 17, fontWeight: FontWeight.w500, letterSpacing: 1)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Night.space4, Night.space2, Night.space4, Night.space8),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: Night.space4),
            child: Text('城市低語是一座夜裡的城市：寫下一句此刻的心情，看見附近的人此刻的感受。', style: Night.body),
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
