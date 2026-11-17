// ============================================================================
// 城市示範對象（NPC）：平行宇宙列出的每座城市，中央車站周圍各 100 位
//   - 暱稱與心情用當地語言；App 一律標示「示範」，點開會說明由程式自動回應、不是真人
//   - 位置、名字、心情都由城市 ID 當種子算出來，每次相同，不必事先寫進資料庫
//   - 第一次出現在某人的雷達上時，才把名字與心情寫進 user_data（檢舉、隱藏、聊天取名照舊運作）
//   - 和台北示範一樣：不在 city_users 裡，不影響殘影密度與城市心情天氣；附近真人多時減量
// ============================================================================

const CITY_BOT_COUNT = 100;
const CITY_RADIUS_KM = 2.5;
const CITY_PREFIX = 'demo-c-'; // uid：demo-c-{城市ID}-{001..100}，不能含底線（聊天室 ID 以底線相接）

// 國家 → 名字與心情用的語言
const LANG_OF_COUNTRY = {
    tw: 'zh', hk: 'zh', mo: 'zh', jp: 'ja', kr: 'ko', my: 'ms', id: 'id', vn: 'vi', th: 'th',
    sg: 'en', ph: 'en', au: 'en', nz: 'en', za: 'en', in: 'hi', br: 'pt', ar: 'es',
};

