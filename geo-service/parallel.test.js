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

test('the outer ring maps to the outer ring, so 桃園 sees and is seen', () => {
    const taoyuan = { lat: 25.1201, lng: 121.2540 }; // 離台北車站約 28 公里
    assert.strictEqual(p.cityOf(taoyuan.lat, taoyuan.lng).id, 'taipei');
    const out = p.project(taipei, tokyo, taoyuan.lat, taoyuan.lng, 'u2', NOW);
    const d = p.distanceKm(tokyo, out);
    // 台北外圍 12.7 公里 → 東京外圍同樣約 12.7 公里（兩邊外圍都是 30 公里）
    assert.ok(d > tokyo.radiusKm + 11 && d < tokyo.radiusKm + 14.5, `d ${d}`);
    // 反過來：東京外圍的人投影到台北，也落在桃園附近
    const back = p.project(tokyo, taipei, out.lat, out.lng, 'u6', NOW);
    assert.ok(p.distanceKm(back, taoyuan) < 3, `back ${p.distanceKm(back, taoyuan)}`);
});

test('cities without an outer ring put outer people just inside the edge', () => {
    const hk = p.CITY_BY_ID.hongkong;
    const far = { lat: taipei.lat + 40 / 111.32, lng: taipei.lng }; // 台北北邊 40 公里（外圍）
    const d = p.distanceKm(hk, p.project(taipei, hk, far.lat, far.lng, 'u7', NOW));
    assert.ok(d >= 0.9 * hk.radiusKm - 0.5 && d <= hk.radiusKm + 0.5, `d ${d}`);
});

test('the search area covers everyone who would land on the radar', () => {
    let seed = 7;
    const rnd = () => ((seed = (seed * 16807) % 2147483647) / 2147483647);
    const viewers = [
        [taipei, 25.0478, 121.5170], [taipei, 25.1201, 121.2540], [taipei, 24.95, 121.70],
        [p.CITY_BY_ID.hongkong, 22.45, 114.05], [p.CITY_BY_ID.macau, 22.13, 113.56], [tokyo, 35.90, 139.50],
    ];
    for (const [vc, vlat, vlng] of viewers) {
        for (const target of p.CITIES.filter((c) => c.id !== vc.id)) {
            const area = p.searchArea(vc, target, vlat, vlng, 5);
            for (let i = 0; i < 400; i++) {
                const r = (target.radiusKm + (target.foldKm ?? 30)) * Math.sqrt(rnd()), a = 2 * Math.PI * rnd();
                const pos = { lat: target.lat + r * Math.sin(a) / 111.32, lng: target.lng + r * Math.cos(a) / (111.32 * Math.cos(target.lat * Math.PI / 180)) };
                const home = p.cityOf(pos.lat, pos.lng);
                if (!home || home.id !== target.id) continue;
                const shown = p.project(target, vc, pos.lat, pos.lng, `u${i}`, NOW);
                if (p.distanceKm({ lat: vlat, lng: vlng }, shown) > 5) continue;
                assert.ok(p.distanceKm(area, pos) <= area.radiusKm, `${vc.id}→${target.id} missed ${p.distanceKm(area, pos)} > ${area.radiusKm}`);
            }
        }
    }
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
    const { others, commands } = p.searchCommands(taipei, taipei.lat, taipei.lng, 5, p.ALL_KEY);
    assert.strictEqual(others.length, p.CITIES.length - 1);
    assert.ok(others.every((c) => c.id !== 'taipei'));
    assert.strictEqual(commands[0][1], p.ALL_KEY);
});

test('one snapshot search reaches every city', () => {
    const cmd = p.snapshotCommand();
    assert.strictEqual(cmd[1], p.GEO_KEY);
    for (const c of p.CITIES) assert.ok(p.distanceKm(p.COVER, c) < p.COVER.km * 1.2); // 平面近似只做粗檢
});
