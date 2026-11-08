const test = require('node:test');
const assert = require('node:assert');
const a = require('./assembly');
const q = require('./quantum');

test('host seats are the 18 seats of ring 3, Q3-1 to Q3-18, 300 m from 101', () => {
    const seats = Array.from({ length: a.RING_SEATS }, (_, i) => a.hostSeat(i));
    assert.strictEqual(seats[0].code, 'Q3-1');
    assert.strictEqual(seats[17].code, 'Q3-18');
    for (const s of seats) {
        assert.strictEqual(s.ring, 3);
        const d = Math.hypot(s.east, s.north);
        assert.ok(d > 250 && d <= 301, `${s.code} ${d}`);
    }
    // 不會和一般使用者的第一個席位（第 4 圈）重疊
    assert.strictEqual(q.seat(0).ring, 4);
});

test('first free host seat; full ring gives -1', () => {
    assert.strictEqual(a.freeHostSeat({}), 0);
    assert.strictEqual(a.freeHostSeat({ 0: 'x', 1: 'y' }), 2);
    assert.strictEqual(a.freeHostSeat({ 0: 'x', 2: 'y' }), 1);
    const full = Object.fromEntries(Array.from({ length: 18 }, (_, i) => [i, 'z']));
    assert.strictEqual(a.freeHostSeat(full), -1);
});

test('plans and products', () => {
    assert.deepStrictEqual([a.PLANS.free.minutes, a.PLANS.free.cap], [30, 50]);
    assert.deepStrictEqual([a.PLANS['1h'].minutes, a.PLANS['1h'].cap], [60, 200]);
    assert.deepStrictEqual([a.PLANS['2h'].minutes, a.PLANS['2h'].cap], [120, 1000]);
    assert.strictEqual(a.planOfProduct('assembly_q3_1h'), '1h');
    assert.strictEqual(a.planOfProduct('assembly_q3_2h'), '2h');
    assert.strictEqual(a.planOfProduct('orb_rainbow'), null);
});

test('free assembly resets each Taipei month', () => {
    assert.strictEqual(a.monthKey(Date.parse('2026-11-30T15:59:00Z')), '2026-11'); // 台北 23:59
    assert.strictEqual(a.monthKey(Date.parse('2026-11-30T16:00:00Z')), '2026-12'); // 台北 12/1 00:00
});

test('title and announcement are trimmed and capped', () => {
    assert.strictEqual(a.cleanTitle('  生日\n快樂  '), '生日 快樂');
    assert.strictEqual(Array.from(a.cleanTitle('字'.repeat(40))).length, 20);
    assert.strictEqual(Array.from(a.cleanAnnounce('a'.repeat(300))).length, 100);
    assert.strictEqual(a.cleanTitle('   '), '');
});

test('cheer fires at the same server moment, with a small lead even when immediate', () => {
    assert.strictEqual(a.cheerFireAt(1000, 0), 2500);
    assert.strictEqual(a.cheerFireAt(1000, 10), 11000);
    assert.ok(a.validCountdown(5) && !a.validCountdown(7));
    assert.ok(a.validColor('#FF8AD8') && !a.validColor('#000000'));
});

test('who can join', () => {
    const base = { status: 'active', count: 10, cap: 50, removed: false, isHost: false };
    assert.ok(a.canJoin(base).ok);
    assert.strictEqual(a.canJoin({ ...base, count: 50 }).code, 'full');
    assert.strictEqual(a.canJoin({ ...base, removed: true }).code, 'removed');
    assert.strictEqual(a.canJoin({ ...base, isHost: true }).code, 'host');
    assert.strictEqual(a.canJoin({ ...base, status: 'ended' }).code, 'ended');
});

test('memorial card merges small regions into other', () => {
    assert.deepStrictEqual(a.regionSummary({ tw: '12', jp: '2', kr: '5', sea: '1', other: '1' }), { tw: 12, kr: 5, other: 4 });
    assert.deepStrictEqual(a.regionSummary({}), {});
});

test('ends only when time is up', () => {
    assert.strictEqual(a.shouldEnd({ endAt: 100, hostBeat: 99 }, 100), 'time');
    // 主持人不在量子世界也不結束，只看時間
    assert.strictEqual(a.shouldEnd({ endAt: 10 ** 9 }, 10 ** 8), null);
    assert.strictEqual(a.shouldEnd({ endAt: 10 ** 9, hostBeat: 1000 }, 2000), null);
});

test('extend with a pass: later end, bigger cap, 12-hour limit', () => {
    const H = 3600 * 1000;
    const base = { startAt: 0, endAt: 30 * 60 * 1000, cap: 50, status: 'active' };
    assert.deepStrictEqual(a.extend(base, '1h', 1000), { ok: true, endAt: 90 * 60 * 1000, cap: 200 });
    assert.deepStrictEqual(a.extend({ ...base, cap: 1000 }, '1h', 1000), { ok: true, endAt: 90 * 60 * 1000, cap: 1000 });
    assert.deepStrictEqual(a.extend(base, '2h', 1000), { ok: true, endAt: 150 * 60 * 1000, cap: 1000 });
    assert.strictEqual(a.extend(base, 'free', 1000).code, 'bad_plan');
    assert.strictEqual(a.extend(base, 'x', 1000).code, 'bad_plan');
    assert.strictEqual(a.extend({ ...base, status: 'ended' }, '1h', 1000).code, 'ended');
    assert.strictEqual(a.extend(base, '1h', base.endAt).code, 'ended');
    assert.strictEqual(a.extend({ ...base, endAt: 11 * H }, '2h', 1000).code, 'too_long');
    assert.strictEqual(a.extend({ ...base, endAt: 11 * H }, '1h', 1000).ok, true);
});
