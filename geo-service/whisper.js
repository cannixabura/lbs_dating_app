// ============================================================================
// 低語（城市漂流瓶）：在某個地方留一句話，之後經過的人會收到
// ============================================================================

const { cellOf } = require('./fuzz');
const { hasBlockedTerm, hasContactInfo } = require('./contentfilter');

const MAX_LENGTH = 60;               // 一則低語最多 60 個字（以肉眼看到的字數計）
const TTL_SECONDS = 7 * 24 * 60 * 60; // 7 天後消失
const MAX_ACTIVE_PER_USER = 3;       // 每人同時最多 3 則
const POST_COOLDOWN_SECONDS = 600;   // 每 10 分鐘最多留 1 則
const DISCOVER_RADIUS_KM = 0.3;      // 經過 300 公尺內才看得到
const MAX_RESULTS = 50;

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
const visibleLength = (s) => Array.from(segmenter.segment(s)).length;

/**
 * 檢查低語內容。回傳 null 表示可以送出，否則回傳給使用者看的錯誤訊息。
 */
function validateText(raw) {
    const text = String(raw || '').trim();
    if (!text) return { error: '低語不能是空白的。' };
    if (visibleLength(text) > MAX_LENGTH) return { error: `低語最多 ${MAX_LENGTH} 個字。` };
    if (hasBlockedTerm(text)) return { error: '這則低語含有不適合的字詞，換個說法吧。' };
    if (hasContactInfo(text)) return { error: '低語是匿名的，不能留下電話、網址或社群帳號。' };
    return { text };
}

/** 低語的位置對齊到 100 公尺網格中心：只透露「曾在這一帶」，不指出精確地點 */
function snapToCell(lat, lng) {
    const c = cellOf(lat, lng);
    return { lat: c.centerLat, lng: c.centerLng };
}

module.exports = {
    MAX_LENGTH, TTL_SECONDS, MAX_ACTIVE_PER_USER, POST_COOLDOWN_SECONDS, DISCOVER_RADIUS_KM, MAX_RESULTS,
    validateText, snapToCell,
};
