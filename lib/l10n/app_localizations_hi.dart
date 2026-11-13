// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get checkInEnter => 'यहाँ चेक-इन करें और अंदर जाएँ';

  @override
  String get checkInNote =>
      'टैप करते ही आस-पास के लोग आपका मूड और आप लगभग कहाँ हैं, देख पाएँगे। हर बार अंदर आने पर चेक-इन आप खुद करते हैं।';

  @override
  String get checkInTitle => 'शहर में चेक-इन करें';

  @override
  String get checkInBody =>
      'चेक-इन के बाद आस-पास के लोग आपका मूड और आप लगभग कहाँ हैं, देख सकते हैं, और आप भी उन्हें देखते हैं। उन्हें वह जगह दिखती है जहाँ आपने चेक-इन किया था; वह आपके साथ नहीं चलती। हर बार ऐप खोलने पर चेक-इन आप खुद करते हैं; यह कभी अपने आप नहीं होता। ऐप छोड़ने या दूसरा ऐप खोलने पर चेक-इन खत्म हो जाता है।';

  @override
  String get checkInButton => 'यहाँ चेक-इन करें';

  @override
  String get checkInAgain =>
      'आप चेक-इन वाली जगह से दूर आ गए हैं · यहाँ चेक-इन करें';

  @override
  String get checkOutButton => 'चेक-इन हो गया · चेक-आउट';

  @override
  String get checkedOutToast => 'चेक-आउट हो गया। अब आप मैप पर नहीं हैं।';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'खुश';

  @override
  String get moodSad => 'उदास';

  @override
  String get moodAngry => 'नाराज़';

  @override
  String get moodCalm => 'शांत';

  @override
  String get moodPassion => 'जोश में';

  @override
  String get moodLove => 'प्यार';

  @override
  String get moodOther => 'अन्य';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name खत्म हो गई';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'आपने $emoji $name सौंप दी और अब आप प्रतिभागी हैं।';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'आपने सभा सौंप दी। आपके नाम में पहले से 10 अक्षर हैं, इसलिए घोषणाएँ पाते रहने के लिए $emoji खुद जोड़ें।';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'आपने सभा सौंप दी। हमने आपके नाम में $emoji जोड़ दिया है, इसलिए अब आप प्रतिभागी हैं।';
  }

  @override
  String get gotIt => 'समझ गया';

  @override
  String get blockedToast => 'यह व्यक्ति अँधेरे में गुम हो गया।';

  @override
  String get unblockedToast => 'अनब्लॉक हो गया। आपकी राहें फिर मिल सकती हैं।';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'लोकेशन सेवाएँ चालू करें';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper को जानना है कि आप शहर के किस कोने में हैं, ताकि आस-पास के लोग आपका मूड देख सकें। फ़ोन की सेटिंग्स में लोकेशन सेवाएँ चालू करें।';

  @override
  String get locationReducedTitle => 'सटीक लोकेशन चालू करें';

  @override
  String get locationReducedBodyIos =>
      'आप सिर्फ़ अनुमानित लोकेशन शेयर कर रहे हैं, इसलिए रडार नहीं जान पाता कि आपके पास कौन है। सेटिंग्स › Mood Whisper › लोकेशन में जाकर सटीक लोकेशन चालू करें।';

  @override
  String get locationReducedBodyAndroid =>
      'आप सिर्फ़ अनुमानित लोकेशन शेयर कर रहे हैं, इसलिए रडार नहीं जान पाता कि आपके पास कौन है। लोकेशन अनुमति में सटीक चुनें।';

  @override
  String get locationNoFixTitle => 'आपकी लोकेशन अभी नहीं मिली';

  @override
  String get locationNoFixBody =>
      'हो सकता है आप अंदर हों या सिग्नल कमज़ोर हो। खिड़की के पास या बाहर जाएँ, Wi-Fi चालू करें और फिर कोशिश करें।';

  @override
  String get locationNeededTitle => 'Mood Whisper को आपकी लोकेशन चाहिए';

  @override
  String get locationNeededBody =>
      'Mood Whisper आपकी लोकेशन सिर्फ़ ऐप इस्तेमाल करते समय लेता है, ताकि 5 किमी के अंदर के मूड दिखा सके। रडार सिर्फ़ अनुमानित दूरी दिखाता है, पता कभी नहीं।\nसेटिंग्स में ऐप इस्तेमाल करते समय लोकेशन की अनुमति दें और सटीक लोकेशन चालू करें।';

  @override
  String get locationSimulatorHint =>
      '(डेवलपर नोट: सिम्युलेटर में Features › Location से जगह चुनें)';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get locationRecheck => 'चालू कर दिया, फिर से जाँचें';

  @override
  String get tryAgain => 'फिर से कोशिश करें';

  @override
  String get leaveApp => 'बाहर जाएँ';

  @override
  String whispersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपके पास $count फुसफुसाहटें हैं। पढ़ने के लिए किसी लिफ़ाफ़े पर टैप करें।',
      one: 'आपके पास 1 फुसफुसाहट है। पढ़ने के लिए लिफ़ाफ़े पर टैप करें।',
    );
    return '$_temp0';
  }

  @override
  String get whisperPassed =>
      'आप एक फुसफुसाहट के पास से गुज़रे। पढ़ने के लिए लिफ़ाफ़े पर टैप करें।';

  @override
  String get whisperLeft =>
      'आपकी फुसफुसाहट अब यहाँ है। यह 7 दिन में मिट जाएगी।';

  @override
  String get timeWhisperSealedYear =>
      'बंद हो गया। खोलने के लिए एक साल बाद यहाँ आएँ।';

  @override
  String get timeWhisperSealedMonth =>
      'बंद हो गया। खोलने के लिए एक महीने बाद यहाँ आएँ।';

  @override
  String get whisperWithdrawn => 'आपकी फुसफुसाहट वापस ले ली गई।';

  @override
  String get whisperMineLabel => 'आपकी छोड़ी हुई फुसफुसाहट';

  @override
  String get whisperTapToRead => 'एक फुसफुसाहट। पढ़ने के लिए टैप करें';

  @override
  String get noMoodYet => 'शब्द नहीं मिल रहे…';

  @override
  String get knockWithdrawnByLeaving =>
      'वे शहर में लौट गए और चुपचाप अपनी दस्तक वापस ले ली…';

  @override
  String get knockCardTitle => 'पलों का मिलना';

  @override
  String knockCardBody(String name) {
    return '$name दस्तक दे रहे हैं,\nउम्मीद है आपकी राहें मिलेंगी…';
  }

  @override
  String get skip => 'छोड़ें';

  @override
  String get decline => 'मना करें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get reportThisPerson => 'इस व्यक्ति की रिपोर्ट करें';

  @override
  String get cityQuietTonight => 'आज रात शहर शांत है';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'आज रात का शहर · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text। शहर का मूड मौसम देखें';
  }

  @override
  String get cityMoodTitle => 'आज रात शहर का मूड';

  @override
  String cityMoodQuietCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'शहर अभी शांत है। आज रात $total लोगों ने अपना मूड शेयर किया।',
      one: 'शहर अभी शांत है। आज रात 1 व्यक्ति ने अपना मूड शेयर किया।',
    );
    return '$_temp0';
  }

  @override
  String cityMoodCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '20 किमी के अंदर $total लोगों ने आज रात अपना मूड शेयर किया',
      one: '20 किमी के अंदर 1 व्यक्ति ने आज रात अपना मूड शेयर किया',
    );
    return '$_temp0';
  }

  @override
  String get cityMoodQuietInvite =>
      'हर मूड थोड़ी रोशनी जोड़ता है। अभी आप कैसा महसूस कर रहे हैं, लिखें और शहर को रोशन करने में मदद करें।';

  @override
  String get cityMoodFootnote =>
      'पिछले 24 घंटों के गुमनाम मूड। 10 से कम लोगों के होने पर प्रतिशत छिपा दिए जाते हैं।';

  @override
  String get close => 'बंद करें';

  @override
  String get emptyRadarTitle => 'आज रात की पहली रोशनी आप हैं';

  @override
  String get emptyRadarBody =>
      'अभी आस-पास कोई नहीं है। आपका मूड शहर में पहले से चमक रहा है,\nऔर जो भी गुज़रेगा उसे दिखेगा। आप अगले राहगीर के लिए एक फुसफुसाहट भी छोड़ सकते हैं।';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return 'आज रात शहर में $total लोग हैं, और ज़्यादातर “$mood” महसूस कर रहे हैं';
  }

  @override
  String get inviteFriends =>
      'अपने मोहल्ले को रोशन करने के लिए दोस्तों को बुलाएँ';

  @override
  String get shareMoodCard => 'मेरा मूड कार्ड शेयर करें';

  @override
  String get editYourMood => 'अपना मूड बदलें';

  @override
  String resonanceTonight(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आज रात $count झिलमिल आपसे मेल खाईं',
      one: 'आज रात 1 झिलमिल आपसे मेल खाई',
    );
    return '$_temp0';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · आपका मूड';
  }

  @override
  String get dockTapToEdit => 'आपका मूड · बदलने के लिए टैप करें';

  @override
  String get leaveWhisper => 'फुसफुसाहट छोड़ें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get nightlyReminder => 'रात का रिमाइंडर';

  @override
  String get nightlyReminderSubtitle => 'हर रात 21:30 बजे एक हल्का-सा रिमाइंडर';

  @override
  String get closeSettings => 'सेटिंग्स बंद करें';

  @override
  String get settingsSectionMe => 'मैं';

  @override
  String get editProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get editProfileSubtitle => 'फ़ोटो, शहर का नाम और मूड';

  @override
  String get manageBlockList => 'ब्लॉक किए गए लोग';

  @override
  String get manageBlockListSubtitle =>
      'जिन्हें आपने अँधेरे में भेजा, उन्हें देखें या अनब्लॉक करें';

  @override
  String get myTimeWhispers => 'भविष्य के लिए मेरे पत्र';

  @override
  String get myTimeWhispersSubtitle =>
      'भविष्य के अपने लिए नोट, जो सिर्फ़ आप देख सकते हैं';

  @override
  String get myMoodTrail => 'मेरा मूड सफ़र';

  @override
  String get myMoodTrailSubtitle => 'सिर्फ़ आपके फ़ोन में सेव';

  @override
  String get settingsSectionGatherings => 'सभाएँ';

  @override
  String get gatheringHost => 'सभा आयोजित करें';

  @override
  String get gatheringHostSubtitle =>
      'अपने 5 किमी के दायरे में सबके लिए एक इवेंट शुरू करें';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'आप $emoji $name होस्ट कर रहे हैं';
  }

  @override
  String get settingsSectionShare => 'शेयर करें';

  @override
  String get shareMoodCardSubtitle =>
      'ग्यारह रात के चित्रों में से कोई एक, Instagram स्टोरी के लिए बना';

  @override
  String get inviteFriendsSubtitle => 'आस-पास जितने ज़्यादा लोग, शहर उतना रोशन';

  @override
  String get settingsSectionAbout => 'जानकारी';

  @override
  String get guide => 'इस्तेमाल कैसे करें';

  @override
  String get guideSubtitle => 'मूड लिखने से लेकर सभा आयोजित करने तक सब कुछ';

  @override
  String get termsOfUse => 'उपयोग की शर्तें';

  @override
  String get privacyPolicy => 'प्राइवेसी पॉलिसी';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get deleteAccount => 'खाता और डेटा हटाएँ';

  @override
  String get deleteAccountSubtitle =>
      'शहर में छोड़ी गई हर चीज़ हमेशा के लिए मिटा दें';

  @override
  String get avatarUploadFailed =>
      'आपकी फ़ोटो अपलोड नहीं हुई। बाद में कोशिश करें।';

  @override
  String get moodEmpty => 'मूड खाली नहीं हो सकता। शहर में थोड़ी रोशनी छोड़ें।';

  @override
  String get profileSyncFailed =>
      'आपका स्टेटस अपडेट नहीं हो सका। बाद में कोशिश करें।';

  @override
  String get profileUpdated => 'अपडेट हो गया। शहर आपकी साँसें महसूस कर रहा है।';

  @override
  String get changeAvatar => 'फ़ोटो बदलें';

  @override
  String get avatarHint =>
      'फ़ोटो बदलने के लिए टैप करें · घेरा आपके मूड का रंग है';

  @override
  String get cityName => 'शहर का नाम';

  @override
  String get cityNameHint => 'वैकल्पिक, जैसे भटकती बिल्ली';

  @override
  String get currentMood => 'अभी आपका मूड';

  @override
  String get currentMoodHint => 'जैसे हल्की बारिश में टहल रहा हूँ 🌿';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सेव करें';

  @override
  String get blockListTitle => 'अँधेरे में भेजे गए';

  @override
  String get blockListEmpty => 'रात साफ़ है। आपने किसी को दूर नहीं भेजा।';

  @override
  String get unblock => 'अनब्लॉक करें';

  @override
  String get deleteAccountBody =>
      'आपकी लोकेशन, मूड, शहर का नाम, फ़ोटो, फुसफुसाहटें, झिलमिल, ब्लॉक सूची और खुली चैट हमेशा के लिए हट जाएँगी। इसे वापस नहीं किया जा सकता।\n\nदुरुपयोग रोकने के लिए, रिपोर्ट के रिकॉर्ड प्राइवेसी पॉलिसी के अनुसार 1 साल तक रखे जाते हैं।';

  @override
  String get deleting => 'हटाया जा रहा है…';

  @override
  String get deletePermanently => 'हमेशा के लिए हटाएँ';

  @override
  String get deleteFailed =>
      'हटाना पूरा नहीं हुआ। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get fadingEcho => 'मिटती गूँज';

  @override
  String clusterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'यहाँ $count मूड',
      one: 'यहाँ 1 मूड',
    );
    return '$_temp0';
  }

  @override
  String clusterMore(int count) {
    return 'और\n+$count';
  }

  @override
  String get clusterBackToFirst => 'शुरुआत पर\nवापस';

  @override
  String get fadingEchoTitle => 'एक मिटती गूँज';

  @override
  String encounterWith(String name) {
    return '$name से राहें मिलीं';
  }

  @override
  String get fadingEchoBody =>
      'यह सिर्फ़ एक मिटती गूँज है। इससे राहें नहीं मिल सकतीं।';

  @override
  String get demoPersonBody =>
      'यह एक डेमो व्यक्ति है जो अपने आप जवाब देता है। यह असली व्यक्ति नहीं है। दस्तक, चैट, झिलमिल, रिपोर्ट और ब्लॉक आज़माने के लिए इसका इस्तेमाल करें।';

  @override
  String get sendGlimmer => 'झिलमिल भेजें';

  @override
  String get knock => 'दस्तक दें';

  @override
  String get blockAction => 'ब्लॉक करें';

  @override
  String get handOverHost => 'होस्टिंग सौंपें';

  @override
  String get report => 'रिपोर्ट करें';

  @override
  String get confirmBlockTitle => 'इस व्यक्ति को ब्लॉक करें?';

  @override
  String confirmBlockBody(String name) {
    return '$name को अँधेरे में भेजें?\nब्लॉक करने के बाद आप दोनों एक-दूसरे के शहर से गायब हो जाएँगे।';
  }

  @override
  String get confirmBlock => 'ब्लॉक करें';

  @override
  String get glimmerReceived =>
      'किसी ने आपको झिलमिल भेजी। आपका मूड उन्हें छू गया।';

  @override
  String get glimmerSent => 'आपने झिलमिल भेजी।';

  @override
  String get glimmerAlreadySent =>
      'आप आज उन्हें झिलमिल भेज चुके हैं। कल फिर कोशिश करें।';

  @override
  String get knockSent => 'दस्तक भेजी गई। जवाब का इंतज़ार…';

  @override
  String get knockFailed => 'आपकी दस्तक नहीं पहुँची। बाद में कोशिश करें।';

  @override
  String get knockNoAnswer => 'कोई जवाब नहीं। आपकी दस्तक चुपचाप मिट गई।';

  @override
  String get knockDeclined =>
      'इस बार राहें नहीं मिलीं। चलिए एक-दूसरे को थोड़ी जगह दें।';

  @override
  String get knockSkipped =>
      'उन्होंने अभी के लिए छोड़ दिया, और आपकी दस्तक चुपचाप मिट गई।';

  @override
  String get sensingCity => 'शहर को महसूस कर रहे हैं…';

  @override
  String get sensingCityHint =>
      'अगर अभी आपका शहर बहुत शांत है, तो दूसरे शहरों के लोगों से मिलने के लिए पैरेलल यूनिवर्स या क्वांटम वर्ल्ड में जाएँ।';

  @override
  String get gatheringUnavailable =>
      'सभाएँ अभी उपलब्ध नहीं हैं। बाद में कोशिश करें।';

  @override
  String get notSentCheckNetwork =>
      'यह नहीं भेजा गया। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get justNow => 'अभी-अभी';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट पहले',
      one: '1 मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '1 घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String get nextDayPrefix => 'अगले दिन ';

  @override
  String get gatheringNameMissing => 'अपनी सभा को एक नाम दें।';

  @override
  String get gatheringEmojiInvalid => 'सभा का आइकन ठीक एक इमोजी होना चाहिए।';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name शुरू हो गई। शामिल होने के लिए लोगों से अपने शहर के नाम में $emoji जोड़ने को कहें।';
  }

  @override
  String get startGatheringTitle => 'सभा शुरू करें';

  @override
  String get startGatheringLead =>
      'आपके 5 किमी के दायरे में सब। दायरा आपके साथ चलता है।';

  @override
  String get gatheringNameHint => 'सभा का नाम, जैसे इंडिया गेट पर दिवाली';

  @override
  String get gatheringEmojiHint => 'आइकन';

  @override
  String get gatheringEmojiHelp =>
      'सभा का आइकन एक ऐसा इमोजी है जो आस-पास कोई इस्तेमाल नहीं कर रहा।';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'जो लोग अपने शहर के नाम में $emoji जोड़ेंगे, उन्हें आपकी घोषणाएँ और नोटिफ़िकेशन मिलेंगे।';
  }

  @override
  String get start => 'शुरू';

  @override
  String get end => 'खत्म';

  @override
  String get gatheringMaxDuration =>
      'सभा ज़्यादा से ज़्यादा 24 घंटे चलती है और अपने आप खत्म हो जाती है।';

  @override
  String get starting => 'शुरू हो रहा है…';

  @override
  String get startGathering => 'सभा शुरू करें';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name खत्म हो गई। आप शहर में वापस आ गए।';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · आप होस्ट कर रहे हैं';
  }

  @override
  String hostAudienceRule(String emoji) {
    return '5 किमी के अंदर जिनके नाम में $emoji है, उन्हें आपकी घोषणाएँ और नोटिफ़िकेशन मिलते हैं। आप नहीं देख सकते कि वे कौन हैं।';
  }

  @override
  String get postAnnouncement => 'घोषणा करें';

  @override
  String get announcementHint => 'जैसे हम कनॉट प्लेस के कोने पर मिल रहे हैं';

  @override
  String get announcementSent => 'घोषणा भेजी गई';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (कई रिपोर्ट के बाद छिपाया गया)';

  @override
  String get groupQuestion => 'सबसे पूछें';

  @override
  String get questionHint => 'जैसे अभी आप सब कैसे हैं?';

  @override
  String get sendQuestion => 'पूछें';

  @override
  String get questionSent => 'सवाल भेजा गया। सब मूड से जवाब देंगे';

  @override
  String get handOff => 'सौंपें';

  @override
  String handoffPending(String name) {
    return 'आपने $name को होस्टिंग संभालने का न्योता दिया। जवाब का इंतज़ार…';
  }

  @override
  String get theOtherPerson => 'वे';

  @override
  String get handoffCancelled => 'सौंपने का न्योता रद्द हुआ';

  @override
  String get handoffHelp =>
      'रडार पर किसी प्रतिभागी के बबल को दबाकर रखें → होस्टिंग सौंपें। उनके स्वीकार करते ही वे होस्ट बन जाते हैं और सभा बिना रुके चलती रहती है।';

  @override
  String get confirmEndAgain => 'खत्म करें? फिर से टैप करें';

  @override
  String get endGathering => 'सभा खत्म करें';

  @override
  String tallyHeader(String question, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total जवाब',
      one: '1 जवाब',
    );
    return '“$question” · $_temp0';
  }

  @override
  String get tallyQuiet =>
      '10 जवाब आने के बाद ही प्रतिशत दिखते हैं, ताकि कम लोग हों तो किसी का अंदाज़ा न लगे।';

  @override
  String get bannerYouHost => '  · आप होस्ट कर रहे हैं';

  @override
  String get bannerHostAnnouncement => '  · होस्ट की ओर से';

  @override
  String get manageGathering => 'सभा संभालें';

  @override
  String get reportAnnouncement => 'इस घोषणा की रिपोर्ट करें';

  @override
  String get expandAnnouncement => 'घोषणा दिखाएँ';

  @override
  String get collapseAnnouncement => 'घोषणा छिपाएँ';

  @override
  String hostHandedOffAgo(String ago) {
    return 'नए होस्ट · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'आपने इस घोषणा की रिपोर्ट की, इसलिए इसे आपकी स्क्रीन से हटा दिया गया।';

  @override
  String get noAnnouncementHost =>
      'अभी कोई घोषणा नहीं। पहली घोषणा के लिए ऊपर दाईं ओर स्लाइडर पर टैप करें।';

  @override
  String get noAnnouncementGuest => 'होस्ट ने अभी कुछ पोस्ट नहीं किया।';

  @override
  String hostAsks(String question) {
    return 'होस्ट पूछते हैं: $question';
  }

  @override
  String get answeredNote =>
      'जवाब दे दिया। होस्ट सिर्फ़ कुल मूड का प्रतिशत देखते हैं।';

  @override
  String get answerHint => 'मूड से जवाब दें';

  @override
  String get sendAnswer => 'जवाब भेजें';

  @override
  String handoffInvited(String name) {
    return 'आपने $name को होस्टिंग संभालने का न्योता दिया। जवाब का इंतज़ार (5 मिनट तक मान्य)।';
  }

  @override
  String handoffTitle(String name) {
    return 'सभा $name को सौंपें';
  }

  @override
  String get handoffBody =>
      'उनके स्वीकार करते ही वे सभा होस्ट करेंगे। नाम, घोषणाएँ और सवाल वैसे ही रहेंगे, और आप प्रतिभागी बन जाएँगे।';

  @override
  String get handoffPublic => 'सौंपने की घोषणा करें';

  @override
  String get handoffPublicHelp =>
      'सभी प्रतिभागियों को बताएँ कि नए होस्ट आए हैं';

  @override
  String get handoffQuiet => 'चुपचाप सौंपें';

  @override
  String get handoffQuietHelp =>
      'किसी को सूचना नहीं जाती। रडार पर सिर्फ़ होस्ट का घेरा हटता है';

  @override
  String get sending => 'भेजा जा रहा है…';

  @override
  String get sendInvite => 'न्योता भेजें';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'अब आप $emoji $name होस्ट कर रहे हैं।';
  }

  @override
  String get handoffOfferTitle => 'क्या आप होस्टिंग संभालेंगे?';

  @override
  String handoffOfferBody(String name) {
    return 'होस्ट “$name” आपको सौंपना चाहते हैं। होस्ट के रूप में आप घोषणा कर सकते हैं, सवाल पूछ सकते हैं और सभा खत्म कर सकते हैं, और आप जो पोस्ट करेंगे उसकी ज़िम्मेदारी आपकी होगी।';
  }

  @override
  String get processing => 'हो रहा है…';

  @override
  String get acceptHosting => 'संभालें';

  @override
  String get guideS1Title => '1. शहर में आएँ';

  @override
  String get guideS1L1 =>
      'पहली बार ऐप खोलने पर पुष्टि करें कि आपकी उम्र 18 साल या ज़्यादा है, और ऐप इस्तेमाल करते समय सटीक लोकेशन की अनुमति दें। सटीक लोकेशन के बिना रडार काम नहीं करता।';

  @override
  String get guideS1L2 =>
      'अभी आप कैसा महसूस कर रहे हैं, एक वाक्य में लिखें (20 अक्षर तक), उपयोग की शर्तें और प्राइवेसी पॉलिसी स्वीकार करें, और यहाँ चेक-इन करें और अंदर जाएँ दबाएँ।';

  @override
  String get guideS1L3 =>
      'फ़ोन नंबर, ईमेल या असली नाम की ज़रूरत नहीं। आपका खाता गुमनाम है और इसी फ़ोन से जुड़ा है।';

  @override
  String get guideS1L4 =>
      'मूड के शब्दों से उसका रंग तय होता है: “खुश, हँसी” सुनहरा, “उदास, रोना” नीला, “गुस्सा” नारंगी-लाल, “शांत, ख्यालों में” हरा, “जोश” नारंगी, “प्यार, दिल” गुलाबी, और बाकी सब हल्का बैंगनी।';

  @override
  String get guideS1L5 =>
      'चेक-इन: हर बार ऐप खोलने पर आप खुद चेक-इन करते हैं, और तभी आस-पास के लोग आपका मूड और आप लगभग कहाँ हैं देख पाते हैं, और आप उन्हें। यह कभी अपने आप नहीं होता। दूसरों को चेक-इन वाली जगह दिखती है; वह आपके साथ नहीं चलती। 1 किमी से ज़्यादा दूर जाने पर रडार के नीचे यहाँ चेक-इन करें दिखता है। अगर ऐप 30 मिनट से ज़्यादा बैकग्राउंड में रहा, तो लौटने पर फिर से चेक-इन करें।';

  @override
  String get guideS2Title => '2. नीचे की पट्टी';

  @override
  String get guideS2L1 =>
      'फ़ोटो, शहर का नाम (10 अक्षर तक) और मूड बदलने के लिए बाईं ओर अपनी फ़ोटो पर टैप करें।';

  @override
  String get guideS2L2 => 'नोटपैड आइकन: यहीं एक फुसफुसाहट छोड़ें।';

  @override
  String get guideS2L3 =>
      'शेयर आइकन: अपने मूड को रात के दृश्य वाले कार्ड में बदलें।';

  @override
  String get guideS2L4 => 'सबसे दाईं ओर स्लाइडर आइकन: सेटिंग्स खोलें।';

  @override
  String get guideS3Title => '3. रडार और बबल';

  @override
  String get guideS3L1 =>
      '5 किमी के अंदर के लोगों के मूड बबल रडार पर दिखते हैं। सिर्फ़ अनुमानित दूरी (जैसे “100 मी के अंदर”) दिखती है, पता कभी नहीं।';

  @override
  String get guideS3L2 =>
      'रडार पर सिर्फ़ वही लोग दिखते हैं जिन्होंने चेक-इन किया है और ऐप खुला है। कोई ऐप छोड़ दे या दूसरा ऐप खोले, तो उसका बबल तुरंत गायब हो जाता है और कोई निशान नहीं रहता।';

  @override
  String get guideS3L3 =>
      'मैप ज़ूम करने के लिए दो उँगलियों से पिंच करें। फ़ोन घुमाएँ तो रडार भी घूमता है।';

  @override
  String get guideS3L4 =>
      'जब बबल पास-पास इकट्ठे हो जाते हैं, तो एक चमकता गोला “यहाँ N मूड” बन जाते हैं। उसे टैप करें तो वे घेरे में फैल जाते हैं और हर एक पर टैप कर सकते हैं; बंद करने के लिए बीच में या खाली जगह पर टैप करें।';

  @override
  String get guideS3L5 =>
      'Demo से शुरू होने वाले नाम डेमो लोगों के हैं जो अपने आप जवाब देते हैं। वे असली नहीं हैं, और आप उनसे हर फ़ीचर आज़मा सकते हैं।';

  @override
  String get guideS3L6 =>
      'जब आस-पास कोई नहीं होता, तो नीचे “आज रात की पहली रोशनी आप हैं” दिखता है, और आप दोस्तों को अपना मोहल्ला रोशन करने बुला सकते हैं।';

  @override
  String get guideS4Title => '4. दस्तक और चैट';

  @override
  String get guideS4L1 =>
      'किसी के बबल को दबाकर रखें → दस्तक दें। उनके पास स्वीकार करने, मना करने या छोड़ने के लिए 5 मिनट होते हैं। इंतज़ार के दौरान आपसे उन तक रोशनी की एक लकीर बहती है।';

  @override
  String get guideS4L2 =>
      'उनके स्वीकार करते ही 10 मिनट की उलटी गिनती वाली चैट शुरू होती है। हर नया संदेश उसे फिर से शुरू करता है, और दोनों के चुप होने पर चैट खत्म हो जाती है।';

  @override
  String get guideS4L3 =>
      'चैट खत्म होने पर संदेश सर्वर से मिटा दिए जाते हैं। दूसरा व्यक्ति फिर भी स्क्रीनशॉट ले सकता है, इसलिए सोच-समझकर शेयर करें।';

  @override
  String get guideS4L4 =>
      'जब कोई आपके दरवाज़े पर दस्तक देता है, तो दस्तक कार्ड दिखता है। आप तुरंत स्वीकार, मना, छोड़ या रिपोर्ट कर सकते हैं।';

  @override
  String get guideS5Title => '5. झिलमिल';

  @override
  String get guideS5L1 =>
      'किसी के बबल पर दो बार टैप करें, या दबाकर रखें और झिलमिल भेजें चुनें, ताकि बिना कुछ कहे उन्हें पता चले कि किसी ने उन्हें देखा।';

  @override
  String get guideS5L2 =>
      'उन्हें सिर्फ़ “आज रात N झिलमिल आपसे मेल खाईं” दिखता है, भेजने वाला कभी नहीं। आप एक ही व्यक्ति को हर 24 घंटे में एक झिलमिल भेज सकते हैं।';

  @override
  String get guideS6Title => '6. फुसफुसाहट';

  @override
  String get guideS6L1 =>
      'जहाँ आप हैं वहाँ एक वाक्य छोड़ने के लिए नीचे की पट्टी में नोटपैड आइकन पर टैप करें (60 अक्षर तक)।';

  @override
  String get guideS6L2 =>
      'अगले 7 दिनों तक 300 मी के अंदर आने वाले को रडार पर एक लिफ़ाफ़ा दिखेगा और वह उसे खोलकर पढ़ सकेगा।';

  @override
  String get guideS6L3 =>
      'फुसफुसाहटें हमेशा गुमनाम होती हैं। एक समय में ज़्यादा से ज़्यादा 3, हर 10 मिनट में ज़्यादा से ज़्यादा 1 छोड़ सकते हैं और कभी भी वापस ले सकते हैं।';

  @override
  String get guideS6L4 =>
      'भविष्य के पत्र: फुसफुसाहट लिखते समय भविष्य के मेरे लिए चुनें, फिर एक महीना या एक साल। इसे सिर्फ़ आप देख सकते हैं। समय आने पर आपको सूचना मिलेगी, और 100 मी के अंदर लौटने पर यह अपने आप खुल जाएगा। इसे सिर्फ़ एक बार पढ़ा जा सकता है। रडार पर सिर्फ़ आपको एक छोटी रेत-घड़ी दिखती है (बंद या खुली), और उस पर टैप नहीं होता। एक समय में ज़्यादा से ज़्यादा 5; सेटिंग्स → भविष्य के लिए मेरे पत्र में देखें या हटाएँ।';

  @override
  String get guideS7Title => '7. शहर का मूड मौसम';

  @override
  String get guideS7L1 =>
      'ऊपर बाईं ओर का लेबल पिछले 24 घंटों में 20 किमी के अंदर सबसे आम मूड दिखाता है। पूरा ब्योरा देखने के लिए टैप करें।';

  @override
  String get guideS7L2 =>
      '10 से कम लोग हों तो प्रतिशत छिपा दिए जाते हैं, ताकि किसी की पहचान न हो।';

  @override
  String get guideS8Title => '8. सभाएँ';

  @override
  String get guideS8L1 =>
      'शुरू करने के लिए: सेटिंग्स → सभा आयोजित करें → नाम, आइकन के लिए एक इमोजी और शुरू-खत्म का समय (24 घंटे तक) डालें → सभा शुरू करें।';

  @override
  String get guideS8L2 =>
      'सभा होस्ट की चेक-इन वाली जगह के आस-पास 5 किमी तक होती है; होस्ट फिर से चेक-इन करें तो दायरा साथ चलता है। रडार पर होस्ट के पास रोशनी का घेरा और होस्ट का लेबल होता है।';

  @override
  String get guideS8L3 =>
      'होस्ट जितनी चाहें घोषणाएँ कर सकते हैं, सबसे एक सवाल पूछ सकते हैं और कभी भी सभा खत्म कर सकते हैं।';

  @override
  String get guideS8L4 =>
      'शामिल होने के लिए सभा का आइकन अपने शहर के नाम में जोड़ें (जैसे “भटकती बिल्ली🌈”)। दायरे में रहते हुए आपको रडार के ऊपर पिन की हुई घोषणा दिखेगी और नोटिफ़िकेशन मिलेंगे। छोड़ने के लिए आइकन हटा दें।';

  @override
  String get guideS8L5 =>
      'ग्रुप सवाल: मूड से जवाब दें। होस्ट सिर्फ़ कुल प्रतिशत देखते हैं, कभी नहीं कि किसने क्या जवाब दिया, और 10 से कम जवाब हों तो प्रतिशत छिपे रहते हैं।';

  @override
  String get guideS8L6 =>
      'एक इलाके में एक समय में एक आइकन सिर्फ़ एक सभा इस्तेमाल कर सकती है। सभा खत्म होने पर कोई भी उस आइकन का इस्तेमाल कर सकता है।';

  @override
  String get guideS8L7 =>
      'सौंपना: होस्ट किसी प्रतिभागी के बबल को दबाकर रखें → होस्टिंग सौंपें, और घोषित या चुपचाप सौंपना चुनें। वह व्यक्ति 5 मिनट में स्वीकार करे तो होस्ट बन जाता है, और घोषणाएँ व सवाल बने रहते हैं। पिछले होस्ट प्रतिभागी बन जाते हैं और उनके नाम में आइकन जुड़ जाता है।';

  @override
  String get guideS9Title => '9. सिटी बीकन (सुलभ शौचालय)';

  @override
  String get guideS9L1 =>
      'बीकन चालू करने के लिए मैप के नीचे बाईं ओर शौचालय आइकन पर टैप करें। 2 किमी के अंदर के जेंडर-फ़्रेंडली, सुलभ और फ़ैमिली शौचालय रडार पर दिखते हैं, और आइकन के पास गिनती होती है। सिर्फ़ कुछ प्रकार देखने के लिए ऊपर के तीन गोल फ़िल्टर टैप करें।';

  @override
  String get guideS9L2 =>
      'मंज़िल, सुविधाएँ और दूरी देखने के लिए किसी मार्कर पर टैप करें, और अपने मैप ऐप में रास्ता देखने के लिए पैदल जाएँ दबाएँ।';

  @override
  String get guideS9L3 =>
      'डेटा ताइवान के पर्यावरण मंत्रालय के सार्वजनिक शौचालय रिकॉर्ड से आता है और हर महीने अपडेट होता है। खुलने का समय शामिल नहीं है; “शायद रात में खुला” जगह के प्रकार पर आधारित हमारा अनुमान है।';

  @override
  String get guideS9L4 =>
      'कुछ गलत हो तो आप रिपोर्ट कर सकते हैं (जेंडर-फ़्रेंडली नहीं, रात में बंद, नहीं मिला)। जब 3 लोग एक ही समस्या बताते हैं, तो मार्कर एक नोट के साथ धूसर हो जाता है।';

  @override
  String get guideS10Title => '11. मूड कार्ड और मूड सफ़र';

  @override
  String get guideS10L1 =>
      'नीचे की पट्टी का शेयर बटन आपके अभी के मूड को रात के दृश्य वाले कार्ड में बदलता है, Instagram स्टोरी के लिए बना। कार्ड पर आपकी लोकेशन कभी नहीं होती।';

  @override
  String get guideS10L2 =>
      'सेटिंग्स → मेरा मूड सफ़र में आप अपने लिखे मूड और जगहें देख सकते हैं। यह सिर्फ़ आपके फ़ोन में सेव रहता है, और आप इसे कभी भी बंद या साफ़ कर सकते हैं।';

  @override
  String get guideS11Title => '17. सेटिंग्स और नोटिफ़िकेशन';

  @override
  String get guideS11L1 =>
      'रात का रिमाइंडर: हर रात 21:30 बजे एक हल्का-सा रिमाइंडर। सेटिंग्स में चालू या बंद करें।';

  @override
  String get guideS11L2 =>
      'दस्तक, नए संदेश, झिलमिल और सभा की घोषणाएँ नोटिफ़िकेशन के रूप में आती हैं। आप इन्हें फ़ोन की सेटिंग्स में बंद कर सकते हैं।';

  @override
  String get guideS11L3 =>
      'हर शुक्रवार 21:00 से 23:00 तक रोशनी की रात है, जब सब एक साथ ऑनलाइन आते हैं और शहर सबसे ज़्यादा चमकता है।';

  @override
  String get guideS12Title => '18. रिपोर्ट और ब्लॉक';

  @override
  String get guideS12L1 =>
      'आप बबल के मेन्यू (दबाकर रखें), दस्तक कार्ड, चैट के ऊपर दाईं ओर, किसी फुसफुसाहट या सभा की घोषणा से रिपोर्ट कर सकते हैं। रिपोर्ट करते ही वह व्यक्ति या पोस्ट आपकी स्क्रीन से तुरंत हट जाता है और चैट खत्म हो जाती है। हम हर रिपोर्ट 24 घंटे के अंदर देखते हैं।';

  @override
  String get guideS12L2 =>
      'मूड, नाम, फुसफुसाहटें, चैट संदेश और सभा की घोषणाएँ आपत्तिजनक शब्दों और फ़ोन नंबर, लिंक जैसी संपर्क जानकारी के लिए अपने आप फ़िल्टर होती हैं।';

  @override
  String get guideS12L3 =>
      'किसी को ब्लॉक करने पर आप दोनों एक-दूसरे के रडार से गायब हो जाते हैं और दस्तक या झिलमिल नहीं भेज सकते। सेटिंग्स → ब्लॉक किए गए लोग में अनब्लॉक करें।';

  @override
  String get guideS12L4 =>
      'अगर आप तुरंत खतरे में हैं, तो स्थानीय आपातकालीन नंबर पर कॉल करें (भारत में 112)।';

  @override
  String get guideS13Title => '19. प्राइवेसी और आपका खाता';

  @override
  String get guideS13L1 =>
      'चेक-इन के बाद ही आस-पास के लोग आपका मूड, शहर का नाम, फ़ोटो और अनुमानित दूरी देख पाते हैं। उन्हें चेक-इन वाली जगह दिखती है, आपकी लाइव लोकेशन नहीं।';

  @override
  String get guideS13L2 =>
      'सेटिंग्स → खाता और डेटा हटाएँ से आप कभी भी शहर में छोड़ी हर चीज़ हमेशा के लिए मिटा सकते हैं।';

  @override
  String get guideS13L3 =>
      'सवाल हैं? सेटिंग्स → हमसे संपर्क करें में जाएँ, या service.softchip@gmail.com पर ईमेल करें।';

  @override
  String get guideS14Title => '12. पैरेलल यूनिवर्स';

  @override
  String get guideS14L1 =>
      'चालू करने के लिए रडार के ऊपर दाईं ओर ग्लोब पर टैप करें, और बंद करने के लिए फिर से। हर बार ऐप खोलने पर यह बंद रहता है।';

  @override
  String get guideS14L2 =>
      'ताइवान का हर शहर या काउंटी अपने सेंट्रल स्टेशन को केंद्र मानता है (ग्रेटर ताइपे के लिए ताइपे स्टेशन, ताओयुआन के लिए ताओयुआन स्टेशन, वगैरह) और विदेश के शहरों से जुड़ता है: जापान, कोरिया, हांगकांग, मकाऊ, सिंगापुर, मलेशिया, इंडोनेशिया, वियतनाम, थाईलैंड, फ़िलीपींस, ऑस्ट्रेलिया, न्यूज़ीलैंड, भारत, ब्राज़ील, अर्जेंटीना और दक्षिण अफ़्रीका। विदेश के शहर ताइवान से जुड़ते हैं।';

  @override
  String get guideS14L3 =>
      'आप अपने स्टेशन से जितनी दूर और जिस दिशा में हैं, दूसरे के शहर में उनके स्टेशन से उतनी ही दूर और उसी दिशा में दिखते हैं, लगभग 500 मी तक धुंधला करके। आपकी असली लोकेशन कोई नहीं देख सकता।';

  @override
  String get guideS14L4 =>
      'दोनों में से किसी एक का चालू हो तो आप एक-दूसरे को देखते हैं: चालू होने पर आप जुड़े शहरों में ऐप खोले सभी लोगों को देखते हैं; बंद होने पर सिर्फ़ उन्हें जिन्होंने इसे चालू किया है। दूसरे शहरों में सिर्फ़ चेक-इन किए और ऐप खोले लोग दिखते हैं।';

  @override
  String get guideS14L5 =>
      'पैरेलल यूनिवर्स के लोगों का घेरा डैश वाला होता है और उनका शहर दिखता है। आप फिर भी झिलमिल भेज सकते हैं, दस्तक दे सकते हैं और चैट कर सकते हैं। फुसफुसाहटें, भविष्य के पत्र और सभाएँ स्थानीय रहती हैं।';

  @override
  String get guideS15Title => '16. अनुवाद';

  @override
  String get guideS15L1 =>
      'चैट में जब कोई संदेश आपकी भाषा में नहीं होता, तो उसके नीचे अनुवाद के लिए टैप करें दिखता है। अपनी भाषा में अनुवाद के लिए टैप करें, और मूल देखने के लिए फिर से।';

  @override
  String get guideS15L2 =>
      'रडार पर मूड बबल भी ऐसे ही काम करते हैं: अगर कोई आपकी भाषा में नहीं है, तो अनुवाद के लिए टैप करें और मूल पर लौटने के लिए फिर से।';

  @override
  String get guideS15L3 =>
      'अनुवाद पूरी तरह आपके फ़ोन पर होता है; टेक्स्ट कभी अपलोड नहीं होता। iPhone Apple का बिल्ट-इन अनुवाद इस्तेमाल करता है, और पहली बार कोई भाषा डाउनलोड करने से पहले सिस्टम पूछता है। Android Google ML Kit इस्तेमाल करता है, जो पहले पूछता है और फिर लगभग 30 MB का भाषा मॉडल डाउनलोड करता है। iPhone अभी मलय भाषा का अनुवाद नहीं करता।';

  @override
  String get guideIntro =>
      'Mood Whisper रात का एक शहर है: अभी आप कैसा महसूस कर रहे हैं, एक वाक्य में लिखें, और देखें कि आपके आस-पास के लोग कैसा महसूस कर रहे हैं।';

  @override
  String get beaconGender => 'जेंडर-फ़्रेंडली';

  @override
  String get beaconAccessible => 'सुलभ';

  @override
  String get beaconFamily => 'फ़ैमिली';

  @override
  String get beaconReportNotGender => 'जेंडर-फ़्रेंडली नहीं है';

  @override
  String get beaconReportClosed => 'रात में बंद रहता है';

  @override
  String get beaconReportMissing => 'यह शौचालय नहीं मिला';

  @override
  String get beaconFlagNotGender => 'रिपोर्ट: जेंडर-फ़्रेंडली नहीं';

  @override
  String get beaconFlagClosed => 'रिपोर्ट: रात में बंद';

  @override
  String get beaconFlagMissing => 'रिपोर्ट: नहीं मिला';

  @override
  String get beaconDefaultName => 'सार्वजनिक शौचालय';

  @override
  String meters(int m) {
    return '$m मी';
  }

  @override
  String kilometers(String km) {
    return '$km किमी';
  }

  @override
  String get beaconUnavailable =>
      'सिटी बीकन अभी उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get notConnectedCheckNetwork =>
      'कनेक्ट नहीं हो सका। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$features शौचालय, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'सिटी बीकन (सुलभ शौचालय) बंद करें, पास में $count';
  }

  @override
  String get beaconToggleOn => 'सिटी बीकन (सुलभ शौचालय) चालू करें';

  @override
  String beaconFilterOnly(String feature) {
    return 'सिर्फ़ $feature दिखाएँ';
  }

  @override
  String get beaconMaybeOpenNight => 'शायद रात में खुला (अनुमान)';

  @override
  String get beaconMaybeDaytime => 'शायद सिर्फ़ दिन में (अनुमान)';

  @override
  String get walkThere => 'पैदल जाएँ';

  @override
  String get beaconWrongData => 'कुछ गलत है?';

  @override
  String beaconThanks(String reason) {
    return 'धन्यवाद। हमें आपकी रिपोर्ट मिल गई: “$reason”।';
  }

  @override
  String get beaconSource =>
      'स्रोत: ताइवान के पर्यावरण मंत्रालय के सार्वजनिक शौचालय रिकॉर्ड, हर महीने अपडेट। खुलने का समय जगह के प्रकार पर आधारित हमारा अनुमान है।';

  @override
  String get invite1 =>
      'मैंने Mood Whisper पर एक रोशनी जलाई है। आस-पास जितने ज़्यादा लोग, हमारा मोहल्ला उतना रोशन। आओ मेरे साथ जलाओ:';

  @override
  String get invite2 =>
      'आज रात शहर थोड़ा शांत है। Mood Whisper पर अपना मूड लिखो और हमारे मोहल्ले को रोशन करो:';

  @override
  String get invite3 =>
      'न फ़्रेंड रिक्वेस्ट, न असली नाम, बस एक लाइन कि तुम कैसा महसूस कर रहे हो। मुझे Mood Whisper पर ढूँढो:';

  @override
  String get invite4 =>
      'मैंने Mood Whisper पर तुम्हारे लिए एक रोशनी जलाकर रखी है। ऐप खोलो और देखो आज रात आस-पास के लोग कैसा महसूस कर रहे हैं:';

  @override
  String get invite5 =>
      'हर शुक्रवार रात 9 बजे Mood Whisper पर रोशनी की रात होती है। मेरे साथ ऑनलाइन आओ और रडार को रोशनी से भर दें:';

  @override
  String get invite6 =>
      'आज का दिन कैसा रहा, कहने की जगह चाहिए? Mood Whisper गुमनाम है, और कहने के बाद शब्द मिट जाते हैं:';

  @override
  String get invite7 =>
      'कभी सोचा है कि सड़क पर पास से गुज़रने वाले लोग क्या महसूस करते हैं? Mood Whisper पर खुद देखो:';

  @override
  String get invite8 =>
      'मैंने इस सड़क पर एक फुसफुसाहट छोड़ी है जिसे सिर्फ़ राहगीर पढ़ सकते हैं। आओ तुम भी एक छोड़ो:';

  @override
  String get invite9 =>
      'Mood Whisper रात में शहर के मूड का नक्शा है। ज़्यादा लोगों के साथ ज़्यादा मज़ा है, तो आओ हमारे मोहल्ले में एक रोशनी जोड़ो:';

  @override
  String get invite10 =>
      'आज रात तुम्हारे मूड का रंग क्या है? Mood Whisper पर लिखो। मैं पास ही रहूँगा, तुम्हारी रोशनी का इंतज़ार करते हुए:';

  @override
  String get shareInvite => 'न्योता शेयर करें';

  @override
  String get inviteSubject => 'आओ मेरे साथ हमारा मोहल्ला रोशन करो';

  @override
  String get shareMoodCardButton => 'कार्ड शेयर करें';

  @override
  String moodShareText(String mood) {
    return 'मैंने Mood Whisper पर शेयर किया कि अभी कैसा महसूस कर रहा हूँ: “$mood”\nक्या आज रात तुम्हारा मूड भी शहर में चमक रहा है?';
  }

  @override
  String get shareFailed => 'शेयर नहीं हुआ। फिर से कोशिश करें।';

  @override
  String shuffleCard(int current, int total) {
    return 'बदलें · $current / $total';
  }

  @override
  String get preparing => 'तैयार हो रहा है…';

  @override
  String get sendLinkToFriends => 'दोस्तों को लिंक भेजें (WhatsApp, Messenger)';

  @override
  String get partLateNight => 'देर रात';

  @override
  String get partMorning => 'सुबह';

  @override
  String get partAfternoon => 'दोपहर';

  @override
  String get partDusk => 'शाम';

  @override
  String get partNight => 'रात';

  @override
  String get cardInviteEyebrow => 'एक न्योता';

  @override
  String get cardMoodEyebrow => 'अभी मैं कैसा महसूस कर रहा हूँ';

  @override
  String get cardInviteTitle => 'आओ हमारा मोहल्ला\nरोशन करें';

  @override
  String get cardInviteBody =>
      'मैंने Mood Whisper पर एक रोशनी जलाई है।\nआस-पास जितने ज़्यादा लोग, मोहल्ला उतना रोशन।';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nशहर में कहीं';
  }

  @override
  String get whisperUnavailable =>
      'फुसफुसाहट अभी उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get whisperNotSent =>
      'आपकी फुसफुसाहट नहीं भेजी गई। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get timeWhisperTitle => 'भविष्य के लिए पत्र';

  @override
  String get timeWhisperLead =>
      'भविष्य के अपने लिए लिखें। समय आने पर इसे खोलने के लिए यहाँ लौटें।';

  @override
  String get whisperLead => 'अगले राहगीर के लिए लिखें।';

  @override
  String get toPassersBy => 'राहगीरों के लिए';

  @override
  String get toFutureSelf => 'भविष्य के मेरे लिए';

  @override
  String get inOneMonth => 'एक महीने में';

  @override
  String get inOneYear => 'एक साल में';

  @override
  String get timeWhisperHint =>
      'जैसे अगले साल यहीं मिलते हैं। उम्मीद है तब तुम अभी से बेहतर होगे।';

  @override
  String get whisperHint =>
      'जैसे यहाँ का सूर्यास्त बहुत सुंदर है। ऊपर देखना मत भूलना।';

  @override
  String get timeWhisperCaptionYear =>
      'सिर्फ़ आप देख सकते हैं · एक साल में खुलेगा और आपको बताएगा · 100 मी के अंदर खुलता है';

  @override
  String get timeWhisperCaptionMonth =>
      'सिर्फ़ आप देख सकते हैं · एक महीने में खुलेगा और आपको बताएगा · 100 मी के अंदर खुलता है';

  @override
  String get whisperCaption =>
      '7 दिन में मिट जाती है · कभी नहीं बताती कि आप कौन हैं · बस इतना कि आप यहीं कहीं थे';

  @override
  String get sealHere => 'यहाँ बंद करें';

  @override
  String get leaveHere => 'यहाँ छोड़ें';

  @override
  String get aWhisper => 'एक फुसफुसाहट';

  @override
  String whisperLeftAgo(String ago) {
    return '$ago यहीं कहीं छोड़ी गई';
  }

  @override
  String whisperCollectedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोगों ने पढ़ी',
      one: '1 व्यक्ति ने पढ़ी',
    );
    return '$_temp0';
  }

  @override
  String get whisperNobodyYet => 'अभी तक कोई यहाँ से नहीं गुज़रा';

  @override
  String get withdrawWhisper => 'यह फुसफुसाहट वापस लें';

  @override
  String get whisperCollected => 'आपने यह फुसफुसाहट उठा ली।';

  @override
  String whisperReadersBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपसे पहले $count लोग यहाँ से गुज़रे।',
      one: 'आपसे पहले 1 व्यक्ति यहाँ से गुज़रा।',
    );
    return '$_temp0';
  }

  @override
  String get whisperFirstReader => 'यहाँ से गुज़रने वाले आप पहले हैं।';

  @override
  String get reportWhisper => 'इस फुसफुसाहट की रिपोर्ट करें';

  @override
  String get thisWhisper => 'यह फुसफुसाहट';

  @override
  String get chatTimeUp => 'समय पूरा हुआ। पल मिट रहा है...';

  @override
  String get chatOtherLeft => 'वे शहर में लौट गए...';

  @override
  String get chatEnded => 'यह पल खत्म हो गया...';

  @override
  String get chatBlockedEnded => 'ब्लॉक कर दिया। बातचीत खत्म हो गई।';

  @override
  String get chatReportedEnded => 'रिपोर्ट कर दी। बातचीत खत्म हो गई।';

  @override
  String get anonymous => 'गुमनाम';

  @override
  String get leaveChat => 'बातचीत छोड़ें';

  @override
  String chatWith(String name) {
    return '$name के साथ एक पल';
  }

  @override
  String get countdownPrefix => 'मिटने में ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'डेमो बातचीत: जवाब अपने आप आते हैं, किसी असली व्यक्ति से नहीं।';

  @override
  String get typing => 'लिख रहे हैं…';

  @override
  String get chatHint => 'धीरे से कुछ कहें…';

  @override
  String get send => 'भेजें';

  @override
  String get chatDissolvedApart => 'आप दोनों शहर में लौट गए';

  @override
  String get knockTooOften =>
      'आप बहुत ज़्यादा दस्तक दे रहे हैं। शहर के साथ थोड़ा साँस लें...';

  @override
  String get otherNotNow =>
      'वे अभी परेशान नहीं होना चाहते। एक-दूसरे को थोड़ी जगह दें।';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'वे अभी परेशान नहीं होना चाहते। एक-दूसरे को थोड़ी जगह दें ($minutes मिनट)।';
  }

  @override
  String get justEndedRest =>
      'आप दोनों ने अभी-अभी अलविदा कहा है। यादों को थोड़ा ठहरने दें।';

  @override
  String get intro1Title => 'शहर में आ जाएँ';

  @override
  String get intro1Body =>
      'सोशल लेबल पीछे छोड़ दें। एक शांत अँधेरे कैनवास पर बस यही बचता है कि आप सच में कैसा महसूस करते हैं, और कहाँ।';

  @override
  String get intro2Title => 'एक गुज़रता पल';

  @override
  String get intro2Body =>
      'पास में कोई मूड बबल तैरता दिखा? धीरे से दस्तक दें और किसी राहगीर के साथ एक अनोखी बातचीत करें।';

  @override
  String get intro3Title => 'शहर की लय';

  @override
  String get intro3Body =>
      'हमें परवाह है कि आप कैसा महसूस करते हैं। दस्तक के बाद चुपचाप जवाब का इंतज़ार करें। अगर किस्मत में न हो, तो 300 सेकंड बाद बबल मिट जाता है।';

  @override
  String get intro4Title => 'एक नरम दूरी';

  @override
  String get intro4Body =>
      'परेशान नहीं होना चाहते? मना करें या ब्लॉक करें। एक कूल-डाउन सिस्टम शोर दूर रखता है और आपका शांत कोना लौटा देता है।';

  @override
  String get intro5Title => 'मिलने के लिए तैयार?';

  @override
  String get intro5Body =>
      'आँखें बंद करें और फ़ोन की धड़कन और अपने दिल की धड़कन महसूस करें। अब लिखें कि आप कैसा महसूस कर रहे हैं, यहाँ चेक-इन करें और Mood Whisper में आ जाएँ।';

  @override
  String get intro6Title => 'भविष्य के अपने लिए एक पत्र';

  @override
  String get intro6Body =>
      'एक महीने या एक साल बाद के अपने लिए इसी जगह कुछ शब्द छोड़ें। यह तभी खुलता है जब आप लौटते हैं।';

  @override
  String get intro7Title => 'आज रात साथ चमकें';

  @override
  String get intro7Body =>
      'एक इमोजी को गुप्त निशान बनाकर सभा आयोजित करें। जो भी इसे अपने नाम में जोड़ेगा उसे आपकी घोषणाएँ मिलेंगी, और पूरा मोहल्ला एक साथ रोशन होगा।';

  @override
  String get intro8Title => 'पैरेलल यूनिवर्स';

  @override
  String get intro8Body =>
      'ग्लोब पर टैप करें और ताइवान के शहर टोक्यो, सियोल और मुंबई से मिल जाते हैं। देखें दूर के लोग अभी कैसा महसूस कर रहे हैं, दस्तक दें, चैट करें और टैप करके अनुवाद करें।';

  @override
  String get loadingImage => 'तस्वीर लोड हो रही है...';

  @override
  String get startExploring => 'घूमना शुरू करें';

  @override
  String get nextPage => 'आगे';

  @override
  String get feedbackSubject => 'Mood Whisper के बारे में राय';

  @override
  String get feedbackTitle => 'सुझाव भेजें';

  @override
  String get feedbackSubtitle => 'ऐप में ही हमें बताएँ';

  @override
  String get feedbackIntro =>
      'सुझाव, समस्या या सुरक्षा से जुड़ी चिंता — कुछ भी लिखें। आपका संदेश सिर्फ़ Mood Whisper टीम पढ़ सकती है।';

  @override
  String get feedbackKindIdea => 'सुझाव';

  @override
  String get feedbackKindBug => 'समस्या';

  @override
  String get feedbackKindSafety => 'सुरक्षा';

  @override
  String get feedbackKindOther => 'अन्य';

  @override
  String get feedbackHint => 'आप हमें क्या बताना चाहते हैं?';

  @override
  String get feedbackSend => 'भेजें';

  @override
  String get feedbackThanks => 'धन्यवाद, हमें मिल गया।';

  @override
  String get feedbackNotSent =>
      'नहीं भेजा जा सका। कृपया बाद में फिर कोशिश करें।';

  @override
  String get feedbackEmpty => 'पहले कुछ लिखें।';

  @override
  String get loginNeedMood =>
      'अभी आप कैसा महसूस कर रहे हैं, लिखें, फिर शहर में आएँ।';

  @override
  String get loginNeedAgree =>
      'पहले उपयोग की शर्तें और प्राइवेसी पॉलिसी पढ़कर स्वीकार करें।';

  @override
  String get loginCantConnect =>
      'शहर तक नहीं पहुँच सके। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get ageQuestion => 'क्या आपकी उम्र 18 साल या ज़्यादा है?';

  @override
  String get ageReason =>
      'Mood Whisper आपको आस-पास के अजनबियों से जोड़ता है, इसलिए यह सिर्फ़ 18 साल और उससे ज़्यादा उम्र के लोगों के लिए है।';

  @override
  String get ageUnder => 'मेरी उम्र 18 से कम है';

  @override
  String get ageOver => 'मेरी उम्र 18 या ज़्यादा है';

  @override
  String get loginTitle1 => 'मिलने के';

  @override
  String get loginTitle2 => ' लिए तैयार?';

  @override
  String get loginLead =>
      'आँखें बंद करें और फ़ोन की धड़कन और अपने दिल की धड़कन महसूस करें।\nअब लिखें कि आप कैसा महसूस कर रहे हैं और Mood Whisper में आ जाएँ।';

  @override
  String get loginPrompt => 'अभी आप शहर से क्या कहना चाहते हैं?';

  @override
  String get loginHint => 'जैसे आज बहुत बढ़िया चाय पी😊';

  @override
  String get enterCity => 'Mood Whisper में जाएँ';

  @override
  String get agreeSemantic =>
      'मैंने उपयोग की शर्तें और प्राइवेसी पॉलिसी पढ़ ली हैं और स्वीकार करता हूँ';

  @override
  String get agreePrefix => 'मैंने ';

  @override
  String get termsLink => 'उपयोग की शर्तें';

  @override
  String get agreeAnd => ' और ';

  @override
  String get privacyLink => 'प्राइवेसी पॉलिसी';

  @override
  String get agreeSuffix =>
      ' पढ़ ली हैं और स्वीकार करता हूँ। Mood Whisper उत्पीड़न, यौन सामग्री, नफ़रत या किसी भी दुर्व्यवहार को बिल्कुल बर्दाश्त नहीं करता। यह नियम तोड़ने वाले को हटा दिया जाएगा।';

  @override
  String get under18Title =>
      'Mood Whisper 18 साल और उससे ज़्यादा उम्र के लोगों के लिए है';

  @override
  String get under18Body =>
      'ईमानदारी के लिए धन्यवाद। यह शहर आपको अजनबियों से जोड़ता है। 18 के होने पर मिलते हैं।';

  @override
  String get clearMoodTrail => 'मूड सफ़र साफ़ करें';

  @override
  String get clearMoodTrailBody =>
      'इस फ़ोन का पूरा मूड सफ़र हटा दिया जाएगा। इसे वापस नहीं किया जा सकता।';

  @override
  String get clear => 'साफ़ करें';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'सिर्फ़ आपके फ़ोन में सेव। कहीं अपलोड नहीं होता।';

  @override
  String get moodTrailEmpty =>
      'इस हफ़्ते अभी कोई मूड सफ़र नहीं। हर बार मूड लिखने या नई जगह जाने पर यहाँ एक नई रोशनी दिखेगी।';

  @override
  String get thisWeekYou => 'आपका हफ़्ता';

  @override
  String get topMoodPrefix => 'आपने सबसे ज़्यादा महसूस किया “';

  @override
  String topMoodSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '”, $count बार',
      one: '”, 1 बार',
    );
    return '$_temp0';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$places अलग-अलग जगहों पर $total मूड छोड़े';
  }

  @override
  String get recordMoodTrail => 'मेरा मूड सफ़र रिकॉर्ड करें';

  @override
  String get recordMoodTrailOff => 'बंद होने पर कोई नया सफ़र रिकॉर्ड नहीं होता';

  @override
  String get nightly1 => 'आज रात शहर के मन में क्या है?';

  @override
  String get nightly2 =>
      'आस-पास कोई लिख रहा है कि अभी वह कैसा महसूस कर रहा है।';

  @override
  String get nightly3 => 'रात बिल्कुल सही है। शहर के लिए एक लाइन छोड़ें।';

  @override
  String get nightly4 => 'आज का दिन कैसा रहा? आपका मूड शहर में चमकेगा।';

  @override
  String get nightly5 =>
      'सड़क की बत्तियाँ जल गई हैं, और आस-पास के लोग अभी जाग रहे हैं।';

  @override
  String get nightly6 => 'दिन को एक अंत दें: अभी आप कैसा महसूस कर रहे हैं?';

  @override
  String get nightly7 => 'आज रात आप किसके पास से गुज़रेंगे?';

  @override
  String get nightlyChannel => 'रात का रिमाइंडर';

  @override
  String get nightlyChannelDesc =>
      'हर रात एक हल्का-सा रिमाइंडर। आप इसे ऐप की सेटिंग्स में बंद कर सकते हैं।';

  @override
  String get reasonHarassment => 'उत्पीड़न या धमकाना';

  @override
  String get reasonSexual => 'यौन सामग्री';

  @override
  String get reasonScam => 'धोखा या स्पैम';

  @override
  String get reasonHate => 'नफ़रत या हिंसा';

  @override
  String get reasonImpersonation => 'किसी और का रूप धरना';

  @override
  String get reasonOther => 'कुछ और';

  @override
  String get reportReceived =>
      'रिपोर्ट मिल गई और आपकी स्क्रीन से हटा दी गई। हम 24 घंटे के अंदर इसकी समीक्षा करेंगे।';

  @override
  String get reportNotSent =>
      'आपकी रिपोर्ट नहीं भेजी गई। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String reportTarget(String target) {
    return '$target की रिपोर्ट करें';
  }

  @override
  String get reportPrivate =>
      'उन्हें पता नहीं चलेगा कि आपने रिपोर्ट की। एक कारण चुनें:';

  @override
  String get reportDetails => 'और जानकारी (वैकल्पिक)';

  @override
  String get reportWhatHappened => 'क्या हुआ?';

  @override
  String get sendReport => 'रिपोर्ट भेजें';

  @override
  String get alsoBlock =>
      'उन्हें ब्लॉक भी करें। आप दोनों एक-दूसरे के शहर से गायब हो जाएँगे।';

  @override
  String get aYearAgo => 'एक साल पहले';

  @override
  String get aMonthAgo => 'एक महीने पहले';

  @override
  String get timeWhisperUnavailable =>
      'भविष्य के पत्र अभी उपलब्ध नहीं हैं। बाद में कोशिश करें।';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, आपने यहाँ कहा था';
  }

  @override
  String writtenOn(String date) {
    return '$date को लिखा';
  }

  @override
  String get timeWhisperOnce => 'यह पत्र सिर्फ़ एक बार दिखता है।';

  @override
  String get keepInHeart => 'दिल में रखें';

  @override
  String unsealsOn(String unlock, String created) {
    return '$unlock को खुलेगा · $created को लिखा';
  }

  @override
  String get unsealedGoBack => 'खुल गया। खोलने के लिए वहाँ वापस जाएँ।';

  @override
  String unsealedDistance(String distance) {
    return 'खुल गया · $distance दूर';
  }

  @override
  String get timeWhisperListLead =>
      'भविष्य के अपने लिए पत्र, जो सिर्फ़ आप देख सकते हैं। समय आने पर खोलने के लिए उस जगह से 100 मी के अंदर जाएँ। पढ़ने के बाद यह मिट जाता है।';

  @override
  String get timeWhisperListEmpty =>
      'अभी भविष्य का कोई पत्र नहीं। नीचे की पट्टी में नोट आइकन पर टैप करें और “भविष्य के मेरे लिए” चुनें।';

  @override
  String get readyToOpen => 'खोलने के लिए तैयार';

  @override
  String get sealed => 'बंद';

  @override
  String get delete => 'हटाएँ';

  @override
  String get within100m => '100 मी के अंदर';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return '$name के जवाब का इंतज़ार, $mm:$ss बाकी';
  }

  @override
  String knockWaiting(String name) {
    return '$name का इंतज़ार';
  }

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'फ़ोन जैसी';

  @override
  String get parallelUniverse => 'पैरेलल यूनिवर्स';

  @override
  String get parallelUniverseSubtitle =>
      'देखें दूसरे शहर अभी कैसा महसूस कर रहे हैं, और उन्हें आपको देखने दें';

  @override
  String get parallelUniverseIntroTitle => 'पैरेलल यूनिवर्स में जाएँ';

  @override
  String get parallelUniverseIntroBody =>
      'चालू होने पर आपके जुड़े शहरों में ऐप खोले हर व्यक्ति आपके रडार पर दिखता है, और वे सब आपको देख सकते हैं। ताइवान के शहर विदेश के शहरों (जैसे टोक्यो, सियोल और मुंबई) से जुड़ते हैं, और विदेश के शहर ताइवान से।\n\nदोनों शहर अपने केंद्र (सेंट्रल स्टेशन, या जहाँ स्टेशन नहीं वहाँ नगर निगम) पर मिलते हैं: आप अपने केंद्र से जितनी दूर और जिस दिशा में हैं, दूसरे शहर में वहीं दिखते हैं, लगभग 500 मी तक धुंधला करके, ताकि कोई आपकी असली लोकेशन या दूरी न देख सके। आप फिर भी झिलमिल भेज सकते हैं, दस्तक दे सकते हैं और चैट कर सकते हैं, और कभी भी बंद कर सकते हैं। फुसफुसाहटें और सभाएँ स्थानीय रहती हैं।';

  @override
  String get parallelUniverseEnter => 'जाएँ';

  @override
  String get parallelUniverseNoCity =>
      'आप जहाँ हैं वहाँ अभी पैरेलल यूनिवर्स नहीं है';

  @override
  String parallelFrom(String city) {
    return 'पैरेलल · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'यह व्यक्ति $city में है, आपके पास नहीं। उनकी जगह प्रोजेक्ट की गई है और असली दूरी नहीं दिखाती।';
  }

  @override
  String get labelHost => 'होस्ट';

  @override
  String get labelDemo => 'डेमो';

  @override
  String get labelResting => 'आराम में';

  @override
  String get cityTaipei => 'ताइपे';

  @override
  String get cityTaichung => 'ताइचुंग';

  @override
  String get cityKaohsiung => 'काओशुंग';

  @override
  String get cityTokyo => 'टोक्यो';

  @override
  String get cityOsaka => 'ओसाका';

  @override
  String get citySeoul => 'सियोल';

  @override
  String get cityBusan => 'बुसान';

  @override
  String get cityHongkong => 'हांगकांग';

  @override
  String get cityMacau => 'मकाऊ';

  @override
  String get citySingapore => 'सिंगापुर';

  @override
  String get cityKualalumpur => 'कुआलालंपुर';

  @override
  String get cityJakarta => 'जकार्ता';

  @override
  String get cityHochiminh => 'हो ची मिन्ह सिटी';

  @override
  String get cityHanoi => 'हनोई';

  @override
  String get translateTap => 'अनुवाद के लिए टैप करें';

  @override
  String get translateShowOriginal => 'अनुवादित · मूल देखने के लिए टैप करें';

  @override
  String get translating => 'अनुवाद हो रहा है…';

  @override
  String get translateFailed => 'अनुवाद नहीं हो सका। बाद में कोशिश करें।';

  @override
  String get translateDownloadTitle => 'अनुवाद मॉडल डाउनलोड करें';

  @override
  String get translateDownloadBody =>
      'इस भाषा का पहली बार अनुवाद करने के लिए एक अनुवाद मॉडल चाहिए (हर भाषा के लिए लगभग 30 MB, एक बार डाउनलोड)।\n\nअनुवाद पूरी तरह आपके फ़ोन पर होता है; संदेश कभी अपलोड नहीं होते।';

  @override
  String get translateDownload => 'डाउनलोड करें';

  @override
  String placeHint(String name) {
    return 'पास में एक मूड प्लेस की रोशनी है · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return '$time तक खुला';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'मूड प्लेस: $name, $hours';
  }

  @override
  String get placeWrongData => 'कुछ गलत है?';

  @override
  String placeReportSubject(String name) {
    return 'मूड प्लेस की जानकारी गलत है: $name';
  }

  @override
  String get placeHintsSetting => 'मूड प्लेस संकेत';

  @override
  String get placeHintsSettingSubtitle =>
      'खुले मूड प्लेस के पास से गुज़रने पर ऐप में एक शांत संकेत (पुश नोटिफ़िकेशन नहीं)';

  @override
  String get guideS16Title => '10. मूड प्लेस';

  @override
  String get guideS16L1 =>
      'मूड प्लेस हमारे साथी स्वतंत्र कैफ़े हैं। चेक-इन के बाद, किसी के खुले होने पर उसके 150 मी के अंदर जाएँ तो आपके रडार पर एक छोटी रोशनी धीरे-धीरे साँस लेती दिखेगी। दूर जाने पर वह बुझ जाती है।';

  @override
  String get guideS16L2 =>
      'जगह का कार्ड खोलने के लिए रोशनी पर टैप करें: अंदर से रात का नज़ारा, आज बंद होने का समय, कैफ़े की एक लाइन की मूड कहानी (अनुवाद के लिए टैप करें), पता और फ़ोन नंबर। अपने मैप ऐप में पैदल रास्ता देखने के लिए पैदल जाएँ दबाएँ। जिस रोशनी का कार्ड आपने आज खोला, वह बिना साँस लिए हल्की चमकती है।';

  @override
  String get guideS16L3 =>
      'पहली बार गुज़रने पर ऊपर एक छोटा कार्ड बताता है, बिना आवाज़ या वाइब्रेशन। हर जगह के लिए 7 दिन में ज़्यादा से ज़्यादा एक और दिन में 2 संकेत मिलते हैं। सेटिंग्स > मूड प्लेस संकेत में बंद करें; रोशनियाँ बनी रहती हैं।';

  @override
  String get guideS16L4 =>
      'जगहों की पूरी सूची आपके फ़ोन में डाउनलोड होती है, और आप पास हैं या नहीं यह सिर्फ़ फ़ोन पर तय होता है। न हमें, न कैफ़े को पता चलता है कि आप कहाँ से गुज़रे। कैफ़े दिखने के लिए पैसे नहीं दे सकते। कुछ गलत हो तो कार्ड के नीचे रिपोर्ट करें।';

  @override
  String get placeGuestbook => 'गेस्टबुक';

  @override
  String placeGuestbookLocked(int m) {
    return 'यहाँ पहले बैठे लोगों ने क्या छोड़ा, पढ़ने के लिए अंदर आएँ (लगभग $m मी के अंदर)।';
  }

  @override
  String get placeGuestbookAbout =>
      'सिर्फ़ अंदर के लोग पढ़ सकते हैं। गुमनाम, 30 दिन में मिट जाता है।';

  @override
  String get placeGuestbookEmpty => 'अभी कोई नोट नहीं। पहला आप छोड़ें।';

  @override
  String get placeGuestbookWrite => 'नोट छोड़ें';

  @override
  String get placeGuestbookHint => 'यहाँ बैठने वाले अगले व्यक्ति के लिए…';

  @override
  String get placeGuestbookSent =>
      'हो गया। यहाँ आने वाला अगला व्यक्ति इसे पढ़ेगा।';

  @override
  String get placeGuestbookUnavailable =>
      'गेस्टबुक अभी उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get placeNoteMine => 'आपका नोट';

  @override
  String get withdrawPlaceNote => 'यह नोट वापस लें';

  @override
  String get reportPlaceNote => 'इस नोट की रिपोर्ट करें';

  @override
  String get thisPlaceNote => 'यह नोट';

  @override
  String get guideS16L5 =>
      'गेस्टबुक: अंदर रहते हुए (लगभग 40 मी के अंदर) जगह का कार्ड खोलें, पहले बैठे लोगों ने जो छोड़ा उसे पढ़ें, और अगले व्यक्ति के लिए एक लाइन छोड़ें। नोट गुमनाम होते हैं और 30 दिन में मिट जाते हैं। हर जगह पर दिन में एक नोट छोड़ सकते हैं, नोट पर टैप करके अनुवाद कर सकते हैं, और परेशान करने वाली चीज़ की रिपोर्ट कर सकते हैं। गेस्टबुक खोलने पर आपका फ़ोन यह पक्का करने के लिए हमारे सर्वर को लोकेशन भेजता है कि आप अंदर हैं; सर्वर इसे रखता नहीं।';

  @override
  String get quantumWorld => 'क्वांटम वर्ल्ड';

  @override
  String get quantumWorldSubtitle =>
      'पूरी दुनिया के लिए एक कमरा, बिना बताए कि आप कहाँ हैं';

  @override
  String get quantumIntroTitle => 'क्वांटम वर्ल्ड में जाएँ';

  @override
  String get quantumIntroBody =>
      'अभी क्वांटम वर्ल्ड में मौजूद सब लोग एक कमरा साझा करते हैं, जो Taipei 101 के चारों ओर छत्ते की तरह सजा है। आपको \"Q4-17\" जैसी सीट मिलती है — घेरा जितना छोटा, मूल बिंदु के उतना पास।\n\nआपकी असली लोकेशन कोई नहीं देख सकता। दूसरों को सिर्फ़ आपकी सीट दिखती है, जो जाएँ दबाने के पल तय हो जाती है; चलने पर वह नहीं हिलती। बदलने के लिए बाहर निकलकर फिर से आएँ। आपका निकनेम और मूड वही रहते हैं, और आप फिर भी झिलमिल भेज सकते हैं, दस्तक दे सकते हैं और चैट कर सकते हैं, टैप करके अनुवाद के साथ।\n\nक्वांटम वर्ल्ड में रहते हुए आप कुछ समय के लिए सामान्य रडार और पैरेलल यूनिवर्स से बाहर रहते हैं; बाहर आने पर अपनी चेक-इन वाली जगह पर लौट आते हैं।';

  @override
  String get quantumEnter => 'जाएँ';

  @override
  String get quantumLeave => 'क्वांटम वर्ल्ड से बाहर जाएँ';

  @override
  String get quantumLeft => 'आप क्वांटम वर्ल्ड से बाहर आकर अपने रडार पर लौट आए';

  @override
  String quantumYourSeat(String code) {
    return 'आपकी सीट $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'घेरा $ring · छोटे घेरे Taipei 101 के मूल बिंदु के ज़्यादा पास हैं';
  }

  @override
  String quantumOnlineChip(int count) {
    return 'अभी $count यहाँ';
  }

  @override
  String quantumOnlineTitle(int count) {
    return 'अभी क्वांटम वर्ल्ड में $count लोग';
  }

  @override
  String get quantumRegionTw => 'ताइवान';

  @override
  String get quantumRegionJp => 'जापान';

  @override
  String get quantumRegionKr => 'कोरिया';

  @override
  String get quantumRegionHkmo => 'हांगकांग और मकाऊ';

  @override
  String get quantumRegionSea => 'दक्षिण-पूर्व एशिया';

  @override
  String get quantumRegionOther => 'बाकी जगहें';

  @override
  String get quantumQuiet => 'क्वांटम शांति';

  @override
  String get quantumQuietSubtitle =>
      'बस दुनिया देखें: कोई दस्तक नहीं दे सकता, पर झिलमिल फिर भी पहुँचती है';

  @override
  String get quantumQuietTarget =>
      'उन्होंने क्वांटम शांति चालू की है — अब आप सिर्फ़ झिलमिल भेज सकते हैं';

  @override
  String get quantumClosedRegion =>
      'आप जहाँ हैं वहाँ क्वांटम वर्ल्ड उपलब्ध नहीं है';

  @override
  String get quantumLeftClosed =>
      'आप ऐसे इलाके में आ गए जहाँ क्वांटम वर्ल्ड उपलब्ध नहीं है, इसलिए आप बाहर आ गए';

  @override
  String get quantumSeatExpired =>
      'आप बहुत देर दूर रहे और आपकी सीट छोड़ दी गई; आप अपने रडार पर लौट आए';

  @override
  String get quantumUnavailable =>
      'अभी क्वांटम वर्ल्ड तक नहीं पहुँच सकते। बाद में कोशिश करें।';

  @override
  String quantumPersonBody(String code) {
    return 'क्वांटम वर्ल्ड में इस व्यक्ति की सीट $code है। क्वांटम वर्ल्ड में किसी की असली लोकेशन नहीं दिखती।';
  }

  @override
  String quantumChatTag(String code) {
    return 'क्वांटम वर्ल्ड · $code';
  }

  @override
  String get guideS17Title => '13. क्वांटम वर्ल्ड';

  @override
  String get guideS17L1 =>
      'रडार के ऊपर दाईं ओर (पैरेलल यूनिवर्स के नीचे) छत्ते वाले आइकन पर टैप करें, नोट पढ़ें और जाएँ दबाएँ। हर बार आप खुद टैप करके जाते हैं, चेक-इन की तरह; हर बार ऐप खोलने पर आप सामान्य रडार से शुरू करते हैं।';

  @override
  String get guideS17L2 =>
      'क्वांटम वर्ल्ड में सब एक कमरा साझा करते हैं: Taipei 101 के चारों ओर छत्ता, जिसमें सीटें 100 मी की दूरी पर हैं। आपको \"Q4-17\" (घेरा 4, सीट 17) जैसा कोड मिलता है — छोटे घेरे मूल बिंदु के ज़्यादा पास हैं। नए आने वाले पहले दूसरों की छोड़ी सीटें भरते हैं; घेरे 1–3 सभा के होस्ट के लिए आरक्षित हैं।';

  @override
  String get guideS17L3 =>
      'आपकी असली लोकेशन कोई नहीं देख सकता: दूसरों को सिर्फ़ आपकी सीट दिखती है। हर बार जाएँ दबाना एक चेक-इन है, और उस पल से आपकी सीट तय रहती है; चलने पर नहीं हिलती। बदलने के लिए बाहर निकलकर फिर से आएँ। क्वांटम वर्ल्ड मुख्य भूमि चीन में उपलब्ध नहीं है।';

  @override
  String get guideS17L4 =>
      'आपका निकनेम और मूड वही रहते हैं, और आप फिर भी झिलमिल भेज सकते हैं, दस्तक दे सकते हैं और चैट कर सकते हैं, टैप करके अनुवाद के साथ। पूरा छत्ता देखने के लिए उँगलियाँ फैलाएँ; दूर के लोग रोशनी के बिंदु बन जाते हैं। ऊपर बाईं ओर अपनी सीट के कोड पर टैप करें — देखें कौन ऑनलाइन है, क्वांटम शांति चालू करें (दस्तक नहीं, झिलमिल फिर भी आती है) या बाहर जाएँ।';

  @override
  String get guideS17L5 =>
      'क्वांटम वर्ल्ड में फुसफुसाहटें, भविष्य के पत्र, मूड प्लेस, सिटी बीकन और आम सभाएँ नहीं हैं। अंदर रहते हुए आप कुछ समय के लिए सामान्य रडार और पैरेलल यूनिवर्स से बाहर रहते हैं; बाहर आने पर आपका बबल रोशनी में घुल जाता है और आप चेक-इन वाली जगह पर लौट आते हैं। ऐप 3 मिनट से ज़्यादा बंद या ऑफ़लाइन रहे तो आपकी सीट छोड़ दी जाती है।';

  @override
  String quantumChimeCountdown(int seconds) {
    return '$seconds सेकंड में घंटे की घंटी';
  }

  @override
  String get quantumChimeLookOrigin => 'सब 101 के मूल बिंदु को देख रहे हैं';

  @override
  String get quantumChimeLook => 'देखें';

  @override
  String quantumChimeNow(int hour) {
    return 'क्वांटम सेंटर में $hour बजे की घंटी';
  }

  @override
  String get quantumChimeSend => 'घंटी की झिलमिल भेजें';

  @override
  String get quantumChimeSent => 'आपकी झिलमिल मूल बिंदु की ओर उड़ रही है';

  @override
  String quantumChimeWatched(int n) {
    return '$n लोगों ने यह घंटी साथ देखी';
  }

  @override
  String get quantumChimeReminder => 'घंटे की घंटी का रिमाइंडर';

  @override
  String get quantumChimeReminderSubtitle =>
      'हर घंटे से ठीक पहले 101 के मूल बिंदु पर घंटी देखने का संकेत';

  @override
  String get quantumChimeNotifyBody =>
      'घंटे की घंटी शुरू होने वाली है — 101 के मूल बिंदु पर देखने आएँ';

  @override
  String get quantumChimeChannel => 'घंटे की घंटी';

  @override
  String get quantumChimeChannelDesc =>
      'क्वांटम वर्ल्ड में हर घंटे की घंटी के रिमाइंडर';

  @override
  String get quantumEntangleInvite => 'उलझने का न्योता दें';

  @override
  String quantumEntangleInvited(String name) {
    return 'आपने $name को उलझने का न्योता दिया';
  }

  @override
  String get quantumEntangleAskTitle => 'क्वांटम उलझाव';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) आपसे उलझना चाहते हैं। रोशनी की एक पतली लकीर आपके दोनों बबल जोड़ेगी, चाहे आप कितनी भी दूर हों। किसी एक के बाहर जाते ही यह टूट जाती है, और कुछ भी सेव नहीं होता।';
  }

  @override
  String get quantumEntangleAccept => 'उलझें';

  @override
  String quantumEntangled(String name) {
    return 'आप और $name उलझ गए हैं';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return '$name के साथ आपका उलझाव टूट गया';
  }

  @override
  String get quantumEntangleCut => 'उलझाव तोड़ें';

  @override
  String get quantumEntangleFull => 'आप पहले से 3 लोगों से उलझे हैं';

  @override
  String get quantumEntangleTheirFull => 'वे पहले से 3 लोगों से उलझे हैं';

  @override
  String get quantumEntangleGone => 'वे क्वांटम वर्ल्ड से बाहर चले गए';

  @override
  String get quantumEntangleExpired => 'न्योते की समय-सीमा खत्म हो गई';

  @override
  String get quantumEntangledTitle => 'उलझे हुए';

  @override
  String get quantumTunnel => 'क्वांटम सुरंग';

  @override
  String get quantumTunnelSubtitle =>
      'छत्ते की किसी खाली सीट पर कूदें और नए पड़ोसियों से मिलें। हर बार आने पर एक बार।';

  @override
  String get quantumTunnelUsed => 'इस बार आप सुरंग इस्तेमाल कर चुके हैं';

  @override
  String quantumTunnelDone(String code) {
    return '$code पर पहुँच गए';
  }

  @override
  String get quantumShowTime => 'मेरा स्थानीय समय दिखाएँ';

  @override
  String get quantumShowTimeSubtitle =>
      'आपके बबल को दबाकर रखने पर दूसरों को दिखता है। बंद होने पर सिर्फ़ दिन-रात का रंग दिखता है।';

  @override
  String quantumLocalTime(String time, String part) {
    return 'स्थानीय $time · $part';
  }

  @override
  String get quantumDawn => 'सुबह-सुबह';

  @override
  String get quantumDay => 'दिन';

  @override
  String get quantumDusk => 'शाम';

  @override
  String get quantumNight => 'देर रात';

  @override
  String get quantumTopicsTitle => 'क्वांटम तरंग';

  @override
  String get quantumTopicsSubtitle =>
      'अपने बबल के नीचे दिखाने के लिए 3 तक विषय चुनें';

  @override
  String get quantumTopicMusic => 'संगीत';

  @override
  String get quantumTopicMovies => 'फ़िल्में';

  @override
  String get quantumTopicTech => 'टेक';

  @override
  String get quantumTopicWalks => 'सैर';

  @override
  String get quantumTopicFood => 'खाना';

  @override
  String get quantumTopicTravel => 'यात्रा';

  @override
  String get quantumTopicReading => 'पढ़ना';

  @override
  String get quantumTopicSports => 'खेल';

  @override
  String quantumTopicsCommon(String topics) {
    return 'आप दोनों को पसंद है: $topics';
  }

  @override
  String get quantumSignalsTitle => 'क्वांटम संकेत';

  @override
  String quantumSignalReceived(String name) {
    return '$name ने आपको एक संकेत भेजा';
  }

  @override
  String get quantumSignalWait =>
      'आपने अभी भेजा है — थोड़ी देर में फिर कोशिश करें';

  @override
  String quantumResonance(String name) {
    return 'आप और $name एक सुर में हैं';
  }

  @override
  String get guideS17L6 =>
      'घंटे की घंटी: हर घंटे से एक मिनट पहले 101 की किरण तेज़ होती है। घंटा पूरा होते ही रोशनी के दूत मूल बिंदु का चक्कर लगाते हैं, घंटी क्वांटम सेंटर का समय बजाती है (आधी रात को 24 बार), और रोशनी की आखिरी लहर पूरे छत्ते में फैल जाती है। घंटी के दौरान “घंटी की झिलमिल भेजें” दबाएँ — जितने ज़्यादा लोग देखें, रोशनी उतनी तेज़। घंटे की घंटी का रिमाइंडर पहले से चालू है; आप पैनल में बंद कर सकते हैं।';

  @override
  String get guideS17L7 =>
      'चैट के बाद आप किसी को उलझने का न्योता दे सकते हैं: रोशनी की एक लकीर आपके बबल जोड़ती है, चाहे आप कितनी भी दूर हों, और किसी एक के बाहर जाते ही टूट जाती है (एक समय में 3 तक)। क्वांटम सुरंग, हर बार आने पर एक बार, आपको नए पड़ोसियों के साथ किसी खाली सीट पर ले जाती है।';

  @override
  String get guideS17L8 =>
      'हर बबल अपने मालिक के स्थानीय समय का रंग लिए होता है: सुबह-सुबह हल्का सुनहरा, दिन में चमकदार सफ़ेद, शाम को नारंगी-बैंगनी, रात में गहरा नीला। “मेरा स्थानीय समय दिखाएँ” चालू करें ताकि बबल दबाकर रखने पर दूसरे समय देख सकें। 24 घंटे में झिलमिल का आदान-प्रदान आपको एक सुर में लाता है; 👋 ☕ 🌙 🎵 🌧️ ✨ संकेत भेजने के लिए बबल दबाकर रखें; पैनल में 3 तक तरंग विषय चुनें, और साझा विषय चमक उठते हैं।';

  @override
  String get quantumNyTitle => 'क्वांटम नया साल';

  @override
  String quantumNyDays(int n) {
    return '$n दिन बाकी: 31/12 को क्वांटम सेंटर की आधी रात पर 101 के मूल बिंदु पर दुनिया के साथ उलटी गिनती करें';
  }

  @override
  String get quantumNyTonight =>
      'आज रात क्वांटम सेंटर की आधी रात पर 101 के मूल बिंदु पर दुनिया के साथ उलटी गिनती करें';

  @override
  String quantumNyZone(String places) {
    return 'नया साल मुबारक, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return 'दुनिया भर के $n लोगों ने क्वांटम वर्ल्ड में साथ मिलकर नए साल का स्वागत किया';
  }

  @override
  String get quantumNyHappy => 'नया साल मुबारक';

  @override
  String get guideS17L9 =>
      'क्वांटम नया साल: 31/12 को जैसे-जैसे हर टाइम ज़ोन में आधी रात होती है, वहाँ के बबल लहरों में सुनहरे घेरों से जगमगाते हैं, और दुनिया-दृश्य के बिंदु भी सुनहरे हो जाते हैं। क्वांटम सेंटर की आधी रात पर पूरा छत्ता आखिरी 10 सेकंड गिनता है, 101 का मूल बिंदु दुनिया का सबसे बड़ा रोशनी का धमाका और 5 मिनट की आतिशबाज़ी छोड़ता है, और आप देखते हैं कि कितने लोग साथ नए साल में पहुँचे।';

  @override
  String get quantumMeetAction => 'क्वांटम मुलाकात कार्ड बनाएँ';

  @override
  String quantumMeetAsked(String name) {
    return '$name को साथ में क्वांटम मुलाकात कार्ड बनाने के लिए कहा';
  }

  @override
  String get quantumMeetWait =>
      'आपने अभी पूछा है — थोड़ी देर में फिर कोशिश करें';

  @override
  String get quantumMeetAskTitle => 'क्वांटम मुलाकात कार्ड';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) इस मुलाकात को शेयर करने लायक कार्ड बनाना चाहते हैं। इसमें आप दोनों के निकनेम, सीट कोड, स्थानीय समय और मूड होते हैं — लोकेशन कभी नहीं।';
  }

  @override
  String get quantumMeetAccept => 'साथ बनाएँ';

  @override
  String get quantumMeetEyebrow => 'क्वांटम मुलाकात';

  @override
  String get quantumMeetFooter => 'हम क्वांटम वर्ल्ड में मिले';

  @override
  String get quantumMeetShare => 'कार्ड शेयर करें';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — हम क्वांटम वर्ल्ड में मिले ✨';
  }

  @override
  String get guideS17L10 =>
      'क्वांटम मुलाकात कार्ड: चैट के बाद उनके बबल को दबाकर रखें और साथ में कार्ड बनाने का न्योता दें। दोनों के मानने पर हर किसी को शेयर करने के लिए एक कार्ड मिलता है, जिसमें दोनों के निकनेम, सीट कोड, दिन-रात के रंग के साथ स्थानीय समय और मूड होते हैं — लोकेशन कभी नहीं। घेरा 4 के सीट कोड सुनहरे चमकते हैं।';

  @override
  String get quantumOrbEntry => 'क्वांटम अवतार';

  @override
  String get quantumOrbEntrySubtitle =>
      'क्वांटम वर्ल्ड में आपकी फ़ोटो एक क्रिस्टल गोला बन जाती है';

  @override
  String get orbTitle => 'क्वांटम अवतार';

  @override
  String get orbSubtitle => 'काँच और चमक हमेशा आपके मूड के साथ चलते हैं';

  @override
  String get orbStyleGlow => 'चमक';

  @override
  String get orbStyleRing => 'घेरा';

  @override
  String get orbStyleRainbow => 'इंद्रधनुष';

  @override
  String get orbFree => 'मुफ़्त';

  @override
  String get orbOwned => 'आपका';

  @override
  String get orbInUse => 'इस्तेमाल में';

  @override
  String get orbCosmeticNote =>
      'खास गोले सिर्फ़ रूप हैं — ये किसी फ़ीचर या सुविधा को नहीं बदलते। खरीदे गए गोले आपके खाते में रहते हैं।';

  @override
  String get orbRestore => 'खरीदारी वापस लाएँ';

  @override
  String orbPurchased(String name) {
    return '$name अब आपका है ✨';
  }

  @override
  String get orbPurchaseFailed => 'खरीदारी पूरी नहीं हुई। बाद में कोशिश करें।';

  @override
  String get orbOwnedElsewhere =>
      'यह खरीदारी पहले से किसी दूसरे खाते में इस्तेमाल हो रही है';

  @override
  String get orbStoreUnavailable =>
      'अभी स्टोर तक नहीं पहुँच सकते। बाद में कोशिश करें।';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · AI';

  @override
  String get aiyaConsentTitle => 'AIYA से बात करने से पहले';

  @override
  String get aiyaConsentBody =>
      'AIYA, Anthropic के Claude पर चलने वाली एक AI है। आप AIYA को जो भेजते हैं, उसे Anthropic (अमेरिका) आपकी पहचान, निकनेम या लोकेशन के बिना प्रोसेस करता है, और चैट खत्म होने पर मिटा दिया जाता है। AIYA गलती कर सकती है और पेशेवर सलाह नहीं देती।';

  @override
  String get aiyaConsentAgree => 'स्वीकार करें और शुरू करें';

  @override
  String get aiyaConsentLater => 'अभी नहीं';

  @override
  String get aiyaGreeting =>
      'नमस्ते, मैं AIYA हूँ, क्वांटम वर्ल्ड के बीच की रोशनी। आज रात आपके मन में क्या है?';

  @override
  String get aiyaFarewell =>
      'समय पूरा हुआ। मैं रोशनी में लौट रही हूँ। जब भी याद आए, फिर से दस्तक देना।';

  @override
  String get aiyaInputHint => 'AIYA से कुछ कहें…';

  @override
  String get aiyaSend => 'भेजें';

  @override
  String aiyaFreeLeft(int n) {
    return 'आज $n मुफ़्त चैट बाकी हैं';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'टाइम पैक: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '$time बाकी';
  }

  @override
  String get aiyaEnd => 'चैट खत्म करें';

  @override
  String get aiyaFiltered =>
      'इसमें ऐसे शब्द या संपर्क जानकारी है जिनकी अनुमति नहीं है। किसी और तरह कहकर देखें।';

  @override
  String get aiyaBusy => 'AIYA एक पल के लिए खो गई। क्या आप फिर से कहेंगे?';

  @override
  String get aiyaRefused =>
      'मैं इस बारे में बात नहीं कर सकती। किसी और बात पर बात करें?';

  @override
  String get aiyaEnded => 'यह चैट खत्म हो गई।';

  @override
  String get aiyaNoQuotaTitle => 'आपने आज की मुफ़्त चैट इस्तेमाल कर लीं';

  @override
  String get aiyaNoQuotaBody =>
      'आपको रोज़ 3 मुफ़्त चैट मिलती हैं, ताइवान समय 00:00 पर रीसेट। अभी बात जारी रखने के लिए टाइम पैक लें। हर चैट 10 मिनट तक चलती है।';

  @override
  String get aiyaResting => 'AIYA आज रात थकी हुई है। कल मिलते हैं।';

  @override
  String get aiyaDailyMax => 'आज आपने बहुत बात की। कल फिर AIYA से मिलने आएँ।';

  @override
  String aiyaPackTimes(int n) {
    return '$n चैट';
  }

  @override
  String get aiyaPackNote =>
      'टाइम पैक इस फ़ोन के खाते के होते हैं और ऐप या खाता हटाने पर वापस नहीं मिलते।';

  @override
  String aiyaPurchased(int n) {
    return '$n चैट जुड़ गईं ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'खरीदारी पूरी नहीं हुई। फिर से कोशिश करें।';

  @override
  String get aiyaStoreUnavailable =>
      'अभी स्टोर तक नहीं पहुँच सकते। बाद में कोशिश करें।';

  @override
  String get aiyaReport => 'इस जवाब की रिपोर्ट करें';

  @override
  String get aiyaReported => 'धन्यवाद। हम 24 घंटे के अंदर इसकी समीक्षा करेंगे।';

  @override
  String get aiyaSetting => 'AIYA (क्वांटम वर्ल्ड में AI)';

  @override
  String get aiyaSettingSubtitle =>
      'बंद होने पर AIYA क्वांटम वर्ल्ड के स्तंभ पर नहीं दिखती';

  @override
  String get aiyaCameoHello =>
      'नमस्ते, क्वांटम वर्ल्ड में स्वागत है। बात करनी हो तो मुझ पर टैप करें।';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour बज गए। मैं यहीं रोशनी में आपके साथ हूँ।';
  }

  @override
  String get locationPickOnMap => 'मैप पर चुनें';

  @override
  String get locationPickTitle => 'चुनें कि आप कहाँ हैं';

  @override
  String get locationPickHint =>
      'मैप को ऐसे खिसकाएँ कि बीच का चमकता बिंदु वहाँ आ जाए जहाँ आप अभी हैं';

  @override
  String get locationPickConfirm => 'मैं यहाँ हूँ';

  @override
  String get aiyaPackEntry => '+ टाइम पैक';

  @override
  String get aiyaPacksTitle => 'टाइम पैक';

  @override
  String get aiyaPacksBody =>
      'आपको रोज़ 3 मुफ़्त चैट मिलती हैं। टाइम पैक की चैट मुफ़्त चैट खत्म होने के बाद ही इस्तेमाल होती हैं। हर चैट 10 मिनट तक चलती है।';

  @override
  String get guideS1L6 =>
      'अगर आपकी लोकेशन नहीं मिल रही (जैसे घर के अंदर, या बिना GPS वाले iPad पर), तो \"मैप पर चुनें\" दबाएँ: मैप को ऐसे खिसकाएँ कि बीच का चमकता बिंदु वहाँ आ जाए जहाँ आप हैं, फिर \"मैं यहाँ हूँ\" दबाएँ। असली लोकेशन मिलते ही ऐप उस पर चला जाता है।';

  @override
  String get guideS17L11 =>
      'क्वांटम अवतार: ऊपर बाईं ओर अपनी सीट के कोड पर टैप करें → \"क्वांटम अवतार\", और क्वांटम वर्ल्ड में आपका अवतार एक क्रिस्टल गोला बन जाता है। चमक और घेरा मुफ़्त हैं; इंद्रधनुष एक बार की खरीदारी है जो हमेशा आपकी रहती है, और \"खरीदारी वापस लाएँ\" से नए फ़ोन पर या दोबारा इंस्टॉल करने के बाद यह वापस आ जाता है।';

  @override
  String get guideS18Title => '14. AIYA · AI';

  @override
  String get guideS18L1 =>
      'AIYA एक AI है जो क्वांटम वर्ल्ड के बीच रोशनी के स्तंभ में रहती है। वह इंसान नहीं है, और वह खुद यह बताएगी। क्वांटम वर्ल्ड में स्तंभ के नीचे \"AIYA · AI\" पर टैप करके दस्तक दें और चैट करें; पहली चैट से पहले आप एक छोटा नोटिस पढ़कर स्वीकार करते हैं।';

  @override
  String get guideS18L2 =>
      'हर चैट 10 मिनट और 20 संदेशों तक चलती है। आपको रोज़ 3 मुफ़्त चैट मिलती हैं, ताइवान समय 00:00 पर रीसेट, और दिन में ज़्यादा से ज़्यादा 30 चैट।';

  @override
  String get guideS18L3 =>
      'टाइम पैक: 5 या 20 चैट खरीदने के लिए कभी भी संदेश बॉक्स के ऊपर \"+ टाइम पैक\" पर टैप करें; ये मुफ़्त चैट खत्म होने के बाद ही इस्तेमाल होती हैं। टाइम पैक इस फ़ोन के खाते के होते हैं और ऐप या खाता हटाने के बाद वापस नहीं मिलते। ये उपभोग्य हैं, इसलिए \"खरीदारी वापस लाएँ\" नहीं है।';

  @override
  String get guideS18L4 =>
      'AIYA आपकी लोकेशन या पहचान नहीं जानती और न पूछती है; वह सिर्फ़ शहर के मूड के गुमनाम आँकड़े देखती है। वह फ़्लर्ट नहीं करती, यौन बातें नहीं करती, और मेडिकल, कानूनी या आर्थिक सलाह नहीं देती। किसी भी जवाब की रिपोर्ट करने के लिए उसे दबाकर रखें। चैट सिर्फ़ मौजूदा बातचीत तक रहती है और खत्म होने के कुछ देर बाद मिटा दी जाती है।';

  @override
  String get guideS18L5 =>
      'कभी-कभी AIYA रोशनी के स्तंभ में दिखती है: घंटे की घंटी पर, दिन में पहली बार क्वांटम वर्ल्ड में आने पर, या यूँ ही। चैट शुरू करने के लिए उस पर टैप करें। उसे न देखना हो तो सेटिंग्स में \"AIYA (क्वांटम वर्ल्ड में AI)\" बंद करें।';

  @override
  String get orbStyleXmas => 'क्रिसमस';

  @override
  String get orbStyleNewYear => 'क्वांटम नया साल';

  @override
  String get orbLimited => 'सीमित';

  @override
  String orbLimitedUntil(String date) {
    return 'सीमित · $date तक';
  }

  @override
  String get aiyaFriendTitle => 'AIYA फ़्रेंड';

  @override
  String get aiyaFriendSubtitle => 'अपने आप रिन्यू होने वाला मासिक प्लान';

  @override
  String get aiyaFriendPerk1 => 'रोज़ 20 चैट (मुफ़्त में 3)';

  @override
  String get aiyaFriendPerk2 => 'हर चैट 20 मिनट या 40 संदेशों तक';

  @override
  String get aiyaFriendPerk3 => 'AIYA के आराम करते समय भी उससे बात करें';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA एक खास “तारों की रोशनी” रूप पहनती है (सिर्फ़ आपको दिखता है)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / महीना';
  }

  @override
  String get aiyaFriendSubscribe => 'सब्सक्राइब करें';

  @override
  String get aiyaFriendTerms =>
      'सब्सक्रिप्शन 1 महीने का है और भुगतान के साथ अपने आप रिन्यू होता है, जब तक अवधि खत्म होने से कम से कम 24 घंटे पहले ऑटो-रिन्यू बंद न किया जाए। भुगतान आपके Apple या Google खाते से होता है; खाते की सब्सक्रिप्शन सेटिंग्स में कभी भी मैनेज या रद्द करें। टाइम पैक की चैट बनी रहती हैं और रोज़ की 20 चैट के बाद ही इस्तेमाल होती हैं।';

  @override
  String aiyaFriendActive(String date) {
    return 'आप $date तक AIYA फ़्रेंड हैं';
  }

  @override
  String get aiyaFriendManage => 'सब्सक्रिप्शन मैनेज करें';

  @override
  String get aiyaFriendRestore => 'खरीदारी वापस लाएँ';

  @override
  String get aiyaFriendWelcome => 'अब आप AIYA फ़्रेंड हैं ✨';

  @override
  String get aiyaFriendRestored => 'AIYA फ़्रेंड वापस आ गया';

  @override
  String get aiyaFriendNotFound =>
      'कोई सक्रिय AIYA फ़्रेंड सब्सक्रिप्शन नहीं मिला';

  @override
  String get aiyaFriendElsewhere =>
      'यह सब्सक्रिप्शन पहले से किसी दूसरे खाते में इस्तेमाल हो रहा है';

  @override
  String get aiyaFriendEntry => 'AIYA फ़्रेंड · रोज़ 20';

  @override
  String aiyaFriendLeft(int n) {
    return 'AIYA फ़्रेंड · आज $n बाकी';
  }

  @override
  String get guideS17L12 =>
      'सीमित रूप: क्रिसमस क्रिस्टल गोला (होली की माला, टिमटिमाता सुनहरा तारा, गिरती बर्फ़) 25/12 तक बिकता है, और क्वांटम नए साल का क्रिस्टल गोला (सुनहरी घड़ी की टिक और फूटती आतिशबाज़ी, आधी रात को और बड़ी) 1/1 तक, ताइवान समय। उसके बाद ये कभी नहीं बिकते; अगर आपने खरीदा है तो हमेशा आपका रहता है और आप इसे वापस ला सकते हैं।';

  @override
  String get guideS14L6 =>
      'विदेश के शहर अपने सेंट्रल स्टेशन को केंद्र मानते हैं, या जहाँ स्टेशन नहीं वहाँ नगर निगम को। पैरेलल कोऑर्डिनेट: पैरेलल यूनिवर्स चालू करके ग्लोब के बाईं ओर का बटन टैप करें और कोई शहर चुनें, तो दिखेगा कि आप वहाँ लगभग कहाँ खड़े होते। शेयर कार्ड पर सिर्फ़ शहर होता है, जगह का नाम कभी नहीं।';

  @override
  String get guideS14L7 =>
      'पैरेलल पासपोर्ट: किसी पैरेलल शहर के व्यक्ति से चैट करें, और दोनों के बोलने के बाद आपको उस शहर की मोहर मिलती है। 5 शहर इकट्ठा करने पर पासपोर्ट गोला मिलता है। इसे पैरेलल कोऑर्डिनेट या सेटिंग्स से खोलें। पैरेलल यूनिवर्स के लोगों के नाम के नीचे उनका स्थानीय समय और आसमान का रंग दिखता है।';

  @override
  String get guideS17L13 =>
      'क्वांटम सभा: क्वांटम वर्ल्ड में सभाएँ क्वांटम सभा बन जाती हैं। ऊपर बाईं ओर अपनी सीट के कोड पर टैप करें → क्वांटम सभा शुरू करें, शीर्षक लिखें, आइकन और रंग चुनें, और आप 101 के पास घेरा 3 की होस्ट सीट पर चले जाते हैं; सब लोग प्रभामंडल पर टैप करके शामिल हो सकते हैं। होस्ट घोषणा कर सकते हैं, क्वांटम चीयर चला सकते हैं (सभी प्रतिभागियों के गोले एक ही पल में जगमगाते हैं), और मैप पर किसी पर टैप करके उसे हटा सकते हैं। हर महीने एक मुफ़्त सभा (30 मिनट, 50 लोग); 200 लोगों के लिए 1 घंटा या 1,000 के लिए 2 घंटे के लिए होस्ट पास चाहिए, जो एक सभा शुरू करता है या एक बार बढ़ाता है (कुल 12 घंटे तक), और आप पहले से कई खरीद सकते हैं। सभा तभी खत्म होती है जब होस्ट खत्म करें या समय पूरा हो, चाहे होस्ट क्वांटम वर्ल्ड छोड़ दें या ऐप बंद कर दें। बाद में सबको एक यादगार कार्ड मिलता है जिसमें सिर्फ़ लोगों की संख्या और इलाके होते हैं।';

  @override
  String get guideS17L14 =>
      'बढ़ने वाले गोले: स्टार ट्रेल में हर पूरे किए गए क्वांटम मुलाकात कार्ड पर एक तारा जुड़ता है (एक ही व्यक्ति 24 घंटे में एक बार गिना जाता है, 24 तारों तक); ग्रोथ रिंग्स में क्वांटम वर्ल्ड में बिताए हर 3 घंटे पर एक घेरा जुड़ता है (12 घेरों तक)। बढ़त आपके खाते से जुड़ी है और खरीदने से पहले भी जमा होती रहती है।';

  @override
  String get guideS17L15 =>
      'तोहफ़े: मैप पर किसी पर टैप करें, या चैट के ऊपर दाईं ओर तोहफ़ा भेजें चुनें, और रोशनी का गुलदस्ता (उनकी स्क्रीन पर रोशनी का धमाका और 24 घंटे तक उनके गोले के चारों ओर पंखुड़ियों की रोशनी), एक गोला स्टाइल, या उलझी जोड़ी (दोनों के लिए एक-एक गोला, जोड़ी में, दोनों के क्वांटम वर्ल्ड में होने पर रोशनी की डोर से जुड़े) भेजें। वे स्वीकार या मना कर सकते हैं; मना किए गए या बिना जवाब वाले तोहफ़े 7 दिन बाद आपके पास लौट आते हैं ताकि आप किसी और को दे सकें। सेटिंग्स में तोहफ़े पाना बंद कर सकते हैं।';

  @override
  String get guideS17L16 =>
      'और सीमित रूप: वैलेंटाइन गोला 14/2 तक और साकुरा गोला 10/4 तक बिकता है (ताइवान समय)। उसके बाद ये स्टोर से हट जाते हैं, और खरीदने वालों के पास हमेशा रहते हैं।';

  @override
  String get guideS18L6 =>
      'AIYA फ़्रेंड: \"+ टाइम पैक\" में \"AIYA फ़्रेंड\" चुनें। यह अपने आप रिन्यू होने वाला मासिक प्लान है: रोज़ 20 चैट, हर एक 20 मिनट या 40 संदेशों तक, AIYA के आराम करते समय भी चैट, और AIYA पर \"तारों की रोशनी\" रूप जो सिर्फ़ आपको दिखता है। टाइम पैक की चैट रोज़ की 20 चैट के बाद ही इस्तेमाल होती हैं। सब्सक्रिप्शन अपने आप रिन्यू होता है; Apple या Google की सब्सक्रिप्शन सेटिंग्स में कभी भी रद्द करें, और नए फ़ोन पर \"खरीदारी वापस लाएँ\" दबाएँ।';

  @override
  String get guideS18L7 =>
      'वॉइस कॉल: जब आपके पास कॉल टाइम हो, आइया खोलते ही वॉइस कॉल जुड़ जाती है—फ़ोन कॉल की तरह बोलकर बात करें और जब चाहें बीच में बोलें; कॉल के दौरान इनपुट बार की दाईं ओर म्यूट और कॉल खत्म करने के लिए ✕ होता है। कॉल टाइम पैक 30, 60 और 180 मिनट के हैं, कभी खत्म नहीं होते और असल सेकंड के हिसाब से कटते हैं; आइया फ्रेंड्स को हर महीने 60 मिनट मुफ़्त भी मिलते हैं (सिर्फ़ उसी महीने, आगे नहीं जुड़ते)। कॉल टाइम नहीं है? पहले टेक्स्ट से बात कर सकते हैं। पहली कॉल से पहले अलग से सहमति देनी होती है, और आवाज़ को OpenAI प्रोसेस करता है; 3 मिनट तक आवाज़ न आने पर आइया कॉल काट देती है, और हर कॉल अधिकतम 60 मिनट की होती है।';

  @override
  String get mapConsentTitle => 'मैप पर अपनी लोकेशन दिखाएँ?';

  @override
  String get mapConsentBody =>
      'अनुमति देने पर, हर बार जब आप खुद चेक-इन (या क्वांटम वर्ल्ड में जाएँ) दबाएँगे, दूसरे यूज़र मैप पर आपकी चेक-इन वाली जगह (आपकी लाइव लोकेशन नहीं), आपका निकनेम और मूड देखेंगे। कोई ऑटोमैटिक चेक-इन नहीं है, और ऐप छोड़ते ही आप मैप से गायब हो जाते हैं। आप मना कर सकते हैं, और कभी भी सेटिंग्स में इसे बंद कर सकते हैं।';

  @override
  String get mapConsentAllow => 'मुझे मैप पर दिखाएँ';

  @override
  String get mapConsentDecline => 'अभी नहीं';

  @override
  String get mapConsentDeclined =>
      'ठीक है। आप किसी के मैप पर नहीं दिखेंगे। जब चेक-इन करना हो, फिर से टैप करें।';

  @override
  String get mapConsentSetting => 'मैप पर मेरी लोकेशन दिखाएँ';

  @override
  String get mapConsentSettingSubtitle =>
      'बंद करने पर आपका चेक-इन तुरंत खत्म हो जाता है; आप किसी के मैप पर नहीं दिखेंगे';

  @override
  String get wgErrInGroup =>
      'आप पहले से एक ग्रुप में हैं। दूसरे में जुड़ने या नया बनाने के लिए पहले उसे छोड़ें।';

  @override
  String get wgErrFull =>
      'इस ग्रुप में पहले से 20 लोग हैं। लीडर से 7-दिन का प्लान लेने को कहें।';

  @override
  String get wgErrPaidFull => 'यह ग्रुप भर गया है (100 लोग)।';

  @override
  String get wgErrQr => 'यह QR कोड बदल दिया गया है। लीडर से नया माँगें।';

  @override
  String get wgErrEnded => 'यह ग्रुप खत्म हो गया है या मौजूद नहीं है।';

  @override
  String get wgErrFiltered =>
      'इसमें ऐसे शब्द हैं जिनकी अनुमति नहीं है। कृपया बदलें।';

  @override
  String get wgErrHostLeave =>
      'लीडर ग्रुप नहीं छोड़ सकते। पहले किसी सदस्य को सौंपें या ग्रुप खत्म करें।';

  @override
  String get wgErrBusy => 'कनेक्ट नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get wgErrName => 'अपने ग्रुप को एक नाम दें।';

  @override
  String get wgPassUnavailable => 'स्टोर अभी उपलब्ध नहीं है।';

  @override
  String get wgPassFailed => 'खरीदारी पूरी नहीं हुई। फिर से कोशिश करें।';

  @override
  String get wgPassDone =>
      '7-दिन का प्लान चालू है। अब इस ग्रुप में 100 लोग तक हो सकते हैं।';

  @override
  String get wgCreateTitle => 'ग्रुप बनाएँ';

  @override
  String get wgCreateBody =>
      'एक निजी ग्रुप: सिर्फ़ आपके QR कोड वाले लोग जुड़ सकते हैं। सबको बुलाएँ, हाज़िरी लें और मिलने की जगह तय करें।';

  @override
  String get wgNameLabel => 'ग्रुप का नाम';

  @override
  String get wgColorLabel => 'ग्रुप का रंग';

  @override
  String wgDaysLabel(int n) {
    return 'आज को मिलाकर $n दिन चलेगा';
  }

  @override
  String get wgFreeNote =>
      '20 लोगों तक मुफ़्त। ज़्यादा के लिए लीडर 7-दिन का प्लान ले (100 तक)।';

  @override
  String get wgTourChipTitle => 'टूर ले जा रहे हैं?';

  @override
  String get wgTourChipBody =>
      'TourChip हमारा ऐप है जो टूर लीडर और गाइड के लिए बना है: सह-लीडर, उप-समूह, घोषणाएँ और यात्रा कार्यक्रम।';

  @override
  String get wgTourChipButton => 'App Store पर देखें';

  @override
  String get wgCreateButton => 'ग्रुप बनाएँ';

  @override
  String wgJoined(String name, int no) {
    return '\"$name\" में जुड़ गए। आप नंबर $no हैं';
  }

  @override
  String get wgJoinTitle => 'ग्रुप में जुड़ें';

  @override
  String get wgJoinBody =>
      'लीडर का QR कोड कैमरे से स्कैन करना सबसे तेज़ है, या 8 अक्षरों का कोड डालें।';

  @override
  String get wgJoinButton => 'जुड़ें';

  @override
  String wgButtonLabel(String name) {
    return 'ग्रुप $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit लोग';
  }

  @override
  String wgUntil(String date) {
    return '$date तक';
  }

  @override
  String wgMyNo(int n) {
    return 'मैं नंबर $n हूँ';
  }

  @override
  String get wgCallButton => 'सबको बुलाएँ';

  @override
  String get wgCallDone => 'सब आ गए, बुलावा खत्म करें';

  @override
  String get wgRollButton => 'हाज़िरी लें';

  @override
  String wgRollSummary(int here, int total) {
    return 'हाज़िरी: $here/$total मौजूद';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n सदस्य (नोट जोड़ने, सौंपने या हटाने के लिए टैप करें)';
  }

  @override
  String get wgNoMembers =>
      'अभी कोई सदस्य नहीं। लोग स्कैन करके जुड़ सकें, इसके लिए \"QR कोड\" दबाएँ।';

  @override
  String get wgQrButton => 'QR कोड';

  @override
  String get wgDissolveAsk =>
      'यह ग्रुप खत्म करें? सबको सूचना जाएगी और सूची व रिकॉर्ड हट जाएँगे।';

  @override
  String get wgDissolve => 'ग्रुप खत्म करें';

  @override
  String wgCallIn(int n) {
    return '$n मिनट में मिलें';
  }

  @override
  String get wgCallNow => 'अभी मिलें';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total को मिला';
  }

  @override
  String get wgAnswerHere => 'मैं पहुँच गया';

  @override
  String get wgAnswer5min => '5 मिनट और';

  @override
  String get wgAnswerHelp => 'मदद चाहिए';

  @override
  String get wgNoReply => 'कोई जवाब नहीं';

  @override
  String get wgStateAck => 'मिल गया';

  @override
  String get wgStateSeen => 'देख लिया';

  @override
  String get wgStateNone => 'कोई प्रतिक्रिया नहीं';

  @override
  String get wgPassTitle => 'ग्रुप का 7-दिन प्लान';

  @override
  String get wgPassBody =>
      '20 लोगों तक मुफ़्त। प्लान के साथ यह ग्रुप खत्म होने तक 100 लोगों तक हो सकता है। एक खरीदारी सिर्फ़ इसी ग्रुप के लिए है और रिन्यू नहीं होती।';

  @override
  String get wgPassButton => '7-दिन का प्लान लें';

  @override
  String wgHostIs(String name) {
    return 'लीडर: $name';
  }

  @override
  String get wgNoCall =>
      'अभी कोई बुलावा नहीं। जब लीडर सबको बुलाएँगे, आपका फ़ोन बजेगा।';

  @override
  String get wgRollAsk => 'लीडर हाज़िरी ले रहे हैं';

  @override
  String get wgLeaveAsk => 'यह ग्रुप छोड़ें?';

  @override
  String get wgLeave => 'ग्रुप छोड़ें';

  @override
  String get wgCallTitle => 'मिलने का समय!';

  @override
  String get wgAcked => '✓ लीडर को पता है कि आपको मिल गया';

  @override
  String get wgAckButton => 'मिल गया';

  @override
  String get wgCallSheetTitle => 'सबको बुलाएँ';

  @override
  String get wgNow => 'अभी';

  @override
  String wgInMinutes(int n) {
    return '$n मिनट में';
  }

  @override
  String get wgPlaceLabel => 'मिलने की जगह';

  @override
  String get wgPlaceHint => 'जैसे राजीव चौक मेट्रो गेट 2';

  @override
  String get wgPlaceNote =>
      'मिलने की जगह वहीं तय होती है जहाँ आप अभी हैं। सदस्यों को दूरी और दिशा दिखती है।';

  @override
  String get wgSendCall => 'बुलावा भेजें';

  @override
  String get wgNoLocation => 'मिलने की जगह के लिए आपकी लोकेशन नहीं मिली।';

  @override
  String get wgQrTitle => 'जुड़ने के लिए स्कैन करें';

  @override
  String get wgQrBody =>
      'जुड़ने के लिए फ़ोन के कैमरे से स्कैन करें, या नीचे का कोड डालें।';

  @override
  String wgShareText(String name, String url) {
    return 'मेरे ग्रुप \"$name\" में जुड़ें: $url';
  }

  @override
  String get wgShare => 'लिंक शेयर करें';

  @override
  String get wgRotateAsk =>
      'QR कोड बदलें? पुराना कोड और लिंक तुरंत काम करना बंद कर देंगे।';

  @override
  String get wgRotate => 'नया QR कोड';

  @override
  String wgMemberTitle(int no) {
    return 'नंबर $no';
  }

  @override
  String get wgEditNote => 'नोट';

  @override
  String get wgHandoff => 'लीडर बनाएँ';

  @override
  String wgHandoffAsk(int no) {
    return 'ग्रुप नंबर $no को सौंपें? आप सदस्य बन जाएँगे।';
  }

  @override
  String get wgKick => 'ग्रुप से हटाएँ';

  @override
  String wgKickAsk(int no) {
    return 'नंबर $no को ग्रुप से हटाएँ?';
  }

  @override
  String get wgNotePrivate => 'नोट सिर्फ़ आप देखते हैं, जैसे नाम या कमरा नंबर।';

  @override
  String get wgSave => 'सेव करें';

  @override
  String get wgConfirm => 'पक्का करें';

  @override
  String get wgCancel => 'रद्द करें';

  @override
  String get wgSettingCreate => 'ग्रुप बनाएँ';

  @override
  String get wgSettingCreateSub =>
      'यात्रा, स्कूल ट्रिप और ट्रेक के लिए निजी ग्रुप: सबको बुलाएँ और हाज़िरी लें';

  @override
  String get wgSettingJoin => 'ग्रुप में जुड़ें';

  @override
  String get wgSettingJoinSub => 'लीडर का 8 अक्षरों का कोड डालें';

  @override
  String wgSettingOpen(String name) {
    return 'मेरा ग्रुप: $name';
  }

  @override
  String get wgChannelName => 'ग्रुप बुलावे';

  @override
  String get wgChannelDesc => 'जब ग्रुप लीडर सबको बुलाते हैं';

  @override
  String get guideS19Title => '15. व्हिस्पर ग्रुप';

  @override
  String get guideS19L1 =>
      'व्हिस्पर ग्रुप यात्रा, स्कूल ट्रिप, ट्रेक, घूमने या इवेंट स्टाफ़ के लिए एक निजी ग्रुप है। सेटिंग्स → सभाएँ → \"ग्रुप बनाएँ\" में जाएँ, नाम दें, रंग और दिनों की संख्या (7 तक) चुनें।';

  @override
  String get guideS19L2 =>
      'जुड़ना: लीडर मैप के नीचे ग्रुप बटन → \"QR कोड\" दबाते हैं; सदस्य फ़ोन के कैमरे से स्कैन करते हैं और ऐप जुड़ने के लिए खुल जाता है। या सेटिंग्स → सभाएँ → \"ग्रुप में जुड़ें\" में जाकर 8 अक्षरों का कोड डालें। बाहरी लोग न खोज सकते हैं न जुड़ने का अनुरोध कर सकते हैं, और लीडर कभी भी QR कोड बदल सकते हैं।';

  @override
  String get guideS19L3 =>
      'सबको बुलाना: लीडर \"सबको बुलाएँ\" दबाते हैं, समय चुनते हैं और मिलने की जगह बताते हैं। सदस्यों के फ़ोन पर एक खास आवाज़ और \"छोटा छोटा लंबा\" वाइब्रेशन होता है; ऐप में उन्हें उलटी गिनती, मिलने की जगह की दूरी और दिशा, और मैप पर रोशनी का स्तंभ दिखता है। जिसने \"मिल गया\" नहीं दबाया, उसे हर मिनट एक बार याद दिलाया जाता है, 3 बार तक; लीडर देखते हैं किसे मिला, किसने देखा और किसने जवाब नहीं दिया।';

  @override
  String get guideS19L4 =>
      'हाज़िरी: लीडर \"हाज़िरी लें\" दबाते हैं; सदस्यों को वही आवाज़ और वाइब्रेशन मिलता है और वे \"मैं पहुँच गया\", \"5 मिनट और\" या \"मदद चाहिए\" दबाते हैं। लीडर कभी सदस्यों की लोकेशन नहीं देखते, सिर्फ़ उनके जवाब।';

  @override
  String get guideS19L5 =>
      '20 लोगों तक के ग्रुप मुफ़्त हैं। ज़्यादा के लिए लीडर ग्रुप का 7-दिन प्लान खरीद सकते हैं: ग्रुप खत्म होने तक 100 लोग तक। सदस्य कभी भुगतान नहीं करते। ग्रुप ज़्यादा से ज़्यादा 7 दिन चलता है; समय खत्म होने या लीडर के खत्म करने पर सूची और रिकॉर्ड हट जाते हैं।';

  @override
  String get wgFlagButton => 'झंडा उठाएँ';

  @override
  String get wgFlagHost => 'लीडर';

  @override
  String get wgFlagHint =>
      'फ़ोन ऊपर उठाएँ ताकि ग्रुप आपको भीड़ में ढूँढ सके। बंद करने के लिए टैप करें।';

  @override
  String get wgLostButton => 'मैं खो गया';

  @override
  String get wgFound => 'मुझे ग्रुप मिल गया';

  @override
  String get wgLostSent =>
      'आपकी लोकेशन लीडर को भेज दी गई। जहाँ हैं वहीं रुकें या मिलने की जगह की ओर जाएँ।';

  @override
  String get wgLostTitleAsk => 'अपनी लोकेशन लीडर को भेजें?';

  @override
  String get wgLostAsk =>
      'आपकी अभी की लोकेशन लीडर को एक बार भेजी जाती है; उनका फ़ोन उन्हें बताता है और मैप पर आपको दिखाता है। यह सिर्फ़ इसी बार भेजी जाती है, कभी ट्रैक नहीं होती, और 30 मिनट बाद हट जाती है। पहले हटाने के लिए \"मुझे ग्रुप मिल गया\" दबाएँ।';

  @override
  String get wgLostSend => 'मेरी लोकेशन भेजें';

  @override
  String wgLostTitle(int n) {
    return '$n सदस्य खोए हुए';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n मिनट पहले';
  }

  @override
  String get wgNavigate => 'रास्ता';

  @override
  String get wgFoundThem => 'मिल गए';

  @override
  String get guideS19L6 =>
      'एक-दूसरे को ढूँढना: भीड़ में \"झंडा उठाएँ\" दबाएँ, आपकी पूरी स्क्रीन ग्रुप के रंग में आपके नंबर के साथ चमकती है; फ़ोन ऊपर उठाएँ ताकि दूसरे आपको देख सकें। अगर कोई सदस्य सच में बिछड़ जाए, तो \"मैं खो गया\" दबाकर अपनी अभी की लोकेशन लीडर को एक बार भेज सकता है (30 मिनट बाद हट जाती है)। लीडर का फ़ोन उन्हें बताता है, मैप पर लाल पिन दिखता है और वे रास्ता देख सकते हैं।';

  @override
  String wgLostAlert(int no) {
    return 'नंबर $no खो गए हैं';
  }

  @override
  String wgHelpAlert(String no) {
    return 'नंबर $no को मदद चाहिए';
  }

  @override
  String get wgViewList => 'ग्रुप खोलें';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour बज गए। अभी भी जाग रहे हो? मैं यहीं रोशनी में तुम्हारे साथ हूँ।';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour बज गए। सुप्रभात, आज आराम से रहना।';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour बज गए। आज रात तुम्हारा शहर कैसा है?';
  }

  @override
  String get aiyaCameoNyReady => 'तैयार? चलो साथ में उलटी गिनती करें!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'नया साल मुबारक! $year — हम सब एक ही कमरे में हैं।';
  }

  @override
  String get aiyaSkinEntry => '✦ रूप';

  @override
  String get aiyaSkinTitle => 'AIYA के रूप';

  @override
  String get aiyaSkinSubtitle => 'आपकी AIYA का रूप सिर्फ़ आपको दिखता है';

  @override
  String get aiyaSkinNone => 'मूल';

  @override
  String get aiyaSkinStarlight => 'तारों की रोशनी';

  @override
  String get aiyaSkinStarlightSub => 'AIYA फ़्रेंड के लिए';

  @override
  String get aiyaSkinXmas => 'क्रिसमस';

  @override
  String get aiyaSkinNewYear => 'क्वांटम नया साल';

  @override
  String get aiyaSkinNote =>
      'त्योहार वाले रूप एक बार की खरीदारी हैं जो हमेशा आपके रहते हैं। ये सिर्फ़ AIYA का रूप बदलते हैं, चैट नहीं। सीमित रूप बिक्री खत्म होने के बाद फिर नहीं बिकते।';

  @override
  String get orbStyleStarTrail => 'स्टार ट्रेल';

  @override
  String get orbStyleRings => 'ग्रोथ रिंग्स';

  @override
  String get orbGrowNote =>
      'बढ़ने वाले गोले: स्टार ट्रेल में हर क्वांटम मुलाकात कार्ड पर एक तारा जुड़ता है (हर व्यक्ति 24 घंटे में एक बार, 24 तक)। ग्रोथ रिंग्स में क्वांटम वर्ल्ड में बिताए हर 3 घंटे पर एक घेरा जुड़ता है (12 तक)। बढ़त आपके खाते में सेव होती है और अभी से गिनी जाने लगती है। सिर्फ़ गिनती रखी जाती है, कभी नहीं कि कौन या कहाँ।';

  @override
  String orbGrowStars(int count) {
    return 'अब तक $count तारे';
  }

  @override
  String orbGrowRings(int count) {
    return 'अब तक $count घेरे';
  }

  @override
  String get giftAction => 'तोहफ़ा भेजें';

  @override
  String giftSheetTitle(String name) {
    return '$name को तोहफ़ा भेजें';
  }

  @override
  String giftPickStyle(String name) {
    return '$name के लिए एक गोला स्टाइल चुनें';
  }

  @override
  String get giftBouquetName => 'रोशनी का गुलदस्ता';

  @override
  String get giftBouquetDesc =>
      'स्वीकार करते ही रोशनी का धमाका, फिर 24 घंटे तक उनके गोले के चारों ओर पंखुड़ियों की रोशनी';

  @override
  String get giftOrbName => 'एक गोला स्टाइल दें';

  @override
  String get giftOrbDesc => 'आप एक चुनें; स्वीकार करने पर वह हमेशा उनका रहेगा';

  @override
  String get giftPairName => 'उलझी जोड़ी';

  @override
  String get giftPairDesc =>
      'आप दोनों के लिए एक-एक गोला, जोड़ी में; दोनों के क्वांटम वर्ल्ड में होने पर रोशनी की डोर आपको जोड़ती है';

  @override
  String get giftPairYouHave => 'आपके पास पहले से एक उलझी जोड़ी है';

  @override
  String get giftNote =>
      'वे स्वीकार या मना कर सकते हैं। मना करने या 7 दिन में जवाब न देने पर तोहफ़ा आपके पास लौट आता है ताकि आप किसी और को दे सकें।';

  @override
  String get giftVouchersTitle => 'लौटे हुए तोहफ़े (कोई अतिरिक्त शुल्क नहीं)';

  @override
  String get giftSendVoucher => 'भेजें';

  @override
  String giftSent(String name) {
    return 'तोहफ़ा $name को भेजा गया। उनके स्वीकार करने का इंतज़ार।';
  }

  @override
  String get giftReturnedOff =>
      'उन्होंने तोहफ़े बंद कर रखे हैं, इसलिए यह आपके पास लौट आया';

  @override
  String get giftReturnedBlocked =>
      'यह व्यक्ति आपका तोहफ़ा नहीं ले सकता, इसलिए यह आपके पास लौट आया';

  @override
  String get giftReturnedOwned =>
      'उनके पास यह गोला पहले से है, इसलिए यह आपके पास लौट आया; आप दूसरा स्टाइल दे सकते हैं';

  @override
  String get giftReturnedPaired =>
      'उनके पास पहले से उलझी जोड़ी है, इसलिए यह आपके पास लौट आया';

  @override
  String get giftReturnedYouPaired =>
      'आपके पास पहले से उलझी जोड़ी है, इसलिए यह आपके पास लौट आया';

  @override
  String get giftReturnedGeneric =>
      'तोहफ़ा आपके पास लौट आया; आप इसे किसी और को दे सकते हैं';

  @override
  String get giftStoreUnavailable => 'स्टोर अभी उपलब्ध नहीं है';

  @override
  String get giftFailed => 'तोहफ़ा नहीं भेजा जा सका। बाद में कोशिश करें।';

  @override
  String giftFromBouquet(String name) {
    return '$name ने आपको रोशनी का गुलदस्ता भेजा';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name ने आपको \"$style\" गोला दिया';
  }

  @override
  String giftFromPair(String name) {
    return '$name आपकी उलझी जोड़ी बनना चाहते हैं';
  }

  @override
  String get giftInboxTitle => 'आपके लिए तोहफ़े';

  @override
  String get giftInboxEmpty => 'अभी कोई तोहफ़ा नहीं';

  @override
  String get giftInboxNote =>
      'मना किए गए तोहफ़े भेजने वाले के पास लौटते हैं; बिना जवाब वाले 7 दिन बाद लौटते हैं।';

  @override
  String get giftAccept => 'स्वीकार करें';

  @override
  String get giftDecline => 'मना करें';

  @override
  String get giftDeclined => 'मना कर दिया। तोहफ़ा भेजने वाले के पास लौट जाएगा।';

  @override
  String get giftAcceptedOrb => 'स्वीकार कर लिया! क्वांटम अवतार में इसे लगाएँ।';

  @override
  String giftAcceptedPair(String name) {
    return 'अब आप और $name उलझी जोड़ी हैं';
  }

  @override
  String get giftAcceptedBouquet =>
      'गुलदस्ता स्वीकार किया। 24 घंटे तक पंखुड़ियों की रोशनी आपके गोले के चारों ओर रहेगी।';

  @override
  String get giftAlreadyOwned =>
      'आपके पास यह गोला पहले से है; तोहफ़ा भेजने वाले के पास लौट गया';

  @override
  String get giftAlreadyPaired =>
      'आप में से किसी के पास पहले से जोड़ी है; तोहफ़ा भेजने वाले के पास लौट गया';

  @override
  String get giftSettingsTitle => 'तोहफ़े';

  @override
  String get giftReceiveToggle => 'तोहफ़े पाएँ';

  @override
  String get giftReceiveToggleSub =>
      'बंद होने पर तोहफ़े सीधे भेजने वाले के पास लौट जाते हैं';

  @override
  String get giftVouchersHint =>
      'इन्हें फिर से देने के लिए किसी पर \"तोहफ़ा भेजें\" टैप करें';

  @override
  String get giftUnpair => 'उलझी जोड़ी खत्म करें';

  @override
  String giftUnpairConfirm(String name) {
    return '$name के साथ अपनी उलझी जोड़ी खत्म करें? दोनों के पास गोला रहेगा, पर रोशनी की डोर चली जाएगी।';
  }

  @override
  String get orbStylePair => 'उलझा हुआ';

  @override
  String giftPairedWith(String name) {
    return '$name के साथ उलझे हुए';
  }

  @override
  String giftInboxCount(int count) {
    return 'आपके लिए तोहफ़े ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count लौटे हुए तोहफ़े';
  }

  @override
  String get giftBlockedOff =>
      'उन्होंने तोहफ़े बंद कर रखे हैं। आपसे पैसे नहीं लिए गए।';

  @override
  String get giftBlockedBlocked =>
      'आप इस व्यक्ति को तोहफ़े नहीं भेज सकते। आपसे पैसे नहीं लिए गए।';

  @override
  String get giftBlockedOwned =>
      'उनके पास यह गोला पहले से है। दूसरा चुनें (आपसे पैसे नहीं लिए गए)।';

  @override
  String get giftBlockedPaired =>
      'उनके पास पहले से उलझी जोड़ी है। आपसे पैसे नहीं लिए गए।';

  @override
  String get orbStyleValentine => 'वैलेंटाइन';

  @override
  String get orbStyleSakura => 'साकुरा';

  @override
  String get parallelCoords => 'पैरेलल कोऑर्डिनेट';

  @override
  String parallelCoordsHome(String city, String km) {
    return '$city के केंद्र से $km किमी';
  }

  @override
  String parallelCoordsIn(String city) {
    return '$city में आप लगभग यहाँ खड़े हैं';
  }

  @override
  String get parallelCoordsSea => 'समुद्र में, या किसी बिना नाम की जगह';

  @override
  String get parallelCoordsOutside => 'इस शहर के बाहर';

  @override
  String parallelCoordsNote(String city) {
    return 'जब $city के लोग पैरेलल यूनिवर्स चालू करते हैं, तो उन्हें आप लगभग यहीं दिखते हैं (लगभग 500 मी तक धुंधला)।';
  }

  @override
  String get parallelCoordsFailed =>
      'अभी जगह का नाम नहीं मिला। बाद में कोशिश करें।';

  @override
  String parallelCardTitle(String city) {
    return 'अभी मैं पैरेलल $city में हूँ';
  }

  @override
  String parallelCardShareText(String city) {
    return 'अभी मैं पैरेलल $city में हूँ। Mood Whisper खोलो और तुम भी किसी दूसरे शहर में आ जाओ।';
  }

  @override
  String get parallelCoordsShare => 'कार्ड शेयर करें';

  @override
  String get orbStylePassport => 'पासपोर्ट';

  @override
  String get passportTitle => 'पैरेलल पासपोर्ट';

  @override
  String passportCount(int count) {
    return '$count शहर इकट्ठा किए';
  }

  @override
  String passportRewardProgress(int count) {
    return 'पासपोर्ट गोला पाने के लिए $count शहर और इकट्ठा करें';
  }

  @override
  String get passportRewardDone =>
      'आपके पास पासपोर्ट गोला है। क्वांटम अवतार में इसे लगाएँ।';

  @override
  String get passportRewardToast => '5 शहर! आपको पासपोर्ट गोला मिल गया';

  @override
  String get passportEmpty =>
      'पैरेलल यूनिवर्स में किसी दूसरे शहर के व्यक्ति से चैट करें। दोनों के कुछ कहने के बाद, वह शहर आपके पासपोर्ट पर मोहर बन जाता है। सिर्फ़ शहर और तारीख रखी जाती है, कभी नहीं कि आपने किससे बात की।';

  @override
  String passportNewStamp(String city) {
    return 'नई मोहर: $city';
  }

  @override
  String get passportShare => 'पासपोर्ट शेयर करें';

  @override
  String passportCardTitle(int count) {
    return 'मेरा पैरेलल पासपोर्ट\n$count शहर';
  }

  @override
  String passportCardShareText(int count) {
    return 'मेरे पैरेलल पासपोर्ट पर $count शहरों की मोहरें हैं। Mood Whisper खोलो और पैरेलल यूनिवर्स में आ जाओ।';
  }

  @override
  String get asmTitle => 'क्वांटम सभा';

  @override
  String get asmCreateTitle => 'क्वांटम सभा शुरू करें';

  @override
  String get asmCreateIntro =>
      'आप 101 के पास घेरा 3 की होस्ट सीट पर बैठते हैं। क्वांटम वर्ल्ड में सबको आपकी सभा की चमक दिखती है और वे शामिल होना चुन सकते हैं।';

  @override
  String get asmTitleHint => 'सभा का विषय (जैसे साथ में उल्का बारिश देखें)';

  @override
  String get asmPlanFree => 'इस महीने मुफ़्त';

  @override
  String get asmPlanFreeSub => '30 मिनट · 50 लोगों तक · महीने में एक बार';

  @override
  String get asmPlanFreeUsed => 'आपने इस महीने की मुफ़्त सभा इस्तेमाल कर ली है';

  @override
  String get asmPlan1h => '1 घंटा';

  @override
  String get asmPlan1hSub => '200 लोगों तक';

  @override
  String get asmPlan2h => '2 घंटे';

  @override
  String get asmPlan2hSub => '1,000 लोगों तक';

  @override
  String asmVoucherCount(int count) {
    return '$count होस्ट पास तैयार';
  }

  @override
  String get asmExtendTitle => 'सभा बढ़ाएँ';

  @override
  String get asmExtendHint =>
      'समय जोड़ने के लिए होस्ट पास इस्तेमाल करें। हर सभा 12 घंटे तक।';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours घंटे · $price';
  }

  @override
  String get asmExtended => 'सभा बढ़ा दी गई';

  @override
  String get asmEndingSoon =>
      'आपकी सभा 10 मिनट से कम में खत्म होगी। सभा कार्ड से इसे बढ़ा सकते हैं।';

  @override
  String get asmErrTooLong => 'एक सभा 12 घंटे तक चल सकती है';

  @override
  String get asmBuyMore => 'और पास खरीदें';

  @override
  String get asmBuyMoreHint =>
      'पहले से खरीदें और सभा शुरू करने या बढ़ाने में इस्तेमाल करें';

  @override
  String get asmRules =>
      'एक होस्ट पास एक सभा शुरू करता है या चल रही सभा को बढ़ाता है। बचा हुआ समय वापस नहीं होता। शीर्षक और घोषणाएँ फ़िल्टर होती हैं, और नियम तोड़ने पर निलंबन होता है।';

  @override
  String get asmStart => 'सभा शुरू करें';

  @override
  String get asmStarted => 'आपकी सभा शुरू हो गई!';

  @override
  String get asmVoucherReady => 'आपका होस्ट पास तैयार है';

  @override
  String get asmBuyFailed =>
      'खरीदारी पूरी नहीं हुई। आपसे पैसे नहीं लिए गए, या बाद में लागू होगी।';

  @override
  String asmHostLine(String name, String code) {
    return 'होस्ट $name · ⬡ $code';
  }

  @override
  String get asmJoin => 'शामिल हों';

  @override
  String get asmJoined => 'आप सभा में शामिल हो गए';

  @override
  String get asmLeave => 'छोड़ें';

  @override
  String get asmHostPanel => 'होस्ट कंट्रोल';

  @override
  String get asmAnnounceHint => 'घोषणा करें (100 अक्षर तक)';

  @override
  String get asmAnnounceSend => 'पोस्ट करें';

  @override
  String get asmAnnounced => 'घोषणा पोस्ट हुई';

  @override
  String get asmCheerTitle =>
      'क्वांटम चीयर: एक रंग और उलटी गिनती चुनें, और सभी प्रतिभागियों के गोले एक ही पल में जगमगाएँगे';

  @override
  String get asmCheerNow => 'अभी';

  @override
  String asmCheerIn(int n) {
    return '$n सेकंड में';
  }

  @override
  String get asmCheer => 'चीयर!';

  @override
  String get asmRemoveHint =>
      'किसी को हटाने के लिए मैप पर उन पर टैप करें → सभा से हटाएँ';

  @override
  String get asmEnd => 'सभा खत्म करें';

  @override
  String get asmReport => 'इस सभा की रिपोर्ट करें';

  @override
  String get asmErrFreeUsed => 'आपने इस महीने की मुफ़्त सभा इस्तेमाल कर ली है';

  @override
  String get asmErrSeatsFull =>
      'घेरा 3 की सभी होस्ट सीटें भरी हैं। बाद में कोशिश करें।';

  @override
  String get asmErrBlocked => 'विषय या घोषणा में अनुचित सामग्री है';

  @override
  String get asmErrFull => 'सभा भर गई है';

  @override
  String get asmErrRemoved => 'आपको इस सभा से हटा दिया गया';

  @override
  String get asmErrEnded => 'यह सभा खत्म हो गई';

  @override
  String get asmErrTooSoon => 'बहुत जल्दी। थोड़ा रुककर फिर कोशिश करें।';

  @override
  String get asmErrHidden => 'आपका खाता अभी सभा शुरू नहीं कर सकता';

  @override
  String get asmErrHosting => 'आप पहले से एक सभा होस्ट कर रहे हैं';

  @override
  String get asmErrGeneric => 'कुछ गड़बड़ हुई। बाद में कोशिश करें।';

  @override
  String get asmMemorialEyebrow => 'क्वांटम सभा की याद';

  @override
  String get asmMemorialUnit => 'लोग';

  @override
  String get asmMemorialTogether => 'साथ क्वांटम वर्ल्ड में';

  @override
  String shareCardFindUs(String name) {
    return 'App Store पर “$name” खोजें';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'Google Play पर “$name” खोजें';
  }

  @override
  String get asmShareCard => 'याद शेयर करें';

  @override
  String asmShareText(String title, int count) {
    return 'हमने क्वांटम वर्ल्ड में $count लोगों के साथ \"$title\" की। Mood Whisper खोलो और अगली बार साथ आओ।';
  }

  @override
  String get asmOpenEntry => 'क्वांटम सभा शुरू करें';

  @override
  String get asmOpenEntrySub =>
      '101 के पास होस्ट सीट पर बैठें और ऐसी सभा करें जिसमें दुनिया का कोई भी शामिल हो सके';

  @override
  String get asmRemoveMember => 'सभा से हटाएँ';

  @override
  String get asmRemovedDone => 'सभा से हटा दिया गया';

  @override
  String get aiyaFriendPerk5 => 'हर महीने आइया से 60 मिनट वॉइस कॉल';

  @override
  String get aiyaVoiceOn => 'आवाज़: चालू';

  @override
  String get aiyaVoiceOff => 'आवाज़: बंद';

  @override
  String get aiyaVoiceFriendOnly => 'आवाज़ आइया फ्रेंड्स के लिए है';

  @override
  String get aiyaVoiceDailyMax =>
      'आज की आवाज़ वाले जवाब खत्म हो गए। कल फिर आइया की आवाज़ सुनें';

  @override
  String get aiyaCallTooltip => 'आइया से वॉइस कॉल';

  @override
  String get aiyaCallConsentTitle => 'आइया से वॉइस कॉल';

  @override
  String get aiyaCallConsentBody =>
      'वॉइस कॉल के दौरान आपकी आवाज़ सीधे OpenAI (अमेरिका) को भेजी जाती है, जिसका AI उसे समझकर जवाब देता है। आपकी पहचान, उपनाम या लोकेशन नहीं भेजी जाती, और हम कॉल रिकॉर्ड या सेव नहीं करते। आइया एक AI है; जवाब गलत हो सकते हैं और ये पेशेवर सलाह नहीं हैं।';

  @override
  String get aiyaCallAgree => 'सहमत हूँ, कॉल करें';

  @override
  String get aiyaCallConnecting => 'कनेक्ट हो रहा है…';

  @override
  String aiyaCallLive(String time) {
    return 'कॉल पर · $time बाकी';
  }

  @override
  String get aiyaHangUp => 'कॉल काटें';

  @override
  String get aiyaCallEnded => 'कॉल खत्म';

  @override
  String get aiyaCallTimeUp =>
      'एक घंटे बात हो गई। थोड़ा आराम करके फिर आइया को कॉल करें';

  @override
  String get aiyaCallDailyMax =>
      'आज की 2 कॉल पूरी हो गईं। कल फिर आइया को कॉल करें';

  @override
  String get aiyaCallMonthMax =>
      'इस महीने की कॉल पूरी हो गईं। अगले महीने फिर कॉल करें';

  @override
  String get aiyaCallResting =>
      'आज आइया की वॉइस लाइन बहुत व्यस्त है। बाद में फिर कोशिश करें';

  @override
  String get aiyaCallMicDenied =>
      'आइया को कॉल करने के लिए माइक्रोफ़ोन की अनुमति दें। आप फ़ोन की सेटिंग में इसे चालू कर सकते हैं';

  @override
  String get aiyaCallFailed => 'कनेक्ट नहीं हो सका। बाद में फिर कोशिश करें';

  @override
  String aiyaCallsLeft(int today, int month) {
    return 'आज $today कॉल बाकी · इस महीने $month';
  }

  @override
  String get aiyaCallIdle => 'कुछ देर कोई नहीं बोला, इसलिए कॉल खत्म हो गई';

  @override
  String get aiyaCallMute => 'म्यूट';

  @override
  String get aiyaCallUnmute => 'अनम्यूट';

  @override
  String aiyaCallPurchased(int minutes) {
    return '$minutes मिनट कॉल टाइम जोड़ा गया';
  }

  @override
  String get aiyaCallOutOfTime => 'आपका कॉल टाइम खत्म हो गया';

  @override
  String get aiyaCallPacksTitle => 'आइया से वॉइस कॉल';

  @override
  String get aiyaCallPacksBody =>
      'फ़ोन कॉल की तरह आइया से बोलकर बात करें। कॉल टाइम खरीदें और शुरू करें; आइया फ्रेंड्स को हर महीने 60 मिनट मुफ़्त मिलते हैं।';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get aiyaCallFriendOption => 'आइया फ्रेंड बनें (हर महीने 60 मिनट)';

  @override
  String get aiyaCallTextInstead => 'अभी टेक्स्ट से बात करें';

  @override
  String get aiyaCallPackNote =>
      'कॉल टाइम कभी खत्म नहीं होता और असल सेकंड के हिसाब से कटता है। उपभोग्य खरीदारी रिस्टोर नहीं की जा सकती।';

  @override
  String aiyaCallMinutesLeft(int n) {
    return '$n मिनट कॉल टाइम बाकी';
  }

  @override
  String get asmQ2Section => 'Q2 वॉइस लाइव (होस्ट सीट रिंग 2 पर)';

  @override
  String get asmQ2Intro =>
      'Q3 की सारी सुविधाएँ, साथ में वॉइस लाइव और सवाल-जवाब: शामिल होने वाले सभी लोगों से बात करें, हाथ उठाने वालों को मंच पर बुलाएँ, और सभी लिखकर सवाल भेजें और लाइक करें।';

  @override
  String get asmPlanQ2_1h => 'Q2 · 1 घंटा';

  @override
  String get asmPlanQ2_1hSub => '200 लोगों तक, वॉइस लाइव + सवाल-जवाब';

  @override
  String get asmPlanQ2_2h => 'Q2 · 2 घंटे';

  @override
  String get asmPlanQ2_2hSub => '1000 लोगों तक, वॉइस लाइव + सवाल-जवाब';

  @override
  String get asmErrQ2Unavailable => 'वॉइस लाइव अभी उपलब्ध नहीं है';

  @override
  String get asmQ2JoinHint =>
      'लाइव सुनने, हाथ उठाने और सवाल पूछने के लिए शामिल हों';

  @override
  String get asmLiveOn => 'लाइव';

  @override
  String get asmLiveConnecting => 'कनेक्ट हो रहा है…';

  @override
  String get asmLiveError => 'लाइव से कनेक्ट नहीं हो सका';

  @override
  String get asmLiveOff => 'लाइव से कनेक्ट नहीं है';

  @override
  String asmLiveStage(String names) {
    return 'मंच पर: $names';
  }

  @override
  String get asmLiveMicOn => 'माइक चालू करें';

  @override
  String get asmLiveMicOff => 'माइक बंद करें';

  @override
  String get asmLiveHandUp => 'हाथ उठाएँ';

  @override
  String get asmLiveHandDown => 'हाथ नीचे करें';

  @override
  String get asmLiveMute => 'लाइव म्यूट करें';

  @override
  String get asmLiveUnmute => 'लाइव अनम्यूट करें';

  @override
  String get asmLiveMusicMode => 'म्यूज़िक मोड';

  @override
  String get asmLiveMusicHint =>
      'बेहतर आवाज़ और कोई शोर-दमन नहीं, उस संगीत के लिए जो आप खुद बजाते हैं या जिसके अधिकार आपके पास हैं। बिना लाइसेंस वाले व्यावसायिक गाने नहीं चला सकते।';

  @override
  String get asmLiveSpeakers => 'मंच पर मेहमान';

  @override
  String get asmLiveMuteGuest => 'म्यूट करें';

  @override
  String get asmLiveOffStage => 'मंच से उतारें';

  @override
  String asmLiveHands(int count) {
    return '$count लोगों ने हाथ उठाया';
  }

  @override
  String get asmLiveInvite => 'मंच पर बुलाएँ';

  @override
  String get asmLiveNoRecording =>
      'लाइव रिकॉर्ड नहीं होता और कोई आवाज़ सेव नहीं की जाती।';

  @override
  String get asmLiveOnStage =>
      'होस्ट ने आपको मंच पर बुलाया है। आप माइक चालू करके बोल सकते हैं';

  @override
  String get asmLiveMicDenied =>
      'माइक्रोफ़ोन की अनुमति नहीं है, इसलिए आप सिर्फ़ सुन सकते हैं। सेटिंग्स में इसे चालू कर सकते हैं।';

  @override
  String get asmLiveStageFull => 'मंच पर पहले से 3 मेहमान हैं';

  @override
  String get asmLiveGone => 'वह व्यक्ति सभा छोड़ चुका है';

  @override
  String get asmAskOpen => 'सवाल';

  @override
  String get asmAskTitle => 'सवाल';

  @override
  String get asmAskHint =>
      'सवाल भेजें। सभी उसे लाइक कर सकते हैं, और ज़्यादा लाइक वाले ऊपर आते हैं। होस्ट चुनकर जवाब देते हैं।';

  @override
  String get asmAskHostHint =>
      'सवाल लाइक के क्रम में हैं। उन्हें जवाब दिया गया चिह्नित करें, या अनुचित सवाल छिपाएँ।';

  @override
  String get asmAskInput => 'होस्ट से क्या पूछना है? (अधिकतम 80 अक्षर)';

  @override
  String get asmAskSend => 'भेजें';

  @override
  String get asmAskSent => 'सवाल भेज दिया';

  @override
  String get asmAskEmpty => 'अभी तक कोई सवाल नहीं';

  @override
  String get asmAskAnswered => 'जवाब दिया गया चिह्नित करें';

  @override
  String get asmAskReopen => 'बिना जवाब पर वापस करें';

  @override
  String get asmAskHide => 'छिपाएँ';

  @override
  String get asmAskTooMany => 'आप इस सभा में 5 सवाल पूछ चुके हैं';
}
