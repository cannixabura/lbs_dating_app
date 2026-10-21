// ============================================================================
// 集會：任何人都能以自己的位置為中心，開一場 5 公里內的活動。
// 活動以一個表情符號識別；把這個符號放進城市稱呼的人，就是參加者。
// 同一個符號在範圍重疊（中心相距 UNIQUE_RADIUS_KM 內）時不能同時使用；
// 前一場結束後，任何人都可以立刻接著用。
// ============================================================================

const { isDisallowed } = require('./contentfilter');
const citymood = require('./citymood');

const PARTICIPANT_RADIUS_KM = 5;
const UNIQUE_RADIUS_KM = 10;
const MAX_DURATION_MS = 24 * 60 * 60 * 1000;
const START_GRACE_MS = 10 * 60 * 1000; // 開始時間可以早於現在一點點（填表的時間）
const MAX_NAME_LENGTH = 20;
const MAX_ANNOUNCEMENT_LENGTH = 200;
const MAX_QUESTION_LENGTH = 40;
const MAX_ANSWER_LENGTH = 20;
const MIN_ANSWERS = citymood.MIN_PEOPLE; // 少於 10 人回答不給比例，和城市心情天氣同一條規則
// 檢舉：只隱藏被檢舉的那則公告，活動本身不自動結束（避免選舉等場合被對手惡意檢舉下架）
const REPORT_MIN_REPORTERS = 10;
const REPORT_PARTICIPANT_SHARE = 0.1;

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
const graphemes = (text) => Array.from(segmenter.segment(String(text || '')), (s) => s.segment);

const EMOJI_RE = /\p{Extended_Pictographic}|\p{Regional_Indicator}|⃣/u;

/** 一個字是不是表情符號（含旗幟、鍵帽、膚色與 ZWJ 組合，例如 🏳️‍🌈） */
function isEmoji(grapheme) {
    return EMOJI_RE.test(grapheme);
}

/**
 * 表情符號的識別碼：去掉變體選擇符 FE0F（❤️ 和 ❤ 視為同一個），其餘碼位以 "_" 相接。
 * App 端（lib/gathering.dart 的 emojiKey）用完全相同的規則。
 */
function emojiKey(grapheme) {
    return Array.from(String(grapheme))
        .map((ch) => ch.codePointAt(0))
        .filter((cp) => cp !== 0xfe0f)
        .map((cp) => cp.toString(16))
        .join('_');
}

/** 稱呼裡出現的所有表情符號識別碼 */
function emojiKeysIn(text) {
    return new Set(graphemes(text).filter(isEmoji).map(emojiKey));
}

/** 活動圖標必須剛好是一個表情符號 */
function validateEmoji(raw) {
    const g = graphemes(String(raw || '').trim());
    if (g.length !== 1 || !isEmoji(g[0])) return { error: '活動圖標要剛好是一個表情符號。' };
    return { emoji: g[0], key: emojiKey(g[0]) };
}

function cleanText(raw, max, emptyError, tooLongError) {
    const text = String(raw || '').trim().replace(/\s+/g, ' ');
    if (!text) return { error: emptyError };
    if (graphemes(text).length > max) return { error: tooLongError };
    if (isDisallowed(text)) return { error: '內容包含不適當的字詞或聯絡方式，請修改後再送出。' };
    return { text };
}

function validateName(raw) {
    return cleanText(raw, MAX_NAME_LENGTH, '請幫活動取個名字。', `活動名稱最多 ${MAX_NAME_LENGTH} 個字。`);
}

function validateAnnouncement(raw) {
    return cleanText(raw, MAX_ANNOUNCEMENT_LENGTH, '公告不能是空白的。', `公告最多 ${MAX_ANNOUNCEMENT_LENGTH} 個字。`);
}

function validateQuestion(raw) {
    return cleanText(raw, MAX_QUESTION_LENGTH, '問題不能是空白的。', `問題最多 ${MAX_QUESTION_LENGTH} 個字。`);
}

