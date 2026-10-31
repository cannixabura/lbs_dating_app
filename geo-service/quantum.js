// ============================================================================
// 量子世界：全世界共用的同一個房間（規格：docs/quantum-world-spec.md）
//
// 以台北 101 為原點 Q0，所有進來的人排成六角形蜂巢：第 n 圈有 6n 個席位，相鄰席位相距 100 公尺。
// 第 1～3 圈（36 席）保留給量子集會主持人（第三期），一般使用者從第 4 圈開始排。
// 席位代號「Q4-17」= 第 4 圈第 17 號，從正北順時針編號；只在這次入場有效。
//
// 顯示位置 = 席位中心 ＋ 入場後真實走過的位移。位移由手機自己算，伺服器只收到「往東、往北幾公尺」，
// 真實經緯度只在入場時用來排除中國大陸，不寫進量子世界的任何資料。
// 時速超過 25 公里時位移不累加（搭車、高鐵），停下來後從當下繼續算。
//
// Redis：
//   quantum_free          sorted set：空出來的席位（score = 席位序號），入場先拿最小的
//   quantum_next          下一個新席位的序號（INCR）
//   quantum_seat:{uid}    這次入場：席位序號、入場時間、累計位移、上次回報的原始位移與時間、大區、量子寧靜
//   quantum_beats         sorted set：uid → 最後心跳時間；超過 3 分鐘沒心跳就釋放席位
//   quantum_region:{r}    sorted set：各大區的心跳（只用來算匿名人數）
//   quantum_users         地理索引：只放量子世界的顯示位置
//   quantum_collapses     sorted set：剛主動離開的人（score = 時間），讓旁邊的人播放塌縮動畫
//   ── 第二期 ──
//   quantum_ent:{uid}       set：這次入場糾纏中的人（雙方各存一份），任一方離開就斷掉
//   quantum_ent_inv:{uid}   hash：誰邀請我糾纏 → 邀請時間（2 分鐘內有效）
//   quantum_ent_gone:{uid}  list：糾纏剛塌縮的對方暱稱，下一次心跳告訴我
//   quantum_chime:{hour}    sorted set：這次整點報時送出報時微光的人
//   quantum_chime_fx:{hour} sorted set：報時微光的出發點「uid|lat|lng」，讓大家看到光點飛向原點
// ============================================================================

const parallel = require('./parallel');

const ORIGIN = { lat: 25.033964, lng: 121.564468 }; // 台北 101
const SPACING_M = 100;
const HOST_RINGS = 3; // 第 1～3 圈只給集會主持人
const HOST_SEATS = 3 * HOST_RINGS * (HOST_RINGS + 1); // 36
const METERS_PER_DEG_LAT = 111320;

const GRACE_MS = 3 * 60 * 1000; // 意外斷線：席位保留 3 分鐘
const VISIBLE_MS = 75 * 1000; // 超過這麼久沒心跳就先不顯示（心跳最慢 30 秒一次）
const MAX_SPEED_MPS = 25 / 3.6; // 時速 25 公里
const HOME_RADIUS_M = 40; // 回到入場的地方 40 公尺內，位移就跟著回到原點（定位飄移、搭車跳過的段落不再留下來）
const COLLAPSE_MS = 12 * 1000; // 塌縮動畫：離開後這段時間內掃描到的人會看到
const RADAR_KM = 5; // 一般雷達半徑；超過就是世界視角
const WORLD_MAX_KM = 60;
const WORLD_MAX_DOTS = 1500;
const MAX_RESULTS = 300;
const REGION_MIN = 5; // 人數太少的大區不單獨顯示，避免找出特定的人
const STALE_SWEEP = 20; // 每次順手釋放的過期席位上限

const KEY = {
    free: 'quantum_free',
    next: 'quantum_next',
    seat: (uid) => `quantum_seat:${uid}`,
    beats: 'quantum_beats',
    region: (r) => `quantum_region:${r}`,
    geo: 'quantum_users',
    collapses: 'quantum_collapses',
    ent: (uid) => `quantum_ent:${uid}`,
    invites: (uid) => `quantum_ent_inv:${uid}`,
    entGone: (uid) => `quantum_ent_gone:${uid}`,
    chime: (hour) => `quantum_chime:${hour}`,
    chimeFx: (hour) => `quantum_chime_fx:${hour}`,
};

