// ============================================================================
// 低語穿越：寫給未來的自己。只有作者看得到；一個月或一年後解封，
// 時間到推播一次，作者打開 App 回到 100 公尺內才能讀。
// ============================================================================

const DAY = 24 * 60 * 60 * 1000;
const DELAYS = { month: 30 * DAY, year: 365 * DAY };
const MAX_ACTIVE = 5;          // 每人同時最多 5 封（還沒讀的）
const OPEN_RADIUS_M = 100;
const MAX_LENGTH = 120;

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });

function validateText(raw) {
    const text = String(raw || '').trim();
    if (!text) return { error: '寫一句話給未來的自己。' };
    if (Array.from(segmenter.segment(text)).length > MAX_LENGTH) return { error: `最多 ${MAX_LENGTH} 個字。` };
    return { text };
}

function unlockAtFor(delay, now) {
    return DELAYS[delay] ? now + DELAYS[delay] : null;
}

function metersBetween(a, b) {
    const R = 6371000;
    const dLat = ((b.lat - a.lat) * Math.PI) / 180;
    const dLng = ((b.lng - a.lng) * Math.PI) / 180;
    const s = Math.sin(dLat / 2) ** 2 + Math.cos((a.lat * Math.PI) / 180) * Math.cos((b.lat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(s));
}

/** 能不能打開：時間到了、人在 100 公尺內 */
function openProblem(w, here, now) {
    if (!w) return '找不到這封低語穿越。';
    if (now < w.unlockAt) return '還沒到時間，再等等。';
    if (!here || metersBetween(here, w) > OPEN_RADIUS_M) return `回到那裡 ${OPEN_RADIUS_M} 公尺內就能打開。`;
    return null;
}

/** 給作者看的版本：還沒打開時不回傳內容 */
function forOwner(id, w, now) {
    const opened = !!w.openedAt;
    return {
        id, lat: w.lat, lng: w.lng, createdAt: w.createdAt, unlockAt: w.unlockAt,
        unlocked: now >= w.unlockAt, opened, ...(opened ? { text: w.text, openedAt: w.openedAt } : {}),
    };
}

module.exports = { DELAYS, MAX_ACTIVE, OPEN_RADIUS_M, MAX_LENGTH, validateText, unlockAtFor, metersBetween, openProblem, forOwner };
