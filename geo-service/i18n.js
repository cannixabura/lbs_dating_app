// ============================================================================
// 伺服器回給使用者的文字（錯誤訊息、推播、示範對象的話）翻成使用者的語言。
// 程式裡照舊寫繁體中文；送出前用 localize(lang, text) 換成對應語言。
// 範本裡的 {名稱} 是變數：先從繁中原文抓出值，再填進目標語言的範本（值本身也會再翻一次，例如「一年前」）。
// 找不到範本的文字（使用者自己寫的公告、聊天內容）原樣送出。
// ============================================================================

const LANGS = ['zh-Hant', 'zh-Hans', 'en', 'ja', 'ko', 'ms', 'id', 'vi'];
const DEFAULT_LANG = 'zh-Hant';

// [繁中, 簡中, 英, 日, 韓, 馬來, 印尼, 越南]
const TABLE = [
    // ---- 一般錯誤 ----
    ['未授權', '未授权', 'Not signed in.', 'ログインしていません。', '로그인되어 있지 않아요.', 'Belum log masuk.', 'Belum masuk.', 'Chưa đăng nhập.'],
    ['座標格式錯誤', '坐标格式错误', 'Invalid location.', '位置情報の形式が正しくありません。', '위치 형식이 올바르지 않아요.', 'Lokasi tidak sah.', 'Lokasi tidak valid.', 'Vị trí không hợp lệ.'],
    ['更新失敗', '更新失败', "Couldn't update. Please try again.", '更新できませんでした。もう一度お試しください。', '업데이트하지 못했어요. 다시 시도해 주세요.', 'Tidak dapat dikemas kini. Sila cuba lagi.', 'Gagal diperbarui. Coba lagi.', 'Không cập nhật được. Vui lòng thử lại.'],
    ['掃描失敗', '扫描失败', "Couldn't scan the city. Please try again.", '街をスキャンできませんでした。もう一度お試しください。', '도시를 살펴보지 못했어요. 다시 시도해 주세요.', 'Tidak dapat mengimbas bandar. Sila cuba lagi.', 'Gagal memindai kota. Coba lagi.', 'Không quét được thành phố. Vui lòng thử lại.'],
    ['刪除失敗', '删除失败', "Couldn't delete. Please try again.", '削除できませんでした。もう一度お試しください。', '삭제하지 못했어요. 다시 시도해 주세요.', 'Tidak dapat dipadam. Sila cuba lagi.', 'Gagal dihapus. Coba lagi.', 'Không xóa được. Vui lòng thử lại.'],
    ['未知的操作', '未知的操作', 'Unknown action.', '不明な操作です。', '알 수 없는 작업이에요.', 'Tindakan tidak diketahui.', 'Tindakan tidak dikenal.', 'Thao tác không xác định.'],
    ['內容包含不適當的字詞或聯絡方式，請修改後再送出。', '内容包含不适当的字词或联系方式，请修改后再送出。', 'This contains offensive words or contact details. Please edit it and try again.', '不適切な言葉や連絡先が含まれています。修正してから送信してください。', '부적절한 말이나 연락처가 들어 있어요. 고친 뒤 다시 보내 주세요.', 'Ini mengandungi kata-kata kesat atau butiran hubungan. Sila ubah dan cuba lagi.', 'Ini berisi kata kasar atau info kontak. Ubah dulu lalu kirim lagi.', 'Nội dung có từ ngữ không phù hợp hoặc thông tin liên lạc. Hãy sửa rồi gửi lại.'],

    // ---- 低語 ----
    ['你的帳號正在審查中，暫時無法留下低語。', '你的账号正在审查中，暂时无法留下低语。', "Your account is under review, so you can't leave whispers for now.", 'アカウントを審査中のため、今はささやきを残せません。', '계정을 검토하고 있어서 지금은 속삭임을 남길 수 없어요.', 'Akaun anda sedang disemak, jadi anda tidak boleh meninggalkan bisikan buat masa ini.', 'Akunmu sedang ditinjau, jadi untuk sementara kamu tidak bisa meninggalkan bisikan.', 'Tài khoản của bạn đang được xem xét nên tạm thời chưa thể để lại lời thì thầm.'],
    ['你已經在城市裡留下 {n} 則低語了，等其中一則消散再留吧。', '你已经在城市里留下 {n} 则低语了，等其中一则消散再留吧。', "You already have {n} whispers in the city. Wait for one to fade before leaving another.", 'すでに街に {n} 件のささやきを残しています。どれかが消えてから残してください。', '이미 도시에 속삭임 {n}개를 남겼어요. 하나가 사라진 뒤에 남겨 주세요.', 'Anda sudah ada {n} bisikan di bandar. Tunggu satu pudar dahulu.', 'Kamu sudah punya {n} bisikan di kota. Tunggu salah satunya memudar dulu.', 'Bạn đã có {n} lời thì thầm trong thành phố. Hãy chờ một lời tan đi rồi để lại tiếp.'],
    ['只能收回自己的低語。', '只能收回自己的低语。', 'You can only take back your own whispers.', '取り消せるのは自分のささやきだけです。', '내 속삭임만 거둘 수 있어요.', 'Anda hanya boleh menarik balik bisikan sendiri.', 'Kamu hanya bisa menarik bisikanmu sendiri.', 'Bạn chỉ thu hồi được lời thì thầm của mình.'],
    ['低語暫時無法使用，請稍後再試。', '低语暂时无法使用，请稍后再试。', "Whispers aren't available right now. Please try again later.", 'ささやきは現在使えません。しばらくしてからお試しください。', '지금은 속삭임을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.', 'Bisikan tidak tersedia sekarang. Sila cuba lagi nanti.', 'Bisikan sedang tidak tersedia. Coba lagi nanti.', 'Lời thì thầm hiện chưa dùng được. Vui lòng thử lại sau.'],
    ['低語不能是空白的。', '低语不能是空白的。', "Your whisper can't be empty.", 'ささやきが空です。', '속삭임이 비어 있어요.', 'Bisikan tidak boleh kosong.', 'Bisikan tidak boleh kosong.', 'Lời thì thầm không được để trống.'],
    ['低語最多 {n} 個字。', '低语最多 {n} 个字。', 'Whispers can be up to {n} characters.', 'ささやきは {n} 文字までです。', '속삭임은 최대 {n}자예요.', 'Bisikan maksimum {n} aksara.', 'Bisikan maksimal {n} karakter.', 'Lời thì thầm tối đa {n} ký tự.'],
    ['這則低語含有不適合的字詞，換個說法吧。', '这则低语含有不适合的字词，换个说法吧。', 'This whisper has words that aren\'t allowed. Try saying it another way.', 'このささやきには不適切な言葉が含まれています。言い方を変えてみてください。', '이 속삭임에 부적절한 말이 있어요. 다르게 표현해 보세요.', 'Bisikan ini mengandungi kata-kata yang tidak dibenarkan. Cuba cara lain.', 'Bisikan ini berisi kata yang tidak diizinkan. Coba ungkapkan dengan cara lain.', 'Lời thì thầm này có từ ngữ không phù hợp. Hãy thử nói cách khác.'],
    ['低語是匿名的，不能留下電話、網址或社群帳號。', '低语是匿名的，不能留下电话、网址或社交账号。', "Whispers are anonymous, so phone numbers, links and social accounts aren't allowed.", 'ささやきは匿名です。電話番号、URL、SNS アカウントは残せません。', '속삭임은 익명이라 전화번호, 링크, SNS 계정은 남길 수 없어요.', 'Bisikan adalah tanpa nama, jadi nombor telefon, pautan dan akaun media sosial tidak dibenarkan.', 'Bisikan itu anonim, jadi nomor telepon, tautan, dan akun media sosial tidak diizinkan.', 'Lời thì thầm là ẩn danh, không được để lại số điện thoại, đường link hay tài khoản mạng xã hội.'],

    // ---- 店內留言本 ----
    ['留言不能是空白的。', '留言不能是空白的。', "Your note can't be empty.", 'ノートが空です。', '메모가 비어 있어요.', 'Nota tidak boleh kosong.', 'Catatan tidak boleh kosong.', 'Lời nhắn không được để trống.'],
    ['留言最多 {n} 個字。', '留言最多 {n} 个字。', 'Notes can be up to {n} characters.', 'ノートは {n} 文字までです。', '메모는 최대 {n}자예요.', 'Nota maksimum {n} aksara.', 'Catatan maksimal {n} karakter.', 'Lời nhắn tối đa {n} ký tự.'],
    ['這則留言含有不適合的字詞，換個說法吧。', '这则留言含有不适合的字词，换个说法吧。', "This note has words that aren't allowed. Try saying it another way.", 'このノートには不適切な言葉が含まれています。言い方を変えてみてください。', '이 메모에 부적절한 말이 있어요. 다르게 표현해 보세요.', 'Nota ini mengandungi kata-kata yang tidak dibenarkan. Cuba cara lain.', 'Catatan ini berisi kata yang tidak diizinkan. Coba ungkapkan dengan cara lain.', 'Lời nhắn này có từ ngữ không phù hợp. Hãy thử nói cách khác.'],
    ['留言是匿名的，不能留下電話、網址或社群帳號。', '留言是匿名的，不能留下电话、网址或社交账号。', "Notes are anonymous, so phone numbers, links and social accounts aren't allowed.", 'ノートは匿名です。電話番号、URL、SNS アカウントは残せません。', '메모는 익명이라 전화번호, 링크, SNS 계정은 남길 수 없어요.', 'Nota adalah tanpa nama, jadi nombor telefon, pautan dan akaun media sosial tidak dibenarkan.', 'Catatan itu anonim, jadi nomor telepon, tautan, dan akun media sosial tidak diizinkan.', 'Lời nhắn là ẩn danh, không được để lại số điện thoại, đường link hay tài khoản mạng xã hội.'],
    ['找不到這家店。', '找不到这家店。', "Couldn't find this place.", 'このお店が見つかりません。', '이 가게를 찾을 수 없어요.', 'Tempat ini tidak dijumpai.', 'Tempat ini tidak ditemukan.', 'Không tìm thấy quán này.'],
    ['走進店裡（約 {m} 公尺內）才讀得到留言本。', '走进店里（约 {m} 米内）才读得到留言本。', 'Step inside (within about {m} m) to read the guestbook.', 'お店の中（約 {m} m 以内）に入ると店内ノートが読めます。', '가게 안(약 {m}m 이내)에 들어가야 방명록을 읽을 수 있어요.', 'Masuk ke dalam (dalam lingkungan kira-kira {m} m) untuk membaca buku pelawat.', 'Masuk ke dalam (sekitar {m} m) untuk membaca buku tamu.', 'Hãy vào trong quán (trong khoảng {m} m) để đọc sổ lưu bút.'],
    ['你的帳號正在審查中，暫時無法留言。', '你的账号正在审查中，暂时无法留言。', "Your account is under review, so you can't leave notes for now.", 'アカウントを審査中のため、今はノートを残せません。', '계정을 검토하고 있어서 지금은 메모를 남길 수 없어요.', 'Akaun anda sedang disemak, jadi anda tidak boleh meninggalkan nota buat masa ini.', 'Akunmu sedang ditinjau, jadi untuk sementara kamu tidak bisa meninggalkan catatan.', 'Tài khoản của bạn đang được xem xét nên tạm thời chưa thể để lại lời nhắn.'],
    ['你今天已經在這家店留過一句了，明天再來吧。', '你今天已经在这家店留过一句了，明天再来吧。', "You've already left a note here today. Come back tomorrow.", '今日はもうこのお店にノートを残しました。また明日どうぞ。', '오늘은 이미 이 가게에 메모를 남겼어요. 내일 다시 와 주세요.', 'Anda sudah meninggalkan nota di sini hari ini. Datang lagi esok.', 'Kamu sudah meninggalkan catatan di sini hari ini. Datang lagi besok.', 'Hôm nay bạn đã để lại lời nhắn ở đây rồi. Ngày mai quay lại nhé.'],
    ['只能收回自己的留言。', '只能收回自己的留言。', 'You can only take back your own notes.', '取り消せるのは自分のノートだけです。', '내 메모만 거둘 수 있어요.', 'Anda hanya boleh menarik balik nota sendiri.', 'Kamu hanya bisa menarik catatanmu sendiri.', 'Bạn chỉ thu hồi được lời nhắn của mình.'],
    ['留言本暫時無法使用，請稍後再試。', '留言本暂时无法使用，请稍后再试。', "The guestbook isn't available right now. Please try again later.", '店内ノートは現在使えません。しばらくしてからお試しください。', '지금은 방명록을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.', 'Buku pelawat tidak tersedia sekarang. Sila cuba lagi nanti.', 'Buku tamu sedang tidak tersedia. Coba lagi nanti.', 'Sổ lưu bút hiện chưa dùng được. Vui lòng thử lại sau.'],

    // ---- 低語穿越 ----
    ['請選一個月後或一年後。', '请选一个月后或一年后。', 'Choose one month or one year.', '1 か月後か 1 年後を選んでください。', '한 달 뒤나 1년 뒤를 골라 주세요.', 'Pilih sebulan atau setahun.', 'Pilih sebulan atau setahun.', 'Hãy chọn một tháng hoặc một năm.'],
    ['你已經有 {n} 封還沒打開的低語穿越了，先讀完一封再寫吧。', '你已经有 {n} 封还没打开的低语穿越了，先读完一封再写吧。', 'You already have {n} unopened letters to the future. Read one before writing another.', '未開封の未来への手紙がすでに {n} 通あります。1 通読んでから書いてください。', '아직 열지 않은 미래로 보내는 편지가 {n}통 있어요. 하나를 읽고 나서 써 주세요.', 'Anda sudah ada {n} surat ke masa depan yang belum dibuka. Baca satu dahulu.', 'Kamu sudah punya {n} surat untuk masa depan yang belum dibuka. Baca satu dulu.', 'Bạn đã có {n} thư gửi tương lai chưa mở. Hãy đọc một lá trước khi viết thêm.'],
    ['低語穿越暫時無法使用，請稍後再試。', '低语穿越暂时无法使用，请稍后再试。', "Letters to the future aren't available right now. Please try again later.", '未来への手紙は現在使えません。しばらくしてからお試しください。', '지금은 미래로 보내는 편지를 이용할 수 없어요. 잠시 후 다시 시도해 주세요.', 'Surat ke masa depan tidak tersedia sekarang. Sila cuba lagi nanti.', 'Surat untuk masa depan sedang tidak tersedia. Coba lagi nanti.', 'Thư gửi tương lai hiện chưa dùng được. Vui lòng thử lại sau.'],
    ['寫一句話給未來的自己。', '写一句话给未来的自己。', 'Write something to your future self.', '未来の自分にひとこと書いてください。', '미래의 나에게 한마디 써 주세요.', 'Tulis sesuatu untuk diri anda pada masa depan.', 'Tulis sesuatu untuk dirimu di masa depan.', 'Hãy viết một câu cho chính mình trong tương lai.'],
    ['最多 {n} 個字。', '最多 {n} 个字。', 'Up to {n} characters.', '{n} 文字までです。', '최대 {n}자예요.', 'Maksimum {n} aksara.', 'Maksimal {n} karakter.', 'Tối đa {n} ký tự.'],
    ['找不到這封低語穿越。', '找不到这封低语穿越。', "Couldn't find this letter.", 'この手紙が見つかりません。', '이 편지를 찾을 수 없어요.', 'Surat ini tidak dijumpai.', 'Surat ini tidak ditemukan.', 'Không tìm thấy lá thư này.'],
    ['還沒到時間，再等等。', '还没到时间，再等等。', "It's not time yet. Wait a little longer.", 'まだその時ではありません。もう少し待ってください。', '아직 때가 아니에요. 조금만 더 기다려 주세요.', 'Belum tiba masanya. Tunggu sedikit lagi.', 'Belum waktunya. Tunggu sebentar lagi.', 'Chưa đến lúc. Hãy chờ thêm chút nữa.'],
    ['回到那裡 {m} 公尺內就能打開。', '回到那里 {m} 米内就能打开。', 'Go back within {m} m of the spot to open it.', 'その場所の {m} m 以内に戻ると開けられます。', '그곳 {m}m 안으로 돌아가면 열 수 있어요.', 'Kembali dalam lingkungan {m} m dari tempat itu untuk membukanya.', 'Kembali dalam radius {m} m dari tempat itu untuk membukanya.', 'Quay lại trong bán kính {m} m của nơi đó để mở.'],

    // ---- 集會 ----
    ['你的帳號正在審查中，暫時無法主持活動。', '你的账号正在审查中，暂时无法主持活动。', "Your account is under review, so you can't host gatherings for now.", 'アカウントを審査中のため、今は集いを主催できません。', '계정을 검토하고 있어서 지금은 모임을 열 수 없어요.', 'Akaun anda sedang disemak, jadi anda tidak boleh menganjurkan perhimpunan buat masa ini.', 'Akunmu sedang ditinjau, jadi untuk sementara kamu tidak bisa mengadakan acara.', 'Tài khoản của bạn đang được xem xét nên tạm thời chưa thể tổ chức tụ họp.'],
    ['附近已經有人用 {emoji} 開了活動，等它結束或換一個圖標吧。', '附近已经有人用 {emoji} 开了活动，等它结束或换一个图标吧。', 'Someone nearby is already using {emoji} for a gathering. Wait for it to end or pick another icon.', '近くですでに {emoji} を使った集いが開かれています。終わるのを待つか、別のアイコンを選んでください。', '근처에서 이미 {emoji}로 모임을 열었어요. 끝날 때까지 기다리거나 다른 아이콘을 골라 주세요.', 'Seseorang berdekatan sudah menggunakan {emoji} untuk perhimpunan. Tunggu ia tamat atau pilih ikon lain.', 'Seseorang di dekatmu sudah memakai {emoji} untuk acara. Tunggu sampai selesai atau pilih ikon lain.', 'Gần đây đã có người dùng {emoji} cho buổi tụ họp. Hãy chờ kết thúc hoặc chọn biểu tượng khác.'],
    ['這場活動已經結束或換了主持人。', '这场活动已经结束或换了主持人。', 'This gathering has ended or has a new host.', 'この集いは終了したか、主催者が変わりました。', '이 모임은 끝났거나 진행자가 바뀌었어요.', 'Perhimpunan ini telah tamat atau ada penganjur baharu.', 'Acara ini sudah selesai atau penyelenggaranya sudah berganti.', 'Buổi tụ họp này đã kết thúc hoặc đã đổi người tổ chức.'],
    ['找不到這場活動。', '找不到这场活动。', "Couldn't find this gathering.", 'この集いが見つかりません。', '이 모임을 찾을 수 없어요.', 'Perhimpunan ini tidak dijumpai.', 'Acara ini tidak ditemukan.', 'Không tìm thấy buổi tụ họp này.'],
    ['這場活動已經結束了。', '这场活动已经结束了。', 'This gathering has ended.', 'この集いは終了しました。', '이 모임은 끝났어요.', 'Perhimpunan ini telah tamat.', 'Acara ini sudah selesai.', 'Buổi tụ họp này đã kết thúc.'],
    ['只有主持人可以結束活動。', '只有主持人可以结束活动。', 'Only the host can end the gathering.', '集いを終了できるのは主催者だけです。', '진행자만 모임을 끝낼 수 있어요.', 'Hanya penganjur boleh menamatkan perhimpunan.', 'Hanya penyelenggara yang bisa mengakhiri acara.', 'Chỉ người tổ chức mới kết thúc được buổi tụ họp.'],
    ['活動沒有結束成功，請再試一次。', '活动没有结束成功，请再试一次。', "The gathering didn't end. Please try again.", '集いを終了できませんでした。もう一度お試しください。', '모임을 끝내지 못했어요. 다시 시도해 주세요.', 'Perhimpunan tidak dapat ditamatkan. Sila cuba lagi.', 'Acara gagal diakhiri. Coba lagi.', 'Chưa kết thúc được buổi tụ họp. Vui lòng thử lại.'],
    ['只有主持人可以轉移活動。', '只有主持人可以转移活动。', 'Only the host can hand over the gathering.', '集いを引き継げるのは主催者だけです。', '진행자만 모임을 넘길 수 있어요.', 'Hanya penganjur boleh menyerahkan perhimpunan.', 'Hanya penyelenggara yang bisa menyerahkan acara.', 'Chỉ người tổ chức mới trao lại được buổi tụ họp.'],
    ['無法把活動交給這位使用者。', '无法把活动交给这位用户。', "You can't hand the gathering to this person.", 'この人には集いを引き継げません。', '이 사람에게는 모임을 넘길 수 없어요.', 'Anda tidak boleh menyerahkan perhimpunan kepada orang ini.', 'Kamu tidak bisa menyerahkan acara ke orang ini.', 'Không thể trao buổi tụ họp cho người này.'],
    ['只有主持人可以取消。', '只有主持人可以取消。', 'Only the host can cancel.', '取り消せるのは主催者だけです。', '진행자만 취소할 수 있어요.', 'Hanya penganjur boleh membatalkan.', 'Hanya penyelenggara yang bisa membatalkan.', 'Chỉ người tổ chức mới hủy được.'],
    ['只有主持人可以發公告。', '只有主持人可以发公告。', 'Only the host can post announcements.', 'お知らせを投稿できるのは主催者だけです。', '진행자만 공지를 올릴 수 있어요.', 'Hanya penganjur boleh menyiarkan pengumuman.', 'Hanya penyelenggara yang bisa mengirim pengumuman.', 'Chỉ người tổ chức mới đăng được thông báo.'],
    ['只有主持人可以提問。', '只有主持人可以提问。', 'Only the host can ask questions.', '質問できるのは主催者だけです。', '진행자만 질문할 수 있어요.', 'Hanya penganjur boleh bertanya.', 'Hanya penyelenggara yang bisa bertanya.', 'Chỉ người tổ chức mới đặt câu hỏi được.'],
    ['這個問題已經換了。', '这个问题已经换了。', 'This question has changed.', 'この質問はすでに変わりました。', '질문이 바뀌었어요.', 'Soalan ini telah bertukar.', 'Pertanyaan ini sudah diganti.', 'Câu hỏi này đã được thay.'],
    ['把 {emoji} 加進你的城市稱呼，就能參加這場活動。', '把 {emoji} 加进你的城市昵称，就能参加这场活动。', 'Add {emoji} to your city name to join this gathering.', '呼び名に {emoji} を加えると、この集いに参加できます。', '닉네임에 {emoji}를 넣으면 이 모임에 참가할 수 있어요.', 'Tambahkan {emoji} pada nama panggilan anda untuk menyertai perhimpunan ini.', 'Tambahkan {emoji} ke nama panggilanmu untuk ikut acara ini.', 'Thêm {emoji} vào biệt danh để tham gia buổi tụ họp này.'],
    ['你離活動有點遠，靠近一點再回答吧。', '你离活动有点远，靠近一点再回答吧。', "You're a bit far from the gathering. Come closer to answer.", '集いから少し離れています。近づいてから答えてください。', '모임에서 조금 멀어요. 가까이 와서 답해 주세요.', 'Anda agak jauh dari perhimpunan. Datang lebih dekat untuk menjawab.', 'Kamu agak jauh dari acara. Mendekatlah untuk menjawab.', 'Bạn hơi xa buổi tụ họp. Hãy lại gần hơn để trả lời.'],
    ['活動功能暫時無法使用，請稍後再試。', '活动功能暂时无法使用，请稍后再试。', "Gatherings aren't available right now. Please try again later.", '集いは現在使えません。しばらくしてからお試しください。', '지금은 모임을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.', 'Perhimpunan tidak tersedia sekarang. Sila cuba lagi nanti.', 'Acara sedang tidak tersedia. Coba lagi nanti.', 'Tụ họp hiện chưa dùng được. Vui lòng thử lại sau.'],
    ['活動圖標要剛好是一個表情符號。', '活动图标要刚好是一个表情符号。', 'The gathering icon must be exactly one emoji.', 'アイコンは絵文字ひとつだけにしてください。', '아이콘은 이모지 하나여야 해요.', 'Ikon perhimpunan mesti tepat satu emoji.', 'Ikon acara harus tepat satu emoji.', 'Biểu tượng phải là đúng một emoji.'],
    ['請幫活動取個名字。', '请帮活动取个名字。', 'Please give your gathering a name.', '集いに名前をつけてください。', '모임 이름을 정해 주세요.', 'Sila beri nama untuk perhimpunan anda.', 'Beri nama untuk acaramu.', 'Hãy đặt tên cho buổi tụ họp.'],
    ['活動名稱最多 {n} 個字。', '活动名称最多 {n} 个字。', 'Gathering names can be up to {n} characters.', '集いの名前は {n} 文字までです。', '모임 이름은 최대 {n}자예요.', 'Nama perhimpunan maksimum {n} aksara.', 'Nama acara maksimal {n} karakter.', 'Tên buổi tụ họp tối đa {n} ký tự.'],
    ['公告不能是空白的。', '公告不能是空白的。', "The announcement can't be empty.", 'お知らせが空です。', '공지가 비어 있어요.', 'Pengumuman tidak boleh kosong.', 'Pengumuman tidak boleh kosong.', 'Thông báo không được để trống.'],
    ['公告最多 {n} 個字。', '公告最多 {n} 个字。', 'Announcements can be up to {n} characters.', 'お知らせは {n} 文字までです。', '공지는 최대 {n}자예요.', 'Pengumuman maksimum {n} aksara.', 'Pengumuman maksimal {n} karakter.', 'Thông báo tối đa {n} ký tự.'],
    ['問題不能是空白的。', '问题不能是空白的。', "The question can't be empty.", '質問が空です。', '질문이 비어 있어요.', 'Soalan tidak boleh kosong.', 'Pertanyaan tidak boleh kosong.', 'Câu hỏi không được để trống.'],
    ['問題最多 {n} 個字。', '问题最多 {n} 个字。', 'Questions can be up to {n} characters.', '質問は {n} 文字までです。', '질문은 최대 {n}자예요.', 'Soalan maksimum {n} aksara.', 'Pertanyaan maksimal {n} karakter.', 'Câu hỏi tối đa {n} ký tự.'],
    ['寫一句此刻的心情再送出。', '写一句此刻的心情再送出。', 'Write how you feel right now, then send.', '今の気持ちをひとこと書いてから送信してください。', '지금 기분을 한마디 쓰고 보내 주세요.', 'Tulis perasaan anda sekarang, kemudian hantar.', 'Tulis perasaanmu sekarang, lalu kirim.', 'Hãy viết cảm xúc lúc này rồi gửi.'],
    ['回答最多 {n} 個字。', '回答最多 {n} 个字。', 'Answers can be up to {n} characters.', '回答は {n} 文字までです。', '답은 최대 {n}자예요.', 'Jawapan maksimum {n} aksara.', 'Jawaban maksimal {n} karakter.', 'Câu trả lời tối đa {n} ký tự.'],
    ['請設定開始與結束時間。', '请设置开始与结束时间。', 'Set a start and end time.', '開始と終了の時刻を設定してください。', '시작과 종료 시간을 정해 주세요.', 'Tetapkan masa mula dan tamat.', 'Atur waktu mulai dan selesai.', 'Hãy đặt giờ bắt đầu và kết thúc.'],
    ['開始時間不能早於現在。', '开始时间不能早于现在。', "The start time can't be in the past.", '開始時刻を過去にすることはできません。', '시작 시간은 지금보다 이를 수 없어요.', 'Masa mula tidak boleh pada masa lalu.', 'Waktu mulai tidak boleh di masa lalu.', 'Giờ bắt đầu không được sớm hơn hiện tại.'],
    ['開始時間要在 24 小時內。', '开始时间要在 24 小时内。', 'The start time must be within 24 hours.', '開始時刻は 24 時間以内にしてください。', '시작 시간은 24시간 안이어야 해요.', 'Masa mula mesti dalam 24 jam.', 'Waktu mulai harus dalam 24 jam.', 'Giờ bắt đầu phải trong vòng 24 giờ.'],
    ['結束時間要晚於開始時間。', '结束时间要晚于开始时间。', 'The end time must be after the start time.', '終了時刻は開始時刻より後にしてください。', '종료 시간은 시작 시간보다 늦어야 해요.', 'Masa tamat mesti selepas masa mula.', 'Waktu selesai harus setelah waktu mulai.', 'Giờ kết thúc phải sau giờ bắt đầu.'],
    ['活動最長 24 小時。', '活动最长 24 小时。', 'A gathering can last up to 24 hours.', '集いは最長 24 時間です。', '모임은 최대 24시간이에요.', 'Perhimpunan paling lama 24 jam.', 'Acara paling lama 24 jam.', 'Buổi tụ họp kéo dài tối đa 24 giờ.'],
    ['這位使用者目前無法接下主持。', '这位用户目前无法接下主持。', "This person can't take over hosting right now.", 'この人は今、主催を引き継げません。', '이 사람은 지금 진행을 맡을 수 없어요.', 'Orang ini tidak boleh mengambil alih penganjuran sekarang.', 'Orang ini tidak bisa mengambil alih sekarang.', 'Người này hiện không thể nhận tổ chức.'],
    ['對方還沒加入這場活動（稱呼裡沒有 {emoji}）。', '对方还没加入这场活动（昵称里没有 {emoji}）。', "They haven't joined this gathering yet (no {emoji} in their name).", '相手はまだこの集いに参加していません（呼び名に {emoji} がありません）。', '상대가 아직 이 모임에 참가하지 않았어요 (닉네임에 {emoji}가 없어요).', 'Mereka belum menyertai perhimpunan ini (tiada {emoji} pada nama mereka).', 'Mereka belum ikut acara ini (tidak ada {emoji} di namanya).', 'Họ chưa tham gia buổi tụ họp này (biệt danh không có {emoji}).'],
    ['對方不在活動範圍 5 公里內。', '对方不在活动范围 5 公里内。', "They're not within the gathering's 5 km area.", '相手は集いの範囲 5 km 以内にいません。', '상대가 모임 범위 5km 안에 없어요.', 'Mereka tiada dalam kawasan 5 km perhimpunan.', 'Mereka tidak berada dalam area 5 km acara.', 'Họ không ở trong phạm vi 5 km của buổi tụ họp.'],
    ['對方正在主持另一場活動。', '对方正在主持另一场活动。', "They're hosting another gathering.", '相手は別の集いを主催中です。', '상대가 다른 모임을 진행하고 있어요.', 'Mereka sedang menganjurkan perhimpunan lain.', 'Mereka sedang menyelenggarakan acara lain.', 'Họ đang tổ chức một buổi tụ họp khác.'],

    // ---- 城市燈塔 ----
    ['回報格式錯誤', '回报格式错误', 'Invalid report.', '報告の形式が正しくありません。', '신고 형식이 올바르지 않아요.', 'Laporan tidak sah.', 'Laporan tidak valid.', 'Báo cáo không hợp lệ.'],
    ['找不到這個地點', '找不到这个地点', "Couldn't find this place.", 'この場所が見つかりません。', '이 장소를 찾을 수 없어요.', 'Tempat ini tidak dijumpai.', 'Tempat ini tidak ditemukan.', 'Không tìm thấy địa điểm này.'],
    ['城市燈塔暫時無法使用，請稍後再試。', '城市灯塔暂时无法使用，请稍后再试。', "City Beacon isn't available right now. Please try again later.", 'シティ・ビーコンは現在使えません。しばらくしてからお試しください。', '지금은 시티 비컨을 이용할 수 없어요. 잠시 후 다시 시도해 주세요.', 'Suar Bandar tidak tersedia sekarang. Sila cuba lagi nanti.', 'Mercusuar Kota sedang tidak tersedia. Coba lagi nanti.', 'Hải đăng thành phố hiện chưa dùng được. Vui lòng thử lại sau.'],

    // ---- 推播 ----
    ['城市低語', '城市低语', 'Mood Whisper', 'Mood Whisper', 'Mood Whisper', 'Mood Whisper', 'Mood Whisper', 'Mood Whisper'],
    ['片刻交集', '片刻交集', "A moment's crossing", 'ひとときの交差', '잠깐의 교차', 'Pertemuan seketika', 'Persilangan sesaat', 'Khoảnh khắc giao nhau'],
    ['{name} 正在敲門，想與你產生交集...', '{name} 正在敲门，想与你产生交集...', '{name} is knocking, hoping your paths will cross...', '{name} がノックしています。あなたと道を交えたいようです…', '{name}님이 노크하고 있어요. 당신과 길이 겹치길 바라며…', '{name} sedang mengetuk, berharap laluan anda bersilang...', '{name} sedang mengetuk, berharap jalan kalian bersilangan...', '{name} đang gõ cửa, mong được gặp bạn...'],
    ['來自 {name} 的低語', '来自 {name} 的低语', 'A whisper from {name}', '{name} からのささやき', '{name}님의 속삭임', 'Bisikan daripada {name}', 'Bisikan dari {name}', 'Lời thì thầm từ {name}'],
    ['有人在附近，與你的心情共鳴了。', '有人在附近，与你的心情共鸣了。', 'Someone nearby resonated with your mood.', '近くの誰かが、あなたのムードに共鳴しました。', '근처의 누군가가 당신의 무드에 공명했어요.', 'Seseorang berdekatan bergema dengan mood anda.', 'Seseorang di dekatmu beresonansi dengan mood-mu.', 'Có người gần đây đồng cảm với tâm trạng của bạn.'],
    ['對方婉拒了接下主持。', '对方婉拒了接下主持。', 'They declined to take over hosting.', '相手は主催の引き継ぎを断りました。', '상대가 진행 맡기를 거절했어요.', 'Mereka menolak untuk mengambil alih penganjuran.', 'Mereka menolak mengambil alih acara.', 'Họ đã từ chối nhận tổ chức.'],
    ['主持人想把這場活動交給你主持，打開 App 回覆。', '主持人想把这场活动交给你主持，打开 App 回复。', 'The host would like you to take over this gathering. Open the app to reply.', '主催者がこの集いをあなたに任せたいそうです。アプリを開いて返事をしてください。', '진행자가 이 모임을 맡아 달래요. 앱을 열고 답해 주세요.', 'Penganjur ingin anda mengambil alih perhimpunan ini. Buka app untuk menjawab.', 'Penyelenggara ingin kamu mengambil alih acara ini. Buka aplikasi untuk menjawab.', 'Người tổ chức muốn bạn nhận buổi tụ họp này. Mở ứng dụng để trả lời.'],
    ['主持人問：{q}', '主持人问：{q}', 'The host asks: {q}', '主催者からの質問：{q}', '진행자의 질문: {q}', 'Penganjur bertanya: {q}', 'Penyelenggara bertanya: {q}', 'Người tổ chức hỏi: {q}'],
    ['對方接下了主持，你回到了城市裡。', '对方接下了主持，你回到了城市里。', "They've taken over hosting. You're back in the city.", '相手が主催を引き継ぎました。あなたは街に戻りました。', '상대가 진행을 맡았어요. 다시 도시로 돌아왔어요.', 'Mereka telah mengambil alih penganjuran. Anda kembali ke bandar.', 'Mereka sudah mengambil alih. Kamu kembali ke kota.', 'Họ đã nhận tổ chức. Bạn đã trở lại thành phố.'],
    ['主持人已交棒，活動繼續進行。', '主持人已交棒，活动继续进行。', 'There\'s a new host. The gathering carries on.', '主催が交代しました。集いは続きます。', '진행자가 바뀌었어요. 모임은 계속돼요.', 'Ada penganjur baharu. Perhimpunan diteruskan.', 'Ada penyelenggara baru. Acara tetap berlanjut.', 'Đã có người tổ chức mới. Buổi tụ họp vẫn tiếp tục.'],
    ['活動結束了，謝謝你今晚一起在這裡。', '活动结束了，谢谢你今晚一起在这里。', 'The gathering has ended. Thank you for being here tonight.', '集いは終わりました。今夜一緒にいてくれてありがとう。', '모임이 끝났어요. 오늘 밤 함께해 줘서 고마워요.', 'Perhimpunan telah tamat. Terima kasih kerana bersama malam ini.', 'Acara sudah selesai. Terima kasih sudah hadir malam ini.', 'Buổi tụ họp đã kết thúc. Cảm ơn bạn đã ở đây đêm nay.'],
    ['活動時間到了，謝謝你今晚一起在這裡。', '活动时间到了，谢谢你今晚一起在这里。', "The gathering's time is up. Thank you for being here tonight.", '集いの時間になりました。今夜一緒にいてくれてありがとう。', '모임 시간이 끝났어요. 오늘 밤 함께해 줘서 고마워요.', 'Masa perhimpunan sudah tamat. Terima kasih kerana bersama malam ini.', 'Waktu acara sudah habis. Terima kasih sudah hadir malam ini.', 'Đã hết giờ tụ họp. Cảm ơn bạn đã ở đây đêm nay.'],
    ['主持人已離開，活動結束。', '主持人已离开，活动结束。', 'The host has left, so the gathering has ended.', '主催者が退出したため、集いは終了しました。', '진행자가 떠나서 모임이 끝났어요.', 'Penganjur telah pergi, jadi perhimpunan tamat.', 'Penyelenggara sudah pergi, jadi acara selesai.', 'Người tổ chức đã rời đi nên buổi tụ họp kết thúc.'],
    ['低語穿越', '低语穿越', 'Letter to the future', '未来への手紙', '미래로 보내는 편지', 'Surat ke masa depan', 'Surat untuk masa depan', 'Thư gửi tương lai'],
    ['{ago}的你，在某個地方留下了一句話。回到那裡，就能讀到。', '{ago}的你，在某个地方留下了一句话。回到那里，就能读到。', '{ago}, you left a few words somewhere. Go back there to read them.', '{ago}のあなたが、どこかにひとこと残しました。そこに戻ると読めます。', '{ago}의 당신이 어딘가에 한마디를 남겼어요. 그곳에 돌아가면 읽을 수 있어요.', '{ago}, anda meninggalkan beberapa kata di suatu tempat. Kembali ke sana untuk membacanya.', '{ago}, kamu meninggalkan beberapa kata di suatu tempat. Kembali ke sana untuk membacanya.', '{ago}, bạn đã để lại vài lời ở một nơi. Quay lại đó để đọc.'],
    ['一年前', '一年前', 'A year ago', '1 年前', '1년 전', 'Setahun lalu', 'Setahun lalu', 'Một năm trước'],
    ['一個月前', '一个月前', 'A month ago', '1 か月前', '한 달 전', 'Sebulan lalu', 'Sebulan lalu', 'Một tháng trước'],

    // ---- 示範對象 ----
    ['示範對象 {n}', '示范对象 {n}', 'Demo {n}', 'デモ {n}', '데모 {n}', 'Demo {n}', 'Demo {n}', 'Mẫu {n}'],
    ['導覽員 {n}', '导览员 {n}', 'Guide {n}', 'ガイド {n}', '가이드 {n}', 'Pemandu {n}', 'Pemandu {n}', 'Hướng dẫn viên {n}'],
    ['示範對象', '示范对象', 'Demo', 'デモ', '데모', 'Demo', 'Demo', 'Mẫu'],
    ['嗨！我是示範對象，由程式自動回覆，不是真人 🌙 讓我帶你認識城市低語。', '嗨！我是示范对象，由程序自动回复，不是真人 🌙 让我带你认识城市低语。', "Hi! I'm a demo person. My replies are automatic, I'm not real 🌙 Let me show you around Mood Whisper.", 'こんにちは！デモ用の相手で、自動で返信しています。実在の人ではありません 🌙 Mood Whisper を案内しますね。', '안녕하세요! 저는 자동으로 답하는 데모 상대예요. 실제 사람이 아니에요 🌙 Mood Whisper를 안내해 드릴게요.', 'Hai! Saya orang demo yang membalas secara automatik, bukan orang sebenar 🌙 Mari saya tunjukkan Mood Whisper.', 'Hai! Aku orang demo yang membalas otomatis, bukan orang sungguhan 🌙 Yuk aku kenalkan Mood Whisper.', 'Chào bạn! Mình là người mẫu, trả lời tự động, không phải người thật 🌙 Để mình giới thiệu Mood Whisper nhé.'],
    ['在這裡，每段交集只有 10 分鐘。只要有人說話，倒數就會重新開始。', '在这里，每段交集只有 10 分钟。只要有人说话，倒数就会重新开始。', 'Here, each conversation lasts only 10 minutes. Whenever someone speaks, the countdown starts over.', 'ここでは、ひとつの会話は 10 分だけ。誰かが話すたびにカウントダウンがリセットされます。', '여기서는 대화마다 10분뿐이에요. 누군가 말할 때마다 카운트다운이 다시 시작돼요.', 'Di sini, setiap perbualan hanya 10 minit. Setiap kali seseorang bercakap, kiraan detik bermula semula.', 'Di sini, setiap obrolan hanya 10 menit. Setiap kali ada yang bicara, hitung mundur dimulai lagi.', 'Ở đây, mỗi cuộc trò chuyện chỉ kéo dài 10 phút. Mỗi khi có người nói, đồng hồ đếm ngược lại từ đầu.'],
    ['如果遇到讓你不舒服的人，右上角的旗子可以檢舉；回到雷達長按氣泡，也可以封鎖。', '如果遇到让你不舒服的人，右上角的旗子可以举报；回到雷达长按气泡，也可以屏蔽。', 'If someone makes you uncomfortable, use the flag at the top right to report them. On the radar, long-press their bubble to block them.', '嫌な思いをしたら、右上の旗から通報できます。レーダーで泡を長押しすればブロックもできます。', '불편한 사람을 만나면 오른쪽 위 깃발로 신고할 수 있어요. 레이더에서 버블을 길게 누르면 차단도 할 수 있어요.', 'Jika seseorang membuat anda tidak selesa, gunakan bendera di kanan atas untuk melapor. Di radar, tekan lama gelembung mereka untuk menyekat.', 'Kalau ada yang membuatmu tidak nyaman, pakai bendera di kanan atas untuk melapor. Di radar, tekan lama gelembungnya untuk memblokir.', 'Nếu ai đó khiến bạn khó chịu, hãy dùng lá cờ ở góc trên bên phải để báo cáo. Trên radar, nhấn giữ bong bóng của họ để chặn.'],
    ['離開對話之後，這些訊息會全部消失，什麼都不會留下。', '离开对话之后，这些消息会全部消失，什么都不会留下。', 'Once you leave the conversation, all these messages disappear. Nothing is kept.', '会話を抜けると、メッセージはすべて消え、何も残りません。', '대화를 나가면 메시지는 모두 사라지고 아무것도 남지 않아요.', 'Selepas anda meninggalkan perbualan, semua mesej ini hilang. Tiada apa yang disimpan.', 'Setelah kamu keluar dari obrolan, semua pesan ini hilang. Tidak ada yang tersimpan.', 'Khi bạn rời cuộc trò chuyện, mọi tin nhắn sẽ biến mất. Không có gì được giữ lại.'],
    ['試試雙擊別人的氣泡，送出一道微光；或從底部選單留一則低語，給之後經過這裡的人。', '试试双击别人的气泡，送出一道微光；或从底部菜单留一则低语，给之后经过这里的人。', "Try double-tapping someone's bubble to send a glimmer, or leave a whisper from the bottom bar for whoever passes by next.", '相手の泡をダブルタップしてきらめきを送ったり、下のメニューから次に通る人へささやきを残したりしてみて。', '다른 사람의 버블을 두 번 눌러 반짝임을 보내 보세요. 아니면 아래 메뉴에서 다음에 지나갈 사람에게 속삭임을 남겨 보세요.', 'Cuba ketik dua kali gelembung seseorang untuk menghantar kerlipan, atau tinggalkan bisikan dari bar bawah untuk orang seterusnya yang lalu.', 'Coba ketuk dua kali gelembung seseorang untuk mengirim kilauan, atau tinggalkan bisikan dari bilah bawah untuk orang berikutnya yang lewat.', 'Thử chạm hai lần vào bong bóng của ai đó để gửi đốm sáng, hoặc để lại lời thì thầm từ thanh dưới cho người kế tiếp đi qua.'],
    ['謝謝你陪我聊天。希望你在城市裡，也能遇到真正的人 ✨', '谢谢你陪我聊天。希望你在城市里，也能遇到真正的人 ✨', 'Thanks for chatting with me. I hope you meet real people in the city too ✨', '話してくれてありがとう。街で本物の誰かにも出会えますように ✨', '대화해 줘서 고마워요. 도시에서 진짜 사람도 만나길 바라요 ✨', 'Terima kasih kerana bersembang. Semoga anda juga bertemu orang sebenar di bandar ✨', 'Terima kasih sudah mengobrol. Semoga kamu juga bertemu orang sungguhan di kota ✨', 'Cảm ơn bạn đã trò chuyện. Mong bạn cũng gặp được người thật trong thành phố ✨'],
    ['我只會說這些示範的話，去雷達上找找附近的真人吧！', '我只会说这些示范的话，去雷达上找找附近的真人吧！', 'These demo lines are all I can say. Go find real people nearby on the radar!', '私が話せるのはこのデモの言葉だけ。レーダーで近くの本物の人を探してみて！', '저는 이 데모 문장만 말할 수 있어요. 레이더에서 근처의 진짜 사람을 찾아보세요!', 'Saya hanya boleh berkata ayat demo ini. Cari orang sebenar berdekatan di radar!', 'Aku cuma bisa mengucapkan kalimat demo ini. Cari orang sungguhan di dekatmu lewat radar!', 'Mình chỉ nói được mấy câu mẫu này thôi. Hãy tìm người thật gần bạn trên radar nhé!'],
];

