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
// 天數：出發日起免費 3 天；每張天數券多 7 天，可以疊加，一團最長 30 天。出發日最遠可以選 90 天後。
const FREE_DAYS = 3;
const DAYS_PER_PASS = 7;
const MAX_DAYS = 30;
const MAX_LEAD_DAYS = 90;
// 人數券（商品代碼沿用 tour_pass_7d）：這一團升到 100 人，到解散為止；天數券：這一團多 7 天
const PASS_PRODUCT = 'tour_pass_7d';
const DAYS_PRODUCT = 'tour_days_7d';
const PRODUCTS = [PASS_PRODUCT, DAYS_PRODUCT];
const BUNDLE_ID = 'com.softchip.tourchip';
const PLAY_PACKAGE = 'com.softchip.tourchip';
const LINK_BASE = 'https://tourchip.web.app';
const CODE_LENGTH = 8;
const VOUCHER_LENGTH = 10;
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
// 邀請碼：8 位數字，已經裝好 App 的人可以直接輸入入團；換新 QR code 時一起換新
const INVITE_LENGTH = 8;
const INVITE_FAILS = 10; // 每人每小時最多輸錯幾次（防止亂猜）
const INVITE_FAIL_WINDOW_S = 3600;
const MAX_NAME = 20;
const MAX_PLACE = 30;
const MAX_NOTE = 20;
const MAX_COHOSTS = 2;
const MAX_SUBS = 6;
const MAX_SUB_NAME = 10;
const MAX_ANN = 20;
const MAX_ANN_LEN = 200;
const MAX_STOPS = 60;
const MAX_NICK = 10;
const MAX_BUBBLE = 20;
const MAX_MSG = 200;
const MAX_MSGS = 300; // 每團最多留幾則私訊（舊的刪掉）
const MSG_RATE = 20; // 每人每分鐘最多傳幾則
const POS_FRESH_MS = 10 * 60 * 1000; // （舊）不再用來隱藏人；保留匯出給舊測試
// 地圖上的人永遠不會因為沒更新而消失（只有退團、被移出、解散、到期才拿掉）；
// 超過 30 分鐘沒有任何回應（App 被關掉、手機關機）就顯示成灰色。
// App 在背景時伺服器每 12 分鐘送一個無聲推播，App 回 pong 就算有回應。
const PRESENCE_STALE_MS = 30 * 60 * 1000;
const PING_EVERY_MS = 12 * 60 * 1000;
const COLORS = ['violet', 'pink', 'blue', 'teal', 'green', 'gold', 'orange', 'red'];
const REMIND_EVERY_MS = 60 * 1000;
const REMIND_MAX = 3;
const CALL_LEAD_MAX_MS = 12 * 60 * 60 * 1000; // 自由活動可以排到 12 小時後
// 集合前 15 分鐘自動提醒一次（集合呼叫與行程表的集合點都會）；離發出不到 20 分鐘的集合不另外提醒
const PRE_REMIND_MS = 15 * 60 * 1000;
const PRE_REMIND_MIN_LEAD_MS = 20 * 60 * 1000;
// 每日資訊卡、團體資訊、團員資料
const MAX_DAY_NOTE = 1000;
const MAX_LINKS = 10;
const MAX_LINK_TITLE = 40;
const MAX_URL = 500;
const MAX_HOTEL_NAME = 40;
const MAX_ADDR = 200;
const MAX_PHONE = 25;
const MAX_INFO_NOTE = 200;
const CALL_LINGER_MS = 30 * 60 * 1000;
// 飯店：Wi-Fi、早餐時間（領隊填，團員在每日資訊看）
const MAX_WIFI = 80;
const MAX_BREAKFAST = 60;
// 房號（領隊在名單設定，或用艾婭匯入分房表）
const MAX_ROOM = 10;
// 手動點名：領隊幫沒有手機、沒電、沒網路的人按「到了」
const MARKED = 'marked';
// 送花感謝：最後一天起到解散後 3 天，團員可以送一朵花給團主或共同團主，附一句話
const MAX_THANK = 60;
const MAX_INTRO = 80;
const MAX_THANKS_KEPT = 500; // 每位領隊最多留幾則感謝（舊的刪掉）
const THANK_FROM_MS = 24 * 60 * 60 * 1000; // 結束前 24 小時（最後一天）起可以送
const THANKS_REMIND_BEFORE_MS = 7 * 60 * 60 * 1000; // 最後一天約 17:00（結束前 7 小時）提醒團員
const ENDED_TTL_S = 3 * 86400; // 解散後還能送花幾天
// 艾婭匯入行程與分房表：領隊免費，每團最多 5 次
const AI_IMPORTS = 5;
// 有送花功能的 App 版本（build 9 = 1.0.1）；舊版收到送花提醒也找不到地方送，所以只提醒新版
const THANKS_MIN_BUILD = 9;
const MAX_IMPORT_TEXT = 6000;
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
    profile: 'tgroup_profile', // 每位使用者的暱稱與頭像 JSON（旅行團自己的，不讀城市低語的 user_data）
    share: 'tgroup_share', // 每位使用者：{ on, consent, at }（分享位置的開關、年齡／家長同意）
    pos: (code) => `tgroup_pos:${code}`, // 團員的位置（同團的人在 3D 地圖上互相看得到）
    bubble: (code) => `tgroup_bubble:${code}`, // 團員的氣泡
    msgs: (code) => `tgroup_msgs:${code}`, // 團裡的私訊（解散就刪除）
    blocks: (code) => `tgroup_blocks:${code}`, // 每個人封鎖的對象（JSON 陣列）
    msgRate: (uid) => `tgroup_msgrate:${uid}`,
    reports: 'tgroup_reports',
    seen: (code) => `tgroup_seen:${code}`, // 每個人最後一次跟伺服器聯絡的時間（判斷要不要變灰）
    pingDue: 'tgroup_ping_due', // 有序集合：「團代碼|uid」→ 下次該送無聲推播的時間
    voucher: (v) => `tvoucher:${v}`,
    vouchersOf: (uid) => `tvouchers_of:${uid}`,
    days: (code) => `tgroup_days:${code}`, // 每日資訊卡：hash 日期 'YYYY-MM-DD' → JSON（說明、飯店、攻略連結）
    info: (code) => `tgroup_info:${code}`, // 團體資訊 JSON：車輛（可依分組）、緊急聯絡
    mdata: (code) => `tgroup_mdata:${code}`, // 團員資料：hash uid → JSON（飲食、健康、緊急聯絡人；只有團主與共同團主看得到）
    stopDue: 'tgroup_stop_due', // 有序集合：「團代碼|集合點 id」→ 集合前 15 分鐘提醒的時間
    invite: (inv) => `tgroup_invite:${inv}`, // 邀請碼 → 團代碼（跟著團一起到期；換新 QR code 時刪掉舊的）
    inviteFails: (uid) => `tgroup_invfail:${uid}`, // 每人輸錯邀請碼的次數（一小時）
    build: 'tgroup_build', // 每位使用者 App 的 build 號（App 每次呼叫帶 X-App-Build）
    aiImports: (code) => `tgroup_aiimp:${code}`, // 這一團用了幾次艾婭匯入
    thanked: (code) => `tgroup_thanked:${code}`, // hash「送的人|收的人」→ 1（每團每人對每位領隊送一次）
    thanksDue: 'tgroup_thanks_due', // 有序集合：團代碼 → 最後一天提醒送花的時間
    ended: (code) => `tgroup_ended:${code}`, // 解散後 3 天：團名、領隊名單、團員（還能送花）
    endedOf: (uid) => `tgroup_ended_of:${uid}`, // 團員最近解散的團
    leaderCard: (uid) => `tleader:${uid}`, // 領隊名片 JSON：{ slug, pub, intro }
    leaderThanks: (uid) => `tleader_thanks:${uid}`, // 領隊收到的感謝（list，新的在前）JSON：{ id, at, group, text, pub }
    leaderSlug: (slug) => `tleader_slug:${slug}`, // 公開名片網址 → 領隊 uid
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
/** 8 位數字的邀請碼（可以 0 開頭） */
function newInvite(randomInt = crypto.randomInt) {
    let s = '';
    for (let i = 0; i < INVITE_LENGTH; i++) s += String(randomInt(10));
    return s;
}
/** 使用者輸入的邀請碼：拿掉空白、連字號等，只留數字；不是 8 位數就回傳 null */
function normInvite(raw) {
    const s = String(raw ?? '').replace(/[\s\-－‐·.]/g, '').replace(/[０-９]/g, (c) => String(c.charCodeAt(0) - 0xff10));
    return new RegExp(`^\\d{${INVITE_LENGTH}}$`).test(s) ? s : null;
}
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

