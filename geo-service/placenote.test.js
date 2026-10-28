const test = require('node:test');
const assert = require('node:assert');
const pn = require('./placenote');

const shop = { id: 'p001', lat: 25.0485, lng: 121.5165 };

test('text: empty, length, contact details', () => {
    assert.match(pn.validateText('  ').error, /空白/);
    assert.strictEqual(pn.validateText('窗邊的位子很好').text, '窗邊的位子很好');
    assert.strictEqual(pn.validateText('好'.repeat(60)).text.length, 60);
    assert.match(pn.validateText('好'.repeat(61)).error, /60/);
    assert.match(pn.validateText('打給我 0912345678').error, /匿名/);
});

test('readable only within 40 m of the shop', () => {
    assert.strictEqual(pn.placeProblem(shop, { lat: 25.0487, lng: 121.5167 }), null);   // 約 30 m
    assert.match(pn.placeProblem(shop, { lat: 25.0490, lng: 121.5165 }), /40 公尺/);   // 約 56 m
    assert.match(pn.placeProblem(undefined, { lat: 25.0485, lng: 121.5165 }), /找不到/);
});

test('places list is cached and survives a failed download', async () => {
    pn.resetCache();
    let calls = 0;
    const ok = async () => { calls++; return { ok: true, json: async () => ({ places: [shop] }) }; };
    const down = async () => { calls++; throw new Error('offline'); };
    assert.deepStrictEqual((await pn.loadPlaces(0, ok)).get('p001'), shop);
    await pn.loadPlaces(60 * 1000, ok);
    assert.strictEqual(calls, 1);                                                   // 10 分鐘內不重抓
    assert.ok((await pn.loadPlaces(11 * 60 * 1000, down)).get('p001'));           // 下載失敗沿用舊的
    pn.resetCache();
    await assert.rejects(pn.loadPlaces(0, down));                                   // 從來沒抓到過就報錯
});

test('authors stay anonymous', () => {
    const row = { text: 'hi', author: 'u1', createdAt: '1000' };
    assert.deepStrictEqual(pn.forReader('n1', row, 'u2'), { id: 'n1', text: 'hi', createdAt: 1000, mine: false });
    assert.strictEqual(pn.forReader('n1', row, 'u1').mine, true);
});