const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

// 繁中範本 → 正規表示式（{名稱} 變成擷取群組）
const COMPILED = TABLE.map((row) => {
    const names = [];
    const source = row[0].split(/(\{\w+\})/).map((part) => {
        const m = /^\{(\w+)\}$/.exec(part);
        if (!m) return escapeRe(part);
        names.push(m[1]);
        return '(.+?)';
    }).join('');
    return { re: new RegExp(`^${source}$`, 's'), names, row };
});

/** 'zh-TW'、'zh-Hant-TW'、'en-US,en;q=0.9' … → 支援的語言之一 */
function normalizeLang(raw) {
    const tag = String(raw || '').split(',')[0].trim().toLowerCase().replace(/_/g, '-');
    if (!tag) return DEFAULT_LANG;
    const [lang, ...rest] = tag.split('-');
    if (lang === 'zh') return rest.some((p) => p === 'hans' || p === 'cn' || p === 'sg' || p === 'my') ? 'zh-Hans' : 'zh-Hant';
    return LANGS.includes(lang) ? lang : (lang === 'in' ? 'id' : DEFAULT_LANG);
}

/** HTTP 請求的語言：App 送 Accept-Language（或 body.lang） */
function langOf(req) {
    return normalizeLang((req && req.body && req.body.lang) || (req && req.get && req.get('accept-language')));
}

function localize(lang, text) {
    lang = normalizeLang(lang);
    if (typeof text !== 'string' || lang === DEFAULT_LANG) return text;
    const col = LANGS.indexOf(lang);
    for (const { re, names, row } of COMPILED) {
        const m = re.exec(text);
        if (!m) continue;
        const values = Object.fromEntries(names.map((n, i) => [n, localize(lang, m[i + 1])]));
        return row[col].replace(/\{(\w+)\}/g, (_, n) => values[n] ?? '');
    }
    return text;
}

module.exports = { LANGS, DEFAULT_LANG, TABLE, normalizeLang, langOf, localize };
