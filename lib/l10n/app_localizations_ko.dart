// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

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
  String get releaseNotesTitle => 'Mood Whisper 1.1 내부 테스트 버전';

  @override
  String get releaseNotesLead => '도시가 밤의 색으로 갈아입었어요.';

  @override
  String get releaseNotesMap => '새로운 야경 지도: 짙은 파랑의 거리, 은은히 빛나는 길, 네온 건물';

  @override
  String get releaseNotesBubbles => '무드 버블이 어두운 유리로 바뀌어 어디서나 잘 보여요';

  @override
  String get releaseNotesResting => '휴식 중과 잔상: 화면이 잠겨 있어도 노크를 받을 수 있어요';

  @override
  String get releaseNotesSafety => '신고와 차단으로 도시를 안전하게';

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
      '지금 기분을 한 문장(최대 20자)으로 쓰고, 이용약관과 개인정보 처리방침에 동의한 뒤 \'Mood Whisper 입장\'을 누르세요.';

  @override
  String get guideS1L3 => '전화번호, 이메일, 실명이 필요 없어요. 계정은 익명이며 이 휴대폰에 연결돼요.';

  @override
  String get guideS1L4 =>
      '무드 색은 글 속 키워드로 정해져요. \'기쁨·웃음\'은 금색, \'슬픔·눈물\'은 파랑, \'화남\'은 주홍, \'평온·멍\'은 초록, \'열정\'은 주황, \'사랑·하트\'는 분홍, 그 밖에는 연보라예요.';

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
      '숨 쉬듯 움직이는 버블은 상대가 앱을 쓰고 있다는 뜻이에요. 어두워지고 \'휴식 중\'이라고 표시되면 화면을 잠갔지만 노크는 할 수 있어요. 이름 없는 회색 버블은 막 떠난 사람이 남긴 \'잔상\'으로, 천천히 사라져요.';

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
      '범위는 진행자를 중심으로 5km이고, 진행자가 움직이면 함께 움직여요. 레이더에서 진행자에게는 빛 고리와 \'진행\' 표시가 붙어요.';

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
  String get guideS10Title => '10. 무드 카드와 무드 궤적';

  @override
  String get guideS10L1 =>
      '아래 메뉴의 공유 버튼으로 지금 무드를 야경 카드로 만들 수 있어요. 인스타 스토리에 딱이고, 카드에는 위치가 들어가지 않아요.';

  @override
  String get guideS10L2 =>
      '설정 → \'나의 무드 궤적\'에서 지금까지 쓴 무드와 장소를 돌아볼 수 있어요. 데이터는 이 휴대폰에만 저장되며 언제든 끄거나 지울 수 있어요.';

  @override
  String get guideS11Title => '11. 설정과 알림';

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
  String get guideS12Title => '12. 신고와 차단';

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
  String get guideS13Title => '13. 개인정보와 계정';

  @override
  String get guideS13L1 =>
      '근처 사람들은 당신의 무드, 도시 닉네임, 사진, 대략적인 거리를 볼 수 있어요. 위치는 앱을 사용하는 동안에만 쓰여요.';

  @override
  String get guideS13L2 =>
      '설정 → \'계정 및 데이터 삭제\'에서 도시에 남긴 모든 것을 언제든 영구 삭제할 수 있어요.';

  @override
  String get guideS13L3 =>
      '궁금한 점은 설정 → \'문의하기\' 또는 service.softchip@gmail.com으로 보내 주세요.';

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
      '눈을 감고 휴대폰의 진동과 심장 박동을 느껴 보세요. 이제 지금 기분을 적고 Mood Whisper로 들어오세요.';

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
  String get loginTitle2 => '준비 됐나요?';

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
      '켜면 다른 도시에서 지금 접속 중인 모든 사람이 내 레이더에 투영되고, 그들 모두 나를 볼 수 있습니다.\n\n위치는 도시 크기에 맞춰 투영되고 약 500m로 흐려져서, 누구도 실제 위치나 거리를 알 수 없습니다. 빛 보내기, 노크, 채팅도 할 수 있고 언제든 끌 수 있습니다.';

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
}
