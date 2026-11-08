// ============================================================================
// 旅行團（TourChip）：給領隊、導遊用的獨立 App（規格：旅行團 產品規格，2026-11-08）
//
// 以低語團（whispergroup.js）為基礎，另外加上：
//   共同團主（最多 2 位）、分組（分車）、公告、行程表（每個集合點用當地時區）、團購券。
// 低語團完全不動；這裡的 Redis 都用 tgroup* 開頭，兩邊互不影響。
//
// 這個檔案只放純函式，方便測試；HTTP、Redis、推播在 tourgroup_api.js。
//
// Redis（團解散或過期就整組刪掉）
//   tgroup:{code}              團資料 JSON（host, cohosts, name, color, tz, endDate, endsAt, createdAt, paid, qrVer, subs）
//   tgroup_members:{code}      hash  uid → JSON { no, note, sub, joinedAt }
//   tgroup_of:{uid}            使用者目前所在的團代碼
//   tgroup_call:{code}         目前的集合呼叫 JSON（id, at, tz, place, lat, lng, sub, targets, sentAt, remind）
//   tgroup_acks:{code}         hash  uid → seen | ack
//   tgroup_roll:{code}         目前的點名 JSON（id, sentAt, sub, targets）
//   tgroup_answers:{code}      hash  uid → here | 5min | help
//   tgroup_lost:{code}         hash  uid → JSON { lat, lng, at }（團員自己按「我迷路了」才有，30 分鐘失效）
//   tgroup_ann:{code}          公告 JSON 陣列（最新在前，最多 20 則）
//   tgroup_stops:{code}        行程表 JSON 陣列（依時間排序）
//   tgroup_active_calls        set   有進行中集合呼叫的團
//   tvoucher:{code}            團購券 JSON（buyer, receipt, createdAt, usedBy, usedAt）
//   tvouchers_of:{uid}         set   這個人買的團購券
// ============================================================================

const crypto = require('crypto');

const FREE_LIMIT = 20; // 含團主、共同團主
const PAID_LIMIT = 100;
const MAX_DAYS = 7;
const PASS_PRODUCT = 'tour_pass_7d';
const BUNDLE_ID = 'com.softchip.tourchip';
const PLAY_PACKAGE = 'com.softchip.tourchip';
const LINK_BASE = 'https://tourchip.web.app';
const CODE_LENGTH = 8;
const VOUCHER_LENGTH = 10;
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
const MAX_NAME = 20;
const MAX_PLACE = 30;
const MAX_NOTE = 20;
const MAX_COHOSTS = 2;
const MAX_SUBS = 6;
const MAX_SUB_NAME = 10;
const MAX_ANN = 20;
const MAX_ANN_LEN = 200;
const MAX_STOPS = 60;
const COLORS = ['violet', 'pink', 'blue', 'teal', 'green', 'gold', 'orange', 'red'];
const REMIND_EVERY_MS = 60 * 1000;
const REMIND_MAX = 3;
const CALL_LEAD_MAX_MS = 3 * 60 * 60 * 1000;
const CALL_LINGER_MS = 30 * 60 * 1000;
const ANSWERS = ['here', '5min', 'help'];
const LOST_TTL_MS = 30 * 60 * 1000;
const VOUCHER_TTL_DAYS = 400;
const DEFAULT_TZ = 'Asia/Taipei';

const KEY = {
    group: (code) => `tgroup:${code}`,
    members: (code) => `tgroup_members:${code}`,
    of: (uid) => `tgroup_of:${uid}`,
    call: (code) => `tgroup_call:${code}`,
    acks: (code) => `tgroup_acks:${code}`,
    roll: (code) => `tgroup_roll:${code}`,
    answers: (code) => `tgroup_answers:${code}`,
    lost: (code) => `tgroup_lost:${code}`,
    ann: (code) => `tgroup_ann:${code}`,
    stops: (code) => `tgroup_stops:${code}`,
    activeCalls: 'tgroup_active_calls',
    lang: 'tgroup_lang', // 每位使用者的語言（推播用；旅行團帳號沒有城市低語的 user_data）
    voucher: (v) => `tvoucher:${v}`,
    vouchersOf: (uid) => `tvouchers_of:${uid}`,
};

const segmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
const clip = (text, n) => Array.from(segmenter.segment(String(text || '').replace(/\s+/g, ' ').trim()), (s) => s.segment).slice(0, n).join('');
/** 公告可以換行：只把連續空白收成一個，保留換行（最多連續兩個） */
const clipText = (text, n) => Array.from(segmenter.segment(String(text || '').replace(/[ \t]+/g, ' ').replace(/\n{3,}/g, '\n\n').trim()), (s) => s.segment).slice(0, n).join('');

function randomCode(len, random = crypto.randomBytes) {
    const bytes = random(len);
    let code = '';
    for (let i = 0; i < len; i++) code += CODE_ALPHABET[bytes[i] % CODE_ALPHABET.length];
    return code;
}
const newCode = (random) => randomCode(CODE_LENGTH, random);
const newVoucherCode = (random) => randomCode(VOUCHER_LENGTH, random);
const isCodeOf = (len) => (s) => typeof s === 'string' && s.length === len && [...s].every((c) => CODE_ALPHABET.includes(c));
const isCode = isCodeOf(CODE_LENGTH);
const isVoucherCode = isCodeOf(VOUCHER_LENGTH);

// ---------- 時區 ----------

/** IANA 時區名稱是否有效（例如 Asia/Tokyo） */
function validTz(tz) {
    if (typeof tz !== 'string' || !tz || tz.length > 64) return false;
    try { new Intl.DateTimeFormat('en-US', { timeZone: tz }); return true; } catch (e) { return false; }
}