const MAX_ENTANGLED = 3; // 每人同時最多糾纏 3 人
const INVITE_MS = 2 * 60 * 1000;
const HOUR_MS = 3600 * 1000;
const CHIME_BEFORE_MS = 60 * 1000; // 整點前 1 分鐘光柱開始變亮
const CHIME_AFTER_MS = 30 * 1000; // 報時約 15 秒，再留一點時間給慢一點的心跳拿到最後的人數
const CHIME_FX_MAX = 40;
const TOPIC_COUNT = 8; // 音樂、電影、科技、散步、美食、旅行、閱讀、運動
const MAX_TOPICS = 3;

// 大區：只用來顯示匿名人數
const REGIONS = ['tw', 'jp', 'kr', 'hkmo', 'sea', 'other'];
const COUNTRY_REGION = { tw: 'tw', jp: 'jp', kr: 'kr', hk: 'hkmo', mo: 'hkmo', sg: 'sea', my: 'sea', id: 'sea', vn: 'sea' };

// ---------- 席位 ----------

/** 第 ring 圈、第 index 號（0 起算，從正北順時針）的席位中心：離 101 往東、往北幾公尺 */
function seatOffset(ring, index) {
    const side = Math.floor(index / ring);
    const step = index % ring;
    const corner = (k) => {
        const bearing = (k % 6) * Math.PI / 3; // 六個角在方位 0°、60°、120°…（順時針）
        return { east: Math.sin(bearing) * ring * SPACING_M, north: Math.cos(bearing) * ring * SPACING_M };
    };
    const a = corner(side), b = corner(side + 1);
    return { east: a.east + (b.east - a.east) * step / ring, north: a.north + (b.north - a.north) * step / ring };
}

/** 全蜂巢的第 g 個席位（0 起算，含主持人席）→ 圈與圈內序號 */
function ringOf(globalIndex) {
    // 第 1～n 圈共有 3n(n+1) 席
    let ring = Math.max(1, Math.floor((Math.sqrt(9 + 12 * globalIndex) - 3) / 6));
    while (3 * ring * (ring + 1) <= globalIndex) ring++;
    while (ring > 1 && 3 * (ring - 1) * ring > globalIndex) ring--;
    return { ring, index: globalIndex - 3 * (ring - 1) * ring };
}

/** 一般使用者的席位序號（0 起算，0 = 第 4 圈第 1 號）→ 席位資料 */
function seat(ordinal) {
    const { ring, index } = ringOf(HOST_SEATS + ordinal);
    const off = seatOffset(ring, index);
    return { ordinal, ring, number: index + 1, code: `Q${ring}-${index + 1}`, east: off.east, north: off.north };
}

/** 離 101 往東、往北幾公尺 → 經緯度（蜂巢範圍內誤差可忽略） */
function toLatLng(east, north) {
    return {
        lat: ORIGIN.lat + north / METERS_PER_DEG_LAT,
        lng: ORIGIN.lng + east / (METERS_PER_DEG_LAT * Math.cos(ORIGIN.lat * Math.PI / 180)),
    };
}

function toLocal(lat, lng) {
    return {
        east: (lng - ORIGIN.lng) * METERS_PER_DEG_LAT * Math.cos(ORIGIN.lat * Math.PI / 180),
        north: (lat - ORIGIN.lat) * METERS_PER_DEG_LAT,
    };
}

/** 這個位置最近的席位代號（給審核示範對象用）；在主持人席範圍內就回傳 null */
function nearestCode(east, north) {
    const r = Math.max(1, Math.round(Math.hypot(east, north) / SPACING_M));
    let best = null, bestD = Infinity;
    for (let ring = Math.max(1, r - 1); ring <= r + 1; ring++) {
        for (let i = 0; i < 6 * ring; i++) {
            const o = seatOffset(ring, i);
            const d = Math.hypot(o.east - east, o.north - north);
            if (d < bestD) { bestD = d; best = { ring, number: i + 1 }; }
        }
    }
    return best && best.ring > HOST_RINGS ? `Q${best.ring}-${best.number}` : null;
}

// ---------- 位移 ----------

/**
 * 手機回報新的原始位移（相對入場那一刻，往東、往北幾公尺）。
 * 和上一次回報比較：時速不超過 25 公里才累加，超過就跳過這一段，停下來後從當下繼續算。
 * 回到入場的地方（homeEast/homeNorth，原始位移的座標）附近時，累計位移直接等於原始位移，回到自己的席位。
 * @returns {{east:number, north:number}} 新的累計位移
 */
