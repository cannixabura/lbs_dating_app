// 集合四件組（後端）：到點自動點名、我會晚到、脫隊預警
const test = require('node:test');
const assert = require('node:assert');
const { run } = require('./mini_redis');
const api = require('./tourgroup_api');
const tg = require('./tourgroup');

let now = Date.UTC(2026, 10, 20, 1, 0);
const pushes = [];
const tour = api.create({
    cmd: async (c) => run(c),
    pipe: async (cs) => cs.map((c) => run(c)),
    verifyCaller: async (req) => req.uid,
    isDisallowed: () => false,
    push: async (uids, title, body, data) => { pushes.push({ uids, body, data }); return uids.length; },
    langOf: () => 'zh-Hant',
    localize: (l, t) => t,
    db: () => ({}),
    verifyAppleJws: (j) => JSON.parse(j),
    receiptKey: (s, id) => `g_${id}`,
    playPurchase: async () => ({ purchaseState: 0 }),
    clock: () => now,
});
async function call(uid, action, body = {}) {
    let out;
    const res = { status: () => res, json: (x) => { out = x; return res; }, send: (x) => { out = x; return res; } };
    await tour.handle({ method: 'POST', uid, headers: { 'x-app-build': '14' }, body: { action, ...body } }, res);
    return out;
}
// 往北移動 n 公尺
const north = (lat, m) => lat + m / 111195;

test('純函式：距離、能不能到、晚到、脫隊判斷', () => {
    assert.ok(Math.abs(tg.distM(25, 121, north(25, 100), 121) - 100) < 1);
    const c = { at: now + 20 * 60000, lat: 25, lng: 121 };
    assert.equal(tg.canArrive(c, { lat: north(25, 30), lng: 121 }, now).ok, true);
    assert.equal(tg.canArrive(c, { lat: north(25, 80), lng: 121 }, now).code, 'too_far');
    assert.equal(tg.canArrive({ ...c, at: now + 40 * 60000 }, { lat: 25, lng: 121 }, now).code, 'too_early');
    assert.equal(tg.makeLate({ mins: 4 }, now).ok, false);
    assert.deepEqual(tg.makeLate({ mins: 5, why: 'toilet' }, now).late, { mins: 5, why: 'toilet', at: now });
    assert.equal(tg.makeLate({ mins: 3, why: 'xx' }, now).late.why, '');
    assert.equal(tg.lateText(7, { mins: 5, why: 'toilet' }), '7 號會晚 5 分鐘到：在排廁所');
    assert.equal(tg.lateText(7, { mins: 3, why: '' }), '7 號會晚 3 分鐘到');
    assert.equal(tg.farTextStaff(3, 312), '3 號離大家約 300 公尺，可能脫隊了');

    const at = now;
    const staff = [{ uid: 'L', lat: 25, lng: 121, at }];
    const near = (u, m = 20) => ({ uid: u, lat: north(25, m), lng: 121, at });
    // 大家都在領隊附近、一個人 400 公尺外：先記下，不提醒
    let r = tg.farCheck({ staff, members: [near('a'), near('b'), near('c'), near('x', 400)], now });
    assert.equal(r.together, true);
    assert.deepEqual(r.alerts, []);
    assert.equal(r.next.x.since, now);
    // 3 分鐘後還在外面 → 提醒一次
    r = tg.farCheck({ staff, members: [near('a'), near('b'), near('c'), near('x', 400)], prev: r.next, now: now + 3 * 60000 });
    assert.deepEqual(r.alerts.map((a) => a.uid), []); // 位置已經超過 2 分鐘：不算
    const t3 = now + 3 * 60000;
    const fresh = (p) => ({ ...p, at: t3 });
    r = tg.farCheck({ staff: staff.map(fresh), members: [near('a'), near('b'), near('c'), near('x', 400)].map(fresh), prev: { x: { since: now, alerted: false } }, now: t3 });
    assert.deepEqual(r.alerts.map((a) => a.uid), ['x']);
    // 已經提醒過：不再提醒；回到 150 公尺內：解除
    r = tg.farCheck({ staff: staff.map(fresh), members: [near('a'), near('b'), near('c'), near('x', 400)].map(fresh), prev: r.next, now: t3 });
    assert.deepEqual(r.alerts, []);
    assert.equal(r.next.x.alerted, true);
    r = tg.farCheck({ staff: staff.map(fresh), members: [near('a'), near('b'), near('c'), near('x', 100)].map(fresh), prev: r.next, now: t3 });
    assert.equal(r.next.x, undefined);
    // 自由活動（大家分散）：不提醒
    r = tg.farCheck({ staff, members: [near('a', 500), near('b', 900), near('c'), near('x', 400)], prev: { x: { since: now - 600000 } }, now });
    assert.equal(r.together, false);
    assert.deepEqual(r.alerts, []);
    // 人太少（不到 3 人有位置）：不判斷
    assert.equal(tg.farCheck({ staff, members: [near('a'), near('x', 400)], now }).together, false);
    // 按了「我迷路了」的人不重複提醒
    r = tg.farCheck({ staff, members: [near('a'), near('b'), near('c'), near('x', 400)], prev: { x: { since: now - 600000 } }, skip: ['x'], now });
    assert.deepEqual(r.alerts, []);
});

