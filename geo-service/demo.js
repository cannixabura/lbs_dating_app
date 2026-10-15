// ============================================================================
// 示範對象（導覽員機器人）
//   - 台北示範：200 位，放在台北市中心，所有人都看得到，一律標示「示範」
//   - 審核示範：20 位，只有在心情欄輸入通關碼的帳號看得到，從觀看者所在處起每 200 公尺一位
// 示範對象不在 city_users 地理索引裡，所以不會影響城市心情天氣與殘影的密度分級。
// 敲門會自動同意、聊天會自動回覆、送微光會回送一道；可以被檢舉與封鎖，流程與真人相同。
// ============================================================================

const DEMO_PREFIX = 'demo-'; // 用連字號：聊天室 ID 是兩人的 uid 以底線相接，示範對象的 uid 不能含底線
const PUBLIC_GEO_KEY = 'demo_public';   // 台北示範的地理索引
const REVIEWERS_KEY = 'demo_reviewers'; // 輸入過通關碼的帳號
const REVIEW_CODE = '#review';          // 審核備註裡提供的通關碼（心情欄輸入）
const REVIEW_MOOD = '審核示範模式';      // 輸入通關碼後，對外顯示的心情
const REVIEW_BOT_COUNT = 20;
const REVIEW_STEP_METERS = 200;
const REVIEW_REANCHOR_KM = 5;           // 審核人員移動超過這個距離，示範對象跟著移過去

const TAIPEI_CENTER = { lat: 25.0418, lng: 121.5440 }; // 忠孝復興一帶
const TAIPEI_RADIUS_KM = 4;
const TAIPEI_BOT_COUNT = 200;
const PUBLIC_MAX_RESULTS = 12;          // 一次最多顯示最近的 12 位，避免示範對象蓋過真人

const isDemoUid = (uid) => typeof uid === 'string' && uid.startsWith(DEMO_PREFIX);
const isReviewCode = (mood) => String(mood || '').trim().toLowerCase() === REVIEW_CODE;

const MOODS = [
    '平靜地散步🌿', '下班了，想吃宵夜😊', '今晚的風好舒服', '有點想家', '在咖啡店發呆☕', '剛看完一場電影',
    '雨好大，有點難過', '想找人聊聊天', '好愛這座城市💖', '加班到現在…', '在河堤看夜景', '今天被稱讚了😊',
    '想念某個人', '一個人吃火鍋🔥', '聽著音樂慢慢走', '剛跑完步，好累', '失眠中', '想去海邊',
    '平靜地喝一杯熱茶', '在書店待了一下午', '期待明天的旅行', '城市的燈好美', '剛搬來這裡', '有點孤單',
];

const REVIEW_MOODS = [
    '平靜地散步🌿', '想找人聊聊天', '好愛這座城市💖', '在咖啡店發呆☕', '今晚的風好舒服', '剛下班😊',
];

// 示範對話：依序回覆，說明這個 App 的玩法；講完之後用最後一組輪流回覆
const CHAT_LINES = [
    '嗨！我是示範對象，由程式自動回覆，不是真人 🌙 讓我帶你認識城市低語。',
    '在這裡，每段交集只有 10 分鐘。只要有人說話，倒數就會重新開始。',
    '如果遇到讓你不舒服的人，右上角的旗子可以檢舉；回到雷達長按氣泡，也可以封鎖。',
    '離開對話之後，這些訊息會全部消失，什麼都不會留下。',
    '試試雙擊別人的氣泡，送出一道微光；或從底部選單留一則低語，給之後經過這裡的人。',
];
const CHAT_IDLE_LINES = [
    '謝謝你陪我聊天。希望你在城市裡，也能遇到真正的人 ✨',
    '我只會說這些示範的話，去雷達上找找附近的真人吧！',
];

// 可重現的亂數：同一個種子每次產生同樣的分布，重新整理時位置不會亂跳
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

function offsetLatLng(lat, lng, distanceMeters, bearingRad) {
    const dLat = (distanceMeters * Math.cos(bearingRad)) / 111320;
    const dLng = (distanceMeters * Math.sin(bearingRad)) / (111320 * Math.cos((lat * Math.PI) / 180));
    return { lat: lat + dLat, lng: lng + dLng };
}

const pad = (n, width) => String(n).padStart(width, '0');
const GOLDEN_ANGLE = Math.PI * (3 - Math.sqrt(5));

/** 台北示範對象：均勻散在市中心半徑 4 公里內 */
function taipeiBots() {
    const rand = seededRandom(20261016);
    return Array.from({ length: TAIPEI_BOT_COUNT }, (_, i) => {
        const distance = Math.sqrt(rand()) * TAIPEI_RADIUS_KM * 1000; // 開根號讓面積上均勻
        const pos = offsetLatLng(TAIPEI_CENTER.lat, TAIPEI_CENTER.lng, distance, rand() * 2 * Math.PI);
        return {
            uid: `${DEMO_PREFIX}tpe-${pad(i + 1, 3)}`,
            nickname: `導覽員 ${pad(i + 1, 3)}`,
            mood: MOODS[Math.floor(rand() * MOODS.length)],
            ...pos,
        };
    });
}

/** 審核示範對象：圍繞錨點，第 i 位距離 200×i 公尺，方向以黃金角錯開 */
function reviewBots(anchor) {
    return Array.from({ length: REVIEW_BOT_COUNT }, (_, i) => {
        const pos = offsetLatLng(anchor.lat, anchor.lng, REVIEW_STEP_METERS * (i + 1), i * GOLDEN_ANGLE);
        return { uid: `${DEMO_PREFIX}rev-${pad(i + 1, 2)}`, ...pos };
    });
}

/** 審核示範對象的名字與心情（寫進 user_data，讓檢舉、隱藏、推播取名都和真人一樣運作） */
function reviewBotProfiles() {
    return Array.from({ length: REVIEW_BOT_COUNT }, (_, i) => ({
        uid: `${DEMO_PREFIX}rev-${pad(i + 1, 2)}`,
        nickname: `示範對象 ${pad(i + 1, 2)}`,
        mood: REVIEW_MOODS[i % REVIEW_MOODS.length],
    }));
}

/** 第 n 則回覆（n 從 0 起算） */
function chatReply(n) {
    return n < CHAT_LINES.length ? CHAT_LINES[n] : CHAT_IDLE_LINES[(n - CHAT_LINES.length) % CHAT_IDLE_LINES.length];
}

function distanceKm(a, b) {
    const R = 6371;
    const dLat = ((b.lat - a.lat) * Math.PI) / 180;
    const dLng = ((b.lng - a.lng) * Math.PI) / 180;
    const h = Math.sin(dLat / 2) ** 2 + Math.cos((a.lat * Math.PI) / 180) * Math.cos((b.lat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(h));
}

module.exports = {
    DEMO_PREFIX, PUBLIC_GEO_KEY, PUBLIC_MAX_RESULTS, REVIEWERS_KEY, REVIEW_CODE, REVIEW_MOOD, REVIEW_REANCHOR_KM,
    isDemoUid, isReviewCode, taipeiBots, reviewBots, reviewBotProfiles, chatReply, distanceKm,
};