/** 某時區某天某時刻（'HH:MM'）的時間戳；格式不對回傳 null */
function localTimeToMs(date, hm, tz) {
    const m = /^(\d{1,2}):(\d{2})$/.exec(String(hm || ''));
    if (!validDateStr(date) || !m || Number(m[1]) > 23 || Number(m[2]) > 59 || !validTz(tz)) return null;
    const [y, mo, d] = String(date).split('-').map(Number);
    const guess = Date.UTC(y, mo - 1, d, Number(m[1]), Number(m[2]));
    let t = guess - tzOffsetMin(tz, guess) * 60000;
    t = guess - tzOffsetMin(tz, t) * 60000;
    return t;
}
const validDateStr = (s) => typeof s === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(s);

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

const validDate = (s) => typeof s === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(s) && addDays(s, 0) === s;
/** 兩個日期差幾天（b − a） */
const dayDiff = (a, b) => Math.round((Date.parse(`${b}T00:00:00Z`) - Date.parse(`${a}T00:00:00Z`)) / 86400000);

/** 目前的行程長度（舊的團沒有 days 欄位：用開始、結束日算） */
const tripDays = (g) => (Number.isInteger(g.days) ? g.days : dayDiff(g.startDate, g.endDate) + 1);
/** 這一團最多能用幾天：免費天數＋每張天數券 7 天，最多 30 天（舊的團：原本的長度都算免費） */
const freeDaysOf = (g) => (Number.isInteger(g.freeDays) ? g.freeDays : dayDiff(g.startDate, g.endDate) + 1);
const allowedDays = (g) => Math.min(MAX_DAYS, freeDaysOf(g) + DAYS_PER_PASS * (g.dayPasses || 0));
/** 依想要的天數與可用天數算出結束日；還要再買幾張天數券 */
function applyTrip(g) {
    const len = Math.min(tripDays(g), allowedDays(g));
    return { ...g, endDate: addDays(g.startDate, len - 1) };
}
const daysPassesNeeded = (g) => Math.max(0, Math.ceil((Math.min(tripDays(g), MAX_DAYS) - allowedDays(g)) / DAYS_PER_PASS));

