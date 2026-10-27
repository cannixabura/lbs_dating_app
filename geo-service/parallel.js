// ============================================================================
// 平行宇宙：把其他國家的人，疊到你所在城市的雷達上
//
// 對應法：每座城市以它的中央車站為中心點（例如大台北＝台北車站、桃園＝桃園車站、
// 東京＝東京車站、橫濱＝橫濱車站）。你離自家車站往哪個方向、多少公里，
// 在對方城市就出現在離對方車站同方向、同樣公里數的地方（1:1，不縮放）。
// 所以台北車站東邊 3 公里的人，東京的人會在東京車站東邊約 3 公里看到他；
// 橫濱車站北邊 2 公里的人，台北的人會在台北車站北邊約 2 公里看到他。
//
// 誰對到誰：目前固定是「台灣 ↔ 其他國家」：台灣各縣市疊上所有國外城市，
// 國外城市疊上台灣各縣市；同一個國家內、國外之間不互疊。之後可能開放讓使用者選擇。
//
// 誰看得到誰：只要「其中一人」開啟平行宇宙就看得到對方。
//   都沒開 → 互相看不到；只有 B 開 → A 只看到 B 一個人，B 看到 A 城市所有人；
//   都開 → 兩座城市重疊，都看到對方城市所有人。
// 只有正開著 App 的人會跨城市；殘影、低語、低語穿越、集會都是在地的，不進平行宇宙。
//
// 位置不可還原：先在「原本的城市」把精確位置吸附到 500 公尺網格，
// 加上每人每天固定的偏移，才疊過去。所以看到的位置都至少有 500 公尺的誤差，也不會顯示真實距離。
//
// 永遠不包含中國大陸。
// ============================================================================

const crypto = require('crypto');

const GEO_KEY = 'parallel_users'; // 只放開啟平行宇宙的人（精確座標，跟 city_users 一樣不對外）
const ALL_KEY = 'city_users'; // 開啟的人看得到其他城市所有人
const CELL_METERS = 500;
const JITTER_FRACTION = 0.3; // 格內偏移最多 ±30%（±150 公尺）
const FUZZ_MARGIN_KM = 1; // 模糊化最多讓位置偏多遠（格子半對角線＋偏移，約 0.6 公里）再留餘裕
const DEFAULT_KM = 40; // 國外城市：離中心車站多少公里內算這座城市
const PER_CITY_RESULTS = 60;
const MAX_RESULTS = 30;
const METERS_PER_DEG_LAT = 111320;
const TAIWAN = 'tw';

// 台灣本島：方框內的位置都歸最近的縣市車站（方框內沒有中國大陸的土地）
const TAIWAN_MAIN_ISLAND = { box: [21.85, 25.35, 119.95, 122.1] };

