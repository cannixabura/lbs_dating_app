const test = require('node:test');
const assert = require('node:assert');
const p = require('./parallel');

const NOW = Date.parse('2026-10-27T12:00:00Z');
const C = p.CITY_BY_ID;
const at = (lat, lng) => { const c = p.cityOf(lat, lng); return c && c.id; };
// 離 city 中心車站往東 east、往北 north 公里的位置
const offset = (city, east, north) => ({
    lat: city.lat + north / 111.32,
    lng: city.lng + east / (111.32 * Math.cos(city.lat * Math.PI / 180)),
});

test('every Taiwan county belongs to its own central station', () => {
    assert.strictEqual(at(25.033, 121.5654), 'taipei'); // 台北 101
    assert.strictEqual(at(25.0129, 121.4625), 'taipei'); // 板橋（大台北）
    assert.strictEqual(at(25.1201, 121.2540), 'taoyuan'); // 大園
    assert.strictEqual(at(24.9537, 121.2257), 'taoyuan'); // 中壢
    assert.strictEqual(at(22.6273, 120.3014), 'kaohsiung');
    assert.strictEqual(at(25.1286, 121.7419), 'keelung');
    assert.strictEqual(at(23.0, 121.1), 'taitung'); // 東部海岸也有歸屬
    assert.strictEqual(at(23.57, 119.58), 'penghu');
    assert.strictEqual(at(24.43, 118.32), 'kinmen');
    assert.strictEqual(at(26.16, 119.94), 'matsu');
});

test('foreign cities belong to their central station, e.g. Yokohama is not Tokyo', () => {
    assert.strictEqual(at(35.6595, 139.7005), 'tokyo'); // 澀谷
    assert.strictEqual(at(35.4437, 139.6380), 'yokohama'); // 橫濱市役所
    assert.strictEqual(at(37.4979, 127.0276), 'seoul'); // 江南
    assert.strictEqual(at(3.1579, 101.7116), 'kualalumpur'); // 雙子星
    assert.strictEqual(at(-6.1754, 106.8272), 'jakarta'); // 獨立紀念碑
    assert.strictEqual(at(22.2783, 114.1747), 'hongkong');
    assert.strictEqual(at(1.3048, 103.8318), 'singapore'); // 烏節路
    assert.strictEqual(at(1.4927, 103.7414), null); // 新山市區（馬來西亞，不算新加坡）
    assert.strictEqual(at(40.7128, -74.006), null); // 沒有的城市
});

test('no city in mainland China', () => {
    for (const [lat, lng] of [
        [31.2304, 121.4737], [39.9042, 116.4074], [22.5431, 114.0579], [22.5333, 114.1167], // 上海、北京、深圳、羅湖
        [22.2707, 113.5767], [22.1300, 113.5300], // 珠海、橫琴
        [24.4798, 118.0894], [24.4900, 118.1800], [24.5600, 118.3300], // 廈門、廈門島東岸、大嶝
        [26.0745, 119.2965], [26.3200, 119.8000], [25.5000, 119.7900], // 福州、黃岐、平潭
    ]) assert.strictEqual(at(lat, lng), null, `${lat},${lng}`);
    assert.strictEqual(at(22.4950, 114.1380), 'hongkong'); // 上水
    assert.strictEqual(at(22.1940, 113.5420), 'macau');
    for (const c of p.CITIES) assert.ok(!['shanghai', 'beijing', 'shenzhen', 'guangzhou', 'xiamen'].includes(c.id));
});

test('only Taiwan ↔ other countries are paired', () => {
    assert.ok(p.paired(C.taichung, C.tokyo));
    assert.ok(p.paired(C.yokohama, C.taipei));
    assert.ok(!p.paired(C.taipei, C.taichung));
    assert.ok(!p.paired(C.tokyo, C.yokohama));
    assert.ok(!p.paired(C.tokyo, C.seoul));
});

test('the offset from the central station carries over 1:1', () => {
    // 台北車站東邊 3 公里 → 東京車站東邊約 3 公里
    const a = offset(C.taipei, 3, 0);
    const out = p.project(C.taipei, C.tokyo, a.lat, a.lng, 'u1', NOW);
    const { east, north } = p.toLocalKm(C.tokyo, out.lat, out.lng);
    assert.ok(Math.abs(east - 3) < 0.6 && Math.abs(north) < 0.6, `${east},${north}`);
    // 橫濱車站北邊 2 公里 → 台北車站北邊約 2 公里
    const b = offset(C.yokohama, 0, 2);
    const back = p.toLocalKm(C.taipei, ...Object.values(p.project(C.yokohama, C.taipei, b.lat, b.lng, 'u2', NOW)));
    assert.ok(Math.abs(back.north - 2) < 0.6 && Math.abs(back.east) < 0.6, `${back.east},${back.north}`);
});

