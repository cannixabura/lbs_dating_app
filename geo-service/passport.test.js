const test = require('node:test');
const assert = require('node:assert');
const pp = require('./passport');
const p = require('./parallel');

test('both sides must speak, from paired cities, before anyone gets a stamp', () => {
    const room = 'alice_bob';
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'taipei' }), []);
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'taipei', bob: 'tokyo' }), [{ uid: 'alice', city: 'tokyo' }, { uid: 'bob', city: 'taipei' }]);
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'taipei', bob: 'taichung' }), []); // 同一國不算
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'tokyo', bob: 'seoul' }), []); // 國外之間不配對
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'taipei', bob: '-' }), []);
    assert.deepStrictEqual(pp.stampsFor(room, { alice: 'taipei', bob: 'tokyo', _done: '1' }), []); // 只蓋一次
    assert.deepStrictEqual(pp.stampsFor('broken', { broken: 'taipei' }), []);
});

test('a stamp keeps only the city and the day, with names for every language', () => {
    const r = pp.stampRecord('osaka', 123);
    assert.deepStrictEqual(Object.keys(r).sort(), ['at', 'country', 'names']);
    assert.strictEqual(r.country, 'jp');
    assert.strictEqual(r.names.length, p.LANGS.length);
});

test('city of the speaker; outside every city is "-"', () => {
    assert.strictEqual(pp.cityField({ lat: 35.6812, lng: 139.7671 }), 'tokyo');
    assert.strictEqual(pp.cityField({ lat: 40.71, lng: -74.0 }), '-');
    assert.strictEqual(pp.cityField(null), '-');
});

test('five cities earn the passport orb', () => {
    assert.ok(!pp.earnsReward(4));
    assert.ok(pp.earnsReward(5));
    assert.strictEqual(pp.REWARD_STYLE, 'passport');
});
