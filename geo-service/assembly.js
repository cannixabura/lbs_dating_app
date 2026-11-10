// ============================================================================
// 量子集會（規格：docs/quantum-assembly-spec.md）
//
// Q3：主持人坐進第 3 圈的保留席（Q3-1～Q3-18），參加者留在自己的席位自願加入。
// Q2：主持席在第 2 圈（Q2-1～Q2-12），另外有語音直播（LiveKit）和文字提問。
// 主持人可以發公告、觸發「量子應援」（所有參加者的光球在同一刻閃成同一個顏色）。
// 結束後只留下匿名的紀念卡數據：參加人數與各大區分布。
// 這裡只放規則（純函式），Redis / RTDB 的讀寫在 index.js。
// ============================================================================

const quantum = require('./quantum');

/** 方案：每場時長與人數上限；free 是每月免費一場 */
const PLANS = {
    free: { minutes: 30, cap: 50, tier: 'q3' },
    '1h': { minutes: 60, cap: 200, product: 'assembly_q3_1h', tier: 'q3' },
    '2h': { minutes: 120, cap: 1000, product: 'assembly_q3_2h', tier: 'q3' },
    q2_1h: { minutes: 60, cap: 200, product: 'assembly_q2_1h', tier: 'q2' },
    q2_2h: { minutes: 120, cap: 1000, product: 'assembly_q2_2h', tier: 'q2' },
};
const HOST_RING = 3;
const RING_SEATS = 6 * HOST_RING; // 第 3 圈 18 席
const FIRST_GLOBAL = 3 * (HOST_RING - 1) * HOST_RING; // 第 3 圈第 1 席在全蜂巢的序號（第 1～2 圈共 18 席）
// Q2 的主持席在第 2 圈（12 席）。席位序號從 100 起算（100～111），和第 3 圈的 0～17 分開，舊資料不用改
const Q2_RING = 2;
const Q2_SEATS = 6 * Q2_RING;
const Q2_BASE = 100;
const Q2_FIRST_GLOBAL = 3 * (Q2_RING - 1) * Q2_RING; // 第 2 圈第 1 席在全蜂巢的序號（第 1 圈 6 席）
const tierOf = (plan) => (PLANS[plan] ? PLANS[plan].tier : null);
// 語音直播
const MAX_SPEAKERS = 3; // 台上來賓（不含主持人）
const MAX_QUESTION = 80;
const QUESTION_GAP_MS = 60 * 1000;
const MAX_QUESTIONS_PER_USER = 5;
const AUDIO_TOKEN_TTL_S = 15 * 60;
const COLORS = ['#B79CFF', '#FF8AD8', '#7FD8FF', '#FFD27A', '#8AFFC8', '#FF7F7F'];
const EMOJIS = ['🎉', '🎵', '💜', '🌈', '🎂', '🌙', '✨', '🔥', '🌸', '🎄'];
const MAX_TITLE = 20;
const MAX_ANNOUNCE = 100;
const COUNTDOWNS = [0, 3, 5, 10];
const CHEER_GAP_MS = 10 * 1000;
const ANNOUNCE_GAP_MS = 30 * 1000;
const CHEER_LEAD_MS = 1500; // 立即應援也留 1.5 秒，讓大家的手機收到
const REGION_MIN = 3; // 少於 3 人的大區併入「其他」，避免找出特定的人
const KEY = {
    asm: (id) => `qasm:${id}`,
    members: (id) => `qasm_members:${id}`,
    removed: (id) => `qasm_removed:${id}`,
    regions: (id) => `qasm_regions:${id}`,
    joined: (id) => `qasm_joined:${id}`, // set：曾經加入過的人（紀念卡的參加人數，重複加入只算一次）
    free: (uid, month) => `qasm_free:${uid}:${month}`,
    memo: (uid) => `qasm_memo:${uid}`, // 主持人不在量子世界時結束的集會：下次入場顯示紀念卡
    host: (uid) => `qasm_host:${uid}`, // 主持中的集會 id（主持人離開量子世界也留著，回來時坐回主持席）
    speakers: (id) => `qasm_speakers:${id}`, // hash：台上來賓 uid → 暱稱
    hands: (id) => `qasm_hands:${id}`, // hash：舉手的人 uid → 時間
    qAsker: (id, qid) => `qasm_q:${id}:${qid}`, // 提問者 uid（只給檢舉處理用）
    qVotes: (id, qid) => `qasm_qvotes:${id}:${qid}`, // set：按讚的人
    qCount: (id, uid) => `qasm_qcount:${id}:${uid}`, // 這個人在這場問了幾題
    qLast: (id, uid) => `qasm_qlast:${id}:${uid}`, // 上次提問時間
    seats: 'qasm_seats', // hash：主持席序號（0～17）→ 集會 id
    active: 'qasm_active', // sorted set：集會 id → 結束時間
};

const planOfProduct = (productId) => Object.keys(PLANS).find((p) => PLANS[p].product === productId) || null;

/** 主持席：0～17 是第 3 圈（Q3），100～111 是第 2 圈（Q2）；回傳代號與離 101 的位移 */
function hostSeat(i) {
    const { ring, index } = quantum.ringOf(i >= Q2_BASE ? Q2_FIRST_GLOBAL + (i - Q2_BASE) : FIRST_GLOBAL + i);
    const off = quantum.seatOffset(ring, index);
    return { index: i, ring, number: index + 1, code: `Q${ring}-${index + 1}`, east: off.east, north: off.north };
}

