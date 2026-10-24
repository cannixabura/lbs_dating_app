// ============================================================================
// 城市燈塔：友善公廁（性別友善／無障礙／親子）
// 資料：環境部「全國公廁建檔資料」fac_p_07（政府資料開放授權條款第 1 版），每月同步一次。
// 原始資料一筆是一間廁所，同一棟樓會拆成很多筆；這裡依座標合併成「地點」，只留有友善設施的地點。
// 沒有開放時間：依場所類別與名稱推估「晚上可能有開」，App 上一律標成推估。
// ============================================================================

const SEARCH_RADIUS_M = 2000; // 和雷達的可視範圍一樣
const MAX_RESULTS = 40;
const MAX_ROOMS = 8;
const MIN_NAME_LENGTH = 4;
const REPORT_THRESHOLD = 3; // 同一個地點、同一種問題，3 個人回報就在 App 上標註
const REPORT_WINDOW_MS = 180 * 24 * 60 * 60 * 1000; // 只算半年內的回報
const REPORT_REASONS = {
    not_gender: '不是性別友善',
    closed: '晚上沒開',
    missing: '找不到這間廁所',
};

const TYPE_GENDER = '性別友善廁所';
const TYPE_ACCESSIBLE = '無障礙廁所';
const TYPE_FAMILY = '親子廁所';

// 晚上可能有開：交通場站、公園，以及名稱看得出來是 24 小時營業的場所
const NIGHT_CATEGORIES = new Set(['交通', '公園']);
const NIGHT_NAME = /加油站|超商|便利商店|7-ELEVEN|7-11|統一超商|全家|萊爾富|OK超商|捷運|車站|轉運|高鐵|臺鐵|台鐵|機場|公園|急診/i;

// 名稱尾巴的廁所種類（「台北101購物中心B1東-無障礙廁所」→「台北101購物中心B1東」）
const ROOM_SUFFIX = /[-－\s]*(性別友善廁所?|無障礙廁所?|親子廁所?|混合廁所?|男廁所?|女廁所?|廁所)\s*$/;

function inTaiwan(lat, lng) {
    return lat > 21.8 && lat < 26.5 && lng > 118 && lng < 122.1;
}

function siteKey(lat, lng) {
    return `${lat.toFixed(5)},${lng.toFixed(5)}`;
}

function cleanName(name) {
    return String(name || '').replace(ROOM_SUFFIX, '').trim();
}

// 一組名稱的共同開頭，當作地點名稱（「捷運台北101世貿站站內女」「…站內男」→「捷運台北101世貿站站內」）
function commonPrefix(names) {
    if (!names.length) return '';
    let p = names[0];
    for (const n of names.slice(1)) {
        let i = 0;
        while (i < p.length && i < n.length && p[i] === n[i]) i++;
        p = p.slice(0, i);
    }
    return p.replace(/[-－\s(（]+$/, '').trim();
}

function isNightLikely(rows) {
    return rows.some((r) => NIGHT_CATEGORIES.has(r.type2) || NIGHT_NAME.test(r.name || ''));
}

/**
 * 原始資料 → 地點。排除不合格、座標錯誤、沒有任何友善設施的地點。
 * id 用地點裡最小的建檔編號，每月重新同步時保持不變。
 */
function buildSites(records) {
    const groups = new Map();
    for (const r of records) {
        if (r.grade === '不合格') continue;
        const lat = parseFloat(r.latitude);
        const lng = parseFloat(r.longitude);
        if (!Number.isFinite(lat) || !Number.isFinite(lng) || !inTaiwan(lat, lng)) continue;
        const key = siteKey(lat, lng);
        if (!groups.has(key)) groups.set(key, { lat, lng, rows: [] });
        groups.get(key).rows.push(r);
    }
    const sites = [];
    for (const { lat, lng, rows } of groups.values()) {
        const gender = rows.some((r) => r.type === TYPE_GENDER);
        const accessible = rows.some((r) => r.type === TYPE_ACCESSIBLE);
        const family = rows.some((r) => r.type === TYPE_FAMILY || (parseInt(r.diaper, 10) || 0) > 0);
        if (!gender && !accessible && !family) continue;
        const names = rows.map((r) => String(r.name || '').trim()).filter(Boolean);
        // 共同開頭太短（同一點有兩個不同場所，例如「六合夜市」「六合二路」）就用友善廁所那一筆的名稱
        const special = rows.find((r) => [TYPE_GENDER, TYPE_ACCESSIBLE, TYPE_FAMILY].includes(r.type)) || rows[0];
        const prefix = commonPrefix(names);
        const name = (prefix.length >= MIN_NAME_LENGTH ? prefix : cleanName(special.name)) || '公廁';
        const rooms = rows
            .filter((r) => [TYPE_GENDER, TYPE_ACCESSIBLE, TYPE_FAMILY].includes(r.type))
            .map((r) => {
                const label = String(r.name || '').slice(name.length).replace(/^[-－\s]+/, '').trim();
                return label || r.type;
            });
        sites.push({
            id: rows.map((r) => r.number).filter(Boolean).sort()[0] || `S${siteKey(lat, lng).replace(/[.,]/g, '_')}`, // RTDB 的 key 不能有「.」
            name,
            address: rows[0].address || '',
            lat, lng,
            gender, accessible, family,
            night: isNightLikely(rows),
            rooms: [...new Set(rooms)].slice(0, MAX_ROOMS),
        });
    }
    return sites;
}

function validateReason(reason) {
    return Object.prototype.hasOwnProperty.call(REPORT_REASONS, reason);
}

/** beaconReports/{id} = {reason: {uid: timestamp}} → 達到門檻的問題 */
function flagsFrom(reports, now) {
    const flags = [];
    for (const reason of Object.keys(REPORT_REASONS)) {
        const recent = Object.values((reports && reports[reason]) || {}).filter((t) => now - t <= REPORT_WINDOW_MS);
        if (recent.length >= REPORT_THRESHOLD) flags.push(reason);
    }
    return flags;
}

module.exports = {
    SEARCH_RADIUS_M, MAX_RESULTS, REPORT_THRESHOLD, REPORT_WINDOW_MS, REPORT_REASONS,
    cleanName, commonPrefix, isNightLikely, buildSites, validateReason, flagsFrom,
};
