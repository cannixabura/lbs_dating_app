const test = require('node:test');
const assert = require('node:assert');
const demoCity = require('./demo_city');
const parallel = require('./parallel');

test('every parallel city gets 100 local NPCs near its centre', () => {
    let total = 0;
    for (const city of parallel.CITIES) {
        const bots = demoCity.cityBots(city);
        assert.strictEqual(bots.length, 100);
        assert.ok(demoCity.LANG_OF_COUNTRY[city.country], `no language for ${city.country}`);
        for (const b of bots) {
            assert.ok(b.uid.startsWith('demo-c-') && !b.uid.includes('_'));
            assert.ok(b.nickname && b.mood);
            assert.ok(!/示範|demo|NPC/i.test(b.nickname));
            const d = Math.hypot(b.lat - city.lat, (b.lng - city.lng) * Math.cos(city.lat * Math.PI / 180)) * 111.2;
            assert.ok(d <= demoCity.CITY_RADIUS_KM + 0.05, `${b.uid} is ${d} km out`);
        }
        total += bots.length;
    }
    assert.strictEqual(new Set(parallel.CITIES.flatMap((c) => demoCity.cityBots(c).map((b) => b.uid))).size, total);
});

test('same city always gives the same bots, names in local language', () => {
    const tokyo = parallel.CITY_BY_ID.tokyo;
    assert.deepStrictEqual(demoCity.cityBots(tokyo)[0], demoCity.cityBots({ ...tokyo, id: 'tokyo' })[0]);
    assert.ok(demoCity.NAMES.ja.includes(demoCity.cityBots(tokyo)[0].nickname));
});

test('nearby search returns closest first within radius', () => {
    const taipei = parallel.CITY_BY_ID.taipei;
    const near = demoCity.nearbyCityBots(parallel.CITIES, taipei, 1);
    assert.ok(near.length > 0);
    for (let i = 1; i < near.length; i++) assert.ok(near[i].dist >= near[i - 1].dist);
    assert.ok(near.every((b) => b.dist <= 1));
    assert.strictEqual(demoCity.nearbyCityBots(parallel.CITIES, { lat: 0, lng: -150 }, 5).length, 0);
});
