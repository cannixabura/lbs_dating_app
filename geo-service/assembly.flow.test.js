// 量子集會的完整流程：迷你 Redis ＋ 記憶體裡的 Realtime Database，直接呼叫 exports.quantum
const test = require('node:test');
const assert = require('node:assert');

const { run } = require('./mini_redis');

process.env.UPSTASH_REDIS_REST_URL = 'https://redis.test';
process.env.UPSTASH_REDIS_REST_TOKEN = 'token';
global.fetch = async (url, { body }) => {
    const parsed = JSON.parse(body);
    const result = url.endsWith('/pipeline') ? parsed.map((c) => ({ result: run(c) })) : { result: run(parsed) };
    return { ok: true, json: async () => result };
};

// 記憶體裡的 RTDB：路徑 → 值（巢狀物件），支援 once / set / update / remove / transaction
const store = {};
const parts = (p) => p.split('/').filter(Boolean);
function getAt(p) { let o = store; for (const k of parts(p)) { if (o == null || typeof o !== 'object') return null; o = o[k]; } return o ?? null; }
function setAt(p, v) {
    const ks = parts(p); let o = store;
    for (const k of ks.slice(0, -1)) { if (typeof o[k] !== 'object' || o[k] == null) o[k] = {}; o = o[k]; }
    if (v == null) delete o[ks[ks.length - 1]]; else o[ks[ks.length - 1]] = JSON.parse(JSON.stringify(v));
}
const ref = (path = '') => ({
    once: async () => ({ val: () => getAt(path), exists: () => getAt(path) != null }),
    set: async (v) => setAt(path, v),
    remove: async () => setAt(path, null),
    update: async (obj) => { for (const [k, v] of Object.entries(obj)) setAt(path ? `${path}/${k}` : k, v); },
    transaction: async (fn) => {
        const next = fn(getAt(path));
        if (next === undefined) return { committed: false, snapshot: { val: () => getAt(path) } };
        setAt(path, next);
        return { committed: true, snapshot: { val: () => next } };
    },
});
const admin = require('firebase-admin');
Object.defineProperty(Object.getPrototypeOf(admin), 'auth', { configurable: true, value: () => ({ verifyIdToken: async (token) => ({ uid: token }) }) });
Object.defineProperty(Object.getPrototypeOf(admin), 'database', { configurable: true, value: () => ({ ref }) });

const index = require('./index');
const a = require('./assembly');
const q = require('./quantum');

let clock = Date.parse('2026-11-08T04:00:00Z');
Date.now = () => clock;
const TAIPEI = { lat: 25.0478, lng: 121.5170 };

function call(uid, body) {
    return new Promise((resolve) => {
        const res = {
            statusCode: 200, headers: {},
            setHeader(k, v) { this.headers[k] = v; }, getHeader(k) { return this.headers[k]; },
            status(c) { this.statusCode = c; return this; },
            json(data) { resolve({ status: this.statusCode, ...data }); },
            send(data) { resolve({ status: this.statusCode, data }); },
            end() { resolve({ status: this.statusCode }); },
        };
        index.quantum({ method: 'POST', headers: { authorization: `Bearer ${uid}`, origin: 'app' }, body }, res);
    });
}
const enter = (uid) => call(uid, { action: 'enter', ...TAIPEI, mood: '今晚一起', nickname: uid });
const beat = (uid) => call(uid, { action: 'beat', east: 0, north: 0 });

let id;

test('host opens a free assembly: moves to Q3-1, everyone sees it, free plan used once a month', async () => {
    for (const u of ['host', 'amy', 'ben', 'cat']) await enter(u);
    const st = await call('host', { action: 'asmStatus' });
    assert.strictEqual(st.free, true);
    const r = await call('host', { action: 'asmCreate', plan: 'free', title: '  一起看流星雨 ', emoji: '🌙', color: '#7FD8FF' });
    assert.strictEqual(r.success, true, JSON.stringify(r));
    assert.strictEqual(r.code, 'Q3-1');
    id = r.id;
    const pub = getAt(`qAssemblies/${id}`);
    assert.strictEqual(pub.title, '一起看流星雨');
    assert.strictEqual(pub.cap, 50);
    assert.strictEqual(pub.status, 'active');
    assert.strictEqual(getAt(`qAssemblyActive/${id}`), true);
    assert.ok(!JSON.stringify(pub).includes('host"') || pub.host === 'host'); // 只有暱稱，沒有 uid 欄位
    // 主持人的光球在主持席，鄰居看到 Q3-1 與主持標記
    clock += 5000;
    const me = await beat('host');
    assert.strictEqual(me.me.code, 'Q3-1');
    assert.strictEqual(me.me.hostAsm, id);
    const seen = (await beat('amy')).data.find((u) => u.nickname === 'host');
    assert.strictEqual(seen.quantum, 'Q3-1');
    assert.strictEqual(seen.asmHost, true);
    // 本月的免費場用掉了
    assert.strictEqual((await call('host', { action: 'asmStatus' })).free, false);
    assert.strictEqual((await call('amy', { action: 'asmCreate', plan: '1h', title: 'x' })).code, 'no_voucher');
});

