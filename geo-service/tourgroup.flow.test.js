// 旅行團完整流程：迷你 Redis ＋ 記憶體 RTDB，直接呼叫 tourgroup_api 的 handle
const test = require('node:test');
const assert = require('node:assert');
const { run } = require('./mini_redis');
const api = require('./tourgroup_api');
const tg = require('./tourgroup');

let now = Date.UTC(2026, 10, 17, 1, 0);
const store = {};
const ref = (path) => ({
    transaction: async (fn) => {
        const next = fn(store[path] ?? null);
        if (next === undefined) return { committed: false };
        store[path] = next;
        return { committed: true };
    },
});
const pushes = [];
const tour = api.create({
    cmd: async (c) => run(c),
    pipe: async (cs) => cs.map((c) => run(c)),
    verifyCaller: async (req) => req.uid,
    isDisallowed: (t) => String(t).includes('髒話'),
    push: async (uids, title, body, data, opts) => { pushes.push({ uids, body, data, urgent: !!(opts && opts.urgent), langs: opts && opts.langs }); return uids.length; },
    langOf: (req) => req.lang || 'zh-Hant',
    localize: (l, t) => t,
    db: () => ({ ref }),
    verifyAppleJws: (jws) => JSON.parse(jws),
    receiptKey: (src, id) => `g_${id}`,
    playPurchase: async () => ({ purchaseState: 0 }),
    clock: () => now,
});

async function call(uid, action, body = {}, lang) {
    let out;
    const res = { status: () => res, json: (x) => { out = x; return res; }, send: (x) => { out = x; return res; } };
    await tour.handle({ method: 'POST', uid, lang, body: { action, ...body } }, res);
    return out;
}

