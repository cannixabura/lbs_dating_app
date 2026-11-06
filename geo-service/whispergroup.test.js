const test = require('node:test');
const assert = require('node:assert');
const g = require('./whispergroup');

const NOW = Date.parse('2026-11-06T10:00:00+08:00');

test('newCode：8 碼、只用不易看錯的字元', () => {
    const code = g.newCode();
    assert.strictEqual(code.length, 8);
    assert.ok(g.isCode(code));
    assert.strictEqual(g.isCode('ABCDEFG1'), false); // 1 不在字元表
    assert.strictEqual(g.newCode(() => Buffer.alloc(8, 0)), 'AAAAAAAA');
});

test('makeGroup：團名、團色、1～7 天，結束在最後一天台北 23:59', () => {
    const r = g.makeGroup({ host: 'h', name: '  西門町  夜遊團 ', color: 'violet', days: 3 }, NOW);
    assert.strictEqual(r.ok, true);
    assert.strictEqual(r.group.name, '西門町 夜遊團');
    assert.strictEqual(r.group.endsAt, Date.parse('2026-11-08T23:59:59.999+08:00'));
    assert.strictEqual(r.group.paid, false);
    assert.deepStrictEqual(g.makeGroup({ host: 'h', name: '', color: 'violet', days: 1 }, NOW), { ok: false, code: 'name' });
    assert.deepStrictEqual(g.makeGroup({ host: 'h', name: 'a', color: 'black', days: 1 }, NOW), { ok: false, code: 'color' });
    assert.deepStrictEqual(g.makeGroup({ host: 'h', name: 'a', color: 'gold', days: 8 }, NOW), { ok: false, code: 'days' });
    assert.strictEqual(g.makeGroup({ host: 'h', name: 'x'.repeat(30), color: 'gold', days: 1 }, NOW).group.name.length, 20);
});

test('canJoin：20 人以內免費，付費後 100 人；換新 QR code 舊的失效', () => {
    const grp = g.makeGroup({ host: 'h', name: '團', color: 'teal', days: 1 }, NOW).group;
    assert.deepStrictEqual(g.canJoin(grp, { count: 19, qrVer: 1 }, NOW), { ok: true });
    assert.deepStrictEqual(g.canJoin(grp, { count: 20, qrVer: 1 }, NOW), { ok: false, code: 'full' });
    assert.deepStrictEqual(g.canJoin({ ...grp, paid: true }, { count: 20, qrVer: 1 }, NOW), { ok: true });
    assert.deepStrictEqual(g.canJoin({ ...grp, paid: true }, { count: 100, qrVer: 1 }, NOW), { ok: false, code: 'paid_full' });
    assert.deepStrictEqual(g.canJoin({ ...grp, qrVer: 2 }, { count: 1, qrVer: 1 }, NOW), { ok: false, code: 'qr' });
    assert.deepStrictEqual(g.canJoin(grp, { count: 1, qrVer: 1, alreadyMember: true }, NOW), { ok: false, code: 'already' });
    assert.deepStrictEqual(g.canJoin(grp, { count: 1, qrVer: 1 }, grp.endsAt + 1), { ok: false, code: 'ended' });
});

test('nextNumber：團號接著最大的編', () => {
    assert.strictEqual(g.nextNumber([]), 1);
    assert.strictEqual(g.nextNumber([{ no: 0 }, { no: 1 }, { no: 4 }]), 5);
});

test('makeCall：集合時間在現在到 3 小時內，集合點要有座標', () => {
    const r = g.makeCall({ at: NOW + 15 * 60000, place: '捷運西門站 6 號出口', lat: 25.042, lng: 121.508 }, NOW);
    assert.strictEqual(r.ok, true);
    assert.strictEqual(r.call.place, '捷運西門站 6 號出口');
    assert.deepStrictEqual(g.makeCall({ at: NOW + 4 * 3600000, lat: 25, lng: 121 }, NOW), { ok: false, code: 'time' });
    assert.deepStrictEqual(g.makeCall({ at: NOW, lat: 'x', lng: 121 }, NOW), { ok: false, code: 'place' });
    assert.strictEqual(g.callLive(r.call, r.call.at + 29 * 60000), true);
    assert.strictEqual(g.callLive(r.call, r.call.at + 31 * 60000), false);
});

test('dueReminders：沒收到的人每 60 秒提醒、最多 3 次、集合時間到就停', () => {
    const call = { at: NOW + 10 * 60000, sentAt: NOW, remind: { b: 3 } };
    assert.deepStrictEqual(g.dueReminders(call, ['a', 'b', 'c'], { c: 'ack' }, NOW + 30000), []); // 未滿 60 秒
    assert.deepStrictEqual(g.dueReminders(call, ['a', 'b', 'c'], { c: 'ack' }, NOW + 61000), ['a']); // b 已滿 3 次、c 已收到
    assert.deepStrictEqual(g.dueReminders(call, ['a'], { a: 'seen' }, NOW + 61000), ['a']); // 看了沒回也要提醒
    assert.deepStrictEqual(g.dueReminders(call, ['a'], {}, call.at), []);
});

test('callRoster／rollRoster：沒反應、需要幫忙排最上面', () => {
    const members = [{ uid: 'a', no: 1 }, { uid: 'b', no: 2 }, { uid: 'c', no: 3 }];
    const c = g.callRoster(members, { a: 'ack', c: 'seen' });
    assert.deepStrictEqual(c.rows.map((r) => r.uid), ['b', 'c', 'a']);
    assert.strictEqual(c.acked, 1);
    const r = g.rollRoster(members, { a: 'here', b: 'help', c: 'bogus' });
    assert.deepStrictEqual(r.rows.map((x) => x.answer), ['help', 'none', 'here']);
    assert.strictEqual(r.here, 1);
    assert.strictEqual(r.help, 1);
});

test('applePass／googlePass：只認 group_pass_7d', () => {
    const b = 'com.softchip.moodwhisper';
    assert.deepStrictEqual(g.applePass({ bundleId: b, productId: 'group_pass_7d', transactionId: '9' }, b), { receipt: 'a_9', productId: 'group_pass_7d' });
    assert.throws(() => g.applePass({ bundleId: b, productId: 'aiya_time_5', transactionId: '9' }, b), /unknown_product/);
    assert.throws(() => g.applePass({ bundleId: b, productId: 'group_pass_7d', transactionId: '9', revocationDate: 1 }, b), /revoked/);
    assert.deepStrictEqual(g.googlePass('group_pass_7d', 'g_x', { purchaseState: 0 }), { receipt: 'g_x', productId: 'group_pass_7d' });
    assert.throws(() => g.googlePass('group_pass_7d', 'g_x', { purchaseState: 2 }), /not_paid/);
});
