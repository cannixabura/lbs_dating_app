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