test('完整流程：開團、入團、共同團主、分組集合、點名、公告、行程表、迷路、團購券、解散', async () => {
    let r = await call('leader', 'create', { name: '京都秋楓五日', color: 'violet', days: 5, tz: 'Asia/Taipei', subs: ['1 號車', '2 號車'] });
    assert.equal(r.success, true);
    const g0 = r.group;
    assert.equal(g0.role, 'host');
    assert.deepEqual(g0.subs, ['1 號車', '2 號車']);
    const v = Number(new URL(g0.qr).searchParams.get('v'));

    // 19 位團員＋導遊入團（含團主共 21 人 → 第 21 位被擋）
    for (let i = 1; i <= 18; i++) assert.equal((await call(`m${i}`, 'join', { code: g0.code, v })).success, true);
    assert.equal((await call('guide', 'join', { code: g0.code, v })).success, true);
    r = await call('late', 'join', { code: g0.code, v });
    assert.equal(r.code, 'full');
    assert.ok(pushes.some((p) => p.data.type === 'tgroup_full'));

    // 導遊成為共同團主
    r = await call('leader', 'cohost_add', { uid: 'guide' });
    assert.equal(r.group.staff.length, 2);
    r = await call('guide', 'status');
    assert.equal(r.group.role, 'cohost');
    assert.equal(r.group.members.length, 18);

    // 共同團主不能解散、不能升別人
    assert.equal((await call('guide', 'dissolve')).code, 'not_host');

    // 分組：m1～m9 是 1 號車、m10～m18 是 2 號車
    for (let i = 1; i <= 18; i++) await call('leader', 'assign', { uid: `m${i}`, sub: i <= 9 ? 0 : 1 });

    // 共同團主只叫 2 號車集合（京都時間）
    pushes.length = 0;
    r = await call('guide', 'call', { at: now + 15 * 60000, tz: 'Asia/Tokyo', place: '仁王門前石階下', lat: 34.99, lng: 135.78, sub: 1 });
    assert.equal(r.success, true);
    assert.equal(pushes[0].uids.length, 9);
    assert.equal(pushes[0].urgent, true);
    assert.equal(r.group.callRoster.total, 9);
    // 1 號車的人看不到這次集合；2 號車看得到
    assert.equal((await call('m1', 'status')).group.call, null);
    const m10 = (await call('m10', 'status')).group;
    assert.equal(m10.call.place, '仁王門前石階下');
    assert.equal((await call('m10', 'ack', { callId: m10.call.id })).success, true);

    // 一分鐘後只提醒 2 號車還沒收到的 8 個人
    pushes.length = 0;
    now += 61000;
    await tour.remind();
    assert.equal(pushes[0].uids.length, 8);
    assert.ok(!pushes[0].uids.includes('m10'));

    // 全團點名；m3 需要幫忙 → 團主與共同團主都收到
    r = await call('leader', 'rollcall', {});
    const rollId = r.group.roll.id;
    await call('m1', 'answer', { rollId, answer: 'here' });
    pushes.length = 0;
    await call('m3', 'answer', { rollId, answer: 'help' });
    assert.deepEqual(pushes[0].uids.sort(), ['guide', 'leader']);
    r = await call('leader', 'status');
    assert.equal(r.group.rollRoster.rows[0].uid, 'm3');
    assert.equal(r.group.rollRoster.here, 1);

    // 公告：只給 1 號車
    await call('leader', 'announce', { text: '1 號車 18:30 在飯店大廳集合', sub: 0 });
    assert.equal((await call('m2', 'status')).group.announcements.length, 1);
    assert.equal((await call('m12', 'status')).group.announcements.length, 0);
    assert.equal((await call('leader', 'announce', { text: '髒話' })).code, 'filtered');

    // 行程表：最後一個集合點在京都 → 結束時間改成京都的 23:59
    const before = (await call('leader', 'status')).group.endsAt;
    await call('leader', 'stop_add', { at: now + 3600000, tz: 'Asia/Taipei', place: '桃園機場 第一航廈' });
    r = await call('leader', 'stop_add', { at: now + 6 * 3600000, tz: 'Asia/Tokyo', place: '關西機場 南出口', lat: 34.43, lng: 135.24 });
    assert.equal(r.group.stops.length, 2);
    assert.equal(r.group.endsAt, before - 3600000);
    assert.equal(new Date(r.group.endsAt).toISOString(), '2026-11-21T14:59:59.999Z');

    // 我迷路了：團員按下才傳一次位置
    await call('m5', 'lost', { lat: 34.995, lng: 135.785 });
    r = await call('guide', 'status');
    assert.equal(r.group.lost.length, 1);
    assert.equal(r.group.lost[0].uid, 'm5');
    assert.equal(r.group.members.some((m) => 'lat' in m), false); // 名單裡沒有任何人的位置
    assert.equal((await call('leader', 'lost', { lat: 1, lng: 1 })).code, 'bad_request');

    // 旅行社買團購券 → 發給領隊 → 這一團升級，第 21 位就能入團
    r = await call('agency', 'buy_voucher', { purchase: { platform: 'apple', data: JSON.stringify({ bundleId: tg.BUNDLE_ID, productId: tg.PASS_PRODUCT, transactionId: '777' }) } });
    assert.equal(r.result, 'granted');
    const voucher = r.voucher;
    r = await call('agency', 'buy_voucher', { purchase: { platform: 'apple', data: JSON.stringify({ bundleId: tg.BUNDLE_ID, productId: tg.PASS_PRODUCT, transactionId: '777' }) } });
    assert.equal(r.result, 'exists');
    assert.equal(r.vouchers.length, 1);
    assert.equal((await call('guide', 'redeem', { voucher })).code, 'not_host');
    r = await call('leader', 'redeem', { voucher });
    assert.equal(r.group.paid, true);
    assert.equal(r.group.limit, 100);
    assert.equal((await call('agency', 'vouchers')).vouchers[0].used, true);
    assert.equal((await call('late', 'join', { code: g0.code, v })).success, true);

    // 換新 QR code：舊的失效
    await call('leader', 'rotate_qr');
    assert.equal((await call('late2', 'join', { code: g0.code, v })).code, 'qr');

    // 交棒給導遊：原團主變共同團主
    r = await call('leader', 'handoff', { uid: 'guide' });
    assert.equal(r.group.role, 'cohost');
    assert.equal((await call('guide', 'status')).group.role, 'host');

    // 解散：所有資料刪除
    r = await call('guide', 'dissolve');
    assert.equal(r.group, null);
    assert.equal((await call('m1', 'status')).group, null);
    assert.equal(run(['GET', tg.KEY.group(g0.code)]), null);
});