// 城市：中心點（中央車站）、國家、成員範圍、各語言名稱
// 名稱順序 [繁中, 簡中, 英, 日, 韓, 馬來, 印尼, 越南]，與 i18n.js 的 LANGS 相同。
// 成員範圍：預設是離車站 DEFAULT_KM 內；box = [南, 北, 西, 東]；circles = [[lat, lng, km], ...]
const CITIES = [
    // ---- 台灣：各縣市的中央車站 ----
    { id: 'keelung', country: TAIWAN, lat: 25.1319, lng: 121.7397, ...TAIWAN_MAIN_ISLAND, names: ['基隆', '基隆', 'Keelung', '基隆', '지룽', 'Keelung', 'Keelung', 'Cơ Long'] }, // 基隆車站
    { id: 'taipei', country: TAIWAN, lat: 25.0478, lng: 121.5170, ...TAIWAN_MAIN_ISLAND, names: ['台北', '台北', 'Taipei', '台北', '타이베이', 'Taipei', 'Taipei', 'Đài Bắc'] }, // 台北車站（大台北）
    { id: 'taoyuan', country: TAIWAN, lat: 24.9891, lng: 121.3134, ...TAIWAN_MAIN_ISLAND, names: ['桃園', '桃园', 'Taoyuan', '桃園', '타오위안', 'Taoyuan', 'Taoyuan', 'Đào Viên'] }, // 桃園車站
    { id: 'hsinchu', country: TAIWAN, lat: 24.8016, lng: 120.9716, ...TAIWAN_MAIN_ISLAND, names: ['新竹', '新竹', 'Hsinchu', '新竹', '신주', 'Hsinchu', 'Hsinchu', 'Tân Trúc'] }, // 新竹車站
    { id: 'miaoli', country: TAIWAN, lat: 24.5703, lng: 120.8222, ...TAIWAN_MAIN_ISLAND, names: ['苗栗', '苗栗', 'Miaoli', '苗栗', '먀오리', 'Miaoli', 'Miaoli', 'Miêu Lật'] }, // 苗栗車站
    { id: 'taichung', country: TAIWAN, lat: 24.1372, lng: 120.6866, ...TAIWAN_MAIN_ISLAND, names: ['台中', '台中', 'Taichung', '台中', '타이중', 'Taichung', 'Taichung', 'Đài Trung'] }, // 台中車站
    { id: 'changhua', country: TAIWAN, lat: 24.0817, lng: 120.5386, ...TAIWAN_MAIN_ISLAND, names: ['彰化', '彰化', 'Changhua', '彰化', '장화', 'Changhua', 'Changhua', 'Chương Hóa'] }, // 彰化車站
    { id: 'nantou', country: TAIWAN, lat: 23.9106, lng: 120.6855, ...TAIWAN_MAIN_ISLAND, names: ['南投', '南投', 'Nantou', '南投', '난터우', 'Nantou', 'Nantou', 'Nam Đầu'] }, // 南投轉運站（南投市沒有火車站）
    { id: 'yunlin', country: TAIWAN, lat: 23.7116, lng: 120.5411, ...TAIWAN_MAIN_ISLAND, names: ['雲林', '云林', 'Yunlin', '雲林', '윈린', 'Yunlin', 'Yunlin', 'Vân Lâm'] }, // 斗六車站
    { id: 'chiayi', country: TAIWAN, lat: 23.4791, lng: 120.4412, ...TAIWAN_MAIN_ISLAND, names: ['嘉義', '嘉义', 'Chiayi', '嘉義', '자이', 'Chiayi', 'Chiayi', 'Gia Nghĩa'] }, // 嘉義車站
    { id: 'tainan', country: TAIWAN, lat: 22.9971, lng: 120.2124, ...TAIWAN_MAIN_ISLAND, names: ['台南', '台南', 'Tainan', '台南', '타이난', 'Tainan', 'Tainan', 'Đài Nam'] }, // 台南車站
    { id: 'kaohsiung', country: TAIWAN, lat: 22.6393, lng: 120.3024, ...TAIWAN_MAIN_ISLAND, names: ['高雄', '高雄', 'Kaohsiung', '高雄', '가오슝', 'Kaohsiung', 'Kaohsiung', 'Cao Hùng'] }, // 高雄車站
    { id: 'pingtung', country: TAIWAN, lat: 22.6693, lng: 120.4864, ...TAIWAN_MAIN_ISLAND, names: ['屏東', '屏东', 'Pingtung', '屏東', '핑둥', 'Pingtung', 'Pingtung', 'Bình Đông'] }, // 屏東車站
    { id: 'yilan', country: TAIWAN, lat: 24.7546, lng: 121.7582, ...TAIWAN_MAIN_ISLAND, names: ['宜蘭', '宜兰', 'Yilan', '宜蘭', '이란', 'Yilan', 'Yilan', 'Nghi Lan'] }, // 宜蘭車站
    { id: 'hualien', country: TAIWAN, lat: 23.9929, lng: 121.6013, ...TAIWAN_MAIN_ISLAND, names: ['花蓮', '花莲', 'Hualien', '花蓮', '화롄', 'Hualien', 'Hualien', 'Hoa Liên'] }, // 花蓮車站
    { id: 'taitung', country: TAIWAN, lat: 22.7935, lng: 121.1233, ...TAIWAN_MAIN_ISLAND, names: ['台東', '台东', 'Taitung', '台東', '타이둥', 'Taitung', 'Taitung', 'Đài Đông'] }, // 台東車站
    { id: 'penghu', country: TAIWAN, lat: 23.5667, lng: 119.5660, km: 35, names: ['澎湖', '澎湖', 'Penghu', '澎湖', '펑후', 'Penghu', 'Penghu', 'Bành Hồ'] }, // 馬公
    // 金門、馬祖緊鄰中國大陸：只收島上的範圍
    { id: 'kinmen', country: TAIWAN, lat: 24.4337, lng: 118.3170, box: [24.38, 24.535, 118.21, 118.48], names: ['金門', '金门', 'Kinmen', '金門', '진먼', 'Kinmen', 'Kinmen', 'Kim Môn'] }, // 金城車站
    { id: 'matsu', country: TAIWAN, lat: 26.1606, lng: 119.9497, circles: [[26.155, 119.935, 4], [26.225, 119.995, 3], [25.965, 119.95, 3], [26.365, 120.49, 3]], names: ['馬祖', '马祖', 'Matsu', '馬祖', '마쭈', 'Matsu', 'Matsu', 'Mã Tổ'] }, // 南竿福澳港

    // ---- 日本 ----
    { id: 'tokyo', country: 'jp', lat: 35.6812, lng: 139.7671, names: ['東京', '东京', 'Tokyo', '東京', '도쿄', 'Tokyo', 'Tokyo', 'Tokyo'] }, // 東京駅
    { id: 'yokohama', country: 'jp', lat: 35.4660, lng: 139.6223, names: ['橫濱', '横滨', 'Yokohama', '横浜', '요코하마', 'Yokohama', 'Yokohama', 'Yokohama'] }, // 横浜駅
    { id: 'osaka', country: 'jp', lat: 34.7024, lng: 135.4959, names: ['大阪', '大阪', 'Osaka', '大阪', '오사카', 'Osaka', 'Osaka', 'Osaka'] }, // 大阪駅
    { id: 'kyoto', country: 'jp', lat: 34.9858, lng: 135.7588, names: ['京都', '京都', 'Kyoto', '京都', '교토', 'Kyoto', 'Kyoto', 'Kyoto'] }, // 京都駅
    { id: 'kobe', country: 'jp', lat: 34.6947, lng: 135.1953, names: ['神戶', '神户', 'Kobe', '神戸', '고베', 'Kobe', 'Kobe', 'Kobe'] }, // 三ノ宮駅
    { id: 'nagoya', country: 'jp', lat: 35.1709, lng: 136.8815, names: ['名古屋', '名古屋', 'Nagoya', '名古屋', '나고야', 'Nagoya', 'Nagoya', 'Nagoya'] }, // 名古屋駅
    { id: 'fukuoka', country: 'jp', lat: 33.5902, lng: 130.4207, names: ['福岡', '福冈', 'Fukuoka', '福岡', '후쿠오카', 'Fukuoka', 'Fukuoka', 'Fukuoka'] }, // 博多駅
    { id: 'sapporo', country: 'jp', lat: 43.0686, lng: 141.3508, names: ['札幌', '札幌', 'Sapporo', '札幌', '삿포로', 'Sapporo', 'Sapporo', 'Sapporo'] }, // 札幌駅
    { id: 'sendai', country: 'jp', lat: 38.2601, lng: 140.8823, names: ['仙台', '仙台', 'Sendai', '仙台', '센다이', 'Sendai', 'Sendai', 'Sendai'] }, // 仙台駅
    { id: 'hiroshima', country: 'jp', lat: 34.3973, lng: 132.4753, names: ['廣島', '广岛', 'Hiroshima', '広島', '히로시마', 'Hiroshima', 'Hiroshima', 'Hiroshima'] }, // 広島駅
    { id: 'naha', country: 'jp', lat: 26.2149, lng: 127.6793, names: ['那霸', '那霸', 'Naha', '那覇', '나하', 'Naha', 'Naha', 'Naha'] }, // 県庁前駅

    // ---- 韓國 ----
    { id: 'seoul', country: 'kr', lat: 37.5547, lng: 126.9707, names: ['首爾', '首尔', 'Seoul', 'ソウル', '서울', 'Seoul', 'Seoul', 'Seoul'] }, // 서울역
    { id: 'busan', country: 'kr', lat: 35.1152, lng: 129.0414, names: ['釜山', '釜山', 'Busan', '釜山', '부산', 'Busan', 'Busan', 'Busan'] }, // 부산역
    { id: 'daegu', country: 'kr', lat: 35.8793, lng: 128.6285, names: ['大邱', '大邱', 'Daegu', '大邱', '대구', 'Daegu', 'Daegu', 'Daegu'] }, // 동대구역
    { id: 'daejeon', country: 'kr', lat: 36.3323, lng: 127.4346, names: ['大田', '大田', 'Daejeon', '大田', '대전', 'Daejeon', 'Daejeon', 'Daejeon'] }, // 대전역
    { id: 'gwangju', country: 'kr', lat: 35.1655, lng: 126.9092, names: ['光州', '光州', 'Gwangju', '光州', '광주', 'Gwangju', 'Gwangju', 'Gwangju'] }, // 광주역

    // ---- 香港、澳門：北邊就是中國大陸，只收原本的範圍並排除邊界 ----
    { id: 'hongkong', country: 'hk', lat: 22.2850, lng: 114.1580, circles: [[22.3193, 114.1694, 26]], names: ['香港', '香港', 'Hong Kong', '香港', '홍콩', 'Hong Kong', 'Hong Kong', 'Hồng Kông'] }, // 香港站
    { id: 'macau', country: 'mo', lat: 22.1935, lng: 113.5395, circles: [[22.1757, 113.5560, 7]], names: ['澳門', '澳门', 'Macau', 'マカオ', '마카오', 'Macau', 'Makau', 'Ma Cao'] }, // 議事亭前地

    // ---- 東南亞 ----
    // 新加坡：只收新加坡島（北邊柔佛海峽、南邊巴淡島不算）
    { id: 'singapore', country: 'sg', lat: 1.2930, lng: 103.8520, box: [1.19, 1.452, 103.59, 104.1], names: ['新加坡', '新加坡', 'Singapore', 'シンガポール', '싱가포르', 'Singapura', 'Singapura', 'Singapore'] }, // City Hall
    { id: 'kualalumpur', country: 'my', lat: 3.1343, lng: 101.6863, names: ['吉隆坡', '吉隆坡', 'Kuala Lumpur', 'クアラルンプール', '쿠알라룸푸르', 'Kuala Lumpur', 'Kuala Lumpur', 'Kuala Lumpur'] }, // KL Sentral
    { id: 'penang', country: 'my', lat: 5.4145, lng: 100.3295, km: 25, names: ['檳城', '槟城', 'Penang', 'ペナン', '페낭', 'Pulau Pinang', 'Penang', 'Penang'] }, // Komtar
    { id: 'jakarta', country: 'id', lat: -6.1766, lng: 106.8307, names: ['雅加達', '雅加达', 'Jakarta', 'ジャカルタ', '자카르타', 'Jakarta', 'Jakarta', 'Jakarta'] }, // Stasiun Gambir
    { id: 'bandung', country: 'id', lat: -6.9142, lng: 107.6025, km: 30, names: ['萬隆', '万隆', 'Bandung', 'バンドン', '반둥', 'Bandung', 'Bandung', 'Bandung'] }, // Stasiun Bandung
    { id: 'surabaya', country: 'id', lat: -7.2654, lng: 112.7517, names: ['泗水', '泗水', 'Surabaya', 'スラバヤ', '수라바야', 'Surabaya', 'Surabaya', 'Surabaya'] }, // Stasiun Gubeng
    { id: 'bali', country: 'id', lat: -8.6566, lng: 115.2166, km: 35, names: ['峇里島', '巴厘岛', 'Bali', 'バリ島', '발리', 'Bali', 'Bali', 'Bali'] }, // Denpasar
    { id: 'hochiminh', country: 'vn', lat: 10.7823, lng: 106.6770, names: ['胡志明市', '胡志明市', 'Ho Chi Minh City', 'ホーチミン', '호찌민', 'Ho Chi Minh', 'Ho Chi Minh', 'TP. Hồ Chí Minh'] }, // Ga Sài Gòn
    { id: 'hanoi', country: 'vn', lat: 21.0246, lng: 105.8411, names: ['河內', '河内', 'Hanoi', 'ハノイ', '하노이', 'Hanoi', 'Hanoi', 'Hà Nội'] }, // Ga Hà Nội
    { id: 'danang', country: 'vn', lat: 16.0716, lng: 108.2093, km: 30, names: ['峴港', '岘港', 'Da Nang', 'ダナン', '다낭', 'Da Nang', 'Da Nang', 'Đà Nẵng'] }, // Ga Đà Nẵng
];
const CITY_BY_ID = Object.fromEntries(CITIES.map((c) => [c.id, c]));
const LANGS = ['zh-Hant', 'zh-Hans', 'en', 'ja', 'ko', 'ms', 'id', 'vi'];

