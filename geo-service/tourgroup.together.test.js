// 第二批：投票與調查、團內揪伴
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

test('純函式：投票、揪伴', () => {
    assert.equal(tg.makePoll({ q: '', opts: ['a', 'b'] }, 'L', now).code, 'empty');
    assert.equal(tg.makePoll({ q: '晚餐', opts: ['燒肉'] }, 'L', now).ok, false);
    assert.equal(tg.makePoll({ q: '晚餐', opts: ['燒肉', '燒肉'] }, 'L', now).ok, false);
    assert.equal(tg.makePoll({ q: '晚餐', opts: ['1', '2', '3', '4', '5', '6', '7'] }, 'L', now).ok, false);
    const p = tg.makePoll({ q: '晚餐吃什麼', opts: ['燒肉', ' 拉麵 ', ''], sub: -1 }, 'L', now).poll;
    assert.deepEqual(p.opts, ['燒肉', '拉麵']);
    assert.equal(p.sub, null);
    assert.equal(p.multi, false);
    assert.deepEqual(tg.cleanChoice(p, [1]), [1]);
    assert.equal(tg.cleanChoice(p, [0, 1]), null);
    assert.equal(tg.cleanChoice(p, [2]), null);
    assert.equal(tg.cleanChoice(p, []), null);
    assert.deepEqual(tg.cleanChoice({ ...p, multi: true }, [1, 0]), [0, 1]);
    assert.equal(tg.cleanChoice({ ...p, multi: true }, [1, 1]), null);
    const votes = { [`${p.id}|a`]: '[0]', [`${p.id}|b`]: '[1]', [`${p.id}|c`]: '[1]', [`${p.id}|gone`]: '[0]' };
    const v = tg.pollView(p, votes, 'b', false, ['a', 'b', 'c', 'd']);
    assert.deepEqual(v.counts, [1, 2]);
    assert.equal(v.voters, 3);
    assert.equal(v.total, 4);
    assert.deepEqual(v.mine, [1]);
    assert.equal(v.who, undefined);
    assert.deepEqual(tg.pollView(p, votes, 'L', true, ['a', 'b', 'c', 'd']).who, [['a'], ['b', 'c']]);
    assert.equal(tg.pollView(p, votes, 'd', false, ['a', 'b', 'c', 'd']).mine, null);

    const j = tg.makeJio({ text: '  誰要一起去逛唐吉訶德？ ' }, 'a', now).jio;
    assert.equal(j.text, '誰要一起去逛唐吉訶德？');
    assert.equal(tg.makeJio({ text: ' ' }, 'a', now).code, 'empty');
    assert.equal(tg.liveJios([j], now + tg.JIO_TTL_MS).length, 0);
    const three = [1, 2, 3].map((i) => ({ ...j, id: `j${i}` }));
    assert.equal(tg.canJio(three, 'a', now), 'too_many');
    assert.equal(tg.canJio(three, 'b', now), null);
    const view = tg.jioView([j], { [`${j.id}|b`]: '1', [`${j.id}|x`]: '1' }, 'b', ['x'], ['a', 'b', 'c', 'x'], now);
    assert.deepEqual(view[0].going, ['b']);
    assert.equal(view[0].count, 2);
    assert.equal(view[0].joined, true);
    assert.equal(view[0].mine, false);
    assert.equal(tg.jioView([j], {}, 'c', ['a'], ['a', 'b', 'c'], now).length, 0); // 封鎖的人發的看不到
    assert.equal(tg.jioView([j], {}, 'c', [], ['b', 'c'], now).length, 0); // 已經退團的人發的不顯示
});

