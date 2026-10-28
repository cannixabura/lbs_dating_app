// ============================================================================
// 店內留言本（心情據點第三階段）：只有人在店裡（約 40 公尺內）才讀得到、寫得了的留言
// 店家清單跟 App 一樣從網站下載（places/v1.json），伺服器不另外存一份
// ============================================================================

const { hasBlockedTerm, hasContactInfo } = require('./contentfilter');
const { metersBetween } = require('./timewhisper');

const MAX_LENGTH = 60;                 // 一則最多 60 個字（以肉眼看到的字數計）
const TTL_SECONDS = 30 * 24 * 60 * 60; // 30 天後消失
const READ_RADIUS_M = 40;              // 室內 GPS 常有 20～40 公尺誤差
const COOLDOWN_SECONDS = 24 * 60 * 60; // 同一個人在同一家店，每天 1 則
const MAX_SHOWN = 30;                  // 每家店顯示最新 30 則
const MAX_KEPT = 100;                  // 每家店最多保留 100 則（被隱藏、封鎖的扣掉後，仍有 30 則可顯示）
const PLACES_URL = 'https://mood-whisper-f7de9.web.app/places/v1.json';
const PLACES_CACHE_MS = 10 * 60 * 1000;

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
const visibleLength = (s) => Array.from(segmenter.segment(s)).length;

function validateText(raw) {
    const text = String(raw || '').trim();
    if (!text) return { error: '留言不能是空白的。' };
    if (visibleLength(text) > MAX_LENGTH) return { error: `留言最多 ${MAX_LENGTH} 個字。` };
    if (hasBlockedTerm(text)) return { error: '這則留言含有不適合的字詞，換個說法吧。' };
    if (hasContactInfo(text)) return { error: '留言是匿名的，不能留下電話、網址或社群帳號。' };
    return { text };
}

/** 能不能讀、寫這家店的留言本：店在清單上、人在 40 公尺內 */
function placeProblem(place, here) {
    if (!place) return '找不到這家店。';
    if (metersBetween(place, here) > READ_RADIUS_M) return `走進店裡（約 ${READ_RADIUS_M} 公尺內）才讀得到留言本。`;
    return null;
}

let cache = { at: 0, byId: null };

/** 店家清單（快取 10 分鐘）。下載失敗時沿用上一份 */
async function loadPlaces(now = Date.now(), fetchFn = fetch) {
    if (cache.byId && now - cache.at < PLACES_CACHE_MS) return cache.byId;
    try {
        const res = await fetchFn(PLACES_URL);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const json = await res.json();
        cache = { at: now, byId: new Map((json.places || []).map((p) => [p.id, { id: p.id, lat: p.lat, lng: p.lng }])) };
    } catch (e) {
        console.error('[留言本] 下載店家清單失敗：', e.message);
        if (!cache.byId) throw e;
    }
    return cache.byId;
}

/** 測試用：清掉快取 */
function resetCache() {
    cache = { at: 0, byId: null };
}

/** 給 App 的一則留言：從不回傳作者 uid，只告訴作者本人「這是你的」 */
function forReader(id, row, uid) {
    return { id, text: row.text, createdAt: parseInt(row.createdAt, 10), mine: row.author === uid };
}

module.exports = {
    MAX_LENGTH, TTL_SECONDS, READ_RADIUS_M, COOLDOWN_SECONDS, MAX_SHOWN, MAX_KEPT,
    validateText, placeProblem, loadPlaces, resetCache, forReader,
};