test('城市低語的低語團不受影響：使用不同的 Redis key', () => {
    const wg = require('./whispergroup');
    assert.notEqual(wg.KEY.group('ABCDEFGH'), tg.KEY.group('ABCDEFGH'));
    assert.notEqual(wg.KEY.of('u'), tg.KEY.of('u'));
    assert.notEqual(wg.KEY.activeCalls, tg.KEY.activeCalls);
});

test('單獨呼叫：只推給那一個人；沒有集合或點名時不送', async () => {
    let r = await call('lead2', 'create', { name: '單獨呼叫測試', color: 'blue', days: 1, tz: 'Asia/Taipei' });
    const code = r.group.code, v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('p1', 'join', { code, v });
    await call('p2', 'join', { code, v });
    assert.equal((await call('lead2', 'ping', { uid: 'p1' })).code, 'ended');
    await call('lead2', 'call', { at: now + 10 * 60000, tz: 'Asia/Taipei', place: '大廳', lat: 25, lng: 121 });
    pushes.length = 0;
    r = await call('lead2', 'ping', { uid: 'p1' });
    assert.equal(r.success, true);
    assert.deepEqual(pushes[0].uids, ['p1']);
    assert.equal((await call('p2', 'ping', { uid: 'p1' })).code, 'not_host');
    await call('lead2', 'dissolve');
});

test('推播用收件人自己的語言：記在 tgroup_lang，不讀城市低語的 user_data', async () => {
    let r = await call('lead3', 'create', { name: '語言測試', color: 'blue', days: 1, tz: 'Asia/Taipei' }, 'zh-Hant');
    const code = r.group.code, v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('en1', 'join', { code, v }, 'en');
    await call('zh1', 'join', { code, v }, 'zh-Hant');
    pushes.length = 0;
    await call('lead3', 'call', { at: now + 10 * 60000, tz: 'Asia/Taipei', place: '大廳', lat: 25, lng: 121 }, 'zh-Hant');
    const p = pushes.find((x) => x.data.type === 'tgroup_call');
    assert.deepEqual(Object.fromEntries(p.uids.map((u, i) => [u, p.langs[i]])), { en1: 'en', zh1: 'zh-Hant' });
    assert.equal(run(['HGET', tg.KEY.lang, 'en1']), 'en');
    await call('lead3', 'dissolve');
});

test('個人資料：暱稱與頭像存在 tgroup_profile，團主名單看得到；髒話擋下', async () => {
    const av = (u) => `https://firebasestorage.googleapis.com/v0/b/x/o/avatars%2F${u}.jpg?alt=media`;
    let r = await call('lead4', 'profile', { name: '阿導', avatar: av('lead4') });
    assert.deepEqual(r.profile, { name: '阿導', avatar: av('lead4') });
    assert.equal((await call('lead4', 'status')).profile.name, '阿導');
    r = await call('lead4', 'create', { name: '暱稱測試', color: 'blue', days: 1, tz: 'Asia/Taipei' });
    const code = r.group.code, v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('fan1', 'profile', { name: '小美', avatar: av('fan1') });
    await call('fan1', 'join', { code, v });
    r = await call('lead4', 'status');
    assert.equal(r.group.hostName, '阿導');
    assert.equal(r.group.staff[0].avatar, av('lead4'));
    assert.deepEqual(r.group.members.map((m) => [m.name, m.avatar]), [['小美', av('fan1')]]);
    assert.equal((await call('fan1', 'profile', { name: '髒話' })).code, 'filtered');
    await call('fan1', 'profile', { name: '', avatar: '' });
    assert.equal(run(['HGET', tg.KEY.profile, 'fan1']), null);
    await call('lead4', 'dissolve');
});