function accumulate(state, raw, now) {
    if (finite(state.homeEast) && finite(state.homeNorth) &&
        Math.hypot(raw.east - state.homeEast, raw.north - state.homeNorth) <= HOME_RADIUS_M) {
        // 回到入場（或穿隧）那一刻的累計位移，加上離那裡多遠
        const baseE = finite(state.homeAccEast) ? state.homeAccEast : state.homeEast;
        const baseN = finite(state.homeAccNorth) ? state.homeAccNorth : state.homeNorth;
        return { east: baseE + raw.east - state.homeEast, north: baseN + raw.north - state.homeNorth };
    }
    const dE = raw.east - state.rawEast, dN = raw.north - state.rawNorth;
    const seconds = Math.max(0.001, (now - state.rawAt) / 1000);
    if (Math.hypot(dE, dN) / seconds > MAX_SPEED_MPS) return { east: state.east, north: state.north };
    return { east: state.east + dE, north: state.north + dN };
}

const finite = (v) => typeof v === 'number' && Number.isFinite(v);
/** 位移要是合理的數字（地球周長以內） */
function validDisplacement(east, north) {
    return finite(east) && finite(north) && Math.abs(east) < 2e7 && Math.abs(north) < 2e7;
}

// ---------- 不開放的地區 ----------

// 中國大陸的簡化外框（經度, 緯度），沿陸地國界外側、海上往外拉；台灣、金門、馬祖、澎湖、香港、澳門由 parallel.cityOf 扣掉。
// 邊界寧可多收一點鄰國的邊境，也不漏掉中國大陸。App 端 lib/quantum_world.dart 有同一份（測試會比對）。
const MAINLAND_CHINA = [
    [135.2, 48.5], [134.0, 47.4], [133.3, 45.6], [131.9, 45.3], [131.0, 44.9], [131.3, 44.0], [130.7, 42.3],
    [129.9, 43.0], [129.0, 42.3], [128.0, 41.9], [126.6, 41.7], [124.3, 39.8], [123.0, 37.6], [122.9, 35.0],
    [122.5, 32.0], [123.0, 30.5], [122.0, 28.5], [120.6, 27.0], [119.9, 25.5], [119.0, 24.9], [117.3, 23.4],
    [116.2, 22.4], [114.4, 22.1], [113.6, 21.9], [111.6, 21.3], [111.3, 19.6], [110.3, 17.8], [108.4, 18.1],
    [108.3, 20.6], [108.1, 21.5], [107.35, 21.65], [106.75, 22.0], [106.8, 22.9], [105.9, 23.0], [105.3, 23.4],
    [104.6, 22.9], [104.0, 22.6], [103.0, 22.8], [102.14, 22.45], [101.75, 22.45], [101.6, 21.2], [101.15, 21.1],
    [100.1, 21.45], [99.2, 22.1], [99.5, 22.9], [98.7, 23.9], [97.6, 23.9], [97.6, 24.8], [98.7, 25.8],
    [98.7, 27.5], [97.4, 28.3], [96.1, 29.5], [95.4, 29.1], [94.0, 29.0], [92.0, 27.8], [91.6, 27.9],
    [90.0, 28.3], [89.1, 27.3], [88.8, 28.1], [88.0, 27.9], [86.9, 27.9], [85.0, 28.6], [84.0, 29.2],
    [81.5, 30.4], [81.0, 30.2], [79.0, 31.3], [78.7, 32.5], [79.5, 32.7], [78.0, 35.5], [75.4, 36.9],
    [74.8, 37.2], [74.9, 38.4], [73.5, 39.4], [73.9, 39.8], [75.4, 40.6], [78.0, 41.1], [80.2, 42.2],
    [80.2, 44.9], [82.6, 45.2], [82.5, 46.4], [83.1, 47.2], [85.5, 47.0], [86.0, 48.5], [87.4, 49.2],
    [88.0, 49.3], [90.0, 47.9], [91.0, 46.6], [90.8, 45.3], [93.5, 44.9], [95.4, 44.2], [96.4, 42.7],
    [100.0, 42.6], [105.0, 41.6], [107.0, 42.3], [110.4, 42.8], [111.9, 43.75], [113.6, 44.8], [116.5, 46.0],
    [117.4, 46.6], [119.9, 46.75], [118.5, 47.9], [117.4, 47.7], [115.6, 47.9], [116.7, 49.9], [117.8, 49.6],
    [119.3, 50.3], [120.8, 52.6], [122.4, 53.6], [125.5, 53.2], [127.6, 50.3], [130.6, 48.9], [132.5, 47.8],
    [134.7, 48.4],
];