function tzParts(ms, tz) {
    const dtf = new Intl.DateTimeFormat('en-US', { timeZone: tz, hourCycle: 'h23', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' });
    const p = {};
    for (const x of dtf.formatToParts(new Date(ms))) if (x.type !== 'literal') p[x.type] = Number(x.value);
    if (p.hour === 24) p.hour = 0;
    return p;
}

/** 某時區在某一刻比 UTC 快幾分鐘（台北 = 480） */
function tzOffsetMin(tz, ms) {
    const p = tzParts(ms, tz);
    const asUtc = Date.UTC(p.year, p.month - 1, p.day, p.hour, p.minute, p.second);
    return Math.round((asUtc - Math.floor(ms / 1000) * 1000) / 60000);
}

/** 某一刻在某時區的日期 'YYYY-MM-DD' */
function localDate(ms, tz) {
    const p = tzParts(ms, tz);
    return `${p.year}-${String(p.month).padStart(2, '0')}-${String(p.day).padStart(2, '0')}`;
}

/** 某時區某天 23:59:59.999 的時間戳 */
function endOfLocalDate(date, tz) {
    const [y, m, d] = String(date).split('-').map(Number);
    const guess = Date.UTC(y, m - 1, d, 23, 59, 59, 999);
    let t = guess - tzOffsetMin(tz, guess) * 60000;
    t = guess - tzOffsetMin(tz, t) * 60000; // 夏令時間交界再校正一次
    return t;
}

/** 某一刻在某時區的「HH:MM」 */
function localHm(ms, tz) {
    const p = tzParts(ms, tz);
    return `${String(p.hour).padStart(2, '0')}:${String(p.minute).padStart(2, '0')}`;
}

/** 日期加天數（純日期運算，不受時區影響） */
function addDays(date, n) {
    const [y, m, d] = String(date).split('-').map(Number);
    const t = new Date(Date.UTC(y, m - 1, d + n));
    return `${t.getUTCFullYear()}-${String(t.getUTCMonth() + 1).padStart(2, '0')}-${String(t.getUTCDate()).padStart(2, '0')}`;
}

/**
 * 行程結束時間：結束日 23:59，以最後一個集合點的當地時區為準；還沒有行程表就用開團時的時區
 */
function computeEndsAt(g, stops) {
    const last = (stops || []).length ? stops[stops.length - 1] : null;
    const tz = last && validTz(last.tz) ? last.tz : g.tz;
    return endOfLocalDate(g.endDate, tz);
}

// ---------- 開團、入團 ----------

/**
 * 開團：團名、團色、天數（1～7，含開團當天）、開團的人手機的時區
 * @returns {{ok: true, group: object} | {ok: false, code: string}}
 */
function makeGroup({ host, name, color, days, tz }, now) {
    const n = clip(name, MAX_NAME);
    if (!n) return { ok: false, code: 'name' };
    if (!COLORS.includes(color)) return { ok: false, code: 'color' };
    const d = Math.round(Number(days));
    if (!Number.isFinite(d) || d < 1 || d > MAX_DAYS) return { ok: false, code: 'days' };
    const zone = validTz(tz) ? tz : DEFAULT_TZ;
    const startDate = localDate(now, zone);
    const g = { host, cohosts: [], name: n, color, tz: zone, startDate, endDate: addDays(startDate, d - 1), createdAt: now, paid: false, qrVer: 1, subs: [] };
    g.endsAt = computeEndsAt(g, []);
    return { ok: true, group: g };
}

const isOpen = (g, now) => !!g && now <= g.endsAt;
const memberLimit = (g) => (g && g.paid ? PAID_LIMIT : FREE_LIMIT);
const isStaff = (g, uid) => !!g && (g.host === uid || (g.cohosts || []).includes(uid));
const roleOf = (g, uid) => (!g ? null : g.host === uid ? 'host' : (g.cohosts || []).includes(uid) ? 'cohost' : 'member');

function canJoin(g, { count, qrVer, alreadyMember }, now) {
    if (!isOpen(g, now)) return { ok: false, code: 'ended' };
    if (Number(qrVer) !== g.qrVer) return { ok: false, code: 'qr' };
    if (alreadyMember) return { ok: false, code: 'already' };
    if (count >= memberLimit(g)) return { ok: false, code: g.paid ? 'paid_full' : 'full' };
    return { ok: true };
}

function nextNumber(members) {
    let max = 0;
    for (const m of members) if (Number(m.no) > max) max = Number(m.no);
    return max + 1;
}

// ---------- 共同團主、分組 ----------

/** 把團員升為共同團主（最多 2 位；團主自己不算） */
function addCohost(g, uid, members) {
    const cur = g.cohosts || [];
    if (uid === g.host || !members.some((m) => m.uid === uid)) return { ok: false, code: 'bad_request' };
    if (cur.includes(uid)) return { ok: true, group: g };
    if (cur.length >= MAX_COHOSTS) return { ok: false, code: 'cohost_full' };
    return { ok: true, group: { ...g, cohosts: [...cur, uid] } };
}

const removeCohost = (g, uid) => ({ ...g, cohosts: (g.cohosts || []).filter((u) => u !== uid) });

/** 分組名稱：最多 6 組、每組 10 字、不能重複、不能空白 */
function cleanSubs(names) {
    if (!Array.isArray(names)) return { ok: false, code: 'bad_request' };
    const out = [];
    for (const raw of names) {
        const n = clip(raw, MAX_SUB_NAME);
        if (n && !out.includes(n)) out.push(n);
    }
    if (out.length > MAX_SUBS) return { ok: false, code: 'too_many' };
    return { ok: true, subs: out };
}

/** 分組編號是否有效；null／-1 代表全團 */
function validSub(g, sub) {
    if (sub === null || sub === undefined || sub === -1) return true;
    return Number.isInteger(sub) && sub >= 0 && sub < (g.subs || []).length;
}
const normSub = (sub) => (sub === null || sub === undefined || sub === -1 ? null : sub);

/** 這次要通知誰：不含團主與共同團主；指定分組時只通知那一組 */
function targetUids(g, members, sub) {
    const s = normSub(sub);
    return members.filter((m) => !isStaff(g, m.uid) && (s === null || m.sub === s)).map((m) => m.uid);
}

// ---------- 集合、點名、迷路 ----------

function badCoord(lat, lng) {
    const la = Number(lat), lo = Number(lng);
    return !Number.isFinite(la) || !Number.isFinite(lo) || Math.abs(la) > 90 || Math.abs(lo) > 180;
}

/**
 * 集合呼叫：集合時間（現在到 3 小時後）、集合點的時區、說明、座標（團主放的集合點）、分組
 */
function makeCall({ at, tz, place, lat, lng, sub, targets }, now) {
    const t = Number(at);
    if (!Number.isFinite(t) || t < now - 60 * 1000 || t > now + CALL_LEAD_MAX_MS) return { ok: false, code: 'time' };
    if (badCoord(lat, lng)) return { ok: false, code: 'place' };
    return {
        ok: true,
        call: {
            id: `${now.toString(36)}${crypto.randomBytes(2).toString('hex')}`,
            at: Math.max(t, now), tz: validTz(tz) ? tz : DEFAULT_TZ, place: clip(place, MAX_PLACE),
            lat: Number(lat), lng: Number(lng), sub: normSub(sub), targets: targets || [], sentAt: now, remind: {},
        },
    };
}

const callLive = (call, now) => !!call && now <= call.at + CALL_LINGER_MS;

/** 該再提醒誰：這次集合的對象中，還沒按「收到」、提醒不到 3 次、距上次滿 60 秒、還沒到集合時間 */
function dueReminders(call, memberUids, acks, now) {
    if (!call || now >= call.at) return [];
    if (now - (call.lastRemindAt || call.sentAt) < REMIND_EVERY_MS) return [];
    const targets = new Set(call.targets && call.targets.length ? call.targets : memberUids);
    return memberUids.filter((u) => targets.has(u) && (acks || {})[u] !== 'ack' && ((call.remind || {})[u] || 0) < REMIND_MAX);
}

function callRoster(members, acks) {
    const order = { none: 0, seen: 1, ack: 2 };
    const rows = members.map((m) => ({ ...m, state: (acks || {})[m.uid] === 'ack' ? 'ack' : (acks || {})[m.uid] === 'seen' ? 'seen' : 'none' }));
    rows.sort((a, b) => order[a.state] - order[b.state] || a.no - b.no);
    return { rows, acked: rows.filter((r) => r.state === 'ack').length, total: rows.length };
}

function rollRoster(members, answers) {
    const order = { help: 0, none: 1, '5min': 2, here: 3 };
    const rows = members.map((m) => ({ ...m, answer: ANSWERS.includes((answers || {})[m.uid]) ? answers[m.uid] : 'none' }));
    rows.sort((a, b) => order[a.answer] - order[b.answer] || a.no - b.no);
    return {
        rows, total: rows.length,
        here: rows.filter((r) => r.answer === 'here').length,
        late: rows.filter((r) => r.answer === '5min').length,
        help: rows.filter((r) => r.answer === 'help').length,
    };
}

function makeLost({ lat, lng }, now) {
    if (badCoord(lat, lng)) return { ok: false, code: 'place' };
    return { ok: true, entry: { lat: Number(lat), lng: Number(lng), at: now } };
}

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

// ---------- 公告 ----------

function makeAnnouncement({ text, sub }, by, now) {
    const t = clipText(text, MAX_ANN_LEN);
    if (!t) return { ok: false, code: 'empty' };
    return { ok: true, ann: { id: `${now.toString(36)}${crypto.randomBytes(2).toString('hex')}`, text: t, sub: normSub(sub), by, at: now } };
}

/** 新公告放最前面，最多留 20 則 */
const pushAnnouncement = (list, ann) => [ann, ...(list || [])].slice(0, MAX_ANN);

/** 團員看得到的公告：全團的，加上自己那一組的 */
const visibleAnnouncements = (list, sub, staff) => (list || []).filter((a) => staff || a.sub === null || a.sub === sub);

// ---------- 行程表 ----------

/**
 * 行程表的一個集合點：時間、當地時區、說明、座標（可以不填）、分組
 * 時間要落在開團日前一天到行程結束日之間
 */
function makeStop({ id, at, tz, place, lat, lng, sub }, g, now) {
    const t = Number(at);
    const lo = endOfLocalDate(addDays(g.startDate, -1), g.tz) - 86400000;
    const hi = endOfLocalDate(addDays(g.endDate, 1), g.tz);
    if (!Number.isFinite(t) || t < lo || t > hi) return { ok: false, code: 'time' };
    if (!validTz(tz)) return { ok: false, code: 'tz' };
    const p = clip(place, MAX_PLACE);
    if (!p) return { ok: false, code: 'place' };
    const hasCoord = lat !== undefined && lat !== null && lng !== undefined && lng !== null;
    if (hasCoord && badCoord(lat, lng)) return { ok: false, code: 'place' };
    if (!validSub(g, sub)) return { ok: false, code: 'bad_request' };
    return {
        ok: true,
        stop: {
            id: typeof id === 'string' && /^[a-z0-9]{4,20}$/.test(id) ? id : `${now.toString(36)}${crypto.randomBytes(2).toString('hex')}`,
            at: t, tz, place: p, lat: hasCoord ? Number(lat) : null, lng: hasCoord ? Number(lng) : null, sub: normSub(sub),
        },
    };
}

/** 新增或取代同 id 的集合點，依時間排序；最多 60 個 */
function upsertStop(stops, stop) {
    const list = (stops || []).filter((s) => s.id !== stop.id);
    if (list.length >= MAX_STOPS) return { ok: false, code: 'too_many' };
    list.push(stop);
    list.sort((a, b) => a.at - b.at);
    return { ok: true, stops: list };
}

const removeStop = (stops, id) => (stops || []).filter((s) => s.id !== id);

// ---------- 7 天方案、團購券 ----------

function applePass(tx, bundleId = BUNDLE_ID) {
    if (!tx || tx.bundleId !== bundleId) throw new Error('wrong_app');
    if (tx.revocationDate) throw new Error('revoked');
    if (tx.productId !== PASS_PRODUCT) throw new Error('unknown_product');
    if (!tx.transactionId) throw new Error('bad_tx');
    return { receipt: `ta_${tx.transactionId}`, productId: tx.productId };
}

function googlePass(productId, receiptKey, purchase) {
    if (productId !== PASS_PRODUCT) throw new Error('unknown_product');
    if (!purchase || purchase.purchaseState !== 0) throw new Error('not_paid');
    return { receipt: `t${receiptKey}`, productId };
}

/** 團購券：買的人、這張券來自哪一筆購買 */
const makeVoucher = (buyer, receipt, now) => ({ buyer, receipt, createdAt: now, usedBy: null, usedAt: null });

/** 能不能把券用在這一團 */
function canRedeem(v, g, now) {
    if (!v) return { ok: false, code: 'voucher_not_found' };
    if (v.usedBy) return { ok: false, code: 'voucher_used' };
    if (now - v.createdAt > VOUCHER_TTL_DAYS * 86400000) return { ok: false, code: 'voucher_expired' };
    if (g.paid) return { ok: false, code: 'already_paid' };
    return { ok: true };
}

// ---------- 連結 ----------

const groupLink = (code, qrVer) => `${LINK_BASE}/g/${code}?v=${qrVer}`;
const voucherLink = (v) => `${LINK_BASE}/v/${v}`;

/** 集合呼叫推播的文字（繁中原文，送出時翻成收件人的語言） */
function callText(call, now) {
    const mins = Math.max(0, Math.round((call.at - now) / 60000));
    const hm = localHm(call.at, call.tz || DEFAULT_TZ);
    if (call.place) return mins > 0 ? `${hm} 到「${call.place}」集合，還有 ${mins} 分鐘` : `現在到「${call.place}」集合`;
    return mins > 0 ? `${hm} 集合，還有 ${mins} 分鐘，打開 App 看集合點` : '現在集合，打開 App 看集合點';
}

module.exports = {
    FREE_LIMIT, PAID_LIMIT, MAX_DAYS, PASS_PRODUCT, BUNDLE_ID, PLAY_PACKAGE, LINK_BASE, CODE_LENGTH, VOUCHER_LENGTH,
    MAX_NAME, MAX_PLACE, MAX_NOTE, MAX_COHOSTS, MAX_SUBS, MAX_SUB_NAME, MAX_ANN, MAX_ANN_LEN, MAX_STOPS, COLORS,
    REMIND_EVERY_MS, REMIND_MAX, CALL_LEAD_MAX_MS, CALL_LINGER_MS, ANSWERS, LOST_TTL_MS, VOUCHER_TTL_DAYS, DEFAULT_TZ, KEY,
    clip, newCode, newVoucherCode, isCode, isVoucherCode,
    validTz, tzOffsetMin, localDate, endOfLocalDate, localHm, addDays, computeEndsAt,
    makeGroup, isOpen, memberLimit, isStaff, roleOf, canJoin, nextNumber,
    addCohost, removeCohost, cleanSubs, validSub, normSub, targetUids,
    makeCall, callLive, dueReminders, callRoster, rollRoster, makeLost, lostRoster,
    makeAnnouncement, pushAnnouncement, visibleAnnouncements,
    makeStop, upsertStop, removeStop,
    applePass, googlePass, makeVoucher, canRedeem, groupLink, voucherLink, callText,
};
