// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Happy';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodAngry => 'Angry';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodPassion => 'Fired up';

  @override
  String get moodLove => 'Love';

  @override
  String get moodOther => 'Other';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name has ended';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'You handed $emoji $name over and are now a participant.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'You handed the gathering over. Your name is already 10 characters, so add $emoji to it yourself to keep getting announcements.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'You handed the gathering over. We added $emoji to your name, so you are now a participant.';
  }

  @override
  String get releaseNotesTitle => 'Mood Whisper 1.1 internal test';

  @override
  String get releaseNotesLead => 'The city has put on its night colours.';

  @override
  String get releaseNotesMap =>
      'A new night map: deep-blue blocks, glowing roads, neon buildings';

  @override
  String get releaseNotesBubbles =>
      'Mood bubbles are now dark glass, easy to read anywhere';

  @override
  String get releaseNotesResting =>
      'Resting and fading echoes: people can knock even when your screen is locked';

  @override
  String get releaseNotesSafety => 'Report and block keep the city safe';

  @override
  String get gotIt => 'Got it';

  @override
  String get blockedToast => 'This person has faded into the dark.';

  @override
  String get unblockedToast => 'Unblocked. Your paths can cross again.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Turn on Location Services';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper needs to know which corner of the city you are in so people nearby can see your mood. Turn on Location Services in your phone\'s Settings.';

  @override
  String get locationReducedTitle => 'Turn on Precise Location';

  @override
  String get locationReducedBodyIos =>
      'You are only sharing an approximate location, so the radar cannot tell who is near you. Go to Settings › Mood Whisper › Location and turn on Precise Location.';

  @override
  String get locationReducedBodyAndroid =>
      'You are only sharing an approximate location, so the radar cannot tell who is near you. Choose Precise in the location permission.';

  @override
  String get locationNoFixTitle => 'Can\'t find your location yet';

  @override
  String get locationNoFixBody =>
      'You may be indoors or the signal is weak. Move near a window or outside, turn on Wi-Fi, and try again.';

  @override
  String get locationNeededTitle => 'Mood Whisper needs your location';

  @override
  String get locationNeededBody =>
      'Mood Whisper only uses your location while you are using the app, to show moods within 5 km. The radar shows rough distances, never addresses.\nIn Settings, allow location While Using the App and turn on Precise Location.';

  @override
  String get locationSimulatorHint =>
      '(Developer note: in the Simulator, pick a location under Features › Location)';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get locationRecheck => 'I turned it on, check again';

  @override
  String get tryAgain => 'Try again';

  @override
  String get leaveApp => 'Leave';

  @override
  String whispersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'There are $count whispers near you. Tap an envelope to read one.',
      one: 'There is 1 whisper near you. Tap the envelope to read it.',
    );
    return '$_temp0';
  }

  @override
  String get whisperPassed =>
      'You passed a whisper. Tap the envelope to read it.';

  @override
  String get whisperLeft => 'Your whisper is here now. It fades in 7 days.';

  @override
  String get timeWhisperSealedYear =>
      'Sealed. Come back here in a year to open it.';

  @override
  String get timeWhisperSealedMonth =>
      'Sealed. Come back here in a month to open it.';

  @override
  String get whisperWithdrawn => 'Your whisper has been taken back.';

  @override
  String get whisperMineLabel => 'A whisper you left';

  @override
  String get whisperTapToRead => 'A whisper. Tap to read';

  @override
  String get noMoodYet => 'Lost for words…';

  @override
  String get knockWithdrawnByLeaving =>
      'They slipped back into the city and quietly took back their knock…';

  @override
  String get knockCardTitle => 'A moment\'s crossing';

  @override
  String knockCardBody(String name) {
    return '$name is knocking,\nhoping your paths will cross…';
  }

  @override
  String get skip => 'Skip';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get reportThisPerson => 'Report this person';

  @override
  String get cityQuietTonight => 'The city is quiet tonight';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'Tonight\'s city · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. View the city\'s mood weather';
  }

  @override
  String get cityMoodTitle => 'The city\'s mood tonight';

  @override
  String cityMoodQuietCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other:
          'The city is still quiet. $total people have shared a mood tonight.',
      one: 'The city is still quiet. 1 person has shared a mood tonight.',
    );
    return '$_temp0';
  }

  @override
  String cityMoodCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total people within 20 km have shared a mood tonight',
      one: '1 person within 20 km has shared a mood tonight',
    );
    return '$_temp0';
  }

  @override
  String get cityMoodQuietInvite =>
      'Every mood adds a little light. Write how you feel right now and help light up the city.';

  @override
  String get cityMoodFootnote =>
      'Anonymous moods from the last 24 hours. Shares are hidden when fewer than 10 people took part.';

  @override
  String get close => 'Close';

  @override
  String get emptyRadarTitle => 'You are tonight\'s first light';

  @override
  String get emptyRadarBody =>
      'No one is nearby yet. Your mood is already glowing in the city,\nand anyone who passes will see it. You can also leave a whisper for the next person who comes by.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '$total people are in the city tonight, and most feel “$mood”';
  }

  @override
  String get inviteFriends => 'Invite friends to light up your block';

  @override
  String get shareMoodCard => 'Share my mood card';

  @override
  String get editYourMood => 'Edit your mood';

  @override
  String resonanceTonight(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count glimmers resonated with you tonight',
      one: '1 glimmer resonated with you tonight',
    );
    return '$_temp0';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · your mood';
  }

  @override
  String get dockTapToEdit => 'Your mood · tap to edit';

  @override
  String get leaveWhisper => 'Leave a whisper';

  @override
  String get settings => 'Settings';

  @override
  String get nightlyReminder => 'Nightly reminder';

  @override
  String get nightlyReminderSubtitle =>
      'A gentle reminder at 21:30 every night';

  @override
  String get closeSettings => 'Close settings';

  @override
  String get settingsSectionMe => 'Me';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileSubtitle => 'Photo, city name and mood';

  @override
  String get manageBlockList => 'Blocked people';

  @override
  String get manageBlockListSubtitle =>
      'See or unblock the people you sent into the dark';

  @override
  String get myTimeWhispers => 'My letters to the future';

  @override
  String get myTimeWhispersSubtitle =>
      'Notes to your future self that only you can see';

  @override
  String get myMoodTrail => 'My mood trail';

  @override
  String get myMoodTrailSubtitle => 'Stored only on your phone';

  @override
  String get settingsSectionGatherings => 'Gatherings';

  @override
  String get gatheringHost => 'Host a gathering';

  @override
  String get gatheringHostSubtitle =>
      'Start an event for everyone within 5 km of you';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'You are hosting $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Share';

  @override
  String get shareMoodCardSubtitle =>
      'One of eleven night illustrations at random, made for Instagram Stories';

  @override
  String get inviteFriendsSubtitle =>
      'The more people nearby, the brighter the city';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get guide => 'How to use';

  @override
  String get guideSubtitle =>
      'Everything from writing a mood to hosting a gathering';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get contactUs => 'Contact us';

  @override
  String get deleteAccount => 'Delete account and data';

  @override
  String get deleteAccountSubtitle =>
      'Permanently erase everything you left in the city';

  @override
  String get avatarUploadFailed =>
      'Your photo didn\'t upload. Please try again later.';

  @override
  String get moodEmpty =>
      'Your mood can\'t be empty. Leave the city a little light.';

  @override
  String get profileSyncFailed =>
      'Couldn\'t update your status. Please try again later.';

  @override
  String get profileUpdated => 'Updated. The city can feel you breathing.';

  @override
  String get changeAvatar => 'Change photo';

  @override
  String get avatarHint =>
      'Tap to change your photo · the ring is your mood colour';

  @override
  String get cityName => 'City name';

  @override
  String get cityNameHint => 'Optional, e.g. Wandering Cat';

  @override
  String get currentMood => 'Your mood right now';

  @override
  String get currentMoodHint => 'e.g. Walking in a light rain 🌿';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get blockListTitle => 'Sent into the dark';

  @override
  String get blockListEmpty =>
      'The night is clear. You haven\'t sent anyone away.';

  @override
  String get unblock => 'Unblock';

  @override
  String get deleteAccountBody =>
      'Your location, mood, city name, photo, whispers, glimmers, blocked list and open chats will be permanently deleted. This can\'t be undone.\n\nTo prevent abuse, report records are kept for 1 year as described in the Privacy Policy.';

  @override
  String get deleting => 'Deleting…';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deleteFailed =>
      'Deletion didn\'t finish. Check your connection and try again.';

  @override
  String get fadingEcho => 'Fading echo';

  @override
  String clusterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moods here',
      one: '1 mood here',
    );
    return '$_temp0';
  }

  @override
  String clusterMore(int count) {
    return 'More\n+$count';
  }

  @override
  String get clusterBackToFirst => 'Back to\nstart';

  @override
  String get fadingEchoTitle => 'A fading echo';

  @override
  String encounterWith(String name) {
    return 'Crossing paths with $name';
  }

  @override
  String get fadingEchoBody =>
      'This is only a fading echo. You can\'t cross paths with it.';

  @override
  String get demoPersonBody =>
      'This is a demo person who replies automatically. It isn\'t a real person. Use it to try knocking, chatting, glimmers, reporting and blocking.';

  @override
  String get sendGlimmer => 'Send a glimmer';

  @override
  String get knock => 'Knock';

  @override
  String get blockAction => 'Block';

  @override
  String get handOverHost => 'Hand over hosting';

  @override
  String get report => 'Report';

  @override
  String get confirmBlockTitle => 'Block this person?';

  @override
  String confirmBlockBody(String name) {
    return 'Send $name into the dark?\nOnce blocked, you disappear from each other\'s city.';
  }

  @override
  String get confirmBlock => 'Block';

  @override
  String get glimmerReceived =>
      'Someone sent you a glimmer. Your mood resonated with them.';

  @override
  String get glimmerSent => 'You sent a glimmer.';

  @override
  String get glimmerAlreadySent =>
      'You already sent them a glimmer today. Try again tomorrow.';

  @override
  String get knockSent => 'Knock sent. Waiting for an answer…';

  @override
  String get knockFailed =>
      'Your knock didn\'t go through. Please try again later.';

  @override
  String get knockNoAnswer => 'No answer. Your knock quietly faded.';

  @override
  String get knockDeclined =>
      'Your paths didn\'t cross this time. Let\'s give each other some space.';

  @override
  String get knockSkipped =>
      'They passed for now, and your knock quietly faded.';

  @override
  String get sensingCity => 'Sensing the city…';

  @override
  String get gatheringUnavailable =>
      'Gatherings aren\'t available right now. Please try again later.';

  @override
  String get notSentCheckNetwork =>
      'That didn\'t send. Check your connection and try again.';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get nextDayPrefix => 'next day ';

  @override
  String get gatheringNameMissing => 'Please give your gathering a name.';

  @override
  String get gatheringEmojiInvalid =>
      'The gathering icon must be exactly one emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name has started. Ask people to add $emoji to their city name to join.';
  }

  @override
  String get startGatheringTitle => 'Start a gathering';

  @override
  String get startGatheringLead =>
      'Everyone within 5 km of you. The area moves with you.';

  @override
  String get gatheringNameHint =>
      'Gathering name, e.g. Taipei 101 New Year Fireworks';

  @override
  String get gatheringEmojiHint => 'Icon';

  @override
  String get gatheringEmojiHelp =>
      'The gathering icon is one emoji that nobody nearby is already using.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'People who add $emoji to their city name will see your announcements and get notifications.';
  }

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get gatheringMaxDuration =>
      'A gathering lasts up to 24 hours and ends automatically.';

  @override
  String get starting => 'Starting…';

  @override
  String get startGathering => 'Start gathering';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name has ended. You\'re back in the city.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · You\'re hosting';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'People within 5 km with $emoji in their name see your announcements and get notified. You can\'t see who they are.';
  }

  @override
  String get postAnnouncement => 'Post announcement';

  @override
  String get announcementHint =>
      'e.g. We\'re meeting at the corner of Zhongxiao East Road';

  @override
  String get announcementSent => 'Announcement sent';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (hidden after many reports)';

  @override
  String get groupQuestion => 'Ask everyone';

  @override
  String get questionHint => 'e.g. How are you right now?';

  @override
  String get sendQuestion => 'Ask';

  @override
  String get questionSent => 'Question sent. Everyone will answer with a mood';

  @override
  String get handOff => 'Hand over';

  @override
  String handoffPending(String name) {
    return 'Invited $name to take over hosting. Waiting for a reply…';
  }

  @override
  String get theOtherPerson => 'them';

  @override
  String get handoffCancelled => 'Hand-over invitation cancelled';

  @override
  String get handoffHelp =>
      'Long-press a participant\'s bubble on the radar → Hand over hosting. Once they accept, they host and the gathering carries on uninterrupted.';

  @override
  String get confirmEndAgain => 'End it? Tap again';

  @override
  String get endGathering => 'End gathering';

  @override
  String tallyHeader(String question, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total answers',
      one: '1 answer',
    );
    return '“$question” · $_temp0';
  }

  @override
  String get tallyQuiet =>
      'Shares appear after 10 answers, so no one can be guessed when few people answer.';

  @override
  String get bannerYouHost => '  · You\'re hosting';

  @override
  String get bannerHostAnnouncement => '  · From the host';

  @override
  String get manageGathering => 'Manage gathering';

  @override
  String get reportAnnouncement => 'Report this announcement';

  @override
  String get expandAnnouncement => 'Show announcement';

  @override
  String get collapseAnnouncement => 'Hide announcement';

  @override
  String hostHandedOffAgo(String ago) {
    return 'New host · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'You reported this announcement, so it\'s been removed from your screen.';

  @override
  String get noAnnouncementHost =>
      'No announcements yet. Tap the sliders at the top right to post the first one.';

  @override
  String get noAnnouncementGuest => 'The host hasn\'t posted anything yet.';

  @override
  String hostAsks(String question) {
    return 'The host asks: $question';
  }

  @override
  String get answeredNote =>
      'Answered. The host only sees the overall mood shares.';

  @override
  String get answerHint => 'Answer with a mood';

  @override
  String get sendAnswer => 'Send answer';

  @override
  String handoffInvited(String name) {
    return 'Invited $name to take over hosting. Waiting for a reply (valid for 5 minutes).';
  }

  @override
  String handoffTitle(String name) {
    return 'Hand the gathering to $name';
  }

  @override
  String get handoffBody =>
      'Once they accept, they host the gathering. The name, announcements and question stay, and you become a participant.';

  @override
  String get handoffPublic => 'Announce the hand-over';

  @override
  String get handoffPublicHelp => 'Tell all participants there\'s a new host';

  @override
  String get handoffQuiet => 'Quiet hand-over';

  @override
  String get handoffQuietHelp =>
      'No one is notified. Only the host ring on the radar moves';

  @override
  String get sending => 'Sending…';

  @override
  String get sendInvite => 'Send invitation';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'You\'re now hosting $emoji $name.';
  }

  @override
  String get handoffOfferTitle => 'Would you take over hosting?';

  @override
  String handoffOfferBody(String name) {
    return 'The host would like to hand “$name” to you. As host you can post announcements, ask questions and end the gathering, and you\'re responsible for what you post.';
  }

  @override
  String get processing => 'Working…';

  @override
  String get acceptHosting => 'Take over';

  @override
  String get guideS1Title => '1. Enter the city';

  @override
  String get guideS1L1 =>
      'The first time you open the app, confirm you are 18 or older and allow precise location while using the app. Without precise location the radar can\'t work.';

  @override
  String get guideS1L2 =>
      'Write one sentence about how you feel right now (up to 20 characters), agree to the Terms of Use and Privacy Policy, and tap Enter Mood Whisper.';

  @override
  String get guideS1L3 =>
      'No phone number, email or real name is needed. Your account is anonymous and tied to this phone.';

  @override
  String get guideS1L4 =>
      'Words in your mood set its colour: “happy, laugh” is gold, “sad, cry” is blue, “angry” is orange-red, “calm, daydream” is green, “fired up” is orange, “love, heart” is pink, and anything else is soft violet.';

  @override
  String get guideS2Title => '2. The bottom bar';

  @override
  String get guideS2L1 =>
      'Tap your own photo on the left to edit your photo, city name (up to 10 characters) and mood.';

  @override
  String get guideS2L2 => 'Notepad icon: leave a whisper right here.';

  @override
  String get guideS2L3 => 'Share icon: turn your mood into a night-scene card.';

  @override
  String get guideS2L4 => 'Sliders icon on the far right: open Settings.';

  @override
  String get guideS3Title => '3. Radar and bubbles';

  @override
  String get guideS3L1 =>
      'Mood bubbles from people within 5 km appear on the radar. Only a rough distance band is shown (such as “within 100 m”), never an address.';

  @override
  String get guideS3L2 =>
      'A breathing bubble means the person is using the app. A dimmed bubble marked Resting means their screen is locked, and you can still knock. A grey bubble with no name is a fading echo left by someone who just left, and it slowly fades away.';

  @override
  String get guideS3L3 =>
      'Pinch to zoom the map. Turn your phone and the radar turns with you.';

  @override
  String get guideS3L4 =>
      'When bubbles crowd together they merge into a glowing orb, “N moods here”. Tap it to fan them out in a ring so each one can be tapped; tap the middle or empty space to close it.';

  @override
  String get guideS3L5 =>
      'Names starting with Demo belong to demo people who reply automatically. They aren\'t real, and you can use them to try every feature.';

  @override
  String get guideS3L6 =>
      'When no one is nearby, “You are tonight\'s first light” appears at the bottom, and you can invite friends to light up your block.';

  @override
  String get guideS4Title => '4. Knocking and chatting';

  @override
  String get guideS4L1 =>
      'Long-press someone\'s bubble → Knock. They have 5 minutes to accept, decline or skip. While you wait, a line of light flows from you to them.';

  @override
  String get guideS4L2 =>
      'Once they accept, a chat starts with a 10-minute countdown. Any new message restarts it, and the chat ends when you both go quiet.';

  @override
  String get guideS4L3 =>
      'When the chat ends, the messages are deleted from the server. The other person could still take screenshots, so share with care.';

  @override
  String get guideS4L4 =>
      'When someone knocks on your door, a knock card appears. You can accept, decline, skip or report right away.';

  @override
  String get guideS5Title => '5. Glimmers';

  @override
  String get guideS5L1 =>
      'Double-tap someone\'s bubble, or long-press and choose Send a glimmer, to let them know someone noticed without saying a word.';

  @override
  String get guideS5L2 =>
      'They only see “N glimmers resonated with you tonight” and never who sent them. You can send the same person one glimmer every 24 hours.';

  @override
  String get guideS6Title => '6. Whispers';

  @override
  String get guideS6L1 =>
      'Tap the notepad icon in the bottom bar to leave a sentence where you are (up to 60 characters).';

  @override
  String get guideS6L2 =>
      'For the next 7 days, anyone within 300 m will see an envelope on the radar and can open it to read.';

  @override
  String get guideS6L3 =>
      'Whispers are always anonymous. You can have up to 3 at a time, leave at most 1 every 10 minutes, and take them back at any time.';

  @override
  String get guideS6L4 =>
      'Letters to the future: when writing a whisper, choose To my future self, then one month or one year. Only you can see it. When the time comes you\'ll be notified, and it opens on its own when you\'re back within 100 m. It can be read only once. Only you see a small hourglass on the radar (locked or unlocked), and it can\'t be tapped. You can have up to 5 at a time; see or delete them in Settings → My letters to the future.';

  @override
  String get guideS7Title => '7. City mood weather';

  @override
  String get guideS7L1 =>
      'The label at the top left shows the most common mood within 20 km over the last 24 hours. Tap it for the full breakdown.';

  @override
  String get guideS7L2 =>
      'Shares are hidden when fewer than 10 people took part, so no one can be identified.';

  @override
  String get guideS8Title => '8. Gatherings';

  @override
  String get guideS8L1 =>
      'To start one: Settings → Host a gathering → enter a name, one emoji as its icon, and a start and end time (up to 24 hours) → Start gathering.';

  @override
  String get guideS8L2 =>
      'The gathering covers 5 km around the host and moves with them. The host has a ring of light and a Host label on the radar.';

  @override
  String get guideS8L3 =>
      'The host can post announcements (as many as needed), ask everyone a question, and end the gathering at any time.';

  @override
  String get guideS8L4 =>
      'To join, add the gathering\'s icon to your city name (for example “Wandering Cat🌈”). While you\'re in range you\'ll see the pinned announcement above the radar and get notifications. Remove the icon to leave.';

  @override
  String get guideS8L5 =>
      'Group question: answer with a mood. The host only sees the overall mood shares, never who answered what, and shares are hidden below 10 answers.';

  @override
  String get guideS8L6 =>
      'Only one gathering can use an icon in the same area at a time. Once it ends, anyone can use that icon.';

  @override
  String get guideS8L7 =>
      'Hand-over: the host long-presses a participant\'s bubble → Hand over hosting, and chooses an announced or quiet hand-over. If the person accepts within 5 minutes they become host, and announcements and the question stay. The previous host becomes a participant and the icon is added to their name.';

  @override
  String get guideS9Title => '9. City Beacon (accessible restrooms)';

  @override
  String get guideS9L1 =>
      'Tap the restroom icon at the bottom left of the map to turn on the beacon. Gender-friendly, accessible and family restrooms within 2 km appear on the radar, with a count next to the icon. Tap the three round filters above it to show only some kinds.';

  @override
  String get guideS9L2 =>
      'Tap a marker to see the floor, facilities and distance, and tap Walk there to get directions in your map app.';

  @override
  String get guideS9L3 =>
      'Data comes from Taiwan\'s Ministry of Environment public restroom records and is updated monthly. Opening hours aren\'t included; “Probably open at night” is our estimate based on the type of place.';

  @override
  String get guideS9L4 =>
      'If something is wrong you can report it (not gender-friendly, closed at night, can\'t find it). When 3 people report the same problem, the marker turns grey with a note.';

  @override
  String get guideS10Title => '10. Mood cards and mood trail';

  @override
  String get guideS10L1 =>
      'The share button in the bottom bar turns your current mood into a night-scene card, made for Instagram Stories. The card never shows your location.';

  @override
  String get guideS10L2 =>
      'Settings → My mood trail lets you look back at the moods and places you\'ve written. It\'s stored only on your phone, and you can turn it off or clear it at any time.';

  @override
  String get guideS11Title => '11. Settings and notifications';

  @override
  String get guideS11L1 =>
      'Nightly reminder: a gentle reminder at 21:30 every night. Turn it on or off in Settings.';

  @override
  String get guideS11L2 =>
      'Knocks, new messages, glimmers and gathering announcements arrive as notifications. You can turn them off in your phone\'s settings.';

  @override
  String get guideS11L3 =>
      'Every Friday from 21:00 to 23:00 is Light-up Night, when everyone comes online together and the city shines brightest.';

  @override
  String get guideS12Title => '12. Reporting and blocking';

  @override
  String get guideS12L1 =>
      'You can report from a bubble\'s long-press menu, a knock card, the top right of a chat, a whisper or a gathering announcement. Once you report, that person or post disappears from your screen right away and the chat ends. We handle every report within 24 hours.';

  @override
  String get guideS12L2 =>
      'Moods, names, whispers, chat messages and gathering announcements are automatically filtered for offensive words and contact details such as phone numbers and links.';

  @override
  String get guideS12L3 =>
      'Once you block someone, you disappear from each other\'s radar and can\'t knock or send glimmers. Unblock them in Settings → Blocked people.';

  @override
  String get guideS12L4 =>
      'If you\'re in immediate danger, call your local emergency number (110 in Taiwan).';

  @override
  String get guideS13Title => '13. Privacy and your account';

  @override
  String get guideS13L1 =>
      'People nearby can see your mood, city name, photo and rough distance. Your location is only used while you\'re using the app.';

  @override
  String get guideS13L2 =>
      'Settings → Delete account and data permanently erases everything you left in the city, at any time.';

  @override
  String get guideS13L3 =>
      'Questions? Go to Settings → Contact us, or email service.softchip@gmail.com.';

  @override
  String get guideIntro =>
      'Mood Whisper is a city at night: write one sentence about how you feel right now, and see how the people near you feel.';

  @override
  String get beaconGender => 'Gender-friendly';

  @override
  String get beaconAccessible => 'Accessible';

  @override
  String get beaconFamily => 'Family';

  @override
  String get beaconReportNotGender => 'Not gender-friendly';

  @override
  String get beaconReportClosed => 'Closed at night';

  @override
  String get beaconReportMissing => 'Can\'t find this restroom';

  @override
  String get beaconFlagNotGender => 'Reported: not gender-friendly';

  @override
  String get beaconFlagClosed => 'Reported: closed at night';

  @override
  String get beaconFlagMissing => 'Reported: can\'t find it';

  @override
  String get beaconDefaultName => 'Public restroom';

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
      'City Beacon isn\'t available right now. Please try again later.';

  @override
  String get notConnectedCheckNetwork =>
      'Couldn\'t connect. Check your connection and try again.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$features restroom, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Turn off City Beacon (accessible restrooms), $count nearby';
  }

  @override
  String get beaconToggleOn => 'Turn on City Beacon (accessible restrooms)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Show only $feature';
  }

  @override
  String get beaconMaybeOpenNight => 'Probably open at night (estimate)';

  @override
  String get beaconMaybeDaytime => 'Probably daytime only (estimate)';

  @override
  String get walkThere => 'Walk there';

  @override
  String get beaconWrongData => 'Something wrong?';

  @override
  String beaconThanks(String reason) {
    return 'Thanks. We got your report: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Source: Taiwan Ministry of Environment public restroom records, updated monthly. Opening hours are our estimate based on the type of place.';

  @override
  String get invite1 =>
      'I lit a light on Mood Whisper. The more people nearby, the brighter our block gets. Come light it up with me:';

  @override
  String get invite2 =>
      'The city is a little quiet tonight. Write a mood on Mood Whisper and help our block light up:';

  @override
  String get invite3 =>
      'No friend requests, no real names, just one line about how you feel. Find me on Mood Whisper:';

  @override
  String get invite4 =>
      'I left a light on for you on Mood Whisper. Open the app and see what people nearby are feeling tonight:';

  @override
  String get invite5 =>
      'Every Friday at 9 pm is Light-up Night on Mood Whisper. Come online with me and let\'s fill the radar with light:';

  @override
  String get invite6 =>
      'Need somewhere to say how today went? Mood Whisper is anonymous, and your words fade once they\'re said:';

  @override
  String get invite7 =>
      'Ever wonder what the people you pass on the street are feeling? See for yourself on Mood Whisper:';

  @override
  String get invite8 =>
      'I left a whisper on this street that only passers-by can read. Come leave one too:';

  @override
  String get invite9 =>
      'Mood Whisper is a map of the city\'s moods at night. It\'s more fun with more people, so come add a light to our block:';

  @override
  String get invite10 =>
      'What colour is your mood tonight? Write it on Mood Whisper. I\'ll be nearby, watching for your light:';

  @override
  String get shareInvite => 'Share invite';

  @override
  String get inviteSubject => 'Come light up our block with me';

  @override
  String get shareMoodCardButton => 'Share card';

  @override
  String moodShareText(String mood) {
    return 'I shared how I feel right now on Mood Whisper: “$mood”\nIs your mood glowing in the city tonight too?';
  }

  @override
  String get shareFailed => 'That didn\'t share. Please try again.';

  @override
  String shuffleCard(int current, int total) {
    return 'Shuffle · $current / $total';
  }

  @override
  String get preparing => 'Preparing…';

  @override
  String get sendLinkToFriends => 'Send a link to friends (LINE, Messenger)';

  @override
  String get partLateNight => 'Late night';

  @override
  String get partMorning => 'Morning';

  @override
  String get partAfternoon => 'Afternoon';

  @override
  String get partDusk => 'Dusk';

  @override
  String get partNight => 'Night';

  @override
  String get cardInviteEyebrow => 'An invitation';

  @override
  String get cardMoodEyebrow => 'How I feel right now';

  @override
  String get cardInviteTitle => 'Come light up\nour block';

  @override
  String get cardInviteBody =>
      'I lit a light on Mood Whisper.\nThe more people nearby, the brighter our block.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nSomewhere in the city';
  }

  @override
  String get whisperUnavailable =>
      'Whispers aren\'t available right now. Please try again later.';

  @override
  String get whisperNotSent =>
      'Your whisper didn\'t send. Check your connection and try again.';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get timeWhisperTitle => 'Letter to the future';

  @override
  String get timeWhisperLead =>
      'Write to your future self. When the time comes, come back here to open it.';

  @override
  String get whisperLead => 'Write to the next person who passes by.';

  @override
  String get toPassersBy => 'To passers-by';

  @override
  String get toFutureSelf => 'To my future self';

  @override
  String get inOneMonth => 'In a month';

  @override
  String get inOneYear => 'In a year';

  @override
  String get timeWhisperHint =>
      'e.g. See you here next year. I hope you\'re doing better than now.';

  @override
  String get whisperHint =>
      'e.g. The sunset here is beautiful. Remember to look up.';

  @override
  String get timeWhisperCaptionYear =>
      'Only you can see it · unseals in a year and lets you know · opens within 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Only you can see it · unseals in a month and lets you know · opens within 100 m';

  @override
  String get whisperCaption =>
      'Fades in 7 days · never shows who you are · only that you were around here';

  @override
  String get sealHere => 'Seal it here';

  @override
  String get leaveHere => 'Leave it here';

  @override
  String get aWhisper => 'A whisper';

  @override
  String whisperLeftAgo(String ago) {
    return 'Left around here $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Read by $count people',
      one: 'Read by 1 person',
    );
    return '$_temp0';
  }

  @override
  String get whisperNobodyYet => 'No one has passed by yet';

  @override
  String get withdrawWhisper => 'Take this whisper back';

  @override
  String get whisperCollected => 'You picked up this whisper.';

  @override
  String whisperReadersBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people passed by before you.',
      one: '1 person passed by before you.',
    );
    return '$_temp0';
  }

  @override
  String get whisperFirstReader => 'You\'re the first to pass by.';

  @override
  String get reportWhisper => 'Report this whisper';

  @override
  String get thisWhisper => 'This whisper';

  @override
  String get chatTimeUp => 'Time\'s up. The moment fades...';

  @override
  String get chatOtherLeft => 'They\'ve slipped back into the city...';

  @override
  String get chatEnded => 'This moment has ended...';

  @override
  String get chatBlockedEnded => 'Blocked. The conversation has ended.';

  @override
  String get chatReportedEnded => 'Reported. The conversation has ended.';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get leaveChat => 'Leave conversation';

  @override
  String chatWith(String name) {
    return 'A moment with $name';
  }

  @override
  String get countdownPrefix => 'Fades in ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Demo conversation: the replies are automatic, not from a real person.';

  @override
  String get typing => 'Typing…';

  @override
  String get chatHint => 'Say something softly…';

  @override
  String get send => 'Send';

  @override
  String get chatDissolvedApart => 'You\'ve each gone back into the city';

  @override
  String get knockTooOften =>
      'You\'re knocking too often. Take a breath with the city...';

  @override
  String get otherNotNow =>
      'They\'d rather not be disturbed right now. Give each other some space.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'They\'d rather not be disturbed right now. Give each other some space ($minutes min).';
  }

  @override
  String get justEndedRest =>
      'You two only just said goodbye. Let the memory settle for a while.';

  @override
  String get intro1Title => 'Slip into the city';

  @override
  String get intro1Body =>
      'Leave the social labels behind. On a quiet dark canvas, all that remains is how you truly feel, and where.';

  @override
  String get intro2Title => 'A passing moment';

  @override
  String get intro2Body =>
      'See a mood bubble floating nearby? Knock gently and share a once-in-a-lifetime conversation with someone passing by.';

  @override
  String get intro3Title => 'The city\'s rhythm';

  @override
  String get intro3Body =>
      'We care how you feel. After you knock, wait quietly for an answer. If it isn\'t meant to be, the bubble fades away after 300 seconds.';

  @override
  String get intro4Title => 'A gentle distance';

  @override
  String get intro4Body =>
      'Don\'t want to be disturbed? Decline or block. A cool-down system keeps the noise away and gives you back your quiet corner.';

  @override
  String get intro5Title => 'Ready to meet?';

  @override
  String get intro5Body =>
      'Close your eyes and feel your phone\'s pulse and your heartbeat. Now write how you feel and step into Mood Whisper.';

  @override
  String get loadingImage => 'Loading image...';

  @override
  String get startExploring => 'Start exploring';

  @override
  String get nextPage => 'Next';

  @override
  String get feedbackSubject => 'Mood Whisper feedback';

  @override
  String get loginNeedMood =>
      'Write how you feel right now, then step into the city.';

  @override
  String get loginNeedAgree =>
      'Please read and agree to the Terms of Use and Privacy Policy first.';

  @override
  String get loginCantConnect =>
      'Couldn\'t reach the city. Check your connection and try again.';

  @override
  String get ageQuestion => 'Are you 18 or older?';

  @override
  String get ageReason =>
      'Mood Whisper connects you with strangers nearby, so it\'s for people 18 and over only.';

  @override
  String get ageUnder => 'I\'m under 18';

  @override
  String get ageOver => 'I\'m 18 or older';

  @override
  String get loginTitle1 => 'Ready';

  @override
  String get loginTitle2 => 'to meet?';

  @override
  String get loginLead =>
      'Close your eyes and feel your phone\'s pulse and your heartbeat.\nNow write how you feel and step into Mood Whisper.';

  @override
  String get loginPrompt => 'What do you want to tell the city right now?';

  @override
  String get loginHint => 'e.g. Had a really good coffee😊';

  @override
  String get enterCity => 'Enter Mood Whisper';

  @override
  String get agreeSemantic =>
      'I have read and agree to the Terms of Use and Privacy Policy';

  @override
  String get agreePrefix => 'I have read and agree to the ';

  @override
  String get termsLink => 'Terms of Use';

  @override
  String get agreeAnd => ' and ';

  @override
  String get privacyLink => 'Privacy Policy';

  @override
  String get agreeSuffix =>
      '. Mood Whisper has zero tolerance for harassment, sexual content, hate or other abuse. Anyone who breaks this rule will be removed.';

  @override
  String get under18Title => 'Mood Whisper is for people 18 and over';

  @override
  String get under18Body =>
      'Thank you for being honest. This city connects you with strangers. See you when you turn 18.';

  @override
  String get clearMoodTrail => 'Clear mood trail';

  @override
  String get clearMoodTrailBody =>
      'Every mood trail on this phone will be deleted. This can\'t be undone.';

  @override
  String get clear => 'Clear';

  @override
  String monthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get moodTrailLocalOnly =>
      'Stored only on your phone. Never uploaded anywhere.';

  @override
  String get moodTrailEmpty =>
      'No mood trail this week yet. Each time you write a mood or go somewhere new, another light appears here.';

  @override
  String get thisWeekYou => 'Your week';

  @override
  String get topMoodPrefix => 'You most often felt “';

  @override
  String topMoodSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '”, $count times',
      one: '”, once',
    );
    return '$_temp0';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$total moods left in $places different places';
  }

  @override
  String get recordMoodTrail => 'Record my mood trail';

  @override
  String get recordMoodTrailOff => 'When off, no new trail is recorded';

  @override
  String get nightly1 => 'What\'s on the city\'s mind tonight?';

  @override
  String get nightly2 =>
      'Someone nearby is writing down how they feel right now.';

  @override
  String get nightly3 => 'The night is just right. Leave a line for the city.';

  @override
  String get nightly4 => 'How was today? Your mood will glow in the city.';

  @override
  String get nightly5 =>
      'The streetlights are on, and people nearby are still awake.';

  @override
  String get nightly6 => 'Give today an ending: how do you feel right now?';

  @override
  String get nightly7 => 'Who will you pass by tonight?';

  @override
  String get nightlyChannel => 'Nightly reminder';

  @override
  String get nightlyChannelDesc =>
      'A gentle reminder each night. You can turn it off in the app\'s settings.';

  @override
  String get reasonHarassment => 'Harassment or bullying';

  @override
  String get reasonSexual => 'Sexual content';

  @override
  String get reasonScam => 'Scam or spam';

  @override
  String get reasonHate => 'Hate or violence';

  @override
  String get reasonImpersonation => 'Impersonation';

  @override
  String get reasonOther => 'Something else';

  @override
  String get reportReceived =>
      'Report received and removed from your screen. We\'ll review it within 24 hours.';

  @override
  String get reportNotSent =>
      'Your report didn\'t send. Check your connection and try again.';

  @override
  String reportTarget(String target) {
    return 'Report $target';
  }

  @override
  String get reportPrivate =>
      'They won\'t know you reported them. Choose a reason:';

  @override
  String get reportDetails => 'More details (optional)';

  @override
  String get reportWhatHappened => 'What happened?';

  @override
  String get sendReport => 'Send report';

  @override
  String get alsoBlock =>
      'Also block them. You\'ll disappear from each other\'s city.';

  @override
  String get aYearAgo => 'A year ago';

  @override
  String get aMonthAgo => 'A month ago';

  @override
  String get timeWhisperUnavailable =>
      'Letters to the future aren\'t available right now. Please try again later.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, you said here';
  }

  @override
  String writtenOn(String date) {
    return 'Written $date';
  }

  @override
  String get timeWhisperOnce => 'This letter appears only once.';

  @override
  String get keepInHeart => 'Keep it in my heart';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Unseals $unlock · written $created';
  }

  @override
  String get unsealedGoBack => 'Unsealed. Go back there to open it.';

  @override
  String unsealedDistance(String distance) {
    return 'Unsealed · $distance away';
  }

  @override
  String get timeWhisperListLead =>
      'Letters to your future self that only you can see. When the time comes, get within 100 m of the spot to open one. Once read, it disappears.';

  @override
  String get timeWhisperListEmpty =>
      'No letters to the future yet. Tap the note icon in the bottom bar and choose “To my future self”.';

  @override
  String get readyToOpen => 'Ready to open';

  @override
  String get sealed => 'Sealed';

  @override
  String get delete => 'Delete';

  @override
  String get within100m => 'Within 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Waiting for $name to answer, $mm:$ss left';
  }

  @override
  String knockWaiting(String name) {
    return 'Waiting for $name';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Same as phone';

  @override
  String get parallelUniverse => 'Parallel Universe';

  @override
  String get parallelUniverseSubtitle =>
      'See how other cities feel right now, and let them see you';

  @override
  String get parallelUniverseIntroTitle => 'Enter the Parallel Universe';

  @override
  String get parallelUniverseIntroBody =>
      'When it\'s on, everyone with the app open in your matched cities appears on your radar, and they can all see you. Cities in Taiwan are matched with cities abroad (such as Tokyo, Seoul and Kuala Lumpur), and cities abroad are matched with Taiwan.\n\nThe two cities line up at their central stations: however far and in whichever direction you are from your station, that\'s where you appear in theirs, blurred to about 500 m, so no one can see your real location or distance. You can still send glimmers, knock and chat, and turn it off at any time. Fading echoes, whispers and gatherings stay local.';

  @override
  String get parallelUniverseEnter => 'Enter';

  @override
  String get parallelUniverseNoCity =>
      'There\'s no Parallel Universe where you are yet';

  @override
  String parallelFrom(String city) {
    return 'Parallel · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'This person is in $city, not near you. Their position is projected and doesn\'t show a real distance.';
  }

  @override
  String get labelHost => 'Host';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelResting => 'Resting';

  @override
  String get cityTaipei => 'Taipei';

  @override
  String get cityTaichung => 'Taichung';

  @override
  String get cityKaohsiung => 'Kaohsiung';

  @override
  String get cityTokyo => 'Tokyo';

  @override
  String get cityOsaka => 'Osaka';

  @override
  String get citySeoul => 'Seoul';

  @override
  String get cityBusan => 'Busan';

  @override
  String get cityHongkong => 'Hong Kong';

  @override
  String get cityMacau => 'Macau';

  @override
  String get citySingapore => 'Singapore';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityHochiminh => 'Ho Chi Minh City';

  @override
  String get cityHanoi => 'Hanoi';

  @override
  String get translateTap => 'Tap to translate';

  @override
  String get translateShowOriginal => 'Translated · tap for original';

  @override
  String get translating => 'Translating…';

  @override
  String get translateFailed => 'Couldn\'t translate. Please try again later.';

  @override
  String get translateDownloadTitle => 'Download translation model';

  @override
  String get translateDownloadBody =>
      'Translating this language for the first time needs a translation model (about 30 MB per language, downloaded once).\n\nTranslation happens entirely on your phone; messages are never uploaded.';

  @override
  String get translateDownload => 'Download';
}
