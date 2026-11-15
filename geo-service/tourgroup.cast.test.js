// 講解廣播：團主與共同團主講、團員只聽；同一團同時一場；2 小時到期；解散、退團、移除共同團主就結束
const test = require('node:test');
const assert = require('node:assert');
const { run } = require('./mini_redis');
const api = require('./tourgroup_api');
const tg = require('./tourgroup');

let now = Date.UTC(2026, 10, 21, 1, 0);
const pushes = [];
const deleted = [];
const fakeLivekit = {
    configured: () => true,
    config: () => ({ url: 'wss://live.example', key: 'k', secret: 's' }),
    identityOf: (uid, room) => `p_${uid}_${room}`,
    accessToken: (o) => JSON.stringify(o),
    deleteRoom: async (room) => { deleted.push(room); },
};
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
    livekit: fakeLivekit,
    clock: () => now,
});
async function call(uid, action, body = {}) {
    let out;
    const res = { status: () => res, json: (x) => { out = x; return res; }, send: (x) => { out = x; return res; } };
    await tour.handle({ method: 'POST', uid, headers: { 'x-app-build': '16' }, body: { action, ...body } }, res);
    return out;
}

test('講解廣播：開始、收聽、通行證權限、別人在講、結束', async () => {
    let r = await call('H', 'create', { name: '京都三日', color: 'gold', days: 3, tz: 'Asia/Tokyo', subs: ['1 號車', '2 號車'] });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    for (const u of ['C', 'm1', 'm2']) assert.equal((await call(u, 'join', { code, v })).success, true);
    await call('H', 'cohost_add', { uid: 'C' });
    await call('H', 'profile', { name: '阿導' });

    // 團員不能開
    assert.equal((await call('m1', 'cast_start')).code, 'not_host');

    pushes.length = 0;
    r = await call('H', 'cast_start');
    assert.equal(r.success, true);
    assert.equal(r.group.cast.mine, true);
    assert.deepEqual(pushes[0].uids.sort(), ['C', 'm1', 'm2']);
    assert.equal(pushes[0].body, '🎧 阿導 開始講解廣播，點一下收聽');
    assert.equal(pushes[0].data.type, 'tgroup_cast');

    // 團員看得到、拿到只能聽的通行證；開廣播的人可以講
    r = await call('m1', 'status');
    assert.equal(r.group.cast.byName, '阿導');
    assert.equal(r.group.cast.mine, false);
    let t = await call('m1', 'cast_token', { castId: r.group.cast.id });
    assert.equal(t.success, true);
    assert.equal(t.canPublish, false);
    assert.equal(JSON.parse(t.token).room, `tour_${code}_${r.group.cast.id}`);
    t = await call('H', 'cast_token');
    assert.equal(t.canPublish, true);
    // 共同團主也只能聽；團主在講時共同團主不能開
    assert.equal((await call('C', 'cast_token')).canPublish, false);
    assert.equal((await call('C', 'cast_start')).code, 'cast_busy');
    // 共同團主不能結束團主的廣播
    assert.equal((await call('C', 'cast_stop')).code, 'not_host');

    deleted.length = 0;
    r = await call('H', 'cast_stop');
    assert.equal(r.group.cast, null);
    assert.equal(deleted.length, 1);
    assert.equal((await call('m1', 'cast_token')).code, 'ended');

    // 共同團主開的，只講給 2 號車；1 號車看不到、拿不到通行證；團主可以結束
    const list = (await call('H', 'status')).group.people;
    await call('H', 'assign', { uid: 'm1', sub: 0 });
    await call('H', 'assign', { uid: 'm2', sub: 1 });
    pushes.length = 0;
    r = await call('C', 'cast_start', { sub: 1 });
    assert.equal(r.success, true);
    assert.deepEqual(pushes[0].uids.sort(), ['H', 'm2']);
    assert.equal((await call('m1', 'status')).group.cast, null);
    assert.equal((await call('m1', 'cast_token')).code, 'not_target');
    assert.equal((await call('m2', 'cast_token')).success, true);
    assert.ok(list);

    // 移除共同團主：他的廣播也結束
    deleted.length = 0;
    await call('H', 'cohost_remove', { uid: 'C' });
    assert.equal((await call('m2', 'status')).group.cast, null);
    assert.equal(deleted.length, 1);
});

test('講解廣播：2 小時到期自動結束；解散時關房間', async () => {
    let r = await call('H2', 'create', { name: '奈良一日', color: 'green', days: 1, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('n1', 'join', { code, v });
    await call('H2', 'cast_start');
    deleted.length = 0;
    now += tg.CAST_MAX_MS - 60000;
    await tour.endExpiredCasts(now);
    assert.equal(deleted.length, 0);
    assert.ok((await call('n1', 'status')).group.cast);
    now += 120000;
    assert.equal((await call('n1', 'status')).group.cast, null);
    await tour.endExpiredCasts(now);
    assert.equal(deleted.length, 1);

    await call('H2', 'cast_start');
    deleted.length = 0;
    await call('H2', 'dissolve');
    assert.equal(deleted.length, 1);
});
