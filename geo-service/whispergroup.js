// ============================================================================
// 低語團：私人的團體（規格：docs/whisper-group-spec.md）
//
// 只有拿到團主 QR code（或分享連結）的人才能加入；外人看不到、搜不到。
// 團主可以集合呼叫、點名、放集合點；團員只回覆狀態，位置不會給團主。
// 20 人以內免費；第 21 人起要團主買「低語團 7 天方案」（group_pass_7d），付費後上限 100 人。
//
// 這個檔案只放純函式，方便測試；HTTP、Redis、推播在 index.js 的 exports.whisperGroup。
//
// Redis（團解散或過期就整組刪掉）
//   wgroup:{code}              團資料 JSON（host, name, color, createdAt, endsAt, paid, qrVer）
//   wgroup_members:{code}      hash  uid → JSON { no, note, joinedAt }
//   wgroup_of:{uid}            使用者目前所在的團代碼
//   wgroup_call:{code}         目前的集合呼叫 JSON（id, at, place, lat, lng, sentAt, remind: {uid: 次數}）
//   wgroup_acks:{code}         hash  uid → seen | ack（只屬於目前的集合呼叫）
//   wgroup_roll:{code}         目前的點名 JSON（id, sentAt）
//   wgroup_answers:{code}      hash  uid → here | 5min | help（只屬於目前的點名）
//   wgroup_active_calls        set   有進行中集合呼叫的團（每分鐘的提醒排程用）
//   wgroup_lost:{code}         hash  uid → JSON { lat, lng, at }：團員自己按「我迷路了」才傳一次位置給團主，30 分鐘後失效
// ============================================================================

const crypto = require('crypto');

const FREE_LIMIT = 20; // 含團主
const PAID_LIMIT = 100;
const MAX_DAYS = 7;
const PASS_PRODUCT = 'group_pass_7d';
const CODE_LENGTH = 8;
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; // 去掉容易看錯的 I L O 0 1
const MAX_NAME = 20;
const MAX_PLACE = 30;
const MAX_NOTE = 20;
const COLORS = ['violet', 'pink', 'blue', 'teal', 'green', 'gold', 'orange', 'red'];
const REMIND_EVERY_MS = 60 * 1000;
const REMIND_MAX = 3;
const CALL_LEAD_MAX_MS = 3 * 60 * 60 * 1000; // 集合時間最多 3 小時後
const CALL_LINGER_MS = 30 * 60 * 1000; // 集合時間過 30 分鐘，集合點自動消失
const ANSWERS = ['here', '5min', 'help'];
const LOST_TTL_MS = 30 * 60 * 1000; // 「我迷路了」的位置 30 分鐘後自動消失

const KEY = {
    group: (code) => `wgroup:${code}`,
    members: (code) => `wgroup_members:${code}`,
    of: (uid) => `wgroup_of:${uid}`,
    call: (code) => `wgroup_call:${code}`,
    acks: (code) => `wgroup_acks:${code}`,
    roll: (code) => `wgroup_roll:${code}`,
    answers: (code) => `wgroup_answers:${code}`,
    activeCalls: 'wgroup_active_calls',
    lost: (code) => `wgroup_lost:${code}`,
};

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
const clip = (text, n) => Array.from(segmenter.segment(String(text || '').replace(/\s+/g, ' ').trim()), (s) => s.segment).slice(0, n).join('');

/** 團代碼：8 碼，無法猜測。random 只在測試時換掉 */
function newCode(random = crypto.randomBytes) {
    const bytes = random(CODE_LENGTH);
    let code = '';
    for (let i = 0; i < CODE_LENGTH; i++) code += CODE_ALPHABET[bytes[i] % CODE_ALPHABET.length];
    return code;
}

const isCode = (s) => typeof s === 'string' && s.length === CODE_LENGTH && [...s].every((c) => CODE_ALPHABET.includes(c));

