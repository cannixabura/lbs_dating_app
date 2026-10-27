// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

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
  String get releaseNotesTitle => 'Mood Whisper 1.1 内部テスト版';

  @override
  String get releaseNotesLead => '街が夜の色をまといました。';

  @override
  String get releaseNotesMap => '新しい夜のマップ：深い青の街区、ほのかに光る道、ネオンの建物';

  @override
  String get releaseNotesBubbles => 'ムードの泡がダークガラスになり、どこでも読みやすく';

  @override
  String get releaseNotesResting => '休憩中と残像：画面をロックしていてもノックが届きます';

  @override
  String get releaseNotesSafety => '通報とブロックで街を安全に';

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
      '今の気持ちをひとこと（20 文字まで）書き、利用規約とプライバシーポリシーに同意して「Mood Whisper に入る」をタップします。';

  @override
  String get guideS1L3 => '電話番号、メールアドレス、本名は不要です。アカウントは匿名で、この端末に紐づきます。';

  @override
  String get guideS1L4 =>
      'ムードの色は言葉に含まれるキーワードで決まります。「うれしい・笑」は金色、「かなしい・泣」は青、「怒り」は朱色、「おだやか・ぼんやり」は緑、「情熱」はオレンジ、「愛・ハート」はピンク、それ以外は淡い紫です。';

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
      '呼吸するように動く泡は、その人がアプリを使っている印。暗くなって「休憩中」と表示されていれば画面をロック中ですが、ノックはできます。名前のない灰色の泡は「残像」で、立ち去ったばかりの人の名残です。少しずつ消えていきます。';

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
      '範囲は主催者を中心に 5 km で、主催者が動けば一緒に動きます。レーダー上の主催者には光の輪と「主催」の印がつきます。';

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
  String get guideS10Title => '10. ムードカードとムードの軌跡';

  @override
  String get guideS10L1 =>
      '下のメニューのシェアボタンで、今のムードを夜景カードにできます。インスタのストーリーズにぴったりで、カードに位置情報は載りません。';

  @override
  String get guideS10L2 =>
      '設定 →「ムードの軌跡」で、これまで書いたムードと場所を振り返れます。データはこの端末にだけ保存され、いつでもオフにしたり消去したりできます。';

  @override
  String get guideS11Title => '11. 設定と通知';

  @override
  String get guideS11L1 => '「夜のリマインダー」：毎晩 21:30 にやさしいお知らせが届きます。設定でオン・オフできます。';

  @override
  String get guideS11L2 =>
      'ノック、新しいメッセージ、きらめき、集いのお知らせはプッシュ通知で届きます。端末の設定でオフにできます。';

  @override
  String get guideS11L3 =>
      '毎週金曜 21:00〜23:00 は「ライトアップナイト」。みんなで一緒にオンラインになると、街がいちばん明るくなります。';

  @override
  String get guideS12Title => '12. 通報とブロック';

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
  String get guideS13Title => '13. プライバシーとアカウント';

  @override
  String get guideS13L1 =>
      '近くの人に見えるのは、あなたのムード、呼び名、写真、おおよその距離です。位置情報はアプリの使用中だけ使われます。';

  @override
  String get guideS13L2 => '設定 →「アカウントとデータを削除」で、街に残したすべてをいつでも完全に削除できます。';

  @override
  String get guideS13L3 =>
      'ご不明な点は、設定 →「お問い合わせ」または service.softchip@gmail.com までご連絡ください。';

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
  String get intro5Body => '目を閉じて、端末の振動と鼓動を感じて。さあ、今の気持ちを書いて Mood Whisper へ。';

  @override
  String get loadingImage => '画像を読み込み中…';

  @override
  String get startExploring => 'はじめる';

  @override
  String get nextPage => '次へ';

  @override
  String get feedbackSubject => 'Mood Whisper へのご意見';

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
      'オンにすると、対応する街でいまアプリを開いている人がみんなあなたのレーダーに重なり、みんなもあなたを見ることができます。台湾の街は海外の街（東京、ソウル、クアラルンプールなど）と、海外の街は台湾と対応しています。\n\n2つの街はそれぞれの中央駅で重ね合わせます。あなたが駅からどの方向にどれだけ離れているかで、相手の街での位置が決まり、約500mぼかされるので、本当の位置や距離は誰にもわかりません。光を送る・ノック・チャットもでき、いつでもオフにできます。残像・ささやき・集いはその街だけのものです。';

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
}