/** 出發日：今天到 90 天後（開團的人手機的時區）；沒填就是今天 */
function checkStart(start, zone, now) {
    const today = localDate(now, zone);
    if (start === undefined || start === null || start === '') return { ok: true, date: today };
    if (!validDate(start)) return { ok: false, code: 'start' };
    const diff = dayDiff(today, start);
    if (diff < 0 || diff > MAX_LEAD_DAYS) return { ok: false, code: 'start' };
    return { ok: true, date: start };
}

/**
 * 開團：團名、團色、出發日（今天到 90 天後）、天數（1～30，含出發當天）、開團的人手機的時區。
 * 超過免費 3 天的部分要買天數券才會生效（還沒買之前，團在第 3 天結束）。
 * @returns {{ok: true, group: object} | {ok: false, code: string}}
 */
function makeGroup({ host, name, color, days, tz, start }, now) {
    const n = clip(name, MAX_NAME);
    if (!n) return { ok: false, code: 'name' };
    if (!COLORS.includes(color)) return { ok: false, code: 'color' };
    const d = Math.round(Number(days));
    if (!Number.isFinite(d) || d < 1 || d > MAX_DAYS) return { ok: false, code: 'days' };
    const zone = validTz(tz) ? tz : DEFAULT_TZ;
    const st = checkStart(start, zone, now);
    if (!st.ok) return st;
    const g = applyTrip({ host, cohosts: [], name: n, color, tz: zone, startDate: st.date, days: d, freeDays: FREE_DAYS, dayPasses: 0, createdAt: now, paid: false, qrVer: 1, subs: [] });
    g.endsAt = computeEndsAt(g, []);
    return { ok: true, group: g };
}

/**
 * 團主改出發日或天數。出發日改了的話要在今天到 90 天後；改完的結束時間不能已經過去。
 * @returns {{ok: true, group: object} | {ok: false, code: string}} （endsAt 由呼叫的人依行程表重算）
 */
