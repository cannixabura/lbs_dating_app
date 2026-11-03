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
