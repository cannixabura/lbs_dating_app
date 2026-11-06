// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get checkInEnter => '在這裡打卡，走進城市';

  @override
  String get checkInNote => '按下後，附近的人會看到你此刻的心情與大概的位置。每次進入都要自己打卡。';

  @override
  String get checkInTitle => '打卡，走進城市';

  @override
  String get checkInBody =>
      '打卡後，附近的人才看得到你此刻的心情與大概的位置，你也會看到他們。別人看到的是你打卡的地方，不會跟著你移動。每次打開 App 都要自己打卡，不會自動打卡。離開或切到其他 App，打卡就會結束。';

  @override
  String get checkInButton => '在這裡打卡';

  @override
  String get checkInAgain => '你離開打卡的地方了 · 在這裡重新打卡';

  @override
  String get checkOutButton => '打卡中 · 結束打卡';

  @override
  String get checkedOutToast => '已結束打卡，你已經從地圖上消失。';

  @override
  String get appName => '城市低語';

  @override
  String get moodJoy => '開心';

  @override
  String get moodSad => '難過';

  @override
  String get moodAngry => '生氣';

  @override
  String get moodCalm => '平靜';

  @override
  String get moodPassion => '熱情';

  @override
  String get moodLove => '愛';

  @override
  String get moodOther => '其他';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name 已結束';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return '你已把 $emoji $name 交棒，現在是參加者。';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return '你已交棒。稱呼已滿 10 個字，請自己把 $emoji 加進稱呼，才能繼續收到公告。';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return '你已交棒，稱呼補上了 $emoji，你現在是參加者。';
  }

  @override
  String get gotIt => '我知道了';

  @override
  String get blockedToast => '已將此人沒入黑暗。';

  @override
  String get unblockedToast => '已解除封鎖，城市再次產生交集。';

  @override
  String notificationToast(String title, String body) {
    return '$title：$body';
  }

  @override
  String get locationServiceOffTitle => '請開啟定位服務';

  @override
  String get locationServiceOffBody =>
      '城市低語需要知道你在城市的哪個角落，才能讓附近的人看見你的心情。請到手機的「設定」開啟「定位服務」。';

  @override
  String get locationReducedTitle => '請開啟「精確位置」';

  @override
  String get locationReducedBodyIos =>
      '你目前只分享了大概的位置，雷達無法判斷誰在你附近。請到「設定」›「城市低語」›「位置」，打開「精確位置」。';

  @override
  String get locationReducedBodyAndroid =>
      '你目前只分享了大概的位置，雷達無法判斷誰在你附近。請在位置權限中選擇「精確」。';

  @override
  String get locationNoFixTitle => '暫時抓不到你的位置';

  @override
  String get locationNoFixBody => '可能在室內或訊號較弱。請到窗邊或戶外、開啟 Wi-Fi 後再試一次。';

  @override
  String get locationNeededTitle => '需要使用你的位置';

  @override
  String get locationNeededBody =>
      '城市低語只在你使用 App 時取得位置，用來顯示附近 5 公里內的心情；雷達上只顯示大概的距離，不會顯示地址。\n請在設定中允許「使用 App 期間」取用位置，並開啟「精確位置」。';

  @override
  String get locationSimulatorHint => '（開發提示：模擬器請在 Features › Location 選一個位置）';

  @override
  String get openSettings => '前往設定';

  @override
  String get locationRecheck => '我已開啟，重新檢查';

  @override
  String get tryAgain => '再試一次';

  @override
  String get leaveApp => '離開';

  @override
  String whispersNearby(int count) {
    return '你附近有 $count 則低語，點信封讀讀看。';
  }

  @override
  String get whisperPassed => '你經過了一則低語，點信封讀讀看。';

  @override
  String get whisperLeft => '你的低語留在這裡了，7 天後消散。';

  @override
  String get timeWhisperSealedYear => '已封存。一年後，回到這裡就能打開。';

  @override
  String get timeWhisperSealedMonth => '已封存。一個月後，回到這裡就能打開。';

  @override
  String get whisperWithdrawn => '低語已經收回。';

  @override
  String get whisperMineLabel => '你留下的低語';

  @override
  String get whisperTapToRead => '一則低語，點一下閱讀';

  @override
  String get noMoodYet => '無言中...';

  @override
  String get knockWithdrawnByLeaving => '對方已沒入城市，悄悄收回敲門聲…';

  @override
  String get knockCardTitle => '片刻交集';

  @override
  String knockCardBody(String name) {
    return '$name 正在敲門，\n想與你產生交集…';
  }

  @override
  String get skip => '略過';

  @override
  String get decline => '婉拒';

  @override
  String get accept => '同意';

  @override
  String get reportThisPerson => '檢舉這個人';

  @override
  String get cityQuietTonight => '今晚的城市還很安靜';

  @override
  String cityMoodChip(String mood, String percent) {
    return '今晚的城市 · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text，查看城市心情天氣';
  }

  @override
  String get cityMoodTitle => '今晚的城市心情';

  @override
  String cityMoodQuietCount(int total) {
    return '城市還很安靜，今晚有 $total 個人留下心情。';
  }

  @override
  String cityMoodCount(int total) {
    return '20 公里內，今晚有 $total 個人留下心情';
  }

  @override
  String get cityMoodQuietInvite => '多一點心情，城市就多一點光。寫下此刻的你，成為點亮城市的人。';

  @override
  String get cityMoodFootnote => '匿名統計 24 小時內的心情；少於 10 人時不顯示比例。';

  @override
  String get close => '關閉';

  @override
  String get emptyRadarTitle => '你是今晚第一道光';

  @override
  String get emptyRadarBody =>
      '附近還沒有人。你的心情已經在城市裡發光，\n有人經過時，就會看見你。也可以留一則低語，給下一個經過這裡的人。';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '今晚城市裡有 $total 個人，多半感到「$mood」';
  }

  @override
  String get inviteFriends => '邀請朋友點亮街區';

  @override
  String get shareMoodCard => '分享我的心情卡';

  @override
  String get editYourMood => '編輯你的心情';

  @override
  String resonanceTonight(int count) {
    return '今晚 $count 道微光與你共鳴';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · 你的心情';
  }

  @override
  String get dockTapToEdit => '你的心情 · 點一下修改';

  @override
  String get leaveWhisper => '留下一則低語';

  @override
  String get settings => '設定';

  @override
  String get nightlyReminder => '每晚提醒';

  @override
  String get nightlyReminderSubtitle => '每晚 21:30 一則溫和的提醒';

  @override
  String get closeSettings => '關閉設定';

  @override
  String get settingsSectionMe => '我';

  @override
  String get editProfile => '編輯個人狀態';

  @override
  String get editProfileSubtitle => '大頭貼、城市稱呼與心情';

  @override
  String get manageBlockList => '管理封鎖名單';

  @override
  String get manageBlockListSubtitle => '查看或解除被你沒入黑暗的人';

  @override
  String get myTimeWhispers => '我的低語穿越';

  @override
  String get myTimeWhispersSubtitle => '寫給未來的自己，只有你看得到';

  @override
  String get myMoodTrail => '我的心情軌跡';

  @override
  String get myMoodTrailSubtitle => '只存在你的手機上';

  @override
  String get settingsSectionGatherings => '集會';

  @override
  String get gatheringHost => '集會主持人';

  @override
  String get gatheringHostSubtitle => '以你為中心 5 公里，開一場活動';

  @override
  String gatheringHosting(String emoji, String name) {
    return '你正在主持 $emoji $name';
  }

  @override
  String get settingsSectionShare => '分享';

  @override
  String get shareMoodCardSubtitle => '十一張夜景插畫隨機出現，適合 IG 限時動態';

  @override
  String get inviteFriendsSubtitle => '附近的人越多，城市越亮';

  @override
  String get settingsSectionAbout => '關於';

  @override
  String get guide => '操作說明';

  @override
  String get guideSubtitle => '從寫下心情到開一場集會，一次看懂';

  @override
  String get termsOfUse => '使用條款';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get deleteAccount => '刪除帳號與資料';

  @override
  String get deleteAccountSubtitle => '永久抹除你在城市留下的一切';

  @override
  String get avatarUploadFailed => '大頭貼上傳失敗，請稍後再試。';

  @override
  String get moodEmpty => '心情不能為空，給城市留下點微光吧。';

  @override
  String get profileSyncFailed => '狀態同步失敗，請稍後再試。';

  @override
  String get profileUpdated => '狀態已更新，城市正感知你的呼吸。';

  @override
  String get changeAvatar => '更換大頭貼';

  @override
  String get avatarHint => '輕觸更換大頭貼 · 光環是你的心情色';

  @override
  String get cityName => '城市稱呼';

  @override
  String get cityNameHint => '選填，例如：遊蕩的貓';

  @override
  String get currentMood => '當下心情';

  @override
  String get currentMoodHint => '例如：漫步在微雨中 🌿';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get blockListTitle => '沉入黑暗的名單';

  @override
  String get blockListEmpty => '夜色清朗，你的城市未曾放逐任何人。';

  @override
  String get unblock => '解除放逐';

  @override
  String get deleteAccountBody =>
      '你的位置、心情、城市稱呼、大頭貼、留下的低語、微光、封鎖名單與進行中的對話都會被永久刪除，無法復原。\n\n為了防止濫用，檢舉紀錄會依隱私權政策保留 1 年。';

  @override
  String get deleting => '刪除中…';

  @override
  String get deletePermanently => '永久刪除';

  @override
  String get deleteFailed => '刪除沒有完成，請檢查網路後再試一次。';

  @override
  String get fadingEcho => '歷史殘影';

  @override
  String clusterCount(int count) {
    return '這裡有 $count 個心情';
  }

  @override
  String clusterMore(int count) {
    return '更多\n+$count';
  }

  @override
  String get clusterBackToFirst => '回到\n第一批';

  @override
  String get fadingEchoTitle => '一道歷史殘影';

  @override
  String encounterWith(String name) {
    return '與 $name 的相遇';
  }

  @override
  String get fadingEchoBody => '這只是一道歷史殘影，無法產生交集。';

  @override
  String get demoPersonBody => '這是示範對象，由程式自動回應，不是真人。可以用它體驗敲門、聊天、微光、檢舉與封鎖。';

  @override
  String get sendGlimmer => '送出一道微光 (共鳴)';

  @override
  String get knock => '敲門 (產生交集)';

  @override
  String get blockAction => '封鎖 (沒入黑暗)';

  @override
  String get handOverHost => '轉移主持人';

  @override
  String get report => '檢舉';

  @override
  String get confirmBlockTitle => '確認封鎖';

  @override
  String confirmBlockBody(String name) {
    return '確定要將 $name 沒入黑暗嗎？\n封鎖後，雙方將從彼此的城市中消失。';
  }

  @override
  String get confirmBlock => '確定封鎖';

  @override
  String get glimmerReceived => '有人送你一道微光，與你的心情共鳴。';

  @override
  String get glimmerSent => '你送出了一道微光。';

  @override
  String get glimmerAlreadySent => '今天已經送過微光給對方了，明天再來吧。';

  @override
  String get knockSent => '敲門聲已送出，等待回音…';

  @override
  String get knockFailed => '敲門沒有送出，請稍後再試。';

  @override
  String get knockNoAnswer => '沒有回音，敲門聲悄悄消散了。';

  @override
  String get knockDeclined => '這次沒有交集，讓彼此保留一點空間。';

  @override
  String get knockSkipped => '對方先略過了，敲門聲悄悄消散。';

  @override
  String get sensingCity => '正在感知這座城市...';

  @override
  String get sensingCityHint => '如果你的城市此刻太安靜，可以走進「平行宇宙」或「量子世界」，和其他城市的人相遇。';

  @override
  String get gatheringUnavailable => '活動功能暫時無法使用，請稍後再試。';

  @override
  String get notSentCheckNetwork => '沒有送出，請檢查網路後再試一次。';

  @override
  String get justNow => '剛剛';

  @override
  String minutesAgo(int count) {
    return '$count 分鐘前';
  }

  @override
  String hoursAgo(int count) {
    return '$count 小時前';
  }

  @override
  String get nextDayPrefix => '隔天 ';

  @override
  String get gatheringNameMissing => '請幫活動取個名字。';

  @override
  String get gatheringEmojiInvalid => '活動圖標要剛好是一個表情符號。';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name 開始了。請參加的人把 $emoji 加進城市稱呼。';
  }

  @override
  String get startGatheringTitle => '開一場集會';

  @override
  String get startGatheringLead => '以你的位置為中心 5 公里。你走到哪，範圍就跟到哪。';

  @override
  String get gatheringNameHint => '活動名稱，例如：台北101跨年煙火秀';

  @override
  String get gatheringEmojiHint => '圖標';

  @override
  String get gatheringEmojiHelp => '活動圖標：一個表情符號。附近沒人在用才能選。';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return '參加的人把 $emoji 加進自己的城市稱呼，就會看到你的公告、收到推播。';
  }

  @override
  String get start => '開始';

  @override
  String get end => '結束';

  @override
  String get gatheringMaxDuration => '整場最長 24 小時，時間到自動結束。';

  @override
  String get starting => '開始中…';

  @override
  String get startGathering => '開始活動';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name 已結束，你回到了城市裡。';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · 你正在主持';
  }

  @override
  String hostAudienceRule(String emoji) {
    return '5 公里內、稱呼裡有 $emoji 的人會看到公告並收到推播。你看不到他們是誰。';
  }

  @override
  String get postAnnouncement => '發布公告';

  @override
  String get announcementHint => '例如：隊伍在忠孝東路口集合';

  @override
  String get announcementSent => '公告已送出';

  @override
  String announcementLine(String ago, String text) {
    return '$ago　$text';
  }

  @override
  String get announcementHiddenSuffix => '（已因多人檢舉隱藏）';

  @override
  String get groupQuestion => '全場提問';

  @override
  String get questionHint => '例如：此刻的你？';

  @override
  String get sendQuestion => '送出提問';

  @override
  String get questionSent => '提問已送出，大家會用心情回答';

  @override
  String get handOff => '交棒';

  @override
  String handoffPending(String name) {
    return '已邀請 $name 接下主持，等待回覆中…';
  }

  @override
  String get theOtherPerson => '對方';

  @override
  String get handoffCancelled => '已取消交棒邀請';

  @override
  String get handoffHelp => '長按雷達上參加者的氣泡 →「轉移主持人」，對方同意後就由他主持，活動與公告都不會中斷。';

  @override
  String get confirmEndAgain => '確定結束？再按一次';

  @override
  String get endGathering => '結束活動';

  @override
  String tallyHeader(String question, int total) {
    return '「$question」· $total 人回答';
  }

  @override
  String get tallyQuiet => '滿 10 人回答才顯示比例，避免人少時猜得出是誰。';

  @override
  String get bannerYouHost => '  · 你正在主持';

  @override
  String get bannerHostAnnouncement => '  · 主持人公告';

  @override
  String get manageGathering => '管理活動';

  @override
  String get reportAnnouncement => '檢舉這則公告';

  @override
  String get expandAnnouncement => '展開公告';

  @override
  String get collapseAnnouncement => '收起公告';

  @override
  String hostHandedOffAgo(String ago) {
    return '主持人已交棒 · $ago';
  }

  @override
  String get announcementReportedHidden => '你檢舉了這則公告，已從你的畫面移除。';

  @override
  String get noAnnouncementHost => '還沒有公告。按右上角的調整鈕發布第一則。';

  @override
  String get noAnnouncementGuest => '主持人還沒有發公告。';

  @override
  String hostAsks(String question) {
    return '主持人問：$question';
  }

  @override
  String get answeredNote => '已回答。主持人只會看到全場的心情比例。';

  @override
  String get answerHint => '用一句心情回答';

  @override
  String get sendAnswer => '送出回答';

  @override
  String handoffInvited(String name) {
    return '已邀請 $name 接下主持，等對方回覆（5 分鐘內有效）。';
  }

  @override
  String handoffTitle(String name) {
    return '把活動交給 $name';
  }

  @override
  String get handoffBody => '對方同意後，由他主持這場活動；名稱、公告與提問都會留著。你會變回參加者。';

  @override
  String get handoffPublic => '公開交棒';

  @override
  String get handoffPublicHelp => '通知所有參加者「主持人已交棒」';

  @override
  String get handoffQuiet => '安靜交棒';

  @override
  String get handoffQuietHelp => '不通知任何人，只有雷達上的「主持」光環換人';

  @override
  String get sending => '送出中…';

  @override
  String get sendInvite => '送出邀請';

  @override
  String youAreNowHost(String emoji, String name) {
    return '你現在是 $emoji $name 的主持人。';
  }

  @override
  String get handoffOfferTitle => '想請你接下主持';

  @override
  String handoffOfferBody(String name) {
    return '主持人想把「$name」交給你。接下後，你可以發公告、提問與結束活動，也要對公告內容負責。';
  }

  @override
  String get processing => '處理中…';

  @override
  String get acceptHosting => '接下主持';

  @override
  String get guideS1Title => '1. 走進城市';

  @override
  String get guideS1L1 =>
      '第一次開啟時，請確認你已年滿 18 歲，並允許「使用 App 時」取得精確位置；沒有精確位置，雷達無法運作。';

  @override
  String get guideS1L2 =>
      '寫下一句此刻的心情（最多 20 個字），勾選同意《使用條款》與《隱私權政策》，按「在這裡打卡，走進城市」。';

  @override
  String get guideS1L3 => '不需要手機號碼、Email 或真名。帳號是匿名的，綁定在這支手機上。';

  @override
  String get guideS1L4 =>
      '心情的顏色由字裡的關鍵字決定：「開心、笑」金黃，「難過、哭」藍，「生氣、怒」橘紅，「平靜、發呆」綠，「熱情」橘，「愛、心」粉紅，其他是淡紫。';

  @override
  String get guideS1L5 =>
      '打卡：每次打開 App 都要自己按下打卡，附近的人才看得到你的心情與大概的位置，你也才看得到他們；不會自動打卡。別人看到的是你打卡的地方，不會跟著你移動。走離打卡的地方超過 1 公里，雷達下方會出現「在這裡重新打卡」；App 在背景超過 30 分鐘，回來時也要重新打卡。';

  @override
  String get guideS2Title => '2. 底部選單';

  @override
  String get guideS2L1 => '點左邊自己的頭像：編輯大頭貼、城市稱呼（最多 10 個字）與心情。';

  @override
  String get guideS2L2 => '筆記圖示：在這裡留下一則低語。';

  @override
  String get guideS2L3 => '分享圖示：把此刻的心情做成一張夜景卡片。';

  @override
  String get guideS2L4 => '最右邊的調整圖示：打開設定。';

  @override
  String get guideS3Title => '3. 雷達與氣泡';

  @override
  String get guideS3L1 => '雷達上會浮現 5 公里內其他人的心情氣泡，只顯示分級的距離（例如「100m 內」），不顯示地址。';

  @override
  String get guideS3L2 => '雷達上只會出現此刻打卡、開著 App 的人；對方離開或切到其他 App，氣泡就會立刻消失，不留殘影。';

  @override
  String get guideS3L3 => '雙指可以放大縮小地圖。轉動手機，雷達會跟著你面向的方向轉。';

  @override
  String get guideS3L4 =>
      '氣泡太密集時會合成一顆光球「這裡有 N 個心情」，點一下就展開成一圈，每顆都點得到；點中間或空白處收起。';

  @override
  String get guideS3L5 => '名字前有「示範」的是示範對象，由程式自動回應，不是真人，可以用來體驗所有功能。';

  @override
  String get guideS3L6 => '附近都沒有人時，畫面下方會出現「你是今晚第一道光」，可以邀請朋友一起點亮街區。';

  @override
  String get guideS4Title => '4. 敲門與聊天';

  @override
  String get guideS4L1 =>
      '長按別人的氣泡 →「敲門」。對方有 5 分鐘可以回應：同意、婉拒或略過。等待時，你會看到一道光從你流向對方。';

  @override
  String get guideS4L2 => '對方同意後開始對話，倒數 10 分鐘；任何一方傳新訊息就重新倒數，安靜下來就結束。';

  @override
  String get guideS4L3 => '對話結束後，訊息會從伺服器刪除。對方仍可能截圖，請斟酌分享的內容。';

  @override
  String get guideS4L4 => '有人敲你的門時，會跳出敲門卡片，可以同意、婉拒、略過，或直接檢舉。';

  @override
  String get guideS5Title => '5. 微光';

  @override
  String get guideS5L1 => '雙擊別人的氣泡，或長按選「送出一道微光」，讓對方知道有人看見了，不需要開口。';

  @override
  String get guideS5L2 => '對方只會看到「今晚 N 道微光與你共鳴」，永遠不知道是誰送的。同一個人 24 小時內只能送一次。';

  @override
  String get guideS6Title => '6. 低語';

  @override
  String get guideS6L1 => '按底部選單的筆記圖示，在你所在的地方留下一句話（最多 60 個字）。';

  @override
  String get guideS6L2 => '接下來 7 天，經過那一帶 300 公尺內的人會在雷達上看到信封，打開就能讀到。';

  @override
  String get guideS6L3 => '低語永遠匿名；每人同時最多留 3 則、每 10 分鐘最多 1 則，可以隨時收回。';

  @override
  String get guideS6L4 =>
      '低語穿越：寫低語時選「寄給未來的自己」，再選一個月後或一年後。只有你看得到；時間到了會通知你，回到那裡 100 公尺內就會自動打開，讀過一次就會消失。雷達上只有你看得到一個小沙漏（上鎖／解鎖），不能點。每人同時最多 5 封，設定 →「我的低語穿越」可以查看或刪除。';

  @override
  String get guideS7Title => '7. 城市心情天氣';

  @override
  String get guideS7L1 => '左上角的標籤顯示 20 公里內、24 小時內大家最多的心情；點一下看完整比例。';

  @override
  String get guideS7L2 => '少於 10 人時不顯示比例，避免猜得出是誰。';

  @override
  String get guideS8Title => '8. 集會';

  @override
  String get guideS8L1 =>
      '開活動：設定 → 集會主持人 → 填活動名稱、一個表情符號當圖標、開始與結束時間（最長 24 小時）→ 開始活動。';

  @override
  String get guideS8L2 =>
      '範圍是以主持人打卡的地方為中心 5 公里；主持人重新打卡，範圍就跟著移動。主持人在雷達上有一圈光環和「主持」標示。';

  @override
  String get guideS8L3 => '主持人可以發公告（不限次數）、提出全場提問，也可以隨時結束活動。';

  @override
  String get guideS8L4 =>
      '參加：把活動的圖標加進你的城市稱呼（例如「遊蕩的貓🌈」），人在範圍內就會看到雷達上方的置頂公告，並收到推播。把圖標移除就退出。';

  @override
  String get guideS8L5 =>
      '全場提問：用一句心情回答；主持人只看得到全場的心情比例，看不到誰回答了什麼，少於 10 人時不顯示比例。';

  @override
  String get guideS8L6 => '同一個圖標在同一區域同時只能有一場活動；活動結束後，任何人都可以用。';

  @override
  String get guideS8L7 =>
      '交棒：主持人長按某位參加者的氣泡 →「轉移主持人」，選公開交棒（通知所有人）或安靜交棒（不通知），對方 5 分鐘內同意就由他主持，公告與提問都會留著；原主持人變回參加者，稱呼會自動補上圖標。';

  @override
  String get guideS9Title => '9. 城市燈塔（友善廁所）';

  @override
  String get guideS9L1 =>
      '點地圖左下角的廁所圖示打開燈塔，雷達上會出現 2 公里內的性別友善、無障礙與親子廁所，圖示旁會顯示數量；可以再點上方的三個圓形篩選，只看其中幾種。';

  @override
  String get guideS9L2 => '點一下標記可以看樓層、設施與距離，按「走路過去」用手機的地圖 App 導航。';

  @override
  String get guideS9L3 => '資料來自環境部「全國公廁建檔資料」，每月更新；沒有開放時間，「晚上可能有開」是依場所推估的。';

  @override
  String get guideS9L4 => '資料不對時可以回報（不是性別友善、晚上沒開、找不到）；同一種問題有 3 個人回報，標記會變灰並註明。';

  @override
  String get guideS10Title => '11. 心情卡與心情軌跡';

  @override
  String get guideS10L1 => '底部選單的分享鈕可以把此刻的心情做成一張夜景卡片，適合 IG 限時動態；卡片上不會有你的位置。';

  @override
  String get guideS10L2 => '設定 →「我的心情軌跡」可以回顧你寫過的心情與地點，資料只存在你的手機上，可以隨時關閉或清除。';

  @override
  String get guideS11Title => '17. 設定與通知';

  @override
  String get guideS11L1 => '「每晚提醒」：每天 21:30 一則溫和的提醒，可以在設定裡開關。';

  @override
  String get guideS11L2 => '敲門、新訊息、微光與集會公告會以推播通知你；可以在手機的系統設定裡關閉。';

  @override
  String get guideS11L3 => '每週五 21:00–23:00 是「點亮之夜」，大家一起上線，城市最亮。';

  @override
  String get guideS12Title => '18. 檢舉與封鎖';

  @override
  String get guideS12L1 =>
      '長按氣泡、敲門卡片、聊天室右上角、低語與集會公告都可以檢舉。檢舉後，那個人或那則內容會立刻從你的畫面消失，聊天室也會立即結束；我們會在 24 小時內處理。';

  @override
  String get guideS12L2 => '心情、稱呼、低語、聊天訊息與集會公告都會自動過濾不當字詞、電話與網址等聯絡方式。';

  @override
  String get guideS12L3 => '封鎖後，雙方會從彼此的雷達上消失，也不能再敲門或送微光。設定 →「管理封鎖名單」可以解除。';

  @override
  String get guideS12L4 => '遇到立即的危險，請直接撥打 110。';

  @override
  String get guideS13Title => '19. 隱私與帳號';

  @override
  String get guideS13L1 =>
      '只有在你打卡之後，附近的人才看得到你的心情、城市稱呼、大頭貼與大概的距離；他們看到的是你打卡的地方，不是即時位置。';

  @override
  String get guideS13L2 => '設定 →「刪除帳號與資料」可以隨時永久刪除你在城市留下的一切。';

  @override
  String get guideS13L3 => '有任何問題，設定 →「聯絡我們」或寫信到 service.softchip@gmail.com。';

  @override
  String get guideS14Title => '12. 平行宇宙';

  @override
  String get guideS14L1 => '點雷達右上角的地球圖示開啟，再點一次關閉。每次打開 App 都是關閉的。';

  @override
  String get guideS14L2 =>
      '台灣各縣市以各自的中央車站為中心（例如大台北是台北車站、桃園是桃園車站），對應到國外的城市：日本、韓國、香港、澳門、新加坡、馬來西亞、印尼、越南、泰國、菲律賓與澳洲；國外的城市則對應到台灣。';

  @override
  String get guideS14L3 =>
      '你離車站往哪個方向、多遠，在對方的城市就出現在離對方車站同樣方向、同樣距離的地方，並模糊到約 500 公尺，沒有人看得到你的真實位置。';

  @override
  String get guideS14L4 =>
      '只要你或對方其中一方開啟就看得到：你開啟時，看得到對方城市所有正開著 App 的人；你沒開時，只看得到有開啟的人。只有已打卡、正開著 App 的人會出現在其他城市。';

  @override
  String get guideS14L5 =>
      '平行宇宙的人有虛線光環，並標示所在的城市；一樣可以送微光、敲門和聊天。低語、低語穿越與集會都只留在當地。';

  @override
  String get guideS15Title => '16. 翻譯';

  @override
  String get guideS15L1 => '聊天時，對方的訊息跟你的語言不同，下方會出現「點一下翻譯」；點一下就翻成你的語言，再點一下看原文。';

  @override
  String get guideS15L2 => '雷達上的心情氣泡也一樣：跟你的語言不同時，點一下就翻譯，再點一下回到原文。';

  @override
  String get guideS15L3 =>
      '翻譯完全在手機上進行，文字不會上傳。iPhone 使用 Apple 內建的翻譯，第一次翻某種語言時系統會問你要不要下載；Android 使用 Google ML Kit，第一次會先問你，再下載約 30 MB 的語言模型。iPhone 暫時無法翻譯馬來文。';

  @override
  String get guideIntro => '城市低語是一座夜裡的城市：寫下一句此刻的心情，看見附近的人此刻的感受。';

  @override
  String get beaconGender => '性別友善';

  @override
  String get beaconAccessible => '無障礙';

  @override
  String get beaconFamily => '親子';

  @override
  String get beaconReportNotGender => '不是性別友善';

  @override
  String get beaconReportClosed => '晚上沒開';

  @override
  String get beaconReportMissing => '找不到這間廁所';

  @override
  String get beaconFlagNotGender => '有人回報：不是性別友善';

  @override
  String get beaconFlagClosed => '有人回報：晚上沒開';

  @override
  String get beaconFlagMissing => '有人回報：找不到';

  @override
  String get beaconDefaultName => '公廁';

  @override
  String meters(int m) {
    return '$m 公尺';
  }

  @override
  String kilometers(String km) {
    return '$km 公里';
  }

  @override
  String get beaconUnavailable => '城市燈塔暫時無法使用，請稍後再試。';

  @override
  String get notConnectedCheckNetwork => '沒有連上，請檢查網路後再試一次。';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$features廁所，$name，$distance';
  }

  @override
  String get listSeparator => '、';

  @override
  String beaconToggleOff(int count) {
    return '關閉城市燈塔（友善廁所），附近 $count 間';
  }

  @override
  String get beaconToggleOn => '打開城市燈塔（友善廁所）';

  @override
  String beaconFilterOnly(String feature) {
    return '只看$feature';
  }

  @override
  String get beaconMaybeOpenNight => '晚上可能有開（推估）';

  @override
  String get beaconMaybeDaytime => '可能只在白天開（推估）';

  @override
  String get walkThere => '走路過去';

  @override
  String get beaconWrongData => '資料不對嗎？';

  @override
  String beaconThanks(String reason) {
    return '謝謝你，已經收到「$reason」的回報。';
  }

  @override
  String get beaconSource => '資料來源：環境部「全國公廁建檔資料」，每月更新。開放時間是依場所推估的。';

  @override
  String get invite1 => '我在城市低語點亮了一道光。附近的人越多，街區就越亮，一起來點亮我們的街區吧：';

  @override
  String get invite2 => '今晚的城市有點安靜。來城市低語寫下一句心情，讓我們的街區亮起來：';

  @override
  String get invite3 => '不用加好友、不用真名，只要一句此刻的心情。來城市低語找我：';

  @override
  String get invite4 => '我在城市低語留了一盞燈給你。打開 App，看看今晚附近的人都在想什麼：';

  @override
  String get invite5 => '每週五晚上九點是城市低語的點亮之夜，一起上線，讓雷達亮成一片吧：';

  @override
  String get invite6 => '想找個地方說說今天的心情嗎？城市低語是匿名的，說完就消散：';

  @override
  String get invite7 => '走在路上的時候，你會好奇擦肩而過的人在想什麼嗎？來城市低語看看：';

  @override
  String get invite8 => '我在這條街留下了一則低語，經過的人才讀得到。你也來留一則吧：';

  @override
  String get invite9 => '城市低語是一張夜裡的心情地圖。人越多越好玩，來幫我們的街區多點一道光：';

  @override
  String get invite10 => '今晚的你，心情是什麼顏色？來城市低語寫下來，我在附近等你的光：';

  @override
  String get shareInvite => '分享邀請';

  @override
  String get inviteSubject => '一起來點亮我們的街區';

  @override
  String get shareMoodCardButton => '分享心情卡';

  @override
  String moodShareText(String mood) {
    return '我在城市低語留下了此刻的心情：「$mood」\n今晚，你的心情也在城市裡發光嗎？';
  }

  @override
  String get shareFailed => '沒有分享出去，請再試一次。';

  @override
  String shuffleCard(int current, int total) {
    return '換一張 · $current / $total';
  }

  @override
  String get preparing => '準備中…';

  @override
  String get sendLinkToFriends => '傳連結給朋友（LINE、Messenger）';

  @override
  String get partLateNight => '深夜';

  @override
  String get partMorning => '早晨';

  @override
  String get partAfternoon => '午後';

  @override
  String get partDusk => '黃昏';

  @override
  String get partNight => '夜晚';

  @override
  String get cardInviteEyebrow => '邀請你';

  @override
  String get cardMoodEyebrow => '此刻的心情';

  @override
  String get cardInviteTitle => '一起來點亮\n我們的街區';

  @override
  String get cardInviteBody => '我在城市低語點亮了一道光。\n附近的人越多，街區就越亮。';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\n在城市的某個角落';
  }

  @override
  String get whisperUnavailable => '低語暫時無法使用，請稍後再試。';

  @override
  String get whisperNotSent => '低語沒有送出，請檢查網路後再試一次。';

  @override
  String daysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get timeWhisperTitle => '低語穿越';

  @override
  String get timeWhisperLead => '寫給未來的自己。時間到了，回到這裡才能打開。';

  @override
  String get whisperLead => '寫給下一個經過這裡的人。';

  @override
  String get toPassersBy => '給經過的人';

  @override
  String get toFutureSelf => '寄給未來的自己';

  @override
  String get inOneMonth => '一個月後';

  @override
  String get inOneYear => '一年後';

  @override
  String get timeWhisperHint => '例如：明年此地再見。希望那時的你，過得比現在好。';

  @override
  String get whisperHint => '例如：這裡的夕陽很美，記得抬頭看看。';

  @override
  String get timeWhisperCaptionYear => '只有你看得到 · 一年後解封並通知你 · 回到 100 公尺內打開';

  @override
  String get timeWhisperCaptionMonth => '只有你看得到 · 一個月後解封並通知你 · 回到 100 公尺內打開';

  @override
  String get whisperCaption => '7 天後消散 · 不會顯示你是誰 · 只透露你曾在這一帶';

  @override
  String get sealHere => '封存在這裡';

  @override
  String get leaveHere => '留在這裡';

  @override
  String get aWhisper => '一則低語';

  @override
  String whisperLeftAgo(String ago) {
    return '$ago留在這一帶';
  }

  @override
  String whisperCollectedBy(int count) {
    return '已被 $count 個人收下';
  }

  @override
  String get whisperNobodyYet => '還沒有人經過';

  @override
  String get withdrawWhisper => '收回這則低語';

  @override
  String get whisperCollected => '你收下了這則低語。';

  @override
  String whisperReadersBefore(int count) {
    return '在你之前，已經有 $count 個人經過這裡。';
  }

  @override
  String get whisperFirstReader => '你是第一個經過這裡的人。';

  @override
  String get reportWhisper => '檢舉這則低語';

  @override
  String get thisWhisper => '這則低語';

  @override
  String get chatTimeUp => '時間已盡，交集消散...';

  @override
  String get chatOtherLeft => '對方已沒入城市...';

  @override
  String get chatEnded => '交集已結束...';

  @override
  String get chatBlockedEnded => '已封鎖對方，交集結束。';

  @override
  String get chatReportedEnded => '已檢舉對方，交集結束。';

  @override
  String get anonymous => '匿名';

  @override
  String get leaveChat => '離開對話';

  @override
  String chatWith(String name) {
    return '與 $name 的交集';
  }

  @override
  String get countdownPrefix => '倒數 ';

  @override
  String get countdownSuffix => ' 消散';

  @override
  String get demoChatNotice => '示範對話：對方由程式自動回覆，不是真人。';

  @override
  String get typing => '對方正在輸入中…';

  @override
  String get chatHint => '輕聲說點什麼…';

  @override
  String get send => '送出';

  @override
  String get chatDissolvedApart => '你們各自回到城市裡了';

  @override
  String get knockTooOften => '敲門太頻繁，請感受一下城市的呼吸...';

  @override
  String get otherNotNow => '對方目前不想被打擾，請給彼此一點空間。';

  @override
  String otherNotNowMinutes(int minutes) {
    return '對方目前不想被打擾，請給彼此一點空間 ($minutes 分鐘)。';
  }

  @override
  String get justEndedRest => '你們才剛結束交集，讓回憶沉澱一下吧。';

  @override
  String get intro1Title => '沒入這座城市';

  @override
  String get intro1Body => '拋開繁雜的社交標籤，在極簡的暗黑畫布上，只留下你最真實的情緒與座標。';

  @override
  String get intro2Title => '片刻的交集';

  @override
  String get intro2Body => '看見附近浮動的心情氣泡？輕輕敲門，與擦肩而過的人產生一期一會的對話。';

  @override
  String get intro3Title => '城市的節奏';

  @override
  String get intro3Body => '我們在意你的感受。發送敲門後請靜待回音，若無緣交集，300 秒後氣泡將悄悄消散。';

  @override
  String get intro4Title => '溫柔的距離';

  @override
  String get intro4Body => '不想被打擾？點擊婉拒或封鎖。專屬的冷卻系統會為你隔絕喧囂，還你安靜的角落。';

  @override
  String get intro5Title => '準備好相遇了嗎？';

  @override
  String get intro5Body => '閉上眼睛，感受手機的震動與心跳。現在，寫下你此刻的心情，在這裡打卡，走進城市低語。';

  @override
  String get intro6Title => '寫給未來的自己';

  @override
  String get intro6Body => '把一句話留在此刻的地方，寄給一個月或一年後的自己。等你回到這裡，它才會為你打開。';

  @override
  String get intro7Title => '今晚，一起發光';

  @override
  String get intro7Body => '開一場集會，用一個表情符號當暗號。把它加進稱呼的人，會收到你的公告，一起點亮同一片街區。';

  @override
  String get intro8Title => '平行宇宙';

  @override
  String get intro8Body =>
      '點一下地球，台灣的城市與東京、首爾、吉隆坡重疊在一起。看見遠方此刻的心情，一樣可以敲門聊天，點一下就翻譯。';

  @override
  String get loadingImage => '等待載入高清圖片...';

  @override
  String get startExploring => '開始探索';

  @override
  String get nextPage => '下一頁';

  @override
  String get feedbackSubject => '城市低語 意見回報';

  @override
  String get loginNeedMood => '請留下你此刻的心情，再沒入城市。';

  @override
  String get loginNeedAgree => '請先閱讀並勾選同意使用條款與隱私權政策。';

  @override
  String get loginCantConnect => '無法連上城市，請檢查網路後再試一次。';

  @override
  String get ageQuestion => '請問你已年滿 18 歲了嗎？';

  @override
  String get ageReason => '城市低語會與附近的陌生人互動，僅限 18 歲以上使用。';

  @override
  String get ageUnder => '未滿 18 歲';

  @override
  String get ageOver => '已滿 18 歲';

  @override
  String get loginTitle1 => '準備好';

  @override
  String get loginTitle2 => '相遇了嗎？';

  @override
  String get loginLead => '閉上眼睛，感受手機的震動與心跳。\n現在，寫下你此刻的心情，走進城市低語。';

  @override
  String get loginPrompt => '此時此刻，你想對城市說什麼？';

  @override
  String get loginHint => '例如：喝了一杯好咖啡😊';

  @override
  String get enterCity => '走進城市低語';

  @override
  String get agreeSemantic => '我已閱讀並同意使用條款與隱私權政策';

  @override
  String get agreePrefix => '我已閱讀及同意';

  @override
  String get termsLink => '《使用條款》';

  @override
  String get agreeAnd => '與';

  @override
  String get privacyLink => '《隱私權政策》';

  @override
  String get agreeSuffix => '。城市低語對騷擾、色情與仇恨等不當內容零容忍，違者將被移出城市。';

  @override
  String get under18Title => '城市低語僅限 18 歲以上使用';

  @override
  String get under18Body => '謝謝你的誠實。這座城市會與陌生人互動，等你滿 18 歲，我們再見。';

  @override
  String get clearMoodTrail => '清除心情軌跡';

  @override
  String get clearMoodTrailBody => '這支手機上的所有心情軌跡都會刪除，無法復原。';

  @override
  String get clear => '清除';

  @override
  String monthDay(int month, int day) {
    return '$month 月 $day 日';
  }

  @override
  String get moodTrailLocalOnly => '只存在你的手機上，不會上傳到任何地方。';

  @override
  String get moodTrailEmpty => '這週還沒有心情軌跡。每次寫下心情、或走到新的地方，這裡都會多一道光。';

  @override
  String get thisWeekYou => '這週的你';

  @override
  String get topMoodPrefix => '最常感到「';

  @override
  String topMoodSuffix(int count) {
    return '」，共 $count 次';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '在 $places 個不同的地方，留下了 $total 道心情';
  }

  @override
  String get recordMoodTrail => '記錄我的心情軌跡';

  @override
  String get recordMoodTrailOff => '關閉後不再記錄新的軌跡';

  @override
  String get nightly1 => '今晚的城市在想什麼？';

  @override
  String get nightly2 => '有人在附近，正寫下此刻的心情。';

  @override
  String get nightly3 => '夜色剛好，留一句話給這座城市吧。';

  @override
  String get nightly4 => '今天過得怎麼樣？你的心情會在城市裡發光。';

  @override
  String get nightly5 => '街燈亮了，附近的人也還醒著。';

  @override
  String get nightly6 => '給今天一個結尾：此刻的你，是什麼心情？';

  @override
  String get nightly7 => '今晚，誰會和你擦肩而過？';

  @override
  String get nightlyChannel => '每晚提醒';

  @override
  String get nightlyChannelDesc => '每晚一則溫和的提醒，可在 App 設定中關閉';

  @override
  String get reasonHarassment => '騷擾或霸凌';

  @override
  String get reasonSexual => '色情或性暗示';

  @override
  String get reasonScam => '詐騙或廣告';

  @override
  String get reasonHate => '仇恨或暴力言論';

  @override
  String get reasonImpersonation => '冒充他人';

  @override
  String get reasonOther => '其他';

  @override
  String get reportReceived => '已收到檢舉，已從你的畫面移除。我們會在 24 小時內處理。';

  @override
  String get reportNotSent => '檢舉沒有送出，請檢查網路後再試一次。';

  @override
  String reportTarget(String target) {
    return '檢舉 $target';
  }

  @override
  String get reportPrivate => '你的檢舉不會讓對方知道。請選擇原因：';

  @override
  String get reportDetails => '補充說明（選填）';

  @override
  String get reportWhatHappened => '發生了什麼事？';

  @override
  String get sendReport => '送出檢舉';

  @override
  String get alsoBlock => '同時封鎖對方，雙方將從彼此的城市中消失';

  @override
  String get aYearAgo => '一年前';

  @override
  String get aMonthAgo => '一個月前';

  @override
  String get timeWhisperUnavailable => '低語穿越暫時無法使用，請稍後再試。';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago的你，在這裡說';
  }

  @override
  String writtenOn(String date) {
    return '寫於 $date';
  }

  @override
  String get timeWhisperOnce => '這封信只會出現這一次。';

  @override
  String get keepInHeart => '收進心裡';

  @override
  String unsealsOn(String unlock, String created) {
    return '$unlock 解封 · 寫於 $created';
  }

  @override
  String get unsealedGoBack => '已解封，回到那裡就能打開';

  @override
  String unsealedDistance(String distance) {
    return '已解封 · 距離你 $distance';
  }

  @override
  String get timeWhisperListLead =>
      '寫給未來的自己，只有你看得到。時間到了，回到那裡 100 公尺內就會打開；讀過一次就會消失。';

  @override
  String get timeWhisperListEmpty => '還沒有寫給未來的信。按底部選單的筆記圖示，選「寄給未來的自己」。';

  @override
  String get readyToOpen => '已經可以打開了';

  @override
  String get sealed => '封存中';

  @override
  String get delete => '刪除';

  @override
  String get within100m => '100m 內';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return '正在等待 $name 回音，剩下 $mm 分 $ss 秒';
  }

  @override
  String knockWaiting(String name) {
    return '等待 $name 回音';
  }

  @override
  String get language => '語言';

  @override
  String get languageSystem => '跟隨手機設定';

  @override
  String get parallelUniverse => '平行宇宙';

  @override
  String get parallelUniverseSubtitle => '看見其他城市此刻的心情，也讓他們看見你';

  @override
  String get parallelUniverseIntroTitle => '進入平行宇宙';

  @override
  String get parallelUniverseIntroBody =>
      '開啟後，對應城市裡此刻開著 App 的人都會疊到你的雷達上，他們也都看得到你。台灣的城市對應到國外的城市（例如東京、首爾、吉隆坡），國外的城市對應到台灣。\n\n兩邊以各自的中央車站對齊：你離車站多遠、往哪個方向，在對方的城市就出現在同樣的地方，而且模糊到約 500 公尺，沒有人看得到你的真實位置或距離。一樣可以送微光、敲門和聊天，隨時可以關閉。低語和集會只留在當地。';

  @override
  String get parallelUniverseEnter => '進入';

  @override
  String get parallelUniverseNoCity => '你所在的地方還沒有平行宇宙';

  @override
  String parallelFrom(String city) {
    return '平行宇宙 · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return '這個人在$city，不在你身邊。位置是投影過來的，不代表真實距離。';
  }

  @override
  String get labelHost => '主持';

  @override
  String get labelDemo => '示範';

  @override
  String get labelResting => '休息中';

  @override
  String get cityTaipei => '台北';

  @override
  String get cityTaichung => '台中';

  @override
  String get cityKaohsiung => '高雄';

  @override
  String get cityTokyo => '東京';

  @override
  String get cityOsaka => '大阪';

  @override
  String get citySeoul => '首爾';

  @override
  String get cityBusan => '釜山';

  @override
  String get cityHongkong => '香港';

  @override
  String get cityMacau => '澳門';

  @override
  String get citySingapore => '新加坡';

  @override
  String get cityKualalumpur => '吉隆坡';

  @override
  String get cityJakarta => '雅加達';

  @override
  String get cityHochiminh => '胡志明市';

  @override
  String get cityHanoi => '河內';

  @override
  String get translateTap => '點一下翻譯';

  @override
  String get translateShowOriginal => '已翻譯 · 點一下看原文';

  @override
  String get translating => '翻譯中…';

  @override
  String get translateFailed => '翻譯失敗，請稍後再試';

  @override
  String get translateDownloadTitle => '下載翻譯模型';

  @override
  String get translateDownloadBody =>
      '第一次翻譯這種語言，需要下載翻譯模型（每種語言約 30 MB，只需一次）。\n\n翻譯完全在你的手機上進行，訊息不會上傳。';

  @override
  String get translateDownload => '下載';

  @override
  String placeHint(String name) {
    return '附近有一盞心情據點的燈 · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return '營業到 $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return '心情據點：$name，$hours';
  }

  @override
  String get placeWrongData => '資料有誤？';

  @override
  String placeReportSubject(String name) {
    return '心情據點資料有誤：$name';
  }

  @override
  String get placeHintsSetting => '心情據點提示';

  @override
  String get placeHintsSettingSubtitle => '經過營業中的心情據點時，在 App 裡輕聲提示（不推播）';

  @override
  String get guideS16Title => '10. 心情據點';

  @override
  String get guideS16L1 =>
      '心情據點是合作的獨立咖啡店。你打卡後，走到營業中的店門口 150 公尺內，雷達上會浮現一盞慢慢呼吸的小燈；走遠了就熄掉。';

  @override
  String get guideS16L2 =>
      '點小燈打開據點名片：店裡的夜景、今天營業到幾點、一句店家的心情故事（點一下翻譯）、地址與電話，按「走路過去」用手機的地圖 App 導航。今天打開過的燈會變成靜止的柔光。';

  @override
  String get guideS16L3 =>
      '第一次經過時，上方會浮出一張小卡提示你，不響也不震動；同一家店 7 天內只提示一次，一天最多 2 次。可以在「設定 → 心情據點提示」關掉，燈還是會在。';

  @override
  String get guideS16L4 =>
      '店家清單整份下載到你的手機，是否在附近只在手機上判斷，我們和店家都不會知道你經過哪家店。店家不能付費換取曝光；資料有誤可以在名片下方回報。';

  @override
  String get placeGuestbook => '店內留言本';

  @override
  String placeGuestbookLocked(int m) {
    return '走進店裡（約 $m 公尺內）就讀得到之前坐在這裡的人留下的話。';
  }

  @override
  String get placeGuestbookAbout => '只有在店裡的人讀得到。匿名，30 天後消失。';

  @override
  String get placeGuestbookEmpty => '還沒有人留言，留下第一句吧。';

  @override
  String get placeGuestbookWrite => '留一句話';

  @override
  String get placeGuestbookHint => '給下一個坐在這裡的人…';

  @override
  String get placeGuestbookSent => '留好了，下一個坐在這裡的人會讀到。';

  @override
  String get placeGuestbookUnavailable => '留言本暫時無法使用，請稍後再試。';

  @override
  String get placeNoteMine => '你的留言';

  @override
  String get withdrawPlaceNote => '收回這則留言';

  @override
  String get reportPlaceNote => '檢舉這則留言';

  @override
  String get thisPlaceNote => '這則留言';

  @override
  String get guideS16L5 =>
      '店內留言本：人在店裡（約 40 公尺內）打開名片，就讀得到之前坐在這裡的人留下的話，也可以留一句給下一個人。留言匿名、30 天後消失，同一家店一天可以留一則，點一下可以翻譯，不舒服的可以檢舉。打開留言本時，手機會把位置送到伺服器確認你在店裡，伺服器不保存。';

  @override
  String get quantumWorld => '量子世界';

  @override
  String get quantumWorldSubtitle => '全世界一個房間，不透露你的位置';

  @override
  String get quantumIntroTitle => '進入量子世界';

  @override
  String get quantumIntroBody =>
      '全世界此刻在量子世界的人，都在同一個房間裡：以台北 101 為原點排成蜂巢，你會拿到一個席位，例如「Q4-17」，圈數越小越靠近原點。\n\n沒有人看得到你的真實位置。大家看到的是你的席位，固定在你按下「進入」的那一刻，走路也不會移動；想換位置就離開再進入一次。暱稱和心情照舊，一樣可以送微光、敲門和聊天，點一下就翻譯。\n\n在量子世界期間，會暫時離開一般雷達和平行宇宙；離開後回到原本打卡的位置。';

  @override
  String get quantumEnter => '進入';

  @override
  String get quantumLeave => '離開量子世界';

  @override
  String get quantumLeft => '你離開了量子世界，回到原本的雷達';

  @override
  String quantumYourSeat(String code) {
    return '你的席位 $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return '第 $ring 圈 · 圈數越小越靠近 101 原點';
  }

  @override
  String quantumOnlineChip(int count) {
    return '此刻 $count 人';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '此刻共有 $count 人在量子世界';
  }

  @override
  String get quantumRegionTw => '台灣';

  @override
  String get quantumRegionJp => '日本';

  @override
  String get quantumRegionKr => '韓國';

  @override
  String get quantumRegionHkmo => '港澳';

  @override
  String get quantumRegionSea => '東南亞';

  @override
  String get quantumRegionOther => '其他地區';

  @override
  String get quantumQuiet => '量子寧靜';

  @override
  String get quantumQuietSubtitle => '只看世界：別人不能敲你的門，仍然收得到微光';

  @override
  String get quantumQuietTarget => '對方開啟了量子寧靜，現在只能送微光';

  @override
  String get quantumClosedRegion => '你所在的地區沒有開放量子世界';

  @override
  String get quantumLeftClosed => '你進入了未開放量子世界的地區，已自動離開';

  @override
  String get quantumSeatExpired => '你離開太久，席位已經釋放，回到原本的雷達';

  @override
  String get quantumUnavailable => '量子世界暫時進不去，請稍後再試';

  @override
  String quantumPersonBody(String code) {
    return '這個人在量子世界的席位 $code。量子世界裡看不到任何人的真實位置。';
  }

  @override
  String quantumChatTag(String code) {
    return '量子世界・$code';
  }

  @override
  String get guideS17Title => '13. 量子世界';

  @override
  String get guideS17L1 =>
      '點雷達右上角的蜂巢圖示（平行宇宙下方），看完說明後按「進入」。每次進入都要自己按，就像打卡；每次打開 App 都從一般雷達開始。';

  @override
  String get guideS17L2 =>
      '全世界在量子世界的人都在同一個房間：以台北 101 為原點排成蜂巢，相鄰席位相距 100 公尺。你會拿到一個席位代號，例如「Q4-17」（第 4 圈第 17 號），圈數越小越靠近原點。入場時先補別人離開的空位；第 1～3 圈保留給集會主持人。';

  @override
  String get guideS17L3 =>
      '沒有人看得到你的真實位置：大家看到的是你的席位。每次按下「進入」就是一次打卡，席位固定在那一刻，走路不會移動；想換位置就離開再進入。中國大陸不開放量子世界。';

  @override
  String get guideS17L4 =>
      '暱稱和心情照舊，一樣可以送微光、敲門和聊天，點一下就翻譯。兩指縮小可以看到整個蜂巢，遠處的人會變成光點。點左上角的席位代號，可以看在線人數、開啟「量子寧靜」（別人不能敲門，仍然收得到微光），或離開。';

  @override
  String get guideS17L5 =>
      '量子世界裡沒有低語、低語穿越、心情據點、城市燈塔與集會。進入期間會暫時離開一般雷達和平行宇宙；離開時你的氣泡化成光點散掉，回到原本打卡的位置。App 關掉或斷線超過 3 分鐘，席位就會釋放。';

  @override
  String quantumChimeCountdown(int seconds) {
    return '$seconds 秒後整點報時';
  }

  @override
  String get quantumChimeLookOrigin => '大家都在看 101 原點';

  @override
  String get quantumChimeLook => '看原點';

  @override
  String quantumChimeNow(int hour) {
    return '量子中心 $hour 點報時';
  }

  @override
  String get quantumChimeSend => '送出報時微光';

  @override
  String get quantumChimeSent => '你的微光飛向原點';

  @override
  String quantumChimeWatched(int n) {
    return '這次報時，有 $n 人一起看';
  }

  @override
  String get quantumChimeReminder => '整點報時提醒';

  @override
  String get quantumChimeReminderSubtitle => '整點前提醒你到 101 原點看報時';

  @override
  String get quantumChimeNotifyBody => '整點報時快開始了，到 101 原點一起看';

  @override
  String get quantumChimeChannel => '整點報時';

  @override
  String get quantumChimeChannelDesc => '量子世界的整點報時提醒';

  @override
  String get quantumEntangleInvite => '邀請量子糾纏';

  @override
  String quantumEntangleInvited(String name) {
    return '已邀請 $name 糾纏';
  }

  @override
  String get quantumEntangleAskTitle => '量子糾纏';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name（$code）想和你量子糾纏。糾纏後，兩顆氣泡之間會有一道光線，不管相隔多遠都看得到；任何一方離開，光線就會塌縮。不留紀錄。';
  }

  @override
  String get quantumEntangleAccept => '糾纏';

  @override
  String quantumEntangled(String name) {
    return '你和 $name 糾纏了';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return '與 $name 的糾纏已塌縮';
  }

  @override
  String get quantumEntangleCut => '解除糾纏';

  @override
  String get quantumEntangleFull => '你已經和 3 個人糾纏了';

  @override
  String get quantumEntangleTheirFull => '對方已經和 3 個人糾纏了';

  @override
  String get quantumEntangleGone => '對方已經離開量子世界';

  @override
  String get quantumEntangleExpired => '邀請已經過期';

  @override
  String get quantumEntangledTitle => '糾纏中';

  @override
  String get quantumTunnel => '量子穿隧';

  @override
  String get quantumTunnelSubtitle => '跳到蜂巢裡隨機一個空席位，換一群鄰居。每次入場可以用一次。';

  @override
  String get quantumTunnelUsed => '這次入場已經穿隧過了';

  @override
  String quantumTunnelDone(String code) {
    return '穿隧到 $code';
  }

  @override
  String get quantumShowTime => '顯示我的當地時間';

  @override
  String get quantumShowTimeSubtitle => '別人長按你的氣泡時看得到；關閉時只顯示晝夜色調';

  @override
  String quantumLocalTime(String time, String part) {
    return '當地 $time・$part';
  }

  @override
  String get quantumDawn => '清晨';

  @override
  String get quantumDay => '白天';

  @override
  String get quantumDusk => '黃昏';

  @override
  String get quantumNight => '深夜';

  @override
  String get quantumTopicsTitle => '量子同頻';

  @override
  String get quantumTopicsSubtitle => '選最多 3 個主題，顯示在你的氣泡下方';

  @override
  String get quantumTopicMusic => '音樂';

  @override
  String get quantumTopicMovies => '電影';

  @override
  String get quantumTopicTech => '科技';

  @override
  String get quantumTopicWalks => '散步';

  @override
  String get quantumTopicFood => '美食';

  @override
  String get quantumTopicTravel => '旅行';

  @override
  String get quantumTopicReading => '閱讀';

  @override
  String get quantumTopicSports => '運動';

  @override
  String quantumTopicsCommon(String topics) {
    return '你們都喜歡：$topics';
  }

  @override
  String get quantumSignalsTitle => '量子訊號';

  @override
  String quantumSignalReceived(String name) {
    return '$name 傳來一個訊號';
  }

  @override
  String get quantumSignalWait => '剛送過了，等一下再送';

  @override
  String quantumResonance(String name) {
    return '你和 $name 產生了共振';
  }

  @override
  String get guideS17L6 =>
      '整點報時：每個整點，101 光柱前 1 分鐘開始變亮，整點時光之使者繞原點一圈、敲出量子中心時間的鐘聲（0 點 24 聲），最後一道光波擴散到整個蜂巢。報時時點一下「送出報時微光」，一起看的人越多光越盛。「整點報時提醒」預設打開，可以在面板裡關掉。';

  @override
  String get guideS17L7 =>
      '聊過天的人可以邀請「量子糾纏」：兩顆氣泡之間會有一道光線，不管多遠都看得到，任何一方離開就塌縮，每人最多同時糾纏 3 人。「量子穿隧」每次入場可以用一次，跳到隨機一個空席位、換一群鄰居。';

  @override
  String get guideS17L8 =>
      '每顆氣泡帶著主人當地時間的色調：清晨淡金、白天亮白、黃昏橘紫、深夜深藍；開啟「顯示我的當地時間」後，長按氣泡看得到時間。24 小時內互送微光會產生「量子共振」；長按氣泡可以送 👋 ☕ 🌙 🎵 🌧️ ✨ 量子訊號；在面板選最多 3 個「量子同頻」主題，共同的主題會亮起來。';

  @override
  String get quantumNyTitle => '量子跨年';

  @override
  String quantumNyDays(int n) {
    return '還有 $n 天：12/31 量子中心午夜，到 101 原點和全世界一起倒數';
  }

  @override
  String get quantumNyTonight => '今晚量子中心午夜，到 101 原點和全世界一起倒數';

  @override
  String quantumNyZone(String places) {
    return '$places 跨年了 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '此刻全世界共 $n 人在量子世界一起跨年';
  }

  @override
  String get quantumNyHappy => '新年快樂';

  @override
  String get guideS17L9 =>
      '量子跨年：12/31 各時區跨年時，那裡的氣泡一波波亮起金色光環，世界視角的光點也跟著變金色。量子中心午夜時，全蜂巢一起倒數最後 10 秒，101 原點放出全世界最大的光爆和 5 分鐘的煙火，並顯示這一刻一起跨年的人數。';

  @override
  String get quantumMeetAction => '製作量子相遇卡';

  @override
  String quantumMeetAsked(String name) {
    return '已邀請 $name 一起製作量子相遇卡';
  }

  @override
  String get quantumMeetWait => '剛剛邀請過了，稍等一下再試';

  @override
  String get quantumMeetAskTitle => '量子相遇卡';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name（⬡ $code）想和你把這次相遇做成一張分享卡。卡片上有雙方的暱稱、席位代號、當地時間和心情，不含任何位置。';
  }

  @override
  String get quantumMeetAccept => '一起製作';

  @override
  String get quantumMeetEyebrow => '量子相遇';

  @override
  String get quantumMeetFooter => '我們在量子世界相遇';

  @override
  String get quantumMeetShare => '分享相遇卡';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b，我們在量子世界相遇了 ✨';
  }

  @override
  String get guideS17L10 =>
      '量子相遇卡：聊過天的人，長按氣泡可以邀請對方一起製作。雙方都同意後，各自拿到一張分享卡，上面有兩人的暱稱、席位代號、當地時間與晝夜色和心情，不含任何位置；第 4 圈的席位代號是金色的。';

  @override
  String get quantumOrbEntry => '量子化身';

  @override
  String get quantumOrbEntrySubtitle => '你的頭像在量子世界裡會變成一顆水晶球';

  @override
  String get orbTitle => '量子化身';

  @override
  String get orbSubtitle => '球緣和光暈永遠跟著你的心情';

  @override
  String get orbStyleGlow => '光球';

  @override
  String get orbStyleRing => '星環';

  @override
  String get orbStyleRainbow => '彩虹';

  @override
  String get orbFree => '免費';

  @override
  String get orbOwned => '已擁有';

  @override
  String get orbInUse => '使用中';

  @override
  String get orbCosmeticNote => '特殊款只是外觀，不影響任何功能或權益。買過的款式跟著帳號保存。';

  @override
  String get orbRestore => '恢復購買';

  @override
  String orbPurchased(String name) {
    return '$name已經是你的了 ✨';
  }

  @override
  String get orbPurchaseFailed => '購買沒有完成，請稍後再試';

  @override
  String get orbOwnedElsewhere => '這筆購買已經用在另一個帳號上';

  @override
  String get orbStoreUnavailable => '商店暫時連不上，請稍後再試';

  @override
  String get aiyaName => '艾婭';

  @override
  String get aiyaChip => '艾婭 · AI';

  @override
  String get aiyaConsentTitle => '和艾婭聊天之前';

  @override
  String get aiyaConsentBody =>
      '艾婭是 AI，由 Anthropic 的 Claude 提供。你傳給艾婭的文字會送到 Anthropic（美國）處理，不會附上你的身分、暱稱或位置；對話結束就刪除。艾婭的回覆可能出錯，不構成專業建議。';

  @override
  String get aiyaConsentAgree => '同意並開始';

  @override
  String get aiyaConsentLater => '先不要';

  @override
  String get aiyaGreeting => '嗨，我是艾婭，住在量子中心的那道光。今晚想聊什麼？';

  @override
  String get aiyaFarewell => '時間到了，我要回到光裡了。想我的時候再來敲門。';

  @override
  String get aiyaInputHint => '跟艾婭說點什麼…';

  @override
  String get aiyaSend => '送出';

  @override
  String aiyaFreeLeft(int n) {
    return '今天免費還有 $n 次';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return '時光包 $n 次';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '剩 $time';
  }

  @override
  String get aiyaEnd => '結束聊天';

  @override
  String get aiyaFiltered => '這句話裡有不適合的字詞或聯絡方式，換個說法吧。';

  @override
  String get aiyaBusy => '艾婭剛剛恍神了，再說一次好嗎？';

  @override
  String get aiyaRefused => '這個我不太能聊，換個話題好嗎？';

  @override
  String get aiyaEnded => '這次的聊天已經結束了。';

  @override
  String get aiyaNoQuotaTitle => '今天的免費次數用完了';

  @override
  String get aiyaNoQuotaBody =>
      '每天有 3 次免費聊天，明天 00:00（台灣時間）重新計算。想現在繼續，可以買時光包，每次最多 10 分鐘。';

  @override
  String get aiyaResting => '艾婭今晚累了，明天見。';

  @override
  String get aiyaDailyMax => '今天已經聊很多了，明天再來找艾婭吧。';

  @override
  String aiyaPackTimes(int n) {
    return '$n 次聊天';
  }

  @override
  String get aiyaPackNote => '時光包綁定這支手機的帳號，刪除 App 或帳號後無法恢復。';

  @override
  String aiyaPurchased(int n) {
    return '已加入 $n 次聊天 ✨';
  }

  @override
  String get aiyaPurchaseFailed => '購買沒有完成，請再試一次。';

  @override
  String get aiyaStoreUnavailable => '商店暫時連不上，請稍後再試';

  @override
  String get aiyaReport => '檢舉這句話';

  @override
  String get aiyaReported => '已收到檢舉，我們會在 24 小時內處理。';

  @override
  String get aiyaSetting => '艾婭（量子世界的 AI）';

  @override
  String get aiyaSettingSubtitle => '關掉後，量子世界的光柱不再顯示艾婭';

  @override
  String get aiyaCameoHello => '嗨，歡迎來到量子世界。想聊天就點我。';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour 點了。我在光裡陪你。';
  }

  @override
  String get locationPickOnMap => '在地圖上選擇位置';

  @override
  String get locationPickTitle => '選擇你現在的位置';

  @override
  String get locationPickHint => '移動地圖，讓中間的光點對準你現在所在的地方';

  @override
  String get locationPickConfirm => '就是這裡';

  @override
  String get aiyaPackEntry => '＋ 時光包';

  @override
  String get aiyaPacksTitle => '時光包';

  @override
  String get aiyaPacksBody => '每天有 3 次免費聊天；免費次數用完後，才會使用時光包的次數。每次聊天最多 10 分鐘。';

  @override
  String get guideS1L6 =>
      '抓不到位置時（例如在室內，或使用沒有 GPS 的 iPad），可以按「在地圖上選擇位置」：移動地圖，讓中間的光點對準你現在的位置，再按「就是這裡」。之後抓到真實位置，就會自動換過去。';

  @override
  String get guideS17L11 =>
      '量子化身：點左上角的席位代號 →「量子化身」，你的頭像在量子世界裡會變成一顆水晶球。光球、星環兩款免費；彩虹水晶球為一次購買、永久擁有，換手機或重新安裝後可以按「恢復購買」找回。';

  @override
  String get guideS18Title => '14. 艾婭 · AI';

  @override
  String get guideS18L1 =>
      '艾婭是住在量子世界中央光柱裡的 AI，不是真人，她自己也會這樣說。進入量子世界後，點光柱底下的「艾婭 · AI」就能敲門聊天；第一次聊天前要先看完說明並同意。';

  @override
  String get guideS18L2 =>
      '每次聊天最多 10 分鐘、20 則訊息。每天有 3 次免費，台灣時間 00:00 重新計算；每天最多 30 次。';

  @override
  String get guideS18L3 =>
      '時光包：輸入框上方的「＋ 時光包」隨時可以購買 5 次或 20 次聊天，免費次數用完後才會使用。時光包綁定這支手機的帳號，刪除 App 或帳號後無法恢復；它是用完就沒有的消耗型商品，所以沒有「恢復購買」。';

  @override
  String get guideS18L4 =>
      '艾婭不知道、也不會問你的位置與身分，只知道匿名的城市心情統計。她不談戀愛、不聊色情內容，也不提供醫療、法律或財務建議；長按她的回覆可以檢舉。聊天內容只暫存在這次對話，結束後不久就會自動刪除。';

  @override
  String get guideS18L5 =>
      '艾婭偶爾會在光柱裡現身：整點報時、每天第一次進入量子世界，或不經意的偶遇；點她就能開始聊天。不想看到她，可以在設定裡關掉「艾婭（量子世界的 AI）」。';

  @override
  String get orbStyleXmas => '聖誕';

  @override
  String get orbStyleNewYear => '量子跨年';

  @override
  String get orbLimited => '限定款';

  @override
  String orbLimitedUntil(String date) {
    return '限定 · $date 截止';
  }

  @override
  String get aiyaFriendTitle => '艾婭之友';

  @override
  String get aiyaFriendSubtitle => '自動續訂的月費方案';

  @override
  String get aiyaFriendPerk1 => '每天 20 次聊天（免費是 3 次）';

  @override
  String get aiyaFriendPerk2 => '每次聊 20 分鐘或 40 則';

  @override
  String get aiyaFriendPerk3 => '艾婭休息時，也能找她聊';

  @override
  String get aiyaFriendPerk4 => '艾婭換上專屬的「星光」造型（只有你看得到）';

  @override
  String aiyaFriendPrice(String price) {
    return '$price／月';
  }

  @override
  String get aiyaFriendSubscribe => '訂閱';

  @override
  String get aiyaFriendTerms =>
      '訂閱期間為 1 個月，到期時會自動續訂並扣款，除非在到期前至少 24 小時關閉自動續訂。付款由 Apple 或 Google 帳戶處理，可以隨時到帳戶的訂閱設定管理或取消。時光包的次數會保留，每天 20 次用完後才會使用。';

  @override
  String aiyaFriendActive(String date) {
    return '你是艾婭之友，有效到 $date';
  }

  @override
  String get aiyaFriendManage => '管理訂閱';

  @override
  String get aiyaFriendRestore => '恢復購買';

  @override
  String get aiyaFriendWelcome => '你成為艾婭之友了 ✨';

  @override
  String get aiyaFriendRestored => '已恢復艾婭之友';

  @override
  String get aiyaFriendNotFound => '沒有找到有效的艾婭之友訂閱';

  @override
  String get aiyaFriendElsewhere => '這個訂閱已經用在另一個帳號';

  @override
  String get aiyaFriendEntry => '艾婭之友 · 每天 20 次';

  @override
  String aiyaFriendLeft(int n) {
    return '艾婭之友 · 今天還有 $n 次';
  }

  @override
  String get guideS17L12 =>
      '限定款：聖誕水晶球（冬青花圈、會閃的金星、飄雪）賣到 12/25，量子跨年水晶球（金色時鐘刻度、輪流綻開的煙火，跨年那一刻綻開得特別大）賣到 1/1（台灣時間）。過了販售期就不再上架，買過的人永久保留，也可以恢復購買。';

  @override
  String get guideS18L6 =>
      '艾婭之友：在「＋ 時光包」裡選「艾婭之友」，是自動續訂的月費方案。每天 20 次聊天、每次 20 分鐘或 40 則，艾婭休息時也能聊，她還會換上只有你看得到的「星光」造型。每天 20 次用完後才扣時光包。訂閱會自動續訂，可以隨時在 Apple 或 Google 的訂閱設定取消；換手機後按「恢復購買」找回。';

  @override
  String get mapConsentTitle => '要在地圖上顯示你的位置嗎？';

  @override
  String get mapConsentBody =>
      '允許後，每次你自己按下「打卡」或量子世界的「進入」，其他使用者會在地圖上看到你打卡的地方（不是即時位置）、暱稱與心情。不會自動打卡；離開 App 就從地圖上消失。你可以拒絕，也可以隨時在設定關掉。';

  @override
  String get mapConsentAllow => '允許';

  @override
  String get mapConsentDecline => '不允許';

  @override
  String get mapConsentDeclined => '好的，你不會出現在任何人的地圖上。想打卡時再按一次就好。';

  @override
  String get mapConsentSetting => '在地圖上顯示我的位置';

  @override
  String get mapConsentSettingSubtitle => '關掉後立即結束打卡，你不會出現在任何人的地圖上';

  @override
  String get wgErrInGroup => '你已經在一個低語團裡了，先退出才能加入或開新的團。';

  @override
  String get wgErrFull => '這個低語團已經 20 人了，請團主開通 7 天方案就能再加入。';

  @override
  String get wgErrPaidFull => '這個低語團已經滿 100 人了。';

  @override
  String get wgErrQr => '這個 QR code 已經換新了，請團主給你新的。';

  @override
  String get wgErrEnded => '這個低語團已經結束或不存在。';

  @override
  String get wgErrFiltered => '內容包含不適當的字詞，請修改後再送出。';

  @override
  String get wgErrHostLeave => '團主不能直接退出，請先交棒給團員或解散低語團。';

  @override
  String get wgErrBusy => '暫時連不上，請稍後再試。';

  @override
  String get wgErrName => '請幫低語團取個名字。';

  @override
  String get wgPassUnavailable => '商店暫時無法購買，請稍後再試。';

  @override
  String get wgPassFailed => '購買沒有完成，請再試一次。';

  @override
  String get wgPassDone => '已開通 7 天方案，這個低語團最多可以 100 人。';

  @override
  String get wgCreateTitle => '開一個低語團';

  @override
  String get wgCreateBody => '私人的團體：只有拿到你的 QR code 的人才能加入。可以集合、點名、放集合點。';

  @override
  String get wgNameLabel => '團名';

  @override
  String get wgColorLabel => '團色';

  @override
  String wgDaysLabel(int n) {
    return '行程 $n 天（含今天）';
  }

  @override
  String get wgFreeNote => '20 人以內免費；超過 20 人時，團主開通 7 天方案就能到 100 人。';

  @override
  String get wgCreateButton => '開團';

  @override
  String wgJoined(String name, int no) {
    return '已加入「$name」，你是 $no 號';
  }

  @override
  String get wgJoinTitle => '加入低語團';

  @override
  String get wgJoinBody => '用手機相機掃團主的 QR code 最快；也可以輸入 8 碼團代碼。';

  @override
  String get wgJoinButton => '加入';

  @override
  String wgButtonLabel(String name) {
    return '低語團 $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n／$limit 人';
  }

  @override
  String wgUntil(String date) {
    return '到 $date';
  }

  @override
  String wgMyNo(int n) {
    return '我是 $n 號';
  }

  @override
  String get wgCallButton => '集合';

  @override
  String get wgCallDone => '人齊了，結束集合';

  @override
  String get wgRollButton => '點名';

  @override
  String wgRollSummary(int here, int total) {
    return '點名：到了 $here／$total';
  }

  @override
  String wgMembersTitle(int n) {
    return '團員 $n 人（點一下可以備註、交棒或移除）';
  }

  @override
  String get wgNoMembers => '還沒有團員，按「QR code」讓大家掃描加入。';

  @override
  String get wgQrButton => 'QR code';

  @override
  String get wgDissolveAsk => '要解散這個低語團嗎？所有團員會收到通知，名單與紀錄會全部刪除。';

  @override
  String get wgDissolve => '解散';

  @override
  String wgCallIn(int n) {
    return '$n 分鐘後集合';
  }

  @override
  String get wgCallNow => '現在集合';

  @override
  String wgAckSummary(int acked, int total) {
    return '收到 $acked／$total';
  }

  @override
  String get wgAnswerHere => '我到了';

  @override
  String get wgAnswer5min => '還要 5 分鐘';

  @override
  String get wgAnswerHelp => '需要幫忙';

  @override
  String get wgNoReply => '沒回';

  @override
  String get wgStateAck => '收到';

  @override
  String get wgStateSeen => '看了沒回';

  @override
  String get wgStateNone => '沒反應';

  @override
  String get wgPassTitle => '低語團 7 天方案';

  @override
  String get wgPassBody => '20 人以內免費。開通後這個團最多 100 人，直到低語團結束；一次購買只用在這一團，不會自動續費。';

  @override
  String get wgPassButton => '開通 7 天方案';

  @override
  String wgHostIs(String name) {
    return '團主：$name';
  }

  @override
  String get wgNoCall => '目前沒有集合呼叫。團主一按「集合」，你的手機就會響。';

  @override
  String get wgRollAsk => '團主在點名';

  @override
  String get wgLeaveAsk => '要退出這個低語團嗎？';

  @override
  String get wgLeave => '退出低語團';

  @override
  String get wgCallTitle => '集合！';

  @override
  String get wgAcked => '✓ 已經告訴團主你收到了';

  @override
  String get wgAckButton => '收到';

  @override
  String get wgCallSheetTitle => '集合呼叫';

  @override
  String get wgNow => '現在';

  @override
  String wgInMinutes(int n) {
    return '$n 分鐘後';
  }

  @override
  String get wgPlaceLabel => '集合點說明';

  @override
  String get wgPlaceHint => '例如：捷運西門站 6 號出口';

  @override
  String get wgPlaceNote => '集合點會放在你現在的位置，團員看得到距離與方向。';

  @override
  String get wgSendCall => '送出集合呼叫';

  @override
  String get wgNoLocation => '抓不到你的位置，沒辦法放集合點。';

  @override
  String get wgQrTitle => '讓大家掃描加入';

  @override
  String get wgQrBody => '用手機相機掃描就能加入；也可以輸入下面的團代碼。';

  @override
  String wgShareText(String name, String url) {
    return '加入我的低語團「$name」：$url';
  }

  @override
  String get wgShare => '分享連結';

  @override
  String get wgRotateAsk => '要換新 QR code 嗎？舊的 QR code 和連結會立即失效。';

  @override
  String get wgRotate => '換新 QR code';

  @override
  String wgMemberTitle(int no) {
    return '$no 號';
  }

  @override
  String get wgEditNote => '備註';

  @override
  String get wgHandoff => '交棒給他當團主';

  @override
  String wgHandoffAsk(int no) {
    return '要把團主交給 $no 號嗎？你會變成團員。';
  }

  @override
  String get wgKick => '移出低語團';

  @override
  String wgKickAsk(int no) {
    return '要把 $no 號移出低語團嗎？';
  }

  @override
  String get wgNotePrivate => '備註只有你看得到，例如名字或房號。';

  @override
  String get wgSave => '儲存';

  @override
  String get wgConfirm => '確定';

  @override
  String get wgCancel => '取消';

  @override
  String get wgSettingCreate => '開一個低語團';

  @override
  String get wgSettingCreateSub => '私人團體：旅行、校外教學、登山、出遊時集合與點名';

  @override
  String get wgSettingJoin => '加入低語團';

  @override
  String get wgSettingJoinSub => '輸入團主給你的 8 碼團代碼';

  @override
  String wgSettingOpen(String name) {
    return '我的低語團：$name';
  }

  @override
  String get wgChannelName => '低語團集合';

  @override
  String get wgChannelDesc => '團主按下「集合」時的提醒';

  @override
  String get guideS19Title => '15. 低語團';

  @override
  String get guideS19L1 =>
      '低語團是私人的團體，適合旅行、校外教學、登山、出遊或活動工作人員。設定 → 集會 →「開一個低語團」，取團名、選團色和天數（最長 7 天）就開好了。';

  @override
  String get guideS19L2 =>
      '入團：團主按地圖下方的低語團按鈕 →「QR code」，團員用手機相機掃描就會打開 App 加入；也可以在設定 → 集會 →「加入低語團」輸入 8 碼團代碼。外人無法搜尋或申請，團主可以隨時換新 QR code。';

  @override
  String get guideS19L3 =>
      '集合：團主按「集合」，選時間、寫集合點說明，團員的手機會響專屬音效並震動「短短長」，打開 App 會看到倒數、集合點的距離與方向，以及地圖上的團色光柱。沒按「收到」的人每分鐘再提醒一次，最多 3 次；團主看得到誰收到、誰看了沒回、誰沒反應。';

  @override
  String get guideS19L4 =>
      '點名：團主按「點名」，團員一樣會收到音效與震動，按「我到了」「還要 5 分鐘」或「需要幫忙」。團主看不到團員的位置，只看得到大家的回覆。';

  @override
  String get guideS19L5 =>
      '20 人以內免費；超過 20 人時，團主可以購買「低語團 7 天方案」，這個團最多 100 人，直到結束。團員永遠免費。低語團最長 7 天，到期或團主解散後，名單與紀錄全部刪除。';

  @override
  String get wgFlagButton => '舉旗';

  @override
  String get wgFlagHost => '團主';

  @override
  String get wgFlagHint => '舉起手機，讓大家在人群裡找到你。點一下關閉。';

  @override
  String get wgLostButton => '我迷路了';

  @override
  String get wgFound => '我找到團了';

  @override
  String get wgLostSent => '已把位置傳給團主，原地等一下或往集合點走。';

  @override
  String get wgLostTitleAsk => '傳位置給團主？';

  @override
  String get wgLostAsk =>
      '會把你此刻的位置傳一次給團主，團主的手機會響起提醒，地圖上也會出現你的位置。只傳這一次，不會持續追蹤；30 分鐘後自動刪除，找到團也可以按「我找到團了」取消。';

  @override
  String get wgLostSend => '傳送我的位置';

  @override
  String wgLostTitle(int n) {
    return '迷路的團員 $n 人';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n 分鐘前';
  }

  @override
  String get wgNavigate => '導航過去';

  @override
  String get wgFoundThem => '找到了';

  @override
  String get guideS19L6 =>
      '找人：在人群裡找不到彼此時，按「舉旗」，整個螢幕會變成團色並閃爍、顯示你的團號，舉起來讓大家看到。真的走散了，團員可以按「我迷路了」，把此刻的位置傳一次給團主（只傳這一次，30 分鐘後刪除），團主的手機會響起提醒，地圖上出現紅色圖釘，可以直接導航過去。';

  @override
  String wgLostAlert(int no) {
    return '$no 號迷路了';
  }

  @override
  String wgHelpAlert(String no) {
    return '$no 號需要幫忙';
  }

  @override
  String get wgViewList => '查看低語團';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour 點了。還醒著的人，我在光裡陪你。';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour 點了，早安。今天也慢慢來。';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour 點了。今晚的城市，你好嗎？';
  }

  @override
  String get aiyaCameoNyReady => '準備好了嗎？我們一起倒數！';

  @override
  String aiyaCameoNewYear(int year) {
    return '新年快樂！$year，我們在同一個房間。';
  }

  @override
  String get aiyaSkinEntry => '✦ 造型';

  @override
  String get aiyaSkinTitle => '艾婭的造型';

  @override
  String get aiyaSkinSubtitle => '只有你看得到自己的艾婭換造型';

  @override
  String get aiyaSkinNone => '原本的艾婭';

  @override
  String get aiyaSkinStarlight => '星光';

  @override
  String get aiyaSkinStarlightSub => '艾婭之友專屬';

  @override
  String get aiyaSkinXmas => '聖誕';

  @override
  String get aiyaSkinNewYear => '量子跨年';

  @override
  String get aiyaSkinNote => '節日造型是一次購買、永久擁有，只改變艾婭的樣子，不影響聊天次數。限定款過了販售期就不再上架。';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get checkInEnter => '在这里打卡，走进城市';

  @override
  String get checkInNote => '按下后，附近的人会看到你此刻的心情与大概的位置。每次进入都要自己打卡。';

  @override
  String get checkInTitle => '打卡，走进城市';

  @override
  String get checkInBody =>
      '打卡后，附近的人才看得到你此刻的心情与大概的位置，你也会看到他们。别人看到的是你打卡的地方，不会跟着你移动。每次打开 App 都要自己打卡，不会自动打卡。离开或切到其他 App，打卡就会结束。';

  @override
  String get checkInButton => '在这里打卡';

  @override
  String get checkInAgain => '你离开打卡的地方了 · 在这里重新打卡';

  @override
  String get checkOutButton => '打卡中 · 结束打卡';

  @override
  String get checkedOutToast => '已结束打卡，你已经从地图上消失。';

  @override
  String get appName => '城市低语';

  @override
  String get moodJoy => '开心';

  @override
  String get moodSad => '难过';

  @override
  String get moodAngry => '生气';

  @override
  String get moodCalm => '平静';

  @override
  String get moodPassion => '热情';

  @override
  String get moodLove => '爱';

  @override
  String get moodOther => '其他';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name 已结束';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return '你已把 $emoji $name 交棒，现在是参加者。';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return '你已交棒。昵称已满 10 个字，请自己把 $emoji 加进昵称，才能继续收到公告。';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return '你已交棒，昵称补上了 $emoji，你现在是参加者。';
  }

  @override
  String get gotIt => '我知道了';

  @override
  String get blockedToast => '已将此人没入黑暗。';

  @override
  String get unblockedToast => '已解除屏蔽，城市再次产生交集。';

  @override
  String notificationToast(String title, String body) {
    return '$title：$body';
  }

  @override
  String get locationServiceOffTitle => '请开启定位服务';

  @override
  String get locationServiceOffBody =>
      '城市低语需要知道你在城市的哪个角落，才能让附近的人看见你的心情。请到手机的「设置」开启「定位服务」。';

  @override
  String get locationReducedTitle => '请开启「精确位置」';

  @override
  String get locationReducedBodyIos =>
      '你目前只分享了大概的位置，雷达无法判断谁在你附近。请到「设置」›「城市低语」›「位置」，打开「精确位置」。';

  @override
  String get locationReducedBodyAndroid =>
      '你目前只分享了大概的位置，雷达无法判断谁在你附近。请在位置权限中选择「精确」。';

  @override
  String get locationNoFixTitle => '暂时获取不到你的位置';

  @override
  String get locationNoFixBody => '可能在室内或信号较弱。请到窗边或户外、开启 Wi-Fi 后再试一次。';

  @override
  String get locationNeededTitle => '需要使用你的位置';

  @override
  String get locationNeededBody =>
      '城市低语只在你使用 App 时获取位置，用来显示附近 5 公里内的心情；雷达上只显示大概的距离，不会显示地址。\n请在设置中允许「使用 App 期间」访问位置，并开启「精确位置」。';

  @override
  String get locationSimulatorHint => '（开发提示：模拟器请在 Features › Location 选一个位置）';

  @override
  String get openSettings => '前往设置';

  @override
  String get locationRecheck => '我已开启，重新检查';

  @override
  String get tryAgain => '再试一次';

  @override
  String get leaveApp => '离开';

  @override
  String whispersNearby(int count) {
    return '你附近有 $count 则低语，点信封读读看。';
  }

  @override
  String get whisperPassed => '你经过了一则低语，点信封读读看。';

  @override
  String get whisperLeft => '你的低语留在这里了，7 天后消散。';

  @override
  String get timeWhisperSealedYear => '已封存。一年后，回到这里就能打开。';

  @override
  String get timeWhisperSealedMonth => '已封存。一个月后，回到这里就能打开。';

  @override
  String get whisperWithdrawn => '低语已经收回。';

  @override
  String get whisperMineLabel => '你留下的低语';

  @override
  String get whisperTapToRead => '一则低语，点一下阅读';

  @override
  String get noMoodYet => '无言中...';

  @override
  String get knockWithdrawnByLeaving => '对方已没入城市，悄悄收回敲门声…';

  @override
  String get knockCardTitle => '片刻交集';

  @override
  String knockCardBody(String name) {
    return '$name 正在敲门，\n想与你产生交集…';
  }

  @override
  String get skip => '略过';

  @override
  String get decline => '婉拒';

  @override
  String get accept => '同意';

  @override
  String get reportThisPerson => '举报这个人';

  @override
  String get cityQuietTonight => '今晚的城市还很安静';

  @override
  String cityMoodChip(String mood, String percent) {
    return '今晚的城市 · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text，查看城市心情天气';
  }

  @override
  String get cityMoodTitle => '今晚的城市心情';

  @override
  String cityMoodQuietCount(int total) {
    return '城市还很安静，今晚有 $total 个人留下心情。';
  }

  @override
  String cityMoodCount(int total) {
    return '20 公里内，今晚有 $total 个人留下心情';
  }

  @override
  String get cityMoodQuietInvite => '多一点心情，城市就多一点光。写下此刻的你，成为点亮城市的人。';

  @override
  String get cityMoodFootnote => '匿名统计 24 小时内的心情；少于 10 人时不显示比例。';

  @override
  String get close => '关闭';

  @override
  String get emptyRadarTitle => '你是今晚第一道光';

  @override
  String get emptyRadarBody =>
      '附近还没有人。你的心情已经在城市里发光，\n有人经过时，就会看见你。也可以留一则低语，给下一个经过这里的人。';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '今晚城市里有 $total 个人，多半感到「$mood」';
  }

  @override
  String get inviteFriends => '邀请朋友点亮街区';

  @override
  String get shareMoodCard => '分享我的心情卡';

  @override
  String get editYourMood => '编辑你的心情';

  @override
  String resonanceTonight(int count) {
    return '今晚 $count 道微光与你共鸣';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · 你的心情';
  }

  @override
  String get dockTapToEdit => '你的心情 · 点一下修改';

  @override
  String get leaveWhisper => '留下一则低语';

  @override
  String get settings => '设置';

  @override
  String get nightlyReminder => '每晚提醒';

  @override
  String get nightlyReminderSubtitle => '每晚 21:30 一则温和的提醒';

  @override
  String get closeSettings => '关闭设置';

  @override
  String get settingsSectionMe => '我';

  @override
  String get editProfile => '编辑个人状态';

  @override
  String get editProfileSubtitle => '头像、城市昵称与心情';

  @override
  String get manageBlockList => '管理屏蔽名单';

  @override
  String get manageBlockListSubtitle => '查看或解除被你没入黑暗的人';

  @override
  String get myTimeWhispers => '我的低语穿越';

  @override
  String get myTimeWhispersSubtitle => '写给未来的自己，只有你看得到';

  @override
  String get myMoodTrail => '我的心情轨迹';

  @override
  String get myMoodTrailSubtitle => '只存在你的手机上';

  @override
  String get settingsSectionGatherings => '集会';

  @override
  String get gatheringHost => '集会主持人';

  @override
  String get gatheringHostSubtitle => '以你为中心 5 公里，开一场活动';

  @override
  String gatheringHosting(String emoji, String name) {
    return '你正在主持 $emoji $name';
  }

  @override
  String get settingsSectionShare => '分享';

  @override
  String get shareMoodCardSubtitle => '十一张夜景插画随机出现，适合 IG 快拍';

  @override
  String get inviteFriendsSubtitle => '附近的人越多，城市越亮';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get guide => '使用说明';

  @override
  String get guideSubtitle => '从写下心情到开一场集会，一次看懂';

  @override
  String get termsOfUse => '使用条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get contactUs => '联系我们';

  @override
  String get deleteAccount => '删除账号与数据';

  @override
  String get deleteAccountSubtitle => '永久抹除你在城市留下的一切';

  @override
  String get avatarUploadFailed => '头像上传失败，请稍后再试。';

  @override
  String get moodEmpty => '心情不能为空，给城市留下点微光吧。';

  @override
  String get profileSyncFailed => '状态同步失败，请稍后再试。';

  @override
  String get profileUpdated => '状态已更新，城市正感知你的呼吸。';

  @override
  String get changeAvatar => '更换头像';

  @override
  String get avatarHint => '轻触更换头像 · 光环是你的心情色';

  @override
  String get cityName => '城市昵称';

  @override
  String get cityNameHint => '选填，例如：游荡的猫';

  @override
  String get currentMood => '当下心情';

  @override
  String get currentMoodHint => '例如：漫步在微雨中 🌿';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get blockListTitle => '沉入黑暗的名单';

  @override
  String get blockListEmpty => '夜色清朗，你的城市未曾放逐任何人。';

  @override
  String get unblock => '解除放逐';

  @override
  String get deleteAccountBody =>
      '你的位置、心情、城市昵称、头像、留下的低语、微光、屏蔽名单与进行中的对话都会被永久删除，无法恢复。\n\n为了防止滥用，举报记录会依隐私政策保留 1 年。';

  @override
  String get deleting => '删除中…';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get deleteFailed => '删除没有完成，请检查网络后再试一次。';

  @override
  String get fadingEcho => '历史残影';

  @override
  String clusterCount(int count) {
    return '这里有 $count 个心情';
  }

  @override
  String clusterMore(int count) {
    return '更多\n+$count';
  }

  @override
  String get clusterBackToFirst => '回到\n第一批';

  @override
  String get fadingEchoTitle => '一道历史残影';

  @override
  String encounterWith(String name) {
    return '与 $name 的相遇';
  }

  @override
  String get fadingEchoBody => '这只是一道历史残影，无法产生交集。';

  @override
  String get demoPersonBody => '这是示范对象，由程序自动回应，不是真人。可以用它体验敲门、聊天、微光、举报与屏蔽。';

  @override
  String get sendGlimmer => '送出一道微光 (共鸣)';

  @override
  String get knock => '敲门 (产生交集)';

  @override
  String get blockAction => '屏蔽 (没入黑暗)';

  @override
  String get handOverHost => '转移主持人';

  @override
  String get report => '举报';

  @override
  String get confirmBlockTitle => '确认屏蔽';

  @override
  String confirmBlockBody(String name) {
    return '确定要将 $name 没入黑暗吗？\n屏蔽后，双方将从彼此的城市中消失。';
  }

  @override
  String get confirmBlock => '确定屏蔽';

  @override
  String get glimmerReceived => '有人送你一道微光，与你的心情共鸣。';

  @override
  String get glimmerSent => '你送出了一道微光。';

  @override
  String get glimmerAlreadySent => '今天已经送过微光给对方了，明天再来吧。';

  @override
  String get knockSent => '敲门声已送出，等待回音…';

  @override
  String get knockFailed => '敲门没有送出，请稍后再试。';

  @override
  String get knockNoAnswer => '没有回音，敲门声悄悄消散了。';

  @override
  String get knockDeclined => '这次没有交集，让彼此保留一点空间。';

  @override
  String get knockSkipped => '对方先略过了，敲门声悄悄消散。';

  @override
  String get sensingCity => '正在感知这座城市...';

  @override
  String get sensingCityHint => '如果你的城市此刻太安静，可以走进“平行宇宙”或“量子世界”，和其他城市的人相遇。';

  @override
  String get gatheringUnavailable => '活动功能暂时无法使用，请稍后再试。';

  @override
  String get notSentCheckNetwork => '没有送出，请检查网络后再试一次。';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String get nextDayPrefix => '隔天 ';

  @override
  String get gatheringNameMissing => '请帮活动取个名字。';

  @override
  String get gatheringEmojiInvalid => '活动图标要刚好是一个表情符号。';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name 开始了。请参加的人把 $emoji 加进城市昵称。';
  }

  @override
  String get startGatheringTitle => '开一场集会';

  @override
  String get startGatheringLead => '以你的位置为中心 5 公里。你走到哪，范围就跟到哪。';

  @override
  String get gatheringNameHint => '活动名称，例如：滨海湾跨年烟火';

  @override
  String get gatheringEmojiHint => '图标';

  @override
  String get gatheringEmojiHelp => '活动图标：一个表情符号。附近没人在用才能选。';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return '参加的人把 $emoji 加进自己的城市昵称，就会看到你的公告、收到推送。';
  }

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get gatheringMaxDuration => '整场最长 24 小时，时间到自动结束。';

  @override
  String get starting => '开始中…';

  @override
  String get startGathering => '开始活动';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name 已结束，你回到了城市里。';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · 你正在主持';
  }

  @override
  String hostAudienceRule(String emoji) {
    return '5 公里内、昵称里有 $emoji 的人会看到公告并收到推送。你看不到他们是谁。';
  }

  @override
  String get postAnnouncement => '发布公告';

  @override
  String get announcementHint => '例如：队伍在地铁站 A 出口集合';

  @override
  String get announcementSent => '公告已送出';

  @override
  String announcementLine(String ago, String text) {
    return '$ago　$text';
  }

  @override
  String get announcementHiddenSuffix => '（已因多人举报隐藏）';

  @override
  String get groupQuestion => '全场提问';

  @override
  String get questionHint => '例如：此刻的你？';

  @override
  String get sendQuestion => '送出提问';

  @override
  String get questionSent => '提问已送出，大家会用心情回答';

  @override
  String get handOff => '交棒';

  @override
  String handoffPending(String name) {
    return '已邀请 $name 接下主持，等待回复中…';
  }

  @override
  String get theOtherPerson => '对方';

  @override
  String get handoffCancelled => '已取消交棒邀请';

  @override
  String get handoffHelp => '长按雷达上参加者的气泡 →「转移主持人」，对方同意后就由他主持，活动与公告都不会中断。';

  @override
  String get confirmEndAgain => '确定结束？再按一次';

  @override
  String get endGathering => '结束活动';

  @override
  String tallyHeader(String question, int total) {
    return '「$question」· $total 人回答';
  }

  @override
  String get tallyQuiet => '满 10 人回答才显示比例，避免人少时猜得出是谁。';

  @override
  String get bannerYouHost => '  · 你正在主持';

  @override
  String get bannerHostAnnouncement => '  · 主持人公告';

  @override
  String get manageGathering => '管理活动';

  @override
  String get reportAnnouncement => '举报这则公告';

  @override
  String get expandAnnouncement => '展开公告';

  @override
  String get collapseAnnouncement => '收起公告';

  @override
  String hostHandedOffAgo(String ago) {
    return '主持人已交棒 · $ago';
  }

  @override
  String get announcementReportedHidden => '你举报了这则公告，已从你的画面移除。';

  @override
  String get noAnnouncementHost => '还没有公告。按右上角的调整钮发布第一则。';

  @override
  String get noAnnouncementGuest => '主持人还没有发公告。';

  @override
  String hostAsks(String question) {
    return '主持人问：$question';
  }

  @override
  String get answeredNote => '已回答。主持人只会看到全场的心情比例。';

  @override
  String get answerHint => '用一句心情回答';

  @override
  String get sendAnswer => '送出回答';

  @override
  String handoffInvited(String name) {
    return '已邀请 $name 接下主持，等对方回复（5 分钟内有效）。';
  }

  @override
  String handoffTitle(String name) {
    return '把活动交给 $name';
  }

  @override
  String get handoffBody => '对方同意后，由他主持这场活动；名称、公告与提问都会留着。你会变回参加者。';

  @override
  String get handoffPublic => '公开交棒';

  @override
  String get handoffPublicHelp => '通知所有参加者「主持人已交棒」';

  @override
  String get handoffQuiet => '安静交棒';

  @override
  String get handoffQuietHelp => '不通知任何人，只有雷达上的「主持」光环换人';

  @override
  String get sending => '送出中…';

  @override
  String get sendInvite => '送出邀请';

  @override
  String youAreNowHost(String emoji, String name) {
    return '你现在是 $emoji $name 的主持人。';
  }

  @override
  String get handoffOfferTitle => '想请你接下主持';

  @override
  String handoffOfferBody(String name) {
    return '主持人想把「$name」交给你。接下后，你可以发公告、提问与结束活动，也要对公告内容负责。';
  }

  @override
  String get processing => '处理中…';

  @override
  String get acceptHosting => '接下主持';

  @override
  String get guideS1Title => '1. 走进城市';

  @override
  String get guideS1L1 =>
      '第一次打开时，请确认你已年满 18 岁，并允许「使用 App 时」获取精确位置；没有精确位置，雷达无法运作。';

  @override
  String get guideS1L2 =>
      '写下一句此刻的心情（最多 20 个字），勾选同意《使用条款》与《隐私政策》，按「在这里打卡，走进城市」。';

  @override
  String get guideS1L3 => '不需要手机号码、Email 或真名。账号是匿名的，绑定在这台手机上。';

  @override
  String get guideS1L4 =>
      '心情的颜色由字里的关键字决定：「开心、笑」金黄，「难过、哭」蓝，「生气、怒」橘红，「平静、发呆」绿，「热情」橘，「爱、心」粉红，其他是淡紫。';

  @override
  String get guideS1L5 =>
      '打卡：每次打开 App 都要自己按下打卡，附近的人才看得到你的心情与大概的位置，你也才看得到他们；不会自动打卡。别人看到的是你打卡的地方，不会跟着你移动。走离打卡的地方超过 1 公里，雷达下方会出现「在这里重新打卡」；App 在后台超过 30 分钟，回来时也要重新打卡。';

  @override
  String get guideS2Title => '2. 底部菜单';

  @override
  String get guideS2L1 => '点左边自己的头像：编辑头像、城市昵称（最多 10 个字）与心情。';

  @override
  String get guideS2L2 => '笔记图标：在这里留下一则低语。';

  @override
  String get guideS2L3 => '分享图标：把此刻的心情做成一张夜景卡片。';

  @override
  String get guideS2L4 => '最右边的调整图标：打开设置。';

  @override
  String get guideS3Title => '3. 雷达与气泡';

  @override
  String get guideS3L1 => '雷达上会浮现 5 公里内其他人的心情气泡，只显示分级的距离（例如「100m 内」），不显示地址。';

  @override
  String get guideS3L2 => '雷达上只会出现此刻打卡、开着 App 的人；对方离开或切到其他 App，气泡就会立刻消失，不留残影。';

  @override
  String get guideS3L3 => '双指可以放大缩小地图。转动手机，雷达会跟着你面向的方向转。';

  @override
  String get guideS3L4 =>
      '气泡太密集时会合成一颗光球「这里有 N 个心情」，点一下就展开成一圈，每颗都点得到；点中间或空白处收起。';

  @override
  String get guideS3L5 => '名字前有「示范」的是示范对象，由程序自动回应，不是真人，可以用来体验所有功能。';

  @override
  String get guideS3L6 => '附近都没有人时，画面下方会出现「你是今晚第一道光」，可以邀请朋友一起点亮街区。';

  @override
  String get guideS4Title => '4. 敲门与聊天';

  @override
  String get guideS4L1 =>
      '长按别人的气泡 →「敲门」。对方有 5 分钟可以回应：同意、婉拒或略过。等待时，你会看到一道光从你流向对方。';

  @override
  String get guideS4L2 => '对方同意后开始对话，倒数 10 分钟；任何一方发新消息就重新倒数，安静下来就结束。';

  @override
  String get guideS4L3 => '对话结束后，消息会从服务器删除。对方仍可能截图，请斟酌分享的内容。';

  @override
  String get guideS4L4 => '有人敲你的门时，会跳出敲门卡片，可以同意、婉拒、略过，或直接举报。';

  @override
  String get guideS5Title => '5. 微光';

  @override
  String get guideS5L1 => '双击别人的气泡，或长按选「送出一道微光」，让对方知道有人看见了，不需要开口。';

  @override
  String get guideS5L2 => '对方只会看到「今晚 N 道微光与你共鸣」，永远不知道是谁送的。同一个人 24 小时内只能送一次。';

  @override
  String get guideS6Title => '6. 低语';

  @override
  String get guideS6L1 => '按底部菜单的笔记图标，在你所在的地方留下一句话（最多 60 个字）。';

  @override
  String get guideS6L2 => '接下来 7 天，经过那一带 300 米内的人会在雷达上看到信封，打开就能读到。';

  @override
  String get guideS6L3 => '低语永远匿名；每人同时最多留 3 则、每 10 分钟最多 1 则，可以随时收回。';

  @override
  String get guideS6L4 =>
      '低语穿越：写低语时选「寄给未来的自己」，再选一个月后或一年后。只有你看得到；时间到了会通知你，回到那里 100 米内就会自动打开，读过一次就会消失。雷达上只有你看得到一个小沙漏（上锁／解锁），不能点。每人同时最多 5 封，设置 →「我的低语穿越」可以查看或删除。';

  @override
  String get guideS7Title => '7. 城市心情天气';

  @override
  String get guideS7L1 => '左上角的标签显示 20 公里内、24 小时内大家最多的心情；点一下看完整比例。';

  @override
  String get guideS7L2 => '少于 10 人时不显示比例，避免猜得出是谁。';

  @override
  String get guideS8Title => '8. 集会';

  @override
  String get guideS8L1 =>
      '开活动：设置 → 集会主持人 → 填活动名称、一个表情符号当图标、开始与结束时间（最长 24 小时）→ 开始活动。';

  @override
  String get guideS8L2 =>
      '范围是以主持人打卡的地方为中心 5 公里；主持人重新打卡，范围就跟着移动。主持人在雷达上有一圈光环和「主持」标示。';

  @override
  String get guideS8L3 => '主持人可以发公告（不限次数）、提出全场提问，也可以随时结束活动。';

  @override
  String get guideS8L4 =>
      '参加：把活动的图标加进你的城市昵称（例如「游荡的猫🌈」），人在范围内就会看到雷达上方的置顶公告，并收到推送。把图标移除就退出。';

  @override
  String get guideS8L5 =>
      '全场提问：用一句心情回答；主持人只看得到全场的心情比例，看不到谁回答了什么，少于 10 人时不显示比例。';

  @override
  String get guideS8L6 => '同一个图标在同一区域同时只能有一场活动；活动结束后，任何人都可以用。';

  @override
  String get guideS8L7 =>
      '交棒：主持人长按某位参加者的气泡 →「转移主持人」，选公开交棒（通知所有人）或安静交棒（不通知），对方 5 分钟内同意就由他主持，公告与提问都会留着；原主持人变回参加者，昵称会自动补上图标。';

  @override
  String get guideS9Title => '9. 城市灯塔（友善厕所）';

  @override
  String get guideS9L1 =>
      '点地图左下角的厕所图标打开灯塔，雷达上会出现 2 公里内的性别友善、无障碍与亲子厕所，图标旁会显示数量；可以再点上方的三个圆形筛选，只看其中几种。';

  @override
  String get guideS9L2 => '点一下标记可以看楼层、设施与距离，按「走路过去」用手机的地图 App 导航。';

  @override
  String get guideS9L3 => '数据来自台湾环境部「全国公厕建档资料」，每月更新；没有开放时间，「晚上可能有开」是依场所推估的。';

  @override
  String get guideS9L4 => '数据不对时可以回报（不是性别友善、晚上没开、找不到）；同一种问题有 3 个人回报，标记会变灰并注明。';

  @override
  String get guideS10Title => '11. 心情卡与心情轨迹';

  @override
  String get guideS10L1 => '底部菜单的分享钮可以把此刻的心情做成一张夜景卡片，适合 IG 快拍；卡片上不会有你的位置。';

  @override
  String get guideS10L2 => '设置 →「我的心情轨迹」可以回顾你写过的心情与地点，数据只存在你的手机上，可以随时关闭或清除。';

  @override
  String get guideS11Title => '17. 设置与通知';

  @override
  String get guideS11L1 => '「每晚提醒」：每天 21:30 一则温和的提醒，可以在设置里开关。';

  @override
  String get guideS11L2 => '敲门、新消息、微光与集会公告会以推送通知你；可以在手机的系统设置里关闭。';

  @override
  String get guideS11L3 => '每周五 21:00–23:00 是「点亮之夜」，大家一起上线，城市最亮。';

  @override
  String get guideS12Title => '18. 举报与屏蔽';

  @override
  String get guideS12L1 =>
      '长按气泡、敲门卡片、聊天室右上角、低语与集会公告都可以举报。举报后，那个人或那则内容会立刻从你的画面消失，聊天室也会立即结束；我们会在 24 小时内处理。';

  @override
  String get guideS12L2 => '心情、昵称、低语、聊天消息与集会公告都会自动过滤不当字词、电话与网址等联系方式。';

  @override
  String get guideS12L3 => '屏蔽后，双方会从彼此的雷达上消失，也不能再敲门或送微光。设置 →「管理屏蔽名单」可以解除。';

  @override
  String get guideS12L4 => '遇到紧急危险，请直接拨打当地的紧急电话（台湾为 110）。';

  @override
  String get guideS13Title => '19. 隐私与账号';

  @override
  String get guideS13L1 =>
      '只有在你打卡之后，附近的人才看得到你的心情、城市称呼、头像与大概的距离；他们看到的是你打卡的地方，不是实时位置。';

  @override
  String get guideS13L2 => '设置 →「删除账号与数据」可以随时永久删除你在城市留下的一切。';

  @override
  String get guideS13L3 => '有任何问题，设置 →「联系我们」或写信到 service.softchip@gmail.com。';

  @override
  String get guideS14Title => '12. 平行宇宙';

  @override
  String get guideS14L1 => '点雷达右上角的地球图标开启，再点一次关闭。每次打开 App 都是关闭的。';

  @override
  String get guideS14L2 =>
      '台湾各县市以各自的中央车站为中心（例如大台北是台北车站、桃园是桃园车站），对应到国外的城市：日本、韩国、香港、澳门、新加坡、马来西亚、印尼、越南、泰国、菲律宾与澳大利亚；国外的城市则对应到台湾。';

  @override
  String get guideS14L3 =>
      '你离车站往哪个方向、多远，在对方的城市就出现在离对方车站同样方向、同样距离的地方，并模糊到约 500 米，没有人看得到你的真实位置。';

  @override
  String get guideS14L4 =>
      '只要你或对方其中一方开启就看得到：你开启时，看得到对方城市所有正开着 App 的人；你没开时，只看得到有开启的人。只有已打卡、正开着 App 的人会出现在其他城市。';

  @override
  String get guideS14L5 =>
      '平行宇宙的人有虚线光环，并标示所在的城市；一样可以送微光、敲门和聊天。低语、低语穿越与集会都只留在当地。';

  @override
  String get guideS15Title => '16. 翻译';

  @override
  String get guideS15L1 => '聊天时，对方的消息跟你的语言不同，下方会出现「点一下翻译」；点一下就翻成你的语言，再点一下看原文。';

  @override
  String get guideS15L2 => '雷达上的心情气泡也一样：跟你的语言不同时，点一下就翻译，再点一下回到原文。';

  @override
  String get guideS15L3 =>
      '翻译完全在手机上进行，文字不会上传。iPhone 使用 Apple 内置的翻译，第一次翻某种语言时系统会问你要不要下载；Android 使用 Google ML Kit，第一次会先问你，再下载约 30 MB 的语言模型。iPhone 暂时无法翻译马来文。';

  @override
  String get guideIntro => '城市低语是一座夜里的城市：写下一句此刻的心情，看见附近的人此刻的感受。';

  @override
  String get beaconGender => '性别友善';

  @override
  String get beaconAccessible => '无障碍';

  @override
  String get beaconFamily => '亲子';

  @override
  String get beaconReportNotGender => '不是性别友善';

  @override
  String get beaconReportClosed => '晚上没开';

  @override
  String get beaconReportMissing => '找不到这间厕所';

  @override
  String get beaconFlagNotGender => '有人回报：不是性别友善';

  @override
  String get beaconFlagClosed => '有人回报：晚上没开';

  @override
  String get beaconFlagMissing => '有人回报：找不到';

  @override
  String get beaconDefaultName => '公厕';

  @override
  String meters(int m) {
    return '$m 米';
  }

  @override
  String kilometers(String km) {
    return '$km 公里';
  }

  @override
  String get beaconUnavailable => '城市灯塔暂时无法使用，请稍后再试。';

  @override
  String get notConnectedCheckNetwork => '没有连上，请检查网络后再试一次。';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$features厕所，$name，$distance';
  }

  @override
  String get listSeparator => '、';

  @override
  String beaconToggleOff(int count) {
    return '关闭城市灯塔（友善厕所），附近 $count 间';
  }

  @override
  String get beaconToggleOn => '打开城市灯塔（友善厕所）';

  @override
  String beaconFilterOnly(String feature) {
    return '只看$feature';
  }

  @override
  String get beaconMaybeOpenNight => '晚上可能有开（推估）';

  @override
  String get beaconMaybeDaytime => '可能只在白天开（推估）';

  @override
  String get walkThere => '走路过去';

  @override
  String get beaconWrongData => '数据不对吗？';

  @override
  String beaconThanks(String reason) {
    return '谢谢你，已经收到「$reason」的回报。';
  }

  @override
  String get beaconSource => '数据来源：台湾环境部「全国公厕建档资料」，每月更新。开放时间是依场所推估的。';

  @override
  String get invite1 => '我在城市低语点亮了一道光。附近的人越多，街区就越亮，一起来点亮我们的街区吧：';

  @override
  String get invite2 => '今晚的城市有点安静。来城市低语写下一句心情，让我们的街区亮起来：';

  @override
  String get invite3 => '不用加好友、不用真名，只要一句此刻的心情。来城市低语找我：';

  @override
  String get invite4 => '我在城市低语留了一盏灯给你。打开 App，看看今晚附近的人都在想什么：';

  @override
  String get invite5 => '每周五晚上九点是城市低语的点亮之夜，一起上线，让雷达亮成一片吧：';

  @override
  String get invite6 => '想找个地方说说今天的心情吗？城市低语是匿名的，说完就消散：';

  @override
  String get invite7 => '走在路上的时候，你会好奇擦肩而过的人在想什么吗？来城市低语看看：';

  @override
  String get invite8 => '我在这条街留下了一则低语，经过的人才读得到。你也来留一则吧：';

  @override
  String get invite9 => '城市低语是一张夜里的心情地图。人越多越好玩，来帮我们的街区多点一道光：';

  @override
  String get invite10 => '今晚的你，心情是什么颜色？来城市低语写下来，我在附近等你的光：';

  @override
  String get shareInvite => '分享邀请';

  @override
  String get inviteSubject => '一起来点亮我们的街区';

  @override
  String get shareMoodCardButton => '分享心情卡';

  @override
  String moodShareText(String mood) {
    return '我在城市低语留下了此刻的心情：「$mood」\n今晚，你的心情也在城市里发光吗？';
  }

  @override
  String get shareFailed => '没有分享出去，请再试一次。';

  @override
  String shuffleCard(int current, int total) {
    return '换一张 · $current / $total';
  }

  @override
  String get preparing => '准备中…';

  @override
  String get sendLinkToFriends => '发链接给朋友（WhatsApp、Messenger）';

  @override
  String get partLateNight => '深夜';

  @override
  String get partMorning => '早晨';

  @override
  String get partAfternoon => '午后';

  @override
  String get partDusk => '黄昏';

  @override
  String get partNight => '夜晚';

  @override
  String get cardInviteEyebrow => '邀请你';

  @override
  String get cardMoodEyebrow => '此刻的心情';

  @override
  String get cardInviteTitle => '一起来点亮\n我们的街区';

  @override
  String get cardInviteBody => '我在城市低语点亮了一道光。\n附近的人越多，街区就越亮。';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\n在城市的某个角落';
  }

  @override
  String get whisperUnavailable => '低语暂时无法使用，请稍后再试。';

  @override
  String get whisperNotSent => '低语没有送出，请检查网络后再试一次。';

  @override
  String daysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get timeWhisperTitle => '低语穿越';

  @override
  String get timeWhisperLead => '写给未来的自己。时间到了，回到这里才能打开。';

  @override
  String get whisperLead => '写给下一个经过这里的人。';

  @override
  String get toPassersBy => '给经过的人';

  @override
  String get toFutureSelf => '寄给未来的自己';

  @override
  String get inOneMonth => '一个月后';

  @override
  String get inOneYear => '一年后';

  @override
  String get timeWhisperHint => '例如：明年此地再见。希望那时的你，过得比现在好。';

  @override
  String get whisperHint => '例如：这里的夕阳很美，记得抬头看看。';

  @override
  String get timeWhisperCaptionYear => '只有你看得到 · 一年后解封并通知你 · 回到 100 米内打开';

  @override
  String get timeWhisperCaptionMonth => '只有你看得到 · 一个月后解封并通知你 · 回到 100 米内打开';

  @override
  String get whisperCaption => '7 天后消散 · 不会显示你是谁 · 只透露你曾在这一带';

  @override
  String get sealHere => '封存在这里';

  @override
  String get leaveHere => '留在这里';

  @override
  String get aWhisper => '一则低语';

  @override
  String whisperLeftAgo(String ago) {
    return '$ago留在这一带';
  }

  @override
  String whisperCollectedBy(int count) {
    return '已被 $count 个人收下';
  }

  @override
  String get whisperNobodyYet => '还没有人经过';

  @override
  String get withdrawWhisper => '收回这则低语';

  @override
  String get whisperCollected => '你收下了这则低语。';

  @override
  String whisperReadersBefore(int count) {
    return '在你之前，已经有 $count 个人经过这里。';
  }

  @override
  String get whisperFirstReader => '你是第一个经过这里的人。';

  @override
  String get reportWhisper => '举报这则低语';

  @override
  String get thisWhisper => '这则低语';

  @override
  String get chatTimeUp => '时间已尽，交集消散...';

  @override
  String get chatOtherLeft => '对方已没入城市...';

  @override
  String get chatEnded => '交集已结束...';

  @override
  String get chatBlockedEnded => '已屏蔽对方，交集结束。';

  @override
  String get chatReportedEnded => '已举报对方，交集结束。';

  @override
  String get anonymous => '匿名';

  @override
  String get leaveChat => '离开对话';

  @override
  String chatWith(String name) {
    return '与 $name 的交集';
  }

  @override
  String get countdownPrefix => '倒数 ';

  @override
  String get countdownSuffix => ' 消散';

  @override
  String get demoChatNotice => '示范对话：对方由程序自动回复，不是真人。';

  @override
  String get typing => '对方正在输入中…';

  @override
  String get chatHint => '轻声说点什么…';

  @override
  String get send => '发送';

  @override
  String get chatDissolvedApart => '你们各自回到城市里了';

  @override
  String get knockTooOften => '敲门太频繁，请感受一下城市的呼吸...';

  @override
  String get otherNotNow => '对方目前不想被打扰，请给彼此一点空间。';

  @override
  String otherNotNowMinutes(int minutes) {
    return '对方目前不想被打扰，请给彼此一点空间 ($minutes 分钟)。';
  }

  @override
  String get justEndedRest => '你们才刚结束交集，让回忆沉淀一下吧。';

  @override
  String get intro1Title => '没入这座城市';

  @override
  String get intro1Body => '抛开繁杂的社交标签，在极简的暗黑画布上，只留下你最真实的情绪与坐标。';

  @override
  String get intro2Title => '片刻的交集';

  @override
  String get intro2Body => '看见附近浮动的心情气泡？轻轻敲门，与擦肩而过的人产生一期一会的对话。';

  @override
  String get intro3Title => '城市的节奏';

  @override
  String get intro3Body => '我们在意你的感受。发送敲门后请静待回音，若无缘交集，300 秒后气泡将悄悄消散。';

  @override
  String get intro4Title => '温柔的距离';

  @override
  String get intro4Body => '不想被打扰？点击婉拒或屏蔽。专属的冷却系统会为你隔绝喧嚣，还你安静的角落。';

  @override
  String get intro5Title => '准备好相遇了吗？';

  @override
  String get intro5Body => '闭上眼睛，感受手机的震动与心跳。现在，写下你此刻的心情，在这里打卡，走进城市低语。';

  @override
  String get intro6Title => '写给未来的自己';

  @override
  String get intro6Body => '把一句话留在此刻的地方，寄给一个月或一年后的自己。等你回到这里，它才会为你打开。';

  @override
  String get intro7Title => '今晚，一起发光';

  @override
  String get intro7Body => '开一场集会，用一个表情符号当暗号。把它加进称呼的人，会收到你的公告，一起点亮同一片街区。';

  @override
  String get intro8Title => '平行宇宙';

  @override
  String get intro8Body =>
      '点一下地球，台湾的城市与东京、首尔、吉隆坡重叠在一起。看见远方此刻的心情，一样可以敲门聊天，点一下就翻译。';

  @override
  String get loadingImage => '等待加载高清图片...';

  @override
  String get startExploring => '开始探索';

  @override
  String get nextPage => '下一页';

  @override
  String get feedbackSubject => '城市低语 意见反馈';

  @override
  String get loginNeedMood => '请留下你此刻的心情，再没入城市。';

  @override
  String get loginNeedAgree => '请先阅读并勾选同意使用条款与隐私政策。';

  @override
  String get loginCantConnect => '无法连上城市，请检查网络后再试一次。';

  @override
  String get ageQuestion => '请问你已年满 18 岁了吗？';

  @override
  String get ageReason => '城市低语会与附近的陌生人互动，仅限 18 岁以上使用。';

  @override
  String get ageUnder => '未满 18 岁';

  @override
  String get ageOver => '已满 18 岁';

  @override
  String get loginTitle1 => '准备好';

  @override
  String get loginTitle2 => '相遇了吗？';

  @override
  String get loginLead => '闭上眼睛，感受手机的震动与心跳。\n现在，写下你此刻的心情，走进城市低语。';

  @override
  String get loginPrompt => '此时此刻，你想对城市说什么？';

  @override
  String get loginHint => '例如：喝了一杯好咖啡😊';

  @override
  String get enterCity => '走进城市低语';

  @override
  String get agreeSemantic => '我已阅读并同意使用条款与隐私政策';

  @override
  String get agreePrefix => '我已阅读及同意';

  @override
  String get termsLink => '《使用条款》';

  @override
  String get agreeAnd => '与';

  @override
  String get privacyLink => '《隐私政策》';

  @override
  String get agreeSuffix => '。城市低语对骚扰、色情与仇恨等不当内容零容忍，违者将被移出城市。';

  @override
  String get under18Title => '城市低语仅限 18 岁以上使用';

  @override
  String get under18Body => '谢谢你的诚实。这座城市会与陌生人互动，等你满 18 岁，我们再见。';

  @override
  String get clearMoodTrail => '清除心情轨迹';

  @override
  String get clearMoodTrailBody => '这台手机上的所有心情轨迹都会删除，无法恢复。';

  @override
  String get clear => '清除';

  @override
  String monthDay(int month, int day) {
    return '$month 月 $day 日';
  }

  @override
  String get moodTrailLocalOnly => '只存在你的手机上，不会上传到任何地方。';

  @override
  String get moodTrailEmpty => '这周还没有心情轨迹。每次写下心情、或走到新的地方，这里都会多一道光。';

  @override
  String get thisWeekYou => '这周的你';

  @override
  String get topMoodPrefix => '最常感到「';

  @override
  String topMoodSuffix(int count) {
    return '」，共 $count 次';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '在 $places 个不同的地方，留下了 $total 道心情';
  }

  @override
  String get recordMoodTrail => '记录我的心情轨迹';

  @override
  String get recordMoodTrailOff => '关闭后不再记录新的轨迹';

  @override
  String get nightly1 => '今晚的城市在想什么？';

  @override
  String get nightly2 => '有人在附近，正写下此刻的心情。';

  @override
  String get nightly3 => '夜色刚好，留一句话给这座城市吧。';

  @override
  String get nightly4 => '今天过得怎么样？你的心情会在城市里发光。';

  @override
  String get nightly5 => '街灯亮了，附近的人也还醒着。';

  @override
  String get nightly6 => '给今天一个结尾：此刻的你，是什么心情？';

  @override
  String get nightly7 => '今晚，谁会和你擦肩而过？';

  @override
  String get nightlyChannel => '每晚提醒';

  @override
  String get nightlyChannelDesc => '每晚一则温和的提醒，可在 App 设置中关闭';

  @override
  String get reasonHarassment => '骚扰或霸凌';

  @override
  String get reasonSexual => '色情或性暗示';

  @override
  String get reasonScam => '诈骗或广告';

  @override
  String get reasonHate => '仇恨或暴力言论';

  @override
  String get reasonImpersonation => '冒充他人';

  @override
  String get reasonOther => '其他';

  @override
  String get reportReceived => '已收到举报，已从你的画面移除。我们会在 24 小时内处理。';

  @override
  String get reportNotSent => '举报没有送出，请检查网络后再试一次。';

  @override
  String reportTarget(String target) {
    return '举报 $target';
  }

  @override
  String get reportPrivate => '你的举报不会让对方知道。请选择原因：';

  @override
  String get reportDetails => '补充说明（选填）';

  @override
  String get reportWhatHappened => '发生了什么事？';

  @override
  String get sendReport => '送出举报';

  @override
  String get alsoBlock => '同时屏蔽对方，双方将从彼此的城市中消失';

  @override
  String get aYearAgo => '一年前';

  @override
  String get aMonthAgo => '一个月前';

  @override
  String get timeWhisperUnavailable => '低语穿越暂时无法使用，请稍后再试。';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago的你，在这里说';
  }

  @override
  String writtenOn(String date) {
    return '写于 $date';
  }

  @override
  String get timeWhisperOnce => '这封信只会出现这一次。';

  @override
  String get keepInHeart => '收进心里';

  @override
  String unsealsOn(String unlock, String created) {
    return '$unlock 解封 · 写于 $created';
  }

  @override
  String get unsealedGoBack => '已解封，回到那里就能打开';

  @override
  String unsealedDistance(String distance) {
    return '已解封 · 距离你 $distance';
  }

  @override
  String get timeWhisperListLead =>
      '写给未来的自己，只有你看得到。时间到了，回到那里 100 米内就会打开；读过一次就会消失。';

  @override
  String get timeWhisperListEmpty => '还没有写给未来的信。按底部菜单的笔记图标，选「寄给未来的自己」。';

  @override
  String get readyToOpen => '已经可以打开了';

  @override
  String get sealed => '封存中';

  @override
  String get delete => '删除';

  @override
  String get within100m => '100m 内';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return '正在等待 $name 回音，剩下 $mm 分 $ss 秒';
  }

  @override
  String knockWaiting(String name) {
    return '等待 $name 回音';
  }

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随手机设置';

  @override
  String get parallelUniverse => '平行宇宙';

  @override
  String get parallelUniverseSubtitle => '看见其他城市此刻的心情，也让他们看见你';

  @override
  String get parallelUniverseIntroTitle => '进入平行宇宙';

  @override
  String get parallelUniverseIntroBody =>
      '开启后，对应城市里此刻开着 App 的人都会叠到你的雷达上，他们也都看得到你。台湾的城市对应到国外的城市（例如东京、首尔、吉隆坡），国外的城市对应到台湾。\n\n两边以各自的中央车站对齐：你离车站多远、往哪个方向，在对方的城市就出现在同样的地方，而且模糊到约 500 米，没有人看得到你的真实位置或距离。一样可以送微光、敲门和聊天，随时可以关闭。低语和集会只留在当地。';

  @override
  String get parallelUniverseEnter => '进入';

  @override
  String get parallelUniverseNoCity => '你所在的地方还没有平行宇宙';

  @override
  String parallelFrom(String city) {
    return '平行宇宙 · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return '这个人在$city，不在你身边。位置是投影过来的，不代表真实距离。';
  }

  @override
  String get labelHost => '主持';

  @override
  String get labelDemo => '示范';

  @override
  String get labelResting => '休息中';

  @override
  String get cityTaipei => '台北';

  @override
  String get cityTaichung => '台中';

  @override
  String get cityKaohsiung => '高雄';

  @override
  String get cityTokyo => '东京';

  @override
  String get cityOsaka => '大阪';

  @override
  String get citySeoul => '首尔';

  @override
  String get cityBusan => '釜山';

  @override
  String get cityHongkong => '香港';

  @override
  String get cityMacau => '澳门';

  @override
  String get citySingapore => '新加坡';

  @override
  String get cityKualalumpur => '吉隆坡';

  @override
  String get cityJakarta => '雅加达';

  @override
  String get cityHochiminh => '胡志明市';

  @override
  String get cityHanoi => '河内';

  @override
  String get translateTap => '点一下翻译';

  @override
  String get translateShowOriginal => '已翻译 · 点一下看原文';

  @override
  String get translating => '翻译中…';

  @override
  String get translateFailed => '翻译失败，请稍后再试';

  @override
  String get translateDownloadTitle => '下载翻译模型';

  @override
  String get translateDownloadBody =>
      '第一次翻译这种语言，需要下载翻译模型（每种语言约 30 MB，只需一次）。\n\n翻译完全在你的手机上进行，消息不会上传。';

  @override
  String get translateDownload => '下载';

  @override
  String placeHint(String name) {
    return '附近有一盏心情据点的灯 · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return '营业到 $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return '心情据点：$name，$hours';
  }

  @override
  String get placeWrongData => '信息有误？';

  @override
  String placeReportSubject(String name) {
    return '心情据点信息有误：$name';
  }

  @override
  String get placeHintsSetting => '心情据点提示';

  @override
  String get placeHintsSettingSubtitle => '经过营业中的心情据点时，在 App 里轻声提示（不推送）';

  @override
  String get guideS16Title => '10. 心情据点';

  @override
  String get guideS16L1 =>
      '心情据点是合作的独立咖啡店。你打卡后，走到营业中的店门口 150 米内，雷达上会浮现一盏慢慢呼吸的小灯；走远了就熄掉。';

  @override
  String get guideS16L2 =>
      '点小灯打开据点名片：店里的夜景、今天营业到几点、一句店家的心情故事（点一下翻译）、地址与电话，按“走路过去”用手机的地图 App 导航。今天打开过的灯会变成静止的柔光。';

  @override
  String get guideS16L3 =>
      '第一次经过时，上方会浮出一张小卡提示你，不响也不震动；同一家店 7 天内只提示一次，一天最多 2 次。可以在“设置 → 心情据点提示”关掉，灯还是会在。';

  @override
  String get guideS16L4 =>
      '店家清单整份下载到你的手机，是否在附近只在手机上判断，我们和店家都不会知道你经过哪家店。店家不能付费换取曝光；信息有误可以在名片下方反馈。';

  @override
  String get placeGuestbook => '店内留言本';

  @override
  String placeGuestbookLocked(int m) {
    return '走进店里（约 $m 米内）就读得到之前坐在这里的人留下的话。';
  }

  @override
  String get placeGuestbookAbout => '只有在店里的人读得到。匿名，30 天后消失。';

  @override
  String get placeGuestbookEmpty => '还没有人留言，留下第一句吧。';

  @override
  String get placeGuestbookWrite => '留一句话';

  @override
  String get placeGuestbookHint => '给下一个坐在这里的人…';

  @override
  String get placeGuestbookSent => '留好了，下一个坐在这里的人会读到。';

  @override
  String get placeGuestbookUnavailable => '留言本暂时无法使用，请稍后再试。';

  @override
  String get placeNoteMine => '你的留言';

  @override
  String get withdrawPlaceNote => '收回这则留言';

  @override
  String get reportPlaceNote => '举报这则留言';

  @override
  String get thisPlaceNote => '这则留言';

  @override
  String get guideS16L5 =>
      '店内留言本：人在店里（约 40 米内）打开名片，就读得到之前坐在这里的人留下的话，也可以留一句给下一个人。留言匿名、30 天后消失，同一家店一天可以留一则，点一下可以翻译，不舒服的可以举报。打开留言本时，手机会把位置发到服务器确认你在店里，服务器不保存。';

  @override
  String get quantumWorld => '量子世界';

  @override
  String get quantumWorldSubtitle => '全世界一个房间，不透露你的位置';

  @override
  String get quantumIntroTitle => '进入量子世界';

  @override
  String get quantumIntroBody =>
      '全世界此刻在量子世界的人，都在同一个房间里：以台北 101 为原点排成蜂巢，你会拿到一个席位，例如“Q4-17”，圈数越小越靠近原点。\n\n没有人看得到你的真实位置。大家看到的是你的席位，固定在你点“进入”的那一刻，走路也不会移动；想换位置就离开再进入一次。昵称和心情照旧，一样可以送微光、敲门和聊天，点一下就翻译。\n\n在量子世界期间，会暂时离开一般雷达和平行宇宙；离开后回到原本打卡的位置。';

  @override
  String get quantumEnter => '进入';

  @override
  String get quantumLeave => '离开量子世界';

  @override
  String get quantumLeft => '你离开了量子世界，回到原本的雷达';

  @override
  String quantumYourSeat(String code) {
    return '你的席位 $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return '第 $ring 圈 · 圈数越小越靠近 101 原点';
  }

  @override
  String quantumOnlineChip(int count) {
    return '此刻 $count 人';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '此刻共有 $count 人在量子世界';
  }

  @override
  String get quantumRegionTw => '台湾';

  @override
  String get quantumRegionJp => '日本';

  @override
  String get quantumRegionKr => '韩国';

  @override
  String get quantumRegionHkmo => '港澳';

  @override
  String get quantumRegionSea => '东南亚';

  @override
  String get quantumRegionOther => '其他地区';

  @override
  String get quantumQuiet => '量子宁静';

  @override
  String get quantumQuietSubtitle => '只看世界：别人不能敲你的门，仍然收得到微光';

  @override
  String get quantumQuietTarget => '对方开启了量子宁静，现在只能送微光';

  @override
  String get quantumClosedRegion => '你所在的地区没有开放量子世界';

  @override
  String get quantumLeftClosed => '你进入了未开放量子世界的地区，已自动离开';

  @override
  String get quantumSeatExpired => '你离开太久，席位已经释放，回到原本的雷达';

  @override
  String get quantumUnavailable => '量子世界暂时进不去，请稍后再试';

  @override
  String quantumPersonBody(String code) {
    return '这个人在量子世界的席位 $code。量子世界里看不到任何人的真实位置。';
  }

  @override
  String quantumChatTag(String code) {
    return '量子世界・$code';
  }

  @override
  String get guideS17Title => '13. 量子世界';

  @override
  String get guideS17L1 =>
      '点雷达右上角的蜂巢图标（平行宇宙下方），看完说明后按“进入”。每次进入都要自己按，就像打卡；每次打开 App 都从一般雷达开始。';

  @override
  String get guideS17L2 =>
      '全世界在量子世界的人都在同一个房间：以台北 101 为原点排成蜂巢，相邻席位相距 100 米。你会拿到一个席位代号，例如“Q4-17”（第 4 圈第 17 号），圈数越小越靠近原点。入场时先补别人离开的空位；第 1～3 圈保留给集会主持人。';

  @override
  String get guideS17L3 =>
      '没有人看得到你的真实位置：大家看到的是你的席位。每次点“进入”就是一次打卡，席位固定在那一刻，走路不会移动；想换位置就离开再进入。中国大陆不开放量子世界。';

  @override
  String get guideS17L4 =>
      '昵称和心情照旧，一样可以送微光、敲门和聊天，点一下就翻译。两指缩小可以看到整个蜂巢，远处的人会变成光点。点左上角的席位代号，可以看在线人数、开启“量子宁静”（别人不能敲门，仍然收得到微光），或离开。';

  @override
  String get guideS17L5 =>
      '量子世界里没有低语、低语穿越、心情据点、城市灯塔与集会。进入期间会暂时离开一般雷达和平行宇宙；离开时你的气泡化成光点散掉，回到原本打卡的位置。App 关掉或断线超过 3 分钟，席位就会释放。';

  @override
  String quantumChimeCountdown(int seconds) {
    return '$seconds 秒后整点报时';
  }

  @override
  String get quantumChimeLookOrigin => '大家都在看 101 原点';

  @override
  String get quantumChimeLook => '看原点';

  @override
  String quantumChimeNow(int hour) {
    return '量子中心 $hour 点报时';
  }

  @override
  String get quantumChimeSend => '送出报时微光';

  @override
  String get quantumChimeSent => '你的微光飞向原点';

  @override
  String quantumChimeWatched(int n) {
    return '这次报时，有 $n 人一起看';
  }

  @override
  String get quantumChimeReminder => '整点报时提醒';

  @override
  String get quantumChimeReminderSubtitle => '整点前提醒你到 101 原点看报时';

  @override
  String get quantumChimeNotifyBody => '整点报时快开始了，到 101 原点一起看';

  @override
  String get quantumChimeChannel => '整点报时';

  @override
  String get quantumChimeChannelDesc => '量子世界的整点报时提醒';

  @override
  String get quantumEntangleInvite => '邀请量子纠缠';

  @override
  String quantumEntangleInvited(String name) {
    return '已邀请 $name 纠缠';
  }

  @override
  String get quantumEntangleAskTitle => '量子纠缠';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name（$code）想和你量子纠缠。纠缠后，两颗气泡之间会有一道光线，不管相隔多远都看得到；任何一方离开，光线就会坍缩。不留记录。';
  }

  @override
  String get quantumEntangleAccept => '纠缠';

  @override
  String quantumEntangled(String name) {
    return '你和 $name 纠缠了';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return '与 $name 的纠缠已坍缩';
  }

  @override
  String get quantumEntangleCut => '解除纠缠';

  @override
  String get quantumEntangleFull => '你已经和 3 个人纠缠了';

  @override
  String get quantumEntangleTheirFull => '对方已经和 3 个人纠缠了';

  @override
  String get quantumEntangleGone => '对方已经离开量子世界';

  @override
  String get quantumEntangleExpired => '邀请已经过期';

  @override
  String get quantumEntangledTitle => '纠缠中';

  @override
  String get quantumTunnel => '量子穿隧';

  @override
  String get quantumTunnelSubtitle => '跳到蜂巢里随机一个空席位，换一群邻居。每次入场可以用一次。';

  @override
  String get quantumTunnelUsed => '这次入场已经穿隧过了';

  @override
  String quantumTunnelDone(String code) {
    return '穿隧到 $code';
  }

  @override
  String get quantumShowTime => '显示我的当地时间';

  @override
  String get quantumShowTimeSubtitle => '别人长按你的气泡时看得到；关闭时只显示昼夜色调';

  @override
  String quantumLocalTime(String time, String part) {
    return '当地 $time・$part';
  }

  @override
  String get quantumDawn => '清晨';

  @override
  String get quantumDay => '白天';

  @override
  String get quantumDusk => '黄昏';

  @override
  String get quantumNight => '深夜';

  @override
  String get quantumTopicsTitle => '量子同频';

  @override
  String get quantumTopicsSubtitle => '选最多 3 个主题，显示在你的气泡下方';

  @override
  String get quantumTopicMusic => '音乐';

  @override
  String get quantumTopicMovies => '电影';

  @override
  String get quantumTopicTech => '科技';

  @override
  String get quantumTopicWalks => '散步';

  @override
  String get quantumTopicFood => '美食';

  @override
  String get quantumTopicTravel => '旅行';

  @override
  String get quantumTopicReading => '阅读';

  @override
  String get quantumTopicSports => '运动';

  @override
  String quantumTopicsCommon(String topics) {
    return '你们都喜欢：$topics';
  }

  @override
  String get quantumSignalsTitle => '量子信号';

  @override
  String quantumSignalReceived(String name) {
    return '$name 传来一个信号';
  }

  @override
  String get quantumSignalWait => '刚送过了，等一下再送';

  @override
  String quantumResonance(String name) {
    return '你和 $name 产生了共振';
  }

  @override
  String get guideS17L6 =>
      '整点报时：每个整点，101 光柱前 1 分钟开始变亮，整点时光之使者绕原点一圈、敲出量子中心时间的钟声（0 点 24 声），最后一道光波扩散到整个蜂巢。报时时点一下「送出报时微光」，一起看的人越多光越盛。「整点报时提醒」默认打开，可以在面板里关掉。';

  @override
  String get guideS17L7 =>
      '聊过天的人可以邀请「量子纠缠」：两颗气泡之间会有一道光线，不管多远都看得到，任何一方离开就坍缩，每人最多同时纠缠 3 人。「量子穿隧」每次入场可以用一次，跳到随机一个空席位、换一群邻居。';

  @override
  String get guideS17L8 =>
      '每颗气泡带着主人当地时间的色调：清晨淡金、白天亮白、黄昏橘紫、深夜深蓝；开启「显示我的当地时间」后，长按气泡看得到时间。24 小时内互送微光会产生「量子共振」；长按气泡可以送 👋 ☕ 🌙 🎵 🌧️ ✨ 量子信号；在面板选最多 3 个「量子同频」主题，共同的主题会亮起来。';

  @override
  String get quantumNyTitle => '量子跨年';

  @override
  String quantumNyDays(int n) {
    return '还有 $n 天：12/31 量子中心午夜，到 101 原点和全世界一起倒数';
  }

  @override
  String get quantumNyTonight => '今晚量子中心午夜，到 101 原点和全世界一起倒数';

  @override
  String quantumNyZone(String places) {
    return '$places 跨年了 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '此刻全世界共 $n 人在量子世界一起跨年';
  }

  @override
  String get quantumNyHappy => '新年快乐';

  @override
  String get guideS17L9 =>
      '量子跨年：12/31 各时区跨年时，那里的气泡一波波亮起金色光环，世界视角的光点也跟着变金色。量子中心午夜时，全蜂巢一起倒数最后 10 秒，101 原点放出全世界最大的光爆和 5 分钟的烟火，并显示这一刻一起跨年的人数。';

  @override
  String get quantumMeetAction => '制作量子相遇卡';

  @override
  String quantumMeetAsked(String name) {
    return '已邀请 $name 一起制作量子相遇卡';
  }

  @override
  String get quantumMeetWait => '刚刚邀请过了，稍等一下再试';

  @override
  String get quantumMeetAskTitle => '量子相遇卡';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name（⬡ $code）想和你把这次相遇做成一张分享卡。卡片上有双方的昵称、席位代号、当地时间和心情，不含任何位置。';
  }

  @override
  String get quantumMeetAccept => '一起制作';

  @override
  String get quantumMeetEyebrow => '量子相遇';

  @override
  String get quantumMeetFooter => '我们在量子世界相遇';

  @override
  String get quantumMeetShare => '分享相遇卡';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b，我们在量子世界相遇了 ✨';
  }

  @override
  String get guideS17L10 =>
      '量子相遇卡：聊过天的人，长按气泡可以邀请对方一起制作。双方都同意后，各自拿到一张分享卡，上面有两人的昵称、席位代号、当地时间与昼夜色和心情，不含任何位置；第 4 圈的席位代号是金色的。';

  @override
  String get quantumOrbEntry => '量子化身';

  @override
  String get quantumOrbEntrySubtitle => '你的头像在量子世界里会变成一颗水晶球';

  @override
  String get orbTitle => '量子化身';

  @override
  String get orbSubtitle => '球缘和光晕永远跟着你的心情';

  @override
  String get orbStyleGlow => '光球';

  @override
  String get orbStyleRing => '星环';

  @override
  String get orbStyleRainbow => '彩虹';

  @override
  String get orbFree => '免费';

  @override
  String get orbOwned => '已拥有';

  @override
  String get orbInUse => '使用中';

  @override
  String get orbCosmeticNote => '特殊款只是外观，不影响任何功能或权益。买过的款式跟着账号保存。';

  @override
  String get orbRestore => '恢复购买';

  @override
  String orbPurchased(String name) {
    return '$name已经是你的了 ✨';
  }

  @override
  String get orbPurchaseFailed => '购买没有完成，请稍后再试';

  @override
  String get orbOwnedElsewhere => '这笔购买已经用在另一个账号上';

  @override
  String get orbStoreUnavailable => '商店暂时连不上，请稍后再试';

  @override
  String get aiyaName => '艾娅';

  @override
  String get aiyaChip => '艾娅 · AI';

  @override
  String get aiyaConsentTitle => '和艾娅聊天之前';

  @override
  String get aiyaConsentBody =>
      '艾娅是 AI，由 Anthropic 的 Claude 提供。你发给艾娅的文字会送到 Anthropic（美国）处理，不会附上你的身份、昵称或位置；对话结束就删除。艾娅的回复可能出错，不构成专业建议。';

  @override
  String get aiyaConsentAgree => '同意并开始';

  @override
  String get aiyaConsentLater => '先不要';

  @override
  String get aiyaGreeting => '嗨，我是艾娅，住在量子中心的那道光。今晚想聊什么？';

  @override
  String get aiyaFarewell => '时间到了，我要回到光里了。想我的时候再来敲门。';

  @override
  String get aiyaInputHint => '跟艾娅说点什么…';

  @override
  String get aiyaSend => '发送';

  @override
  String aiyaFreeLeft(int n) {
    return '今天免费还有 $n 次';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return '时光包 $n 次';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '剩 $time';
  }

  @override
  String get aiyaEnd => '结束聊天';

  @override
  String get aiyaFiltered => '这句话里有不适合的字词或联系方式，换个说法吧。';

  @override
  String get aiyaBusy => '艾娅刚刚走神了，再说一次好吗？';

  @override
  String get aiyaRefused => '这个我不太能聊，换个话题好吗？';

  @override
  String get aiyaEnded => '这次的聊天已经结束了。';

  @override
  String get aiyaNoQuotaTitle => '今天的免费次数用完了';

  @override
  String get aiyaNoQuotaBody =>
      '每天有 3 次免费聊天，明天 00:00（台湾时间）重新计算。想现在继续，可以买时光包，每次最多 10 分钟。';

  @override
  String get aiyaResting => '艾娅今晚累了，明天见。';

  @override
  String get aiyaDailyMax => '今天已经聊很多了，明天再来找艾娅吧。';

  @override
  String aiyaPackTimes(int n) {
    return '$n 次聊天';
  }

  @override
  String get aiyaPackNote => '时光包绑定这台手机的账号，删除 App 或账号后无法恢复。';

  @override
  String aiyaPurchased(int n) {
    return '已加入 $n 次聊天 ✨';
  }

  @override
  String get aiyaPurchaseFailed => '购买没有完成，请再试一次。';

  @override
  String get aiyaStoreUnavailable => '商店暂时连不上，请稍后再试';

  @override
  String get aiyaReport => '举报这句话';

  @override
  String get aiyaReported => '已收到举报，我们会在 24 小时内处理。';

  @override
  String get aiyaSetting => '艾娅（量子世界的 AI）';

  @override
  String get aiyaSettingSubtitle => '关掉后，量子世界的光柱不再显示艾娅';

  @override
  String get aiyaCameoHello => '嗨，欢迎来到量子世界。想聊天就点我。';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour 点了。我在光里陪你。';
  }

  @override
  String get locationPickOnMap => '在地图上选择位置';

  @override
  String get locationPickTitle => '选择你现在的位置';

  @override
  String get locationPickHint => '移动地图，让中间的光点对准你现在所在的地方';

  @override
  String get locationPickConfirm => '就是这里';

  @override
  String get aiyaPackEntry => '＋ 时光包';

  @override
  String get aiyaPacksTitle => '时光包';

  @override
  String get aiyaPacksBody => '每天有 3 次免费聊天；免费次数用完后，才会使用时光包的次数。每次聊天最多 10 分钟。';

  @override
  String get guideS1L6 =>
      '抓不到位置时（例如在室内，或使用没有 GPS 的 iPad），可以按「在地图上选择位置」：移动地图，让中间的光点对准你现在的位置，再按「就是这里」。之后抓到真实位置，就会自动换过去。';

  @override
  String get guideS17L11 =>
      '量子化身：点左上角的席位代号 →「量子化身」，你的头像在量子世界里会变成一颗水晶球。光球、星环两款免费；彩虹水晶球为一次购买、永久拥有，换手机或重新安装后可以按「恢复购买」找回。';

  @override
  String get guideS18Title => '14. 艾娅 · AI';

  @override
  String get guideS18L1 =>
      '艾娅是住在量子世界中央光柱里的 AI，不是真人，她自己也会这样说。进入量子世界后，点光柱底下的「艾娅 · AI」就能敲门聊天；第一次聊天前要先看完说明并同意。';

  @override
  String get guideS18L2 =>
      '每次聊天最多 10 分钟、20 条消息。每天有 3 次免费，台湾时间 00:00 重新计算；每天最多 30 次。';

  @override
  String get guideS18L3 =>
      '时光包：输入框上方的「＋ 时光包」随时可以购买 5 次或 20 次聊天，免费次数用完后才会使用。时光包绑定这部手机的账号，删除 App 或账号后无法恢复；它是用完就没有的消耗型商品，所以没有「恢复购买」。';

  @override
  String get guideS18L4 =>
      '艾娅不知道、也不会问你的位置与身份，只知道匿名的城市心情统计。她不谈恋爱、不聊色情内容，也不提供医疗、法律或财务建议；长按她的回复可以举报。聊天内容只暂存在这次对话，结束后不久就会自动删除。';

  @override
  String get guideS18L5 =>
      '艾娅偶尔会在光柱里现身：整点报时、每天第一次进入量子世界，或不经意的偶遇；点她就能开始聊天。不想看到她，可以在设置里关掉「艾娅（量子世界的 AI）」。';

  @override
  String get orbStyleXmas => '圣诞';

  @override
  String get orbStyleNewYear => '量子跨年';

  @override
  String get orbLimited => '限定款';

  @override
  String orbLimitedUntil(String date) {
    return '限定 · $date 截止';
  }

  @override
  String get aiyaFriendTitle => '艾娅之友';

  @override
  String get aiyaFriendSubtitle => '自动续订的月费方案';

  @override
  String get aiyaFriendPerk1 => '每天 20 次聊天（免费是 3 次）';

  @override
  String get aiyaFriendPerk2 => '每次聊 20 分钟或 40 条';

  @override
  String get aiyaFriendPerk3 => '艾娅休息时，也能找她聊';

  @override
  String get aiyaFriendPerk4 => '艾娅换上专属的“星光”造型（只有你看得到）';

  @override
  String aiyaFriendPrice(String price) {
    return '$price／月';
  }

  @override
  String get aiyaFriendSubscribe => '订阅';

  @override
  String get aiyaFriendTerms =>
      '订阅期为 1 个月，到期时会自动续订并扣款，除非在到期前至少 24 小时关闭自动续订。付款由 Apple 或 Google 账户处理，可以随时到账户的订阅设置管理或取消。时光包的次数会保留，每天 20 次用完后才会使用。';

  @override
  String aiyaFriendActive(String date) {
    return '你是艾娅之友，有效期至 $date';
  }

  @override
  String get aiyaFriendManage => '管理订阅';

  @override
  String get aiyaFriendRestore => '恢复购买';

  @override
  String get aiyaFriendWelcome => '你成为艾娅之友了 ✨';

  @override
  String get aiyaFriendRestored => '已恢复艾娅之友';

  @override
  String get aiyaFriendNotFound => '没有找到有效的艾娅之友订阅';

  @override
  String get aiyaFriendElsewhere => '这个订阅已经用在另一个账号';

  @override
  String get aiyaFriendEntry => '艾娅之友 · 每天 20 次';

  @override
  String aiyaFriendLeft(int n) {
    return '艾娅之友 · 今天还有 $n 次';
  }

  @override
  String get guideS17L12 =>
      '限定款：圣诞水晶球（冬青花环、会闪的金星、飘雪）卖到 12/25，量子跨年水晶球（金色时钟刻度、轮流绽放的烟火，跨年那一刻绽放得特别大）卖到 1/1（台湾时间）。过了销售期就不再上架，买过的人永久保留，也可以恢复购买。';

  @override
  String get guideS18L6 =>
      '艾娅之友：在“＋ 时光包”里选“艾娅之友”，是自动续订的月费方案。每天 20 次聊天、每次 20 分钟或 40 条，艾娅休息时也能聊，她还会换上只有你看得到的“星光”造型。每天 20 次用完后才扣时光包。订阅会自动续订，可以随时在 Apple 或 Google 的订阅设置取消；换手机后点“恢复购买”找回。';

  @override
  String get mapConsentTitle => '要在地图上显示你的位置吗？';

  @override
  String get mapConsentBody =>
      '允许后，每次你自己点“打卡”或量子世界的“进入”，其他用户会在地图上看到你打卡的地方（不是实时位置）、昵称与心情。不会自动打卡；离开 App 就从地图上消失。你可以拒绝，也可以随时在设置中关闭。';

  @override
  String get mapConsentAllow => '允许';

  @override
  String get mapConsentDecline => '不允许';

  @override
  String get mapConsentDeclined => '好的，你不会出现在任何人的地图上。想打卡时再点一次就好。';

  @override
  String get mapConsentSetting => '在地图上显示我的位置';

  @override
  String get mapConsentSettingSubtitle => '关闭后立即结束打卡，你不会出现在任何人的地图上';

  @override
  String get wgErrInGroup => '你已经在一个低语团里了，先退出才能加入或开新的团。';

  @override
  String get wgErrFull => '这个低语团已经 20 人了，请团主开通 7 天方案就能再加入。';

  @override
  String get wgErrPaidFull => '这个低语团已经满 100 人了。';

  @override
  String get wgErrQr => '这个 QR code 已经换新了，请团主给你新的。';

  @override
  String get wgErrEnded => '这个低语团已经结束或不存在。';

  @override
  String get wgErrFiltered => '内容包含不适当的字词，请修改后再送出。';

  @override
  String get wgErrHostLeave => '团主不能直接退出，请先交棒给团员或解散低语团。';

  @override
  String get wgErrBusy => '暂时连不上，请稍后再试。';

  @override
  String get wgErrName => '请帮低语团取个名字。';

  @override
  String get wgPassUnavailable => '商店暂时无法购买，请稍后再试。';

  @override
  String get wgPassFailed => '购买没有完成，请再试一次。';

  @override
  String get wgPassDone => '已开通 7 天方案，这个低语团最多可以 100 人。';

  @override
  String get wgCreateTitle => '开一个低语团';

  @override
  String get wgCreateBody => '私人的团体：只有拿到你的 QR code 的人才能加入。可以集合、点名、放集合点。';

  @override
  String get wgNameLabel => '团名';

  @override
  String get wgColorLabel => '团色';

  @override
  String wgDaysLabel(int n) {
    return '行程 $n 天（含今天）';
  }

  @override
  String get wgFreeNote => '20 人以内免费；超过 20 人时，团主开通 7 天方案就能到 100 人。';

  @override
  String get wgCreateButton => '开团';

  @override
  String wgJoined(String name, int no) {
    return '已加入“$name”，你是 $no 号';
  }

  @override
  String get wgJoinTitle => '加入低语团';

  @override
  String get wgJoinBody => '用手机相机扫团主的 QR code 最快；也可以输入 8 码团代码。';

  @override
  String get wgJoinButton => '加入';

  @override
  String wgButtonLabel(String name) {
    return '低语团 $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n／$limit 人';
  }

  @override
  String wgUntil(String date) {
    return '到 $date';
  }

  @override
  String wgMyNo(int n) {
    return '我是 $n 号';
  }

  @override
  String get wgCallButton => '集合';

  @override
  String get wgCallDone => '人齐了，结束集合';

  @override
  String get wgRollButton => '点名';

  @override
  String wgRollSummary(int here, int total) {
    return '点名：到了 $here／$total';
  }

  @override
  String wgMembersTitle(int n) {
    return '团员 $n 人（点一下可以备注、交棒或移除）';
  }

  @override
  String get wgNoMembers => '还没有团员，点“QR code”让大家扫描加入。';

  @override
  String get wgQrButton => 'QR code';

  @override
  String get wgDissolveAsk => '要解散这个低语团吗？所有团员会收到通知，名单与记录会全部删除。';

  @override
  String get wgDissolve => '解散';

  @override
  String wgCallIn(int n) {
    return '$n 分钟后集合';
  }

  @override
  String get wgCallNow => '现在集合';

  @override
  String wgAckSummary(int acked, int total) {
    return '收到 $acked／$total';
  }

  @override
  String get wgAnswerHere => '我到了';

  @override
  String get wgAnswer5min => '还要 5 分钟';

  @override
  String get wgAnswerHelp => '需要帮忙';

  @override
  String get wgNoReply => '没回';

  @override
  String get wgStateAck => '收到';

  @override
  String get wgStateSeen => '看了没回';

  @override
  String get wgStateNone => '没反应';

  @override
  String get wgPassTitle => '低语团 7 天方案';

  @override
  String get wgPassBody => '20 人以内免费。开通后这个团最多 100 人，直到低语团结束；一次购买只用在这一团，不会自动续费。';

  @override
  String get wgPassButton => '开通 7 天方案';

  @override
  String wgHostIs(String name) {
    return '团主：$name';
  }

  @override
  String get wgNoCall => '目前没有集合呼叫。团主一按“集合”，你的手机就会响。';

  @override
  String get wgRollAsk => '团主在点名';

  @override
  String get wgLeaveAsk => '要退出这个低语团吗？';

  @override
  String get wgLeave => '退出低语团';

  @override
  String get wgCallTitle => '集合！';

  @override
  String get wgAcked => '✓ 已经告诉团主你收到了';

  @override
  String get wgAckButton => '收到';

  @override
  String get wgCallSheetTitle => '集合呼叫';

  @override
  String get wgNow => '现在';

  @override
  String wgInMinutes(int n) {
    return '$n 分钟后';
  }

  @override
  String get wgPlaceLabel => '集合点说明';

  @override
  String get wgPlaceHint => '例如：地铁西门站 6 号出口';

  @override
  String get wgPlaceNote => '集合点会放在你现在的位置，团员看得到距离与方向。';

  @override
  String get wgSendCall => '送出集合呼叫';

  @override
  String get wgNoLocation => '抓不到你的位置，没办法放集合点。';

  @override
  String get wgQrTitle => '让大家扫描加入';

  @override
  String get wgQrBody => '用手机相机扫描就能加入；也可以输入下面的团代码。';

  @override
  String wgShareText(String name, String url) {
    return '加入我的低语团“$name”：$url';
  }

  @override
  String get wgShare => '分享链接';

  @override
  String get wgRotateAsk => '要换新 QR code 吗？旧的 QR code 和链接会立即失效。';

  @override
  String get wgRotate => '换新 QR code';

  @override
  String wgMemberTitle(int no) {
    return '$no 号';
  }

  @override
  String get wgEditNote => '备注';

  @override
  String get wgHandoff => '交棒给他当团主';

  @override
  String wgHandoffAsk(int no) {
    return '要把团主交给 $no 号吗？你会变成团员。';
  }

  @override
  String get wgKick => '移出低语团';

  @override
  String wgKickAsk(int no) {
    return '要把 $no 号移出低语团吗？';
  }

  @override
  String get wgNotePrivate => '备注只有你看得到，例如名字或房号。';

  @override
  String get wgSave => '保存';

  @override
  String get wgConfirm => '确定';

  @override
  String get wgCancel => '取消';

  @override
  String get wgSettingCreate => '开一个低语团';

  @override
  String get wgSettingCreateSub => '私人团体：旅行、校外教学、登山、出游时集合与点名';

  @override
  String get wgSettingJoin => '加入低语团';

  @override
  String get wgSettingJoinSub => '输入团主给你的 8 码团代码';

  @override
  String wgSettingOpen(String name) {
    return '我的低语团：$name';
  }

  @override
  String get wgChannelName => '低语团集合';

  @override
  String get wgChannelDesc => '团主点“集合”时的提醒';

  @override
  String get guideS19Title => '15. 低语团';

  @override
  String get guideS19L1 =>
      '低语团是私人的团体，适合旅行、校外教学、登山、出游或活动工作人员。设置 → 集会 →“开一个低语团”，取团名、选团色和天数（最长 7 天）就开好了。';

  @override
  String get guideS19L2 =>
      '入团：团主点地图下方的低语团按钮 →“QR code”，团员用手机相机扫描就会打开 App 加入；也可以在设置 → 集会 →“加入低语团”输入 8 码团代码。外人无法搜索或申请，团主可以随时换新 QR code。';

  @override
  String get guideS19L3 =>
      '集合：团主点“集合”，选时间、写集合点说明，团员的手机会响专属音效并震动“短短长”，打开 App 会看到倒数、集合点的距离与方向，以及地图上的团色光柱。没点“收到”的人每分钟再提醒一次，最多 3 次；团主看得到谁收到、谁看了没回、谁没反应。';

  @override
  String get guideS19L4 =>
      '点名：团主点“点名”，团员一样会收到音效与震动，点“我到了”“还要 5 分钟”或“需要帮忙”。团主看不到团员的位置，只看得到大家的回复。';

  @override
  String get guideS19L5 =>
      '20 人以内免费；超过 20 人时，团主可以购买“低语团 7 天方案”，这个团最多 100 人，直到结束。团员永远免费。低语团最长 7 天，到期或团主解散后，名单与记录全部删除。';

  @override
  String get wgFlagButton => '举旗';

  @override
  String get wgFlagHost => '团主';

  @override
  String get wgFlagHint => '举起手机，让大家在人群里找到你。点一下关闭。';

  @override
  String get wgLostButton => '我迷路了';

  @override
  String get wgFound => '我找到团了';

  @override
  String get wgLostSent => '已把位置传给团主，原地等一下或往集合点走。';

  @override
  String get wgLostTitleAsk => '传位置给团主？';

  @override
  String get wgLostAsk =>
      '会把你此刻的位置传一次给团主，团主的手机会响起提醒，地图上也会出现你的位置。只传这一次，不会持续追踪；30 分钟后自动删除，找到团也可以点“我找到团了”取消。';

  @override
  String get wgLostSend => '传送我的位置';

  @override
  String wgLostTitle(int n) {
    return '迷路的团员 $n 人';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n 分钟前';
  }

  @override
  String get wgNavigate => '导航过去';

  @override
  String get wgFoundThem => '找到了';

  @override
  String get guideS19L6 =>
      '找人：在人群里找不到彼此时，点“举旗”，整个屏幕会变成团色并闪烁、显示你的团号，举起来让大家看到。真的走散了，团员可以点“我迷路了”，把此刻的位置传一次给团主（只传这一次，30 分钟后删除），团主的手机会响起提醒，地图上出现红色图钉，可以直接导航过去。';

  @override
  String wgLostAlert(int no) {
    return '$no 号迷路了';
  }

  @override
  String wgHelpAlert(String no) {
    return '$no 号需要帮忙';
  }

  @override
  String get wgViewList => '查看低语团';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour 点了。还醒着的人，我在光里陪你。';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour 点了，早安。今天也慢慢来。';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour 点了。今晚的城市，你好吗？';
  }

  @override
  String get aiyaCameoNyReady => '准备好了吗？我们一起倒数！';

  @override
  String aiyaCameoNewYear(int year) {
    return '新年快乐！$year，我们在同一个房间。';
  }

  @override
  String get aiyaSkinEntry => '✦ 造型';

  @override
  String get aiyaSkinTitle => '艾娅的造型';

  @override
  String get aiyaSkinSubtitle => '只有你看得到自己的艾娅换造型';

  @override
  String get aiyaSkinNone => '原本的艾娅';

  @override
  String get aiyaSkinStarlight => '星光';

  @override
  String get aiyaSkinStarlightSub => '艾娅之友专属';

  @override
  String get aiyaSkinXmas => '圣诞';

  @override
  String get aiyaSkinNewYear => '量子跨年';

  @override
  String get aiyaSkinNote => '节日造型是一次购买、永久拥有，只改变艾娅的样子，不影响聊天次数。限定款过了销售期就不再上架。';
}
