// ============================================================================
// 平行宇宙：把其他城市開啟平行宇宙的人，投影到你所在城市的雷達上
//
// 投影（對稱）：你離自己城市中心的方位不變，距離換算成「城市半徑的幾成」，
// 再放到對方城市的同樣位置。例如你在台北中心東邊 3 成半徑處，
// 東京的人就會在東京中心東邊 3 成半徑處看到你。
// 城市半徑外（最多再 30 公里）的人往內摺到 0.9～1 成半徑之間；更遠的人不屬於任何城市。
//
// 位置不可還原：先在「原本的城市」把精確位置吸附到 500 公尺網格，
// 加上每人每天固定的偏移，才做投影。所以不論投影到哪座城市，
// 看到的位置都至少有 500 公尺的誤差，也不會顯示真實距離。
//
// 永遠不包含中國大陸。
// ============================================================================

const crypto = require('crypto');

const GEO_KEY = 'parallel_users'; // 只放開啟平行宇宙的人（精確座標，跟 city_users 一樣不對外）
const FOLD_KM = 30; // 城市半徑外多少公里內仍算這座城市
const CELL_METERS = 500;
const JITTER_FRACTION = 0.3; // 格內偏移最多 ±30%（±150 公尺）
const PER_CITY_RESULTS = 40;
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

/**
 * 把 from 城市裡的一個人投影到 to 城市。
 * @returns {{lat:number, lng:number}} 對外顯示的位置（已模糊化）
 */
function project(from, to, lat, lng, uid, now) {
    const { east, north } = fuzzInCity(from, lat, lng, uid, now);
    const d = Math.hypot(east, north);
    if (d === 0) return { lat: to.lat, lng: to.lng };
    // 半徑內照比例；半徑外摺進 0.9～1 成半徑
    const fraction = d <= from.radiusKm ? d / from.radiusKm : 0.9 + 0.1 * Math.min(1, (d - from.radiusKm) / Math.max(foldOf(from), 1));
    const scale = fraction * to.radiusKm / d;
    return fromLocalKm(to, east * scale, north * scale);
}

function distanceKm(a, b) {
    const dLat = (b.lat - a.lat) * METERS_PER_DEG_LAT;
    const dLng = (b.lng - a.lng) * METERS_PER_DEG_LAT * Math.cos(((a.lat + b.lat) / 2) * Math.PI / 180);
    return Math.hypot(dLat, dLng) / 1000;
}

/** 搜尋其他城市要用的指令（一城一個 GEOSEARCH，放進同一個 pipeline） */
function searchCommands(viewerCity) {
    const others = CITIES.filter((c) => c.id !== viewerCity.id);
    return {
        others,
        commands: others.map((c) => [
            'GEOSEARCH', GEO_KEY, 'FROMLONLAT', String(c.lng), String(c.lat),
            'BYRADIUS', String(c.radiusKm + foldOf(c)), 'km', 'ASC', 'COUNT', String(PER_CITY_RESULTS), 'WITHCOORD',
        ]),
    };
}

module.exports = {
    GEO_KEY, FOLD_KM, CELL_METERS, MAX_RESULTS, CITIES, CITY_BY_ID,
    cityOf, isMainlandBorderArea, project, distanceKm, searchCommands, toLocalKm,
};
