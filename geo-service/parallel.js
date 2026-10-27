// ============================================================================
// 平行宇宙：把其他城市開啟平行宇宙的人，投影到你所在城市的雷達上
//
// 誰看得到誰：兩個人在不同城市，只要「其中一人」開啟平行宇宙就看得到對方。
//   都沒開 → 互相看不到；只有 B 開 → A 只看到 B 一個人，B 看到 A 城市所有人；
//   都開 → 兩座城市重疊，都看到對方城市所有人。
//
// 投影（對稱）：你離自己城市中心的方位不變，距離換算成「城市半徑的幾成」，
// 再放到對方城市的同樣位置。例如你在台北中心東邊 3 成半徑處，
// 東京的人就會在東京中心東邊 3 成半徑處看到你。
// 城市半徑外還有一圈外圍（最多 30 公里，例如台北的桃園），對到對方城市的外圍，
// 所以住在外圍的人也看得到、也被看到；更遠的人不屬於任何城市。
//
// 位置不可還原：先在「原本的城市」把精確位置吸附到 500 公尺網格，
// 加上每人每天固定的偏移，才做投影。所以不論投影到哪座城市，
// 看到的位置都至少有 500 公尺的誤差，也不會顯示真實距離。
//
// 永遠不包含中國大陸。
// ============================================================================

const crypto = require('crypto');

const GEO_KEY = 'parallel_users'; // 只放開啟平行宇宙的人（精確座標，跟 city_users 一樣不對外）
const ALL_KEY = 'city_users'; // 開啟的人看得到其他城市所有人
const FOLD_KM = 30; // 城市半徑外多少公里內仍算這座城市（外圍）
const OUTER = 0.1; // 外圍在比例上佔多寬：半徑內 0～1，外圍 1～1.1
const CELL_METERS = 500;
const JITTER_FRACTION = 0.3; // 格內偏移最多 ±30%（±150 公尺）
const PER_CITY_RESULTS = 60;
const MAX_RESULTS = 30;
const METERS_PER_DEG_LAT = 111320;

// 中心點與半徑（公里）。新增城市只要加一列；名稱由 App 依語言顯示。
const CITIES = [
    { id: 'taipei', lat: 25.0478, lng: 121.5170, radiusKm: 15 },
    { id: 'taichung', lat: 24.1477, lng: 120.6736, radiusKm: 12 },
    { id: 'kaohsiung', lat: 22.6273, lng: 120.3014, radiusKm: 12 },
    { id: 'tokyo', lat: 35.6812, lng: 139.7671, radiusKm: 20 },
    { id: 'osaka', lat: 34.7025, lng: 135.4959, radiusKm: 15 },
    { id: 'seoul', lat: 37.5665, lng: 126.9780, radiusKm: 18 },
    { id: 'busan', lat: 35.1796, lng: 129.0756, radiusKm: 12 },
    // 香港、澳門緊鄰深圳、珠海：不往外摺，邊界另外排除
    { id: 'hongkong', lat: 22.3193, lng: 114.1694, radiusKm: 22, foldKm: 0 },
    { id: 'macau', lat: 22.1757, lng: 113.5560, radiusKm: 7, foldKm: 0 },
    { id: 'singapore', lat: 1.3521, lng: 103.8198, radiusKm: 15 },
    { id: 'kualalumpur', lat: 3.1390, lng: 101.6869, radiusKm: 15 },
    { id: 'jakarta', lat: -6.2088, lng: 106.8456, radiusKm: 18 },
    { id: 'hochiminh', lat: 10.7769, lng: 106.7009, radiusKm: 15 },
    { id: 'hanoi', lat: 21.0285, lng: 105.8542, radiusKm: 12 },
];
const CITY_BY_ID = Object.fromEntries(CITIES.map((c) => [c.id, c]));
const foldOf = (city) => city.foldKm ?? FOLD_KM;

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

/** 這個位置屬於哪座城市（最近、且在半徑＋30 公里內）；都不是就回傳 null */
function cityOf(lat, lng) {
    if (isMainlandBorderArea(lat, lng)) return null;
    let best = null;
    for (const city of CITIES) {
        const { east, north } = toLocalKm(city, lat, lng);
        const d = Math.hypot(east, north);
        if (d <= city.radiusKm + foldOf(city) && (!best || d / city.radiusKm < best.ratio)) best = { city, ratio: d / city.radiusKm };
    }
    return best ? best.city : null;
}

// 依 uid + 日期產生 [-1, 1) 的固定值：同一天同一人永遠相同，無法靠多次查詢平均掉
function stableUnit(uid, day, axis) {
    const h = crypto.createHash('sha256').update(`parallel|${uid}|${day}|${axis}`).digest();
    return (h.readUInt32BE(0) / 0x100000000) * 2 - 1;
}