const NAMES = {
    zh: ['小雨', '阿哲', '柚子', '小魚', '阿凱', '晴晴', 'Momo', '阿偉', '小安', '米米', '阿翔', '豆花', '小樹', '阿傑', '芋圓', '小夏',
        '阿寬', '貝貝', '小鹿', '阿宏', '布丁', '小晨', '阿駿', '可可', '小光', '阿倫', '湯圓', '小薰', '阿彥', '奶茶', '小涵', '阿哲哥',
        '星星', '小羽', '阿誠', '蘋果', '小綠', '阿廷', '麻糬', '小白'],
    ja: ['ハル', 'ゆき', 'そら', 'りん', 'ケンタ', 'みお', 'ユウ', 'さくら', 'タク', 'あおい', 'ひなた', 'リョウ', 'まい', 'ソウタ', 'ことね', 'カイ',
        'なな', 'ショウ', 'つむぎ', 'レン', 'ゆい', 'ダイキ', 'はるか', 'ミナト', 'めい', 'コウ', 'さき', 'ハヤト', 'ちひろ', 'ナオ', 'かな', 'ジン',
        'もも', 'リク', 'あや', 'トモ', 'えま', 'シン', 'ここ', 'ユウキ'],
    ko: ['민지', '하늘', '준', '서연', '지호', '유나', '도윤', '수아', '현우', '예린', '태오', '하린', '시우', '다은', '민재', '소희',
        '준호', '지안', '건우', '채원', '은우', '나연', '승민', '세아', '우진', '하은', '재현', '보라', '동현', '미소', '진', '아라',
        '성훈', '유진', '태양', '별', '지훈', '새봄', '한결', '루미'],
    ms: ['Aina', 'Hafiz', 'Mei', 'Arif', 'Siti', 'Daniel', 'Nurul', 'Irfan', 'Ain', 'Kumar', 'Farah', 'Amir', 'Lina', 'Zul', 'Hana', 'Raj',
        'Aisyah', 'Haziq', 'Wei Ling', 'Adam', 'Sofia', 'Syafiq', 'Priya', 'Iman', 'Jun', 'Alya', 'Faiz', 'Yana', 'Hakim', 'Mira', 'Danish', 'Qis',
        'Ezra', 'Nadia', 'Kai', 'Balqis', 'Imran', 'Jia Yi', 'Rizal', 'Dina'],
    id: ['Putri', 'Rizky', 'Dewi', 'Bima', 'Ayu', 'Fajar', 'Nadia', 'Dimas', 'Sari', 'Yoga', 'Intan', 'Arga', 'Laras', 'Raka', 'Tari', 'Bayu',
        'Citra', 'Adit', 'Wulan', 'Gilang', 'Nisa', 'Reza', 'Kirana', 'Andi', 'Mega', 'Rangga', 'Salsa', 'Tegar', 'Indah', 'Farel', 'Rara', 'Ilham',
        'Dinda', 'Galih', 'Ratna', 'Bagas', 'Alya', 'Satria', 'Nayla', 'Eko'],
    vi: ['Linh', 'Minh', 'Trang', 'Huy', 'Mai', 'Khoa', 'Ngọc', 'Tuấn', 'Thảo', 'Nam', 'Vy', 'Long', 'Hà', 'Phúc', 'An', 'Quân',
        'Lan', 'Đạt', 'Hương', 'Bảo', 'My', 'Khang', 'Yến', 'Tùng', 'Nhi', 'Duy', 'Thư', 'Hải', 'Uyên', 'Sơn', 'Chi', 'Vinh',
        'Hân', 'Lộc', 'Quỳnh', 'Tâm', 'Diệp', 'Thắng', 'Na', 'Kiên'],
    th: ['พลอย', 'บอส', 'มายด์', 'ต้น', 'ฝน', 'เจ', 'น้ำ', 'กัน', 'แพร', 'ภูมิ', 'มิ้นท์', 'โอ๊ต', 'เฟิร์น', 'ปั้น', 'ใบเตย', 'นนท์',
        'ขิม', 'ภู', 'แนน', 'ต้า', 'ปราง', 'เก่ง', 'ไอซ์', 'ฟ้า', 'เมย์', 'ก้อง', 'จูน', 'บีม', 'ส้ม', 'ตาล', 'อิ่ม', 'กาย',
        'ดาว', 'นัท', 'แป้ง', 'ฟลุ๊ค', 'หมิว', 'ปอ', 'เอิร์น', 'ซัน'],
    en: ['Mia', 'Jack', 'Chloe', 'Leo', 'Ruby', 'Sam', 'Ava', 'Noah', 'Ella', 'Max', 'Zoe', 'Ben', 'Lily', 'Kai', 'Grace', 'Theo',
        'Isla', 'Ethan', 'Nina', 'Liam', 'Sophie', 'Jay', 'Hannah', 'Oscar', 'Maya', 'Finn', 'Bea', 'Josh', 'Ivy', 'Sean', 'Tess', 'Marco',
        'Ana', 'Rafa', 'Jess', 'Tom', 'Kyla', 'Luke', 'Thandi', 'Ari'],
    hi: ['आरव', 'अनन्या', 'रोहन', 'प्रिया', 'कबीर', 'ईशा', 'अर्जुन', 'नेहा', 'विहान', 'सान्वी', 'आदित्य', 'मीरा', 'करण', 'दिया', 'ऋषि', 'तारा',
        'अमन', 'काव्या', 'यश', 'पूजा', 'देव', 'सिया', 'निखिल', 'आन्या', 'समीर', 'रिया', 'वरुण', 'ज़ोया', 'ओम', 'नैना', 'राहुल', 'इरा',
        'शिव', 'तान्या', 'मनन', 'गौरी', 'आयुष', 'किआरा', 'हर्ष', 'अदिति'],
    pt: ['Ana', 'Lucas', 'Júlia', 'Pedro', 'Bia', 'Gabriel', 'Lari', 'Mateus', 'Camila', 'Rafa', 'Duda', 'Thiago', 'Manu', 'Caio', 'Lívia', 'Gui',
        'Isa', 'Bruno', 'Carol', 'Diego', 'Nanda', 'Leo', 'Malu', 'Vini', 'Bel', 'João', 'Clara', 'Davi', 'Lu', 'Felipe', 'Mari', 'Enzo',
        'Lara', 'Igor', 'Sofia', 'Fábio', 'Nina', 'Breno', 'Alice', 'Tati'],
    es: ['Sofi', 'Mateo', 'Valen', 'Tomás', 'Cami', 'Nico', 'Lu', 'Santi', 'Flor', 'Facu', 'Agus', 'Juli', 'Mica', 'Benja', 'Male', 'Lauti',
        'Pili', 'Joaco', 'Delfi', 'Fran', 'Martu', 'Gonza', 'Abril', 'Thiago', 'Juana', 'Bauti', 'Emi', 'Lucho', 'Caro', 'Nacho', 'Meli', 'Seba',
        'Ana', 'Fede', 'Rocío', 'Pablo', 'Vicky', 'Leo', 'Paz', 'Dante'],
};

