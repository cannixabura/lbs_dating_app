const test = require('node:test');
const assert = require('node:assert');
const t = require('./tourgroup');

const NOW = Date.UTC(2026, 10, 17, 1, 0); // 2026-11-17 09:00 台北
const mk = (extra = {}) => t.makeGroup({ host: 'h', name: '京都秋楓五日', color: 'violet', days: 5, tz: 'Asia/Taipei', ...extra }, NOW).group;

test('開團：結束日 23:59 以開團時區計算', () => {
  const g = mk();
  assert.equal(g.startDate, '2026-11-17');
  assert.equal(g.endDate, '2026-11-21');
  assert.equal(new Date(g.endsAt).toISOString(), '2026-11-21T15:59:59.999Z');
});

test('開團：檢查團名、團色、天數；無效時區改用台北', () => {
  assert.equal(t.makeGroup({ host: 'h', name: ' ', color: 'violet', days: 1 }, NOW).code, 'name');
  assert.equal(t.makeGroup({ host: 'h', name: 'a', color: 'black', days: 1 }, NOW).code, 'color');
  assert.equal(t.makeGroup({ host: 'h', name: 'a', color: 'violet', days: 8 }, NOW).code, 'days');
  assert.equal(t.makeGroup({ host: 'h', name: 'a', color: 'violet', days: 1, tz: 'Mars/Base' }, NOW).group.tz, 'Asia/Taipei');
});

test('結束時間跟著最後一個集合點的時區', () => {
  const g = mk();
  const stops = [{ at: NOW, tz: 'Asia/Taipei' }, { at: NOW + 86400000, tz: 'Asia/Tokyo' }];
  assert.equal(new Date(t.computeEndsAt(g, stops)).toISOString(), '2026-11-21T14:59:59.999Z');
});

test('時區工具：偏移、當地時間、夏令時間', () => {
  assert.equal(t.tzOffsetMin('Asia/Taipei', NOW), 480);
  assert.equal(t.tzOffsetMin('Asia/Tokyo', NOW), 540);
  assert.equal(t.localHm(Date.UTC(2026, 10, 18, 5, 30), 'Asia/Tokyo'), '14:30');
  // 雪梨 11 月是夏令時間 UTC+11
  assert.equal(new Date(t.endOfLocalDate('2026-11-20', 'Australia/Sydney')).toISOString(), '2026-11-20T12:59:59.999Z');
  assert.equal(t.validTz('Asia/Seoul'), true);
  assert.equal(t.validTz('nope'), false);
});

test('入團：人數上限 20，付費後 100；QR 換新後舊的失效', () => {
  const g = mk();
  assert.deepEqual(t.canJoin(g, { count: 5, qrVer: 1 }, NOW), { ok: true });
  assert.equal(t.canJoin(g, { count: 20, qrVer: 1 }, NOW).code, 'full');
  assert.equal(t.canJoin({ ...g, paid: true }, { count: 20, qrVer: 1 }, NOW).ok, true);
  assert.equal(t.canJoin({ ...g, paid: true }, { count: 100, qrVer: 1 }, NOW).code, 'paid_full');
  assert.equal(t.canJoin({ ...g, qrVer: 2 }, { count: 1, qrVer: 1 }, NOW).code, 'qr');
  assert.equal(t.canJoin(g, { count: 1, qrVer: 1 }, g.endsAt + 1).code, 'ended');
});

test('共同團主：最多 2 位、必須是團員、不能是團主', () => {
  const members = ['h', 'a', 'b', 'c'].map((uid, no) => ({ uid, no }));
  let g = mk();
  assert.equal(t.addCohost(g, 'h', members).code, 'bad_request');
  assert.equal(t.addCohost(g, 'x', members).code, 'bad_request');
  g = t.addCohost(g, 'a', members).group;
  g = t.addCohost(g, 'b', members).group;
  assert.equal(t.addCohost(g, 'c', members).code, 'cohost_full');
  assert.equal(t.roleOf(g, 'a'), 'cohost');
  assert.equal(t.isStaff(g, 'b'), true);
  assert.equal(t.roleOf(t.removeCohost(g, 'a'), 'a'), 'member');
});

test('分組與通知對象：不含團主、共同團主；可只通知一組', () => {
  assert.deepEqual(t.cleanSubs(['1 號車', ' 1 號車 ', '', '2 號車']).subs, ['1 號車', '2 號車']);
  assert.equal(t.cleanSubs(['1', '2', '3', '4', '5', '6', '7']).code, 'too_many');
  const g = { ...mk(), cohosts: ['a'], subs: ['1 號車', '2 號車'] };
  const members = [{ uid: 'h', sub: null }, { uid: 'a', sub: 0 }, { uid: 'm1', sub: 0 }, { uid: 'm2', sub: 1 }, { uid: 'm3', sub: null }];
  assert.deepEqual(t.targetUids(g, members, null), ['m1', 'm2', 'm3']);
  assert.deepEqual(t.targetUids(g, members, 1), ['m2']);
  assert.equal(t.validSub(g, 1), true);
  assert.equal(t.validSub(g, 2), false);
  assert.equal(t.validSub(g, -1), true);
});

