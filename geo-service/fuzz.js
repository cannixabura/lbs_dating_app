// ============================================================================
// 位置模糊化：別人只會看到你所在的 100 公尺網格，而不是精確位置
//
// 為什麼不是「每次隨機偏移」：查詢 100 次取平均就能還原真實位置。
// 為什麼是網格：在同一格內怎麼移動，別人看到的都一樣，無法用平均或三角定位推算。
//   1. 位置吸附到 100m 網格的中心
//   2. 每人在格內加一個固定的小偏移（依 uid + 日期），避免同一格的人疊在一起
//   3. 遲滯：換格前必須離開原格中心超過 75m（越過邊界 25m），避免在邊界上來回跳動洩漏「正站在這條線上」
// 誤差上限約 92m（格角 71m ＋ 偏移 21m）；遲滯期間最多約 96m。精確座標只留在伺服器的地理索引中，用來計算 5 公里半徑。
// ============================================================================

const crypto = require('crypto');

const CELL_METERS = 100;
const JITTER_FRACTION = 0.15; // 格內偏移最多 ±15m
const HYSTERESIS_METERS = 75; // 離開原格中心超過此距離才換格
const METERS_PER_DEG_LAT = 111320;

function cellOf(lat, lng) {
    const latStep = CELL_METERS / METERS_PER_DEG_LAT;
    const row = Math.floor(lat / latStep);
    const centerLat = (row + 0.5) * latStep;
    // 經度格寬依該列的緯度計算，同一列的格子大小一致
    const lngStep = CELL_METERS / (METERS_PER_DEG_LAT * Math.cos(centerLat * Math.PI / 180));
    const col = Math.floor(lng / lngStep);
    return { row, col, centerLat, centerLng: (col + 0.5) * lngStep, latStep, lngStep };
}

function cellCenter(row, col) {
    const latStep = CELL_METERS / METERS_PER_DEG_LAT;
    const centerLat = (row + 0.5) * latStep;
    const lngStep = CELL_METERS / (METERS_PER_DEG_LAT * Math.cos(centerLat * Math.PI / 180));
    return { centerLat, centerLng: (col + 0.5) * lngStep, latStep, lngStep };
}

function metersBetween(lat1, lng1, lat2, lng2) {
    const dLat = (lat2 - lat1) * METERS_PER_DEG_LAT;
    const dLng = (lng2 - lng1) * METERS_PER_DEG_LAT * Math.cos(((lat1 + lat2) / 2) * Math.PI / 180);
    return Math.hypot(dLat, dLng);
}

// 依 uid + 日期產生 [-1, 1) 的固定值；同一天同一人永遠相同，所以無法靠多次查詢平均掉
function stableUnit(uid, day, axis) {
    const h = crypto.createHash('sha256').update(`${uid}|${day}|${axis}`).digest();
    return (h.readUInt32BE(0) / 0x100000000) * 2 - 1;
}

/**
 * @param {number} lat 精確緯度
 * @param {number} lng 精確經度
 * @param {string} uid
 * @param {{row:number,col:number}|null} previousCell 上次使用的格子（遲滯用）
 * @param {number} now ms
 * @returns {{lat:number, lng:number, row:number, col:number}} 對外公開的模糊座標與所在格
 */
function fuzzLocation(lat, lng, uid, previousCell, now) {
    let cell = cellOf(lat, lng);
    if (previousCell && (previousCell.row !== cell.row || previousCell.col !== cell.col)) {
        const prev = cellCenter(previousCell.row, previousCell.col);
        if (metersBetween(lat, lng, prev.centerLat, prev.centerLng) <= HYSTERESIS_METERS) {
            cell = { row: previousCell.row, col: previousCell.col, ...prev };
        }
    }
    const day = new Date(now).toISOString().slice(0, 10);
    return {
        lat: cell.centerLat + stableUnit(uid, day, 'lat') * JITTER_FRACTION * cell.latStep,
        lng: cell.centerLng + stableUnit(uid, day, 'lng') * JITTER_FRACTION * cell.lngStep,
        row: cell.row,
        col: cell.col,
    };
}

module.exports = { CELL_METERS, fuzzLocation, metersBetween, cellOf };