const MOODS = {
    zh: ['剛下班，想散散步', '在便利商店找宵夜', '今天的天空很漂亮', '有點累，想聽音樂', '咖啡續第二杯☕', '等公車中', '想吃一碗熱湯麵',
        '週末想去走走', '剛看完展覽', '慢慢晃回家', '雨停了🌧️', '今天很順利😊', '一個人逛書店', '想念家裡的飯菜', '夜市人好多',
        '在河邊吹風', '加班終於結束', '剛搬來，還在熟悉這裡', '耳機裡在放老歌', '有點想找人聊天'],
    ja: ['仕事終わり、ちょっと散歩', 'コンビニで夜食探し', '今日は空がきれい', '少し疲れた、音楽聴きたい', 'カフェで二杯目☕', 'バス待ち中', 'ラーメン食べたい🍜',
        '週末どこか行きたいな', '展示を見てきた', 'のんびり帰り道', '雨やんだ🌧️', '今日はいい日だった😊', '本屋でぶらぶら', '実家のごはんが恋しい', '駅前、人が多い',
        '川沿いで風に当たってる', 'やっと残業おわった', '引っ越してきたばかり', 'イヤホンで昔の曲', '誰かと少し話したい'],
    ko: ['퇴근하고 산책 중', '편의점에서 야식 고르는 중', '오늘 하늘 너무 예쁘다', '좀 피곤해, 음악 듣고 싶어', '카페에서 두 잔째☕', '버스 기다리는 중', '따뜻한 국물 먹고 싶다',
        '주말에 어디 가고 싶다', '전시 보고 나왔어', '천천히 집에 가는 길', '비 그쳤다🌧️', '오늘 하루 괜찮았어😊', '혼자 서점 구경', '엄마 밥 생각나', '사람 진짜 많다',
        '강변에서 바람 쐬는 중', '야근 드디어 끝', '이사 온 지 얼마 안 됐어', '이어폰으로 옛날 노래', '누군가랑 얘기하고 싶다'],
    ms: ['Baru habis kerja, nak jalan-jalan', 'Cari makan malam', 'Langit cantik hari ini', 'Penat sikit, nak dengar lagu', 'Kopi cawan kedua☕', 'Tunggu bas', 'Teringin nasi lemak',
        'Hujung minggu nak keluar', 'Baru lepas tengok pameran', 'Jalan balik perlahan-lahan', 'Hujan dah berhenti🌧️', 'Hari ni okay😊', 'Lepak di kedai buku', 'Rindu masakan mak', 'Ramai orang malam ni',
        'Ambil angin tepi sungai', 'Akhirnya habis OT', 'Baru pindah sini', 'Dengar lagu lama', 'Nak borak dengan seseorang'],
    id: ['Baru pulang kerja, jalan santai', 'Cari jajan malam', 'Langitnya bagus hari ini', 'Agak capek, mau dengar musik', 'Kopi gelas kedua☕', 'Nunggu bus', 'Pengen bakso hangat',
        'Weekend pengen jalan-jalan', 'Habis lihat pameran', 'Pulang pelan-pelan', 'Hujannya reda🌧️', 'Hari ini lancar😊', 'Main ke toko buku', 'Kangen masakan rumah', 'Ramai banget malam ini',
        'Cari angin di pinggir sungai', 'Akhirnya lembur selesai', 'Baru pindah ke sini', 'Dengar lagu lama', 'Pengen ngobrol sama seseorang'],
    vi: ['Vừa tan làm, đi dạo chút', 'Đi tìm đồ ăn khuya', 'Hôm nay trời đẹp quá', 'Hơi mệt, muốn nghe nhạc', 'Ly cà phê thứ hai☕', 'Đang chờ xe buýt', 'Thèm một tô phở nóng',
        'Cuối tuần muốn đi đâu đó', 'Vừa xem triển lãm', 'Thong thả đi về', 'Tạnh mưa rồi🌧️', 'Hôm nay ổn áp😊', 'Lang thang nhà sách', 'Nhớ cơm nhà', 'Tối nay đông người ghê',
        'Hóng gió bên sông', 'Cuối cùng cũng tăng ca xong', 'Mới chuyển đến đây', 'Nghe lại bài hát cũ', 'Muốn trò chuyện với ai đó'],
    th: ['เพิ่งเลิกงาน เดินเล่นหน่อย', 'หาของกินรอบดึก', 'วันนี้ฟ้าสวยมาก', 'เหนื่อยนิดหน่อย อยากฟังเพลง', 'กาแฟแก้วที่สอง☕', 'รอรถเมล์อยู่', 'อยากกินก๋วยเตี๋ยวร้อนๆ',
        'สุดสัปดาห์อยากไปเที่ยว', 'เพิ่งดูนิทรรศการมา', 'ค่อยๆ เดินกลับบ้าน', 'ฝนหยุดแล้ว🌧️', 'วันนี้ดีจัง😊', 'เดินเล่นร้านหนังสือ', 'คิดถึงกับข้าวที่บ้าน', 'คืนนี้คนเยอะมาก',
        'นั่งรับลมริมแม่น้ำ', 'โอทีเสร็จสักที', 'เพิ่งย้ายมาอยู่ที่นี่', 'ฟังเพลงเก่าๆ', 'อยากคุยกับใครสักคน'],
    en: ['Just finished work, taking a walk', 'Hunting for a late-night snack', 'The sky looks amazing today', 'A bit tired, need some music', 'Second coffee of the day☕', 'Waiting for the bus', 'Craving something warm',
        'Want to get away this weekend', 'Just saw a great exhibition', 'Slowly heading home', 'The rain finally stopped🌧️', 'Good day today😊', 'Browsing a bookshop', 'Missing home cooking', 'So busy around here tonight',
        'Catching the breeze by the water', 'Finally done with overtime', 'Just moved here', 'Old songs on repeat', 'Kind of want someone to talk to'],
    hi: ['अभी काम खत्म हुआ, थोड़ा टहल रहा हूँ', 'रात का नाश्ता ढूँढ रहे हैं', 'आज आसमान बहुत सुंदर है', 'थोड़ी थकान है, गाने सुनने हैं', 'दूसरी चाय☕', 'बस का इंतज़ार', 'गरम समोसे खाने का मन',
        'वीकेंड पर कहीं घूमना है', 'अभी प्रदर्शनी देखकर आए', 'आराम से घर जा रहे हैं', 'बारिश रुक गई🌧️', 'आज का दिन अच्छा रहा😊', 'किताबों की दुकान में', 'घर के खाने की याद', 'आज यहाँ बहुत भीड़ है',
        'नदी किनारे हवा खा रहे हैं', 'आखिरकार ओवरटाइम खत्म', 'अभी-अभी यहाँ आए हैं', 'पुराने गाने सुन रहे हैं', 'किसी से बात करने का मन है'],
    pt: ['Acabei de sair do trabalho, dando uma volta', 'Procurando um lanche da noite', 'O céu tá lindo hoje', 'Meio cansado, quero ouvir música', 'Segundo café do dia☕', 'Esperando o ônibus', 'Com vontade de um caldo quente',
        'Quero viajar no fim de semana', 'Acabei de ver uma exposição', 'Voltando pra casa devagar', 'A chuva parou🌧️', 'Dia bom hoje😊', 'Passeando numa livraria', 'Saudade da comida de casa', 'Muita gente por aqui hoje',
        'Pegando um vento perto da água', 'Finalmente acabou a hora extra', 'Acabei de me mudar pra cá', 'Ouvindo músicas antigas', 'Afim de conversar com alguém'],
    es: ['Recién salgo del laburo, caminando un rato', 'Buscando algo para picar', 'Hoy el cielo está hermoso', 'Un poco cansado, quiero música', 'Segundo café del día☕', 'Esperando el colectivo', 'Tengo ganas de algo calentito',
        'Quiero escaparme el finde', 'Recién vi una muestra', 'Volviendo a casa tranqui', 'Paró la lluvia🌧️', 'Hoy fue un buen día😊', 'Paseando por una librería', 'Extraño la comida de casa', 'Hay mucha gente hoy',
        'Tomando aire cerca del río', 'Por fin terminé las horas extra', 'Recién me mudé acá', 'Escuchando temas viejos', 'Con ganas de charlar con alguien'],
};