function validateAnswer(raw) {
    return cleanText(raw, MAX_ANSWER_LENGTH, '寫一句此刻的心情再送出。', `回答最多 ${MAX_ANSWER_LENGTH} 個字。`);
}

/** 開始與結束時間：開始在 24 小時內、結束晚於開始與現在、整場不超過 24 小時 */
function validateTimes(startAt, endAt, now) {
    if (!Number.isFinite(startAt) || !Number.isFinite(endAt)) return { error: '請設定開始與結束時間。' };
    if (startAt < now - START_GRACE_MS) return { error: '開始時間不能早於現在。' };
    if (startAt > now + MAX_DURATION_MS) return { error: '開始時間要在 24 小時內。' };
    if (endAt <= startAt) return { error: '結束時間要晚於開始時間。' };
    if (endAt - startAt > MAX_DURATION_MS) return { error: '活動最長 24 小時。' };
    return { startAt: Math.max(startAt, now - START_GRACE_MS), endAt };
}

function distanceKm(a, b) {
    const R = 6371;
    const dLat = ((b.lat - a.lat) * Math.PI) / 180;
    const dLng = ((b.lng - a.lng) * Math.PI) / 180;
    const s = Math.sin(dLat / 2) ** 2 + Math.cos((a.lat * Math.PI) / 180) * Math.cos((b.lat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(s));
}

/** 同一個符號、還沒結束、中心在 10 公里內的活動，就是衝突 */
function conflicts(activeSameEmoji, center) {
    return activeSameEmoji.some((g) => distanceKm(g, center) <= UNIQUE_RADIUS_KM);
}

/** 對外公開的中心點：到小數第 3 位（約 100 公尺），夠判斷 5 公里範圍 */
function publicCenter(lat, lng) {
    return { lat: Math.round(lat * 1000) / 1000, lng: Math.round(lng * 1000) / 1000 };
}

/** 全場提問的彙總：只有比例，少於 MIN_ANSWERS 人不給比例 */
function tally(moodKeys) {
    const total = moodKeys.length;
    if (total < MIN_ANSWERS) return { total, quiet: true };
    const counts = {};
    for (const k of moodKeys) counts[k] = (counts[k] || 0) + 1;
    const labels = Object.fromEntries([...citymood.CATEGORIES, citymood.OTHER].map((c) => [c.key, c.label]));
    const moods = Object.entries(counts)
        .map(([key, count]) => ({ key, label: labels[key] || '其他', count, percent: Math.round((count / total) * 100) }))
        .sort((a, b) => b.count - a.count);
    return { total, quiet: false, moods };
}

/** 隱藏一則公告需要的有效檢舉人數：10 人或參加人數的 10%，取較大者 */
function reportThreshold(participants) {
    return Math.max(REPORT_MIN_REPORTERS, Math.ceil(participants * REPORT_PARTICIPANT_SHARE));
}

/** 檢舉目標："gathering:<gid>:<announcementId>"（公告）或 "gathering:<gid>"（整場，只進人工審查） */
function parseReportTarget(target) {
    const m = /^gathering:([^:]+)(?::([^:]+))?$/.exec(String(target || ''));
    return m ? { gid: m[1], aid: m[2] || null } : null;
}

module.exports = {
    REPORT_MIN_REPORTERS, reportThreshold, parseReportTarget,
    PARTICIPANT_RADIUS_KM, UNIQUE_RADIUS_KM, MAX_DURATION_MS, MIN_ANSWERS,
    MAX_NAME_LENGTH, MAX_ANNOUNCEMENT_LENGTH, MAX_QUESTION_LENGTH, MAX_ANSWER_LENGTH,
    isEmoji, emojiKey, emojiKeysIn, validateEmoji, validateName, validateAnnouncement, validateQuestion, validateAnswer,
    validateTimes, distanceKm, conflicts, publicCenter, tally,
};
