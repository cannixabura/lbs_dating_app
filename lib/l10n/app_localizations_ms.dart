// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get checkInEnter => 'Daftar masuk di sini dan masuk';

  @override
  String get checkInNote =>
      'Selepas anda ketik, orang berdekatan akan melihat mood anda dan lebih kurang di mana anda berada. Anda daftar masuk sendiri setiap kali masuk.';

  @override
  String get checkInTitle => 'Daftar masuk ke bandar';

  @override
  String get checkInBody =>
      'Selepas anda daftar masuk, orang berdekatan dapat melihat mood anda dan lebih kurang di mana anda berada, dan anda juga akan melihat mereka. Mereka melihat tempat anda daftar masuk; ia tidak mengikut anda bergerak. Anda daftar masuk sendiri setiap kali membuka aplikasi; ia tidak berlaku secara automatik. Keluar atau beralih ke app lain akan menamatkan daftar masuk anda.';

  @override
  String get checkInButton => 'Daftar masuk di sini';

  @override
  String get checkInAgain =>
      'Anda telah meninggalkan tempat daftar masuk · Daftar masuk di sini';

  @override
  String get checkOutButton => 'Didaftar masuk · Keluar';

  @override
  String get checkedOutToast =>
      'Anda telah daftar keluar dan tidak lagi kelihatan di peta.';

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
  String get sensingCityHint =>
      'Jika bandar anda terasa terlalu sunyi sekarang, masuki Alam Selari atau Dunia Kuantum untuk bertemu orang dari bandar lain.';

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
      'Tulis satu ayat tentang perasaan anda sekarang (maksimum 20 aksara), setuju dengan Terma Penggunaan dan Dasar Privasi, kemudian ketik Daftar masuk di sini dan masuk.';

  @override
  String get guideS1L3 =>
      'Tiada nombor telefon, e-mel atau nama sebenar diperlukan. Akaun anda tanpa nama dan terikat pada telefon ini.';

  @override
  String get guideS1L4 =>
      'Perkataan dalam mood anda menentukan warnanya: “gembira, ketawa” emas, “sedih, menangis” biru, “marah” merah jingga, “tenang, termenung” hijau, “bersemangat” jingga, “cinta, hati” merah jambu, dan selainnya ungu lembut.';

  @override
  String get guideS1L5 =>
      'Daftar masuk: setiap kali membuka aplikasi, anda daftar masuk sendiri, dan barulah orang berdekatan dapat melihat mood anda dan lebih kurang di mana anda berada, dan anda melihat mereka. Ia tidak berlaku secara automatik. Orang lain melihat tempat anda daftar masuk; ia tidak mengikut anda bergerak. Jika anda bergerak lebih 1 km, Daftar masuk di sini muncul di bawah radar. Jika aplikasi berada di latar belakang lebih 30 minit, anda daftar masuk semula apabila kembali.';

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
      'Hanya orang yang telah daftar masuk dan sedang membuka app muncul di radar. Apabila seseorang keluar atau beralih ke app lain, gelembungnya terus hilang tanpa meninggalkan jejak.';

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
      'Perhimpunan meliputi 5 km di sekitar tempat hos daftar masuk; apabila hos daftar masuk semula, ia bergerak bersama. Hos mempunyai gelang cahaya dan label Hos di radar.';

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
  String get guideS10Title => '11. Kad mood dan jejak mood';

  @override
  String get guideS10L1 =>
      'Butang kongsi di bar bawah menjadikan mood semasa anda kad pemandangan malam, sesuai untuk Instagram Stories. Kad tidak pernah menunjukkan lokasi anda.';

  @override
  String get guideS10L2 =>
      'Tetapan → Jejak mood saya membolehkan anda melihat semula mood dan tempat yang pernah anda tulis. Ia disimpan hanya dalam telefon anda, dan anda boleh mematikan atau mengosongkannya bila-bila masa.';

  @override
  String get guideS11Title => '17. Tetapan dan pemberitahuan';

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
  String get guideS12Title => '18. Laporan dan sekatan';

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
  String get guideS13Title => '19. Privasi dan akaun anda';

  @override
  String get guideS13L1 =>
      'Hanya selepas anda daftar masuk, orang berdekatan dapat melihat mood, nama bandar, foto dan jarak anggaran anda. Mereka melihat tempat anda daftar masuk, bukan lokasi masa nyata.';

  @override
  String get guideS13L2 =>
      'Tetapan → Padam akaun dan data memadam selama-lamanya semua yang anda tinggalkan di bandar, bila-bila masa.';

  @override
  String get guideS13L3 =>
      'Ada soalan? Pergi ke Tetapan → Hubungi kami, atau e-mel service.softchip@gmail.com.';

  @override
  String get guideS14Title => '12. Alam Selari';

  @override
  String get guideS14L1 =>
      'Ketik glob di kanan atas radar untuk menghidupkannya, dan ketik lagi untuk mematikannya. Ia mati setiap kali anda membuka aplikasi.';

  @override
  String get guideS14L2 =>
      'Setiap bandar atau daerah di Taiwan berpusat di stesen pusatnya sendiri (Taipei Raya di Stesen Taipei, Taoyuan di Stesen Taoyuan, dan seterusnya) dan dipadankan dengan bandar di luar negara: Jepun, Korea, Hong Kong, Macau, Singapura, Malaysia, Indonesia, Vietnam, Thailand, Filipina dan Australia. Bandar di luar negara dipadankan dengan Taiwan.';

  @override
  String get guideS14L3 =>
      'Sejauh mana dan ke arah mana anda dari stesen anda, di situlah anda muncul di bandar mereka, pada jarak dan arah yang sama dari stesen mereka, dikaburkan kira-kira 500 m. Tiada siapa dapat melihat lokasi sebenar anda.';

  @override
  String get guideS14L4 =>
      'Anda saling melihat jika salah seorang menghidupkannya: apabila hidup, anda melihat semua orang di bandar padanan yang membuka aplikasi; apabila mati, anda hanya melihat orang yang menghidupkannya. Hanya orang yang telah daftar masuk dan membuka aplikasi muncul di bandar lain.';

  @override
  String get guideS14L5 =>
      'Orang dari Alam Selari mempunyai gelang putus-putus dan menunjukkan bandar mereka. Anda masih boleh menghantar cahaya, mengetuk dan berbual. Bisikan, surat ke masa depan dan perhimpunan kekal di tempat asal.';

  @override
  String get guideS15Title => '16. Terjemahan';

  @override
  String get guideS15L1 =>
      'Dalam sembang, apabila mesej bukan dalam bahasa anda, Ketik untuk terjemah muncul di bawahnya. Ketik untuk menterjemahnya, dan ketik lagi untuk melihat teks asal.';

  @override
  String get guideS15L2 =>
      'Gelembung mood di radar juga sama: apabila bukan dalam bahasa anda, ketik untuk terjemah dan ketik lagi untuk kembali ke teks asal.';

  @override
  String get guideS15L3 =>
      'Terjemahan dibuat sepenuhnya dalam telefon anda; teks tidak pernah dimuat naik. iPhone menggunakan terjemahan terbina dalam Apple, dan sistem bertanya sebelum memuat turun bahasa kali pertama. Android menggunakan Google ML Kit, yang bertanya dahulu kemudian memuat turun model bahasa kira-kira 30 MB. iPhone belum dapat menterjemah bahasa Melayu.';

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
      'Pejamkan mata dan rasai getaran telefon dan degupan jantung anda. Sekarang, tulis perasaan anda, daftar masuk di sini dan masuk ke Mood Whisper.';

  @override
  String get intro6Title => 'Surat untuk diri anda pada masa depan';

  @override
  String get intro6Body =>
      'Tinggalkan beberapa patah kata di tempat ini untuk diri anda sebulan atau setahun lagi. Ia hanya terbuka apabila anda kembali ke sini.';

  @override
  String get intro7Title => 'Bersinar bersama malam ini';

  @override
  String get intro7Body =>
      'Anjurkan perhimpunan dengan satu emoji sebagai isyarat rahsia. Sesiapa yang menambahnya pada nama mereka akan menerima pengumuman anda, dan seluruh kawasan bersinar bersama.';

  @override
  String get intro8Title => 'Alam Selari';

  @override
  String get intro8Body =>
      'Ketik glob dan bandar-bandar Taiwan bertindih dengan Tokyo, Seoul dan Kuala Lumpur. Lihat perasaan orang di tempat jauh sekarang, ketuk dan berbual, dan ketik untuk terjemah.';

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
  String get loginTitle2 => ' untuk bertemu?';

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
      'Apabila dihidupkan, semua orang yang sedang membuka aplikasi di bandar padanan anda muncul di radar anda, dan mereka semua dapat melihat anda. Bandar di Taiwan dipadankan dengan bandar di luar negara (seperti Tokyo, Seoul dan Kuala Lumpur), dan bandar di luar negara dipadankan dengan Taiwan.\n\nKedua-dua bandar diselaraskan pada pusat masing-masing (stesen pusat, atau dewan bandaraya jika tiada): sejauh mana dan ke arah mana anda dari pusat anda, di situlah anda muncul di bandar mereka, dikaburkan kira-kira 500 m, jadi tiada siapa dapat melihat lokasi atau jarak sebenar anda. Anda masih boleh menghantar cahaya, mengetuk dan berbual, dan boleh mematikannya bila-bila masa. Bisikan dan perhimpunan kekal di tempat asal.';

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

  @override
  String placeHint(String name) {
    return 'Ada lampu Tempat Mood berdekatan · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Dibuka hingga $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Tempat Mood: $name, $hours';
  }

  @override
  String get placeWrongData => 'Maklumat salah?';

  @override
  String placeReportSubject(String name) {
    return 'Maklumat Tempat Mood salah: $name';
  }

  @override
  String get placeHintsSetting => 'Petunjuk Tempat Mood';

  @override
  String get placeHintsSettingSubtitle =>
      'Petunjuk perlahan dalam aplikasi apabila anda melalui Tempat Mood yang dibuka (tiada pemberitahuan tolak)';

  @override
  String get guideS16Title => '10. Tempat Mood';

  @override
  String get guideS16L1 =>
      'Tempat Mood ialah kafe bebas yang bekerjasama dengan kami. Selepas anda daftar masuk, berjalan dalam lingkungan 150 m dari kafe yang sedang dibuka dan lampu kecil yang bernafas perlahan muncul di radar anda. Ia padam apabila anda berjalan pergi.';

  @override
  String get guideS16L2 =>
      'Ketik lampu untuk membuka kad tempat: pemandangan malam dari dalam kafe, waktu tutup hari ini, satu baris cerita mood daripada kafe (ketik untuk terjemah), alamat dan nombor telefon. Ketik Jalan ke sana untuk arah berjalan kaki dalam aplikasi peta. Lampu yang kadnya anda buka hari ini bercahaya lembut tanpa bernafas.';

  @override
  String get guideS16L3 =>
      'Kali pertama anda lalu, kad kecil di bahagian atas memberitahu anda, tanpa bunyi atau getaran. Paling banyak satu petunjuk bagi setiap tempat setiap 7 hari dan 2 petunjuk sehari. Matikan dalam Tetapan > Petunjuk Tempat Mood; lampu tetap kelihatan.';

  @override
  String get guideS16L4 =>
      'Seluruh senarai tempat dimuat turun ke telefon anda, dan sama ada anda berdekatan hanya ditentukan dalam telefon anda. Kami dan kafe tidak tahu tempat mana yang anda lalui. Kafe tidak boleh membayar untuk lebih kelihatan. Jika ada maklumat salah, laporkan di bahagian bawah kad.';

  @override
  String get placeGuestbook => 'Buku pelawat';

  @override
  String placeGuestbookLocked(int m) {
    return 'Masuk ke dalam (dalam lingkungan kira-kira $m m) untuk membaca kata-kata yang ditinggalkan oleh orang yang pernah duduk di sini.';
  }

  @override
  String get placeGuestbookAbout =>
      'Hanya orang di dalam boleh membacanya. Tanpa nama, hilang selepas 30 hari.';

  @override
  String get placeGuestbookEmpty => 'Belum ada nota. Tinggalkan yang pertama.';

  @override
  String get placeGuestbookWrite => 'Tinggalkan nota';

  @override
  String get placeGuestbookHint => 'Untuk orang seterusnya yang duduk di sini…';

  @override
  String get placeGuestbookSent =>
      'Siap. Orang seterusnya di sini akan membacanya.';

  @override
  String get placeGuestbookUnavailable =>
      'Buku pelawat tidak tersedia sekarang. Sila cuba lagi nanti.';

  @override
  String get placeNoteMine => 'Nota anda';

  @override
  String get withdrawPlaceNote => 'Tarik balik nota ini';

  @override
  String get reportPlaceNote => 'Laporkan nota ini';

  @override
  String get thisPlaceNote => 'nota ini';

  @override
  String get guideS16L5 =>
      'Buku pelawat: buka kad tempat ketika anda di dalam (dalam lingkungan kira-kira 40 m) untuk membaca kata-kata orang yang pernah duduk di sini, dan tinggalkan satu baris untuk orang seterusnya. Nota adalah tanpa nama dan hilang selepas 30 hari. Anda boleh meninggalkan satu nota setiap tempat sehari, ketik nota untuk menterjemah, dan laporkan apa-apa yang mengganggu. Apabila anda membuka buku pelawat, telefon anda menghantar lokasi ke pelayan kami untuk mengesahkan anda di dalam; pelayan tidak menyimpannya.';

  @override
  String get quantumWorld => 'Dunia Kuantum';

  @override
  String get quantumWorldSubtitle =>
      'Satu bilik untuk seluruh dunia, tanpa mendedahkan lokasi anda';

  @override
  String get quantumIntroTitle => 'Masuk Dunia Kuantum';

  @override
  String get quantumIntroBody =>
      'Semua orang dalam Dunia Kuantum sekarang berkongsi satu bilik, tersusun seperti sarang lebah di sekeliling Taipei 101. Anda mendapat tempat duduk seperti \"Q4-17\" — lebih kecil gelangnya, lebih dekat dengan titik asal.\n\nTiada siapa dapat melihat lokasi sebenar anda. Orang lain hanya melihat tempat duduk anda, yang ditetapkan pada saat anda mengetik Masuk; ia tidak bergerak semasa anda berjalan. Untuk menukarnya, keluar dan masuk semula. Nama panggilan dan mood kekal sama, dan anda masih boleh menghantar kerlipan, mengetuk dan bersembang, dengan terjemahan sekali ketik.\n\nSemasa dalam Dunia Kuantum, anda keluar sementara dari radar biasa dan Alam Selari; apabila keluar, anda kembali ke tempat daftar masuk anda.';

  @override
  String get quantumEnter => 'Masuk';

  @override
  String get quantumLeave => 'Keluar dari Dunia Kuantum';

  @override
  String get quantumLeft =>
      'Anda telah keluar dari Dunia Kuantum dan kembali ke radar anda';

  @override
  String quantumYourSeat(String code) {
    return 'Tempat duduk anda $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Gelang $ring · gelang lebih kecil lebih dekat dengan titik asal Taipei 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count di sini sekarang';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '$count orang dalam Dunia Kuantum sekarang';
  }

  @override
  String get quantumRegionTw => 'Taiwan';

  @override
  String get quantumRegionJp => 'Jepun';

  @override
  String get quantumRegionKr => 'Korea';

  @override
  String get quantumRegionHkmo => 'Hong Kong & Macau';

  @override
  String get quantumRegionSea => 'Asia Tenggara';

  @override
  String get quantumRegionOther => 'Tempat lain';

  @override
  String get quantumQuiet => 'Senyap Kuantum';

  @override
  String get quantumQuietSubtitle =>
      'Hanya melihat dunia: tiada siapa boleh mengetuk, tetapi kerlipan masih sampai kepada anda';

  @override
  String get quantumQuietTarget =>
      'Dia menghidupkan Senyap Kuantum — anda hanya boleh menghantar kerlipan sekarang';

  @override
  String get quantumClosedRegion =>
      'Dunia Kuantum tidak tersedia di kawasan anda';

  @override
  String get quantumLeftClosed =>
      'Anda memasuki kawasan yang tiada Dunia Kuantum, jadi anda telah dikeluarkan';

  @override
  String get quantumSeatExpired =>
      'Anda pergi terlalu lama dan tempat duduk anda telah dilepaskan; anda kembali ke radar anda';

  @override
  String get quantumUnavailable =>
      'Tidak dapat masuk ke Dunia Kuantum sekarang. Sila cuba sebentar lagi.';

  @override
  String quantumPersonBody(String code) {
    return 'Tempat duduk orang ini dalam Dunia Kuantum ialah $code. Lokasi sebenar sesiapa tidak dipaparkan dalam Dunia Kuantum.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Dunia Kuantum · $code';
  }

  @override
  String get guideS17Title => '13. Dunia Kuantum';

  @override
  String get guideS17L1 =>
      'Ketik ikon sarang lebah di penjuru kanan atas radar (di bawah Alam Selari), baca nota dan ketik Masuk. Anda masuk dengan mengetik setiap kali, sama seperti daftar masuk; setiap kali membuka aplikasi anda bermula di radar biasa.';

  @override
  String get guideS17L2 =>
      'Semua orang dalam Dunia Kuantum berkongsi satu bilik: sarang lebah di sekeliling Taipei 101, dengan tempat duduk 100 m antara satu sama lain. Anda mendapat kod tempat duduk seperti \"Q4-17\" (gelang 4, tempat duduk 17) — gelang lebih kecil lebih dekat dengan titik asal. Pendatang baru mengisi tempat yang ditinggalkan orang lain dahulu; gelang 1–3 dikhaskan untuk hos perhimpunan.';

  @override
  String get guideS17L3 =>
      'Tiada siapa dapat melihat lokasi sebenar anda: orang lain hanya melihat tempat duduk anda. Setiap kali anda mengetik Masuk dikira sebagai satu daftar masuk, dan tempat duduk anda tetap dari saat itu; ia tidak bergerak semasa anda berjalan. Untuk menukarnya, keluar dan masuk semula. Dunia Kuantum tidak tersedia di tanah besar China.';

  @override
  String get guideS17L4 =>
      'Nama panggilan dan mood kekal sama, dan anda masih boleh menghantar kerlipan, mengetuk dan bersembang, dengan terjemahan sekali ketik. Cubit untuk mengecil bagi melihat seluruh sarang; orang yang jauh menjadi titik cahaya. Ketik kod tempat duduk di kiri atas untuk melihat siapa dalam talian, menghidupkan Senyap Kuantum (tiada ketukan, kerlipan masih sampai), atau keluar.';

  @override
  String get guideS17L5 =>
      'Tiada bisikan, surat ke masa depan, Tempat Mood, Suar Bandar atau perhimpunan dalam Dunia Kuantum. Semasa di dalam, anda keluar sementara dari radar biasa dan Alam Selari; apabila keluar, gelembung anda larut menjadi cahaya dan anda kembali ke tempat daftar masuk. Jika aplikasi ditutup atau di luar talian lebih 3 minit, tempat duduk anda dilepaskan.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Loceng jam dalam $seconds saat';
  }

  @override
  String get quantumChimeLookOrigin =>
      'Semua orang sedang melihat titik asal 101';

  @override
  String get quantumChimeLook => 'Lihat';

  @override
  String quantumChimeNow(int hour) {
    return 'Loceng pukul $hour Pusat Kuantum';
  }

  @override
  String get quantumChimeSend => 'Hantar kerlipan loceng';

  @override
  String get quantumChimeSent => 'Kerlipan anda terbang ke titik asal';

  @override
  String quantumChimeWatched(int n) {
    return '$n orang menonton loceng ini bersama';
  }

  @override
  String get quantumChimeReminder => 'Peringatan loceng jam';

  @override
  String get quantumChimeReminderSubtitle =>
      'Peringatan sebelum setiap jam untuk menonton loceng di titik asal 101';

  @override
  String get quantumChimeNotifyBody =>
      'Loceng jam hampir bermula — mari tonton di titik asal 101';

  @override
  String get quantumChimeChannel => 'Loceng jam';

  @override
  String get quantumChimeChannelDesc => 'Peringatan loceng jam Dunia Kuantum';

  @override
  String get quantumEntangleInvite => 'Ajak berbelit kuantum';

  @override
  String quantumEntangleInvited(String name) {
    return '$name telah diajak berbelit';
  }

  @override
  String get quantumEntangleAskTitle => 'Belitan kuantum';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) mahu berbelit dengan anda. Satu garis cahaya akan menyambung dua gelembung anda, kelihatan sejauh mana pun. Ia runtuh apabila salah seorang keluar, dan tiada rekod disimpan.';
  }

  @override
  String get quantumEntangleAccept => 'Berbelit';

  @override
  String quantumEntangled(String name) {
    return 'Anda dan $name kini berbelit';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Belitan dengan $name telah runtuh';
  }

  @override
  String get quantumEntangleCut => 'Leraikan belitan';

  @override
  String get quantumEntangleFull => 'Anda sudah berbelit dengan 3 orang';

  @override
  String get quantumEntangleTheirFull => 'Mereka sudah berbelit dengan 3 orang';

  @override
  String get quantumEntangleGone => 'Mereka sudah keluar dari Dunia Kuantum';

  @override
  String get quantumEntangleExpired => 'Jemputan telah tamat tempoh';

  @override
  String get quantumEntangledTitle => 'Sedang berbelit';

  @override
  String get quantumTunnel => 'Terowong kuantum';

  @override
  String get quantumTunnelSubtitle =>
      'Lompat ke tempat duduk kosong secara rawak dalam sarang dan bertemu jiran baharu. Sekali setiap lawatan.';

  @override
  String get quantumTunnelUsed => 'Anda sudah menggunakan terowong lawatan ini';

  @override
  String quantumTunnelDone(String code) {
    return 'Melalui terowong ke $code';
  }

  @override
  String get quantumShowTime => 'Tunjukkan waktu tempatan saya';

  @override
  String get quantumShowTimeSubtitle =>
      'Orang lain melihatnya apabila menekan lama gelembung anda. Jika dimatikan, hanya warna siang-malam ditunjukkan.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Tempatan $time · $part';
  }

  @override
  String get quantumDawn => 'awal pagi';

  @override
  String get quantumDay => 'siang';

  @override
  String get quantumDusk => 'senja';

  @override
  String get quantumNight => 'lewat malam';

  @override
  String get quantumTopicsTitle => 'Frekuensi kuantum';

  @override
  String get quantumTopicsSubtitle =>
      'Pilih sehingga 3 topik untuk dipaparkan di bawah gelembung anda';

  @override
  String get quantumTopicMusic => 'Muzik';

  @override
  String get quantumTopicMovies => 'Filem';

  @override
  String get quantumTopicTech => 'Teknologi';

  @override
  String get quantumTopicWalks => 'Berjalan';

  @override
  String get quantumTopicFood => 'Makanan';

  @override
  String get quantumTopicTravel => 'Melancong';

  @override
  String get quantumTopicReading => 'Membaca';

  @override
  String get quantumTopicSports => 'Sukan';

  @override
  String quantumTopicsCommon(String topics) {
    return 'Anda berdua suka: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Isyarat kuantum';

  @override
  String quantumSignalReceived(String name) {
    return '$name menghantar isyarat kepada anda';
  }

  @override
  String get quantumSignalWait => 'Anda baru menghantar — cuba sebentar lagi';

  @override
  String quantumResonance(String name) {
    return 'Anda dan $name sedang bergema';
  }

  @override
  String get guideS17L6 =>
      'Loceng jam: seminit sebelum setiap jam, pancaran 101 semakin terang. Tepat pada jamnya, utusan cahaya mengelilingi titik asal, loceng berbunyi mengikut waktu Pusat Kuantum (24 kali pada tengah malam), dan gelombang cahaya terakhir merebak ke seluruh sarang. Ketik “Hantar kerlipan loceng” semasa loceng — lebih ramai yang menonton, lebih terang cahayanya. Peringatan loceng jam hidup secara lalai; anda boleh matikannya dalam panel.';

  @override
  String get guideS17L7 =>
      'Selepas berbual, anda boleh ajak seseorang berbelit: satu garis cahaya menyambung gelembung anda sejauh mana pun, dan runtuh apabila salah seorang keluar (sehingga 3 orang serentak). Terowong kuantum, sekali setiap lawatan, membawa anda ke tempat duduk kosong rawak dengan jiran baharu.';

  @override
  String get guideS17L8 =>
      'Setiap gelembung membawa warna waktu tempatan pemiliknya: emas pucat waktu subuh, putih terang waktu siang, jingga-ungu waktu senja, biru pekat waktu malam. Hidupkan “Tunjukkan waktu tempatan saya” supaya orang lain nampak waktunya apabila menekan lama gelembung anda. Saling menghantar kerlipan dalam 24 jam akan mencetuskan gema kuantum; tekan lama gelembung untuk menghantar isyarat 👋 ☕ 🌙 🎵 🌧️ ✨; pilih sehingga 3 topik frekuensi dalam panel dan topik yang sama akan menyala.';

  @override
  String get quantumNyTitle => 'Tahun Baharu Kuantum';

  @override
  String quantumNyDays(int n) {
    return 'Lagi $n hari: pada tengah malam Pusat Kuantum 12/31, kira detik bersama dunia di titik asal 101';
  }

  @override
  String get quantumNyTonight =>
      'Malam ini pada tengah malam Pusat Kuantum, kira detik bersama dunia di titik asal 101';

  @override
  String quantumNyZone(String places) {
    return 'Selamat Tahun Baharu, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n orang di seluruh dunia menyambut tahun baharu bersama dalam Dunia Kuantum';
  }

  @override
  String get quantumNyHappy => 'Selamat Tahun Baharu';

  @override
  String get guideS17L9 =>
      'Tahun Baharu Kuantum: pada 12/31, setiap kali zon waktu mencapai tengah malam, gelembung di sana menyala dengan gelang emas secara berombak, dan titik paparan dunia turut bertukar emas. Pada tengah malam Pusat Kuantum, seluruh sarang mengira detik 10 saat terakhir, titik asal 101 melepaskan letupan cahaya terbesar di dunia dan bunga api selama 5 minit, serta menunjukkan bilangan orang yang menyambut tahun baharu bersama.';

  @override
  String get quantumMeetAction => 'Buat kad Pertemuan Kuantum';

  @override
  String quantumMeetAsked(String name) {
    return 'Telah ajak $name membuat kad Pertemuan Kuantum bersama';
  }

  @override
  String get quantumMeetWait =>
      'Anda baru sahaja mengajak — cuba lagi sebentar lagi';

  @override
  String get quantumMeetAskTitle => 'Kad Pertemuan Kuantum';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) mahu menjadikan pertemuan ini kad untuk dikongsi. Kad memaparkan nama panggilan, kod tempat duduk, waktu tempatan dan mood anda berdua — tiada lokasi langsung.';
  }

  @override
  String get quantumMeetAccept => 'Buat bersama';

  @override
  String get quantumMeetEyebrow => 'PERTEMUAN KUANTUM';

  @override
  String get quantumMeetFooter => 'Kami bertemu dalam Dunia Kuantum';

  @override
  String get quantumMeetShare => 'Kongsi kad';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — kami bertemu dalam Dunia Kuantum ✨';
  }

  @override
  String get guideS17L10 =>
      'Kad Pertemuan Kuantum: selepas berbual, tekan lama gelembung mereka untuk mengajak membuatnya bersama. Apabila kedua-dua bersetuju, setiap orang menerima kad untuk dikongsi dengan nama panggilan, kod tempat duduk, waktu tempatan berserta warna siang-malam, dan mood — tiada lokasi. Kod tempat duduk gelang 4 berwarna emas.';

  @override
  String get quantumOrbEntry => 'Avatar kuantum';

  @override
  String get quantumOrbEntrySubtitle =>
      'Foto anda menjadi bebola kristal dalam Dunia Kuantum';

  @override
  String get orbTitle => 'Avatar kuantum';

  @override
  String get orbSubtitle => 'Kaca dan cahayanya sentiasa mengikut mood anda';

  @override
  String get orbStyleGlow => 'Cahaya';

  @override
  String get orbStyleRing => 'Gelang';

  @override
  String get orbStyleRainbow => 'Pelangi';

  @override
  String get orbFree => 'Percuma';

  @override
  String get orbOwned => 'Dimiliki';

  @override
  String get orbInUse => 'Sedang digunakan';

  @override
  String get orbCosmeticNote =>
      'Bebola istimewa hanyalah rupa — ia tidak mengubah sebarang ciri atau keistimewaan. Bebola yang dibeli kekal dalam akaun anda.';

  @override
  String get orbRestore => 'Pulihkan pembelian';

  @override
  String orbPurchased(String name) {
    return '$name kini milik anda ✨';
  }

  @override
  String get orbPurchaseFailed =>
      'Pembelian tidak berjaya. Sila cuba lagi nanti.';

  @override
  String get orbOwnedElsewhere =>
      'Pembelian ini sudah digunakan pada akaun lain';

  @override
  String get orbStoreUnavailable =>
      'Kedai tidak dapat dihubungi sekarang. Sila cuba lagi nanti.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · AI';

  @override
  String get aiyaConsentTitle => 'Sebelum berbual dengan AIYA';

  @override
  String get aiyaConsentBody =>
      'AIYA ialah AI yang dikuasakan oleh Claude daripada Anthropic. Apa yang anda hantar kepada AIYA diproses oleh Anthropic (AS) tanpa identiti, nama samaran atau lokasi anda, dan dipadam apabila perbualan tamat. AIYA boleh tersilap dan bukan nasihat profesional.';

  @override
  String get aiyaConsentAgree => 'Setuju dan mula';

  @override
  String get aiyaConsentLater => 'Bukan sekarang';

  @override
  String get aiyaGreeting =>
      'Hai, saya AIYA, cahaya di tengah Dunia Kuantum. Apa yang anda fikirkan malam ini?';

  @override
  String get aiyaFarewell =>
      'Masa sudah tamat. Saya kembali ke dalam cahaya. Ketuk lagi bila rindu.';

  @override
  String get aiyaInputHint => 'Katakan sesuatu kepada AIYA…';

  @override
  String get aiyaSend => 'Hantar';

  @override
  String aiyaFreeLeft(int n) {
    return '$n sembang percuma lagi hari ini';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Pek masa: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'Tinggal $time';
  }

  @override
  String get aiyaEnd => 'Tamatkan sembang';

  @override
  String get aiyaFiltered =>
      'Ada perkataan atau butiran hubungan yang tidak dibenarkan. Cuba cara lain.';

  @override
  String get aiyaBusy => 'AIYA termenung sekejap. Boleh ulang sekali lagi?';

  @override
  String get aiyaRefused =>
      'Saya tak dapat bercakap tentang itu. Topik lain, boleh?';

  @override
  String get aiyaEnded => 'Sembang ini sudah tamat.';

  @override
  String get aiyaNoQuotaTitle => 'Sembang percuma hari ini sudah habis';

  @override
  String get aiyaNoQuotaBody =>
      'Anda dapat 3 sembang percuma sehari, ditetapkan semula pada 00:00 waktu Taiwan. Untuk terus berbual sekarang, dapatkan pek masa. Setiap sembang sehingga 10 minit.';

  @override
  String get aiyaResting => 'AIYA penat malam ini. Jumpa esok.';

  @override
  String get aiyaDailyMax =>
      'Anda sudah banyak berbual hari ini. Jumpa AIYA lagi esok.';

  @override
  String aiyaPackTimes(int n) {
    return '$n sembang';
  }

  @override
  String get aiyaPackNote =>
      'Pek masa terikat pada akaun telefon ini dan tidak boleh dipulihkan jika anda memadam aplikasi atau akaun.';

  @override
  String aiyaPurchased(int n) {
    return '$n sembang ditambah ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'Pembelian tidak berjaya. Sila cuba lagi.';

  @override
  String get aiyaStoreUnavailable =>
      'Tidak dapat menghubungi kedai sekarang. Sila cuba lagi nanti.';

  @override
  String get aiyaReport => 'Laporkan balasan ini';

  @override
  String get aiyaReported =>
      'Laporan diterima. Kami akan menyemaknya dalam 24 jam.';

  @override
  String get aiyaSetting => 'AIYA (AI dalam Dunia Kuantum)';

  @override
  String get aiyaSettingSubtitle =>
      'Jika dimatikan, AIYA tidak lagi muncul di tiang cahaya Dunia Kuantum';

  @override
  String get aiyaCameoHello =>
      'Hai, selamat datang ke Dunia Kuantum. Ketik saya jika mahu berbual.';

  @override
  String aiyaCameoChime(int hour) {
    return 'Sudah pukul $hour. Saya di sini dalam cahaya bersama anda.';
  }

  @override
  String get locationPickOnMap => 'Pilih pada peta';

  @override
  String get locationPickTitle => 'Pilih lokasi anda';

  @override
  String get locationPickHint =>
      'Gerakkan peta supaya titik bercahaya di tengah berada di tempat anda sekarang';

  @override
  String get locationPickConfirm => 'Saya di sini';

  @override
  String get aiyaPackEntry => '+ Pek masa';

  @override
  String get aiyaPacksTitle => 'Pek masa';

  @override
  String get aiyaPacksBody =>
      'Anda dapat 3 sembang percuma sehari. Sembang pek masa hanya digunakan selepas yang percuma habis. Setiap sembang paling lama 10 minit.';

  @override
  String get guideS1L6 =>
      'Jika lokasi anda tidak dapat dikesan (contohnya di dalam bangunan, atau pada iPad tanpa GPS), ketik \"Pilih pada peta\": gerakkan peta supaya titik bercahaya di tengah berada di tempat anda, kemudian ketik \"Saya di sini\". Apabila lokasi sebenar diperoleh, aplikasi akan bertukar kepadanya.';

  @override
  String get guideS17L11 =>
      'Avatar kuantum: ketik kod tempat duduk anda di kiri atas → \"Avatar kuantum\" dan avatar anda menjadi bola kristal dalam Dunia Kuantum. Cahaya dan Gelang adalah percuma; Pelangi dibeli sekali dan kekal milik anda, dan \"Pulihkan pembelian\" mengembalikannya pada telefon baharu atau selepas dipasang semula.';

  @override
  String get guideS18Title => '14. AIYA · AI';

  @override
  String get guideS18L1 =>
      'AIYA ialah AI yang tinggal dalam tiang cahaya di tengah Dunia Kuantum. Dia bukan manusia, dan dia akan memberitahu anda begitu. Dalam Dunia Kuantum, ketik \"AIYA · AI\" di bawah tiang untuk mengetuk dan bersembang; sebelum sembang pertama, baca notis ringkas dan setuju.';

  @override
  String get guideS18L2 =>
      'Setiap sembang paling lama 10 minit dan 20 mesej. Anda dapat 3 sembang percuma sehari, ditetapkan semula pada 00:00 waktu Taiwan, dengan maksimum 30 sembang sehari.';

  @override
  String get guideS18L3 =>
      'Pek masa: ketik \"+ Pek masa\" di atas kotak mesej bila-bila masa untuk membeli 5 atau 20 sembang; ia hanya digunakan selepas sembang percuma habis. Pek masa terikat pada akaun di telefon ini dan tidak boleh dipulihkan selepas aplikasi atau akaun dipadam. Ia boleh guna habis, jadi tiada \"Pulihkan pembelian\".';

  @override
  String get guideS18L4 =>
      'AIYA tidak tahu dan tidak akan bertanya lokasi atau identiti anda; dia hanya melihat jumlah mood bandar tanpa nama. Dia tidak bercumbu atau membincangkan kandungan seksual, dan tidak memberi nasihat perubatan, undang-undang atau kewangan. Tekan lama mana-mana balasan untuk melaporkannya. Sembang hanya disimpan sementara untuk perbualan itu dan dipadam sejurus selepas tamat.';

  @override
  String get guideS18L5 =>
      'Sesekali AIYA muncul dalam tiang cahaya: ketika loceng setiap jam, kali pertama anda masuk ke Dunia Kuantum setiap hari, atau secara kebetulan. Ketik dia untuk mula bersembang. Untuk tidak melihatnya lagi, matikan \"AIYA (AI dalam Dunia Kuantum)\" dalam Tetapan.';

  @override
  String get orbStyleXmas => 'Krismas';

  @override
  String get orbStyleNewYear => 'Tahun Baru Kuantum';

  @override
  String get orbLimited => 'Edisi terhad';

  @override
  String orbLimitedUntil(String date) {
    return 'Edisi terhad · hingga $date';
  }

  @override
  String get aiyaFriendTitle => 'Rakan AIYA';

  @override
  String get aiyaFriendSubtitle => 'Pelan bulanan auto-pembaharuan';

  @override
  String get aiyaFriendPerk1 => '20 sembang sehari (3 jika percuma)';

  @override
  String get aiyaFriendPerk2 => 'Setiap sembang 20 minit atau 40 mesej';

  @override
  String get aiyaFriendPerk3 => 'Boleh bersembang walaupun AIYA sedang berehat';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA memakai rupa “Cahaya Bintang” eksklusif (hanya anda nampak)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / bulan';
  }

  @override
  String get aiyaFriendSubscribe => 'Langgan';

  @override
  String get aiyaFriendTerms =>
      'Langganan selama 1 bulan dan diperbaharui secara automatik dengan bayaran kecuali auto-pembaharuan dimatikan sekurang-kurangnya 24 jam sebelum tempoh tamat. Bayaran diuruskan oleh akaun Apple atau Google anda; urus atau batal bila-bila masa dalam tetapan langganan akaun. Kiraan Pek Masa dikekalkan dan hanya digunakan selepas 20 sembang harian.';

  @override
  String aiyaFriendActive(String date) {
    return 'Anda Rakan AIYA hingga $date';
  }

  @override
  String get aiyaFriendManage => 'Urus langganan';

  @override
  String get aiyaFriendRestore => 'Pulihkan pembelian';

  @override
  String get aiyaFriendWelcome => 'Anda kini Rakan AIYA ✨';

  @override
  String get aiyaFriendRestored => 'Rakan AIYA dipulihkan';

  @override
  String get aiyaFriendNotFound => 'Tiada langganan Rakan AIYA yang aktif';

  @override
  String get aiyaFriendElsewhere =>
      'Langganan ini sudah digunakan oleh akaun lain';

  @override
  String get aiyaFriendEntry => 'Rakan AIYA · 20 sehari';

  @override
  String aiyaFriendLeft(int n) {
    return 'Rakan AIYA · tinggal $n hari ini';
  }

  @override
  String get guideS17L12 =>
      'Edisi terhad: bebola kristal Krismas (kalungan holi, bintang emas berkelip, salji turun) dijual hingga 12/25, dan bebola kristal Tahun Baru Kuantum (detik jam emas dan bunga api, paling besar tepat tengah malam) hingga 1/1, waktu Taiwan. Selepas itu ia tidak dijual lagi; jika anda membelinya, ia kekal milik anda dan boleh dipulihkan.';

  @override
  String get guideS18L6 =>
      'Rakan AIYA: pilih \"Rakan AIYA\" dalam \"+ Pek Masa\". Ia pelan bulanan auto-pembaharuan: 20 sembang sehari, setiap satu hingga 20 minit atau 40 mesej, boleh bersembang walaupun AIYA berehat, dan rupa \"Cahaya Bintang\" pada AIYA yang hanya anda nampak. Pek Masa digunakan selepas 20 sembang harian. Langganan diperbaharui secara automatik; batal bila-bila masa dalam tetapan langganan Apple atau Google, dan ketik \"Pulihkan pembelian\" pada telefon baharu.';

  @override
  String get mapConsentTitle => 'Tunjukkan lokasi anda pada peta?';

  @override
  String get mapConsentBody =>
      'Jika anda benarkan, setiap kali anda sendiri mengetik Daftar masuk (atau Masuk di Dunia Kuantum), pengguna lain melihat tempat anda daftar masuk (bukan lokasi masa nyata), nama panggilan dan mood anda pada peta. Tiada daftar masuk automatik, dan anda hilang dari peta apabila keluar dari aplikasi. Anda boleh menolak, dan boleh mematikannya bila-bila masa dalam Tetapan.';

  @override
  String get mapConsentAllow => 'Benarkan';

  @override
  String get mapConsentDecline => 'Jangan benarkan';

  @override
  String get mapConsentDeclined =>
      'Baik. Anda tidak akan muncul pada peta sesiapa. Ketik semula bila-bila masa anda mahu daftar masuk.';

  @override
  String get mapConsentSetting => 'Tunjukkan lokasi saya pada peta';

  @override
  String get mapConsentSettingSubtitle =>
      'Mematikannya menamatkan daftar masuk serta-merta; anda tidak akan muncul pada peta sesiapa';

  @override
  String get wgErrInGroup => 'Anda sudah dalam satu kumpulan. Keluar dahulu.';

  @override
  String get wgErrFull =>
      'Kumpulan ini sudah 20 orang. Minta ketua dapatkan pelan 7 hari.';

  @override
  String get wgErrPaidFull => 'Kumpulan ini penuh (100 orang).';

  @override
  String get wgErrQr =>
      'Kod QR ini telah ditukar. Minta yang baharu daripada ketua.';

  @override
  String get wgErrEnded => 'Kumpulan ini telah tamat atau tidak wujud.';

  @override
  String get wgErrFiltered => 'Ini mengandungi kata yang tidak dibenarkan.';

  @override
  String get wgErrHostLeave =>
      'Ketua tidak boleh keluar. Serahkan atau tamatkan kumpulan dahulu.';

  @override
  String get wgErrBusy => 'Tidak dapat bersambung. Cuba lagi.';

  @override
  String get wgErrName => 'Beri nama kumpulan anda.';

  @override
  String get wgPassUnavailable => 'Kedai tidak tersedia sekarang.';

  @override
  String get wgPassFailed => 'Pembelian tidak berjaya.';

  @override
  String get wgPassDone =>
      'Pelan 7 hari aktif. Kumpulan boleh ada sehingga 100 orang.';

  @override
  String get wgCreateTitle => 'Mulakan kumpulan';

  @override
  String get wgCreateBody =>
      'Kumpulan peribadi: hanya mereka yang ada kod QR anda boleh sertai.';

  @override
  String get wgNameLabel => 'Nama kumpulan';

  @override
  String get wgColorLabel => 'Warna kumpulan';

  @override
  String wgDaysLabel(int n) {
    return '$n hari, termasuk hari ini';
  }

  @override
  String get wgFreeNote =>
      'Percuma sehingga 20 orang. Lebih daripada itu, ketua dapatkan pelan 7 hari (hingga 100).';

  @override
  String get wgCreateButton => 'Mulakan';

  @override
  String wgJoined(String name, int no) {
    return 'Menyertai \"$name\". Anda No. $no';
  }

  @override
  String get wgJoinTitle => 'Sertai kumpulan';

  @override
  String get wgJoinBody =>
      'Imbas kod QR ketua dengan kamera, atau masukkan kod 8 aksara.';

  @override
  String get wgJoinButton => 'Sertai';

  @override
  String wgButtonLabel(String name) {
    return 'Kumpulan $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit orang';
  }

  @override
  String wgUntil(String date) {
    return 'hingga $date';
  }

  @override
  String wgMyNo(int n) {
    return 'Saya No. $n';
  }

  @override
  String get wgCallButton => 'Panggil berkumpul';

  @override
  String get wgCallDone => 'Semua sudah ada, tamatkan';

  @override
  String get wgRollButton => 'Panggilan nama';

  @override
  String wgRollSummary(int here, int total) {
    return 'Panggilan nama: $here/$total hadir';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n ahli (ketik untuk nota, serah atau buang)';
  }

  @override
  String get wgNoMembers => 'Belum ada ahli. Ketik \"Kod QR\" untuk diimbas.';

  @override
  String get wgQrButton => 'Kod QR';

  @override
  String get wgDissolveAsk =>
      'Tamatkan kumpulan? Semua akan dimaklumkan dan rekod dipadam.';

  @override
  String get wgDissolve => 'Tamatkan';

  @override
  String wgCallIn(int n) {
    return 'Berkumpul dalam $n minit';
  }

  @override
  String get wgCallNow => 'Berkumpul sekarang';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total terima';
  }

  @override
  String get wgAnswerHere => 'Saya sudah sampai';

  @override
  String get wgAnswer5min => '5 minit lagi';

  @override
  String get wgAnswerHelp => 'Perlu bantuan';

  @override
  String get wgNoReply => 'Tiada jawapan';

  @override
  String get wgStateAck => 'Terima';

  @override
  String get wgStateSeen => 'Dilihat';

  @override
  String get wgStateNone => 'Tiada respons';

  @override
  String get wgPassTitle => 'Pelan 7 hari kumpulan';

  @override
  String get wgPassBody =>
      'Percuma hingga 20 orang. Dengan pelan, kumpulan ini boleh sehingga 100 orang sehingga tamat. Sekali beli untuk kumpulan ini sahaja, tiada pembaharuan automatik.';

  @override
  String get wgPassButton => 'Dapatkan pelan 7 hari';

  @override
  String wgHostIs(String name) {
    return 'Ketua: $name';
  }

  @override
  String get wgNoCall =>
      'Tiada panggilan sekarang. Bila ketua memanggil, telefon anda akan berbunyi.';

  @override
  String get wgRollAsk => 'Ketua sedang memanggil nama';

  @override
  String get wgLeaveAsk => 'Keluar dari kumpulan ini?';

  @override
  String get wgLeave => 'Keluar kumpulan';

  @override
  String get wgCallTitle => 'Masa berkumpul!';

  @override
  String get wgAcked => '✓ Ketua tahu anda terima';

  @override
  String get wgAckButton => 'Terima';

  @override
  String get wgCallSheetTitle => 'Panggil berkumpul';

  @override
  String get wgNow => 'Sekarang';

  @override
  String wgInMinutes(int n) {
    return 'Dalam $n minit';
  }

  @override
  String get wgPlaceLabel => 'Tempat berkumpul';

  @override
  String get wgPlaceHint => 'cth. Pintu keluar 6 MRT Ximen';

  @override
  String get wgPlaceNote =>
      'Tempat berkumpul ditetapkan di lokasi anda sekarang.';

  @override
  String get wgSendCall => 'Hantar panggilan';

  @override
  String get wgNoLocation => 'Tidak dapat lokasi anda untuk tempat berkumpul.';

  @override
  String get wgQrTitle => 'Imbas untuk sertai';

  @override
  String get wgQrBody =>
      'Imbas dengan kamera telefon, atau masukkan kod di bawah.';

  @override
  String wgShareText(String name, String url) {
    return 'Sertai kumpulan saya \"$name\": $url';
  }

  @override
  String get wgShare => 'Kongsi pautan';

  @override
  String get wgRotateAsk =>
      'Tukar kod QR? Kod dan pautan lama tidak lagi berfungsi.';

  @override
  String get wgRotate => 'Kod QR baharu';

  @override
  String wgMemberTitle(int no) {
    return 'No. $no';
  }

  @override
  String get wgEditNote => 'Nota';

  @override
  String get wgHandoff => 'Jadikan ketua';

  @override
  String wgHandoffAsk(int no) {
    return 'Serahkan kepada No. $no? Anda akan menjadi ahli.';
  }

  @override
  String get wgKick => 'Buang dari kumpulan';

  @override
  String wgKickAsk(int no) {
    return 'Buang No. $no dari kumpulan?';
  }

  @override
  String get wgNotePrivate =>
      'Hanya anda nampak nota, cth. nama atau nombor bilik.';

  @override
  String get wgSave => 'Simpan';

  @override
  String get wgConfirm => 'Sahkan';

  @override
  String get wgCancel => 'Batal';

  @override
  String get wgSettingCreate => 'Mulakan kumpulan';

  @override
  String get wgSettingCreateSub =>
      'Kumpulan peribadi untuk lawatan dan pendakian';

  @override
  String get wgSettingJoin => 'Sertai kumpulan';

  @override
  String get wgSettingJoinSub => 'Masukkan kod 8 aksara ketua';

  @override
  String wgSettingOpen(String name) {
    return 'Kumpulan saya: $name';
  }

  @override
  String get wgChannelName => 'Panggilan kumpulan';

  @override
  String get wgChannelDesc => 'Bila ketua memanggil semua berkumpul';

  @override
  String get guideS19Title => '15. Kumpulan Bisikan';

  @override
  String get guideS19L1 =>
      'Kumpulan Bisikan ialah kumpulan peribadi untuk lawatan, lawatan sekolah, mendaki, bersiar atau kakitangan acara. Pergi ke Tetapan → Perhimpunan → \"Mulakan kumpulan\", beri nama, pilih warna dan bilangan hari (hingga 7).';

  @override
  String get guideS19L2 =>
      'Menyertai: ketua ketik butang kumpulan di bawah peta → \"Kod QR\"; ahli imbas dengan kamera telefon dan aplikasi dibuka untuk menyertai. Atau pergi ke Tetapan → Perhimpunan → \"Sertai kumpulan\" dan masukkan kod 8 aksara. Orang luar tidak boleh mencari atau memohon, dan ketua boleh menukar kod QR bila-bila masa.';

  @override
  String get guideS19L3 =>
      'Panggil berkumpul: ketua ketik \"Panggil berkumpul\", pilih masa dan terangkan tempat berkumpul. Telefon ahli memainkan bunyi khas dengan getaran \"pendek pendek panjang\"; dalam aplikasi mereka nampak kiraan detik, jarak dan arah ke tempat berkumpul, serta tiang cahaya di peta. Sesiapa yang belum ketik \"Terima\" diingatkan setiap minit, sehingga 3 kali; ketua nampak siapa terima, siapa melihat dan siapa belum memberi respons.';

  @override
  String get guideS19L4 =>
      'Panggilan nama: ketua ketik \"Panggilan nama\"; ahli menerima bunyi dan getaran yang sama dan menjawab \"Saya sudah sampai\", \"5 minit lagi\" atau \"Perlu bantuan\". Ketua tidak pernah nampak lokasi ahli, hanya jawapan mereka.';

  @override
  String get guideS19L5 =>
      'Kumpulan sehingga 20 orang adalah percuma. Untuk lebih, ketua boleh membeli pelan 7 hari: sehingga 100 orang sehingga kumpulan tamat. Ahli tidak pernah membayar. Kumpulan paling lama 7 hari; apabila tamat, senarai dan rekod dipadam.';

  @override
  String get wgFlagButton => 'Angkat bendera';

  @override
  String get wgFlagHost => 'Ketua';

  @override
  String get wgFlagHint =>
      'Angkat telefon supaya kumpulan nampak anda dalam orang ramai. Ketik untuk tutup.';

  @override
  String get wgLostButton => 'Saya sesat';

  @override
  String get wgFound => 'Saya jumpa kumpulan';

  @override
  String get wgLostSent =>
      'Lokasi anda dihantar kepada ketua. Tunggu di situ atau pergi ke tempat berkumpul.';

  @override
  String get wgLostTitleAsk => 'Hantar lokasi kepada ketua?';

  @override
  String get wgLostAsk =>
      'Lokasi semasa anda dihantar sekali kepada ketua; telefon mereka akan memberi amaran dan menunjukkan anda di peta. Tidak dijejaki, dipadam selepas 30 minit. Ketik \"Saya jumpa kumpulan\" untuk membuangnya lebih awal.';

  @override
  String get wgLostSend => 'Hantar lokasi saya';

  @override
  String wgLostTitle(int n) {
    return '$n ahli sesat';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n minit lalu';
  }

  @override
  String get wgNavigate => 'Arah';

  @override
  String get wgFoundThem => 'Sudah jumpa';

  @override
  String get guideS19L6 =>
      'Mencari satu sama lain: dalam orang ramai, ketik \"Angkat bendera\" dan seluruh skrin berkelip dengan warna kumpulan serta nombor anda. Jika benar-benar terpisah, ahli boleh ketik \"Saya sesat\" untuk menghantar lokasi semasa sekali kepada ketua (dipadam selepas 30 minit). Telefon ketua memberi amaran, pin merah muncul di peta dan boleh dapatkan arah.';

  @override
  String wgLostAlert(int no) {
    return 'No. $no sesat';
  }

  @override
  String wgHelpAlert(String no) {
    return 'No. $no perlukan bantuan';
  }

  @override
  String get wgViewList => 'Buka kumpulan';

  @override
  String aiyaCameoChimeNight(int hour) {
    return 'Sudah pukul $hour. Masih berjaga? Saya ada di dalam cahaya bersama anda.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return 'Pukul $hour, selamat pagi. Hari ini santai sahaja.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return 'Pukul $hour. Bagaimana bandar anda malam ini?';
  }

  @override
  String get aiyaCameoNyReady => 'Sedia? Mari kira detik bersama!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'Selamat Tahun Baru! $year, kita semua dalam bilik yang sama.';
  }

  @override
  String get aiyaSkinEntry => '✦ Gaya';

  @override
  String get aiyaSkinTitle => 'Gaya AIYA';

  @override
  String get aiyaSkinSubtitle => 'Hanya anda yang nampak gaya AIYA anda';

  @override
  String get aiyaSkinNone => 'Asal';

  @override
  String get aiyaSkinStarlight => 'Cahaya Bintang';

  @override
  String get aiyaSkinStarlightSub => 'Untuk Rakan AIYA';

  @override
  String get aiyaSkinXmas => 'Krismas';

  @override
  String get aiyaSkinNewYear => 'Tahun Baru Kuantum';

  @override
  String get aiyaSkinNote =>
      'Gaya perayaan dibeli sekali dan kekal milik anda. Ia hanya mengubah rupa AIYA. Edisi terhad tidak dijual lagi selepas tempoh jualan.';

  @override
  String get orbStyleStarTrail => 'Jejak Bintang';

  @override
  String get orbStyleRings => 'Gelang Usia';

  @override
  String get orbGrowNote =>
      'Orb yang membesar: Jejak Bintang mendapat satu bintang untuk setiap Kad Pertemuan Kuantum (sekali bagi setiap orang dalam 24 jam, maksimum 24). Gelang Usia bertambah satu bagi setiap 3 jam di Dunia Kuantum (maksimum 12). Rekod disimpan dalam akaun anda dan mula dikira sekarang. Hanya bilangan disimpan, bukan siapa atau di mana.';

  @override
  String orbGrowStars(int count) {
    return '$count bintang setakat ini';
  }

  @override
  String orbGrowRings(int count) {
    return '$count gelang setakat ini';
  }

  @override
  String get giftAction => 'Hantar hadiah';

  @override
  String giftSheetTitle(String name) {
    return 'Hantar hadiah kepada $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Pilih gaya orb untuk $name';
  }

  @override
  String get giftBouquetName => 'Jambangan cahaya';

  @override
  String get giftBouquetDesc =>
      'Cahaya mekar apabila diterima, kemudian kelopak cahaya mengelilingi orb mereka selama 24 jam';

  @override
  String get giftOrbName => 'Hadiahkan gaya orb';

  @override
  String get giftOrbDesc =>
      'Anda pilih; ia kekal milik mereka selepas diterima';

  @override
  String get giftPairName => 'Pasangan terjalin';

  @override
  String get giftPairDesc =>
      'Satu orb untuk setiap seorang, berpasangan; tali cahaya menghubungkan anda di Dunia Kuantum';

  @override
  String get giftPairYouHave => 'Anda sudah ada pasangan terjalin';

  @override
  String get giftNote =>
      'Mereka boleh terima atau tolak. Jika ditolak atau tiada jawapan dalam 7 hari, hadiah kembali kepada anda.';

  @override
  String get giftVouchersTitle => 'Hadiah dikembalikan (tiada caj tambahan)';

  @override
  String get giftSendVoucher => 'Hantar';

  @override
  String giftSent(String name) {
    return 'Hadiah dihantar kepada $name. Menunggu diterima.';
  }

  @override
  String get giftReturnedOff =>
      'Mereka menutup terima hadiah; hadiah dikembalikan kepada anda';

  @override
  String get giftReturnedBlocked =>
      'Hadiah tidak boleh dihantar kepada orang ini; ia dikembalikan';

  @override
  String get giftReturnedOwned =>
      'Mereka sudah ada orb ini; hadiah dikembalikan, anda boleh beri gaya lain';

  @override
  String get giftReturnedPaired =>
      'Mereka sudah berpasangan; hadiah dikembalikan';

  @override
  String get giftReturnedYouPaired =>
      'Anda sudah berpasangan; hadiah dikembalikan';

  @override
  String get giftReturnedGeneric =>
      'Hadiah dikembalikan; anda boleh beri kepada orang lain';

  @override
  String get giftStoreUnavailable => 'Kedai tidak tersedia sekarang';

  @override
  String get giftFailed => 'Hadiah tidak berjaya. Sila cuba lagi nanti.';

  @override
  String giftFromBouquet(String name) {
    return '$name menghantar jambangan cahaya';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name menghadiahkan orb \"$style\"';
  }

  @override
  String giftFromPair(String name) {
    return '$name mahu menjadi pasangan terjalin anda';
  }

  @override
  String get giftInboxTitle => 'Hadiah untuk anda';

  @override
  String get giftInboxEmpty => 'Tiada hadiah buat masa ini';

  @override
  String get giftInboxNote =>
      'Hadiah yang ditolak dikembalikan kepada pengirim; tiada jawapan 7 hari juga dikembalikan.';

  @override
  String get giftAccept => 'Terima';

  @override
  String get giftDecline => 'Tolak';

  @override
  String get giftDeclined => 'Ditolak. Hadiah dikembalikan kepada pengirim.';

  @override
  String get giftAcceptedOrb => 'Diterima! Tukar di avatar kuantum.';

  @override
  String giftAcceptedPair(String name) {
    return 'Anda dan $name kini pasangan terjalin';
  }

  @override
  String get giftAcceptedBouquet =>
      'Jambangan diterima. Kelopak cahaya mengelilingi orb anda selama 24 jam.';

  @override
  String get giftAlreadyOwned =>
      'Anda sudah ada orb ini; hadiah dikembalikan kepada pengirim';

  @override
  String get giftAlreadyPaired =>
      'Salah seorang sudah berpasangan; hadiah dikembalikan';

  @override
  String get giftSettingsTitle => 'Hadiah';

  @override
  String get giftReceiveToggle => 'Terima hadiah';

  @override
  String get giftReceiveToggleSub =>
      'Jika ditutup, hadiah terus dikembalikan kepada pengirim';

  @override
  String get giftVouchersHint =>
      'Ketik \"Hantar hadiah\" pada seseorang untuk memberi semula';

  @override
  String get giftUnpair => 'Tamatkan pasangan terjalin';

  @override
  String giftUnpairConfirm(String name) {
    return 'Tamatkan pasangan dengan $name? Kedua-dua kekalkan orb, tetapi tali cahaya hilang.';
  }

  @override
  String get orbStylePair => 'Terjalin';

  @override
  String giftPairedWith(String name) {
    return 'Berpasangan dengan $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Hadiah untuk anda ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count hadiah dikembalikan';
  }

  @override
  String get giftBlockedOff =>
      'Mereka menutup terima hadiah. Anda tidak dicaj.';

  @override
  String get giftBlockedBlocked =>
      'Anda tidak boleh menghantar hadiah kepada orang ini. Anda tidak dicaj.';

  @override
  String get giftBlockedOwned =>
      'Mereka sudah ada orb ini. Pilih yang lain (anda tidak dicaj).';

  @override
  String get giftBlockedPaired => 'Mereka sudah berpasangan. Anda tidak dicaj.';

  @override
  String get orbStyleValentine => 'Valentine';

  @override
  String get orbStyleSakura => 'Sakura';

  @override
  String get parallelCoords => 'Koordinat selari';

  @override
  String parallelCoordsHome(String city, String km) {
    return '$km km dari pusat $city';
  }

  @override
  String parallelCoordsIn(String city) {
    return 'Di $city, anda berdiri di sekitar';
  }

  @override
  String get parallelCoordsSea => 'Di laut, atau tempat tanpa nama';

  @override
  String get parallelCoordsOutside => 'Di luar bandar ini';

  @override
  String parallelCoordsNote(String city) {
    return 'Apabila orang di $city menghidupkan Alam Selari, di sinilah lebih kurang mereka nampak anda (dikaburkan kira-kira 500 m).';
  }

  @override
  String get parallelCoordsFailed =>
      'Nama tempat tidak dijumpai buat masa ini. Cuba lagi nanti.';

  @override
  String parallelCardTitle(String city) {
    return 'Sekarang, saya di $city alam selari';
  }

  @override
  String parallelCardShareText(String city) {
    return 'Sekarang, saya di $city alam selari. Buka Mood Whisper dan masuk ke bandar lain juga.';
  }

  @override
  String get parallelCoordsShare => 'Kongsi kad';

  @override
  String get orbStylePassport => 'Pasport';

  @override
  String get passportTitle => 'Pasport Selari';

  @override
  String passportCount(int count) {
    return '$count bandar dikumpul';
  }

  @override
  String passportRewardProgress(int count) {
    return 'Kumpul $count bandar lagi untuk dapatkan orb Pasport';
  }

  @override
  String get passportRewardDone =>
      'Anda sudah dapat orb Pasport. Pakai di Avatar Kuantum.';

  @override
  String get passportRewardToast => '5 bandar! Anda dapat orb Pasport';

  @override
  String get passportEmpty =>
      'Berbual dengan orang dari bandar lain di Alam Selari. Apabila kedua-dua pihak sudah bercakap, bandar itu dicop dalam pasport anda. Hanya bandar dan tarikh disimpan, bukan siapa yang anda bualkan.';

  @override
  String passportNewStamp(String city) {
    return 'Cop baharu: $city';
  }

  @override
  String get passportShare => 'Kongsi pasport';

  @override
  String passportCardTitle(int count) {
    return 'Pasport Selari saya\n$count bandar';
  }

  @override
  String passportCardShareText(int count) {
    return 'Pasport Selari saya ada cop dari $count bandar. Buka Mood Whisper dan masuk ke Alam Selari.';
  }
}