/** 城市名稱（使用者的語言；不認得的語言用繁中） */
function nameOf(id, lang) {
    const city = CITY_BY_ID[id];
    if (!city) return id;
    return city.names[Math.max(0, LANGS.indexOf(lang))];
}

/** 兩座城市是否互疊：目前固定是台灣 ↔ 其他國家 */
function paired(a, b) {
    return (a.country === TAIWAN) !== (b.country === TAIWAN);
}

// 香港、澳門北邊就是中國大陸：深圳（深圳河以北）、珠海（關閘以北）、橫琴。
// 用保守的方框排除，寧可少收邊界上的香港人，也不收到大陸的人。
function isMainlandBorderArea(lat, lng) {
    if (lng > 113.75 && lng < 114.65 && lat > 22.505) return true; // 深圳
    if (lng > 113.45 && lng < 113.70 && lat > 22.214) return true; // 珠海
    if (lng > 113.45 && lng < 113.556 && lat > 22.08 && lat < 22.17) return true; // 橫琴
    return false;
}

// 以城市中心為原點的平面公里座標（東、北）；城市範圍內誤差可忽略
function toLocalKm(city, lat, lng) {
    const east = (lng - city.lng) * METERS_PER_DEG_LAT * Math.cos(city.lat * Math.PI / 180) / 1000;
    const north = (lat - city.lat) * METERS_PER_DEG_LAT / 1000;
    return { east, north };
}

