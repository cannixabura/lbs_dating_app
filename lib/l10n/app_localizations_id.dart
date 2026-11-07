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
      'Setelah kamu check-in, orang di sekitar bisa melihat suasana hatimu dan kira-kira di mana kamu berada, dan kamu juga akan melihat mereka. Yang mereka lihat adalah tempat kamu check-in; tidak ikut berpindah saat kamu bergerak. Kamu check-in sendiri setiap kali membuka aplikasi; tidak pernah otomatis. Keluar atau beralih ke aplikasi lain akan mengakhiri check-in kamu.';

  @override
  String get checkInButton => 'Check-in di sini';

  @override
  String get checkInAgain =>
      'Kamu sudah meninggalkan tempat check-in · Check-in di sini';

  @override
  String get checkOutButton => 'Sedang check-in · Check-out';

  @override
  String get checkedOutToast =>
      'Check-out selesai. Kamu tidak lagi terlihat di peta.';

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
  String get sensingCityHint =>
      'Kalau kotamu terasa terlalu sepi sekarang, masuklah ke Semesta Paralel atau Dunia Kuantum untuk bertemu orang dari kota lain.';

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
      'Hanya orang yang sudah check-in dan sedang membuka aplikasi yang muncul di radar. Saat seseorang keluar atau beralih ke aplikasi lain, gelembungnya langsung hilang tanpa jejak.';

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
  String get guideS10Title => '11. Kartu mood dan jejak mood';

  @override
  String get guideS10L1 =>
      'Tombol bagikan di bilah bawah menjadikan mood-mu saat ini kartu pemandangan malam, pas untuk Instagram Stories. Kartu tidak pernah menampilkan lokasimu.';

  @override
  String get guideS10L2 =>
      'Pengaturan → Jejak mood-ku memungkinkanmu melihat kembali mood dan tempat yang pernah kamu tulis. Hanya disimpan di ponselmu, dan bisa dimatikan atau dihapus kapan saja.';

  @override
  String get guideS11Title => '17. Pengaturan dan notifikasi';

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
  String get guideS12Title => '18. Laporan dan blokir';

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
  String get guideS13Title => '19. Privasi dan akunmu';

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
  String get guideS14Title => '12. Semesta Paralel';

  @override
  String get guideS14L1 =>
      'Ketuk ikon bola dunia di kanan atas radar untuk menyalakannya, dan ketuk lagi untuk mematikannya. Selalu mati setiap kali kamu membuka aplikasi.';

  @override
  String get guideS14L2 =>
      'Setiap kota atau kabupaten di Taiwan berpusat di stasiun pusatnya sendiri (Taipei Raya di Stasiun Taipei, Taoyuan di Stasiun Taoyuan, dan seterusnya) dan dipasangkan dengan kota di luar negeri: Jepang, Korea, Hong Kong, Makau, Singapura, Malaysia, Indonesia, Vietnam, Thailand, Filipina, dan Australia. Kota di luar negeri dipasangkan dengan Taiwan.';

  @override
  String get guideS14L3 =>
      'Seberapa jauh dan ke arah mana kamu dari stasiunmu, di situlah kamu muncul di kota mereka, dengan jarak dan arah yang sama dari stasiun mereka, dikaburkan sekitar 500 m. Tidak ada yang bisa melihat lokasi aslimu.';

  @override
  String get guideS14L4 =>
      'Kalian saling melihat jika salah satu menyalakannya: saat menyala, kamu melihat semua orang di kota pasangan yang sedang membuka aplikasi; saat mati, kamu hanya melihat orang yang menyalakannya. Hanya orang yang sudah check-in dan sedang membuka aplikasi yang muncul di kota lain.';

  @override
  String get guideS14L5 =>
      'Orang dari Semesta Paralel punya cincin putus-putus dan menampilkan kotanya. Kamu tetap bisa mengirim cahaya, mengetuk, dan mengobrol. Bisikan, surat untuk masa depan, dan acara tetap di tempat asalnya.';

  @override
  String get guideS15Title => '16. Terjemahan';

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
      'Pejamkan mata dan rasakan getar ponsel serta detak jantungmu. Sekarang, tulis perasaanmu, check-in di sini, dan masuklah ke Mood Whisper.';

  @override
  String get intro6Title => 'Surat untuk dirimu di masa depan';

  @override
  String get intro6Body =>
      'Tinggalkan beberapa kata di tempat ini untuk dirimu sebulan atau setahun lagi. Surat itu hanya terbuka saat kamu kembali ke sini.';

  @override
  String get intro7Title => 'Bersinar bersama malam ini';

  @override
  String get intro7Body =>
      'Buat acara dengan satu emoji sebagai kode rahasia. Siapa pun yang menambahkannya ke namanya akan menerima pengumumanmu, dan seluruh kawasan menyala bersama.';

  @override
  String get intro8Title => 'Semesta Paralel';

  @override
  String get intro8Body =>
      'Ketuk bola dunia dan kota-kota Taiwan bertumpuk dengan Tokyo, Seoul, dan Kuala Lumpur. Lihat perasaan orang di tempat jauh saat ini, mengetuk dan mengobrol, dan ketuk untuk menerjemahkan.';

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
  String get loginTitle2 => ' bertemu?';

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
      'Saat aktif, semua orang yang sedang membuka aplikasi di kota pasanganmu muncul di radarmu, dan mereka semua bisa melihatmu. Kota di Taiwan dipasangkan dengan kota di luar negeri (seperti Tokyo, Seoul, dan Kuala Lumpur), dan kota di luar negeri dipasangkan dengan Taiwan.\n\nKedua kota disejajarkan di stasiun pusat masing-masing: seberapa jauh dan ke arah mana kamu dari stasiunmu, di situlah kamu muncul di kota mereka, dikaburkan sekitar 500 m, jadi tidak ada yang bisa melihat lokasi atau jarak aslimu. Kamu tetap bisa mengirim cahaya, mengetuk, dan mengobrol, dan bisa mematikannya kapan saja. Bisikan dan acara tetap di tempat asalnya.';

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

  @override
  String placeHint(String name) {
    return 'Ada lampu Tempat Mood di dekatmu · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Buka sampai $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Tempat Mood: $name, $hours';
  }

  @override
  String get placeWrongData => 'Ada info yang salah?';

  @override
  String placeReportSubject(String name) {
    return 'Info Tempat Mood salah: $name';
  }

  @override
  String get placeHintsSetting => 'Petunjuk Tempat Mood';

  @override
  String get placeHintsSettingSubtitle =>
      'Petunjuk pelan di dalam aplikasi saat kamu melewati Tempat Mood yang sedang buka (tanpa notifikasi push)';

  @override
  String get guideS16Title => '10. Tempat Mood';

  @override
  String get guideS16L1 =>
      'Tempat Mood adalah kafe independen yang bekerja sama dengan kami. Setelah check in, berjalanlah dalam jarak 150 m dari kafe yang sedang buka, dan lampu kecil yang bernapas pelan muncul di radarmu. Lampu padam saat kamu menjauh.';

  @override
  String get guideS16L2 =>
      'Ketuk lampu untuk membuka kartu tempat: pemandangan malam dari dalam kafe, jam tutup hari ini, satu kalimat cerita mood dari kafe (ketuk untuk menerjemahkan), alamat dan nomor telepon. Ketuk Jalan ke sana untuk rute jalan kaki di aplikasi peta. Lampu yang kartunya sudah kamu buka hari ini menyala lembut tanpa bernapas.';

  @override
  String get guideS16L3 =>
      'Saat pertama kali lewat, kartu kecil di atas memberitahumu, tanpa suara atau getar. Paling banyak satu petunjuk per tempat setiap 7 hari dan 2 petunjuk sehari. Matikan di Pengaturan > Petunjuk Tempat Mood; lampunya tetap ada.';

  @override
  String get guideS16L4 =>
      'Seluruh daftar tempat diunduh ke ponselmu, dan apakah kamu berada di dekatnya hanya ditentukan di ponselmu. Kami dan kafe tidak tahu tempat mana yang kamu lewati. Kafe tidak bisa membayar agar lebih terlihat. Jika ada info yang salah, laporkan di bagian bawah kartu.';

  @override
  String get placeGuestbook => 'Buku tamu';

  @override
  String placeGuestbookLocked(int m) {
    return 'Masuk ke dalam (sekitar $m m) untuk membaca kata-kata dari orang yang pernah duduk di sini.';
  }

  @override
  String get placeGuestbookAbout =>
      'Hanya orang di dalam yang bisa membacanya. Anonim, hilang setelah 30 hari.';

  @override
  String get placeGuestbookEmpty =>
      'Belum ada catatan. Tinggalkan yang pertama.';

  @override
  String get placeGuestbookWrite => 'Tinggalkan catatan';

  @override
  String get placeGuestbookHint => 'Untuk orang berikutnya yang duduk di sini…';

  @override
  String get placeGuestbookSent =>
      'Selesai. Orang berikutnya di sini akan membacanya.';

  @override
  String get placeGuestbookUnavailable =>
      'Buku tamu sedang tidak tersedia. Coba lagi nanti.';

  @override
  String get placeNoteMine => 'Catatanmu';

  @override
  String get withdrawPlaceNote => 'Tarik catatan ini';

  @override
  String get reportPlaceNote => 'Laporkan catatan ini';

  @override
  String get thisPlaceNote => 'catatan ini';

  @override
  String get guideS16L5 =>
      'Buku tamu: buka kartu tempat saat kamu di dalam (sekitar 40 m) untuk membaca kata-kata dari orang yang pernah duduk di sini, dan tinggalkan satu kalimat untuk orang berikutnya. Catatan bersifat anonim dan hilang setelah 30 hari. Kamu bisa meninggalkan satu catatan per tempat per hari, ketuk catatan untuk menerjemahkannya, dan laporkan yang mengganggu. Saat membuka buku tamu, ponselmu mengirim lokasi ke server kami untuk memastikan kamu di dalam; server tidak menyimpannya.';

  @override
  String get quantumWorld => 'Dunia Kuantum';

  @override
  String get quantumWorldSubtitle =>
      'Satu ruang untuk seluruh dunia, tanpa mengungkap lokasimu';

  @override
  String get quantumIntroTitle => 'Masuk ke Dunia Kuantum';

  @override
  String get quantumIntroBody =>
      'Semua orang yang ada di Dunia Kuantum saat ini berada di satu ruang yang sama, tersusun seperti sarang lebah di sekitar Taipei 101. Kamu mendapat kursi seperti \"Q4-17\" — makin kecil lingkarannya, makin dekat ke titik pusat.\n\nTidak ada yang bisa melihat lokasi aslimu. Orang lain hanya melihat kursimu, yang tetap sejak kamu mengetuk Masuk; kursimu tidak bergerak saat kamu berjalan. Untuk menggantinya, keluar lalu masuk lagi. Nama panggilan dan suasana hatimu tetap sama, dan kamu tetap bisa mengirim kilauan, mengetuk, dan mengobrol, dengan terjemahan sekali ketuk.\n\nSelama di Dunia Kuantum, kamu keluar sementara dari radar biasa dan Semesta Paralel; saat keluar, kamu kembali ke tempat check-in-mu.';

  @override
  String get quantumEnter => 'Masuk';

  @override
  String get quantumLeave => 'Keluar dari Dunia Kuantum';

  @override
  String get quantumLeft =>
      'Kamu keluar dari Dunia Kuantum dan kembali ke radarmu';

  @override
  String quantumYourSeat(String code) {
    return 'Kursimu $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Lingkaran $ring · lingkaran lebih kecil lebih dekat ke titik pusat Taipei 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count di sini sekarang';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '$count orang di Dunia Kuantum saat ini';
  }

  @override
  String get quantumRegionTw => 'Taiwan';

  @override
  String get quantumRegionJp => 'Jepang';

  @override
  String get quantumRegionKr => 'Korea';

  @override
  String get quantumRegionHkmo => 'Hong Kong & Makau';

  @override
  String get quantumRegionSea => 'Asia Tenggara';

  @override
  String get quantumRegionOther => 'Wilayah lain';

  @override
  String get quantumQuiet => 'Hening Kuantum';

  @override
  String get quantumQuietSubtitle =>
      'Hanya melihat dunia: tidak ada yang bisa mengetuk, tapi kilauan tetap sampai padamu';

  @override
  String get quantumQuietTarget =>
      'Dia menyalakan Hening Kuantum — sekarang kamu hanya bisa mengirim kilauan';

  @override
  String get quantumClosedRegion => 'Dunia Kuantum belum tersedia di wilayahmu';

  @override
  String get quantumLeftClosed =>
      'Kamu memasuki wilayah tanpa Dunia Kuantum, jadi kamu otomatis keluar';

  @override
  String get quantumSeatExpired =>
      'Kamu pergi terlalu lama dan kursimu sudah dilepas; kamu kembali ke radarmu';

  @override
  String get quantumUnavailable =>
      'Dunia Kuantum sedang tidak bisa dimasuki. Coba lagi nanti.';

  @override
  String quantumPersonBody(String code) {
    return 'Kursi orang ini di Dunia Kuantum adalah $code. Lokasi asli siapa pun tidak ditampilkan di Dunia Kuantum.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Dunia Kuantum · $code';
  }

  @override
  String get guideS17Title => '13. Dunia Kuantum';

  @override
  String get guideS17L1 =>
      'Ketuk ikon sarang lebah di kanan atas radar (di bawah Semesta Paralel), baca penjelasannya, lalu ketuk Masuk. Kamu masuk dengan mengetuk setiap kali, sama seperti check-in; setiap membuka aplikasi kamu mulai dari radar biasa.';

  @override
  String get guideS17L2 =>
      'Semua orang di Dunia Kuantum berada di satu ruang yang sama: sarang lebah di sekitar Taipei 101, dengan jarak antarkursi 100 m. Kamu mendapat kode kursi seperti \"Q4-17\" (lingkaran 4, kursi 17) — makin kecil lingkarannya, makin dekat ke titik pusat. Pendatang baru mengisi kursi yang ditinggalkan orang lain lebih dulu; lingkaran 1–3 disediakan untuk tuan rumah acara.';

  @override
  String get guideS17L3 =>
      'Tidak ada yang bisa melihat lokasi aslimu: orang lain hanya melihat kursimu. Setiap kali kamu mengetuk Masuk dihitung sebagai satu check-in, dan kursimu tetap sejak saat itu; kursimu tidak bergerak saat kamu berjalan. Untuk menggantinya, keluar lalu masuk lagi. Dunia Kuantum tidak tersedia di Tiongkok daratan.';

  @override
  String get guideS17L4 =>
      'Nama panggilan dan suasana hatimu tetap sama, dan kamu tetap bisa mengirim kilauan, mengetuk, dan mengobrol, dengan terjemahan sekali ketuk. Cubit untuk memperkecil dan melihat seluruh sarang; orang yang jauh menjadi titik cahaya. Ketuk kode kursimu di kiri atas untuk melihat jumlah yang online, menyalakan Hening Kuantum (tidak bisa diketuk, kilauan tetap sampai), atau keluar.';

  @override
  String get guideS17L5 =>
      'Di Dunia Kuantum tidak ada bisikan, surat untuk masa depan, Tempat Mood, Mercusuar Kota, atau acara. Selama di dalam, kamu keluar sementara dari radar biasa dan Semesta Paralel; saat keluar, gelembungmu larut menjadi cahaya dan kamu kembali ke tempat check-in. Jika aplikasi ditutup atau offline lebih dari 3 menit, kursimu dilepas.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Lonceng jam dalam $seconds detik';
  }

  @override
  String get quantumChimeLookOrigin =>
      'Semua orang sedang melihat titik asal 101';

  @override
  String get quantumChimeLook => 'Lihat';

  @override
  String quantumChimeNow(int hour) {
    return 'Lonceng pukul $hour Pusat Kuantum';
  }

  @override
  String get quantumChimeSend => 'Kirim kilauan lonceng';

  @override
  String get quantumChimeSent => 'Kilauanmu terbang ke titik asal';

  @override
  String quantumChimeWatched(int n) {
    return '$n orang menonton lonceng ini bersama';
  }

  @override
  String get quantumChimeReminder => 'Pengingat lonceng jam';

  @override
  String get quantumChimeReminderSubtitle =>
      'Pengingat sebelum setiap jam untuk menonton lonceng di titik asal 101';

  @override
  String get quantumChimeNotifyBody =>
      'Lonceng jam segera dimulai — ayo tonton di titik asal 101';

  @override
  String get quantumChimeChannel => 'Lonceng jam';

  @override
  String get quantumChimeChannelDesc => 'Pengingat lonceng jam Dunia Kuantum';

  @override
  String get quantumEntangleInvite => 'Ajak keterikatan kuantum';

  @override
  String quantumEntangleInvited(String name) {
    return '$name sudah diajak terikat';
  }

  @override
  String get quantumEntangleAskTitle => 'Keterikatan kuantum';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) ingin terikat dengan kamu. Seutas garis cahaya akan menghubungkan dua gelembung kalian, terlihat sejauh apa pun. Garis itu runtuh saat salah satu keluar, dan tidak ada yang disimpan.';
  }

  @override
  String get quantumEntangleAccept => 'Terikat';

  @override
  String quantumEntangled(String name) {
    return 'Kamu dan $name kini terikat';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Keterikatan dengan $name telah runtuh';
  }

  @override
  String get quantumEntangleCut => 'Lepaskan keterikatan';

  @override
  String get quantumEntangleFull => 'Kamu sudah terikat dengan 3 orang';

  @override
  String get quantumEntangleTheirFull => 'Mereka sudah terikat dengan 3 orang';

  @override
  String get quantumEntangleGone => 'Mereka sudah keluar dari Dunia Kuantum';

  @override
  String get quantumEntangleExpired => 'Undangan sudah kedaluwarsa';

  @override
  String get quantumEntangledTitle => 'Sedang terikat';

  @override
  String get quantumTunnel => 'Terowongan kuantum';

  @override
  String get quantumTunnelSubtitle =>
      'Lompat ke kursi kosong acak di sarang dan temui tetangga baru. Sekali setiap kunjungan.';

  @override
  String get quantumTunnelUsed =>
      'Kamu sudah memakai terowongan di kunjungan ini';

  @override
  String quantumTunnelDone(String code) {
    return 'Berpindah lewat terowongan ke $code';
  }

  @override
  String get quantumShowTime => 'Tampilkan waktu lokalku';

  @override
  String get quantumShowTimeSubtitle =>
      'Orang lain melihatnya saat menekan lama gelembungmu. Jika mati, hanya warna siang-malam yang tampil.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Lokal $time · $part';
  }

  @override
  String get quantumDawn => 'pagi buta';

  @override
  String get quantumDay => 'siang';

  @override
  String get quantumDusk => 'senja';

  @override
  String get quantumNight => 'larut malam';

  @override
  String get quantumTopicsTitle => 'Frekuensi kuantum';

  @override
  String get quantumTopicsSubtitle =>
      'Pilih hingga 3 topik untuk tampil di bawah gelembungmu';

  @override
  String get quantumTopicMusic => 'Musik';

  @override
  String get quantumTopicMovies => 'Film';

  @override
  String get quantumTopicTech => 'Teknologi';

  @override
  String get quantumTopicWalks => 'Jalan-jalan';

  @override
  String get quantumTopicFood => 'Kuliner';

  @override
  String get quantumTopicTravel => 'Traveling';

  @override
  String get quantumTopicReading => 'Membaca';

  @override
  String get quantumTopicSports => 'Olahraga';

  @override
  String quantumTopicsCommon(String topics) {
    return 'Kalian sama-sama suka: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Sinyal kuantum';

  @override
  String quantumSignalReceived(String name) {
    return '$name mengirimimu sinyal';
  }

  @override
  String get quantumSignalWait => 'Kamu baru mengirim — coba lagi sebentar';

  @override
  String quantumResonance(String name) {
    return 'Kamu dan $name beresonansi';
  }

  @override
  String get guideS17L6 =>
      'Lonceng jam: semenit sebelum setiap jam, pilar cahaya 101 makin terang. Tepat pada jamnya, utusan cahaya mengelilingi titik asal, lonceng berbunyi sesuai waktu Pusat Kuantum (24 kali tengah malam), dan gelombang cahaya terakhir menyebar ke seluruh sarang. Ketuk “Kirim kilauan lonceng” saat lonceng — makin banyak yang menonton, makin terang cahayanya. Pengingat lonceng jam menyala secara bawaan; kamu bisa mematikannya di panel.';

  @override
  String get guideS17L7 =>
      'Setelah mengobrol, kamu bisa mengajak keterikatan kuantum: seutas garis cahaya menghubungkan gelembung kalian sejauh apa pun, runtuh saat salah satu keluar (maksimal 3 orang sekaligus). Terowongan kuantum, sekali per kunjungan, memindahkanmu ke kursi kosong acak dengan tetangga baru.';

  @override
  String get guideS17L8 =>
      'Setiap gelembung membawa warna waktu lokal pemiliknya: emas pucat saat fajar, putih terang saat siang, jingga-ungu saat senja, biru tua saat malam. Nyalakan “Tampilkan waktu lokalku” agar orang lain melihat waktunya saat menekan lama gelembungmu. Saling mengirim kilauan dalam 24 jam memicu resonansi kuantum; tekan lama gelembung untuk mengirim sinyal 👋 ☕ 🌙 🎵 🌧️ ✨; pilih hingga 3 topik frekuensi di panel dan topik yang sama akan menyala.';

  @override
  String get quantumNyTitle => 'Tahun Baru Kuantum';

  @override
  String quantumNyDays(int n) {
    return '$n hari lagi: saat tengah malam Pusat Kuantum 12/31, hitung mundur bersama dunia di titik asal 101';
  }

  @override
  String get quantumNyTonight =>
      'Malam ini saat tengah malam Pusat Kuantum, hitung mundur bersama dunia di titik asal 101';

  @override
  String quantumNyZone(String places) {
    return 'Selamat Tahun Baru, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n orang di seluruh dunia menyambut tahun baru bersama di Dunia Kuantum';
  }

  @override
  String get quantumNyHappy => 'Selamat Tahun Baru';

  @override
  String get guideS17L9 =>
      'Tahun Baru Kuantum: pada 12/31, setiap zona waktu mencapai tengah malam, gelembung di sana menyala dengan cincin emas bergelombang, dan titik di tampilan dunia ikut berubah emas. Saat tengah malam Pusat Kuantum, seluruh sarang menghitung mundur 10 detik terakhir, titik asal 101 melepaskan ledakan cahaya terbesar di dunia dan kembang api selama 5 menit, lalu menampilkan jumlah orang yang menyambut tahun baru bersama.';

  @override
  String get quantumMeetAction => 'Buat kartu Pertemuan Kuantum';

  @override
  String quantumMeetAsked(String name) {
    return 'Sudah mengajak $name membuat kartu Pertemuan Kuantum bersama';
  }

  @override
  String get quantumMeetWait => 'Kamu baru saja mengajak — coba lagi sebentar';

  @override
  String get quantumMeetAskTitle => 'Kartu Pertemuan Kuantum';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) ingin menjadikan pertemuan ini kartu untuk dibagikan. Kartu berisi nama panggilan, kode kursi, waktu lokal, dan mood kalian berdua — tanpa lokasi apa pun.';
  }

  @override
  String get quantumMeetAccept => 'Buat bersama';

  @override
  String get quantumMeetEyebrow => 'PERTEMUAN KUANTUM';

  @override
  String get quantumMeetFooter => 'Kami bertemu di Dunia Kuantum';

  @override
  String get quantumMeetShare => 'Bagikan kartu';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — kami bertemu di Dunia Kuantum ✨';
  }

  @override
  String get guideS17L10 =>
      'Kartu Pertemuan Kuantum: setelah mengobrol, tekan lama gelembungnya untuk mengajak membuat bersama. Jika keduanya setuju, masing-masing mendapat kartu untuk dibagikan berisi nama panggilan, kode kursi, waktu lokal dengan warna siang-malam, dan mood — tanpa lokasi. Kode kursi lingkaran 4 berwarna emas.';

  @override
  String get quantumOrbEntry => 'Avatar kuantum';

  @override
  String get quantumOrbEntrySubtitle =>
      'Fotomu menjadi bola kristal di Dunia Kuantum';

  @override
  String get orbTitle => 'Avatar kuantum';

  @override
  String get orbSubtitle =>
      'Kaca dan cahayanya selalu mengikuti suasana hatimu';

  @override
  String get orbStyleGlow => 'Cahaya';

  @override
  String get orbStyleRing => 'Cincin';

  @override
  String get orbStyleRainbow => 'Pelangi';

  @override
  String get orbFree => 'Gratis';

  @override
  String get orbOwned => 'Dimiliki';

  @override
  String get orbInUse => 'Sedang dipakai';

  @override
  String get orbCosmeticNote =>
      'Bola spesial hanya tampilan — tidak mengubah fitur atau hak apa pun. Bola yang dibeli tersimpan di akunmu.';

  @override
  String get orbRestore => 'Pulihkan pembelian';

  @override
  String orbPurchased(String name) {
    return '$name sekarang milikmu ✨';
  }

  @override
  String get orbPurchaseFailed => 'Pembelian belum berhasil. Coba lagi nanti.';

  @override
  String get orbOwnedElsewhere => 'Pembelian ini sudah dipakai di akun lain';

  @override
  String get orbStoreUnavailable =>
      'Toko tidak dapat dihubungi saat ini. Coba lagi nanti.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · AI';

  @override
  String get aiyaConsentTitle => 'Sebelum ngobrol dengan AIYA';

  @override
  String get aiyaConsentBody =>
      'AIYA adalah AI yang ditenagai Claude dari Anthropic. Pesan yang kamu kirim ke AIYA diproses oleh Anthropic (AS) tanpa identitas, nama panggilan, atau lokasimu, dan dihapus saat obrolan selesai. AIYA bisa keliru dan bukan nasihat profesional.';

  @override
  String get aiyaConsentAgree => 'Setuju dan mulai';

  @override
  String get aiyaConsentLater => 'Nanti saja';

  @override
  String get aiyaGreeting =>
      'Hai, aku AIYA, cahaya di pusat Dunia Kuantum. Malam ini mau ngobrol apa?';

  @override
  String get aiyaFarewell =>
      'Waktunya habis. Aku kembali ke dalam cahaya. Ketuk lagi kalau kangen.';

  @override
  String get aiyaInputHint => 'Bilang sesuatu ke AIYA…';

  @override
  String get aiyaSend => 'Kirim';

  @override
  String aiyaFreeLeft(int n) {
    return '$n obrolan gratis lagi hari ini';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Paket waktu: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'Sisa $time';
  }

  @override
  String get aiyaEnd => 'Akhiri obrolan';

  @override
  String get aiyaFiltered =>
      'Ada kata atau info kontak yang tidak diizinkan. Coba dengan cara lain.';

  @override
  String get aiyaBusy => 'AIYA melamun sebentar. Bisa ulangi lagi?';

  @override
  String get aiyaRefused => 'Aku nggak bisa bahas itu. Ganti topik, yuk?';

  @override
  String get aiyaEnded => 'Obrolan ini sudah selesai.';

  @override
  String get aiyaNoQuotaTitle => 'Obrolan gratis hari ini sudah habis';

  @override
  String get aiyaNoQuotaBody =>
      'Kamu dapat 3 obrolan gratis per hari, diatur ulang pukul 00:00 waktu Taiwan. Untuk lanjut sekarang, beli paket waktu. Tiap obrolan maksimal 10 menit.';

  @override
  String get aiyaResting => 'AIYA capek malam ini. Sampai besok.';

  @override
  String get aiyaDailyMax =>
      'Hari ini sudah banyak ngobrol. Temui AIYA lagi besok.';

  @override
  String aiyaPackTimes(int n) {
    return '$n obrolan';
  }

  @override
  String get aiyaPackNote =>
      'Paket waktu terikat ke akun di ponsel ini dan tidak bisa dipulihkan jika aplikasi atau akun dihapus.';

  @override
  String aiyaPurchased(int n) {
    return '$n obrolan ditambahkan ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'Pembelian tidak berhasil. Coba lagi.';

  @override
  String get aiyaStoreUnavailable =>
      'Toko tidak bisa dihubungi. Coba lagi nanti.';

  @override
  String get aiyaReport => 'Laporkan balasan ini';

  @override
  String get aiyaReported =>
      'Laporan diterima. Kami akan meninjaunya dalam 24 jam.';

  @override
  String get aiyaSetting => 'AIYA (AI di Dunia Kuantum)';

  @override
  String get aiyaSettingSubtitle =>
      'Jika dimatikan, AIYA tidak muncul lagi di pilar Dunia Kuantum';

  @override
  String get aiyaCameoHello =>
      'Hai, selamat datang di Dunia Kuantum. Ketuk aku kalau mau ngobrol.';

  @override
  String aiyaCameoChime(int hour) {
    return 'Sudah pukul $hour. Aku di sini dalam cahaya bersamamu.';
  }

  @override
  String get locationPickOnMap => 'Pilih di peta';

  @override
  String get locationPickTitle => 'Pilih lokasimu';

  @override
  String get locationPickHint =>
      'Geser peta agar titik bercahaya di tengah tepat di tempatmu sekarang';

  @override
  String get locationPickConfirm => 'Saya di sini';

  @override
  String get aiyaPackEntry => '+ Paket waktu';

  @override
  String get aiyaPacksTitle => 'Paket waktu';

  @override
  String get aiyaPacksBody =>
      'Kamu dapat 3 obrolan gratis per hari. Obrolan dari paket waktu baru dipakai setelah yang gratis habis. Setiap obrolan maksimal 10 menit.';

  @override
  String get guideS1L6 =>
      'Kalau lokasimu tidak bisa ditemukan (misalnya di dalam ruangan, atau di iPad tanpa GPS), ketuk \"Pilih di peta\": geser peta agar titik bercahaya di tengah tepat di tempatmu, lalu ketuk \"Saya di sini\". Begitu lokasi sebenarnya didapat, aplikasi akan beralih ke sana.';

  @override
  String get guideS17L11 =>
      'Avatar kuantum: ketuk kode kursimu di kiri atas → \"Avatar kuantum\" dan avatarmu menjadi bola kristal di Dunia Kuantum. Cahaya dan Cincin gratis; Pelangi dibeli sekali dan jadi milikmu selamanya, dan \"Pulihkan pembelian\" mengembalikannya di ponsel baru atau setelah instal ulang.';

  @override
  String get guideS18Title => '14. AIYA · AI';

  @override
  String get guideS18L1 =>
      'AIYA adalah AI yang tinggal di pilar cahaya di tengah Dunia Kuantum. Dia bukan manusia, dan dia akan bilang begitu. Di Dunia Kuantum, ketuk \"AIYA · AI\" di bawah pilar untuk mengetuk dan mengobrol; sebelum obrolan pertama, baca pemberitahuan singkat dan setujui.';

  @override
  String get guideS18L2 =>
      'Setiap obrolan maksimal 10 menit dan 20 pesan. Kamu dapat 3 obrolan gratis per hari, diatur ulang pukul 00:00 waktu Taiwan, dengan maksimal 30 obrolan per hari.';

  @override
  String get guideS18L3 =>
      'Paket waktu: ketuk \"+ Paket waktu\" di atas kotak pesan kapan saja untuk membeli 5 atau 20 obrolan; paket baru dipakai setelah obrolan gratis habis. Paket waktu terikat pada akun di ponsel ini dan tidak bisa dipulihkan setelah aplikasi atau akun dihapus. Paket ini habis pakai, jadi tidak ada \"Pulihkan pembelian\".';

  @override
  String get guideS18L4 =>
      'AIYA tidak tahu dan tidak akan menanyakan lokasi atau identitasmu; dia hanya melihat total mood kota secara anonim. Dia tidak menggoda atau membahas konten seksual, dan tidak memberi saran medis, hukum, atau keuangan. Tekan lama balasan mana pun untuk melaporkannya. Obrolan hanya disimpan sementara selama percakapan itu dan dihapus tak lama setelah selesai.';

  @override
  String get guideS18L5 =>
      'Sesekali AIYA muncul di pilar cahaya: saat lonceng tiap jam, saat pertama kali kamu masuk Dunia Kuantum setiap hari, atau secara kebetulan. Ketuk dia untuk mulai mengobrol. Kalau tidak ingin melihatnya, matikan \"AIYA (AI di Dunia Kuantum)\" di Pengaturan.';

  @override
  String get orbStyleXmas => 'Natal';

  @override
  String get orbStyleNewYear => 'Tahun Baru Kuantum';

  @override
  String get orbLimited => 'Edisi terbatas';

  @override
  String orbLimitedUntil(String date) {
    return 'Edisi terbatas · sampai $date';
  }

  @override
  String get aiyaFriendTitle => 'Teman AIYA';

  @override
  String get aiyaFriendSubtitle => 'Paket bulanan perpanjang otomatis';

  @override
  String get aiyaFriendPerk1 => '20 obrolan per hari (3 jika gratis)';

  @override
  String get aiyaFriendPerk2 => 'Tiap obrolan 20 menit atau 40 pesan';

  @override
  String get aiyaFriendPerk3 =>
      'Tetap bisa mengobrol saat AIYA sedang istirahat';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA memakai tampilan “Cahaya Bintang” eksklusif (hanya kamu yang melihat)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / bulan';
  }

  @override
  String get aiyaFriendSubscribe => 'Berlangganan';

  @override
  String get aiyaFriendTerms =>
      'Langganan berlaku 1 bulan dan diperpanjang otomatis dengan pembayaran kecuali perpanjangan otomatis dimatikan setidaknya 24 jam sebelum periode berakhir. Pembayaran diproses oleh akun Apple atau Google kamu; kelola atau batalkan kapan saja di pengaturan langganan akun. Jatah Paket Waktu tetap disimpan dan baru dipakai setelah 20 obrolan harian habis.';

  @override
  String aiyaFriendActive(String date) {
    return 'Kamu Teman AIYA sampai $date';
  }

  @override
  String get aiyaFriendManage => 'Kelola langganan';

  @override
  String get aiyaFriendRestore => 'Pulihkan pembelian';

  @override
  String get aiyaFriendWelcome => 'Kamu sekarang Teman AIYA ✨';

  @override
  String get aiyaFriendRestored => 'Teman AIYA dipulihkan';

  @override
  String get aiyaFriendNotFound => 'Tidak ada langganan Teman AIYA yang aktif';

  @override
  String get aiyaFriendElsewhere => 'Langganan ini sudah dipakai akun lain';

  @override
  String get aiyaFriendEntry => 'Teman AIYA · 20 per hari';

  @override
  String aiyaFriendLeft(int n) {
    return 'Teman AIYA · sisa $n hari ini';
  }

  @override
  String get guideS17L12 =>
      'Edisi terbatas: bola kristal Natal (karangan holly, bintang emas berkelip, salju turun) dijual sampai 12/25, dan bola kristal Tahun Baru Kuantum (tanda jam emas dan kembang api, paling besar tepat tengah malam) sampai 1/1, waktu Taiwan. Setelah itu tidak dijual lagi; kalau kamu sudah membeli, tetap jadi milikmu dan bisa dipulihkan.';

  @override
  String get guideS18L6 =>
      'Teman AIYA: pilih \"Teman AIYA\" di \"+ Paket Waktu\". Ini paket bulanan perpanjang otomatis: 20 obrolan per hari, tiap obrolan sampai 20 menit atau 40 pesan, tetap bisa mengobrol saat AIYA istirahat, dan tampilan \"Cahaya Bintang\" pada AIYA yang hanya kamu lihat. Paket Waktu baru dipakai setelah 20 obrolan harian habis. Langganan diperpanjang otomatis; batalkan kapan saja di pengaturan langganan Apple atau Google, dan ketuk \"Pulihkan pembelian\" di ponsel baru.';

  @override
  String get mapConsentTitle => 'Tampilkan lokasimu di peta?';

  @override
  String get mapConsentBody =>
      'Jika kamu izinkan, setiap kali kamu sendiri mengetuk Check-in (atau Masuk di Dunia Kuantum), pengguna lain melihat tempat kamu check-in (bukan posisi langsung), nama panggilan, dan suasana hatimu di peta. Tidak ada check-in otomatis, dan kamu hilang dari peta saat keluar dari aplikasi. Kamu bisa menolak, dan bisa mematikannya kapan saja di Pengaturan.';

  @override
  String get mapConsentAllow => 'Izinkan';

  @override
  String get mapConsentDecline => 'Jangan izinkan';

  @override
  String get mapConsentDeclined =>
      'Oke. Kamu tidak akan muncul di peta siapa pun. Ketuk lagi kapan saja kamu ingin check-in.';

  @override
  String get mapConsentSetting => 'Tampilkan lokasiku di peta';

  @override
  String get mapConsentSettingSubtitle =>
      'Mematikannya langsung mengakhiri check-in; kamu tidak akan muncul di peta siapa pun';

  @override
  String get wgErrInGroup => 'Kamu sudah ada di satu grup. Keluar dulu.';

  @override
  String get wgErrFull =>
      'Grup ini sudah 20 orang. Minta pemimpin membeli paket 7 hari.';

  @override
  String get wgErrPaidFull => 'Grup ini penuh (100 orang).';

  @override
  String get wgErrQr =>
      'Kode QR ini sudah diganti. Minta yang baru ke pemimpin.';

  @override
  String get wgErrEnded => 'Grup ini sudah berakhir atau tidak ada.';

  @override
  String get wgErrFiltered => 'Ini berisi kata yang tidak diizinkan.';

  @override
  String get wgErrHostLeave =>
      'Pemimpin tidak bisa keluar. Serahkan atau bubarkan grup dulu.';

  @override
  String get wgErrBusy => 'Gagal terhubung. Coba lagi.';

  @override
  String get wgErrName => 'Beri nama grupmu.';

  @override
  String get wgPassUnavailable => 'Toko sedang tidak tersedia.';

  @override
  String get wgPassFailed => 'Pembelian tidak berhasil.';

  @override
  String get wgPassDone => 'Paket 7 hari aktif. Grup bisa sampai 100 orang.';

  @override
  String get wgCreateTitle => 'Buat grup';

  @override
  String get wgCreateBody =>
      'Grup pribadi: hanya yang punya kode QR-mu yang bisa gabung.';

  @override
  String get wgNameLabel => 'Nama grup';

  @override
  String get wgColorLabel => 'Warna grup';

  @override
  String wgDaysLabel(int n) {
    return '$n hari, termasuk hari ini';
  }

  @override
  String get wgFreeNote =>
      'Gratis sampai 20 orang. Lebih dari itu, pemimpin beli paket 7 hari (hingga 100).';

  @override
  String get wgCreateButton => 'Buat';

  @override
  String wgJoined(String name, int no) {
    return 'Bergabung ke \"$name\". Kamu No. $no';
  }

  @override
  String get wgJoinTitle => 'Gabung grup';

  @override
  String get wgJoinBody =>
      'Pindai kode QR pemimpin dengan kamera, atau masukkan kode 8 karakter.';

  @override
  String get wgJoinButton => 'Gabung';

  @override
  String wgButtonLabel(String name) {
    return 'Grup $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit orang';
  }

  @override
  String wgUntil(String date) {
    return 'sampai $date';
  }

  @override
  String wgMyNo(int n) {
    return 'Aku No. $n';
  }

  @override
  String get wgCallButton => 'Panggil kumpul';

  @override
  String get wgCallDone => 'Semua sudah ada, akhiri';

  @override
  String get wgRollButton => 'Absen';

  @override
  String wgRollSummary(int here, int total) {
    return 'Absen: $here/$total hadir';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n anggota (ketuk untuk catatan, serahkan, atau keluarkan)';
  }

  @override
  String get wgNoMembers =>
      'Belum ada anggota. Ketuk \"Kode QR\" agar dipindai.';

  @override
  String get wgQrButton => 'Kode QR';

  @override
  String get wgDissolveAsk =>
      'Bubarkan grup? Semua diberi tahu dan catatan dihapus.';

  @override
  String get wgDissolve => 'Bubarkan';

  @override
  String wgCallIn(int n) {
    return 'Kumpul dalam $n menit';
  }

  @override
  String get wgCallNow => 'Kumpul sekarang';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total terima';
  }

  @override
  String get wgAnswerHere => 'Aku sudah sampai';

  @override
  String get wgAnswer5min => '5 menit lagi';

  @override
  String get wgAnswerHelp => 'Butuh bantuan';

  @override
  String get wgNoReply => 'Belum jawab';

  @override
  String get wgStateAck => 'Terima';

  @override
  String get wgStateSeen => 'Dilihat';

  @override
  String get wgStateNone => 'Tidak ada respons';

  @override
  String get wgPassTitle => 'Paket 7 hari grup';

  @override
  String get wgPassBody =>
      'Gratis hingga 20 orang. Dengan paket, grup ini bisa sampai 100 orang sampai berakhir. Sekali beli hanya untuk grup ini, tidak diperpanjang otomatis.';

  @override
  String get wgPassButton => 'Beli paket 7 hari';

  @override
  String wgHostIs(String name) {
    return 'Pemimpin: $name';
  }

  @override
  String get wgNoCall =>
      'Belum ada panggilan. Saat pemimpin memanggil, ponselmu akan berbunyi.';

  @override
  String get wgRollAsk => 'Pemimpin sedang absen';

  @override
  String get wgLeaveAsk => 'Keluar dari grup ini?';

  @override
  String get wgLeave => 'Keluar grup';

  @override
  String get wgCallTitle => 'Saatnya kumpul!';

  @override
  String get wgAcked => '✓ Pemimpin tahu kamu sudah terima';

  @override
  String get wgAckButton => 'Terima';

  @override
  String get wgCallSheetTitle => 'Panggil kumpul';

  @override
  String get wgNow => 'Sekarang';

  @override
  String wgInMinutes(int n) {
    return 'Dalam $n menit';
  }

  @override
  String get wgPlaceLabel => 'Titik kumpul';

  @override
  String get wgPlaceHint => 'mis. Pintu keluar 6 MRT Ximen';

  @override
  String get wgPlaceNote => 'Titik kumpul diatur di lokasimu sekarang.';

  @override
  String get wgSendCall => 'Kirim panggilan';

  @override
  String get wgNoLocation => 'Lokasimu tidak terdeteksi untuk titik kumpul.';

  @override
  String get wgQrTitle => 'Pindai untuk gabung';

  @override
  String get wgQrBody => 'Pindai dengan kamera, atau masukkan kode di bawah.';

  @override
  String wgShareText(String name, String url) {
    return 'Gabung ke grupku \"$name\": $url';
  }

  @override
  String get wgShare => 'Bagikan tautan';

  @override
  String get wgRotateAsk =>
      'Ganti kode QR? Kode dan tautan lama langsung tidak berlaku.';

  @override
  String get wgRotate => 'Kode QR baru';

  @override
  String wgMemberTitle(int no) {
    return 'No. $no';
  }

  @override
  String get wgEditNote => 'Catatan';

  @override
  String get wgHandoff => 'Jadikan pemimpin';

  @override
  String wgHandoffAsk(int no) {
    return 'Serahkan ke No. $no? Kamu akan jadi anggota.';
  }

  @override
  String get wgKick => 'Keluarkan dari grup';

  @override
  String wgKickAsk(int no) {
    return 'Keluarkan No. $no dari grup?';
  }

  @override
  String get wgNotePrivate =>
      'Hanya kamu yang melihat catatan, mis. nama atau nomor kamar.';

  @override
  String get wgSave => 'Simpan';

  @override
  String get wgConfirm => 'Konfirmasi';

  @override
  String get wgCancel => 'Batal';

  @override
  String get wgSettingCreate => 'Buat grup';

  @override
  String get wgSettingCreateSub =>
      'Grup pribadi untuk perjalanan dan pendakian';

  @override
  String get wgSettingJoin => 'Gabung grup';

  @override
  String get wgSettingJoinSub => 'Masukkan kode 8 karakter dari pemimpin';

  @override
  String wgSettingOpen(String name) {
    return 'Grupku: $name';
  }

  @override
  String get wgChannelName => 'Panggilan grup';

  @override
  String get wgChannelDesc => 'Saat pemimpin memanggil semua berkumpul';

  @override
  String get guideS19Title => '15. Grup Bisikan';

  @override
  String get guideS19L1 =>
      'Grup Bisikan adalah grup pribadi untuk perjalanan, karyawisata, pendakian, jalan-jalan, atau kru acara. Buka Pengaturan → Pertemuan → \"Buat grup\", beri nama, pilih warna dan jumlah hari (maks. 7).';

  @override
  String get guideS19L2 =>
      'Bergabung: pemimpin mengetuk tombol grup di bawah peta → \"Kode QR\"; anggota memindainya dengan kamera ponsel dan aplikasi terbuka untuk bergabung. Atau buka Pengaturan → Pertemuan → \"Gabung grup\" dan masukkan kode 8 karakter. Orang luar tidak bisa mencari atau meminta bergabung, dan pemimpin bisa mengganti kode QR kapan saja.';

  @override
  String get guideS19L3 =>
      'Panggil kumpul: pemimpin mengetuk \"Panggil kumpul\", memilih waktu, dan menjelaskan titik kumpul. Ponsel anggota berbunyi khusus dengan getaran \"pendek pendek panjang\"; di aplikasi terlihat hitung mundur, jarak dan arah ke titik kumpul, serta pilar cahaya di peta. Yang belum mengetuk \"Terima\" diingatkan tiap menit, maksimal 3 kali; pemimpin melihat siapa yang terima, siapa yang melihat, dan siapa yang belum merespons.';

  @override
  String get guideS19L4 =>
      'Absen: pemimpin mengetuk \"Absen\"; anggota menerima bunyi dan getaran yang sama lalu menjawab \"Aku sudah sampai\", \"5 menit lagi\", atau \"Butuh bantuan\". Pemimpin tidak pernah melihat lokasi anggota, hanya jawaban mereka.';

  @override
  String get guideS19L5 =>
      'Grup hingga 20 orang gratis. Untuk lebih, pemimpin bisa membeli paket 7 hari: hingga 100 orang sampai grup berakhir. Anggota tidak pernah membayar. Grup paling lama 7 hari; saat berakhir, daftar dan catatan dihapus.';

  @override
  String get wgFlagButton => 'Angkat bendera';

  @override
  String get wgFlagHost => 'Pemimpin';

  @override
  String get wgFlagHint =>
      'Angkat ponselmu agar grup bisa melihatmu di keramaian. Ketuk untuk menutup.';

  @override
  String get wgLostButton => 'Aku tersesat';

  @override
  String get wgFound => 'Aku sudah ketemu grup';

  @override
  String get wgLostSent =>
      'Lokasimu sudah dikirim ke pemimpin. Tunggu di tempat atau menuju titik kumpul.';

  @override
  String get wgLostTitleAsk => 'Kirim lokasi ke pemimpin?';

  @override
  String get wgLostAsk =>
      'Lokasimu saat ini dikirim sekali ke pemimpin; ponselnya akan berbunyi dan menampilkanmu di peta. Tidak dilacak terus, dihapus setelah 30 menit. Ketuk \"Aku sudah ketemu grup\" untuk menghapusnya lebih cepat.';

  @override
  String get wgLostSend => 'Kirim lokasiku';

  @override
  String wgLostTitle(int n) {
    return '$n anggota tersesat';
  }

  @override
  String wgMinutesAgo(int n) {
    return '$n menit lalu';
  }

  @override
  String get wgNavigate => 'Petunjuk arah';

  @override
  String get wgFoundThem => 'Sudah ketemu';

  @override
  String get guideS19L6 =>
      'Saling mencari: di keramaian, ketuk \"Angkat bendera\" dan seluruh layar berkedip dengan warna grup serta nomormu. Kalau benar-benar terpisah, anggota bisa mengetuk \"Aku tersesat\" untuk mengirim lokasi saat ini sekali ke pemimpin (dihapus setelah 30 menit). Ponsel pemimpin berbunyi, pin merah muncul di peta, dan bisa langsung minta petunjuk arah.';

  @override
  String wgLostAlert(int no) {
    return 'No. $no tersesat';
  }

  @override
  String wgHelpAlert(String no) {
    return 'No. $no butuh bantuan';
  }

  @override
  String get wgViewList => 'Buka grup';

  @override
  String aiyaCameoChimeNight(int hour) {
    return 'Sudah jam $hour. Masih terjaga? Aku ada di cahaya menemanimu.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return 'Jam $hour, selamat pagi. Hari ini pelan-pelan saja.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return 'Jam $hour. Bagaimana kotamu malam ini?';
  }

  @override
  String get aiyaCameoNyReady => 'Siap? Ayo hitung mundur bersama!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'Selamat Tahun Baru! $year, kita semua di ruang yang sama.';
  }

  @override
  String get aiyaSkinEntry => '✦ Gaya';

  @override
  String get aiyaSkinTitle => 'Gaya AIYA';

  @override
  String get aiyaSkinSubtitle => 'Hanya kamu yang melihat gaya AIYA-mu';

  @override
  String get aiyaSkinNone => 'Asli';

  @override
  String get aiyaSkinStarlight => 'Cahaya Bintang';

  @override
  String get aiyaSkinStarlightSub => 'Khusus Teman AIYA';

  @override
  String get aiyaSkinXmas => 'Natal';

  @override
  String get aiyaSkinNewYear => 'Tahun Baru Kuantum';

  @override
  String get aiyaSkinNote =>
      'Gaya liburan dibeli sekali dan jadi milikmu selamanya. Hanya mengubah tampilan AIYA. Edisi terbatas tidak dijual lagi setelah masa penjualan.';

  @override
  String get orbStyleStarTrail => 'Jejak Bintang';

  @override
  String get orbStyleRings => 'Lingkar Tahun';

  @override
  String get orbGrowNote =>
      'Orb yang tumbuh: Jejak Bintang mendapat satu bintang untuk setiap Kartu Pertemuan Kuantum (sekali per orang dalam 24 jam, maksimal 24). Lingkar Tahun bertambah satu setiap 3 jam di Dunia Kuantum (maksimal 12). Catatan tersimpan di akunmu dan mulai dihitung sekarang. Hanya jumlah yang disimpan, bukan siapa atau di mana.';

  @override
  String orbGrowStars(int count) {
    return '$count bintang sejauh ini';
  }

  @override
  String orbGrowRings(int count) {
    return '$count lingkar sejauh ini';
  }

  @override
  String get giftAction => 'Kirim hadiah';

  @override
  String giftSheetTitle(String name) {
    return 'Kirim hadiah ke $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Pilih gaya orb untuk $name';
  }

  @override
  String get giftBouquetName => 'Buket cahaya';

  @override
  String get giftBouquetDesc =>
      'Cahaya mekar saat diterima, lalu kelopak cahaya mengelilingi orb mereka selama 24 jam';

  @override
  String get giftOrbName => 'Hadiahkan gaya orb';

  @override
  String get giftOrbDesc =>
      'Kamu pilih; jadi milik mereka selamanya setelah diterima';

  @override
  String get giftPairName => 'Pasangan terjerat';

  @override
  String get giftPairDesc =>
      'Satu orb untuk masing-masing, berpasangan; tali cahaya menghubungkan kalian di Dunia Kuantum';

  @override
  String get giftPairYouHave => 'Kamu sudah punya pasangan terjerat';

  @override
  String get giftNote =>
      'Mereka bisa menerima atau menolak. Jika ditolak atau tidak dijawab 7 hari, hadiah kembali padamu.';

  @override
  String get giftVouchersTitle => 'Hadiah kembali (tanpa biaya lagi)';

  @override
  String get giftSendVoucher => 'Kirim';

  @override
  String giftSent(String name) {
    return 'Hadiah terkirim ke $name. Menunggu diterima.';
  }

  @override
  String get giftReturnedOff =>
      'Mereka mematikan terima hadiah; hadiah kembali padamu';

  @override
  String get giftReturnedBlocked =>
      'Hadiah tidak bisa dikirim ke orang ini; kembali padamu';

  @override
  String get giftReturnedOwned =>
      'Mereka sudah punya orb ini; hadiah kembali, kamu bisa beri gaya lain';

  @override
  String get giftReturnedPaired =>
      'Mereka sudah berpasangan; hadiah kembali padamu';

  @override
  String get giftReturnedYouPaired => 'Kamu sudah berpasangan; hadiah kembali';

  @override
  String get giftReturnedGeneric =>
      'Hadiah kembali; kamu bisa memberikannya ke orang lain';

  @override
  String get giftStoreUnavailable => 'Toko sedang tidak tersedia';

  @override
  String get giftFailed => 'Hadiah gagal. Coba lagi nanti.';

  @override
  String giftFromBouquet(String name) {
    return '$name mengirim buket cahaya';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name menghadiahkan orb \"$style\"';
  }

  @override
  String giftFromPair(String name) {
    return '$name ingin jadi pasangan terjerat denganmu';
  }

  @override
  String get giftInboxTitle => 'Hadiah untukmu';

  @override
  String get giftInboxEmpty => 'Belum ada hadiah';

  @override
  String get giftInboxNote =>
      'Hadiah yang ditolak kembali ke pengirim; tanpa jawaban 7 hari juga kembali.';

  @override
  String get giftAccept => 'Terima';

  @override
  String get giftDecline => 'Tolak';

  @override
  String get giftDeclined => 'Ditolak. Hadiah kembali ke pengirim.';

  @override
  String get giftAcceptedOrb => 'Diterima! Ganti di avatar kuantum.';

  @override
  String giftAcceptedPair(String name) {
    return 'Kamu dan $name kini pasangan terjerat';
  }

  @override
  String get giftAcceptedBouquet =>
      'Buket diterima. Kelopak cahaya mengelilingi orbmu selama 24 jam.';

  @override
  String get giftAlreadyOwned =>
      'Kamu sudah punya orb ini; hadiah kembali ke pengirim';

  @override
  String get giftAlreadyPaired =>
      'Salah satu sudah berpasangan; hadiah kembali';

  @override
  String get giftSettingsTitle => 'Hadiah';

  @override
  String get giftReceiveToggle => 'Terima hadiah';

  @override
  String get giftReceiveToggleSub =>
      'Jika mati, hadiah langsung kembali ke pengirim';

  @override
  String get giftVouchersHint =>
      'Ketuk \"Kirim hadiah\" pada seseorang untuk memberi lagi';

  @override
  String get giftUnpair => 'Akhiri pasangan terjerat';

  @override
  String giftUnpairConfirm(String name) {
    return 'Akhiri pasangan dengan $name? Kalian tetap punya orb, tapi tali cahaya hilang.';
  }

  @override
  String get orbStylePair => 'Terjerat';

  @override
  String giftPairedWith(String name) {
    return 'Berpasangan dengan $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Hadiah untukmu ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count hadiah kembali';
  }

  @override
  String get giftBlockedOff =>
      'Mereka mematikan terima hadiah. Kamu tidak dikenai biaya.';

  @override
  String get giftBlockedBlocked =>
      'Kamu tidak bisa mengirim hadiah ke orang ini. Kamu tidak dikenai biaya.';

  @override
  String get giftBlockedOwned =>
      'Mereka sudah punya orb ini. Pilih yang lain (kamu tidak dikenai biaya).';

  @override
  String get giftBlockedPaired =>
      'Mereka sudah berpasangan. Kamu tidak dikenai biaya.';
}