test('集合呼叫：時間範圍、時區、對象；提醒只給這次的對象', () => {
  assert.equal(t.makeCall({ at: NOW + 4 * 3600000, lat: 35, lng: 135 }, NOW).code, 'time');
  assert.equal(t.makeCall({ at: NOW, lat: 999, lng: 135 }, NOW).code, 'place');
  const c = t.makeCall({ at: NOW + 15 * 60000, tz: 'Asia/Tokyo', place: '仁王門前', lat: 35, lng: 135.78, sub: 1, targets: ['m2'] }, NOW).call;
  assert.equal(c.tz, 'Asia/Tokyo');
  assert.equal(c.sub, 1);
  assert.deepEqual(t.dueReminders(c, ['m1', 'm2'], {}, NOW + 30000), []);
  assert.deepEqual(t.dueReminders(c, ['m1', 'm2'], {}, NOW + 61000), ['m2']);
  assert.deepEqual(t.dueReminders(c, ['m1', 'm2'], { m2: 'ack' }, NOW + 61000), []);
  assert.match(t.callText(c, NOW), /^\d\d:\d\d 到「仁王門前」集合，還有 15 分鐘$/);
});

test('點名名單：需要幫忙排最上面，統計到了／還要 5 分鐘', () => {
  const members = [{ uid: 'a', no: 1 }, { uid: 'b', no: 2 }, { uid: 'c', no: 3 }, { uid: 'd', no: 4 }];
  const r = t.rollRoster(members, { a: 'here', b: 'help', c: '5min' });
  assert.deepEqual(r.rows.map((x) => x.uid), ['b', 'd', 'c', 'a']);
  assert.equal(r.here, 1); assert.equal(r.late, 1); assert.equal(r.help, 1);
});

test('公告：最多 20 則；團員只看到全團與自己那組', () => {
  let list = [];
  for (let i = 0; i < 25; i++) list = t.pushAnnouncement(list, t.makeAnnouncement({ text: `第 ${i} 則`, sub: i % 2 ? 0 : null }, 'h', NOW + i).ann);
  assert.equal(list.length, 20);
  assert.equal(list[0].text, '第 24 則');
  assert.ok(t.visibleAnnouncements(list, 1, false).every((a) => a.sub === null));
  assert.equal(t.visibleAnnouncements(list, 1, true).length, 20);
  assert.equal(t.makeAnnouncement({ text: '   ' }, 'h', NOW).code, 'empty');
});

test('行程表：時間要在行程內、時區有效；依時間排序、同 id 取代', () => {
  const g = mk();
  assert.equal(t.makeStop({ at: NOW + 30 * 86400000, tz: 'Asia/Tokyo', place: 'x' }, g, NOW).code, 'time');
  assert.equal(t.makeStop({ at: NOW, tz: 'Bad/Zone', place: 'x' }, g, NOW).code, 'tz');
  const a = t.makeStop({ id: 'stopa', at: NOW + 7200000, tz: 'Asia/Tokyo', place: '關西機場' }, g, NOW).stop;
  const b = t.makeStop({ id: 'stopb', at: NOW + 3600000, tz: 'Asia/Taipei', place: '桃園機場', lat: 25.07, lng: 121.23 }, g, NOW).stop;
  let s = t.upsertStop([], a).stops;
  s = t.upsertStop(s, b).stops;
  assert.deepEqual(s.map((x) => x.id), ['stopb', 'stopa']);
  s = t.upsertStop(s, { ...a, place: '關西機場 南出口' }).stops;
  assert.equal(s.length, 2);
  assert.equal(t.removeStop(s, 'stopa').length, 1);
});

test('團購券：用過、過期、已付費都不能再用', () => {
  const g = mk();
  const v = t.makeVoucher('buyer', 'ta_1', NOW);
  assert.deepEqual(t.canRedeem(v, g, NOW), { ok: true });
  assert.equal(t.canRedeem({ ...v, usedBy: 'X' }, g, NOW).code, 'voucher_used');
  assert.equal(t.canRedeem(v, g, NOW + 401 * 86400000).code, 'voucher_expired');
  assert.equal(t.canRedeem(v, { ...g, paid: true }, NOW).code, 'already_paid');
  assert.equal(t.canRedeem(null, g, NOW).code, 'voucher_not_found');
  assert.equal(t.isVoucherCode(t.newVoucherCode()), true);
});

test('內購驗證：只接受旅行團自己的商品與 App', () => {
  const tx = { bundleId: 'com.softchip.tourchip', productId: 'tour_pass_7d', transactionId: '9' };
  assert.equal(t.applePass(tx).receipt, 'ta_9');
  assert.throws(() => t.applePass({ ...tx, bundleId: 'com.softchip.moodwhisper' }), /wrong_app/);
  assert.throws(() => t.applePass({ ...tx, productId: 'group_pass_7d' }), /unknown_product/);
  assert.equal(t.googlePass('tour_pass_7d', 'g_abc', { purchaseState: 0 }).receipt, 'tg_abc');
});
