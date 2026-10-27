import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'城市低語'**
  String get appName;

  /// No description provided for @moodJoy.
  ///
  /// In zh, this message translates to:
  /// **'開心'**
  String get moodJoy;

  /// No description provided for @moodSad.
  ///
  /// In zh, this message translates to:
  /// **'難過'**
  String get moodSad;

  /// No description provided for @moodAngry.
  ///
  /// In zh, this message translates to:
  /// **'生氣'**
  String get moodAngry;

  /// No description provided for @moodCalm.
  ///
  /// In zh, this message translates to:
  /// **'平靜'**
  String get moodCalm;

  /// No description provided for @moodPassion.
  ///
  /// In zh, this message translates to:
  /// **'熱情'**
  String get moodPassion;

  /// No description provided for @moodLove.
  ///
  /// In zh, this message translates to:
  /// **'愛'**
  String get moodLove;

  /// No description provided for @moodOther.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get moodOther;

  /// No description provided for @gatheringEnded.
  ///
  /// In zh, this message translates to:
  /// **'{emoji} {name} 已結束'**
  String gatheringEnded(String emoji, String name);

  /// No description provided for @handedOffStillJoined.
  ///
  /// In zh, this message translates to:
  /// **'你已把 {emoji} {name} 交棒，現在是參加者。'**
  String handedOffStillJoined(String emoji, String name);

  /// No description provided for @handedOffNicknameFull.
  ///
  /// In zh, this message translates to:
  /// **'你已交棒。稱呼已滿 10 個字，請自己把 {emoji} 加進稱呼，才能繼續收到公告。'**
  String handedOffNicknameFull(String emoji);

  /// No description provided for @handedOffEmojiAdded.
  ///
  /// In zh, this message translates to:
  /// **'你已交棒，稱呼補上了 {emoji}，你現在是參加者。'**
  String handedOffEmojiAdded(String emoji);

  /// No description provided for @releaseNotesTitle.
  ///
  /// In zh, this message translates to:
  /// **'城市低語 1.1 內部測試版'**
  String get releaseNotesTitle;

  /// No description provided for @releaseNotesLead.
  ///
  /// In zh, this message translates to:
  /// **'這座城市換上了夜色。'**
  String get releaseNotesLead;

  /// No description provided for @releaseNotesMap.
  ///
  /// In zh, this message translates to:
  /// **'全新夜光地圖：深藍街區、微光道路、霓虹建築'**
  String get releaseNotesMap;

  /// No description provided for @releaseNotesBubbles.
  ///
  /// In zh, this message translates to:
  /// **'心情氣泡改為深色玻璃，在哪裡都看得清楚'**
  String get releaseNotesBubbles;

  /// No description provided for @releaseNotesResting.
  ///
  /// In zh, this message translates to:
  /// **'休息中與歷史殘影：鎖屏也能被敲門'**
  String get releaseNotesResting;

  /// No description provided for @releaseNotesSafety.
  ///
  /// In zh, this message translates to:
  /// **'檢舉與封鎖：讓城市保持安全'**
  String get releaseNotesSafety;

  /// No description provided for @gotIt.
  ///
  /// In zh, this message translates to:
  /// **'我知道了'**
  String get gotIt;

  /// No description provided for @blockedToast.
  ///
  /// In zh, this message translates to:
  /// **'已將此人沒入黑暗。'**
  String get blockedToast;

  /// No description provided for @unblockedToast.
  ///
  /// In zh, this message translates to:
  /// **'已解除封鎖，城市再次產生交集。'**
  String get unblockedToast;

  /// No description provided for @notificationToast.
  ///
  /// In zh, this message translates to:
  /// **'{title}：{body}'**
  String notificationToast(String title, String body);

  /// No description provided for @locationServiceOffTitle.
  ///
  /// In zh, this message translates to:
  /// **'請開啟定位服務'**
  String get locationServiceOffTitle;

  /// No description provided for @locationServiceOffBody.
  ///
  /// In zh, this message translates to:
  /// **'城市低語需要知道你在城市的哪個角落，才能讓附近的人看見你的心情。請到手機的「設定」開啟「定位服務」。'**
  String get locationServiceOffBody;

  /// No description provided for @locationReducedTitle.
  ///
  /// In zh, this message translates to:
  /// **'請開啟「精確位置」'**
  String get locationReducedTitle;

  /// No description provided for @locationReducedBodyIos.
  ///
  /// In zh, this message translates to:
  /// **'你目前只分享了大概的位置，雷達無法判斷誰在你附近。請到「設定」›「城市低語」›「位置」，打開「精確位置」。'**
  String get locationReducedBodyIos;

  /// No description provided for @locationReducedBodyAndroid.
  ///
  /// In zh, this message translates to:
  /// **'你目前只分享了大概的位置，雷達無法判斷誰在你附近。請在位置權限中選擇「精確」。'**
  String get locationReducedBodyAndroid;

  /// No description provided for @locationNoFixTitle.
  ///
  /// In zh, this message translates to:
  /// **'暫時抓不到你的位置'**
  String get locationNoFixTitle;

  /// No description provided for @locationNoFixBody.
  ///
  /// In zh, this message translates to:
  /// **'可能在室內或訊號較弱。請到窗邊或戶外、開啟 Wi-Fi 後再試一次。'**
  String get locationNoFixBody;

  /// No description provided for @locationNeededTitle.
  ///
  /// In zh, this message translates to:
  /// **'需要使用你的位置'**
  String get locationNeededTitle;

  /// No description provided for @locationNeededBody.
  ///
  /// In zh, this message translates to:
  /// **'城市低語只在你使用 App 時取得位置，用來顯示附近 5 公里內的心情；雷達上只顯示大概的距離，不會顯示地址。\n請在設定中允許「使用 App 期間」取用位置，並開啟「精確位置」。'**
  String get locationNeededBody;

  /// No description provided for @locationSimulatorHint.
  ///
  /// In zh, this message translates to:
  /// **'（開發提示：模擬器請在 Features › Location 選一個位置）'**
  String get locationSimulatorHint;

  /// No description provided for @openSettings.
  ///
  /// In zh, this message translates to:
  /// **'前往設定'**
  String get openSettings;

  /// No description provided for @locationRecheck.
  ///
  /// In zh, this message translates to:
  /// **'我已開啟，重新檢查'**
  String get locationRecheck;

  /// No description provided for @tryAgain.
  ///
  /// In zh, this message translates to:
  /// **'再試一次'**
  String get tryAgain;

  /// No description provided for @leaveApp.
  ///
  /// In zh, this message translates to:
  /// **'離開'**
  String get leaveApp;

  /// No description provided for @whispersNearby.
  ///
  /// In zh, this message translates to:
  /// **'你附近有 {count} 則低語，點信封讀讀看。'**
  String whispersNearby(int count);

  /// No description provided for @whisperPassed.
  ///
  /// In zh, this message translates to:
  /// **'你經過了一則低語，點信封讀讀看。'**
  String get whisperPassed;

  /// No description provided for @whisperLeft.
  ///
  /// In zh, this message translates to:
  /// **'你的低語留在這裡了，7 天後消散。'**
  String get whisperLeft;

  /// No description provided for @timeWhisperSealedYear.
  ///
  /// In zh, this message translates to:
  /// **'已封存。一年後，回到這裡就能打開。'**
  String get timeWhisperSealedYear;

  /// No description provided for @timeWhisperSealedMonth.
  ///
  /// In zh, this message translates to:
  /// **'已封存。一個月後，回到這裡就能打開。'**
  String get timeWhisperSealedMonth;

  /// No description provided for @whisperWithdrawn.
  ///
  /// In zh, this message translates to:
  /// **'低語已經收回。'**
  String get whisperWithdrawn;

  /// No description provided for @whisperMineLabel.
  ///
  /// In zh, this message translates to:
  /// **'你留下的低語'**
  String get whisperMineLabel;

  /// No description provided for @whisperTapToRead.
  ///
  /// In zh, this message translates to:
  /// **'一則低語，點一下閱讀'**
  String get whisperTapToRead;

  /// No description provided for @noMoodYet.
  ///
  /// In zh, this message translates to:
  /// **'無言中...'**
  String get noMoodYet;

  /// No description provided for @knockWithdrawnByLeaving.
  ///
  /// In zh, this message translates to:
  /// **'對方已沒入城市，悄悄收回敲門聲…'**
  String get knockWithdrawnByLeaving;

  /// No description provided for @knockCardTitle.
  ///
  /// In zh, this message translates to:
  /// **'片刻交集'**
  String get knockCardTitle;

  /// No description provided for @knockCardBody.
  ///
  /// In zh, this message translates to:
  /// **'{name} 正在敲門，\n想與你產生交集…'**
  String knockCardBody(String name);

  /// No description provided for @skip.
  ///
  /// In zh, this message translates to:
  /// **'略過'**
  String get skip;

  /// No description provided for @decline.
  ///
  /// In zh, this message translates to:
  /// **'婉拒'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get accept;

  /// No description provided for @reportThisPerson.
  ///
  /// In zh, this message translates to:
  /// **'檢舉這個人'**
  String get reportThisPerson;

  /// No description provided for @cityQuietTonight.
  ///
  /// In zh, this message translates to:
  /// **'今晚的城市還很安靜'**
  String get cityQuietTonight;

  /// No description provided for @cityMoodChip.
  ///
  /// In zh, this message translates to:
  /// **'今晚的城市 · {mood} {percent}%'**
  String cityMoodChip(String mood, String percent);

  /// No description provided for @cityMoodChipLabel.
  ///
  /// In zh, this message translates to:
  /// **'{text}，查看城市心情天氣'**
  String cityMoodChipLabel(String text);

  /// No description provided for @cityMoodTitle.
  ///
  /// In zh, this message translates to:
  /// **'今晚的城市心情'**
  String get cityMoodTitle;

  /// No description provided for @cityMoodQuietCount.
  ///
  /// In zh, this message translates to:
  /// **'城市還很安靜，今晚有 {total} 個人留下心情。'**
  String cityMoodQuietCount(int total);

  /// No description provided for @cityMoodCount.
  ///
  /// In zh, this message translates to:
  /// **'20 公里內，今晚有 {total} 個人留下心情'**
  String cityMoodCount(int total);

  /// No description provided for @cityMoodQuietInvite.
  ///
  /// In zh, this message translates to:
  /// **'多一點心情，城市就多一點光。寫下此刻的你，成為點亮城市的人。'**
  String get cityMoodQuietInvite;

  /// No description provided for @cityMoodFootnote.
  ///
  /// In zh, this message translates to:
  /// **'匿名統計 24 小時內的心情；少於 10 人時不顯示比例。'**
  String get cityMoodFootnote;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'關閉'**
  String get close;

  /// No description provided for @emptyRadarTitle.
  ///
  /// In zh, this message translates to:
  /// **'你是今晚第一道光'**
  String get emptyRadarTitle;

  /// No description provided for @emptyRadarBody.
  ///
  /// In zh, this message translates to:
  /// **'附近還沒有人。你的心情已經在城市裡發光，\n有人經過時，就會看見你。也可以留一則低語，給下一個經過這裡的人。'**
  String get emptyRadarBody;

  /// No description provided for @emptyRadarCityMood.
  ///
  /// In zh, this message translates to:
  /// **'今晚城市裡有 {total} 個人，多半感到「{mood}」'**
  String emptyRadarCityMood(String total, String mood);

  /// No description provided for @inviteFriends.
  ///
  /// In zh, this message translates to:
  /// **'邀請朋友點亮街區'**
  String get inviteFriends;

  /// No description provided for @shareMoodCard.
  ///
  /// In zh, this message translates to:
  /// **'分享我的心情卡'**
  String get shareMoodCard;

  /// No description provided for @editYourMood.
  ///
  /// In zh, this message translates to:
  /// **'編輯你的心情'**
  String get editYourMood;

  /// No description provided for @resonanceTonight.
  ///
  /// In zh, this message translates to:
  /// **'今晚 {count} 道微光與你共鳴'**
  String resonanceTonight(int count);

  /// No description provided for @dockNicknameMood.
  ///
  /// In zh, this message translates to:
  /// **'{nickname} · 你的心情'**
  String dockNicknameMood(String nickname);

  /// No description provided for @dockTapToEdit.
  ///
  /// In zh, this message translates to:
  /// **'你的心情 · 點一下修改'**
  String get dockTapToEdit;

  /// No description provided for @leaveWhisper.
  ///
  /// In zh, this message translates to:
  /// **'留下一則低語'**
  String get leaveWhisper;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @nightlyReminder.
  ///
  /// In zh, this message translates to:
  /// **'每晚提醒'**
  String get nightlyReminder;

  /// No description provided for @nightlyReminderSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'每晚 21:30 一則溫和的提醒'**
  String get nightlyReminderSubtitle;

  /// No description provided for @closeSettings.
  ///
  /// In zh, this message translates to:
  /// **'關閉設定'**
  String get closeSettings;

  /// No description provided for @settingsSectionMe.
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get settingsSectionMe;

  /// No description provided for @editProfile.
  ///
  /// In zh, this message translates to:
  /// **'編輯個人狀態'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'大頭貼、城市稱呼與心情'**
  String get editProfileSubtitle;

  /// No description provided for @manageBlockList.
  ///
  /// In zh, this message translates to:
  /// **'管理封鎖名單'**
  String get manageBlockList;

  /// No description provided for @manageBlockListSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'查看或解除被你沒入黑暗的人'**
  String get manageBlockListSubtitle;

  /// No description provided for @myTimeWhispers.
  ///
  /// In zh, this message translates to:
  /// **'我的低語穿越'**
  String get myTimeWhispers;

  /// No description provided for @myTimeWhispersSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'寫給未來的自己，只有你看得到'**
  String get myTimeWhispersSubtitle;

  /// No description provided for @myMoodTrail.
  ///
  /// In zh, this message translates to:
  /// **'我的心情軌跡'**
  String get myMoodTrail;

  /// No description provided for @myMoodTrailSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'只存在你的手機上'**
  String get myMoodTrailSubtitle;

  /// No description provided for @settingsSectionGatherings.
  ///
  /// In zh, this message translates to:
  /// **'集會'**
  String get settingsSectionGatherings;

  /// No description provided for @gatheringHost.
  ///
  /// In zh, this message translates to:
  /// **'集會主持人'**
  String get gatheringHost;

  /// No description provided for @gatheringHostSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'以你為中心 5 公里，開一場活動'**
  String get gatheringHostSubtitle;

  /// No description provided for @gatheringHosting.
  ///
  /// In zh, this message translates to:
  /// **'你正在主持 {emoji} {name}'**
  String gatheringHosting(String emoji, String name);

  /// No description provided for @settingsSectionShare.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get settingsSectionShare;

  /// No description provided for @shareMoodCardSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'十一張夜景插畫隨機出現，適合 IG 限時動態'**
  String get shareMoodCardSubtitle;

  /// No description provided for @inviteFriendsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'附近的人越多，城市越亮'**
  String get inviteFriendsSubtitle;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In zh, this message translates to:
  /// **'關於'**
  String get settingsSectionAbout;

  /// No description provided for @guide.
  ///
  /// In zh, this message translates to:
  /// **'操作說明'**
  String get guide;

  /// No description provided for @guideSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'從寫下心情到開一場集會，一次看懂'**
  String get guideSubtitle;

  /// No description provided for @termsOfUse.
  ///
  /// In zh, this message translates to:
  /// **'使用條款'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隱私權政策'**
  String get privacyPolicy;

  /// No description provided for @contactUs.
  ///
  /// In zh, this message translates to:
  /// **'聯絡我們'**
  String get contactUs;

  /// No description provided for @deleteAccount.
  ///
  /// In zh, this message translates to:
  /// **'刪除帳號與資料'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'永久抹除你在城市留下的一切'**
  String get deleteAccountSubtitle;

  /// No description provided for @avatarUploadFailed.
  ///
  /// In zh, this message translates to:
  /// **'大頭貼上傳失敗，請稍後再試。'**
  String get avatarUploadFailed;

  /// No description provided for @moodEmpty.
  ///
  /// In zh, this message translates to:
  /// **'心情不能為空，給城市留下點微光吧。'**
  String get moodEmpty;

  /// No description provided for @profileSyncFailed.
  ///
  /// In zh, this message translates to:
  /// **'狀態同步失敗，請稍後再試。'**
  String get profileSyncFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In zh, this message translates to:
  /// **'狀態已更新，城市正感知你的呼吸。'**
  String get profileUpdated;

  /// No description provided for @changeAvatar.
  ///
  /// In zh, this message translates to:
  /// **'更換大頭貼'**
  String get changeAvatar;

  /// No description provided for @avatarHint.
  ///
  /// In zh, this message translates to:
  /// **'輕觸更換大頭貼 · 光環是你的心情色'**
  String get avatarHint;

  /// No description provided for @cityName.
  ///
  /// In zh, this message translates to:
  /// **'城市稱呼'**
  String get cityName;

  /// No description provided for @cityNameHint.
  ///
  /// In zh, this message translates to:
  /// **'選填，例如：遊蕩的貓'**
  String get cityNameHint;

  /// No description provided for @currentMood.
  ///
  /// In zh, this message translates to:
  /// **'當下心情'**
  String get currentMood;

  /// No description provided for @currentMoodHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：漫步在微雨中 🌿'**
  String get currentMoodHint;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'儲存'**
  String get save;

  /// No description provided for @blockListTitle.
  ///
  /// In zh, this message translates to:
  /// **'沉入黑暗的名單'**
  String get blockListTitle;

  /// No description provided for @blockListEmpty.
  ///
  /// In zh, this message translates to:
  /// **'夜色清朗，你的城市未曾放逐任何人。'**
  String get blockListEmpty;

  /// No description provided for @unblock.
  ///
  /// In zh, this message translates to:
  /// **'解除放逐'**
  String get unblock;

  /// No description provided for @deleteAccountBody.
  ///
  /// In zh, this message translates to:
  /// **'你的位置、心情、城市稱呼、大頭貼、留下的低語、微光、封鎖名單與進行中的對話都會被永久刪除，無法復原。\n\n為了防止濫用，檢舉紀錄會依隱私權政策保留 1 年。'**
  String get deleteAccountBody;

  /// No description provided for @deleting.
  ///
  /// In zh, this message translates to:
  /// **'刪除中…'**
  String get deleting;

  /// No description provided for @deletePermanently.
  ///
  /// In zh, this message translates to:
  /// **'永久刪除'**
  String get deletePermanently;

  /// No description provided for @deleteFailed.
  ///
  /// In zh, this message translates to:
  /// **'刪除沒有完成，請檢查網路後再試一次。'**
  String get deleteFailed;

  /// No description provided for @fadingEcho.
  ///
  /// In zh, this message translates to:
  /// **'歷史殘影'**
  String get fadingEcho;

  /// No description provided for @clusterCount.
  ///
  /// In zh, this message translates to:
  /// **'這裡有 {count} 個心情'**
  String clusterCount(int count);

  /// No description provided for @clusterMore.
  ///
  /// In zh, this message translates to:
  /// **'更多\n+{count}'**
  String clusterMore(int count);

  /// No description provided for @clusterBackToFirst.
  ///
  /// In zh, this message translates to:
  /// **'回到\n第一批'**
  String get clusterBackToFirst;

  /// No description provided for @fadingEchoTitle.
  ///
  /// In zh, this message translates to:
  /// **'一道歷史殘影'**
  String get fadingEchoTitle;

  /// No description provided for @encounterWith.
  ///
  /// In zh, this message translates to:
  /// **'與 {name} 的相遇'**
  String encounterWith(String name);

  /// No description provided for @fadingEchoBody.
  ///
  /// In zh, this message translates to:
  /// **'這只是一道歷史殘影，無法產生交集。'**
  String get fadingEchoBody;

  /// No description provided for @demoPersonBody.
  ///
  /// In zh, this message translates to:
  /// **'這是示範對象，由程式自動回應，不是真人。可以用它體驗敲門、聊天、微光、檢舉與封鎖。'**
  String get demoPersonBody;

  /// No description provided for @sendGlimmer.
  ///
  /// In zh, this message translates to:
  /// **'送出一道微光 (共鳴)'**
  String get sendGlimmer;

  /// No description provided for @knock.
  ///
  /// In zh, this message translates to:
  /// **'敲門 (產生交集)'**
  String get knock;

  /// No description provided for @blockAction.
  ///
  /// In zh, this message translates to:
  /// **'封鎖 (沒入黑暗)'**
  String get blockAction;

  /// No description provided for @handOverHost.
  ///
  /// In zh, this message translates to:
  /// **'轉移主持人'**
  String get handOverHost;

  /// No description provided for @report.
  ///
  /// In zh, this message translates to:
  /// **'檢舉'**
  String get report;

  /// No description provided for @confirmBlockTitle.
  ///
  /// In zh, this message translates to:
  /// **'確認封鎖'**
  String get confirmBlockTitle;

  /// No description provided for @confirmBlockBody.
  ///
  /// In zh, this message translates to:
  /// **'確定要將 {name} 沒入黑暗嗎？\n封鎖後，雙方將從彼此的城市中消失。'**
  String confirmBlockBody(String name);

  /// No description provided for @confirmBlock.
  ///
  /// In zh, this message translates to:
  /// **'確定封鎖'**
  String get confirmBlock;

  /// No description provided for @glimmerReceived.
  ///
  /// In zh, this message translates to:
  /// **'有人送你一道微光，與你的心情共鳴。'**
  String get glimmerReceived;

  /// No description provided for @glimmerSent.
  ///
  /// In zh, this message translates to:
  /// **'你送出了一道微光。'**
  String get glimmerSent;

  /// No description provided for @glimmerAlreadySent.
  ///
  /// In zh, this message translates to:
  /// **'今天已經送過微光給對方了，明天再來吧。'**
  String get glimmerAlreadySent;

  /// No description provided for @knockSent.
  ///
  /// In zh, this message translates to:
  /// **'敲門聲已送出，等待回音…'**
  String get knockSent;

  /// No description provided for @knockFailed.
  ///
  /// In zh, this message translates to:
  /// **'敲門沒有送出，請稍後再試。'**
  String get knockFailed;

  /// No description provided for @knockNoAnswer.
  ///
  /// In zh, this message translates to:
  /// **'沒有回音，敲門聲悄悄消散了。'**
  String get knockNoAnswer;

  /// No description provided for @knockDeclined.
  ///
  /// In zh, this message translates to:
  /// **'這次沒有交集，讓彼此保留一點空間。'**
  String get knockDeclined;

  /// No description provided for @knockSkipped.
  ///
  /// In zh, this message translates to:
  /// **'對方先略過了，敲門聲悄悄消散。'**
  String get knockSkipped;

  /// No description provided for @sensingCity.
  ///
  /// In zh, this message translates to:
  /// **'正在感知這座城市...'**
  String get sensingCity;

  /// No description provided for @gatheringUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'活動功能暫時無法使用，請稍後再試。'**
  String get gatheringUnavailable;

  /// No description provided for @notSentCheckNetwork.
  ///
  /// In zh, this message translates to:
  /// **'沒有送出，請檢查網路後再試一次。'**
  String get notSentCheckNetwork;

  /// No description provided for @justNow.
  ///
  /// In zh, this message translates to:
  /// **'剛剛'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count} 分鐘前'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count} 小時前'**
  String hoursAgo(int count);

  /// No description provided for @nextDayPrefix.
  ///
  /// In zh, this message translates to:
  /// **'隔天 '**
  String get nextDayPrefix;

  /// No description provided for @gatheringNameMissing.
  ///
  /// In zh, this message translates to:
  /// **'請幫活動取個名字。'**
  String get gatheringNameMissing;

  /// No description provided for @gatheringEmojiInvalid.
  ///
  /// In zh, this message translates to:
  /// **'活動圖標要剛好是一個表情符號。'**
  String get gatheringEmojiInvalid;

  /// No description provided for @gatheringStarted.
  ///
  /// In zh, this message translates to:
  /// **'{emoji} {name} 開始了。請參加的人把 {emoji} 加進城市稱呼。'**
  String gatheringStarted(String emoji, String name);

  /// No description provided for @startGatheringTitle.
  ///
  /// In zh, this message translates to:
  /// **'開一場集會'**
  String get startGatheringTitle;

  /// No description provided for @startGatheringLead.
  ///
  /// In zh, this message translates to:
  /// **'以你的位置為中心 5 公里。你走到哪，範圍就跟到哪。'**
  String get startGatheringLead;

  /// No description provided for @gatheringNameHint.
  ///
  /// In zh, this message translates to:
  /// **'活動名稱，例如：台北101跨年煙火秀'**
  String get gatheringNameHint;

  /// No description provided for @gatheringEmojiHint.
  ///
  /// In zh, this message translates to:
  /// **'圖標'**
  String get gatheringEmojiHint;

  /// No description provided for @gatheringEmojiHelp.
  ///
  /// In zh, this message translates to:
  /// **'活動圖標：一個表情符號。附近沒人在用才能選。'**
  String get gatheringEmojiHelp;

  /// No description provided for @gatheringEmojiJoinHelp.
  ///
  /// In zh, this message translates to:
  /// **'參加的人把 {emoji} 加進自己的城市稱呼，就會看到你的公告、收到推播。'**
  String gatheringEmojiJoinHelp(String emoji);

  /// No description provided for @start.
  ///
  /// In zh, this message translates to:
  /// **'開始'**
  String get start;

  /// No description provided for @end.
  ///
  /// In zh, this message translates to:
  /// **'結束'**
  String get end;

  /// No description provided for @gatheringMaxDuration.
  ///
  /// In zh, this message translates to:
  /// **'整場最長 24 小時，時間到自動結束。'**
  String get gatheringMaxDuration;

  /// No description provided for @starting.
  ///
  /// In zh, this message translates to:
  /// **'開始中…'**
  String get starting;

  /// No description provided for @startGathering.
  ///
  /// In zh, this message translates to:
  /// **'開始活動'**
  String get startGathering;

  /// No description provided for @gatheringEndedYouBack.
  ///
  /// In zh, this message translates to:
  /// **'{emoji} {name} 已結束，你回到了城市裡。'**
  String gatheringEndedYouBack(String emoji, String name);

  /// No description provided for @hostingTimeRange.
  ///
  /// In zh, this message translates to:
  /// **'{range} · 你正在主持'**
  String hostingTimeRange(String range);

  /// No description provided for @hostAudienceRule.
  ///
  /// In zh, this message translates to:
  /// **'5 公里內、稱呼裡有 {emoji} 的人會看到公告並收到推播。你看不到他們是誰。'**
  String hostAudienceRule(String emoji);

  /// No description provided for @postAnnouncement.
  ///
  /// In zh, this message translates to:
  /// **'發布公告'**
  String get postAnnouncement;

  /// No description provided for @announcementHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：隊伍在忠孝東路口集合'**
  String get announcementHint;

  /// No description provided for @announcementSent.
  ///
  /// In zh, this message translates to:
  /// **'公告已送出'**
  String get announcementSent;

  /// No description provided for @announcementLine.
  ///
  /// In zh, this message translates to:
  /// **'{ago}　{text}'**
  String announcementLine(String ago, String text);

  /// No description provided for @announcementHiddenSuffix.
  ///
  /// In zh, this message translates to:
  /// **'（已因多人檢舉隱藏）'**
  String get announcementHiddenSuffix;

  /// No description provided for @groupQuestion.
  ///
  /// In zh, this message translates to:
  /// **'全場提問'**
  String get groupQuestion;

  /// No description provided for @questionHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：此刻的你？'**
  String get questionHint;

  /// No description provided for @sendQuestion.
  ///
  /// In zh, this message translates to:
  /// **'送出提問'**
  String get sendQuestion;

  /// No description provided for @questionSent.
  ///
  /// In zh, this message translates to:
  /// **'提問已送出，大家會用心情回答'**
  String get questionSent;

  /// No description provided for @handOff.
  ///
  /// In zh, this message translates to:
  /// **'交棒'**
  String get handOff;

  /// No description provided for @handoffPending.
  ///
  /// In zh, this message translates to:
  /// **'已邀請 {name} 接下主持，等待回覆中…'**
  String handoffPending(String name);

  /// No description provided for @theOtherPerson.
  ///
  /// In zh, this message translates to:
  /// **'對方'**
  String get theOtherPerson;

  /// No description provided for @handoffCancelled.
  ///
  /// In zh, this message translates to:
  /// **'已取消交棒邀請'**
  String get handoffCancelled;

  /// No description provided for @handoffHelp.
  ///
  /// In zh, this message translates to:
  /// **'長按雷達上參加者的氣泡 →「轉移主持人」，對方同意後就由他主持，活動與公告都不會中斷。'**
  String get handoffHelp;

  /// No description provided for @confirmEndAgain.
  ///
  /// In zh, this message translates to:
  /// **'確定結束？再按一次'**
  String get confirmEndAgain;

  /// No description provided for @endGathering.
  ///
  /// In zh, this message translates to:
  /// **'結束活動'**
  String get endGathering;

  /// No description provided for @tallyHeader.
  ///
  /// In zh, this message translates to:
  /// **'「{question}」· {total} 人回答'**
  String tallyHeader(String question, int total);

  /// No description provided for @tallyQuiet.
  ///
  /// In zh, this message translates to:
  /// **'滿 10 人回答才顯示比例，避免人少時猜得出是誰。'**
  String get tallyQuiet;

  /// No description provided for @bannerYouHost.
  ///
  /// In zh, this message translates to:
  /// **'  · 你正在主持'**
  String get bannerYouHost;

  /// No description provided for @bannerHostAnnouncement.
  ///
  /// In zh, this message translates to:
  /// **'  · 主持人公告'**
  String get bannerHostAnnouncement;

  /// No description provided for @manageGathering.
  ///
  /// In zh, this message translates to:
  /// **'管理活動'**
  String get manageGathering;

  /// No description provided for @reportAnnouncement.
  ///
  /// In zh, this message translates to:
  /// **'檢舉這則公告'**
  String get reportAnnouncement;

  /// No description provided for @expandAnnouncement.
  ///
  /// In zh, this message translates to:
  /// **'展開公告'**
  String get expandAnnouncement;

  /// No description provided for @collapseAnnouncement.
  ///
  /// In zh, this message translates to:
  /// **'收起公告'**
  String get collapseAnnouncement;

  /// No description provided for @hostHandedOffAgo.
  ///
  /// In zh, this message translates to:
  /// **'主持人已交棒 · {ago}'**
  String hostHandedOffAgo(String ago);

  /// No description provided for @announcementReportedHidden.
  ///
  /// In zh, this message translates to:
  /// **'你檢舉了這則公告，已從你的畫面移除。'**
  String get announcementReportedHidden;

  /// No description provided for @noAnnouncementHost.
  ///
  /// In zh, this message translates to:
  /// **'還沒有公告。按右上角的調整鈕發布第一則。'**
  String get noAnnouncementHost;

  /// No description provided for @noAnnouncementGuest.
  ///
  /// In zh, this message translates to:
  /// **'主持人還沒有發公告。'**
  String get noAnnouncementGuest;

  /// No description provided for @hostAsks.
  ///
  /// In zh, this message translates to:
  /// **'主持人問：{question}'**
  String hostAsks(String question);

  /// No description provided for @answeredNote.
  ///
  /// In zh, this message translates to:
  /// **'已回答。主持人只會看到全場的心情比例。'**
  String get answeredNote;

  /// No description provided for @answerHint.
  ///
  /// In zh, this message translates to:
  /// **'用一句心情回答'**
  String get answerHint;

  /// No description provided for @sendAnswer.
  ///
  /// In zh, this message translates to:
  /// **'送出回答'**
  String get sendAnswer;

  /// No description provided for @handoffInvited.
  ///
  /// In zh, this message translates to:
  /// **'已邀請 {name} 接下主持，等對方回覆（5 分鐘內有效）。'**
  String handoffInvited(String name);

  /// No description provided for @handoffTitle.
  ///
  /// In zh, this message translates to:
  /// **'把活動交給 {name}'**
  String handoffTitle(String name);

  /// No description provided for @handoffBody.
  ///
  /// In zh, this message translates to:
  /// **'對方同意後，由他主持這場活動；名稱、公告與提問都會留著。你會變回參加者。'**
  String get handoffBody;

  /// No description provided for @handoffPublic.
  ///
  /// In zh, this message translates to:
  /// **'公開交棒'**
  String get handoffPublic;

  /// No description provided for @handoffPublicHelp.
  ///
  /// In zh, this message translates to:
  /// **'通知所有參加者「主持人已交棒」'**
  String get handoffPublicHelp;

  /// No description provided for @handoffQuiet.
  ///
  /// In zh, this message translates to:
  /// **'安靜交棒'**
  String get handoffQuiet;

  /// No description provided for @handoffQuietHelp.
  ///
  /// In zh, this message translates to:
  /// **'不通知任何人，只有雷達上的「主持」光環換人'**
  String get handoffQuietHelp;

  /// No description provided for @sending.
  ///
  /// In zh, this message translates to:
  /// **'送出中…'**
  String get sending;

  /// No description provided for @sendInvite.
  ///
  /// In zh, this message translates to:
  /// **'送出邀請'**
  String get sendInvite;

  /// No description provided for @youAreNowHost.
  ///
  /// In zh, this message translates to:
  /// **'你現在是 {emoji} {name} 的主持人。'**
  String youAreNowHost(String emoji, String name);

  /// No description provided for @handoffOfferTitle.
  ///
  /// In zh, this message translates to:
  /// **'想請你接下主持'**
  String get handoffOfferTitle;

  /// No description provided for @handoffOfferBody.
  ///
  /// In zh, this message translates to:
  /// **'主持人想把「{name}」交給你。接下後，你可以發公告、提問與結束活動，也要對公告內容負責。'**
  String handoffOfferBody(String name);

  /// No description provided for @processing.
  ///
  /// In zh, this message translates to:
  /// **'處理中…'**
  String get processing;

  /// No description provided for @acceptHosting.
  ///
  /// In zh, this message translates to:
  /// **'接下主持'**
  String get acceptHosting;

  /// No description provided for @guideS1Title.
  ///
  /// In zh, this message translates to:
  /// **'1. 走進城市'**
  String get guideS1Title;

  /// No description provided for @guideS1L1.
  ///
  /// In zh, this message translates to:
  /// **'第一次開啟時，請確認你已年滿 18 歲，並允許「使用 App 時」取得精確位置；沒有精確位置，雷達無法運作。'**
  String get guideS1L1;

  /// No description provided for @guideS1L2.
  ///
  /// In zh, this message translates to:
  /// **'寫下一句此刻的心情（最多 20 個字），勾選同意《使用條款》與《隱私權政策》，按「走進城市低語」。'**
  String get guideS1L2;

  /// No description provided for @guideS1L3.
  ///
  /// In zh, this message translates to:
  /// **'不需要手機號碼、Email 或真名。帳號是匿名的，綁定在這支手機上。'**
  String get guideS1L3;

  /// No description provided for @guideS1L4.
  ///
  /// In zh, this message translates to:
  /// **'心情的顏色由字裡的關鍵字決定：「開心、笑」金黃，「難過、哭」藍，「生氣、怒」橘紅，「平靜、發呆」綠，「熱情」橘，「愛、心」粉紅，其他是淡紫。'**
  String get guideS1L4;

  /// No description provided for @guideS2Title.
  ///
  /// In zh, this message translates to:
  /// **'2. 底部選單'**
  String get guideS2Title;

  /// No description provided for @guideS2L1.
  ///
  /// In zh, this message translates to:
  /// **'點左邊自己的頭像：編輯大頭貼、城市稱呼（最多 10 個字）與心情。'**
  String get guideS2L1;

  /// No description provided for @guideS2L2.
  ///
  /// In zh, this message translates to:
  /// **'筆記圖示：在這裡留下一則低語。'**
  String get guideS2L2;

  /// No description provided for @guideS2L3.
  ///
  /// In zh, this message translates to:
  /// **'分享圖示：把此刻的心情做成一張夜景卡片。'**
  String get guideS2L3;

  /// No description provided for @guideS2L4.
  ///
  /// In zh, this message translates to:
  /// **'最右邊的調整圖示：打開設定。'**
  String get guideS2L4;

  /// No description provided for @guideS3Title.
  ///
  /// In zh, this message translates to:
  /// **'3. 雷達與氣泡'**
  String get guideS3Title;

  /// No description provided for @guideS3L1.
  ///
  /// In zh, this message translates to:
  /// **'雷達上會浮現 5 公里內其他人的心情氣泡，只顯示分級的距離（例如「100m 內」），不顯示地址。'**
  String get guideS3L1;

  /// No description provided for @guideS3L2.
  ///
  /// In zh, this message translates to:
  /// **'會呼吸的氣泡代表對方正在使用；變暗並標示「休息中」代表對方鎖了螢幕，仍可以敲門；灰色、沒有名字的是「歷史殘影」，是剛離開的人留下的，會慢慢淡去。'**
  String get guideS3L2;

  /// No description provided for @guideS3L3.
  ///
  /// In zh, this message translates to:
  /// **'雙指可以放大縮小地圖。轉動手機，雷達會跟著你面向的方向轉。'**
  String get guideS3L3;

  /// No description provided for @guideS3L4.
  ///
  /// In zh, this message translates to:
  /// **'氣泡太密集時會合成一顆光球「這裡有 N 個心情」，點一下就展開成一圈，每顆都點得到；點中間或空白處收起。'**
  String get guideS3L4;

  /// No description provided for @guideS3L5.
  ///
  /// In zh, this message translates to:
  /// **'名字前有「示範」的是示範對象，由程式自動回應，不是真人，可以用來體驗所有功能。'**
  String get guideS3L5;

  /// No description provided for @guideS3L6.
  ///
  /// In zh, this message translates to:
  /// **'附近都沒有人時，畫面下方會出現「你是今晚第一道光」，可以邀請朋友一起點亮街區。'**
  String get guideS3L6;

  /// No description provided for @guideS4Title.
  ///
  /// In zh, this message translates to:
  /// **'4. 敲門與聊天'**
  String get guideS4Title;

  /// No description provided for @guideS4L1.
  ///
  /// In zh, this message translates to:
  /// **'長按別人的氣泡 →「敲門」。對方有 5 分鐘可以回應：同意、婉拒或略過。等待時，你會看到一道光從你流向對方。'**
  String get guideS4L1;

  /// No description provided for @guideS4L2.
  ///
  /// In zh, this message translates to:
  /// **'對方同意後開始對話，倒數 10 分鐘；任何一方傳新訊息就重新倒數，安靜下來就結束。'**
  String get guideS4L2;

  /// No description provided for @guideS4L3.
  ///
  /// In zh, this message translates to:
  /// **'對話結束後，訊息會從伺服器刪除。對方仍可能截圖，請斟酌分享的內容。'**
  String get guideS4L3;

  /// No description provided for @guideS4L4.
  ///
  /// In zh, this message translates to:
  /// **'有人敲你的門時，會跳出敲門卡片，可以同意、婉拒、略過，或直接檢舉。'**
  String get guideS4L4;

  /// No description provided for @guideS5Title.
  ///
  /// In zh, this message translates to:
  /// **'5. 微光'**
  String get guideS5Title;

  /// No description provided for @guideS5L1.
  ///
  /// In zh, this message translates to:
  /// **'雙擊別人的氣泡，或長按選「送出一道微光」，讓對方知道有人看見了，不需要開口。'**
  String get guideS5L1;

  /// No description provided for @guideS5L2.
  ///
  /// In zh, this message translates to:
  /// **'對方只會看到「今晚 N 道微光與你共鳴」，永遠不知道是誰送的。同一個人 24 小時內只能送一次。'**
  String get guideS5L2;

  /// No description provided for @guideS6Title.
  ///
  /// In zh, this message translates to:
  /// **'6. 低語'**
  String get guideS6Title;

  /// No description provided for @guideS6L1.
  ///
  /// In zh, this message translates to:
  /// **'按底部選單的筆記圖示，在你所在的地方留下一句話（最多 60 個字）。'**
  String get guideS6L1;

  /// No description provided for @guideS6L2.
  ///
  /// In zh, this message translates to:
  /// **'接下來 7 天，經過那一帶 300 公尺內的人會在雷達上看到信封，打開就能讀到。'**
  String get guideS6L2;

  /// No description provided for @guideS6L3.
  ///
  /// In zh, this message translates to:
  /// **'低語永遠匿名；每人同時最多留 3 則、每 10 分鐘最多 1 則，可以隨時收回。'**
  String get guideS6L3;

  /// No description provided for @guideS6L4.
  ///
  /// In zh, this message translates to:
  /// **'低語穿越：寫低語時選「寄給未來的自己」，再選一個月後或一年後。只有你看得到；時間到了會通知你，回到那裡 100 公尺內就會自動打開，讀過一次就會消失。雷達上只有你看得到一個小沙漏（上鎖／解鎖），不能點。每人同時最多 5 封，設定 →「我的低語穿越」可以查看或刪除。'**
  String get guideS6L4;

  /// No description provided for @guideS7Title.
  ///
  /// In zh, this message translates to:
  /// **'7. 城市心情天氣'**
  String get guideS7Title;

  /// No description provided for @guideS7L1.
  ///
  /// In zh, this message translates to:
  /// **'左上角的標籤顯示 20 公里內、24 小時內大家最多的心情；點一下看完整比例。'**
  String get guideS7L1;

  /// No description provided for @guideS7L2.
  ///
  /// In zh, this message translates to:
  /// **'少於 10 人時不顯示比例，避免猜得出是誰。'**
  String get guideS7L2;

  /// No description provided for @guideS8Title.
  ///
  /// In zh, this message translates to:
  /// **'8. 集會'**
  String get guideS8Title;

  /// No description provided for @guideS8L1.
  ///
  /// In zh, this message translates to:
  /// **'開活動：設定 → 集會主持人 → 填活動名稱、一個表情符號當圖標、開始與結束時間（最長 24 小時）→ 開始活動。'**
  String get guideS8L1;

  /// No description provided for @guideS8L2.
  ///
  /// In zh, this message translates to:
  /// **'範圍是以主持人為中心 5 公里，主持人走到哪，範圍就跟到哪。主持人在雷達上有一圈光環和「主持」標示。'**
  String get guideS8L2;

  /// No description provided for @guideS8L3.
  ///
  /// In zh, this message translates to:
  /// **'主持人可以發公告（不限次數）、提出全場提問，也可以隨時結束活動。'**
  String get guideS8L3;

  /// No description provided for @guideS8L4.
  ///
  /// In zh, this message translates to:
  /// **'參加：把活動的圖標加進你的城市稱呼（例如「遊蕩的貓🌈」），人在範圍內就會看到雷達上方的置頂公告，並收到推播。把圖標移除就退出。'**
  String get guideS8L4;

  /// No description provided for @guideS8L5.
  ///
  /// In zh, this message translates to:
  /// **'全場提問：用一句心情回答；主持人只看得到全場的心情比例，看不到誰回答了什麼，少於 10 人時不顯示比例。'**
  String get guideS8L5;

  /// No description provided for @guideS8L6.
  ///
  /// In zh, this message translates to:
  /// **'同一個圖標在同一區域同時只能有一場活動；活動結束後，任何人都可以用。'**
  String get guideS8L6;

  /// No description provided for @guideS8L7.
  ///
  /// In zh, this message translates to:
  /// **'交棒：主持人長按某位參加者的氣泡 →「轉移主持人」，選公開交棒（通知所有人）或安靜交棒（不通知），對方 5 分鐘內同意就由他主持，公告與提問都會留著；原主持人變回參加者，稱呼會自動補上圖標。'**
  String get guideS8L7;

  /// No description provided for @guideS9Title.
  ///
  /// In zh, this message translates to:
  /// **'9. 城市燈塔（友善廁所）'**
  String get guideS9Title;

  /// No description provided for @guideS9L1.
  ///
  /// In zh, this message translates to:
  /// **'點地圖左下角的廁所圖示打開燈塔，雷達上會出現 2 公里內的性別友善、無障礙與親子廁所，圖示旁會顯示數量；可以再點上方的三個圓形篩選，只看其中幾種。'**
  String get guideS9L1;

  /// No description provided for @guideS9L2.
  ///
  /// In zh, this message translates to:
  /// **'點一下標記可以看樓層、設施與距離，按「走路過去」用手機的地圖 App 導航。'**
  String get guideS9L2;

  /// No description provided for @guideS9L3.
  ///
  /// In zh, this message translates to:
  /// **'資料來自環境部「全國公廁建檔資料」，每月更新；沒有開放時間，「晚上可能有開」是依場所推估的。'**
  String get guideS9L3;

  /// No description provided for @guideS9L4.
  ///
  /// In zh, this message translates to:
  /// **'資料不對時可以回報（不是性別友善、晚上沒開、找不到）；同一種問題有 3 個人回報，標記會變灰並註明。'**
  String get guideS9L4;

  /// No description provided for @guideS10Title.
  ///
  /// In zh, this message translates to:
  /// **'10. 心情卡與心情軌跡'**
  String get guideS10Title;

  /// No description provided for @guideS10L1.
  ///
  /// In zh, this message translates to:
  /// **'底部選單的分享鈕可以把此刻的心情做成一張夜景卡片，適合 IG 限時動態；卡片上不會有你的位置。'**
  String get guideS10L1;

  /// No description provided for @guideS10L2.
  ///
  /// In zh, this message translates to:
  /// **'設定 →「我的心情軌跡」可以回顧你寫過的心情與地點，資料只存在你的手機上，可以隨時關閉或清除。'**
  String get guideS10L2;

  /// No description provided for @guideS11Title.
  ///
  /// In zh, this message translates to:
  /// **'11. 設定與通知'**
  String get guideS11Title;

  /// No description provided for @guideS11L1.
  ///
  /// In zh, this message translates to:
  /// **'「每晚提醒」：每天 21:30 一則溫和的提醒，可以在設定裡開關。'**
  String get guideS11L1;

  /// No description provided for @guideS11L2.
  ///
  /// In zh, this message translates to:
  /// **'敲門、新訊息、微光與集會公告會以推播通知你；可以在手機的系統設定裡關閉。'**
  String get guideS11L2;

  /// No description provided for @guideS11L3.
  ///
  /// In zh, this message translates to:
  /// **'每週五 21:00–23:00 是「點亮之夜」，大家一起上線，城市最亮。'**
  String get guideS11L3;

  /// No description provided for @guideS12Title.
  ///
  /// In zh, this message translates to:
  /// **'12. 檢舉與封鎖'**
  String get guideS12Title;

  /// No description provided for @guideS12L1.
  ///
  /// In zh, this message translates to:
  /// **'長按氣泡、敲門卡片、聊天室右上角、低語與集會公告都可以檢舉。檢舉後，那個人或那則內容會立刻從你的畫面消失，聊天室也會立即結束；我們會在 24 小時內處理。'**
  String get guideS12L1;

  /// No description provided for @guideS12L2.
  ///
  /// In zh, this message translates to:
  /// **'心情、稱呼、低語、聊天訊息與集會公告都會自動過濾不當字詞、電話與網址等聯絡方式。'**
  String get guideS12L2;

  /// No description provided for @guideS12L3.
  ///
  /// In zh, this message translates to:
  /// **'封鎖後，雙方會從彼此的雷達上消失，也不能再敲門或送微光。設定 →「管理封鎖名單」可以解除。'**
  String get guideS12L3;

  /// No description provided for @guideS12L4.
  ///
  /// In zh, this message translates to:
  /// **'遇到立即的危險，請直接撥打 110。'**
  String get guideS12L4;

  /// No description provided for @guideS13Title.
  ///
  /// In zh, this message translates to:
  /// **'13. 隱私與帳號'**
  String get guideS13Title;

  /// No description provided for @guideS13L1.
  ///
  /// In zh, this message translates to:
  /// **'附近的人看得到你的心情、城市稱呼、大頭貼與大概的距離；只有在你使用 App 時才會取得位置。'**
  String get guideS13L1;

  /// No description provided for @guideS13L2.
  ///
  /// In zh, this message translates to:
  /// **'設定 →「刪除帳號與資料」可以隨時永久刪除你在城市留下的一切。'**
  String get guideS13L2;

  /// No description provided for @guideS13L3.
  ///
  /// In zh, this message translates to:
  /// **'有任何問題，設定 →「聯絡我們」或寫信到 service.softchip@gmail.com。'**
  String get guideS13L3;

  /// No description provided for @guideIntro.
  ///
  /// In zh, this message translates to:
  /// **'城市低語是一座夜裡的城市：寫下一句此刻的心情，看見附近的人此刻的感受。'**
  String get guideIntro;

  /// No description provided for @beaconGender.
  ///
  /// In zh, this message translates to:
  /// **'性別友善'**
  String get beaconGender;

  /// No description provided for @beaconAccessible.
  ///
  /// In zh, this message translates to:
  /// **'無障礙'**
  String get beaconAccessible;

  /// No description provided for @beaconFamily.
  ///
  /// In zh, this message translates to:
  /// **'親子'**
  String get beaconFamily;

  /// No description provided for @beaconReportNotGender.
  ///
  /// In zh, this message translates to:
  /// **'不是性別友善'**
  String get beaconReportNotGender;

  /// No description provided for @beaconReportClosed.
  ///
  /// In zh, this message translates to:
  /// **'晚上沒開'**
  String get beaconReportClosed;

  /// No description provided for @beaconReportMissing.
  ///
  /// In zh, this message translates to:
  /// **'找不到這間廁所'**
  String get beaconReportMissing;

  /// No description provided for @beaconFlagNotGender.
  ///
  /// In zh, this message translates to:
  /// **'有人回報：不是性別友善'**
  String get beaconFlagNotGender;

  /// No description provided for @beaconFlagClosed.
  ///
  /// In zh, this message translates to:
  /// **'有人回報：晚上沒開'**
  String get beaconFlagClosed;

  /// No description provided for @beaconFlagMissing.
  ///
  /// In zh, this message translates to:
  /// **'有人回報：找不到'**
  String get beaconFlagMissing;

  /// No description provided for @beaconDefaultName.
  ///
  /// In zh, this message translates to:
  /// **'公廁'**
  String get beaconDefaultName;

  /// No description provided for @meters.
  ///
  /// In zh, this message translates to:
  /// **'{m} 公尺'**
  String meters(int m);

  /// No description provided for @kilometers.
  ///
  /// In zh, this message translates to:
  /// **'{km} 公里'**
  String kilometers(String km);

  /// No description provided for @beaconUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'城市燈塔暫時無法使用，請稍後再試。'**
  String get beaconUnavailable;

  /// No description provided for @notConnectedCheckNetwork.
  ///
  /// In zh, this message translates to:
  /// **'沒有連上，請檢查網路後再試一次。'**
  String get notConnectedCheckNetwork;

  /// No description provided for @beaconMarkerLabel.
  ///
  /// In zh, this message translates to:
  /// **'{features}廁所，{name}，{distance}'**
  String beaconMarkerLabel(String features, String name, String distance);

  /// No description provided for @listSeparator.
  ///
  /// In zh, this message translates to:
  /// **'、'**
  String get listSeparator;

  /// No description provided for @beaconToggleOff.
  ///
  /// In zh, this message translates to:
  /// **'關閉城市燈塔（友善廁所），附近 {count} 間'**
  String beaconToggleOff(int count);

  /// No description provided for @beaconToggleOn.
  ///
  /// In zh, this message translates to:
  /// **'打開城市燈塔（友善廁所）'**
  String get beaconToggleOn;

  /// No description provided for @beaconFilterOnly.
  ///
  /// In zh, this message translates to:
  /// **'只看{feature}'**
  String beaconFilterOnly(String feature);

  /// No description provided for @beaconMaybeOpenNight.
  ///
  /// In zh, this message translates to:
  /// **'晚上可能有開（推估）'**
  String get beaconMaybeOpenNight;

  /// No description provided for @beaconMaybeDaytime.
  ///
  /// In zh, this message translates to:
  /// **'可能只在白天開（推估）'**
  String get beaconMaybeDaytime;

  /// No description provided for @walkThere.
  ///
  /// In zh, this message translates to:
  /// **'走路過去'**
  String get walkThere;

  /// No description provided for @beaconWrongData.
  ///
  /// In zh, this message translates to:
  /// **'資料不對嗎？'**
  String get beaconWrongData;

  /// No description provided for @beaconThanks.
  ///
  /// In zh, this message translates to:
  /// **'謝謝你，已經收到「{reason}」的回報。'**
  String beaconThanks(String reason);

  /// No description provided for @beaconSource.
  ///
  /// In zh, this message translates to:
  /// **'資料來源：環境部「全國公廁建檔資料」，每月更新。開放時間是依場所推估的。'**
  String get beaconSource;

  /// No description provided for @invite1.
  ///
  /// In zh, this message translates to:
  /// **'我在城市低語點亮了一道光。附近的人越多，街區就越亮，一起來點亮我們的街區吧：'**
  String get invite1;

  /// No description provided for @invite2.
  ///
  /// In zh, this message translates to:
  /// **'今晚的城市有點安靜。來城市低語寫下一句心情，讓我們的街區亮起來：'**
  String get invite2;

  /// No description provided for @invite3.
  ///
  /// In zh, this message translates to:
  /// **'不用加好友、不用真名，只要一句此刻的心情。來城市低語找我：'**
  String get invite3;

  /// No description provided for @invite4.
  ///
  /// In zh, this message translates to:
  /// **'我在城市低語留了一盞燈給你。打開 App，看看今晚附近的人都在想什麼：'**
  String get invite4;

  /// No description provided for @invite5.
  ///
  /// In zh, this message translates to:
  /// **'每週五晚上九點是城市低語的點亮之夜，一起上線，讓雷達亮成一片吧：'**
  String get invite5;

  /// No description provided for @invite6.
  ///
  /// In zh, this message translates to:
  /// **'想找個地方說說今天的心情嗎？城市低語是匿名的，說完就消散：'**
  String get invite6;

  /// No description provided for @invite7.
  ///
  /// In zh, this message translates to:
  /// **'走在路上的時候，你會好奇擦肩而過的人在想什麼嗎？來城市低語看看：'**
  String get invite7;

  /// No description provided for @invite8.
  ///
  /// In zh, this message translates to:
  /// **'我在這條街留下了一則低語，經過的人才讀得到。你也來留一則吧：'**
  String get invite8;

  /// No description provided for @invite9.
  ///
  /// In zh, this message translates to:
  /// **'城市低語是一張夜裡的心情地圖。人越多越好玩，來幫我們的街區多點一道光：'**
  String get invite9;

  /// No description provided for @invite10.
  ///
  /// In zh, this message translates to:
  /// **'今晚的你，心情是什麼顏色？來城市低語寫下來，我在附近等你的光：'**
  String get invite10;

  /// No description provided for @shareInvite.
  ///
  /// In zh, this message translates to:
  /// **'分享邀請'**
  String get shareInvite;

  /// No description provided for @inviteSubject.
  ///
  /// In zh, this message translates to:
  /// **'一起來點亮我們的街區'**
  String get inviteSubject;

  /// No description provided for @shareMoodCardButton.
  ///
  /// In zh, this message translates to:
  /// **'分享心情卡'**
  String get shareMoodCardButton;

  /// No description provided for @moodShareText.
  ///
  /// In zh, this message translates to:
  /// **'我在城市低語留下了此刻的心情：「{mood}」\n今晚，你的心情也在城市裡發光嗎？'**
  String moodShareText(String mood);

  /// No description provided for @shareFailed.
  ///
  /// In zh, this message translates to:
  /// **'沒有分享出去，請再試一次。'**
  String get shareFailed;

  /// No description provided for @shuffleCard.
  ///
  /// In zh, this message translates to:
  /// **'換一張 · {current} / {total}'**
  String shuffleCard(int current, int total);

  /// No description provided for @preparing.
  ///
  /// In zh, this message translates to:
  /// **'準備中…'**
  String get preparing;

  /// No description provided for @sendLinkToFriends.
  ///
  /// In zh, this message translates to:
  /// **'傳連結給朋友（LINE、Messenger）'**
  String get sendLinkToFriends;

  /// No description provided for @partLateNight.
  ///
  /// In zh, this message translates to:
  /// **'深夜'**
  String get partLateNight;

  /// No description provided for @partMorning.
  ///
  /// In zh, this message translates to:
  /// **'早晨'**
  String get partMorning;

  /// No description provided for @partAfternoon.
  ///
  /// In zh, this message translates to:
  /// **'午後'**
  String get partAfternoon;

  /// No description provided for @partDusk.
  ///
  /// In zh, this message translates to:
  /// **'黃昏'**
  String get partDusk;

  /// No description provided for @partNight.
  ///
  /// In zh, this message translates to:
  /// **'夜晚'**
  String get partNight;

  /// No description provided for @cardInviteEyebrow.
  ///
  /// In zh, this message translates to:
  /// **'邀請你'**
  String get cardInviteEyebrow;

  /// No description provided for @cardMoodEyebrow.
  ///
  /// In zh, this message translates to:
  /// **'此刻的心情'**
  String get cardMoodEyebrow;

  /// No description provided for @cardInviteTitle.
  ///
  /// In zh, this message translates to:
  /// **'一起來點亮\n我們的街區'**
  String get cardInviteTitle;

  /// No description provided for @cardInviteBody.
  ///
  /// In zh, this message translates to:
  /// **'我在城市低語點亮了一道光。\n附近的人越多，街區就越亮。'**
  String get cardInviteBody;

  /// No description provided for @cardMoodFooter.
  ///
  /// In zh, this message translates to:
  /// **'{date} · {partOfDay}\n在城市的某個角落'**
  String cardMoodFooter(String date, String partOfDay);

  /// No description provided for @whisperUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'低語暫時無法使用，請稍後再試。'**
  String get whisperUnavailable;

  /// No description provided for @whisperNotSent.
  ///
  /// In zh, this message translates to:
  /// **'低語沒有送出，請檢查網路後再試一次。'**
  String get whisperNotSent;

  /// No description provided for @daysAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count} 天前'**
  String daysAgo(int count);

  /// No description provided for @timeWhisperTitle.
  ///
  /// In zh, this message translates to:
  /// **'低語穿越'**
  String get timeWhisperTitle;

  /// No description provided for @timeWhisperLead.
  ///
  /// In zh, this message translates to:
  /// **'寫給未來的自己。時間到了，回到這裡才能打開。'**
  String get timeWhisperLead;

  /// No description provided for @whisperLead.
  ///
  /// In zh, this message translates to:
  /// **'寫給下一個經過這裡的人。'**
  String get whisperLead;

  /// No description provided for @toPassersBy.
  ///
  /// In zh, this message translates to:
  /// **'給經過的人'**
  String get toPassersBy;

  /// No description provided for @toFutureSelf.
  ///
  /// In zh, this message translates to:
  /// **'寄給未來的自己'**
  String get toFutureSelf;

  /// No description provided for @inOneMonth.
  ///
  /// In zh, this message translates to:
  /// **'一個月後'**
  String get inOneMonth;

  /// No description provided for @inOneYear.
  ///
  /// In zh, this message translates to:
  /// **'一年後'**
  String get inOneYear;

  /// No description provided for @timeWhisperHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：明年此地再見。希望那時的你，過得比現在好。'**
  String get timeWhisperHint;

  /// No description provided for @whisperHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：這裡的夕陽很美，記得抬頭看看。'**
  String get whisperHint;

  /// No description provided for @timeWhisperCaptionYear.
  ///
  /// In zh, this message translates to:
  /// **'只有你看得到 · 一年後解封並通知你 · 回到 100 公尺內打開'**
  String get timeWhisperCaptionYear;

  /// No description provided for @timeWhisperCaptionMonth.
  ///
  /// In zh, this message translates to:
  /// **'只有你看得到 · 一個月後解封並通知你 · 回到 100 公尺內打開'**
  String get timeWhisperCaptionMonth;

  /// No description provided for @whisperCaption.
  ///
  /// In zh, this message translates to:
  /// **'7 天後消散 · 不會顯示你是誰 · 只透露你曾在這一帶'**
  String get whisperCaption;

  /// No description provided for @sealHere.
  ///
  /// In zh, this message translates to:
  /// **'封存在這裡'**
  String get sealHere;

  /// No description provided for @leaveHere.
  ///
  /// In zh, this message translates to:
  /// **'留在這裡'**
  String get leaveHere;

  /// No description provided for @aWhisper.
  ///
  /// In zh, this message translates to:
  /// **'一則低語'**
  String get aWhisper;

  /// No description provided for @whisperLeftAgo.
  ///
  /// In zh, this message translates to:
  /// **'{ago}留在這一帶'**
  String whisperLeftAgo(String ago);

  /// No description provided for @whisperCollectedBy.
  ///
  /// In zh, this message translates to:
  /// **'已被 {count} 個人收下'**
  String whisperCollectedBy(int count);

  /// No description provided for @whisperNobodyYet.
  ///
  /// In zh, this message translates to:
  /// **'還沒有人經過'**
  String get whisperNobodyYet;

  /// No description provided for @withdrawWhisper.
  ///
  /// In zh, this message translates to:
  /// **'收回這則低語'**
  String get withdrawWhisper;

  /// No description provided for @whisperCollected.
  ///
  /// In zh, this message translates to:
  /// **'你收下了這則低語。'**
  String get whisperCollected;

  /// No description provided for @whisperReadersBefore.
  ///
  /// In zh, this message translates to:
  /// **'在你之前，已經有 {count} 個人經過這裡。'**
  String whisperReadersBefore(int count);

  /// No description provided for @whisperFirstReader.
  ///
  /// In zh, this message translates to:
  /// **'你是第一個經過這裡的人。'**
  String get whisperFirstReader;

  /// No description provided for @reportWhisper.
  ///
  /// In zh, this message translates to:
  /// **'檢舉這則低語'**
  String get reportWhisper;

  /// No description provided for @thisWhisper.
  ///
  /// In zh, this message translates to:
  /// **'這則低語'**
  String get thisWhisper;

  /// No description provided for @chatTimeUp.
  ///
  /// In zh, this message translates to:
  /// **'時間已盡，交集消散...'**
  String get chatTimeUp;

  /// No description provided for @chatOtherLeft.
  ///
  /// In zh, this message translates to:
  /// **'對方已沒入城市...'**
  String get chatOtherLeft;

  /// No description provided for @chatEnded.
  ///
  /// In zh, this message translates to:
  /// **'交集已結束...'**
  String get chatEnded;

  /// No description provided for @chatBlockedEnded.
  ///
  /// In zh, this message translates to:
  /// **'已封鎖對方，交集結束。'**
  String get chatBlockedEnded;

  /// No description provided for @chatReportedEnded.
  ///
  /// In zh, this message translates to:
  /// **'已檢舉對方，交集結束。'**
  String get chatReportedEnded;

  /// No description provided for @anonymous.
  ///
  /// In zh, this message translates to:
  /// **'匿名'**
  String get anonymous;

  /// No description provided for @leaveChat.
  ///
  /// In zh, this message translates to:
  /// **'離開對話'**
  String get leaveChat;

  /// No description provided for @chatWith.
  ///
  /// In zh, this message translates to:
  /// **'與 {name} 的交集'**
  String chatWith(String name);

  /// No description provided for @countdownPrefix.
  ///
  /// In zh, this message translates to:
  /// **'倒數 '**
  String get countdownPrefix;

  /// No description provided for @countdownSuffix.
  ///
  /// In zh, this message translates to:
  /// **' 消散'**
  String get countdownSuffix;

  /// No description provided for @demoChatNotice.
  ///
  /// In zh, this message translates to:
  /// **'示範對話：對方由程式自動回覆，不是真人。'**
  String get demoChatNotice;

  /// No description provided for @typing.
  ///
  /// In zh, this message translates to:
  /// **'對方正在輸入中…'**
  String get typing;

  /// No description provided for @chatHint.
  ///
  /// In zh, this message translates to:
  /// **'輕聲說點什麼…'**
  String get chatHint;

  /// No description provided for @send.
  ///
  /// In zh, this message translates to:
  /// **'送出'**
  String get send;

  /// No description provided for @chatDissolvedApart.
  ///
  /// In zh, this message translates to:
  /// **'你們各自回到城市裡了'**
  String get chatDissolvedApart;

  /// No description provided for @knockTooOften.
  ///
  /// In zh, this message translates to:
  /// **'敲門太頻繁，請感受一下城市的呼吸...'**
  String get knockTooOften;

  /// No description provided for @otherNotNow.
  ///
  /// In zh, this message translates to:
  /// **'對方目前不想被打擾，請給彼此一點空間。'**
  String get otherNotNow;

  /// No description provided for @otherNotNowMinutes.
  ///
  /// In zh, this message translates to:
  /// **'對方目前不想被打擾，請給彼此一點空間 ({minutes} 分鐘)。'**
  String otherNotNowMinutes(int minutes);

  /// No description provided for @justEndedRest.
  ///
  /// In zh, this message translates to:
  /// **'你們才剛結束交集，讓回憶沉澱一下吧。'**
  String get justEndedRest;

  /// No description provided for @intro1Title.
  ///
  /// In zh, this message translates to:
  /// **'沒入這座城市'**
  String get intro1Title;

  /// No description provided for @intro1Body.
  ///
  /// In zh, this message translates to:
  /// **'拋開繁雜的社交標籤，在極簡的暗黑畫布上，只留下你最真實的情緒與座標。'**
  String get intro1Body;

  /// No description provided for @intro2Title.
  ///
  /// In zh, this message translates to:
  /// **'片刻的交集'**
  String get intro2Title;

  /// No description provided for @intro2Body.
  ///
  /// In zh, this message translates to:
  /// **'看見附近浮動的心情氣泡？輕輕敲門，與擦肩而過的人產生一期一會的對話。'**
  String get intro2Body;

  /// No description provided for @intro3Title.
  ///
  /// In zh, this message translates to:
  /// **'城市的節奏'**
  String get intro3Title;

  /// No description provided for @intro3Body.
  ///
  /// In zh, this message translates to:
  /// **'我們在意你的感受。發送敲門後請靜待回音，若無緣交集，300 秒後氣泡將悄悄消散。'**
  String get intro3Body;

  /// No description provided for @intro4Title.
  ///
  /// In zh, this message translates to:
  /// **'溫柔的距離'**
  String get intro4Title;

  /// No description provided for @intro4Body.
  ///
  /// In zh, this message translates to:
  /// **'不想被打擾？點擊婉拒或封鎖。專屬的冷卻系統會為你隔絕喧囂，還你安靜的角落。'**
  String get intro4Body;

  /// No description provided for @intro5Title.
  ///
  /// In zh, this message translates to:
  /// **'準備好相遇了嗎？'**
  String get intro5Title;

  /// No description provided for @intro5Body.
  ///
  /// In zh, this message translates to:
  /// **'閉上眼睛，感受手機的震動與心跳。現在，寫下你此刻的心情，走進城市低語。'**
  String get intro5Body;

  /// No description provided for @loadingImage.
  ///
  /// In zh, this message translates to:
  /// **'等待載入高清圖片...'**
  String get loadingImage;

  /// No description provided for @startExploring.
  ///
  /// In zh, this message translates to:
  /// **'開始探索'**
  String get startExploring;

  /// No description provided for @nextPage.
  ///
  /// In zh, this message translates to:
  /// **'下一頁'**
  String get nextPage;

  /// No description provided for @feedbackSubject.
  ///
  /// In zh, this message translates to:
  /// **'城市低語 意見回報'**
  String get feedbackSubject;

  /// No description provided for @loginNeedMood.
  ///
  /// In zh, this message translates to:
  /// **'請留下你此刻的心情，再沒入城市。'**
  String get loginNeedMood;

  /// No description provided for @loginNeedAgree.
  ///
  /// In zh, this message translates to:
  /// **'請先閱讀並勾選同意使用條款與隱私權政策。'**
  String get loginNeedAgree;

  /// No description provided for @loginCantConnect.
  ///
  /// In zh, this message translates to:
  /// **'無法連上城市，請檢查網路後再試一次。'**
  String get loginCantConnect;

  /// No description provided for @ageQuestion.
  ///
  /// In zh, this message translates to:
  /// **'請問你已年滿 18 歲了嗎？'**
  String get ageQuestion;

  /// No description provided for @ageReason.
  ///
  /// In zh, this message translates to:
  /// **'城市低語會與附近的陌生人互動，僅限 18 歲以上使用。'**
  String get ageReason;

  /// No description provided for @ageUnder.
  ///
  /// In zh, this message translates to:
  /// **'未滿 18 歲'**
  String get ageUnder;

  /// No description provided for @ageOver.
  ///
  /// In zh, this message translates to:
  /// **'已滿 18 歲'**
  String get ageOver;

  /// No description provided for @loginTitle1.
  ///
  /// In zh, this message translates to:
  /// **'準備好'**
  String get loginTitle1;

  /// No description provided for @loginTitle2.
  ///
  /// In zh, this message translates to:
  /// **'相遇了嗎？'**
  String get loginTitle2;

  /// No description provided for @loginLead.
  ///
  /// In zh, this message translates to:
  /// **'閉上眼睛，感受手機的震動與心跳。\n現在，寫下你此刻的心情，走進城市低語。'**
  String get loginLead;

  /// No description provided for @loginPrompt.
  ///
  /// In zh, this message translates to:
  /// **'此時此刻，你想對城市說什麼？'**
  String get loginPrompt;

  /// No description provided for @loginHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：喝了一杯好咖啡😊'**
  String get loginHint;

  /// No description provided for @enterCity.
  ///
  /// In zh, this message translates to:
  /// **'走進城市低語'**
  String get enterCity;

  /// No description provided for @agreeSemantic.
  ///
  /// In zh, this message translates to:
  /// **'我已閱讀並同意使用條款與隱私權政策'**
  String get agreeSemantic;

  /// No description provided for @agreePrefix.
  ///
  /// In zh, this message translates to:
  /// **'我已閱讀及同意'**
  String get agreePrefix;

  /// No description provided for @termsLink.
  ///
  /// In zh, this message translates to:
  /// **'《使用條款》'**
  String get termsLink;

  /// No description provided for @agreeAnd.
  ///
  /// In zh, this message translates to:
  /// **'與'**
  String get agreeAnd;

  /// No description provided for @privacyLink.
  ///
  /// In zh, this message translates to:
  /// **'《隱私權政策》'**
  String get privacyLink;

  /// No description provided for @agreeSuffix.
  ///
  /// In zh, this message translates to:
  /// **'。城市低語對騷擾、色情與仇恨等不當內容零容忍，違者將被移出城市。'**
  String get agreeSuffix;

  /// No description provided for @under18Title.
  ///
  /// In zh, this message translates to:
  /// **'城市低語僅限 18 歲以上使用'**
  String get under18Title;

  /// No description provided for @under18Body.
  ///
  /// In zh, this message translates to:
  /// **'謝謝你的誠實。這座城市會與陌生人互動，等你滿 18 歲，我們再見。'**
  String get under18Body;

  /// No description provided for @clearMoodTrail.
  ///
  /// In zh, this message translates to:
  /// **'清除心情軌跡'**
  String get clearMoodTrail;

  /// No description provided for @clearMoodTrailBody.
  ///
  /// In zh, this message translates to:
  /// **'這支手機上的所有心情軌跡都會刪除，無法復原。'**
  String get clearMoodTrailBody;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get clear;

  /// No description provided for @monthDay.
  ///
  /// In zh, this message translates to:
  /// **'{month} 月 {day} 日'**
  String monthDay(int month, int day);

  /// No description provided for @moodTrailLocalOnly.
  ///
  /// In zh, this message translates to:
  /// **'只存在你的手機上，不會上傳到任何地方。'**
  String get moodTrailLocalOnly;

  /// No description provided for @moodTrailEmpty.
  ///
  /// In zh, this message translates to:
  /// **'這週還沒有心情軌跡。每次寫下心情、或走到新的地方，這裡都會多一道光。'**
  String get moodTrailEmpty;

  /// No description provided for @thisWeekYou.
  ///
  /// In zh, this message translates to:
  /// **'這週的你'**
  String get thisWeekYou;

  /// No description provided for @topMoodPrefix.
  ///
  /// In zh, this message translates to:
  /// **'最常感到「'**
  String get topMoodPrefix;

  /// No description provided for @topMoodSuffix.
  ///
  /// In zh, this message translates to:
  /// **'」，共 {count} 次'**
  String topMoodSuffix(int count);

  /// No description provided for @weekPlacesMoods.
  ///
  /// In zh, this message translates to:
  /// **'在 {places} 個不同的地方，留下了 {total} 道心情'**
  String weekPlacesMoods(int places, int total);

  /// No description provided for @recordMoodTrail.
  ///
  /// In zh, this message translates to:
  /// **'記錄我的心情軌跡'**
  String get recordMoodTrail;

  /// No description provided for @recordMoodTrailOff.
  ///
  /// In zh, this message translates to:
  /// **'關閉後不再記錄新的軌跡'**
  String get recordMoodTrailOff;

  /// No description provided for @nightly1.
  ///
  /// In zh, this message translates to:
  /// **'今晚的城市在想什麼？'**
  String get nightly1;

  /// No description provided for @nightly2.
  ///
  /// In zh, this message translates to:
  /// **'有人在附近，正寫下此刻的心情。'**
  String get nightly2;

  /// No description provided for @nightly3.
  ///
  /// In zh, this message translates to:
  /// **'夜色剛好，留一句話給這座城市吧。'**
  String get nightly3;

  /// No description provided for @nightly4.
  ///
  /// In zh, this message translates to:
  /// **'今天過得怎麼樣？你的心情會在城市裡發光。'**
  String get nightly4;

  /// No description provided for @nightly5.
  ///
  /// In zh, this message translates to:
  /// **'街燈亮了，附近的人也還醒著。'**
  String get nightly5;

  /// No description provided for @nightly6.
  ///
  /// In zh, this message translates to:
  /// **'給今天一個結尾：此刻的你，是什麼心情？'**
  String get nightly6;

  /// No description provided for @nightly7.
  ///
  /// In zh, this message translates to:
  /// **'今晚，誰會和你擦肩而過？'**
  String get nightly7;

  /// No description provided for @nightlyChannel.
  ///
  /// In zh, this message translates to:
  /// **'每晚提醒'**
  String get nightlyChannel;

  /// No description provided for @nightlyChannelDesc.
  ///
  /// In zh, this message translates to:
  /// **'每晚一則溫和的提醒，可在 App 設定中關閉'**
  String get nightlyChannelDesc;

  /// No description provided for @reasonHarassment.
  ///
  /// In zh, this message translates to:
  /// **'騷擾或霸凌'**
  String get reasonHarassment;

  /// No description provided for @reasonSexual.
  ///
  /// In zh, this message translates to:
  /// **'色情或性暗示'**
  String get reasonSexual;

  /// No description provided for @reasonScam.
  ///
  /// In zh, this message translates to:
  /// **'詐騙或廣告'**
  String get reasonScam;

  /// No description provided for @reasonHate.
  ///
  /// In zh, this message translates to:
  /// **'仇恨或暴力言論'**
  String get reasonHate;

  /// No description provided for @reasonImpersonation.
  ///
  /// In zh, this message translates to:
  /// **'冒充他人'**
  String get reasonImpersonation;

  /// No description provided for @reasonOther.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get reasonOther;

  /// No description provided for @reportReceived.
  ///
  /// In zh, this message translates to:
  /// **'已收到檢舉，已從你的畫面移除。我們會在 24 小時內處理。'**
  String get reportReceived;

  /// No description provided for @reportNotSent.
  ///
  /// In zh, this message translates to:
  /// **'檢舉沒有送出，請檢查網路後再試一次。'**
  String get reportNotSent;

  /// No description provided for @reportTarget.
  ///
  /// In zh, this message translates to:
  /// **'檢舉 {target}'**
  String reportTarget(String target);

  /// No description provided for @reportPrivate.
  ///
  /// In zh, this message translates to:
  /// **'你的檢舉不會讓對方知道。請選擇原因：'**
  String get reportPrivate;

  /// No description provided for @reportDetails.
  ///
  /// In zh, this message translates to:
  /// **'補充說明（選填）'**
  String get reportDetails;

  /// No description provided for @reportWhatHappened.
  ///
  /// In zh, this message translates to:
  /// **'發生了什麼事？'**
  String get reportWhatHappened;

  /// No description provided for @sendReport.
  ///
  /// In zh, this message translates to:
  /// **'送出檢舉'**
  String get sendReport;

  /// No description provided for @alsoBlock.
  ///
  /// In zh, this message translates to:
  /// **'同時封鎖對方，雙方將從彼此的城市中消失'**
  String get alsoBlock;

  /// No description provided for @aYearAgo.
  ///
  /// In zh, this message translates to:
  /// **'一年前'**
  String get aYearAgo;

  /// No description provided for @aMonthAgo.
  ///
  /// In zh, this message translates to:
  /// **'一個月前'**
  String get aMonthAgo;

  /// No description provided for @timeWhisperUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'低語穿越暫時無法使用，請稍後再試。'**
  String get timeWhisperUnavailable;

  /// No description provided for @timeWhisperYouSaid.
  ///
  /// In zh, this message translates to:
  /// **'{ago}的你，在這裡說'**
  String timeWhisperYouSaid(String ago);

  /// No description provided for @writtenOn.
  ///
  /// In zh, this message translates to:
  /// **'寫於 {date}'**
  String writtenOn(String date);

  /// No description provided for @timeWhisperOnce.
  ///
  /// In zh, this message translates to:
  /// **'這封信只會出現這一次。'**
  String get timeWhisperOnce;

  /// No description provided for @keepInHeart.
  ///
  /// In zh, this message translates to:
  /// **'收進心裡'**
  String get keepInHeart;

  /// No description provided for @unsealsOn.
  ///
  /// In zh, this message translates to:
  /// **'{unlock} 解封 · 寫於 {created}'**
  String unsealsOn(String unlock, String created);

  /// No description provided for @unsealedGoBack.
  ///
  /// In zh, this message translates to:
  /// **'已解封，回到那裡就能打開'**
  String get unsealedGoBack;

  /// No description provided for @unsealedDistance.
  ///
  /// In zh, this message translates to:
  /// **'已解封 · 距離你 {distance}'**
  String unsealedDistance(String distance);

  /// No description provided for @timeWhisperListLead.
  ///
  /// In zh, this message translates to:
  /// **'寫給未來的自己，只有你看得到。時間到了，回到那裡 100 公尺內就會打開；讀過一次就會消失。'**
  String get timeWhisperListLead;

  /// No description provided for @timeWhisperListEmpty.
  ///
  /// In zh, this message translates to:
  /// **'還沒有寫給未來的信。按底部選單的筆記圖示，選「寄給未來的自己」。'**
  String get timeWhisperListEmpty;

  /// No description provided for @readyToOpen.
  ///
  /// In zh, this message translates to:
  /// **'已經可以打開了'**
  String get readyToOpen;

  /// No description provided for @sealed.
  ///
  /// In zh, this message translates to:
  /// **'封存中'**
  String get sealed;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'刪除'**
  String get delete;

  /// No description provided for @within100m.
  ///
  /// In zh, this message translates to:
  /// **'100m 內'**
  String get within100m;

  /// No description provided for @knockWaitingSemantic.
  ///
  /// In zh, this message translates to:
  /// **'正在等待 {name} 回音，剩下 {mm} 分 {ss} 秒'**
  String knockWaitingSemantic(String name, String mm, String ss);

  /// No description provided for @knockWaiting.
  ///
  /// In zh, this message translates to:
  /// **'等待 {name} 回音'**
  String knockWaiting(String name);

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'語言'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟隨手機設定'**
  String get languageSystem;

  /// No description provided for @parallelUniverse.
  ///
  /// In zh, this message translates to:
  /// **'平行宇宙'**
  String get parallelUniverse;

  /// No description provided for @parallelUniverseSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'看見其他城市此刻的心情，也讓他們看見你'**
  String get parallelUniverseSubtitle;

  /// No description provided for @parallelUniverseIntroTitle.
  ///
  /// In zh, this message translates to:
  /// **'進入平行宇宙'**
  String get parallelUniverseIntroTitle;

  /// No description provided for @parallelUniverseIntroBody.
  ///
  /// In zh, this message translates to:
  /// **'開啟後，其他城市也開啟平行宇宙的人會出現在你的雷達上，你也會出現在他們的雷達上。\n\n位置依城市比例投影過去，並模糊到約 500 公尺，沒有人看得到你的真實位置或距離。一樣可以送微光、敲門和聊天，隨時可以關閉。'**
  String get parallelUniverseIntroBody;

  /// No description provided for @parallelUniverseEnter.
  ///
  /// In zh, this message translates to:
  /// **'進入'**
  String get parallelUniverseEnter;

  /// No description provided for @parallelUniverseNoCity.
  ///
  /// In zh, this message translates to:
  /// **'你所在的地方還沒有平行宇宙'**
  String get parallelUniverseNoCity;

  /// No description provided for @parallelFrom.
  ///
  /// In zh, this message translates to:
  /// **'平行宇宙 · {city}'**
  String parallelFrom(String city);

  /// No description provided for @parallelPersonBody.
  ///
  /// In zh, this message translates to:
  /// **'這個人在{city}，不在你身邊。位置是投影過來的，不代表真實距離。'**
  String parallelPersonBody(String city);

  /// No description provided for @labelHost.
  ///
  /// In zh, this message translates to:
  /// **'主持'**
  String get labelHost;

  /// No description provided for @labelDemo.
  ///
  /// In zh, this message translates to:
  /// **'示範'**
  String get labelDemo;

  /// No description provided for @labelResting.
  ///
  /// In zh, this message translates to:
  /// **'休息中'**
  String get labelResting;

  /// No description provided for @cityTaipei.
  ///
  /// In zh, this message translates to:
  /// **'台北'**
  String get cityTaipei;

  /// No description provided for @cityTaichung.
  ///
  /// In zh, this message translates to:
  /// **'台中'**
  String get cityTaichung;

  /// No description provided for @cityKaohsiung.
  ///
  /// In zh, this message translates to:
  /// **'高雄'**
  String get cityKaohsiung;

  /// No description provided for @cityTokyo.
  ///
  /// In zh, this message translates to:
  /// **'東京'**
  String get cityTokyo;

  /// No description provided for @cityOsaka.
  ///
  /// In zh, this message translates to:
  /// **'大阪'**
  String get cityOsaka;

  /// No description provided for @citySeoul.
  ///
  /// In zh, this message translates to:
  /// **'首爾'**
  String get citySeoul;

  /// No description provided for @cityBusan.
  ///
  /// In zh, this message translates to:
  /// **'釜山'**
  String get cityBusan;

  /// No description provided for @cityHongkong.
  ///
  /// In zh, this message translates to:
  /// **'香港'**
  String get cityHongkong;

  /// No description provided for @cityMacau.
  ///
  /// In zh, this message translates to:
  /// **'澳門'**
  String get cityMacau;

  /// No description provided for @citySingapore.
  ///
  /// In zh, this message translates to:
  /// **'新加坡'**
  String get citySingapore;

  /// No description provided for @cityKualalumpur.
  ///
  /// In zh, this message translates to:
  /// **'吉隆坡'**
  String get cityKualalumpur;

  /// No description provided for @cityJakarta.
  ///
  /// In zh, this message translates to:
  /// **'雅加達'**
  String get cityJakarta;

  /// No description provided for @cityHochiminh.
  ///
  /// In zh, this message translates to:
  /// **'胡志明市'**
  String get cityHochiminh;

  /// No description provided for @cityHanoi.
  ///
  /// In zh, this message translates to:
  /// **'河內'**
  String get cityHanoi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'id',
    'ja',
    'ko',
    'ms',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
