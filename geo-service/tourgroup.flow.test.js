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
        if (next === undefined) return { committed: false, snapshot: { val: () => store[path] ?? null } };
        store[path] = next;
        return { committed: true };
    },
});
const pushes = [];
let llmReply = null; // 假的 AI：測試裡設定回傳內容（Error 表示失敗）
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
    llm: async () => { if (llmReply instanceof Error) throw llmReply; return llmReply; },
});

async function call(uid, action, body = {}, lang) {
    let out;
    const res = { status: () => res, json: (x) => { out = x; return res; }, send: (x) => { out = x; return res; } };
    await tour.handle({ method: 'POST', uid, lang, headers: { 'x-app-build': uid === 'oldapp' ? undefined : '9' }, body: { action, ...body } }, res);
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
    // 5 天的團還沒買天數券：先在免費的第 3 天結束
    assert.equal(new Date(r.group.endsAt).toISOString(), '2026-11-19T14:59:59.999Z');
    assert.equal(r.group.daysNeeded, 1);

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

test('地圖上的人不會因為太久沒更新而消失：30 分鐘沒回應變灰；背景時送無聲推播，回 pong 就恢復；退團才拿掉', async () => {
    let r = await call('lead6', 'create', { name: '在線測試', color: 'blue', days: 1, tz: 'Asia/Taipei' });
    const code = r.group.code, v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('c1', 'join', { code, v });
    for (const u of ['lead6', 'c1']) await call(u, 'share', { consent: true, on: true });
    await call('c1', 'pos', { lat: 25.04, lng: 121.51 });
    const c1 = async () => (await call('lead6', 'status')).group.people.find((p) => p.uid === 'c1');
    assert.equal((await c1()).online, true);
    // 13 分鐘沒聯絡：該送無聲推播了（只送給 c1；團主剛剛才聯絡過）
    now += 13 * 60000;
    pushes.length = 0;
    await tour.remind();
    const ping = pushes.find((p) => p.data.type === 'tgroup_ping');
    assert.ok(ping && ping.uids.includes('c1'));
    // 回 pong：仍然在線，而且不會改掉推播語言
    await call('c1', 'pong', {}, 'en');
    assert.notEqual(run(['HGET', tg.KEY.lang, 'c1']), 'en');
    now += 20 * 60000;
    assert.equal((await c1()).online, true);
    // App 被關掉或關機：之後一直沒回應 → 超過 30 分鐘變灰，但還在地圖上（位置是最後一次的）
    now += 15 * 60000;
    const gone = await c1();
    assert.ok(gone, '超過 30 分鐘仍然在地圖上');
    assert.equal(gone.online, false);
    assert.equal(gone.lat, 25.04);
    // 再打開 App：恢復彩色
    await call('c1', 'status');
    assert.equal((await c1()).online, true);
    // 退團：從地圖拿掉，也不再送無聲推播
    await call('c1', 'leave');
    assert.ok(!(await call('lead6', 'status')).group.people.some((p) => p.uid === 'c1'));
    assert.equal(run(['ZSCORE', tg.KEY.pingDue, `${code}|c1`]), null);
    await call('lead6', 'dissolve');
});

test('出發日與天數：免費 3 天，天數券每張多 7 天（購買、團購券），最長 30 天；團主改天數', async () => {
    now = Date.UTC(2026, 10, 20, 1, 0); // 台北 11/20 09:00
    assert.equal((await call('t1', 'create', { name: '北海道十日', color: 'blue', days: 10, tz: 'Asia/Taipei', start: '2026-10-01' })).code, 'start');
    assert.equal((await call('t1', 'create', { name: '北海道十日', color: 'blue', days: 10, tz: 'Asia/Taipei', start: '2027-03-01' })).code, 'start'); // 超過 90 天
    let r = await call('t1', 'create', { name: '北海道十日', color: 'blue', days: 10, tz: 'Asia/Taipei', start: '2026-12-01' });
    assert.equal(r.group.startDate, '2026-12-01');
    assert.equal(r.group.endDate, '2026-12-03');
    assert.equal(r.group.allowedDays, 3);
    assert.equal(r.group.daysNeeded, 1);
    // 出發前就能入團
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    assert.equal((await call('t2', 'join', { code: r.group.code, v })).success, true);

    // 買一張天數券 → 10 天
    const buy = (id, productId) => call('t1', 'verify', { purchase: { platform: 'apple', data: JSON.stringify({ bundleId: tg.BUNDLE_ID, productId, transactionId: id }) } });
    r = await buy('d1', tg.DAYS_PRODUCT);
    assert.equal(r.result, 'granted');
    assert.equal(r.group.endDate, '2026-12-10');
    assert.equal(r.group.daysNeeded, 0);
    assert.equal(r.group.paid, false);
    // 同一筆購買再送一次不會多加
    r = await buy('d1', tg.DAYS_PRODUCT);
    assert.equal(r.result, 'granted');
    assert.equal(r.group.allowedDays, 10);

    // 改成 30 天：要再 3 張；用團購券補一張
    r = await call('t1', 'trip', { days: 30 });
    assert.equal(r.group.days, 30);
    assert.equal(r.group.endDate, '2026-12-10');
    assert.equal(r.group.daysNeeded, 3);
    r = await call('agency2', 'buy_voucher', { purchase: { platform: 'apple', data: JSON.stringify({ bundleId: tg.BUNDLE_ID, productId: tg.DAYS_PRODUCT, transactionId: 'dv1' }) } });
    assert.equal(r.vouchers[0].kind, 'days');
    r = await call('t1', 'redeem', { voucher: r.voucher });
    assert.equal(r.kind, 'days');
    assert.equal(r.group.endDate, '2026-12-17');
    await buy('d2', tg.DAYS_PRODUCT);
    r = await buy('d3', tg.DAYS_PRODUCT);
    assert.equal(r.group.allowedDays, 30);
    assert.equal(r.group.endDate, '2026-12-30');
    assert.equal((await buy('d4', tg.DAYS_PRODUCT)).code, 'max_days');
    // 人數券另外算
    r = await buy('p1', tg.PASS_PRODUCT);
    assert.equal(r.group.paid, true);
    assert.equal(r.group.allowedDays, 30);

    // 改出發日：整段往後移；不能改到過去；共同團主、團員不能改
    r = await call('t1', 'trip', { start: '2026-12-05' });
    assert.equal(r.group.endDate, '2027-01-03');
    assert.equal((await call('t1', 'trip', { start: '2026-11-01' })).code, 'start');
    assert.equal((await call('t2', 'trip', { days: 3 })).code, 'not_host');
    await call('t1', 'dissolve');
});

test('每日資訊卡、車輛、緊急聯絡、團員資料（只有團主看得到）；解散刪除', async () => {
    now = Date.UTC(2026, 10, 20, 1, 0);
    let r = await call('h1', 'create', { name: '東京三日', color: 'red', days: 3, tz: 'Asia/Tokyo', subs: ['1 號車', '2 號車'] });
    const code = r.group.code;
    const v = Number(new URL(r.group.qr).searchParams.get('v'));
    await call('u1', 'join', { code, v });

    r = await call('h1', 'day_set', {
        date: '2026-11-20', note: '早餐 7:00 一樓\n午餐自理',
        hotel: { name: '新宿王子飯店', addr: '東京都新宿区歌舞伎町1-30-1', phone: '+81-3-3205-1111 <script>', lat: 35.69, lng: 139.70 },
        links: [{ title: '淺草寺攻略', url: 'https://example.com/asakusa' }, { url: 'https://example.com/b' }],
    });
    assert.equal(r.success, true);
    let card = r.group.dayCards[0];
    assert.equal(card.hotel.phone, '+81-3-3205-1111');
    assert.equal(card.links[1].title, 'example.com/b');
    assert.equal((await call('h1', 'day_set', { date: '2026-11-20', links: [{ url: 'javascript:alert(1)' }] })).code, 'url');
    assert.equal((await call('h1', 'day_set', { date: '2026-11-20', note: '髒話' })).code, 'filtered');
    assert.equal((await call('u1', 'day_set', { date: '2026-11-20', note: 'x' })).code, 'not_host');
    r = await call('u1', 'status');
    assert.equal(r.group.dayCards.length, 1);
    // 全部清空 → 刪除這一天
    r = await call('h1', 'day_set', { date: '2026-11-20', note: '' });
    assert.equal(r.group.dayCards.length, 0);
    await call('h1', 'day_set', { date: '2026-11-21', note: '自由活動' });

    r = await call('h1', 'info_set', { buses: [{ sub: 0, plate: '品川 500 あ 12-34', driver: '佐藤', phone: '090-1234-5678' }, { sub: 5, plate: 'x' }] });
    assert.equal(r.code, 'bad_request');
    r = await call('h1', 'info_set', { buses: [{ sub: 0, plate: '品川 500 あ 12-34', driver: '佐藤', phone: '090-1234-5678' }, { sub: null }], emergency: { phone: '+886 912 345 678', agency: '雄獅旅遊', agencyPhone: '+886 2 1234 5678' } });
    assert.equal(r.group.info.buses.length, 1);
    assert.equal((await call('u1', 'status')).group.info.emergency.agency, '雄獅旅遊');

    // 團員資料：自己填；團主在名單看得到，其他團員看不到
    await call('u2', 'join', { code, v });
    r = await call('u1', 'mdata', { diet: '不吃牛', health: '花生過敏', contact: '媽媽', contactPhone: '0912-000-000' });
    assert.equal(r.group.myData.diet, '不吃牛');
    assert.equal('contactPhone' in r.group.myData, false); // 不收緊急聯絡人電話
    r = await call('h1', 'status');
    assert.equal(r.group.members.find((m) => m.uid === 'u1').data.health, '花生過敏');
    r = await call('u2', 'status');
    assert.equal(r.group.members, undefined);
    assert.equal(JSON.stringify(r.group).includes('花生過敏'), false);
    // 退團就刪除
    await call('u1', 'leave');
    assert.equal(run(['HGET', tg.KEY.mdata(code), 'u1']), null);
    await call('h1', 'dissolve');
    assert.equal(run(['GET', tg.KEY.info(code)]), null);
    assert.equal(run(['HGETALL', tg.KEY.days(code)]).length, 0);
});

test('集合前 15 分鐘自動提醒：集合呼叫與行程表都會；同一個時間只提醒一次', async () => {
    now = Date.UTC(2026, 10, 20, 1, 0);
    let r = await call('h2', 'create', { name: '大阪', color: 'gold', days: 2, tz: 'Asia/Tokyo' });
    const code = r.group.code;
    await call('w1', 'join', { code, v: Number(new URL(r.group.qr).searchParams.get('v')) });

    // 自由活動 3 小時後集合
    const at = now + 3 * 3600000;
    r = await call('h2', 'call', { at, tz: 'Asia/Tokyo', place: '道頓堀 固力果', lat: 34.67, lng: 135.50 });
    assert.equal(r.success, true);
    await call('w1', 'ack', { callId: r.group.call.id });
    // 行程表：同一個時間的集合點（有集合呼叫就不重複）＋ 晚一點的另一個
    await call('h2', 'stop_add', { at, tz: 'Asia/Tokyo', place: '道頓堀 固力果' });
    await call('h2', 'stop_add', { at: at + 3600000, tz: 'Asia/Tokyo', place: '飯店大廳' });

    pushes.length = 0;
    const loud = () => pushes.filter((p) => p.data.type !== 'tgroup_ping'); // 不算無聲推播
    now = at - 20 * 60000;
    await tour.remind();
    assert.equal(loud().length, 0);
    now = at - 15 * 60000;
    await tour.remind();
    assert.equal(loud().length, 1);
    assert.deepEqual(loud()[0].uids, ['w1']); // 按過收到的也會提醒
    assert.match(loud()[0].body, /還有 15 分鐘/);
    now += 60000;
    await tour.remind();
    assert.equal(loud().length, 1); // 只提醒一次

    now = at + 3600000 - 15 * 60000;
    await tour.remind();
    assert.equal(loud().length, 2);
    assert.equal(loud()[1].data.type, 'tgroup_stop');
    assert.match(loud()[1].body, /飯店大廳/);
    await call('h2', 'dissolve');
});

test('邀請碼：輸入入團、換新 QR code 後舊碼失效、輸錯太多次暫停、解散後失效', async () => {
    let r = await call('ih', 'create', { name: '大阪三日', color: 'blue', days: 3, tz: 'Asia/Tokyo' });
    assert.equal(r.success, true);
    const inv = r.group.invite;
    assert.match(inv, /^\d{8}$/);
    assert.equal(new URL(r.group.qr).searchParams.get('i'), inv);
    const code = r.group.code;

    // 用邀請碼入團（容許空白）；團員看不到邀請碼
    r = await call('ia', 'join', { invite: `${inv.slice(0, 4)} ${inv.slice(4)}` });
    assert.equal(r.success, true);
    assert.equal(r.group.code, code);
    assert.equal(r.group.invite, undefined);
    assert.equal((await call('ia', 'join', { invite: inv })).success, true); // 已經在團裡：當成功

    // 格式不對：不算輸錯
    assert.equal((await call('ib', 'join', { invite: '123' })).code, 'invite');

    // 換新 QR code：舊邀請碼、舊連結都失效，新的邀請碼可以用
    await call('ih', 'rotate_qr');
    const inv2 = (await call('ih', 'status')).group.invite;
    assert.match(inv2, /^\d{8}$/);
    assert.notEqual(inv2, inv);
    assert.equal((await call('ib', 'join', { invite: inv })).code, 'invite');
    assert.equal((await call('ib', 'join', { invite: inv2 })).success, true);

    // 亂猜：一小時內輸錯 10 次就暫停，連正確的也先不收
    const wrong = inv2 === '99999999' ? '99999998' : '99999999';
    for (let i = 0; i < 10; i++) assert.equal((await call('guess', 'join', { invite: wrong })).code, 'invite');
    assert.equal((await call('guess', 'join', { invite: inv2 })).code, 'invite_rate');

    // 舊的團（沒有邀請碼）：團主打開時補一個
    const raw = JSON.parse(run(['GET', tg.KEY.group(code)]));
    run(['DEL', tg.KEY.invite(inv2)]);
    run(['SET', tg.KEY.group(code), JSON.stringify({ ...raw, invite: undefined })]);
    const inv3 = (await call('ih', 'status')).group.invite;
    assert.match(inv3, /^\d{8}$/);
    assert.equal((await call('ic', 'join', { invite: inv3 })).success, true);

    // 解散後邀請碼失效
    await call('ih', 'dissolve');
    assert.equal(run(['GET', tg.KEY.invite(inv3)]), null);
    assert.equal((await call('id', 'join', { invite: inv3 })).code, 'invite');
});

test('領隊工具：手動點名、房號、飯店 Wi-Fi／早餐、艾婭匯入', async () => {
    let r = await call('th', 'create', { name: '北海道五日', color: 'green', days: 3, tz: 'Asia/Tokyo', subs: ['1 號車', '2 號車'] });
    const inv = r.group.invite;
    for (const u of ['ta', 'tb']) assert.equal((await call(u, 'join', { invite: inv })).success, true);

    // 手動點名：tb 沒手機，領隊幫他按到了；團員看到自己的是「到了」
    r = await call('th', 'rollcall', {});
    const rollId = r.group.rollRoster ? (await call('ta', 'status')).group.roll.id : null;
    assert.ok(rollId);
    assert.equal((await call('ta', 'mark', { rollId, uid: 'tb' })).code, 'not_host'); // 團員不能幫別人按
    r = await call('th', 'mark', { rollId, uid: 'tb' });
    assert.equal(r.group.rollRoster.here, 1);
    assert.equal(r.group.rollRoster.rows.find((x) => x.uid === 'tb').marked, true);
    assert.equal((await call('tb', 'status')).group.roll.mine, 'here');
    r = await call('th', 'mark', { rollId, uid: 'tb', on: false });
    assert.equal(r.group.rollRoster.here, 0);
    // 團員自己按的不會被「取消」清掉
    await call('ta', 'answer', { rollId, answer: 'here' });
    r = await call('th', 'mark', { rollId, uid: 'ta', on: false });
    assert.equal(r.group.rollRoster.here, 1);
    assert.equal((await call('th', 'mark', { rollId: 'old', uid: 'tb' })).code, 'ended');

    // 房號：單一設定、一次設定（含分組）；團員看到自己的房號
    await call('th', 'room', { uid: 'ta', room: '1203' });
    assert.equal((await call('ta', 'status')).group.myRoom, '1203');
    r = await call('th', 'rooms', { list: [{ uid: 'tb', room: '1205', sub: 1 }, { uid: 'th', room: '1201' }] });
    assert.equal(r.group.members.find((m) => m.uid === 'tb').room, '1205');
    assert.equal(r.group.members.find((m) => m.uid === 'tb').sub, 1);
    assert.equal(r.group.staffRooms.th, '1201');
    assert.equal((await call('tb', 'status')).group.myRoom, '1205');
    assert.equal((await call('th', 'rooms', { list: [{ uid: 'nobody', room: '1' }] })).code, 'bad_request');

    // 飯店 Wi-Fi、早餐
    const date = r.group.startDate;
    r = await call('th', 'day_set', { date, hotel: { name: 'JR Inn', wifi: 'JRINN / 12345678', breakfast: '6:30–9:30 2F' } });
    assert.equal(r.success, true);
    const hotel = (await call('ta', 'status')).group.dayCards[0].hotel;
    assert.equal(hotel.wifi, 'JRINN / 12345678');
    assert.equal(hotel.breakfast, '6:30–9:30 2F');

    // 艾婭匯入：預覽（不存），失敗不算次數，每團 5 次
    llmReply = {
        days: [{ date, note: '早餐在飯店', hotel: { name: 'JR Inn 札幌', addr: '札幌市中央區', phone: '', wifi: '', breakfast: '6:30' } }],
        stops: [{ date, time: '18:00', tz: 'Asia/Tokyo', place: '飯店大廳' }, { date, time: '25:00', tz: 'Asia/Tokyo', place: '錯的' }],
        rooms: [{ name: '王小明', room: '1203', group: '1 號車' }],
    };
    assert.equal((await call('ta', 'ai_import', { text: '第一天 18:00 飯店大廳集合' })).code, 'not_host');
    r = await call('th', 'ai_import', { text: '第一天 18:00 飯店大廳集合，住 JR Inn' });
    assert.equal(r.success, true);
    assert.equal(r.import.days[0].hotel.name, 'JR Inn 札幌');
    assert.equal(r.import.stops.length, 1);
    assert.equal(r.import.rooms[0].room, '1203');
    assert.equal(r.group.aiLeft, 4);
    assert.equal(r.group.stops.length, 0); // 還沒存
    llmReply = new Error('boom');
    assert.equal((await call('th', 'ai_import', { text: '第一天 18:00 飯店大廳集合' })).code, 'ai');
    assert.equal((await call('th', 'status')).group.aiLeft, 4);
    llmReply = { days: [], stops: [], rooms: [] };
    for (let i = 0; i < 4; i++) assert.equal((await call('th', 'ai_import', { text: '第一天 18:00 飯店大廳集合' })).success, true);
    assert.equal((await call('th', 'ai_import', { text: '第一天 18:00 飯店大廳集合' })).code, 'ai_limit');
    assert.equal((await call('th', 'ai_import', { text: '短' })).code, 'ai_empty');
    await call('th', 'dissolve');
});

test('送花感謝：最後一天起才能送、每人每位一次、最後一天提醒、解散後 3 天內還能送、公開名片', async () => {
    const start = now;
    let r = await call('fh', 'create', { name: '沖繩三日', color: 'pink', days: 1, tz: 'Asia/Tokyo' });
    const g0 = r.group;
    for (const u of ['fa', 'fb', 'fc', 'oldapp']) await call(u, 'join', { invite: g0.invite });
    await call('fh', 'cohost_add', { uid: 'fc' });

    // 1 天的團：開團當下就是最後一天 → 可以送；先測多天的情況用 status 的 open
    assert.equal((await call('fa', 'status')).group.thanks.open, true);
    r = await call('fa', 'thank', { to: 'fh', text: '謝謝你這幾天的照顧' });
    assert.equal(r.success, true);
    assert.deepEqual(r.group.thanks.sent, ['fh']);
    assert.ok(pushes.some((p) => p.data.type === 'tgroup_flower' && p.uids[0] === 'fh'));
    assert.equal((await call('fa', 'thank', { to: 'fh' })).code, 'already');
    assert.equal((await call('fa', 'thank', { to: 'fa' })).code, 'bad_request');
    assert.equal((await call('fa', 'thank', { to: 'fb' })).code, 'bad_request'); // 只能送給領隊
    assert.equal((await call('fa', 'thank', { to: 'fc', text: '髒話' })).code, 'filtered');
    assert.equal((await call('fa', 'thank', { to: 'fc' })).success, true); // 共同團主也可以收

    // 最後一天傍晚提醒：只提醒還沒送的團員（不含領隊）
    pushes.length = 0;
    now = g0.endsAt - 7 * 3600000 + 1000;
    await tour.remindThanks(now);
    const rem = pushes.find((p) => p.data.type === 'tgroup_thanks');
    assert.deepEqual(rem.uids, ['fb']); // 舊版 App（沒帶 build 號）不提醒

    // 領隊的名片：預設不公開；挑一則公開
    r = await call('fh', 'my_card');
    assert.equal(r.flowers, 1);
    assert.equal(r.card.pub, false);
    const id = r.thanks[0].id;
    r = await call('fh', 'card_set', { pub: true, intro: '帶團 10 年，日本線' });
    const slug = r.card.link.split('/l/')[1];
    assert.match(slug, /^[a-z2-9]{10}$/);
    let pub = await call(undefined, 'card', { slug });
    assert.equal(pub.card.flowers, 1);
    assert.equal(pub.card.thanks.length, 0);
    await call('fh', 'thank_pub', { id, pub: true });
    pub = await call(undefined, 'card', { slug });
    assert.equal(pub.card.thanks[0].text, '謝謝你這幾天的照顧');
    assert.equal(pub.card.intro, '帶團 10 年，日本線');
    assert.equal(pub.card.thanks[0].group, '沖繩三日');
    await call('fh', 'card_set', { pub: false });
    assert.equal((await call(undefined, 'card', { slug })).code, 'not_found');

    // 解散後：fb 還沒送 → 首頁問一次；3 天內可以送
    await call('fh', 'dissolve');
    r = await call('fb', 'status');
    assert.equal(r.group, null);
    assert.equal(r.ended.name, '沖繩三日');
    assert.equal(r.ended.staff.length, 2);
    assert.deepEqual(r.ended.sent, []);
    r = await call('fb', 'thank', { to: 'fh', text: '下次還要跟你的團' });
    assert.equal(r.success, true);
    assert.deepEqual(r.ended.sent, ['fh']);
    assert.equal((await call('fh', 'my_card')).flowers, 2);
    // 已經送過的 fa 在解散後也不能再送給同一位
    assert.equal((await call('fa', 'thank', { to: 'fh' })).code, 'already');
    // 沒入過這一團的人不能送
    assert.equal((await call('stranger', 'thank', { to: 'fh' })).code, 'no_group');
    now = start;
});

test('送花感謝：多天的團在最後一天以前不能送', async () => {
    let r = await call('mh', 'create', { name: '九州五日', color: 'gold', days: 3, tz: 'Asia/Tokyo' });
    await call('ma', 'join', { invite: r.group.invite });
    assert.equal((await call('ma', 'status')).group.thanks.open, false);
    assert.equal((await call('ma', 'thank', { to: 'mh' })).code, 'not_yet');
    await call('mh', 'dissolve');
});
