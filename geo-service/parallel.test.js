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
    assert.strictEqual(at(1.4927, 103.7414), 'johorbahru'); // 新山市區（馬來西亞，不算新加坡）
    assert.strictEqual(at(40.7128, -74.006), null); // 沒有的城市
});

test('no city in mainland China', () => {
    for (const [lat, lng] of [
        [31.2304, 121.4737], [39.9042, 116.4074], [22.5431, 114.0579], [22.5333, 114.1167], // 上海、北京、深圳、羅湖
        [22.2707, 113.5767], [22.1300, 113.5300], // 珠海、橫琴
        [24.4798, 118.0894], [24.4900, 118.1800], [24.5600, 118.3300], // 廈門、廈門島東岸、大嶝
        [26.0745, 119.2965], [26.3200, 119.8000], [25.5000, 119.7900], // 福州、黃岐、平潭
        [21.547, 107.972], [22.094, 106.755], [22.817, 108.366], [22.507, 103.95], [20.044, 110.199], [18.253, 109.512], // 東興、憑祥、南寧、河口、海口、三亞（越南邊境與海南）
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
    for (const c of p.CITIES) assert.strictEqual(c.names.length, p.LANGS.length, c.id);
    assert.strictEqual(p.nameOf('tokyo', 'pt'), 'Tóquio');
    assert.strictEqual(p.nameOf('tokyo', 'fr'), '東京'); // 不認得的語言用繁中（伺服器 i18n 會先把未知語言換成英文）
    assert.strictEqual(p.nameOf('saopaulo', 'hi'), 'साओ पाउलो');
});

test('one snapshot search reaches every city', () => {
    const cmd = p.snapshotCommand();
    assert.strictEqual(cmd[1], p.GEO_KEY);
    assert.ok(p.COVER.km < 20000);
});

test('Bangkok, Manila and Sydney pair with Taiwan', () => {
    for (const [id, lat, lng] of [['bangkok', 13.7563, 100.5018], ['manila', 14.5995, 120.9842], ['sydney', -33.8688, 151.2093]]) {
        const city = p.cityOf(lat, lng);
        assert.strictEqual(city && city.id, id);
        assert.ok(p.paired(city, p.CITY_BY_ID.taipei));
    }
    assert.strictEqual(p.nameOf('bangkok', 'th'), 'กรุงเทพฯ');
    assert.strictEqual(p.nameOf('sydney', 'zh-Hant'), '雪梨');
});

test('new cities: each place goes to its own centre', () => {
    for (const [id, lat, lng] of [
        ['kanazawa', 36.5613, 136.6562], ['kumamoto', 32.8031, 130.7079], ['kagoshima', 31.5966, 130.5571], ['hakodate', 41.7687, 140.7288],
        ['saitama', 35.8617, 139.6455], ['kawasaki', 35.5308, 139.7029], ['nara', 34.6851, 135.8048], ['matsuyama', 33.8392, 132.7657],
        ['incheon', 37.4602, 126.4407], ['jeju', 33.4890, 126.4983],
        ['haiphong', 20.8449, 106.6881], ['hue', 16.4637, 107.5909], ['nhatrang', 12.2388, 109.1967], ['dalat', 11.9404, 108.4583], ['cantho', 10.0452, 105.7469],
        ['johorbahru', 1.4655, 103.7578], ['melaka', 2.1896, 102.2501], ['ipoh', 4.5975, 101.0901], ['kuching', 1.5533, 110.3592], ['kotakinabalu', 5.9788, 116.0753],
        ['chiangmai', 18.7883, 98.9853], ['cebu', 10.3157, 123.8854], ['makati', 14.5547, 121.0244],
        ['melbourne', -37.8136, 144.9631], ['perth', -31.9523, 115.8613],
    ]) assert.strictEqual(at(lat, lng), id, id);
});

test('Singapore, Johor Bahru and Batam do not swallow each other', () => {
    assert.strictEqual(at(1.4360, 103.7860), 'singapore'); // 兀蘭（新加坡）
    assert.strictEqual(at(1.2494, 103.8303), 'singapore'); // 聖淘沙
    assert.strictEqual(at(1.3644, 103.9915), 'singapore'); // 樟宜
    assert.strictEqual(at(1.4927, 103.7414), 'johorbahru'); // 新山市區
    assert.strictEqual(at(1.1301, 104.0529), 'batam');
});

test('every new city has nine names and a unique id', () => {
    const ids = new Set();
    for (const c of p.CITIES) {
        assert.ok(!ids.has(c.id), c.id); ids.add(c.id);
        assert.ok(c.names.every((n) => typeof n === 'string' && n.length > 0), c.id);
        assert.ok(p.reachKm(c) > 0 && (c.country === p.TAIWAN || p.reachKm(c) < 80), c.id);
    }
});

test('radar searches only cities that have someone right now', () => {
    const results = p.CITIES.map((c) => (c.id === 'tokyo' || c.id === 'cebu' ? [['u1']] : []));
    const live = p.liveCities(results);
    assert.deepStrictEqual([...live].sort(), ['cebu', 'tokyo']);
    assert.strictEqual(p.liveCheckCommands().length, p.CITIES.length);
    const { others, commands } = p.searchCommands(C.taipei, C.taipei.lat, C.taipei.lng, 5, p.ALL_KEY, live);
    assert.deepStrictEqual(others.map((c) => c.id).sort(), ['cebu', 'tokyo']);
    assert.strictEqual(commands.length, 2);
    assert.ok(p.searchCommands(C.taipei, C.taipei.lat, C.taipei.lng, 5, p.ALL_KEY).others.length > 100);
});

test('parallel coordinates: your spot mirrored into every paired city, blurred like everyone else sees it', () => {
    const a = offset(C.taipei, 3, 1);
    const m = p.mirrors(a.lat, a.lng, 'u9', NOW, 'zh-Hant');
    assert.strictEqual(m.home.id, 'taipei');
    assert.strictEqual(m.home.name, '台北');
    assert.ok(Math.abs(m.east - 3) < 0.6 && Math.abs(m.north - 1) < 0.6);
    assert.ok(m.list.length > 100 && m.list.every((c) => c.country !== p.TAIWAN));
    const tokyo = m.list.find((c) => c.id === 'tokyo');
    const seen = p.project(C.taipei, C.tokyo, a.lat, a.lng, 'u9', NOW);
    assert.ok(p.distanceKm(tokyo, seen) < 0.01); // 跟東京的人看到你的位置一樣
    assert.strictEqual(tokyo.name, '東京');
    assert.strictEqual(p.mirrors(40.7128, -74.006, 'u9', NOW, 'en'), null);
    const back = p.mirrors(C.tokyo.lat, C.tokyo.lng, 'u9', NOW, 'ja');
    assert.ok(back.list.every((c) => c.country === p.TAIWAN) && back.list.find((c) => c.id === 'taipei').name === '台北');
});

test('parallel coordinates never point into mainland China or outside the city', () => {
    const north = offset(C.taipei, 0, 25); // 台北車站北邊 25 公里 → 香港站北邊 25 公里已是深圳
    const m = p.mirrors(north.lat, north.lng, 'u9', NOW, 'en');
    const hk = m.list.find((c) => c.id === 'hongkong');
    assert.ok(hk.outside && hk.lat === undefined);
    const macau = m.list.find((c) => c.id === 'macau');
    assert.ok(macau.outside);
    assert.ok(!m.list.find((c) => c.id === 'tokyo').outside);
});

test('local time of each city, with daylight saving', () => {
    const jan = Date.parse('2027-01-15T12:00:00Z'), jul = Date.parse('2026-07-15T12:00:00Z');
    assert.strictEqual(p.utcOffsetMinutes('taipei', jan), 480);
    assert.strictEqual(p.utcOffsetMinutes('tokyo', jan), 540);
    assert.strictEqual(p.utcOffsetMinutes('bangkok', jan), 420);
    assert.strictEqual(p.utcOffsetMinutes('bali', jan), 480);
    assert.strictEqual(p.utcOffsetMinutes('jakarta', jan), 420);
    assert.strictEqual(p.utcOffsetMinutes('sydney', jan), 660); // 夏令
    assert.strictEqual(p.utcOffsetMinutes('sydney', jul), 600);
    assert.strictEqual(p.utcOffsetMinutes('brisbane', jan), 600); // 昆士蘭沒有夏令
    assert.strictEqual(p.utcOffsetMinutes('adelaide', jan), 630);
    assert.strictEqual(p.utcOffsetMinutes('perth', jan), 480);
    for (const c of p.CITIES) assert.ok(Number.isInteger(p.utcOffsetMinutes(c.id, jan)), c.id);
    assert.strictEqual(p.utcOffsetMinutes('nowhere'), null);
});
