const test = require('node:test');
const assert = require('node:assert');
const p = require('./parallel');

const NOW = Date.parse('2026-10-27T12:00:00Z');
const taipei = p.CITY_BY_ID.taipei;
const tokyo = p.CITY_BY_ID.tokyo;

test('positions belong to the nearest city, or none', () => {
    assert.strictEqual(p.cityOf(25.033, 121.5654).id, 'taipei'); // 台北 101
    assert.strictEqual(p.cityOf(35.6595, 139.7005).id, 'tokyo'); // 澀谷
    assert.strictEqual(p.cityOf(22.2783, 114.1747).id, 'hongkong');
    assert.strictEqual(p.cityOf(24.15, 121.3), null); // 中央山脈
});

test('no city in mainland China', () => {
    assert.strictEqual(p.cityOf(31.2304, 121.4737), null); // 上海
    assert.strictEqual(p.cityOf(39.9042, 116.4074), null); // 北京
    assert.strictEqual(p.cityOf(22.5431, 114.0579), null); // 深圳市中心
    assert.strictEqual(p.cityOf(22.5333, 114.1167), null); // 羅湖
    assert.strictEqual(p.cityOf(22.2707, 113.5767), null); // 珠海
    assert.strictEqual(p.cityOf(22.1300, 113.5300), null); // 橫琴
    assert.strictEqual(p.cityOf(22.4950, 114.1380).id, 'hongkong'); // 上水
    assert.strictEqual(p.cityOf(22.4450, 114.0220).id, 'hongkong'); // 元朗
    assert.strictEqual(p.cityOf(22.1940, 113.5420).id, 'macau'); // 澳門半島
    assert.strictEqual(p.cityOf(22.1240, 113.5600).id, 'macau'); // 路環
    for (const c of p.CITIES) assert.ok(!['shanghai', 'beijing', 'shenzhen', 'guangzhou'].includes(c.id));
});

test('projection keeps the direction and the fraction of the radius', () => {
    // 台北中心往東 7.5 公里（半徑的一半）
    const pos = { lat: taipei.lat, lng: taipei.lng + 7.5 / (111.32 * Math.cos(taipei.lat * Math.PI / 180)) };
    const out = p.project(taipei, tokyo, pos.lat, pos.lng, 'u1', NOW);
    const { east, north } = p.toLocalKm(tokyo, out.lat, out.lng);
    assert.ok(Math.abs(east - 10) < 0.6, `east ${east}`); // 東京半徑 20 → 約 10 公里
    assert.ok(Math.abs(north) < 0.6, `north ${north}`);
});

test('people outside the radius are folded inside', () => {
    const far = { lat: taipei.lat + 25 / 111.32, lng: taipei.lng }; // 北邊 25 公里（半徑 15）
    const out = p.project(taipei, tokyo, far.lat, far.lng, 'u2', NOW);
    const d = p.distanceKm(tokyo, out);
    assert.ok(d >= 0.9 * tokyo.radiusKm - 0.5 && d <= tokyo.radiusKm + 0.5, `d ${d}`);
});

test('moving inside a 500 m cell does not move the projected position', () => {
    const a = p.project(taipei, tokyo, 25.0401, 121.5301, 'u3', NOW);
    const b = p.project(taipei, tokyo, 25.0401 + 0.0003, 121.5301 + 0.0003, 'u3', NOW); // 約 40 公尺
    const sameCell = p.distanceKm(a, b) < 0.001;
    // 剛好跨格時位置會跳一格；兩點都在同一格就必須完全相同
    const cellA = p.toLocalKm(taipei, 25.0401, 121.5301), cellB = p.toLocalKm(taipei, 25.0404, 121.5304);
    if (Math.floor(cellA.east / 0.5) === Math.floor(cellB.east / 0.5) && Math.floor(cellA.north / 0.5) === Math.floor(cellB.north / 0.5)) assert.ok(sameCell);
});

test('the same person lands in the same place all day, different people differ', () => {
    const a = p.project(taipei, tokyo, 25.05, 121.52, 'u4', NOW);
    const b = p.project(taipei, tokyo, 25.05, 121.52, 'u4', NOW + 3600000);
    const c = p.project(taipei, tokyo, 25.05, 121.52, 'u5', NOW);
    assert.deepStrictEqual(a, b);
    assert.notDeepStrictEqual(a, c);
});

test('search skips the viewer city', () => {
    const { others, commands } = p.searchCommands(taipei);
    assert.strictEqual(others.length, p.CITIES.length - 1);
    assert.ok(others.every((c) => c.id !== 'taipei'));
    assert.strictEqual(commands[0][1], p.GEO_KEY);
});