test('同團互相看得到：同意後分享位置、氣泡、私訊、封鎖；沒入團看不到；退團就刪除', async () => {
    let r = await call('lead5', 'create', { name: '互看測試', color: 'blue', days: 1, tz: 'Asia/Taipei' });
    const code = r.group.code, v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('a1', 'join', { code, v });
    await call('b1', 'join', { code, v });
    // 還沒同意：不能傳位置、不能傳訊息
    assert.equal((await call('a1', 'pos', { lat: 25.04, lng: 121.51 })).code, 'not_sharing');
    assert.equal((await call('a1', 'msg', { to: 'b1', text: '嗨' })).code, 'need_consent');
    for (const u of ['lead5', 'a1', 'b1']) await call(u, 'share', { consent: true, on: true });
    await call('a1', 'pos', { lat: 25.04, lng: 121.51 });
    await call('lead5', 'pos', { lat: 25.05, lng: 121.52 });
    await call('a1', 'bubble', { text: '在找廁所' });
    r = await call('b1', 'status');
    assert.deepEqual(r.group.people.map((p) => [p.uid, p.bubble]).sort(), [['a1', '在找廁所'], ['lead5', '']]);
    assert.equal(r.group.people.find((p) => p.uid === 'lead5').role, 'host');
    // 自己不在 people 裡
    assert.ok(!(await call('a1', 'status')).group.people.some((p) => p.uid === 'a1'));
    // 私訊：對方收到推播，雙方都看得到
    pushes.length = 0;
    r = await call('b1', 'msg', { to: 'a1', text: '我在大廳' });
    assert.equal(r.success, true);
    assert.deepEqual(pushes[0].uids, ['a1']);
    assert.equal(pushes[0].data.type, 'tgroup_msg');
    assert.equal(pushes[0].body, `${(await call('b1', 'status')).group.myNo} 號：我在大廳`);
    assert.equal((await call('a1', 'status')).group.messages[0].text, '我在大廳');
    assert.equal((await call('b1', 'status')).group.messages[0].mine, true);
    assert.equal((await call('b1', 'msg', { to: 'a1', text: '髒話' })).code, 'filtered');
    // 封鎖：對方的訊息不再送達、氣泡也看不到
    await call('b1', 'block', { uid: 'a1' });
    pushes.length = 0;
    assert.equal((await call('a1', 'msg', { to: 'b1', text: '還在嗎' })).success, true);
    assert.equal(pushes.length, 0);
    r = await call('b1', 'status');
    assert.equal(r.group.people.find((p) => p.uid === 'a1').bubble, '');
    assert.ok(!r.group.messages.some((m) => m.text === '還在嗎'));
    // 關掉分享：位置立刻刪除
    await call('a1', 'share', { on: false });
    assert.ok(!(await call('b1', 'status')).group.people.some((p) => p.uid === 'a1'));
    // 沒入團的人看不到任何人
    assert.equal((await call('stranger', 'status')).group, null);
    // 退團：位置、氣泡刪除
    await call('a1', 'share', { on: true });
    await call('a1', 'pos', { lat: 25.04, lng: 121.51 });
    await call('a1', 'leave');
    assert.equal(run(['HGET', tg.KEY.pos(code), 'a1']), null);
    assert.equal(run(['HGET', tg.KEY.bubble(code), 'a1']), null);
    // 解散：全部刪除
    await call('lead5', 'dissolve');
    assert.equal(run(['LRANGE', tg.KEY.msgs(code), '0', '-1']).length, 0);
    assert.equal(run(['HGETALL', tg.KEY.pos(code)]).length, 0);
});
