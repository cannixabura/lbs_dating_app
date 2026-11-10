// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get checkInEnter => 'เช็กอินที่นี่แล้วเข้าสู่เมือง';

  @override
  String get checkInNote =>
      'เมื่อแตะแล้ว คนใกล้ ๆ จะเห็นอารมณ์ของคุณและตำแหน่งคร่าว ๆ คุณต้องเช็กอินเองทุกครั้งที่เข้ามา';

  @override
  String get checkInTitle => 'เช็กอินเข้าเมือง';

  @override
  String get checkInBody =>
      'เมื่อเช็กอินแล้ว คนใกล้ ๆ จะเห็นอารมณ์ของคุณและตำแหน่งคร่าว ๆ และคุณก็จะเห็นพวกเขาด้วย พวกเขาเห็นจุดที่คุณเช็กอิน ไม่ได้ตามคุณไปทุกที่ คุณต้องเช็กอินเองทุกครั้งที่เปิดแอป ไม่มีการเช็กอินอัตโนมัติ การออกจากแอปหรือสลับไปแอปอื่นจะสิ้นสุดการเช็กอิน';

  @override
  String get checkInButton => 'เช็กอินที่นี่';

  @override
  String get checkInAgain => 'คุณออกจากจุดที่เช็กอินแล้ว · เช็กอินที่นี่';

  @override
  String get checkOutButton => 'เช็กอินอยู่ · เลิกเช็กอิน';

  @override
  String get checkedOutToast => 'เลิกเช็กอินแล้ว คุณไม่ปรากฏบนแผนที่อีกต่อไป';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'มีความสุข';

  @override
  String get moodSad => 'เศร้า';

  @override
  String get moodAngry => 'โกรธ';

  @override
  String get moodCalm => 'สงบ';

  @override
  String get moodPassion => 'ไฟลุก';

  @override
  String get moodLove => 'รัก';

  @override
  String get moodOther => 'อื่น ๆ';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name จบแล้ว';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'คุณส่งต่อ $emoji $name แล้ว และตอนนี้เป็นผู้เข้าร่วม';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'คุณส่งต่อกิจกรรมแล้ว ชื่อของคุณยาวครบ 10 ตัวอักษรแล้ว จึงต้องเพิ่ม $emoji เองเพื่อรับประกาศต่อ';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'คุณส่งต่อกิจกรรมแล้ว เราเพิ่ม $emoji ลงในชื่อของคุณ ตอนนี้คุณเป็นผู้เข้าร่วม';
  }

  @override
  String get gotIt => 'เข้าใจแล้ว';

  @override
  String get blockedToast => 'คนนี้จางหายไปในความมืดแล้ว';

  @override
  String get unblockedToast =>
      'เลิกบล็อกแล้ว เส้นทางของคุณกลับมาบรรจบกันได้อีก';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'เปิดบริการหาตำแหน่ง';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper ต้องรู้ว่าคุณอยู่มุมไหนของเมือง เพื่อให้คนใกล้ ๆ เห็นอารมณ์ของคุณ เปิดบริการหาตำแหน่งในการตั้งค่าของโทรศัพท์';

  @override
  String get locationReducedTitle => 'เปิดตำแหน่งที่แม่นยำ';

  @override
  String get locationReducedBodyIos =>
      'คุณแชร์แค่ตำแหน่งโดยประมาณ เรดาร์จึงบอกไม่ได้ว่าใครอยู่ใกล้ ไปที่ การตั้งค่า › Mood Whisper › ตำแหน่งที่ตั้ง แล้วเปิดตำแหน่งที่แม่นยำ';

  @override
  String get locationReducedBodyAndroid =>
      'คุณแชร์แค่ตำแหน่งโดยประมาณ เรดาร์จึงบอกไม่ได้ว่าใครอยู่ใกล้ เลือก \"แม่นยำ\" ในสิทธิ์เข้าถึงตำแหน่ง';

  @override
  String get locationNoFixTitle => 'ยังหาตำแหน่งของคุณไม่เจอ';

  @override
  String get locationNoFixBody =>
      'คุณอาจอยู่ในอาคารหรือสัญญาณอ่อน ลองไปใกล้หน้าต่างหรือออกไปข้างนอก เปิด Wi‑Fi แล้วลองใหม่';

  @override
  String get locationNeededTitle => 'Mood Whisper ต้องใช้ตำแหน่งของคุณ';

  @override
  String get locationNeededBody =>
      'Mood Whisper ใช้ตำแหน่งของคุณเฉพาะตอนที่ใช้แอป เพื่อแสดงอารมณ์ในระยะ 5 กม. เรดาร์แสดงแค่ระยะห่างคร่าว ๆ ไม่แสดงที่อยู่\nในการตั้งค่า ให้อนุญาตตำแหน่ง \"ขณะใช้แอป\" และเปิดตำแหน่งที่แม่นยำ';

  @override
  String get locationSimulatorHint =>
      '(หมายเหตุสำหรับนักพัฒนา: ใน Simulator ให้เลือกตำแหน่งที่ Features › Location)';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get locationRecheck => 'เปิดแล้ว ตรวจอีกครั้ง';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get leaveApp => 'ออก';

  @override
  String whispersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มีเสียงกระซิบ $count ข้อความใกล้คุณ แตะซองจดหมายเพื่ออ่าน',
    );
    return '$_temp0';
  }

  @override
  String get whisperPassed => 'คุณเดินผ่านเสียงกระซิบ แตะซองจดหมายเพื่ออ่าน';

  @override
  String get whisperLeft =>
      'เสียงกระซิบของคุณอยู่ที่นี่แล้ว จะจางหายไปใน 7 วัน';

  @override
  String get timeWhisperSealedYear =>
      'ปิดผนึกแล้ว กลับมาที่นี่อีกหนึ่งปีเพื่อเปิดอ่าน';

  @override
  String get timeWhisperSealedMonth =>
      'ปิดผนึกแล้ว กลับมาที่นี่อีกหนึ่งเดือนเพื่อเปิดอ่าน';

  @override
  String get whisperWithdrawn => 'เรียกคืนเสียงกระซิบแล้ว';

  @override
  String get whisperMineLabel => 'เสียงกระซิบที่คุณฝากไว้';

  @override
  String get whisperTapToRead => 'เสียงกระซิบ แตะเพื่ออ่าน';

  @override
  String get noMoodYet => 'ไม่รู้จะพูดอะไรดี…';

  @override
  String get knockWithdrawnByLeaving =>
      'อีกฝ่ายกลับเข้าไปในเมือง และเงียบ ๆ ถอนการเคาะคืน…';

  @override
  String get knockCardTitle => 'ช่วงเวลาที่ได้พบกัน';

  @override
  String knockCardBody(String name) {
    return '$name กำลังเคาะประตู\nอยากให้เส้นทางของคุณได้บรรจบกัน…';
  }

  @override
  String get skip => 'ข้าม';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get accept => 'ตอบรับ';

  @override
  String get reportThisPerson => 'รายงานคนนี้';

  @override
  String get cityQuietTonight => 'คืนนี้เมืองเงียบสงบ';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'เมืองคืนนี้ · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text ดูสภาพอากาศอารมณ์ของเมือง';
  }

  @override
  String get cityMoodTitle => 'อารมณ์ของเมืองคืนนี้';

  @override
  String cityMoodQuietCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'เมืองยังเงียบอยู่ คืนนี้มี $total คนแชร์อารมณ์',
    );
    return '$_temp0';
  }

  @override
  String cityMoodCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'คืนนี้มี $total คนในระยะ 20 กม. แชร์อารมณ์',
    );
    return '$_temp0';
  }

  @override
  String get cityMoodQuietInvite =>
      'ทุกอารมณ์เพิ่มแสงให้เมืองอีกนิด เขียนความรู้สึกตอนนี้ แล้วช่วยกันจุดแสงให้เมือง';

  @override
  String get cityMoodFootnote =>
      'อารมณ์แบบไม่ระบุตัวตนในช่วง 24 ชั่วโมงที่ผ่านมา จะไม่แสดงสัดส่วนเมื่อมีผู้ร่วมน้อยกว่า 10 คน';

  @override
  String get close => 'ปิด';

  @override
  String get emptyRadarTitle => 'คุณคือแสงแรกของคืนนี้';

  @override
  String get emptyRadarBody =>
      'ยังไม่มีใครอยู่ใกล้ อารมณ์ของคุณกำลังส่องแสงอยู่ในเมืองแล้ว\nใครผ่านมาก็จะเห็น คุณยังฝากเสียงกระซิบไว้ให้คนถัดไปที่ผ่านมาได้ด้วย';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return 'คืนนี้มี $total คนอยู่ในเมือง ส่วนใหญ่รู้สึก “$mood”';
  }

  @override
  String get inviteFriends => 'ชวนเพื่อนมาจุดแสงให้ย่านของคุณ';

  @override
  String get shareMoodCard => 'แชร์การ์ดอารมณ์ของฉัน';

  @override
  String get editYourMood => 'แก้ไขอารมณ์ของคุณ';

  @override
  String resonanceTonight(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คืนนี้มีประกายแสง $count ดวงที่รู้สึกเหมือนคุณ',
    );
    return '$_temp0';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · อารมณ์ของคุณ';
  }

  @override
  String get dockTapToEdit => 'อารมณ์ของคุณ · แตะเพื่อแก้ไข';

  @override
  String get leaveWhisper => 'ฝากเสียงกระซิบ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get nightlyReminder => 'การแจ้งเตือนยามค่ำ';

  @override
  String get nightlyReminderSubtitle => 'เตือนเบา ๆ ทุกคืนเวลา 21:30';

  @override
  String get closeSettings => 'ปิดการตั้งค่า';

  @override
  String get settingsSectionMe => 'ฉัน';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String get editProfileSubtitle => 'รูป ชื่อในเมือง และอารมณ์';

  @override
  String get manageBlockList => 'คนที่บล็อกไว้';

  @override
  String get manageBlockListSubtitle =>
      'ดูหรือเลิกบล็อกคนที่คุณส่งเข้าไปในความมืด';

  @override
  String get myTimeWhispers => 'จดหมายถึงอนาคตของฉัน';

  @override
  String get myTimeWhispersSubtitle => 'ข้อความถึงตัวคุณในอนาคตที่มีแค่คุณเห็น';

  @override
  String get myMoodTrail => 'เส้นทางอารมณ์ของฉัน';

  @override
  String get myMoodTrailSubtitle => 'เก็บไว้ในโทรศัพท์ของคุณเท่านั้น';

  @override
  String get settingsSectionGatherings => 'กิจกรรม';

  @override
  String get gatheringHost => 'จัดกิจกรรม';

  @override
  String get gatheringHostSubtitle =>
      'เริ่มกิจกรรมสำหรับทุกคนในระยะ 5 กม. จากคุณ';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'คุณกำลังจัด $emoji $name';
  }

  @override
  String get settingsSectionShare => 'แชร์';

  @override
  String get shareMoodCardSubtitle =>
      'สุ่มหนึ่งในภาพวาดยามค่ำ 11 แบบ ทำมาสำหรับ Instagram Stories';

  @override
  String get inviteFriendsSubtitle => 'ยิ่งมีคนใกล้ ๆ มาก เมืองก็ยิ่งสว่าง';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับ';

  @override
  String get guide => 'วิธีใช้';

  @override
  String get guideSubtitle => 'ทุกอย่างตั้งแต่เขียนอารมณ์จนถึงจัดกิจกรรม';

  @override
  String get termsOfUse => 'ข้อกำหนดการใช้งาน';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get contactUs => 'ติดต่อเรา';

  @override
  String get deleteAccount => 'ลบบัญชีและข้อมูล';

  @override
  String get deleteAccountSubtitle => 'ลบทุกอย่างที่คุณทิ้งไว้ในเมืองอย่างถาวร';

  @override
  String get avatarUploadFailed => 'อัปโหลดรูปไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get moodEmpty =>
      'อารมณ์ต้องไม่ว่างเปล่า ฝากแสงเล็ก ๆ ไว้ให้เมืองหน่อย';

  @override
  String get profileSyncFailed => 'อัปเดตสถานะไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get profileUpdated => 'อัปเดตแล้ว เมืองรู้สึกได้ถึงลมหายใจของคุณ';

  @override
  String get changeAvatar => 'เปลี่ยนรูป';

  @override
  String get avatarHint => 'แตะเพื่อเปลี่ยนรูป · วงแหวนคือสีอารมณ์ของคุณ';

  @override
  String get cityName => 'ชื่อในเมือง';

  @override
  String get cityNameHint => 'ไม่บังคับ เช่น แมวจรยามค่ำ';

  @override
  String get currentMood => 'อารมณ์ของคุณตอนนี้';

  @override
  String get currentMoodHint => 'เช่น เดินเล่นกลางฝนปรอย ๆ 🌿';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get blockListTitle => 'ส่งเข้าไปในความมืด';

  @override
  String get blockListEmpty => 'ท้องฟ้ายามค่ำแจ่มใส คุณยังไม่ได้ส่งใครออกไป';

  @override
  String get unblock => 'เลิกบล็อก';

  @override
  String get deleteAccountBody =>
      'ตำแหน่ง อารมณ์ ชื่อในเมือง รูป เสียงกระซิบ ประกายแสง รายชื่อที่บล็อก และแชตที่เปิดอยู่ของคุณจะถูกลบอย่างถาวร ย้อนกลับไม่ได้\n\nเพื่อป้องกันการใช้งานในทางที่ผิด ประวัติการรายงานจะถูกเก็บไว้ 1 ปีตามที่ระบุในนโยบายความเป็นส่วนตัว';

  @override
  String get deleting => 'กำลังลบ…';

  @override
  String get deletePermanently => 'ลบถาวร';

  @override
  String get deleteFailed => 'ลบไม่สำเร็จ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String get fadingEcho => 'เงาที่จางลง';

  @override
  String clusterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มี $count อารมณ์ที่นี่',
    );
    return '$_temp0';
  }

  @override
  String clusterMore(int count) {
    return 'เพิ่มเติม\n+$count';
  }

  @override
  String get clusterBackToFirst => 'กลับไป\nเริ่มต้น';

  @override
  String get fadingEchoTitle => 'เงาที่กำลังจางลง';

  @override
  String encounterWith(String name) {
    return 'ได้พบกับ $name';
  }

  @override
  String get fadingEchoBody => 'นี่เป็นแค่เงาที่กำลังจางลง คุณพบกับมันไม่ได้';

  @override
  String get demoPersonBody =>
      'นี่คือคนตัวอย่างที่ตอบกลับอัตโนมัติ ไม่ใช่คนจริง ใช้ทดลองเคาะประตู แชต ส่งประกายแสง รายงาน และบล็อกได้';

  @override
  String get sendGlimmer => 'ส่งประกายแสง';

  @override
  String get knock => 'เคาะประตู';

  @override
  String get blockAction => 'บล็อก';

  @override
  String get handOverHost => 'ส่งต่อการเป็นผู้จัด';

  @override
  String get report => 'รายงาน';

  @override
  String get confirmBlockTitle => 'บล็อกคนนี้ไหม?';

  @override
  String confirmBlockBody(String name) {
    return 'ส่ง $name เข้าไปในความมืดไหม?\nเมื่อบล็อกแล้ว คุณทั้งสองจะหายไปจากเมืองของกันและกัน';
  }

  @override
  String get confirmBlock => 'บล็อก';

  @override
  String get glimmerReceived =>
      'มีคนส่งประกายแสงให้คุณ อารมณ์ของคุณทำให้เขารู้สึกเหมือนกัน';

  @override
  String get glimmerSent => 'ส่งประกายแสงแล้ว';

  @override
  String get glimmerAlreadySent =>
      'วันนี้คุณส่งประกายแสงให้เขาแล้ว พรุ่งนี้ค่อยลองใหม่';

  @override
  String get knockSent => 'เคาะประตูแล้ว รอคำตอบ…';

  @override
  String get knockFailed => 'เคาะประตูไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get knockNoAnswer => 'ไม่มีคำตอบ เสียงเคาะของคุณจางหายไปเงียบ ๆ';

  @override
  String get knockDeclined =>
      'ครั้งนี้เส้นทางของคุณยังไม่บรรจบกัน ให้พื้นที่กันและกันสักหน่อยนะ';

  @override
  String get knockSkipped => 'อีกฝ่ายข้ามไปก่อน เสียงเคาะของคุณจางหายไปเงียบ ๆ';

  @override
  String get sensingCity => 'กำลังสัมผัสเมือง…';

  @override
  String get sensingCityHint =>
      'ถ้าเมืองของคุณเงียบเกินไปตอนนี้ ลองเข้าไปที่จักรวาลคู่ขนานหรือโลกควอนตัม เพื่อพบผู้คนจากเมืองอื่น';

  @override
  String get gatheringUnavailable => 'ตอนนี้ยังใช้กิจกรรมไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get notSentCheckNetwork =>
      'ส่งไม่สำเร็จ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String get justNow => 'เมื่อสักครู่';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count นาทีที่แล้ว',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ชั่วโมงที่แล้ว',
    );
    return '$_temp0';
  }

  @override
  String get nextDayPrefix => 'วันถัดไป ';

  @override
  String get gatheringNameMissing => 'ตั้งชื่อให้กิจกรรมของคุณ';

  @override
  String get gatheringEmojiInvalid => 'ไอคอนกิจกรรมต้องเป็นอีโมจิหนึ่งตัวพอดี';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name เริ่มแล้ว บอกให้ผู้คนเพิ่ม $emoji ลงในชื่อในเมืองเพื่อเข้าร่วม';
  }

  @override
  String get startGatheringTitle => 'เริ่มกิจกรรม';

  @override
  String get startGatheringLead =>
      'ทุกคนในระยะ 5 กม. จากคุณ พื้นที่จะเลื่อนตามคุณ';

  @override
  String get gatheringNameHint => 'ชื่อกิจกรรม เช่น ดูพลุปีใหม่ที่ไทเป 101';

  @override
  String get gatheringEmojiHint => 'ไอคอน';

  @override
  String get gatheringEmojiHelp =>
      'ไอคอนกิจกรรมคืออีโมจิหนึ่งตัวที่ยังไม่มีใครแถวนี้ใช้';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'คนที่เพิ่ม $emoji ลงในชื่อในเมืองจะเห็นประกาศและได้รับการแจ้งเตือนจากคุณ';
  }

  @override
  String get start => 'เริ่ม';

  @override
  String get end => 'จบ';

  @override
  String get gatheringMaxDuration =>
      'กิจกรรมยาวได้สูงสุด 24 ชั่วโมงและจะจบเองอัตโนมัติ';

  @override
  String get starting => 'กำลังเริ่ม…';

  @override
  String get startGathering => 'เริ่มกิจกรรม';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name จบแล้ว คุณกลับมาอยู่ในเมืองแล้ว';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · คุณเป็นผู้จัด';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'คนในระยะ 5 กม. ที่มี $emoji ในชื่อจะเห็นประกาศและได้รับการแจ้งเตือน คุณจะไม่เห็นว่าพวกเขาเป็นใคร';
  }

  @override
  String get postAnnouncement => 'โพสต์ประกาศ';

  @override
  String get announcementHint => 'เช่น เจอกันที่หัวมุมถนนจงเซี่ยวตะวันออก';

  @override
  String get announcementSent => 'ส่งประกาศแล้ว';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (ซ่อนแล้วเพราะถูกรายงานหลายครั้ง)';

  @override
  String get groupQuestion => 'ถามทุกคน';

  @override
  String get questionHint => 'เช่น ตอนนี้รู้สึกยังไงบ้าง?';

  @override
  String get sendQuestion => 'ถาม';

  @override
  String get questionSent => 'ส่งคำถามแล้ว ทุกคนจะตอบด้วยอารมณ์';

  @override
  String get handOff => 'ส่งต่อ';

  @override
  String handoffPending(String name) {
    return 'เชิญ $name รับช่วงเป็นผู้จัดแล้ว รอคำตอบ…';
  }

  @override
  String get theOtherPerson => 'อีกฝ่าย';

  @override
  String get handoffCancelled => 'ยกเลิกคำเชิญส่งต่อแล้ว';

  @override
  String get handoffHelp =>
      'กดค้างที่ฟองของผู้เข้าร่วมบนเรดาร์ → ส่งต่อการเป็นผู้จัด เมื่อเขาตอบรับ เขาจะเป็นผู้จัดและกิจกรรมดำเนินต่อไม่สะดุด';

  @override
  String get confirmEndAgain => 'จบเลยไหม? แตะอีกครั้ง';

  @override
  String get endGathering => 'จบกิจกรรม';

  @override
  String tallyHeader(String question, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total คำตอบ',
    );
    return '“$question” · $_temp0';
  }

  @override
  String get tallyQuiet =>
      'สัดส่วนจะแสดงเมื่อมีครบ 10 คำตอบ เพื่อไม่ให้ใครถูกเดาได้เมื่อมีคนตอบน้อย';

  @override
  String get bannerYouHost => '  · คุณเป็นผู้จัด';

  @override
  String get bannerHostAnnouncement => '  · จากผู้จัด';

  @override
  String get manageGathering => 'จัดการกิจกรรม';

  @override
  String get reportAnnouncement => 'รายงานประกาศนี้';

  @override
  String get expandAnnouncement => 'แสดงประกาศ';

  @override
  String get collapseAnnouncement => 'ซ่อนประกาศ';

  @override
  String hostHandedOffAgo(String ago) {
    return 'ผู้จัดคนใหม่ · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'คุณรายงานประกาศนี้แล้ว จึงนำออกจากหน้าจอของคุณ';

  @override
  String get noAnnouncementHost =>
      'ยังไม่มีประกาศ แตะปุ่มปรับค่าที่มุมขวาบนเพื่อโพสต์ประกาศแรก';

  @override
  String get noAnnouncementGuest => 'ผู้จัดยังไม่ได้โพสต์อะไร';

  @override
  String hostAsks(String question) {
    return 'ผู้จัดถามว่า: $question';
  }

  @override
  String get answeredNote => 'ตอบแล้ว ผู้จัดเห็นแค่สัดส่วนอารมณ์โดยรวม';

  @override
  String get answerHint => 'ตอบด้วยอารมณ์';

  @override
  String get sendAnswer => 'ส่งคำตอบ';

  @override
  String handoffInvited(String name) {
    return 'เชิญ $name รับช่วงเป็นผู้จัดแล้ว รอคำตอบ (มีผล 5 นาที)';
  }

  @override
  String handoffTitle(String name) {
    return 'ส่งต่อกิจกรรมให้ $name';
  }

  @override
  String get handoffBody =>
      'เมื่อเขาตอบรับ เขาจะเป็นผู้จัดกิจกรรม ชื่อ ประกาศ และคำถามยังอยู่เหมือนเดิม ส่วนคุณจะเป็นผู้เข้าร่วม';

  @override
  String get handoffPublic => 'ประกาศการส่งต่อ';

  @override
  String get handoffPublicHelp => 'บอกผู้เข้าร่วมทุกคนว่ามีผู้จัดคนใหม่';

  @override
  String get handoffQuiet => 'ส่งต่อแบบเงียบ ๆ';

  @override
  String get handoffQuietHelp => 'ไม่แจ้งใคร แค่วงแหวนผู้จัดบนเรดาร์ย้ายไป';

  @override
  String get sending => 'กำลังส่ง…';

  @override
  String get sendInvite => 'ส่งคำเชิญ';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'ตอนนี้คุณเป็นผู้จัด $emoji $name';
  }

  @override
  String get handoffOfferTitle => 'รับช่วงเป็นผู้จัดไหม?';

  @override
  String handoffOfferBody(String name) {
    return 'ผู้จัดอยากส่งต่อ “$name” ให้คุณ ในฐานะผู้จัด คุณโพสต์ประกาศ ตั้งคำถาม และจบกิจกรรมได้ และต้องรับผิดชอบสิ่งที่คุณโพสต์';
  }

  @override
  String get processing => 'กำลังดำเนินการ…';

  @override
  String get acceptHosting => 'รับช่วง';

  @override
  String get guideS1Title => '1. เข้าสู่เมือง';

  @override
  String get guideS1L1 =>
      'ครั้งแรกที่เปิดแอป ให้ยืนยันว่าคุณอายุ 18 ปีขึ้นไป และอนุญาตตำแหน่งที่แม่นยำขณะใช้แอป ถ้าไม่มีตำแหน่งที่แม่นยำ เรดาร์จะทำงานไม่ได้';

  @override
  String get guideS1L2 =>
      'เขียนหนึ่งประโยคถึงความรู้สึกตอนนี้ (สูงสุด 20 ตัวอักษร) ยอมรับข้อกำหนดการใช้งานและนโยบายความเป็นส่วนตัว แล้วแตะ \"เช็กอินที่นี่แล้วเข้าสู่เมือง\"';

  @override
  String get guideS1L3 =>
      'ไม่ต้องใช้เบอร์โทร อีเมล หรือชื่อจริง บัญชีของคุณไม่ระบุตัวตนและผูกกับโทรศัพท์เครื่องนี้';

  @override
  String get guideS1L4 =>
      'คำในอารมณ์ของคุณกำหนดสี: “มีความสุข หัวเราะ” เป็นสีทอง “เศร้า ร้องไห้” เป็นสีฟ้า “โกรธ” เป็นสีส้มแดง “สงบ เหม่อ” เป็นสีเขียว “ไฟลุก” เป็นสีส้ม “รัก หัวใจ” เป็นสีชมพู และอย่างอื่นเป็นสีม่วงอ่อน';

  @override
  String get guideS1L5 =>
      'การเช็กอิน: ทุกครั้งที่เปิดแอปคุณต้องเช็กอินเอง แล้วคนใกล้ ๆ จึงจะเห็นอารมณ์และตำแหน่งคร่าว ๆ ของคุณ และคุณก็จะเห็นพวกเขา ไม่มีการเช็กอินอัตโนมัติ คนอื่นเห็นจุดที่คุณเช็กอิน ไม่ได้ตามคุณไปทุกที่ ถ้าคุณย้ายไปไกลกว่า 1 กม. ปุ่ม \"เช็กอินที่นี่\" จะปรากฏใต้เรดาร์ ถ้าแอปอยู่เบื้องหลังนานกว่า 30 นาที ต้องเช็กอินใหม่เมื่อกลับมา';

  @override
  String get guideS2Title => '2. แถบด้านล่าง';

  @override
  String get guideS2L1 =>
      'แตะรูปของคุณทางซ้ายเพื่อแก้ไขรูป ชื่อในเมือง (สูงสุด 10 ตัวอักษร) และอารมณ์';

  @override
  String get guideS2L2 => 'ไอคอนสมุดโน้ต: ฝากเสียงกระซิบไว้ตรงนี้';

  @override
  String get guideS2L3 => 'ไอคอนแชร์: เปลี่ยนอารมณ์ของคุณเป็นการ์ดภาพยามค่ำ';

  @override
  String get guideS2L4 => 'ไอคอนปรับค่าด้านขวาสุด: เปิดการตั้งค่า';

  @override
  String get guideS3Title => '3. เรดาร์และฟองอารมณ์';

  @override
  String get guideS3L1 =>
      'ฟองอารมณ์ของคนในระยะ 5 กม. จะปรากฏบนเรดาร์ แสดงแค่ช่วงระยะคร่าว ๆ (เช่น “ภายใน 100 ม.”) ไม่แสดงที่อยู่';

  @override
  String get guideS3L2 =>
      'เรดาร์จะแสดงเฉพาะคนที่เช็กอินและเปิดแอปอยู่ตอนนี้ เมื่อมีคนออกจากแอปหรือสลับไปแอปอื่น ฟองของเขาจะหายไปทันทีโดยไม่ทิ้งร่องรอย';

  @override
  String get guideS3L3 => 'ใช้สองนิ้วซูมแผนที่ หมุนโทรศัพท์แล้วเรดาร์จะหมุนตาม';

  @override
  String get guideS3L4 =>
      'เมื่อฟองอยู่เบียดกัน จะรวมเป็นลูกแสง “มี N อารมณ์ที่นี่” แตะเพื่อกางออกเป็นวง แล้วแตะแต่ละฟองได้ แตะตรงกลางหรือที่ว่างเพื่อปิด';

  @override
  String get guideS3L5 =>
      'ชื่อที่ขึ้นต้นด้วย \"ตัวอย่าง\" เป็นคนตัวอย่างที่ตอบกลับอัตโนมัติ ไม่ใช่คนจริง ใช้ทดลองทุกฟีเจอร์ได้';

  @override
  String get guideS3L6 =>
      'เมื่อไม่มีใครอยู่ใกล้ จะมีข้อความ “คุณคือแสงแรกของคืนนี้” ด้านล่าง และคุณชวนเพื่อนมาจุดแสงให้ย่านได้';

  @override
  String get guideS4Title => '4. เคาะประตูและแชต';

  @override
  String get guideS4L1 =>
      'กดค้างที่ฟองของใครสักคน → เคาะประตู เขามีเวลา 5 นาทีในการตอบรับ ปฏิเสธ หรือข้าม ระหว่างรอ จะมีเส้นแสงไหลจากคุณไปหาเขา';

  @override
  String get guideS4L2 =>
      'เมื่อเขาตอบรับ แชตจะเริ่มพร้อมนับถอยหลัง 10 นาที ข้อความใหม่ทุกข้อความจะเริ่มนับใหม่ และแชตจะจบเมื่อทั้งคู่เงียบไป';

  @override
  String get guideS4L3 =>
      'เมื่อแชตจบ ข้อความจะถูกลบจากเซิร์ฟเวอร์ แต่อีกฝ่ายยังจับภาพหน้าจอได้ จึงควรแชร์อย่างระมัดระวัง';

  @override
  String get guideS4L4 =>
      'เมื่อมีคนเคาะประตูคุณ การ์ดเคาะประตูจะปรากฏ คุณตอบรับ ปฏิเสธ ข้าม หรือรายงานได้ทันที';

  @override
  String get guideS5Title => '5. ประกายแสง';

  @override
  String get guideS5L1 =>
      'แตะสองครั้งที่ฟองของใครสักคน หรือกดค้างแล้วเลือก \"ส่งประกายแสง\" เพื่อบอกเขาว่ามีคนสังเกตเห็นโดยไม่ต้องพูดอะไร';

  @override
  String get guideS5L2 =>
      'เขาจะเห็นแค่ “คืนนี้มีประกายแสง N ดวงที่รู้สึกเหมือนคุณ” และไม่รู้ว่าใครส่ง คุณส่งให้คนเดิมได้หนึ่งดวงทุก 24 ชั่วโมง';

  @override
  String get guideS6Title => '6. เสียงกระซิบ';

  @override
  String get guideS6L1 =>
      'แตะไอคอนสมุดโน้ตในแถบด้านล่างเพื่อฝากประโยคไว้ตรงที่คุณอยู่ (สูงสุด 60 ตัวอักษร)';

  @override
  String get guideS6L2 =>
      'ตลอด 7 วันต่อจากนี้ ใครที่อยู่ในระยะ 300 ม. จะเห็นซองจดหมายบนเรดาร์และเปิดอ่านได้';

  @override
  String get guideS6L3 =>
      'เสียงกระซิบไม่ระบุตัวตนเสมอ คุณมีได้สูงสุด 3 ข้อความพร้อมกัน ฝากได้ไม่เกิน 1 ข้อความทุก 10 นาที และเรียกคืนได้ทุกเมื่อ';

  @override
  String get guideS6L4 =>
      'จดหมายถึงอนาคต: ตอนเขียนเสียงกระซิบ เลือก \"ถึงตัวฉันในอนาคต\" แล้วเลือกหนึ่งเดือนหรือหนึ่งปี มีแค่คุณที่เห็น เมื่อถึงเวลาจะมีการแจ้งเตือน และจะเปิดเองเมื่อคุณกลับไปอยู่ในระยะ 100 ม. อ่านได้ครั้งเดียว มีแค่คุณที่เห็นนาฬิกาทรายเล็ก ๆ บนเรดาร์ (ล็อกหรือปลดล็อก) และแตะไม่ได้ มีได้สูงสุด 5 ฉบับพร้อมกัน ดูหรือลบได้ที่ การตั้งค่า → จดหมายถึงอนาคตของฉัน';

  @override
  String get guideS7Title => '7. สภาพอากาศอารมณ์ของเมือง';

  @override
  String get guideS7L1 =>
      'ป้ายที่มุมซ้ายบนแสดงอารมณ์ที่พบบ่อยที่สุดในระยะ 20 กม. ช่วง 24 ชั่วโมงที่ผ่านมา แตะเพื่อดูรายละเอียดทั้งหมด';

  @override
  String get guideS7L2 =>
      'สัดส่วนจะถูกซ่อนเมื่อมีผู้ร่วมน้อยกว่า 10 คน เพื่อไม่ให้ใครถูกระบุตัวได้';

  @override
  String get guideS8Title => '8. กิจกรรม';

  @override
  String get guideS8L1 =>
      'วิธีเริ่ม: การตั้งค่า → จัดกิจกรรม → ใส่ชื่อ อีโมจิหนึ่งตัวเป็นไอคอน และเวลาเริ่มกับเวลาจบ (สูงสุด 24 ชั่วโมง) → เริ่มกิจกรรม';

  @override
  String get guideS8L2 =>
      'กิจกรรมครอบคลุมรัศมี 5 กม. รอบจุดที่ผู้จัดเช็กอิน เมื่อผู้จัดเช็กอินใหม่ พื้นที่จะย้ายตาม ผู้จัดมีวงแหวนแสงและป้าย \"ผู้จัด\" บนเรดาร์';

  @override
  String get guideS8L3 =>
      'ผู้จัดโพสต์ประกาศได้ (กี่ครั้งก็ได้) ตั้งคำถามถึงทุกคน และจบกิจกรรมได้ทุกเมื่อ';

  @override
  String get guideS8L4 =>
      'วิธีเข้าร่วม: เพิ่มไอคอนของกิจกรรมลงในชื่อในเมืองของคุณ (เช่น “แมวจรยามค่ำ🌈”) ขณะอยู่ในพื้นที่ คุณจะเห็นประกาศที่ปักไว้เหนือเรดาร์และได้รับการแจ้งเตือน ลบไอคอนออกเพื่อออกจากกิจกรรม';

  @override
  String get guideS8L5 =>
      'คำถามถึงทุกคน: ตอบด้วยอารมณ์ ผู้จัดเห็นแค่สัดส่วนอารมณ์โดยรวม ไม่เห็นว่าใครตอบอะไร และจะซ่อนสัดส่วนเมื่อมีน้อยกว่า 10 คำตอบ';

  @override
  String get guideS8L6 =>
      'ในพื้นที่เดียวกัน ไอคอนหนึ่งใช้ได้กับกิจกรรมเดียวในเวลาเดียวกัน เมื่อจบแล้วใครก็ใช้ไอคอนนั้นได้';

  @override
  String get guideS8L7 =>
      'การส่งต่อ: ผู้จัดกดค้างที่ฟองของผู้เข้าร่วม → ส่งต่อการเป็นผู้จัด แล้วเลือกแบบประกาศหรือแบบเงียบ ๆ ถ้าเขาตอบรับภายใน 5 นาที เขาจะเป็นผู้จัด โดยประกาศและคำถามยังอยู่ ผู้จัดคนเดิมจะเป็นผู้เข้าร่วมและมีไอคอนเพิ่มลงในชื่อ';

  @override
  String get guideS9Title => '9. ประภาคารเมือง (ห้องน้ำที่เข้าถึงได้)';

  @override
  String get guideS9L1 =>
      'แตะไอคอนห้องน้ำที่มุมซ้ายล่างของแผนที่เพื่อเปิดประภาคาร ห้องน้ำที่เป็นมิตรกับทุกเพศ ห้องน้ำสำหรับผู้พิการ และห้องน้ำครอบครัวในระยะ 2 กม. จะปรากฏบนเรดาร์ พร้อมจำนวนข้างไอคอน แตะตัวกรองกลมสามอันด้านบนเพื่อแสดงเฉพาะบางประเภท';

  @override
  String get guideS9L2 =>
      'แตะหมุดเพื่อดูชั้น สิ่งอำนวยความสะดวก และระยะทาง แล้วแตะ \"เดินไปที่นั่น\" เพื่อดูเส้นทางในแอปแผนที่';

  @override
  String get guideS9L3 =>
      'ข้อมูลมาจากบันทึกห้องน้ำสาธารณะของกระทรวงสิ่งแวดล้อมไต้หวัน อัปเดตทุกเดือน ไม่มีเวลาเปิดปิด ส่วน “น่าจะเปิดตอนกลางคืน” เป็นการคาดคะเนของเราจากประเภทสถานที่';

  @override
  String get guideS9L4 =>
      'ถ้าข้อมูลผิด คุณรายงานได้ (ไม่เป็นมิตรกับทุกเพศ ปิดตอนกลางคืน หาไม่เจอ) เมื่อมี 3 คนรายงานปัญหาเดียวกัน หมุดจะเป็นสีเทาพร้อมหมายเหตุ';

  @override
  String get guideS10Title => '11. การ์ดอารมณ์และเส้นทางอารมณ์';

  @override
  String get guideS10L1 =>
      'ปุ่มแชร์ในแถบด้านล่างจะเปลี่ยนอารมณ์ตอนนี้ของคุณเป็นการ์ดภาพยามค่ำ ทำมาสำหรับ Instagram Stories การ์ดไม่แสดงตำแหน่งของคุณ';

  @override
  String get guideS10L2 =>
      'การตั้งค่า → เส้นทางอารมณ์ของฉัน ให้คุณย้อนดูอารมณ์และสถานที่ที่เคยเขียน เก็บไว้ในโทรศัพท์ของคุณเท่านั้น และปิดหรือล้างได้ทุกเมื่อ';

  @override
  String get guideS11Title => '17. การตั้งค่าและการแจ้งเตือน';

  @override
  String get guideS11L1 =>
      'การแจ้งเตือนยามค่ำ: เตือนเบา ๆ ทุกคืนเวลา 21:30 เปิดหรือปิดได้ในการตั้งค่า';

  @override
  String get guideS11L2 =>
      'การเคาะประตู ข้อความใหม่ ประกายแสง และประกาศกิจกรรมจะมาเป็นการแจ้งเตือน ปิดได้ในการตั้งค่าของโทรศัพท์';

  @override
  String get guideS11L3 =>
      'ทุกวันศุกร์ 21:00 ถึง 23:00 คือคืนจุดแสง ทุกคนออนไลน์พร้อมกันและเมืองจะสว่างที่สุด';

  @override
  String get guideS12Title => '18. การรายงานและการบล็อก';

  @override
  String get guideS12L1 =>
      'คุณรายงานได้จากเมนูกดค้างของฟอง การ์ดเคาะประตู มุมขวาบนของแชต เสียงกระซิบ หรือประกาศกิจกรรม เมื่อรายงานแล้ว คนหรือโพสต์นั้นจะหายไปจากหน้าจอของคุณทันทีและแชตจะจบ เราจัดการทุกการรายงานภายใน 24 ชั่วโมง';

  @override
  String get guideS12L2 =>
      'อารมณ์ ชื่อ เสียงกระซิบ ข้อความแชต และประกาศกิจกรรม จะถูกกรองคำไม่เหมาะสมและข้อมูลติดต่อ เช่น เบอร์โทรและลิงก์ โดยอัตโนมัติ';

  @override
  String get guideS12L3 =>
      'เมื่อบล็อกใครแล้ว คุณทั้งสองจะหายไปจากเรดาร์ของกันและกัน และเคาะประตูหรือส่งประกายแสงไม่ได้ เลิกบล็อกได้ที่ การตั้งค่า → คนที่บล็อกไว้';

  @override
  String get guideS12L4 =>
      'ถ้าคุณอยู่ในอันตรายเร่งด่วน ให้โทรหาหมายเลขฉุกเฉินในพื้นที่ (ไต้หวัน 110 ประเทศไทย 191)';

  @override
  String get guideS13Title => '19. ความเป็นส่วนตัวและบัญชีของคุณ';

  @override
  String get guideS13L1 =>
      'หลังจากคุณเช็กอินแล้วเท่านั้น คนใกล้ ๆ จึงจะเห็นอารมณ์ ชื่อในเมือง รูป และระยะห่างคร่าว ๆ ของคุณ พวกเขาเห็นจุดที่คุณเช็กอิน ไม่ใช่ตำแหน่งปัจจุบันของคุณ';

  @override
  String get guideS13L2 =>
      'การตั้งค่า → ลบบัญชีและข้อมูล จะลบทุกอย่างที่คุณทิ้งไว้ในเมืองอย่างถาวร ได้ทุกเมื่อ';

  @override
  String get guideS13L3 =>
      'มีคำถาม? ไปที่ การตั้งค่า → ติดต่อเรา หรืออีเมลมาที่ service.softchip@gmail.com';

  @override
  String get guideS14Title => '12. จักรวาลคู่ขนาน';

  @override
  String get guideS14L1 =>
      'แตะรูปลูกโลกที่มุมขวาบนของเรดาร์เพื่อเปิด และแตะอีกครั้งเพื่อปิด ทุกครั้งที่เปิดแอปจะเริ่มจากปิดเสมอ';

  @override
  String get guideS14L2 =>
      'แต่ละเมืองหรือเขตในไต้หวันมีศูนย์กลางที่สถานีกลางของตัวเอง (ไทเปใหญ่ที่สถานีไทเป เถาหยวนที่สถานีเถาหยวน เป็นต้น) และจับคู่กับเมืองในต่างประเทศ: ญี่ปุ่น เกาหลี ฮ่องกง มาเก๊า สิงคโปร์ มาเลเซีย อินโดนีเซีย เวียดนาม ไทย ฟิลิปปินส์ ออสเตรเลีย นิวซีแลนด์ อินเดีย บราซิล อาร์เจนตินา และแอฟริกาใต้ ส่วนเมืองในต่างประเทศจะจับคู่กับไต้หวัน';

  @override
  String get guideS14L3 =>
      'คุณอยู่ห่างจากสถานีของคุณไกลแค่ไหนและไปทางไหน คุณก็จะปรากฏในเมืองของเขาที่ระยะและทิศเดียวกันจากสถานีของเขา โดยเบลอไว้ราว 500 ม. ไม่มีใครเห็นตำแหน่งจริงของคุณ';

  @override
  String get guideS14L4 =>
      'คุณจะเห็นกันถ้าฝ่ายใดฝ่ายหนึ่งเปิดไว้: เมื่อเปิด คุณจะเห็นทุกคนในเมืองที่จับคู่กันซึ่งเปิดแอปอยู่ เมื่อปิด คุณจะเห็นแค่คนที่เปิดไว้ เฉพาะคนที่เช็กอินแล้วและเปิดแอปอยู่เท่านั้นที่จะปรากฏในเมืองอื่น';

  @override
  String get guideS14L5 =>
      'คนจากจักรวาลคู่ขนานมีวงแหวนเส้นประและแสดงชื่อเมืองของเขา คุณยังส่งประกายแสง เคาะประตู และแชตได้ เสียงกระซิบ จดหมายถึงอนาคต และกิจกรรม จะอยู่แค่ในพื้นที่ของตัวเอง';

  @override
  String get guideS15Title => '16. การแปล';

  @override
  String get guideS15L1 =>
      'ในแชต เมื่อข้อความไม่ใช่ภาษาของคุณ จะมีคำว่า \"แตะเพื่อแปล\" อยู่ข้างใต้ แตะเพื่อแปลเป็นภาษาของคุณ และแตะอีกครั้งเพื่อดูต้นฉบับ';

  @override
  String get guideS15L2 =>
      'ฟองอารมณ์บนเรดาร์ก็ใช้แบบเดียวกัน: เมื่อไม่ใช่ภาษาของคุณ แตะเพื่อแปล และแตะอีกครั้งเพื่อกลับไปที่ต้นฉบับ';

  @override
  String get guideS15L3 =>
      'การแปลเกิดขึ้นในโทรศัพท์ของคุณทั้งหมด ข้อความไม่ถูกอัปโหลด iPhone ใช้การแปลในตัวของ Apple และระบบจะถามก่อนดาวน์โหลดภาษาครั้งแรก Android ใช้ Google ML Kit ซึ่งจะถามคุณก่อนแล้วดาวน์โหลดโมเดลภาษาประมาณ 30 MB ตอนนี้ iPhone ยังแปลภาษามลายูไม่ได้';

  @override
  String get guideIntro =>
      'Mood Whisper คือเมืองยามค่ำคืน: เขียนหนึ่งประโยคถึงความรู้สึกตอนนี้ แล้วดูว่าคนใกล้ ๆ รู้สึกอย่างไร';

  @override
  String get beaconGender => 'เป็นมิตรกับทุกเพศ';

  @override
  String get beaconAccessible => 'ผู้พิการเข้าถึงได้';

  @override
  String get beaconFamily => 'ครอบครัว';

  @override
  String get beaconReportNotGender => 'ไม่เป็นมิตรกับทุกเพศ';

  @override
  String get beaconReportClosed => 'ปิดตอนกลางคืน';

  @override
  String get beaconReportMissing => 'หาห้องน้ำนี้ไม่เจอ';

  @override
  String get beaconFlagNotGender => 'มีรายงาน: ไม่เป็นมิตรกับทุกเพศ';

  @override
  String get beaconFlagClosed => 'มีรายงาน: ปิดตอนกลางคืน';

  @override
  String get beaconFlagMissing => 'มีรายงาน: หาไม่เจอ';

  @override
  String get beaconDefaultName => 'ห้องน้ำสาธารณะ';

  @override
  String meters(int m) {
    return '$m ม.';
  }

  @override
  String kilometers(String km) {
    return '$km กม.';
  }

  @override
  String get beaconUnavailable =>
      'ตอนนี้ยังใช้ประภาคารเมืองไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get notConnectedCheckNetwork =>
      'เชื่อมต่อไม่ได้ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'ห้องน้ำ$features $name $distance';
  }

  @override
  String get listSeparator => ' ';

  @override
  String beaconToggleOff(int count) {
    return 'ปิดประภาคารเมือง (ห้องน้ำที่เข้าถึงได้) มี $count แห่งใกล้ ๆ';
  }

  @override
  String get beaconToggleOn => 'เปิดประภาคารเมือง (ห้องน้ำที่เข้าถึงได้)';

  @override
  String beaconFilterOnly(String feature) {
    return 'แสดงเฉพาะ$feature';
  }

  @override
  String get beaconMaybeOpenNight => 'น่าจะเปิดตอนกลางคืน (คาดคะเน)';

  @override
  String get beaconMaybeDaytime => 'น่าจะเปิดเฉพาะกลางวัน (คาดคะเน)';

  @override
  String get walkThere => 'เดินไปที่นั่น';

  @override
  String get beaconWrongData => 'ข้อมูลผิดไหม?';

  @override
  String beaconThanks(String reason) {
    return 'ขอบคุณ เราได้รับรายงานของคุณแล้ว: “$reason”';
  }

  @override
  String get beaconSource =>
      'ที่มา: บันทึกห้องน้ำสาธารณะของกระทรวงสิ่งแวดล้อมไต้หวัน อัปเดตทุกเดือน เวลาเปิดปิดเป็นการคาดคะเนของเราจากประเภทสถานที่';

  @override
  String get invite1 =>
      'ฉันจุดแสงไว้ใน Mood Whisper ยิ่งมีคนใกล้ ๆ มาก ย่านของเราก็ยิ่งสว่าง มาจุดแสงด้วยกันนะ:';

  @override
  String get invite2 =>
      'คืนนี้เมืองเงียบไปหน่อย มาเขียนอารมณ์ใน Mood Whisper แล้วช่วยให้ย่านของเราสว่างขึ้น:';

  @override
  String get invite3 =>
      'ไม่มีคำขอเป็นเพื่อน ไม่มีชื่อจริง แค่หนึ่งประโยคถึงความรู้สึกของคุณ มาหาฉันใน Mood Whisper:';

  @override
  String get invite4 =>
      'ฉันเปิดไฟรอคุณไว้ใน Mood Whisper เปิดแอปแล้วดูว่าคืนนี้คนใกล้ ๆ รู้สึกอย่างไร:';

  @override
  String get invite5 =>
      'ทุกวันศุกร์สามทุ่มคือคืนจุดแสงใน Mood Whisper มาออนไลน์ด้วยกัน แล้วเติมแสงให้เต็มเรดาร์:';

  @override
  String get invite6 =>
      'อยากมีที่ระบายว่าวันนี้เป็นอย่างไรไหม? Mood Whisper ไม่ระบุตัวตน และคำพูดจะจางหายไปเมื่อพูดจบ:';

  @override
  String get invite7 =>
      'เคยสงสัยไหมว่าคนที่เดินสวนกันบนถนนรู้สึกอย่างไร? มาดูเองใน Mood Whisper:';

  @override
  String get invite8 =>
      'ฉันฝากเสียงกระซิบไว้บนถนนนี้ ที่มีแค่คนเดินผ่านเท่านั้นที่อ่านได้ มาฝากไว้ด้วยกันนะ:';

  @override
  String get invite9 =>
      'Mood Whisper คือแผนที่อารมณ์ของเมืองยามค่ำคืน ยิ่งคนเยอะยิ่งสนุก มาเติมแสงให้ย่านของเรากัน:';

  @override
  String get invite10 =>
      'คืนนี้อารมณ์ของคุณเป็นสีอะไร? เขียนลงใน Mood Whisper ฉันจะอยู่ใกล้ ๆ คอยมองหาแสงของคุณ:';

  @override
  String get shareInvite => 'แชร์คำชวน';

  @override
  String get inviteSubject => 'มาจุดแสงให้ย่านของเราด้วยกัน';

  @override
  String get shareMoodCardButton => 'แชร์การ์ด';

  @override
  String moodShareText(String mood) {
    return 'ฉันแชร์ความรู้สึกตอนนี้ใน Mood Whisper: “$mood”\nคืนนี้อารมณ์ของคุณก็ส่องแสงอยู่ในเมืองเหมือนกันไหม?';
  }

  @override
  String get shareFailed => 'แชร์ไม่สำเร็จ ลองอีกครั้ง';

  @override
  String shuffleCard(int current, int total) {
    return 'สุ่มใหม่ · $current / $total';
  }

  @override
  String get preparing => 'กำลังเตรียม…';

  @override
  String get sendLinkToFriends => 'ส่งลิงก์ให้เพื่อน (LINE, Messenger)';

  @override
  String get partLateNight => 'ดึก';

  @override
  String get partMorning => 'เช้า';

  @override
  String get partAfternoon => 'บ่าย';

  @override
  String get partDusk => 'พลบค่ำ';

  @override
  String get partNight => 'ค่ำ';

  @override
  String get cardInviteEyebrow => 'คำเชิญ';

  @override
  String get cardMoodEyebrow => 'ความรู้สึกของฉันตอนนี้';

  @override
  String get cardInviteTitle => 'มาจุดแสง\nให้ย่านของเรา';

  @override
  String get cardInviteBody =>
      'ฉันจุดแสงไว้ใน Mood Whisper\nยิ่งคนใกล้ ๆ มาก ย่านของเราก็ยิ่งสว่าง';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nที่ไหนสักแห่งในเมือง';
  }

  @override
  String get whisperUnavailable =>
      'ตอนนี้ยังใช้เสียงกระซิบไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get whisperNotSent =>
      'ส่งเสียงกระซิบไม่สำเร็จ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count วันที่แล้ว',
    );
    return '$_temp0';
  }

  @override
  String get timeWhisperTitle => 'จดหมายถึงอนาคต';

  @override
  String get timeWhisperLead =>
      'เขียนถึงตัวคุณในอนาคต เมื่อถึงเวลา ให้กลับมาที่นี่เพื่อเปิดอ่าน';

  @override
  String get whisperLead => 'เขียนถึงคนถัดไปที่ผ่านมา';

  @override
  String get toPassersBy => 'ถึงคนที่ผ่านมา';

  @override
  String get toFutureSelf => 'ถึงตัวฉันในอนาคต';

  @override
  String get inOneMonth => 'อีกหนึ่งเดือน';

  @override
  String get inOneYear => 'อีกหนึ่งปี';

  @override
  String get timeWhisperHint =>
      'เช่น ปีหน้าเจอกันที่นี่ หวังว่าจะดีกว่าตอนนี้นะ';

  @override
  String get whisperHint => 'เช่น พระอาทิตย์ตกตรงนี้สวยมาก อย่าลืมเงยหน้ามองนะ';

  @override
  String get timeWhisperCaptionYear =>
      'มีแค่คุณที่เห็น · เปิดผนึกในอีกหนึ่งปีพร้อมแจ้งเตือน · เปิดได้ในระยะ 100 ม.';

  @override
  String get timeWhisperCaptionMonth =>
      'มีแค่คุณที่เห็น · เปิดผนึกในอีกหนึ่งเดือนพร้อมแจ้งเตือน · เปิดได้ในระยะ 100 ม.';

  @override
  String get whisperCaption =>
      'จางหายใน 7 วัน · ไม่แสดงว่าคุณเป็นใคร · แสดงแค่ว่าคุณเคยอยู่แถวนี้';

  @override
  String get sealHere => 'ปิดผนึกไว้ที่นี่';

  @override
  String get leaveHere => 'ฝากไว้ที่นี่';

  @override
  String get aWhisper => 'เสียงกระซิบ';

  @override
  String whisperLeftAgo(String ago) {
    return 'ฝากไว้แถวนี้เมื่อ$ago';
  }

  @override
  String whisperCollectedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มีคนอ่านแล้ว $count คน',
    );
    return '$_temp0';
  }

  @override
  String get whisperNobodyYet => 'ยังไม่มีใครผ่านมา';

  @override
  String get withdrawWhisper => 'เรียกคืนเสียงกระซิบนี้';

  @override
  String get whisperCollected => 'คุณเก็บเสียงกระซิบนี้แล้ว';

  @override
  String whisperReadersBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'มี $count คนผ่านมาก่อนคุณ',
    );
    return '$_temp0';
  }

  @override
  String get whisperFirstReader => 'คุณเป็นคนแรกที่ผ่านมา';

  @override
  String get reportWhisper => 'รายงานเสียงกระซิบนี้';

  @override
  String get thisWhisper => 'เสียงกระซิบนี้';

  @override
  String get chatTimeUp => 'หมดเวลาแล้ว ช่วงเวลานี้กำลังจางหาย...';

  @override
  String get chatOtherLeft => 'อีกฝ่ายกลับเข้าไปในเมืองแล้ว...';

  @override
  String get chatEnded => 'ช่วงเวลานี้จบลงแล้ว...';

  @override
  String get chatBlockedEnded => 'บล็อกแล้ว บทสนทนาจบลง';

  @override
  String get chatReportedEnded => 'รายงานแล้ว บทสนทนาจบลง';

  @override
  String get anonymous => 'ไม่ระบุชื่อ';

  @override
  String get leaveChat => 'ออกจากบทสนทนา';

  @override
  String chatWith(String name) {
    return 'ช่วงเวลากับ $name';
  }

  @override
  String get countdownPrefix => 'จางหายใน ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'บทสนทนาตัวอย่าง: คำตอบเป็นแบบอัตโนมัติ ไม่ได้มาจากคนจริง';

  @override
  String get typing => 'กำลังพิมพ์…';

  @override
  String get chatHint => 'พูดอะไรเบา ๆ สักหน่อย…';

  @override
  String get send => 'ส่ง';

  @override
  String get chatDissolvedApart => 'คุณทั้งสองต่างกลับเข้าไปในเมืองแล้ว';

  @override
  String get knockTooOften =>
      'คุณเคาะประตูบ่อยเกินไป หายใจไปพร้อมกับเมืองสักหน่อยนะ...';

  @override
  String get otherNotNow =>
      'อีกฝ่ายไม่อยากถูกรบกวนตอนนี้ ให้พื้นที่กันและกันสักหน่อย';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'อีกฝ่ายไม่อยากถูกรบกวนตอนนี้ ให้พื้นที่กันและกันสักหน่อย ($minutes นาที)';
  }

  @override
  String get justEndedRest =>
      'คุณสองคนเพิ่งบอกลากันไป ปล่อยให้ความทรงจำได้พักสักครู่';

  @override
  String get intro1Title => 'ค่อย ๆ ก้าวเข้าสู่เมือง';

  @override
  String get intro1Body =>
      'ทิ้งป้ายทางสังคมไว้ข้างหลัง บนผืนผ้าใบมืดที่เงียบสงบ เหลือเพียงความรู้สึกที่แท้จริงของคุณ และที่ที่คุณอยู่';

  @override
  String get intro2Title => 'ช่วงเวลาที่ผ่านมาแล้วผ่านไป';

  @override
  String get intro2Body =>
      'เห็นฟองอารมณ์ลอยอยู่ใกล้ ๆ ไหม? เคาะประตูเบา ๆ แล้วแบ่งปันบทสนทนาครั้งหนึ่งในชีวิตกับคนที่ผ่านมา';

  @override
  String get intro3Title => 'จังหวะของเมือง';

  @override
  String get intro3Body =>
      'เราใส่ใจความรู้สึกของคุณ หลังเคาะประตู ให้รอคำตอบอย่างเงียบ ๆ ถ้าไม่ใช่วาสนา ฟองจะจางหายไปหลัง 300 วินาที';

  @override
  String get intro4Title => 'ระยะห่างที่อ่อนโยน';

  @override
  String get intro4Body =>
      'ไม่อยากถูกรบกวน? ปฏิเสธหรือบล็อกได้ ระบบพักอารมณ์จะกันเสียงรบกวนออกไป และคืนมุมสงบให้คุณ';

  @override
  String get intro5Title => 'พร้อมจะพบกันหรือยัง?';

  @override
  String get intro5Body =>
      'หลับตา แล้วสัมผัสจังหวะของโทรศัพท์และเสียงหัวใจของคุณ ตอนนี้เขียนความรู้สึกของคุณ เช็กอินที่นี่ แล้วก้าวเข้าสู่ Mood Whisper';

  @override
  String get intro6Title => 'จดหมายถึงตัวคุณในอนาคต';

  @override
  String get intro6Body =>
      'ฝากถ้อยคำไว้ตรงจุดนี้ ให้ตัวคุณในอีกหนึ่งเดือนหรือหนึ่งปี จะเปิดได้ก็ต่อเมื่อคุณกลับมา';

  @override
  String get intro7Title => 'ส่องแสงด้วยกันคืนนี้';

  @override
  String get intro7Body =>
      'จัดกิจกรรมโดยใช้อีโมจิหนึ่งตัวเป็นรหัสลับ ทุกคนที่เพิ่มอีโมจินั้นลงในชื่อจะได้รับประกาศของคุณ แล้วทั้งย่านจะสว่างไปด้วยกัน';

  @override
  String get intro8Title => 'จักรวาลคู่ขนาน';

  @override
  String get intro8Body =>
      'แตะรูปลูกโลก แล้วเมืองในไต้หวันจะซ้อนทับกับโตเกียว โซล และกรุงเทพฯ ดูว่าคนที่อยู่ไกลรู้สึกอย่างไรตอนนี้ เคาะประตู แชต และแตะเพื่อแปล';

  @override
  String get loadingImage => 'กำลังโหลดรูป...';

  @override
  String get startExploring => 'เริ่มสำรวจ';

  @override
  String get nextPage => 'ถัดไป';

  @override
  String get feedbackSubject => 'ความคิดเห็นเกี่ยวกับ Mood Whisper';

  @override
  String get loginNeedMood => 'เขียนความรู้สึกตอนนี้ แล้วค่อยก้าวเข้าสู่เมือง';

  @override
  String get loginNeedAgree =>
      'กรุณาอ่านและยอมรับข้อกำหนดการใช้งานและนโยบายความเป็นส่วนตัวก่อน';

  @override
  String get loginCantConnect =>
      'เชื่อมต่อกับเมืองไม่ได้ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String get ageQuestion => 'คุณอายุ 18 ปีขึ้นไปหรือไม่?';

  @override
  String get ageReason =>
      'Mood Whisper เชื่อมคุณกับคนแปลกหน้าใกล้ ๆ จึงสำหรับผู้ที่อายุ 18 ปีขึ้นไปเท่านั้น';

  @override
  String get ageUnder => 'ฉันอายุต่ำกว่า 18 ปี';

  @override
  String get ageOver => 'ฉันอายุ 18 ปีขึ้นไป';

  @override
  String get loginTitle1 => 'พร้อม';

  @override
  String get loginTitle2 => 'จะพบกันหรือยัง?';

  @override
  String get loginLead =>
      'หลับตา แล้วสัมผัสจังหวะของโทรศัพท์และเสียงหัวใจของคุณ\nตอนนี้เขียนความรู้สึกของคุณ แล้วก้าวเข้าสู่ Mood Whisper';

  @override
  String get loginPrompt => 'ตอนนี้อยากบอกอะไรกับเมือง?';

  @override
  String get loginHint => 'เช่น ได้กาแฟอร่อยมาก😊';

  @override
  String get enterCity => 'เข้าสู่ Mood Whisper';

  @override
  String get agreeSemantic =>
      'ฉันได้อ่านและยอมรับข้อกำหนดการใช้งานและนโยบายความเป็นส่วนตัวแล้ว';

  @override
  String get agreePrefix => 'ฉันได้อ่านและยอมรับ';

  @override
  String get termsLink => 'ข้อกำหนดการใช้งาน';

  @override
  String get agreeAnd => 'และ';

  @override
  String get privacyLink => 'นโยบายความเป็นส่วนตัว';

  @override
  String get agreeSuffix =>
      'แล้ว Mood Whisper ไม่ยอมรับการคุกคาม เนื้อหาทางเพศ ความเกลียดชัง หรือการละเมิดอื่น ๆ โดยเด็ดขาด ผู้ที่ฝ่าฝืนจะถูกนำออก';

  @override
  String get under18Title => 'Mood Whisper สำหรับผู้ที่อายุ 18 ปีขึ้นไป';

  @override
  String get under18Body =>
      'ขอบคุณที่บอกตามจริง เมืองนี้เชื่อมคุณกับคนแปลกหน้า แล้วเจอกันเมื่อคุณอายุครบ 18 ปีนะ';

  @override
  String get clearMoodTrail => 'ล้างเส้นทางอารมณ์';

  @override
  String get clearMoodTrailBody =>
      'เส้นทางอารมณ์ทั้งหมดในโทรศัพท์เครื่องนี้จะถูกลบ ย้อนกลับไม่ได้';

  @override
  String get clear => 'ล้าง';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'เก็บไว้ในโทรศัพท์ของคุณเท่านั้น ไม่ถูกอัปโหลดไปที่ไหน';

  @override
  String get moodTrailEmpty =>
      'สัปดาห์นี้ยังไม่มีเส้นทางอารมณ์ ทุกครั้งที่คุณเขียนอารมณ์หรือไปที่ใหม่ จะมีแสงเพิ่มขึ้นที่นี่';

  @override
  String get thisWeekYou => 'สัปดาห์ของคุณ';

  @override
  String get topMoodPrefix => 'คุณรู้สึก “';

  @override
  String topMoodSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '” บ่อยที่สุด $count ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return 'ฝากอารมณ์ไว้ $total ครั้ง ใน $places สถานที่';
  }

  @override
  String get recordMoodTrail => 'บันทึกเส้นทางอารมณ์ของฉัน';

  @override
  String get recordMoodTrailOff => 'เมื่อปิด จะไม่บันทึกเส้นทางใหม่';

  @override
  String get nightly1 => 'คืนนี้เมืองกำลังคิดอะไรอยู่?';

  @override
  String get nightly2 => 'มีคนใกล้ ๆ กำลังเขียนความรู้สึกตอนนี้';

  @override
  String get nightly3 => 'คืนนี้กำลังดี ฝากสักประโยคไว้ให้เมือง';

  @override
  String get nightly4 =>
      'วันนี้เป็นอย่างไรบ้าง? อารมณ์ของคุณจะส่องแสงอยู่ในเมือง';

  @override
  String get nightly5 => 'ไฟถนนสว่างแล้ว และคนใกล้ ๆ ก็ยังไม่หลับ';

  @override
  String get nightly6 => 'ปิดท้ายวันนี้สักหน่อย: ตอนนี้คุณรู้สึกอย่างไร?';

  @override
  String get nightly7 => 'คืนนี้คุณจะเดินสวนกับใคร?';

  @override
  String get nightlyChannel => 'การแจ้งเตือนยามค่ำ';

  @override
  String get nightlyChannelDesc => 'เตือนเบา ๆ ทุกคืน ปิดได้ในการตั้งค่าของแอป';

  @override
  String get reasonHarassment => 'การคุกคามหรือกลั่นแกล้ง';

  @override
  String get reasonSexual => 'เนื้อหาทางเพศ';

  @override
  String get reasonScam => 'หลอกลวงหรือสแปม';

  @override
  String get reasonHate => 'ความเกลียดชังหรือความรุนแรง';

  @override
  String get reasonImpersonation => 'แอบอ้างเป็นผู้อื่น';

  @override
  String get reasonOther => 'อย่างอื่น';

  @override
  String get reportReceived =>
      'ได้รับรายงานแล้วและนำออกจากหน้าจอของคุณ เราจะตรวจสอบภายใน 24 ชั่วโมง';

  @override
  String get reportNotSent =>
      'ส่งรายงานไม่สำเร็จ ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String reportTarget(String target) {
    return 'รายงาน$target';
  }

  @override
  String get reportPrivate => 'อีกฝ่ายจะไม่รู้ว่าคุณรายงาน เลือกเหตุผล:';

  @override
  String get reportDetails => 'รายละเอียดเพิ่มเติม (ไม่บังคับ)';

  @override
  String get reportWhatHappened => 'เกิดอะไรขึ้น?';

  @override
  String get sendReport => 'ส่งรายงาน';

  @override
  String get alsoBlock => 'บล็อกด้วย คุณทั้งสองจะหายไปจากเมืองของกันและกัน';

  @override
  String get aYearAgo => 'หนึ่งปีก่อน';

  @override
  String get aMonthAgo => 'หนึ่งเดือนก่อน';

  @override
  String get timeWhisperUnavailable =>
      'ตอนนี้ยังใช้จดหมายถึงอนาคตไม่ได้ ลองใหม่ภายหลัง';

  @override
  String timeWhisperYouSaid(String ago) {
    return 'เมื่อ$ago คุณพูดไว้ที่นี่ว่า';
  }

  @override
  String writtenOn(String date) {
    return 'เขียนเมื่อ $date';
  }

  @override
  String get timeWhisperOnce => 'จดหมายฉบับนี้ปรากฏเพียงครั้งเดียว';

  @override
  String get keepInHeart => 'เก็บไว้ในใจ';

  @override
  String unsealsOn(String unlock, String created) {
    return 'เปิดผนึก $unlock · เขียนเมื่อ $created';
  }

  @override
  String get unsealedGoBack => 'เปิดผนึกแล้ว กลับไปที่นั่นเพื่อเปิดอ่าน';

  @override
  String unsealedDistance(String distance) {
    return 'เปิดผนึกแล้ว · ห่างออกไป $distance';
  }

  @override
  String get timeWhisperListLead =>
      'จดหมายถึงตัวคุณในอนาคตที่มีแค่คุณเห็น เมื่อถึงเวลา ให้ไปอยู่ในระยะ 100 ม. จากจุดนั้นเพื่อเปิดอ่าน อ่านแล้วจะหายไป';

  @override
  String get timeWhisperListEmpty =>
      'ยังไม่มีจดหมายถึงอนาคต แตะไอคอนสมุดโน้ตในแถบด้านล่าง แล้วเลือก “ถึงตัวฉันในอนาคต”';

  @override
  String get readyToOpen => 'พร้อมเปิดอ่าน';

  @override
  String get sealed => 'ปิดผนึกอยู่';

  @override
  String get delete => 'ลบ';

  @override
  String get within100m => 'ภายใน 100 ม.';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'รอ $name ตอบ เหลือ $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'รอ $name';
  }

  @override
  String get language => 'ภาษา';

  @override
  String get languageSystem => 'ตามโทรศัพท์';

  @override
  String get parallelUniverse => 'จักรวาลคู่ขนาน';

  @override
  String get parallelUniverseSubtitle =>
      'ดูว่าเมืองอื่นรู้สึกอย่างไรตอนนี้ และให้พวกเขาเห็นคุณ';

  @override
  String get parallelUniverseIntroTitle => 'เข้าสู่จักรวาลคู่ขนาน';

  @override
  String get parallelUniverseIntroBody =>
      'เมื่อเปิด ทุกคนที่เปิดแอปอยู่ในเมืองที่จับคู่กับคุณจะปรากฏบนเรดาร์ของคุณ และพวกเขาทุกคนก็เห็นคุณ เมืองในไต้หวันจับคู่กับเมืองในต่างประเทศ (เช่น โตเกียว โซล และกรุงเทพฯ) และเมืองในต่างประเทศจับคู่กับไต้หวัน\n\nสองเมืองจะเรียงกันที่ใจกลางเมือง (สถานีกลาง หรือศาลาว่าการเมืองถ้าไม่มีสถานี): คุณอยู่ห่างจากใจกลางเมืองของคุณไกลแค่ไหนและไปทางไหน คุณก็จะปรากฏในเมืองของเขาที่ตำแหน่งเดียวกัน โดยเบลอไว้ราว 500 ม. ไม่มีใครเห็นตำแหน่งหรือระยะห่างจริงของคุณ คุณยังส่งประกายแสง เคาะประตู และแชตได้ และปิดได้ทุกเมื่อ เสียงกระซิบและกิจกรรมจะอยู่แค่ในพื้นที่ของตัวเอง';

  @override
  String get parallelUniverseEnter => 'เข้าสู่';

  @override
  String get parallelUniverseNoCity => 'ที่ที่คุณอยู่ยังไม่มีจักรวาลคู่ขนาน';

  @override
  String parallelFrom(String city) {
    return 'คู่ขนาน · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'คนนี้อยู่ที่$city ไม่ได้อยู่ใกล้คุณ ตำแหน่งของเขาเป็นการฉายภาพ ไม่ได้แสดงระยะห่างจริง';
  }

  @override
  String get labelHost => 'ผู้จัด';

  @override
  String get labelDemo => 'ตัวอย่าง';

  @override
  String get labelResting => 'พักอยู่';

  @override
  String get cityTaipei => 'ไทเป';

  @override
  String get cityTaichung => 'ไถจง';

  @override
  String get cityKaohsiung => 'เกาสง';

  @override
  String get cityTokyo => 'โตเกียว';

  @override
  String get cityOsaka => 'โอซาก้า';

  @override
  String get citySeoul => 'โซล';

  @override
  String get cityBusan => 'ปูซาน';

  @override
  String get cityHongkong => 'ฮ่องกง';

  @override
  String get cityMacau => 'มาเก๊า';

  @override
  String get citySingapore => 'สิงคโปร์';

  @override
  String get cityKualalumpur => 'กัวลาลัมเปอร์';

  @override
  String get cityJakarta => 'จาการ์ตา';

  @override
  String get cityHochiminh => 'โฮจิมินห์';

  @override
  String get cityHanoi => 'ฮานอย';

  @override
  String get translateTap => 'แตะเพื่อแปล';

  @override
  String get translateShowOriginal => 'แปลแล้ว · แตะเพื่อดูต้นฉบับ';

  @override
  String get translating => 'กำลังแปล…';

  @override
  String get translateFailed => 'แปลไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get translateDownloadTitle => 'ดาวน์โหลดโมเดลการแปล';

  @override
  String get translateDownloadBody =>
      'การแปลภาษานี้ครั้งแรกต้องใช้โมเดลการแปล (ประมาณ 30 MB ต่อภาษา ดาวน์โหลดครั้งเดียว)\n\nการแปลเกิดขึ้นในโทรศัพท์ของคุณทั้งหมด ข้อความไม่ถูกอัปโหลด';

  @override
  String get translateDownload => 'ดาวน์โหลด';

  @override
  String placeHint(String name) {
    return 'มีโคมไฟของจุดอารมณ์อยู่ใกล้ ๆ · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'เปิดถึง $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'จุดอารมณ์: $name $hours';
  }

  @override
  String get placeWrongData => 'ข้อมูลผิดไหม?';

  @override
  String placeReportSubject(String name) {
    return 'ข้อมูลจุดอารมณ์ไม่ถูกต้อง: $name';
  }

  @override
  String get placeHintsSetting => 'การบอกใบ้จุดอารมณ์';

  @override
  String get placeHintsSettingSubtitle =>
      'บอกใบ้เบา ๆ ในแอปเมื่อคุณผ่านจุดอารมณ์ที่เปิดอยู่ (ไม่มีการแจ้งเตือนแบบพุช)';

  @override
  String get guideS16Title => '10. จุดอารมณ์';

  @override
  String get guideS16L1 =>
      'จุดอารมณ์คือคาเฟ่อิสระที่เราร่วมมือด้วย หลังจากเช็กอินแล้ว เมื่อคุณเดินเข้าไปในระยะ 150 ม. ขณะที่ร้านเปิดอยู่ จะมีโคมไฟเล็ก ๆ ปรากฏบนเรดาร์และค่อย ๆ หายใจเป็นจังหวะ เมื่อเดินออกไปโคมจะดับลง';

  @override
  String get guideS16L2 =>
      'แตะโคมไฟเพื่อเปิดการ์ดสถานที่: ภาพยามค่ำจากในร้าน เวลาปิดวันนี้ เรื่องราวอารมณ์หนึ่งบรรทัดจากคาเฟ่ (แตะเพื่อแปล) ที่อยู่ และเบอร์โทร แตะ \"เดินไปที่นั่น\" เพื่อดูเส้นทางเดินในแอปแผนที่ โคมที่คุณเปิดการ์ดแล้ววันนี้จะส่องแสงนิ่ง ๆ ไม่หายใจ';

  @override
  String get guideS16L3 =>
      'ครั้งแรกที่คุณผ่าน จะมีการ์ดเล็ก ๆ ด้านบนบอกคุณ โดยไม่มีเสียงหรือการสั่น คุณจะได้รับคำบอกใบ้ไม่เกินหนึ่งครั้งต่อสถานที่ทุก 7 วัน และไม่เกิน 2 ครั้งต่อวัน ปิดได้ที่ การตั้งค่า > การบอกใบ้จุดอารมณ์ โดยโคมไฟยังอยู่';

  @override
  String get guideS16L4 =>
      'รายชื่อสถานที่ทั้งหมดจะถูกดาวน์โหลดลงโทรศัพท์ของคุณ และการตรวจว่าคุณอยู่ใกล้หรือไม่ทำในโทรศัพท์ของคุณเท่านั้น ทั้งเราและคาเฟ่ไม่รู้ว่าคุณผ่านที่ไหน คาเฟ่จ่ายเงินเพื่อให้มองเห็นมากขึ้นไม่ได้ ถ้าข้อมูลผิด รายงานได้ที่ด้านล่างของการ์ด';

  @override
  String get placeGuestbook => 'สมุดเยี่ยม';

  @override
  String placeGuestbookLocked(int m) {
    return 'เข้าไปในร้าน (ภายในราว $m ม.) เพื่ออ่านสิ่งที่คนที่เคยนั่งตรงนี้ฝากไว้';
  }

  @override
  String get placeGuestbookAbout =>
      'อ่านได้เฉพาะคนที่อยู่ในร้าน ไม่ระบุตัวตน หายไปหลัง 30 วัน';

  @override
  String get placeGuestbookEmpty => 'ยังไม่มีข้อความ ฝากข้อความแรกเลย';

  @override
  String get placeGuestbookWrite => 'ฝากข้อความ';

  @override
  String get placeGuestbookHint => 'ถึงคนถัดไปที่นั่งตรงนี้…';

  @override
  String get placeGuestbookSent => 'เรียบร้อย คนถัดไปที่มาที่นี่จะได้อ่าน';

  @override
  String get placeGuestbookUnavailable =>
      'ตอนนี้ยังใช้สมุดเยี่ยมไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get placeNoteMine => 'ข้อความของคุณ';

  @override
  String get withdrawPlaceNote => 'เรียกคืนข้อความนี้';

  @override
  String get reportPlaceNote => 'รายงานข้อความนี้';

  @override
  String get thisPlaceNote => 'ข้อความนี้';

  @override
  String get guideS16L5 =>
      'สมุดเยี่ยม: เปิดการ์ดของสถานที่ขณะอยู่ในร้าน (ภายในราว 40 ม.) เพื่ออ่านสิ่งที่คนที่เคยนั่งตรงนี้ฝากไว้ และฝากหนึ่งบรรทัดให้คนถัดไป ข้อความไม่ระบุตัวตนและหายไปหลัง 30 วัน คุณฝากได้หนึ่งข้อความต่อสถานที่ต่อวัน แตะข้อความเพื่อแปล และรายงานสิ่งที่รบกวนใจได้ เมื่อเปิดสมุดเยี่ยม โทรศัพท์จะส่งตำแหน่งไปยังเซิร์ฟเวอร์ของเราเพื่อยืนยันว่าคุณอยู่ในร้าน โดยเซิร์ฟเวอร์ไม่เก็บไว้';

  @override
  String get quantumWorld => 'โลกควอนตัม';

  @override
  String get quantumWorldSubtitle =>
      'ห้องเดียวสำหรับคนทั้งโลก โดยไม่เปิดเผยว่าคุณอยู่ที่ไหน';

  @override
  String get quantumIntroTitle => 'เข้าสู่โลกควอนตัม';

  @override
  String get quantumIntroBody =>
      'ทุกคนที่อยู่ในโลกควอนตัมตอนนี้อยู่ในห้องเดียวกัน จัดเป็นรังผึ้งรอบไทเป 101 คุณจะได้ที่นั่ง เช่น \"Q4-17\" — วงยิ่งเล็กยิ่งใกล้จุดศูนย์กลาง\n\nไม่มีใครเห็นตำแหน่งจริงของคุณ คนอื่นเห็นแค่ที่นั่งของคุณ ซึ่งจะคงที่ตั้งแต่ตอนที่คุณแตะ \"เข้า\" และไม่เคลื่อนแม้คุณจะเดิน ถ้าอยากเปลี่ยนที่ ให้ออกแล้วเข้าใหม่ ชื่อเล่นและอารมณ์ของคุณยังเหมือนเดิม และคุณยังส่งประกายแสง เคาะประตู และแชตได้ พร้อมแตะเพื่อแปล\n\nขณะอยู่ในโลกควอนตัม คุณจะออกจากเรดาร์ปกติและจักรวาลคู่ขนานชั่วคราว เมื่อออกมา คุณจะกลับไปที่จุดเช็กอิน';

  @override
  String get quantumEnter => 'เข้าสู่';

  @override
  String get quantumLeave => 'ออกจากโลกควอนตัม';

  @override
  String get quantumLeft => 'คุณออกจากโลกควอนตัมและกลับมาที่เรดาร์แล้ว';

  @override
  String quantumYourSeat(String code) {
    return 'ที่นั่งของคุณ $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'วง $ring · วงยิ่งเล็กยิ่งใกล้จุดศูนย์กลางไทเป 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return 'อยู่ที่นี่ $count คน';
  }

  @override
  String quantumOnlineTitle(int count) {
    return 'ตอนนี้มี $count คนอยู่ในโลกควอนตัม';
  }

  @override
  String get quantumRegionTw => 'ไต้หวัน';

  @override
  String get quantumRegionJp => 'ญี่ปุ่น';

  @override
  String get quantumRegionKr => 'เกาหลี';

  @override
  String get quantumRegionHkmo => 'ฮ่องกงและมาเก๊า';

  @override
  String get quantumRegionSea => 'เอเชียตะวันออกเฉียงใต้';

  @override
  String get quantumRegionOther => 'ที่อื่น ๆ';

  @override
  String get quantumQuiet => 'ความสงบควอนตัม';

  @override
  String get quantumQuietSubtitle =>
      'แค่ดูโลก: ไม่มีใครเคาะประตูได้ แต่ประกายแสงยังส่งถึงคุณ';

  @override
  String get quantumQuietTarget =>
      'อีกฝ่ายเปิดความสงบควอนตัมอยู่ — ตอนนี้คุณส่งได้แค่ประกายแสง';

  @override
  String get quantumClosedRegion => 'โลกควอนตัมใช้ไม่ได้ในพื้นที่ที่คุณอยู่';

  @override
  String get quantumLeftClosed =>
      'คุณเข้าไปในพื้นที่ที่ใช้โลกควอนตัมไม่ได้ จึงออกมาแล้ว';

  @override
  String get quantumSeatExpired =>
      'คุณหายไปนานเกินไป ที่นั่งจึงถูกปล่อยแล้ว คุณกลับมาที่เรดาร์ของคุณ';

  @override
  String get quantumUnavailable =>
      'ตอนนี้เชื่อมต่อโลกควอนตัมไม่ได้ ลองใหม่ภายหลัง';

  @override
  String quantumPersonBody(String code) {
    return 'ที่นั่งของคนนี้ในโลกควอนตัมคือ $code โลกควอนตัมไม่แสดงตำแหน่งจริงของใคร';
  }

  @override
  String quantumChatTag(String code) {
    return 'โลกควอนตัม · $code';
  }

  @override
  String get guideS17Title => '13. โลกควอนตัม';

  @override
  String get guideS17L1 =>
      'แตะไอคอนรังผึ้งที่มุมขวาบนของเรดาร์ (ใต้จักรวาลคู่ขนาน) อ่านคำอธิบายแล้วแตะ \"เข้าสู่\" คุณต้องแตะเข้าเองทุกครั้งเหมือนการเช็กอิน ทุกครั้งที่เปิดแอปจะเริ่มที่เรดาร์ปกติ';

  @override
  String get guideS17L2 =>
      'ทุกคนในโลกควอนตัมอยู่ในห้องเดียวกัน: รังผึ้งรอบไทเป 101 ที่นั่งห่างกัน 100 ม. คุณจะได้รหัสที่นั่ง เช่น \"Q4-17\" (วง 4 ที่นั่ง 17) — วงยิ่งเล็กยิ่งใกล้จุดศูนย์กลาง คนที่มาใหม่จะได้ที่นั่งที่คนอื่นเพิ่งออกไปก่อน วง 1–3 สงวนไว้สำหรับผู้จัดกิจกรรม';

  @override
  String get guideS17L3 =>
      'ไม่มีใครเห็นตำแหน่งจริงของคุณ: คนอื่นเห็นแค่ที่นั่งของคุณ ทุกครั้งที่แตะ \"เข้า\" นับเป็นการเช็กอินหนึ่งครั้ง และที่นั่งจะคงที่ตั้งแต่ตอนนั้น ไม่เคลื่อนแม้คุณจะเดิน ถ้าอยากเปลี่ยนที่ ให้ออกแล้วเข้าใหม่ โลกควอนตัมใช้ไม่ได้ในจีนแผ่นดินใหญ่';

  @override
  String get guideS17L4 =>
      'ชื่อเล่นและอารมณ์ของคุณยังเหมือนเดิม คุณยังส่งประกายแสง เคาะประตู และแชตได้ พร้อมแตะเพื่อแปล ใช้สองนิ้วถ่างออกเพื่อดูรังผึ้งทั้งหมด คนที่อยู่ไกลจะกลายเป็นจุดแสง แตะรหัสที่นั่งที่มุมซ้ายบนเพื่อดูว่าใครออนไลน์ เปิดความสงบควอนตัม (ไม่มีใครเคาะได้ แต่ประกายแสงยังมาถึง) หรือออก';

  @override
  String get guideS17L5 =>
      'ในโลกควอนตัมไม่มีเสียงกระซิบ จดหมายถึงอนาคต จุดอารมณ์ ประภาคารเมือง หรือกิจกรรม ขณะอยู่ข้างในคุณจะออกจากเรดาร์ปกติและจักรวาลคู่ขนานชั่วคราว เมื่อออกมา ฟองของคุณจะสลายเป็นแสงและคุณกลับไปที่จุดเช็กอิน ถ้าปิดแอปหรือออฟไลน์นานกว่า 3 นาที ที่นั่งจะถูกปล่อย';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'ระฆังบอกชั่วโมงในอีก $seconds วินาที';
  }

  @override
  String get quantumChimeLookOrigin => 'ทุกคนกำลังมองไปที่จุดศูนย์กลาง 101';

  @override
  String get quantumChimeLook => 'ดู';

  @override
  String quantumChimeNow(int hour) {
    return 'ระฆังศูนย์ควอนตัม $hour นาฬิกา';
  }

  @override
  String get quantumChimeSend => 'ส่งประกายแสงระฆัง';

  @override
  String get quantumChimeSent => 'ประกายแสงของคุณกำลังบินไปยังจุดศูนย์กลาง';

  @override
  String quantumChimeWatched(int n) {
    return 'มี $n คนดูระฆังครั้งนี้ด้วยกัน';
  }

  @override
  String get quantumChimeReminder => 'เตือนระฆังบอกชั่วโมง';

  @override
  String get quantumChimeReminderSubtitle =>
      'เตือนก่อนถึงต้นชั่วโมงเพื่อมาดูระฆังที่จุดศูนย์กลาง 101';

  @override
  String get quantumChimeNotifyBody =>
      'ระฆังบอกชั่วโมงกำลังจะเริ่ม — มาดูที่จุดศูนย์กลาง 101';

  @override
  String get quantumChimeChannel => 'ระฆังบอกชั่วโมง';

  @override
  String get quantumChimeChannelDesc => 'การเตือนระฆังบอกชั่วโมงของโลกควอนตัม';

  @override
  String get quantumEntangleInvite => 'ชวนพัวพันควอนตัม';

  @override
  String quantumEntangleInvited(String name) {
    return 'ชวน $name พัวพันแล้ว';
  }

  @override
  String get quantumEntangleAskTitle => 'การพัวพันควอนตัม';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) อยากพัวพันกับคุณ เส้นแสงบาง ๆ จะเชื่อมฟองของคุณทั้งสอง มองเห็นได้ไม่ว่าจะอยู่ห่างกันแค่ไหน เส้นจะสลายเมื่อฝ่ายใดฝ่ายหนึ่งออกไป และไม่มีอะไรถูกเก็บไว้';
  }

  @override
  String get quantumEntangleAccept => 'พัวพัน';

  @override
  String quantumEntangled(String name) {
    return 'คุณกับ $name พัวพันกันแล้ว';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'การพัวพันของคุณกับ $name สลายแล้ว';
  }

  @override
  String get quantumEntangleCut => 'ยกเลิกการพัวพัน';

  @override
  String get quantumEntangleFull => 'คุณพัวพันกับ 3 คนแล้ว';

  @override
  String get quantumEntangleTheirFull => 'อีกฝ่ายพัวพันกับ 3 คนแล้ว';

  @override
  String get quantumEntangleGone => 'อีกฝ่ายออกจากโลกควอนตัมแล้ว';

  @override
  String get quantumEntangleExpired => 'คำเชิญหมดอายุแล้ว';

  @override
  String get quantumEntangledTitle => 'พัวพันกันอยู่';

  @override
  String get quantumTunnel => 'การทะลุควอนตัม';

  @override
  String get quantumTunnelSubtitle =>
      'กระโดดไปยังที่นั่งว่างแบบสุ่มในรังผึ้ง แล้วพบเพื่อนบ้านใหม่ ใช้ได้ครั้งเดียวต่อการเข้า';

  @override
  String get quantumTunnelUsed => 'การเข้าครั้งนี้คุณทะลุไปแล้ว';

  @override
  String quantumTunnelDone(String code) {
    return 'ทะลุไปที่ $code แล้ว';
  }

  @override
  String get quantumShowTime => 'แสดงเวลาท้องถิ่นของฉัน';

  @override
  String get quantumShowTimeSubtitle =>
      'คนอื่นจะเห็นเมื่อกดค้างที่ฟองของคุณ เมื่อปิด จะแสดงแค่โทนสีกลางวันกลางคืน';

  @override
  String quantumLocalTime(String time, String part) {
    return 'เวลาท้องถิ่น $time · $part';
  }

  @override
  String get quantumDawn => 'เช้าตรู่';

  @override
  String get quantumDay => 'กลางวัน';

  @override
  String get quantumDusk => 'พลบค่ำ';

  @override
  String get quantumNight => 'ดึก';

  @override
  String get quantumTopicsTitle => 'คลื่นความถี่ควอนตัม';

  @override
  String get quantumTopicsSubtitle =>
      'เลือกได้สูงสุด 3 หัวข้อเพื่อแสดงใต้ฟองของคุณ';

  @override
  String get quantumTopicMusic => 'ดนตรี';

  @override
  String get quantumTopicMovies => 'ภาพยนตร์';

  @override
  String get quantumTopicTech => 'เทคโนโลยี';

  @override
  String get quantumTopicWalks => 'เดินเล่น';

  @override
  String get quantumTopicFood => 'อาหาร';

  @override
  String get quantumTopicTravel => 'ท่องเที่ยว';

  @override
  String get quantumTopicReading => 'อ่านหนังสือ';

  @override
  String get quantumTopicSports => 'กีฬา';

  @override
  String quantumTopicsCommon(String topics) {
    return 'คุณทั้งคู่ชอบ: $topics';
  }

  @override
  String get quantumSignalsTitle => 'สัญญาณควอนตัม';

  @override
  String quantumSignalReceived(String name) {
    return '$name ส่งสัญญาณถึงคุณ';
  }

  @override
  String get quantumSignalWait => 'คุณเพิ่งส่งไป — รอสักครู่แล้วลองใหม่';

  @override
  String quantumResonance(String name) {
    return 'คุณกับ $name กำลังสั่นพ้องกัน';
  }

  @override
  String get guideS17L6 =>
      'ระฆังบอกชั่วโมง: หนึ่งนาทีก่อนต้นชั่วโมง ลำแสง 101 จะสว่างขึ้น เมื่อถึงต้นชั่วโมง ผู้ส่งสารแห่งแสงจะวนรอบจุดศูนย์กลาง ระฆังตีตามเวลาศูนย์ควอนตัม (เที่ยงคืนตี 24 ครั้ง) และคลื่นแสงสุดท้ายจะกวาดผ่านรังผึ้ง แตะ “ส่งประกายแสงระฆัง” ระหว่างระฆังดัง — ยิ่งมีคนดูมากยิ่งสว่าง การเตือนระฆังบอกชั่วโมงเปิดไว้เป็นค่าเริ่มต้น ปิดได้ในแผง';

  @override
  String get guideS17L7 =>
      'หลังแชตกันแล้ว คุณชวนอีกฝ่ายพัวพันได้: เส้นแสงจะเชื่อมฟองของคุณไม่ว่าจะห่างกันแค่ไหน และสลายเมื่อฝ่ายใดฝ่ายหนึ่งออกไป (สูงสุด 3 คนพร้อมกัน) การทะลุควอนตัมใช้ได้ครั้งเดียวต่อการเข้า จะพาคุณกระโดดไปที่นั่งว่างแบบสุ่มพร้อมเพื่อนบ้านใหม่';

  @override
  String get guideS17L8 =>
      'แต่ละฟองมีโทนสีตามเวลาท้องถิ่นของเจ้าของ: ทองอ่อนตอนเช้าตรู่ ขาวสว่างตอนกลางวัน ส้มม่วงตอนพลบค่ำ น้ำเงินเข้มตอนดึก เปิด “แสดงเวลาท้องถิ่นของฉัน” เพื่อให้คนอื่นเห็นเวลาเมื่อกดค้างที่ฟองของคุณ การส่งประกายแสงให้กันภายใน 24 ชั่วโมงทำให้คุณสั่นพ้องกัน กดค้างที่ฟองเพื่อส่งสัญญาณ 👋 ☕ 🌙 🎵 🌧️ ✨ เลือกหัวข้อคลื่นความถี่ได้สูงสุด 3 หัวข้อในแผง หัวข้อที่ตรงกันจะสว่างขึ้น';

  @override
  String get quantumNyTitle => 'ปีใหม่ควอนตัม';

  @override
  String quantumNyDays(int n) {
    return 'อีก $n วัน: เที่ยงคืนวันที่ 31/12 ตามเวลาศูนย์ควอนตัม นับถอยหลังพร้อมคนทั้งโลกที่จุดศูนย์กลาง 101';
  }

  @override
  String get quantumNyTonight =>
      'คืนนี้เที่ยงคืนตามเวลาศูนย์ควอนตัม นับถอยหลังพร้อมคนทั้งโลกที่จุดศูนย์กลาง 101';

  @override
  String quantumNyZone(String places) {
    return 'สวัสดีปีใหม่ $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return 'มี $n คนทั่วโลกต้อนรับปีใหม่ด้วยกันในโลกควอนตัม';
  }

  @override
  String get quantumNyHappy => 'สวัสดีปีใหม่';

  @override
  String get guideS17L9 =>
      'ปีใหม่ควอนตัม: ในวันที่ 31/12 เมื่อแต่ละเขตเวลาถึงเที่ยงคืน ฟองในเขตนั้นจะสว่างด้วยวงแหวนสีทองเป็นระลอก และจุดในมุมมองโลกก็จะเป็นสีทองด้วย เมื่อถึงเที่ยงคืนเวลาศูนย์ควอนตัม ทั้งรังผึ้งจะนับถอยหลัง 10 วินาทีสุดท้าย จุดศูนย์กลาง 101 จะปล่อยแสงที่ยิ่งใหญ่ที่สุดในโลกพร้อมพลุ 5 นาที และคุณจะเห็นว่ามีกี่คนข้ามสู่ปีใหม่ด้วยกัน';

  @override
  String get quantumMeetAction => 'ทำการ์ดการพบกันควอนตัม';

  @override
  String quantumMeetAsked(String name) {
    return 'ชวน $name ทำการ์ดการพบกันควอนตัมด้วยกันแล้ว';
  }

  @override
  String get quantumMeetWait => 'คุณเพิ่งชวนไป — รอสักครู่แล้วลองใหม่';

  @override
  String get quantumMeetAskTitle => 'การ์ดการพบกันควอนตัม';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) อยากเปลี่ยนการพบกันครั้งนี้เป็นการ์ดเพื่อแชร์ การ์ดแสดงชื่อเล่น รหัสที่นั่ง เวลาท้องถิ่น และอารมณ์ของคุณทั้งสอง — ไม่แสดงตำแหน่งใด ๆ';
  }

  @override
  String get quantumMeetAccept => 'ทำด้วยกัน';

  @override
  String get quantumMeetEyebrow => 'QUANTUM ENCOUNTER';

  @override
  String get quantumMeetFooter => 'เราพบกันในโลกควอนตัม';

  @override
  String get quantumMeetShare => 'แชร์การ์ด';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — เราพบกันในโลกควอนตัม ✨';
  }

  @override
  String get guideS17L10 =>
      'การ์ดการพบกันควอนตัม: หลังแชตกันแล้ว กดค้างที่ฟองของอีกฝ่ายเพื่อชวนทำการ์ดด้วยกัน เมื่อทั้งคู่ตกลง แต่ละคนจะได้การ์ดเพื่อแชร์ ซึ่งมีชื่อเล่น รหัสที่นั่ง เวลาท้องถิ่นพร้อมโทนสีกลางวันกลางคืน และอารมณ์ของทั้งสอง — ไม่แสดงตำแหน่งใด ๆ รหัสที่นั่งวง 4 จะเป็นสีทอง';

  @override
  String get quantumOrbEntry => 'อวตารควอนตัม';

  @override
  String get quantumOrbEntrySubtitle =>
      'รูปของคุณจะกลายเป็นลูกแก้วคริสตัลในโลกควอนตัม';

  @override
  String get orbTitle => 'อวตารควอนตัม';

  @override
  String get orbSubtitle => 'แก้วและแสงเรืองจะตามอารมณ์ของคุณเสมอ';

  @override
  String get orbStyleGlow => 'แสงเรือง';

  @override
  String get orbStyleRing => 'วงแหวน';

  @override
  String get orbStyleRainbow => 'สายรุ้ง';

  @override
  String get orbFree => 'ฟรี';

  @override
  String get orbOwned => 'มีแล้ว';

  @override
  String get orbInUse => 'ใช้อยู่';

  @override
  String get orbCosmeticNote =>
      'ลูกแก้วพิเศษเป็นแค่รูปลักษณ์ — ไม่เปลี่ยนฟีเจอร์หรือสิทธิ์ใด ๆ ลูกแก้วที่ซื้อจะอยู่กับบัญชีของคุณ';

  @override
  String get orbRestore => 'กู้คืนการซื้อ';

  @override
  String orbPurchased(String name) {
    return '$name เป็นของคุณแล้ว ✨';
  }

  @override
  String get orbPurchaseFailed => 'การซื้อไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String get orbOwnedElsewhere => 'การซื้อนี้ถูกใช้กับบัญชีอื่นแล้ว';

  @override
  String get orbStoreUnavailable =>
      'ตอนนี้เชื่อมต่อร้านค้าไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get aiyaName => 'ไอยา';

  @override
  String get aiyaChip => 'ไอยา · AI';

  @override
  String get aiyaConsentTitle => 'ก่อนคุยกับไอยา';

  @override
  String get aiyaConsentBody =>
      'ไอยาเป็น AI ที่ใช้ Claude ของ Anthropic ข้อความที่คุณส่งให้ไอยาจะถูกประมวลผลโดย Anthropic (สหรัฐฯ) โดยไม่มีตัวตน ชื่อเล่น หรือตำแหน่งของคุณ และจะถูกลบเมื่อจบการสนทนา คำตอบของไอยาอาจผิดพลาดและไม่ใช่คำแนะนำจากผู้เชี่ยวชาญ';

  @override
  String get aiyaConsentAgree => 'ยอมรับและเริ่ม';

  @override
  String get aiyaConsentLater => 'ไว้ก่อน';

  @override
  String get aiyaGreeting =>
      'สวัสดี ฉันคือไอยา แสงที่อยู่กลางโลกควอนตัม คืนนี้อยากคุยเรื่องอะไร';

  @override
  String get aiyaFarewell =>
      'หมดเวลาแล้ว ฉันจะกลับเข้าไปในแสง คิดถึงเมื่อไหร่ก็มาเคาะประตูนะ';

  @override
  String get aiyaInputHint => 'พูดอะไรกับไอยาสักหน่อย…';

  @override
  String get aiyaSend => 'ส่ง';

  @override
  String aiyaFreeLeft(int n) {
    return 'วันนี้เหลือฟรีอีก $n ครั้ง';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'แพ็กเวลา $n ครั้ง';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'เหลือ $time';
  }

  @override
  String get aiyaEnd => 'จบการคุย';

  @override
  String get aiyaFiltered =>
      'มีคำหรือข้อมูลติดต่อที่ไม่อนุญาต ลองพูดแบบอื่นดูนะ';

  @override
  String get aiyaBusy => 'ไอยาเหม่อไปแป๊บหนึ่ง พูดอีกครั้งได้ไหม';

  @override
  String get aiyaRefused => 'เรื่องนี้ฉันคุยไม่ค่อยได้ เปลี่ยนเรื่องกันไหม';

  @override
  String get aiyaEnded => 'การคุยครั้งนี้จบแล้ว';

  @override
  String get aiyaNoQuotaTitle => 'ใช้ครั้งฟรีของวันนี้หมดแล้ว';

  @override
  String get aiyaNoQuotaBody =>
      'แต่ละวันคุยฟรีได้ 3 ครั้ง เริ่มนับใหม่ตอน 00:00 เวลาไต้หวัน ถ้าอยากคุยต่อตอนนี้ ซื้อแพ็กเวลาได้ ครั้งละไม่เกิน 10 นาที';

  @override
  String get aiyaResting => 'คืนนี้ไอยาเหนื่อยแล้ว เจอกันพรุ่งนี้';

  @override
  String get aiyaDailyMax => 'วันนี้คุยกันเยอะแล้ว พรุ่งนี้มาหาไอยาใหม่นะ';

  @override
  String aiyaPackTimes(int n) {
    return '$n ครั้ง';
  }

  @override
  String get aiyaPackNote =>
      'แพ็กเวลาผูกกับบัญชีในโทรศัพท์เครื่องนี้ และกู้คืนไม่ได้ถ้าลบแอปหรือบัญชี';

  @override
  String aiyaPurchased(int n) {
    return 'เพิ่ม $n ครั้งแล้ว ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'การซื้อไม่สำเร็จ ลองอีกครั้ง';

  @override
  String get aiyaStoreUnavailable =>
      'ตอนนี้เชื่อมต่อร้านค้าไม่ได้ ลองใหม่ภายหลัง';

  @override
  String get aiyaReport => 'รายงานคำตอบนี้';

  @override
  String get aiyaReported => 'ได้รับรายงานแล้ว เราจะตรวจสอบภายใน 24 ชั่วโมง';

  @override
  String get aiyaSetting => 'ไอยา (AI ในโลกควอนตัม)';

  @override
  String get aiyaSettingSubtitle =>
      'เมื่อปิด ไอยาจะไม่ปรากฏที่เสาแสงในโลกควอนตัม';

  @override
  String get aiyaCameoHello =>
      'สวัสดี ยินดีต้อนรับสู่โลกควอนตัม อยากคุยก็แตะฉันได้เลย';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour นาฬิกาแล้ว ฉันอยู่ในแสงนี้กับคุณนะ';
  }

  @override
  String get locationPickOnMap => 'เลือกบนแผนที่';

  @override
  String get locationPickTitle => 'เลือกตำแหน่งของคุณ';

  @override
  String get locationPickHint =>
      'เลื่อนแผนที่ให้จุดเรืองแสงตรงกลางอยู่ตรงที่คุณอยู่ตอนนี้';

  @override
  String get locationPickConfirm => 'ฉันอยู่ที่นี่';

  @override
  String get aiyaPackEntry => '+ แพ็กเวลา';

  @override
  String get aiyaPacksTitle => 'แพ็กเวลา';

  @override
  String get aiyaPacksBody =>
      'คุณคุยฟรีได้วันละ 3 ครั้ง ครั้งในแพ็กเวลาจะถูกใช้หลังจากครั้งฟรีหมดแล้วเท่านั้น คุยแต่ละครั้งได้นานสุด 10 นาที';

  @override
  String get guideS1L6 =>
      'ถ้าหาตำแหน่งของคุณไม่เจอ (เช่น อยู่ในอาคาร หรือใช้ iPad ที่ไม่มี GPS) ให้แตะ \"เลือกบนแผนที่\" แล้วเลื่อนแผนที่ให้จุดเรืองแสงตรงกลางอยู่ตรงที่คุณอยู่ จากนั้นแตะ \"ฉันอยู่ที่นี่\" เมื่อได้ตำแหน่งจริงแล้ว แอปจะเปลี่ยนไปใช้ตำแหน่งนั้นเอง';

  @override
  String get guideS17L11 =>
      'อวตารควอนตัม: แตะรหัสที่นั่งมุมซ้ายบน → \"อวตารควอนตัม\" แล้วรูปของคุณในโลกควอนตัมจะกลายเป็นลูกแก้วคริสตัล แสงเรืองและวงแหวนใช้ฟรี ส่วนสายรุ้งซื้อครั้งเดียวใช้ได้ตลอด และ \"กู้คืนการซื้อ\" จะนำกลับมาเมื่อเปลี่ยนเครื่องหรือติดตั้งใหม่';

  @override
  String get guideS18Title => '14. ไอยา · AI';

  @override
  String get guideS18L1 =>
      'ไอยาเป็น AI ที่อาศัยอยู่ในเสาแสงกลางโลกควอนตัม เธอไม่ใช่คน และเธอจะบอกคุณแบบนั้น ในโลกควอนตัม แตะ \"ไอยา · AI\" ใต้เสาเพื่อเคาะประตูและคุย ก่อนคุยครั้งแรกต้องอ่านคำอธิบายสั้น ๆ และกดยอมรับ';

  @override
  String get guideS18L2 =>
      'คุยแต่ละครั้งได้นานสุด 10 นาทีและ 20 ข้อความ คุยฟรีได้วันละ 3 ครั้ง รีเซ็ตเวลา 00:00 ตามเวลาไต้หวัน และคุยได้สูงสุดวันละ 30 ครั้ง';

  @override
  String get guideS18L3 =>
      'แพ็กเวลา: แตะ \"+ แพ็กเวลา\" เหนือช่องพิมพ์ได้ทุกเมื่อเพื่อซื้อ 5 หรือ 20 ครั้ง โดยจะถูกใช้หลังจากครั้งฟรีหมด แพ็กเวลาผูกกับบัญชีในเครื่องนี้ และกู้คืนไม่ได้หลังลบแอปหรือบัญชี เป็นสินค้าแบบใช้แล้วหมดไป จึงไม่มี \"กู้คืนการซื้อ\"';

  @override
  String get guideS18L4 =>
      'ไอยาไม่รู้และจะไม่ถามตำแหน่งหรือตัวตนของคุณ เธอเห็นแค่สถิติอารมณ์ของเมืองแบบไม่ระบุตัวตน เธอไม่จีบ ไม่คุยเรื่องทางเพศ และไม่ให้คำแนะนำด้านการแพทย์ กฎหมาย หรือการเงิน กดค้างที่คำตอบใดก็ได้เพื่อรายงาน บทสนทนาจะเก็บไว้ชั่วคราวเฉพาะในการคุยครั้งนั้นและถูกลบไม่นานหลังจบ';

  @override
  String get guideS18L5 =>
      'บางครั้งไอยาจะปรากฏในเสาแสง: ตอนระฆังบอกเวลาทุกชั่วโมง ตอนที่คุณเข้าโลกควอนตัมครั้งแรกของวัน หรือโดยบังเอิญ แตะเธอเพื่อเริ่มคุย ถ้าไม่อยากเห็นเธอ ให้ปิด \"ไอยา (AI ในโลกควอนตัม)\" ในการตั้งค่า';

  @override
  String get orbStyleXmas => 'คริสต์มาส';

  @override
  String get orbStyleNewYear => 'ปีใหม่ควอนตัม';

  @override
  String get orbLimited => 'รุ่นลิมิเต็ด';

  @override
  String orbLimitedUntil(String date) {
    return 'ลิมิเต็ด · ถึง $date';
  }

  @override
  String get aiyaFriendTitle => 'เพื่อนของไอยา';

  @override
  String get aiyaFriendSubtitle => 'แพ็กเกจรายเดือนต่ออายุอัตโนมัติ';

  @override
  String get aiyaFriendPerk1 => 'คุยได้วันละ 20 ครั้ง (ฟรีวันละ 3 ครั้ง)';

  @override
  String get aiyaFriendPerk2 => 'ครั้งละ 20 นาทีหรือ 40 ข้อความ';

  @override
  String get aiyaFriendPerk3 => 'คุยได้แม้ตอนที่ ไอยา พักผ่อน';

  @override
  String get aiyaFriendPerk4 =>
      'ไอยา เปลี่ยนเป็นลุค “แสงดาว” สุดพิเศษ (เห็นแค่คุณ)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / เดือน';
  }

  @override
  String get aiyaFriendSubscribe => 'สมัครสมาชิก';

  @override
  String get aiyaFriendTerms =>
      'การสมัครมีระยะเวลา 1 เดือนและจะต่ออายุพร้อมเรียกเก็บเงินโดยอัตโนมัติ เว้นแต่จะปิดการต่ออายุอัตโนมัติอย่างน้อย 24 ชั่วโมงก่อนสิ้นสุดรอบ การชำระเงินดำเนินการผ่านบัญชี Apple หรือ Google จัดการหรือยกเลิกได้ทุกเมื่อในการตั้งค่าการสมัครสมาชิกของบัญชี จำนวนครั้งในแพ็กเวลาจะยังอยู่ และจะใช้หลังจากใช้ครบ 20 ครั้งต่อวัน';

  @override
  String aiyaFriendActive(String date) {
    return 'คุณเป็นเพื่อนของไอยา ถึง $date';
  }

  @override
  String get aiyaFriendManage => 'จัดการการสมัครสมาชิก';

  @override
  String get aiyaFriendRestore => 'กู้คืนการซื้อ';

  @override
  String get aiyaFriendWelcome => 'คุณเป็นเพื่อนของไอยา แล้ว ✨';

  @override
  String get aiyaFriendRestored => 'กู้คืนเพื่อนของไอยา แล้ว';

  @override
  String get aiyaFriendNotFound => 'ไม่พบการสมัครเพื่อนของไอยา ที่ใช้งานอยู่';

  @override
  String get aiyaFriendElsewhere => 'การสมัครนี้ถูกใช้กับบัญชีอื่นแล้ว';

  @override
  String get aiyaFriendEntry => 'เพื่อนของไอยา · วันละ 20 ครั้ง';

  @override
  String aiyaFriendLeft(int n) {
    return 'เพื่อนของไอยา · วันนี้เหลือ $n ครั้ง';
  }

  @override
  String get guideS17L12 =>
      'รุ่นลิมิเต็ด: ลูกแก้วคริสต์มาส (พวงหรีดฮอลลี่ ดาวทองระยิบระยับ หิมะโปรย) ขายถึง 12/25 และลูกแก้วปีใหม่ควอนตัม (ขีดนาฬิกาสีทองกับพลุที่ผลัดกันบาน บานใหญ่เป็นพิเศษตอนเที่ยงคืน) ขายถึง 1/1 ตามเวลาไต้หวัน หลังจากนั้นจะไม่ขายอีก ใครซื้อแล้วใช้ได้ตลอดและกู้คืนการซื้อได้';

  @override
  String get guideS14L6 =>
      'เมืองต่างประเทศใช้สถานีกลางเป็นศูนย์กลาง ถ้าไม่มีใช้ศาลาว่าการเมือง พิกัดคู่ขนาน: เมื่อเปิดจักรวาลคู่ขนาน แตะปุ่มทางซ้ายของลูกโลกแล้วเลือกเมือง จะเห็นว่าคุณยืนอยู่แถวไหนในเมืองนั้นโดยประมาณ การ์ดแชร์เขียนแค่ชื่อเมือง ไม่มีชื่อสถานที่';

  @override
  String get guideS14L7 =>
      'พาสปอร์ตคู่ขนาน: แชทกับคนในเมืองคู่ขนาน เมื่อทั้งสองฝ่ายพูดแล้วจะได้ตราประทับของเมืองนั้น สะสมครบ 5 เมืองได้ลูกแก้ว \'พาสปอร์ต\' เปิดได้จากพิกัดคู่ขนานหรือการตั้งค่า คนในจักรวาลคู่ขนานจะแสดงเวลาท้องถิ่นและสีท้องฟ้าใต้ชื่อ';

  @override
  String get guideS17L13 =>
      'การชุมนุมควอนตัม: ในโลกควอนตัม การชุมนุมจะเป็นการชุมนุมควอนตัม แตะรหัสที่นั่งมุมซ้ายบน → \'เปิดการชุมนุมควอนตัม\' ตั้งหัวข้อ เลือกไอคอนและสี คุณจะย้ายไปนั่งที่นั่งผู้จัดในวงที่ 3 ข้าง 101 คนอื่นแตะวงแสงเพื่อเข้าร่วม ผู้จัดประกาศข้อความ กด \'เชียร์ควอนตัม\' (ลูกแก้วของผู้ร่วมทุกคนสว่างพร้อมกัน) และแตะคนบนแผนที่เพื่อ \'เชิญออกจากการชุมนุม\' ได้ ฟรีเดือนละ 1 ครั้ง (30 นาที 50 คน) แบบ 1 ชั่วโมง 200 คน หรือ 2 ชั่วโมง 1000 คนต้องใช้บัตรผู้จัด 1 ใบเปิดได้ 1 ครั้งหรือต่อเวลา 1 ครั้ง (สูงสุด 12 ชั่วโมง) และซื้อไว้หลายใบได้ การชุมนุมจะจบเมื่อผู้จัดกดจบหรือหมดเวลาเท่านั้น แม้ผู้จัดออกจากโลกควอนตัมหรือปิดแอปก็ยังดำเนินต่อ เมื่อจบทุกคนได้การ์ดที่ระลึกที่มีแค่จำนวนคนและภูมิภาค';

  @override
  String get guideS17L14 =>
      'ลูกแก้วที่เติบโต: วงโคจรดาวได้ดาว 1 ดวงทุกครั้งที่ทำการ์ดพบกันควอนตัมสำเร็จ (คนเดิมนับครั้งเดียวใน 24 ชั่วโมง สูงสุด 24 ดวง) วงปีได้ 1 วงทุก 3 ชั่วโมงที่อยู่ในโลกควอนตัม (สูงสุด 12 วง) การเติบโตผูกกับบัญชีและเริ่มสะสมตั้งแต่ก่อนซื้อ';

  @override
  String get guideS17L15 =>
      'ของขวัญ: แตะคนบนแผนที่ หรือเลือก \'ส่งของขวัญ\' มุมขวาบนของแชท เพื่อส่งช่อดอกไม้แห่งแสง (แสงบานบนหน้าจอผู้รับ และมีกลีบแสงรอบลูกแก้ว 24 ชั่วโมง) ลูกแก้ว 1 แบบ หรือคู่พัวพัน (คนละลูก จับคู่กัน มีเชือกแสงเชื่อมเมื่ออยู่ในโลกควอนตัมทั้งคู่) ผู้รับรับหรือปฏิเสธได้ ถ้าปฏิเสธหรือไม่ตอบใน 7 วัน ของขวัญจะกลับมาหาคุณและส่งให้คนอื่นได้ ปิดการรับของขวัญได้ในการตั้งค่า';

  @override
  String get guideS17L16 =>
      'ลายจำกัดอื่น ๆ: ลูกแก้ววาเลนไทน์ขายถึง 2/14 และลูกแก้วซากุระขายถึง 4/10 (เวลาไต้หวัน) หลังจากนั้นจะไม่วางขาย ผู้ที่ซื้อแล้วใช้ได้ตลอดไป';

  @override
  String get guideS18L6 =>
      'เพื่อนของไอยา: เลือก \"เพื่อนของไอยา\" ใน \"+ แพ็กเวลา\" เป็นแพ็กเกจรายเดือนต่ออายุอัตโนมัติ คุยได้วันละ 20 ครั้ง ครั้งละไม่เกิน 20 นาทีหรือ 40 ข้อความ คุยได้แม้ไอยาพักผ่อน และไอยาจะเปลี่ยนเป็นลุค \"แสงดาว\" ที่เห็นแค่คุณ แพ็กเวลาจะใช้หลังจากใช้ครบ 20 ครั้งต่อวัน การสมัครต่ออายุอัตโนมัติ ยกเลิกได้ทุกเมื่อในการตั้งค่าการสมัครสมาชิกของ Apple หรือ Google และแตะ \"กู้คืนการซื้อ\" บนโทรศัพท์เครื่องใหม่';

  @override
  String get guideS18L7 =>
      'โทรด้วยเสียง: ถ้ามีเวลาโทร เปิดไอย่าแล้วจะต่อสายเสียงทันที คุยด้วยเสียงเหมือนโทรศัพท์ และพูดแทรกได้ทุกเมื่อ ระหว่างโทร ด้านขวาของช่องพิมพ์มีปุ่มปิดเสียงและ ✕ วางสาย แพ็กเวลาโทรมี 30, 60 และ 180 นาที ไม่มีวันหมดอายุ และหักตามจำนวนวินาทีที่โทรจริง เพื่อนไอย่ายังได้ฟรีเดือนละ 60 นาที (ใช้ได้เฉพาะเดือนนั้น ไม่สะสม) ถ้าไม่มีเวลาโทร ก็คุยด้วยข้อความก่อนได้ การโทรครั้งแรกต้องยินยอมแยกต่างหาก และเสียงจะประมวลผลโดย OpenAI ไอย่าจะวางสายเองเมื่อไม่ได้ยินเสียง 3 นาที และแต่ละสายนานสุด 60 นาที';

  @override
  String get mapConsentTitle => 'แสดงตำแหน่งของคุณบนแผนที่ไหม?';

  @override
  String get mapConsentBody =>
      'ถ้าคุณอนุญาต ทุกครั้งที่คุณแตะ \"เช็กอิน\" (หรือ \"เข้า\" ในโลกควอนตัม) ด้วยตัวเอง ผู้ใช้คนอื่นจะเห็นจุดที่คุณเช็กอิน (ไม่ใช่ตำแหน่งแบบเรียลไทม์) ชื่อเล่น และอารมณ์ของคุณบนแผนที่ ไม่มีการเช็กอินอัตโนมัติ และคุณจะหายไปจากแผนที่เมื่อออกจากแอป คุณปฏิเสธได้ และปิดได้ทุกเมื่อในการตั้งค่า';

  @override
  String get mapConsentAllow => 'อนุญาต';

  @override
  String get mapConsentDecline => 'ไม่อนุญาต';

  @override
  String get mapConsentDeclined =>
      'ได้เลย คุณจะไม่ปรากฏบนแผนที่ของใคร อยากเช็กอินเมื่อไหร่ก็แตะอีกครั้ง';

  @override
  String get mapConsentSetting => 'แสดงตำแหน่งของฉันบนแผนที่';

  @override
  String get mapConsentSettingSubtitle =>
      'ปิดแล้วการเช็กอินจะจบทันที และคุณจะไม่ปรากฏบนแผนที่ของใคร';

  @override
  String get wgErrInGroup => 'คุณอยู่ในกลุ่มหนึ่งแล้ว ออกจากกลุ่มก่อน';

  @override
  String get wgErrFull =>
      'กลุ่มนี้มีครบ 20 คนแล้ว ขอให้หัวหน้าซื้อแพ็กเกจ 7 วัน';

  @override
  String get wgErrPaidFull => 'กลุ่มนี้เต็มแล้ว (100 คน)';

  @override
  String get wgErrQr => 'QR code นี้ถูกเปลี่ยนแล้ว ขอใหม่จากหัวหน้า';

  @override
  String get wgErrEnded => 'กลุ่มนี้สิ้นสุดแล้วหรือไม่มีอยู่';

  @override
  String get wgErrFiltered => 'มีคำที่ไม่อนุญาต โปรดแก้ไข';

  @override
  String get wgErrHostLeave => 'หัวหน้าออกไม่ได้ ส่งต่อหรือยุบกลุ่มก่อน';

  @override
  String get wgErrBusy => 'เชื่อมต่อไม่ได้ ลองอีกครั้ง';

  @override
  String get wgErrName => 'ตั้งชื่อกลุ่มของคุณ';

  @override
  String get wgPassUnavailable => 'ร้านค้ายังใช้งานไม่ได้';

  @override
  String get wgPassFailed => 'การซื้อไม่สำเร็จ';

  @override
  String get wgPassDone => 'เปิดแพ็กเกจ 7 วันแล้ว กลุ่มมีได้สูงสุด 100 คน';

  @override
  String get wgCreateTitle => 'สร้างกลุ่ม';

  @override
  String get wgCreateBody => 'กลุ่มส่วนตัว: เข้าได้เฉพาะคนที่มี QR code ของคุณ';

  @override
  String get wgNameLabel => 'ชื่อกลุ่ม';

  @override
  String get wgColorLabel => 'สีกลุ่ม';

  @override
  String wgDaysLabel(int n) {
    return '$n วัน รวมวันนี้';
  }

  @override
  String get wgFreeNote =>
      'ฟรีถึง 20 คน ถ้ามากกว่านั้น หัวหน้าซื้อแพ็กเกจ 7 วัน (สูงสุด 100 คน)';

  @override
  String get wgCreateButton => 'สร้าง';

  @override
  String wgJoined(String name, int no) {
    return 'เข้าร่วม \"$name\" แล้ว คุณคือหมายเลข $no';
  }

  @override
  String get wgJoinTitle => 'เข้าร่วมกลุ่ม';

  @override
  String get wgJoinBody => 'สแกน QR code ของหัวหน้าด้วยกล้อง หรือใส่รหัส 8 ตัว';

  @override
  String get wgJoinButton => 'เข้าร่วม';

  @override
  String wgButtonLabel(String name) {
    return 'กลุ่ม $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit คน';
  }

  @override
  String wgUntil(String date) {
    return 'ถึง $date';
  }

  @override
  String wgMyNo(int n) {
    return 'ฉันหมายเลข $n';
  }

  @override
  String get wgCallButton => 'เรียกรวมตัว';

  @override
  String get wgCallDone => 'ครบแล้ว จบการรวมตัว';

  @override
  String get wgRollButton => 'เช็กชื่อ';

  @override
  String wgRollSummary(int here, int total) {
    return 'เช็กชื่อ: มาแล้ว $here/$total';
  }

  @override
  String wgMembersTitle(int n) {
    return 'สมาชิก $n คน (แตะเพื่อบันทึก ส่งต่อ หรือนำออก)';
  }

  @override
  String get wgNoMembers => 'ยังไม่มีสมาชิก แตะ \"QR code\" ให้ทุกคนสแกน';

  @override
  String get wgQrButton => 'QR code';

  @override
  String get wgDissolveAsk =>
      'ยุบกลุ่มนี้ไหม ทุกคนจะได้รับแจ้งและข้อมูลจะถูกลบ';

  @override
  String get wgDissolve => 'ยุบกลุ่ม';

  @override
  String wgCallIn(int n) {
    return 'รวมตัวในอีก $n นาที';
  }

  @override
  String get wgCallNow => 'รวมตัวตอนนี้';

  @override
  String wgAckSummary(int acked, int total) {
    return 'รับทราบ $acked/$total';
  }

  @override
  String get wgAnswerHere => 'ฉันมาถึงแล้ว';

  @override
  String get wgAnswer5min => 'อีก 5 นาที';

  @override
  String get wgAnswerHelp => 'ต้องการความช่วยเหลือ';

  @override
  String get wgNoReply => 'ยังไม่ตอบ';

  @override
  String get wgStateAck => 'รับทราบ';

  @override
  String get wgStateSeen => 'อ่านแล้ว';

  @override
  String get wgStateNone => 'ไม่มีการตอบสนอง';

  @override
  String get wgPassTitle => 'แพ็กเกจกลุ่ม 7 วัน';

  @override
  String get wgPassBody =>
      'ฟรีถึง 20 คน เมื่อซื้อแล้วกลุ่มนี้มีได้สูงสุด 100 คนจนกว่าจะสิ้นสุด ซื้อครั้งเดียวใช้กับกลุ่มนี้เท่านั้น ไม่ต่ออายุอัตโนมัติ';

  @override
  String get wgPassButton => 'ซื้อแพ็กเกจ 7 วัน';

  @override
  String wgHostIs(String name) {
    return 'หัวหน้า: $name';
  }

  @override
  String get wgNoCall =>
      'ตอนนี้ยังไม่มีการเรียกรวมตัว เมื่อหัวหน้าเรียก โทรศัพท์จะดัง';

  @override
  String get wgRollAsk => 'หัวหน้ากำลังเช็กชื่อ';

  @override
  String get wgLeaveAsk => 'ออกจากกลุ่มนี้ไหม';

  @override
  String get wgLeave => 'ออกจากกลุ่ม';

  @override
  String get wgCallTitle => 'รวมตัว!';

  @override
  String get wgAcked => '✓ แจ้งหัวหน้าแล้วว่าคุณรับทราบ';

  @override
  String get wgAckButton => 'รับทราบ';

  @override
  String get wgCallSheetTitle => 'เรียกรวมตัว';

  @override
  String get wgNow => 'ตอนนี้';

  @override
  String wgInMinutes(int n) {
    return 'อีก $n นาที';
  }

  @override
  String get wgPlaceLabel => 'จุดนัดพบ';

  @override
  String get wgPlaceHint => 'เช่น ทางออก 6 สถานี Ximen';

  @override
  String get wgPlaceNote => 'จุดนัดพบจะตั้งที่ตำแหน่งปัจจุบันของคุณ';

  @override
  String get wgSendCall => 'ส่งการเรียก';

  @override
  String get wgNoLocation => 'หาตำแหน่งไม่ได้ ตั้งจุดนัดพบไม่ได้';

  @override
  String get wgQrTitle => 'สแกนเพื่อเข้าร่วม';

  @override
  String get wgQrBody => 'สแกนด้วยกล้อง หรือใส่รหัสด้านล่าง';

  @override
  String wgShareText(String name, String url) {
    return 'เข้าร่วมกลุ่ม \"$name\" ของฉัน: $url';
  }

  @override
  String get wgShare => 'แชร์ลิงก์';

  @override
  String get wgRotateAsk =>
      'เปลี่ยน QR code ไหม รหัสและลิงก์เดิมจะใช้ไม่ได้ทันที';

  @override
  String get wgRotate => 'เปลี่ยน QR code';

  @override
  String wgMemberTitle(int no) {
    return 'หมายเลข $no';
  }

  @override
  String get wgEditNote => 'บันทึก';

  @override
  String get wgHandoff => 'ให้เป็นหัวหน้า';

  @override
  String wgHandoffAsk(int no) {
    return 'ส่งต่อหัวหน้าให้หมายเลข $no ไหม คุณจะเป็นสมาชิก';
  }

  @override
  String get wgKick => 'นำออกจากกลุ่ม';

  @override
  String wgKickAsk(int no) {
    return 'นำหมายเลข $no ออกจากกลุ่มไหม';
  }

  @override
  String get wgNotePrivate => 'มีแค่คุณที่เห็นบันทึก เช่น ชื่อหรือเลขห้อง';

  @override
  String get wgSave => 'บันทึก';

  @override
  String get wgConfirm => 'ยืนยัน';

  @override
  String get wgCancel => 'ยกเลิก';

  @override
  String get wgSettingCreate => 'สร้างกลุ่ม';

  @override
  String get wgSettingCreateSub => 'กลุ่มส่วนตัวสำหรับทริป ทัศนศึกษา เดินป่า';

  @override
  String get wgSettingJoin => 'เข้าร่วมกลุ่ม';

  @override
  String get wgSettingJoinSub => 'ใส่รหัส 8 ตัวจากหัวหน้า';

  @override
  String wgSettingOpen(String name) {
    return 'กลุ่มของฉัน: $name';
  }

  @override
  String get wgChannelName => 'การเรียกรวมกลุ่ม';

  @override
  String get wgChannelDesc => 'เมื่อหัวหน้ากลุ่มเรียกทุกคนมารวมตัว';

  @override
  String get guideS19Title => '15. กลุ่มเสียงกระซิบ';

  @override
  String get guideS19L1 =>
      'กลุ่มเสียงกระซิบเป็นกลุ่มส่วนตัวสำหรับทริป ทัศนศึกษา เดินป่า เที่ยวเล่น หรือทีมงานอีเวนต์ ไปที่การตั้งค่า → การรวมตัว → \"สร้างกลุ่ม\" ตั้งชื่อ เลือกสีและจำนวนวัน (สูงสุด 7 วัน)';

  @override
  String get guideS19L2 =>
      'เข้าร่วม: หัวหน้าแตะปุ่มกลุ่มด้านล่างแผนที่ → \"QR code\" สมาชิกสแกนด้วยกล้องโทรศัพท์แล้วแอปจะเปิดเพื่อเข้าร่วม หรือไปที่การตั้งค่า → การรวมตัว → \"เข้าร่วมกลุ่ม\" แล้วใส่รหัส 8 ตัว คนนอกค้นหาหรือขอเข้าร่วมไม่ได้ และหัวหน้าเปลี่ยน QR code ได้ทุกเมื่อ';

  @override
  String get guideS19L3 =>
      'เรียกรวมตัว: หัวหน้าแตะ \"เรียกรวมตัว\" เลือกเวลาและบอกจุดนัดพบ โทรศัพท์ของสมาชิกจะดังเสียงเฉพาะพร้อมสั่น \"สั้น สั้น ยาว\" ในแอปจะเห็นนับถอยหลัง ระยะทางและทิศทางไปยังจุดนัดพบ และเสาแสงบนแผนที่ ใครยังไม่แตะ \"รับทราบ\" จะถูกเตือนทุกนาที สูงสุด 3 ครั้ง หัวหน้าเห็นว่าใครรับทราบ ใครอ่านแล้ว และใครยังไม่ตอบสนอง';

  @override
  String get guideS19L4 =>
      'เช็กชื่อ: หัวหน้าแตะ \"เช็กชื่อ\" สมาชิกจะได้รับเสียงและการสั่นแบบเดียวกัน แล้วตอบ \"ฉันมาถึงแล้ว\" \"อีก 5 นาที\" หรือ \"ต้องการความช่วยเหลือ\" หัวหน้าไม่เห็นตำแหน่งของสมาชิก เห็นแค่คำตอบ';

  @override
  String get guideS19L5 =>
      'กลุ่มไม่เกิน 20 คนใช้ฟรี ถ้ามากกว่านั้น หัวหน้าซื้อแพ็กเกจ 7 วันได้ มีสมาชิกได้สูงสุด 100 คนจนกว่ากลุ่มจะสิ้นสุด สมาชิกไม่ต้องจ่าย กลุ่มอยู่ได้นานสุด 7 วัน เมื่อสิ้นสุด รายชื่อและข้อมูลจะถูกลบ';

  @override
  String get wgFlagButton => 'ยกธง';

  @override
  String get wgFlagHost => 'หัวหน้า';

  @override
  String get wgFlagHint =>
      'ยกโทรศัพท์ขึ้นให้กลุ่มเห็นคุณท่ามกลางฝูงชน แตะเพื่อปิด';

  @override
  String get wgLostButton => 'ฉันหลงทาง';

  @override
  String get wgFound => 'ฉันเจอกลุ่มแล้ว';

  @override
  String get wgLostSent =>
      'ส่งตำแหน่งให้หัวหน้าแล้ว รออยู่ตรงนั้นหรือเดินไปจุดนัดพบ';

  @override
  String get wgLostTitleAsk => 'ส่งตำแหน่งให้หัวหน้าไหม';

  @override
  String get wgLostAsk =>
      'ตำแหน่งปัจจุบันของคุณจะถูกส่งให้หัวหน้าหนึ่งครั้ง โทรศัพท์ของหัวหน้าจะเตือนและแสดงคุณบนแผนที่ ไม่มีการติดตามต่อเนื่อง ลบอัตโนมัติหลัง 30 นาที แตะ \"ฉันเจอกลุ่มแล้ว\" เพื่อลบเร็วขึ้น';

  @override
  String get wgLostSend => 'ส่งตำแหน่งของฉัน';

  @override
  String wgLostTitle(int n) {
    return 'สมาชิกหลงทาง $n คน';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n นาทีที่แล้ว';
  }

  @override
  String get wgNavigate => 'นำทาง';

  @override
  String get wgFoundThem => 'เจอแล้ว';

  @override
  String get guideS19L6 =>
      'ตามหากัน: ในฝูงชน แตะ \"ยกธง\" แล้วหน้าจอทั้งหมดจะกะพริบเป็นสีกลุ่มพร้อมหมายเลขของคุณ ถ้าพลัดหลงจริง สมาชิกแตะ \"ฉันหลงทาง\" เพื่อส่งตำแหน่งปัจจุบันให้หัวหน้าหนึ่งครั้ง (ลบหลัง 30 นาที) โทรศัพท์หัวหน้าจะเตือน มีหมุดสีแดงบนแผนที่ และนำทางไปได้ทันที';

  @override
  String wgLostAlert(int no) {
    return 'หมายเลข $no หลงทาง';
  }

  @override
  String wgHelpAlert(String no) {
    return 'หมายเลข $no ต้องการความช่วยเหลือ';
  }

  @override
  String get wgViewList => 'เปิดกลุ่ม';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour นาฬิกาแล้ว ใครยังไม่นอน ฉันอยู่ในแสงข้างๆ คุณนะ';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour นาฬิกา อรุณสวัสดิ์ วันนี้ค่อยๆ ไปนะ';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour นาฬิกาแล้ว คืนนี้เมืองของคุณเป็นยังไงบ้าง';
  }

  @override
  String get aiyaCameoNyReady => 'พร้อมไหม มานับถอยหลังด้วยกัน!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'สวัสดีปีใหม่! $year พวกเราอยู่ในห้องเดียวกัน';
  }

  @override
  String get aiyaSkinEntry => '✦ ลุค';

  @override
  String get aiyaSkinTitle => 'ลุคของไอยา';

  @override
  String get aiyaSkinSubtitle => 'มีแค่คุณที่เห็นลุคของไอยา';

  @override
  String get aiyaSkinNone => 'แบบเดิม';

  @override
  String get aiyaSkinStarlight => 'แสงดาว';

  @override
  String get aiyaSkinStarlightSub => 'สำหรับเพื่อนของไอยา';

  @override
  String get aiyaSkinXmas => 'คริสต์มาส';

  @override
  String get aiyaSkinNewYear => 'ปีใหม่ควอนตัม';

  @override
  String get aiyaSkinNote =>
      'ลุคเทศกาลซื้อครั้งเดียวใช้ได้ตลอด เปลี่ยนแค่หน้าตาของไอยา ไม่กระทบจำนวนแชต รุ่นลิมิเต็ดจะไม่ขายอีกหลังหมดช่วงขาย';

  @override
  String get orbStyleStarTrail => 'วงโคจรดาว';

  @override
  String get orbStyleRings => 'วงปี';

  @override
  String get orbGrowNote =>
      'ลูกแก้วที่โตได้: วงโคจรดาวได้ดาวเพิ่ม 1 ดวงทุกครั้งที่ทำการ์ดพบกันควอนตัมสำเร็จ (คนเดิมนับครั้งเดียวใน 24 ชั่วโมง สูงสุด 24 ดวง) วงปีเพิ่ม 1 วงทุกครั้งที่อยู่ในโลกควอนตัมครบ 3 ชั่วโมง (สูงสุด 12 วง) บันทึกไว้กับบัญชีและเริ่มนับตั้งแต่ตอนนี้ เก็บแค่จำนวน ไม่เก็บว่าเป็นใครหรือที่ไหน';

  @override
  String orbGrowStars(int count) {
    return 'สะสมแล้ว $count ดวง';
  }

  @override
  String orbGrowRings(int count) {
    return 'สะสมแล้ว $count วง';
  }

  @override
  String get giftAction => 'ส่งของขวัญ';

  @override
  String giftSheetTitle(String name) {
    return 'ส่งของขวัญให้ $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'เลือกลูกแก้วแสงให้ $name';
  }

  @override
  String get giftBouquetName => 'ช่อดอกไม้แห่งแสง';

  @override
  String get giftBouquetDesc =>
      'เมื่อรับจะมีแสงบานขึ้น แล้วกลีบดอกแสงจะวนรอบลูกแก้ว 24 ชั่วโมง';

  @override
  String get giftOrbName => 'ส่งลูกแก้วแสง';

  @override
  String get giftOrbDesc => 'คุณเลือก เมื่อรับแล้วเป็นของเขาตลอดไป';

  @override
  String get giftPairName => 'คู่พัวพัน';

  @override
  String get giftPairDesc =>
      'ลูกแก้วคู่คนละลูก เมื่ออยู่ในโลกควอนตัมพร้อมกันจะมีเชือกแสงเชื่อมกัน';

  @override
  String get giftPairYouHave => 'คุณมีคู่พัวพันแล้ว';

  @override
  String get giftNote =>
      'เขารับหรือปฏิเสธได้ ถ้าปฏิเสธหรือไม่ตอบใน 7 วัน ของขวัญจะกลับมาหาคุณ';

  @override
  String get giftVouchersTitle => 'ของขวัญที่ถูกส่งคืน (ไม่ต้องจ่ายเพิ่ม)';

  @override
  String get giftSendVoucher => 'ส่ง';

  @override
  String giftSent(String name) {
    return 'ส่งของขวัญให้ $name แล้ว รอเขารับ';
  }

  @override
  String get giftReturnedOff => 'เขาปิดรับของขวัญ ของขวัญกลับมาหาคุณแล้ว';

  @override
  String get giftReturnedBlocked => 'ส่งให้คนนี้ไม่ได้ ของขวัญกลับมาหาคุณแล้ว';

  @override
  String get giftReturnedOwned =>
      'เขามีลูกแก้วนี้แล้ว ของขวัญกลับมา ส่งแบบอื่นได้';

  @override
  String get giftReturnedPaired => 'เขามีคู่พัวพันแล้ว ของขวัญกลับมาหาคุณ';

  @override
  String get giftReturnedYouPaired => 'คุณมีคู่พัวพันแล้ว ของขวัญกลับมา';

  @override
  String get giftReturnedGeneric => 'ของขวัญกลับมาแล้ว ส่งให้คนอื่นได้';

  @override
  String get giftStoreUnavailable => 'ตอนนี้ร้านค้าใช้ไม่ได้';

  @override
  String get giftFailed => 'ส่งของขวัญไม่สำเร็จ ลองใหม่ภายหลัง';

  @override
  String giftFromBouquet(String name) {
    return '$name ส่งช่อดอกไม้แห่งแสงให้คุณ';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name ส่งลูกแก้ว \"$style\" ให้คุณ';
  }

  @override
  String giftFromPair(String name) {
    return '$name อยากเป็นคู่พัวพันกับคุณ';
  }

  @override
  String get giftInboxTitle => 'ของขวัญที่ได้รับ';

  @override
  String get giftInboxEmpty => 'ยังไม่มีของขวัญ';

  @override
  String get giftInboxNote =>
      'ของขวัญที่ปฏิเสธจะกลับไปหาผู้ส่ง ไม่ตอบใน 7 วันก็จะกลับไปเอง';

  @override
  String get giftAccept => 'รับ';

  @override
  String get giftDecline => 'ปฏิเสธ';

  @override
  String get giftDeclined => 'ปฏิเสธแล้ว ของขวัญจะกลับไปหาผู้ส่ง';

  @override
  String get giftAcceptedOrb => 'รับแล้ว! เปลี่ยนได้ที่อวาตาร์ควอนตัม';

  @override
  String giftAcceptedPair(String name) {
    return 'คุณกับ $name เป็นคู่พัวพันแล้ว';
  }

  @override
  String get giftAcceptedBouquet =>
      'รับช่อดอกไม้แล้ว กลีบดอกแสงจะวนรอบลูกแก้วของคุณ 24 ชั่วโมง';

  @override
  String get giftAlreadyOwned => 'คุณมีลูกแก้วนี้แล้ว ของขวัญกลับไปหาผู้ส่ง';

  @override
  String get giftAlreadyPaired => 'มีคนหนึ่งมีคู่แล้ว ของขวัญกลับไปหาผู้ส่ง';

  @override
  String get giftSettingsTitle => 'ของขวัญ';

  @override
  String get giftReceiveToggle => 'รับของขวัญ';

  @override
  String get giftReceiveToggleSub => 'ถ้าปิด ของขวัญจะกลับไปหาผู้ส่งทันที';

  @override
  String get giftVouchersHint =>
      'แตะ \"ส่งของขวัญ\" ที่เมนูของใครสักคนเพื่อส่งอีกครั้ง';

  @override
  String get giftUnpair => 'ยกเลิกคู่พัวพัน';

  @override
  String giftUnpairConfirm(String name) {
    return 'ยกเลิกคู่กับ $name ไหม ทั้งสองยังมีลูกแก้ว แต่เชือกแสงจะหายไป';
  }

  @override
  String get orbStylePair => 'พัวพัน';

  @override
  String giftPairedWith(String name) {
    return 'คู่กับ $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'ของขวัญที่ได้รับ ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return 'ของขวัญที่ส่งคืน $count ชิ้น';
  }

  @override
  String get giftBlockedOff => 'เขาปิดรับของขวัญ คุณยังไม่ถูกเรียกเก็บเงิน';

  @override
  String get giftBlockedBlocked =>
      'ส่งของขวัญให้คนนี้ไม่ได้ คุณยังไม่ถูกเรียกเก็บเงิน';

  @override
  String get giftBlockedOwned =>
      'เขามีลูกแก้วนี้แล้ว เลือกแบบอื่นนะ (ยังไม่ถูกเรียกเก็บเงิน)';

  @override
  String get giftBlockedPaired =>
      'เขามีคู่พัวพันแล้ว คุณยังไม่ถูกเรียกเก็บเงิน';

  @override
  String get orbStyleValentine => 'วาเลนไทน์';

  @override
  String get orbStyleSakura => 'ซากุระ';

  @override
  String get parallelCoords => 'พิกัดคู่ขนาน';

  @override
  String parallelCoordsHome(String city, String km) {
    return 'ห่างจากใจกลาง$city $km กม.';
  }

  @override
  String parallelCoordsIn(String city) {
    return 'ใน$city คุณยืนอยู่แถว';
  }

  @override
  String get parallelCoordsSea => 'กลางทะเล หรือที่ที่ไม่มีชื่อ';

  @override
  String get parallelCoordsOutside => 'นอกเขตเมืองนี้';

  @override
  String parallelCoordsNote(String city) {
    return 'เมื่อคนใน$cityเปิดจักรวาลคู่ขนาน พวกเขาจะเห็นคุณแถวนี้ (เบลอประมาณ 500 ม.)';
  }

  @override
  String get parallelCoordsFailed => 'ยังหาชื่อสถานที่ไม่เจอ ลองใหม่ภายหลัง';

  @override
  String parallelCardTitle(String city) {
    return 'ตอนนี้ ฉันอยู่ที่$cityในจักรวาลคู่ขนาน';
  }

  @override
  String parallelCardShareText(String city) {
    return 'ตอนนี้ ฉันอยู่ที่$cityในจักรวาลคู่ขนาน เปิด Mood Whisper แล้วไปอีกเมืองด้วยกัน';
  }

  @override
  String get parallelCoordsShare => 'แชร์การ์ด';

  @override
  String get orbStylePassport => 'พาสปอร์ต';

  @override
  String get passportTitle => 'พาสปอร์ตคู่ขนาน';

  @override
  String passportCount(int count) {
    return 'สะสมแล้ว $count เมือง';
  }

  @override
  String passportRewardProgress(int count) {
    return 'สะสมอีก $count เมือง เพื่อรับลูกแก้วพาสปอร์ต';
  }

  @override
  String get passportRewardDone =>
      'คุณได้ลูกแก้วพาสปอร์ตแล้ว ใส่ได้ในอวตารควอนตัม';

  @override
  String get passportRewardToast => 'ครบ 5 เมือง! คุณได้ลูกแก้วพาสปอร์ต';

  @override
  String get passportEmpty =>
      'แชตกับคนจากเมืองอื่นในจักรวาลคู่ขนาน เมื่อทั้งสองฝ่ายได้พูดกันแล้ว เมืองนั้นจะถูกประทับตราในพาสปอร์ต เก็บแค่เมืองกับวันที่ ไม่เก็บว่าคุยกับใคร';

  @override
  String passportNewStamp(String city) {
    return 'ตราใหม่: $city';
  }

  @override
  String get passportShare => 'แชร์พาสปอร์ต';

  @override
  String passportCardTitle(int count) {
    return 'พาสปอร์ตคู่ขนานของฉัน\n$count เมือง';
  }

  @override
  String passportCardShareText(int count) {
    return 'พาสปอร์ตคู่ขนานของฉันมีตราจาก $count เมืองแล้ว เปิด Mood Whisper แล้วไปจักรวาลคู่ขนานด้วยกัน';
  }

  @override
  String get asmTitle => 'การรวมตัวควอนตัม';

  @override
  String get asmCreateTitle => 'จัดการรวมตัวควอนตัม';

  @override
  String get asmCreateIntro =>
      'คุณจะนั่งที่นั่งผู้จัดวงที่ 3 ข้างตึก 101 ทุกคนในโลกควอนตัมจะเห็นวงแสงของการรวมตัว และเลือกเข้าร่วมได้';

  @override
  String get asmTitleHint => 'หัวข้อ (เช่น ดูฝนดาวตกด้วยกัน)';

  @override
  String get asmPlanFree => 'ฟรีเดือนนี้';

  @override
  String get asmPlanFreeSub => '30 นาที · ไม่เกิน 50 คน · เดือนละครั้ง';

  @override
  String get asmPlanFreeUsed => 'คุณใช้สิทธิ์ฟรีของเดือนนี้ไปแล้ว';

  @override
  String get asmPlan1h => '1 ชั่วโมง';

  @override
  String get asmPlan1hSub => 'ไม่เกิน 200 คน';

  @override
  String get asmPlan2h => '2 ชั่วโมง';

  @override
  String get asmPlan2hSub => 'ไม่เกิน 1,000 คน';

  @override
  String asmVoucherCount(int count) {
    return 'มีบัตรผู้จัด $count ใบ';
  }

  @override
  String get asmExtendTitle => 'ต่อเวลาการชุมนุม';

  @override
  String get asmExtendHint =>
      'ใช้บัตรผู้จัดเพื่อต่อเวลา สูงสุด 12 ชั่วโมงต่อครั้ง';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours ชม. · $price';
  }

  @override
  String get asmExtended => 'ต่อเวลาการชุมนุมแล้ว';

  @override
  String get asmEndingSoon =>
      'การชุมนุมของคุณเหลือไม่ถึง 10 นาที ต่อเวลาได้ที่การ์ดการชุมนุม';

  @override
  String get asmErrTooLong => 'การชุมนุมยาวได้สูงสุด 12 ชั่วโมง';

  @override
  String get asmBuyMore => 'ซื้อบัตรเพิ่ม';

  @override
  String get asmBuyMoreHint => 'ซื้อไว้ก่อน ใช้เปิดหรือต่อเวลาได้ทันที';

  @override
  String get asmRules =>
      'บัตรผู้จัด 1 ใบใช้เปิดการชุมนุม 1 ครั้ง หรือต่อเวลาการชุมนุมที่กำลังดำเนินอยู่ เวลาที่ไม่ได้ใช้ไม่คืนเงิน หัวข้อและประกาศจะถูกกรอง การละเมิดจะถูกระงับการใช้งาน';

  @override
  String get asmStart => 'เริ่มการรวมตัว';

  @override
  String get asmStarted => 'การรวมตัวเริ่มแล้ว!';

  @override
  String get asmVoucherReady => 'บัตรผู้จัดพร้อมแล้ว';

  @override
  String get asmBuyFailed =>
      'การซื้อไม่สำเร็จ ยังไม่มีการเรียกเก็บเงิน หรือจะได้รับภายหลัง';

  @override
  String asmHostLine(String name, String code) {
    return 'ผู้จัด $name · ⬡ $code';
  }

  @override
  String get asmJoin => 'เข้าร่วม';

  @override
  String get asmJoined => 'คุณเข้าร่วมแล้ว';

  @override
  String get asmLeave => 'ออก';

  @override
  String get asmHostPanel => 'แผงควบคุมผู้จัด';

  @override
  String get asmAnnounceHint => 'ส่งประกาศ (ไม่เกิน 100 ตัวอักษร)';

  @override
  String get asmAnnounceSend => 'ส่ง';

  @override
  String get asmAnnounced => 'ส่งประกาศแล้ว';

  @override
  String get asmCheerTitle =>
      'เชียร์ควอนตัม: เลือกสีและนับถอยหลัง ลูกแก้วของผู้เข้าร่วมทุกคนจะสว่างพร้อมกัน';

  @override
  String get asmCheerNow => 'ทันที';

  @override
  String asmCheerIn(int n) {
    return 'อีก $n วิ';
  }

  @override
  String get asmCheer => 'เชียร์!';

  @override
  String get asmRemoveHint =>
      'หากต้องการเชิญใครออก แตะคนนั้นบนแผนที่ → เชิญออกจากการรวมตัว';

  @override
  String get asmEnd => 'จบการรวมตัว';

  @override
  String get asmReport => 'รายงานการรวมตัวนี้';

  @override
  String get asmErrFreeUsed => 'คุณใช้สิทธิ์ฟรีของเดือนนี้ไปแล้ว';

  @override
  String get asmErrSeatsFull => 'ที่นั่งผู้จัดวงที่ 3 เต็มแล้ว ลองใหม่ภายหลัง';

  @override
  String get asmErrBlocked => 'หัวข้อหรือประกาศมีเนื้อหาไม่เหมาะสม';

  @override
  String get asmErrFull => 'การรวมตัวเต็มแล้ว';

  @override
  String get asmErrRemoved => 'คุณถูกเชิญออกจากการรวมตัวนี้';

  @override
  String get asmErrEnded => 'การรวมตัวนี้จบแล้ว';

  @override
  String get asmErrTooSoon => 'เร็วเกินไป รอสักครู่แล้วลองใหม่';

  @override
  String get asmErrHidden => 'บัญชีของคุณยังจัดการรวมตัวไม่ได้ในตอนนี้';

  @override
  String get asmErrHosting => 'คุณกำลังจัดการรวมตัวอื่นอยู่';

  @override
  String get asmErrGeneric => 'เกิดข้อผิดพลาด ลองใหม่ภายหลัง';

  @override
  String get asmMemorialEyebrow => 'การ์ดที่ระลึกการรวมตัวควอนตัม';

  @override
  String get asmMemorialUnit => 'คน';

  @override
  String get asmMemorialTogether => 'อยู่ด้วยกันในโลกควอนตัม';

  @override
  String shareCardFindUs(String name) {
    return 'ค้นหา “$name” ใน App Store';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'ค้นหา “$name” ใน Google Play';
  }

  @override
  String get asmShareCard => 'แชร์การ์ดที่ระลึก';

  @override
  String asmShareText(String title, int count) {
    return 'เราจัด \"$title\" ในโลกควอนตัม มีผู้เข้าร่วม $count คน เปิด Mood Whisper แล้วมาด้วยกันครั้งหน้า';
  }

  @override
  String get asmOpenEntry => 'จัดการรวมตัวควอนตัม';

  @override
  String get asmOpenEntrySub =>
      'นั่งที่นั่งผู้จัดข้างตึก 101 แล้วจัดการรวมตัวที่ใครทั่วโลกก็เข้าร่วมได้';

  @override
  String get asmRemoveMember => 'เชิญออกจากการรวมตัว';

  @override
  String get asmRemovedDone => 'เชิญออกจากการรวมตัวแล้ว';

  @override
  String get aiyaFriendPerk5 => 'โทรคุยกับไอย่าได้เดือนละ 60 นาที';

  @override
  String get aiyaVoiceOn => 'อ่านออกเสียง: เปิด';

  @override
  String get aiyaVoiceOff => 'อ่านออกเสียง: ปิด';

  @override
  String get aiyaVoiceFriendOnly => 'การอ่านออกเสียงสำหรับเพื่อนไอย่า';

  @override
  String get aiyaVoiceDailyMax =>
      'วันนี้ใช้การอ่านออกเสียงหมดแล้ว พรุ่งนี้มาฟังเสียงไอย่าใหม่นะ';

  @override
  String get aiyaCallTooltip => 'โทรคุยกับไอย่า';

  @override
  String get aiyaCallConsentTitle => 'โทรคุยกับไอย่า';

  @override
  String get aiyaCallConsentBody =>
      'ระหว่างโทร เสียงของคุณจะถูกส่งแบบเรียลไทม์ไปยัง OpenAI (สหรัฐฯ) เพื่อให้ AI ประมวลผลและตอบ โดยไม่ส่งตัวตน ชื่อเล่น หรือตำแหน่งของคุณ เราไม่บันทึกเสียงและไม่เก็บเนื้อหาการโทร ไอย่าเป็น AI คำตอบอาจผิดพลาดและไม่ใช่คำแนะนำจากผู้เชี่ยวชาญ';

  @override
  String get aiyaCallAgree => 'ยอมรับและโทร';

  @override
  String get aiyaCallConnecting => 'กำลังเชื่อมต่อ…';

  @override
  String aiyaCallLive(String time) {
    return 'กำลังโทร · เหลือ $time';
  }

  @override
  String get aiyaHangUp => 'วางสาย';

  @override
  String get aiyaCallEnded => 'จบการโทร';

  @override
  String get aiyaCallTimeUp =>
      'คุยกันมาชั่วโมงหนึ่งแล้ว พักสักหน่อยแล้วโทรหาไอย่าใหม่นะ';

  @override
  String get aiyaCallDailyMax =>
      'วันนี้โทรครบ 2 ครั้งแล้ว พรุ่งนี้โทรหาไอย่าใหม่นะ';

  @override
  String get aiyaCallMonthMax => 'เดือนนี้โทรครบแล้ว เดือนหน้าโทรหาไอย่าใหม่นะ';

  @override
  String get aiyaCallResting =>
      'วันนี้สายเสียงของไอย่ายุ่งมาก ลองใหม่ภายหลังนะ';

  @override
  String get aiyaCallMicDenied =>
      'อนุญาตไมโครโฟนเพื่อโทรหาไอย่า เปิดได้ในการตั้งค่าของโทรศัพท์';

  @override
  String get aiyaCallFailed => 'เชื่อมต่อไม่ได้ โปรดลองใหม่ภายหลัง';

  @override
  String aiyaCallsLeft(int today, int month) {
    return 'วันนี้เหลือ $today ครั้ง · เดือนนี้ $month ครั้ง';
  }

  @override
  String get aiyaCallIdle => 'ไม่มีใครพูดสักพัก จึงวางสายให้แล้ว';

  @override
  String get aiyaCallMute => 'ปิดเสียง';

  @override
  String get aiyaCallUnmute => 'เปิดเสียง';

  @override
  String aiyaCallPurchased(int minutes) {
    return 'เพิ่มเวลาโทร $minutes นาทีแล้ว';
  }

  @override
  String get aiyaCallOutOfTime => 'เวลาโทรหมดแล้ว';

  @override
  String get aiyaCallPacksTitle => 'โทรคุยกับไอย่า';

  @override
  String get aiyaCallPacksBody =>
      'คุยกับไอย่าด้วยเสียงเหมือนโทรศัพท์ ซื้อเวลาโทรแล้วโทรได้เลย เพื่อนไอย่ายังได้ฟรีเดือนละ 60 นาที';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get aiyaCallFriendOption => 'เป็นเพื่อนไอย่า (เดือนละ 60 นาที)';

  @override
  String get aiyaCallTextInstead => 'คุยด้วยข้อความก่อน';

  @override
  String get aiyaCallPackNote =>
      'เวลาโทรไม่มีวันหมดอายุ และหักตามจำนวนวินาทีที่โทรจริง สินค้าแบบใช้แล้วหมดไปกู้คืนไม่ได้';

  @override
  String aiyaCallMinutesLeft(int n) {
    return 'เหลือเวลาโทร $n นาที';
  }
}
