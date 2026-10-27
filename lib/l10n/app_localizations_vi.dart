// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

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
  String get releaseNotesTitle => 'Mood Whisper 1.1 bản thử nội bộ';

  @override
  String get releaseNotesLead => 'Thành phố đã khoác lên màu đêm.';

  @override
  String get releaseNotesMap =>
      'Bản đồ đêm mới: khu phố xanh thẫm, con đường phát sáng, tòa nhà neon';

  @override
  String get releaseNotesBubbles =>
      'Bong bóng tâm trạng giờ là kính tối, dễ đọc ở mọi nơi';

  @override
  String get releaseNotesResting =>
      'Đang nghỉ và dư ảnh: người khác vẫn gõ cửa được khi màn hình bạn khóa';

  @override
  String get releaseNotesSafety => 'Báo cáo và chặn giúp thành phố an toàn';

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
      'Viết một câu về cảm xúc lúc này (tối đa 20 ký tự), đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư, rồi chạm Vào Mood Whisper.';

  @override
  String get guideS1L3 =>
      'Không cần số điện thoại, email hay tên thật. Tài khoản ẩn danh và gắn với điện thoại này.';

  @override
  String get guideS1L4 =>
      'Từ ngữ trong tâm trạng quyết định màu sắc: “vui, cười” vàng kim, “buồn, khóc” xanh dương, “giận” đỏ cam, “bình yên, thẫn thờ” xanh lá, “nhiệt huyết” cam, “yêu, tim” hồng, còn lại là tím nhạt.';

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
      'Bong bóng đang thở nghĩa là người đó đang dùng ứng dụng. Bong bóng mờ có chữ Đang nghỉ nghĩa là họ đã khóa màn hình, nhưng bạn vẫn gõ cửa được. Bong bóng xám không tên là dư ảnh của người vừa rời đi, và sẽ mờ dần.';

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
      'Buổi tụ họp bao phủ 5 km quanh người tổ chức và di chuyển theo họ. Người tổ chức có vòng sáng và nhãn Tổ chức trên radar.';

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
  String get guideS10Title => '10. Thẻ tâm trạng và dấu vết tâm trạng';

  @override
  String get guideS10L1 =>
      'Nút chia sẻ ở thanh dưới biến tâm trạng hiện tại thành thẻ cảnh đêm, hợp với Instagram Stories. Thẻ không bao giờ hiện vị trí của bạn.';

  @override
  String get guideS10L2 =>
      'Cài đặt → Dấu vết tâm trạng cho bạn xem lại những tâm trạng và nơi bạn đã viết. Dữ liệu chỉ lưu trên điện thoại, có thể tắt hoặc xóa bất cứ lúc nào.';

  @override
  String get guideS11Title => '11. Cài đặt và thông báo';

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
  String get guideS12Title => '12. Báo cáo và chặn';

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
  String get guideS13Title => '13. Quyền riêng tư và tài khoản';

  @override
  String get guideS13L1 =>
      'Người gần đó thấy được tâm trạng, biệt danh, ảnh và khoảng cách gần đúng của bạn. Vị trí chỉ được dùng khi bạn đang dùng ứng dụng.';

  @override
  String get guideS13L2 =>
      'Cài đặt → Xóa tài khoản và dữ liệu sẽ xóa vĩnh viễn mọi thứ bạn để lại trong thành phố, bất cứ lúc nào.';

  @override
  String get guideS13L3 =>
      'Có câu hỏi? Vào Cài đặt → Liên hệ, hoặc gửi email đến service.softchip@gmail.com.';

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
      'Nhắm mắt lại, cảm nhận rung động của điện thoại và nhịp tim. Giờ hãy viết cảm xúc lúc này và bước vào Mood Whisper.';

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
  String get loginTitle2 => 'gặp gỡ chưa?';

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
      'Khi bật, mọi người đang trực tuyến ở các thành phố khác sẽ được chiếu lên radar của bạn, và tất cả họ đều thấy bạn.\n\nVị trí được chiếu theo tỷ lệ thành phố và làm mờ khoảng 500 m, nên không ai thấy được vị trí hay khoảng cách thật của bạn. Bạn vẫn có thể gửi ánh sáng, gõ cửa và trò chuyện, và tắt bất cứ lúc nào.';

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
}
