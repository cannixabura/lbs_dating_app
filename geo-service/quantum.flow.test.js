// 量子世界 API 的完整流程：用記憶體裡的迷你 Redis 取代 Upstash，直接呼叫 exports.quantum
const test = require('node:test');
const assert = require('node:assert');

// ---------- 迷你 Redis（只實作量子世界用到的指令） ----------
const db = new Map();
const zset = (k) => { if (!db.has(k)) db.set(k, new Map()); return db.get(k); };
const hash = (k) => { if (!db.has(k)) db.set(k, new Map()); return db.get(k); };
const score = (s) => (s === '-inf' ? -Infinity : s === '+inf' ? Infinity : Number(s));
const sorted = (k) => [...zset(k).entries()].sort((a, b) => a[1] - b[1] || (a[0] < b[0] ? -1 : 1));
const R = 6372797.560856;
const distM = (a, b) => {
    const r = Math.PI / 180;
    const h = Math.sin((b.lat - a.lat) * r / 2) ** 2 + Math.cos(a.lat * r) * Math.cos(b.lat * r) * Math.sin((b.lng - a.lng) * r / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(h));
};
const geo = new Map(); // key → Map(member → {lat, lng})

function run([cmd, ...a]) {
    switch (cmd.toUpperCase()) {
        case 'ECHO': return a[0];
        case 'DEL': return a.filter((k) => db.delete(k) || geo.delete(k)).length;
        case 'INCR': { const v = Number(db.get(a[0]) || 0) + 1; db.set(a[0], String(v)); return v; }
        case 'HSET': { const h = hash(a[0]); for (let i = 1; i < a.length; i += 2) h.set(a[i], String(a[i + 1])); return 1; }
        case 'HGET': return db.has(a[0]) ? (hash(a[0]).get(a[1]) ?? null) : null;
        case 'HMGET': return a.slice(1).map((f) => (db.has(a[0]) ? (hash(a[0]).get(f) ?? null) : null));
        case 'HGETALL': return db.has(a[0]) ? [...hash(a[0]).entries()].flat() : [];
        case 'SADD': { const h = hash(a[0]); a.slice(1).forEach((m) => h.set(m, 1)); return 1; }
        case 'SISMEMBER': return db.has(a[0]) && hash(a[0]).has(a[1]) ? 1 : 0;
        case 'ZADD': zset(a[0]).set(a[2], Number(a[1])); return 1;
        case 'ZREM': {
            let n = 0;
            for (const m of a.slice(1)) { if (zset(a[0]).delete(m)) n++; if (geo.get(a[0])?.delete(m)) n++; }
            return n;
        }
        case 'ZPOPMIN': { const [first] = sorted(a[0]); if (!first) return []; zset(a[0]).delete(first[0]); return [first[0], String(first[1])]; }
        case 'ZCOUNT': return sorted(a[0]).filter(([, s]) => s >= score(a[1]) && s <= score(a[2])).length;
        case 'ZRANGEBYSCORE': {
            let out = sorted(a[0]).filter(([, s]) => s >= score(a[1]) && s <= score(a[2])).map(([m]) => m);
            const li = a.indexOf('LIMIT');
            if (li >= 0) out = out.slice(Number(a[li + 1]), Number(a[li + 1]) + Number(a[li + 2]));
            return out;
        }
        case 'ZREMRANGEBYSCORE': {
            const z = zset(a[0]);
            for (const [m, s] of [...z]) if (s >= score(a[1]) && s <= score(a[2])) z.delete(m);
            return 1;
        }
        case 'GEOADD': { if (!geo.has(a[0])) geo.set(a[0], new Map()); geo.get(a[0]).set(a[3], { lng: Number(a[1]), lat: Number(a[2]) }); return 1; }
        case 'GEOSEARCH': {
            const here = { lng: Number(a[a.indexOf('FROMLONLAT') + 1]), lat: Number(a[a.indexOf('FROMLONLAT') + 2]) };
            const km = Number(a[a.indexOf('BYRADIUS') + 1]);
            const count = a.includes('COUNT') ? Number(a[a.indexOf('COUNT') + 1]) : Infinity;
            return [...(geo.get(a[0]) || new Map())].map(([m, p]) => [m, p, distM(here, p)])
                .filter(([, , d]) => d <= km * 1000).sort((x, y) => x[2] - y[2]).slice(0, count)
                .map(([m, p]) => [m, [String(p.lng), String(p.lat)]]);
        }
        default: throw new Error(`mini redis: ${cmd} not implemented`);
    }
}

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
