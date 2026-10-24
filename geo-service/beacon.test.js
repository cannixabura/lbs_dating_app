const test = require('node:test');
const assert = require('node:assert');
const beacon = require('./beacon');

const row = (o) => ({ latitude: '25.03400000', longitude: '121.56450000', grade: '特優級', type2: '商業營業場所', diaper: '0', address: '臺北市信義區', ...o });

test('rows at the same spot merge into one site with its features', () => {
    const sites = beacon.buildSites([
        row({ number: 'A002', name: '台北101購物中心B1東-男廁所', type: '男廁所' }),
        row({ number: 'A001', name: '台北101購物中心B1東-性別友善廁所', type: '性別友善廁所' }),
        row({ number: 'A003', name: '台北101購物中心B1東-無障礙廁所', type: '無障礙廁所', diaper: '1' }),
    ]);
    assert.strictEqual(sites.length, 1);
    const s = sites[0];
    assert.strictEqual(s.id, 'A001');
    assert.strictEqual(s.name, '台北101購物中心B1東');
    assert.deepStrictEqual([s.gender, s.accessible, s.family], [true, true, true]);
    assert.deepStrictEqual(s.rooms, ['性別友善廁所', '無障礙廁所']);
});

test('drops failed grades, bad coordinates and plain toilets', () => {
    const sites = beacon.buildSites([
        row({ number: 'B1', name: 'X-無障礙廁所', type: '無障礙廁所', grade: '不合格' }),
        row({ number: 'B2', name: 'Y-無障礙廁所', type: '無障礙廁所', latitude: '35.6', longitude: '139.7' }),
        row({ number: 'B3', name: 'Z-男廁所', type: '男廁所', latitude: '24.1' }),
    ]);
    assert.strictEqual(sites.length, 0);
});

test('night is a guess from category and name', () => {
    assert.strictEqual(beacon.isNightLikely([{ type2: '交通', name: '台北車站' }]), true);
    assert.strictEqual(beacon.isNightLikely([{ type2: '商業營業場所', name: '中油鶯歌加油站-男廁' }]), true);
    assert.strictEqual(beacon.isNightLikely([{ type2: '民眾洽公場所', name: '新莊區公所1F-性別友善廁所' }]), false);
});

test('a flag needs 3 recent reports of the same problem', () => {
    const now = Date.UTC(2026, 9, 24);
    const old = now - beacon.REPORT_WINDOW_MS - 1;
    assert.deepStrictEqual(beacon.flagsFrom({ closed: { a: now, b: now } }, now), []);
    assert.deepStrictEqual(beacon.flagsFrom({ closed: { a: now, b: now, c: old } }, now), []);
    assert.deepStrictEqual(beacon.flagsFrom({ not_gender: { a: now, b: now, c: now } }, now), ['not_gender']);
    assert.strictEqual(beacon.validateReason('closed'), true);
    assert.strictEqual(beacon.validateReason('__proto__'), false);
});
