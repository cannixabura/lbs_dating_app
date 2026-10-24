// ============================================================================
// 今晚的台灣心情（公開網頁 mood.html 的資料）
// 把 24 小時內所有人的心情，依最近的城市中心分成 18 個區域，各自彙總成比例。
// 只有比例、沒有任何個人資料；少於 MIN_PEOPLE 人的區域不給比例（和城市心情天氣同一條規則）。
// 示範對象不在 city_users 裡，不會被算進來；被檢舉隱藏的帳號也不算。
// ============================================================================

const citymood = require('./citymood');

// 區域中心（大約的市中心座標）。以「最近的中心」分區，邊界是概略的，網頁上有註明。
const REGIONS = [
    { name: '大台北', lat: 25.05, lng: 121.53 },
    { name: '桃園', lat: 24.99, lng: 121.30 },
    { name: '新竹', lat: 24.81, lng: 120.98 },
    { name: '苗栗', lat: 24.56, lng: 120.82 },
    { name: '台中', lat: 24.15, lng: 120.67 },
    { name: '彰化', lat: 24.07, lng: 120.54 },
    { name: '南投', lat: 23.91, lng: 120.68 },
    { name: '雲林', lat: 23.71, lng: 120.43 },
    { name: '嘉義', lat: 23.48, lng: 120.45 },
    { name: '台南', lat: 23.00, lng: 120.21 },
    { name: '高雄', lat: 22.63, lng: 120.30 },
    { name: '屏東', lat: 22.67, lng: 120.49 },
    { name: '宜蘭', lat: 24.75, lng: 121.75 },
    { name: '花蓮', lat: 23.99, lng: 121.60 },
    { name: '台東', lat: 22.76, lng: 121.14 },
    { name: '澎湖', lat: 23.57, lng: 119.58 },
    { name: '金門', lat: 24.43, lng: 118.32 },
    { name: '馬祖', lat: 26.16, lng: 119.95 },
];
const MAX_REGION_KM = 60; // 離所有區域中心都超過 60 公里（例如在國外）就不算進台灣

function distanceKm(a, b) {
    const R = 6371;
    const dLat = ((b.lat - a.lat) * Math.PI) / 180;
    const dLng = ((b.lng - a.lng) * Math.PI) / 180;
    const s = Math.sin(dLat / 2) ** 2 + Math.cos((a.lat * Math.PI) / 180) * Math.cos((b.lat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(s));
}

function regionOf(lat, lng) {
    let best = null;
    let bestKm = Infinity;
    for (const r of REGIONS) {
        const d = distanceKm({ lat, lng }, r);
        if (d < bestKm) { best = r; bestKm = d; }
    }
    return bestKm <= MAX_REGION_KM ? best.name : null;
}

/** 只留下要公開的欄位：總人數、是否安靜、各心情比例（不含人數，避免小區域被推算） */
function publicSummary(people, now) {
    const s = citymood.summarize(people, now);
    if (s.quiet) return { total: s.total, quiet: true };
    return { total: s.total, quiet: false, moods: s.moods.map(({ key, label, percent }) => ({ key, label, percent })) };
}

/**
 * @param {Array<{lat, lng, mood, lastSeen}>} people 所有人（已排除隱藏帳號）
 * @returns {{at, taiwan, regions: Object<string, summary>}}
 */
function aggregate(people, now) {
    const byRegion = {};
    const inTaiwan = [];
    for (const p of people) {
        const region = regionOf(p.lat, p.lng);
        if (!region) continue;
        inTaiwan.push(p);
        (byRegion[region] = byRegion[region] || []).push(p);
    }
    const regions = {};
    for (const r of REGIONS) regions[r.name] = publicSummary(byRegion[r.name] || [], now);
    return { at: now, taiwan: publicSummary(inTaiwan, now), regions };
}

/** 每小時留一筆趨勢：全台與各區最多的心情 */
function hourlyPoint(snapshot) {
    const top = (s) => (s.quiet ? { total: s.total, quiet: true } : { total: s.total, top: s.moods[0].key, percent: s.moods[0].percent });
    const regions = {};
    for (const [name, s] of Object.entries(snapshot.regions)) regions[name] = top(s);
    return { at: snapshot.at, taiwan: snapshot.taiwan.quiet ? { total: snapshot.taiwan.total, quiet: true } : { total: snapshot.taiwan.total, moods: snapshot.taiwan.moods }, regions };
}

module.exports = { REGIONS, MAX_REGION_KM, regionOf, aggregate, hourlyPoint };
