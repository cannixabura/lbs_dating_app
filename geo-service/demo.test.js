const test = require('node:test');
const assert = require('node:assert');
const demo = require('./demo');
const parallel = require('./parallel');
const { localize } = require('./i18n');

test('every third review bot plays a parallel visitor from a paired city', () => {
    const fromAbroad = demo.reviewBotProfiles().map((b) => demo.parallelDemoCity(b.uid, true)).filter(Boolean);
    assert.strictEqual(fromAbroad.length, 6);
    for (const id of fromAbroad) assert.ok(parallel.paired(parallel.CITY_BY_ID[id], parallel.CITY_BY_ID.taipei), id);
    const fromTaiwan = demo.reviewBotProfiles().map((b) => demo.parallelDemoCity(b.uid, false)).filter(Boolean);
    for (const id of fromTaiwan) assert.strictEqual(parallel.CITY_BY_ID[id].country, parallel.TAIWAN, id);
    assert.strictEqual(demo.parallelDemoCity('demo-tpe-003', true), null); // 台北示範是公開的，不扮演訪客
});

test('demo moods are translated for every language', () => {
    for (const bot of [...demo.taipeiBots().slice(0, 30), ...demo.reviewBotProfiles()]) {
        for (const lang of ['en', 'ja', 'th']) assert.notStrictEqual(localize(lang, bot.mood), bot.mood, `${bot.mood} → ${lang}`);
    }
});

test('parallel demo visitors ring the viewer within about a kilometre', () => {
    const viewer = { lat: 24.15, lng: 120.65 };
    for (const b of demo.reviewBotProfiles().filter((x) => demo.parallelDemoCity(x.uid, true))) {
        const d = demo.distanceKm(viewer, demo.parallelDemoPosition(b.uid, viewer));
        assert.ok(d > 0.25 && d < 1.1, `${b.uid} ${d}`);
    }
});

test('every parallel demo city has a short name', () => {
    for (const viewerInTaiwan of [true, false]) {
        for (const b of demo.reviewBotProfiles()) {
            const city = demo.parallelDemoCity(b.uid, viewerInTaiwan);
            if (city) assert.ok(demo.PARALLEL_DEMO_NAMES[city], city);
        }
    }
});