test('流程：自動點到、我會晚到、點名沿用、脫隊預警', async () => {
    let r = await call('L', 'create', { name: '大阪四日', color: 'blue', days: 4, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    for (const u of ['a', 'b', 'c', 'x']) assert.equal((await call(u, 'join', { code, v })).success, true);

    // 集合：20 分鐘後在大阪城
    const P = { lat: 34.6873, lng: 135.5262 };
    r = await call('L', 'call', { at: now + 20 * 60000, tz: 'Asia/Tokyo', place: '大阪城天守閣前', ...P });
    const callId = r.group.call.id;

    // a 到了（30 公尺內）→ 自動點到、算收到；太遠的不算
    assert.equal((await call('a', 'arrive', { callId, lat: north(P.lat, 25), lng: P.lng })).success, true);
    assert.equal((await call('b', 'arrive', { callId, lat: north(P.lat, 300), lng: P.lng })).code, 'too_far');
    assert.equal((await call('a', 'arrive', { callId: 'old', ...P })).code, 'ended');
    assert.equal((await call('L', 'arrive', { callId, ...P })).code, 'bad_request');
    r = await call('a', 'status');
    assert.equal(r.group.call.here, true);
    assert.equal(r.group.call.mine, 'ack');

    // b 會晚 5 分鐘（在排廁所）→ 領隊收到推播
    pushes.length = 0;
    assert.equal((await call('b', 'late', { callId, mins: 5, why: 'toilet' })).success, true);
    assert.equal(pushes[0].body, '2 號會晚 5 分鐘到：在排廁所');
    assert.deepEqual(pushes[0].uids, ['L']);
    assert.equal((await call('b', 'late', { callId, mins: 7 })).code, 'bad_request');
    r = await call('b', 'status');
    assert.deepEqual(r.group.call.late, { mins: 5, why: 'toilet', at: now });

    // 領隊的名單：沒反應的在前，再來會晚到、已到
    r = await call('L', 'status');
    const roster = r.group.callRoster;
    assert.equal(roster.arrived, 1);
    assert.equal(roster.late, 1);
    assert.equal(roster.acked, 2);
    assert.deepEqual(roster.rows.map((x) => x.uid), ['c', 'x', 'b', 'a']);
    assert.equal(roster.rows[3].arrived, true);
    assert.equal(roster.rows[2].late.mins, 5);

    // 再提醒只響沒收到的 c、x（a 到了、b 說會晚到都不再響）
    pushes.length = 0;
    now += 61000;
    await tour.remind();
    assert.deepEqual(pushes[0].uids.sort(), ['c', 'x']);

    // 開始點名：自動點到的 a 已經算到了
    r = await call('L', 'rollcall', {});
    assert.equal(r.group.rollRoster.here, 1);
    assert.equal(r.group.rollRoster.rows.find((x) => x.uid === 'a').auto, true);

    // b 後來也到了 → 不再顯示會晚到
    await call('b', 'arrive', { callId, ...P });
    r = await call('L', 'status');
    assert.equal(r.group.callRoster.late, 0);
    assert.equal(r.group.callRoster.arrived, 2);

    // 結束集合：自動點到、晚到的紀錄都清掉
    await call('L', 'roll_done');
    await call('L', 'call_done');
    r = await call('L', 'call', { at: now + 20 * 60000, tz: 'Asia/Tokyo', place: '道頓堀', ...P });
    assert.equal(r.group.callRoster.arrived, 0);
    await call('L', 'call_done');

    // 脫隊預警：大家都分享位置，跟著領隊走；x 落後 400 公尺
    for (const u of ['L', 'a', 'b', 'c', 'x']) await call(u, 'share', { on: true, consent: true });
    const walk = async (xm) => {
        await call('L', 'pos', P);
        for (const u of ['a', 'b', 'c']) await call(u, 'pos', { lat: north(P.lat, 30), lng: P.lng });
        await call('x', 'pos', { lat: north(P.lat, xm), lng: P.lng });
    };
    pushes.length = 0;
    now += 61000;
    await walk(400);
    // 1 分鐘只檢查一次：第一次已經記下
    // 每次檢查用的是上一輪的位置（2 分鐘內都算）：第 2 輪記下、滿 3 分鐘（第 5 輪）才提醒
    for (let i = 0; i < 3; i++) { now += 61000; await walk(400); }
    assert.equal(pushes.length, 0);
    now += 61000; await walk(400);
    assert.equal(pushes.length, 2);
    assert.equal(pushes[0].body, '4 號離大家約 400 公尺，可能脫隊了');
    assert.deepEqual(pushes[0].uids, ['L']);
    assert.deepEqual(pushes[1].uids, ['x']);
    assert.equal(pushes[1].body, '你離大家約 400 公尺了，記得跟上隊伍');
    r = await call('L', 'status');
    assert.deepEqual(r.group.far.map((f) => f.uid), ['x']);
    assert.equal((await call('a', 'status')).group.far, undefined);
    // 不重複提醒；回來就解除
    now += 61000; await walk(400);
    assert.equal(pushes.length, 2);
    now += 61000; await walk(50);
    now += 61000; await walk(50);
    assert.deepEqual((await call('L', 'status')).group.far, []);
});
