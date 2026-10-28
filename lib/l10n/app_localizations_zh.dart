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
      '打卡後，附近的人才看得到你此刻的心情與大概的位置，你也會看到他們。別人看到的是你打卡的地方，不會跟著你移動。每次打開 App 都要自己打卡，不會自動打卡。';

  @override
  String get checkInButton => '在這裡打卡';

  @override
  String get checkInAgain => '你離開打卡的地方了 · 在這裡重新打卡';

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
  String get guideS3L2 =>
      '會呼吸的氣泡代表對方正在使用；變暗並標示「休息中」代表對方鎖了螢幕，仍可以敲門；灰色、沒有名字的是「歷史殘影」，是剛離開的人留下的，會慢慢淡去。';

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
  String get guideS11Title => '14. 設定與通知';

  @override
  String get guideS11L1 => '「每晚提醒」：每天 21:30 一則溫和的提醒，可以在設定裡開關。';

  @override
  String get guideS11L2 => '敲門、新訊息、微光與集會公告會以推播通知你；可以在手機的系統設定裡關閉。';

  @override
  String get guideS11L3 => '每週五 21:00–23:00 是「點亮之夜」，大家一起上線，城市最亮。';

  @override
  String get guideS12Title => '15. 檢舉與封鎖';

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
  String get guideS13Title => '16. 隱私與帳號';

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
      '台灣各縣市以各自的中央車站為中心（例如大台北是台北車站、桃園是桃園車站），對應到國外的城市：日本、韓國、香港、澳門、新加坡、馬來西亞、印尼與越南；國外的城市則對應到台灣。';

  @override
  String get guideS14L3 =>
      '你離車站往哪個方向、多遠，在對方的城市就出現在離對方車站同樣方向、同樣距離的地方，並模糊到約 500 公尺，沒有人看得到你的真實位置。';

  @override
  String get guideS14L4 =>
      '只要你或對方其中一方開啟就看得到：你開啟時，看得到對方城市所有正開著 App 的人；你沒開時，只看得到有開啟的人。只有已打卡、正開著 App 的人會出現在其他城市。';

  @override
  String get guideS14L5 =>
      '平行宇宙的人有虛線光環，並標示所在的城市；一樣可以送微光、敲門和聊天。殘影、低語、低語穿越與集會都只留在當地。';

  @override
  String get guideS15Title => '13. 翻譯';

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
      '開啟後，對應城市裡此刻開著 App 的人都會疊到你的雷達上，他們也都看得到你。台灣的城市對應到國外的城市（例如東京、首爾、吉隆坡），國外的城市對應到台灣。\n\n兩邊以各自的中央車站對齊：你離車站多遠、往哪個方向，在對方的城市就出現在同樣的地方，而且模糊到約 500 公尺，沒有人看得到你的真實位置或距離。一樣可以送微光、敲門和聊天，隨時可以關閉。殘影、低語和集會只留在當地。';

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
      '打卡后，附近的人才看得到你此刻的心情与大概的位置，你也会看到他们。别人看到的是你打卡的地方，不会跟着你移动。每次打开 App 都要自己打卡，不会自动打卡。';

  @override
  String get checkInButton => '在这里打卡';

  @override
  String get checkInAgain => '你离开打卡的地方了 · 在这里重新打卡';

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
  String get guideS3L2 =>
      '会呼吸的气泡代表对方正在使用；变暗并标示「休息中」代表对方锁了屏幕，仍可以敲门；灰色、没有名字的是「历史残影」，是刚离开的人留下的，会慢慢淡去。';

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
  String get guideS11Title => '14. 设置与通知';

  @override
  String get guideS11L1 => '「每晚提醒」：每天 21:30 一则温和的提醒，可以在设置里开关。';

  @override
  String get guideS11L2 => '敲门、新消息、微光与集会公告会以推送通知你；可以在手机的系统设置里关闭。';

  @override
  String get guideS11L3 => '每周五 21:00–23:00 是「点亮之夜」，大家一起上线，城市最亮。';

  @override
  String get guideS12Title => '15. 举报与屏蔽';

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
  String get guideS13Title => '16. 隐私与账号';

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
      '台湾各县市以各自的中央车站为中心（例如大台北是台北车站、桃园是桃园车站），对应到国外的城市：日本、韩国、香港、澳门、新加坡、马来西亚、印尼与越南；国外的城市则对应到台湾。';

  @override
  String get guideS14L3 =>
      '你离车站往哪个方向、多远，在对方的城市就出现在离对方车站同样方向、同样距离的地方，并模糊到约 500 米，没有人看得到你的真实位置。';

  @override
  String get guideS14L4 =>
      '只要你或对方其中一方开启就看得到：你开启时，看得到对方城市所有正开着 App 的人；你没开时，只看得到有开启的人。只有已打卡、正开着 App 的人会出现在其他城市。';

  @override
  String get guideS14L5 =>
      '平行宇宙的人有虚线光环，并标示所在的城市；一样可以送微光、敲门和聊天。残影、低语、低语穿越与集会都只留在当地。';

  @override
  String get guideS15Title => '13. 翻译';

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
      '开启后，对应城市里此刻开着 App 的人都会叠到你的雷达上，他们也都看得到你。台湾的城市对应到国外的城市（例如东京、首尔、吉隆坡），国外的城市对应到台湾。\n\n两边以各自的中央车站对齐：你离车站多远、往哪个方向，在对方的城市就出现在同样的地方，而且模糊到约 500 米，没有人看得到你的真实位置或距离。一样可以送微光、敲门和聊天，随时可以关闭。残影、低语和集会只留在当地。';

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
}
