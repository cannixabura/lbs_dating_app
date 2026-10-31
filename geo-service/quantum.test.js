const test = require('node:test');
const assert = require('node:assert');
const q = require('./quantum');

test('ring n has 6n seats 100 m apart, and rings 1–3 are reserved for hosts', () => {
    assert.strictEqual(q.HOST_SEATS, 36);
    for (const ring of [1, 4, 10]) {
        const pts = Array.from({ length: 6 * ring }, (_, i) => q.seatOffset(ring, i));
        for (let i = 0; i < pts.length; i++) {
            const a = pts[i], b = pts[(i + 1) % pts.length];
            assert.ok(Math.abs(Math.hypot(a.east - b.east, a.north - b.north) - 100) < 1e-6, `ring ${ring} seat ${i}`);
        }
    }
    // 第一位一般使用者：第 4 圈第 1 號，在 101 正北 400 公尺
    const first = q.seat(0);
    assert.deepStrictEqual([first.ring, first.number, first.code], [4, 1, 'Q4-1']);
    assert.ok(Math.abs(first.east) < 1e-9 && Math.abs(first.north - 400) < 1e-9);
});

test('seat codes count clockwise from north and fill ring by ring', () => {
    // 第 4 圈第 2 號在正北偏東（順時針）
    assert.ok(q.seat(1).east > 0);
    assert.strictEqual(q.seat(23).code, 'Q4-24');
    assert.strictEqual(q.seat(24).code, 'Q5-1');
    // 規格表：第 10 圈填滿時一般使用者累計 294 人、第 100 圈 30,264 人
    assert.strictEqual(q.seat(293).code, 'Q10-60');
    assert.strictEqual(q.seat(294).code, 'Q11-1');
    assert.strictEqual(q.seat(30263).code, 'Q100-600');
    // 每一個序號都對到不同的席位
    const codes = new Set(Array.from({ length: 2000 }, (_, i) => q.seat(i).code));
    assert.strictEqual(codes.size, 2000);
});

test('seat positions round-trip through lat/lng', () => {
    const s = q.seat(17);
    const ll = q.toLatLng(s.east, s.north);
    const back = q.toLocal(ll.lat, ll.lng);
    assert.ok(Math.abs(back.east - s.east) < 1e-6 && Math.abs(back.north - s.north) < 1e-6);
    assert.strictEqual(q.nearestCode(s.east + 20, s.north - 10), s.code);
    assert.strictEqual(q.nearestCode(0, 150), null); // 主持人席範圍
});

test('walking accumulates, riding faster than 25 km/h is skipped and resumes from there', () => {
    let state = { east: 0, north: 0, rawEast: 0, rawNorth: 0, rawAt: 0 };
    const step = (raw, at) => {
        const next = q.accumulate(state, raw, at);
        state = { ...next, rawEast: raw.east, rawNorth: raw.north, rawAt: at };
        return next;
    };
    assert.deepStrictEqual(step({ east: 12, north: 5 }, 10000), { east: 12, north: 5 }); // 走路 1.3 m/s
    assert.deepStrictEqual(step({ east: 2012, north: 5 }, 70000), { east: 12, north: 5 }); // 1 分鐘 2 公里：搭車
    assert.deepStrictEqual(step({ east: 2020, north: 5 }, 80000), { east: 20, north: 5 }); // 下車後從當下繼續走
    assert.ok(q.validDisplacement(5000, -3000));
    assert.ok(!q.validDisplacement(NaN, 0) && !q.validDisplacement('1', 0) && !q.validDisplacement(3e7, 0));
});

test('mainland China is closed; Taiwan, Kinmen, Matsu, Hong Kong, Macau and neighbours are open', () => {
    for (const [lat, lng, name] of [
        [39.9042, 116.4074, 'Beijing'], [31.2304, 121.4737, 'Shanghai'], [22.5431, 114.0579, 'Shenzhen'],
        [22.2710, 113.5767, 'Zhuhai'], [24.4798, 118.0894, 'Xiamen'], [26.0745, 119.2965, 'Fuzhou'],
        [25.5, 119.78, 'Pingtan'], [20.0440, 110.1999, 'Haikou'], [43.8256, 87.6168, 'Urumqi'],
        [29.6520, 91.1721, 'Lhasa'], [45.8038, 126.5350, 'Harbin'], [22.8170, 108.3665, 'Nanning'],
        [25.0389, 102.7183, 'Kunming'], [40.1263, 124.3943, 'Dandong'],
    ]) assert.ok(q.isMainlandChina(lat, lng), name);
    for (const [lat, lng, name] of [
        [25.0339, 121.5645, 'Taipei 101'], [22.6273, 120.3014, 'Kaohsiung'], [23.57, 119.58, 'Penghu'],
        [24.43, 118.32, 'Kinmen'], [26.16, 119.94, 'Matsu'], [22.2783, 114.1747, 'Hong Kong'],
        [22.1987, 113.5439, 'Macau'], [21.0278, 105.8342, 'Hanoi'], [37.5665, 126.9780, 'Seoul'],
        [39.0392, 125.7625, 'Pyongyang'], [43.1155, 131.8855, 'Vladivostok'], [47.8864, 106.9057, 'Ulaanbaatar'],
        [27.7172, 85.3240, 'Kathmandu'], [21.4735, 105.8, 'Thai Nguyen'], [35.6812, 139.7671, 'Tokyo'],
        [14.5995, 120.9842, 'Manila'], [13.7563, 100.5018, 'Bangkok'], [16.8661, 96.1951, 'Yangon'],
    ]) assert.ok(!q.isMainlandChina(lat, lng), name);
});

test('regions are anonymous: small regions fold into other', () => {
    assert.strictEqual(q.regionOf(25.0339, 121.5645), 'tw');
    assert.strictEqual(q.regionOf(35.6812, 139.7671), 'jp');
    assert.strictEqual(q.regionOf(40.7128, -74.006), 'other');
    // REGIONS = tw, jp, kr, hkmo, sea, other
    assert.deepStrictEqual(q.regionCounts([120, 6, 2, 0, 9, 3]), { tw: 120, jp: 6, sea: 9, other: 5 });
    assert.deepStrictEqual(q.regionCounts([1, 0, 0, 0, 0, 0]), { other: 1 });
});

test('radar radius: up to 5 km normally, up to 60 km in world view', () => {
    assert.strictEqual(q.clampRadius(undefined), 5);
    assert.strictEqual(q.clampRadius(500), 60);
    assert.strictEqual(q.clampRadius(0), 0.1);
});

test('the app keeps the same mainland outline', () => {
    const dart = require('fs').readFileSync(require('path').join(__dirname, '../lib/quantum_world.dart'), 'utf8');
    const block = dart.match(/_mainlandChina = \[([\s\S]*?)\];/);
    assert.ok(block, 'lib/quantum_world.dart has _mainlandChina');
    const pts = [...block[1].matchAll(/\[(-?[\d.]+), (-?[\d.]+)\]/g)].map((m) => [Number(m[1]), Number(m[2])]);
    assert.deepStrictEqual(pts, q.MAINLAND_CHINA);
});
