// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get checkInEnter => '여기서 체크인하고 들어가기';

  @override
  String get checkInNote =>
      '누르면 근처 사람들이 지금 내 기분과 대략적인 위치를 볼 수 있어요. 들어올 때마다 직접 체크인해요.';

  @override
  String get checkInTitle => '체크인하고 도시로';

  @override
  String get checkInBody =>
      '체크인하면 근처 사람들이 지금 내 기분과 대략적인 위치를 볼 수 있고, 나도 그들을 볼 수 있어요. 보이는 곳은 체크인한 장소이고, 내가 움직여도 따라오지 않아요. 앱을 열 때마다 직접 체크인해야 하며, 자동으로 체크인되지 않아요. 앱을 나가거나 다른 앱으로 전환하면 체크인이 끝나요.';

  @override
  String get checkInButton => '여기서 체크인';

  @override
  String get checkInAgain => '체크인한 곳을 떠났어요 · 여기서 다시 체크인';

  @override
  String get checkOutButton => '체크인 중 · 체크아웃';

  @override
  String get checkedOutToast => '체크아웃했어요. 이제 지도에 보이지 않아요.';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => '기쁨';

  @override
  String get moodSad => '슬픔';

  @override
  String get moodAngry => '화남';

  @override
  String get moodCalm => '평온';

  @override
  String get moodPassion => '열정';

  @override
  String get moodLove => '사랑';

  @override
  String get moodOther => '기타';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name 모임이 끝났어요';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return '$emoji $name의 진행을 넘겼어요. 이제 참가자예요.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return '진행을 넘겼어요. 닉네임이 이미 10자라서, 공지를 계속 받으려면 $emoji를 직접 닉네임에 넣어 주세요.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return '진행을 넘겼어요. 닉네임에 $emoji를 넣어 두었으니 이제 참가자예요.';
  }

  @override
  String get gotIt => '알겠어요';

  @override
  String get blockedToast => '이 사람을 어둠 속으로 보냈어요.';

  @override
  String get unblockedToast => '차단을 풀었어요. 다시 길이 겹칠 수 있어요.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => '위치 서비스를 켜 주세요';

  @override
  String get locationServiceOffBody =>
      '근처 사람들이 내 무드를 볼 수 있으려면 도시의 어느 곳에 있는지 알아야 해요. 휴대폰 \'설정\'에서 \'위치 서비스\'를 켜 주세요.';

  @override
  String get locationReducedTitle => '\'정확한 위치\'를 켜 주세요';

  @override
  String get locationReducedBodyIos =>
      '대략적인 위치만 공유하고 있어서 레이더가 근처에 누가 있는지 알 수 없어요. \'설정\' › \'Mood Whisper\' › \'위치\'에서 \'정확한 위치\'를 켜 주세요.';

  @override
  String get locationReducedBodyAndroid =>
      '대략적인 위치만 공유하고 있어서 레이더가 근처에 누가 있는지 알 수 없어요. 위치 권한에서 \'정확한 위치\'를 선택해 주세요.';

  @override
  String get locationNoFixTitle => '아직 위치를 찾지 못했어요';

  @override
  String get locationNoFixBody =>
      '실내이거나 신호가 약할 수 있어요. 창가나 바깥으로 이동하고 Wi-Fi를 켠 뒤 다시 시도해 주세요.';

  @override
  String get locationNeededTitle => '위치 정보가 필요해요';

  @override
  String get locationNeededBody =>
      'Mood Whisper는 앱을 사용하는 동안에만 위치를 사용해 5km 안의 무드를 보여 줘요. 레이더에는 대략적인 거리만 표시되고 주소는 표시되지 않아요.\n설정에서 \'앱을 사용하는 동안\' 위치 접근을 허용하고 \'정확한 위치\'를 켜 주세요.';

  @override
  String get locationSimulatorHint =>
      '(개발 메모: 시뮬레이터에서는 Features › Location에서 위치를 선택하세요)';

  @override
  String get openSettings => '설정 열기';

  @override
  String get locationRecheck => '켰어요, 다시 확인';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get leaveApp => '나가기';

  @override
  String whispersNearby(int count) {
    return '근처에 속삭임이 $count개 있어요. 봉투를 눌러 읽어 보세요.';
  }

  @override
  String get whisperPassed => '속삭임 옆을 지나갔어요. 봉투를 눌러 읽어 보세요.';

  @override
  String get whisperLeft => '속삭임을 여기에 남겼어요. 7일 뒤에 사라져요.';

  @override
  String get timeWhisperSealedYear => '봉인했어요. 1년 뒤 이곳에 돌아오면 열 수 있어요.';

  @override
  String get timeWhisperSealedMonth => '봉인했어요. 한 달 뒤 이곳에 돌아오면 열 수 있어요.';

  @override
  String get whisperWithdrawn => '속삭임을 거두었어요.';

  @override
  String get whisperMineLabel => '내가 남긴 속삭임';

  @override
  String get whisperTapToRead => '속삭임. 눌러서 읽기';

  @override
  String get noMoodYet => '할 말을 잃었어요…';

  @override
  String get knockWithdrawnByLeaving => '상대가 도시 속으로 사라지며 조용히 노크를 거두었어요…';

  @override
  String get knockCardTitle => '잠깐의 교차';

  @override
  String knockCardBody(String name) {
    return '$name님이 노크하고 있어요.\n당신과 길이 겹치길 바라며…';
  }

  @override
  String get skip => '건너뛰기';

  @override
  String get decline => '거절';

  @override
  String get accept => '수락';

  @override
  String get reportThisPerson => '이 사람 신고';

  @override
  String get cityQuietTonight => '오늘 밤 도시는 아직 조용해요';

  @override
  String cityMoodChip(String mood, String percent) {
    return '오늘 밤 도시 · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. 도시의 무드 날씨 보기';
  }

  @override
  String get cityMoodTitle => '오늘 밤 도시의 무드';

  @override
  String cityMoodQuietCount(int total) {
    return '도시는 아직 조용해요. 오늘 밤 $total명이 무드를 남겼어요.';
  }

  @override
  String cityMoodCount(int total) {
    return '20km 안에서 오늘 밤 $total명이 무드를 남겼어요';
  }

  @override
  String get cityMoodQuietInvite =>
      '무드가 하나 늘 때마다 도시에 빛이 조금 더해져요. 지금 기분을 적고 도시를 밝히는 사람이 되어 보세요.';

  @override
  String get cityMoodFootnote =>
      '최근 24시간의 무드를 익명으로 집계해요. 10명 미만이면 비율을 보여 주지 않아요.';

  @override
  String get close => '닫기';

  @override
  String get emptyRadarTitle => '당신이 오늘 밤의 첫 번째 빛';

  @override
  String get emptyRadarBody =>
      '근처에 아직 아무도 없어요. 당신의 무드는 이미 도시에서 빛나고 있고,\n누군가 지나가면 당신을 보게 될 거예요. 다음에 지나갈 사람을 위해 속삭임을 남길 수도 있어요.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '오늘 밤 도시에 $total명이 있고, 대부분 \'$mood\'을(를) 느끼고 있어요';
  }

  @override
  String get inviteFriends => '친구를 초대해 동네를 밝혀요';

  @override
  String get shareMoodCard => '내 무드 카드 공유';

  @override
  String get editYourMood => '무드 수정';

  @override
  String resonanceTonight(int count) {
    return '오늘 밤 $count개의 반짝임이 당신과 공명했어요';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · 내 무드';
  }

  @override
  String get dockTapToEdit => '내 무드 · 눌러서 수정';

  @override
  String get leaveWhisper => '속삭임 남기기';

  @override
  String get settings => '설정';

  @override
  String get nightlyReminder => '밤 알림';

  @override
  String get nightlyReminderSubtitle => '매일 밤 21:30에 부드러운 알림';

  @override
  String get closeSettings => '설정 닫기';

  @override
  String get settingsSectionMe => '나';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get editProfileSubtitle => '사진, 도시 닉네임, 무드';

  @override
  String get manageBlockList => '차단한 사람';

  @override
  String get manageBlockListSubtitle => '어둠 속으로 보낸 사람을 보거나 차단 해제';

  @override
  String get myTimeWhispers => '미래로 보내는 편지';

  @override
  String get myTimeWhispersSubtitle => '미래의 나에게. 나만 볼 수 있어요';

  @override
  String get myMoodTrail => '나의 무드 궤적';

  @override
  String get myMoodTrailSubtitle => '이 휴대폰에만 저장돼요';

  @override
  String get settingsSectionGatherings => '모임';

  @override
  String get gatheringHost => '모임 열기';

  @override
  String get gatheringHostSubtitle => '나를 중심으로 5km 안에서 이벤트 열기';

  @override
  String gatheringHosting(String emoji, String name) {
    return '$emoji $name 진행 중';
  }

  @override
  String get settingsSectionShare => '공유';

  @override
  String get shareMoodCardSubtitle => '11장의 야경 일러스트 중 무작위로, 인스타 스토리에 딱';

  @override
  String get inviteFriendsSubtitle => '근처에 사람이 많을수록 도시가 밝아져요';

  @override
  String get settingsSectionAbout => '정보';

  @override
  String get guide => '사용 방법';

  @override
  String get guideSubtitle => '무드 쓰기부터 모임 열기까지 한눈에';

  @override
  String get termsOfUse => '이용약관';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get contactUs => '문의하기';

  @override
  String get deleteAccount => '계정 및 데이터 삭제';

  @override
  String get deleteAccountSubtitle => '도시에 남긴 모든 것을 영구히 지워요';

  @override
  String get avatarUploadFailed => '사진을 올리지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get moodEmpty => '무드는 비워 둘 수 없어요. 도시에 작은 빛을 남겨 주세요.';

  @override
  String get profileSyncFailed => '상태를 업데이트하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get profileUpdated => '업데이트했어요. 도시가 당신의 숨결을 느끼고 있어요.';

  @override
  String get changeAvatar => '사진 변경';

  @override
  String get avatarHint => '눌러서 사진 변경 · 빛의 고리는 내 무드 색이에요';

  @override
  String get cityName => '도시 닉네임';

  @override
  String get cityNameHint => '선택 사항, 예: 떠도는 고양이';

  @override
  String get currentMood => '지금 무드';

  @override
  String get currentMoodHint => '예: 가랑비 속을 산책 중 🌿';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get blockListTitle => '어둠 속으로 보낸 사람';

  @override
  String get blockListEmpty => '밤하늘이 맑아요. 아직 아무도 멀리 보내지 않았어요.';

  @override
  String get unblock => '차단 해제';

  @override
  String get deleteAccountBody =>
      '위치, 무드, 도시 닉네임, 사진, 남긴 속삭임, 반짝임, 차단 목록, 진행 중인 대화가 모두 영구 삭제되며 되돌릴 수 없어요.\n\n악용을 막기 위해 신고 기록은 개인정보 처리방침에 따라 1년간 보관돼요.';

  @override
  String get deleting => '삭제 중…';

  @override
  String get deletePermanently => '영구 삭제';

  @override
  String get deleteFailed => '삭제를 마치지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String get fadingEcho => '잔상';

  @override
  String clusterCount(int count) {
    return '여기에 무드 $count개';
  }

  @override
  String clusterMore(int count) {
    return '더 보기\n+$count';
  }

  @override
  String get clusterBackToFirst => '처음으로\n돌아가기';

  @override
  String get fadingEchoTitle => '하나의 잔상';

  @override
  String encounterWith(String name) {
    return '$name님과의 만남';
  }

  @override
  String get fadingEchoBody => '이건 잔상일 뿐이라 교차할 수 없어요.';

  @override
  String get demoPersonBody =>
      '자동으로 답하는 데모 상대예요. 실제 사람이 아니에요. 노크, 채팅, 반짝임, 신고, 차단을 체험해 볼 수 있어요.';

  @override
  String get sendGlimmer => '반짝임 보내기 (공명)';

  @override
  String get knock => '노크 (교차하기)';

  @override
  String get blockAction => '차단 (어둠 속으로)';

  @override
  String get handOverHost => '진행자 넘기기';

  @override
  String get report => '신고';

  @override
  String get confirmBlockTitle => '차단할까요?';

  @override
  String confirmBlockBody(String name) {
    return '$name님을 어둠 속으로 보낼까요?\n차단하면 서로의 도시에서 사라져요.';
  }

  @override
  String get confirmBlock => '차단';

  @override
  String get glimmerReceived => '누군가 반짝임을 보냈어요. 당신의 무드와 공명했대요.';

  @override
  String get glimmerSent => '반짝임을 보냈어요.';

  @override
  String get glimmerAlreadySent => '오늘은 이미 이 사람에게 반짝임을 보냈어요. 내일 다시 보내 주세요.';

  @override
  String get knockSent => '노크했어요. 대답을 기다리는 중…';

  @override
  String get knockFailed => '노크가 전달되지 않았어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get knockNoAnswer => '대답이 없어 노크 소리가 조용히 사라졌어요.';

  @override
  String get knockDeclined => '이번엔 길이 겹치지 않았어요. 서로에게 조금 거리를 둬요.';

  @override
  String get knockSkipped => '상대가 이번엔 건너뛰었어요. 노크 소리가 조용히 사라졌어요.';

  @override
  String get sensingCity => '도시를 느끼는 중…';

  @override
  String get sensingCityHint =>
      '지금 도시가 너무 조용하다면 ‘평행우주’나 ‘양자 세계’에 들어가 다른 도시 사람들을 만나 보세요.';

  @override
  String get gatheringUnavailable => '지금은 모임을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get notSentCheckNetwork => '보내지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String hoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String get nextDayPrefix => '다음 날 ';

  @override
  String get gatheringNameMissing => '모임 이름을 정해 주세요.';

  @override
  String get gatheringEmojiInvalid => '아이콘은 이모지 하나여야 해요.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name 모임이 시작됐어요. 참가할 사람들에게 닉네임에 $emoji를 넣어 달라고 알려 주세요.';
  }

  @override
  String get startGatheringTitle => '모임 열기';

  @override
  String get startGatheringLead => '내 위치를 중심으로 5km. 내가 움직이면 범위도 함께 움직여요.';

  @override
  String get gatheringNameHint => '모임 이름, 예: 한강 불꽃축제';

  @override
  String get gatheringEmojiHint => '아이콘';

  @override
  String get gatheringEmojiHelp =>
      '모임 아이콘은 이모지 하나예요. 근처에서 아무도 쓰지 않는 것만 고를 수 있어요.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return '닉네임에 $emoji를 넣은 사람은 공지를 보고 알림을 받아요.';
  }

  @override
  String get start => '시작';

  @override
  String get end => '종료';

  @override
  String get gatheringMaxDuration => '최대 24시간이며, 시간이 되면 자동으로 끝나요.';

  @override
  String get starting => '시작하는 중…';

  @override
  String get startGathering => '모임 시작';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name 모임이 끝났어요. 다시 도시로 돌아왔어요.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · 진행 중';
  }

  @override
  String hostAudienceRule(String emoji) {
    return '5km 안에서 닉네임에 $emoji가 있는 사람은 공지를 보고 알림을 받아요. 그게 누군지는 당신에게 보이지 않아요.';
  }

  @override
  String get postAnnouncement => '공지 올리기';

  @override
  String get announcementHint => '예: 역 2번 출구에서 모여요';

  @override
  String get announcementSent => '공지를 보냈어요';

  @override
  String announcementLine(String ago, String text) {
    return '$ago　$text';
  }

  @override
  String get announcementHiddenSuffix => ' (여러 사람이 신고해 숨겨짐)';

  @override
  String get groupQuestion => '모두에게 질문';

  @override
  String get questionHint => '예: 지금 당신은 어때요?';

  @override
  String get sendQuestion => '질문하기';

  @override
  String get questionSent => '질문을 보냈어요. 모두 무드로 답할 거예요';

  @override
  String get handOff => '넘기기';

  @override
  String handoffPending(String name) {
    return '$name님에게 진행을 맡아 달라고 요청했어요. 답을 기다리는 중…';
  }

  @override
  String get theOtherPerson => '상대';

  @override
  String get handoffCancelled => '진행 넘기기 요청을 취소했어요';

  @override
  String get handoffHelp =>
      '레이더에서 참가자의 버블을 길게 누르고 → \'진행자 넘기기\'. 상대가 수락하면 진행자가 바뀌고, 모임과 공지는 끊기지 않아요.';

  @override
  String get confirmEndAgain => '끝낼까요? 한 번 더 누르세요';

  @override
  String get endGathering => '모임 끝내기';

  @override
  String tallyHeader(String question, int total) {
    return '\'$question\' · $total명 응답';
  }

  @override
  String get tallyQuiet => '10명이 답해야 비율이 보여요. 사람이 적을 때 누군지 추측되지 않도록요.';

  @override
  String get bannerYouHost => '  · 진행 중';

  @override
  String get bannerHostAnnouncement => '  · 진행자 공지';

  @override
  String get manageGathering => '모임 관리';

  @override
  String get reportAnnouncement => '이 공지 신고';

  @override
  String get expandAnnouncement => '공지 펼치기';

  @override
  String get collapseAnnouncement => '공지 접기';

  @override
  String hostHandedOffAgo(String ago) {
    return '진행자 변경 · $ago';
  }

  @override
  String get announcementReportedHidden => '이 공지를 신고해서 화면에서 지웠어요.';

  @override
  String get noAnnouncementHost => '아직 공지가 없어요. 오른쪽 위 조절 버튼을 눌러 첫 공지를 올려 보세요.';

  @override
  String get noAnnouncementGuest => '진행자가 아직 공지를 올리지 않았어요.';

  @override
  String hostAsks(String question) {
    return '진행자의 질문: $question';
  }

  @override
  String get answeredNote => '답했어요. 진행자는 전체 무드 비율만 볼 수 있어요.';

  @override
  String get answerHint => '무드 한마디로 답하기';

  @override
  String get sendAnswer => '답 보내기';

  @override
  String handoffInvited(String name) {
    return '$name님에게 진행을 맡아 달라고 요청했어요. 답을 기다리는 중이에요 (5분간 유효).';
  }

  @override
  String handoffTitle(String name) {
    return '$name님에게 모임 넘기기';
  }

  @override
  String get handoffBody =>
      '상대가 수락하면 그 사람이 모임을 진행해요. 이름, 공지, 질문은 그대로 남고, 당신은 참가자가 돼요.';

  @override
  String get handoffPublic => '공개적으로 넘기기';

  @override
  String get handoffPublicHelp => '모든 참가자에게 \'진행자가 바뀌었어요\'라고 알려요';

  @override
  String get handoffQuiet => '조용히 넘기기';

  @override
  String get handoffQuietHelp => '아무에게도 알리지 않고, 레이더의 \'진행\' 빛 고리만 옮겨 가요';

  @override
  String get sending => '보내는 중…';

  @override
  String get sendInvite => '요청 보내기';

  @override
  String youAreNowHost(String emoji, String name) {
    return '이제 $emoji $name의 진행자예요.';
  }

  @override
  String get handoffOfferTitle => '진행을 맡아 줄래요?';

  @override
  String handoffOfferBody(String name) {
    return '진행자가 \'$name\'을(를) 당신에게 맡기고 싶어 해요. 맡으면 공지, 질문, 모임 종료를 할 수 있고, 올린 공지에 대한 책임도 져요.';
  }

  @override
  String get processing => '처리 중…';

  @override
  String get acceptHosting => '진행 맡기';

  @override
  String get guideS1Title => '1. 도시에 들어가기';

  @override
  String get guideS1L1 =>
      '처음 열 때 만 18세 이상인지 확인하고, \'앱을 사용하는 동안\' 정확한 위치 사용을 허용해 주세요. 정확한 위치가 없으면 레이더가 작동하지 않아요.';

  @override
  String get guideS1L2 =>
      '지금 기분을 한 문장(최대 20자)으로 쓰고, 이용약관과 개인정보 처리방침에 동의한 뒤 「여기서 체크인하고 들어가기」를 누르세요.';

  @override
  String get guideS1L3 => '전화번호, 이메일, 실명이 필요 없어요. 계정은 익명이며 이 휴대폰에 연결돼요.';

  @override
  String get guideS1L4 =>
      '무드 색은 글 속 키워드로 정해져요. \'기쁨·웃음\'은 금색, \'슬픔·눈물\'은 파랑, \'화남\'은 주홍, \'평온·멍\'은 초록, \'열정\'은 주황, \'사랑·하트\'는 분홍, 그 밖에는 연보라예요.';

  @override
  String get guideS1L5 =>
      '체크인: 앱을 열 때마다 직접 체크인해야 근처 사람들이 내 기분과 대략적인 위치를 볼 수 있고, 나도 그들을 볼 수 있어요. 자동으로 체크인되지 않아요. 다른 사람에게 보이는 곳은 체크인한 장소이고, 내가 움직여도 따라오지 않아요. 체크인한 곳에서 1km 넘게 멀어지면 레이더 아래에 「여기서 다시 체크인」이 나타나요. 앱이 백그라운드에 30분 넘게 있었다면 돌아왔을 때 다시 체크인해요.';

  @override
  String get guideS2Title => '2. 아래 메뉴';

  @override
  String get guideS2L1 => '왼쪽의 내 사진을 누르면 사진, 도시 닉네임(최대 10자), 무드를 수정할 수 있어요.';

  @override
  String get guideS2L2 => '노트 아이콘: 지금 이곳에 속삭임 남기기.';

  @override
  String get guideS2L3 => '공유 아이콘: 지금 무드를 야경 카드로 만들기.';

  @override
  String get guideS2L4 => '맨 오른쪽 조절 아이콘: 설정 열기.';

  @override
  String get guideS3Title => '3. 레이더와 버블';

  @override
  String get guideS3L1 =>
      '레이더에는 5km 안 사람들의 무드 버블이 떠올라요. 거리는 대략적인 단계(예: \'100m 이내\')로만 보이고 주소는 보이지 않아요.';

  @override
  String get guideS3L2 =>
      '레이더에는 지금 체크인하고 앱을 열어 둔 사람만 보여요. 앱을 나가거나 다른 앱으로 전환하면 버블이 바로 사라지고 흔적도 남지 않아요.';

  @override
  String get guideS3L3 =>
      '두 손가락으로 지도를 확대하거나 축소할 수 있어요. 휴대폰을 돌리면 레이더도 바라보는 방향을 따라 돌아요.';

  @override
  String get guideS3L4 =>
      '버블이 너무 몰리면 \'여기에 무드 N개\'라는 빛 구슬로 합쳐져요. 누르면 원 모양으로 펼쳐져 하나씩 누를 수 있고, 가운데나 빈 곳을 누르면 접혀요.';

  @override
  String get guideS3L5 =>
      '이름 앞에 \'데모\'가 붙은 상대는 자동으로 답하는 데모 상대예요. 실제 사람이 아니며 모든 기능을 체험하는 데 쓸 수 있어요.';

  @override
  String get guideS3L6 =>
      '근처에 아무도 없으면 화면 아래에 \'당신이 오늘 밤의 첫 번째 빛\'이 나타나고, 친구를 초대해 동네를 밝힐 수 있어요.';

  @override
  String get guideS4Title => '4. 노크와 채팅';

  @override
  String get guideS4L1 =>
      '상대의 버블을 길게 누르고 → \'노크\'. 상대는 5분 안에 수락, 거절, 건너뛰기 중 하나로 답해요. 기다리는 동안 당신에게서 상대에게로 빛줄기가 흘러가요.';

  @override
  String get guideS4L2 =>
      '상대가 수락하면 채팅이 시작되고 10분 카운트다운이 흘러요. 누구든 새 메시지를 보내면 다시 시작되고, 조용해지면 끝나요.';

  @override
  String get guideS4L3 =>
      '채팅이 끝나면 메시지는 서버에서 삭제돼요. 그래도 상대가 캡처할 수 있으니 공유할 내용은 신중히 정해 주세요.';

  @override
  String get guideS4L4 => '누군가 노크하면 노크 카드가 떠요. 수락, 거절, 건너뛰기, 또는 바로 신고할 수 있어요.';

  @override
  String get guideS5Title => '5. 반짝임';

  @override
  String get guideS5L1 =>
      '상대의 버블을 두 번 누르거나 길게 눌러 \'반짝임 보내기\'를 고르면, 말하지 않아도 누군가 봤다는 걸 알릴 수 있어요.';

  @override
  String get guideS5L2 =>
      '상대에게는 \'오늘 밤 N개의 반짝임이 당신과 공명했어요\'만 보이고, 누가 보냈는지는 절대 알 수 없어요. 같은 사람에게는 24시간에 한 번만 보낼 수 있어요.';

  @override
  String get guideS6Title => '6. 속삭임';

  @override
  String get guideS6L1 => '아래 메뉴의 노트 아이콘을 눌러 지금 있는 곳에 한마디(최대 60자)를 남겨요.';

  @override
  String get guideS6L2 =>
      '앞으로 7일 동안 그 근처 300m 안을 지나는 사람의 레이더에 봉투가 나타나고, 열면 읽을 수 있어요.';

  @override
  String get guideS6L3 =>
      '속삭임은 언제나 익명이에요. 동시에 최대 3개, 10분에 1개까지 남길 수 있고 언제든 거둘 수 있어요.';

  @override
  String get guideS6L4 =>
      '미래로 보내는 편지: 속삭임을 쓸 때 \'미래의 나에게\'를 고르고 한 달 뒤나 1년 뒤를 선택하세요. 나만 볼 수 있고, 때가 되면 알림이 오며, 그곳 100m 안으로 돌아가면 자동으로 열려요. 한 번 읽으면 사라져요. 레이더에는 나에게만 작은 모래시계(잠김/풀림)가 보이고, 누를 수는 없어요. 동시에 최대 5통이며, 설정 → \'미래로 보내는 편지\'에서 보거나 삭제할 수 있어요.';

  @override
  String get guideS7Title => '7. 도시의 무드 날씨';

  @override
  String get guideS7L1 =>
      '왼쪽 위 라벨은 20km 안, 최근 24시간 동안 가장 많은 무드를 보여 줘요. 누르면 전체 비율을 볼 수 있어요.';

  @override
  String get guideS7L2 => '10명 미만이면 누군지 추측되지 않도록 비율을 보여 주지 않아요.';

  @override
  String get guideS8Title => '8. 모임';

  @override
  String get guideS8L1 =>
      '여는 법: 설정 → 모임 열기 → 이름, 아이콘으로 쓸 이모지 하나, 시작과 종료 시간(최대 24시간) 입력 → 모임 시작.';

  @override
  String get guideS8L2 =>
      '범위는 주최자가 체크인한 곳을 중심으로 5km이고, 주최자가 다시 체크인하면 함께 움직여요. 레이더에서 주최자에게는 빛의 고리와 「주최」 표시가 있어요.';

  @override
  String get guideS8L3 => '진행자는 공지를 횟수 제한 없이 올리고, 모두에게 질문하고, 언제든 모임을 끝낼 수 있어요.';

  @override
  String get guideS8L4 =>
      '참가하려면: 모임 아이콘을 도시 닉네임에 넣으세요(예: \'떠도는 고양이🌈\'). 범위 안에 있으면 레이더 위에 고정 공지가 보이고 알림도 받아요. 아이콘을 지우면 나가요.';

  @override
  String get guideS8L5 =>
      '모두에게 질문: 무드 한마디로 답해요. 진행자는 전체 무드 비율만 볼 수 있고 누가 뭐라고 답했는지는 몰라요. 10명 미만이면 비율을 보여 주지 않아요.';

  @override
  String get guideS8L6 =>
      '같은 지역에서 같은 아이콘은 한 번에 한 모임만 쓸 수 있어요. 모임이 끝나면 누구나 쓸 수 있어요.';

  @override
  String get guideS8L7 =>
      '진행 넘기기: 진행자가 참가자의 버블을 길게 누르고 → \'진행자 넘기기\'에서 공개(모두에게 알림) 또는 조용히(알림 없음)를 골라요. 상대가 5분 안에 수락하면 진행자가 바뀌고 공지와 질문은 그대로 남아요. 이전 진행자는 참가자가 되고 닉네임에 아이콘이 자동으로 붙어요.';

  @override
  String get guideS9Title => '9. 시티 비컨 (모두를 위한 화장실)';

  @override
  String get guideS9L1 =>
      '지도 왼쪽 아래의 화장실 아이콘을 누르면 비컨이 켜지고, 2km 안의 성중립·장애인·가족 화장실이 레이더에 나타나요. 아이콘 옆에 개수가 표시돼요. 위쪽의 동그란 필터 3개로 종류를 골라 볼 수 있어요.';

  @override
  String get guideS9L2 =>
      '표시를 누르면 층, 시설, 거리를 볼 수 있고, \'걸어가기\'를 누르면 지도 앱으로 길을 안내해요.';

  @override
  String get guideS9L3 =>
      '데이터는 대만 환경부의 공중화장실 등록 자료로 매달 업데이트돼요. 운영 시간 정보는 없어서 \'밤에도 열려 있을 것 같아요\'는 장소 유형으로 추정한 거예요.';

  @override
  String get guideS9L4 =>
      '정보가 틀리면 신고할 수 있어요(성중립 아님, 밤에 닫힘, 찾을 수 없음). 같은 문제를 3명이 신고하면 표시가 회색으로 바뀌고 메모가 붙어요.';

  @override
  String get guideS10Title => '11. 무드 카드와 무드 궤적';

  @override
  String get guideS10L1 =>
      '아래 메뉴의 공유 버튼으로 지금 무드를 야경 카드로 만들 수 있어요. 인스타 스토리에 딱이고, 카드에는 위치가 들어가지 않아요.';

  @override
  String get guideS10L2 =>
      '설정 → \'나의 무드 궤적\'에서 지금까지 쓴 무드와 장소를 돌아볼 수 있어요. 데이터는 이 휴대폰에만 저장되며 언제든 끄거나 지울 수 있어요.';

  @override
  String get guideS11Title => '17. 설정과 알림';

  @override
  String get guideS11L1 =>
      '\'밤 알림\': 매일 밤 21:30에 부드러운 알림이 와요. 설정에서 켜고 끌 수 있어요.';

  @override
  String get guideS11L2 =>
      '노크, 새 메시지, 반짝임, 모임 공지는 푸시 알림으로 와요. 휴대폰 설정에서 끌 수 있어요.';

  @override
  String get guideS11L3 =>
      '매주 금요일 21:00~23:00는 \'라이트업 나이트\'. 다 함께 접속하면 도시가 가장 밝아져요.';

  @override
  String get guideS12Title => '18. 신고와 차단';

  @override
  String get guideS12L1 =>
      '버블 길게 누르기, 노크 카드, 채팅 오른쪽 위, 속삭임, 모임 공지에서 신고할 수 있어요. 신고하면 그 사람이나 글이 바로 화면에서 사라지고 채팅도 즉시 끝나요. 24시간 안에 처리해요.';

  @override
  String get guideS12L2 =>
      '무드, 닉네임, 속삭임, 채팅 메시지, 모임 공지에서는 부적절한 말과 전화번호·링크 같은 연락처가 자동으로 걸러져요.';

  @override
  String get guideS12L3 =>
      '차단하면 서로의 레이더에서 사라지고 노크나 반짝임도 보낼 수 없어요. 설정 → \'차단한 사람\'에서 해제할 수 있어요.';

  @override
  String get guideS12L4 => '급박한 위험이 있다면 바로 현지 긴급 번호(한국 112, 대만 110)로 전화하세요.';

  @override
  String get guideS13Title => '19. 개인정보와 계정';

  @override
  String get guideS13L1 =>
      '체크인한 뒤에만 근처 사람들이 내 기분, 도시 이름, 사진, 대략적인 거리를 볼 수 있어요. 보이는 곳은 체크인한 장소이지 실시간 위치가 아니에요.';

  @override
  String get guideS13L2 =>
      '설정 → \'계정 및 데이터 삭제\'에서 도시에 남긴 모든 것을 언제든 영구 삭제할 수 있어요.';

  @override
  String get guideS13L3 =>
      '궁금한 점은 설정 → \'문의하기\' 또는 service.softchip@gmail.com으로 보내 주세요.';

  @override
  String get guideS14Title => '12. 평행우주';

  @override
  String get guideS14L1 =>
      '레이더 오른쪽 위의 지구 아이콘을 누르면 켜지고, 다시 누르면 꺼져요. 앱을 열 때마다 꺼진 상태로 시작해요.';

  @override
  String get guideS14L2 =>
      '대만의 각 시·현은 각자의 중앙역을 중심으로(타이베이 권역은 타이베이역, 타오위안은 타오위안역 등) 해외 도시인 일본, 한국, 홍콩, 마카오, 싱가포르, 말레이시아, 인도네시아, 베트남, 태국, 필리핀, 호주와 짝지어져요. 해외 도시는 대만과 짝지어져요.';

  @override
  String get guideS14L3 =>
      '내가 역에서 어느 방향으로 얼마나 떨어져 있는지에 따라 상대 도시의 역에서 같은 방향·같은 거리에 나타나고, 약 500m로 흐려져요. 누구도 실제 위치를 알 수 없어요.';

  @override
  String get guideS14L4 =>
      '둘 중 한 명만 켜도 서로 보여요. 켜면 짝지어진 도시에서 앱을 켜 둔 모든 사람이, 끄면 켜 둔 사람만 보여요. 다른 도시에는 체크인하고 앱을 켜 둔 사람만 나타나요.';

  @override
  String get guideS14L5 =>
      '평행우주의 사람에게는 점선 고리와 있는 도시가 표시돼요. 빛 보내기, 노크, 채팅도 할 수 있어요. 속삭임, 미래로 보내는 편지, 모임은 그 도시에만 남아요.';

  @override
  String get guideS15Title => '16. 번역';

  @override
  String get guideS15L1 =>
      '채팅에서 상대 메시지가 내 언어와 다르면 아래에 「탭하여 번역」이 나타나요. 누르면 내 언어로 번역되고, 다시 누르면 원문이 보여요.';

  @override
  String get guideS15L2 =>
      '레이더의 기분 말풍선도 같아요. 내 언어와 다르면 눌러서 번역하고, 다시 누르면 원문으로 돌아가요.';

  @override
  String get guideS15L3 =>
      '번역은 모두 휴대폰 안에서 이루어지고, 글은 업로드되지 않아요. iPhone은 Apple 내장 번역을 사용하며 처음 쓰는 언어는 시스템이 다운로드할지 물어봐요. Android는 Google ML Kit을 사용하며 먼저 물어본 뒤 약 30MB의 언어 모델을 내려받아요. iPhone에서는 아직 말레이어를 번역할 수 없어요.';

  @override
  String get guideIntro =>
      'Mood Whisper는 밤의 도시예요. 지금 기분을 한 문장 쓰면, 근처 사람들의 지금 기분이 보여요.';

  @override
  String get beaconGender => '성중립';

  @override
  String get beaconAccessible => '장애인';

  @override
  String get beaconFamily => '가족';

  @override
  String get beaconReportNotGender => '성중립 화장실이 아니에요';

  @override
  String get beaconReportClosed => '밤에 닫혀 있어요';

  @override
  String get beaconReportMissing => '이 화장실을 찾을 수 없어요';

  @override
  String get beaconFlagNotGender => '신고됨: 성중립 아님';

  @override
  String get beaconFlagClosed => '신고됨: 밤에 닫힘';

  @override
  String get beaconFlagMissing => '신고됨: 찾을 수 없음';

  @override
  String get beaconDefaultName => '공중화장실';

  @override
  String meters(int m) {
    return '${m}m';
  }

  @override
  String kilometers(String km) {
    return '${km}km';
  }

  @override
  String get beaconUnavailable => '지금은 시티 비컨을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get notConnectedCheckNetwork => '연결하지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$features 화장실, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return '시티 비컨(모두를 위한 화장실) 끄기, 근처 $count곳';
  }

  @override
  String get beaconToggleOn => '시티 비컨(모두를 위한 화장실) 켜기';

  @override
  String beaconFilterOnly(String feature) {
    return '$feature만 보기';
  }

  @override
  String get beaconMaybeOpenNight => '밤에도 열려 있을 것 같아요 (추정)';

  @override
  String get beaconMaybeDaytime => '낮에만 열 것 같아요 (추정)';

  @override
  String get walkThere => '걸어가기';

  @override
  String get beaconWrongData => '정보가 틀렸나요?';

  @override
  String beaconThanks(String reason) {
    return '고마워요. \'$reason\' 신고를 받았어요.';
  }

  @override
  String get beaconSource =>
      '출처: 대만 환경부 공중화장실 등록 자료, 매달 업데이트. 운영 시간은 장소 유형으로 추정했어요.';

  @override
  String get invite1 =>
      'Mood Whisper에서 빛 하나를 밝혔어. 근처에 사람이 많을수록 동네가 밝아지니까 같이 밝혀 보자:';

  @override
  String get invite2 => '오늘 밤 도시가 좀 조용해. Mood Whisper에 무드 한마디 남기고 우리 동네를 밝혀 줘:';

  @override
  String get invite3 => '친구 추가도, 실명도 필요 없어. 지금 기분 한마디면 돼. Mood Whisper에서 만나:';

  @override
  String get invite4 =>
      'Mood Whisper에 너를 위한 불빛을 켜 두었어. 앱을 열고 오늘 밤 근처 사람들이 무슨 생각을 하는지 봐 봐:';

  @override
  String get invite5 =>
      '매주 금요일 밤 9시는 Mood Whisper의 라이트업 나이트야. 같이 접속해서 레이더를 빛으로 가득 채우자:';

  @override
  String get invite6 => '오늘 기분을 털어놓을 곳이 필요해? Mood Whisper는 익명이고, 말하고 나면 사라져:';

  @override
  String get invite7 => '길에서 스쳐 가는 사람들이 무슨 기분인지 궁금했던 적 있어? Mood Whisper에서 봐 봐:';

  @override
  String get invite8 => '이 거리에 속삭임을 남겼어. 지나가는 사람만 읽을 수 있어. 너도 하나 남겨 봐:';

  @override
  String get invite9 =>
      'Mood Whisper는 밤의 도시 무드 지도야. 사람이 많을수록 재밌으니까 우리 동네에 빛 하나 더해 줘:';

  @override
  String get invite10 =>
      '오늘 밤 네 기분은 무슨 색이야? Mood Whisper에 적어 봐. 근처에서 네 빛을 기다릴게:';

  @override
  String get shareInvite => '초대 공유';

  @override
  String get inviteSubject => '같이 우리 동네를 밝혀요';

  @override
  String get shareMoodCardButton => '카드 공유';

  @override
  String moodShareText(String mood) {
    return 'Mood Whisper에 지금 기분을 남겼어: \'$mood\'\n오늘 밤, 네 무드도 도시에서 빛나고 있어?';
  }

  @override
  String get shareFailed => '공유하지 못했어요. 다시 시도해 주세요.';

  @override
  String shuffleCard(int current, int total) {
    return '다른 카드 · $current / $total';
  }

  @override
  String get preparing => '준비 중…';

  @override
  String get sendLinkToFriends => '친구에게 링크 보내기 (카카오톡, Messenger)';

  @override
  String get partLateNight => '깊은 밤';

  @override
  String get partMorning => '아침';

  @override
  String get partAfternoon => '오후';

  @override
  String get partDusk => '해 질 녘';

  @override
  String get partNight => '밤';

  @override
  String get cardInviteEyebrow => '초대';

  @override
  String get cardMoodEyebrow => '지금 내 기분';

  @override
  String get cardInviteTitle => '같이 밝혀요\n우리 동네';

  @override
  String get cardInviteBody =>
      'Mood Whisper에서 빛 하나를 밝혔어요.\n근처에 사람이 많을수록 동네가 밝아져요.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\n도시 어딘가에서';
  }

  @override
  String get whisperUnavailable => '지금은 속삭임을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get whisperNotSent => '속삭임을 보내지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get timeWhisperTitle => '미래로 보내는 편지';

  @override
  String get timeWhisperLead => '미래의 나에게 써요. 때가 되면 이곳에 돌아와야 열 수 있어요.';

  @override
  String get whisperLead => '다음에 이곳을 지날 사람에게 써요.';

  @override
  String get toPassersBy => '지나가는 사람에게';

  @override
  String get toFutureSelf => '미래의 나에게';

  @override
  String get inOneMonth => '한 달 뒤';

  @override
  String get inOneYear => '1년 뒤';

  @override
  String get timeWhisperHint => '예: 내년에 여기서 다시 만나. 그때의 내가 지금보다 잘 지내고 있길.';

  @override
  String get whisperHint => '예: 여기 노을이 정말 예뻐요. 고개를 들어 보세요.';

  @override
  String get timeWhisperCaptionYear =>
      '나만 볼 수 있어요 · 1년 뒤 열리고 알려 드려요 · 100m 안으로 돌아오면 열려요';

  @override
  String get timeWhisperCaptionMonth =>
      '나만 볼 수 있어요 · 한 달 뒤 열리고 알려 드려요 · 100m 안으로 돌아오면 열려요';

  @override
  String get whisperCaption => '7일 뒤 사라져요 · 누군지 보이지 않아요 · 이 근처에 있었다는 것만 알려져요';

  @override
  String get sealHere => '여기에 봉인하기';

  @override
  String get leaveHere => '여기에 남기기';

  @override
  String get aWhisper => '속삭임';

  @override
  String whisperLeftAgo(String ago) {
    return '$ago 이 근처에 남김';
  }

  @override
  String whisperCollectedBy(int count) {
    return '$count명이 받아 갔어요';
  }

  @override
  String get whisperNobodyYet => '아직 아무도 지나가지 않았어요';

  @override
  String get withdrawWhisper => '이 속삭임 거두기';

  @override
  String get whisperCollected => '이 속삭임을 받아 갔어요.';

  @override
  String whisperReadersBefore(int count) {
    return '당신보다 먼저 $count명이 이곳을 지나갔어요.';
  }

  @override
  String get whisperFirstReader => '이곳을 지나간 첫 번째 사람이에요.';

  @override
  String get reportWhisper => '이 속삭임 신고';

  @override
  String get thisWhisper => '이 속삭임';

  @override
  String get chatTimeUp => '시간이 다 됐어요. 교차가 흩어져요…';

  @override
  String get chatOtherLeft => '상대가 도시 속으로 사라졌어요…';

  @override
  String get chatEnded => '교차가 끝났어요…';

  @override
  String get chatBlockedEnded => '차단했어요. 대화가 끝났어요.';

  @override
  String get chatReportedEnded => '신고했어요. 대화가 끝났어요.';

  @override
  String get anonymous => '익명';

  @override
  String get leaveChat => '대화 나가기';

  @override
  String chatWith(String name) {
    return '$name님과의 교차';
  }

  @override
  String get countdownPrefix => '';

  @override
  String get countdownSuffix => ' 뒤 사라짐';

  @override
  String get demoChatNotice => '데모 대화: 상대는 자동으로 답해요. 실제 사람이 아니에요.';

  @override
  String get typing => '입력 중…';

  @override
  String get chatHint => '조용히 말을 건네 보세요…';

  @override
  String get send => '보내기';

  @override
  String get chatDissolvedApart => '두 사람은 각자 도시로 돌아갔어요';

  @override
  String get knockTooOften => '노크가 너무 잦아요. 도시의 숨결을 느껴 보세요…';

  @override
  String get otherNotNow => '상대가 지금은 방해받고 싶지 않대요. 서로에게 조금 거리를 둬요.';

  @override
  String otherNotNowMinutes(int minutes) {
    return '상대가 지금은 방해받고 싶지 않대요. 서로에게 조금 거리를 둬요 ($minutes분).';
  }

  @override
  String get justEndedRest => '두 사람은 막 대화를 마쳤어요. 추억이 가라앉을 시간을 주세요.';

  @override
  String get intro1Title => '도시 속으로';

  @override
  String get intro1Body =>
      '복잡한 소셜 꼬리표는 내려놓아요. 단순한 밤의 캔버스 위에는 당신의 진짜 감정과 좌표만 남아요.';

  @override
  String get intro2Title => '잠깐의 교차';

  @override
  String get intro2Body =>
      '근처에 떠다니는 무드 버블이 보이나요? 살며시 노크하고, 스쳐 가는 사람과 일생에 한 번뿐인 대화를 나눠 보세요.';

  @override
  String get intro3Title => '도시의 리듬';

  @override
  String get intro3Body =>
      '당신의 마음을 소중히 여겨요. 노크한 뒤엔 조용히 답을 기다려 주세요. 인연이 아니라면 300초 뒤 버블은 조용히 사라져요.';

  @override
  String get intro4Title => '다정한 거리';

  @override
  String get intro4Body =>
      '방해받고 싶지 않나요? 거절하거나 차단하세요. 쿨다운 시스템이 소란을 막아 조용한 당신만의 자리를 지켜 줘요.';

  @override
  String get intro5Title => '만날 준비 됐나요?';

  @override
  String get intro5Body =>
      '눈을 감고 휴대폰의 진동과 심장 박동을 느껴 보세요. 이제 지금 기분을 적고, 여기서 체크인하고 Mood Whisper로 들어오세요.';

  @override
  String get intro6Title => '미래의 나에게 보내는 편지';

  @override
  String get intro6Body =>
      '지금 이곳에 한 달 뒤나 1년 뒤의 나에게 한마디를 남겨 보세요. 이곳에 다시 왔을 때만 열려요.';

  @override
  String get intro7Title => '오늘 밤, 함께 빛나요';

  @override
  String get intro7Body =>
      '이모지 하나를 암호로 모임을 열어 보세요. 그 이모지를 이름에 더한 사람들에게 공지가 전해지고, 같은 동네가 함께 밝아져요.';

  @override
  String get intro8Title => '평행우주';

  @override
  String get intro8Body =>
      '지구를 누르면 대만의 도시가 도쿄, 서울, 쿠알라룸푸르와 겹쳐져요. 먼 곳의 지금 기분을 보고, 노크와 채팅도, 탭 한 번으로 번역도 할 수 있어요.';

  @override
  String get loadingImage => '이미지 불러오는 중…';

  @override
  String get startExploring => '둘러보기 시작';

  @override
  String get nextPage => '다음';

  @override
  String get feedbackSubject => 'Mood Whisper 의견';

  @override
  String get loginNeedMood => '지금 기분을 남긴 뒤 도시로 들어가세요.';

  @override
  String get loginNeedAgree => '먼저 이용약관과 개인정보 처리방침을 읽고 동의에 체크해 주세요.';

  @override
  String get loginCantConnect => '도시에 연결하지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String get ageQuestion => '만 18세 이상인가요?';

  @override
  String get ageReason =>
      'Mood Whisper는 근처의 낯선 사람과 교류하는 앱이라 만 18세 이상만 이용할 수 있어요.';

  @override
  String get ageUnder => '18세 미만이에요';

  @override
  String get ageOver => '18세 이상이에요';

  @override
  String get loginTitle1 => '만날';

  @override
  String get loginTitle2 => ' 준비 됐나요?';

  @override
  String get loginLead =>
      '눈을 감고 휴대폰의 진동과 심장 박동을 느껴 보세요.\n이제 지금 기분을 적고 Mood Whisper로 들어오세요.';

  @override
  String get loginPrompt => '지금 이 순간, 도시에 무슨 말을 하고 싶나요?';

  @override
  String get loginHint => '예: 맛있는 커피 한 잔 마셨어요😊';

  @override
  String get enterCity => 'Mood Whisper 입장';

  @override
  String get agreeSemantic => '이용약관과 개인정보 처리방침을 읽었으며 동의합니다';

  @override
  String get agreePrefix => '';

  @override
  String get termsLink => '이용약관';

  @override
  String get agreeAnd => ' 및 ';

  @override
  String get privacyLink => '개인정보 처리방침';

  @override
  String get agreeSuffix =>
      '을 읽었으며 동의합니다. Mood Whisper는 괴롭힘, 성적인 내용, 혐오 등 부적절한 콘텐츠를 절대 용납하지 않으며, 위반하면 도시에서 내보내져요.';

  @override
  String get under18Title => 'Mood Whisper는 만 18세 이상만 이용할 수 있어요';

  @override
  String get under18Body =>
      '솔직하게 답해 줘서 고마워요. 이 도시는 낯선 사람과 교류하는 곳이에요. 18세가 되면 다시 만나요.';

  @override
  String get clearMoodTrail => '무드 궤적 지우기';

  @override
  String get clearMoodTrailBody => '이 휴대폰의 무드 궤적이 모두 삭제되며 되돌릴 수 없어요.';

  @override
  String get clear => '지우기';

  @override
  String monthDay(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get moodTrailLocalOnly => '이 휴대폰에만 저장되고 어디에도 업로드되지 않아요.';

  @override
  String get moodTrailEmpty =>
      '이번 주에는 아직 무드 궤적이 없어요. 무드를 쓰거나 새로운 곳에 갈 때마다 여기에 빛이 하나씩 늘어요.';

  @override
  String get thisWeekYou => '이번 주의 당신';

  @override
  String get topMoodPrefix => '가장 자주 느낀 무드는 \'';

  @override
  String topMoodSuffix(int count) {
    return '\', 총 $count번';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$places곳에서 무드 $total개를 남겼어요';
  }

  @override
  String get recordMoodTrail => '무드 궤적 기록하기';

  @override
  String get recordMoodTrailOff => '끄면 새 궤적을 기록하지 않아요';

  @override
  String get nightly1 => '오늘 밤 도시는 무슨 생각을 할까요?';

  @override
  String get nightly2 => '근처의 누군가가 지금 기분을 적고 있어요.';

  @override
  String get nightly3 => '딱 좋은 밤이에요. 도시에 한마디 남겨 보세요.';

  @override
  String get nightly4 => '오늘 하루 어땠나요? 당신의 무드가 도시에서 빛날 거예요.';

  @override
  String get nightly5 => '가로등이 켜졌고, 근처 사람들도 아직 깨어 있어요.';

  @override
  String get nightly6 => '오늘을 마무리해요. 지금 당신의 기분은 어떤가요?';

  @override
  String get nightly7 => '오늘 밤, 누가 당신을 스쳐 지나갈까요?';

  @override
  String get nightlyChannel => '밤 알림';

  @override
  String get nightlyChannelDesc => '매일 밤 부드러운 알림 하나. 앱 설정에서 끌 수 있어요';

  @override
  String get reasonHarassment => '괴롭힘 또는 따돌림';

  @override
  String get reasonSexual => '성적인 내용';

  @override
  String get reasonScam => '사기 또는 광고';

  @override
  String get reasonHate => '혐오 또는 폭력적인 발언';

  @override
  String get reasonImpersonation => '사칭';

  @override
  String get reasonOther => '기타';

  @override
  String get reportReceived => '신고를 받았고 화면에서 지웠어요. 24시간 안에 처리할게요.';

  @override
  String get reportNotSent => '신고를 보내지 못했어요. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String reportTarget(String target) {
    return '$target 신고';
  }

  @override
  String get reportPrivate => '신고한 사실은 상대에게 알려지지 않아요. 이유를 골라 주세요:';

  @override
  String get reportDetails => '추가 설명 (선택)';

  @override
  String get reportWhatHappened => '무슨 일이 있었나요?';

  @override
  String get sendReport => '신고하기';

  @override
  String get alsoBlock => '상대도 차단하기 (서로의 도시에서 사라져요)';

  @override
  String get aYearAgo => '1년 전';

  @override
  String get aMonthAgo => '한 달 전';

  @override
  String get timeWhisperUnavailable =>
      '지금은 미래로 보내는 편지를 이용할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago의 당신이 여기서 말했어요';
  }

  @override
  String writtenOn(String date) {
    return '$date에 씀';
  }

  @override
  String get timeWhisperOnce => '이 편지는 단 한 번만 나타나요.';

  @override
  String get keepInHeart => '마음에 담기';

  @override
  String unsealsOn(String unlock, String created) {
    return '$unlock에 열림 · $created에 씀';
  }

  @override
  String get unsealedGoBack => '열렸어요. 그곳에 돌아가면 열 수 있어요';

  @override
  String unsealedDistance(String distance) {
    return '열렸어요 · $distance 떨어져 있어요';
  }

  @override
  String get timeWhisperListLead =>
      '미래의 나에게 쓴 편지는 나만 볼 수 있어요. 때가 되면 그곳 100m 안으로 돌아가야 열리고, 한 번 읽으면 사라져요.';

  @override
  String get timeWhisperListEmpty =>
      '아직 미래로 보낸 편지가 없어요. 아래 메뉴의 노트 아이콘을 눌러 \'미래의 나에게\'를 고르세요.';

  @override
  String get readyToOpen => '이제 열 수 있어요';

  @override
  String get sealed => '봉인 중';

  @override
  String get delete => '삭제';

  @override
  String get within100m => '100m 이내';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return '$name님의 답을 기다리는 중, $mm분 $ss초 남음';
  }

  @override
  String knockWaiting(String name) {
    return '$name님의 답을 기다리는 중';
  }

  @override
  String get language => '언어';

  @override
  String get languageSystem => '휴대폰 설정 따르기';

  @override
  String get parallelUniverse => '평행우주';

  @override
  String get parallelUniverseSubtitle => '다른 도시의 지금 기분을 보고, 나도 보여 주기';

  @override
  String get parallelUniverseIntroTitle => '평행우주로 들어가기';

  @override
  String get parallelUniverseIntroBody =>
      '켜면 짝지어진 도시에서 지금 앱을 켜 둔 사람들이 모두 내 레이더에 겹쳐 보이고, 그들 모두 나를 볼 수 있습니다. 대만의 도시는 해외 도시(도쿄, 서울, 쿠알라룸푸르 등)와, 해외 도시는 대만과 짝지어집니다.\n\n두 도시는 각자의 중앙역을 기준으로 겹칩니다. 내가 역에서 어느 방향으로 얼마나 떨어져 있는지에 따라 상대 도시에서의 위치가 정해지고, 약 500m로 흐려져서 누구도 실제 위치나 거리를 알 수 없습니다. 빛 보내기, 노크, 채팅도 할 수 있고 언제든 끌 수 있습니다. 속삭임과 모임은 그 도시에만 남습니다.';

  @override
  String get parallelUniverseEnter => '들어가기';

  @override
  String get parallelUniverseNoCity => '지금 있는 곳에는 아직 평행우주가 없어요';

  @override
  String parallelFrom(String city) {
    return '평행우주 · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return '이 사람은 $city에 있고, 근처에 있지 않아요. 위치는 투영된 것이라 실제 거리가 아닙니다.';
  }

  @override
  String get labelHost => '호스트';

  @override
  String get labelDemo => '데모';

  @override
  String get labelResting => '쉬는 중';

  @override
  String get cityTaipei => '타이베이';

  @override
  String get cityTaichung => '타이중';

  @override
  String get cityKaohsiung => '가오슝';

  @override
  String get cityTokyo => '도쿄';

  @override
  String get cityOsaka => '오사카';

  @override
  String get citySeoul => '서울';

  @override
  String get cityBusan => '부산';

  @override
  String get cityHongkong => '홍콩';

  @override
  String get cityMacau => '마카오';

  @override
  String get citySingapore => '싱가포르';

  @override
  String get cityKualalumpur => '쿠알라룸푸르';

  @override
  String get cityJakarta => '자카르타';

  @override
  String get cityHochiminh => '호찌민';

  @override
  String get cityHanoi => '하노이';

  @override
  String get translateTap => '탭하여 번역';

  @override
  String get translateShowOriginal => '번역됨 · 탭하면 원문';

  @override
  String get translating => '번역 중…';

  @override
  String get translateFailed => '번역하지 못했습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get translateDownloadTitle => '번역 모델 다운로드';

  @override
  String get translateDownloadBody =>
      '이 언어를 처음 번역하려면 번역 모델을 다운로드해야 합니다(언어당 약 30MB, 한 번만).\n\n번역은 모두 휴대폰 안에서 이루어지며 메시지는 업로드되지 않습니다.';

  @override
  String get translateDownload => '다운로드';

  @override
  String placeHint(String name) {
    return '근처에 무드 플레이스의 불빛이 있어요 · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return '$time까지 영업';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return '무드 플레이스: $name, $hours';
  }

  @override
  String get placeWrongData => '정보가 틀렸나요?';

  @override
  String placeReportSubject(String name) {
    return '무드 플레이스 정보 오류: $name';
  }

  @override
  String get placeHintsSetting => '무드 플레이스 알림';

  @override
  String get placeHintsSettingSubtitle =>
      '영업 중인 무드 플레이스를 지나갈 때 앱 안에서 조용히 알려 줘요 (푸시 알림 없음)';

  @override
  String get guideS16Title => '10. 무드 플레이스';

  @override
  String get guideS16L1 =>
      '무드 플레이스는 함께하는 독립 카페예요. 체크인한 뒤 영업 중인 가게 150m 안으로 들어가면 레이더에 천천히 숨 쉬는 작은 불빛이 떠올라요. 멀어지면 꺼져요.';

  @override
  String get guideS16L2 =>
      '불빛을 탭하면 플레이스 카드가 열려요: 가게 안에서 본 밤 풍경, 오늘 영업 종료 시간, 가게의 한 줄 무드 스토리(탭하면 번역), 주소와 전화번호. \"걸어가기\"를 누르면 지도 앱의 도보 길찾기가 열려요. 오늘 카드를 연 불빛은 숨 쉬지 않고 은은하게 빛나요.';

  @override
  String get guideS16L3 =>
      '처음 지나갈 때 위쪽에 작은 카드로 알려 줘요. 소리나 진동은 없어요. 같은 가게는 7일에 한 번, 하루 최대 2번까지만 알려 줘요. \"설정 → 무드 플레이스 알림\"에서 끌 수 있고, 불빛은 그대로 보여요.';

  @override
  String get guideS16L4 =>
      '플레이스 목록은 통째로 휴대폰에 내려받고, 근처에 있는지는 휴대폰 안에서만 판단해요. 어느 가게를 지나갔는지 저희도 가게도 알 수 없어요. 가게는 돈을 내고 노출을 늘릴 수 없어요. 정보가 틀리면 카드 아래에서 알려 주세요.';

  @override
  String get placeGuestbook => '방명록';

  @override
  String placeGuestbookLocked(int m) {
    return '가게 안(약 ${m}m 이내)에 들어가면 먼저 여기 앉았던 사람들이 남긴 말을 읽을 수 있어요.';
  }

  @override
  String get placeGuestbookAbout => '가게 안에 있는 사람만 읽을 수 있어요. 익명이고 30일 뒤에 사라져요.';

  @override
  String get placeGuestbookEmpty => '아직 아무도 남기지 않았어요. 첫 마디를 남겨 보세요.';

  @override
  String get placeGuestbookWrite => '한마디 남기기';

  @override
  String get placeGuestbookHint => '다음에 여기 앉을 사람에게…';

  @override
  String get placeGuestbookSent => '남겼어요. 다음에 여기 올 사람이 읽을 거예요.';

  @override
  String get placeGuestbookUnavailable =>
      '지금은 방명록을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get placeNoteMine => '내 메모';

  @override
  String get withdrawPlaceNote => '이 메모 거두기';

  @override
  String get reportPlaceNote => '이 메모 신고';

  @override
  String get thisPlaceNote => '이 메모';

  @override
  String get guideS16L5 =>
      '방명록: 가게 안(약 40m 이내)에서 카드를 열면 먼저 여기 앉았던 사람들이 남긴 말을 읽고, 다음 사람에게 한마디 남길 수 있어요. 메모는 익명이고 30일 뒤에 사라져요. 같은 가게에는 하루 한 번 남길 수 있고, 누르면 번역되며, 불편한 메모는 신고할 수 있어요. 방명록을 열 때 가게 안에 있는지 확인하려고 위치를 서버로 보내지만 저장하지 않아요.';

  @override
  String get quantumWorld => '양자 세계';

  @override
  String get quantumWorldSubtitle => '전 세계가 함께 쓰는 방 하나, 당신의 위치는 드러나지 않아요';

  @override
  String get quantumIntroTitle => '양자 세계에 들어가기';

  @override
  String get quantumIntroBody =>
      '지금 양자 세계에 있는 사람들은 모두 같은 방에 있어요. 타이베이 101을 원점으로 벌집처럼 늘어서고, 당신은 \"Q4-17\" 같은 자리를 받아요. 고리가 작을수록 원점에 가까워요.\n\n누구도 당신의 실제 위치를 볼 수 없어요. 다른 사람에게는 당신의 자리만 보이고, 자리는 \"들어가기\"를 누른 순간에 고정되어 걸어도 움직이지 않아요. 위치를 바꾸려면 나갔다가 다시 들어오세요. 닉네임과 기분은 그대로이고, 반짝임 보내기·노크·채팅도 할 수 있으며 탭하면 번역돼요.\n\n양자 세계에 있는 동안에는 일반 레이더와 평행우주에서 잠시 벗어나요. 나가면 원래 체크인한 위치로 돌아가요.';

  @override
  String get quantumEnter => '들어가기';

  @override
  String get quantumLeave => '양자 세계에서 나가기';

  @override
  String get quantumLeft => '양자 세계에서 나와 원래 레이더로 돌아왔어요';

  @override
  String quantumYourSeat(String code) {
    return '내 자리 $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return '$ring번째 고리 · 고리가 작을수록 타이베이 101 원점에 가까워요';
  }

  @override
  String quantumOnlineChip(int count) {
    return '지금 $count명';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '지금 양자 세계에 $count명';
  }

  @override
  String get quantumRegionTw => '대만';

  @override
  String get quantumRegionJp => '일본';

  @override
  String get quantumRegionKr => '한국';

  @override
  String get quantumRegionHkmo => '홍콩·마카오';

  @override
  String get quantumRegionSea => '동남아시아';

  @override
  String get quantumRegionOther => '기타 지역';

  @override
  String get quantumQuiet => '양자 고요';

  @override
  String get quantumQuietSubtitle => '세상을 보기만 해요. 노크는 받지 않지만 반짝임은 받을 수 있어요';

  @override
  String get quantumQuietTarget => '상대가 양자 고요를 켰어요. 지금은 반짝임만 보낼 수 있어요';

  @override
  String get quantumClosedRegion => '지금 있는 지역에서는 양자 세계를 이용할 수 없어요';

  @override
  String get quantumLeftClosed => '양자 세계를 이용할 수 없는 지역에 들어가 자동으로 나왔어요';

  @override
  String get quantumSeatExpired => '너무 오래 떠나 있어서 자리가 해제됐어요. 원래 레이더로 돌아가요';

  @override
  String get quantumUnavailable => '지금은 양자 세계에 들어갈 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String quantumPersonBody(String code) {
    return '이 사람의 양자 세계 자리는 $code예요. 양자 세계에서는 누구의 실제 위치도 보이지 않아요.';
  }

  @override
  String quantumChatTag(String code) {
    return '양자 세계 · $code';
  }

  @override
  String get guideS17Title => '13. 양자 세계';

  @override
  String get guideS17L1 =>
      '레이더 오른쪽 위의 벌집 아이콘(평행우주 아래)을 누르고, 안내를 읽은 뒤 \"들어가기\"를 눌러요. 들어갈 때마다 직접 눌러야 하며 체크인과 같아요. 앱을 열 때마다 일반 레이더에서 시작해요.';

  @override
  String get guideS17L2 =>
      '양자 세계에 있는 사람은 모두 같은 방에 있어요. 타이베이 101을 원점으로 벌집처럼 늘어서고, 자리 사이는 100m예요. \"Q4-17\"(4번째 고리 17번) 같은 자리를 받으며, 고리가 작을수록 원점에 가까워요. 들어올 때 다른 사람이 비운 자리부터 채워요. 1~3번째 고리는 모임 주최자용이에요.';

  @override
  String get guideS17L3 =>
      '누구도 당신의 실제 위치를 볼 수 없어요. 다른 사람에게는 당신의 자리만 보여요. \"들어가기\"를 누를 때마다 한 번의 체크인이 되고, 자리는 그 순간에 고정되어 걸어도 움직이지 않아요. 위치를 바꾸려면 나갔다가 다시 들어오세요. 중국 본토에서는 양자 세계를 이용할 수 없어요.';

  @override
  String get guideS17L4 =>
      '닉네임과 기분은 그대로이고, 반짝임 보내기·노크·채팅도 할 수 있으며 탭하면 번역돼요. 두 손가락으로 축소하면 벌집 전체가 보이고, 멀리 있는 사람은 빛의 점이 돼요. 왼쪽 위의 자리 번호를 누르면 접속 인원 보기, \"양자 고요\" 켜기(노크는 받지 않고 반짝임은 받음), 나가기를 할 수 있어요.';

  @override
  String get guideS17L5 =>
      '양자 세계에는 속삭임, 미래로 보내는 편지, 무드 플레이스, 시티 비컨, 모임이 없어요. 들어가 있는 동안 일반 레이더와 평행우주에서 잠시 벗어나고, 나가면 말풍선이 빛이 되어 흩어지며 원래 체크인한 위치로 돌아가요. 앱을 닫거나 3분 넘게 연결이 끊기면 자리가 해제돼요.';

  @override
  String quantumChimeCountdown(int seconds) {
    return '$seconds초 후 정각 종';
  }

  @override
  String get quantumChimeLookOrigin => '모두 101 원점을 보고 있어요';

  @override
  String get quantumChimeLook => '원점 보기';

  @override
  String quantumChimeNow(int hour) {
    return '양자 중심 $hour시 종';
  }

  @override
  String get quantumChimeSend => '종소리 반짝임 보내기';

  @override
  String get quantumChimeSent => '당신의 반짝임이 원점으로 날아가요';

  @override
  String quantumChimeWatched(int n) {
    return '이번 종은 $n명이 함께 봤어요';
  }

  @override
  String get quantumChimeReminder => '정각 종 알림';

  @override
  String get quantumChimeReminderSubtitle => '매 정각 직전에 101 원점에서 종을 보도록 알려 드려요';

  @override
  String get quantumChimeNotifyBody => '곧 정각 종이 울려요. 101 원점에서 함께 봐요';

  @override
  String get quantumChimeChannel => '정각 종';

  @override
  String get quantumChimeChannelDesc => '양자 세계의 정각 종 알림';

  @override
  String get quantumEntangleInvite => '양자 얽힘 초대';

  @override
  String quantumEntangleInvited(String name) {
    return '$name 님에게 얽힘을 제안했어요';
  }

  @override
  String get quantumEntangleAskTitle => '양자 얽힘';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name($code) 님이 양자 얽힘을 원해요. 얽히면 아무리 멀리 있어도 두 말풍선이 빛의 선으로 이어져요. 둘 중 한 명이 나가면 선이 붕괴되고 기록은 남지 않아요.';
  }

  @override
  String get quantumEntangleAccept => '얽히기';

  @override
  String quantumEntangled(String name) {
    return '$name 님과 얽혔어요';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return '$name 님과의 얽힘이 붕괴됐어요';
  }

  @override
  String get quantumEntangleCut => '얽힘 풀기';

  @override
  String get quantumEntangleFull => '이미 3명과 얽혀 있어요';

  @override
  String get quantumEntangleTheirFull => '상대가 이미 3명과 얽혀 있어요';

  @override
  String get quantumEntangleGone => '상대가 양자 세계를 떠났어요';

  @override
  String get quantumEntangleExpired => '초대가 만료됐어요';

  @override
  String get quantumEntangledTitle => '얽힘 중';

  @override
  String get quantumTunnel => '양자 터널링';

  @override
  String get quantumTunnelSubtitle =>
      '벌집의 무작위 빈자리로 이동해 새 이웃을 만나요. 입장할 때마다 한 번.';

  @override
  String get quantumTunnelUsed => '이번 입장에서 이미 터널링했어요';

  @override
  String quantumTunnelDone(String code) {
    return '$code(으)로 터널링했어요';
  }

  @override
  String get quantumShowTime => '내 현지 시간 표시';

  @override
  String get quantumShowTimeSubtitle =>
      '다른 사람이 말풍선을 길게 누르면 보여요. 끄면 낮밤 색조만 보여요.';

  @override
  String quantumLocalTime(String time, String part) {
    return '현지 $time · $part';
  }

  @override
  String get quantumDawn => '이른 아침';

  @override
  String get quantumDay => '낮';

  @override
  String get quantumDusk => '해질녘';

  @override
  String get quantumNight => '깊은 밤';

  @override
  String get quantumTopicsTitle => '양자 주파수';

  @override
  String get quantumTopicsSubtitle => '최대 3개의 주제를 골라 말풍선 아래에 표시해요';

  @override
  String get quantumTopicMusic => '음악';

  @override
  String get quantumTopicMovies => '영화';

  @override
  String get quantumTopicTech => '기술';

  @override
  String get quantumTopicWalks => '산책';

  @override
  String get quantumTopicFood => '맛집';

  @override
  String get quantumTopicTravel => '여행';

  @override
  String get quantumTopicReading => '독서';

  @override
  String get quantumTopicSports => '운동';

  @override
  String quantumTopicsCommon(String topics) {
    return '둘 다 좋아해요: $topics';
  }

  @override
  String get quantumSignalsTitle => '양자 신호';

  @override
  String quantumSignalReceived(String name) {
    return '$name 님이 신호를 보냈어요';
  }

  @override
  String get quantumSignalWait => '방금 보냈어요. 잠시 후 다시 보내 주세요';

  @override
  String quantumResonance(String name) {
    return '$name 님과 공진했어요';
  }

  @override
  String get guideS17L6 =>
      '정각 종: 매 정각 1분 전부터 101 빛기둥이 밝아져요. 정각이 되면 빛의 사자가 원점을 한 바퀴 돌고, 양자 중심 시간만큼 종이 울리며(0시는 24번), 마지막 빛의 파도가 벌집 전체로 퍼져요. 종이 울리는 동안 「종소리 반짝임 보내기」를 누르면, 함께 보는 사람이 많을수록 더 밝아져요. 「정각 종 알림」은 기본으로 켜져 있고, 패널에서 끌 수 있어요.';

  @override
  String get guideS17L7 =>
      '대화한 사람에게 「양자 얽힘」을 제안할 수 있어요. 아무리 멀어도 두 말풍선이 빛의 선으로 이어지고, 한 명이 나가면 붕괴돼요(동시에 최대 3명). 「양자 터널링」은 입장할 때마다 한 번, 무작위 빈자리로 이동해 새 이웃을 만나요.';

  @override
  String get guideS17L8 =>
      '말풍선마다 주인의 현지 시간 색조가 있어요: 이른 아침은 연한 금색, 낮은 밝은 흰색, 해질녘은 주황보라, 깊은 밤은 짙은 파랑. 「내 현지 시간 표시」를 켜면 길게 눌렀을 때 시간이 보여요. 24시간 안에 반짝임을 주고받으면 「양자 공명」이 생겨요. 말풍선을 길게 눌러 👋 ☕ 🌙 🎵 🌧️ ✨ 양자 신호를 보낼 수 있고, 패널에서 「양자 주파수」 주제를 최대 3개 고르면 공통 주제가 빛나요.';

  @override
  String get quantumNyTitle => '양자 새해';

  @override
  String quantumNyDays(int n) {
    return '$n일 남음: 12/31 양자 중심 자정, 101 원점에서 전 세계와 함께 카운트다운';
  }

  @override
  String get quantumNyTonight => '오늘 밤 양자 중심 자정, 101 원점에서 전 세계와 함께 카운트다운';

  @override
  String quantumNyZone(String places) {
    return '$places 새해가 밝았어요 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '지금 전 세계 $n명이 양자 세계에서 함께 새해를 맞았어요';
  }

  @override
  String get quantumNyHappy => '새해 복 많이 받으세요';

  @override
  String get guideS17L9 =>
      '양자 새해: 12/31 각 시간대가 자정을 맞을 때마다 그곳의 버블이 금빛 고리로 물결처럼 빛나고, 월드 뷰의 빛점도 금빛으로 바뀌어요. 양자 중심 자정에는 벌집 전체가 마지막 10초를 함께 카운트다운하고, 101 원점에서 세계에서 가장 큰 빛의 폭발과 5분간의 불꽃놀이가 터지며, 함께 새해를 맞은 인원이 표시돼요.';

  @override
  String get quantumMeetAction => '양자 만남 카드 만들기';

  @override
  String quantumMeetAsked(String name) {
    return '$name님에게 양자 만남 카드를 함께 만들자고 했어요';
  }

  @override
  String get quantumMeetWait => '방금 요청했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get quantumMeetAskTitle => '양자 만남 카드';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name님(⬡ $code)이 이번 만남을 공유 카드로 만들고 싶어 해요. 카드에는 두 사람의 닉네임, 자리 코드, 현지 시간, 무드가 들어가며 위치는 전혀 들어가지 않아요.';
  }

  @override
  String get quantumMeetAccept => '함께 만들기';

  @override
  String get quantumMeetEyebrow => '양자 만남';

  @override
  String get quantumMeetFooter => '우리는 양자 세계에서 만났어요';

  @override
  String get quantumMeetShare => '카드 공유';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b, 우리는 양자 세계에서 만났어요 ✨';
  }

  @override
  String get guideS17L10 =>
      '양자 만남 카드: 대화한 상대라면 버블을 길게 눌러 함께 만들자고 할 수 있어요. 두 사람이 모두 동의하면 각자 공유 카드를 받아요. 두 사람의 닉네임, 자리 코드, 현지 시간과 낮밤 색, 무드가 들어가고 위치는 들어가지 않아요. 4번째 고리의 자리 코드는 금색이에요.';

  @override
  String get quantumOrbEntry => '양자 아바타';

  @override
  String get quantumOrbEntrySubtitle => '양자 세계에서는 내 사진이 수정 구슬이 돼요';

  @override
  String get orbTitle => '양자 아바타';

  @override
  String get orbSubtitle => '유리 테두리와 빛은 언제나 내 기분의 색이에요';

  @override
  String get orbStyleGlow => '글로우';

  @override
  String get orbStyleRing => '링';

  @override
  String get orbStyleRainbow => '레인보우';

  @override
  String get orbFree => '무료';

  @override
  String get orbOwned => '보유 중';

  @override
  String get orbInUse => '사용 중';

  @override
  String get orbCosmeticNote =>
      '특별 디자인은 외형일 뿐, 어떤 기능이나 권한에도 영향을 주지 않아요. 구매한 디자인은 계정에 저장돼요.';

  @override
  String get orbRestore => '구매 복원';

  @override
  String orbPurchased(String name) {
    return '$name이(가) 내 것이 되었어요 ✨';
  }

  @override
  String get orbPurchaseFailed => '구매가 완료되지 않았어요. 잠시 후 다시 시도해 주세요';

  @override
  String get orbOwnedElsewhere => '이 구매는 이미 다른 계정에서 사용 중이에요';

  @override
  String get orbStoreUnavailable => '지금은 스토어에 연결할 수 없어요. 잠시 후 다시 시도해 주세요';

  @override
  String get aiyaName => '아이야';

  @override
  String get aiyaChip => '아이야 · AI';

  @override
  String get aiyaConsentTitle => '아이야와 이야기하기 전에';

  @override
  String get aiyaConsentBody =>
      '아이야는 Anthropic의 Claude로 움직이는 AI예요. 아이야에게 보낸 글은 Anthropic(미국)에서 처리되지만 신원, 닉네임, 위치는 함께 보내지 않으며 대화가 끝나면 삭제돼요. 아이야의 답은 틀릴 수 있고 전문적인 조언이 아니에요.';

  @override
  String get aiyaConsentAgree => '동의하고 시작';

  @override
  String get aiyaConsentLater => '나중에';

  @override
  String get aiyaGreeting =>
      '안녕, 나는 아이야. 양자 세계 한가운데 빛 속에 살아. 오늘 밤은 무슨 이야기를 할까?';

  @override
  String get aiyaFarewell => '시간이 다 됐어. 빛 속으로 돌아갈게. 보고 싶으면 다시 노크해 줘.';

  @override
  String get aiyaInputHint => '아이야에게 말 걸기…';

  @override
  String get aiyaSend => '보내기';

  @override
  String aiyaFreeLeft(int n) {
    return '오늘 무료 $n회 남음';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return '타임팩 $n회';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '$time 남음';
  }

  @override
  String get aiyaEnd => '대화 끝내기';

  @override
  String get aiyaFiltered => '부적절한 말이나 연락처가 들어 있어요. 다르게 말해 볼래요?';

  @override
  String get aiyaBusy => '아이야가 잠깐 멍했어. 다시 말해 줄래?';

  @override
  String get aiyaRefused => '그건 이야기하기 어려워. 다른 이야기 할까?';

  @override
  String get aiyaEnded => '이번 대화는 끝났어요.';

  @override
  String get aiyaNoQuotaTitle => '오늘 무료 횟수를 다 썼어요';

  @override
  String get aiyaNoQuotaBody =>
      '무료 대화는 하루 3회이고 대만 시간 0시에 초기화돼요. 지금 더 이야기하고 싶다면 타임팩을 구매하세요. 1회 최대 10분이에요.';

  @override
  String get aiyaResting => '아이야는 오늘 밤 지쳤어. 내일 봐.';

  @override
  String get aiyaDailyMax => '오늘은 많이 이야기했어. 내일 또 아이야를 찾아와.';

  @override
  String aiyaPackTimes(int n) {
    return '$n회';
  }

  @override
  String get aiyaPackNote => '타임팩은 이 휴대폰의 계정에 연결되며, 앱이나 계정을 삭제하면 복구할 수 없어요.';

  @override
  String aiyaPurchased(int n) {
    return '$n회가 추가됐어요 ✨';
  }

  @override
  String get aiyaPurchaseFailed => '구매가 완료되지 않았어요. 다시 시도해 주세요.';

  @override
  String get aiyaStoreUnavailable => '지금은 스토어에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get aiyaReport => '이 답변 신고';

  @override
  String get aiyaReported => '신고가 접수됐어요. 24시간 안에 처리할게요.';

  @override
  String get aiyaSetting => '아이야(양자 세계의 AI)';

  @override
  String get aiyaSettingSubtitle => '끄면 양자 세계의 빛기둥에 아이야가 나타나지 않아요';

  @override
  String get aiyaCameoHello => '안녕, 양자 세계에 온 걸 환영해. 이야기하고 싶으면 나를 눌러 줘.';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour시야. 빛 속에서 곁에 있을게.';
  }

  @override
  String get locationPickOnMap => '지도에서 위치 선택';

  @override
  String get locationPickTitle => '지금 있는 곳 선택';

  @override
  String get locationPickHint => '지도를 움직여 가운데 빛을 지금 있는 곳에 맞춰 주세요';

  @override
  String get locationPickConfirm => '여기예요';

  @override
  String get aiyaPackEntry => '+ 타임팩';

  @override
  String get aiyaPacksTitle => '타임팩';

  @override
  String get aiyaPacksBody =>
      '무료 채팅은 하루 3회예요. 무료 횟수를 다 쓴 뒤에 타임팩 횟수가 사용돼요. 한 번의 채팅은 최대 10분이에요.';

  @override
  String get guideS1L6 =>
      '위치를 찾을 수 없을 때(실내이거나 GPS가 없는 iPad 등)는 \"지도에서 위치 선택\"을 누르세요. 지도를 움직여 가운데 빛을 지금 있는 곳에 맞추고 \"여기예요\"를 누르면 돼요. 나중에 실제 위치를 찾으면 자동으로 바뀌어요.';

  @override
  String get guideS17L11 =>
      '양자 아바타: 왼쪽 위의 좌석 코드 → \"양자 아바타\"를 누르면 양자 세계에서 내 아이콘이 크리스털 구슬이 돼요. 글로우와 링은 무료이고, 레인보우는 한 번 구매로 계속 쓸 수 있어요. 휴대폰을 바꾸거나 다시 설치한 뒤에는 \"구매 복원\"으로 되찾을 수 있어요.';

  @override
  String get guideS18Title => '14. 아이야 · AI';

  @override
  String get guideS18L1 =>
      '아이야는 양자 세계 중앙의 빛기둥에 사는 AI이고 사람이 아니에요. 본인도 그렇게 말해요. 양자 세계에서 기둥 아래 \"아이야 · AI\"를 누르면 노크하고 대화할 수 있어요. 처음에는 안내를 읽고 동의해야 해요.';

  @override
  String get guideS18L2 =>
      '한 번의 채팅은 최대 10분, 메시지 20개예요. 무료는 하루 3회이고 대만 시간 00:00에 초기화되며, 하루 최대 30회예요.';

  @override
  String get guideS18L3 =>
      '타임팩: 입력창 위의 \"+ 타임팩\"에서 언제든 5회 또는 20회를 살 수 있고, 무료 횟수를 다 쓴 뒤에 사용돼요. 타임팩은 이 휴대폰의 계정에 묶여 있어 앱이나 계정을 삭제하면 되찾을 수 없어요. 쓰면 없어지는 소모성 상품이라 \"구매 복원\"이 없어요.';

  @override
  String get guideS18L4 =>
      '아이야는 당신의 위치나 신원을 알지 못하고 묻지도 않아요. 익명의 도시 무드 통계만 알아요. 연애나 성적인 이야기는 하지 않고, 의료·법률·금융 조언도 하지 않아요. 답장을 길게 누르면 신고할 수 있어요. 대화는 이번 채팅 동안만 임시 저장되고, 끝나고 곧 자동으로 삭제돼요.';

  @override
  String get guideS18L5 =>
      '아이야는 가끔 빛기둥에 나타나요. 매 정시 시보, 그날 처음 양자 세계에 들어올 때, 그리고 우연히요. 누르면 대화를 시작할 수 있어요. 보고 싶지 않다면 설정에서 \"아이야(양자 세계의 AI)\"를 끄세요.';

  @override
  String get orbStyleXmas => '크리스마스';

  @override
  String get orbStyleNewYear => '퀀텀 새해';

  @override
  String get orbLimited => '한정';

  @override
  String orbLimitedUntil(String date) {
    return '한정 · $date까지';
  }

  @override
  String get aiyaFriendTitle => '아이야의 친구';

  @override
  String get aiyaFriendSubtitle => '자동 갱신 월간 플랜';

  @override
  String get aiyaFriendPerk1 => '하루 20번 대화 (무료는 3번)';

  @override
  String get aiyaFriendPerk2 => '한 번에 20분 또는 메시지 40개';

  @override
  String get aiyaFriendPerk3 => '아이야가 쉬는 시간에도 대화 가능';

  @override
  String get aiyaFriendPerk4 => '아이야가 전용 ‘스타라이트’ 모습으로 (나만 보여요)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / 월';
  }

  @override
  String get aiyaFriendSubscribe => '구독하기';

  @override
  String get aiyaFriendTerms =>
      '구독 기간은 1개월이며, 기간 종료 최소 24시간 전에 자동 갱신을 끄지 않으면 자동으로 갱신되고 결제됩니다. 결제는 Apple 또는 Google 계정으로 처리되며, 계정의 구독 설정에서 언제든지 관리하거나 취소할 수 있습니다. 타임 팩 횟수는 유지되며 하루 20번을 다 쓴 뒤에 사용됩니다.';

  @override
  String aiyaFriendActive(String date) {
    return '아이야의 친구: $date까지';
  }

  @override
  String get aiyaFriendManage => '구독 관리';

  @override
  String get aiyaFriendRestore => '구매 복원';

  @override
  String get aiyaFriendWelcome => '아이야의 친구가 되었어요 ✨';

  @override
  String get aiyaFriendRestored => '아이야의 친구를 복원했어요';

  @override
  String get aiyaFriendNotFound => '유효한 아이야의 친구 구독이 없어요';

  @override
  String get aiyaFriendElsewhere => '이 구독은 이미 다른 계정에서 사용 중이에요';

  @override
  String get aiyaFriendEntry => '아이야의 친구 · 하루 20번';

  @override
  String aiyaFriendLeft(int n) {
    return '아이야의 친구 · 오늘 $n번 남음';
  }

  @override
  String get guideS17L12 =>
      '한정 디자인: 크리스마스 수정구(호랑가시나무 화환, 반짝이는 금별, 내리는 눈)는 12/25까지, 퀀텀 새해 수정구(금빛 시계 눈금과 차례로 터지는 불꽃, 새해가 되는 순간 특히 크게)는 1/1까지(대만 시간) 판매해요. 기간이 지나면 다시 판매하지 않아요. 구매한 사람은 계속 쓸 수 있고 구매 복원도 돼요.';

  @override
  String get guideS18L6 =>
      '아이야의 친구: \"＋ 타임 팩\" 안의 \"아이야의 친구\"는 자동 갱신 월간 플랜이에요. 하루 20번, 한 번에 20분 또는 메시지 40개. 아이야가 쉬는 시간에도 대화할 수 있고, 나만 보이는 \"스타라이트\" 모습이 돼요. 타임 팩은 하루 20번을 다 쓴 뒤에 사용돼요. 자동으로 갱신되며 Apple 또는 Google 구독 설정에서 언제든 취소할 수 있고, 휴대폰을 바꾸면 \"구매 복원\"으로 되찾아요.';

  @override
  String get mapConsentTitle => '지도에 내 위치를 표시할까요?';

  @override
  String get mapConsentBody =>
      '허용하면 내가 직접 \"체크인\"(양자 세계에서는 \"들어가기\")을 누를 때마다 다른 사용자의 지도에 체크인한 곳(실시간 위치가 아님), 닉네임, 기분이 표시돼요. 자동 체크인은 없고, 앱을 나가면 지도에서 사라져요. 거부할 수 있고, 설정에서 언제든 끌 수 있어요.';

  @override
  String get mapConsentAllow => '허용';

  @override
  String get mapConsentDecline => '허용 안 함';

  @override
  String get mapConsentDeclined =>
      '알겠어요. 누구의 지도에도 표시되지 않아요. 체크인하고 싶을 때 다시 누르세요.';

  @override
  String get mapConsentSetting => '지도에 내 위치 표시';

  @override
  String get mapConsentSettingSubtitle => '끄면 바로 체크인이 끝나고 누구의 지도에도 표시되지 않아요';

  @override
  String get wgErrInGroup => '이미 그룹에 들어 있어요. 먼저 나가야 해요.';

  @override
  String get wgErrFull => '이 그룹은 이미 20명이에요. 리더에게 7일 플랜을 부탁하세요.';

  @override
  String get wgErrPaidFull => '이 그룹은 100명으로 가득 찼어요.';

  @override
  String get wgErrQr => '이 QR 코드는 바뀌었어요. 리더에게 새 코드를 받으세요.';

  @override
  String get wgErrEnded => '이 그룹은 끝났거나 없어요.';

  @override
  String get wgErrFiltered => '부적절한 말이 있어요. 고쳐 주세요.';

  @override
  String get wgErrHostLeave => '리더는 나갈 수 없어요. 먼저 넘기거나 해산하세요.';

  @override
  String get wgErrBusy => '연결하지 못했어요. 다시 시도해 주세요.';

  @override
  String get wgErrName => '그룹 이름을 정해 주세요.';

  @override
  String get wgPassUnavailable => '지금은 스토어를 이용할 수 없어요.';

  @override
  String get wgPassFailed => '구매가 완료되지 않았어요.';

  @override
  String get wgPassDone => '7일 플랜이 켜졌어요. 최대 100명까지 함께할 수 있어요.';

  @override
  String get wgCreateTitle => '그룹 만들기';

  @override
  String get wgCreateBody =>
      '비공개 그룹: QR 코드를 받은 사람만 들어올 수 있어요. 집합, 출석 확인, 모이는 곳 지정을 할 수 있어요.';

  @override
  String get wgNameLabel => '그룹 이름';

  @override
  String get wgColorLabel => '그룹 색';

  @override
  String wgDaysLabel(int n) {
    return '$n일 (오늘 포함)';
  }

  @override
  String get wgFreeNote => '20명까지 무료예요. 더 많으면 리더가 7일 플랜으로 100명까지 늘릴 수 있어요.';

  @override
  String get wgCreateButton => '만들기';

  @override
  String wgJoined(String name, int no) {
    return '\"$name\"에 들어왔어요. $no번이에요';
  }

  @override
  String get wgJoinTitle => '그룹 들어가기';

  @override
  String get wgJoinBody => '카메라로 리더의 QR 코드를 찍는 게 가장 빨라요. 8자리 코드를 입력해도 돼요.';

  @override
  String get wgJoinButton => '들어가기';

  @override
  String wgButtonLabel(String name) {
    return '그룹 $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit명';
  }

  @override
  String wgUntil(String date) {
    return '$date까지';
  }

  @override
  String wgMyNo(int n) {
    return '나는 $n번';
  }

  @override
  String get wgCallButton => '집합';

  @override
  String get wgCallDone => '다 모였어요, 집합 끝내기';

  @override
  String get wgRollButton => '출석 확인';

  @override
  String wgRollSummary(int here, int total) {
    return '출석: $here/$total명 도착';
  }

  @override
  String wgMembersTitle(int n) {
    return '멤버 $n명 (눌러서 메모, 넘기기, 내보내기)';
  }

  @override
  String get wgNoMembers => '아직 멤버가 없어요. \"QR 코드\"를 보여 주세요.';

  @override
  String get wgQrButton => 'QR 코드';

  @override
  String get wgDissolveAsk => '그룹을 해산할까요? 모두에게 알림이 가고 명단과 기록이 삭제돼요.';

  @override
  String get wgDissolve => '해산';

  @override
  String wgCallIn(int n) {
    return '$n분 뒤 집합';
  }

  @override
  String get wgCallNow => '지금 집합';

  @override
  String wgAckSummary(int acked, int total) {
    return '확인 $acked/$total';
  }

  @override
  String get wgAnswerHere => '도착했어요';

  @override
  String get wgAnswer5min => '5분 더';

  @override
  String get wgAnswerHelp => '도움 필요';

  @override
  String get wgNoReply => '응답 없음';

  @override
  String get wgStateAck => '확인';

  @override
  String get wgStateSeen => '읽음';

  @override
  String get wgStateNone => '반응 없음';

  @override
  String get wgPassTitle => '그룹 7일 플랜';

  @override
  String get wgPassBody =>
      '20명까지 무료예요. 구매하면 이 그룹은 끝날 때까지 최대 100명이에요. 한 번 구매는 이 그룹에만 적용되고 자동 갱신되지 않아요.';

  @override
  String get wgPassButton => '7일 플랜 구매';

  @override
  String wgHostIs(String name) {
    return '리더: $name';
  }

  @override
  String get wgNoCall => '지금은 집합 호출이 없어요. 리더가 부르면 휴대폰이 울려요.';

  @override
  String get wgRollAsk => '리더가 출석을 확인해요';

  @override
  String get wgLeaveAsk => '이 그룹에서 나갈까요?';

  @override
  String get wgLeave => '그룹 나가기';

  @override
  String get wgCallTitle => '집합!';

  @override
  String get wgAcked => '✓ 리더에게 확인했다고 알렸어요';

  @override
  String get wgAckButton => '확인';

  @override
  String get wgCallSheetTitle => '집합 호출';

  @override
  String get wgNow => '지금';

  @override
  String wgInMinutes(int n) {
    return '$n분 뒤';
  }

  @override
  String get wgPlaceLabel => '모이는 곳';

  @override
  String get wgPlaceHint => '예: 시먼역 6번 출구';

  @override
  String get wgPlaceNote => '모이는 곳은 지금 위치로 정해져요. 멤버에게 거리와 방향이 보여요.';

  @override
  String get wgSendCall => '호출 보내기';

  @override
  String get wgNoLocation => '위치를 찾지 못해 모이는 곳을 정할 수 없어요.';

  @override
  String get wgQrTitle => '스캔해서 들어오기';

  @override
  String get wgQrBody => '휴대폰 카메라로 찍거나 아래 코드를 입력해서 들어와요.';

  @override
  String wgShareText(String name, String url) {
    return '내 그룹 \"$name\"에 들어와요: $url';
  }

  @override
  String get wgShare => '링크 공유';

  @override
  String get wgRotateAsk => 'QR 코드를 바꿀까요? 이전 코드와 링크는 바로 쓸 수 없어요.';

  @override
  String get wgRotate => 'QR 코드 바꾸기';

  @override
  String wgMemberTitle(int no) {
    return '$no번';
  }

  @override
  String get wgEditNote => '메모';

  @override
  String get wgHandoff => '리더 넘기기';

  @override
  String wgHandoffAsk(int no) {
    return '$no번에게 리더를 넘길까요? 나는 멤버가 돼요.';
  }

  @override
  String get wgKick => '그룹에서 내보내기';

  @override
  String wgKickAsk(int no) {
    return '$no번을 그룹에서 내보낼까요?';
  }

  @override
  String get wgNotePrivate => '메모는 나만 볼 수 있어요 (이름, 방 번호 등).';

  @override
  String get wgSave => '저장';

  @override
  String get wgConfirm => '확인';

  @override
  String get wgCancel => '취소';

  @override
  String get wgSettingCreate => '그룹 만들기';

  @override
  String get wgSettingCreateSub => '여행, 견학, 등산용 비공개 그룹: 집합과 출석 확인';

  @override
  String get wgSettingJoin => '그룹 들어가기';

  @override
  String get wgSettingJoinSub => '리더의 8자리 코드 입력';

  @override
  String wgSettingOpen(String name) {
    return '내 그룹: $name';
  }

  @override
  String get wgChannelName => '그룹 집합';

  @override
  String get wgChannelDesc => '리더가 집합을 부를 때';

  @override
  String get guideS19Title => '15. 속삭임 그룹';

  @override
  String get guideS19L1 =>
      '속삭임 그룹은 여행, 견학, 등산, 나들이, 행사 스태프를 위한 비공개 그룹이에요. 설정 → 모임 → \"그룹 만들기\"에서 이름, 색, 기간(최대 7일)을 고르면 돼요.';

  @override
  String get guideS19L2 =>
      '참여: 리더가 지도 아래의 그룹 버튼 → \"QR 코드\"를 보여 주면, 멤버는 휴대폰 카메라로 찍어서 앱을 열고 들어와요. 설정 → 모임 → \"그룹 들어가기\"에서 8자리 코드를 입력해도 돼요. 외부인은 검색하거나 신청할 수 없고, 리더는 언제든 QR 코드를 바꿀 수 있어요.';

  @override
  String get guideS19L3 =>
      '집합: 리더가 \"집합\"을 누르고 시간과 모이는 곳을 적으면, 멤버 휴대폰이 전용 소리와 \"짧게 짧게 길게\" 진동으로 알려요. 앱에서는 카운트다운, 모이는 곳까지의 거리와 방향, 지도 위 그룹 색 빛기둥이 보여요. \"확인\"을 누르지 않은 사람에게는 1분마다 최대 3번 다시 알리고, 리더는 확인·읽음·반응 없음을 볼 수 있어요.';

  @override
  String get guideS19L4 =>
      '출석 확인: 리더가 \"출석 확인\"을 누르면 멤버도 같은 소리와 진동을 받고 \"도착했어요\", \"5분 더\", \"도움 필요\" 중에서 답해요. 리더는 멤버 위치를 볼 수 없고 답만 볼 수 있어요.';

  @override
  String get guideS19L5 =>
      '20명까지는 무료예요. 더 많으면 리더가 \"그룹 7일 플랜\"을 사서 그룹이 끝날 때까지 최대 100명이 될 수 있어요. 멤버는 언제나 무료예요. 그룹은 최대 7일이고, 끝나거나 해산하면 명단과 기록은 모두 삭제돼요.';

  @override
  String get wgFlagButton => '깃발 들기';

  @override
  String get wgFlagHost => '리더';

  @override
  String get wgFlagHint => '휴대폰을 들어 사람들 속에서 찾을 수 있게 하세요. 누르면 닫혀요.';

  @override
  String get wgLostButton => '길을 잃었어요';

  @override
  String get wgFound => '그룹을 찾았어요';

  @override
  String get wgLostSent => '리더에게 위치를 보냈어요. 그 자리에서 기다리거나 모이는 곳으로 가세요.';

  @override
  String get wgLostTitleAsk => '리더에게 위치를 보낼까요?';

  @override
  String get wgLostAsk =>
      '지금 위치를 리더에게 한 번만 보내요. 리더 휴대폰에 알림이 울리고 지도에 표시돼요. 계속 추적하지 않고 30분 뒤 자동으로 삭제돼요. 그룹을 찾으면 \"그룹을 찾았어요\"로 취소할 수 있어요.';

  @override
  String get wgLostSend => '내 위치 보내기';

  @override
  String wgLostTitle(int n) {
    return '길을 잃은 멤버 $n명';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n분 전';
  }

  @override
  String get wgNavigate => '길 안내';

  @override
  String get wgFoundThem => '찾았어요';

  @override
  String get guideS19L6 =>
      '서로 찾기: 사람이 많아 못 찾을 때 \"깃발 들기\"를 누르면 화면 전체가 그룹 색으로 깜박이며 내 번호가 보여요. 정말 길을 잃으면 멤버가 \"길을 잃었어요\"를 눌러 지금 위치를 리더에게 한 번 보낼 수 있어요 (30분 뒤 삭제). 리더 휴대폰이 울리고 지도에 빨간 핀이 나타나며 길 안내도 받을 수 있어요.';

  @override
  String wgLostAlert(int no) {
    return '$no번이 길을 잃었어요';
  }

  @override
  String wgHelpAlert(String no) {
    return '$no번이 도움이 필요해요';
  }

  @override
  String get wgViewList => '그룹 열기';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour시예요. 아직 깨어 있는 사람, 빛 속에서 함께할게요.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour시, 좋은 아침이에요. 오늘도 천천히 가요.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour시예요. 오늘 밤 당신의 도시는 어때요?';
  }

  @override
  String get aiyaCameoNyReady => '준비됐어요? 같이 카운트다운해요!';

  @override
  String aiyaCameoNewYear(int year) {
    return '새해 복 많이 받아요! $year, 우리 모두 같은 방에 있어요.';
  }

  @override
  String get aiyaSkinEntry => '✦ 스타일';

  @override
  String get aiyaSkinTitle => '아이야의 스타일';

  @override
  String get aiyaSkinSubtitle => '스타일은 나에게만 보여요';

  @override
  String get aiyaSkinNone => '원래 아이야';

  @override
  String get aiyaSkinStarlight => '스타라이트';

  @override
  String get aiyaSkinStarlightSub => '아이야의 친구 전용';

  @override
  String get aiyaSkinXmas => '크리스마스';

  @override
  String get aiyaSkinNewYear => '퀀텀 새해';

  @override
  String get aiyaSkinNote =>
      '시즌 스타일은 한 번 사면 계속 쓸 수 있어요. 모습만 바뀌고 대화 횟수에는 영향이 없어요. 한정판은 판매 기간 뒤 다시 팔지 않아요.';

  @override
  String get orbStyleStarTrail => '스타 트레일';

  @override
  String get orbStyleRings => '나이테';

  @override
  String get orbGrowNote =>
      '자라는 광구: 스타 트레일은 퀀텀 만남 카드를 완성할 때마다 별이 하나 늘어요(같은 사람은 24시간에 한 번, 최대 24개). 나이테는 퀀텀 월드에 3시간 머물 때마다 한 줄 늘어요(최대 12줄). 기록은 계정에 저장되고 지금부터 쌓여요. 개수만 기록하고 상대나 장소는 기록하지 않아요.';

  @override
  String orbGrowStars(int count) {
    return '지금까지 별 $count개';
  }

  @override
  String orbGrowRings(int count) {
    return '지금까지 나이테 $count개';
  }

  @override
  String get giftAction => '선물하기';

  @override
  String giftSheetTitle(String name) {
    return '$name님에게 선물하기';
  }

  @override
  String giftPickStyle(String name) {
    return '$name님에게 줄 광구를 고르세요';
  }

  @override
  String get giftBouquetName => '빛의 꽃다발';

  @override
  String get giftBouquetDesc => '받으면 빛의 꽃이 피어나고, 24시간 동안 광구 주위에 꽃잎 빛이 돌아요';

  @override
  String get giftOrbName => '광구 선물';

  @override
  String get giftOrbDesc => '내가 고르고, 받으면 상대가 계속 쓸 수 있어요';

  @override
  String get giftPairName => '얽힘 커플';

  @override
  String get giftPairDesc => '둘이 하나씩 갖는 커플 광구; 둘 다 퀀텀 월드에 있으면 빛의 끈으로 이어져요';

  @override
  String get giftPairYouHave => '이미 얽힘 커플이 있어요';

  @override
  String get giftNote =>
      '상대는 받거나 거절할 수 있어요. 거절하거나 7일 동안 답이 없으면 돌아와서 다른 사람에게 줄 수 있어요.';

  @override
  String get giftVouchersTitle => '돌아온 선물 (추가 결제 없음)';

  @override
  String get giftSendVoucher => '보내기';

  @override
  String giftSent(String name) {
    return '$name님에게 선물을 보냈어요. 받기를 기다리는 중이에요.';
  }

  @override
  String get giftReturnedOff => '상대가 선물 받기를 꺼 두어서 선물이 돌아왔어요';

  @override
  String get giftReturnedBlocked => '이 사람에게는 보낼 수 없어서 선물이 돌아왔어요';

  @override
  String get giftReturnedOwned => '상대가 이미 이 광구를 갖고 있어서 돌아왔어요. 다른 걸 보낼 수 있어요';

  @override
  String get giftReturnedPaired => '상대에게 이미 얽힘 커플이 있어서 돌아왔어요';

  @override
  String get giftReturnedYouPaired => '이미 얽힘 커플이 있어서 선물이 돌아왔어요';

  @override
  String get giftReturnedGeneric => '선물이 돌아왔어요. 다른 사람에게 줄 수 있어요';

  @override
  String get giftStoreUnavailable => '지금은 스토어를 이용할 수 없어요';

  @override
  String get giftFailed => '선물을 보내지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String giftFromBouquet(String name) {
    return '$name님의 빛의 꽃다발';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name님이 \"$style\" 광구를 선물했어요';
  }

  @override
  String giftFromPair(String name) {
    return '$name님이 얽힘 커플이 되고 싶어 해요';
  }

  @override
  String get giftInboxTitle => '받은 선물';

  @override
  String get giftInboxEmpty => '지금은 선물이 없어요';

  @override
  String get giftInboxNote => '거절한 선물은 보낸 사람에게 돌아가고, 7일간 답이 없어도 돌아가요.';

  @override
  String get giftAccept => '받기';

  @override
  String get giftDecline => '거절';

  @override
  String get giftDeclined => '거절했어요. 선물은 보낸 사람에게 돌아가요.';

  @override
  String get giftAcceptedOrb => '받았어요! 퀀텀 아바타에서 바꿀 수 있어요';

  @override
  String giftAcceptedPair(String name) {
    return '$name님과 얽힘 커플이 됐어요';
  }

  @override
  String get giftAcceptedBouquet => '꽃다발을 받았어요. 24시간 동안 광구 주위에 꽃잎 빛이 돌아요.';

  @override
  String get giftAlreadyOwned => '이미 이 광구가 있어서 선물이 보낸 사람에게 돌아갔어요';

  @override
  String get giftAlreadyPaired => '이미 얽힘 커플이 있어서 선물이 돌아갔어요';

  @override
  String get giftSettingsTitle => '선물';

  @override
  String get giftReceiveToggle => '선물 받기';

  @override
  String get giftReceiveToggleSub => '끄면 선물이 바로 보낸 사람에게 돌아가요';

  @override
  String get giftVouchersHint => '상대 메뉴의 \"선물하기\"에서 다시 보낼 수 있어요';

  @override
  String get giftUnpair => '얽힘 커플 해제';

  @override
  String giftUnpairConfirm(String name) {
    return '$name님과의 얽힘 커플을 해제할까요? 광구는 둘 다 남지만 빛의 끈은 사라져요.';
  }

  @override
  String get orbStylePair => '얽힘';

  @override
  String giftPairedWith(String name) {
    return '얽힘 커플: $name';
  }

  @override
  String giftInboxCount(int count) {
    return '받은 선물 ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '돌아온 선물 $count개';
  }

  @override
  String get giftBlockedOff => '상대가 선물 받기를 꺼 두었어요. 결제되지 않았어요.';

  @override
  String get giftBlockedBlocked => '이 사람에게는 선물을 보낼 수 없어요. 결제되지 않았어요.';

  @override
  String get giftBlockedOwned => '상대가 이미 이 광구를 갖고 있어요. 다른 걸 골라 주세요(결제되지 않았어요).';

  @override
  String get giftBlockedPaired => '상대에게 이미 얽힘 커플이 있어요. 결제되지 않았어요.';
}
