// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Gembira';

  @override
  String get moodSad => 'Sedih';

  @override
  String get moodAngry => 'Marah';

  @override
  String get moodCalm => 'Tenang';

  @override
  String get moodPassion => 'Bersemangat';

  @override
  String get moodLove => 'Cinta';

  @override
  String get moodOther => 'Lain-lain';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name telah tamat';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'Anda telah menyerahkan $emoji $name dan kini seorang peserta.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'Anda telah menyerahkan perhimpunan. Nama panggilan anda sudah 10 aksara, jadi tambahkan $emoji sendiri untuk terus menerima pengumuman.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'Anda telah menyerahkan perhimpunan. Kami tambahkan $emoji pada nama anda, jadi anda kini seorang peserta.';
  }

  @override
  String get releaseNotesTitle => 'Mood Whisper 1.1 ujian dalaman';

  @override
  String get releaseNotesLead => 'Bandar ini kini berwarna malam.';

  @override
  String get releaseNotesMap =>
      'Peta malam baharu: blok biru gelap, jalan bercahaya, bangunan neon';

  @override
  String get releaseNotesBubbles =>
      'Gelembung mood kini kaca gelap, mudah dibaca di mana-mana';

  @override
  String get releaseNotesResting =>
      'Berehat dan gema pudar: orang boleh mengetuk walaupun skrin anda dikunci';

  @override
  String get releaseNotesSafety =>
      'Lapor dan sekat untuk memastikan bandar selamat';

  @override
  String get gotIt => 'Faham';

  @override
  String get blockedToast => 'Orang ini telah lenyap ke dalam gelap.';

  @override
  String get unblockedToast =>
      'Sekatan dibuang. Laluan anda boleh bersilang semula.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Hidupkan Perkhidmatan Lokasi';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper perlu tahu di sudut bandar mana anda berada supaya orang berdekatan dapat melihat mood anda. Hidupkan Perkhidmatan Lokasi dalam Tetapan telefon anda.';

  @override
  String get locationReducedTitle => 'Hidupkan Lokasi Tepat';

  @override
  String get locationReducedBodyIos =>
      'Anda hanya berkongsi lokasi anggaran, jadi radar tidak dapat mengenal pasti siapa yang berdekatan. Pergi ke Tetapan › Mood Whisper › Lokasi dan hidupkan Lokasi Tepat.';

  @override
  String get locationReducedBodyAndroid =>
      'Anda hanya berkongsi lokasi anggaran, jadi radar tidak dapat mengenal pasti siapa yang berdekatan. Pilih Tepat dalam kebenaran lokasi.';

  @override
  String get locationNoFixTitle => 'Belum dapat mengesan lokasi anda';

  @override
  String get locationNoFixBody =>
      'Anda mungkin di dalam bangunan atau isyarat lemah. Pergi dekat tingkap atau ke luar, hidupkan Wi-Fi dan cuba lagi.';

  @override
  String get locationNeededTitle => 'Mood Whisper perlukan lokasi anda';

  @override
  String get locationNeededBody =>
      'Mood Whisper hanya menggunakan lokasi anda semasa anda menggunakan app, untuk menunjukkan mood dalam lingkungan 5 km. Radar hanya menunjukkan jarak anggaran, bukan alamat.\nDalam Tetapan, benarkan lokasi Semasa Menggunakan App dan hidupkan Lokasi Tepat.';

  @override
  String get locationSimulatorHint =>
      '(Nota pembangun: dalam Simulator, pilih lokasi di Features › Location)';

  @override
  String get openSettings => 'Buka Tetapan';

  @override
  String get locationRecheck => 'Sudah dihidupkan, semak semula';

  @override
  String get tryAgain => 'Cuba lagi';

  @override
  String get leaveApp => 'Keluar';

  @override
  String whispersNearby(int count) {
    return 'Ada $count bisikan berdekatan anda. Ketik sampul untuk membacanya.';
  }

  @override
  String get whisperPassed =>
      'Anda melalui satu bisikan. Ketik sampul untuk membacanya.';

  @override
  String get whisperLeft =>
      'Bisikan anda kini di sini. Ia akan pudar dalam 7 hari.';

  @override
  String get timeWhisperSealedYear =>
      'Dimeterai. Kembali ke sini setahun lagi untuk membukanya.';

  @override
  String get timeWhisperSealedMonth =>
      'Dimeterai. Kembali ke sini sebulan lagi untuk membukanya.';

  @override
  String get whisperWithdrawn => 'Bisikan anda telah ditarik balik.';

  @override
  String get whisperMineLabel => 'Bisikan yang anda tinggalkan';

  @override
  String get whisperTapToRead => 'Satu bisikan. Ketik untuk membaca';

  @override
  String get noMoodYet => 'Kehilangan kata-kata…';

  @override
  String get knockWithdrawnByLeaving =>
      'Mereka telah hilang ke dalam bandar dan diam-diam menarik balik ketukan…';

  @override
  String get knockCardTitle => 'Pertemuan seketika';

  @override
  String knockCardBody(String name) {
    return '$name sedang mengetuk,\nberharap laluan anda bersilang…';
  }

  @override
  String get skip => 'Langkau';

  @override
  String get decline => 'Tolak';

  @override
  String get accept => 'Terima';

  @override
  String get reportThisPerson => 'Laporkan orang ini';

  @override
  String get cityQuietTonight => 'Bandar sunyi malam ini';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'Bandar malam ini · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. Lihat cuaca mood bandar';
  }

  @override
  String get cityMoodTitle => 'Mood bandar malam ini';

  @override
  String cityMoodQuietCount(int total) {
    return 'Bandar masih sunyi. $total orang telah berkongsi mood malam ini.';
  }

  @override
  String cityMoodCount(int total) {
    return '$total orang dalam lingkungan 20 km telah berkongsi mood malam ini';
  }

  @override
  String get cityMoodQuietInvite =>
      'Setiap mood menambah sedikit cahaya. Tulis perasaan anda sekarang dan bantu terangi bandar.';

  @override
  String get cityMoodFootnote =>
      'Mood tanpa nama dari 24 jam lalu. Peratusan disembunyikan jika kurang daripada 10 orang.';

  @override
  String get close => 'Tutup';

  @override
  String get emptyRadarTitle => 'Anda cahaya pertama malam ini';

  @override
  String get emptyRadarBody =>
      'Belum ada sesiapa berdekatan. Mood anda sudah bersinar di bandar,\ndan sesiapa yang lalu akan melihatnya. Anda juga boleh meninggalkan bisikan untuk orang seterusnya yang lalu.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '$total orang di bandar malam ini, kebanyakannya rasa “$mood”';
  }

  @override
  String get inviteFriends => 'Ajak kawan terangi kawasan anda';

  @override
  String get shareMoodCard => 'Kongsi kad mood saya';

  @override
  String get editYourMood => 'Ubah mood anda';

  @override
  String resonanceTonight(int count) {
    return '$count kerlipan bergema dengan anda malam ini';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · mood anda';
  }

  @override
  String get dockTapToEdit => 'Mood anda · ketik untuk ubah';

  @override
  String get leaveWhisper => 'Tinggalkan bisikan';

  @override
  String get settings => 'Tetapan';

  @override
  String get nightlyReminder => 'Peringatan malam';

  @override
  String get nightlyReminderSubtitle =>
      'Peringatan lembut pada 21:30 setiap malam';

  @override
  String get closeSettings => 'Tutup tetapan';

  @override
  String get settingsSectionMe => 'Saya';

  @override
  String get editProfile => 'Ubah profil';

  @override
  String get editProfileSubtitle => 'Foto, nama panggilan dan mood';

  @override
  String get manageBlockList => 'Orang yang disekat';

  @override
  String get manageBlockListSubtitle =>
      'Lihat atau buang sekatan orang yang anda hantar ke dalam gelap';

  @override
  String get myTimeWhispers => 'Surat ke masa depan';

  @override
  String get myTimeWhispersSubtitle =>
      'Nota untuk diri anda pada masa depan, hanya anda boleh lihat';

  @override
  String get myMoodTrail => 'Jejak mood saya';

  @override
  String get myMoodTrailSubtitle => 'Disimpan hanya dalam telefon anda';

  @override
  String get settingsSectionGatherings => 'Perhimpunan';

  @override
  String get gatheringHost => 'Anjurkan perhimpunan';

  @override
  String get gatheringHostSubtitle =>
      'Mulakan acara untuk semua dalam lingkungan 5 km';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'Anda menganjurkan $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Kongsi';

  @override
  String get shareMoodCardSubtitle =>
      'Salah satu daripada sebelas ilustrasi malam secara rawak, sesuai untuk Instagram Stories';

  @override
  String get inviteFriendsSubtitle =>
      'Lebih ramai orang berdekatan, lebih terang bandar';

  @override
  String get settingsSectionAbout => 'Perihal';

  @override
  String get guide => 'Cara guna';

  @override
  String get guideSubtitle =>
      'Dari menulis mood hingga menganjurkan perhimpunan';

  @override
  String get termsOfUse => 'Terma Penggunaan';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get contactUs => 'Hubungi kami';

  @override
  String get deleteAccount => 'Padam akaun dan data';

  @override
  String get deleteAccountSubtitle =>
      'Padam selama-lamanya semua yang anda tinggalkan di bandar';

  @override
  String get avatarUploadFailed =>
      'Foto anda tidak dapat dimuat naik. Sila cuba lagi nanti.';

  @override
  String get moodEmpty =>
      'Mood anda tidak boleh kosong. Tinggalkan sedikit cahaya untuk bandar.';

  @override
  String get profileSyncFailed =>
      'Status anda tidak dapat dikemas kini. Sila cuba lagi nanti.';

  @override
  String get profileUpdated => 'Dikemas kini. Bandar dapat merasai nafas anda.';

  @override
  String get changeAvatar => 'Tukar foto';

  @override
  String get avatarHint =>
      'Ketik untuk tukar foto · gelang itu warna mood anda';

  @override
  String get cityName => 'Nama panggilan';

  @override
  String get cityNameHint => 'Pilihan, cth. Kucing Berkelana';

  @override
  String get currentMood => 'Mood anda sekarang';

  @override
  String get currentMoodHint => 'cth. Berjalan dalam hujan renyai 🌿';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get blockListTitle => 'Dihantar ke dalam gelap';

  @override
  String get blockListEmpty => 'Malam cerah. Anda belum menjauhkan sesiapa.';

  @override
  String get unblock => 'Buang sekatan';

  @override
  String get deleteAccountBody =>
      'Lokasi, mood, nama panggilan, foto, bisikan, kerlipan, senarai sekatan dan perbualan aktif anda akan dipadam selama-lamanya. Tindakan ini tidak boleh dibatalkan.\n\nUntuk mengelakkan penyalahgunaan, rekod laporan disimpan selama 1 tahun seperti dalam Dasar Privasi.';

  @override
  String get deleting => 'Memadam…';

  @override
  String get deletePermanently => 'Padam selama-lamanya';

  @override
  String get deleteFailed =>
      'Pemadaman tidak selesai. Semak sambungan anda dan cuba lagi.';

  @override
  String get fadingEcho => 'Gema pudar';

  @override
  String clusterCount(int count) {
    return '$count mood di sini';
  }

  @override
  String clusterMore(int count) {
    return 'Lagi\n+$count';
  }

  @override
  String get clusterBackToFirst => 'Kembali\nke awal';

  @override
  String get fadingEchoTitle => 'Satu gema pudar';

  @override
  String encounterWith(String name) {
    return 'Bertemu dengan $name';
  }

  @override
  String get fadingEchoBody =>
      'Ini hanya gema pudar. Anda tidak boleh bersilang dengannya.';

  @override
  String get demoPersonBody =>
      'Ini orang demo yang membalas secara automatik, bukan orang sebenar. Gunakannya untuk mencuba ketuk, sembang, kerlipan, lapor dan sekat.';

  @override
  String get sendGlimmer => 'Hantar kerlipan';

  @override
  String get knock => 'Ketuk';

  @override
  String get blockAction => 'Sekat';

  @override
  String get handOverHost => 'Serahkan penganjuran';

  @override
  String get report => 'Lapor';

  @override
  String get confirmBlockTitle => 'Sekat orang ini?';

  @override
  String confirmBlockBody(String name) {
    return 'Hantar $name ke dalam gelap?\nSelepas disekat, anda akan hilang dari bandar masing-masing.';
  }

  @override
  String get confirmBlock => 'Sekat';

  @override
  String get glimmerReceived =>
      'Seseorang menghantar kerlipan kepada anda. Mood anda bergema dengan mereka.';

  @override
  String get glimmerSent => 'Anda menghantar satu kerlipan.';

  @override
  String get glimmerAlreadySent =>
      'Anda sudah menghantar kerlipan kepada mereka hari ini. Cuba lagi esok.';

  @override
  String get knockSent => 'Ketukan dihantar. Menunggu jawapan…';

  @override
  String get knockFailed => 'Ketukan anda tidak sampai. Sila cuba lagi nanti.';

  @override
  String get knockNoAnswer =>
      'Tiada jawapan. Ketukan anda pudar perlahan-lahan.';

  @override
  String get knockDeclined =>
      'Laluan anda tidak bersilang kali ini. Beri sedikit ruang antara satu sama lain.';

  @override
  String get knockSkipped =>
      'Mereka melangkau buat masa ini, dan ketukan anda pudar perlahan-lahan.';

  @override
  String get sensingCity => 'Merasai bandar…';

  @override
  String get gatheringUnavailable =>
      'Perhimpunan tidak tersedia sekarang. Sila cuba lagi nanti.';

  @override
  String get notSentCheckNetwork =>
      'Tidak dihantar. Semak sambungan anda dan cuba lagi.';

  @override
  String get justNow => 'baru sahaja';

  @override
  String minutesAgo(int count) {
    return '$count minit lalu';
  }

  @override
  String hoursAgo(int count) {
    return '$count jam lalu';
  }

  @override
  String get nextDayPrefix => 'hari berikutnya ';

  @override
  String get gatheringNameMissing => 'Sila beri nama untuk perhimpunan anda.';

  @override
  String get gatheringEmojiInvalid =>
      'Ikon perhimpunan mesti tepat satu emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name telah bermula. Minta peserta tambah $emoji pada nama panggilan mereka.';
  }

  @override
  String get startGatheringTitle => 'Mulakan perhimpunan';

  @override
  String get startGatheringLead =>
      'Semua dalam lingkungan 5 km dari anda. Kawasan bergerak bersama anda.';

  @override
  String get gatheringNameHint =>
      'Nama perhimpunan, cth. Bunga api Tahun Baru KLCC';

  @override
  String get gatheringEmojiHint => 'Ikon';

  @override
  String get gatheringEmojiHelp =>
      'Ikon perhimpunan ialah satu emoji yang belum digunakan sesiapa berdekatan.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'Sesiapa yang menambah $emoji pada nama panggilan mereka akan melihat pengumuman anda dan menerima pemberitahuan.';
  }

  @override
  String get start => 'Mula';

  @override
  String get end => 'Tamat';

  @override
  String get gatheringMaxDuration =>
      'Perhimpunan berlangsung paling lama 24 jam dan tamat secara automatik.';

  @override
  String get starting => 'Memulakan…';

  @override
  String get startGathering => 'Mulakan perhimpunan';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name telah tamat. Anda kembali ke bandar.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · Anda penganjur';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'Orang dalam lingkungan 5 km yang ada $emoji pada nama mereka akan melihat pengumuman dan menerima pemberitahuan. Anda tidak dapat melihat siapa mereka.';
  }

  @override
  String get postAnnouncement => 'Siarkan pengumuman';

  @override
  String get announcementHint => 'cth. Kita berkumpul di pintu keluar A stesen';

  @override
  String get announcementSent => 'Pengumuman dihantar';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix =>
      ' (disembunyikan selepas banyak laporan)';

  @override
  String get groupQuestion => 'Tanya semua';

  @override
  String get questionHint => 'cth. Apa khabar anda sekarang?';

  @override
  String get sendQuestion => 'Tanya';

  @override
  String get questionSent => 'Soalan dihantar. Semua akan menjawab dengan mood';

  @override
  String get handOff => 'Serahkan';

  @override
  String handoffPending(String name) {
    return '$name dijemput untuk mengambil alih penganjuran. Menunggu jawapan…';
  }

  @override
  String get theOtherPerson => 'mereka';

  @override
  String get handoffCancelled => 'Jemputan penyerahan dibatalkan';

  @override
  String get handoffHelp =>
      'Tekan lama gelembung peserta di radar → Serahkan penganjuran. Selepas mereka terima, mereka menjadi penganjur dan perhimpunan diteruskan tanpa gangguan.';

  @override
  String get confirmEndAgain => 'Tamatkan? Ketik sekali lagi';

  @override
  String get endGathering => 'Tamatkan perhimpunan';

  @override
  String tallyHeader(String question, int total) {
    return '“$question” · $total jawapan';
  }

  @override
  String get tallyQuiet =>
      'Peratusan dipaparkan selepas 10 jawapan, supaya tiada sesiapa dapat diteka apabila sedikit orang menjawab.';

  @override
  String get bannerYouHost => '  · Anda penganjur';

  @override
  String get bannerHostAnnouncement => '  · Daripada penganjur';

  @override
  String get manageGathering => 'Urus perhimpunan';

  @override
  String get reportAnnouncement => 'Laporkan pengumuman ini';

  @override
  String get expandAnnouncement => 'Tunjukkan pengumuman';

  @override
  String get collapseAnnouncement => 'Sembunyikan pengumuman';

  @override
  String hostHandedOffAgo(String ago) {
    return 'Penganjur baharu · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'Anda melaporkan pengumuman ini, jadi ia telah dibuang dari skrin anda.';

  @override
  String get noAnnouncementHost =>
      'Belum ada pengumuman. Ketik ikon pelaras di kanan atas untuk menyiarkan yang pertama.';

  @override
  String get noAnnouncementGuest => 'Penganjur belum menyiarkan apa-apa.';

  @override
  String hostAsks(String question) {
    return 'Penganjur bertanya: $question';
  }

  @override
  String get answeredNote =>
      'Sudah dijawab. Penganjur hanya melihat peratusan mood keseluruhan.';

  @override
  String get answerHint => 'Jawab dengan satu mood';

  @override
  String get sendAnswer => 'Hantar jawapan';

  @override
  String handoffInvited(String name) {
    return '$name dijemput untuk mengambil alih penganjuran. Menunggu jawapan (sah selama 5 minit).';
  }

  @override
  String handoffTitle(String name) {
    return 'Serahkan perhimpunan kepada $name';
  }

  @override
  String get handoffBody =>
      'Selepas mereka terima, mereka menganjurkan perhimpunan ini. Nama, pengumuman dan soalan kekal, dan anda menjadi peserta.';

  @override
  String get handoffPublic => 'Umumkan penyerahan';

  @override
  String get handoffPublicHelp => 'Beritahu semua peserta ada penganjur baharu';

  @override
  String get handoffQuiet => 'Serahkan secara senyap';

  @override
  String get handoffQuietHelp =>
      'Tiada sesiapa diberitahu. Hanya gelang penganjur di radar yang berpindah';

  @override
  String get sending => 'Menghantar…';

  @override
  String get sendInvite => 'Hantar jemputan';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'Anda kini penganjur $emoji $name.';
  }

  @override
  String get handoffOfferTitle => 'Sudi ambil alih penganjuran?';

  @override
  String handoffOfferBody(String name) {
    return 'Penganjur ingin menyerahkan “$name” kepada anda. Sebagai penganjur, anda boleh menyiarkan pengumuman, bertanya soalan dan menamatkan perhimpunan, dan anda bertanggungjawab atas apa yang anda siarkan.';
  }

  @override
  String get processing => 'Memproses…';

  @override
  String get acceptHosting => 'Ambil alih';

  @override
  String get guideS1Title => '1. Masuk ke bandar';

  @override
  String get guideS1L1 =>
      'Kali pertama anda membuka app, sahkan anda berumur 18 tahun ke atas dan benarkan lokasi tepat semasa menggunakan app. Tanpa lokasi tepat, radar tidak dapat berfungsi.';

  @override
  String get guideS1L2 =>
      'Tulis satu ayat tentang perasaan anda sekarang (hingga 20 aksara), setuju dengan Terma Penggunaan dan Dasar Privasi, kemudian ketik Masuk Mood Whisper.';

  @override
  String get guideS1L3 =>
      'Tiada nombor telefon, e-mel atau nama sebenar diperlukan. Akaun anda tanpa nama dan terikat pada telefon ini.';

  @override
  String get guideS1L4 =>
      'Perkataan dalam mood anda menentukan warnanya: “gembira, ketawa” emas, “sedih, menangis” biru, “marah” merah jingga, “tenang, termenung” hijau, “bersemangat” jingga, “cinta, hati” merah jambu, dan selainnya ungu lembut.';

  @override
  String get guideS2Title => '2. Bar bawah';

  @override
  String get guideS2L1 =>
      'Ketik foto anda di sebelah kiri untuk mengubah foto, nama panggilan (hingga 10 aksara) dan mood.';

  @override
  String get guideS2L2 => 'Ikon nota: tinggalkan bisikan di sini.';

  @override
  String get guideS2L3 =>
      'Ikon kongsi: jadikan mood anda kad pemandangan malam.';

  @override
  String get guideS2L4 => 'Ikon pelaras di paling kanan: buka Tetapan.';

  @override
  String get guideS3Title => '3. Radar dan gelembung';

  @override
  String get guideS3L1 =>
      'Gelembung mood orang dalam lingkungan 5 km muncul di radar. Hanya julat jarak anggaran ditunjukkan (seperti “dalam 100 m”), bukan alamat.';

  @override
  String get guideS3L2 =>
      'Gelembung yang bernafas bermakna orang itu sedang menggunakan app. Gelembung malap bertanda Berehat bermakna skrin mereka dikunci, tetapi anda masih boleh mengetuk. Gelembung kelabu tanpa nama ialah gema pudar daripada seseorang yang baru pergi, dan ia pudar perlahan-lahan.';

  @override
  String get guideS3L3 =>
      'Cubit untuk zum peta. Pusingkan telefon dan radar berpusing bersama anda.';

  @override
  String get guideS3L4 =>
      'Apabila gelembung berkerumun, ia bergabung menjadi bola cahaya, “N mood di sini”. Ketik untuk membukanya dalam bulatan supaya setiap satu boleh diketik; ketik tengah atau ruang kosong untuk menutupnya.';

  @override
  String get guideS3L5 =>
      'Nama yang bermula dengan Demo ialah orang demo yang membalas secara automatik. Mereka bukan orang sebenar, dan anda boleh mencuba semua ciri dengan mereka.';

  @override
  String get guideS3L6 =>
      'Apabila tiada sesiapa berdekatan, “Anda cahaya pertama malam ini” muncul di bawah, dan anda boleh mengajak kawan menerangi kawasan anda.';

  @override
  String get guideS4Title => '4. Mengetuk dan bersembang';

  @override
  String get guideS4L1 =>
      'Tekan lama gelembung seseorang → Ketuk. Mereka ada 5 minit untuk terima, tolak atau langkau. Semasa menunggu, satu garis cahaya mengalir dari anda kepada mereka.';

  @override
  String get guideS4L2 =>
      'Selepas mereka terima, sembang bermula dengan kiraan detik 10 minit. Setiap mesej baharu memulakannya semula, dan sembang tamat apabila kedua-dua senyap.';

  @override
  String get guideS4L3 =>
      'Apabila sembang tamat, mesej dipadam dari pelayan. Orang lain masih boleh mengambil tangkapan skrin, jadi kongsi dengan berhati-hati.';

  @override
  String get guideS4L4 =>
      'Apabila seseorang mengetuk, kad ketukan muncul. Anda boleh terima, tolak, langkau atau terus melapor.';

  @override
  String get guideS5Title => '5. Kerlipan';

  @override
  String get guideS5L1 =>
      'Ketik dua kali gelembung seseorang, atau tekan lama dan pilih Hantar kerlipan, untuk memberitahu mereka ada yang perasan tanpa berkata apa-apa.';

  @override
  String get guideS5L2 =>
      'Mereka hanya melihat “N kerlipan bergema dengan anda malam ini” dan tidak pernah tahu siapa yang menghantarnya. Anda boleh menghantar satu kerlipan kepada orang yang sama setiap 24 jam.';

  @override
  String get guideS6Title => '6. Bisikan';

  @override
  String get guideS6L1 =>
      'Ketik ikon nota di bar bawah untuk meninggalkan satu ayat di tempat anda berada (hingga 60 aksara).';

  @override
  String get guideS6L2 =>
      'Selama 7 hari, sesiapa dalam lingkungan 300 m akan melihat sampul di radar dan boleh membukanya untuk membaca.';

  @override
  String get guideS6L3 =>
      'Bisikan sentiasa tanpa nama. Anda boleh ada hingga 3 serentak, tinggalkan paling banyak 1 setiap 10 minit, dan tarik balik bila-bila masa.';

  @override
  String get guideS6L4 =>
      'Surat ke masa depan: semasa menulis bisikan, pilih Untuk diri saya pada masa depan, kemudian sebulan atau setahun. Hanya anda boleh melihatnya. Apabila tiba masanya anda akan diberitahu, dan ia terbuka sendiri apabila anda kembali dalam lingkungan 100 m. Ia hanya boleh dibaca sekali. Hanya anda melihat jam pasir kecil di radar (berkunci atau tidak), dan ia tidak boleh diketik. Anda boleh ada hingga 5 serentak; lihat atau padam dalam Tetapan → Surat ke masa depan.';

  @override
  String get guideS7Title => '7. Cuaca mood bandar';

  @override
  String get guideS7L1 =>
      'Label di kiri atas menunjukkan mood paling biasa dalam lingkungan 20 km sepanjang 24 jam lalu. Ketik untuk pecahan penuh.';

  @override
  String get guideS7L2 =>
      'Peratusan disembunyikan jika kurang daripada 10 orang, supaya tiada sesiapa dapat dikenal pasti.';

  @override
  String get guideS8Title => '8. Perhimpunan';

  @override
  String get guideS8L1 =>
      'Untuk memulakan: Tetapan → Anjurkan perhimpunan → masukkan nama, satu emoji sebagai ikon, dan masa mula serta tamat (hingga 24 jam) → Mulakan perhimpunan.';

  @override
  String get guideS8L2 =>
      'Perhimpunan meliputi 5 km di sekeliling penganjur dan bergerak bersama mereka. Penganjur ada gelang cahaya dan label Penganjur di radar.';

  @override
  String get guideS8L3 =>
      'Penganjur boleh menyiarkan pengumuman (seberapa banyak yang perlu), bertanya soalan kepada semua dan menamatkan perhimpunan bila-bila masa.';

  @override
  String get guideS8L4 =>
      'Untuk menyertai, tambahkan ikon perhimpunan pada nama panggilan anda (contohnya “Kucing Berkelana🌈”). Selagi anda dalam kawasan, anda akan melihat pengumuman yang disematkan di atas radar dan menerima pemberitahuan. Buang ikon untuk keluar.';

  @override
  String get guideS8L5 =>
      'Soalan kumpulan: jawab dengan satu mood. Penganjur hanya melihat peratusan mood keseluruhan, bukan siapa menjawab apa, dan peratusan disembunyikan bawah 10 jawapan.';

  @override
  String get guideS8L6 =>
      'Hanya satu perhimpunan boleh menggunakan satu ikon di kawasan yang sama pada satu masa. Selepas tamat, sesiapa boleh menggunakannya.';

  @override
  String get guideS8L7 =>
      'Penyerahan: penganjur menekan lama gelembung peserta → Serahkan penganjuran, dan memilih penyerahan yang diumumkan atau senyap. Jika orang itu terima dalam 5 minit, mereka menjadi penganjur, dan pengumuman serta soalan kekal. Penganjur sebelumnya menjadi peserta dan ikon ditambah pada nama mereka.';

  @override
  String get guideS9Title => '9. Suar Bandar (tandas mesra semua)';

  @override
  String get guideS9L1 =>
      'Ketik ikon tandas di kiri bawah peta untuk menghidupkan suar. Tandas mesra jantina, OKU dan keluarga dalam lingkungan 2 km muncul di radar, dengan bilangan di sebelah ikon. Ketik tiga penapis bulat di atasnya untuk menunjukkan jenis tertentu sahaja.';

  @override
  String get guideS9L2 =>
      'Ketik penanda untuk melihat tingkat, kemudahan dan jarak, dan ketik Jalan kaki ke sana untuk arah dalam app peta anda.';

  @override
  String get guideS9L3 =>
      'Data daripada rekod tandas awam Kementerian Alam Sekitar Taiwan dan dikemas kini setiap bulan. Waktu buka tidak disertakan; “Mungkin buka pada waktu malam” ialah anggaran kami berdasarkan jenis tempat.';

  @override
  String get guideS9L4 =>
      'Jika ada yang salah, anda boleh melaporkannya (bukan mesra jantina, tutup pada waktu malam, tidak dijumpai). Apabila 3 orang melaporkan masalah yang sama, penanda menjadi kelabu dengan nota.';

  @override
  String get guideS10Title => '10. Kad mood dan jejak mood';

  @override
  String get guideS10L1 =>
      'Butang kongsi di bar bawah menjadikan mood semasa anda kad pemandangan malam, sesuai untuk Instagram Stories. Kad tidak pernah menunjukkan lokasi anda.';

  @override
  String get guideS10L2 =>
      'Tetapan → Jejak mood saya membolehkan anda melihat semula mood dan tempat yang pernah anda tulis. Ia disimpan hanya dalam telefon anda, dan anda boleh mematikan atau mengosongkannya bila-bila masa.';

  @override
  String get guideS11Title => '11. Tetapan dan pemberitahuan';

  @override
  String get guideS11L1 =>
      'Peringatan malam: peringatan lembut pada 21:30 setiap malam. Hidupkan atau matikan dalam Tetapan.';

  @override
  String get guideS11L2 =>
      'Ketukan, mesej baharu, kerlipan dan pengumuman perhimpunan tiba sebagai pemberitahuan. Anda boleh mematikannya dalam tetapan telefon.';

  @override
  String get guideS11L3 =>
      'Setiap Jumaat 21:00 hingga 23:00 ialah Malam Bercahaya, apabila semua dalam talian bersama dan bandar paling terang.';

  @override
  String get guideS12Title => '12. Melapor dan menyekat';

  @override
  String get guideS12L1 =>
      'Anda boleh melapor dari menu tekan lama gelembung, kad ketukan, kanan atas sembang, bisikan atau pengumuman perhimpunan. Selepas melapor, orang atau siaran itu hilang dari skrin anda serta-merta dan sembang tamat. Kami mengendalikan setiap laporan dalam 24 jam.';

  @override
  String get guideS12L2 =>
      'Mood, nama, bisikan, mesej sembang dan pengumuman perhimpunan ditapis secara automatik untuk kata-kata kesat dan butiran hubungan seperti nombor telefon dan pautan.';

  @override
  String get guideS12L3 =>
      'Selepas anda menyekat seseorang, anda hilang dari radar masing-masing dan tidak boleh mengetuk atau menghantar kerlipan. Buang sekatan dalam Tetapan → Orang yang disekat.';

  @override
  String get guideS12L4 =>
      'Jika anda dalam bahaya segera, hubungi nombor kecemasan tempatan (999 di Malaysia, 110 di Taiwan).';

  @override
  String get guideS13Title => '13. Privasi dan akaun anda';

  @override
  String get guideS13L1 =>
      'Orang berdekatan boleh melihat mood, nama panggilan, foto dan jarak anggaran anda. Lokasi anda hanya digunakan semasa anda menggunakan app.';

  @override
  String get guideS13L2 =>
      'Tetapan → Padam akaun dan data memadam selama-lamanya semua yang anda tinggalkan di bandar, bila-bila masa.';

  @override
  String get guideS13L3 =>
      'Ada soalan? Pergi ke Tetapan → Hubungi kami, atau e-mel service.softchip@gmail.com.';

  @override
  String get guideIntro =>
      'Mood Whisper ialah bandar pada waktu malam: tulis satu ayat tentang perasaan anda sekarang, dan lihat perasaan orang di sekeliling anda.';

  @override
  String get beaconGender => 'Mesra jantina';

  @override
  String get beaconAccessible => 'OKU';

  @override
  String get beaconFamily => 'Keluarga';

  @override
  String get beaconReportNotGender => 'Bukan mesra jantina';

  @override
  String get beaconReportClosed => 'Tutup pada waktu malam';

  @override
  String get beaconReportMissing => 'Tandas ini tidak dijumpai';

  @override
  String get beaconFlagNotGender => 'Dilaporkan: bukan mesra jantina';

  @override
  String get beaconFlagClosed => 'Dilaporkan: tutup pada waktu malam';

  @override
  String get beaconFlagMissing => 'Dilaporkan: tidak dijumpai';

  @override
  String get beaconDefaultName => 'Tandas awam';

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
      'Suar Bandar tidak tersedia sekarang. Sila cuba lagi nanti.';

  @override
  String get notConnectedCheckNetwork =>
      'Tidak dapat bersambung. Semak sambungan anda dan cuba lagi.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'Tandas $features, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Matikan Suar Bandar (tandas mesra semua), $count berdekatan';
  }

  @override
  String get beaconToggleOn => 'Hidupkan Suar Bandar (tandas mesra semua)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Tunjukkan $feature sahaja';
  }

  @override
  String get beaconMaybeOpenNight => 'Mungkin buka pada waktu malam (anggaran)';

  @override
  String get beaconMaybeDaytime => 'Mungkin buka siang sahaja (anggaran)';

  @override
  String get walkThere => 'Jalan kaki ke sana';

  @override
  String get beaconWrongData => 'Ada yang salah?';

  @override
  String beaconThanks(String reason) {
    return 'Terima kasih. Laporan anda telah diterima: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Sumber: rekod tandas awam Kementerian Alam Sekitar Taiwan, dikemas kini setiap bulan. Waktu buka ialah anggaran kami berdasarkan jenis tempat.';

  @override
  String get invite1 =>
      'Saya nyalakan satu cahaya di Mood Whisper. Lebih ramai orang berdekatan, lebih terang kawasan kita. Jom terangi bersama:';

  @override
  String get invite2 =>
      'Bandar agak sunyi malam ini. Tulis satu mood di Mood Whisper dan bantu terangi kawasan kita:';

  @override
  String get invite3 =>
      'Tak perlu tambah kawan, tak perlu nama sebenar, cuma satu ayat tentang perasaan anda. Cari saya di Mood Whisper:';

  @override
  String get invite4 =>
      'Saya tinggalkan satu cahaya untuk anda di Mood Whisper. Buka app dan lihat apa yang orang berdekatan rasa malam ini:';

  @override
  String get invite5 =>
      'Setiap Jumaat jam 9 malam ialah Malam Bercahaya di Mood Whisper. Jom dalam talian bersama dan penuhi radar dengan cahaya:';

  @override
  String get invite6 =>
      'Perlukan tempat untuk luahkan hari anda? Mood Whisper tanpa nama, dan kata-kata anda pudar selepas diluahkan:';

  @override
  String get invite7 =>
      'Pernah tertanya apa yang dirasai orang yang anda selisih di jalan? Lihat sendiri di Mood Whisper:';

  @override
  String get invite8 =>
      'Saya tinggalkan bisikan di jalan ini yang hanya boleh dibaca oleh orang yang lalu. Jom tinggalkan satu juga:';

  @override
  String get invite9 =>
      'Mood Whisper ialah peta mood bandar pada waktu malam. Lebih ramai lebih seronok, jadi jom tambah cahaya di kawasan kita:';

  @override
  String get invite10 =>
      'Apa warna mood anda malam ini? Tulis di Mood Whisper. Saya berdekatan, menanti cahaya anda:';

  @override
  String get shareInvite => 'Kongsi jemputan';

  @override
  String get inviteSubject => 'Jom terangi kawasan kita bersama';

  @override
  String get shareMoodCardButton => 'Kongsi kad';

  @override
  String moodShareText(String mood) {
    return 'Saya kongsi perasaan saya sekarang di Mood Whisper: “$mood”\nAdakah mood anda juga bersinar di bandar malam ini?';
  }

  @override
  String get shareFailed => 'Tidak dapat dikongsi. Sila cuba lagi.';

  @override
  String shuffleCard(int current, int total) {
    return 'Tukar · $current / $total';
  }

  @override
  String get preparing => 'Menyediakan…';

  @override
  String get sendLinkToFriends =>
      'Hantar pautan kepada kawan (WhatsApp, Messenger)';

  @override
  String get partLateNight => 'Lewat malam';

  @override
  String get partMorning => 'Pagi';

  @override
  String get partAfternoon => 'Petang';

  @override
  String get partDusk => 'Senja';

  @override
  String get partNight => 'Malam';

  @override
  String get cardInviteEyebrow => 'Jemputan';

  @override
  String get cardMoodEyebrow => 'Perasaan saya sekarang';

  @override
  String get cardInviteTitle => 'Jom terangi\nkawasan kita';

  @override
  String get cardInviteBody =>
      'Saya nyalakan satu cahaya di Mood Whisper.\nLebih ramai berdekatan, lebih terang kawasan kita.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nDi suatu sudut bandar';
  }

  @override
  String get whisperUnavailable =>
      'Bisikan tidak tersedia sekarang. Sila cuba lagi nanti.';

  @override
  String get whisperNotSent =>
      'Bisikan anda tidak dihantar. Semak sambungan anda dan cuba lagi.';

  @override
  String daysAgo(int count) {
    return '$count hari lalu';
  }

  @override
  String get timeWhisperTitle => 'Surat ke masa depan';

  @override
  String get timeWhisperLead =>
      'Tulis kepada diri anda pada masa depan. Apabila tiba masanya, kembali ke sini untuk membukanya.';

  @override
  String get whisperLead => 'Tulis kepada orang seterusnya yang lalu di sini.';

  @override
  String get toPassersBy => 'Untuk orang yang lalu';

  @override
  String get toFutureSelf => 'Untuk diri saya pada masa depan';

  @override
  String get inOneMonth => 'Sebulan lagi';

  @override
  String get inOneYear => 'Setahun lagi';

  @override
  String get timeWhisperHint =>
      'cth. Jumpa di sini tahun depan. Semoga anda lebih baik daripada sekarang.';

  @override
  String get whisperHint =>
      'cth. Matahari terbenam di sini cantik. Jangan lupa pandang ke atas.';

  @override
  String get timeWhisperCaptionYear =>
      'Hanya anda boleh lihat · dibuka setahun lagi dan anda diberitahu · terbuka dalam 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Hanya anda boleh lihat · dibuka sebulan lagi dan anda diberitahu · terbuka dalam 100 m';

  @override
  String get whisperCaption =>
      'Pudar dalam 7 hari · tidak menunjukkan siapa anda · hanya bahawa anda pernah di sekitar sini';

  @override
  String get sealHere => 'Meterai di sini';

  @override
  String get leaveHere => 'Tinggalkan di sini';

  @override
  String get aWhisper => 'Satu bisikan';

  @override
  String whisperLeftAgo(String ago) {
    return 'Ditinggalkan di sekitar sini $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    return 'Dibaca oleh $count orang';
  }

  @override
  String get whisperNobodyYet => 'Belum ada sesiapa yang lalu';

  @override
  String get withdrawWhisper => 'Tarik balik bisikan ini';

  @override
  String get whisperCollected => 'Anda mengambil bisikan ini.';

  @override
  String whisperReadersBefore(int count) {
    return '$count orang telah lalu di sini sebelum anda.';
  }

  @override
  String get whisperFirstReader => 'Anda orang pertama yang lalu di sini.';

  @override
  String get reportWhisper => 'Laporkan bisikan ini';

  @override
  String get thisWhisper => 'Bisikan ini';

  @override
  String get chatTimeUp => 'Masa tamat. Detik ini pudar...';

  @override
  String get chatOtherLeft => 'Mereka telah hilang ke dalam bandar...';

  @override
  String get chatEnded => 'Detik ini telah tamat...';

  @override
  String get chatBlockedEnded => 'Disekat. Perbualan telah tamat.';

  @override
  String get chatReportedEnded => 'Dilaporkan. Perbualan telah tamat.';

  @override
  String get anonymous => 'Tanpa nama';

  @override
  String get leaveChat => 'Tinggalkan perbualan';

  @override
  String chatWith(String name) {
    return 'Detik bersama $name';
  }

  @override
  String get countdownPrefix => 'Pudar dalam ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Perbualan demo: balasan adalah automatik, bukan daripada orang sebenar.';

  @override
  String get typing => 'Sedang menaip…';

  @override
  String get chatHint => 'Katakan sesuatu dengan lembut…';

  @override
  String get send => 'Hantar';

  @override
  String get chatDissolvedApart =>
      'Anda berdua kembali ke bandar masing-masing';

  @override
  String get knockTooOften =>
      'Anda terlalu kerap mengetuk. Tarik nafas bersama bandar...';

  @override
  String get otherNotNow =>
      'Mereka tidak mahu diganggu sekarang. Beri sedikit ruang antara satu sama lain.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'Mereka tidak mahu diganggu sekarang. Beri sedikit ruang antara satu sama lain ($minutes min).';
  }

  @override
  String get justEndedRest =>
      'Anda berdua baru sahaja berpisah. Biarkan kenangan itu mengendap sebentar.';

  @override
  String get intro1Title => 'Menyelinap ke dalam bandar';

  @override
  String get intro1Body =>
      'Tinggalkan label sosial. Di atas kanvas gelap yang tenang, yang tinggal hanyalah perasaan sebenar anda, dan di mana anda berada.';

  @override
  String get intro2Title => 'Detik yang berlalu';

  @override
  String get intro2Body =>
      'Nampak gelembung mood terapung berdekatan? Ketuk perlahan dan kongsi perbualan sekali seumur hidup dengan seseorang yang lalu.';

  @override
  String get intro3Title => 'Rentak bandar';

  @override
  String get intro3Body =>
      'Kami peduli perasaan anda. Selepas mengetuk, tunggu jawapan dengan tenang. Jika bukan jodoh, gelembung akan pudar selepas 300 saat.';

  @override
  String get intro4Title => 'Jarak yang lembut';

  @override
  String get intro4Body =>
      'Tidak mahu diganggu? Tolak atau sekat. Sistem bertenang menjauhkan kebisingan dan mengembalikan sudut tenang anda.';

  @override
  String get intro5Title => 'Sedia untuk bertemu?';

  @override
  String get intro5Body =>
      'Pejamkan mata dan rasai getaran telefon dan degupan jantung anda. Sekarang, tulis perasaan anda dan masuk ke Mood Whisper.';

  @override
  String get loadingImage => 'Memuatkan imej...';

  @override
  String get startExploring => 'Mula meneroka';

  @override
  String get nextPage => 'Seterusnya';

  @override
  String get feedbackSubject => 'Maklum balas Mood Whisper';

  @override
  String get loginNeedMood =>
      'Tulis perasaan anda sekarang, kemudian masuk ke bandar.';

  @override
  String get loginNeedAgree =>
      'Sila baca dan setuju dengan Terma Penggunaan dan Dasar Privasi dahulu.';

  @override
  String get loginCantConnect =>
      'Tidak dapat mencapai bandar. Semak sambungan anda dan cuba lagi.';

  @override
  String get ageQuestion => 'Adakah anda berumur 18 tahun ke atas?';

  @override
  String get ageReason =>
      'Mood Whisper menghubungkan anda dengan orang asing berdekatan, jadi ia hanya untuk mereka berumur 18 tahun ke atas.';

  @override
  String get ageUnder => 'Saya bawah 18 tahun';

  @override
  String get ageOver => 'Saya 18 tahun ke atas';

  @override
  String get loginTitle1 => 'Sedia';

  @override
  String get loginTitle2 => 'untuk bertemu?';

  @override
  String get loginLead =>
      'Pejamkan mata dan rasai getaran telefon dan degupan jantung anda.\nSekarang, tulis perasaan anda dan masuk ke Mood Whisper.';

  @override
  String get loginPrompt =>
      'Apa yang ingin anda katakan kepada bandar sekarang?';

  @override
  String get loginHint => 'cth. Baru minum kopi yang sedap😊';

  @override
  String get enterCity => 'Masuk Mood Whisper';

  @override
  String get agreeSemantic =>
      'Saya telah membaca dan bersetuju dengan Terma Penggunaan dan Dasar Privasi';

  @override
  String get agreePrefix => 'Saya telah membaca dan bersetuju dengan ';

  @override
  String get termsLink => 'Terma Penggunaan';

  @override
  String get agreeAnd => ' dan ';

  @override
  String get privacyLink => 'Dasar Privasi';

  @override
  String get agreeSuffix =>
      '. Mood Whisper tidak bertolak ansur dengan gangguan, kandungan seksual, kebencian atau penyalahgunaan lain. Sesiapa yang melanggar peraturan ini akan dikeluarkan.';

  @override
  String get under18Title =>
      'Mood Whisper hanya untuk mereka berumur 18 tahun ke atas';

  @override
  String get under18Body =>
      'Terima kasih kerana jujur. Bandar ini menghubungkan anda dengan orang asing. Jumpa lagi apabila anda berumur 18 tahun.';

  @override
  String get clearMoodTrail => 'Kosongkan jejak mood';

  @override
  String get clearMoodTrailBody =>
      'Semua jejak mood dalam telefon ini akan dipadam. Tindakan ini tidak boleh dibatalkan.';

  @override
  String get clear => 'Kosongkan';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'Disimpan hanya dalam telefon anda. Tidak dimuat naik ke mana-mana.';

  @override
  String get moodTrailEmpty =>
      'Belum ada jejak mood minggu ini. Setiap kali anda menulis mood atau pergi ke tempat baharu, satu lagi cahaya muncul di sini.';

  @override
  String get thisWeekYou => 'Minggu anda';

  @override
  String get topMoodPrefix => 'Anda paling kerap rasa “';

  @override
  String topMoodSuffix(int count) {
    return '”, sebanyak $count kali';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$total mood ditinggalkan di $places tempat berbeza';
  }

  @override
  String get recordMoodTrail => 'Rekod jejak mood saya';

  @override
  String get recordMoodTrailOff =>
      'Apabila dimatikan, tiada jejak baharu direkodkan';

  @override
  String get nightly1 => 'Apa yang bandar fikirkan malam ini?';

  @override
  String get nightly2 =>
      'Seseorang berdekatan sedang menulis perasaan mereka sekarang.';

  @override
  String get nightly3 =>
      'Malam yang sempurna. Tinggalkan satu ayat untuk bandar.';

  @override
  String get nightly4 =>
      'Bagaimana hari ini? Mood anda akan bersinar di bandar.';

  @override
  String get nightly5 =>
      'Lampu jalan sudah menyala, dan orang berdekatan masih berjaga.';

  @override
  String get nightly6 => 'Akhiri hari ini: apa perasaan anda sekarang?';

  @override
  String get nightly7 => 'Siapa yang akan anda selisih malam ini?';

  @override
  String get nightlyChannel => 'Peringatan malam';

  @override
  String get nightlyChannelDesc =>
      'Satu peringatan lembut setiap malam. Anda boleh mematikannya dalam tetapan app.';

  @override
  String get reasonHarassment => 'Gangguan atau buli';

  @override
  String get reasonSexual => 'Kandungan seksual';

  @override
  String get reasonScam => 'Penipuan atau spam';

  @override
  String get reasonHate => 'Kebencian atau keganasan';

  @override
  String get reasonImpersonation => 'Penyamaran';

  @override
  String get reasonOther => 'Lain-lain';

  @override
  String get reportReceived =>
      'Laporan diterima dan dibuang dari skrin anda. Kami akan menyemaknya dalam 24 jam.';

  @override
  String get reportNotSent =>
      'Laporan anda tidak dihantar. Semak sambungan anda dan cuba lagi.';

  @override
  String reportTarget(String target) {
    return 'Laporkan $target';
  }

  @override
  String get reportPrivate =>
      'Mereka tidak akan tahu anda melaporkan mereka. Pilih sebab:';

  @override
  String get reportDetails => 'Butiran lanjut (pilihan)';

  @override
  String get reportWhatHappened => 'Apa yang berlaku?';

  @override
  String get sendReport => 'Hantar laporan';

  @override
  String get alsoBlock =>
      'Sekat mereka juga. Anda akan hilang dari bandar masing-masing.';

  @override
  String get aYearAgo => 'Setahun lalu';

  @override
  String get aMonthAgo => 'Sebulan lalu';

  @override
  String get timeWhisperUnavailable =>
      'Surat ke masa depan tidak tersedia sekarang. Sila cuba lagi nanti.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, anda berkata di sini';
  }

  @override
  String writtenOn(String date) {
    return 'Ditulis $date';
  }

  @override
  String get timeWhisperOnce => 'Surat ini hanya muncul sekali.';

  @override
  String get keepInHeart => 'Simpan dalam hati';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Dibuka $unlock · ditulis $created';
  }

  @override
  String get unsealedGoBack =>
      'Sudah dibuka. Kembali ke sana untuk membukanya.';

  @override
  String unsealedDistance(String distance) {
    return 'Sudah dibuka · $distance dari anda';
  }

  @override
  String get timeWhisperListLead =>
      'Surat untuk diri anda pada masa depan yang hanya anda boleh lihat. Apabila tiba masanya, pergi dalam lingkungan 100 m dari tempat itu untuk membukanya. Selepas dibaca, ia hilang.';

  @override
  String get timeWhisperListEmpty =>
      'Belum ada surat ke masa depan. Ketik ikon nota di bar bawah dan pilih “Untuk diri saya pada masa depan”.';

  @override
  String get readyToOpen => 'Sedia dibuka';

  @override
  String get sealed => 'Dimeterai';

  @override
  String get delete => 'Padam';

  @override
  String get within100m => 'Dalam 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Menunggu $name menjawab, tinggal $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'Menunggu $name';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Ikut telefon';

  @override
  String get parallelUniverse => 'Alam Selari';

  @override
  String get parallelUniverseSubtitle =>
      'Lihat perasaan bandar lain sekarang, dan biar mereka lihat anda';

  @override
  String get parallelUniverseIntroTitle => 'Masuk ke Alam Selari';

  @override
  String get parallelUniverseIntroBody =>
      'Apabila dihidupkan, semua orang yang sedang dalam talian di bandar lain diunjurkan ke radar anda, dan mereka semua dapat melihat anda.\n\nKedudukan diunjurkan mengikut skala bandar dan dikaburkan kira-kira 500 m, jadi tiada siapa dapat melihat lokasi atau jarak sebenar anda. Anda masih boleh menghantar cahaya, mengetuk dan berbual, dan boleh mematikannya bila-bila masa.';

  @override
  String get parallelUniverseEnter => 'Masuk';

  @override
  String get parallelUniverseNoCity => 'Belum ada Alam Selari di tempat anda';

  @override
  String parallelFrom(String city) {
    return 'Selari · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'Orang ini berada di $city, bukan berhampiran anda. Kedudukannya diunjurkan dan bukan jarak sebenar.';
  }

  @override
  String get labelHost => 'Hos';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelResting => 'Berehat';

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
  String get citySingapore => 'Singapura';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityHochiminh => 'Bandar Ho Chi Minh';

  @override
  String get cityHanoi => 'Hanoi';

  @override
  String get translateTap => 'Ketik untuk terjemah';

  @override
  String get translateShowOriginal => 'Diterjemah · ketik untuk teks asal';

  @override
  String get translating => 'Menterjemah…';

  @override
  String get translateFailed =>
      'Tidak dapat menterjemah. Sila cuba lagi nanti.';

  @override
  String get translateDownloadTitle => 'Muat turun model terjemahan';

  @override
  String get translateDownloadBody =>
      'Kali pertama menterjemah bahasa ini memerlukan model terjemahan (kira-kira 30 MB setiap bahasa, sekali sahaja).\n\nTerjemahan dibuat sepenuhnya dalam telefon anda; mesej tidak dimuat naik.';

  @override
  String get translateDownload => 'Muat turun';
}
