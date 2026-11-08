// ============================================================================
// 量子集會（Q3 第一版，規格：docs/quantum-assembly-spec.md）
//
// 主持人坐進第 3 圈的保留席（Q3-1～Q3-18），參加者留在自己的席位自願加入。
// 主持人可以發公告、觸發「量子應援」（所有參加者的光球在同一刻閃成同一個顏色）。
// 結束後只留下匿名的紀念卡數據：參加人數與各大區分布。
// 這裡只放規則（純函式），Redis / RTDB 的讀寫在 index.js。
// ============================================================================

const quantum = require('./quantum');

/** 方案：每場時長與人數上限；free 是每月免費一場 */
const PLANS = {
    free: { minutes: 30, cap: 50 },
    '1h': { minutes: 60, cap: 200, product: 'assembly_q3_1h' },
    '2h': { minutes: 120, cap: 1000, product: 'assembly_q3_2h' },
};
const HOST_RING = 3;
const RING_SEATS = 6 * HOST_RING; // 第 3 圈 18 席
const FIRST_GLOBAL = 3 * (HOST_RING - 1) * HOST_RING; // 第 3 圈第 1 席在全蜂巢的序號（第 1～2 圈共 18 席）
const COLORS = ['#B79CFF', '#FF8AD8', '#7FD8FF', '#FFD27A', '#8AFFC8', '#FF7F7F'];
const EMOJIS = ['🎉', '🎵', '💜', '🌈', '🎂', '🌙', '✨', '🔥', '🌸', '🎄'];
const MAX_TITLE = 20;
const MAX_ANNOUNCE = 100;
const COUNTDOWNS = [0, 3, 5, 10];
const CHEER_GAP_MS = 10 * 1000;
const ANNOUNCE_GAP_MS = 30 * 1000;
const CHEER_LEAD_MS = 1500; // 立即應援也留 1.5 秒，讓大家的手機收到
const HOST_GONE_MS = quantum.GRACE_MS; // 主持人離開量子世界超過 3 分鐘就結束
const REGION_MIN = 3; // 少於 3 人的大區併入「其他」，避免找出特定的人
const KEY = {
    asm: (id) => `qasm:${id}`,
    members: (id) => `qasm_members:${id}`,
    removed: (id) => `qasm_removed:${id}`,
    regions: (id) => `qasm_regions:${id}`,
    joined: (id) => `qasm_joined:${id}`, // set：曾經加入過的人（紀念卡的參加人數，重複加入只算一次）
    free: (uid, month) => `qasm_free:${uid}:${month}`,
    seats: 'qasm_seats', // hash：主持席序號（0～17）→ 集會 id
    active: 'qasm_active', // sorted set：集會 id → 結束時間
};

const planOfProduct = (productId) => Object.keys(PLANS).find((p) => PLANS[p].product === productId) || null;

/** 第 3 圈第 i 席（0～17）：代號與離 101 的位移 */
function hostSeat(i) {
    const { ring, index } = quantum.ringOf(FIRST_GLOBAL + i);
    const off = quantum.seatOffset(ring, index);
    return { index: i, ring, number: index + 1, code: `Q${ring}-${index + 1}`, east: off.east, north: off.north };
}

/** 第一個空的主持席；坐滿回傳 -1 */
function freeHostSeat(taken) {
    const used = new Set(Object.keys(taken || {}).map((k) => parseInt(k, 10)));
    for (let i = 0; i < RING_SEATS; i++) if (!used.has(i)) return i;
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

/** 這場該不該結束（時間到、或主持人離開太久） */
function shouldEnd({ endAt, hostBeat }, now) {
    if (now >= endAt) return 'time';
    if (!hostBeat || now - hostBeat > HOST_GONE_MS) return 'host_gone';
    return null;
}

module.exports = {
    PLANS, HOST_RING, RING_SEATS, COLORS, EMOJIS, MAX_TITLE, MAX_ANNOUNCE, COUNTDOWNS, CHEER_GAP_MS, ANNOUNCE_GAP_MS, HOST_GONE_MS, REGION_MIN, KEY,
    planOfProduct, hostSeat, freeHostSeat, monthKey, cleanTitle, cleanAnnounce, validColor, validEmoji, validCountdown, cheerFireAt, canJoin, regionSummary, shouldEnd,
};
