// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get checkInEnter => 'Check-in di sini dan masuk';

  @override
  String get checkInNote =>
      'Setelah kamu ketuk, orang di sekitar akan melihat suasana hatimu dan kira-kira di mana kamu berada. Kamu check-in sendiri setiap kali masuk.';

  @override
  String get checkInTitle => 'Check-in ke kota';

  @override
  String get checkInBody =>
      'Setelah kamu check-in, orang di sekitar bisa melihat suasana hatimu dan kira-kira di mana kamu berada, dan kamu juga akan melihat mereka. Yang mereka lihat adalah tempat kamu check-in; tidak ikut berpindah saat kamu bergerak. Kamu check-in sendiri setiap kali membuka aplikasi; tidak pernah otomatis.';

  @override
  String get checkInButton => 'Check-in di sini';

  @override
  String get checkInAgain =>
      'Kamu sudah meninggalkan tempat check-in · Check-in di sini';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Senang';

  @override
  String get moodSad => 'Sedih';

  @override
  String get moodAngry => 'Marah';

  @override
  String get moodCalm => 'Tenang';

  @override
  String get moodPassion => 'Semangat';

  @override
  String get moodLove => 'Cinta';

  @override
  String get moodOther => 'Lainnya';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name sudah selesai';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'Kamu sudah menyerahkan $emoji $name dan sekarang menjadi peserta.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'Kamu sudah menyerahkan acara. Nama panggilanmu sudah 10 karakter, jadi tambahkan $emoji sendiri agar tetap menerima pengumuman.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'Kamu sudah menyerahkan acara. Kami menambahkan $emoji ke namamu, jadi sekarang kamu peserta.';
  }

  @override
  String get gotIt => 'Oke';

  @override
  String get blockedToast => 'Orang ini sudah lenyap ke dalam gelap.';

  @override
  String get unblockedToast =>
      'Blokir dibuka. Jalan kalian bisa bersilangan lagi.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Nyalakan Layanan Lokasi';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper perlu tahu kamu ada di sudut kota mana agar orang di sekitar bisa melihat mood-mu. Nyalakan Layanan Lokasi di Pengaturan ponselmu.';

  @override
  String get locationReducedTitle => 'Nyalakan Lokasi Akurat';

  @override
  String get locationReducedBodyIos =>
      'Kamu hanya membagikan lokasi perkiraan, jadi radar tidak bisa tahu siapa yang ada di dekatmu. Buka Pengaturan › Mood Whisper › Lokasi dan nyalakan Lokasi Akurat.';

  @override
  String get locationReducedBodyAndroid =>
      'Kamu hanya membagikan lokasi perkiraan, jadi radar tidak bisa tahu siapa yang ada di dekatmu. Pilih Akurat di izin lokasi.';

  @override
  String get locationNoFixTitle => 'Lokasimu belum ditemukan';

  @override
  String get locationNoFixBody =>
      'Mungkin kamu di dalam ruangan atau sinyal lemah. Pindah ke dekat jendela atau ke luar, nyalakan Wi-Fi, lalu coba lagi.';

  @override
  String get locationNeededTitle => 'Mood Whisper butuh lokasimu';

  @override
  String get locationNeededBody =>
      'Mood Whisper hanya memakai lokasimu saat aplikasi digunakan, untuk menampilkan mood dalam radius 5 km. Radar hanya menampilkan jarak perkiraan, bukan alamat.\nDi Pengaturan, izinkan lokasi Saat Aplikasi Digunakan dan nyalakan Lokasi Akurat.';

  @override
  String get locationSimulatorHint =>
      '(Catatan pengembang: di Simulator, pilih lokasi lewat Features › Location)';

  @override
  String get openSettings => 'Buka Pengaturan';

  @override
  String get locationRecheck => 'Sudah kunyalakan, periksa lagi';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get leaveApp => 'Keluar';

  @override
  String whispersNearby(int count) {
    return 'Ada $count bisikan di dekatmu. Ketuk amplop untuk membacanya.';
  }

  @override
  String get whisperPassed =>
      'Kamu melewati sebuah bisikan. Ketuk amplop untuk membacanya.';

  @override
  String get whisperLeft =>
      'Bisikanmu sudah ada di sini. Akan memudar dalam 7 hari.';

  @override
  String get timeWhisperSealedYear =>
      'Tersegel. Kembali ke sini setahun lagi untuk membukanya.';

  @override
  String get timeWhisperSealedMonth =>
      'Tersegel. Kembali ke sini sebulan lagi untuk membukanya.';

  @override
  String get whisperWithdrawn => 'Bisikanmu sudah ditarik.';

  @override
  String get whisperMineLabel => 'Bisikan yang kamu tinggalkan';

  @override
  String get whisperTapToRead => 'Sebuah bisikan. Ketuk untuk membaca';

  @override
  String get noMoodYet => 'Kehabisan kata…';

  @override
  String get knockWithdrawnByLeaving =>
      'Mereka menghilang ke dalam kota dan diam-diam menarik ketukannya…';

  @override
  String get knockCardTitle => 'Persilangan sesaat';

  @override
  String knockCardBody(String name) {
    return '$name sedang mengetuk,\nberharap jalan kalian bersilangan…';
  }

  @override
  String get skip => 'Lewati';

  @override
  String get decline => 'Tolak';

  @override
  String get accept => 'Terima';

  @override
  String get reportThisPerson => 'Laporkan orang ini';

  @override
  String get cityQuietTonight => 'Kota masih sepi malam ini';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'Kota malam ini · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. Lihat cuaca mood kota';
  }

  @override
  String get cityMoodTitle => 'Mood kota malam ini';

  @override
  String cityMoodQuietCount(int total) {
    return 'Kota masih sepi. $total orang sudah berbagi mood malam ini.';
  }

  @override
  String cityMoodCount(int total) {
    return '$total orang dalam radius 20 km sudah berbagi mood malam ini';
  }

  @override
  String get cityMoodQuietInvite =>
      'Setiap mood menambah sedikit cahaya. Tulis perasaanmu sekarang dan bantu terangi kota.';

  @override
  String get cityMoodFootnote =>
      'Mood anonim dari 24 jam terakhir. Persentase disembunyikan jika kurang dari 10 orang.';

  @override
  String get close => 'Tutup';

  @override
  String get emptyRadarTitle => 'Kamu cahaya pertama malam ini';

  @override
  String get emptyRadarBody =>
      'Belum ada orang di sekitar. Mood-mu sudah bersinar di kota,\ndan siapa pun yang lewat akan melihatnya. Kamu juga bisa meninggalkan bisikan untuk orang berikutnya yang lewat.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '$total orang ada di kota malam ini, kebanyakan merasa “$mood”';
  }

  @override
  String get inviteFriends => 'Ajak teman menerangi lingkunganmu';

  @override
  String get shareMoodCard => 'Bagikan kartu mood-ku';

  @override
  String get editYourMood => 'Ubah mood-mu';

  @override
  String resonanceTonight(int count) {
    return '$count kilauan beresonansi denganmu malam ini';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · mood-mu';
  }

  @override
  String get dockTapToEdit => 'Mood-mu · ketuk untuk ubah';

  @override
  String get leaveWhisper => 'Tinggalkan bisikan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get nightlyReminder => 'Pengingat malam';

  @override
  String get nightlyReminderSubtitle =>
      'Pengingat lembut pukul 21.30 setiap malam';

  @override
  String get closeSettings => 'Tutup pengaturan';

  @override
  String get settingsSectionMe => 'Aku';

  @override
  String get editProfile => 'Ubah profil';

  @override
  String get editProfileSubtitle => 'Foto, nama panggilan, dan mood';

  @override
  String get manageBlockList => 'Orang yang diblokir';

  @override
  String get manageBlockListSubtitle =>
      'Lihat atau buka blokir orang yang kamu kirim ke dalam gelap';

  @override
  String get myTimeWhispers => 'Surat untuk masa depan';

  @override
  String get myTimeWhispersSubtitle =>
      'Catatan untuk dirimu di masa depan, hanya kamu yang bisa melihat';

  @override
  String get myMoodTrail => 'Jejak mood-ku';

  @override
  String get myMoodTrailSubtitle => 'Hanya disimpan di ponselmu';

  @override
  String get settingsSectionGatherings => 'Acara';

  @override
  String get gatheringHost => 'Adakan acara';

  @override
  String get gatheringHostSubtitle =>
      'Mulai acara untuk semua orang dalam radius 5 km';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'Kamu menyelenggarakan $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Bagikan';

  @override
  String get shareMoodCardSubtitle =>
      'Salah satu dari sebelas ilustrasi malam secara acak, pas untuk Instagram Stories';

  @override
  String get inviteFriendsSubtitle =>
      'Makin banyak orang di sekitar, makin terang kotanya';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get guide => 'Cara pakai';

  @override
  String get guideSubtitle => 'Dari menulis mood sampai mengadakan acara';

  @override
  String get termsOfUse => 'Ketentuan Penggunaan';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get contactUs => 'Hubungi kami';

  @override
  String get deleteAccount => 'Hapus akun dan data';

  @override
  String get deleteAccountSubtitle =>
      'Hapus permanen semua yang kamu tinggalkan di kota';

  @override
  String get avatarUploadFailed => 'Fotomu gagal diunggah. Coba lagi nanti.';

  @override
  String get moodEmpty =>
      'Mood-mu tidak boleh kosong. Tinggalkan sedikit cahaya untuk kota.';

  @override
  String get profileSyncFailed => 'Statusmu gagal diperbarui. Coba lagi nanti.';

  @override
  String get profileUpdated => 'Diperbarui. Kota bisa merasakan napasmu.';

  @override
  String get changeAvatar => 'Ganti foto';

  @override
  String get avatarHint =>
      'Ketuk untuk ganti foto · cincinnya adalah warna mood-mu';

  @override
  String get cityName => 'Nama panggilan';

  @override
  String get cityNameHint => 'Opsional, mis. Kucing Pengembara';

  @override
  String get currentMood => 'Mood-mu sekarang';

  @override
  String get currentMoodHint => 'mis. Jalan-jalan di bawah gerimis 🌿';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get blockListTitle => 'Dikirim ke dalam gelap';

  @override
  String get blockListEmpty => 'Malam cerah. Kamu belum menjauhkan siapa pun.';

  @override
  String get unblock => 'Buka blokir';

  @override
  String get deleteAccountBody =>
      'Lokasi, mood, nama panggilan, foto, bisikan, kilauan, daftar blokir, dan obrolan aktifmu akan dihapus permanen. Ini tidak bisa dibatalkan.\n\nUntuk mencegah penyalahgunaan, catatan laporan disimpan selama 1 tahun sesuai Kebijakan Privasi.';

  @override
  String get deleting => 'Menghapus…';

  @override
  String get deletePermanently => 'Hapus permanen';

  @override
  String get deleteFailed =>
      'Penghapusan belum selesai. Periksa koneksimu dan coba lagi.';

  @override
  String get fadingEcho => 'Gema memudar';

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
  String get fadingEchoTitle => 'Sebuah gema memudar';

  @override
  String encounterWith(String name) {
    return 'Bertemu $name';
  }

  @override
  String get fadingEchoBody =>
      'Ini hanya gema yang memudar. Kamu tidak bisa bersilangan dengannya.';

  @override
  String get demoPersonBody =>
      'Ini orang demo yang membalas otomatis, bukan orang sungguhan. Pakai untuk mencoba mengetuk, mengobrol, kilauan, melapor, dan memblokir.';

  @override
  String get sendGlimmer => 'Kirim kilauan';

  @override
  String get knock => 'Ketuk';

  @override
  String get blockAction => 'Blokir';

  @override
  String get handOverHost => 'Serahkan penyelenggara';

  @override
  String get report => 'Laporkan';

  @override
  String get confirmBlockTitle => 'Blokir orang ini?';

  @override
  String confirmBlockBody(String name) {
    return 'Kirim $name ke dalam gelap?\nSetelah diblokir, kalian akan hilang dari kota satu sama lain.';
  }

  @override
  String get confirmBlock => 'Blokir';

  @override
  String get glimmerReceived =>
      'Seseorang mengirimimu kilauan. Mood-mu beresonansi dengan mereka.';

  @override
  String get glimmerSent => 'Kamu mengirim sebuah kilauan.';

  @override
  String get glimmerAlreadySent =>
      'Kamu sudah mengirim kilauan ke orang ini hari ini. Coba lagi besok.';

  @override
  String get knockSent => 'Ketukan terkirim. Menunggu jawaban…';

  @override
  String get knockFailed => 'Ketukanmu tidak terkirim. Coba lagi nanti.';

  @override
  String get knockNoAnswer => 'Tidak ada jawaban. Ketukanmu perlahan memudar.';

  @override
  String get knockDeclined =>
      'Jalan kalian belum bersilangan kali ini. Beri sedikit ruang untuk satu sama lain.';

  @override
  String get knockSkipped =>
      'Mereka melewatinya untuk sekarang, dan ketukanmu perlahan memudar.';

  @override
  String get sensingCity => 'Merasakan kota…';

  @override
  String get gatheringUnavailable =>
      'Acara sedang tidak tersedia. Coba lagi nanti.';

  @override
  String get notSentCheckNetwork =>
      'Tidak terkirim. Periksa koneksimu dan coba lagi.';

  @override
  String get justNow => 'baru saja';

  @override
  String minutesAgo(int count) {
    return '$count menit lalu';
  }

  @override
  String hoursAgo(int count) {
    return '$count jam lalu';
  }

  @override
  String get nextDayPrefix => 'besoknya ';

  @override
  String get gatheringNameMissing => 'Beri nama untuk acaramu.';

  @override
  String get gatheringEmojiInvalid => 'Ikon acara harus tepat satu emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name sudah dimulai. Minta orang menambahkan $emoji ke nama panggilan mereka untuk ikut.';
  }

  @override
  String get startGatheringTitle => 'Mulai acara';

  @override
  String get startGatheringLead =>
      'Semua orang dalam radius 5 km darimu. Areanya ikut bergerak bersamamu.';

  @override
  String get gatheringNameHint =>
      'Nama acara, mis. Kembang Api Tahun Baru Monas';

  @override
  String get gatheringEmojiHint => 'Ikon';

  @override
  String get gatheringEmojiHelp =>
      'Ikon acara adalah satu emoji yang belum dipakai siapa pun di sekitar.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'Orang yang menambahkan $emoji ke nama panggilannya akan melihat pengumumanmu dan menerima notifikasi.';
  }

  @override
  String get start => 'Mulai';

  @override
  String get end => 'Selesai';

  @override
  String get gatheringMaxDuration =>
      'Acara berlangsung paling lama 24 jam dan selesai otomatis.';

  @override
  String get starting => 'Memulai…';

  @override
  String get startGathering => 'Mulai acara';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name sudah selesai. Kamu kembali ke kota.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · Kamu penyelenggara';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'Orang dalam radius 5 km yang punya $emoji di namanya akan melihat pengumuman dan mendapat notifikasi. Kamu tidak bisa melihat siapa mereka.';
  }

  @override
  String get postAnnouncement => 'Kirim pengumuman';

  @override
  String get announcementHint => 'mis. Kita kumpul di pintu keluar A stasiun';

  @override
  String get announcementSent => 'Pengumuman terkirim';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix =>
      ' (disembunyikan setelah banyak laporan)';

  @override
  String get groupQuestion => 'Tanya semua';

  @override
  String get questionHint => 'mis. Bagaimana perasaanmu sekarang?';

  @override
  String get sendQuestion => 'Tanya';

  @override
  String get questionSent =>
      'Pertanyaan terkirim. Semua akan menjawab dengan mood';

  @override
  String get handOff => 'Serahkan';

  @override
  String handoffPending(String name) {
    return '$name diundang untuk mengambil alih. Menunggu jawaban…';
  }

  @override
  String get theOtherPerson => 'mereka';

  @override
  String get handoffCancelled => 'Undangan penyerahan dibatalkan';

  @override
  String get handoffHelp =>
      'Tekan lama gelembung peserta di radar → Serahkan penyelenggara. Setelah mereka menerima, merekalah penyelenggaranya dan acara berjalan tanpa terputus.';

  @override
  String get confirmEndAgain => 'Akhiri? Ketuk sekali lagi';

  @override
  String get endGathering => 'Akhiri acara';

  @override
  String tallyHeader(String question, int total) {
    return '“$question” · $total jawaban';
  }

  @override
  String get tallyQuiet =>
      'Persentase muncul setelah 10 jawaban, agar tidak ada yang bisa ditebak saat sedikit yang menjawab.';

  @override
  String get bannerYouHost => '  · Kamu penyelenggara';

  @override
  String get bannerHostAnnouncement => '  · Dari penyelenggara';

  @override
  String get manageGathering => 'Kelola acara';

  @override
  String get reportAnnouncement => 'Laporkan pengumuman ini';

  @override
  String get expandAnnouncement => 'Tampilkan pengumuman';

  @override
  String get collapseAnnouncement => 'Sembunyikan pengumuman';

  @override
  String hostHandedOffAgo(String ago) {
    return 'Penyelenggara baru · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'Kamu melaporkan pengumuman ini, jadi sudah dihapus dari layarmu.';

  @override
  String get noAnnouncementHost =>
      'Belum ada pengumuman. Ketuk ikon pengatur di kanan atas untuk mengirim yang pertama.';

  @override
  String get noAnnouncementGuest => 'Penyelenggara belum mengirim apa pun.';

  @override
  String hostAsks(String question) {
    return 'Penyelenggara bertanya: $question';
  }

  @override
  String get answeredNote =>
      'Sudah dijawab. Penyelenggara hanya melihat persentase mood keseluruhan.';

  @override
  String get answerHint => 'Jawab dengan satu mood';

  @override
  String get sendAnswer => 'Kirim jawaban';

  @override
  String handoffInvited(String name) {
    return '$name diundang untuk mengambil alih. Menunggu jawaban (berlaku 5 menit).';
  }

  @override
  String handoffTitle(String name) {
    return 'Serahkan acara ke $name';
  }

  @override
  String get handoffBody =>
      'Setelah mereka menerima, merekalah yang menyelenggarakan acara. Nama, pengumuman, dan pertanyaan tetap ada, dan kamu menjadi peserta.';

  @override
  String get handoffPublic => 'Umumkan penyerahan';

  @override
  String get handoffPublicHelp =>
      'Beri tahu semua peserta ada penyelenggara baru';

  @override
  String get handoffQuiet => 'Serahkan diam-diam';

  @override
  String get handoffQuietHelp =>
      'Tidak ada yang diberi tahu. Hanya cincin penyelenggara di radar yang berpindah';

  @override
  String get sending => 'Mengirim…';

  @override
  String get sendInvite => 'Kirim undangan';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'Sekarang kamu penyelenggara $emoji $name.';
  }

  @override
  String get handoffOfferTitle => 'Mau mengambil alih acara?';

  @override
  String handoffOfferBody(String name) {
    return 'Penyelenggara ingin menyerahkan “$name” kepadamu. Sebagai penyelenggara, kamu bisa mengirim pengumuman, bertanya, dan mengakhiri acara, serta bertanggung jawab atas yang kamu kirim.';
  }

  @override
  String get processing => 'Memproses…';

  @override
  String get acceptHosting => 'Ambil alih';

  @override
  String get guideS1Title => '1. Masuk ke kota';

  @override
  String get guideS1L1 =>
      'Saat pertama membuka aplikasi, pastikan kamu berusia 18 tahun ke atas dan izinkan lokasi akurat saat aplikasi digunakan. Tanpa lokasi akurat, radar tidak bisa bekerja.';

  @override
  String get guideS1L2 =>
      'Tulis satu kalimat tentang perasaanmu saat ini (maksimal 20 karakter), setujui Ketentuan Penggunaan dan Kebijakan Privasi, lalu ketuk Check-in di sini dan masuk.';

  @override
  String get guideS1L3 =>
      'Tidak perlu nomor telepon, email, atau nama asli. Akunmu anonim dan terikat ke ponsel ini.';

  @override
  String get guideS1L4 =>
      'Kata dalam mood-mu menentukan warnanya: “senang, tertawa” emas, “sedih, menangis” biru, “marah” merah oranye, “tenang, melamun” hijau, “semangat” oranye, “cinta, hati” merah muda, dan lainnya ungu lembut.';

  @override
  String get guideS1L5 =>
      'Check-in: setiap kali membuka aplikasi, kamu check-in sendiri, dan baru setelah itu orang di sekitar bisa melihat suasana hatimu dan kira-kira di mana kamu berada, dan kamu melihat mereka. Tidak pernah otomatis. Orang lain melihat tempat kamu check-in; tidak ikut berpindah saat kamu bergerak. Jika kamu bergerak lebih dari 1 km, Check-in di sini muncul di bawah radar. Jika aplikasi berada di latar belakang lebih dari 30 menit, kamu check-in lagi saat kembali.';

  @override
  String get guideS2Title => '2. Bilah bawah';

  @override
  String get guideS2L1 =>
      'Ketuk fotomu di kiri untuk mengubah foto, nama panggilan (maks. 10 karakter), dan mood.';

  @override
  String get guideS2L2 => 'Ikon catatan: tinggalkan bisikan di sini.';

  @override
  String get guideS2L3 =>
      'Ikon bagikan: jadikan mood-mu kartu pemandangan malam.';

  @override
  String get guideS2L4 => 'Ikon pengatur paling kanan: buka Pengaturan.';

  @override
  String get guideS3Title => '3. Radar dan gelembung';

  @override
  String get guideS3L1 =>
      'Gelembung mood orang dalam radius 5 km muncul di radar. Hanya rentang jarak perkiraan yang ditampilkan (seperti “dalam 100 m”), bukan alamat.';

  @override
  String get guideS3L2 =>
      'Gelembung yang bernapas berarti orangnya sedang memakai aplikasi. Gelembung redup bertanda Istirahat berarti layarnya terkunci, tapi kamu tetap bisa mengetuk. Gelembung abu-abu tanpa nama adalah gema memudar dari orang yang baru pergi, dan perlahan menghilang.';

  @override
  String get guideS3L3 =>
      'Cubit untuk memperbesar peta. Putar ponselmu dan radar ikut berputar.';

  @override
  String get guideS3L4 =>
      'Saat gelembung berkumpul, mereka menyatu menjadi bola cahaya, “N mood di sini”. Ketuk untuk membukanya melingkar agar setiap gelembung bisa diketuk; ketuk tengah atau ruang kosong untuk menutup.';

  @override
  String get guideS3L5 =>
      'Nama yang diawali Demo adalah orang demo yang membalas otomatis. Mereka bukan orang sungguhan, dan bisa dipakai untuk mencoba semua fitur.';

  @override
  String get guideS3L6 =>
      'Saat tidak ada orang di sekitar, “Kamu cahaya pertama malam ini” muncul di bawah, dan kamu bisa mengajak teman menerangi lingkunganmu.';

  @override
  String get guideS4Title => '4. Mengetuk dan mengobrol';

  @override
  String get guideS4L1 =>
      'Tekan lama gelembung seseorang → Ketuk. Mereka punya 5 menit untuk menerima, menolak, atau melewati. Selama menunggu, garis cahaya mengalir darimu ke mereka.';

  @override
  String get guideS4L2 =>
      'Setelah mereka menerima, obrolan dimulai dengan hitung mundur 10 menit. Setiap pesan baru mengulangnya, dan obrolan selesai saat kalian berdua diam.';

  @override
  String get guideS4L3 =>
      'Saat obrolan selesai, pesan dihapus dari server. Orang lain tetap bisa mengambil tangkapan layar, jadi berbagilah dengan hati-hati.';

  @override
  String get guideS4L4 =>
      'Saat seseorang mengetuk pintumu, kartu ketukan muncul. Kamu bisa menerima, menolak, melewati, atau langsung melapor.';

  @override
  String get guideS5Title => '5. Kilauan';

  @override
  String get guideS5L1 =>
      'Ketuk dua kali gelembung seseorang, atau tekan lama dan pilih Kirim kilauan, untuk memberi tahu mereka ada yang memperhatikan tanpa berkata apa-apa.';

  @override
  String get guideS5L2 =>
      'Mereka hanya melihat “N kilauan beresonansi denganmu malam ini” dan tidak pernah tahu siapa pengirimnya. Kamu bisa mengirim satu kilauan ke orang yang sama setiap 24 jam.';

  @override
  String get guideS6Title => '6. Bisikan';

  @override
  String get guideS6L1 =>
      'Ketuk ikon catatan di bilah bawah untuk meninggalkan satu kalimat di tempatmu berada (maks. 60 karakter).';

  @override
  String get guideS6L2 =>
      'Selama 7 hari ke depan, siapa pun dalam radius 300 m akan melihat amplop di radar dan bisa membukanya.';

  @override
  String get guideS6L3 =>
      'Bisikan selalu anonim. Kamu bisa punya maksimal 3 sekaligus, meninggalkan paling banyak 1 setiap 10 menit, dan menariknya kapan saja.';

  @override
  String get guideS6L4 =>
      'Surat untuk masa depan: saat menulis bisikan, pilih Untuk diriku di masa depan, lalu sebulan atau setahun lagi. Hanya kamu yang bisa melihatnya. Saat waktunya tiba kamu akan diberi tahu, dan surat terbuka sendiri saat kamu kembali dalam radius 100 m. Hanya bisa dibaca sekali. Hanya kamu yang melihat jam pasir kecil di radar (terkunci atau terbuka), dan tidak bisa diketuk. Maksimal 5 sekaligus; lihat atau hapus di Pengaturan → Surat untuk masa depan.';

  @override
  String get guideS7Title => '7. Cuaca mood kota';

  @override
  String get guideS7L1 =>
      'Label di kiri atas menampilkan mood paling umum dalam radius 20 km selama 24 jam terakhir. Ketuk untuk rincian lengkap.';

  @override
  String get guideS7L2 =>
      'Persentase disembunyikan jika kurang dari 10 orang, agar tidak ada yang bisa dikenali.';

  @override
  String get guideS8Title => '8. Acara';

  @override
  String get guideS8L1 =>
      'Cara memulai: Pengaturan → Adakan acara → isi nama, satu emoji sebagai ikon, serta waktu mulai dan selesai (maks. 24 jam) → Mulai acara.';

  @override
  String get guideS8L2 =>
      'Acara mencakup 5 km di sekitar tempat tuan rumah check-in; saat tuan rumah check-in lagi, area ikut berpindah. Tuan rumah punya cincin cahaya dan label Tuan rumah di radar.';

  @override
  String get guideS8L3 =>
      'Penyelenggara bisa mengirim pengumuman (sebanyak yang perlu), bertanya ke semua orang, dan mengakhiri acara kapan saja.';

  @override
  String get guideS8L4 =>
      'Untuk ikut, tambahkan ikon acara ke nama panggilanmu (mis. “Kucing Pengembara🌈”). Selama kamu di dalam area, kamu akan melihat pengumuman tersemat di atas radar dan mendapat notifikasi. Hapus ikonnya untuk keluar.';

  @override
  String get guideS8L5 =>
      'Pertanyaan grup: jawab dengan satu mood. Penyelenggara hanya melihat persentase mood keseluruhan, bukan siapa menjawab apa, dan persentase disembunyikan di bawah 10 jawaban.';

  @override
  String get guideS8L6 =>
      'Hanya satu acara yang bisa memakai satu ikon di area yang sama pada waktu yang sama. Setelah selesai, siapa pun bisa memakainya.';

  @override
  String get guideS8L7 =>
      'Penyerahan: penyelenggara menekan lama gelembung peserta → Serahkan penyelenggara, lalu memilih penyerahan diumumkan atau diam-diam. Jika orang itu menerima dalam 5 menit, ia menjadi penyelenggara, dan pengumuman serta pertanyaan tetap ada. Penyelenggara sebelumnya menjadi peserta dan ikon ditambahkan ke namanya.';

  @override
  String get guideS9Title => '9. Mercusuar Kota (toilet ramah semua)';

  @override
  String get guideS9L1 =>
      'Ketuk ikon toilet di kiri bawah peta untuk menyalakan mercusuar. Toilet netral gender, difabel, dan keluarga dalam radius 2 km muncul di radar, dengan jumlahnya di samping ikon. Ketuk tiga filter bulat di atasnya untuk menampilkan jenis tertentu saja.';

  @override
  String get guideS9L2 =>
      'Ketuk penanda untuk melihat lantai, fasilitas, dan jarak, lalu ketuk Jalan ke sana untuk petunjuk arah di aplikasi petamu.';

  @override
  String get guideS9L3 =>
      'Data berasal dari catatan toilet umum Kementerian Lingkungan Hidup Taiwan dan diperbarui setiap bulan. Jam buka tidak tersedia; “Mungkin buka malam hari” adalah perkiraan kami berdasarkan jenis tempat.';

  @override
  String get guideS9L4 =>
      'Jika ada yang salah, kamu bisa melaporkannya (bukan netral gender, tutup malam hari, tidak ditemukan). Jika 3 orang melaporkan masalah yang sama, penanda berubah abu-abu dengan catatan.';

  @override
  String get guideS10Title => '10. Kartu mood dan jejak mood';

  @override
  String get guideS10L1 =>
      'Tombol bagikan di bilah bawah menjadikan mood-mu saat ini kartu pemandangan malam, pas untuk Instagram Stories. Kartu tidak pernah menampilkan lokasimu.';

  @override
  String get guideS10L2 =>
      'Pengaturan → Jejak mood-ku memungkinkanmu melihat kembali mood dan tempat yang pernah kamu tulis. Hanya disimpan di ponselmu, dan bisa dimatikan atau dihapus kapan saja.';

  @override
  String get guideS11Title => '13. Pengaturan dan notifikasi';

  @override
  String get guideS11L1 =>
      'Pengingat malam: pengingat lembut pukul 21.30 setiap malam. Nyalakan atau matikan di Pengaturan.';

  @override
  String get guideS11L2 =>
      'Ketukan, pesan baru, kilauan, dan pengumuman acara datang sebagai notifikasi. Kamu bisa mematikannya di pengaturan ponsel.';

  @override
  String get guideS11L3 =>
      'Setiap Jumat pukul 21.00–23.00 adalah Malam Bercahaya, saat semua orang online bersama dan kota paling terang.';

  @override
  String get guideS12Title => '14. Laporan dan blokir';

  @override
  String get guideS12L1 =>
      'Kamu bisa melapor dari menu tekan lama gelembung, kartu ketukan, kanan atas obrolan, bisikan, atau pengumuman acara. Setelah melapor, orang atau unggahan itu langsung hilang dari layarmu dan obrolan berakhir. Kami menangani setiap laporan dalam 24 jam.';

  @override
  String get guideS12L2 =>
      'Mood, nama, bisikan, pesan obrolan, dan pengumuman acara otomatis disaring dari kata-kata kasar dan info kontak seperti nomor telepon dan tautan.';

  @override
  String get guideS12L3 =>
      'Setelah kamu memblokir seseorang, kalian hilang dari radar satu sama lain dan tidak bisa mengetuk atau mengirim kilauan. Buka blokir di Pengaturan → Orang yang diblokir.';

  @override
  String get guideS12L4 =>
      'Jika kamu dalam bahaya mendesak, hubungi nomor darurat setempat (112 di Indonesia, 110 di Taiwan).';

  @override
  String get guideS13Title => '15. Privasi dan akunmu';

  @override
  String get guideS13L1 =>
      'Hanya setelah kamu check-in, orang di sekitar bisa melihat suasana hati, nama kota, foto, dan perkiraan jarakmu. Yang mereka lihat adalah tempat kamu check-in, bukan lokasi waktu nyata.';

  @override
  String get guideS13L2 =>
      'Pengaturan → Hapus akun dan data menghapus permanen semua yang kamu tinggalkan di kota, kapan saja.';

  @override
  String get guideS13L3 =>
      'Ada pertanyaan? Buka Pengaturan → Hubungi kami, atau email ke service.softchip@gmail.com.';

  @override
  String get guideS14Title => '11. Semesta Paralel';

  @override
  String get guideS14L1 =>
      'Ketuk ikon bola dunia di kanan atas radar untuk menyalakannya, dan ketuk lagi untuk mematikannya. Selalu mati setiap kali kamu membuka aplikasi.';

  @override
  String get guideS14L2 =>
      'Setiap kota atau kabupaten di Taiwan berpusat di stasiun pusatnya sendiri (Taipei Raya di Stasiun Taipei, Taoyuan di Stasiun Taoyuan, dan seterusnya) dan dipasangkan dengan kota di luar negeri: Jepang, Korea, Hong Kong, Makau, Singapura, Malaysia, Indonesia, dan Vietnam. Kota di luar negeri dipasangkan dengan Taiwan.';

  @override
  String get guideS14L3 =>
      'Seberapa jauh dan ke arah mana kamu dari stasiunmu, di situlah kamu muncul di kota mereka, dengan jarak dan arah yang sama dari stasiun mereka, dikaburkan sekitar 500 m. Tidak ada yang bisa melihat lokasi aslimu.';

  @override
  String get guideS14L4 =>
      'Kalian saling melihat jika salah satu menyalakannya: saat menyala, kamu melihat semua orang di kota pasangan yang sedang membuka aplikasi; saat mati, kamu hanya melihat orang yang menyalakannya. Hanya orang yang sudah check-in dan sedang membuka aplikasi yang muncul di kota lain.';

  @override
  String get guideS14L5 =>
      'Orang dari Semesta Paralel punya cincin putus-putus dan menampilkan kotanya. Kamu tetap bisa mengirim cahaya, mengetuk, dan mengobrol. Gema yang memudar, bisikan, surat untuk masa depan, dan acara tetap di tempat asalnya.';

  @override
  String get guideS15Title => '12. Terjemahan';

  @override
  String get guideS15L1 =>
      'Saat mengobrol, jika pesan tidak dalam bahasamu, Ketuk untuk menerjemahkan muncul di bawahnya. Ketuk untuk menerjemahkan, dan ketuk lagi untuk melihat teks asli.';

  @override
  String get guideS15L2 =>
      'Gelembung suasana hati di radar juga sama: jika tidak dalam bahasamu, ketuk untuk menerjemahkan dan ketuk lagi untuk kembali ke teks asli.';

  @override
  String get guideS15L3 =>
      'Terjemahan sepenuhnya dilakukan di ponselmu; teks tidak pernah diunggah. iPhone memakai terjemahan bawaan Apple, dan sistem bertanya sebelum mengunduh bahasa pertama kali. Android memakai Google ML Kit, yang bertanya dulu lalu mengunduh model bahasa sekitar 30 MB. iPhone belum bisa menerjemahkan bahasa Melayu.';

  @override
  String get guideIntro =>
      'Mood Whisper adalah kota di malam hari: tulis satu kalimat tentang perasaanmu sekarang, dan lihat perasaan orang-orang di sekitarmu.';

  @override
  String get beaconGender => 'Netral gender';

  @override
  String get beaconAccessible => 'Difabel';

  @override
  String get beaconFamily => 'Keluarga';

  @override
  String get beaconReportNotGender => 'Bukan netral gender';

  @override
  String get beaconReportClosed => 'Tutup malam hari';

  @override
  String get beaconReportMissing => 'Toilet ini tidak ditemukan';

  @override
  String get beaconFlagNotGender => 'Dilaporkan: bukan netral gender';

  @override
  String get beaconFlagClosed => 'Dilaporkan: tutup malam hari';

  @override
  String get beaconFlagMissing => 'Dilaporkan: tidak ditemukan';

  @override
  String get beaconDefaultName => 'Toilet umum';

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
      'Mercusuar Kota sedang tidak tersedia. Coba lagi nanti.';

  @override
  String get notConnectedCheckNetwork =>
      'Tidak bisa terhubung. Periksa koneksimu dan coba lagi.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'Toilet $features, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Matikan Mercusuar Kota (toilet ramah semua), $count di sekitar';
  }

  @override
  String get beaconToggleOn => 'Nyalakan Mercusuar Kota (toilet ramah semua)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Tampilkan $feature saja';
  }

  @override
  String get beaconMaybeOpenNight => 'Mungkin buka malam hari (perkiraan)';

  @override
  String get beaconMaybeDaytime => 'Mungkin hanya buka siang (perkiraan)';

  @override
  String get walkThere => 'Jalan ke sana';

  @override
  String get beaconWrongData => 'Ada yang salah?';

  @override
  String beaconThanks(String reason) {
    return 'Terima kasih. Laporanmu sudah kami terima: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Sumber: catatan toilet umum Kementerian Lingkungan Hidup Taiwan, diperbarui setiap bulan. Jam buka adalah perkiraan kami berdasarkan jenis tempat.';

  @override
  String get invite1 =>
      'Aku menyalakan satu cahaya di Mood Whisper. Makin banyak orang di sekitar, makin terang lingkungan kita. Yuk terangi bareng:';

  @override
  String get invite2 =>
      'Kota agak sepi malam ini. Tulis satu mood di Mood Whisper dan bantu terangi lingkungan kita:';

  @override
  String get invite3 =>
      'Nggak perlu tambah teman, nggak perlu nama asli, cukup satu kalimat tentang perasaanmu. Temui aku di Mood Whisper:';

  @override
  String get invite4 =>
      'Aku meninggalkan satu cahaya untukmu di Mood Whisper. Buka aplikasinya dan lihat apa yang dirasakan orang di sekitar malam ini:';

  @override
  String get invite5 =>
      'Setiap Jumat jam 9 malam adalah Malam Bercahaya di Mood Whisper. Yuk online bareng dan penuhi radar dengan cahaya:';

  @override
  String get invite6 =>
      'Butuh tempat untuk cerita tentang harimu? Mood Whisper anonim, dan kata-katamu memudar setelah diucapkan:';

  @override
  String get invite7 =>
      'Pernah penasaran apa yang dirasakan orang yang kamu lewati di jalan? Lihat sendiri di Mood Whisper:';

  @override
  String get invite8 =>
      'Aku meninggalkan bisikan di jalan ini yang hanya bisa dibaca orang yang lewat. Yuk tinggalkan satu juga:';

  @override
  String get invite9 =>
      'Mood Whisper adalah peta mood kota di malam hari. Makin ramai makin seru, jadi yuk tambah cahaya di lingkungan kita:';

  @override
  String get invite10 =>
      'Apa warna mood-mu malam ini? Tulis di Mood Whisper. Aku ada di dekat sini, menunggu cahayamu:';

  @override
  String get shareInvite => 'Bagikan undangan';

  @override
  String get inviteSubject => 'Yuk terangi lingkungan kita bareng';

  @override
  String get shareMoodCardButton => 'Bagikan kartu';

  @override
  String moodShareText(String mood) {
    return 'Aku membagikan perasaanku sekarang di Mood Whisper: “$mood”\nApakah mood-mu juga bersinar di kota malam ini?';
  }

  @override
  String get shareFailed => 'Gagal dibagikan. Coba lagi.';

  @override
  String shuffleCard(int current, int total) {
    return 'Ganti · $current / $total';
  }

  @override
  String get preparing => 'Menyiapkan…';

  @override
  String get sendLinkToFriends => 'Kirim tautan ke teman (WhatsApp, Messenger)';

  @override
  String get partLateNight => 'Larut malam';

  @override
  String get partMorning => 'Pagi';

  @override
  String get partAfternoon => 'Siang';

  @override
  String get partDusk => 'Senja';

  @override
  String get partNight => 'Malam';

  @override
  String get cardInviteEyebrow => 'Undangan';

  @override
  String get cardMoodEyebrow => 'Perasaanku sekarang';

  @override
  String get cardInviteTitle => 'Yuk terangi\nlingkungan kita';

  @override
  String get cardInviteBody =>
      'Aku menyalakan satu cahaya di Mood Whisper.\nMakin banyak orang di sekitar, makin terang lingkungan kita.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nDi suatu sudut kota';
  }

  @override
  String get whisperUnavailable =>
      'Bisikan sedang tidak tersedia. Coba lagi nanti.';

  @override
  String get whisperNotSent =>
      'Bisikanmu tidak terkirim. Periksa koneksimu dan coba lagi.';

  @override
  String daysAgo(int count) {
    return '$count hari lalu';
  }

  @override
  String get timeWhisperTitle => 'Surat untuk masa depan';

  @override
  String get timeWhisperLead =>
      'Tulis untuk dirimu di masa depan. Saat waktunya tiba, kembali ke sini untuk membukanya.';

  @override
  String get whisperLead => 'Tulis untuk orang berikutnya yang lewat.';

  @override
  String get toPassersBy => 'Untuk yang lewat';

  @override
  String get toFutureSelf => 'Untuk diriku di masa depan';

  @override
  String get inOneMonth => 'Sebulan lagi';

  @override
  String get inOneYear => 'Setahun lagi';

  @override
  String get timeWhisperHint =>
      'mis. Sampai jumpa di sini tahun depan. Semoga kamu lebih baik dari sekarang.';

  @override
  String get whisperHint =>
      'mis. Senja di sini indah. Jangan lupa lihat ke atas.';

  @override
  String get timeWhisperCaptionYear =>
      'Hanya kamu yang bisa melihat · terbuka setahun lagi dan kamu diberi tahu · dibuka dalam 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Hanya kamu yang bisa melihat · terbuka sebulan lagi dan kamu diberi tahu · dibuka dalam 100 m';

  @override
  String get whisperCaption =>
      'Memudar dalam 7 hari · tidak menunjukkan siapa kamu · hanya bahwa kamu pernah di sekitar sini';

  @override
  String get sealHere => 'Segel di sini';

  @override
  String get leaveHere => 'Tinggalkan di sini';

  @override
  String get aWhisper => 'Sebuah bisikan';

  @override
  String whisperLeftAgo(String ago) {
    return 'Ditinggalkan di sekitar sini $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    return 'Dibaca $count orang';
  }

  @override
  String get whisperNobodyYet => 'Belum ada yang lewat';

  @override
  String get withdrawWhisper => 'Tarik bisikan ini';

  @override
  String get whisperCollected => 'Kamu mengambil bisikan ini.';

  @override
  String whisperReadersBefore(int count) {
    return '$count orang sudah lewat di sini sebelum kamu.';
  }

  @override
  String get whisperFirstReader => 'Kamu orang pertama yang lewat di sini.';

  @override
  String get reportWhisper => 'Laporkan bisikan ini';

  @override
  String get thisWhisper => 'Bisikan ini';

  @override
  String get chatTimeUp => 'Waktu habis. Momen ini memudar...';

  @override
  String get chatOtherLeft => 'Mereka menghilang ke dalam kota...';

  @override
  String get chatEnded => 'Momen ini sudah berakhir...';

  @override
  String get chatBlockedEnded => 'Diblokir. Obrolan sudah berakhir.';

  @override
  String get chatReportedEnded => 'Dilaporkan. Obrolan sudah berakhir.';

  @override
  String get anonymous => 'Anonim';

  @override
  String get leaveChat => 'Tinggalkan obrolan';

  @override
  String chatWith(String name) {
    return 'Momen bersama $name';
  }

  @override
  String get countdownPrefix => 'Memudar dalam ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Obrolan demo: balasannya otomatis, bukan dari orang sungguhan.';

  @override
  String get typing => 'Sedang mengetik…';

  @override
  String get chatHint => 'Ucapkan sesuatu dengan lembut…';

  @override
  String get send => 'Kirim';

  @override
  String get chatDissolvedApart => 'Kalian masing-masing kembali ke kota';

  @override
  String get knockTooOften =>
      'Kamu terlalu sering mengetuk. Tarik napas bersama kota...';

  @override
  String get otherNotNow =>
      'Mereka sedang tidak ingin diganggu. Beri sedikit ruang untuk satu sama lain.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'Mereka sedang tidak ingin diganggu. Beri sedikit ruang untuk satu sama lain ($minutes menit).';
  }

  @override
  String get justEndedRest =>
      'Kalian baru saja berpisah. Biarkan kenangan itu mengendap sebentar.';

  @override
  String get intro1Title => 'Menyelinap ke kota';

  @override
  String get intro1Body =>
      'Tinggalkan label sosial. Di atas kanvas gelap yang tenang, yang tersisa hanya perasaanmu yang sebenarnya, dan di mana kamu berada.';

  @override
  String get intro2Title => 'Momen yang lewat';

  @override
  String get intro2Body =>
      'Lihat gelembung mood melayang di dekatmu? Ketuk pelan dan nikmati obrolan sekali seumur hidup dengan orang yang lewat.';

  @override
  String get intro3Title => 'Irama kota';

  @override
  String get intro3Body =>
      'Kami peduli dengan perasaanmu. Setelah mengetuk, tunggu jawaban dengan tenang. Jika belum berjodoh, gelembung akan memudar setelah 300 detik.';

  @override
  String get intro4Title => 'Jarak yang lembut';

  @override
  String get intro4Body =>
      'Tidak ingin diganggu? Tolak atau blokir. Sistem jeda menjauhkan kebisingan dan mengembalikan sudut tenangmu.';

  @override
  String get intro5Title => 'Siap bertemu?';

  @override
  String get intro5Body =>
      'Pejamkan mata dan rasakan getar ponsel serta detak jantungmu. Sekarang, tulis perasaanmu dan masuklah ke Mood Whisper.';

  @override
  String get loadingImage => 'Memuat gambar...';

  @override
  String get startExploring => 'Mulai menjelajah';

  @override
  String get nextPage => 'Berikutnya';

  @override
  String get feedbackSubject => 'Masukan untuk Mood Whisper';

  @override
  String get loginNeedMood =>
      'Tulis perasaanmu sekarang, lalu masuklah ke kota.';

  @override
  String get loginNeedAgree =>
      'Baca dan setujui Ketentuan Penggunaan dan Kebijakan Privasi dulu.';

  @override
  String get loginCantConnect =>
      'Tidak bisa menjangkau kota. Periksa koneksimu dan coba lagi.';

  @override
  String get ageQuestion => 'Apakah kamu berusia 18 tahun ke atas?';

  @override
  String get ageReason =>
      'Mood Whisper menghubungkanmu dengan orang asing di sekitar, jadi hanya untuk usia 18 tahun ke atas.';

  @override
  String get ageUnder => 'Aku di bawah 18';

  @override
  String get ageOver => 'Aku 18 atau lebih';

  @override
  String get loginTitle1 => 'Siap';

  @override
  String get loginTitle2 => 'bertemu?';

  @override
  String get loginLead =>
      'Pejamkan mata dan rasakan getar ponsel serta detak jantungmu.\nSekarang, tulis perasaanmu dan masuklah ke Mood Whisper.';

  @override
  String get loginPrompt => 'Apa yang ingin kamu katakan ke kota saat ini?';

  @override
  String get loginHint => 'mis. Baru minum kopi yang enak😊';

  @override
  String get enterCity => 'Masuk Mood Whisper';

  @override
  String get agreeSemantic =>
      'Aku sudah membaca dan menyetujui Ketentuan Penggunaan dan Kebijakan Privasi';

  @override
  String get agreePrefix => 'Aku sudah membaca dan menyetujui ';

  @override
  String get termsLink => 'Ketentuan Penggunaan';

  @override
  String get agreeAnd => ' dan ';

  @override
  String get privacyLink => 'Kebijakan Privasi';

  @override
  String get agreeSuffix =>
      '. Mood Whisper tidak menoleransi pelecehan, konten seksual, kebencian, atau penyalahgunaan lainnya. Siapa pun yang melanggar akan dikeluarkan.';

  @override
  String get under18Title => 'Mood Whisper hanya untuk usia 18 tahun ke atas';

  @override
  String get under18Body =>
      'Terima kasih sudah jujur. Kota ini menghubungkanmu dengan orang asing. Sampai jumpa saat kamu berusia 18 tahun.';

  @override
  String get clearMoodTrail => 'Hapus jejak mood';

  @override
  String get clearMoodTrailBody =>
      'Semua jejak mood di ponsel ini akan dihapus. Ini tidak bisa dibatalkan.';

  @override
  String get clear => 'Hapus';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'Hanya disimpan di ponselmu. Tidak pernah diunggah ke mana pun.';

  @override
  String get moodTrailEmpty =>
      'Belum ada jejak mood minggu ini. Setiap kali kamu menulis mood atau pergi ke tempat baru, satu cahaya lagi muncul di sini.';

  @override
  String get thisWeekYou => 'Minggumu';

  @override
  String get topMoodPrefix => 'Kamu paling sering merasa “';

  @override
  String topMoodSuffix(int count) {
    return '”, sebanyak $count kali';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$total mood ditinggalkan di $places tempat berbeda';
  }

  @override
  String get recordMoodTrail => 'Rekam jejak mood-ku';

  @override
  String get recordMoodTrailOff =>
      'Jika dimatikan, tidak ada jejak baru yang direkam';

  @override
  String get nightly1 => 'Apa yang dipikirkan kota malam ini?';

  @override
  String get nightly2 =>
      'Seseorang di dekatmu sedang menulis perasaannya sekarang.';

  @override
  String get nightly3 => 'Malamnya pas. Tinggalkan satu kalimat untuk kota.';

  @override
  String get nightly4 => 'Bagaimana harimu? Mood-mu akan bersinar di kota.';

  @override
  String get nightly5 =>
      'Lampu jalan sudah menyala, dan orang di sekitar masih terjaga.';

  @override
  String get nightly6 => 'Tutup hari ini: bagaimana perasaanmu sekarang?';

  @override
  String get nightly7 => 'Siapa yang akan berpapasan denganmu malam ini?';

  @override
  String get nightlyChannel => 'Pengingat malam';

  @override
  String get nightlyChannelDesc =>
      'Satu pengingat lembut setiap malam. Bisa dimatikan di pengaturan aplikasi.';

  @override
  String get reasonHarassment => 'Pelecehan atau perundungan';

  @override
  String get reasonSexual => 'Konten seksual';

  @override
  String get reasonScam => 'Penipuan atau spam';

  @override
  String get reasonHate => 'Kebencian atau kekerasan';

  @override
  String get reasonImpersonation => 'Peniruan identitas';

  @override
  String get reasonOther => 'Lainnya';

  @override
  String get reportReceived =>
      'Laporan diterima dan dihapus dari layarmu. Kami akan meninjaunya dalam 24 jam.';

  @override
  String get reportNotSent =>
      'Laporanmu tidak terkirim. Periksa koneksimu dan coba lagi.';

  @override
  String reportTarget(String target) {
    return 'Laporkan $target';
  }

  @override
  String get reportPrivate =>
      'Mereka tidak akan tahu kamu melaporkannya. Pilih alasan:';

  @override
  String get reportDetails => 'Detail tambahan (opsional)';

  @override
  String get reportWhatHappened => 'Apa yang terjadi?';

  @override
  String get sendReport => 'Kirim laporan';

  @override
  String get alsoBlock =>
      'Blokir juga. Kalian akan hilang dari kota satu sama lain.';

  @override
  String get aYearAgo => 'Setahun lalu';

  @override
  String get aMonthAgo => 'Sebulan lalu';

  @override
  String get timeWhisperUnavailable =>
      'Surat untuk masa depan sedang tidak tersedia. Coba lagi nanti.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, kamu berkata di sini';
  }

  @override
  String writtenOn(String date) {
    return 'Ditulis $date';
  }

  @override
  String get timeWhisperOnce => 'Surat ini hanya muncul sekali.';

  @override
  String get keepInHeart => 'Simpan di hati';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Terbuka $unlock · ditulis $created';
  }

  @override
  String get unsealedGoBack =>
      'Sudah terbuka. Kembali ke sana untuk membukanya.';

  @override
  String unsealedDistance(String distance) {
    return 'Sudah terbuka · $distance darimu';
  }

  @override
  String get timeWhisperListLead =>
      'Surat untuk dirimu di masa depan yang hanya bisa kamu lihat. Saat waktunya tiba, datang dalam radius 100 m dari tempat itu untuk membukanya. Setelah dibaca, surat menghilang.';

  @override
  String get timeWhisperListEmpty =>
      'Belum ada surat untuk masa depan. Ketuk ikon catatan di bilah bawah dan pilih “Untuk diriku di masa depan”.';

  @override
  String get readyToOpen => 'Siap dibuka';

  @override
  String get sealed => 'Tersegel';

  @override
  String get delete => 'Hapus';

  @override
  String get within100m => 'Dalam 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Menunggu jawaban $name, sisa $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'Menunggu $name';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Ikuti ponsel';

  @override
  String get parallelUniverse => 'Semesta Paralel';

  @override
  String get parallelUniverseSubtitle =>
      'Lihat perasaan kota lain saat ini, dan biarkan mereka melihatmu';

  @override
  String get parallelUniverseIntroTitle => 'Masuk ke Semesta Paralel';

  @override
  String get parallelUniverseIntroBody =>
      'Saat aktif, semua orang yang sedang membuka aplikasi di kota pasanganmu muncul di radarmu, dan mereka semua bisa melihatmu. Kota di Taiwan dipasangkan dengan kota di luar negeri (seperti Tokyo, Seoul, dan Kuala Lumpur), dan kota di luar negeri dipasangkan dengan Taiwan.\n\nKedua kota disejajarkan di stasiun pusat masing-masing: seberapa jauh dan ke arah mana kamu dari stasiunmu, di situlah kamu muncul di kota mereka, dikaburkan sekitar 500 m, jadi tidak ada yang bisa melihat lokasi atau jarak aslimu. Kamu tetap bisa mengirim cahaya, mengetuk, dan mengobrol, dan bisa mematikannya kapan saja. Gema yang memudar, bisikan, dan acara tetap di tempat asalnya.';

  @override
  String get parallelUniverseEnter => 'Masuk';

  @override
  String get parallelUniverseNoCity => 'Belum ada Semesta Paralel di tempatmu';

  @override
  String parallelFrom(String city) {
    return 'Paralel · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'Orang ini ada di $city, tidak di dekatmu. Posisinya diproyeksikan dan bukan jarak sebenarnya.';
  }

  @override
  String get labelHost => 'Tuan rumah';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelResting => 'Istirahat';

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
  String get cityMacau => 'Makau';

  @override
  String get citySingapore => 'Singapura';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityHochiminh => 'Kota Ho Chi Minh';

  @override
  String get cityHanoi => 'Hanoi';

  @override
  String get translateTap => 'Ketuk untuk menerjemahkan';

  @override
  String get translateShowOriginal => 'Diterjemahkan · ketuk untuk teks asli';

  @override
  String get translating => 'Menerjemahkan…';

  @override
  String get translateFailed => 'Gagal menerjemahkan. Coba lagi nanti.';

  @override
  String get translateDownloadTitle => 'Unduh model terjemahan';

  @override
  String get translateDownloadBody =>
      'Menerjemahkan bahasa ini pertama kali memerlukan model terjemahan (sekitar 30 MB per bahasa, cukup sekali).\n\nTerjemahan dilakukan sepenuhnya di ponselmu; pesan tidak pernah diunggah.';

  @override
  String get translateDownload => 'Unduh';
}
