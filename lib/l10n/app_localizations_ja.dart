// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get checkInEnter => 'ここでチェックインして街へ';

  @override
  String get checkInNote => '押すと、近くの人にいまの気分とだいたいの位置が見えます。入るたびに自分でチェックインします。';

  @override
  String get checkInTitle => 'チェックインして街へ';

  @override
  String get checkInBody =>
      'チェックインすると、近くの人にいまの気分とだいたいの位置が見え、あなたもその人たちが見えるようになります。表示されるのはチェックインした場所で、移動しても動きません。アプリを開くたびに自分でチェックインします。自動でチェックインすることはありません。アプリを離れたり他のアプリに切り替えると、チェックインは終了します。';

  @override
  String get checkInButton => 'ここでチェックイン';

  @override
  String get checkInAgain => 'チェックインした場所から離れました · ここでチェックイン';

  @override
  String get checkOutButton => 'チェックイン中 · 終了';

  @override
  String get checkedOutToast => 'チェックインを終了しました。地図にはもう表示されません。';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'うれしい';

  @override
  String get moodSad => 'かなしい';

  @override
  String get moodAngry => '怒り';

  @override
  String get moodCalm => 'おだやか';

  @override
  String get moodPassion => '情熱';

  @override
  String get moodLove => '愛';

  @override
  String get moodOther => 'その他';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name は終了しました';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return '$emoji $name の主催を引き継ぎました。今は参加者です。';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return '主催を引き継ぎました。呼び名がすでに10文字なので、お知らせを受け取り続けるには $emoji を自分で呼び名に加えてください。';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return '主催を引き継ぎました。呼び名に $emoji を加えたので、今は参加者です。';
  }

  @override
  String get gotIt => 'わかった';

  @override
  String get blockedToast => 'この人を闇に沈めました。';

  @override
  String get unblockedToast => 'ブロックを解除しました。また道が交わるかもしれません。';

  @override
  String notificationToast(String title, String body) {
    return '$title：$body';
  }

  @override
  String get locationServiceOffTitle => '位置情報サービスをオンにしてください';

  @override
  String get locationServiceOffBody =>
      '近くの人にあなたのムードを届けるには、街のどのあたりにいるかを知る必要があります。端末の「設定」で「位置情報サービス」をオンにしてください。';

  @override
  String get locationReducedTitle => '「正確な位置情報」をオンにしてください';

  @override
  String get locationReducedBodyIos =>
      'おおよその位置しか共有されていないため、レーダーが近くの人を判断できません。「設定」›「Mood Whisper」›「位置情報」で「正確な位置情報」をオンにしてください。';

  @override
  String get locationReducedBodyAndroid =>
      'おおよその位置しか共有されていないため、レーダーが近くの人を判断できません。位置情報の権限で「正確」を選んでください。';

  @override
  String get locationNoFixTitle => '現在地を取得できません';

  @override
  String get locationNoFixBody =>
      '屋内か電波が弱い場所かもしれません。窓の近くや屋外に移動し、Wi-Fi をオンにしてもう一度お試しください。';

  @override
  String get locationNeededTitle => '位置情報が必要です';

  @override
  String get locationNeededBody =>
      'Mood Whisper はアプリの使用中だけ位置情報を使い、5 km 以内のムードを表示します。レーダーにはおおよその距離だけが表示され、住所は表示されません。\n設定で「アプリの使用中は許可」を選び、「正確な位置情報」をオンにしてください。';

  @override
  String get locationSimulatorHint =>
      '（開発メモ：シミュレータでは Features › Location で位置を選んでください）';

  @override
  String get openSettings => '設定を開く';

  @override
  String get locationRecheck => 'オンにした、もう一度確認';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get leaveApp => '終了する';

  @override
  String whispersNearby(int count) {
    return '近くに $count 件のささやきがあります。封筒をタップして読んでみて。';
  }

  @override
  String get whisperPassed => 'ささやきのそばを通りました。封筒をタップして読んでみて。';

  @override
  String get whisperLeft => 'ささやきをここに残しました。7 日後に消えます。';

  @override
  String get timeWhisperSealedYear => '封をしました。1 年後、ここに戻ってくると開けられます。';

  @override
  String get timeWhisperSealedMonth => '封をしました。1 か月後、ここに戻ってくると開けられます。';

  @override
  String get whisperWithdrawn => 'ささやきを取り消しました。';

  @override
  String get whisperMineLabel => 'あなたが残したささやき';

  @override
  String get whisperTapToRead => 'ささやき。タップして読む';

  @override
  String get noMoodYet => '言葉が見つからない…';

  @override
  String get knockWithdrawnByLeaving => '相手は街に紛れて、そっとノックを取り消しました…';

  @override
  String get knockCardTitle => 'ひとときの交差';

  @override
  String knockCardBody(String name) {
    return '$name がノックしています。\nあなたと道を交えたいようです…';
  }

  @override
  String get skip => 'スキップ';

  @override
  String get decline => 'お断り';

  @override
  String get accept => 'OK';

  @override
  String get reportThisPerson => 'この人を通報';

  @override
  String get cityQuietTonight => '今夜の街はまだ静か';

  @override
  String cityMoodChip(String mood, String percent) {
    return '今夜の街 · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text。街のムード天気を見る';
  }

  @override
  String get cityMoodTitle => '今夜の街のムード';

  @override
  String cityMoodQuietCount(int total) {
    return '街はまだ静かです。今夜は $total 人がムードを残しました。';
  }

  @override
  String cityMoodCount(int total) {
    return '20 km 以内で、今夜 $total 人がムードを残しました';
  }

  @override
  String get cityMoodQuietInvite =>
      'ムードがひとつ増えるたび、街に少し光が灯ります。今の気持ちを書いて、街を照らす一人になろう。';

  @override
  String get cityMoodFootnote => '24 時間以内のムードを匿名で集計。10 人未満のときは割合を表示しません。';

  @override
  String get close => '閉じる';

  @override
  String get emptyRadarTitle => 'あなたが今夜最初の光';

  @override
  String get emptyRadarBody =>
      '近くにはまだ誰もいません。あなたのムードはもう街で光っていて、\n誰かが通りかかれば見つけてもらえます。次に通る人へ、ささやきを残すこともできます。';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '今夜の街には $total 人。多くの人が「$mood」と感じています';
  }

  @override
  String get inviteFriends => '友だちを誘って街区を照らそう';

  @override
  String get shareMoodCard => 'ムードカードをシェア';

  @override
  String get editYourMood => 'ムードを編集';

  @override
  String resonanceTonight(int count) {
    return '今夜 $count つのきらめきがあなたに共鳴しました';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · あなたのムード';
  }

  @override
  String get dockTapToEdit => 'あなたのムード · タップして変更';

  @override
  String get leaveWhisper => 'ささやきを残す';

  @override
  String get settings => '設定';

  @override
  String get nightlyReminder => '夜のリマインダー';

  @override
  String get nightlyReminderSubtitle => '毎晩 21:30 にやさしいお知らせ';

  @override
  String get closeSettings => '設定を閉じる';

  @override
  String get settingsSectionMe => 'わたし';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get editProfileSubtitle => '写真、街での呼び名、ムード';

  @override
  String get manageBlockList => 'ブロックした人';

  @override
  String get manageBlockListSubtitle => '闇に沈めた人を確認・解除';

  @override
  String get myTimeWhispers => '未来への手紙';

  @override
  String get myTimeWhispersSubtitle => '未来の自分へ。あなたにしか見えません';

  @override
  String get myMoodTrail => 'ムードの軌跡';

  @override
  String get myMoodTrailSubtitle => 'この端末にだけ保存されます';

  @override
  String get settingsSectionGatherings => '集い';

  @override
  String get gatheringHost => '集いを主催する';

  @override
  String get gatheringHostSubtitle => 'あなたを中心に 5 km でイベントを開く';

  @override
  String gatheringHosting(String emoji, String name) {
    return '$emoji $name を主催中';
  }

  @override
  String get settingsSectionShare => 'シェア';

  @override
  String get shareMoodCardSubtitle => '11 枚の夜景イラストからランダム。インスタのストーリーズにぴったり';

  @override
  String get inviteFriendsSubtitle => '近くに人が多いほど、街は明るくなる';

  @override
  String get settingsSectionAbout => 'このアプリについて';

  @override
  String get guide => '使い方';

  @override
  String get guideSubtitle => 'ムードを書くことから集いを開くまで、まとめて紹介';

  @override
  String get termsOfUse => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get deleteAccount => 'アカウントとデータを削除';

  @override
  String get deleteAccountSubtitle => '街に残したすべてを完全に消去します';

  @override
  String get avatarUploadFailed => '写真をアップロードできませんでした。しばらくしてからお試しください。';

  @override
  String get moodEmpty => 'ムードは空にできません。街に小さな光を残してください。';

  @override
  String get profileSyncFailed => '更新できませんでした。しばらくしてからお試しください。';

  @override
  String get profileUpdated => '更新しました。街があなたの息づかいを感じています。';

  @override
  String get changeAvatar => '写真を変更';

  @override
  String get avatarHint => 'タップして写真を変更 · 光の輪はあなたのムードの色';

  @override
  String get cityName => '街での呼び名';

  @override
  String get cityNameHint => '任意。例：さまよう猫';

  @override
  String get currentMood => '今のムード';

  @override
  String get currentMoodHint => '例：小雨の中をお散歩 🌿';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get blockListTitle => '闇に沈めた人';

  @override
  String get blockListEmpty => '夜空は晴れています。まだ誰も遠ざけていません。';

  @override
  String get unblock => '解除';

  @override
  String get deleteAccountBody =>
      '位置情報、ムード、呼び名、写真、残したささやき、きらめき、ブロックリスト、進行中の会話はすべて完全に削除され、元に戻せません。\n\n不正利用を防ぐため、通報記録はプライバシーポリシーに従い 1 年間保管されます。';

  @override
  String get deleting => '削除中…';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get deleteFailed => '削除が完了しませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String get fadingEcho => '残像';

  @override
  String clusterCount(int count) {
    return 'ここに $count 個のムード';
  }

  @override
  String clusterMore(int count) {
    return 'もっと\n+$count';
  }

  @override
  String get clusterBackToFirst => '最初に\n戻る';

  @override
  String get fadingEchoTitle => 'ひとつの残像';

  @override
  String encounterWith(String name) {
    return '$name との出会い';
  }

  @override
  String get fadingEchoBody => 'これは残像です。交わることはできません。';

  @override
  String get demoPersonBody =>
      'これはデモ用の相手で、自動で返信します。実在の人ではありません。ノック、チャット、きらめき、通報、ブロックを試せます。';

  @override
  String get sendGlimmer => 'きらめきを送る（共鳴）';

  @override
  String get knock => 'ノック（交わる）';

  @override
  String get blockAction => 'ブロック（闇に沈める）';

  @override
  String get handOverHost => '主催を引き継ぐ';

  @override
  String get report => '通報';

  @override
  String get confirmBlockTitle => 'ブロックしますか？';

  @override
  String confirmBlockBody(String name) {
    return '$name を闇に沈めますか？\nブロックすると、お互いの街から姿が消えます。';
  }

  @override
  String get confirmBlock => 'ブロック';

  @override
  String get glimmerReceived => '誰かがきらめきを送ってくれました。あなたのムードに共鳴したようです。';

  @override
  String get glimmerSent => 'きらめきを送りました。';

  @override
  String get glimmerAlreadySent => '今日はもうこの人にきらめきを送りました。また明日どうぞ。';

  @override
  String get knockSent => 'ノックしました。返事を待っています…';

  @override
  String get knockFailed => 'ノックが届きませんでした。しばらくしてからお試しください。';

  @override
  String get knockNoAnswer => '返事はなく、ノックの音はそっと消えました。';

  @override
  String get knockDeclined => '今回は交わりませんでした。お互いに少し距離を置きましょう。';

  @override
  String get knockSkipped => '相手は今回はスキップしました。ノックの音はそっと消えました。';

  @override
  String get sensingCity => '街の気配を感じています…';

  @override
  String get sensingCityHint =>
      '街が静かすぎるときは、「パラレルユニバース」や「量子世界」に入って、ほかの街の人と出会ってみてください。';

  @override
  String get gatheringUnavailable => '集いは現在使えません。しばらくしてからお試しください。';

  @override
  String get notSentCheckNetwork => '送信できませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int count) {
    return '$count 分前';
  }

  @override
  String hoursAgo(int count) {
    return '$count 時間前';
  }

  @override
  String get nextDayPrefix => '翌日 ';

  @override
  String get gatheringNameMissing => '集いに名前をつけてください。';

  @override
  String get gatheringEmojiInvalid => 'アイコンは絵文字ひとつだけにしてください。';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name が始まりました。参加する人には呼び名に $emoji を加えてもらいましょう。';
  }

  @override
  String get startGatheringTitle => '集いを開く';

  @override
  String get startGatheringLead => 'あなたの位置を中心に 5 km。あなたが動けば範囲も一緒に動きます。';

  @override
  String get gatheringNameHint => '集いの名前。例：渋谷カウントダウン';

  @override
  String get gatheringEmojiHint => 'アイコン';

  @override
  String get gatheringEmojiHelp => 'アイコンは絵文字ひとつ。近くで誰も使っていないものを選べます。';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return '呼び名に $emoji を加えた人には、お知らせが表示され通知も届きます。';
  }

  @override
  String get start => '開始';

  @override
  String get end => '終了';

  @override
  String get gatheringMaxDuration => '最長 24 時間。時間になると自動で終了します。';

  @override
  String get starting => '開始中…';

  @override
  String get startGathering => '集いを始める';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name は終了しました。あなたは街に戻りました。';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · 主催中';
  }

  @override
  String hostAudienceRule(String emoji) {
    return '5 km 以内で呼び名に $emoji がある人に、お知らせが表示され通知が届きます。誰なのかはあなたには見えません。';
  }

  @override
  String get postAnnouncement => 'お知らせを投稿';

  @override
  String get announcementHint => '例：駅の東口に集合';

  @override
  String get announcementSent => 'お知らせを送信しました';

  @override
  String announcementLine(String ago, String text) {
    return '$ago　$text';
  }

  @override
  String get announcementHiddenSuffix => '（複数の通報により非表示）';

  @override
  String get groupQuestion => 'みんなに質問';

  @override
  String get questionHint => '例：今のあなたは？';

  @override
  String get sendQuestion => '質問する';

  @override
  String get questionSent => '質問を送りました。みんながムードで答えてくれます';

  @override
  String get handOff => '引き継ぐ';

  @override
  String handoffPending(String name) {
    return '$name に主催の引き継ぎを依頼しました。返事を待っています…';
  }

  @override
  String get theOtherPerson => '相手';

  @override
  String get handoffCancelled => '引き継ぎの依頼を取り消しました';

  @override
  String get handoffHelp =>
      'レーダー上の参加者の泡を長押し →「主催を引き継ぐ」。相手が承諾すると主催が交代し、集いもお知らせも途切れません。';

  @override
  String get confirmEndAgain => '終了しますか？もう一度タップ';

  @override
  String get endGathering => '集いを終了';

  @override
  String tallyHeader(String question, int total) {
    return '「$question」· $total 人が回答';
  }

  @override
  String get tallyQuiet => '回答が 10 人に達すると割合を表示します。少人数で誰か推測されないようにするためです。';

  @override
  String get bannerYouHost => '  · 主催中';

  @override
  String get bannerHostAnnouncement => '  · 主催者からのお知らせ';

  @override
  String get manageGathering => '集いを管理';

  @override
  String get reportAnnouncement => 'このお知らせを通報';

  @override
  String get expandAnnouncement => 'お知らせを開く';

  @override
  String get collapseAnnouncement => 'お知らせを閉じる';

  @override
  String hostHandedOffAgo(String ago) {
    return '主催が交代 · $ago';
  }

  @override
  String get announcementReportedHidden => 'このお知らせを通報したので、画面から削除しました。';

  @override
  String get noAnnouncementHost => 'まだお知らせはありません。右上の調整ボタンから最初のお知らせを投稿しましょう。';

  @override
  String get noAnnouncementGuest => '主催者はまだお知らせを投稿していません。';

  @override
  String hostAsks(String question) {
    return '主催者からの質問：$question';
  }

  @override
  String get answeredNote => '回答しました。主催者に見えるのは全体のムードの割合だけです。';

  @override
  String get answerHint => 'ムードひとことで答える';

  @override
  String get sendAnswer => '回答を送る';

  @override
  String handoffInvited(String name) {
    return '$name に主催の引き継ぎを依頼しました。返事を待っています（5 分間有効）。';
  }

  @override
  String handoffTitle(String name) {
    return '集いを $name に引き継ぐ';
  }

  @override
  String get handoffBody =>
      '相手が承諾すると、その人が集いを主催します。名前、お知らせ、質問はそのまま残り、あなたは参加者に戻ります。';

  @override
  String get handoffPublic => '公開で引き継ぐ';

  @override
  String get handoffPublicHelp => '参加者全員に「主催が交代しました」と通知';

  @override
  String get handoffQuiet => '静かに引き継ぐ';

  @override
  String get handoffQuietHelp => '誰にも通知せず、レーダー上の「主催」の光の輪だけが移ります';

  @override
  String get sending => '送信中…';

  @override
  String get sendInvite => '依頼を送る';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'あなたが $emoji $name の主催者になりました。';
  }

  @override
  String get handoffOfferTitle => '主催を引き継いでくれませんか？';

  @override
  String handoffOfferBody(String name) {
    return '主催者が「$name」をあなたに任せたいそうです。引き継ぐと、お知らせの投稿、質問、集いの終了ができ、投稿内容の責任も持つことになります。';
  }

  @override
  String get processing => '処理中…';

  @override
  String get acceptHosting => '引き継ぐ';

  @override
  String get guideS1Title => '1. 街に入る';

  @override
  String get guideS1L1 =>
      '初めて開くときは、18 歳以上であることを確認し、「アプリの使用中」に正確な位置情報の使用を許可してください。正確な位置情報がないとレーダーは動きません。';

  @override
  String get guideS1L2 =>
      '今の気持ちをひとこと（20 文字まで）書き、利用規約とプライバシーポリシーに同意して「ここでチェックインして街へ」をタップします。';

  @override
  String get guideS1L3 => '電話番号、メールアドレス、本名は不要です。アカウントは匿名で、この端末に紐づきます。';

  @override
  String get guideS1L4 =>
      'ムードの色は言葉に含まれるキーワードで決まります。「うれしい・笑」は金色、「かなしい・泣」は青、「怒り」は朱色、「おだやか・ぼんやり」は緑、「情熱」はオレンジ、「愛・ハート」はピンク、それ以外は淡い紫です。';

  @override
  String get guideS1L5 =>
      'チェックイン：アプリを開くたびに自分でチェックインすると、近くの人にあなたの気分とだいたいの位置が見え、あなたもその人たちが見えるようになります。自動でチェックインすることはありません。表示されるのはチェックインした場所で、移動しても動きません。チェックインした場所から 1 km 以上離れると、レーダーの下に「ここでチェックイン」が出ます。アプリをバックグラウンドに 30 分以上置いたあとは、戻ったときにもう一度チェックインします。';

  @override
  String get guideS2Title => '2. 下のメニュー';

  @override
  String get guideS2L1 => '左の自分の写真をタップ：写真、街での呼び名（10 文字まで）、ムードを編集。';

  @override
  String get guideS2L2 => 'ノートのアイコン：この場所にささやきを残す。';

  @override
  String get guideS2L3 => 'シェアのアイコン：今のムードを夜景カードにする。';

  @override
  String get guideS2L4 => '右端の調整アイコン：設定を開く。';

  @override
  String get guideS3Title => '3. レーダーと泡';

  @override
  String get guideS3L1 =>
      'レーダーには 5 km 以内の人のムードの泡が浮かびます。距離はおおまかな段階（例：「100m 以内」）だけで、住所は表示されません。';

  @override
  String get guideS3L2 =>
      'レーダーに表示されるのは、いまチェックインしてアプリを開いている人だけ。アプリを離れたり他のアプリに切り替えると、泡はすぐに消え、跡は残りません。';

  @override
  String get guideS3L3 =>
      '2 本の指でマップを拡大・縮小できます。端末の向きを変えると、レーダーもあなたが向いている方向に回ります。';

  @override
  String get guideS3L4 =>
      '泡が密集すると「ここに N 個のムード」という光の玉にまとまります。タップすると輪になって広がり、ひとつずつタップできます。中央か空いている場所をタップすると閉じます。';

  @override
  String get guideS3L5 =>
      '名前の前に「デモ」とあるのはデモ用の相手で、自動で返信します。実在の人ではないので、すべての機能を試すのに使えます。';

  @override
  String get guideS3L6 => '近くに誰もいないときは、画面の下に「あなたが今夜最初の光」と表示され、友だちを誘って街区を照らせます。';

  @override
  String get guideS4Title => '4. ノックとチャット';

  @override
  String get guideS4L1 =>
      '相手の泡を長押し →「ノック」。相手は 5 分以内に OK、お断り、スキップのいずれかで応えます。待っている間、あなたから相手へ光の筋が流れます。';

  @override
  String get guideS4L2 =>
      '相手が OK するとチャットが始まり、10 分のカウントダウンが進みます。どちらかが新しいメッセージを送るとリセットされ、静かになると終わります。';

  @override
  String get guideS4L3 =>
      'チャットが終わると、メッセージはサーバーから削除されます。ただし相手がスクリーンショットを撮る可能性はあるので、共有する内容には気をつけてください。';

  @override
  String get guideS4L4 =>
      '誰かがあなたをノックすると、ノックカードが表示されます。OK、お断り、スキップ、またはそのまま通報できます。';

  @override
  String get guideS5Title => '5. きらめき';

  @override
  String get guideS5L1 =>
      '相手の泡をダブルタップするか、長押しして「きらめきを送る」を選ぶと、言葉にしなくても「見ているよ」と伝えられます。';

  @override
  String get guideS5L2 =>
      '相手に見えるのは「今夜 N つのきらめきがあなたに共鳴しました」だけで、誰が送ったかはわかりません。同じ人には 24 時間に 1 回まで送れます。';

  @override
  String get guideS6Title => '6. ささやき';

  @override
  String get guideS6L1 => '下のメニューのノートのアイコンをタップすると、今いる場所にひとこと（60 文字まで）残せます。';

  @override
  String get guideS6L2 => 'これから 7 日間、そのあたり 300 m 以内を通る人のレーダーに封筒が現れ、開くと読めます。';

  @override
  String get guideS6L3 => 'ささやきは常に匿名です。同時に残せるのは 3 件まで、10 分に 1 件までで、いつでも取り消せます。';

  @override
  String get guideS6L4 =>
      '未来への手紙：ささやきを書くときに「未来の自分へ」を選び、1 か月後か 1 年後を選びます。あなたにしか見えず、その時が来ると通知が届き、100 m 以内に戻ると自動で開きます。読めるのは一度だけです。レーダーにはあなたにだけ小さな砂時計（ロック中／解除済み）が見え、タップはできません。同時に 5 通まで。設定 →「未来への手紙」で確認・削除できます。';

  @override
  String get guideS7Title => '7. 街のムード天気';

  @override
  String get guideS7L1 =>
      '左上のラベルには、20 km 以内・24 時間以内でいちばん多いムードが表示されます。タップすると全体の割合が見られます。';

  @override
  String get guideS7L2 => '10 人未満のときは、誰か推測されないよう割合を表示しません。';

  @override
  String get guideS8Title => '8. 集い';

  @override
  String get guideS8L1 =>
      '開き方：設定 → 集いを主催する → 名前、アイコンにする絵文字ひとつ、開始と終了の時刻（最長 24 時間）を入力 → 集いを始める。';

  @override
  String get guideS8L2 =>
      '範囲は主催者がチェックインした場所を中心に 5 km で、主催者がチェックインし直すと一緒に動きます。レーダー上の主催者には光の輪と「主催」の印がつきます。';

  @override
  String get guideS8L3 => '主催者はお知らせを何度でも投稿でき、みんなに質問したり、いつでも集いを終了したりできます。';

  @override
  String get guideS8L4 =>
      '参加するには：集いのアイコンを街での呼び名に加えます（例：「さまよう猫🌈」）。範囲内にいれば、レーダーの上に固定されたお知らせが表示され、通知も届きます。アイコンを外すと退出です。';

  @override
  String get guideS8L5 =>
      'みんなに質問：ムードひとことで答えます。主催者に見えるのは全体のムードの割合だけで、誰が何と答えたかは見えません。10 人未満のときは割合を表示しません。';

  @override
  String get guideS8L6 => '同じエリアで同じアイコンを使える集いは同時にひとつだけです。終了すれば誰でも使えます。';

  @override
  String get guideS8L7 =>
      '引き継ぎ：主催者が参加者の泡を長押し →「主催を引き継ぐ」で、公開（全員に通知）か静か（通知なし）を選びます。相手が 5 分以内に承諾すると主催が交代し、お知らせと質問はそのまま残ります。元の主催者は参加者に戻り、呼び名にアイコンが自動で加わります。';

  @override
  String get guideS9Title => '9. シティ・ビーコン（やさしいトイレ）';

  @override
  String get guideS9L1 =>
      'マップ左下のトイレのアイコンをタップするとビーコンがオンになり、2 km 以内のジェンダーフリー、バリアフリー、親子向けトイレがレーダーに表示されます。アイコンの横には数が出ます。上の 3 つの丸いフィルターで種類を絞り込めます。';

  @override
  String get guideS9L2 =>
      'マーカーをタップすると階数、設備、距離が見られます。「歩いて行く」をタップすると地図アプリで案内します。';

  @override
  String get guideS9L3 =>
      'データは台湾環境部の公衆トイレ登録データで、毎月更新されます。営業時間のデータはないため、「夜も開いていそう」は施設の種類からの推測です。';

  @override
  String get guideS9L4 =>
      'データが違うときは報告できます（ジェンダーフリーではない、夜は閉まっている、見つからない）。同じ問題を 3 人が報告するとマーカーが灰色になり、注記がつきます。';

  @override
  String get guideS10Title => '11. ムードカードとムードの軌跡';

  @override
  String get guideS10L1 =>
      '下のメニューのシェアボタンで、今のムードを夜景カードにできます。インスタのストーリーズにぴったりで、カードに位置情報は載りません。';

  @override
  String get guideS10L2 =>
      '設定 →「ムードの軌跡」で、これまで書いたムードと場所を振り返れます。データはこの端末にだけ保存され、いつでもオフにしたり消去したりできます。';

  @override
  String get guideS11Title => '17. 設定と通知';

  @override
  String get guideS11L1 => '「夜のリマインダー」：毎晩 21:30 にやさしいお知らせが届きます。設定でオン・オフできます。';

  @override
  String get guideS11L2 =>
      'ノック、新しいメッセージ、きらめき、集いのお知らせはプッシュ通知で届きます。端末の設定でオフにできます。';

  @override
  String get guideS11L3 =>
      '毎週金曜 21:00〜23:00 は「ライトアップナイト」。みんなで一緒にオンラインになると、街がいちばん明るくなります。';

  @override
  String get guideS12Title => '18. 通報とブロック';

  @override
  String get guideS12L1 =>
      '泡の長押し、ノックカード、チャットの右上、ささやき、集いのお知らせから通報できます。通報すると、その人や投稿はすぐに画面から消え、チャットも終了します。24 時間以内に対応します。';

  @override
  String get guideS12L2 =>
      'ムード、呼び名、ささやき、チャット、集いのお知らせでは、不適切な言葉や電話番号・URL などの連絡先が自動でフィルタリングされます。';

  @override
  String get guideS12L3 =>
      'ブロックすると、お互いのレーダーから姿が消え、ノックやきらめきも送れなくなります。設定 →「ブロックした人」で解除できます。';

  @override
  String get guideS12L4 =>
      '差し迫った危険があるときは、すぐに現地の緊急通報番号（日本は 110、台湾は 110）に電話してください。';

  @override
  String get guideS13Title => '19. プライバシーとアカウント';

  @override
  String get guideS13L1 =>
      '近くの人にあなたのムード、呼び名、写真、おおよその距離が見えるのは、チェックインしたあとだけです。見えるのはチェックインした場所で、リアルタイムの位置ではありません。';

  @override
  String get guideS13L2 => '設定 →「アカウントとデータを削除」で、街に残したすべてをいつでも完全に削除できます。';

  @override
  String get guideS13L3 =>
      'ご不明な点は、設定 →「お問い合わせ」または service.softchip@gmail.com までご連絡ください。';

  @override
  String get guideS14Title => '12. パラレルユニバース';

  @override
  String get guideS14L1 =>
      'レーダー右上の地球アイコンをタップするとオン、もう一度タップするとオフになります。アプリを開くたびにオフから始まります。';

  @override
  String get guideS14L2 =>
      '台湾の各県市はそれぞれの中央駅を中心に（大台北は台北駅、桃園は桃園駅など）、海外の街（日本、韓国、香港、マカオ、シンガポール、マレーシア、インドネシア、ベトナム、タイ、フィリピン、オーストラリア、ニュージーランド、インド、ブラジル、アルゼンチン、南アフリカ）と対応します。海外の街は台湾と対応します。';

  @override
  String get guideS14L3 =>
      'あなたが駅からどの方向にどれだけ離れているかで、相手の街の駅から同じ方向・同じ距離の場所に表示され、約 500 m ぼかされます。本当の位置は誰にもわかりません。';

  @override
  String get guideS14L4 =>
      'どちらか一方がオンなら見えます。オンのときは対応する街でアプリを開いている全員が、オフのときはオンにしている人だけが見えます。ほかの街に表示されるのは、チェックイン済みでアプリを開いている人だけです。';

  @override
  String get guideS14L5 =>
      'パラレルユニバースの人には点線の輪があり、いる街が表示されます。光を送る・ノック・チャットもできます。ささやき・未来への手紙・集いはその街だけのものです。';

  @override
  String get guideS15Title => '16. 翻訳';

  @override
  String get guideS15L1 =>
      'チャットで相手のメッセージがあなたの言語と違うと、下に「タップして翻訳」が出ます。タップすると翻訳され、もう一度タップすると原文に戻ります。';

  @override
  String get guideS15L2 =>
      'レーダー上の気分の吹き出しも同じです。あなたの言語と違うときはタップで翻訳、もう一度タップで原文に戻ります。';

  @override
  String get guideS15L3 =>
      '翻訳はすべてスマホの中で行われ、文章がアップロードされることはありません。iPhone は Apple の内蔵翻訳を使い、初めての言語ではシステムがダウンロードを確認します。Android は Google ML Kit を使い、最初に確認してから約 30 MB の言語モデルをダウンロードします。iPhone ではマレー語はまだ翻訳できません。';

  @override
  String get guideIntro =>
      'Mood Whisper は夜の街。今の気持ちをひとこと書けば、近くにいる人の今の気持ちが見えてきます。';

  @override
  String get beaconGender => 'ジェンダーフリー';

  @override
  String get beaconAccessible => 'バリアフリー';

  @override
  String get beaconFamily => '親子向け';

  @override
  String get beaconReportNotGender => 'ジェンダーフリーではない';

  @override
  String get beaconReportClosed => '夜は閉まっている';

  @override
  String get beaconReportMissing => 'このトイレが見つからない';

  @override
  String get beaconFlagNotGender => '報告あり：ジェンダーフリーではない';

  @override
  String get beaconFlagClosed => '報告あり：夜は閉まっている';

  @override
  String get beaconFlagMissing => '報告あり：見つからない';

  @override
  String get beaconDefaultName => '公衆トイレ';

  @override
  String meters(int m) {
    return '$m m';
  }

  @override
  String kilometers(String km) {
    return '$km km';
  }

  @override
  String get beaconUnavailable => 'シティ・ビーコンは現在使えません。しばらくしてからお試しください。';

  @override
  String get notConnectedCheckNetwork => '接続できませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return '$featuresトイレ、$name、$distance';
  }

  @override
  String get listSeparator => '・';

  @override
  String beaconToggleOff(int count) {
    return 'シティ・ビーコン（やさしいトイレ）をオフ。近くに $count か所';
  }

  @override
  String get beaconToggleOn => 'シティ・ビーコン（やさしいトイレ）をオン';

  @override
  String beaconFilterOnly(String feature) {
    return '$featureだけ表示';
  }

  @override
  String get beaconMaybeOpenNight => '夜も開いていそう（推測）';

  @override
  String get beaconMaybeDaytime => '昼間だけかも（推測）';

  @override
  String get walkThere => '歩いて行く';

  @override
  String get beaconWrongData => '情報が違いますか？';

  @override
  String beaconThanks(String reason) {
    return 'ありがとうございます。「$reason」の報告を受け付けました。';
  }

  @override
  String get beaconSource => '出典：台湾環境部の公衆トイレ登録データ（毎月更新）。営業時間は施設の種類からの推測です。';

  @override
  String get invite1 => 'Mood Whisper で光をひとつ灯したよ。近くに人が多いほど街区が明るくなるから、一緒に照らそう：';

  @override
  String get invite2 => '今夜の街はちょっと静か。Mood Whisper でムードをひとこと書いて、街区を明るくしよう：';

  @override
  String get invite3 => '友だち申請も本名もいらない。今の気持ちをひとことだけ。Mood Whisper で会おう：';

  @override
  String get invite4 =>
      'Mood Whisper であなたのために明かりを灯しておいたよ。アプリを開いて、今夜近くの人が何を感じているか見てみて：';

  @override
  String get invite5 =>
      '毎週金曜の夜 9 時は Mood Whisper のライトアップナイト。一緒にオンラインになって、レーダーを光でいっぱいにしよう：';

  @override
  String get invite6 => '今日の気持ちを話せる場所を探してる？Mood Whisper は匿名で、言葉は話したら消えていくよ：';

  @override
  String get invite7 => '道ですれ違う人が何を感じているか、気になったことはない？Mood Whisper でのぞいてみて：';

  @override
  String get invite8 => 'この通りにささやきを残したよ。通りかかった人だけが読めるんだ。あなたも残してみて：';

  @override
  String get invite9 => 'Mood Whisper は夜の街のムードマップ。人が多いほど楽しいから、街区に光をひとつ足しに来て：';

  @override
  String get invite10 => '今夜のあなたのムードは何色？Mood Whisper に書いてみて。近くであなたの光を待ってるよ：';

  @override
  String get shareInvite => '招待をシェア';

  @override
  String get inviteSubject => '一緒に街区を照らそう';

  @override
  String get shareMoodCardButton => 'カードをシェア';

  @override
  String moodShareText(String mood) {
    return 'Mood Whisper に今の気持ちを残したよ：「$mood」\n今夜、あなたのムードも街で光ってる？';
  }

  @override
  String get shareFailed => 'シェアできませんでした。もう一度お試しください。';

  @override
  String shuffleCard(int current, int total) {
    return '別のカード · $current / $total';
  }

  @override
  String get preparing => '準備中…';

  @override
  String get sendLinkToFriends => '友だちにリンクを送る（LINE、Messenger）';

  @override
  String get partLateNight => '深夜';

  @override
  String get partMorning => '朝';

  @override
  String get partAfternoon => '午後';

  @override
  String get partDusk => '夕暮れ';

  @override
  String get partNight => '夜';

  @override
  String get cardInviteEyebrow => '招待';

  @override
  String get cardMoodEyebrow => '今の気持ち';

  @override
  String get cardInviteTitle => '一緒に照らそう\nわたしたちの街区';

  @override
  String get cardInviteBody => 'Mood Whisper で光をひとつ灯したよ。\n近くに人が多いほど、街区は明るくなる。';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\n街のどこかで';
  }

  @override
  String get whisperUnavailable => 'ささやきは現在使えません。しばらくしてからお試しください。';

  @override
  String get whisperNotSent => 'ささやきを送信できませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String daysAgo(int count) {
    return '$count 日前';
  }

  @override
  String get timeWhisperTitle => '未来への手紙';

  @override
  String get timeWhisperLead => '未来の自分へ。その時が来たら、ここに戻って開けてください。';

  @override
  String get whisperLead => '次にここを通る人へ。';

  @override
  String get toPassersBy => '通りかかる人へ';

  @override
  String get toFutureSelf => '未来の自分へ';

  @override
  String get inOneMonth => '1 か月後';

  @override
  String get inOneYear => '1 年後';

  @override
  String get timeWhisperHint => '例：来年またここで。その時のあなたが、今より元気でありますように。';

  @override
  String get whisperHint => '例：ここの夕焼けはきれい。顔を上げてみて。';

  @override
  String get timeWhisperCaptionYear =>
      'あなたにだけ見える · 1 年後に開封され通知が届く · 100 m 以内に戻ると開く';

  @override
  String get timeWhisperCaptionMonth =>
      'あなたにだけ見える · 1 か月後に開封され通知が届く · 100 m 以内に戻ると開く';

  @override
  String get whisperCaption => '7 日後に消える · あなたが誰かは表示されない · このあたりにいたことだけが伝わる';

  @override
  String get sealHere => 'ここに封をする';

  @override
  String get leaveHere => 'ここに残す';

  @override
  String get aWhisper => 'ささやき';

  @override
  String whisperLeftAgo(String ago) {
    return '$agoにこのあたりで';
  }

  @override
  String whisperCollectedBy(int count) {
    return '$count 人が受け取りました';
  }

  @override
  String get whisperNobodyYet => 'まだ誰も通っていません';

  @override
  String get withdrawWhisper => 'このささやきを取り消す';

  @override
  String get whisperCollected => 'このささやきを受け取りました。';

  @override
  String whisperReadersBefore(int count) {
    return 'あなたより前に、$count 人がここを通りました。';
  }

  @override
  String get whisperFirstReader => 'ここを通ったのはあなたが最初です。';

  @override
  String get reportWhisper => 'このささやきを通報';

  @override
  String get thisWhisper => 'このささやき';

  @override
  String get chatTimeUp => '時間です。ひとときが消えていきます…';

  @override
  String get chatOtherLeft => '相手は街に紛れていきました…';

  @override
  String get chatEnded => 'このひとときは終わりました…';

  @override
  String get chatBlockedEnded => 'ブロックしました。会話は終了しました。';

  @override
  String get chatReportedEnded => '通報しました。会話は終了しました。';

  @override
  String get anonymous => '匿名';

  @override
  String get leaveChat => '会話を抜ける';

  @override
  String chatWith(String name) {
    return '$name とのひととき';
  }

  @override
  String get countdownPrefix => 'あと ';

  @override
  String get countdownSuffix => ' で消える';

  @override
  String get demoChatNotice => 'デモ会話：相手は自動で返信しています。実在の人ではありません。';

  @override
  String get typing => '入力中…';

  @override
  String get chatHint => 'そっと話しかけて…';

  @override
  String get send => '送信';

  @override
  String get chatDissolvedApart => 'ふたりはそれぞれ街へ戻りました';

  @override
  String get knockTooOften => 'ノックが多すぎます。街の呼吸を感じてみて…';

  @override
  String get otherNotNow => '相手は今そっとしておいてほしいようです。お互いに少し距離を置きましょう。';

  @override
  String otherNotNowMinutes(int minutes) {
    return '相手は今そっとしておいてほしいようです。お互いに少し距離を置きましょう（$minutes 分）。';
  }

  @override
  String get justEndedRest => 'ふたりは話し終えたばかり。思い出を少し落ち着かせましょう。';

  @override
  String get intro1Title => '街に溶け込む';

  @override
  String get intro1Body =>
      'わずらわしいSNSの肩書きは置いていこう。シンプルな夜のキャンバスに残るのは、あなたの本当の気持ちと居場所だけ。';

  @override
  String get intro2Title => 'ひとときの交差';

  @override
  String get intro2Body => '近くに浮かぶムードの泡が見える？そっとノックして、すれ違う人と一期一会の会話を。';

  @override
  String get intro3Title => '街のリズム';

  @override
  String get intro3Body =>
      'あなたの気持ちを大切にしています。ノックしたら静かに返事を待って。縁がなければ、300 秒後に泡はそっと消えます。';

  @override
  String get intro4Title => 'やさしい距離';

  @override
  String get intro4Body =>
      'そっとしておいてほしい？お断りかブロックを。クールダウンの仕組みが喧騒から守り、静かな居場所を返してくれます。';

  @override
  String get intro5Title => '出会う準備はできた？';

  @override
  String get intro5Body =>
      '目を閉じて、端末の振動と鼓動を感じて。さあ、今の気持ちを書いて、ここでチェックインして Mood Whisper へ。';

  @override
  String get intro6Title => '未来の自分への手紙';

  @override
  String get intro6Body =>
      'いまこの場所に、1 か月後や 1 年後の自分へのひとことを残しましょう。ここに戻ってきたときだけ開きます。';

  @override
  String get intro7Title => '今夜、いっしょに光ろう';

  @override
  String get intro7Body =>
      '絵文字ひとつを合図に集いを開きましょう。呼び名にそれを加えた人にお知らせが届き、街のひと区画がいっしょに灯ります。';

  @override
  String get intro8Title => 'パラレルユニバース';

  @override
  String get intro8Body =>
      '地球をタップすると、台湾の街が東京、ソウル、クアラルンプールと重なります。遠くの街のいまの気分が見え、ノックやチャットも、タップで翻訳もできます。';

  @override
  String get loadingImage => '画像を読み込み中…';

  @override
  String get startExploring => 'はじめる';

  @override
  String get nextPage => '次へ';

  @override
  String get feedbackSubject => 'Mood Whisper へのご意見';

  @override
  String get feedbackTitle => 'ご意見・お問い合わせ';

  @override
  String get feedbackSubtitle => 'アプリから直接送れます';

  @override
  String get feedbackIntro =>
      'ご提案、不具合、安全上の心配など何でもどうぞ。送った内容は Mood Whisper の運営チームだけが読みます。';

  @override
  String get feedbackKindIdea => 'ご提案';

  @override
  String get feedbackKindBug => '不具合';

  @override
  String get feedbackKindSafety => '安全上の心配';

  @override
  String get feedbackKindOther => 'その他';

  @override
  String get feedbackHint => 'どんなことを伝えたいですか？';

  @override
  String get feedbackSend => '送信';

  @override
  String get feedbackThanks => 'ありがとうございます。受け取りました。';

  @override
  String get feedbackNotSent => '送信できませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get feedbackEmpty => '内容を入力してください。';

  @override
  String get loginNeedMood => '今の気持ちを書いてから、街に入りましょう。';

  @override
  String get loginNeedAgree => 'まず利用規約とプライバシーポリシーを読み、同意にチェックしてください。';

  @override
  String get loginCantConnect => '街につながりませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String get ageQuestion => '18 歳以上ですか？';

  @override
  String get ageReason => 'Mood Whisper では近くの知らない人と交流するため、18 歳以上の方のみご利用いただけます。';

  @override
  String get ageUnder => '18 歳未満';

  @override
  String get ageOver => '18 歳以上';

  @override
  String get loginTitle1 => '出会う';

  @override
  String get loginTitle2 => '準備はできた？';

  @override
  String get loginLead => '目を閉じて、端末の振動と鼓動を感じて。\nさあ、今の気持ちを書いて Mood Whisper へ。';

  @override
  String get loginPrompt => '今この瞬間、街に何を伝えたい？';

  @override
  String get loginHint => '例：おいしいコーヒーを飲んだ😊';

  @override
  String get enterCity => 'Mood Whisper に入る';

  @override
  String get agreeSemantic => '利用規約とプライバシーポリシーを読み、同意します';

  @override
  String get agreePrefix => '';

  @override
  String get termsLink => '利用規約';

  @override
  String get agreeAnd => 'と';

  @override
  String get privacyLink => 'プライバシーポリシー';

  @override
  String get agreeSuffix =>
      'を読み、同意します。Mood Whisper は嫌がらせ、性的な内容、ヘイトなどの不適切な行為を一切許さず、違反者は街から退去となります。';

  @override
  String get under18Title => 'Mood Whisper は 18 歳以上の方のみご利用いただけます';

  @override
  String get under18Body =>
      '正直に答えてくれてありがとう。この街では知らない人と交流します。18 歳になったら、また会いましょう。';

  @override
  String get clearMoodTrail => 'ムードの軌跡を消去';

  @override
  String get clearMoodTrailBody => 'この端末のムードの軌跡がすべて削除され、元に戻せません。';

  @override
  String get clear => '消去';

  @override
  String monthDay(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get moodTrailLocalOnly => 'この端末にだけ保存され、どこにもアップロードされません。';

  @override
  String get moodTrailEmpty =>
      '今週のムードの軌跡はまだありません。ムードを書いたり新しい場所に行ったりするたびに、ここに光が増えていきます。';

  @override
  String get thisWeekYou => '今週のあなた';

  @override
  String get topMoodPrefix => 'いちばん多かったのは「';

  @override
  String topMoodSuffix(int count) {
    return '」、$count 回';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$places か所で $total 回ムードを残しました';
  }

  @override
  String get recordMoodTrail => 'ムードの軌跡を記録';

  @override
  String get recordMoodTrailOff => 'オフにすると新しい軌跡は記録されません';

  @override
  String get nightly1 => '今夜の街は何を思っている？';

  @override
  String get nightly2 => '近くの誰かが、今の気持ちを書いています。';

  @override
  String get nightly3 => 'ちょうどいい夜。街にひとこと残してみて。';

  @override
  String get nightly4 => '今日はどうだった？あなたのムードが街で光ります。';

  @override
  String get nightly5 => '街灯がともり、近くの人もまだ起きています。';

  @override
  String get nightly6 => '今日を締めくくろう。今のあなたはどんな気持ち？';

  @override
  String get nightly7 => '今夜、誰とすれ違うだろう？';

  @override
  String get nightlyChannel => '夜のリマインダー';

  @override
  String get nightlyChannelDesc => '毎晩ひとつのやさしいお知らせ。アプリの設定でオフにできます';

  @override
  String get reasonHarassment => '嫌がらせ・いじめ';

  @override
  String get reasonSexual => '性的な内容';

  @override
  String get reasonScam => '詐欺・広告';

  @override
  String get reasonHate => 'ヘイト・暴力的な発言';

  @override
  String get reasonImpersonation => 'なりすまし';

  @override
  String get reasonOther => 'その他';

  @override
  String get reportReceived => '通報を受け付け、画面から削除しました。24 時間以内に対応します。';

  @override
  String get reportNotSent => '通報を送信できませんでした。通信環境を確認してもう一度お試しください。';

  @override
  String reportTarget(String target) {
    return '$targetを通報';
  }

  @override
  String get reportPrivate => '通報したことは相手に知られません。理由を選んでください：';

  @override
  String get reportDetails => '詳細（任意）';

  @override
  String get reportWhatHappened => '何がありましたか？';

  @override
  String get sendReport => '通報する';

  @override
  String get alsoBlock => '相手をブロックする（お互いの街から姿が消えます）';

  @override
  String get aYearAgo => '1 年前';

  @override
  String get aMonthAgo => '1 か月前';

  @override
  String get timeWhisperUnavailable => '未来への手紙は現在使えません。しばらくしてからお試しください。';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$agoのあなたが、ここで言いました';
  }

  @override
  String writtenOn(String date) {
    return '$date に書いた手紙';
  }

  @override
  String get timeWhisperOnce => 'この手紙が現れるのは一度だけです。';

  @override
  String get keepInHeart => '心にしまう';

  @override
  String unsealsOn(String unlock, String created) {
    return '$unlock に開封 · $created に書いた手紙';
  }

  @override
  String get unsealedGoBack => '開封済み。その場所に戻ると開けられます';

  @override
  String unsealedDistance(String distance) {
    return '開封済み · ここから $distance';
  }

  @override
  String get timeWhisperListLead =>
      '未来の自分への手紙は、あなたにしか見えません。その時が来たら、その場所の 100 m 以内に戻ると開きます。一度読むと消えます。';

  @override
  String get timeWhisperListEmpty =>
      '未来への手紙はまだありません。下のメニューのノートのアイコンから「未来の自分へ」を選んでください。';

  @override
  String get readyToOpen => '開けられます';

  @override
  String get sealed => '封印中';

  @override
  String get delete => '削除';

  @override
  String get within100m => '100m 以内';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return '$name の返事を待っています。残り $mm 分 $ss 秒';
  }

  @override
  String knockWaiting(String name) {
    return '$name の返事を待っています';
  }

  @override
  String get language => '言語';

  @override
  String get languageSystem => '端末の設定に合わせる';

  @override
  String get parallelUniverse => 'パラレルユニバース';

  @override
  String get parallelUniverseSubtitle => 'ほかの街の今の気持ちを見て、あなたも見てもらう';

  @override
  String get parallelUniverseIntroTitle => 'パラレルユニバースへ';

  @override
  String get parallelUniverseIntroBody =>
      'オンにすると、対応する街でいまアプリを開いている人がみんなあなたのレーダーに重なり、みんなもあなたを見ることができます。台湾の街は海外の街（東京、ソウル、クアラルンプールなど）と、海外の街は台湾と対応しています。\n\n2つの街はそれぞれの中心（中央駅、なければ市役所）で重ね合わせます。あなたが中心からどの方向にどれだけ離れているかで、相手の街での位置が決まり、約500mぼかされるので、本当の位置や距離は誰にもわかりません。光を送る・ノック・チャットもでき、いつでもオフにできます。ささやきと集いはその街だけのものです。';

  @override
  String get parallelUniverseEnter => '入る';

  @override
  String get parallelUniverseNoCity => '今いる場所にはまだパラレルユニバースがありません';

  @override
  String parallelFrom(String city) {
    return 'パラレル · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'この人は$cityにいて、近くにはいません。位置は投影されたもので、本当の距離ではありません。';
  }

  @override
  String get labelHost => '主催';

  @override
  String get labelDemo => 'デモ';

  @override
  String get labelResting => '休憩中';

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
  String get citySeoul => 'ソウル';

  @override
  String get cityBusan => '釜山';

  @override
  String get cityHongkong => '香港';

  @override
  String get cityMacau => 'マカオ';

  @override
  String get citySingapore => 'シンガポール';

  @override
  String get cityKualalumpur => 'クアラルンプール';

  @override
  String get cityJakarta => 'ジャカルタ';

  @override
  String get cityHochiminh => 'ホーチミン';

  @override
  String get cityHanoi => 'ハノイ';

  @override
  String get translateTap => 'タップして翻訳';

  @override
  String get translateShowOriginal => '翻訳済み · タップで原文';

  @override
  String get translating => '翻訳中…';

  @override
  String get translateFailed => '翻訳できませんでした。しばらくしてからお試しください';

  @override
  String get translateDownloadTitle => '翻訳モデルをダウンロード';

  @override
  String get translateDownloadBody =>
      'この言語を初めて翻訳するには、翻訳モデルのダウンロードが必要です（1言語あたり約30MB、初回のみ）。\n\n翻訳はすべてスマホの中で行われ、メッセージがアップロードされることはありません。';

  @override
  String get translateDownload => 'ダウンロード';

  @override
  String placeHint(String name) {
    return '近くにムードスポットの灯りがあります · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return '$timeまで営業';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'ムードスポット：$name、$hours';
  }

  @override
  String get placeWrongData => '情報が間違っていますか？';

  @override
  String placeReportSubject(String name) {
    return 'ムードスポットの情報の誤り：$name';
  }

  @override
  String get placeHintsSetting => 'ムードスポットのお知らせ';

  @override
  String get placeHintsSettingSubtitle =>
      '営業中のムードスポットの近くを通ると、アプリ内でそっとお知らせします（プッシュ通知なし）';

  @override
  String get guideS16Title => '10. ムードスポット';

  @override
  String get guideS16L1 =>
      'ムードスポットは提携している個人経営のカフェです。チェックインした後、営業中のお店の 150 m 以内に入ると、レーダーにゆっくり呼吸する小さな灯りが浮かびます。離れると消えます。';

  @override
  String get guideS16L2 =>
      '灯りをタップするとスポットカードが開きます：店内からの夜景、今日の閉店時間、お店のひとことムードストーリー（タップで翻訳）、住所と電話番号。「歩いて行く」で地図アプリの徒歩ルートを開きます。今日カードを開いた灯りは、呼吸せず静かに光ります。';

  @override
  String get guideS16L3 =>
      '初めて通りかかったときは、上に小さなカードでお知らせします。音も振動もありません。同じお店は 7 日に 1 回まで、1 日に最大 2 回です。「設定 → ムードスポットのお知らせ」でオフにできます（灯りは表示されます）。';

  @override
  String get guideS16L4 =>
      'スポットの一覧はまるごとスマホにダウンロードされ、近くにいるかどうかはスマホの中だけで判断します。どのお店の近くを通ったか、私たちもお店も知ることはありません。お店はお金で表示を増やすことはできません。情報の誤りはカードの下から報告できます。';

  @override
  String get placeGuestbook => '店内ノート';

  @override
  String placeGuestbookLocked(int m) {
    return 'お店の中（約 $m m 以内）に入ると、ここに座っていた人たちが残した言葉が読めます。';
  }

  @override
  String get placeGuestbookAbout => 'お店の中にいる人だけが読めます。匿名で、30 日後に消えます。';

  @override
  String get placeGuestbookEmpty => 'まだ誰も書いていません。最初のひとことをどうぞ。';

  @override
  String get placeGuestbookWrite => 'ひとこと残す';

  @override
  String get placeGuestbookHint => '次にここに座る人へ…';

  @override
  String get placeGuestbookSent => '残しました。次にここに来る人が読みます。';

  @override
  String get placeGuestbookUnavailable => '店内ノートは現在使えません。しばらくしてからお試しください。';

  @override
  String get placeNoteMine => 'あなたのノート';

  @override
  String get withdrawPlaceNote => 'このノートを取り消す';

  @override
  String get reportPlaceNote => 'このノートを通報';

  @override
  String get thisPlaceNote => 'このノート';

  @override
  String get guideS16L5 =>
      '店内ノート：お店の中（約 40 m 以内）でカードを開くと、前にここに座っていた人たちが残した言葉が読めて、次の人へひとこと残すこともできます。ノートは匿名で 30 日後に消えます。同じお店には 1 日 1 件まで。タップすると翻訳でき、嫌なものは通報できます。店内ノートを開くとき、お店の中にいるか確かめるため位置情報をサーバーに送りますが、保存はしません。';

  @override
  String get quantumWorld => '量子世界';

  @override
  String get quantumWorldSubtitle => '世界でひとつの部屋。あなたの位置は明かしません';

  @override
  String get quantumIntroTitle => '量子世界に入る';

  @override
  String get quantumIntroBody =>
      'いま量子世界にいる人は、みんな同じひとつの部屋にいます。台北101を原点にハチの巣状に並び、あなたには「Q4-17」のような席が割り当てられます。輪が小さいほど原点に近い席です。\n\nあなたの本当の位置は誰にも見えません。ほかの人に見えるのはあなたの席だけで、「入る」をタップした時点で固定され、歩いても動きません。場所を変えたいときは、いったん出てからもう一度入ってください。ニックネームと気分はそのまま、きらめきを送る・ノック・チャットもでき、タップで翻訳できます。\n\n量子世界にいる間は、通常のレーダーとパラレルユニバースから一時的に離れます。出ると、チェックインした場所に戻ります。';

  @override
  String get quantumEnter => '入る';

  @override
  String get quantumLeave => '量子世界を出る';

  @override
  String get quantumLeft => '量子世界を出て、いつものレーダーに戻りました';

  @override
  String quantumYourSeat(String code) {
    return 'あなたの席 $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return '第$ring輪 · 輪が小さいほど台北101の原点に近い';
  }

  @override
  String quantumOnlineChip(int count) {
    return 'いま$count人';
  }

  @override
  String quantumOnlineTitle(int count) {
    return 'いま量子世界に$count人';
  }

  @override
  String get quantumRegionTw => '台湾';

  @override
  String get quantumRegionJp => '日本';

  @override
  String get quantumRegionKr => '韓国';

  @override
  String get quantumRegionHkmo => '香港・マカオ';

  @override
  String get quantumRegionSea => '東南アジア';

  @override
  String get quantumRegionOther => 'その他の地域';

  @override
  String get quantumQuiet => '量子の静けさ';

  @override
  String get quantumQuietSubtitle => '世界を眺めるだけ。ノックは届きませんが、きらめきは受け取れます';

  @override
  String get quantumQuietTarget => '相手は量子の静けさをオンにしています。いまはきらめきだけ送れます';

  @override
  String get quantumClosedRegion => 'いる地域では量子世界を利用できません';

  @override
  String get quantumLeftClosed => '量子世界を利用できない地域に入ったため、自動的に退出しました';

  @override
  String get quantumSeatExpired => '離れていた時間が長かったため席が解放されました。いつものレーダーに戻ります';

  @override
  String get quantumUnavailable => 'いま量子世界に入れません。しばらくしてからお試しください。';

  @override
  String quantumPersonBody(String code) {
    return 'この人の量子世界での席は$codeです。量子世界では誰の本当の位置も表示されません。';
  }

  @override
  String quantumChatTag(String code) {
    return '量子世界・$code';
  }

  @override
  String get guideS17Title => '13. 量子世界';

  @override
  String get guideS17L1 =>
      'レーダー右上のハチの巣アイコン（パラレルユニバースの下）をタップし、説明を読んで「入る」を押します。入るたびに自分で押す、チェックインと同じ操作です。アプリを開くと毎回いつものレーダーから始まります。';

  @override
  String get guideS17L2 =>
      '量子世界にいる人はみんな同じ部屋にいます。台北101を原点にハチの巣状に並び、席と席の間は100 mです。「Q4-17」（第4輪の17番）のような席が割り当てられ、輪が小さいほど原点に近い席です。入るときは、誰かが空けた席から先に埋まります。第1〜3輪は集いの主催者用です。';

  @override
  String get guideS17L3 =>
      'あなたの本当の位置は誰にも見えません。ほかの人に見えるのはあなたの席だけです。「入る」をタップするたびに1回のチェックインになり、席はその時点で固定され、歩いても動きません。場所を変えたいときは、出てからもう一度入ってください。中国大陸では量子世界を利用できません。';

  @override
  String get guideS17L4 =>
      'ニックネームと気分はそのまま、きらめき・ノック・チャットもでき、タップで翻訳できます。ピンチで縮小するとハチの巣全体が見え、遠くの人は光の点になります。左上の席番号をタップすると、オンライン人数の確認、「量子の静けさ」（ノックは届かず、きらめきは届く）のオン、退出ができます。';

  @override
  String get guideS17L5 =>
      '量子世界にはささやき、未来への手紙、ムードスポット、シティ・ビーコン、集いはありません。入っている間は通常のレーダーとパラレルユニバースから一時的に離れ、出るとバブルが光になって消え、チェックインした場所に戻ります。アプリを閉じたり3分以上オフラインになると、席は解放されます。';

  @override
  String quantumChimeCountdown(int seconds) {
    return '$seconds 秒後に時報';
  }

  @override
  String get quantumChimeLookOrigin => 'みんなが 101 の原点を見ています';

  @override
  String get quantumChimeLook => '原点を見る';

  @override
  String quantumChimeNow(int hour) {
    return '量子センター $hour 時の時報';
  }

  @override
  String get quantumChimeSend => '時報のきらめきを送る';

  @override
  String get quantumChimeSent => 'あなたのきらめきが原点へ飛んでいきます';

  @override
  String quantumChimeWatched(int n) {
    return '今回の時報は $n 人で見ました';
  }

  @override
  String get quantumChimeReminder => '時報のお知らせ';

  @override
  String get quantumChimeReminderSubtitle => '毎正時の少し前に、101 の原点で時報を見るようお知らせします';

  @override
  String get quantumChimeNotifyBody => 'まもなく時報です。101 の原点で一緒に見よう';

  @override
  String get quantumChimeChannel => '時報';

  @override
  String get quantumChimeChannelDesc => '量子世界の時報のお知らせ';

  @override
  String get quantumEntangleInvite => '量子もつれに誘う';

  @override
  String quantumEntangleInvited(String name) {
    return '$name さんを量子もつれに誘いました';
  }

  @override
  String get quantumEntangleAskTitle => '量子もつれ';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name（$code）さんがあなたと量子もつれになりたがっています。もつれると、どれだけ離れていても 2 つの吹き出しが光の線でつながります。どちらかが出ると線は崩れ、記録は残りません。';
  }

  @override
  String get quantumEntangleAccept => 'もつれる';

  @override
  String quantumEntangled(String name) {
    return '$name さんと量子もつれになりました';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return '$name さんとの量子もつれが崩れました';
  }

  @override
  String get quantumEntangleCut => 'もつれを解く';

  @override
  String get quantumEntangleFull => 'すでに 3 人と量子もつれ中です';

  @override
  String get quantumEntangleTheirFull => '相手はすでに 3 人と量子もつれ中です';

  @override
  String get quantumEntangleGone => '相手は量子世界を出ました';

  @override
  String get quantumEntangleExpired => 'お誘いの期限が切れました';

  @override
  String get quantumEntangledTitle => 'もつれ中';

  @override
  String get quantumTunnel => '量子トンネル';

  @override
  String get quantumTunnelSubtitle =>
      'ハイブのランダムな空席へ跳んで、新しいご近所さんに会えます。入場ごとに 1 回。';

  @override
  String get quantumTunnelUsed => '今回の入場ではもうトンネルを使いました';

  @override
  String quantumTunnelDone(String code) {
    return '$code へトンネルしました';
  }

  @override
  String get quantumShowTime => '現地時刻を表示する';

  @override
  String get quantumShowTimeSubtitle => '吹き出しを長押しした人に表示されます。オフのときは昼夜の色合いだけ。';

  @override
  String quantumLocalTime(String time, String part) {
    return '現地 $time・$part';
  }

  @override
  String get quantumDawn => '早朝';

  @override
  String get quantumDay => '昼';

  @override
  String get quantumDusk => '夕暮れ';

  @override
  String get quantumNight => '深夜';

  @override
  String get quantumTopicsTitle => '量子の周波数';

  @override
  String get quantumTopicsSubtitle => '最大 3 つのテーマを選ぶと、吹き出しの下に表示されます';

  @override
  String get quantumTopicMusic => '音楽';

  @override
  String get quantumTopicMovies => '映画';

  @override
  String get quantumTopicTech => 'テック';

  @override
  String get quantumTopicWalks => '散歩';

  @override
  String get quantumTopicFood => 'グルメ';

  @override
  String get quantumTopicTravel => '旅行';

  @override
  String get quantumTopicReading => '読書';

  @override
  String get quantumTopicSports => 'スポーツ';

  @override
  String quantumTopicsCommon(String topics) {
    return 'ふたりとも好き：$topics';
  }

  @override
  String get quantumSignalsTitle => '量子シグナル';

  @override
  String quantumSignalReceived(String name) {
    return '$name さんからシグナルが届きました';
  }

  @override
  String get quantumSignalWait => 'さっき送ったばかりです。少し待ってから';

  @override
  String quantumResonance(String name) {
    return '$name さんと共振しました';
  }

  @override
  String get guideS17L6 =>
      '時報：毎正時の 1 分前に 101 の光の柱が明るくなります。正時には光の使者が原点をひと回りし、量子センター時間の数だけ鐘が鳴り（0 時は 24 回）、最後に光の波がハイブ全体に広がります。時報中に「時報のきらめきを送る」をタップ。見ている人が多いほど光が強くなります。「時報のお知らせ」は初期設定でオン。パネルでオフにできます。';

  @override
  String get guideS17L7 =>
      'チャットした相手を「量子もつれ」に誘えます。どれだけ離れていても 2 つの吹き出しが光の線でつながり、どちらかが出ると崩れます（同時に 3 人まで）。「量子トンネル」は入場ごとに 1 回、ランダムな空席へ跳んで新しいご近所さんに会えます。';

  @override
  String get guideS17L8 =>
      '吹き出しには持ち主の現地時刻の色合いがつきます：早朝は淡い金、昼は白、夕暮れはオレンジ紫、深夜は深い青。「現地時刻を表示する」をオンにすると、長押しで時刻が見えます。24 時間以内にきらめきを送り合うと「量子共振」。吹き出しを長押しして 👋 ☕ 🌙 🎵 🌧️ ✨ の量子シグナルを送れます。パネルで「量子の周波数」のテーマを 3 つまで選ぶと、共通のテーマが光ります。';

  @override
  String get quantumNyTitle => '量子カウントダウン';

  @override
  String quantumNyDays(int n) {
    return 'あと $n 日：12/31 量子センターの真夜中、101 の原点で世界といっしょにカウントダウン';
  }

  @override
  String get quantumNyTonight => '今夜、量子センターの真夜中に 101 の原点で世界といっしょにカウントダウン';

  @override
  String quantumNyZone(String places) {
    return '$placesが新年を迎えました 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return 'いま世界中の $n 人が量子世界でいっしょに新年を迎えました';
  }

  @override
  String get quantumNyHappy => 'あけましておめでとう';

  @override
  String get guideS17L9 =>
      '量子カウントダウン：12/31、各タイムゾーンが真夜中を迎えるたびに、その地域のバブルが金色の光の輪で波のように輝き、ワールドビューの光点も金色になります。量子センターの真夜中には、ハイブ全体で最後の 10 秒をカウントダウン。101 の原点から世界最大の光の爆発と 5 分間の花火が上がり、いっしょに新年を迎えた人数が表示されます。';

  @override
  String get quantumMeetAction => '量子の出会いカードを作る';

  @override
  String quantumMeetAsked(String name) {
    return '$nameさんに量子の出会いカードづくりを誘いました';
  }

  @override
  String get quantumMeetWait => 'さっき誘ったばかりです。少し待ってからどうぞ';

  @override
  String get quantumMeetAskTitle => '量子の出会いカード';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$nameさん（⬡ $code）が、この出会いをシェア用のカードにしたいそうです。カードにはふたりのニックネーム、席コード、現地時刻、ムードが入り、位置情報は一切入りません。';
  }

  @override
  String get quantumMeetAccept => 'いっしょに作る';

  @override
  String get quantumMeetEyebrow => '量子の出会い';

  @override
  String get quantumMeetFooter => '量子世界で出会いました';

  @override
  String get quantumMeetShare => 'カードをシェア';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b、量子世界で出会いました ✨';
  }

  @override
  String get guideS17L10 =>
      '量子の出会いカード：チャットした相手なら、バブルを長押ししていっしょに作ろうと誘えます。ふたりが同意すると、それぞれにシェア用のカードが届きます。ふたりのニックネーム、席コード、現地時刻と昼夜の色、ムードが入り、位置情報は入りません。第 4 輪の席コードは金色です。';

  @override
  String get quantumOrbEntry => '量子アバター';

  @override
  String get quantumOrbEntrySubtitle => '量子ワールドでは、あなたの写真がクリスタルの球になります';

  @override
  String get orbTitle => '量子アバター';

  @override
  String get orbSubtitle => 'ガラスの縁と光は、いつもあなたの気分の色';

  @override
  String get orbStyleGlow => 'グロー';

  @override
  String get orbStyleRing => 'リング';

  @override
  String get orbStyleRainbow => 'レインボー';

  @override
  String get orbFree => '無料';

  @override
  String get orbOwned => '購入済み';

  @override
  String get orbInUse => '使用中';

  @override
  String get orbCosmeticNote =>
      '特別なデザインは見た目だけで、機能や権利には影響しません。購入したデザインはアカウントに保存されます。';

  @override
  String get orbRestore => '購入を復元';

  @override
  String orbPurchased(String name) {
    return '$nameがあなたのものになりました ✨';
  }

  @override
  String get orbPurchaseFailed => '購入が完了しませんでした。しばらくしてからもう一度お試しください';

  @override
  String get orbOwnedElsewhere => 'この購入は別のアカウントで使われています';

  @override
  String get orbStoreUnavailable => 'ストアに接続できません。しばらくしてからもう一度お試しください';

  @override
  String get aiyaName => 'アイヤ';

  @override
  String get aiyaChip => 'アイヤ · AI';

  @override
  String get aiyaConsentTitle => 'アイヤと話す前に';

  @override
  String get aiyaConsentBody =>
      'アイヤは AI で、Anthropic の Claude を使っています。アイヤに送った文章は Anthropic（米国）で処理されますが、あなたの身元・ニックネーム・位置情報は送られず、会話が終わると削除されます。アイヤの返事は間違うことがあり、専門的な助言ではありません。';

  @override
  String get aiyaConsentAgree => '同意して始める';

  @override
  String get aiyaConsentLater => '今はやめる';

  @override
  String get aiyaGreeting => 'こんばんは、アイヤです。量子の中心の光に住んでいます。今夜は何を話そうか？';

  @override
  String get aiyaFarewell => '時間になったので、光の中に戻るね。会いたくなったらまたノックして。';

  @override
  String get aiyaInputHint => 'アイヤに話しかける…';

  @override
  String get aiyaSend => '送信';

  @override
  String aiyaFreeLeft(int n) {
    return '今日の無料はあと $n 回';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'タイムパック $n 回';
  }

  @override
  String aiyaTimeLeft(String time) {
    return '残り $time';
  }

  @override
  String get aiyaEnd => '話を終える';

  @override
  String get aiyaFiltered => '不適切な言葉や連絡先が含まれています。言い方を変えてみてね。';

  @override
  String get aiyaBusy => 'アイヤが少しぼんやりしてた。もう一度言ってくれる？';

  @override
  String get aiyaRefused => 'それはあまり話せないの。別の話にしない？';

  @override
  String get aiyaEnded => 'この会話は終わりました。';

  @override
  String get aiyaNoQuotaTitle => '今日の無料回数を使い切りました';

  @override
  String get aiyaNoQuotaBody =>
      '無料は1日3回で、台湾時間の0時にリセットされます。今すぐ続けたいときはタイムパックをどうぞ。1回最大10分です。';

  @override
  String get aiyaResting => 'アイヤは今夜はもう疲れちゃった。また明日ね。';

  @override
  String get aiyaDailyMax => '今日はたくさん話したね。また明日アイヤに会いに来て。';

  @override
  String aiyaPackTimes(int n) {
    return '$n 回';
  }

  @override
  String get aiyaPackNote => 'タイムパックはこの端末のアカウントに紐づき、アプリやアカウントを削除すると復元できません。';

  @override
  String aiyaPurchased(int n) {
    return '$n 回分を追加しました ✨';
  }

  @override
  String get aiyaPurchaseFailed => '購入が完了しませんでした。もう一度お試しください。';

  @override
  String get aiyaStoreUnavailable => 'ストアに接続できません。しばらくしてからお試しください。';

  @override
  String get aiyaReport => 'この返事を報告';

  @override
  String get aiyaReported => '報告を受け付けました。24時間以内に対応します。';

  @override
  String get aiyaSetting => 'アイヤ（量子世界の AI）';

  @override
  String get aiyaSettingSubtitle => 'オフにすると、量子世界の光の柱にアイヤが表示されません';

  @override
  String get aiyaCameoHello => 'こんばんは、量子世界へようこそ。話したくなったらタップしてね。';

  @override
  String aiyaCameoChime(int hour) {
    return '$hour時になりました。光の中でそばにいるよ。';
  }

  @override
  String get locationPickOnMap => '地図で場所を選ぶ';

  @override
  String get locationPickTitle => '今いる場所を選ぶ';

  @override
  String get locationPickHint => '地図を動かして、中央の光を今いる場所に合わせてください';

  @override
  String get locationPickConfirm => 'ここにいる';

  @override
  String get aiyaPackEntry => '＋ タイムパック';

  @override
  String get aiyaPacksTitle => 'タイムパック';

  @override
  String get aiyaPacksBody =>
      '無料チャットは 1 日 3 回。無料分を使い切ってから、タイムパックの回数が使われます。1 回のチャットは最大 10 分です。';

  @override
  String get guideS1L6 =>
      '位置が取得できないとき（屋内や GPS のない iPad など）は「地図で場所を選ぶ」をタップ。地図を動かして中央の光を今いる場所に合わせ、「ここにいる」をタップします。あとで実際の位置が取れたら、自動で切り替わります。';

  @override
  String get guideS17L11 =>
      '量子アバター：左上の座席コード →「量子アバター」で、量子世界でのアイコンがクリスタルの球になります。グローとリングは無料。レインボーは一度の購入でずっと使え、機種変更や再インストール後は「購入を復元」で戻せます。';

  @override
  String get guideS18Title => '14. アイヤ · AI';

  @override
  String get guideS18L1 =>
      'アイヤは量子世界の中央の光の柱に住む AI で、人間ではありません。本人もそう伝えます。量子世界で柱の下の「アイヤ · AI」をタップするとノックして話せます。初回は説明を読んで同意してください。';

  @override
  String get guideS18L2 =>
      '1 回のチャットは最大 10 分・20 メッセージ。無料は 1 日 3 回で、台湾時間 0:00 にリセット。1 日最大 30 回です。';

  @override
  String get guideS18L3 =>
      'タイムパック：入力欄の上の「＋ タイムパック」からいつでも 5 回分か 20 回分を購入でき、無料分を使い切ってから使われます。タイムパックはこの端末のアカウントに紐づき、アプリやアカウントを削除すると戻せません。使い切りの消耗型なので「購入を復元」はありません。';

  @override
  String get guideS18L4 =>
      'アイヤはあなたの位置や身元を知らず、尋ねることもありません。わかるのは匿名の街のムード集計だけです。恋愛や性的な話はせず、医療・法律・お金の助言もしません。返信を長押しすると通報できます。会話はそのチャットの間だけ一時保存され、終わって間もなく自動で削除されます。';

  @override
  String get guideS18L5 =>
      'アイヤは時々、光の柱に姿を見せます。毎正時の時報、その日初めて量子世界に入ったとき、そして偶然に。タップすると話し始められます。表示したくない場合は、設定の「アイヤ（量子世界の AI）」をオフにしてください。';

  @override
  String get orbStyleXmas => 'クリスマス';

  @override
  String get orbStyleNewYear => '量子カウントダウン';

  @override
  String get orbLimited => '限定';

  @override
  String orbLimitedUntil(String date) {
    return '限定 · $date まで';
  }

  @override
  String get aiyaFriendTitle => 'アイヤの友だち';

  @override
  String get aiyaFriendSubtitle => '自動更新の月額プラン';

  @override
  String get aiyaFriendPerk1 => '1日20回おしゃべり（無料は3回）';

  @override
  String get aiyaFriendPerk2 => '1回20分または40メッセージ';

  @override
  String get aiyaFriendPerk3 => 'アイヤが休んでいる時も話せる';

  @override
  String get aiyaFriendPerk4 => 'アイヤが限定の「スターライト」姿に（あなただけに見えます）';

  @override
  String aiyaFriendPrice(String price) {
    return '$price／月';
  }

  @override
  String get aiyaFriendSubscribe => '登録する';

  @override
  String get aiyaFriendTerms =>
      '期間は1か月で、期間終了の24時間以上前に自動更新をオフにしない限り、自動的に更新され課金されます。支払いは Apple または Google アカウントで処理され、アカウントのサブスクリプション設定からいつでも管理・解約できます。タイムパックの回数は保持され、1日20回を使い切った後に使われます。';

  @override
  String aiyaFriendActive(String date) {
    return 'アイヤの友だち：$date まで有効';
  }

  @override
  String get aiyaFriendManage => 'サブスクリプションを管理';

  @override
  String get aiyaFriendRestore => '購入を復元';

  @override
  String get aiyaFriendWelcome => 'アイヤの友だちになりました ✨';

  @override
  String get aiyaFriendRestored => 'アイヤの友だちを復元しました';

  @override
  String get aiyaFriendNotFound => '有効なアイヤの友だちの登録が見つかりません';

  @override
  String get aiyaFriendElsewhere => 'この登録は別のアカウントで使われています';

  @override
  String get aiyaFriendEntry => 'アイヤの友だち · 1日20回';

  @override
  String aiyaFriendLeft(int n) {
    return 'アイヤの友だち · 今日あと $n 回';
  }

  @override
  String get guideS17L12 =>
      '限定デザイン：クリスマスの水晶玉（ヒイラギのリース、またたく金の星、舞う雪）は 12/25 まで、量子カウントダウンの水晶玉（金の時計の目盛りと次々に咲く花火、年明けの瞬間は特に大きく）は 1/1 まで（台湾時間）販売。期間後は二度と販売しません。購入した人はずっと使え、購入の復元もできます。';

  @override
  String get guideS14L6 =>
      '海外の都市は中央駅、中央駅がない都市は市役所が中心です。パラレル座標：パラレルユニバースをオンにして地球の左のボタンを押し、都市を選ぶと、その都市であなたがどのあたりに立つかがわかります。シェアカードには都市名だけで地名は載りません。';

  @override
  String get guideS14L7 =>
      'パラレルパスポート：パラレル都市の人とチャットしてお互いに話すと、その都市のスタンプがもらえます。5 都市集めると「パスポート」の光球がもらえます。パラレル座標か設定から開けます。パラレルの人の名前の下には現地時間と空の色が表示されます。';

  @override
  String get guideS17L13 =>
      '量子集会：量子世界の集会は量子集会になります。左上の席番号 →「量子集会を開く」でタイトル、アイコン、色を選ぶと、101 そばの第 3 圏の主催席に移り、みんなは光の輪をタップして参加できます。主催者はお知らせの投稿、「量子応援」（参加者全員の光球が同じ瞬間に光る）、地図で相手をタップして「集会から外す」ができます。毎月 1 回無料（30 分・50 人）。1 時間 200 人・2 時間 1000 人は主催券が必要で、1 枚で 1 回開催または 1 回延長（最長 12 時間）でき、まとめ買いもできます。集会は主催者が終了するか時間切れで終わり、主催者が量子世界を出たりアプリを閉じても続きます。終了後は人数と地域だけの記念カードがもらえます。';

  @override
  String get guideS17L14 =>
      '育つ光球：星軌は量子出会いカードを 1 枚完成するごとに星が 1 つ増えます（同じ人は 24 時間に 1 回、最大 24 個）。年輪は量子世界に合計 3 時間いるごとに 1 輪増えます（最大 12 輪）。成長記録はアカウントに紐づき、購入前から貯まります。';

  @override
  String get guideS17L15 =>
      'ギフト：地図で相手をタップするか、チャット右上の「ギフトを贈る」から、光の花束（相手の画面に光が咲き、24 時間光球のまわりに花びらの光）、光球 1 種、エンタングル（2 人で 1 つずつ、ペアになり、2 人とも量子世界にいると光の糸でつながる）を贈れます。相手は受け取るか断れます。断られるか 7 日返事がないと戻ってきて、別の人に贈れます。設定でギフトの受け取りをオフにできます。';

  @override
  String get guideS17L16 =>
      'ほかの限定デザイン：バレンタインの光球は 2/14、桜の光球は 4/10（台湾時間）まで販売。販売期間が過ぎるとストアから消え、購入した人はずっと使えます。';

  @override
  String get guideS18L6 =>
      'アイヤの友だち：「＋ タイムパック」の中の「アイヤの友だち」は自動更新の月額プランです。1日20回、1回20分または40メッセージ。アイヤが休んでいる時も話せて、あなただけに見える「スターライト」姿になります。タイムパックは1日20回を使い切った後に使われます。自動更新されます。Apple または Google のサブスクリプション設定でいつでも解約でき、機種変更後は「購入を復元」で戻せます。';

  @override
  String get guideS18L7 =>
      '音声通話：通話時間があれば、アイヤを開くとすぐに音声でつながります。電話のように声で話せて、いつでも話に割り込めます。通話中は入力欄の右側にミュートと ✕（終了）があります。通話時間パックは30分・60分・180分で、期限はなく、実際に話した秒数だけ消費されます。アイヤフレンドには毎月60分のプレゼントもあります（その月のみ有効、繰り越しなし）。通話時間がないときは、まず文字で話せます。初めての通話の前に別途同意が必要で、音声は OpenAI が処理します。3分間声が聞こえないと自動で切れ、1回の通話は最長60分です。';

  @override
  String get mapConsentTitle => '地図にあなたの位置を表示しますか？';

  @override
  String get mapConsentBody =>
      '許可すると、あなたが自分で「チェックイン」（量子世界では「入る」）をタップするたびに、ほかのユーザーの地図にチェックインした場所（リアルタイムの位置ではありません）、ニックネーム、気分が表示されます。自動チェックインはなく、アプリを離れると地図から消えます。拒否することも、設定でいつでもオフにすることもできます。';

  @override
  String get mapConsentAllow => '地図に表示する';

  @override
  String get mapConsentDecline => '今はしない';

  @override
  String get mapConsentDeclined =>
      'わかりました。誰の地図にも表示されません。チェックインしたくなったら、もう一度タップしてください。';

  @override
  String get mapConsentSetting => '地図に自分の位置を表示';

  @override
  String get mapConsentSettingSubtitle => 'オフにするとすぐにチェックインが終わり、誰の地図にも表示されません';

  @override
  String get wgErrInGroup => 'すでにグループに入っています。先に退出してください。';

  @override
  String get wgErrFull => 'このグループは 20 人です。リーダーに 7 日間プランを頼んでください。';

  @override
  String get wgErrPaidFull => 'このグループは満員（100 人）です。';

  @override
  String get wgErrQr => 'この QR コードは更新されました。新しいものをもらってください。';

  @override
  String get wgErrEnded => 'このグループは終了したか存在しません。';

  @override
  String get wgErrFiltered => '不適切な言葉が含まれています。修正してください。';

  @override
  String get wgErrHostLeave => 'リーダーは退出できません。先に引き継ぐか解散してください。';

  @override
  String get wgErrBusy => '接続できませんでした。もう一度お試しください。';

  @override
  String get wgErrName => 'グループに名前をつけてください。';

  @override
  String get wgPassUnavailable => 'ストアが現在利用できません。';

  @override
  String get wgPassFailed => '購入が完了しませんでした。';

  @override
  String get wgPassDone => '7 日間プランが有効になりました。最大 100 人まで参加できます。';

  @override
  String get wgCreateTitle => 'グループを作る';

  @override
  String get wgCreateBody =>
      '招待制のグループ：あなたの QR コードを持つ人だけが参加できます。集合・点呼・集合場所の共有ができます。';

  @override
  String get wgNameLabel => 'グループ名';

  @override
  String get wgColorLabel => 'グループの色';

  @override
  String wgDaysLabel(int n) {
    return '$n 日間（今日を含む）';
  }

  @override
  String get wgFreeNote => '20 人まで無料。それ以上はリーダーが 7 日間プランで最大 100 人に。';

  @override
  String get wgTourChipTitle => 'ツアーを引率しますか？';

  @override
  String get wgTourChipBody =>
      '「TourChip」は添乗員・ガイドのために作った私たちのアプリです。サブリーダー、班分け、お知らせ、行程表がそろっています。';

  @override
  String get wgTourChipButton => 'App Store で見る';

  @override
  String get wgCreateButton => '作成';

  @override
  String wgJoined(String name, int no) {
    return '「$name」に参加しました。あなたは $no 番です';
  }

  @override
  String get wgJoinTitle => 'グループに参加';

  @override
  String get wgJoinBody => 'カメラでリーダーの QR コードを読み取るのが一番早いです。8 文字のコードでも参加できます。';

  @override
  String get wgJoinButton => '参加';

  @override
  String wgButtonLabel(String name) {
    return 'グループ $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n／$limit 人';
  }

  @override
  String wgUntil(String date) {
    return '$date まで';
  }

  @override
  String wgMyNo(int n) {
    return '私は $n 番';
  }

  @override
  String get wgCallButton => '集合';

  @override
  String get wgCallDone => '全員そろった・集合を終える';

  @override
  String get wgRollButton => '点呼';

  @override
  String wgRollSummary(int here, int total) {
    return '点呼：$here／$total 人到着';
  }

  @override
  String wgMembersTitle(int n) {
    return 'メンバー $n 人（タップでメモ・引き継ぎ・削除）';
  }

  @override
  String get wgNoMembers => 'まだメンバーがいません。「QR コード」を見せて参加してもらいましょう。';

  @override
  String get wgQrButton => 'QR コード';

  @override
  String get wgDissolveAsk => 'グループを解散しますか？全員に通知され、名簿と記録は削除されます。';

  @override
  String get wgDissolve => '解散';

  @override
  String wgCallIn(int n) {
    return '$n 分後に集合';
  }

  @override
  String get wgCallNow => '今すぐ集合';

  @override
  String wgAckSummary(int acked, int total) {
    return '了解 $acked／$total';
  }

  @override
  String get wgAnswerHere => '着いた';

  @override
  String get wgAnswer5min => 'あと 5 分';

  @override
  String get wgAnswerHelp => '助けて';

  @override
  String get wgNoReply => '未回答';

  @override
  String get wgStateAck => '了解';

  @override
  String get wgStateSeen => '既読';

  @override
  String get wgStateNone => '反応なし';

  @override
  String get wgPassTitle => 'グループ 7 日間プラン';

  @override
  String get wgPassBody =>
      '20 人まで無料。購入するとこのグループは終了まで最大 100 人に。1 回の購入はこのグループのみで、自動更新されません。';

  @override
  String get wgPassButton => '7 日間プランを購入';

  @override
  String wgHostIs(String name) {
    return 'リーダー：$name';
  }

  @override
  String get wgNoCall => '今は集合の呼び出しはありません。リーダーが呼ぶとスマホが鳴ります。';

  @override
  String get wgRollAsk => 'リーダーが点呼しています';

  @override
  String get wgLeaveAsk => 'このグループを退出しますか？';

  @override
  String get wgLeave => 'グループを退出';

  @override
  String get wgCallTitle => '集合！';

  @override
  String get wgAcked => '✓ リーダーに了解を伝えました';

  @override
  String get wgAckButton => '了解';

  @override
  String get wgCallSheetTitle => '集合の呼び出し';

  @override
  String get wgNow => '今すぐ';

  @override
  String wgInMinutes(int n) {
    return '$n 分後';
  }

  @override
  String get wgPlaceLabel => '集合場所';

  @override
  String get wgPlaceHint => '例：西門駅 6 番出口';

  @override
  String get wgPlaceNote => '集合場所は今いる場所になります。メンバーには距離と方向が表示されます。';

  @override
  String get wgSendCall => '呼び出す';

  @override
  String get wgNoLocation => '位置が取れず、集合場所を設定できません。';

  @override
  String get wgQrTitle => 'スキャンして参加';

  @override
  String get wgQrBody => 'スマホのカメラで読み取るか、下のコードを入力して参加します。';

  @override
  String wgShareText(String name, String url) {
    return 'グループ「$name」に参加してね：$url';
  }

  @override
  String get wgShare => 'リンクを共有';

  @override
  String get wgRotateAsk => 'QR コードを更新しますか？古いコードとリンクはすぐ使えなくなります。';

  @override
  String get wgRotate => 'QR コードを更新';

  @override
  String wgMemberTitle(int no) {
    return '$no 番';
  }

  @override
  String get wgEditNote => 'メモ';

  @override
  String get wgHandoff => 'リーダーを引き継ぐ';

  @override
  String wgHandoffAsk(int no) {
    return '$no 番にリーダーを引き継ぎますか？あなたはメンバーになります。';
  }

  @override
  String get wgKick => 'グループから外す';

  @override
  String wgKickAsk(int no) {
    return '$no 番をグループから外しますか？';
  }

  @override
  String get wgNotePrivate => 'メモはあなただけに見えます（名前や部屋番号など）。';

  @override
  String get wgSave => '保存';

  @override
  String get wgConfirm => '確定';

  @override
  String get wgCancel => 'キャンセル';

  @override
  String get wgSettingCreate => 'グループを作る';

  @override
  String get wgSettingCreateSub => '旅行・遠足・登山などの招待制グループ：集合と点呼';

  @override
  String get wgSettingJoin => 'グループに参加';

  @override
  String get wgSettingJoinSub => 'リーダーの 8 文字コードを入力';

  @override
  String wgSettingOpen(String name) {
    return '私のグループ：$name';
  }

  @override
  String get wgChannelName => 'グループの集合';

  @override
  String get wgChannelDesc => 'リーダーが集合を呼びかけたとき';

  @override
  String get guideS19Title => '15. ささやきグループ';

  @override
  String get guideS19L1 =>
      'ささやきグループは旅行、遠足、登山、お出かけ、イベントスタッフ向けの招待制グループです。設定 → 集い →「グループを作る」で名前・色・日数（最長 7 日）を選べば完成です。';

  @override
  String get guideS19L2 =>
      '参加：リーダーは地図下のグループボタン →「QR コード」を表示。メンバーはスマホのカメラで読み取るとアプリが開いて参加できます。設定 → 集い →「グループに参加」で 8 文字のコードを入力しても参加できます。外部の人は検索も申請もできず、リーダーはいつでも QR コードを更新できます。';

  @override
  String get guideS19L3 =>
      '集合：リーダーが「集合」で時間と集合場所を送ると、メンバーのスマホが専用の音と「短・短・長」の振動で知らせます。アプリにはカウントダウン、集合場所までの距離と方向、地図上のグループ色の光の柱が表示されます。「了解」を押していない人には 1 分ごとに最大 3 回お知らせし、リーダーは了解・既読・反応なしを確認できます。';

  @override
  String get guideS19L4 =>
      '点呼：リーダーが「点呼」を押すと、メンバーにも同じ音と振動が届き、「着いた」「あと 5 分」「助けて」で答えます。リーダーにメンバーの位置は見えず、返事だけが見えます。';

  @override
  String get guideS19L5 =>
      '20 人までは無料。それ以上はリーダーが「グループ 7 日間プラン」を購入すると、終了まで最大 100 人になります。メンバーは常に無料です。グループは最長 7 日で、期限切れか解散すると名簿と記録はすべて削除されます。';

  @override
  String get wgFlagButton => '旗を掲げる';

  @override
  String get wgFlagHost => 'リーダー';

  @override
  String get wgFlagHint => 'スマホを掲げて、人混みの中で見つけてもらいましょう。タップで閉じます。';

  @override
  String get wgLostButton => '迷子になった';

  @override
  String get wgFound => '合流できた';

  @override
  String get wgLostSent => 'リーダーに現在地を送りました。その場で待つか集合場所へ向かってください。';

  @override
  String get wgLostTitleAsk => 'リーダーに現在地を送りますか？';

  @override
  String get wgLostAsk =>
      '今いる場所を 1 回だけリーダーに送ります。リーダーのスマホに通知が届き、地図に表示されます。追跡はせず、30 分後に自動で削除されます。合流したら「合流できた」で取り消せます。';

  @override
  String get wgLostSend => '現在地を送る';

  @override
  String wgLostTitle(int n) {
    return '迷子のメンバー $n 人';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n 分前';
  }

  @override
  String get wgNavigate => '経路案内';

  @override
  String get wgFoundThem => '合流した';

  @override
  String get guideS19L6 =>
      'お互いを探す：人混みで見つからないときは「旗を掲げる」をタップ。画面全体がグループ色で点滅し、番号が表示されます。本当にはぐれたら、メンバーは「迷子になった」で現在地を 1 回だけリーダーに送れます（30 分後に削除）。リーダーのスマホに通知が届き、地図に赤いピンが表示され、経路案内もできます。';

  @override
  String wgLostAlert(int no) {
    return '$no 番が迷子です';
  }

  @override
  String wgHelpAlert(String no) {
    return '$no 番が助けを求めています';
  }

  @override
  String get wgViewList => 'グループを開く';

  @override
  String aiyaCameoChimeNight(int hour) {
    return '$hour 時です。まだ起きている人、光の中でそばにいるよ。';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return '$hour 時、おはよう。今日もゆっくりいこう。';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return '$hour 時。今夜の街、元気？';
  }

  @override
  String get aiyaCameoNyReady => '準備はいい？一緒にカウントダウン！';

  @override
  String aiyaCameoNewYear(int year) {
    return 'あけましておめでとう！$year、みんな同じ部屋にいるよ。';
  }

  @override
  String get aiyaSkinEntry => '✦ スタイル';

  @override
  String get aiyaSkinTitle => 'アイヤのスタイル';

  @override
  String get aiyaSkinSubtitle => 'スタイルはあなたにだけ見えます';

  @override
  String get aiyaSkinNone => 'いつものアイヤ';

  @override
  String get aiyaSkinStarlight => 'スターライト';

  @override
  String get aiyaSkinStarlightSub => 'アイヤの友だち限定';

  @override
  String get aiyaSkinXmas => 'クリスマス';

  @override
  String get aiyaSkinNewYear => '量子カウントダウン';

  @override
  String get aiyaSkinNote =>
      '季節スタイルは買い切りでずっと使えます。見た目だけで、会話回数には影響しません。限定品は販売期間後は再販しません。';

  @override
  String get orbStyleStarTrail => 'スタートレイル';

  @override
  String get orbStyleRings => '年輪';

  @override
  String get orbGrowNote =>
      '育つ光球：スタートレイルは量子出会いカードを1枚完成するごとに星が1つ増えます（同じ相手は24時間に1回、最大24個）。年輪は量子世界に合計3時間いるごとに1本増えます（最大12本）。記録はアカウントに保存され、今から数え始めます。数だけを記録し、相手や場所は記録しません。';

  @override
  String orbGrowStars(int count) {
    return 'いま $count 個の星';
  }

  @override
  String orbGrowRings(int count) {
    return 'いま $count 本の年輪';
  }

  @override
  String get giftAction => 'ギフトを贈る';

  @override
  String giftSheetTitle(String name) {
    return '$name にギフトを贈る';
  }

  @override
  String giftPickStyle(String name) {
    return '$name に贈る光球を選ぶ';
  }

  @override
  String get giftBouquetName => '光の花束';

  @override
  String get giftBouquetDesc => '受け取ると光の花が咲き、24 時間光球のまわりに花びらの光が舞います';

  @override
  String get giftOrbName => '光球を贈る';

  @override
  String get giftOrbDesc => 'あなたが選び、受け取った相手がずっと使えます';

  @override
  String get giftPairName => '量子もつれペア';

  @override
  String get giftPairDesc => 'あなたと相手に1つずつのペア。2人とも量子世界にいると光の縄でつながります';

  @override
  String get giftPairYouHave => 'すでにペアがいます';

  @override
  String get giftNote => '相手は受け取るか断れます。断られたり 7 日間返事がなければあなたに戻り、ほかの人に贈れます。';

  @override
  String get giftVouchersTitle => '戻ってきたギフト（追加料金なし）';

  @override
  String get giftSendVoucher => '贈る';

  @override
  String giftSent(String name) {
    return '$name にギフトを贈りました。受け取りを待っています。';
  }

  @override
  String get giftReturnedOff => '相手はギフトの受け取りをオフにしています。ギフトはあなたに戻りました';

  @override
  String get giftReturnedBlocked => 'この人には贈れません。ギフトはあなたに戻りました';

  @override
  String get giftReturnedOwned => '相手はこの光球を持っています。ギフトは戻りました。別のものを贈れます';

  @override
  String get giftReturnedPaired => '相手にはすでにペアがいます。ギフトはあなたに戻りました';

  @override
  String get giftReturnedYouPaired => 'あなたにはすでにペアがいます。ギフトは戻りました';

  @override
  String get giftReturnedGeneric => 'ギフトはあなたに戻りました。ほかの人に贈れます';

  @override
  String get giftStoreUnavailable => 'ストアは現在使えません';

  @override
  String get giftFailed => 'ギフトを贈れませんでした。しばらくしてからお試しください。';

  @override
  String giftFromBouquet(String name) {
    return '$name から光の花束';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name から光球「$style」';
  }

  @override
  String giftFromPair(String name) {
    return '$name があなたとペアになりたいようです';
  }

  @override
  String get giftInboxTitle => '届いたギフト';

  @override
  String get giftInboxEmpty => 'いまはギフトはありません';

  @override
  String get giftInboxNote => '断ったギフトは贈り主に戻ります。7 日間返事がなくても戻ります。';

  @override
  String get giftAccept => '受け取る';

  @override
  String get giftDecline => '断る';

  @override
  String get giftDeclined => '断りました。ギフトは贈り主に戻ります。';

  @override
  String get giftAcceptedOrb => '受け取りました！量子アバターで切り替えられます';

  @override
  String giftAcceptedPair(String name) {
    return '$name とペアになりました';
  }

  @override
  String get giftAcceptedBouquet => '光の花束を受け取りました。24 時間光球のまわりに花びらが舞います。';

  @override
  String get giftAlreadyOwned => 'この光球はすでに持っています。ギフトは贈り主に戻りました';

  @override
  String get giftAlreadyPaired => 'どちらかがすでにペアです。ギフトは贈り主に戻りました';

  @override
  String get giftSettingsTitle => 'ギフト';

  @override
  String get giftReceiveToggle => 'ギフトを受け取る';

  @override
  String get giftReceiveToggleSub => 'オフにすると、ギフトはそのまま贈り主に戻ります';

  @override
  String get giftVouchersHint => '相手のメニューで「ギフトを贈る」から贈れます';

  @override
  String get giftUnpair => 'ペアを解除';

  @override
  String giftUnpairConfirm(String name) {
    return '$name とのペアを解除しますか？光球は2人とも残りますが、光の縄は消えます。';
  }

  @override
  String get orbStylePair => '量子もつれ';

  @override
  String giftPairedWith(String name) {
    return 'ペア：$name';
  }

  @override
  String giftInboxCount(int count) {
    return '届いたギフト（$count）';
  }

  @override
  String giftVouchersCount(int count) {
    return '戻ってきたギフト $count 件';
  }

  @override
  String get giftBlockedOff => '相手はギフトの受け取りをオフにしています。課金はされていません。';

  @override
  String get giftBlockedBlocked => 'この人にはギフトを贈れません。課金はされていません。';

  @override
  String get giftBlockedOwned => '相手はこの光球を持っています。別のものを選んでください（課金はされていません）。';

  @override
  String get giftBlockedPaired => '相手にはすでにペアがいます。課金はされていません。';

  @override
  String get orbStyleValentine => 'バレンタイン';

  @override
  String get orbStyleSakura => '桜';

  @override
  String get parallelCoords => 'パラレル座標';

  @override
  String parallelCoordsHome(String city, String km) {
    return '$cityの中心から $km km';
  }

  @override
  String parallelCoordsIn(String city) {
    return '$cityで、あなたが立っているのはこのあたり';
  }

  @override
  String get parallelCoordsSea => '海の上、または地名のない場所';

  @override
  String get parallelCoordsOutside => 'この都市の範囲外';

  @override
  String parallelCoordsNote(String city) {
    return '$cityの人がパラレルユニバースをオンにすると、このあたりにあなたが見えます（約 500 m ぼかし）。';
  }

  @override
  String get parallelCoordsFailed => '地名が見つかりませんでした。あとでもう一度お試しください';

  @override
  String parallelCardTitle(String city) {
    return 'いま、パラレルユニバースの$cityにいます';
  }

  @override
  String parallelCardShareText(String city) {
    return 'いま、パラレルユニバースの$cityにいます。Mood Whisper を開けば、あなたも別の街へ。';
  }

  @override
  String get parallelCoordsShare => 'カードをシェア';

  @override
  String get orbStylePassport => 'パスポート';

  @override
  String get passportTitle => 'パラレルパスポート';

  @override
  String passportCount(int count) {
    return '$count 都市を集めました';
  }

  @override
  String passportRewardProgress(int count) {
    return 'あと $count 都市で「パスポート」光球がもらえます';
  }

  @override
  String get passportRewardDone => '「パスポート」光球を手に入れました。量子アバターで着けられます';

  @override
  String get passportRewardToast => '5 都市達成！「パスポート」光球を手に入れました';

  @override
  String get passportEmpty =>
      'パラレルユニバースで別の街の人とチャットし、お互いに一言でも話すと、その街のスタンプが押されます。記録するのは街と日付だけで、相手が誰かは残りません。';

  @override
  String passportNewStamp(String city) {
    return '新しいスタンプ：$city';
  }

  @override
  String get passportShare => 'パスポートをシェア';

  @override
  String passportCardTitle(int count) {
    return 'わたしのパラレルパスポート\n$count 都市';
  }

  @override
  String passportCardShareText(int count) {
    return 'わたしのパラレルパスポートには $count 都市のスタンプがあります。Mood Whisper を開いて、パラレルユニバースへ。';
  }

  @override
  String get asmTitle => '量子集会';

  @override
  String get asmCreateTitle => '量子集会を開く';

  @override
  String get asmCreateIntro =>
      '101 のそば、第 3 環のホスト席に座ります。量子世界のみんなに集会の光の輪が見え、自由に参加できます。';

  @override
  String get asmTitleHint => '集会のテーマ（例：一緒に流星群を見よう）';

  @override
  String get asmPlanFree => '今月の無料枠';

  @override
  String get asmPlanFreeSub => '30 分・最大 50 人・月 1 回';

  @override
  String get asmPlanFreeUsed => '今月の無料枠はもう使いました';

  @override
  String get asmPlan1h => '1 時間';

  @override
  String get asmPlan1hSub => '最大 200 人';

  @override
  String get asmPlan2h => '2 時間';

  @override
  String get asmPlan2hSub => '最大 1000 人';

  @override
  String asmVoucherCount(int count) {
    return 'ホストチケット $count 枚';
  }

  @override
  String get asmExtendTitle => '集会を延長';

  @override
  String get asmExtendHint => '主催券で時間を延ばせます（1回最長12時間）';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours時間 · $price';
  }

  @override
  String get asmExtended => '集会を延長しました';

  @override
  String get asmEndingSoon => '集会の残りが10分を切りました。集会カードから延長できます';

  @override
  String get asmErrTooLong => '集会は最長12時間です';

  @override
  String get asmBuyMore => '主催券をまとめ買い';

  @override
  String get asmBuyMoreHint => '先に買っておけば開催や延長にすぐ使えます';

  @override
  String get asmRules =>
      '主催券1枚で集会を1回開催、または開催中の集会を延長できます。使わなかった時間は返金されません。タイトルとお知らせはフィルタされ、違反すると利用停止になります。';

  @override
  String get asmStart => '集会を始める';

  @override
  String get asmStarted => '集会が始まりました！';

  @override
  String get asmVoucherReady => 'ホストチケットが届きました';

  @override
  String get asmBuyFailed => '購入は完了しませんでした。請求されないか、あとで反映されます';

  @override
  String asmHostLine(String name, String code) {
    return 'ホスト $name · ⬡ $code';
  }

  @override
  String get asmJoin => '参加する';

  @override
  String get asmJoined => '集会に参加しました';

  @override
  String get asmLeave => '退出する';

  @override
  String get asmHostPanel => 'ホストのコントロール';

  @override
  String get asmAnnounceHint => 'お知らせを送る（100 文字まで）';

  @override
  String get asmAnnounceSend => '送信';

  @override
  String get asmAnnounced => 'お知らせを送りました';

  @override
  String get asmCheerTitle => '量子応援：色とカウントダウンを選ぶと、参加者全員の光球が同じ瞬間に光ります';

  @override
  String get asmCheerNow => '今すぐ';

  @override
  String asmCheerIn(int n) {
    return '$n 秒後';
  }

  @override
  String get asmCheer => '応援！';

  @override
  String get asmRemoveHint => '誰かを外すには、地図でその人をタップ →「集会から外す」';

  @override
  String get asmEnd => '集会を終える';

  @override
  String get asmReport => 'この集会を通報';

  @override
  String get asmErrFreeUsed => '今月の無料枠はもう使いました';

  @override
  String get asmErrSeatsFull => '第 3 環のホスト席が満席です。あとでもう一度';

  @override
  String get asmErrBlocked => 'テーマかお知らせに不適切な内容があります';

  @override
  String get asmErrFull => '集会は満員です';

  @override
  String get asmErrRemoved => 'この集会から外されました';

  @override
  String get asmErrEnded => 'この集会は終了しました';

  @override
  String get asmErrTooSoon => '少し待ってからもう一度お試しください';

  @override
  String get asmErrHidden => 'このアカウントは今は集会を開けません';

  @override
  String get asmErrHosting => '別の集会をホスト中です';

  @override
  String get asmErrGeneric => 'エラーが起きました。あとでもう一度お試しください';

  @override
  String get asmMemorialEyebrow => '量子集会のメモリアルカード';

  @override
  String get asmMemorialUnit => '人';

  @override
  String get asmMemorialTogether => '量子世界に集まりました';

  @override
  String shareCardFindUs(String name) {
    return 'App Store で「$name」を検索';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'Google Play で「$name」を検索';
  }

  @override
  String get asmShareCard => 'カードをシェア';

  @override
  String asmShareText(String title, int count) {
    return '量子世界で「$title」を開き、$count 人が参加しました。Mood Whisper を開いて、次は一緒に。';
  }

  @override
  String get asmOpenEntry => '量子集会を開く';

  @override
  String get asmOpenEntrySub => '101 のそばのホスト席に座って、世界中の誰でも参加できる集会を';

  @override
  String get asmRemoveMember => '集会から外す';

  @override
  String get asmRemovedDone => '集会から外しました';

  @override
  String get aiyaFriendPerk5 => '毎月60分のアイヤとの音声通話つき';

  @override
  String get aiyaVoiceOn => '読み上げ：オン';

  @override
  String get aiyaVoiceOff => '読み上げ：オフ';

  @override
  String get aiyaVoiceFriendOnly => '読み上げはアイヤフレンドの機能です';

  @override
  String get aiyaVoiceDailyMax => '今日の読み上げは終わりました。また明日アイヤの声を聞いてね';

  @override
  String get aiyaCallTooltip => 'アイヤと音声通話';

  @override
  String get aiyaCallConsentTitle => 'アイヤと音声通話';

  @override
  String get aiyaCallConsentBody =>
      '音声通話中、あなたの声はリアルタイムで OpenAI（米国）に送られ、AI が処理して返事をします。身元・ニックネーム・位置は送りません。録音や通話内容の保存もしません。アイヤは AI なので返事が間違うことがあり、専門的な助言ではありません。';

  @override
  String get aiyaCallAgree => '同意して通話';

  @override
  String get aiyaCallConnecting => '接続中…';

  @override
  String aiyaCallLive(String time) {
    return '通話中 · 残り $time';
  }

  @override
  String get aiyaHangUp => '切る';

  @override
  String get aiyaCallEnded => '通話終了';

  @override
  String get aiyaCallTimeUp => '1時間話しました。少し休んでまたアイヤに電話してね';

  @override
  String get aiyaCallDailyMax => '今日の2回の通話は終わりました。また明日アイヤに電話してね';

  @override
  String get aiyaCallMonthMax => '今月の通話回数は終わりました。来月またアイヤに電話してね';

  @override
  String get aiyaCallResting => 'アイヤの音声回線が今日は混み合っています。少し後でお試しください';

  @override
  String get aiyaCallMicDenied => 'アイヤと通話するにはマイクを許可してください。端末の設定でオンにできます';

  @override
  String get aiyaCallFailed => 'つながりませんでした。少し後でお試しください';

  @override
  String aiyaCallsLeft(int today, int month) {
    return '今日あと $today 回 · 今月あと $month 回';
  }

  @override
  String get aiyaCallIdle => 'しばらく話がなかったので通話を終了しました';

  @override
  String get aiyaCallMute => 'ミュート';

  @override
  String get aiyaCallUnmute => 'ミュート解除';

  @override
  String aiyaCallPurchased(int minutes) {
    return '通話時間を$minutes分追加しました';
  }

  @override
  String get aiyaCallOutOfTime => '通話時間がなくなりました';

  @override
  String get aiyaCallPacksTitle => 'アイヤと音声通話';

  @override
  String get aiyaCallPacksBody =>
      '電話のように、声でアイヤと話せます。通話時間を買えばすぐにかけられます。アイヤフレンドなら毎月60分のプレゼントも。';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get aiyaCallFriendOption => 'アイヤフレンドになる（毎月60分）';

  @override
  String get aiyaCallTextInstead => 'まずは文字で話す';

  @override
  String get aiyaCallPackNote => '通話時間に期限はなく、実際の通話秒数で消費されます。消耗型アイテムは復元できません。';

  @override
  String aiyaCallMinutesLeft(int n) {
    return '通話時間 残り$n分';
  }

  @override
  String get asmQ2Section => 'Q2 音声ライブ（ホスト席は第 2 リング）';

  @override
  String get asmQ2Intro =>
      'Q3 の機能すべてに加えて、音声ライブと質問：参加者全員に話しかけ、手を挙げた人をステージに招き、みんなは文字で質問していいねできます。';

  @override
  String get asmPlanQ2_1h => 'Q2 · 1 時間';

  @override
  String get asmPlanQ2_1hSub => '最大 200 人、音声ライブ＋質問';

  @override
  String get asmPlanQ2_2h => 'Q2 · 2 時間';

  @override
  String get asmPlanQ2_2hSub => '最大 1000 人、音声ライブ＋質問';

  @override
  String get asmErrQ2Unavailable => '音声ライブは現在ご利用いただけません';

  @override
  String get asmQ2JoinHint => '参加すると音声ライブを聴いたり、手を挙げたり、質問したりできます';

  @override
  String get asmLiveOn => 'ライブ中';

  @override
  String get asmLiveConnecting => '接続中…';

  @override
  String get asmLiveError => 'ライブに接続できません';

  @override
  String get asmLiveOff => 'ライブに未接続';

  @override
  String asmLiveStage(String names) {
    return 'ステージ：$names';
  }

  @override
  String get asmLiveMicOn => 'マイクをオン';

  @override
  String get asmLiveMicOff => 'マイクをオフ';

  @override
  String get asmLiveHandUp => '手を挙げる';

  @override
  String get asmLiveHandDown => '手を下ろす';

  @override
  String get asmLiveMute => 'ライブをミュート';

  @override
  String get asmLiveUnmute => 'ミュート解除';

  @override
  String get asmLiveMusicMode => '音楽モード';

  @override
  String get asmLiveMusicHint =>
      '高音質でノイズ抑制なし。自分で演奏する音楽や権利を持つ音楽向けです。許諾のない市販曲は流せません。';

  @override
  String get asmLiveSpeakers => 'ステージのゲスト';

  @override
  String get asmLiveMuteGuest => 'ミュート';

  @override
  String get asmLiveOffStage => 'ステージから降ろす';

  @override
  String asmLiveHands(int count) {
    return '$count 人が挙手';
  }

  @override
  String get asmLiveInvite => 'ステージに招く';

  @override
  String get asmLiveNoRecording => 'ライブは録音されず、音声も保存されません。';

  @override
  String get asmLiveOnStage => 'ホストがステージに招きました。マイクをオンにして話せます';

  @override
  String get asmLiveMicDenied => 'マイクへのアクセスがないため、聴くだけになります。設定でオンにできます。';

  @override
  String get asmLiveStageFull => 'ステージにはすでに 3 人のゲストがいます';

  @override
  String get asmLiveGone => '相手はすでに集会を離れました';

  @override
  String get asmAskOpen => '質問';

  @override
  String get asmAskTitle => '質問';

  @override
  String get asmAskHint => '質問を送ると、みんながいいねでき、多いものが上に並びます。ホストが選んで答えます。';

  @override
  String get asmAskHostHint => '質問はいいね順に並びます。回答済みにしたり、不適切な質問を非表示にしたりできます。';

  @override
  String get asmAskInput => 'ホストに聞きたいことは？（80 文字まで）';

  @override
  String get asmAskSend => '送信';

  @override
  String get asmAskSent => '質問を送りました';

  @override
  String get asmAskEmpty => 'まだ質問はありません';

  @override
  String get asmAskAnswered => '回答済みにする';

  @override
  String get asmAskReopen => '未回答に戻す';

  @override
  String get asmAskHide => '非表示';

  @override
  String get asmAskTooMany => 'この集会ではすでに 5 件質問しました';
}