function hashString(s) {
    let h = 2166136261;
    for (const ch of String(s)) { h ^= ch.codePointAt(0); h = Math.imul(h, 16777619); }
    return h >>> 0;
}

function seededRandom(seed) {
    let s = seed >>> 0;
    return () => {
        s = (s + 0x6D2B79F5) >>> 0;
        let t = s;
        t = Math.imul(t ^ (t >>> 15), t | 1);
        t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
        return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
}

function offsetLatLng(lat, lng, meters, bearing) {
    const R = 6371000, d = meters / R, la1 = (lat * Math.PI) / 180, lo1 = (lng * Math.PI) / 180;
    const la2 = Math.asin(Math.sin(la1) * Math.cos(d) + Math.cos(la1) * Math.sin(d) * Math.cos(bearing));
    const lo2 = lo1 + Math.atan2(Math.sin(bearing) * Math.sin(d) * Math.cos(la1), Math.cos(d) - Math.sin(la1) * Math.sin(la2));
    return { lat: (la2 * 180) / Math.PI, lng: (lo2 * 180) / Math.PI };
}

function distanceKm(a, b) {
    const dLat = ((b.lat - a.lat) * Math.PI) / 180, dLng = ((b.lng - a.lng) * Math.PI) / 180;
    const h = Math.sin(dLat / 2) ** 2 + Math.cos((a.lat * Math.PI) / 180) * Math.cos((b.lat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
    return 2 * 6371 * Math.asin(Math.sqrt(h));
}

const cache = new Map();

/** 一座城市的 100 位示範對象（同一座城市每次結果相同） */
function cityBots(city) {
    if (cache.has(city.id)) return cache.get(city.id);
    const lang = LANG_OF_COUNTRY[city.country] || 'en';
    const names = NAMES[lang], moods = MOODS[lang];
    const rand = seededRandom(hashString(`city-npc:${city.id}`));
    // 名字先洗牌再依序取用，同一城市裡前 40 位不重名
    const order = names.map((n, i) => [rand(), i]).sort((a, b) => a[0] - b[0]).map(([, i]) => names[i]);
    const bots = Array.from({ length: CITY_BOT_COUNT }, (_, i) => {
        const pos = offsetLatLng(city.lat, city.lng, Math.sqrt(rand()) * CITY_RADIUS_KM * 1000, rand() * 2 * Math.PI);
        return { uid: `${CITY_PREFIX}${city.id}-${String(i + 1).padStart(3, '0')}`, nickname: order[i % order.length], mood: moods[Math.floor(rand() * moods.length)], ...pos };
    });
    cache.set(city.id, bots);
    return bots;
}

/** 觀看者半徑內的城市示範對象：[{uid, nickname, mood, lat, lng, dist}]，由近到遠 */
function nearbyCityBots(cities, here, radiusKm) {
    const out = [];
    for (const city of cities) {
        if (distanceKm(city, here) > radiusKm + CITY_RADIUS_KM) continue;
        for (const b of cityBots(city)) {
            const dist = distanceKm(here, b);
            if (dist <= radiusKm) out.push({ ...b, dist });
        }
    }
    return out.sort((a, b) => a.dist - b.dist);
}

module.exports = { CITY_BOT_COUNT, CITY_RADIUS_KM, CITY_PREFIX, LANG_OF_COUNTRY, NAMES, MOODS, cityBots, nearbyCityBots };
