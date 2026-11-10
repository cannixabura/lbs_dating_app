const test = require('node:test');
const assert = require('node:assert');
const a = require('./assembly');

test('Q2 方案：時長、人數、商品、等級', () => {
    assert.deepStrictEqual([a.PLANS.q2_1h.minutes, a.PLANS.q2_1h.cap, a.PLANS.q2_1h.tier], [60, 200, 'q2']);
    assert.deepStrictEqual([a.PLANS.q2_2h.minutes, a.PLANS.q2_2h.cap, a.PLANS.q2_2h.tier], [120, 1000, 'q2']);
    assert.strictEqual(a.planOfProduct('assembly_q2_1h'), 'q2_1h');
    assert.strictEqual(a.planOfProduct('assembly_q2_2h'), 'q2_2h');
    assert.strictEqual(a.tierOf('free'), 'q3');
    assert.strictEqual(a.tierOf('1h'), 'q3');
    assert.strictEqual(a.tierOf('nope'), null);
});

test('Q2 主持席在第 2 圈 12 席，代號 Q2-1～Q2-12，彼此不重疊', () => {
    const seats = Array.from({ length: a.Q2_SEATS }, (_, i) => a.hostSeat(a.Q2_BASE + i));
    assert.ok(seats.every((s) => s.ring === 2));
    assert.deepStrictEqual(seats.map((s) => s.code), Array.from({ length: 12 }, (_, i) => `Q2-${i + 1}`));
    const keys = new Set(seats.map((s) => `${s.east.toFixed(3)},${s.north.toFixed(3)}`));
    assert.strictEqual(keys.size, 12);
    // 第 3 圈照舊
    assert.strictEqual(a.hostSeat(0).code, 'Q3-1');
});

test('空的主持席依等級分開找', () => {
    assert.strictEqual(a.freeHostSeat({}, 'q2'), 100);
    assert.strictEqual(a.freeHostSeat({ 0: 'x', 100: 'y' }, 'q2'), 101);
    assert.strictEqual(a.freeHostSeat({ 100: 'y' }, 'q3'), 0);
    const full = {};
    for (let i = 100; i < 112; i++) full[i] = 'z';
    assert.strictEqual(a.freeHostSeat(full, 'q2'), -1);
    assert.strictEqual(a.freeHostSeat(full), 0);
});

test('延長：券的等級要跟集會一樣', () => {
    const base = { startAt: 0, endAt: 3600e3, cap: 200, status: 'active' };
    assert.strictEqual(a.extend({ ...base, tier: 'q2' }, 'q2_1h', 1000).ok, true);
    assert.strictEqual(a.extend({ ...base, tier: 'q2' }, 'q2_2h', 1000).cap, 1000);
    assert.strictEqual(a.extend({ ...base, tier: 'q2' }, '1h', 1000).code, 'bad_plan');
    assert.strictEqual(a.extend({ ...base, tier: 'q3' }, 'q2_1h', 1000).code, 'bad_plan');
    // 舊資料沒有 tier：照舊可以用 Q3 券
    assert.strictEqual(a.extend(base, '1h', 1000).ok, true);
});

test('提問：清理、頻率與題數限制', () => {
    assert.strictEqual(a.cleanQuestion('  請問\n\n下一首  是什麼？ '), '請問 下一首 是什麼？');
    assert.strictEqual(Array.from(a.cleanQuestion('字'.repeat(200))).length, a.MAX_QUESTION);
    assert.strictEqual(a.canAsk({ count: 0, lastAt: 0 }, 100000).ok, true);
    assert.strictEqual(a.canAsk({ count: 1, lastAt: 90000 }, 100000).code, 'too_soon');
    assert.strictEqual(a.canAsk({ count: 5, lastAt: 0 }, 1e9).code, 'too_many');
});

test('台上來賓最多 3 人', () => {
    assert.strictEqual(a.canAddSpeaker(2, false), true);
    assert.strictEqual(a.canAddSpeaker(3, false), false);
    assert.strictEqual(a.canAddSpeaker(3, true), true);
    assert.strictEqual(a.roomOf('abc123abc123'), 'asm_abc123abc123');
});
