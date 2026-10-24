const test = require('node:test');
const assert = require('node:assert');
const pm = require('./publicmood');

const now = Date.UTC(2026, 10, 28, 13);
const person = (lat, lng, mood, ago = 0) => ({ lat, lng, mood, lastSeen: now - ago });

test('points go to the nearest region, overseas points are dropped', () => {
    assert.strictEqual(pm.regionOf(25.0375, 121.5637), '大台北');
    assert.strictEqual(pm.regionOf(22.6273, 120.3014), '高雄');
    assert.strictEqual(pm.regionOf(24.4300, 118.3200), '金門');
    assert.strictEqual(pm.regionOf(37.33, -122.03), null);
});

test('regions under 10 people stay quiet; no counts leak in public output', () => {
    const people = [
        ...Array.from({ length: 12 }, (_, i) => person(25.04, 121.55, i < 8 ? '好開心' : '平靜地散步')),
        ...Array.from({ length: 3 }, () => person(22.63, 120.30, '難過')),
        person(25.04, 121.55, '開心', 30 * 3600 * 1000), // 超過 24 小時，不算
        person(37.33, -122.03, '開心'),                   // 國外，不算
    ];
    const s = pm.aggregate(people, now);
    assert.strictEqual(s.regions['大台北'].quiet, false);
    assert.deepStrictEqual(s.regions['大台北'].moods.map((m) => [m.key, m.percent]), [['joy', 67], ['calm', 33]]);
    assert.ok(!('count' in s.regions['大台北'].moods[0]));
    assert.deepStrictEqual(s.regions['高雄'], { total: 3, quiet: true });
    assert.strictEqual(s.taiwan.total, 15);
    assert.strictEqual(Object.keys(s.regions).length, 18);
});

test('hourly point keeps only the top mood per region', () => {
    const people = Array.from({ length: 10 }, () => person(24.15, 120.67, '好開心'));
    const h = pm.hourlyPoint(pm.aggregate(people, now));
    assert.deepStrictEqual(h.regions['台中'], { total: 10, top: 'joy', percent: 100 });
    assert.deepStrictEqual(h.regions['台南'], { total: 0, quiet: true });
});