test('流程：投票', async () => {
    let r = await call('L', 'create', { name: '京都三日', color: 'teal', days: 3, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    for (const u of ['a', 'b', 'c']) assert.equal((await call(u, 'join', { code, v })).success, true);
    assert.equal((await call('L', 'subs', { subs: ['1 號車', '2 號車'] })).success, true);
    assert.equal((await call('L', 'assign', { uid: 'c', sub: 1 })).success, true);

    pushes.length = 0;
    assert.equal((await call('a', 'poll_new', { q: '晚餐', opts: ['燒肉', '拉麵'] })).code, 'not_host');
    r = await call('L', 'poll_new', { q: '明天要不要去嵐山（自費 ¥3000）', opts: ['要', '不要', '再想想'] });
    assert.equal(r.success, true);
    const poll = r.group.polls[0];
    assert.equal(poll.total, 3);
    assert.deepEqual(pushes[0].uids.sort(), ['a', 'b', 'c']);
    assert.equal(pushes[0].body, '投票：明天要不要去嵐山（自費 ¥3000）');
    assert.equal(pushes[0].data.type, 'tgroup_poll');

    assert.equal((await call('a', 'vote', { id: poll.id, choice: [0] })).success, true);
    assert.equal((await call('b', 'vote', { id: poll.id, choice: [0, 1] })).code, 'bad_request');
    assert.equal((await call('b', 'vote', { id: poll.id, choice: [1] })).success, true);
    r = await call('b', 'vote', { id: poll.id, choice: [0] }); // 可以改票
    assert.deepEqual(r.group.polls[0].counts, [2, 0, 0]);
    assert.deepEqual(r.group.polls[0].mine, [0]);
    assert.equal(r.group.polls[0].who, undefined);
    assert.equal((await call('L', 'vote', { id: poll.id, choice: [0] })).code, 'bad_request');
    r = await call('L', 'status');
    assert.deepEqual(r.group.polls[0].who, [['a', 'b'], [], []]);
    assert.equal(r.group.polls[0].voters, 2);

    // 只問 2 號車：1 號車的人看不到、不能投
    pushes.length = 0;
    r = await call('L', 'poll_new', { q: '2 號車午餐', opts: ['便當', '自理'], multi: true, sub: 1 });
    const p2 = r.group.polls[0];
    assert.deepEqual(pushes[0].uids, ['c']);
    assert.equal(p2.total, 1);
    assert.equal((await call('a', 'status')).group.polls.length, 1);
    assert.equal((await call('a', 'vote', { id: p2.id, choice: [0] })).code, 'bad_request');
    assert.equal((await call('c', 'vote', { id: p2.id, choice: [0, 1] })).success, true);

    // 結束投票：不能再投；重新開放；刪除
    assert.equal((await call('L', 'poll_close', { id: poll.id })).success, true);
    assert.equal((await call('c', 'vote', { id: poll.id, choice: [1] })).code, 'closed');
    r = await call('c', 'status');
    assert.equal(r.group.polls.find((p) => p.id === poll.id).closed, true);
    await call('L', 'poll_close', { id: poll.id, open: true });
    assert.equal((await call('c', 'vote', { id: poll.id, choice: [1] })).success, true);
    assert.equal((await call('L', 'poll_delete', { id: poll.id })).success, true);
    r = await call('L', 'status');
    assert.deepEqual(r.group.polls.map((p) => p.id), [p2.id]);
    assert.equal(run(['HGET', tg.KEY.votes(code), `${poll.id}|a`]), null);

    // 最多留 10 個：最舊的連同選擇一起刪
    for (let i = 0; i < 10; i++) await call('L', 'poll_new', { q: `第 ${i} 題`, opts: ['是', '否'] });
    r = await call('L', 'status');
    assert.equal(r.group.polls.length, 10);
    assert.ok(!r.group.polls.some((p) => p.id === p2.id));
    assert.equal(run(['HGET', tg.KEY.votes(code), `${p2.id}|c`]), null);

    // 解散：投票都刪掉
    await call('L', 'dissolve');
    assert.equal(run(['GET', tg.KEY.polls(code)]), null);
});

test('流程：團內揪伴', async () => {
    let r = await call('H', 'create', { name: '首爾五日', color: 'pink', days: 5, tz: 'Asia/Seoul' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    for (const u of ['m1', 'm2', 'm3']) assert.equal((await call(u, 'join', { code, v })).success, true);

    // 沒同意（已滿 18 歲或家長同意）不能揪、不能跟
    assert.equal((await call('m1', 'jio_new', { text: '誰要一起去明洞吃烤肉' })).code, 'need_consent');
    for (const u of ['m1', 'm2', 'm3', 'H']) await call(u, 'share', { on: true, consent: true });
    await call('m1', 'profile', { name: '小美' });

    pushes.length = 0;
    r = await call('m1', 'jio_new', { text: '誰要一起去明洞吃烤肉' });
    assert.equal(r.success, true);
    const jio = r.group.jios[0];
    assert.equal(jio.mine, true);
    assert.deepEqual(pushes[0].uids.sort(), ['H', 'm2', 'm3']);
    assert.equal(pushes[0].body, '🙋 小美：誰要一起去明洞吃烤肉');

    pushes.length = 0;
    r = await call('m2', 'jio_join', { id: jio.id });
    assert.equal(r.group.jios[0].joined, true);
    assert.deepEqual(pushes[0].uids, ['m1']);
    assert.equal(pushes[0].body, '#2 也要去：誰要一起去明洞吃烤肉');
    pushes.length = 0;
    await call('m2', 'jio_join', { id: jio.id }); // 重複按不再推播
    assert.equal(pushes.length, 0);
    assert.equal((await call('m1', 'jio_join', { id: jio.id })).code, 'bad_request');
    r = await call('m1', 'status');
    assert.deepEqual(r.group.jios[0].going, ['m2']);
    r = await call('m2', 'jio_join', { id: jio.id, on: false });
    assert.equal(r.group.jios[0].joined, false);

    // m3 封鎖 m1：看不到 m1 的揪伴；m1 也看不到 m3 說要去；m1 之後揪不推給 m3
    await call('m3', 'jio_join', { id: jio.id });
    await call('m3', 'block', { uid: 'm1' });
    assert.equal((await call('m3', 'status')).group.jios.length, 0);
    r = await call('m1', 'status');
    assert.deepEqual(r.group.jios[0].going, []);
    assert.equal(r.group.jios[0].count, 1);
    pushes.length = 0;
    await call('m1', 'jio_new', { text: '宵夜炸雞' });
    assert.ok(!pushes[0].uids.includes('m3'));

    // 每人同時最多 3 個
    await call('m1', 'jio_new', { text: '第三個' });
    assert.equal((await call('m1', 'jio_new', { text: '第四個' })).code, 'too_many');

    // 刪除：自己可以、別的團員不行、領隊可以
    const mine = (await call('m1', 'status')).group.jios;
    assert.equal((await call('m2', 'jio_delete', { id: mine[0].id })).code, 'not_host');
    assert.equal((await call('m1', 'jio_delete', { id: mine[0].id })).success, true);
    assert.equal((await call('H', 'jio_delete', { id: mine[1].id })).success, true);
    assert.equal((await call('m1', 'status')).group.jios.length, 1);

    // 12 小時後自動消失
    now += tg.JIO_TTL_MS;
    assert.equal((await call('m1', 'status')).group.jios.length, 0);
    assert.equal((await call('m1', 'jio_new', { text: '再揪一次' })).success, true);
});

test('封鎖的人收不到我的揪伴推播；退團時投票、揪伴、我也去一起刪掉', async () => {
    let r = await call('H2', 'create', { name: '大阪三日', color: 'blue', days: 3, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    for (const u of ['n1', 'n2', 'n3']) assert.equal((await call(u, 'join', { code, v })).success, true);
    for (const u of ['n1', 'n2', 'n3', 'H2']) await call(u, 'share', { on: true, consent: true });

    // n1 封鎖 n2：n1 發揪伴不推給 n2
    await call('n1', 'block', { uid: 'n2' });
    pushes.length = 0;
    r = await call('n1', 'jio_new', { text: '一起去道頓堀' });
    assert.deepEqual(pushes[0].uids.sort(), ['H2', 'n3']);

    // n2 退團：他的票、他的揪伴、他按的我也去都刪掉；揪伴名額不再被佔
    const p = (await call('H2', 'poll_new', { q: '晚餐', opts: ['拉麵', '燒肉'] })).group.polls[0];
    await call('n2', 'vote', { id: p.id, choice: [0] });
    await call('n3', 'vote', { id: p.id, choice: [1] });
    const j2 = (await call('n2', 'jio_new', { text: '誰要去環球影城' })).group.jios.find((j) => j.mine);
    await call('n3', 'jio_join', { id: j2.id });
    const j1 = (await call('n3', 'status')).group.jios.find((j) => j.by === 'n1');
    await call('n2', 'jio_join', { id: j1.id });
    assert.equal((await call('n2', 'leave')).success, true);
    const votes = Object.keys(Object.fromEntries((run(['HGETALL', tg.KEY.votes(code)]) || []).reduce((a, x, i, arr) => (i % 2 ? a : [...a, [x, arr[i + 1]]]), [])));
    assert.ok(votes.every((k) => !k.endsWith('|n2')));
    r = await call('n3', 'status');
    assert.equal(r.group.jios.length, 1);
    assert.equal(r.group.jios[0].count, 0);
    assert.deepEqual(r.group.polls[0].counts, [0, 1]);
});

test('到點自動點名：集合發出後才入團的人也能點到、說會晚到', async () => {
    let r = await call('H3', 'create', { name: '京都一日', color: 'green', days: 1, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('k1', 'join', { code, v });
    r = await call('H3', 'call', { at: now + 20 * 60000, tz: 'Asia/Tokyo', place: '清水寺', lat: 34.9949, lng: 135.785 });
    assert.equal(r.success, true);
    await call('k2', 'join', { code, v });
    assert.equal((await call('k2', 'late', { callId: r.group.call.id, mins: 5 })).success, true);
    now += 15 * 60000;
    assert.equal((await call('k2', 'arrive', { callId: r.group.call.id, lat: 34.9949, lng: 135.785 })).success, true);
});