/** 在原本的城市裡模糊化：吸附到 500 公尺網格中心，再加每人每天固定的偏移 */
function fuzzInCity(city, lat, lng, uid, now) {
    const { east, north } = toLocalKm(city, lat, lng);
    const cell = CELL_METERS / 1000;
    const day = new Date(now).toISOString().slice(0, 10);
    return {
        east: (Math.floor(east / cell) + 0.5 + stableUnit(uid, day, 'e') * JITTER_FRACTION) * cell,
        north: (Math.floor(north / cell) + 0.5 + stableUnit(uid, day, 'n') * JITTER_FRACTION) * cell,
    };
}

// 離中心的公里數 ↔ 比例：半徑內 0～1；外圍 1～1.1。
// 香港、澳門沒有外圍：別的城市外圍的人放到半徑 0.9～1 之間。
function toScale(city, d) {
    if (d <= city.radiusKm) return d / city.radiusKm;
    const fold = foldOf(city);
    return fold > 0 ? 1 + OUTER * Math.min(1, (d - city.radiusKm) / fold) : 1;
}

function fromScale(city, s) {
    if (s <= 1) return s * city.radiusKm;
    const fold = foldOf(city);
    return fold > 0 ? city.radiusKm + (s - 1) / OUTER * fold : city.radiusKm * (0.9 + (s - 1));
}

// 平面座標沿同一方位，從 from 的比例換到 to
function rescale(from, to, east, north) {
    const d = Math.hypot(east, north);
    if (d === 0) return { east: 0, north: 0 };
    const k = fromScale(to, toScale(from, d)) / d;
    return { east: east * k, north: north * k };
}

/**
 * 把 from 城市裡的一個人投影到 to 城市。
 * @returns {{lat:number, lng:number}} 對外顯示的位置（已模糊化）
 */
function project(from, to, lat, lng, uid, now) {
    const fuzzed = fuzzInCity(from, lat, lng, uid, now);
    const { east, north } = rescale(from, to, fuzzed.east, fuzzed.north);
    return fromLocalKm(to, east, north);
}

/**
 * 觀看者的雷達圈，反推回 target 城市是哪一塊：只要搜尋這一塊就夠了。
 * 取雷達圈邊上的點換算過去，再加上模糊化的誤差；搜到後仍逐一投影、精確過濾。
 */
function searchArea(viewerCity, target, lat, lng, radiusKm) {
    const here = toLocalKm(viewerCity, lat, lng);
    const center = rescale(viewerCity, target, here.east, here.north);
    let reach = 0;
    const SAMPLES = 24;
    for (let i = 0; i < SAMPLES; i++) {
        const a = (2 * Math.PI * i) / SAMPLES;
        const e = here.east + radiusKm * Math.cos(a), n = here.north + radiusKm * Math.sin(a);
        const d = Math.hypot(e, n);
        const images = [rescale(viewerCity, target, e, n)];
        // 香港、澳門的 0.9～1 成半徑也放著別的城市外圍的人
        if (foldOf(viewerCity) === 0 && d >= 0.9 * viewerCity.radiusKm) {
            const s = Math.min(toScale(viewerCity, d), 1) + OUTER;
            images.push({ east: e / d * fromScale(target, s), north: n / d * fromScale(target, s) });
        }
        for (const p of images) reach = Math.max(reach, Math.hypot(p.east - center.east, p.north - center.north));
    }
    return { ...fromLocalKm(target, center.east, center.north), radiusKm: reach * 1.1 + 1 };
}

function distanceKm(a, b) {
    const dLat = (b.lat - a.lat) * METERS_PER_DEG_LAT;
    const dLng = (b.lng - a.lng) * METERS_PER_DEG_LAT * Math.cos(((a.lat + b.lat) / 2) * Math.PI / 180);
    return Math.hypot(dLat, dLng) / 1000;
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
    const km = Math.max(...CITIES.map((c) => greatCircleKm(center, c) + c.radiusKm + foldOf(c))) + 50;
    return { ...center, km: Math.ceil(km) };
})();
const SNAPSHOT_LIMIT = 2000;

/** 取回所有開啟平行宇宙的人（沒開的人用；開啟的人通常不多，伺服器會短暫快取） */
function snapshotCommand() {
    return ['GEOSEARCH', GEO_KEY, 'FROMLONLAT', String(COVER.lng), String(COVER.lat), 'BYRADIUS', String(COVER.km), 'km', 'COUNT', String(SNAPSHOT_LIMIT), 'WITHCOORD'];
}

/**
 * 搜尋其他城市要用的指令（一城一個 GEOSEARCH，放進同一個 pipeline）。
 * key：開啟的人搜 city_users（所有人），沒開的人搜 parallel_users（只有開啟的人）。
 */
function searchCommands(viewerCity, lat, lng, radiusKm, key) {
    const others = CITIES.filter((c) => c.id !== viewerCity.id);
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
    GEO_KEY, ALL_KEY, FOLD_KM, CELL_METERS, MAX_RESULTS, CITIES, CITY_BY_ID,
    cityOf, isMainlandBorderArea, project, searchArea, distanceKm, searchCommands, snapshotCommand, toLocalKm, COVER,
};