function insidePolygon(lat, lng, polygon) {
    let inside = false;
    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        const [xi, yi] = polygon[i], [xj, yj] = polygon[j];
        if ((yi > lat) !== (yj > lat) && lng < (xj - xi) * (lat - yi) / (yj - yi) + xi) inside = !inside;
    }
    return inside;
}

/** 這個位置是否在中國大陸（台灣、香港、澳門照常開放） */
function isMainlandChina(lat, lng) {
    if (!insidePolygon(lat, lng, MAINLAND_CHINA)) return false;
    return !parallel.cityOf(lat, lng); // 金門、馬祖、香港、澳門在外框裡，但屬於支援的城市
}

/** 入場時的真實位置 → 大區（只存大區，不存位置） */
function regionOf(lat, lng) {
    const city = parallel.cityOf(lat, lng);
    return (city && COUNTRY_REGION[city.country]) || 'other';
}

/** 各大區的匿名人數：人數太少的大區併進「其他」 */
function regionCounts(counts) {
    const out = {};
    let other = 0;
    REGIONS.forEach((r, i) => {
        const n = counts[i] || 0;
        if (r !== 'other' && n >= REGION_MIN) out[r] = n; else other += n;
    });
    if (other > 0) out.other = other;
    return out;
}

// ---------- 第二期：讓世界活起來 ----------

/** 最近的整點（毫秒）；台北是整數時區，整點和 UTC 相同 */
const nearestHour = (now) => Math.round(now / HOUR_MS) * HOUR_MS;
/** 報時編號：整點時間 / 1 小時 */
const chimeHour = (now) => Math.round(now / HOUR_MS);
/** 是否在報時期間（整點前 1 分鐘到整點後 30 秒） */
function inChime(now) {
    const d = now - nearestHour(now);
    return d >= -CHIME_BEFORE_MS && d <= CHIME_AFTER_MS;
}
/** 報時微光只在報時那 15 秒（前後各留幾秒）收 */
function chimeOpen(now) {
    const d = now - nearestHour(now);
    return d >= -5000 && d <= 25000;
}
/** 台北時間的點數：1 點 1 聲、23 點 23 聲、0 點 24 聲 */
function chimeStrikes(now) {
    const h = new Date(nearestHour(now) + 8 * HOUR_MS).getUTCHours();
    return h === 0 ? 24 : h;
}

/** 時區偏移（分鐘）：-12:00 ～ +14:00 的整數 */
const validTz = (v) => Number.isInteger(v) && v >= -720 && v <= 840;

/** 主人的當地時間 → 晝夜色調：清晨 5–8、白天 8–17、黃昏 17–20、深夜 20–5 */
function dayPart(tz, now) {
    const minutes = (((Math.floor(now / 60000) + tz) % 1440) + 1440) % 1440;
    const h = minutes / 60;
    return h >= 5 && h < 8 ? 'dawn' : h >= 8 && h < 17 ? 'day' : h >= 17 && h < 20 ? 'dusk' : 'night';
}

/** 量子同頻：最多 3 個主題（0～7），去掉重複和不認得的 */
function cleanTopics(list) {
    if (!Array.isArray(list)) return [];
    return [...new Set(list.filter((t) => Number.isInteger(t) && t >= 0 && t < TOPIC_COUNT))].slice(0, MAX_TOPICS);
}

// ---------- 世界視角 ----------

/** 雷達半徑（公里）：一般最多 5 公里，世界視角最多 60 公里 */
function clampRadius(km) {
    const r = Number(km);
    return Math.min(Math.max(Number.isFinite(r) ? r : RADAR_KM, 0.1), WORLD_MAX_KM);
}

module.exports = {
    ORIGIN, SPACING_M, HOST_RINGS, HOST_SEATS, GRACE_MS, VISIBLE_MS, MAX_SPEED_MPS, HOME_RADIUS_M, COLLAPSE_MS,
    RADAR_KM, WORLD_MAX_KM, WORLD_MAX_DOTS, MAX_RESULTS, REGION_MIN, STALE_SWEEP, KEY, REGIONS, MAINLAND_CHINA,
    seatOffset, ringOf, seat, toLatLng, toLocal, nearestCode, accumulate, validDisplacement,
    insidePolygon, isMainlandChina, regionOf, regionCounts, clampRadius,
    MAX_ENTANGLED, INVITE_MS, HOUR_MS, CHIME_FX_MAX, TOPIC_COUNT, MAX_TOPICS,
    nearestHour, chimeHour, inChime, chimeOpen, chimeStrikes, validTz, dayPart, cleanTopics,
};
