// 量子世界 API 的完整流程：用記憶體裡的迷你 Redis 取代 Upstash，直接呼叫 exports.quantum
const test = require('node:test');
const assert = require('node:assert');

const { run, geo, distM } = require('./mini_redis');

process.env.UPSTASH_REDIS_REST_URL = 'https://redis.test';
process.env.UPSTASH_REDIS_REST_TOKEN = 'token';
global.fetch = async (url, { body }) => {
    const parsed = JSON.parse(body);
    const result = url.endsWith('/pipeline') ? parsed.map((c) => ({ result: run(c) })) : { result: run(parsed) };
    return { ok: true, json: async () => result };
};
const admin = require('firebase-admin');
Object.defineProperty(Object.getPrototypeOf(admin), 'auth', { configurable: true, value: () => ({ verifyIdToken: async (token) => ({ uid: token }) }) });
const blocks = new Set(); // 'a/b' = a 封鎖了 b
Object.defineProperty(Object.getPrototypeOf(admin), 'database', { configurable: true, value: () => ({
    ref: (path) => ({ once: async () => ({ exists: () => blocks.has(path.replace(/^blocks\//, '')), val: () => null }) }),
}) });

const { quantum: handler } = require('./index');
const q = require('./quantum');

let clock = Date.parse('2026-11-01T12:00:00Z');
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
        handler({ method: 'POST', headers: { authorization: `Bearer ${uid}`, origin: 'app' }, body }, res);
    });
}
const enter = (uid, extra = {}) => call(uid, { action: 'enter', ...TAIPEI, mood: '想找人聊聊天', nickname: uid, ...extra });
const beat = (uid, extra = {}) => call(uid, { action: 'beat', east: 0, north: 0, ...extra });

test('first visitors fill ring 4 from north, clockwise', async () => {
    const a = await enter('alice');
    assert.strictEqual(a.status, 200);
    assert.strictEqual(a.me.code, 'Q4-1');
    assert.ok(Math.abs(q.toLocal(a.me.lat, a.me.lng).north - 400) < 0.5);
    assert.strictEqual((await enter('bob')).me.code, 'Q4-2');
    assert.strictEqual((await enter('carol')).me.code, 'Q4-3');
});

test('entering leaves the normal radar and parallel universe, but keeps the profile', async () => {
    run(['GEOADD', 'city_users', '121.5', '25.0', 'dave']);
    run(['GEOADD', 'parallel_users', '121.5', '25.0', 'dave']);
    await enter('dave', { mood: '週六沒有計畫' });
    assert.strictEqual(geo.get('city_users').has('dave'), false);
    assert.strictEqual(geo.get('parallel_users').has('dave'), false);
    assert.strictEqual(run(['HGET', 'user_data:dave', 'mood']), '週六沒有計畫');
});

test('beat returns neighbours with mood, seat code and online count, never real positions', async () => {
    clock += 10000;
    const r = await beat('alice');
    assert.strictEqual(r.status, 200);
    const names = r.data.map((u) => u.nickname).sort();
    assert.deepStrictEqual(names, ['bob', 'carol', 'dave']);
    const bob = r.data.find((u) => u.nickname === 'bob');
    assert.strictEqual(bob.quantum, 'Q4-2');
    assert.strictEqual(bob.mood, '想找人聊聊天');
    // 對外的位置都在 101 附近的蜂巢裡，不是任何人的真實位置（台北車站）
    for (const u of r.data) assert.ok(distM(u, q.ORIGIN) < 1000);
    assert.strictEqual(r.online.total, 4);
    assert.deepStrictEqual(r.online.regions, { other: 4 }); // 台灣只有 4 人，不單獨顯示
});

test('walking moves the bubble; riding a train does not', async () => {
    clock += 10000;
    let r = await beat('bob', { east: 12, north: 0 });
    const start = q.seat(1);
    assert.ok(Math.abs(r.me.east - 12) < 1e-9);
    assert.ok(Math.abs(q.toLocal(r.me.lat, r.me.lng).east - (start.east + 12)) < 0.5);
    clock += 60000;
    r = await beat('bob', { east: 2012, north: 0 }); // 1 分鐘 2 公里
    assert.ok(Math.abs(r.me.east - 12) < 1e-9);
    clock += 10000;
    r = await beat('bob', { east: 2020, north: 0 });
    assert.ok(Math.abs(r.me.east - 20) < 1e-9);
});

test('quiet mode is shown to others; mood changes are filtered and shared', async () => {
    clock += 10000;
    await beat('carol', { quiet: true, mood: '在河堤看夜景', nickname: 'carol' });
    const r = await beat('alice');
    const carol = r.data.find((u) => u.uid === 'carol');
    assert.strictEqual(carol.quiet, true);
    assert.strictEqual(carol.mood, '在河堤看夜景');
});

test('leaving frees the seat for the next visitor and shows a collapse to neighbours', async () => {
    clock += 5000;
    assert.strictEqual((await call('bob', { action: 'leave' })).status, 200);
    assert.strictEqual((await beat('bob')).status, 410);
    const r = await beat('alice');
    assert.ok(!r.data.some((u) => u.uid === 'bob'));
    assert.deepStrictEqual(r.collapses.map((c) => c.uid), ['bob']);
    assert.strictEqual((await enter('erin')).me.code, 'Q4-2'); // 補 bob 留下的空位
    clock += 20000;
    assert.deepStrictEqual((await beat('alice')).collapses, []); // 動畫只播一下
});

test('a dropped connection hides you, keeps the seat for 3 minutes, then releases it', async () => {
    clock += 10000;
    await beat('alice'); await beat('carol'); await beat('dave'); await beat('erin');
    clock += 90000; // dave 斷線 90 秒（其他人持續心跳）
    await beat('carol'); await beat('erin');
    let r = await beat('alice');
    assert.ok(!r.data.some((u) => u.uid === 'dave'), 'not shown while disconnected');
    const back = await enter('dave');
    assert.strictEqual(back.resumed, true);
    assert.strictEqual(back.me.code, 'Q4-4');
    clock += 4 * 60000; // 只有 alice 還在：carol、dave、erin 都斷線超過 3 分鐘
    await beat('alice');
    const fresh = await enter('frank'); // 入場時順手釋放過期的席位，補最小的空位（erin 的 Q4-2）
    assert.strictEqual(fresh.me.code, 'Q4-2');
    assert.strictEqual((await beat('dave')).status, 410);
});

test('world view returns far-away people as light dots only', async () => {
    clock += 10000;
    for (let i = 0; i < 400; i++) { await enter(`crowd${i}`); }
    let r = await beat('alice', { radiusKM: 60 });
    assert.ok(r.dots.length >= 400);
    assert.ok(r.dots.every((d) => Array.isArray(d) && d.length === 2));
    r = await beat('alice');
    assert.deepStrictEqual(r.dots, []);
    assert.ok(r.data.length <= q.MAX_RESULTS);
});

test('mainland China cannot enter', async () => {
    const r = await call('gina', { action: 'enter', lat: 31.2304, lng: 121.4737, mood: 'hi', nickname: 'gina' });
    assert.strictEqual(r.status, 403);
    assert.strictEqual(r.code, 'closed');
    const hk = await call('hana', { action: 'enter', lat: 22.2783, lng: 114.1747, mood: 'hi', nickname: 'hana' });
    assert.strictEqual(hk.status, 200);
});

test('a GPS jump that drifts back slowly does not leave you outside your seat once you are home', async () => {
    const h = await enter('ivy');
    const home = h.me;
    clock += 10000;
    await beat('ivy', { east: 900, north: 0 }); // 定位瞬間跳 900 公尺：跳過
    clock += 10000;
    let r = await beat('ivy', { east: 860, north: 0 }); // 慢慢飄回來：當成走路
    for (let e = 800; e >= 100; e -= 60) { clock += 10000; r = await beat('ivy', { east: e, north: 0 }); }
    assert.ok(r.me.east < -500, 'drift is counted while away');
    clock += 10000;
    r = await beat('ivy', { east: 12, north: 5 }); // 回到家門口
    assert.ok(Math.abs(r.me.east - 12) < 1e-9 && Math.abs(r.me.north - 5) < 1e-9);
    assert.ok(distM(r.me, home) < 20);
});

// ---------- 第二期 ----------

test('day-night tint is always shared, local time and topics only as chosen', async () => {
    clock = Date.parse('2026-11-02T00:30:00Z'); // 台北 08:30、東京 09:30
    await enter('p2a', { tz: 480, topics: [0, 4, 4, 9] });
    await enter('p2b', { tz: 540, showTime: true });
    const r = await beat('p2a');
    const b = r.data.find((u) => u.uid === 'p2b');
    assert.strictEqual(b.day, 'day');
    assert.strictEqual(b.tz, 540);
    const a = (await beat('p2b')).data.find((u) => u.uid === 'p2a');
    assert.strictEqual(a.tz, undefined, 'local time stays hidden unless allowed');
    assert.deepStrictEqual(a.topics, [0, 4]);
});

test('entanglement: invite, accept, line at any distance, max 3, collapses when one leaves', async () => {
    clock += 5000;
    assert.strictEqual((await call('p2a', { action: 'entangle', op: 'invite', uid: 'p2b' })).status, 200);
    let r = await beat('p2b');
    assert.deepStrictEqual(r.invites.map((i) => i.uid), ['p2a']);
    assert.strictEqual((await call('p2b', { action: 'entangle', op: 'accept', uid: 'p2a' })).entangled, true);
    r = await beat('p2a', { radiusKM: 0.1 }); // 就算不在雷達範圍內，糾纏的人也有位置
    assert.deepStrictEqual(r.ent.map((e) => e.uid), ['p2b']);
    assert.ok(r.ent[0].code.startsWith('Q'));
    assert.deepStrictEqual((await beat('p2b')).invites, []);

    for (const u of ['p2c', 'p2d', 'p2e']) {
        await enter(u);
        await call(u, { action: 'entangle', op: 'invite', uid: 'p2a' });
    }
    assert.strictEqual((await call('p2a', { action: 'entangle', op: 'accept', uid: 'p2c' })).status, 200);
    assert.strictEqual((await call('p2a', { action: 'entangle', op: 'accept', uid: 'p2d' })).status, 200);
    assert.strictEqual((await call('p2a', { action: 'entangle', op: 'accept', uid: 'p2e' })).code, 'full');

    blocks.add('p2e/p2b');
    assert.strictEqual((await call('p2b', { action: 'entangle', op: 'invite', uid: 'p2e' })).code, 'gone');

    await call('p2b', { action: 'leave' });
    r = await beat('p2a');
    assert.deepStrictEqual(r.entGone, ['p2b']);
    assert.ok(!r.ent.some((e) => e.uid === 'p2b'));
    assert.deepStrictEqual((await beat('p2a')).entGone, [], 'told only once');

    await call('p2c', { action: 'entangle', op: 'cut', uid: 'p2a' });
    assert.deepStrictEqual((await beat('p2a')).entGone, ['p2c']);
});

test('tunnelling moves you to another free seat once per entry, keeps entanglement', async () => {
    clock += 5000;
    const before = (await beat('p2a', { east: 30, north: 0 })).me;
    const t = await call('p2a', { action: 'tunnel' });
    assert.strictEqual(t.status, 200);
    assert.notStrictEqual(t.me.code, before.code);
    assert.strictEqual(t.me.east, 0);
    assert.strictEqual((await call('p2a', { action: 'tunnel' })).code, 'used');
    // 走一點路：從新席位開始算；走回穿隧的地方就歸位到新席位
    clock += 10000;
    let r = await beat('p2a', { east: 42, north: 0 });
    assert.ok(Math.abs(r.me.east - 12) < 1e-9);
    assert.strictEqual(r.me.code, t.me.code);
    assert.ok(r.me.tunneled);
    r = await beat('p2d');
    assert.ok(r.ent.some((e) => e.uid === 'p2a' && e.code === t.me.code));
    // 原本的席位空出來，下一個人補進去
    assert.strictEqual((await enter('p2f')).me.code, before.code);
});

test('hourly chime: glimmers counted once each, fly-in positions shared, closed outside the show', async () => {
    clock = Date.parse('2026-11-02T03:59:20Z'); // 台北 11:59:20
    for (const u of ['p2a', 'p2d', 'p2f']) await beat(u);
    assert.strictEqual((await call('p2a', { action: 'chime' })).code, 'closed');
    let r = await beat('p2a');
    assert.strictEqual(r.chime.strikes, 12);
    assert.strictEqual(r.chime.count, 0);
    clock = Date.parse('2026-11-02T04:00:03Z');
    assert.strictEqual((await call('p2a', { action: 'chime' })).count, 1);
    assert.strictEqual((await call('p2a', { action: 'chime' })).first, false);
    assert.strictEqual((await call('p2d', { action: 'chime' })).count, 2);
    r = await beat('p2f');
    assert.strictEqual(r.chime.count, 2);
    assert.strictEqual(r.chime.fx.length, 2); // 同一個人點兩次只算一道
    clock = Date.parse('2026-11-02T04:05:00Z');
    assert.strictEqual((await beat('p2f')).chime, undefined);
});