function fromLocalKm(city, east, north) {
    return {
        lat: city.lat + north * 1000 / METERS_PER_DEG_LAT,
        lng: city.lng + east * 1000 / (METERS_PER_DEG_LAT * Math.cos(city.lat * Math.PI / 180)),
    };
}

function distanceKm(a, b) {
    const dLat = (b.lat - a.lat) * METERS_PER_DEG_LAT;
    const dLng = (b.lng - a.lng) * METERS_PER_DEG_LAT * Math.cos(((a.lat + b.lat) / 2) * Math.PI / 180);
    return Math.hypot(dLat, dLng) / 1000;
}

function contains(city, lat, lng) {
    if (city.box) {
        const [south, north, west, east] = city.box;
        return lat >= south && lat <= north && lng >= west && lng <= east;
    }
    if (city.circles) return city.circles.some(([clat, clng, km]) => distanceKm({ lat: clat, lng: clng }, { lat, lng }) <= km);
    return distanceKm(city, { lat, lng }) <= (city.km ?? DEFAULT_KM);
}

/** 這個位置屬於哪座城市（範圍內、離中心車站最近的那座）；都不是就回傳 null */
function cityOf(lat, lng) {
    if (isMainlandBorderArea(lat, lng)) return null;
    let best = null, bestKm = Infinity;
    for (const city of CITIES) {
        if (!contains(city, lat, lng)) continue;
        const d = distanceKm(city, { lat, lng });
        if (d < bestKm) { best = city; bestKm = d; }
    }
    return best;
}