function changeTrip(g, { start, days }, stops, now) {
    let startDate = g.startDate;
    if (start !== undefined && start !== null && start !== g.startDate) {
        const st = checkStart(start, g.tz, now);
        if (!st.ok) return st;
        startDate = st.date;
    }
    const d = days === undefined || days === null ? tripDays(g) : Math.round(Number(days));
    if (!Number.isFinite(d) || d < 1 || d > MAX_DAYS) return { ok: false, code: 'days' };
    const next = applyTrip({ ...g, startDate, days: d, freeDays: freeDaysOf(g) });
    next.endsAt = computeEndsAt(next, stops);
    if (next.endsAt <= now) return { ok: false, code: 'days' };
    return { ok: true, group: next };
}

/** 套用一張天數券（已經 30 天就不能再加） */
function addDayPass(g, stops) {
    if (allowedDays(g) >= MAX_DAYS) return { ok: false, code: 'max_days' };
    const next = applyTrip({ ...g, freeDays: freeDaysOf(g), days: tripDays(g), dayPasses: (g.dayPasses || 0) + 1 });
    next.endsAt = computeEndsAt(next, stops);
    return { ok: true, group: next };
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
 * 集合呼叫：集合時間（現在到 12 小時後）、集合點的時區、說明、座標（團主放的集合點）、分組
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

/** 集合前 15 分鐘的提醒該不該送了（只送一次；發出時離集合不到 20 分鐘的不送） */
const preRemindDue = (call, now) => !!call && !call.pre && now < call.at && call.at - now <= PRE_REMIND_MS && call.at - call.sentAt >= PRE_REMIND_MIN_LEAD_MS;
/** 行程表集合點的提醒時間；已經來不及（離現在不到 15 分鐘）就是 null */
const stopRemindAt = (stop, now) => (stop && stop.at - PRE_REMIND_MS > now ? stop.at - PRE_REMIND_MS : null);

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
    // 領隊手動按的「到了」算到了，另外標記 marked
    const rows = members.map((m) => {
        const a = (answers || {})[m.uid];
        if (a === MARKED) return { ...m, answer: 'here', marked: true };
        return { ...m, answer: ANSWERS.includes(a) ? a : 'none' };
    });
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
    if (!PRODUCTS.includes(tx.productId)) throw new Error('unknown_product');
    if (!tx.transactionId) throw new Error('bad_tx');
    return { receipt: `ta_${tx.transactionId}`, productId: tx.productId };
}

function googlePass(productId, receiptKey, purchase) {
    if (!PRODUCTS.includes(productId)) throw new Error('unknown_product');
    if (!purchase || purchase.purchaseState !== 0) throw new Error('not_paid');
    return { receipt: `t${receiptKey}`, productId };
}

/** 團購券：買的人、這張券來自哪一筆購買、哪一種（people 人數券／days 天數券） */
const kindOf = (productId) => (productId === DAYS_PRODUCT ? 'days' : 'people');
const makeVoucher = (buyer, receipt, now, productId = PASS_PRODUCT) => ({ buyer, receipt, kind: kindOf(productId), createdAt: now, usedBy: null, usedAt: null });

/** 能不能把券用在這一團（舊的券沒有 kind，當成人數券） */
function canRedeem(v, g, now) {
    if (!v) return { ok: false, code: 'voucher_not_found' };
    if (v.usedBy) return { ok: false, code: 'voucher_used' };
    if (now - v.createdAt > VOUCHER_TTL_DAYS * 86400000) return { ok: false, code: 'voucher_expired' };
    if (v.kind === 'days') {
        if (allowedDays(g) >= MAX_DAYS) return { ok: false, code: 'max_days' };
    } else if (g.paid) return { ok: false, code: 'already_paid' };
    return { ok: true };
}

// ---------- 每日資訊卡、團體資訊、團員資料 ----------