/** 台北時間某天 23:59:59.999 的時間戳 */
function taipeiDayEnd(ms) {
    const d = new Date(ms + 8 * 3600 * 1000);
    return Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), 23, 59, 59, 999) - 8 * 3600 * 1000;
}

/**
 * 開團：團名、團色、天數（1～7，含今天）。內容過濾在 index.js 做。
 * @returns {{ok: true, group: object} | {ok: false, code: string}}
 */
function makeGroup({ host, name, color, days }, now) {
    const n = clip(name, MAX_NAME);
    if (!n) return { ok: false, code: 'name' };
    if (!COLORS.includes(color)) return { ok: false, code: 'color' };
    const d = Math.round(Number(days));
    if (!Number.isFinite(d) || d < 1 || d > MAX_DAYS) return { ok: false, code: 'days' };
    return {
        ok: true,
        group: { host, name: n, color, createdAt: now, endsAt: taipeiDayEnd(now + (d - 1) * 86400000), paid: false, qrVer: 1 },
    };
}

const isOpen = (g, now) => !!g && now <= g.endsAt;
const memberLimit = (g) => (g && g.paid ? PAID_LIMIT : FREE_LIMIT);

/**
 * 能不能入團。count 是目前人數（含團主）。
 * @returns {{ok: true} | {ok: false, code: 'ended'|'qr'|'already'|'full'|'paid_full'}}
 */
function canJoin(g, { count, qrVer, alreadyMember }, now) {
    if (!isOpen(g, now)) return { ok: false, code: 'ended' };
    if (Number(qrVer) !== g.qrVer) return { ok: false, code: 'qr' }; // QR code 已經換新
    if (alreadyMember) return { ok: false, code: 'already' };
    if (count >= memberLimit(g)) return { ok: false, code: g.paid ? 'paid_full' : 'full' };
    return { ok: true };
}

/** 下一個團號：目前最大的團號 + 1（團主是 0 號，不佔團員編號） */
function nextNumber(members) {
    let max = 0;
    for (const m of members) if (Number(m.no) > max) max = Number(m.no);
    return max + 1;
}

/**
 * 集合呼叫：集合時間（現在到 3 小時後）、集合點說明、座標（團主放的集合點，不是任何人的位置）
 */
function makeCall({ at, place, lat, lng }, now) {
    const t = Number(at);
    if (!Number.isFinite(t) || t < now - 60 * 1000 || t > now + CALL_LEAD_MAX_MS) return { ok: false, code: 'time' };
    const la = Number(lat), lo = Number(lng);
    if (!Number.isFinite(la) || !Number.isFinite(lo) || Math.abs(la) > 90 || Math.abs(lo) > 180) return { ok: false, code: 'place' };
    return {
        ok: true,
        call: { id: `${now.toString(36)}${crypto.randomBytes(2).toString('hex')}`, at: Math.max(t, now), place: clip(place, MAX_PLACE), lat: la, lng: lo, sentAt: now, remind: {} },
    };
}

/** 集合點還要不要顯示（集合時間過 30 分鐘就收起來） */
const callLive = (call, now) => !!call && now <= call.at + CALL_LINGER_MS;

/**
 * 該再提醒誰：還沒按「收到」、提醒不到 3 次、距離上次提醒滿 60 秒、還沒到集合時間。團主不提醒。
 * @param {object} call  目前的集合呼叫（remind: {uid: 已提醒次數}，lastRemindAt）
 * @param {string[]} memberUids  團員（不含團主）
 * @param {object} acks  uid → seen | ack
 * @returns {string[]}
 */
function dueReminders(call, memberUids, acks, now) {
    if (!call || now >= call.at) return [];
    if (now - (call.lastRemindAt || call.sentAt) < REMIND_EVERY_MS) return [];
    return memberUids.filter((u) => (acks || {})[u] !== 'ack' && ((call.remind || {})[u] || 0) < REMIND_MAX);
}