// 依 uid + 日期產生 [-1, 1) 的固定值：同一天同一人永遠相同，無法靠多次查詢平均掉
function stableUnit(uid, day, axis) {
    const h = crypto.createHash('sha256').update(`parallel|${uid}|${day}|${axis}`).digest();
    return (h.readUInt32BE(0) / 0x100000000) * 2 - 1;
}

/** 在原本的城市裡模糊化：吸附到 500 公尺網格中心，再加每人每天固定的偏移；回傳離中心車站的公里數 */
function fuzzInCity(city, lat, lng, uid, now) {
    const { east, north } = toLocalKm(city, lat, lng);
    const cell = CELL_METERS / 1000;
    const day = new Date(now).toISOString().slice(0, 10);
    return {
        east: (Math.floor(east / cell) + 0.5 + stableUnit(uid, day, 'e') * JITTER_FRACTION) * cell,
        north: (Math.floor(north / cell) + 0.5 + stableUnit(uid, day, 'n') * JITTER_FRACTION) * cell,
    };
}

/**
 * 把 from 城市裡的一個人疊到 to 城市：離中心車站的方向與公里數不變。
 * @returns {{lat:number, lng:number}} 對外顯示的位置（已模糊化）
 */
function project(from, to, lat, lng, uid, now) {
    const { east, north } = fuzzInCity(from, lat, lng, uid, now);
    return fromLocalKm(to, east, north);
}