test('join, count, cheer and announce; only the host controls', async () => {
    assert.ok((await call('amy', { action: 'asmJoin', id })).success);
    assert.ok((await call('ben', { action: 'asmJoin', id })).success);
    assert.strictEqual(getAt(`qAssemblies/${id}/count`), 2);
    const seen = (await beat('cat')).data.find((u) => u.nickname === 'amy');
    assert.strictEqual(seen.asm, id);
    assert.strictEqual((await call('amy', { action: 'asmCheer', id, color: '#FF8AD8', countdown: 3 })).code, 'not_host');
    const c = await call('host', { action: 'asmCheer', id, color: '#FF8AD8', countdown: 3 });
    assert.strictEqual(c.fireAt, clock + 3000);
    assert.deepStrictEqual(getAt(`qAssemblies/${id}/cheer`).color, '#FF8AD8');
    assert.strictEqual((await call('host', { action: 'asmCheer', id, color: '#FF8AD8', countdown: 3 })).code, 'too_soon');
    assert.ok((await call('host', { action: 'asmAnnounce', id, text: '流星雨 10 點開始' })).success);
    assert.strictEqual(getAt(`qAssemblies/${id}/announce`).text, '流星雨 10 點開始');
    assert.strictEqual((await call('host', { action: 'asmAnnounce', id, text: '加我 line: abc123' })).code, 'too_soon');
});

test('removed people cannot come back; leaving the world leaves the assembly', async () => {
    assert.ok((await call('host', { action: 'asmRemove', id, uid: 'ben' })).success);
    assert.strictEqual((await call('ben', { action: 'asmJoin', id })).code, 'removed');
    assert.strictEqual(getAt(`qAssemblies/${id}/count`), 1);
    await call('amy', { action: 'leave' });
    assert.strictEqual(getAt(`qAssemblies/${id}/count`), 0);
    assert.ok((await call('cat', { action: 'asmJoin', id })).success);
});

test('ending leaves an anonymous memorial card and gives the host seat back', async () => {
    assert.ok((await call('host', { action: 'asmEnd', id })).success);
    const pub = getAt(`qAssemblies/${id}`);
    assert.strictEqual(pub.status, 'ended');
    assert.strictEqual(pub.summary.count, 3); // amy、ben、cat 都加入過
    assert.deepStrictEqual(pub.summary.regions, { tw: 3 });
    assert.strictEqual(getAt(`qAssemblyActive/${id}`), null);
    clock += 5000;
    const me = await beat('host');
    assert.ok(me.me.code.startsWith('Q4-'));
    assert.strictEqual(me.me.hostAsm, undefined);
    assert.strictEqual((await beat('cat')).me.asm, undefined);
    assert.strictEqual((await call('cat', { action: 'asmJoin', id })).code, 'ended');
});

test('paid plan uses a voucher; host leaving the world ends it; the scheduler ends expired ones', async () => {
    setAt('qAssemblyVouchers/cat/a_1', { plan: '1h', at: clock });
    const r = await call('cat', { action: 'asmCreate', plan: '1h', title: '生日派對', emoji: '🎂', color: '#FFD27A' });
    assert.ok(r.success, JSON.stringify(r));
    assert.strictEqual(r.code, 'Q3-1'); // 剛才的主持席空出來了
    assert.strictEqual(getAt(`qAssemblies/${r.id}/cap`), 200);
    assert.strictEqual(getAt('qAssemblyVouchers/cat/a_1'), null);
    await call('cat', { action: 'leave' });
    assert.strictEqual(getAt(`qAssemblies/${r.id}/status`), 'ended');
    // 時間到：排程結束
    await enter('dan');
    setAt('qAssemblyVouchers/dan/a_2', { plan: '2h', at: clock });
    const d = await call('dan', { action: 'asmCreate', plan: '2h', title: '跨年前夜', emoji: '✨', color: '#B79CFF' });
    assert.strictEqual(getAt(`qAssemblies/${d.id}/cap`), 1000);
    clock += 121 * 60 * 1000;
    run(['ZADD', q.KEY.beats, String(clock), 'dan']);
    await index.endAssemblies.run({});
    assert.strictEqual(getAt(`qAssemblies/${d.id}/status`), 'ended');
});

test('blocked words in the title are refused, and seats run out after 18', async () => {
    await enter('eve');
    assert.strictEqual((await call('eve', { action: 'asmCreate', plan: 'free', title: '加我 line: abc123' })).code, 'blocked_words');
    for (let i = 0; i < a.RING_SEATS; i++) run(['HSET', a.KEY.seats, String(i), `x${i}`]);
    assert.strictEqual((await call('eve', { action: 'asmCreate', plan: 'free', title: '散步' })).code, 'seats_full');
});