/** 這一級第一個空的主持席；坐滿回傳 -1 */
function freeHostSeat(taken, tier = 'q3') {
    const used = new Set(Object.keys(taken || {}).map((k) => parseInt(k, 10)));
    const [from, n] = tier === 'q2' ? [Q2_BASE, Q2_SEATS] : [0, RING_SEATS];
    for (let i = from; i < from + n; i++) if (!used.has(i)) return i;
    return -1;
}

/** 台北時間的月份，例如 '2026-11'（每月免費一場用） */
function monthKey(now) {
    const t = new Date(now + 8 * 3600 * 1000);
    return `${t.getUTCFullYear()}-${String(t.getUTCMonth() + 1).padStart(2, '0')}`;
}

/** 主題：去掉換行、限制長度；空的回傳 '' */
function cleanTitle(s) {
    return Array.from(String(s || '').replace(/\s+/g, ' ').trim()).slice(0, MAX_TITLE).join('');
}

function cleanAnnounce(s) {
    return Array.from(String(s || '').replace(/[\r\n]+/g, ' ').trim()).slice(0, MAX_ANNOUNCE).join('');
}

const validColor = (c) => COLORS.includes(c);
const validEmoji = (e) => EMOJIS.includes(e);
const validCountdown = (n) => COUNTDOWNS.includes(n);

/** 應援的觸發時間（伺服器時間） */
const cheerFireAt = (now, countdown) => now + Math.max(CHEER_LEAD_MS, countdown * 1000);

/** 能不能加入：結束了、滿了、被移除、自己是主持人都不行 */
function canJoin({ status, count, cap, removed, isHost }) {
    if (status !== 'active') return { ok: false, code: 'ended' };
    if (isHost) return { ok: false, code: 'host' };
    if (removed) return { ok: false, code: 'removed' };
    if (count >= cap) return { ok: false, code: 'full' };
    return { ok: true };
}

/** 紀念卡的各大區分布：少於 REGION_MIN 的併入 other */
function regionSummary(raw) {
    const out = {};
    let other = 0;
    for (const r of quantum.REGIONS) {
        const n = parseInt((raw || {})[r] || '0', 10) || 0;
        if (r === 'other') { other += n; continue; }
        if (n >= REGION_MIN) out[r] = n; else other += n;
    }
    if (other > 0) out.other = other;
    return out;
}

/** 這場該不該結束：只看時間到（主持人離開量子世界、App 在背景或關掉都不會結束） */
function shouldEnd({ endAt }, now) {
    if (now >= endAt) return 'time';
    return null;
}

/** 主持中集會對照的保存秒數：結束時間後再留 1 天 */
function hostKeyTtl(endAt, now) {
    return String(Math.max(60, Math.ceil((endAt - now) / 1000) + 86400));
}

/** 一場集會最長 12 小時（含延長） */
const MAX_TOTAL_MS = 12 * 60 * 60 * 1000;

/**
 * 主持人用主辦券延長：結束時間往後加那張券的時數，人數上限取比較大的。
 * 已經結束、或延長後超過 12 小時就不行。
 */
function extend({ startAt, endAt, cap, status, tier }, plan, now) {
    const p = PLANS[plan];
    if (!p || plan === 'free') return { ok: false, code: 'bad_plan' };
    // Q3 券只能延長 Q3，Q2 券只能延長 Q2（舊資料沒有 tier 的當作 Q3）
    if (tier && p.tier !== tier) return { ok: false, code: 'bad_plan' };
    if (status !== 'active' || now >= endAt) return { ok: false, code: 'ended' };
    const newEnd = endAt + p.minutes * 60 * 1000;
    if (newEnd - startAt > MAX_TOTAL_MS) return { ok: false, code: 'too_long' };
    return { ok: true, endAt: newEnd, cap: Math.max(cap, p.cap) };
}

/** 提問：去掉換行、限制長度 */
function cleanQuestion(s) {
    return Array.from(String(s || '').replace(/[\r\n]+/g, ' ').replace(/\s+/g, ' ').trim()).slice(0, MAX_QUESTION).join('');
}

/** 能不能再問：每人每 60 秒一題、每場最多 5 題 */
function canAsk({ count, lastAt }, now) {
    if (count >= MAX_QUESTIONS_PER_USER) return { ok: false, code: 'too_many' };
    if (now - lastAt < QUESTION_GAP_MS) return { ok: false, code: 'too_soon' };
    return { ok: true };
}

/** 主持人能不能再邀一位上台 */
const canAddSpeaker = (current, isAlready) => isAlready || current < MAX_SPEAKERS;

/** LiveKit 房間名稱 */
const roomOf = (id) => `asm_${id}`;

module.exports = {
    MAX_TOTAL_MS, extend, tierOf, Q2_BASE, Q2_SEATS, MAX_SPEAKERS, MAX_QUESTION, QUESTION_GAP_MS, MAX_QUESTIONS_PER_USER, AUDIO_TOKEN_TTL_S,
    cleanQuestion, canAsk, canAddSpeaker, roomOf,
    PLANS, HOST_RING, RING_SEATS, COLORS, EMOJIS, MAX_TITLE, MAX_ANNOUNCE, COUNTDOWNS, CHEER_GAP_MS, ANNOUNCE_GAP_MS, REGION_MIN, KEY, hostKeyTtl,
    planOfProduct, hostSeat, freeHostSeat, monthKey, cleanTitle, cleanAnnounce, validColor, validEmoji, validCountdown, cheerFireAt, canJoin, regionSummary, shouldEnd,
};