/** 觀看者的雷達圈，對回 target 城市是哪一塊：只要搜尋這一塊就夠了（搜到後仍逐一投影、精確過濾） */
function searchArea(viewerCity, target, lat, lng, radiusKm) {
    const here = toLocalKm(viewerCity, lat, lng);
    return { ...fromLocalKm(target, here.east, here.north), radiusKm: radiusKm + FUZZ_MARGIN_KM };
}

// 所有城市的外接圓（大圓距離）：一次取回全部開啟平行宇宙的人
const EARTH_KM = 6371;
function greatCircleKm(a, b) {
    const r = Math.PI / 180;
    const h = Math.sin((b.lat - a.lat) * r / 2) ** 2 + Math.cos(a.lat * r) * Math.cos(b.lat * r) * Math.sin((b.lng - a.lng) * r / 2) ** 2;
    return 2 * EARTH_KM * Math.asin(Math.sqrt(h));
}
const COVER = (() => {
    const center = { lat: CITIES.reduce((t, c) => t + c.lat, 0) / CITIES.length, lng: CITIES.reduce((t, c) => t + c.lng, 0) / CITIES.length };
    const km = Math.max(...CITIES.map((c) => greatCircleKm(center, c))) + DEFAULT_KM + 50;
    return { ...center, km: Math.ceil(km) };
})();
const SNAPSHOT_LIMIT = 2000;

/** 取回所有開啟平行宇宙的人（沒開的人用；開啟的人通常不多，伺服器會短暫快取） */
function snapshotCommand() {
    return ['GEOSEARCH', GEO_KEY, 'FROMLONLAT', String(COVER.lng), String(COVER.lat), 'BYRADIUS', String(COVER.km), 'km', 'COUNT', String(SNAPSHOT_LIMIT), 'WITHCOORD'];
}

/**
 * 搜尋對方城市要用的指令（一城一個 GEOSEARCH，放進同一個 pipeline）。
 * key：開啟的人搜 city_users（所有人），沒開的人搜 parallel_users（只有開啟的人）。
 */
function searchCommands(viewerCity, lat, lng, radiusKm, key) {
    const others = CITIES.filter((c) => paired(viewerCity, c));
    return {
        others,
        commands: others.map((c) => {
            const area = searchArea(viewerCity, c, lat, lng, radiusKm);
            return ['GEOSEARCH', key, 'FROMLONLAT', String(area.lng), String(area.lat),
                'BYRADIUS', String(area.radiusKm), 'km', 'ASC', 'COUNT', String(PER_CITY_RESULTS), 'WITHCOORD'];
        }),
    };
}

module.exports = {
    GEO_KEY, ALL_KEY, CELL_METERS, MAX_RESULTS, CITIES, CITY_BY_ID, TAIWAN,
    cityOf, nameOf, paired, isMainlandBorderArea, project, searchArea, distanceKm, searchCommands, snapshotCommand, toLocalKm, COVER,
};
