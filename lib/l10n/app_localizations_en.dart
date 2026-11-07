// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get checkInEnter => 'Check in here and enter';

  @override
  String get checkInNote =>
      'Once you tap, people nearby will see your mood and roughly where you are. You check in yourself every time you enter.';

  @override
  String get checkInTitle => 'Check in to the city';

  @override
  String get checkInBody =>
      'Once you check in, people nearby can see your mood and roughly where you are, and you\'ll see them too. They see the place where you checked in; it doesn\'t follow you around. You check in yourself every time you open the app; it never happens automatically. Leaving or switching to another app ends your check-in.';

  @override
  String get checkInButton => 'Check in here';

  @override
  String get checkInAgain =>
      'You\'ve left where you checked in · Check in here';

  @override
  String get checkOutButton => 'Checked in · Check out';

  @override
  String get checkedOutToast => 'Checked out. You\'re no longer on the map.';

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
  String get sensingCityHint =>
      'If your city feels too quiet right now, step into Parallel Universe or Quantum World to meet people from other cities.';

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
      'Write one sentence about how you feel right now (up to 20 characters), agree to the Terms of Use and Privacy Policy, and tap Check in here and enter.';

  @override
  String get guideS1L3 =>
      'No phone number, email or real name is needed. Your account is anonymous and tied to this phone.';

  @override
  String get guideS1L4 =>
      'Words in your mood set its colour: “happy, laugh” is gold, “sad, cry” is blue, “angry” is orange-red, “calm, daydream” is green, “fired up” is orange, “love, heart” is pink, and anything else is soft violet.';

  @override
  String get guideS1L5 =>
      'Checking in: every time you open the app you check in yourself, and only then can people nearby see your mood and roughly where you are, and you see them. It never happens automatically. Others see the place where you checked in; it doesn\'t follow you around. If you move more than 1 km away, Check in here appears below the radar. If the app has been in the background for more than 30 minutes, you check in again when you come back.';

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
      'Only people who are checked in with the app open appear on the radar. When someone leaves or switches to another app, their bubble disappears right away and leaves no trace.';

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
      'The gathering covers 5 km around the place where the host checked in; when the host checks in again, it moves with them. The host has a ring of light and a Host label on the radar.';

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
  String get guideS10Title => '11. Mood cards and mood trail';

  @override
  String get guideS10L1 =>
      'The share button in the bottom bar turns your current mood into a night-scene card, made for Instagram Stories. The card never shows your location.';

  @override
  String get guideS10L2 =>
      'Settings → My mood trail lets you look back at the moods and places you\'ve written. It\'s stored only on your phone, and you can turn it off or clear it at any time.';

  @override
  String get guideS11Title => '17. Settings and notifications';

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
  String get guideS12Title => '18. Reporting and blocking';

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
  String get guideS13Title => '19. Privacy and your account';

  @override
  String get guideS13L1 =>
      'Only after you check in can people nearby see your mood, city name, photo and rough distance. They see the place where you checked in, not your live location.';

  @override
  String get guideS13L2 =>
      'Settings → Delete account and data permanently erases everything you left in the city, at any time.';

  @override
  String get guideS13L3 =>
      'Questions? Go to Settings → Contact us, or email service.softchip@gmail.com.';

  @override
  String get guideS14Title => '12. Parallel Universe';

  @override
  String get guideS14L1 =>
      'Tap the globe at the top right of the radar to turn it on, and again to turn it off. It\'s off every time you open the app.';

  @override
  String get guideS14L2 =>
      'Each city or county in Taiwan is centred on its own central station (Greater Taipei on Taipei Station, Taoyuan on Taoyuan Station, and so on) and matched with cities abroad: Japan, Korea, Hong Kong, Macau, Singapore, Malaysia, Indonesia, Vietnam, Thailand, the Philippines and Australia. Cities abroad are matched with Taiwan.';

  @override
  String get guideS14L3 =>
      'However far and in whichever direction you are from your station, that\'s where you appear in theirs, the same distance and direction from their station, blurred to about 500 m. No one can see your real location.';

  @override
  String get guideS14L4 =>
      'You see each other if either of you has it on: with it on, you see everyone in the matched cities who has the app open; with it off, you only see people who turned it on. Only people who have checked in and have the app open appear in other cities.';

  @override
  String get guideS14L5 =>
      'People from Parallel Universe have a dashed ring and show their city. You can still send glimmers, knock and chat. Whispers, letters to the future and gatherings stay local.';

  @override
  String get guideS15Title => '16. Translation';

  @override
  String get guideS15L1 =>
      'In a chat, when a message isn\'t in your language, Tap to translate appears under it. Tap to translate it into your language, and tap again to see the original.';

  @override
  String get guideS15L2 =>
      'Mood bubbles on the radar work the same way: when one isn\'t in your language, tap it to translate and tap again to go back to the original.';

  @override
  String get guideS15L3 =>
      'Translation happens entirely on your phone; the text is never uploaded. iPhone uses Apple\'s built-in translation, and the system asks before downloading a language the first time. Android uses Google ML Kit, which asks you first and then downloads a language model of about 30 MB. iPhone can\'t translate Malay yet.';

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
      'Close your eyes and feel your phone\'s pulse and your heartbeat. Now write how you feel, check in here and step into Mood Whisper.';

  @override
  String get intro6Title => 'A letter to your future self';

  @override
  String get intro6Body =>
      'Leave a few words in this very spot for yourself a month or a year from now. It opens only when you come back.';

  @override
  String get intro7Title => 'Glow together tonight';

  @override
  String get intro7Body =>
      'Host a gathering with one emoji as the secret sign. Everyone who adds it to their name gets your announcements, and the whole block lights up together.';

  @override
  String get intro8Title => 'Parallel Universe';

  @override
  String get intro8Body =>
      'Tap the globe and Taiwan\'s cities overlap with Tokyo, Seoul and Kuala Lumpur. See how people far away feel right now, knock and chat, and tap to translate.';

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
  String get loginTitle2 => ' to meet?';

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
      'When it\'s on, everyone with the app open in your matched cities appears on your radar, and they can all see you. Cities in Taiwan are matched with cities abroad (such as Tokyo, Seoul and Kuala Lumpur), and cities abroad are matched with Taiwan.\n\nThe two cities line up at their central stations: however far and in whichever direction you are from your station, that\'s where you appear in theirs, blurred to about 500 m, so no one can see your real location or distance. You can still send glimmers, knock and chat, and turn it off at any time. Whispers and gatherings stay local.';

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

  @override
  String placeHint(String name) {
    return 'A Mood Place lamp is nearby · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Open until $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Mood Place: $name, $hours';
  }

  @override
  String get placeWrongData => 'Something wrong?';

  @override
  String placeReportSubject(String name) {
    return 'Mood Place information is wrong: $name';
  }

  @override
  String get placeHintsSetting => 'Mood Place hints';

  @override
  String get placeHintsSettingSubtitle =>
      'A quiet in-app hint when you pass an open Mood Place (no push notifications)';

  @override
  String get guideS16Title => '10. Mood Places';

  @override
  String get guideS16L1 =>
      'Mood Places are independent cafés we partner with. After you check in, walk within 150 m of one while it is open and a small lamp appears on your radar, slowly breathing. It goes out when you walk away.';

  @override
  String get guideS16L2 =>
      'Tap the lamp to open the place card: a night view from inside, today\'s closing time, a one-line mood story from the café (tap to translate), the address and phone number. Tap Walk there to get walking directions in your map app. A lamp whose card you opened today glows softly without breathing.';

  @override
  String get guideS16L3 =>
      'The first time you pass, a small card at the top lets you know, with no sound or vibration. You get at most one hint per place every 7 days and 2 hints a day. Turn them off in Settings > Mood Place hints; the lamps stay.';

  @override
  String get guideS16L4 =>
      'The whole list of places is downloaded to your phone, and whether you are nearby is worked out only on your phone. Neither we nor the cafés know which places you pass. Cafés cannot pay for visibility. If something is wrong, report it at the bottom of the card.';

  @override
  String get placeGuestbook => 'Guestbook';

  @override
  String placeGuestbookLocked(int m) {
    return 'Step inside (within about $m m) to read what people who sat here before left behind.';
  }

  @override
  String get placeGuestbookAbout =>
      'Only people inside can read it. Anonymous, gone after 30 days.';

  @override
  String get placeGuestbookEmpty => 'No notes yet. Leave the first one.';

  @override
  String get placeGuestbookWrite => 'Leave a note';

  @override
  String get placeGuestbookHint => 'For the next person who sits here…';

  @override
  String get placeGuestbookSent => 'Done. The next person here will read it.';

  @override
  String get placeGuestbookUnavailable =>
      'The guestbook isn\'t available right now. Please try again later.';

  @override
  String get placeNoteMine => 'Your note';

  @override
  String get withdrawPlaceNote => 'Take back this note';

  @override
  String get reportPlaceNote => 'Report this note';

  @override
  String get thisPlaceNote => 'this note';

  @override
  String get guideS16L5 =>
      'Guestbook: open a place\'s card while you\'re inside (within about 40 m) to read what people who sat here before left behind, and leave a line for the next person. Notes are anonymous and disappear after 30 days. You can leave one note per place per day, tap a note to translate it, and report anything that bothers you. When you open the guestbook, your phone sends your location to our server to confirm you\'re inside; the server doesn\'t keep it.';

  @override
  String get quantumWorld => 'Quantum World';

  @override
  String get quantumWorldSubtitle =>
      'One room for the whole world, without revealing where you are';

  @override
  String get quantumIntroTitle => 'Enter the Quantum World';

  @override
  String get quantumIntroBody =>
      'Everyone in the Quantum World right now shares one room, arranged as a hive around Taipei 101. You get a seat such as \"Q4-17\" — the smaller the ring, the closer to the origin.\n\nNo one can see your real location. Others see only your seat, fixed at the moment you tap Enter; it does not move when you walk. To change it, leave and enter again. Your nickname and mood stay the same, and you can still send glimmers, knock and chat, with tap-to-translate.\n\nWhile you are in the Quantum World you temporarily leave the normal radar and Parallel Universe; when you leave, you return to your check-in spot.';

  @override
  String get quantumEnter => 'Enter';

  @override
  String get quantumLeave => 'Leave the Quantum World';

  @override
  String get quantumLeft =>
      'You left the Quantum World and are back on your radar';

  @override
  String quantumYourSeat(String code) {
    return 'Your seat $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Ring $ring · smaller rings are closer to the Taipei 101 origin';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count here now';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '$count people in the Quantum World right now';
  }

  @override
  String get quantumRegionTw => 'Taiwan';

  @override
  String get quantumRegionJp => 'Japan';

  @override
  String get quantumRegionKr => 'Korea';

  @override
  String get quantumRegionHkmo => 'Hong Kong & Macau';

  @override
  String get quantumRegionSea => 'Southeast Asia';

  @override
  String get quantumRegionOther => 'Elsewhere';

  @override
  String get quantumQuiet => 'Quantum Quiet';

  @override
  String get quantumQuietSubtitle =>
      'Just watch the world: no one can knock, but glimmers still reach you';

  @override
  String get quantumQuietTarget =>
      'They turned on Quantum Quiet — you can only send a glimmer now';

  @override
  String get quantumClosedRegion =>
      'The Quantum World isn\'t available where you are';

  @override
  String get quantumLeftClosed =>
      'You entered an area where the Quantum World isn\'t available, so you left it';

  @override
  String get quantumSeatExpired =>
      'You were away too long and your seat was released; you\'re back on your radar';

  @override
  String get quantumUnavailable =>
      'Can\'t reach the Quantum World right now. Please try again later.';

  @override
  String quantumPersonBody(String code) {
    return 'This person\'s seat in the Quantum World is $code. No one\'s real location is shown in the Quantum World.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Quantum World · $code';
  }

  @override
  String get guideS17Title => '13. Quantum World';

  @override
  String get guideS17L1 =>
      'Tap the hive icon at the top right of the radar (below Parallel Universe), read the note and tap Enter. You enter by tapping each time, just like checking in; every time you open the app you start on the normal radar.';

  @override
  String get guideS17L2 =>
      'Everyone in the Quantum World shares one room: a hive around Taipei 101, with seats 100 m apart. You get a seat code such as \"Q4-17\" (ring 4, seat 17) — smaller rings are closer to the origin. New arrivals fill seats others have left first; rings 1–3 are reserved for gathering hosts.';

  @override
  String get guideS17L3 =>
      'No one can see your real location: others see only your seat. Each time you tap Enter counts as a check-in, and your seat stays fixed from that moment; it does not move when you walk. To change it, leave and enter again. The Quantum World is not available in mainland China.';

  @override
  String get guideS17L4 =>
      'Your nickname and mood stay the same, and you can still send glimmers, knock and chat, with tap-to-translate. Pinch out to see the whole hive; far-away people become points of light. Tap your seat code at the top left to see who\'s online, turn on Quantum Quiet (no knocks, glimmers still arrive), or leave.';

  @override
  String get guideS17L5 =>
      'There are no whispers, letters to the future, Mood Places, City Beacon or gatherings in the Quantum World. While inside you temporarily leave the normal radar and Parallel Universe; when you leave, your bubble dissolves into light and you return to your check-in spot. If the app is closed or offline for more than 3 minutes, your seat is released.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Hourly chime in ${seconds}s';
  }

  @override
  String get quantumChimeLookOrigin => 'Everyone is watching the 101 origin';

  @override
  String get quantumChimeLook => 'Look';

  @override
  String quantumChimeNow(int hour) {
    return 'Quantum Center $hour o\'clock chime';
  }

  @override
  String get quantumChimeSend => 'Send a chime glimmer';

  @override
  String get quantumChimeSent => 'Your glimmer is flying to the origin';

  @override
  String quantumChimeWatched(int n) {
    return '$n people watched this chime together';
  }

  @override
  String get quantumChimeReminder => 'Hourly chime reminder';

  @override
  String get quantumChimeReminderSubtitle =>
      'A nudge just before each hour to watch the chime at the 101 origin';

  @override
  String get quantumChimeNotifyBody =>
      'The hourly chime is about to start — come watch at the 101 origin';

  @override
  String get quantumChimeChannel => 'Hourly chime';

  @override
  String get quantumChimeChannelDesc =>
      'Hourly chime reminders for the Quantum World';

  @override
  String get quantumEntangleInvite => 'Invite to entangle';

  @override
  String quantumEntangleInvited(String name) {
    return 'Invited $name to entangle';
  }

  @override
  String get quantumEntangleAskTitle => 'Quantum entanglement';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) wants to entangle with you. A thin line of light will join your two bubbles, visible however far apart you are. It collapses when either of you leaves, and nothing is kept.';
  }

  @override
  String get quantumEntangleAccept => 'Entangle';

  @override
  String quantumEntangled(String name) {
    return 'You and $name are entangled';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Your entanglement with $name has collapsed';
  }

  @override
  String get quantumEntangleCut => 'Disentangle';

  @override
  String get quantumEntangleFull => 'You\'re already entangled with 3 people';

  @override
  String get quantumEntangleTheirFull =>
      'They\'re already entangled with 3 people';

  @override
  String get quantumEntangleGone => 'They\'ve left the Quantum World';

  @override
  String get quantumEntangleExpired => 'The invitation has expired';

  @override
  String get quantumEntangledTitle => 'Entangled';

  @override
  String get quantumTunnel => 'Quantum tunnelling';

  @override
  String get quantumTunnelSubtitle =>
      'Jump to a random empty seat in the hive and meet new neighbours. Once per visit.';

  @override
  String get quantumTunnelUsed => 'You\'ve already tunnelled this visit';

  @override
  String quantumTunnelDone(String code) {
    return 'Tunnelled to $code';
  }

  @override
  String get quantumShowTime => 'Show my local time';

  @override
  String get quantumShowTimeSubtitle =>
      'Others see it when they long-press your bubble. When off, only the day-night tint shows.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Local $time · $part';
  }

  @override
  String get quantumDawn => 'early morning';

  @override
  String get quantumDay => 'daytime';

  @override
  String get quantumDusk => 'dusk';

  @override
  String get quantumNight => 'late night';

  @override
  String get quantumTopicsTitle => 'Quantum wavelength';

  @override
  String get quantumTopicsSubtitle =>
      'Pick up to 3 topics to show under your bubble';

  @override
  String get quantumTopicMusic => 'Music';

  @override
  String get quantumTopicMovies => 'Movies';

  @override
  String get quantumTopicTech => 'Tech';

  @override
  String get quantumTopicWalks => 'Walks';

  @override
  String get quantumTopicFood => 'Food';

  @override
  String get quantumTopicTravel => 'Travel';

  @override
  String get quantumTopicReading => 'Reading';

  @override
  String get quantumTopicSports => 'Sports';

  @override
  String quantumTopicsCommon(String topics) {
    return 'You both like: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Quantum signals';

  @override
  String quantumSignalReceived(String name) {
    return '$name sent you a signal';
  }

  @override
  String get quantumSignalWait => 'You just sent one — try again in a moment';

  @override
  String quantumResonance(String name) {
    return 'You and $name are resonating';
  }

  @override
  String get guideS17L6 =>
      'Hourly chime: a minute before each hour the 101 beam brightens. On the hour, messengers of light circle the origin, the bell strikes Quantum Center time (24 strikes at midnight), and a final wave of light sweeps the hive. Tap “Send a chime glimmer” during the chime — the more people watching, the brighter it gets. The hourly chime reminder is on by default; you can turn it off in the panel.';

  @override
  String get guideS17L7 =>
      'After chatting, you can invite someone to entangle: a line of light joins your bubbles however far apart you are, collapsing when either of you leaves (up to 3 at a time). Quantum tunnelling, once per visit, jumps you to a random empty seat with new neighbours.';

  @override
  String get guideS17L8 =>
      'Each bubble carries the tint of its owner\'s local time: pale gold at dawn, bright white by day, orange-violet at dusk, deep blue at night. Turn on “Show my local time” to let others see the time when they long-press your bubble. Swapping glimmers within 24 hours makes you resonate; long-press a bubble to send a 👋 ☕ 🌙 🎵 🌧️ ✨ signal; pick up to 3 wavelength topics in the panel and shared ones light up.';

  @override
  String get quantumNyTitle => 'Quantum New Year';

  @override
  String quantumNyDays(int n) {
    return '$n days to go: at Quantum Center midnight on 12/31, count down with the world at the 101 origin';
  }

  @override
  String get quantumNyTonight =>
      'Tonight at Quantum Center midnight, count down with the world at the 101 origin';

  @override
  String quantumNyZone(String places) {
    return 'Happy New Year, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n people around the world welcomed the new year together in the Quantum World';
  }

  @override
  String get quantumNyHappy => 'Happy New Year';

  @override
  String get guideS17L9 =>
      'Quantum New Year: on 12/31, as each time zone reaches midnight, its bubbles light up with golden rings in waves, and world-view dots turn gold too. At Quantum Center midnight the whole hive counts down the last 10 seconds, the 101 origin releases the world\'s biggest burst of light and 5 minutes of fireworks, and you see how many people crossed into the new year together.';

  @override
  String get quantumMeetAction => 'Make a Quantum Encounter card';

  @override
  String quantumMeetAsked(String name) {
    return 'Asked $name to make a Quantum Encounter card together';
  }

  @override
  String get quantumMeetWait => 'You just asked — try again in a moment';

  @override
  String get quantumMeetAskTitle => 'Quantum Encounter card';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) would like to turn this encounter into a card to share. It shows both your nicknames, seat codes, local times and moods — never any location.';
  }

  @override
  String get quantumMeetAccept => 'Make it together';

  @override
  String get quantumMeetEyebrow => 'QUANTUM ENCOUNTER';

  @override
  String get quantumMeetFooter => 'We met in the Quantum World';

  @override
  String get quantumMeetShare => 'Share card';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — we met in the Quantum World ✨';
  }

  @override
  String get guideS17L10 =>
      'Quantum Encounter card: after you\'ve chatted, long-press their bubble to invite them to make one together. Once you both agree, each of you gets a card to share with both nicknames, seat codes, local times with their day-night tint, and moods — never any location. Ring 4 seat codes shine in gold.';

  @override
  String get quantumOrbEntry => 'Quantum avatar';

  @override
  String get quantumOrbEntrySubtitle =>
      'Your photo becomes a crystal orb in the Quantum World';

  @override
  String get orbTitle => 'Quantum avatar';

  @override
  String get orbSubtitle => 'The glass and glow always follow your mood';

  @override
  String get orbStyleGlow => 'Glow';

  @override
  String get orbStyleRing => 'Ring';

  @override
  String get orbStyleRainbow => 'Rainbow';

  @override
  String get orbFree => 'Free';

  @override
  String get orbOwned => 'Owned';

  @override
  String get orbInUse => 'In use';

  @override
  String get orbCosmeticNote =>
      'Special orbs are only a look — they don\'t change any feature or privilege. Orbs you buy stay with your account.';

  @override
  String get orbRestore => 'Restore purchases';

  @override
  String orbPurchased(String name) {
    return '$name is yours ✨';
  }

  @override
  String get orbPurchaseFailed =>
      'The purchase didn\'t go through. Please try again later.';

  @override
  String get orbOwnedElsewhere =>
      'This purchase is already used on another account';

  @override
  String get orbStoreUnavailable =>
      'Can\'t reach the store right now. Please try again later.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · AI';

  @override
  String get aiyaConsentTitle => 'Before you talk with AIYA';

  @override
  String get aiyaConsentBody =>
      'AIYA is an AI powered by Anthropic\'s Claude. What you send to AIYA is processed by Anthropic (USA) without your identity, nickname or location, and deleted when the chat ends. AIYA can make mistakes and doesn\'t give professional advice.';

  @override
  String get aiyaConsentAgree => 'Agree and start';

  @override
  String get aiyaConsentLater => 'Not now';

  @override
  String get aiyaGreeting =>
      'Hi, I\'m AIYA, the light at the center of Quantum World. What\'s on your mind tonight?';

  @override
  String get aiyaFarewell =>
      'Time\'s up. I\'m going back into the light. Knock again whenever you miss me.';

  @override
  String get aiyaInputHint => 'Say something to AIYA…';

  @override
  String get aiyaSend => 'Send';

  @override
  String aiyaFreeLeft(int n) {
    return '$n free chats left today';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Time pack: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '$time left';
  }

  @override
  String get aiyaEnd => 'End chat';

  @override
  String get aiyaFiltered =>
      'That has words or contact details that aren\'t allowed. Try saying it another way.';

  @override
  String get aiyaBusy =>
      'AIYA drifted off for a second. Could you say that again?';

  @override
  String get aiyaRefused =>
      'I can\'t really talk about that. How about something else?';

  @override
  String get aiyaEnded => 'This chat has ended.';

  @override
  String get aiyaNoQuotaTitle => 'You\'ve used today\'s free chats';

  @override
  String get aiyaNoQuotaBody =>
      'You get 3 free chats a day, reset at 00:00 Taiwan time. To keep talking now, get a time pack. Each chat lasts up to 10 minutes.';

  @override
  String get aiyaResting => 'AIYA is tired tonight. See you tomorrow.';

  @override
  String get aiyaDailyMax =>
      'You\'ve talked a lot today. Come see AIYA again tomorrow.';

  @override
  String aiyaPackTimes(int n) {
    return '$n chats';
  }

  @override
  String get aiyaPackNote =>
      'Time packs belong to this phone\'s account and can\'t be restored if you delete the app or your account.';

  @override
  String aiyaPurchased(int n) {
    return '$n chats added ✨';
  }

  @override
  String get aiyaPurchaseFailed =>
      'The purchase didn\'t go through. Please try again.';

  @override
  String get aiyaStoreUnavailable =>
      'Can\'t reach the store right now. Please try again later.';

  @override
  String get aiyaReport => 'Report this reply';

  @override
  String get aiyaReported => 'Thanks. We\'ll review it within 24 hours.';

  @override
  String get aiyaSetting => 'AIYA (AI in Quantum World)';

  @override
  String get aiyaSettingSubtitle =>
      'When off, AIYA no longer appears at the Quantum World pillar';

  @override
  String get aiyaCameoHello =>
      'Hi, welcome to Quantum World. Tap me if you\'d like to talk.';

  @override
  String aiyaCameoChime(int hour) {
    return 'It\'s $hour o\'clock. I\'m here in the light with you.';
  }

  @override
  String get locationPickOnMap => 'Choose on the map';

  @override
  String get locationPickTitle => 'Choose where you are';

  @override
  String get locationPickHint =>
      'Move the map so the glowing dot in the middle sits where you are now';

  @override
  String get locationPickConfirm => 'I\'m here';

  @override
  String get aiyaPackEntry => '+ Time packs';

  @override
  String get aiyaPacksTitle => 'Time packs';

  @override
  String get aiyaPacksBody =>
      'You get 3 free chats a day. Time pack chats are only used after the free ones run out. Each chat lasts up to 10 minutes.';

  @override
  String get guideS1L6 =>
      'If your location can\'t be found (for example indoors, or on an iPad without GPS), tap \"Choose on the map\": move the map so the glowing dot in the middle sits where you are, then tap \"I\'m here\". Once a real location comes in, the app switches to it.';

  @override
  String get guideS17L11 =>
      'Quantum avatar: tap your seat code at the top left → \"Quantum avatar\" and your avatar becomes a crystal orb in Quantum World. Glow and Ring are free; Rainbow is a one-time purchase you keep forever, and \"Restore purchases\" brings it back on a new phone or after reinstalling.';

  @override
  String get guideS18Title => '14. AIYA · AI';

  @override
  String get guideS18L1 =>
      'AIYA is an AI who lives in the light pillar at the center of Quantum World. She is not a person, and she will tell you so. In Quantum World, tap \"AIYA · AI\" under the pillar to knock and chat; before your first chat you read a short notice and agree.';

  @override
  String get guideS18L2 =>
      'Each chat lasts up to 10 minutes and 20 messages. You get 3 free chats a day, reset at 00:00 Taiwan time, with a maximum of 30 chats a day.';

  @override
  String get guideS18L3 =>
      'Time packs: tap \"+ Time packs\" above the message box at any time to buy 5 or 20 chats; they are only used after your free chats run out. Time packs belong to the account on this phone and cannot be recovered after you delete the app or your account. They are consumable, so there is no \"Restore purchases\".';

  @override
  String get guideS18L4 =>
      'AIYA doesn\'t know and won\'t ask your location or identity; she only sees anonymous city mood totals. She won\'t flirt or discuss sexual content, and she doesn\'t give medical, legal or financial advice. Long-press any reply to report it. Chats are only kept for the current conversation and are deleted shortly after it ends.';

  @override
  String get guideS18L5 =>
      'Now and then AIYA appears in the light pillar: at the hourly chime, the first time you enter Quantum World each day, or by chance. Tap her to start chatting. To stop seeing her, turn off \"AIYA (AI in Quantum World)\" in Settings.';

  @override
  String get orbStyleXmas => 'Christmas';

  @override
  String get orbStyleNewYear => 'Quantum New Year';

  @override
  String get orbLimited => 'Limited';

  @override
  String orbLimitedUntil(String date) {
    return 'Limited · until $date';
  }

  @override
  String get aiyaFriendTitle => 'AIYA Friend';

  @override
  String get aiyaFriendSubtitle => 'Auto-renewing monthly plan';

  @override
  String get aiyaFriendPerk1 => '20 chats a day (3 when free)';

  @override
  String get aiyaFriendPerk2 => 'Each chat lasts 20 minutes or 40 messages';

  @override
  String get aiyaFriendPerk3 => 'Talk to her even when AIYA is resting';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA wears an exclusive “Starlight” look (only you see it)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / month';
  }

  @override
  String get aiyaFriendSubscribe => 'Subscribe';

  @override
  String get aiyaFriendTerms =>
      'The subscription lasts 1 month and renews automatically with payment unless auto-renew is turned off at least 24 hours before the end of the period. Payment is handled by your Apple or Google account; manage or cancel any time in your account’s subscription settings. Time Pack chats are kept and used only after the 20 daily chats.';

  @override
  String aiyaFriendActive(String date) {
    return 'You’re an AIYA Friend until $date';
  }

  @override
  String get aiyaFriendManage => 'Manage subscription';

  @override
  String get aiyaFriendRestore => 'Restore purchases';

  @override
  String get aiyaFriendWelcome => 'You’re now an AIYA Friend ✨';

  @override
  String get aiyaFriendRestored => 'AIYA Friend restored';

  @override
  String get aiyaFriendNotFound => 'No active AIYA Friend subscription found';

  @override
  String get aiyaFriendElsewhere =>
      'This subscription is already used by another account';

  @override
  String get aiyaFriendEntry => 'AIYA Friend · 20 a day';

  @override
  String aiyaFriendLeft(int n) {
    return 'AIYA Friend · $n left today';
  }

  @override
  String get guideS17L12 =>
      'Limited looks: the Christmas crystal orb (holly wreath, twinkling gold star, falling snow) is sold until 12/25, and the Quantum New Year crystal orb (gold clock ticks and bursting fireworks, extra big at the stroke of midnight) until 1/1, Taiwan time. After that they are never sold again; if you bought one you keep it forever and can restore it.';

  @override
  String get guideS18L6 =>
      'AIYA Friend: choose \"AIYA Friend\" under \"+ Time Pack\". It is an auto-renewing monthly plan: 20 chats a day, each up to 20 minutes or 40 messages, chats even while AIYA is resting, and a \"Starlight\" look on AIYA that only you see. Time-pack chats are used only after the 20 daily chats. The subscription renews automatically; cancel any time in your Apple or Google subscription settings, and tap \"Restore purchases\" on a new phone.';

  @override
  String get mapConsentTitle => 'Show your location on the map?';

  @override
  String get mapConsentBody =>
      'If you allow this, each time you tap Check in (or Enter in the Quantum World) yourself, other users see the spot where you checked in (not your live position), your nickname and your mood on the map. There is no automatic check-in, and you disappear from the map when you leave the app. You can decline, and you can turn this off any time in Settings.';

  @override
  String get mapConsentAllow => 'Allow';

  @override
  String get mapConsentDecline => 'Don\'t allow';

  @override
  String get mapConsentDeclined =>
      'OK. You won\'t appear on anyone\'s map. Tap again whenever you want to check in.';

  @override
  String get mapConsentSetting => 'Show my location on the map';

  @override
  String get mapConsentSettingSubtitle =>
      'Turning this off ends your check-in right away; you won\'t appear on anyone\'s map';

  @override
  String get wgErrInGroup =>
      'You\'re already in a group. Leave it first to join or start another.';

  @override
  String get wgErrFull =>
      'This group already has 20 people. Ask the leader to get the 7-day plan.';

  @override
  String get wgErrPaidFull => 'This group is full (100 people).';

  @override
  String get wgErrQr =>
      'This QR code was replaced. Ask the leader for the new one.';

  @override
  String get wgErrEnded => 'This group has ended or does not exist.';

  @override
  String get wgErrFiltered =>
      'This contains words that are not allowed. Please edit it.';

  @override
  String get wgErrHostLeave =>
      'Leaders cannot leave. Hand over to a member or end the group first.';

  @override
  String get wgErrBusy => 'Couldn\'t connect. Please try again.';

  @override
  String get wgErrName => 'Give your group a name.';

  @override
  String get wgPassUnavailable => 'The store isn\'t available right now.';

  @override
  String get wgPassFailed =>
      'The purchase didn\'t go through. Please try again.';

  @override
  String get wgPassDone =>
      'The 7-day plan is on. This group can now have up to 100 people.';

  @override
  String get wgCreateTitle => 'Start a group';

  @override
  String get wgCreateBody =>
      'A private group: only people with your QR code can join. Call everyone together, take roll call and set a meeting point.';

  @override
  String get wgNameLabel => 'Group name';

  @override
  String get wgColorLabel => 'Group color';

  @override
  String wgDaysLabel(int n) {
    return 'Lasts $n day(s), including today';
  }

  @override
  String get wgFreeNote =>
      'Free for up to 20 people. For more, the leader gets the 7-day plan (up to 100).';

  @override
  String get wgCreateButton => 'Start group';

  @override
  String wgJoined(String name, int no) {
    return 'Joined \"$name\". You are No. $no';
  }

  @override
  String get wgJoinTitle => 'Join a group';

  @override
  String get wgJoinBody =>
      'Scanning the leader\'s QR code with your camera is fastest, or enter the 8-character code.';

  @override
  String get wgJoinButton => 'Join';

  @override
  String wgButtonLabel(String name) {
    return 'Group $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit people';
  }

  @override
  String wgUntil(String date) {
    return 'until $date';
  }

  @override
  String wgMyNo(int n) {
    return 'I\'m No. $n';
  }

  @override
  String get wgCallButton => 'Call everyone';

  @override
  String get wgCallDone => 'Everyone\'s here, end the call';

  @override
  String get wgRollButton => 'Roll call';

  @override
  String wgRollSummary(int here, int total) {
    return 'Roll call: $here/$total here';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n members (tap to add a note, hand over or remove)';
  }

  @override
  String get wgNoMembers =>
      'No members yet. Tap \"QR code\" so people can scan to join.';

  @override
  String get wgQrButton => 'QR code';

  @override
  String get wgDissolveAsk =>
      'End this group? Everyone will be notified and the list and records will be deleted.';

  @override
  String get wgDissolve => 'End group';

  @override
  String wgCallIn(int n) {
    return 'Meet in $n min';
  }

  @override
  String get wgCallNow => 'Meet now';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total got it';
  }

  @override
  String get wgAnswerHere => 'I\'m here';

  @override
  String get wgAnswer5min => '5 more min';

  @override
  String get wgAnswerHelp => 'Need help';

  @override
  String get wgNoReply => 'No reply';

  @override
  String get wgStateAck => 'Got it';

  @override
  String get wgStateSeen => 'Seen';

  @override
  String get wgStateNone => 'No response';

  @override
  String get wgPassTitle => 'Group 7-day plan';

  @override
  String get wgPassBody =>
      'Free for up to 20 people. With the plan, this group can have up to 100 people until it ends. One purchase covers this group only and does not renew.';

  @override
  String get wgPassButton => 'Get 7-day plan';

  @override
  String wgHostIs(String name) {
    return 'Leader: $name';
  }

  @override
  String get wgNoCall =>
      'No call right now. When the leader calls everyone, your phone will ring.';

  @override
  String get wgRollAsk => 'The leader is taking roll call';

  @override
  String get wgLeaveAsk => 'Leave this group?';

  @override
  String get wgLeave => 'Leave group';

  @override
  String get wgCallTitle => 'Time to meet!';

  @override
  String get wgAcked => '✓ The leader knows you got it';

  @override
  String get wgAckButton => 'Got it';

  @override
  String get wgCallSheetTitle => 'Call everyone together';

  @override
  String get wgNow => 'Now';

  @override
  String wgInMinutes(int n) {
    return 'In $n min';
  }

  @override
  String get wgPlaceLabel => 'Meeting point';

  @override
  String get wgPlaceHint => 'e.g. Ximen MRT exit 6';

  @override
  String get wgPlaceNote =>
      'The meeting point is set to where you are now. Members see the distance and direction.';

  @override
  String get wgSendCall => 'Send call';

  @override
  String get wgNoLocation =>
      'Couldn\'t get your location for the meeting point.';

  @override
  String get wgQrTitle => 'Scan to join';

  @override
  String get wgQrBody =>
      'Scan with the phone camera to join, or enter the code below.';

  @override
  String wgShareText(String name, String url) {
    return 'Join my group \"$name\": $url';
  }

  @override
  String get wgShare => 'Share link';

  @override
  String get wgRotateAsk =>
      'Replace the QR code? The old code and link stop working right away.';

  @override
  String get wgRotate => 'New QR code';

  @override
  String wgMemberTitle(int no) {
    return 'No. $no';
  }

  @override
  String get wgEditNote => 'Note';

  @override
  String get wgHandoff => 'Make them the leader';

  @override
  String wgHandoffAsk(int no) {
    return 'Hand the group over to No. $no? You will become a member.';
  }

  @override
  String get wgKick => 'Remove from group';

  @override
  String wgKickAsk(int no) {
    return 'Remove No. $no from the group?';
  }

  @override
  String get wgNotePrivate =>
      'Only you see notes, such as a name or room number.';

  @override
  String get wgSave => 'Save';

  @override
  String get wgConfirm => 'Confirm';

  @override
  String get wgCancel => 'Cancel';

  @override
  String get wgSettingCreate => 'Start a group';

  @override
  String get wgSettingCreateSub =>
      'Private group for trips, school outings and hikes: call everyone and take roll call';

  @override
  String get wgSettingJoin => 'Join a group';

  @override
  String get wgSettingJoinSub => 'Enter the leader\'s 8-character code';

  @override
  String wgSettingOpen(String name) {
    return 'My group: $name';
  }

  @override
  String get wgChannelName => 'Group calls';

  @override
  String get wgChannelDesc => 'When the group leader calls everyone together';

  @override
  String get guideS19Title => '15. Whisper Groups';

  @override
  String get guideS19L1 =>
      'A Whisper Group is a private group for trips, school outings, hikes, outings or event staff. Go to Settings → Gatherings → \"Start a group\", give it a name, pick a color and the number of days (up to 7).';

  @override
  String get guideS19L2 =>
      'Joining: the leader taps the group button at the bottom of the map → \"QR code\"; members scan it with the phone camera and the app opens to join. Or go to Settings → Gatherings → \"Join a group\" and enter the 8-character code. Outsiders cannot search for or request to join, and the leader can replace the QR code at any time.';

  @override
  String get guideS19L3 =>
      'Calling everyone: the leader taps \"Call everyone\", picks a time and describes the meeting point. Members\' phones play a special sound with a \"short short long\" vibration; in the app they see a countdown, the distance and direction to the meeting point, and a pillar of light on the map. Anyone who has not tapped \"Got it\" is reminded once a minute, up to 3 times; the leader sees who got it, who saw it and who has not responded.';

  @override
  String get guideS19L4 =>
      'Roll call: the leader taps \"Roll call\"; members get the same sound and vibration and tap \"I\'m here\", \"5 more min\" or \"Need help\". The leader never sees members\' locations, only their replies.';

  @override
  String get guideS19L5 =>
      'Groups of up to 20 people are free. For more, the leader can buy the group 7-day plan: up to 100 people until the group ends. Members never pay. A group lasts at most 7 days; when it expires or the leader ends it, the list and records are deleted.';

  @override
  String get wgFlagButton => 'Raise flag';

  @override
  String get wgFlagHost => 'Leader';

  @override
  String get wgFlagHint =>
      'Hold up your phone so the group can spot you in the crowd. Tap to close.';

  @override
  String get wgLostButton => 'I\'m lost';

  @override
  String get wgFound => 'I found the group';

  @override
  String get wgLostSent =>
      'Your location was sent to the leader. Wait where you are or head to the meeting point.';

  @override
  String get wgLostTitleAsk => 'Send your location to the leader?';

  @override
  String get wgLostAsk =>
      'Your current location is sent to the leader once; their phone alerts them and shows you on the map. It is sent only this once, never tracked, and deleted after 30 minutes. Tap \"I found the group\" to remove it sooner.';

  @override
  String get wgLostSend => 'Send my location';

  @override
  String wgLostTitle(int n) {
    return '$n lost member(s)';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String get wgNavigate => 'Directions';

  @override
  String get wgFoundThem => 'Found them';

  @override
  String get guideS19L6 =>
      'Finding each other: in a crowd, tap \"Raise flag\" and your whole screen flashes in the group color with your number; hold it up so others can spot you. If a member really gets separated, they can tap \"I\'m lost\" to send their current location to the leader once (deleted after 30 minutes). The leader\'s phone alerts them, a red pin appears on the map, and they can get directions.';

  @override
  String wgLostAlert(int no) {
    return 'No. $no is lost';
  }

  @override
  String wgHelpAlert(String no) {
    return 'No. $no needs help';
  }

  @override
  String get wgViewList => 'Open group';

  @override
  String aiyaCameoChimeNight(int hour) {
    return 'It\'s $hour o\'clock. Still awake? I\'m here in the light with you.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return 'It\'s $hour o\'clock. Good morning, take it easy today.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return 'It\'s $hour o\'clock. How is your city tonight?';
  }

  @override
  String get aiyaCameoNyReady => 'Ready? Let\'s count down together!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'Happy New Year! $year — we\'re all in the same room.';
  }

  @override
  String get aiyaSkinEntry => '✦ Looks';

  @override
  String get aiyaSkinTitle => 'AIYA\'s looks';

  @override
  String get aiyaSkinSubtitle => 'Only you see the look on your AIYA';

  @override
  String get aiyaSkinNone => 'Original';

  @override
  String get aiyaSkinStarlight => 'Starlight';

  @override
  String get aiyaSkinStarlightSub => 'For AIYA Friends';

  @override
  String get aiyaSkinXmas => 'Christmas';

  @override
  String get aiyaSkinNewYear => 'Quantum New Year';

  @override
  String get aiyaSkinNote =>
      'Holiday looks are one-time purchases you keep forever. They only change how AIYA looks, not your chats. Limited looks are not sold again after their sale ends.';

  @override
  String get orbStyleStarTrail => 'Star Trail';

  @override
  String get orbStyleRings => 'Growth Rings';

  @override
  String get orbGrowNote =>
      'Growing orbs: Star Trail gains a star for each Quantum Meet Card (once per person per 24 hours, up to 24). Growth Rings gain a ring for every 3 hours spent in the Quantum World (up to 12). Growth is saved to your account and starts counting now. Only the counts are kept, never who or where.';

  @override
  String orbGrowStars(int count) {
    return '$count stars so far';
  }

  @override
  String orbGrowRings(int count) {
    return '$count rings so far';
  }

  @override
  String get giftAction => 'Send a gift';

  @override
  String giftSheetTitle(String name) {
    return 'Send a gift to $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Pick an orb style for $name';
  }

  @override
  String get giftBouquetName => 'Light bouquet';

  @override
  String get giftBouquetDesc =>
      'A burst of light blooms when they accept, then petals of light circle their orb for 24 hours';

  @override
  String get giftOrbName => 'Give an orb style';

  @override
  String get giftOrbDesc =>
      'You pick one; it is theirs to keep once they accept';

  @override
  String get giftPairName => 'Entangled pair';

  @override
  String get giftPairDesc =>
      'One orb for each of you, paired; a rope of light links you when you are both in the Quantum World';

  @override
  String get giftPairYouHave => 'You already have an entangled pair';

  @override
  String get giftNote =>
      'They can accept or decline. If they decline or do not answer in 7 days, the gift comes back to you to give to someone else.';

  @override
  String get giftVouchersTitle => 'Returned gifts (no extra charge)';

  @override
  String get giftSendVoucher => 'Send';

  @override
  String giftSent(String name) {
    return 'Gift sent to $name. Waiting for them to accept.';
  }

  @override
  String get giftReturnedOff =>
      'They have turned off gifts, so it came back to you';

  @override
  String get giftReturnedBlocked =>
      'This person cannot receive your gift, so it came back to you';

  @override
  String get giftReturnedOwned =>
      'They already have this orb, so it came back to you; you can give another style';

  @override
  String get giftReturnedPaired =>
      'They already have an entangled pair, so it came back to you';

  @override
  String get giftReturnedYouPaired =>
      'You already have an entangled pair, so it came back to you';

  @override
  String get giftReturnedGeneric =>
      'The gift came back to you; you can give it to someone else';

  @override
  String get giftStoreUnavailable => 'The store is not available right now';

  @override
  String get giftFailed =>
      'The gift did not go through. Please try again later.';

  @override
  String giftFromBouquet(String name) {
    return '$name sent you a light bouquet';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name gave you the \"$style\" orb';
  }

  @override
  String giftFromPair(String name) {
    return '$name wants to be your entangled pair';
  }

  @override
  String get giftInboxTitle => 'Gifts for you';

  @override
  String get giftInboxEmpty => 'No gifts right now';

  @override
  String get giftInboxNote =>
      'Declined gifts go back to the sender; unanswered gifts go back after 7 days.';

  @override
  String get giftAccept => 'Accept';

  @override
  String get giftDecline => 'Decline';

  @override
  String get giftDeclined => 'Declined. The gift goes back to the sender.';

  @override
  String get giftAcceptedOrb => 'Accepted! Switch to it in Quantum avatar.';

  @override
  String giftAcceptedPair(String name) {
    return 'You and $name are now an entangled pair';
  }

  @override
  String get giftAcceptedBouquet =>
      'Bouquet accepted. Petals of light will circle your orb for 24 hours.';

  @override
  String get giftAlreadyOwned =>
      'You already have this orb; the gift went back to the sender';

  @override
  String get giftAlreadyPaired =>
      'One of you is already paired; the gift went back to the sender';

  @override
  String get giftSettingsTitle => 'Gifts';

  @override
  String get giftReceiveToggle => 'Receive gifts';

  @override
  String get giftReceiveToggleSub =>
      'When off, gifts go straight back to the sender';

  @override
  String get giftVouchersHint =>
      'Tap \"Send a gift\" on someone to give these again';

  @override
  String get giftUnpair => 'End entangled pair';

  @override
  String giftUnpairConfirm(String name) {
    return 'End your entangled pair with $name? You both keep the orb, but the rope of light goes away.';
  }

  @override
  String get orbStylePair => 'Entangled';

  @override
  String giftPairedWith(String name) {
    return 'Entangled with $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Gifts for you ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count returned gifts';
  }

  @override
  String get giftBlockedOff =>
      'They have turned off gifts. You were not charged.';

  @override
  String get giftBlockedBlocked =>
      'You cannot send gifts to this person. You were not charged.';

  @override
  String get giftBlockedOwned =>
      'They already have this orb. Pick another one (you were not charged).';

  @override
  String get giftBlockedPaired =>
      'They already have an entangled pair. You were not charged.';
}