/** 團主看到的集合狀態：收到／打開了沒回／沒反應，依沒反應 → 沒回 → 收到排序 */
function callRoster(members, acks) {
    const order = { none: 0, seen: 1, ack: 2 };
    const rows = members.map((m) => ({ ...m, state: (acks || {})[m.uid] === 'ack' ? 'ack' : (acks || {})[m.uid] === 'seen' ? 'seen' : 'none' }));
    rows.sort((a, b) => order[a.state] - order[b.state] || a.no - b.no);
    return { rows, acked: rows.filter((r) => r.state === 'ack').length, total: rows.length };
}

/** 團主看到的點名：需要幫忙 → 沒回 → 還要 5 分鐘 → 到了 */
function rollRoster(members, answers) {
    const order = { help: 0, none: 1, '5min': 2, here: 3 };
    const rows = members.map((m) => ({ ...m, answer: ANSWERS.includes((answers || {})[m.uid]) ? answers[m.uid] : 'none' }));
    rows.sort((a, b) => order[a.answer] - order[b.answer] || a.no - b.no);
    return { rows, here: rows.filter((r) => r.answer === 'here').length, help: rows.filter((r) => r.answer === 'help').length, total: rows.length };
}

const cleanNote = (note) => clip(note, MAX_NOTE);
const cleanPlace = (place) => clip(place, MAX_PLACE);

/**
 * 「我迷路了」：團員自己按下時傳一次位置（不會持續追蹤）
 * @returns {{ok: true, entry: object} | {ok: false, code: 'place'}}
 */
function makeLost({ lat, lng }, now) {
    const la = Number(lat), lo = Number(lng);
    if (!Number.isFinite(la) || !Number.isFinite(lo) || Math.abs(la) > 90 || Math.abs(lo) > 180) return { ok: false, code: 'place' };
    return { ok: true, entry: { lat: la, lng: lo, at: now } };
}

/** 團主看到的迷路名單：只留 30 分鐘內、還在團裡的人，最新的在最上面 */
function lostRoster(members, lostHash, now) {
    const rows = [];
    for (const m of members) {
        const raw = (lostHash || {})[m.uid];
        if (!raw) continue;
        let e;
        try { e = typeof raw === 'string' ? JSON.parse(raw) : raw; } catch (err) { continue; }
        if (!e || now - e.at > LOST_TTL_MS) continue;
        rows.push({ uid: m.uid, no: m.no, name: m.name || '', note: m.note || '', lat: e.lat, lng: e.lng, at: e.at });
    }
    return rows.sort((a, b) => b.at - a.at);
}

// ---------- 低語團 7 天方案（消耗型：一次購買＝一個團付費到解散） ----------

/** Apple 消耗型交易 → 收據代號 */
function applePass(tx, bundleId) {
    if (!tx || tx.bundleId !== bundleId) throw new Error('wrong_app');
    if (tx.revocationDate) throw new Error('revoked');
    if (tx.productId !== PASS_PRODUCT) throw new Error('unknown_product');
    if (!tx.transactionId) throw new Error('bad_tx');
    return { receipt: `a_${tx.transactionId}`, productId: tx.productId };
}

/** Google Play 購買資料 → 收據代號。purchaseState 0 = 已付款 */
function googlePass(productId, receiptKey, purchase) {
    if (productId !== PASS_PRODUCT) throw new Error('unknown_product');
    if (!purchase || purchase.purchaseState !== 0) throw new Error('not_paid');
    return { receipt: receiptKey, productId };
}

module.exports = {
    FREE_LIMIT, PAID_LIMIT, MAX_DAYS, PASS_PRODUCT, CODE_LENGTH, MAX_NAME, MAX_PLACE, MAX_NOTE, COLORS,
    REMIND_EVERY_MS, REMIND_MAX, CALL_LEAD_MAX_MS, CALL_LINGER_MS, ANSWERS, LOST_TTL_MS, KEY,
    newCode, isCode, taipeiDayEnd, makeGroup, isOpen, memberLimit, canJoin, nextNumber, makeCall, callLive,
    dueReminders, callRoster, rollRoster, makeLost, lostRoster, cleanNote, cleanPlace, applePass, googlePass,
};