/** 電話：只留數字、+、-、括號、空白、#、*，最多 25 字 */
const cleanPhone = (p) => String(p || '').replace(/[^0-9+\-() #*]/g, '').replace(/\s+/g, ' ').trim().slice(0, MAX_PHONE);
/** 攻略連結：只收 http／https，不能有空白，最多 500 字 */
function cleanUrl(u) {
    const s = String(u || '').trim();
    if (s.length > MAX_URL || /\s/.test(s) || !/^https?:\/\/[^/?#]+\.[^/?#]+/i.test(s)) return null;
    return s;
}

/**
 * 每日資訊卡：日期（出發日前一天到最後一天）、說明（餐食、注意事項…最多 1000 字）、
 * 今晚的飯店（名稱、當地地址、電話、座標可不填）、攻略連結（最多 10 個）。
 * 全部空白 → card 是 null（刪除這一天）
 */
function makeDay({ date, note, hotel, links }, g) {
    if (!validDate(date)) return { ok: false, code: 'bad_request' };
    const off = dayDiff(g.startDate, date);
    if (off < -1 || off >= MAX_DAYS) return { ok: false, code: 'bad_request' };
    const n = clipText(note, MAX_DAY_NOTE);
    let h = null;
    if (hotel && typeof hotel === 'object') {
        const name = clip(hotel.name, MAX_HOTEL_NAME);
        const addr = clipText(hotel.addr, MAX_ADDR);
        const phone = cleanPhone(hotel.phone);
        const hasCoord = hotel.lat !== undefined && hotel.lat !== null && hotel.lng !== undefined && hotel.lng !== null;
        if (hasCoord && badCoord(hotel.lat, hotel.lng)) return { ok: false, code: 'place' };
        const wifi = clip(hotel.wifi, MAX_WIFI);
        const breakfast = clip(hotel.breakfast, MAX_BREAKFAST);
        if (name || addr || wifi || breakfast) h = { name, addr, phone, lat: hasCoord ? Number(hotel.lat) : null, lng: hasCoord ? Number(hotel.lng) : null, wifi, breakfast };
    }
    const out = [];
    if (links !== undefined && !Array.isArray(links)) return { ok: false, code: 'bad_request' };
    for (const l of links || []) {
        const url = cleanUrl(l && l.url);
        if (!url) return { ok: false, code: 'url' };
        out.push({ title: clip(l.title, MAX_LINK_TITLE) || url.replace(/^https?:\/\//i, '').slice(0, MAX_LINK_TITLE), url });
    }
    if (out.length > MAX_LINKS) return { ok: false, code: 'too_many' };
    if (!n && !h && !out.length) return { ok: true, card: null };
    return { ok: true, card: { date, note: n, hotel: h, links: out } };
}
/** 要過濾髒話的文字 */
const dayTexts = (c) => (c ? [c.note, c.hotel && c.hotel.name, c.hotel && c.hotel.breakfast, ...c.links.map((l) => l.title)].filter(Boolean) : []);

/**
 * 團體資訊：車輛（全團一台，或依分組各一台：車牌、車色車型、司機稱呼、司機電話、備註）、
 * 緊急聯絡（領隊電話、旅行社名稱、旅行社 24 小時電話、其他說明）
 */
function makeInfo({ buses, emergency }, g) {
    const bs = [];
    if (buses !== undefined && !Array.isArray(buses)) return { ok: false, code: 'bad_request' };
    for (const b of buses || []) {
        if (!b || !validSub(g, b.sub)) return { ok: false, code: 'bad_request' };
        const row = { sub: normSub(b.sub), plate: clip(b.plate, 15), desc: clip(b.desc, 20), driver: clip(b.driver, 20), phone: cleanPhone(b.phone), note: clip(b.note, 40) };
        if (row.plate || row.desc || row.driver || row.phone || row.note) bs.push(row);
    }
    if (bs.length > MAX_SUBS + 1) return { ok: false, code: 'too_many' };
    const e = emergency || {};
    const em = { phone: cleanPhone(e.phone), agency: clip(e.agency, 30), agencyPhone: cleanPhone(e.agencyPhone), note: clipText(e.note, MAX_INFO_NOTE) };
    return { ok: true, info: { buses: bs, emergency: em } };
}
const infoTexts = (i) => [...i.buses.flatMap((b) => [b.plate, b.desc, b.driver, b.note]), i.emergency.agency, i.emergency.note].filter(Boolean);

/** 團員資料：飲食禁忌、健康狀況（過敏、病史、用藥）、緊急聯絡人稱呼（不收電話）；全部空白 → null（刪除） */
/** 房號：最多 10 字 */
const cleanRoom = (s) => clip(s, MAX_ROOM);

// ---------- 送花感謝 ----------
/** 最後一天起（結束前 24 小時）到結束都可以送 */
const canThank = (g, now) => !!g && now >= g.endsAt - THANK_FROM_MS && now <= g.endsAt;
/** 最後一天提醒團員送花的時間 */
const thanksRemindAt = (g) => g.endsAt - THANKS_REMIND_BEFORE_MS;
const cleanThank = (t) => clip(t, MAX_THANK);
const cleanIntro = (t) => clip(t, MAX_INTRO);
const newSlug = (random) => randomCode(10, random).toLowerCase();
const isSlug = (s) => typeof s === 'string' && /^[a-hj-np-z2-9]{10}$/.test(s);
/** 公開名片：只給公開的感謝（不含送的人是誰） */
function publicCard(card, thanks, name) {
    return {
        name: name || '', intro: (card && card.intro) || '',
        flowers: thanks.length,
        thanks: thanks.filter((t) => t.pub && t.text).map((t) => ({ text: t.text, at: t.at, group: t.group || '' })).slice(0, 100),
    };
}

// ---------- 艾婭匯入行程與分房表 ----------
/** 給 AI 的輸出格式（JSON Schema） */
const IMPORT_SCHEMA = {
    type: 'object',
    additionalProperties: false,
    required: ['days', 'stops', 'rooms'],
    properties: {
        days: {
            type: 'array',
            items: {
                type: 'object', additionalProperties: false, required: ['date', 'note', 'hotel'],
                properties: {
                    date: { type: 'string', description: 'YYYY-MM-DD' },
                    note: { type: 'string', description: 'meals, notes, what to wear; plain text' },
                    hotel: {
                        type: 'object', additionalProperties: false, required: ['name', 'addr', 'phone', 'wifi', 'breakfast'],
                        properties: { name: { type: 'string' }, addr: { type: 'string' }, phone: { type: 'string' }, wifi: { type: 'string' }, breakfast: { type: 'string' } },
                    },
                },
            },
        },
        stops: {
            type: 'array',
            items: {
                type: 'object', additionalProperties: false, required: ['date', 'time', 'tz', 'place'],
                properties: { date: { type: 'string' }, time: { type: 'string', description: 'HH:MM local time' }, tz: { type: 'string', description: 'IANA time zone of the place' }, place: { type: 'string' } },
            },
        },
        rooms: {
            type: 'array',
            items: {
                type: 'object', additionalProperties: false, required: ['name', 'room', 'group'],
                properties: { name: { type: 'string' }, room: { type: 'string' }, group: { type: 'string', description: 'bus / group name, or empty' } },
            },
        },
    },
};

/** 給 AI 的指示 */
function importPrompt(g, text) {
    return [
        'You read a tour leader\'s pasted itinerary and/or rooming list and extract structured data. Output JSON only, matching the schema.',
        `The trip starts on ${g.startDate} and ends on ${g.endDate}. Day 1 = ${g.startDate}. Convert "Day N" or "第N天" to dates.`,
        `If a time zone is unclear, use the place's country; default ${g.tz}.`,
        'days: one entry per date that has info. note = short practical notes for members (meals, what to bring), in the source language, max 300 chars. hotel = that night\'s hotel (name and address as written, local language if given); wifi and breakfast only if stated; empty strings when unknown.',
        'stops: meeting points / departure times with an explicit clock time (e.g. "08:00 lobby"). place max 30 chars. Skip entries without a time.',
        'rooms: rooming list rows (guest name as written, room number, bus/group if given). Empty arrays when not present. Never invent data.',
        '',
        'TEXT:',
        String(text || '').slice(0, MAX_IMPORT_TEXT),
    ].join('\n');
}

/** 檢查並整理 AI 的輸出：日期要在行程內、時間要合法；回傳給 App 預覽（還沒存） */
function cleanImport(raw, g) {
    const r = raw && typeof raw === 'object' ? raw : {};
    const inTrip = (date) => validDateStr(date) && addDays(date, 0) === date && dayDiff(g.startDate, date) >= -1 && dayDiff(g.startDate, date) < MAX_DAYS;
    const days = [];
    for (const d of Array.isArray(r.days) ? r.days : []) {
        if (!d || !inTrip(d.date) || days.some((x) => x.date === d.date)) continue;
        const made = makeDay({ date: d.date, note: d.note, hotel: d.hotel || null, links: [] }, g);
        if (made.ok && made.card) days.push(made.card);
    }
    const stops = [];
    for (const x of Array.isArray(r.stops) ? r.stops : []) {
        if (!x || !inTrip(x.date)) continue;
        const tz = validTz(x.tz) ? x.tz : g.tz;
        const at = localTimeToMs(x.date, x.time, tz);
        const place = clip(x.place, MAX_PLACE);
        if (at === null || !place) continue;
        stops.push({ at, tz, place });
        if (stops.length >= MAX_STOPS) break;
    }
    stops.sort((a, b) => a.at - b.at);
    const rooms = [];
    for (const x of Array.isArray(r.rooms) ? r.rooms : []) {
        const name = clip(x && x.name, 30), room = cleanRoom(x && x.room);
        if (!name || (!room && !(x && x.group))) continue;
        rooms.push({ name, room, group: clip(x.group, MAX_SUB_NAME) });
        if (rooms.length >= 200) break;
    }
    return { days, stops, rooms };
}

function cleanMemberData(x) {
    const o = x || {};
    const d = { diet: clip(o.diet, 60), health: clipText(o.health, 150), contact: clip(o.contact, 20) };
    return d.diet || d.health || d.contact ? d : null;
}

// ---------- 連結 ----------

// 入團連結帶著邀請碼（i）：還沒裝 App 的人在入團網頁看得到，裝好後可以照著輸入
const groupLink = (code, qrVer, invite) => `${LINK_BASE}/g/${code}?v=${qrVer}${invite ? `&i=${invite}` : ''}`;
const voucherLink = (v) => `${LINK_BASE}/v/${v}`;

// ---------- 個人資料（暱稱、頭像） ----------

/**
 * 暱稱最多 10 字；頭像只接受自己上傳到 Firebase Storage avatars/<uid>.jpg 的下載網址（沿用城市低語的 Storage 規則）。
 * 兩個都空 → null（刪除）
 */
function cleanProfile(input, uid) {
    const name = clip((input || {}).name, MAX_NICK);
    const raw = String((input || {}).avatar || '');
    const ok = raw.startsWith('https://firebasestorage.googleapis.com/') && raw.includes(`/o/avatars%2F${encodeURIComponent(uid)}.jpg`) && raw.length < 600;
    const avatar = ok ? raw : '';
    return name || avatar ? { name, avatar } : null;
}

// ---------- 同團互相看得到：位置、氣泡、私訊 ----------
// 位置只在團員同意（已滿 18 歲或家長／監護人同意）而且開著分享時才收；只在 App 開著時更新；
// 退團、被移出、解散就刪除。沒入團的人看不到任何人。

const parseJson = (raw, fallback) => { try { return raw ? JSON.parse(raw) : fallback; } catch (e) { return fallback; } };

/** 分享狀態：沒設定過 → 還沒同意（不分享）；同意之後預設分享 */
function shareState(raw) {
    const s = parseJson(raw, {});
    return { consent: !!s.consent, on: !!s.consent && s.on !== false };
}

function validPos(lat, lng) {
    return Number.isFinite(lat) && Number.isFinite(lng) && Math.abs(lat) <= 90 && Math.abs(lng) <= 180;
}

/** 3D 地圖上的人：同團、有同意並開著分享、10 分鐘內有位置；自己不算（自己的位置在手機上） */
/** 最近 30 分鐘內有回應才算在線；沒有紀錄的（舊版 App）用最後一次回報位置的時間 */
function isOnline(seenRaw, pos, now) {
    const at = Number(seenRaw) || (pos && pos.at) || 0;
    return now - at < PRESENCE_STALE_MS;
}

function peopleView({ g, list, me, posHash, bubbleHash, shareHash, seenHash = {}, profOf, blockedByMe, now }) {
    const out = [];
    for (const m of list) {
        if (m.uid === me) continue;
        const share = shareState(shareHash[m.uid]);
        if (!share.on) continue;
        const p = parseJson(posHash[m.uid], null);
        if (!p || !validPos(p.lat, p.lng)) continue; // 不因為太久沒更新而拿掉：改成變灰
        const b = parseJson(bubbleHash[m.uid], null);
        const prof = profOf(m.uid);
        out.push({
            uid: m.uid, no: m.no, role: roleOf(g, m.uid), name: prof.name || '', avatar: prof.avatar || '',
            lat: p.lat, lng: p.lng, at: p.at, online: isOnline(seenHash[m.uid], p, now),
            bubble: b && b.text && !blockedByMe.includes(m.uid) ? b.text : '',
        });
    }
    return out;
}

function makeMessage({ from, to, text }, now) {
    const t = clip(text, MAX_MSG);
    if (!t) return { ok: false, code: 'empty' };
    if (!from || !to || from === to) return { ok: false, code: 'bad_request' };
    return { ok: true, msg: { id: `${now.toString(36)}${Math.random().toString(36).slice(2, 6)}`, from, to, text: t, at: now } };
}

/** 跟我有關的私訊（我傳的、傳給我的），不含我封鎖的人傳來的；最新的 50 則，舊到新 */
function messagesFor(rawList, uid, blockedByMe) {
    return (rawList || []).map((r) => parseJson(r, null))
        .filter((m) => m && (m.to === uid || m.from === uid) && !(m.to === uid && blockedByMe.includes(m.from)))
        .sort((a, b) => a.at - b.at)
        .slice(-50);
}

/** 集合呼叫推播的文字（繁中原文，送出時翻成收件人的語言） */
function callText(call, now) {
    const mins = Math.max(0, Math.round((call.at - now) / 60000));
    const hm = localHm(call.at, call.tz || DEFAULT_TZ);
    if (call.place) return mins > 0 ? `${hm} 到「${call.place}」集合，還有 ${mins} 分鐘` : `現在到「${call.place}」集合`;
    return mins > 0 ? `${hm} 集合，還有 ${mins} 分鐘，打開 App 看集合點` : '現在集合，打開 App 看集合點';
}

module.exports = {
    FREE_LIMIT, PAID_LIMIT, MAX_DAYS, FREE_DAYS, DAYS_PER_PASS, MAX_LEAD_DAYS, PASS_PRODUCT, DAYS_PRODUCT, PRODUCTS, BUNDLE_ID, PLAY_PACKAGE, LINK_BASE, CODE_LENGTH, VOUCHER_LENGTH,
    MAX_NAME, MAX_PLACE, MAX_NOTE, MAX_COHOSTS, MAX_SUBS, MAX_SUB_NAME, MAX_ANN, MAX_ANN_LEN, MAX_STOPS, MAX_NICK, MAX_BUBBLE, MAX_MSG, MAX_MSGS, MSG_RATE, POS_FRESH_MS, PRESENCE_STALE_MS, PING_EVERY_MS, COLORS,
    REMIND_EVERY_MS, REMIND_MAX, CALL_LEAD_MAX_MS, PRE_REMIND_MS, PRE_REMIND_MIN_LEAD_MS, MAX_LINKS, CALL_LINGER_MS, ANSWERS, LOST_TTL_MS, VOUCHER_TTL_DAYS, DEFAULT_TZ, KEY, THANKS_MIN_BUILD, MAX_WIFI, MAX_BREAKFAST, MAX_ROOM, MARKED, MAX_THANK, MAX_THANKS_KEPT, THANK_FROM_MS, ENDED_TTL_S, AI_IMPORTS, MAX_IMPORT_TEXT,
    localTimeToMs, cleanRoom, canThank, thanksRemindAt, cleanThank, cleanIntro, newSlug, isSlug, publicCard, IMPORT_SCHEMA, importPrompt, cleanImport, INVITE_LENGTH, INVITE_FAILS, INVITE_FAIL_WINDOW_S, newInvite, normInvite,
    clip, newCode, newVoucherCode, isCode, isVoucherCode,
    validTz, tzOffsetMin, localDate, endOfLocalDate, localHm, addDays, computeEndsAt,
    makeGroup, changeTrip, addDayPass, tripDays, allowedDays, daysPassesNeeded, validDate, dayDiff, isOpen, memberLimit, isStaff, roleOf, canJoin, nextNumber,
    addCohost, removeCohost, cleanSubs, validSub, normSub, targetUids,
    makeCall, callLive, preRemindDue, stopRemindAt, dueReminders, callRoster, rollRoster, makeLost, lostRoster,
    makeAnnouncement, pushAnnouncement, visibleAnnouncements,
    makeStop, upsertStop, removeStop,
    applePass, googlePass, kindOf, makeVoucher, canRedeem, cleanPhone, cleanUrl, makeDay, dayTexts, makeInfo, infoTexts, cleanMemberData, groupLink, voucherLink, callText, cleanProfile,
    shareState, validPos, isOnline, peopleView, makeMessage, messagesFor,
};
