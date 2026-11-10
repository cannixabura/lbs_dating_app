// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get checkInEnter => 'Check-in tại đây và vào';

  @override
  String get checkInNote =>
      'Khi bạn chạm, người ở gần sẽ thấy tâm trạng và vị trí gần đúng của bạn. Mỗi lần vào bạn đều tự check-in.';

  @override
  String get checkInTitle => 'Check-in vào thành phố';

  @override
  String get checkInBody =>
      'Sau khi check-in, người ở gần sẽ thấy tâm trạng và vị trí gần đúng của bạn, và bạn cũng thấy họ. Họ thấy nơi bạn check-in; vị trí này không đi theo bạn khi bạn di chuyển. Mỗi lần mở ứng dụng bạn tự check-in; không bao giờ tự động. Rời đi hoặc chuyển sang ứng dụng khác sẽ kết thúc check-in.';

  @override
  String get checkInButton => 'Check-in tại đây';

  @override
  String get checkInAgain => 'Bạn đã rời nơi check-in · Check-in tại đây';

  @override
  String get checkOutButton => 'Đang check-in · Kết thúc';

  @override
  String get checkedOutToast =>
      'Đã kết thúc check-in. Bạn không còn hiện trên bản đồ.';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Vui';

  @override
  String get moodSad => 'Buồn';

  @override
  String get moodAngry => 'Giận';

  @override
  String get moodCalm => 'Bình yên';

  @override
  String get moodPassion => 'Nhiệt huyết';

  @override
  String get moodLove => 'Yêu';

  @override
  String get moodOther => 'Khác';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name đã kết thúc';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'Bạn đã trao lại $emoji $name và giờ là người tham gia.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'Bạn đã trao lại buổi tụ họp. Biệt danh của bạn đã đủ 10 ký tự, hãy tự thêm $emoji vào để tiếp tục nhận thông báo.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'Bạn đã trao lại buổi tụ họp. Chúng tôi đã thêm $emoji vào biệt danh, giờ bạn là người tham gia.';
  }

  @override
  String get gotIt => 'Đã hiểu';

  @override
  String get blockedToast => 'Người này đã chìm vào bóng tối.';

  @override
  String get unblockedToast => 'Đã bỏ chặn. Hai bạn có thể gặp lại nhau.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Hãy bật Dịch vụ định vị';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper cần biết bạn đang ở góc nào của thành phố để người gần đó thấy tâm trạng của bạn. Hãy bật Dịch vụ định vị trong Cài đặt của điện thoại.';

  @override
  String get locationReducedTitle => 'Hãy bật Vị trí chính xác';

  @override
  String get locationReducedBodyIos =>
      'Bạn chỉ đang chia sẻ vị trí gần đúng nên radar không biết ai ở gần bạn. Vào Cài đặt › Mood Whisper › Vị trí và bật Vị trí chính xác.';

  @override
  String get locationReducedBodyAndroid =>
      'Bạn chỉ đang chia sẻ vị trí gần đúng nên radar không biết ai ở gần bạn. Hãy chọn Chính xác trong quyền truy cập vị trí.';

  @override
  String get locationNoFixTitle => 'Chưa tìm được vị trí của bạn';

  @override
  String get locationNoFixBody =>
      'Có thể bạn đang ở trong nhà hoặc sóng yếu. Hãy ra gần cửa sổ hoặc ra ngoài, bật Wi-Fi rồi thử lại.';

  @override
  String get locationNeededTitle => 'Mood Whisper cần vị trí của bạn';

  @override
  String get locationNeededBody =>
      'Mood Whisper chỉ dùng vị trí khi bạn đang dùng ứng dụng, để hiện tâm trạng trong bán kính 5 km. Radar chỉ hiện khoảng cách gần đúng, không bao giờ hiện địa chỉ.\nTrong Cài đặt, hãy cho phép vị trí Khi dùng ứng dụng và bật Vị trí chính xác.';

  @override
  String get locationSimulatorHint =>
      '(Ghi chú cho nhà phát triển: trong Simulator, chọn vị trí ở Features › Location)';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get locationRecheck => 'Tôi đã bật, kiểm tra lại';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get leaveApp => 'Rời đi';

  @override
  String whispersNearby(int count) {
    return 'Có $count lời thì thầm gần bạn. Chạm vào phong bì để đọc.';
  }

  @override
  String get whisperPassed =>
      'Bạn vừa đi ngang một lời thì thầm. Chạm vào phong bì để đọc.';

  @override
  String get whisperLeft =>
      'Lời thì thầm của bạn đã ở lại đây. Nó sẽ tan sau 7 ngày.';

  @override
  String get timeWhisperSealedYear =>
      'Đã niêm phong. Quay lại đây sau một năm để mở.';

  @override
  String get timeWhisperSealedMonth =>
      'Đã niêm phong. Quay lại đây sau một tháng để mở.';

  @override
  String get whisperWithdrawn => 'Đã thu hồi lời thì thầm.';

  @override
  String get whisperMineLabel => 'Lời thì thầm bạn để lại';

  @override
  String get whisperTapToRead => 'Một lời thì thầm. Chạm để đọc';

  @override
  String get noMoodYet => 'Không nói nên lời…';

  @override
  String get knockWithdrawnByLeaving =>
      'Họ đã lẫn vào thành phố và lặng lẽ rút lại tiếng gõ cửa…';

  @override
  String get knockCardTitle => 'Khoảnh khắc giao nhau';

  @override
  String knockCardBody(String name) {
    return '$name đang gõ cửa,\nmong được gặp bạn…';
  }

  @override
  String get skip => 'Bỏ qua';

  @override
  String get decline => 'Từ chối';

  @override
  String get accept => 'Đồng ý';

  @override
  String get reportThisPerson => 'Báo cáo người này';

  @override
  String get cityQuietTonight => 'Thành phố đêm nay còn yên ắng';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'Thành phố đêm nay · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. Xem thời tiết tâm trạng của thành phố';
  }

  @override
  String get cityMoodTitle => 'Tâm trạng thành phố đêm nay';

  @override
  String cityMoodQuietCount(int total) {
    return 'Thành phố còn yên ắng. Đêm nay có $total người đã chia sẻ tâm trạng.';
  }

  @override
  String cityMoodCount(int total) {
    return 'Đêm nay có $total người trong bán kính 20 km đã chia sẻ tâm trạng';
  }

  @override
  String get cityMoodQuietInvite =>
      'Mỗi tâm trạng thêm một chút ánh sáng. Hãy viết cảm xúc lúc này và cùng thắp sáng thành phố.';

  @override
  String get cityMoodFootnote =>
      'Tâm trạng ẩn danh trong 24 giờ qua. Không hiện tỷ lệ khi có ít hơn 10 người.';

  @override
  String get close => 'Đóng';

  @override
  String get emptyRadarTitle => 'Bạn là ánh sáng đầu tiên đêm nay';

  @override
  String get emptyRadarBody =>
      'Chưa có ai ở gần. Tâm trạng của bạn đã sáng lên giữa thành phố,\nai đi ngang sẽ thấy bạn. Bạn cũng có thể để lại lời thì thầm cho người kế tiếp đi qua đây.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return 'Đêm nay có $total người trong thành phố, phần lớn cảm thấy “$mood”';
  }

  @override
  String get inviteFriends => 'Rủ bạn bè thắp sáng khu phố';

  @override
  String get shareMoodCard => 'Chia sẻ thẻ tâm trạng';

  @override
  String get editYourMood => 'Sửa tâm trạng';

  @override
  String resonanceTonight(int count) {
    return 'Đêm nay có $count đốm sáng đồng cảm với bạn';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · tâm trạng của bạn';
  }

  @override
  String get dockTapToEdit => 'Tâm trạng của bạn · chạm để sửa';

  @override
  String get leaveWhisper => 'Để lại lời thì thầm';

  @override
  String get settings => 'Cài đặt';

  @override
  String get nightlyReminder => 'Nhắc nhở mỗi tối';

  @override
  String get nightlyReminderSubtitle =>
      'Một lời nhắc nhẹ nhàng lúc 21:30 mỗi tối';

  @override
  String get closeSettings => 'Đóng cài đặt';

  @override
  String get settingsSectionMe => 'Tôi';

  @override
  String get editProfile => 'Sửa hồ sơ';

  @override
  String get editProfileSubtitle => 'Ảnh, biệt danh và tâm trạng';

  @override
  String get manageBlockList => 'Người đã chặn';

  @override
  String get manageBlockListSubtitle =>
      'Xem hoặc bỏ chặn những người bạn đã gửi vào bóng tối';

  @override
  String get myTimeWhispers => 'Thư gửi tương lai';

  @override
  String get myTimeWhispersSubtitle =>
      'Gửi chính mình trong tương lai, chỉ bạn thấy được';

  @override
  String get myMoodTrail => 'Dấu vết tâm trạng';

  @override
  String get myMoodTrailSubtitle => 'Chỉ lưu trên điện thoại của bạn';

  @override
  String get settingsSectionGatherings => 'Tụ họp';

  @override
  String get gatheringHost => 'Tổ chức buổi tụ họp';

  @override
  String get gatheringHostSubtitle =>
      'Mở một sự kiện trong bán kính 5 km quanh bạn';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'Bạn đang tổ chức $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Chia sẻ';

  @override
  String get shareMoodCardSubtitle =>
      'Một trong mười một tranh đêm ngẫu nhiên, hợp với Instagram Stories';

  @override
  String get inviteFriendsSubtitle =>
      'Càng nhiều người gần đây, thành phố càng sáng';

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get guide => 'Hướng dẫn';

  @override
  String get guideSubtitle => 'Từ viết tâm trạng đến tổ chức buổi tụ họp';

  @override
  String get termsOfUse => 'Điều khoản sử dụng';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get contactUs => 'Liên hệ';

  @override
  String get deleteAccount => 'Xóa tài khoản và dữ liệu';

  @override
  String get deleteAccountSubtitle =>
      'Xóa vĩnh viễn mọi thứ bạn để lại trong thành phố';

  @override
  String get avatarUploadFailed =>
      'Không tải ảnh lên được. Vui lòng thử lại sau.';

  @override
  String get moodEmpty =>
      'Tâm trạng không được để trống. Hãy để lại cho thành phố một chút ánh sáng.';

  @override
  String get profileSyncFailed =>
      'Không cập nhật được trạng thái. Vui lòng thử lại sau.';

  @override
  String get profileUpdated =>
      'Đã cập nhật. Thành phố đang cảm nhận hơi thở của bạn.';

  @override
  String get changeAvatar => 'Đổi ảnh';

  @override
  String get avatarHint =>
      'Chạm để đổi ảnh · vòng sáng là màu tâm trạng của bạn';

  @override
  String get cityName => 'Biệt danh';

  @override
  String get cityNameHint => 'Không bắt buộc, ví dụ: Mèo Lang Thang';

  @override
  String get currentMood => 'Tâm trạng lúc này';

  @override
  String get currentMoodHint => 'Ví dụ: Dạo bước dưới mưa phùn 🌿';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get blockListTitle => 'Đã gửi vào bóng tối';

  @override
  String get blockListEmpty => 'Trời đêm trong vắt. Bạn chưa đẩy ai ra xa.';

  @override
  String get unblock => 'Bỏ chặn';

  @override
  String get deleteAccountBody =>
      'Vị trí, tâm trạng, biệt danh, ảnh, lời thì thầm, đốm sáng, danh sách chặn và các cuộc trò chuyện đang mở sẽ bị xóa vĩnh viễn. Không thể hoàn tác.\n\nĐể chống lạm dụng, hồ sơ báo cáo được lưu 1 năm theo Chính sách quyền riêng tư.';

  @override
  String get deleting => 'Đang xóa…';

  @override
  String get deletePermanently => 'Xóa vĩnh viễn';

  @override
  String get deleteFailed => 'Chưa xóa xong. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get fadingEcho => 'Dư ảnh';

  @override
  String clusterCount(int count) {
    return '$count tâm trạng ở đây';
  }

  @override
  String clusterMore(int count) {
    return 'Thêm\n+$count';
  }

  @override
  String get clusterBackToFirst => 'Về\nđầu tiên';

  @override
  String get fadingEchoTitle => 'Một dư ảnh';

  @override
  String encounterWith(String name) {
    return 'Gặp gỡ $name';
  }

  @override
  String get fadingEchoBody =>
      'Đây chỉ là một dư ảnh đang mờ dần. Bạn không thể giao nhau với nó.';

  @override
  String get demoPersonBody =>
      'Đây là người mẫu tự động trả lời, không phải người thật. Hãy dùng để thử gõ cửa, trò chuyện, đốm sáng, báo cáo và chặn.';

  @override
  String get sendGlimmer => 'Gửi một đốm sáng';

  @override
  String get knock => 'Gõ cửa';

  @override
  String get blockAction => 'Chặn';

  @override
  String get handOverHost => 'Trao quyền tổ chức';

  @override
  String get report => 'Báo cáo';

  @override
  String get confirmBlockTitle => 'Chặn người này?';

  @override
  String confirmBlockBody(String name) {
    return 'Gửi $name vào bóng tối?\nSau khi chặn, hai bạn sẽ biến mất khỏi thành phố của nhau.';
  }

  @override
  String get confirmBlock => 'Chặn';

  @override
  String get glimmerReceived =>
      'Có người gửi bạn một đốm sáng. Tâm trạng của bạn đã chạm đến họ.';

  @override
  String get glimmerSent => 'Bạn đã gửi một đốm sáng.';

  @override
  String get glimmerAlreadySent =>
      'Hôm nay bạn đã gửi đốm sáng cho người này rồi. Mai hãy thử lại nhé.';

  @override
  String get knockSent => 'Đã gõ cửa. Đang chờ hồi âm…';

  @override
  String get knockFailed => 'Tiếng gõ cửa chưa đến được. Vui lòng thử lại sau.';

  @override
  String get knockNoAnswer => 'Không có hồi âm. Tiếng gõ cửa lặng lẽ tan đi.';

  @override
  String get knockDeclined =>
      'Lần này hai bạn chưa gặp nhau. Hãy cho nhau chút khoảng lặng.';

  @override
  String get knockSkipped => 'Họ tạm bỏ qua, tiếng gõ cửa lặng lẽ tan đi.';

  @override
  String get sensingCity => 'Đang cảm nhận thành phố…';

  @override
  String get sensingCityHint =>
      'Nếu thành phố của bạn lúc này quá yên tĩnh, hãy bước vào Vũ trụ song song hoặc Thế giới lượng tử để gặp gỡ người ở thành phố khác.';

  @override
  String get gatheringUnavailable =>
      'Hiện chưa dùng được tụ họp. Vui lòng thử lại sau.';

  @override
  String get notSentCheckNetwork =>
      'Chưa gửi được. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get justNow => 'vừa xong';

  @override
  String minutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String hoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String get nextDayPrefix => 'hôm sau ';

  @override
  String get gatheringNameMissing => 'Hãy đặt tên cho buổi tụ họp.';

  @override
  String get gatheringEmojiInvalid => 'Biểu tượng phải là đúng một emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name đã bắt đầu. Hãy nhờ mọi người thêm $emoji vào biệt danh để tham gia.';
  }

  @override
  String get startGatheringTitle => 'Mở buổi tụ họp';

  @override
  String get startGatheringLead =>
      'Mọi người trong bán kính 5 km quanh bạn. Khu vực di chuyển theo bạn.';

  @override
  String get gatheringNameHint =>
      'Tên buổi tụ họp, ví dụ: Pháo hoa giao thừa bờ sông Sài Gòn';

  @override
  String get gatheringEmojiHint => 'Biểu tượng';

  @override
  String get gatheringEmojiHelp =>
      'Biểu tượng là một emoji chưa ai gần đây sử dụng.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'Ai thêm $emoji vào biệt danh sẽ thấy thông báo của bạn và nhận thông báo đẩy.';
  }

  @override
  String get start => 'Bắt đầu';

  @override
  String get end => 'Kết thúc';

  @override
  String get gatheringMaxDuration =>
      'Buổi tụ họp kéo dài tối đa 24 giờ và tự kết thúc.';

  @override
  String get starting => 'Đang bắt đầu…';

  @override
  String get startGathering => 'Bắt đầu tụ họp';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name đã kết thúc. Bạn đã trở lại thành phố.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · Bạn đang tổ chức';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'Người trong bán kính 5 km có $emoji trong biệt danh sẽ thấy thông báo và nhận thông báo đẩy. Bạn không thấy họ là ai.';
  }

  @override
  String get postAnnouncement => 'Đăng thông báo';

  @override
  String get announcementHint => 'Ví dụ: Tập trung ở cửa ra số 1 nhà ga';

  @override
  String get announcementSent => 'Đã gửi thông báo';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (đã ẩn do nhiều người báo cáo)';

  @override
  String get groupQuestion => 'Hỏi mọi người';

  @override
  String get questionHint => 'Ví dụ: Bạn lúc này thế nào?';

  @override
  String get sendQuestion => 'Gửi câu hỏi';

  @override
  String get questionSent =>
      'Đã gửi câu hỏi. Mọi người sẽ trả lời bằng tâm trạng';

  @override
  String get handOff => 'Trao lại';

  @override
  String handoffPending(String name) {
    return 'Đã mời $name nhận quyền tổ chức. Đang chờ trả lời…';
  }

  @override
  String get theOtherPerson => 'họ';

  @override
  String get handoffCancelled => 'Đã hủy lời mời trao quyền';

  @override
  String get handoffHelp =>
      'Nhấn giữ bong bóng của người tham gia trên radar → Trao quyền tổ chức. Khi họ đồng ý, họ sẽ tổ chức và buổi tụ họp vẫn tiếp tục không gián đoạn.';

  @override
  String get confirmEndAgain => 'Kết thúc? Chạm lần nữa';

  @override
  String get endGathering => 'Kết thúc tụ họp';

  @override
  String tallyHeader(String question, int total) {
    return '“$question” · $total câu trả lời';
  }

  @override
  String get tallyQuiet =>
      'Tỷ lệ chỉ hiện khi có 10 câu trả lời, để không ai bị đoán ra khi có ít người trả lời.';

  @override
  String get bannerYouHost => '  · Bạn đang tổ chức';

  @override
  String get bannerHostAnnouncement => '  · Từ người tổ chức';

  @override
  String get manageGathering => 'Quản lý tụ họp';

  @override
  String get reportAnnouncement => 'Báo cáo thông báo này';

  @override
  String get expandAnnouncement => 'Hiện thông báo';

  @override
  String get collapseAnnouncement => 'Ẩn thông báo';

  @override
  String hostHandedOffAgo(String ago) {
    return 'Người tổ chức mới · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'Bạn đã báo cáo thông báo này nên nó đã bị gỡ khỏi màn hình của bạn.';

  @override
  String get noAnnouncementHost =>
      'Chưa có thông báo. Chạm nút điều chỉnh ở góc trên bên phải để đăng thông báo đầu tiên.';

  @override
  String get noAnnouncementGuest => 'Người tổ chức chưa đăng gì.';

  @override
  String hostAsks(String question) {
    return 'Người tổ chức hỏi: $question';
  }

  @override
  String get answeredNote =>
      'Đã trả lời. Người tổ chức chỉ thấy tỷ lệ tâm trạng chung.';

  @override
  String get answerHint => 'Trả lời bằng một tâm trạng';

  @override
  String get sendAnswer => 'Gửi câu trả lời';

  @override
  String handoffInvited(String name) {
    return 'Đã mời $name nhận quyền tổ chức. Đang chờ trả lời (hiệu lực 5 phút).';
  }

  @override
  String handoffTitle(String name) {
    return 'Trao buổi tụ họp cho $name';
  }

  @override
  String get handoffBody =>
      'Khi họ đồng ý, họ sẽ tổ chức buổi tụ họp. Tên, thông báo và câu hỏi vẫn giữ nguyên, còn bạn trở thành người tham gia.';

  @override
  String get handoffPublic => 'Thông báo việc trao quyền';

  @override
  String get handoffPublicHelp =>
      'Báo cho mọi người tham gia biết có người tổ chức mới';

  @override
  String get handoffQuiet => 'Trao quyền lặng lẽ';

  @override
  String get handoffQuietHelp =>
      'Không báo cho ai. Chỉ vòng sáng người tổ chức trên radar đổi chỗ';

  @override
  String get sending => 'Đang gửi…';

  @override
  String get sendInvite => 'Gửi lời mời';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'Giờ bạn là người tổ chức $emoji $name.';
  }

  @override
  String get handoffOfferTitle => 'Bạn có muốn nhận tổ chức không?';

  @override
  String handoffOfferBody(String name) {
    return 'Người tổ chức muốn trao “$name” cho bạn. Khi tổ chức, bạn có thể đăng thông báo, đặt câu hỏi và kết thúc buổi tụ họp, đồng thời chịu trách nhiệm về những gì mình đăng.';
  }

  @override
  String get processing => 'Đang xử lý…';

  @override
  String get acceptHosting => 'Nhận tổ chức';

  @override
  String get guideS1Title => '1. Bước vào thành phố';

  @override
  String get guideS1L1 =>
      'Lần đầu mở ứng dụng, hãy xác nhận bạn đủ 18 tuổi và cho phép vị trí chính xác khi dùng ứng dụng. Không có vị trí chính xác, radar không hoạt động.';

  @override
  String get guideS1L2 =>
      'Viết một câu về cảm xúc lúc này (tối đa 20 ký tự), đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư, rồi chạm Check-in tại đây và vào.';

  @override
  String get guideS1L3 =>
      'Không cần số điện thoại, email hay tên thật. Tài khoản ẩn danh và gắn với điện thoại này.';

  @override
  String get guideS1L4 =>
      'Từ ngữ trong tâm trạng quyết định màu sắc: “vui, cười” vàng kim, “buồn, khóc” xanh dương, “giận” đỏ cam, “bình yên, thẫn thờ” xanh lá, “nhiệt huyết” cam, “yêu, tim” hồng, còn lại là tím nhạt.';

  @override
  String get guideS1L5 =>
      'Check-in: mỗi lần mở ứng dụng bạn tự check-in, và chỉ khi đó người ở gần mới thấy tâm trạng và vị trí gần đúng của bạn, và bạn cũng thấy họ. Không bao giờ tự động. Người khác thấy nơi bạn check-in; vị trí này không đi theo bạn. Nếu bạn đi xa hơn 1 km, nút Check-in tại đây sẽ hiện dưới radar. Nếu ứng dụng ở chế độ nền hơn 30 phút, bạn check-in lại khi quay lại.';

  @override
  String get guideS2Title => '2. Thanh dưới cùng';

  @override
  String get guideS2L1 =>
      'Chạm ảnh của bạn bên trái để sửa ảnh, biệt danh (tối đa 10 ký tự) và tâm trạng.';

  @override
  String get guideS2L2 =>
      'Biểu tượng ghi chú: để lại lời thì thầm ngay tại đây.';

  @override
  String get guideS2L3 =>
      'Biểu tượng chia sẻ: biến tâm trạng thành thẻ cảnh đêm.';

  @override
  String get guideS2L4 =>
      'Biểu tượng điều chỉnh ở ngoài cùng bên phải: mở Cài đặt.';

  @override
  String get guideS3Title => '3. Radar và bong bóng';

  @override
  String get guideS3L1 =>
      'Bong bóng tâm trạng của người trong bán kính 5 km hiện trên radar. Chỉ hiện khoảng cách gần đúng (như “trong 100 m”), không bao giờ hiện địa chỉ.';

  @override
  String get guideS3L2 =>
      'Radar chỉ hiện những người đang check-in và mở ứng dụng. Khi ai đó rời đi hoặc chuyển sang ứng dụng khác, bong bóng của họ biến mất ngay, không để lại dấu vết.';

  @override
  String get guideS3L3 =>
      'Dùng hai ngón tay để phóng to, thu nhỏ bản đồ. Xoay điện thoại thì radar xoay theo hướng bạn nhìn.';

  @override
  String get guideS3L4 =>
      'Khi bong bóng quá dày, chúng gộp thành một quả cầu sáng “N tâm trạng ở đây”. Chạm để xòe thành vòng tròn, chạm được từng cái; chạm giữa hoặc chỗ trống để thu lại.';

  @override
  String get guideS3L5 =>
      'Tên bắt đầu bằng Mẫu là người mẫu tự động trả lời. Họ không phải người thật, bạn có thể dùng để thử mọi tính năng.';

  @override
  String get guideS3L6 =>
      'Khi không có ai gần, dòng “Bạn là ánh sáng đầu tiên đêm nay” hiện ở dưới, và bạn có thể rủ bạn bè thắp sáng khu phố.';

  @override
  String get guideS4Title => '4. Gõ cửa và trò chuyện';

  @override
  String get guideS4L1 =>
      'Nhấn giữ bong bóng của ai đó → Gõ cửa. Họ có 5 phút để đồng ý, từ chối hoặc bỏ qua. Trong lúc chờ, một dải sáng chảy từ bạn đến họ.';

  @override
  String get guideS4L2 =>
      'Khi họ đồng ý, cuộc trò chuyện bắt đầu với đồng hồ đếm ngược 10 phút. Mỗi tin nhắn mới sẽ đếm lại, và cuộc trò chuyện kết thúc khi cả hai im lặng.';

  @override
  String get guideS4L3 =>
      'Khi cuộc trò chuyện kết thúc, tin nhắn bị xóa khỏi máy chủ. Người kia vẫn có thể chụp màn hình, nên hãy cân nhắc những gì bạn chia sẻ.';

  @override
  String get guideS4L4 =>
      'Khi có người gõ cửa, thẻ gõ cửa sẽ hiện ra. Bạn có thể đồng ý, từ chối, bỏ qua hoặc báo cáo ngay.';

  @override
  String get guideS5Title => '5. Đốm sáng';

  @override
  String get guideS5L1 =>
      'Chạm hai lần vào bong bóng của ai đó, hoặc nhấn giữ và chọn Gửi một đốm sáng, để họ biết có người đã để ý mà không cần nói gì.';

  @override
  String get guideS5L2 =>
      'Họ chỉ thấy “Đêm nay có N đốm sáng đồng cảm với bạn” và không bao giờ biết ai gửi. Mỗi người chỉ gửi được một đốm sáng cho cùng một người trong 24 giờ.';

  @override
  String get guideS6Title => '6. Lời thì thầm';

  @override
  String get guideS6L1 =>
      'Chạm biểu tượng ghi chú ở thanh dưới để để lại một câu tại nơi bạn đang đứng (tối đa 60 ký tự).';

  @override
  String get guideS6L2 =>
      'Trong 7 ngày tới, ai đi trong bán kính 300 m sẽ thấy phong bì trên radar và mở ra đọc được.';

  @override
  String get guideS6L3 =>
      'Lời thì thầm luôn ẩn danh. Bạn có tối đa 3 lời cùng lúc, mỗi 10 phút tối đa 1 lời, và có thể thu hồi bất cứ lúc nào.';

  @override
  String get guideS6L4 =>
      'Thư gửi tương lai: khi viết lời thì thầm, chọn Gửi chính mình tương lai, rồi chọn một tháng hoặc một năm sau. Chỉ bạn thấy được. Khi đến lúc bạn sẽ được báo, và thư tự mở khi bạn quay lại trong bán kính 100 m. Thư chỉ đọc được một lần. Chỉ bạn thấy một chiếc đồng hồ cát nhỏ trên radar (đã khóa hoặc đã mở), và không chạm vào được. Tối đa 5 thư cùng lúc; xem hoặc xóa trong Cài đặt → Thư gửi tương lai.';

  @override
  String get guideS7Title => '7. Thời tiết tâm trạng thành phố';

  @override
  String get guideS7L1 =>
      'Nhãn ở góc trên bên trái cho thấy tâm trạng phổ biến nhất trong bán kính 20 km suốt 24 giờ qua. Chạm để xem toàn bộ tỷ lệ.';

  @override
  String get guideS7L2 =>
      'Không hiện tỷ lệ khi ít hơn 10 người, để không ai bị nhận ra.';

  @override
  String get guideS8Title => '8. Tụ họp';

  @override
  String get guideS8L1 =>
      'Cách mở: Cài đặt → Tổ chức buổi tụ họp → nhập tên, một emoji làm biểu tượng, giờ bắt đầu và kết thúc (tối đa 24 giờ) → Bắt đầu tụ họp.';

  @override
  String get guideS8L2 =>
      'Buổi tụ họp bao phủ 5 km quanh nơi người tổ chức check-in; khi người tổ chức check-in lại, phạm vi di chuyển theo. Người tổ chức có vòng sáng và nhãn Tổ chức trên radar.';

  @override
  String get guideS8L3 =>
      'Người tổ chức có thể đăng thông báo (không giới hạn), hỏi mọi người và kết thúc buổi tụ họp bất cứ lúc nào.';

  @override
  String get guideS8L4 =>
      'Để tham gia, thêm biểu tượng của buổi tụ họp vào biệt danh (ví dụ “Mèo Lang Thang🌈”). Khi ở trong khu vực, bạn sẽ thấy thông báo ghim phía trên radar và nhận thông báo đẩy. Xóa biểu tượng để rời đi.';

  @override
  String get guideS8L5 =>
      'Câu hỏi chung: trả lời bằng một tâm trạng. Người tổ chức chỉ thấy tỷ lệ tâm trạng chung, không biết ai trả lời gì, và tỷ lệ bị ẩn khi dưới 10 câu trả lời.';

  @override
  String get guideS8L6 =>
      'Trong cùng một khu vực, mỗi biểu tượng chỉ dùng cho một buổi tụ họp cùng lúc. Sau khi kết thúc, ai cũng có thể dùng.';

  @override
  String get guideS8L7 =>
      'Trao quyền: người tổ chức nhấn giữ bong bóng của một người tham gia → Trao quyền tổ chức, rồi chọn công khai (báo cho mọi người) hoặc lặng lẽ (không báo). Nếu người đó đồng ý trong 5 phút, họ trở thành người tổ chức, thông báo và câu hỏi vẫn giữ nguyên. Người tổ chức cũ trở thành người tham gia và biểu tượng được thêm vào biệt danh.';

  @override
  String get guideS9Title => '9. Hải đăng thành phố (nhà vệ sinh thân thiện)';

  @override
  String get guideS9L1 =>
      'Chạm biểu tượng nhà vệ sinh ở góc dưới bên trái bản đồ để bật hải đăng. Nhà vệ sinh phi giới tính, cho người khuyết tật và gia đình trong bán kính 2 km sẽ hiện trên radar, kèm số lượng cạnh biểu tượng. Chạm ba bộ lọc tròn phía trên để chỉ xem một số loại.';

  @override
  String get guideS9L2 =>
      'Chạm vào điểm đánh dấu để xem tầng, tiện nghi và khoảng cách, rồi chạm Đi bộ tới đó để chỉ đường bằng ứng dụng bản đồ.';

  @override
  String get guideS9L3 =>
      'Dữ liệu lấy từ hồ sơ nhà vệ sinh công cộng của Bộ Môi trường Đài Loan, cập nhật hằng tháng. Không có giờ mở cửa; “Có thể mở ban đêm” là ước tính của chúng tôi dựa trên loại địa điểm.';

  @override
  String get guideS9L4 =>
      'Nếu thông tin sai, bạn có thể báo (không phải phi giới tính, đóng ban đêm, không tìm thấy). Khi 3 người báo cùng một vấn đề, điểm đánh dấu chuyển xám kèm ghi chú.';

  @override
  String get guideS10Title => '11. Thẻ tâm trạng và dấu vết tâm trạng';

  @override
  String get guideS10L1 =>
      'Nút chia sẻ ở thanh dưới biến tâm trạng hiện tại thành thẻ cảnh đêm, hợp với Instagram Stories. Thẻ không bao giờ hiện vị trí của bạn.';

  @override
  String get guideS10L2 =>
      'Cài đặt → Dấu vết tâm trạng cho bạn xem lại những tâm trạng và nơi bạn đã viết. Dữ liệu chỉ lưu trên điện thoại, có thể tắt hoặc xóa bất cứ lúc nào.';

  @override
  String get guideS11Title => '17. Cài đặt và thông báo';

  @override
  String get guideS11L1 =>
      'Nhắc nhở mỗi tối: một lời nhắc nhẹ nhàng lúc 21:30 mỗi tối. Bật hoặc tắt trong Cài đặt.';

  @override
  String get guideS11L2 =>
      'Gõ cửa, tin nhắn mới, đốm sáng và thông báo tụ họp đến dưới dạng thông báo đẩy. Bạn có thể tắt trong cài đặt điện thoại.';

  @override
  String get guideS11L3 =>
      'Mỗi thứ Sáu từ 21:00 đến 23:00 là Đêm Thắp Sáng, khi mọi người cùng online và thành phố sáng nhất.';

  @override
  String get guideS12Title => '18. Báo cáo và chặn';

  @override
  String get guideS12L1 =>
      'Bạn có thể báo cáo từ menu nhấn giữ bong bóng, thẻ gõ cửa, góc trên bên phải cuộc trò chuyện, lời thì thầm hoặc thông báo tụ họp. Sau khi báo cáo, người hoặc nội dung đó biến mất khỏi màn hình ngay và cuộc trò chuyện kết thúc. Chúng tôi xử lý mọi báo cáo trong 24 giờ.';

  @override
  String get guideS12L2 =>
      'Tâm trạng, biệt danh, lời thì thầm, tin nhắn và thông báo tụ họp được tự động lọc từ ngữ xúc phạm và thông tin liên lạc như số điện thoại, đường link.';

  @override
  String get guideS12L3 =>
      'Khi bạn chặn ai đó, hai bạn biến mất khỏi radar của nhau và không thể gõ cửa hay gửi đốm sáng. Bỏ chặn trong Cài đặt → Người đã chặn.';

  @override
  String get guideS12L4 =>
      'Nếu bạn đang gặp nguy hiểm khẩn cấp, hãy gọi ngay số khẩn cấp tại địa phương (113 ở Việt Nam, 110 ở Đài Loan).';

  @override
  String get guideS13Title => '19. Quyền riêng tư và tài khoản';

  @override
  String get guideS13L1 =>
      'Chỉ sau khi bạn check-in, người ở gần mới thấy tâm trạng, tên thành phố, ảnh và khoảng cách gần đúng của bạn. Họ thấy nơi bạn check-in, không phải vị trí theo thời gian thực.';

  @override
  String get guideS13L2 =>
      'Cài đặt → Xóa tài khoản và dữ liệu sẽ xóa vĩnh viễn mọi thứ bạn để lại trong thành phố, bất cứ lúc nào.';

  @override
  String get guideS13L3 =>
      'Có câu hỏi? Vào Cài đặt → Liên hệ, hoặc gửi email đến service.softchip@gmail.com.';

  @override
  String get guideS14Title => '12. Vũ trụ song song';

  @override
  String get guideS14L1 =>
      'Chạm biểu tượng quả địa cầu ở góc trên bên phải radar để bật, chạm lần nữa để tắt. Mỗi lần mở ứng dụng, tính năng này đều tắt.';

  @override
  String get guideS14L2 =>
      'Mỗi thành phố hoặc huyện ở Đài Loan lấy nhà ga trung tâm của mình làm tâm (Đại Đài Bắc là ga Đài Bắc, Đào Viên là ga Đào Viên…) và được ghép với các thành phố nước ngoài: Nhật Bản, Hàn Quốc, Hồng Kông, Ma Cao, Singapore, Malaysia, Indonesia, Việt Nam, Thái Lan, Philippines, Úc, New Zealand, Ấn Độ, Brazil, Argentina và Nam Phi. Các thành phố nước ngoài được ghép với Đài Loan.';

  @override
  String get guideS14L3 =>
      'Bạn cách nhà ga bao xa, theo hướng nào thì sẽ xuất hiện ở thành phố của họ với cùng khoảng cách và hướng so với nhà ga của họ, được làm mờ khoảng 500 m. Không ai thấy được vị trí thật của bạn.';

  @override
  String get guideS14L4 =>
      'Hai người thấy nhau nếu một trong hai bật: khi bật, bạn thấy mọi người đang mở ứng dụng ở các thành phố được ghép; khi tắt, bạn chỉ thấy những người đã bật. Chỉ người đã check-in và đang mở ứng dụng mới xuất hiện ở thành phố khác.';

  @override
  String get guideS14L5 =>
      'Người từ Vũ trụ song song có vòng nét đứt và hiện thành phố của họ. Bạn vẫn có thể gửi ánh sáng, gõ cửa và trò chuyện. Lời thì thầm, thư gửi tương lai và buổi tụ họp chỉ ở lại nơi đó.';

  @override
  String get guideS15Title => '16. Dịch';

  @override
  String get guideS15L1 =>
      'Khi trò chuyện, nếu tin nhắn không phải ngôn ngữ của bạn, dòng Chạm để dịch sẽ hiện bên dưới. Chạm để dịch sang ngôn ngữ của bạn, chạm lần nữa để xem bản gốc.';

  @override
  String get guideS15L2 =>
      'Bong bóng tâm trạng trên radar cũng vậy: nếu không phải ngôn ngữ của bạn, chạm để dịch và chạm lần nữa để trở lại bản gốc.';

  @override
  String get guideS15L3 =>
      'Việc dịch diễn ra hoàn toàn trên điện thoại; văn bản không bao giờ được tải lên. iPhone dùng tính năng dịch có sẵn của Apple, và hệ thống sẽ hỏi trước khi tải một ngôn ngữ lần đầu. Android dùng Google ML Kit, hỏi bạn trước rồi tải mô hình ngôn ngữ khoảng 30 MB. iPhone chưa dịch được tiếng Mã Lai.';

  @override
  String get guideIntro =>
      'Mood Whisper là một thành phố về đêm: viết một câu về cảm xúc lúc này, và thấy những người quanh bạn đang cảm thấy thế nào.';

  @override
  String get beaconGender => 'Phi giới tính';

  @override
  String get beaconAccessible => 'Người khuyết tật';

  @override
  String get beaconFamily => 'Gia đình';

  @override
  String get beaconReportNotGender => 'Không phải phi giới tính';

  @override
  String get beaconReportClosed => 'Đóng cửa ban đêm';

  @override
  String get beaconReportMissing => 'Không tìm thấy nhà vệ sinh này';

  @override
  String get beaconFlagNotGender => 'Có người báo: không phải phi giới tính';

  @override
  String get beaconFlagClosed => 'Có người báo: đóng cửa ban đêm';

  @override
  String get beaconFlagMissing => 'Có người báo: không tìm thấy';

  @override
  String get beaconDefaultName => 'Nhà vệ sinh công cộng';

  @override
  String meters(int m) {
    return '$m m';
  }

  @override
  String kilometers(String km) {
    return '$km km';
  }

  @override
  String get beaconUnavailable =>
      'Hải đăng thành phố hiện chưa dùng được. Vui lòng thử lại sau.';

  @override
  String get notConnectedCheckNetwork =>
      'Không kết nối được. Hãy kiểm tra kết nối và thử lại.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'Nhà vệ sinh $features, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Tắt hải đăng thành phố (nhà vệ sinh thân thiện), $count chỗ gần đây';
  }

  @override
  String get beaconToggleOn =>
      'Bật hải đăng thành phố (nhà vệ sinh thân thiện)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Chỉ xem $feature';
  }

  @override
  String get beaconMaybeOpenNight => 'Có thể mở ban đêm (ước tính)';

  @override
  String get beaconMaybeDaytime => 'Có thể chỉ mở ban ngày (ước tính)';

  @override
  String get walkThere => 'Đi bộ tới đó';

  @override
  String get beaconWrongData => 'Thông tin sai?';

  @override
  String beaconThanks(String reason) {
    return 'Cảm ơn bạn. Chúng tôi đã nhận báo cáo: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Nguồn: hồ sơ nhà vệ sinh công cộng của Bộ Môi trường Đài Loan, cập nhật hằng tháng. Giờ mở cửa là ước tính dựa trên loại địa điểm.';

  @override
  String get invite1 =>
      'Mình vừa thắp một ánh sáng trên Mood Whisper. Càng nhiều người gần đây, khu phố càng sáng. Cùng thắp sáng nhé:';

  @override
  String get invite2 =>
      'Thành phố đêm nay hơi yên ắng. Viết một tâm trạng trên Mood Whisper để khu phố mình sáng lên nhé:';

  @override
  String get invite3 =>
      'Không cần kết bạn, không cần tên thật, chỉ một câu về cảm xúc lúc này. Tìm mình trên Mood Whisper:';

  @override
  String get invite4 =>
      'Mình để lại một ngọn đèn cho bạn trên Mood Whisper. Mở app và xem đêm nay những người quanh đây đang nghĩ gì:';

  @override
  String get invite5 =>
      'Mỗi tối thứ Sáu lúc 9 giờ là Đêm Thắp Sáng trên Mood Whisper. Cùng online để radar sáng rực nhé:';

  @override
  String get invite6 =>
      'Cần một nơi để kể về ngày hôm nay? Mood Whisper ẩn danh, và lời nói sẽ tan đi sau khi nói ra:';

  @override
  String get invite7 =>
      'Bạn có bao giờ tò mò những người lướt qua mình trên phố đang cảm thấy gì không? Xem trên Mood Whisper nhé:';

  @override
  String get invite8 =>
      'Mình đã để lại một lời thì thầm trên con phố này, chỉ người đi ngang mới đọc được. Bạn cũng để lại một lời nhé:';

  @override
  String get invite9 =>
      'Mood Whisper là bản đồ tâm trạng của thành phố về đêm. Càng đông càng vui, đến thêm một ánh sáng cho khu phố mình nhé:';

  @override
  String get invite10 =>
      'Tâm trạng của bạn đêm nay màu gì? Viết lên Mood Whisper nhé. Mình ở gần đây, chờ ánh sáng của bạn:';

  @override
  String get shareInvite => 'Chia sẻ lời mời';

  @override
  String get inviteSubject => 'Cùng thắp sáng khu phố mình nhé';

  @override
  String get shareMoodCardButton => 'Chia sẻ thẻ';

  @override
  String moodShareText(String mood) {
    return 'Mình vừa chia sẻ cảm xúc lúc này trên Mood Whisper: “$mood”\nĐêm nay, tâm trạng của bạn có đang sáng lên trong thành phố không?';
  }

  @override
  String get shareFailed => 'Chưa chia sẻ được. Vui lòng thử lại.';

  @override
  String shuffleCard(int current, int total) {
    return 'Đổi thẻ · $current / $total';
  }

  @override
  String get preparing => 'Đang chuẩn bị…';

  @override
  String get sendLinkToFriends => 'Gửi link cho bạn bè (Zalo, Messenger)';

  @override
  String get partLateNight => 'Khuya';

  @override
  String get partMorning => 'Sáng';

  @override
  String get partAfternoon => 'Chiều';

  @override
  String get partDusk => 'Hoàng hôn';

  @override
  String get partNight => 'Tối';

  @override
  String get cardInviteEyebrow => 'Lời mời';

  @override
  String get cardMoodEyebrow => 'Cảm xúc lúc này';

  @override
  String get cardInviteTitle => 'Cùng thắp sáng\nkhu phố mình';

  @override
  String get cardInviteBody =>
      'Mình vừa thắp một ánh sáng trên Mood Whisper.\nCàng nhiều người gần đây, khu phố càng sáng.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nỞ một góc nào đó của thành phố';
  }

  @override
  String get whisperUnavailable =>
      'Lời thì thầm hiện chưa dùng được. Vui lòng thử lại sau.';

  @override
  String get whisperNotSent =>
      'Lời thì thầm chưa gửi được. Hãy kiểm tra kết nối và thử lại.';

  @override
  String daysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String get timeWhisperTitle => 'Thư gửi tương lai';

  @override
  String get timeWhisperLead =>
      'Viết cho chính mình trong tương lai. Khi đến lúc, hãy quay lại đây để mở.';

  @override
  String get whisperLead => 'Viết cho người kế tiếp đi qua đây.';

  @override
  String get toPassersBy => 'Gửi người qua đường';

  @override
  String get toFutureSelf => 'Gửi chính mình tương lai';

  @override
  String get inOneMonth => 'Một tháng sau';

  @override
  String get inOneYear => 'Một năm sau';

  @override
  String get timeWhisperHint =>
      'Ví dụ: Hẹn gặp lại ở đây năm sau. Mong lúc ấy bạn sống tốt hơn bây giờ.';

  @override
  String get whisperHint =>
      'Ví dụ: Hoàng hôn ở đây rất đẹp. Nhớ ngẩng đầu lên nhé.';

  @override
  String get timeWhisperCaptionYear =>
      'Chỉ bạn thấy được · mở niêm phong sau một năm và báo cho bạn · mở khi trong 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Chỉ bạn thấy được · mở niêm phong sau một tháng và báo cho bạn · mở khi trong 100 m';

  @override
  String get whisperCaption =>
      'Tan sau 7 ngày · không hiện bạn là ai · chỉ cho biết bạn từng ở quanh đây';

  @override
  String get sealHere => 'Niêm phong ở đây';

  @override
  String get leaveHere => 'Để lại ở đây';

  @override
  String get aWhisper => 'Một lời thì thầm';

  @override
  String whisperLeftAgo(String ago) {
    return 'Để lại quanh đây $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    return 'Đã có $count người nhận';
  }

  @override
  String get whisperNobodyYet => 'Chưa có ai đi qua';

  @override
  String get withdrawWhisper => 'Thu hồi lời thì thầm này';

  @override
  String get whisperCollected => 'Bạn đã nhận lời thì thầm này.';

  @override
  String whisperReadersBefore(int count) {
    return 'Trước bạn đã có $count người đi qua đây.';
  }

  @override
  String get whisperFirstReader => 'Bạn là người đầu tiên đi qua đây.';

  @override
  String get reportWhisper => 'Báo cáo lời thì thầm này';

  @override
  String get thisWhisper => 'Lời thì thầm này';

  @override
  String get chatTimeUp => 'Hết giờ. Khoảnh khắc tan dần...';

  @override
  String get chatOtherLeft => 'Họ đã lẫn vào thành phố...';

  @override
  String get chatEnded => 'Khoảnh khắc đã kết thúc...';

  @override
  String get chatBlockedEnded => 'Đã chặn. Cuộc trò chuyện đã kết thúc.';

  @override
  String get chatReportedEnded => 'Đã báo cáo. Cuộc trò chuyện đã kết thúc.';

  @override
  String get anonymous => 'Ẩn danh';

  @override
  String get leaveChat => 'Rời cuộc trò chuyện';

  @override
  String chatWith(String name) {
    return 'Khoảnh khắc với $name';
  }

  @override
  String get countdownPrefix => 'Tan sau ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Cuộc trò chuyện mẫu: tin nhắn trả lời tự động, không phải người thật.';

  @override
  String get typing => 'Đang nhập…';

  @override
  String get chatHint => 'Nói khẽ điều gì đó…';

  @override
  String get send => 'Gửi';

  @override
  String get chatDissolvedApart => 'Hai bạn đã trở về thành phố của riêng mình';

  @override
  String get knockTooOften =>
      'Bạn gõ cửa quá thường xuyên. Hãy hít thở cùng thành phố...';

  @override
  String get otherNotNow =>
      'Họ không muốn bị làm phiền lúc này. Hãy cho nhau chút khoảng lặng.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'Họ không muốn bị làm phiền lúc này. Hãy cho nhau chút khoảng lặng ($minutes phút).';
  }

  @override
  String get justEndedRest =>
      'Hai bạn vừa mới chào nhau. Hãy để kỷ niệm lắng lại một chút.';

  @override
  String get intro1Title => 'Hòa vào thành phố';

  @override
  String get intro1Body =>
      'Bỏ lại những nhãn mác mạng xã hội. Trên tấm vải tối giản của đêm, chỉ còn cảm xúc thật của bạn, và nơi bạn đang đứng.';

  @override
  String get intro2Title => 'Khoảnh khắc giao nhau';

  @override
  String get intro2Body =>
      'Thấy bong bóng tâm trạng trôi gần đây? Gõ cửa thật khẽ và có một cuộc trò chuyện chỉ một lần trong đời với người lướt qua.';

  @override
  String get intro3Title => 'Nhịp điệu thành phố';

  @override
  String get intro3Body =>
      'Chúng tôi trân trọng cảm xúc của bạn. Sau khi gõ cửa, hãy lặng lẽ chờ hồi âm. Nếu chưa có duyên, bong bóng sẽ lặng lẽ tan sau 300 giây.';

  @override
  String get intro4Title => 'Khoảng cách dịu dàng';

  @override
  String get intro4Body =>
      'Không muốn bị làm phiền? Từ chối hoặc chặn. Hệ thống làm dịu giữ ồn ào ở xa và trả lại cho bạn góc yên tĩnh.';

  @override
  String get intro5Title => 'Sẵn sàng gặp gỡ chưa?';

  @override
  String get intro5Body =>
      'Nhắm mắt lại, cảm nhận rung động của điện thoại và nhịp tim. Giờ hãy viết cảm xúc lúc này, check-in tại đây và bước vào Mood Whisper.';

  @override
  String get intro6Title => 'Thư gửi chính mình trong tương lai';

  @override
  String get intro6Body =>
      'Để lại vài lời ở chính nơi này cho bạn của một tháng hay một năm sau. Lá thư chỉ mở khi bạn quay lại đây.';

  @override
  String get intro7Title => 'Đêm nay, cùng tỏa sáng';

  @override
  String get intro7Body =>
      'Tổ chức một buổi tụ họp với một biểu tượng cảm xúc làm ám hiệu. Ai thêm nó vào tên sẽ nhận thông báo của bạn, và cả khu phố cùng sáng lên.';

  @override
  String get intro8Title => 'Vũ trụ song song';

  @override
  String get intro8Body =>
      'Chạm quả địa cầu, các thành phố Đài Loan chồng lên Tokyo, Seoul và Kuala Lumpur. Thấy tâm trạng của người ở xa ngay lúc này, gõ cửa, trò chuyện và chạm để dịch.';

  @override
  String get loadingImage => 'Đang tải ảnh...';

  @override
  String get startExploring => 'Bắt đầu khám phá';

  @override
  String get nextPage => 'Tiếp';

  @override
  String get feedbackSubject => 'Góp ý cho Mood Whisper';

  @override
  String get loginNeedMood =>
      'Hãy viết cảm xúc lúc này, rồi bước vào thành phố.';

  @override
  String get loginNeedAgree =>
      'Hãy đọc và đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư trước.';

  @override
  String get loginCantConnect =>
      'Không kết nối được với thành phố. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get ageQuestion => 'Bạn đã đủ 18 tuổi chưa?';

  @override
  String get ageReason =>
      'Mood Whisper kết nối bạn với người lạ ở gần, nên chỉ dành cho người từ 18 tuổi trở lên.';

  @override
  String get ageUnder => 'Tôi chưa đủ 18';

  @override
  String get ageOver => 'Tôi đủ 18 tuổi';

  @override
  String get loginTitle1 => 'Sẵn sàng';

  @override
  String get loginTitle2 => ' gặp gỡ chưa?';

  @override
  String get loginLead =>
      'Nhắm mắt lại, cảm nhận rung động của điện thoại và nhịp tim.\nGiờ hãy viết cảm xúc lúc này và bước vào Mood Whisper.';

  @override
  String get loginPrompt => 'Lúc này, bạn muốn nói gì với thành phố?';

  @override
  String get loginHint => 'Ví dụ: Vừa uống một ly cà phê ngon😊';

  @override
  String get enterCity => 'Vào Mood Whisper';

  @override
  String get agreeSemantic =>
      'Tôi đã đọc và đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư';

  @override
  String get agreePrefix => 'Tôi đã đọc và đồng ý với ';

  @override
  String get termsLink => 'Điều khoản sử dụng';

  @override
  String get agreeAnd => ' và ';

  @override
  String get privacyLink => 'Chính sách quyền riêng tư';

  @override
  String get agreeSuffix =>
      '. Mood Whisper không dung thứ quấy rối, nội dung tình dục, thù ghét hay hành vi lạm dụng khác. Ai vi phạm sẽ bị đưa ra khỏi thành phố.';

  @override
  String get under18Title =>
      'Mood Whisper chỉ dành cho người từ 18 tuổi trở lên';

  @override
  String get under18Body =>
      'Cảm ơn bạn đã thành thật. Thành phố này kết nối bạn với người lạ. Hẹn gặp lại khi bạn đủ 18 tuổi.';

  @override
  String get clearMoodTrail => 'Xóa dấu vết tâm trạng';

  @override
  String get clearMoodTrailBody =>
      'Toàn bộ dấu vết tâm trạng trên điện thoại này sẽ bị xóa. Không thể hoàn tác.';

  @override
  String get clear => 'Xóa';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'Chỉ lưu trên điện thoại của bạn. Không bao giờ tải lên đâu cả.';

  @override
  String get moodTrailEmpty =>
      'Tuần này chưa có dấu vết tâm trạng. Mỗi lần bạn viết tâm trạng hay đến một nơi mới, ở đây sẽ thêm một ánh sáng.';

  @override
  String get thisWeekYou => 'Tuần này của bạn';

  @override
  String get topMoodPrefix => 'Bạn thường cảm thấy “';

  @override
  String topMoodSuffix(int count) {
    return '” nhất, $count lần';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return 'Để lại $total tâm trạng ở $places nơi khác nhau';
  }

  @override
  String get recordMoodTrail => 'Ghi lại dấu vết tâm trạng';

  @override
  String get recordMoodTrailOff => 'Khi tắt, không ghi thêm dấu vết mới';

  @override
  String get nightly1 => 'Đêm nay thành phố đang nghĩ gì?';

  @override
  String get nightly2 => 'Có người gần đây đang viết cảm xúc lúc này.';

  @override
  String get nightly3 => 'Đêm vừa đẹp. Để lại một câu cho thành phố nhé.';

  @override
  String get nightly4 =>
      'Hôm nay thế nào? Tâm trạng của bạn sẽ sáng lên trong thành phố.';

  @override
  String get nightly5 =>
      'Đèn đường đã sáng, và những người gần đây vẫn còn thức.';

  @override
  String get nightly6 => 'Khép lại ngày hôm nay: lúc này bạn cảm thấy thế nào?';

  @override
  String get nightly7 => 'Đêm nay, ai sẽ lướt qua bạn?';

  @override
  String get nightlyChannel => 'Nhắc nhở mỗi tối';

  @override
  String get nightlyChannelDesc =>
      'Một lời nhắc nhẹ nhàng mỗi tối. Có thể tắt trong cài đặt của ứng dụng.';

  @override
  String get reasonHarassment => 'Quấy rối hoặc bắt nạt';

  @override
  String get reasonSexual => 'Nội dung tình dục';

  @override
  String get reasonScam => 'Lừa đảo hoặc quảng cáo';

  @override
  String get reasonHate => 'Thù ghét hoặc bạo lực';

  @override
  String get reasonImpersonation => 'Mạo danh';

  @override
  String get reasonOther => 'Lý do khác';

  @override
  String get reportReceived =>
      'Đã nhận báo cáo và gỡ khỏi màn hình của bạn. Chúng tôi sẽ xử lý trong 24 giờ.';

  @override
  String get reportNotSent =>
      'Báo cáo chưa gửi được. Hãy kiểm tra kết nối và thử lại.';

  @override
  String reportTarget(String target) {
    return 'Báo cáo $target';
  }

  @override
  String get reportPrivate =>
      'Họ sẽ không biết bạn đã báo cáo. Hãy chọn lý do:';

  @override
  String get reportDetails => 'Mô tả thêm (không bắt buộc)';

  @override
  String get reportWhatHappened => 'Đã xảy ra chuyện gì?';

  @override
  String get sendReport => 'Gửi báo cáo';

  @override
  String get alsoBlock =>
      'Chặn luôn người này. Hai bạn sẽ biến mất khỏi thành phố của nhau.';

  @override
  String get aYearAgo => 'Một năm trước';

  @override
  String get aMonthAgo => 'Một tháng trước';

  @override
  String get timeWhisperUnavailable =>
      'Thư gửi tương lai hiện chưa dùng được. Vui lòng thử lại sau.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, bạn đã nói ở đây';
  }

  @override
  String writtenOn(String date) {
    return 'Viết ngày $date';
  }

  @override
  String get timeWhisperOnce => 'Lá thư này chỉ xuất hiện một lần.';

  @override
  String get keepInHeart => 'Cất vào tim';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Mở ngày $unlock · viết ngày $created';
  }

  @override
  String get unsealedGoBack => 'Đã mở niêm phong. Quay lại nơi đó để mở thư.';

  @override
  String unsealedDistance(String distance) {
    return 'Đã mở niêm phong · cách bạn $distance';
  }

  @override
  String get timeWhisperListLead =>
      'Thư gửi chính mình tương lai, chỉ bạn thấy được. Khi đến lúc, hãy đến trong bán kính 100 m của nơi đó để mở. Đọc một lần là biến mất.';

  @override
  String get timeWhisperListEmpty =>
      'Chưa có thư gửi tương lai. Chạm biểu tượng ghi chú ở thanh dưới và chọn “Gửi chính mình tương lai”.';

  @override
  String get readyToOpen => 'Đã có thể mở';

  @override
  String get sealed => 'Đang niêm phong';

  @override
  String get delete => 'Xóa';

  @override
  String get within100m => 'Trong 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Đang chờ $name trả lời, còn $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'Đang chờ $name';
  }

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo điện thoại';

  @override
  String get parallelUniverse => 'Vũ trụ song song';

  @override
  String get parallelUniverseSubtitle =>
      'Xem tâm trạng các thành phố khác lúc này, và để họ thấy bạn';

  @override
  String get parallelUniverseIntroTitle => 'Bước vào Vũ trụ song song';

  @override
  String get parallelUniverseIntroBody =>
      'Khi bật, mọi người đang mở ứng dụng ở các thành phố được ghép với bạn sẽ hiện lên radar của bạn, và tất cả họ đều thấy bạn. Các thành phố ở Đài Loan được ghép với các thành phố nước ngoài (như Tokyo, Seoul, Kuala Lumpur), và các thành phố nước ngoài được ghép với Đài Loan.\n\nHai thành phố được canh theo trung tâm của mỗi bên (nhà ga trung tâm, hoặc tòa thị chính nếu không có ga): bạn cách trung tâm bao xa, theo hướng nào thì sẽ xuất hiện ở đúng chỗ đó trong thành phố của họ, được làm mờ khoảng 500 m, nên không ai thấy được vị trí hay khoảng cách thật của bạn. Bạn vẫn có thể gửi ánh sáng, gõ cửa và trò chuyện, và tắt bất cứ lúc nào. Lời thì thầm và buổi tụ họp chỉ ở lại nơi đó.';

  @override
  String get parallelUniverseEnter => 'Bước vào';

  @override
  String get parallelUniverseNoCity => 'Nơi bạn ở chưa có Vũ trụ song song';

  @override
  String parallelFrom(String city) {
    return 'Song song · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'Người này đang ở $city, không ở gần bạn. Vị trí được chiếu sang và không phải khoảng cách thật.';
  }

  @override
  String get labelHost => 'Chủ trì';

  @override
  String get labelDemo => 'Mẫu';

  @override
  String get labelResting => 'Đang nghỉ';

  @override
  String get cityTaipei => 'Đài Bắc';

  @override
  String get cityTaichung => 'Đài Trung';

  @override
  String get cityKaohsiung => 'Cao Hùng';

  @override
  String get cityTokyo => 'Tokyo';

  @override
  String get cityOsaka => 'Osaka';

  @override
  String get citySeoul => 'Seoul';

  @override
  String get cityBusan => 'Busan';

  @override
  String get cityHongkong => 'Hồng Kông';

  @override
  String get cityMacau => 'Ma Cao';

  @override
  String get citySingapore => 'Singapore';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityHochiminh => 'TP. Hồ Chí Minh';

  @override
  String get cityHanoi => 'Hà Nội';

  @override
  String get translateTap => 'Chạm để dịch';

  @override
  String get translateShowOriginal => 'Đã dịch · chạm để xem bản gốc';

  @override
  String get translating => 'Đang dịch…';

  @override
  String get translateFailed => 'Không dịch được. Vui lòng thử lại sau.';

  @override
  String get translateDownloadTitle => 'Tải mô hình dịch';

  @override
  String get translateDownloadBody =>
      'Lần đầu dịch ngôn ngữ này cần tải mô hình dịch (khoảng 30 MB mỗi ngôn ngữ, chỉ một lần).\n\nViệc dịch diễn ra hoàn toàn trên điện thoại của bạn; tin nhắn không bao giờ được tải lên.';

  @override
  String get translateDownload => 'Tải xuống';

  @override
  String placeHint(String name) {
    return 'Gần đây có một ngọn đèn Điểm tâm trạng · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Mở cửa đến $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Điểm tâm trạng: $name, $hours';
  }

  @override
  String get placeWrongData => 'Thông tin bị sai?';

  @override
  String placeReportSubject(String name) {
    return 'Thông tin Điểm tâm trạng bị sai: $name';
  }

  @override
  String get placeHintsSetting => 'Gợi ý Điểm tâm trạng';

  @override
  String get placeHintsSettingSubtitle =>
      'Gợi ý nhẹ nhàng trong ứng dụng khi bạn đi ngang một Điểm tâm trạng đang mở cửa (không gửi thông báo đẩy)';

  @override
  String get guideS16Title => '10. Điểm tâm trạng';

  @override
  String get guideS16L1 =>
      'Điểm tâm trạng là các quán cà phê độc lập hợp tác với chúng tôi. Sau khi điểm danh, đi vào trong vòng 150 m quanh một quán đang mở cửa, trên radar sẽ hiện một ngọn đèn nhỏ thở chậm. Đi xa thì đèn tắt.';

  @override
  String get guideS16L2 =>
      'Chạm vào đèn để mở thẻ địa điểm: cảnh đêm nhìn từ trong quán, giờ đóng cửa hôm nay, một câu chuyện tâm trạng của quán (chạm để dịch), địa chỉ và số điện thoại. Chạm Đi bộ đến đó để xem đường đi bộ trong ứng dụng bản đồ. Đèn của thẻ bạn đã mở hôm nay sẽ sáng dịu và không thở nữa.';

  @override
  String get guideS16L3 =>
      'Lần đầu bạn đi ngang, một thẻ nhỏ ở phía trên sẽ báo cho bạn, không có âm thanh hay rung. Mỗi quán chỉ gợi ý tối đa một lần trong 7 ngày, mỗi ngày tối đa 2 lần. Tắt trong Cài đặt > Gợi ý Điểm tâm trạng; đèn vẫn hiện.';

  @override
  String get guideS16L4 =>
      'Toàn bộ danh sách địa điểm được tải về điện thoại của bạn, và việc bạn có ở gần hay không chỉ được xác định trên điện thoại. Chúng tôi và các quán đều không biết bạn đi ngang quán nào. Quán không thể trả tiền để được hiển thị nhiều hơn. Nếu thông tin sai, hãy báo ở cuối thẻ.';

  @override
  String get placeGuestbook => 'Sổ lưu bút';

  @override
  String placeGuestbookLocked(int m) {
    return 'Hãy vào trong quán (trong khoảng $m m) để đọc những lời người ngồi đây trước bạn để lại.';
  }

  @override
  String get placeGuestbookAbout =>
      'Chỉ người trong quán mới đọc được. Ẩn danh, biến mất sau 30 ngày.';

  @override
  String get placeGuestbookEmpty =>
      'Chưa có lời nhắn nào. Hãy để lại lời đầu tiên.';

  @override
  String get placeGuestbookWrite => 'Để lại lời nhắn';

  @override
  String get placeGuestbookHint => 'Gửi người tiếp theo ngồi ở đây…';

  @override
  String get placeGuestbookSent => 'Xong. Người tiếp theo ở đây sẽ đọc được.';

  @override
  String get placeGuestbookUnavailable =>
      'Sổ lưu bút hiện chưa dùng được. Vui lòng thử lại sau.';

  @override
  String get placeNoteMine => 'Lời nhắn của bạn';

  @override
  String get withdrawPlaceNote => 'Thu hồi lời nhắn này';

  @override
  String get reportPlaceNote => 'Báo cáo lời nhắn này';

  @override
  String get thisPlaceNote => 'lời nhắn này';

  @override
  String get guideS16L5 =>
      'Sổ lưu bút: mở thẻ địa điểm khi bạn đang ở trong quán (trong khoảng 40 m) để đọc những lời người ngồi đây trước bạn để lại, và để lại một câu cho người tiếp theo. Lời nhắn ẩn danh và biến mất sau 30 ngày. Mỗi quán bạn được để lại một lời nhắn mỗi ngày, chạm để dịch, và báo cáo những gì khiến bạn khó chịu. Khi bạn mở sổ lưu bút, điện thoại gửi vị trí đến máy chủ để xác nhận bạn đang ở trong quán; máy chủ không lưu lại.';

  @override
  String get quantumWorld => 'Thế giới lượng tử';

  @override
  String get quantumWorldSubtitle =>
      'Một căn phòng cho cả thế giới, không tiết lộ vị trí của bạn';

  @override
  String get quantumIntroTitle => 'Vào Thế giới lượng tử';

  @override
  String get quantumIntroBody =>
      'Mọi người đang ở Thế giới lượng tử lúc này đều chung một căn phòng, xếp thành tổ ong quanh Taipei 101. Bạn nhận một chỗ ngồi như \"Q4-17\" — vòng càng nhỏ càng gần tâm.\n\nKhông ai thấy được vị trí thật của bạn. Người khác chỉ thấy chỗ ngồi của bạn, được cố định lúc bạn chạm Vào; chỗ ngồi không di chuyển khi bạn đi bộ. Muốn đổi chỗ, hãy rời đi rồi vào lại. Biệt danh và tâm trạng giữ nguyên, bạn vẫn có thể gửi đốm sáng, gõ cửa và trò chuyện, chạm để dịch.\n\nTrong thời gian ở Thế giới lượng tử, bạn tạm rời radar thường và Vũ trụ song song; khi rời đi, bạn trở lại vị trí đã check-in.';

  @override
  String get quantumEnter => 'Vào';

  @override
  String get quantumLeave => 'Rời Thế giới lượng tử';

  @override
  String get quantumLeft => 'Bạn đã rời Thế giới lượng tử và trở lại radar';

  @override
  String quantumYourSeat(String code) {
    return 'Chỗ ngồi của bạn $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Vòng $ring · vòng càng nhỏ càng gần tâm Taipei 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count người lúc này';
  }

  @override
  String quantumOnlineTitle(int count) {
    return 'Lúc này có $count người ở Thế giới lượng tử';
  }

  @override
  String get quantumRegionTw => 'Đài Loan';

  @override
  String get quantumRegionJp => 'Nhật Bản';

  @override
  String get quantumRegionKr => 'Hàn Quốc';

  @override
  String get quantumRegionHkmo => 'Hồng Kông & Ma Cao';

  @override
  String get quantumRegionSea => 'Đông Nam Á';

  @override
  String get quantumRegionOther => 'Nơi khác';

  @override
  String get quantumQuiet => 'Lượng tử tĩnh lặng';

  @override
  String get quantumQuietSubtitle =>
      'Chỉ ngắm thế giới: không ai gõ cửa được, nhưng bạn vẫn nhận đốm sáng';

  @override
  String get quantumQuietTarget =>
      'Người này đã bật Lượng tử tĩnh lặng — giờ bạn chỉ có thể gửi đốm sáng';

  @override
  String get quantumClosedRegion =>
      'Thế giới lượng tử chưa mở ở khu vực của bạn';

  @override
  String get quantumLeftClosed =>
      'Bạn đã vào khu vực chưa mở Thế giới lượng tử nên đã tự động rời đi';

  @override
  String get quantumSeatExpired =>
      'Bạn rời đi quá lâu nên chỗ ngồi đã được giải phóng; bạn trở lại radar';

  @override
  String get quantumUnavailable =>
      'Hiện không vào được Thế giới lượng tử. Vui lòng thử lại sau.';

  @override
  String quantumPersonBody(String code) {
    return 'Chỗ ngồi của người này trong Thế giới lượng tử là $code. Không ai bị hiển thị vị trí thật trong Thế giới lượng tử.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Thế giới lượng tử · $code';
  }

  @override
  String get guideS17Title => '13. Thế giới lượng tử';

  @override
  String get guideS17L1 =>
      'Chạm biểu tượng tổ ong ở góc trên bên phải radar (dưới Vũ trụ song song), đọc phần giới thiệu rồi chạm Vào. Mỗi lần vào đều do bạn tự chạm, giống như check-in; mỗi lần mở ứng dụng bạn bắt đầu từ radar thường.';

  @override
  String get guideS17L2 =>
      'Mọi người trong Thế giới lượng tử chung một căn phòng: tổ ong quanh Taipei 101, các chỗ ngồi cách nhau 100 m. Bạn nhận mã chỗ ngồi như \"Q4-17\" (vòng 4, chỗ 17) — vòng càng nhỏ càng gần tâm. Người mới vào sẽ lấp chỗ người khác vừa rời trước; vòng 1–3 dành cho người tổ chức buổi tụ họp.';

  @override
  String get guideS17L3 =>
      'Không ai thấy được vị trí thật của bạn: người khác chỉ thấy chỗ ngồi của bạn. Mỗi lần chạm Vào là một lần check-in, chỗ ngồi được cố định từ lúc đó và không di chuyển khi bạn đi bộ. Muốn đổi chỗ, hãy rời đi rồi vào lại. Thế giới lượng tử không mở ở Trung Quốc đại lục.';

  @override
  String get guideS17L4 =>
      'Biệt danh và tâm trạng giữ nguyên, bạn vẫn có thể gửi đốm sáng, gõ cửa và trò chuyện, chạm để dịch. Chụm hai ngón để thu nhỏ và xem toàn bộ tổ ong; người ở xa trở thành chấm sáng. Chạm mã chỗ ngồi ở góc trên bên trái để xem số người trực tuyến, bật Lượng tử tĩnh lặng (không ai gõ cửa, vẫn nhận đốm sáng), hoặc rời đi.';

  @override
  String get guideS17L5 =>
      'Thế giới lượng tử không có lời thì thầm, thư gửi tương lai, điểm tâm trạng, Hải đăng thành phố hay buổi tụ họp. Trong thời gian ở trong, bạn tạm rời radar thường và Vũ trụ song song; khi rời đi, bong bóng tan thành ánh sáng và bạn trở lại vị trí đã check-in. Nếu ứng dụng bị đóng hoặc mất kết nối quá 3 phút, chỗ ngồi sẽ được giải phóng.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Chuông giờ sau $seconds giây';
  }

  @override
  String get quantumChimeLookOrigin => 'Mọi người đang nhìn về gốc 101';

  @override
  String get quantumChimeLook => 'Xem gốc';

  @override
  String quantumChimeNow(int hour) {
    return 'Chuông $hour giờ Trung tâm Lượng tử';
  }

  @override
  String get quantumChimeSend => 'Gửi đốm sáng chuông giờ';

  @override
  String get quantumChimeSent => 'Đốm sáng của bạn đang bay về gốc';

  @override
  String quantumChimeWatched(int n) {
    return '$n người đã cùng xem lần chuông này';
  }

  @override
  String get quantumChimeReminder => 'Nhắc chuông giờ';

  @override
  String get quantumChimeReminderSubtitle =>
      'Nhắc bạn trước mỗi giờ để xem chuông ở gốc 101';

  @override
  String get quantumChimeNotifyBody =>
      'Chuông giờ sắp bắt đầu — cùng xem ở gốc 101';

  @override
  String get quantumChimeChannel => 'Chuông giờ';

  @override
  String get quantumChimeChannelDesc => 'Nhắc chuông giờ của Thế giới lượng tử';

  @override
  String get quantumEntangleInvite => 'Mời rối lượng tử';

  @override
  String quantumEntangleInvited(String name) {
    return 'Đã mời $name rối lượng tử';
  }

  @override
  String get quantumEntangleAskTitle => 'Rối lượng tử';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) muốn rối lượng tử với bạn. Một sợi sáng sẽ nối hai bong bóng, dù cách xa bao nhiêu vẫn thấy. Khi một trong hai người rời đi, sợi sáng sụp đổ và không lưu lại gì.';
  }

  @override
  String get quantumEntangleAccept => 'Rối';

  @override
  String quantumEntangled(String name) {
    return 'Bạn và $name đã rối lượng tử';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Rối lượng tử với $name đã sụp đổ';
  }

  @override
  String get quantumEntangleCut => 'Gỡ rối';

  @override
  String get quantumEntangleFull => 'Bạn đã rối với 3 người rồi';

  @override
  String get quantumEntangleTheirFull => 'Người kia đã rối với 3 người rồi';

  @override
  String get quantumEntangleGone => 'Người kia đã rời Thế giới lượng tử';

  @override
  String get quantumEntangleExpired => 'Lời mời đã hết hạn';

  @override
  String get quantumEntangledTitle => 'Đang rối';

  @override
  String get quantumTunnel => 'Xuyên hầm lượng tử';

  @override
  String get quantumTunnelSubtitle =>
      'Nhảy tới một chỗ trống ngẫu nhiên trong tổ ong để gặp hàng xóm mới. Mỗi lần vào dùng được một lần.';

  @override
  String get quantumTunnelUsed => 'Lần vào này bạn đã xuyên hầm rồi';

  @override
  String quantumTunnelDone(String code) {
    return 'Đã xuyên hầm tới $code';
  }

  @override
  String get quantumShowTime => 'Hiện giờ địa phương của tôi';

  @override
  String get quantumShowTimeSubtitle =>
      'Người khác thấy khi nhấn giữ bong bóng của bạn. Khi tắt, chỉ hiện sắc ngày đêm.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Giờ địa phương $time · $part';
  }

  @override
  String get quantumDawn => 'sáng sớm';

  @override
  String get quantumDay => 'ban ngày';

  @override
  String get quantumDusk => 'hoàng hôn';

  @override
  String get quantumNight => 'đêm khuya';

  @override
  String get quantumTopicsTitle => 'Đồng tần lượng tử';

  @override
  String get quantumTopicsSubtitle =>
      'Chọn tối đa 3 chủ đề để hiện dưới bong bóng của bạn';

  @override
  String get quantumTopicMusic => 'Âm nhạc';

  @override
  String get quantumTopicMovies => 'Phim';

  @override
  String get quantumTopicTech => 'Công nghệ';

  @override
  String get quantumTopicWalks => 'Đi dạo';

  @override
  String get quantumTopicFood => 'Ẩm thực';

  @override
  String get quantumTopicTravel => 'Du lịch';

  @override
  String get quantumTopicReading => 'Đọc sách';

  @override
  String get quantumTopicSports => 'Thể thao';

  @override
  String quantumTopicsCommon(String topics) {
    return 'Cả hai cùng thích: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Tín hiệu lượng tử';

  @override
  String quantumSignalReceived(String name) {
    return '$name gửi cho bạn một tín hiệu';
  }

  @override
  String get quantumSignalWait => 'Bạn vừa gửi — chờ chút rồi gửi lại';

  @override
  String quantumResonance(String name) {
    return 'Bạn và $name đã cộng hưởng';
  }

  @override
  String get guideS17L6 =>
      'Chuông giờ: một phút trước mỗi giờ, cột sáng 101 sáng dần. Đúng giờ, sứ giả ánh sáng đi một vòng quanh gốc, chuông gõ theo giờ Trung tâm Lượng tử (0 giờ gõ 24 tiếng), và làn sóng sáng cuối cùng lan khắp tổ ong. Trong lúc chuông, chạm “Gửi đốm sáng chuông giờ” — càng nhiều người cùng xem, ánh sáng càng rực. Nhắc chuông giờ được bật sẵn; bạn có thể tắt trong bảng điều khiển.';

  @override
  String get guideS17L7 =>
      'Sau khi trò chuyện, bạn có thể mời rối lượng tử: một sợi sáng nối hai bong bóng dù cách xa bao nhiêu, sụp đổ khi một người rời đi (tối đa 3 người cùng lúc). Xuyên hầm lượng tử, mỗi lần vào một lần, đưa bạn tới một chỗ trống ngẫu nhiên với hàng xóm mới.';

  @override
  String get guideS17L8 =>
      'Mỗi bong bóng mang sắc giờ địa phương của chủ nhân: vàng nhạt lúc sáng sớm, trắng sáng ban ngày, cam tím lúc hoàng hôn, xanh thẫm đêm khuya. Bật “Hiện giờ địa phương của tôi” để người khác thấy giờ khi nhấn giữ bong bóng của bạn. Gửi đốm sáng cho nhau trong 24 giờ sẽ tạo cộng hưởng lượng tử; nhấn giữ bong bóng để gửi tín hiệu 👋 ☕ 🌙 🎵 🌧️ ✨; chọn tối đa 3 chủ đề đồng tần trong bảng điều khiển, chủ đề chung sẽ sáng lên.';

  @override
  String get quantumNyTitle => 'Năm mới lượng tử';

  @override
  String quantumNyDays(int n) {
    return 'Còn $n ngày: nửa đêm Trung tâm Lượng tử 12/31, cùng cả thế giới đếm ngược tại gốc 101';
  }

  @override
  String get quantumNyTonight =>
      'Nửa đêm nay tại Trung tâm Lượng tử, cùng cả thế giới đếm ngược tại gốc 101';

  @override
  String quantumNyZone(String places) {
    return 'Chúc mừng năm mới, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n người trên khắp thế giới đã cùng đón năm mới trong Thế giới lượng tử';
  }

  @override
  String get quantumNyHappy => 'Chúc mừng năm mới';

  @override
  String get guideS17L9 =>
      'Năm mới lượng tử: ngày 12/31, mỗi khi một múi giờ đến nửa đêm, các bong bóng ở đó lần lượt sáng vòng vàng như từng đợt sóng, và các đốm sáng trong chế độ xem thế giới cũng chuyển vàng. Đúng nửa đêm Trung tâm Lượng tử, cả tổ ong cùng đếm ngược 10 giây cuối, gốc 101 bùng lên vụ nổ ánh sáng lớn nhất thế giới và 5 phút pháo hoa, kèm số người đã cùng nhau đón năm mới.';

  @override
  String get quantumMeetAction => 'Tạo thẻ Gặp gỡ lượng tử';

  @override
  String quantumMeetAsked(String name) {
    return 'Đã mời $name cùng tạo thẻ Gặp gỡ lượng tử';
  }

  @override
  String get quantumMeetWait => 'Bạn vừa mời xong — thử lại sau một chút nhé';

  @override
  String get quantumMeetAskTitle => 'Thẻ Gặp gỡ lượng tử';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) muốn biến lần gặp này thành một tấm thẻ để chia sẻ. Thẻ có biệt danh, mã chỗ ngồi, giờ địa phương và tâm trạng của cả hai — không có bất kỳ vị trí nào.';
  }

  @override
  String get quantumMeetAccept => 'Cùng tạo';

  @override
  String get quantumMeetEyebrow => 'GẶP GỠ LƯỢNG TỬ';

  @override
  String get quantumMeetFooter => 'Chúng mình gặp nhau trong Thế giới lượng tử';

  @override
  String get quantumMeetShare => 'Chia sẻ thẻ';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — chúng mình gặp nhau trong Thế giới lượng tử ✨';
  }

  @override
  String get guideS17L10 =>
      'Thẻ Gặp gỡ lượng tử: sau khi đã trò chuyện, nhấn giữ bong bóng của họ để mời cùng tạo. Khi cả hai đồng ý, mỗi người nhận một tấm thẻ để chia sẻ với biệt danh, mã chỗ ngồi, giờ địa phương kèm màu ngày đêm và tâm trạng — không có vị trí. Mã chỗ ngồi vòng 4 có màu vàng.';

  @override
  String get quantumOrbEntry => 'Hình đại diện lượng tử';

  @override
  String get quantumOrbEntrySubtitle =>
      'Ảnh của bạn trở thành quả cầu pha lê trong Thế giới Lượng tử';

  @override
  String get orbTitle => 'Hình đại diện lượng tử';

  @override
  String get orbSubtitle =>
      'Viền kính và ánh sáng luôn theo màu tâm trạng của bạn';

  @override
  String get orbStyleGlow => 'Ánh sáng';

  @override
  String get orbStyleRing => 'Vành sao';

  @override
  String get orbStyleRainbow => 'Cầu vồng';

  @override
  String get orbFree => 'Miễn phí';

  @override
  String get orbOwned => 'Đã sở hữu';

  @override
  String get orbInUse => 'Đang dùng';

  @override
  String get orbCosmeticNote =>
      'Mẫu đặc biệt chỉ là vẻ ngoài, không thay đổi bất kỳ tính năng hay quyền lợi nào. Mẫu đã mua được lưu theo tài khoản.';

  @override
  String get orbRestore => 'Khôi phục giao dịch mua';

  @override
  String orbPurchased(String name) {
    return '$name đã là của bạn ✨';
  }

  @override
  String get orbPurchaseFailed =>
      'Giao dịch chưa hoàn tất. Vui lòng thử lại sau.';

  @override
  String get orbOwnedElsewhere =>
      'Giao dịch này đã được dùng cho một tài khoản khác';

  @override
  String get orbStoreUnavailable =>
      'Hiện không kết nối được cửa hàng. Vui lòng thử lại sau.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · AI';

  @override
  String get aiyaConsentTitle => 'Trước khi trò chuyện với AIYA';

  @override
  String get aiyaConsentBody =>
      'AIYA là AI chạy bằng Claude của Anthropic. Nội dung bạn gửi cho AIYA được Anthropic (Mỹ) xử lý mà không kèm danh tính, biệt danh hay vị trí của bạn, và sẽ bị xóa khi cuộc trò chuyện kết thúc. AIYA có thể sai và không đưa ra lời khuyên chuyên môn.';

  @override
  String get aiyaConsentAgree => 'Đồng ý và bắt đầu';

  @override
  String get aiyaConsentLater => 'Để sau';

  @override
  String get aiyaGreeting =>
      'Chào, mình là AIYA, ánh sáng ở trung tâm Thế giới Lượng tử. Tối nay bạn muốn nói gì?';

  @override
  String get aiyaFarewell =>
      'Hết giờ rồi, mình về lại trong ánh sáng đây. Nhớ mình thì gõ cửa nhé.';

  @override
  String get aiyaInputHint => 'Nói gì đó với AIYA…';

  @override
  String get aiyaSend => 'Gửi';

  @override
  String aiyaFreeLeft(int n) {
    return 'Hôm nay còn $n lượt miễn phí';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Gói thời gian: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'Còn $time';
  }

  @override
  String get aiyaEnd => 'Kết thúc';

  @override
  String get aiyaFiltered =>
      'Câu này có từ ngữ hoặc thông tin liên lạc không phù hợp. Thử nói cách khác nhé.';

  @override
  String get aiyaBusy => 'AIYA vừa lơ đãng một chút. Bạn nói lại được không?';

  @override
  String get aiyaRefused => 'Chuyện này mình không nói được. Đổi chủ đề nhé?';

  @override
  String get aiyaEnded => 'Cuộc trò chuyện này đã kết thúc.';

  @override
  String get aiyaNoQuotaTitle => 'Bạn đã dùng hết lượt miễn phí hôm nay';

  @override
  String get aiyaNoQuotaBody =>
      'Mỗi ngày có 3 lượt miễn phí, làm mới lúc 00:00 giờ Đài Loan. Muốn trò chuyện tiếp ngay, hãy mua gói thời gian. Mỗi lượt tối đa 10 phút.';

  @override
  String get aiyaResting => 'Tối nay AIYA mệt rồi. Hẹn mai nhé.';

  @override
  String get aiyaDailyMax =>
      'Hôm nay bạn đã trò chuyện nhiều rồi. Mai lại tìm AIYA nhé.';

  @override
  String aiyaPackTimes(int n) {
    return '$n lượt';
  }

  @override
  String get aiyaPackNote =>
      'Gói thời gian gắn với tài khoản trên điện thoại này và không khôi phục được nếu bạn xóa ứng dụng hoặc tài khoản.';

  @override
  String aiyaPurchased(int n) {
    return 'Đã thêm $n lượt ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'Giao dịch chưa hoàn tất. Vui lòng thử lại.';

  @override
  String get aiyaStoreUnavailable =>
      'Hiện không kết nối được cửa hàng. Vui lòng thử lại sau.';

  @override
  String get aiyaReport => 'Báo cáo câu trả lời này';

  @override
  String get aiyaReported =>
      'Đã nhận báo cáo. Chúng tôi sẽ xử lý trong 24 giờ.';

  @override
  String get aiyaSetting => 'AIYA (AI trong Thế giới Lượng tử)';

  @override
  String get aiyaSettingSubtitle =>
      'Khi tắt, AIYA sẽ không xuất hiện ở cột sáng Thế giới Lượng tử';

  @override
  String get aiyaCameoHello =>
      'Chào bạn, chào mừng đến Thế giới Lượng tử. Muốn trò chuyện thì chạm vào mình nhé.';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour giờ rồi. Mình ở đây trong ánh sáng cùng bạn.';
  }

  @override
  String get locationPickOnMap => 'Chọn trên bản đồ';

  @override
  String get locationPickTitle => 'Chọn nơi bạn đang ở';

  @override
  String get locationPickHint =>
      'Di chuyển bản đồ để chấm sáng ở giữa nằm đúng nơi bạn đang ở';

  @override
  String get locationPickConfirm => 'Tôi ở đây';

  @override
  String get aiyaPackEntry => '+ Gói thời gian';

  @override
  String get aiyaPacksTitle => 'Gói thời gian';

  @override
  String get aiyaPacksBody =>
      'Mỗi ngày bạn có 3 lượt trò chuyện miễn phí. Lượt trong gói thời gian chỉ được dùng sau khi hết lượt miễn phí. Mỗi lượt tối đa 10 phút.';

  @override
  String get guideS1L6 =>
      'Nếu không xác định được vị trí (ví dụ trong nhà, hoặc trên iPad không có GPS), hãy chạm \"Chọn trên bản đồ\": di chuyển bản đồ để chấm sáng ở giữa nằm đúng nơi bạn đang ở, rồi chạm \"Tôi ở đây\". Khi có vị trí thật, ứng dụng sẽ tự chuyển sang.';

  @override
  String get guideS17L11 =>
      'Hình đại diện lượng tử: chạm mã chỗ ngồi ở góc trên bên trái → \"Hình đại diện lượng tử\", hình đại diện của bạn trong Thế giới lượng tử sẽ thành một quả cầu pha lê. Ánh sáng và Vành sao miễn phí; Cầu vồng mua một lần, dùng mãi mãi, và \"Khôi phục giao dịch mua\" giúp lấy lại trên điện thoại mới hoặc sau khi cài lại.';

  @override
  String get guideS18Title => '14. AIYA · AI';

  @override
  String get guideS18L1 =>
      'AIYA là AI sống trong cột sáng ở trung tâm Thế giới lượng tử. Cô ấy không phải người thật và sẽ nói rõ điều đó. Trong Thế giới lượng tử, chạm \"AIYA · AI\" dưới cột sáng để gõ cửa và trò chuyện; trước lần đầu, hãy đọc thông báo ngắn và đồng ý.';

  @override
  String get guideS18L2 =>
      'Mỗi lượt trò chuyện tối đa 10 phút và 20 tin nhắn. Mỗi ngày có 3 lượt miễn phí, đặt lại lúc 00:00 giờ Đài Loan, tối đa 30 lượt mỗi ngày.';

  @override
  String get guideS18L3 =>
      'Gói thời gian: chạm \"+ Gói thời gian\" phía trên ô nhập bất cứ lúc nào để mua 5 hoặc 20 lượt; chúng chỉ được dùng sau khi hết lượt miễn phí. Gói thời gian gắn với tài khoản trên điện thoại này và không thể khôi phục sau khi xóa ứng dụng hoặc tài khoản. Đây là sản phẩm tiêu hao nên không có \"Khôi phục giao dịch mua\".';

  @override
  String get guideS18L4 =>
      'AIYA không biết và sẽ không hỏi vị trí hay danh tính của bạn; cô ấy chỉ thấy số liệu tâm trạng thành phố ẩn danh. Cô ấy không tán tỉnh, không nói chuyện tình dục, không đưa lời khuyên y tế, pháp lý hay tài chính. Nhấn giữ một câu trả lời để báo cáo. Cuộc trò chuyện chỉ được lưu tạm trong lượt đó và tự xóa ngay sau khi kết thúc.';

  @override
  String get guideS18L5 =>
      'Thỉnh thoảng AIYA xuất hiện trong cột sáng: lúc chuông báo giờ, lần đầu bạn vào Thế giới lượng tử mỗi ngày, hoặc tình cờ. Chạm vào cô ấy để bắt đầu trò chuyện. Nếu không muốn thấy cô ấy, hãy tắt \"AIYA (AI trong Thế giới Lượng tử)\" trong Cài đặt.';

  @override
  String get orbStyleXmas => 'Giáng sinh';

  @override
  String get orbStyleNewYear => 'Năm mới Lượng tử';

  @override
  String get orbLimited => 'Giới hạn';

  @override
  String orbLimitedUntil(String date) {
    return 'Giới hạn · đến $date';
  }

  @override
  String get aiyaFriendTitle => 'Bạn của AIYA';

  @override
  String get aiyaFriendSubtitle => 'Gói tháng tự động gia hạn';

  @override
  String get aiyaFriendPerk1 => '20 lượt trò chuyện mỗi ngày (miễn phí là 3)';

  @override
  String get aiyaFriendPerk2 => 'Mỗi lượt 20 phút hoặc 40 tin nhắn';

  @override
  String get aiyaFriendPerk3 => 'Vẫn trò chuyện được khi AIYA đang nghỉ';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA khoác diện mạo “Ánh sao” độc quyền (chỉ bạn thấy)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / tháng';
  }

  @override
  String get aiyaFriendSubscribe => 'Đăng ký';

  @override
  String get aiyaFriendTerms =>
      'Gói kéo dài 1 tháng và tự động gia hạn kèm thanh toán trừ khi bạn tắt tự động gia hạn ít nhất 24 giờ trước khi hết kỳ. Thanh toán do tài khoản Apple hoặc Google xử lý; bạn có thể quản lý hoặc hủy bất cứ lúc nào trong phần cài đặt gói đăng ký của tài khoản. Lượt trong Gói thời gian vẫn được giữ và chỉ dùng sau khi hết 20 lượt mỗi ngày.';

  @override
  String aiyaFriendActive(String date) {
    return 'Bạn là Bạn của AIYA đến $date';
  }

  @override
  String get aiyaFriendManage => 'Quản lý gói đăng ký';

  @override
  String get aiyaFriendRestore => 'Khôi phục giao dịch';

  @override
  String get aiyaFriendWelcome => 'Bạn đã trở thành Bạn của AIYA ✨';

  @override
  String get aiyaFriendRestored => 'Đã khôi phục Bạn của AIYA';

  @override
  String get aiyaFriendNotFound =>
      'Không tìm thấy gói Bạn của AIYA còn hiệu lực';

  @override
  String get aiyaFriendElsewhere => 'Gói này đã được dùng cho tài khoản khác';

  @override
  String get aiyaFriendEntry => 'Bạn của AIYA · 20 lượt/ngày';

  @override
  String aiyaFriendLeft(int n) {
    return 'Bạn của AIYA · hôm nay còn $n lượt';
  }

  @override
  String get guideS17L12 =>
      'Mẫu giới hạn: quả cầu pha lê Giáng sinh (vòng nguyệt quế, ngôi sao vàng lấp lánh, tuyết rơi) bán đến 12/25, và quả cầu pha lê Năm mới Lượng tử (vạch đồng hồ vàng và pháo hoa, rực nhất đúng lúc giao thừa) bán đến 1/1, giờ Đài Loan. Sau đó sẽ không bán lại; ai đã mua được giữ mãi và có thể khôi phục.';

  @override
  String get guideS14L6 =>
      'Các thành phố nước ngoài lấy ga trung tâm làm tâm, nơi không có ga trung tâm thì lấy tòa thị chính. Tọa độ song song: khi bật Vũ trụ song song, chạm nút bên trái quả địa cầu và chọn một thành phố để xem bạn đứng khoảng chỗ nào ở đó. Thẻ chia sẻ chỉ ghi thành phố, không ghi địa danh.';

  @override
  String get guideS14L7 =>
      'Hộ chiếu song song: trò chuyện với người ở thành phố song song, khi cả hai đã nói thì bạn có một con dấu của thành phố đó. Sưu tầm 5 thành phố để nhận quả cầu Hộ chiếu. Mở từ tọa độ song song hoặc Cài đặt. Người ở vũ trụ song song hiện giờ địa phương và màu trời dưới tên.';

  @override
  String get guideS17L13 =>
      'Tụ họp lượng tử: trong Thế giới lượng tử, buổi tụ họp trở thành Tụ họp lượng tử. Chạm mã chỗ ngồi ở góc trên bên trái → Mở tụ họp lượng tử, đặt tiêu đề, chọn biểu tượng và màu, bạn sẽ chuyển tới ghế chủ trì ở vòng 3 cạnh 101; mọi người chạm vòng sáng để tham gia. Chủ trì có thể đăng thông báo, kích hoạt Cổ vũ lượng tử (quả cầu của mọi người tham gia sáng cùng lúc) và chạm vào ai đó trên bản đồ để mời ra. Miễn phí mỗi tháng một buổi (30 phút, 50 người); 1 giờ 200 người hoặc 2 giờ 1.000 người cần vé chủ trì, một vé mở một buổi hoặc gia hạn một lần (tối đa 12 giờ), và có thể mua trước nhiều vé. Buổi tụ họp chỉ kết thúc khi chủ trì bấm kết thúc hoặc hết giờ, kể cả khi chủ trì rời Thế giới lượng tử hay đóng ứng dụng. Sau đó mọi người nhận thẻ kỷ niệm chỉ ghi số người và khu vực.';

  @override
  String get guideS17L14 =>
      'Quả cầu lớn dần: Vệt sao thêm một ngôi sao mỗi khi bạn hoàn thành một Thẻ gặp gỡ lượng tử (cùng một người tính một lần mỗi 24 giờ, tối đa 24 sao); Vân gỗ thêm một vòng cho mỗi 3 giờ ở Thế giới lượng tử (tối đa 12 vòng). Sự lớn dần gắn với tài khoản và tích lũy cả trước khi mua.';

  @override
  String get guideS17L15 =>
      'Quà tặng: chạm vào ai đó trên bản đồ, hoặc chọn Tặng quà ở góc trên bên phải cuộc trò chuyện, để tặng Bó hoa ánh sáng (ánh sáng nở trên màn hình người nhận và cánh hoa sáng quanh quả cầu trong 24 giờ), một kiểu quả cầu, hoặc cặp Vướng víu (mỗi người một quả, ghép đôi, nối bằng sợi dây sáng khi cả hai ở Thế giới lượng tử). Người nhận có thể nhận hoặc từ chối; quà bị từ chối hoặc 7 ngày không trả lời sẽ quay về để bạn tặng người khác. Có thể tắt nhận quà trong Cài đặt.';

  @override
  String get guideS17L16 =>
      'Thêm mẫu giới hạn: quả cầu Valentine bán đến 2/14 và quả cầu Hoa anh đào đến 4/10 (giờ Đài Loan). Sau đó không còn bán, người đã mua giữ mãi mãi.';

  @override
  String get guideS18L6 =>
      'Bạn của AIYA: chọn \"Bạn của AIYA\" trong \"+ Gói thời gian\". Đây là gói tháng tự động gia hạn: 20 lượt mỗi ngày, mỗi lượt đến 20 phút hoặc 40 tin nhắn, vẫn trò chuyện được khi AIYA nghỉ, và AIYA khoác diện mạo \"Ánh sao\" chỉ bạn thấy. Gói thời gian chỉ dùng sau khi hết 20 lượt mỗi ngày. Gói tự động gia hạn; hủy bất cứ lúc nào trong cài đặt gói đăng ký Apple hoặc Google, và chạm \"Khôi phục giao dịch\" trên điện thoại mới.';

  @override
  String get guideS18L7 =>
      'Gọi thoại: khi bạn còn thời gian gọi, mở AIYA sẽ kết nối cuộc gọi thoại ngay—nói chuyện bằng giọng như gọi điện và có thể ngắt lời bất cứ lúc nào; trong cuộc gọi, bên phải ô nhập có nút Tắt tiếng và ✕ để kết thúc. Gói thời gian gọi có 30, 60 và 180 phút, không hết hạn và được trừ theo số giây thực tế; Bạn của AIYA còn được tặng 60 phút mỗi tháng (chỉ trong tháng đó, không cộng dồn). Hết thời gian gọi? Bạn có thể nhắn tin trước. Lần gọi đầu tiên cần đồng ý riêng, và âm thanh do OpenAI xử lý; AIYA tự cúp máy sau 3 phút im lặng, mỗi cuộc gọi dài tối đa 60 phút.';

  @override
  String get mapConsentTitle => 'Hiển thị vị trí của bạn trên bản đồ?';

  @override
  String get mapConsentBody =>
      'Nếu bạn cho phép, mỗi lần bạn tự chạm Check-in (hoặc Vào trong Thế giới lượng tử), người dùng khác sẽ thấy nơi bạn check-in (không phải vị trí trực tiếp), biệt danh và tâm trạng của bạn trên bản đồ. Không có check-in tự động, và bạn biến khỏi bản đồ khi rời ứng dụng. Bạn có thể từ chối, và có thể tắt bất cứ lúc nào trong Cài đặt.';

  @override
  String get mapConsentAllow => 'Cho phép';

  @override
  String get mapConsentDecline => 'Không cho phép';

  @override
  String get mapConsentDeclined =>
      'Được rồi. Bạn sẽ không xuất hiện trên bản đồ của ai. Khi muốn check-in, hãy chạm lại.';

  @override
  String get mapConsentSetting => 'Hiển thị vị trí của tôi trên bản đồ';

  @override
  String get mapConsentSettingSubtitle =>
      'Tắt sẽ kết thúc check-in ngay; bạn sẽ không xuất hiện trên bản đồ của ai';

  @override
  String get wgErrInGroup => 'Bạn đã ở trong một nhóm. Hãy rời nhóm trước.';

  @override
  String get wgErrFull =>
      'Nhóm đã có 20 người. Hãy nhờ trưởng nhóm mua gói 7 ngày.';

  @override
  String get wgErrPaidFull => 'Nhóm đã đủ 100 người.';

  @override
  String get wgErrQr => 'Mã QR này đã được đổi. Hãy xin mã mới từ trưởng nhóm.';

  @override
  String get wgErrEnded => 'Nhóm này đã kết thúc hoặc không tồn tại.';

  @override
  String get wgErrFiltered => 'Nội dung có từ ngữ không phù hợp.';

  @override
  String get wgErrHostLeave =>
      'Trưởng nhóm không thể rời. Hãy chuyển giao hoặc giải tán trước.';

  @override
  String get wgErrBusy => 'Không kết nối được. Vui lòng thử lại.';

  @override
  String get wgErrName => 'Hãy đặt tên cho nhóm.';

  @override
  String get wgPassUnavailable => 'Cửa hàng hiện không khả dụng.';

  @override
  String get wgPassFailed => 'Mua chưa thành công.';

  @override
  String get wgPassDone => 'Đã bật gói 7 ngày. Nhóm có thể tối đa 100 người.';

  @override
  String get wgCreateTitle => 'Tạo nhóm';

  @override
  String get wgCreateBody =>
      'Nhóm riêng tư: chỉ người có mã QR của bạn mới vào được.';

  @override
  String get wgNameLabel => 'Tên nhóm';

  @override
  String get wgColorLabel => 'Màu nhóm';

  @override
  String wgDaysLabel(int n) {
    return '$n ngày, tính cả hôm nay';
  }

  @override
  String get wgFreeNote =>
      'Miễn phí đến 20 người. Nhiều hơn thì trưởng nhóm mua gói 7 ngày (tối đa 100).';

  @override
  String get wgCreateButton => 'Tạo nhóm';

  @override
  String wgJoined(String name, int no) {
    return 'Đã vào \"$name\". Bạn là số $no';
  }

  @override
  String get wgJoinTitle => 'Vào nhóm';

  @override
  String get wgJoinBody =>
      'Quét mã QR của trưởng nhóm bằng camera, hoặc nhập mã 8 ký tự.';

  @override
  String get wgJoinButton => 'Vào';

  @override
  String wgButtonLabel(String name) {
    return 'Nhóm $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit người';
  }

  @override
  String wgUntil(String date) {
    return 'đến $date';
  }

  @override
  String wgMyNo(int n) {
    return 'Tôi số $n';
  }

  @override
  String get wgCallButton => 'Gọi tập trung';

  @override
  String get wgCallDone => 'Đủ người, kết thúc tập trung';

  @override
  String get wgRollButton => 'Điểm danh';

  @override
  String wgRollSummary(int here, int total) {
    return 'Điểm danh: $here/$total đã đến';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n thành viên (chạm để ghi chú, chuyển giao hoặc xóa)';
  }

  @override
  String get wgNoMembers =>
      'Chưa có thành viên. Chạm \"Mã QR\" để mọi người quét.';

  @override
  String get wgQrButton => 'Mã QR';

  @override
  String get wgDissolveAsk =>
      'Giải tán nhóm? Mọi người sẽ được báo và dữ liệu bị xóa.';

  @override
  String get wgDissolve => 'Giải tán';

  @override
  String wgCallIn(int n) {
    return 'Tập trung sau $n phút';
  }

  @override
  String get wgCallNow => 'Tập trung ngay';

  @override
  String wgAckSummary(int acked, int total) {
    return 'Đã nhận $acked/$total';
  }

  @override
  String get wgAnswerHere => 'Tôi đến rồi';

  @override
  String get wgAnswer5min => 'Thêm 5 phút';

  @override
  String get wgAnswerHelp => 'Cần giúp';

  @override
  String get wgNoReply => 'Chưa trả lời';

  @override
  String get wgStateAck => 'Đã nhận';

  @override
  String get wgStateSeen => 'Đã xem';

  @override
  String get wgStateNone => 'Chưa phản hồi';

  @override
  String get wgPassTitle => 'Gói nhóm 7 ngày';

  @override
  String get wgPassBody =>
      'Miễn phí đến 20 người. Có gói thì nhóm này tối đa 100 người đến khi kết thúc. Mỗi lần mua chỉ cho nhóm này, không tự gia hạn.';

  @override
  String get wgPassButton => 'Mua gói 7 ngày';

  @override
  String wgHostIs(String name) {
    return 'Trưởng nhóm: $name';
  }

  @override
  String get wgNoCall =>
      'Hiện chưa có lệnh tập trung. Khi trưởng nhóm gọi, điện thoại sẽ đổ chuông.';

  @override
  String get wgRollAsk => 'Trưởng nhóm đang điểm danh';

  @override
  String get wgLeaveAsk => 'Rời nhóm này?';

  @override
  String get wgLeave => 'Rời nhóm';

  @override
  String get wgCallTitle => 'Tập trung!';

  @override
  String get wgAcked => '✓ Đã báo trưởng nhóm bạn đã nhận';

  @override
  String get wgAckButton => 'Đã nhận';

  @override
  String get wgCallSheetTitle => 'Gọi tập trung';

  @override
  String get wgNow => 'Ngay';

  @override
  String wgInMinutes(int n) {
    return 'Sau $n phút';
  }

  @override
  String get wgPlaceLabel => 'Điểm hẹn';

  @override
  String get wgPlaceHint => 'VD: Lối ra số 6 ga Ximen';

  @override
  String get wgPlaceNote => 'Điểm hẹn được đặt ở vị trí hiện tại của bạn.';

  @override
  String get wgSendCall => 'Gửi lệnh gọi';

  @override
  String get wgNoLocation => 'Không lấy được vị trí để đặt điểm hẹn.';

  @override
  String get wgQrTitle => 'Quét để vào nhóm';

  @override
  String get wgQrBody => 'Quét bằng camera, hoặc nhập mã bên dưới.';

  @override
  String wgShareText(String name, String url) {
    return 'Vào nhóm \"$name\" của mình: $url';
  }

  @override
  String get wgShare => 'Chia sẻ link';

  @override
  String get wgRotateAsk => 'Đổi mã QR? Mã và link cũ sẽ hết hiệu lực ngay.';

  @override
  String get wgRotate => 'Đổi mã QR';

  @override
  String wgMemberTitle(int no) {
    return 'Số $no';
  }

  @override
  String get wgEditNote => 'Ghi chú';

  @override
  String get wgHandoff => 'Chuyển làm trưởng nhóm';

  @override
  String wgHandoffAsk(int no) {
    return 'Chuyển nhóm cho số $no? Bạn sẽ thành thành viên.';
  }

  @override
  String get wgKick => 'Xóa khỏi nhóm';

  @override
  String wgKickAsk(int no) {
    return 'Xóa số $no khỏi nhóm?';
  }

  @override
  String get wgNotePrivate => 'Chỉ bạn thấy ghi chú, ví dụ tên hoặc số phòng.';

  @override
  String get wgSave => 'Lưu';

  @override
  String get wgConfirm => 'Xác nhận';

  @override
  String get wgCancel => 'Hủy';

  @override
  String get wgSettingCreate => 'Tạo nhóm';

  @override
  String get wgSettingCreateSub =>
      'Nhóm riêng cho chuyến đi, dã ngoại, leo núi';

  @override
  String get wgSettingJoin => 'Vào nhóm';

  @override
  String get wgSettingJoinSub => 'Nhập mã 8 ký tự của trưởng nhóm';

  @override
  String wgSettingOpen(String name) {
    return 'Nhóm của tôi: $name';
  }

  @override
  String get wgChannelName => 'Lệnh tập trung nhóm';

  @override
  String get wgChannelDesc => 'Khi trưởng nhóm gọi mọi người tập trung';

  @override
  String get guideS19Title => '15. Nhóm thì thầm';

  @override
  String get guideS19L1 =>
      'Nhóm thì thầm là nhóm riêng tư cho chuyến đi, dã ngoại, leo núi, đi chơi hoặc nhân viên sự kiện. Vào Cài đặt → Tụ họp → \"Tạo nhóm\", đặt tên, chọn màu và số ngày (tối đa 7).';

  @override
  String get guideS19L2 =>
      'Vào nhóm: trưởng nhóm chạm nút nhóm ở dưới bản đồ → \"Mã QR\"; thành viên quét bằng camera điện thoại và ứng dụng sẽ mở để vào nhóm. Hoặc vào Cài đặt → Tụ họp → \"Vào nhóm\" và nhập mã 8 ký tự. Người ngoài không thể tìm hay xin vào, và trưởng nhóm có thể đổi mã QR bất cứ lúc nào.';

  @override
  String get guideS19L3 =>
      'Gọi tập trung: trưởng nhóm chạm \"Gọi tập trung\", chọn giờ và mô tả điểm hẹn. Điện thoại thành viên phát âm thanh riêng kèm rung \"ngắn ngắn dài\"; trong ứng dụng có đếm ngược, khoảng cách và hướng đến điểm hẹn, cùng cột sáng trên bản đồ. Ai chưa chạm \"Đã nhận\" sẽ được nhắc mỗi phút, tối đa 3 lần; trưởng nhóm thấy ai đã nhận, ai đã xem và ai chưa phản hồi.';

  @override
  String get guideS19L4 =>
      'Điểm danh: trưởng nhóm chạm \"Điểm danh\"; thành viên nhận cùng âm thanh và rung, rồi chọn \"Tôi đến rồi\", \"Thêm 5 phút\" hoặc \"Cần giúp\". Trưởng nhóm không bao giờ thấy vị trí của thành viên, chỉ thấy câu trả lời.';

  @override
  String get guideS19L5 =>
      'Nhóm đến 20 người miễn phí. Nhiều hơn, trưởng nhóm có thể mua gói 7 ngày: tối đa 100 người đến khi nhóm kết thúc. Thành viên luôn miễn phí. Nhóm tồn tại tối đa 7 ngày; khi kết thúc, danh sách và dữ liệu bị xóa.';

  @override
  String get wgFlagButton => 'Giơ cờ';

  @override
  String get wgFlagHost => 'Trưởng nhóm';

  @override
  String get wgFlagHint =>
      'Giơ điện thoại lên để cả nhóm thấy bạn giữa đám đông. Chạm để đóng.';

  @override
  String get wgLostButton => 'Tôi bị lạc';

  @override
  String get wgFound => 'Tôi đã tìm thấy nhóm';

  @override
  String get wgLostSent =>
      'Đã gửi vị trí cho trưởng nhóm. Hãy đợi tại chỗ hoặc đi đến điểm hẹn.';

  @override
  String get wgLostTitleAsk => 'Gửi vị trí cho trưởng nhóm?';

  @override
  String get wgLostAsk =>
      'Vị trí hiện tại của bạn được gửi một lần cho trưởng nhóm; điện thoại của họ sẽ báo và hiện bạn trên bản đồ. Không theo dõi liên tục, tự xóa sau 30 phút. Chạm \"Tôi đã tìm thấy nhóm\" để xóa sớm hơn.';

  @override
  String get wgLostSend => 'Gửi vị trí của tôi';

  @override
  String wgLostTitle(int n) {
    return '$n thành viên bị lạc';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n phút trước';
  }

  @override
  String get wgNavigate => 'Chỉ đường';

  @override
  String get wgFoundThem => 'Đã tìm thấy';

  @override
  String get guideS19L6 =>
      'Tìm nhau: giữa đám đông, chạm \"Giơ cờ\" để cả màn hình nhấp nháy màu nhóm và hiện số của bạn. Nếu thật sự bị lạc, thành viên có thể chạm \"Tôi bị lạc\" để gửi vị trí hiện tại một lần cho trưởng nhóm (xóa sau 30 phút). Điện thoại trưởng nhóm sẽ báo, ghim đỏ hiện trên bản đồ và có thể chỉ đường.';

  @override
  String wgLostAlert(int no) {
    return 'Số $no bị lạc';
  }

  @override
  String wgHelpAlert(String no) {
    return 'Số $no cần giúp đỡ';
  }

  @override
  String get wgViewList => 'Mở nhóm';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour giờ rồi. Ai còn thức, mình ở trong ánh sáng cùng bạn.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour giờ, chào buổi sáng. Hôm nay cứ thong thả nhé.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour giờ rồi. Thành phố của bạn tối nay thế nào?';
  }

  @override
  String get aiyaCameoNyReady => 'Sẵn sàng chưa? Cùng đếm ngược nhé!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'Chúc mừng năm mới! $year, chúng ta cùng chung một căn phòng.';
  }

  @override
  String get aiyaSkinEntry => '✦ Diện mạo';

  @override
  String get aiyaSkinTitle => 'Diện mạo của AIYA';

  @override
  String get aiyaSkinSubtitle => 'Chỉ bạn thấy diện mạo AIYA của mình';

  @override
  String get aiyaSkinNone => 'Nguyên bản';

  @override
  String get aiyaSkinStarlight => 'Ánh sao';

  @override
  String get aiyaSkinStarlightSub => 'Dành cho Bạn của AIYA';

  @override
  String get aiyaSkinXmas => 'Giáng sinh';

  @override
  String get aiyaSkinNewYear => 'Năm mới Lượng tử';

  @override
  String get aiyaSkinNote =>
      'Diện mạo lễ hội mua một lần dùng mãi. Chỉ đổi dáng vẻ AIYA, không ảnh hưởng lượt trò chuyện. Bản giới hạn sẽ không bán lại sau khi hết hạn.';

  @override
  String get orbStyleStarTrail => 'Quỹ đạo sao';

  @override
  String get orbStyleRings => 'Vân gỗ';

  @override
  String get orbGrowNote =>
      'Quả cầu lớn dần: Quỹ đạo sao thêm một ngôi sao cho mỗi Thẻ gặp gỡ lượng tử (mỗi người tính một lần trong 24 giờ, tối đa 24). Vân gỗ thêm một vòng cho mỗi 3 giờ ở Thế giới lượng tử (tối đa 12). Tiến trình lưu theo tài khoản và bắt đầu tính từ bây giờ. Chỉ lưu số lượng, không lưu là ai hay ở đâu.';

  @override
  String orbGrowStars(int count) {
    return 'Đã có $count ngôi sao';
  }

  @override
  String orbGrowRings(int count) {
    return 'Đã có $count vòng';
  }

  @override
  String get giftAction => 'Tặng quà';

  @override
  String giftSheetTitle(String name) {
    return 'Tặng quà cho $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Chọn kiểu quả cầu tặng $name';
  }

  @override
  String get giftBouquetName => 'Bó hoa ánh sáng';

  @override
  String get giftBouquetDesc =>
      'Khi nhận, một bó ánh sáng nở ra, rồi cánh hoa ánh sáng quanh quả cầu suốt 24 giờ';

  @override
  String get giftOrbName => 'Tặng một kiểu quả cầu';

  @override
  String get giftOrbDesc => 'Bạn chọn; người nhận giữ mãi sau khi nhận';

  @override
  String get giftPairName => 'Cặp vướng víu';

  @override
  String get giftPairDesc =>
      'Mỗi người một quả, ghép đôi; dây ánh sáng nối hai bạn khi cùng ở Thế giới lượng tử';

  @override
  String get giftPairYouHave => 'Bạn đã có cặp vướng víu';

  @override
  String get giftNote =>
      'Người nhận có thể nhận hoặc từ chối. Nếu từ chối hoặc 7 ngày không trả lời, quà sẽ quay về với bạn.';

  @override
  String get giftVouchersTitle => 'Quà bị trả lại (không tốn thêm)';

  @override
  String get giftSendVoucher => 'Gửi';

  @override
  String giftSent(String name) {
    return 'Đã gửi quà cho $name. Đang chờ nhận.';
  }

  @override
  String get giftReturnedOff => 'Họ đã tắt nhận quà nên quà quay về với bạn';

  @override
  String get giftReturnedBlocked =>
      'Không thể tặng người này nên quà quay về với bạn';

  @override
  String get giftReturnedOwned =>
      'Họ đã có quả cầu này nên quà quay về; bạn có thể tặng kiểu khác';

  @override
  String get giftReturnedPaired => 'Họ đã có cặp vướng víu nên quà quay về';

  @override
  String get giftReturnedYouPaired => 'Bạn đã có cặp vướng víu nên quà quay về';

  @override
  String get giftReturnedGeneric =>
      'Quà đã quay về; bạn có thể tặng người khác';

  @override
  String get giftStoreUnavailable => 'Cửa hàng tạm thời không khả dụng';

  @override
  String get giftFailed => 'Tặng quà chưa thành công. Vui lòng thử lại sau.';

  @override
  String giftFromBouquet(String name) {
    return '$name gửi bạn bó hoa ánh sáng';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name tặng bạn quả cầu \"$style\"';
  }

  @override
  String giftFromPair(String name) {
    return '$name muốn ghép cặp vướng víu với bạn';
  }

  @override
  String get giftInboxTitle => 'Quà của bạn';

  @override
  String get giftInboxEmpty => 'Hiện chưa có quà';

  @override
  String get giftInboxNote =>
      'Quà từ chối sẽ trả lại người gửi; 7 ngày không trả lời cũng tự trả lại.';

  @override
  String get giftAccept => 'Nhận';

  @override
  String get giftDecline => 'Từ chối';

  @override
  String get giftDeclined => 'Đã từ chối. Quà sẽ trả lại người gửi.';

  @override
  String get giftAcceptedOrb => 'Đã nhận! Đổi trong Ảnh đại diện lượng tử.';

  @override
  String giftAcceptedPair(String name) {
    return 'Bạn và $name đã thành cặp vướng víu';
  }

  @override
  String get giftAcceptedBouquet =>
      'Đã nhận bó hoa. Cánh hoa ánh sáng sẽ quanh quả cầu của bạn 24 giờ.';

  @override
  String get giftAlreadyOwned => 'Bạn đã có quả cầu này; quà trả lại người gửi';

  @override
  String get giftAlreadyPaired =>
      'Một trong hai đã có cặp; quà trả lại người gửi';

  @override
  String get giftSettingsTitle => 'Quà';

  @override
  String get giftReceiveToggle => 'Nhận quà';

  @override
  String get giftReceiveToggleSub => 'Khi tắt, quà sẽ trả ngay về người gửi';

  @override
  String get giftVouchersHint =>
      'Chạm \"Tặng quà\" ở menu của ai đó để tặng lại';

  @override
  String get giftUnpair => 'Hủy cặp vướng víu';

  @override
  String giftUnpairConfirm(String name) {
    return 'Hủy cặp với $name? Cả hai vẫn giữ quả cầu nhưng dây ánh sáng sẽ mất.';
  }

  @override
  String get orbStylePair => 'Vướng víu';

  @override
  String giftPairedWith(String name) {
    return 'Cặp với $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Quà của bạn ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count món quà bị trả lại';
  }

  @override
  String get giftBlockedOff => 'Họ đã tắt nhận quà. Bạn chưa bị trừ tiền.';

  @override
  String get giftBlockedBlocked =>
      'Bạn không thể tặng quà cho người này. Bạn chưa bị trừ tiền.';

  @override
  String get giftBlockedOwned =>
      'Họ đã có quả cầu này. Hãy chọn kiểu khác (bạn chưa bị trừ tiền).';

  @override
  String get giftBlockedPaired =>
      'Họ đã có cặp vướng víu. Bạn chưa bị trừ tiền.';

  @override
  String get orbStyleValentine => 'Valentine';

  @override
  String get orbStyleSakura => 'Hoa anh đào';

  @override
  String get parallelCoords => 'Tọa độ song song';

  @override
  String parallelCoordsHome(String city, String km) {
    return 'Cách trung tâm $city $km km';
  }

  @override
  String parallelCoordsIn(String city) {
    return 'Ở $city, bạn đang đứng quanh';
  }

  @override
  String get parallelCoordsSea => 'Trên biển, hoặc nơi không có tên';

  @override
  String get parallelCoordsOutside => 'Ngoài phạm vi thành phố này';

  @override
  String parallelCoordsNote(String city) {
    return 'Khi người ở $city bật Vũ trụ song song, họ sẽ thấy bạn quanh khu vực này (làm mờ khoảng 500 m).';
  }

  @override
  String get parallelCoordsFailed =>
      'Chưa tìm được tên địa điểm. Hãy thử lại sau.';

  @override
  String parallelCardTitle(String city) {
    return 'Lúc này, tôi đang ở $city song song';
  }

  @override
  String parallelCardShareText(String city) {
    return 'Lúc này, tôi đang ở $city song song. Mở Mood Whisper để bước vào một thành phố khác nhé.';
  }

  @override
  String get parallelCoordsShare => 'Chia sẻ thẻ';

  @override
  String get orbStylePassport => 'Hộ chiếu';

  @override
  String get passportTitle => 'Hộ chiếu song song';

  @override
  String passportCount(int count) {
    return 'Đã sưu tầm $count thành phố';
  }

  @override
  String passportRewardProgress(int count) {
    return 'Sưu tầm thêm $count thành phố để nhận quả cầu Hộ chiếu';
  }

  @override
  String get passportRewardDone =>
      'Bạn đã có quả cầu Hộ chiếu. Hãy dùng trong Hóa thân lượng tử.';

  @override
  String get passportRewardToast =>
      '5 thành phố! Bạn nhận được quả cầu Hộ chiếu';

  @override
  String get passportEmpty =>
      'Trò chuyện với người ở thành phố khác trong Vũ trụ song song. Khi cả hai đã nói ít nhất một câu, thành phố đó được đóng dấu vào hộ chiếu. Chỉ lưu thành phố và ngày, không lưu bạn đã nói chuyện với ai.';

  @override
  String passportNewStamp(String city) {
    return 'Dấu mới: $city';
  }

  @override
  String get passportShare => 'Chia sẻ hộ chiếu';

  @override
  String passportCardTitle(int count) {
    return 'Hộ chiếu song song của tôi\n$count thành phố';
  }

  @override
  String passportCardShareText(int count) {
    return 'Hộ chiếu song song của tôi đã có dấu của $count thành phố. Mở Mood Whisper và bước vào Vũ trụ song song nhé.';
  }

  @override
  String get asmTitle => 'Buổi tụ họp lượng tử';

  @override
  String get asmCreateTitle => 'Tổ chức buổi tụ họp lượng tử';

  @override
  String get asmCreateIntro =>
      'Bạn ngồi vào ghế chủ trì ở vòng 3 cạnh 101. Mọi người trong Thế giới lượng tử đều thấy vầng sáng của buổi tụ họp và có thể tự nguyện tham gia.';

  @override
  String get asmTitleHint => 'Chủ đề (ví dụ: Cùng ngắm mưa sao băng)';

  @override
  String get asmPlanFree => 'Miễn phí tháng này';

  @override
  String get asmPlanFreeSub => '30 phút · tối đa 50 người · mỗi tháng một lần';

  @override
  String get asmPlanFreeUsed => 'Bạn đã dùng buổi miễn phí của tháng này';

  @override
  String get asmPlan1h => '1 giờ';

  @override
  String get asmPlan1hSub => 'Tối đa 200 người';

  @override
  String get asmPlan2h => '2 giờ';

  @override
  String get asmPlan2hSub => 'Tối đa 1.000 người';

  @override
  String asmVoucherCount(int count) {
    return 'Có $count vé chủ trì';
  }

  @override
  String get asmExtendTitle => 'Gia hạn buổi tụ họp';

  @override
  String get asmExtendHint =>
      'Dùng vé chủ trì để thêm giờ. Tối đa 12 giờ mỗi buổi.';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours giờ · $price';
  }

  @override
  String get asmExtended => 'Đã gia hạn buổi tụ họp';

  @override
  String get asmEndingSoon =>
      'Buổi tụ họp của bạn còn chưa tới 10 phút. Có thể gia hạn trong thẻ buổi tụ họp.';

  @override
  String get asmErrTooLong => 'Mỗi buổi tụ họp tối đa 12 giờ';

  @override
  String get asmBuyMore => 'Mua thêm vé';

  @override
  String get asmBuyMoreHint => 'Mua trước, dùng khi mở hoặc gia hạn';

  @override
  String get asmRules =>
      'Một vé chủ trì mở một buổi tụ họp hoặc gia hạn buổi đang diễn ra. Thời gian không dùng hết không được hoàn tiền. Tiêu đề và thông báo được lọc; vi phạm sẽ bị đình chỉ.';

  @override
  String get asmStart => 'Bắt đầu';

  @override
  String get asmStarted => 'Buổi tụ họp đã bắt đầu!';

  @override
  String get asmVoucherReady => 'Vé chủ trì đã sẵn sàng';

  @override
  String get asmBuyFailed =>
      'Giao dịch chưa hoàn tất. Bạn không bị trừ tiền, hoặc sẽ được cộng sau.';

  @override
  String asmHostLine(String name, String code) {
    return 'Chủ trì $name · ⬡ $code';
  }

  @override
  String get asmJoin => 'Tham gia';

  @override
  String get asmJoined => 'Bạn đã tham gia';

  @override
  String get asmLeave => 'Rời đi';

  @override
  String get asmHostPanel => 'Bảng điều khiển chủ trì';

  @override
  String get asmAnnounceHint => 'Đăng thông báo (tối đa 100 ký tự)';

  @override
  String get asmAnnounceSend => 'Đăng';

  @override
  String get asmAnnounced => 'Đã đăng thông báo';

  @override
  String get asmCheerTitle =>
      'Cổ vũ lượng tử: chọn màu và đếm ngược, quả cầu của mọi người tham gia sẽ cùng sáng một lúc';

  @override
  String get asmCheerNow => 'Ngay';

  @override
  String asmCheerIn(int n) {
    return 'Sau $n giây';
  }

  @override
  String get asmCheer => 'Cổ vũ!';

  @override
  String get asmRemoveHint =>
      'Để mời ai đó ra, chạm vào người đó trên bản đồ → Mời ra khỏi buổi tụ họp';

  @override
  String get asmEnd => 'Kết thúc';

  @override
  String get asmReport => 'Báo cáo buổi tụ họp này';

  @override
  String get asmErrFreeUsed => 'Bạn đã dùng buổi miễn phí của tháng này';

  @override
  String get asmErrSeatsFull => 'Ghế chủ trì ở vòng 3 đã kín. Hãy thử lại sau.';

  @override
  String get asmErrBlocked => 'Chủ đề hoặc thông báo có nội dung không phù hợp';

  @override
  String get asmErrFull => 'Buổi tụ họp đã đủ người';

  @override
  String get asmErrRemoved => 'Bạn đã bị mời ra khỏi buổi tụ họp này';

  @override
  String get asmErrEnded => 'Buổi tụ họp đã kết thúc';

  @override
  String get asmErrTooSoon => 'Nhanh quá. Đợi một chút rồi thử lại.';

  @override
  String get asmErrHidden => 'Tài khoản của bạn hiện chưa thể tổ chức';

  @override
  String get asmErrHosting => 'Bạn đang chủ trì một buổi khác';

  @override
  String get asmErrGeneric => 'Đã xảy ra lỗi. Hãy thử lại sau.';

  @override
  String get asmMemorialEyebrow => 'Thẻ kỷ niệm buổi tụ họp lượng tử';

  @override
  String get asmMemorialUnit => 'người';

  @override
  String get asmMemorialTogether => 'cùng ở Thế giới lượng tử';

  @override
  String shareCardFindUs(String name) {
    return 'Tìm “$name” trên App Store';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'Tìm “$name” trên Google Play';
  }

  @override
  String get asmShareCard => 'Chia sẻ thẻ kỷ niệm';

  @override
  String asmShareText(String title, int count) {
    return 'Chúng tôi đã tổ chức \"$title\" trong Thế giới lượng tử với $count người. Mở Mood Whisper để cùng tham gia lần sau.';
  }

  @override
  String get asmOpenEntry => 'Tổ chức buổi tụ họp lượng tử';

  @override
  String get asmOpenEntrySub =>
      'Ngồi ghế chủ trì cạnh 101 và tổ chức buổi tụ họp mà ai trên thế giới cũng có thể tham gia';

  @override
  String get asmRemoveMember => 'Mời ra khỏi buổi tụ họp';

  @override
  String get asmRemovedDone => 'Đã mời ra khỏi buổi tụ họp';

  @override
  String get aiyaFriendPerk5 => 'Mỗi tháng 60 phút gọi thoại với AIYA';

  @override
  String get aiyaVoiceOn => 'Giọng đọc: bật';

  @override
  String get aiyaVoiceOff => 'Giọng đọc: tắt';

  @override
  String get aiyaVoiceFriendOnly => 'Giọng đọc dành cho Bạn của AIYA';

  @override
  String get aiyaVoiceDailyMax =>
      'Hôm nay đã hết lượt giọng đọc. Ngày mai nghe AIYA nói tiếp nhé';

  @override
  String get aiyaCallTooltip => 'Gọi thoại với AIYA';

  @override
  String get aiyaCallConsentTitle => 'Gọi thoại với AIYA';

  @override
  String get aiyaCallConsentBody =>
      'Khi gọi thoại, giọng nói của bạn được gửi trực tiếp tới OpenAI (Mỹ) để AI xử lý và trả lời. Không gửi danh tính, biệt danh hay vị trí của bạn; chúng tôi không ghi âm và không lưu cuộc gọi. AIYA là AI, câu trả lời có thể sai và không phải lời khuyên chuyên môn.';

  @override
  String get aiyaCallAgree => 'Đồng ý và gọi';

  @override
  String get aiyaCallConnecting => 'Đang kết nối…';

  @override
  String aiyaCallLive(String time) {
    return 'Đang gọi · còn $time';
  }

  @override
  String get aiyaHangUp => 'Gác máy';

  @override
  String get aiyaCallEnded => 'Cuộc gọi kết thúc';

  @override
  String get aiyaCallTimeUp =>
      'Bạn đã trò chuyện một tiếng rồi. Nghỉ chút rồi gọi AIYA tiếp nhé';

  @override
  String get aiyaCallDailyMax =>
      'Đã hết 2 cuộc gọi hôm nay. Ngày mai gọi AIYA tiếp nhé';

  @override
  String get aiyaCallMonthMax =>
      'Đã hết lượt gọi tháng này. Tháng sau gọi AIYA tiếp nhé';

  @override
  String get aiyaCallResting =>
      'Đường dây giọng nói của AIYA hôm nay quá bận. Thử lại sau nhé';

  @override
  String get aiyaCallMicDenied =>
      'Hãy cho phép micrô để gọi AIYA. Bạn có thể bật trong Cài đặt của điện thoại';

  @override
  String get aiyaCallFailed => 'Không kết nối được. Vui lòng thử lại sau';

  @override
  String aiyaCallsLeft(int today, int month) {
    return 'Hôm nay còn $today cuộc · tháng này còn $month';
  }

  @override
  String get aiyaCallIdle => 'Một lúc không ai nói nên cuộc gọi đã kết thúc';

  @override
  String get aiyaCallMute => 'Tắt tiếng';

  @override
  String get aiyaCallUnmute => 'Bật tiếng';

  @override
  String aiyaCallPurchased(int minutes) {
    return 'Đã thêm $minutes phút gọi';
  }

  @override
  String get aiyaCallOutOfTime => 'Đã hết thời gian gọi';

  @override
  String get aiyaCallPacksTitle => 'Gọi thoại với AIYA';

  @override
  String get aiyaCallPacksBody =>
      'Trò chuyện với AIYA bằng giọng nói, như gọi điện. Mua thời gian gọi để bắt đầu; Bạn của AIYA còn được tặng 60 phút mỗi tháng.';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get aiyaCallFriendOption =>
      'Trở thành Bạn của AIYA (60 phút mỗi tháng)';

  @override
  String get aiyaCallTextInstead => 'Nhắn tin trước đã';

  @override
  String get aiyaCallPackNote =>
      'Thời gian gọi không hết hạn và được trừ theo số giây thực tế. Mặt hàng tiêu hao không thể khôi phục.';

  @override
  String aiyaCallMinutesLeft(int n) {
    return 'Còn $n phút gọi';
  }

  @override
  String get asmQ2Section =>
      'Q2 phát trực tiếp giọng nói (ghế chủ trì ở vòng 2)';

  @override
  String get asmQ2Intro =>
      'Mọi tính năng của Q3, thêm phát trực tiếp giọng nói và hỏi đáp: nói với mọi người tham gia, mời người giơ tay lên sân khấu, mọi người gửi câu hỏi bằng chữ và bấm thích.';

  @override
  String get asmPlanQ2_1h => 'Q2 · 1 giờ';

  @override
  String get asmPlanQ2_1hSub => 'Tối đa 200 người, live giọng nói + hỏi đáp';

  @override
  String get asmPlanQ2_2h => 'Q2 · 2 giờ';

  @override
  String get asmPlanQ2_2hSub => 'Tối đa 1000 người, live giọng nói + hỏi đáp';

  @override
  String get asmErrQ2Unavailable => 'Hiện chưa mở phát trực tiếp giọng nói';

  @override
  String get asmQ2JoinHint => 'Tham gia để nghe live, giơ tay và đặt câu hỏi';

  @override
  String get asmLiveOn => 'Đang live';

  @override
  String get asmLiveConnecting => 'Đang kết nối…';

  @override
  String get asmLiveError => 'Không kết nối được live';

  @override
  String get asmLiveOff => 'Chưa kết nối live';

  @override
  String asmLiveStage(String names) {
    return 'Trên sân khấu: $names';
  }

  @override
  String get asmLiveMicOn => 'Bật mic';

  @override
  String get asmLiveMicOff => 'Tắt mic';

  @override
  String get asmLiveHandUp => 'Giơ tay';

  @override
  String get asmLiveHandDown => 'Hạ tay';

  @override
  String get asmLiveMute => 'Tắt tiếng live';

  @override
  String get asmLiveUnmute => 'Bật tiếng live';

  @override
  String get asmLiveMusicMode => 'Chế độ âm nhạc';

  @override
  String get asmLiveMusicHint =>
      'Chất lượng âm thanh cao hơn, không lọc tiếng ồn, dành cho nhạc bạn tự chơi hoặc có quyền. Không được phát bài hát thương mại chưa được cấp phép.';

  @override
  String get asmLiveSpeakers => 'Khách trên sân khấu';

  @override
  String get asmLiveMuteGuest => 'Tắt mic';

  @override
  String get asmLiveOffStage => 'Mời xuống';

  @override
  String asmLiveHands(int count) {
    return '$count người giơ tay';
  }

  @override
  String get asmLiveInvite => 'Mời lên sân khấu';

  @override
  String get asmLiveNoRecording =>
      'Buổi live không được ghi âm và không lưu giọng nói.';

  @override
  String get asmLiveOnStage =>
      'Chủ trì đã mời bạn lên sân khấu. Bạn có thể bật mic để nói';

  @override
  String get asmLiveMicDenied =>
      'Không có quyền dùng micro nên chỉ nghe được. Bạn có thể bật trong Cài đặt.';

  @override
  String get asmLiveStageFull => 'Sân khấu đã có 3 khách';

  @override
  String get asmLiveGone => 'Người đó đã rời buổi tụ họp';

  @override
  String get asmAskOpen => 'Câu hỏi';

  @override
  String get asmAskTitle => 'Câu hỏi';

  @override
  String get asmAskHint =>
      'Gửi câu hỏi, mọi người có thể bấm thích, câu nhiều lượt thích sẽ lên đầu. Chủ trì sẽ chọn câu để trả lời.';

  @override
  String get asmAskHostHint =>
      'Câu hỏi được xếp theo lượt thích. Bạn có thể đánh dấu đã trả lời hoặc ẩn câu không phù hợp.';

  @override
  String get asmAskInput => 'Bạn muốn hỏi chủ trì điều gì? (tối đa 80 ký tự)';

  @override
  String get asmAskSend => 'Gửi';

  @override
  String get asmAskSent => 'Đã gửi câu hỏi';

  @override
  String get asmAskEmpty => 'Chưa có câu hỏi nào';

  @override
  String get asmAskAnswered => 'Đánh dấu đã trả lời';

  @override
  String get asmAskReopen => 'Chuyển về chưa trả lời';

  @override
  String get asmAskHide => 'Ẩn';

  @override
  String get asmAskTooMany => 'Bạn đã hỏi 5 câu trong buổi này';
}