test('the search area covers everyone who would land on the radar', () => {
    let seed = 7;
    const rnd = () => ((seed = (seed * 16807) % 2147483647) / 2147483647);
    const viewers = [[25.0478, 121.5170], [25.1201, 121.2540], [24.15, 120.66], [35.70, 139.70], [22.30, 114.17], [1.30, 103.85]];
    for (const [vlat, vlng] of viewers) {
        const vc = p.cityOf(vlat, vlng);
        for (const target of p.CITIES.filter((c) => p.paired(vc, c))) {
            const area = p.searchArea(vc, target, vlat, vlng, 5);
            const here = p.toLocalKm(vc, vlat, vlng);
            for (let i = 0; i < 200; i++) {
                // 雷達圈對過去附近的人
                const r = 7 * Math.sqrt(rnd()), a = 2 * Math.PI * rnd();
                const pos = offset(target, here.east + r * Math.cos(a), here.north + r * Math.sin(a));
                if (at(pos.lat, pos.lng) !== target.id) continue;
                const shown = p.project(target, vc, pos.lat, pos.lng, `u${i}`, NOW);
                if (p.distanceKm({ lat: vlat, lng: vlng }, shown) > 5) continue;
                assert.ok(p.distanceKm(area, pos) <= area.radiusKm, `${vc.id}→${target.id} missed`);
            }
        }
    }
});

test('moving inside a 500 m cell does not move the projected position', () => {
    const cellA = p.toLocalKm(C.taipei, 25.0401, 121.5301), cellB = p.toLocalKm(C.taipei, 25.0404, 121.5304);
    if (Math.floor(cellA.east / 0.5) !== Math.floor(cellB.east / 0.5) || Math.floor(cellA.north / 0.5) !== Math.floor(cellB.north / 0.5)) return;
    const a = p.project(C.taipei, C.tokyo, 25.0401, 121.5301, 'u3', NOW);
    const b = p.project(C.taipei, C.tokyo, 25.0404, 121.5304, 'u3', NOW);
    assert.ok(p.distanceKm(a, b) < 0.001);
});

test('the same person lands in the same place all day, different people differ', () => {
    const a = p.project(C.taipei, C.tokyo, 25.05, 121.52, 'u4', NOW);
    const b = p.project(C.taipei, C.tokyo, 25.05, 121.52, 'u4', NOW + 3600000);
    const c = p.project(C.taipei, C.tokyo, 25.05, 121.52, 'u5', NOW);
    assert.deepStrictEqual(a, b);
    assert.notDeepStrictEqual(a, c);
});

test('a Taiwan viewer searches only foreign cities, a foreign viewer only Taiwan', () => {
    const tw = p.searchCommands(C.taipei, C.taipei.lat, C.taipei.lng, 5, p.ALL_KEY);
    assert.ok(tw.others.length > 0 && tw.others.every((c) => c.country !== p.TAIWAN));
    assert.strictEqual(tw.commands[0][1], p.ALL_KEY);
    const jp = p.searchCommands(C.yokohama, C.yokohama.lat, C.yokohama.lng, 5, p.GEO_KEY);
    assert.ok(jp.others.length > 0 && jp.others.every((c) => c.country === p.TAIWAN));
});

test('city names follow the language', () => {
    assert.strictEqual(p.nameOf('yokohama', 'zh-Hant'), '橫濱');
    assert.strictEqual(p.nameOf('yokohama', 'ja'), '横浜');
    assert.strictEqual(p.nameOf('taoyuan', 'en'), 'Taoyuan');
    assert.strictEqual(p.nameOf('taipei', 'xx'), '台北');
    for (const c of p.CITIES) assert.strictEqual(c.names.length, 8, c.id);
});

test('one snapshot search reaches every city', () => {
    const cmd = p.snapshotCommand();
    assert.strictEqual(cmd[1], p.GEO_KEY);
    assert.ok(p.COVER.km < 20000);
});
