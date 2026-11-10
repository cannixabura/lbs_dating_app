const test = require('node:test');
const assert = require('node:assert');
const r = require('./refunds');

const B = 'com.softchip.moodwhisper';

test('appleRefundTarget：只處理 REFUND／REVOKE，時光包算出要扣的次數', () => {
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'aiya_time_20', transactionId: '7' }, B), { kind: 'pack', receipt: 'a_7', credits: 20 });
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'aiya_time_5', transactionId: '8', quantity: 2 }, B).credits, 10);
    assert.strictEqual(r.appleRefundTarget('DID_RENEW', { bundleId: B, productId: 'aiya_time_5', transactionId: '8' }, B), null);
    assert.strictEqual(r.appleRefundTarget('REFUND', { bundleId: 'x', productId: 'aiya_time_5', transactionId: '8' }, B), null);
    assert.strictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'group_pass_7d', transactionId: '8' }, B), null);
});

test('appleRefundTarget：光球和艾婭造型用原始交易編號對收據', () => {
    assert.deepStrictEqual(r.appleRefundTarget('REVOKE', { bundleId: B, productId: 'orb_xmas', transactionId: '9', originalTransactionId: '5' }, B), { kind: 'orb', receipt: 'a_5', style: 'xmas' });
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'aiya_skin_newyear', transactionId: '6' }, B), { kind: 'orb', receipt: 'a_6', style: 'aiya_newyear' });
});

test('deduct：扣到 0 為止', () => {
    assert.strictEqual(r.deduct(25, 20), 5);
    assert.strictEqual(r.deduct(3, 20), 0);
    assert.strictEqual(r.deduct(null, 5), 0);
});

test('stylesWithReceipt／googleVoidedReceipts', () => {
    assert.deepStrictEqual(r.stylesWithReceipt({ xmas: { receipt: 'a_1' }, ring: { receipt: 'a_2' }, rainbow: null }, 'a_1'), ['xmas']);
    const keys = r.googleVoidedReceipts([{ purchaseToken: 'tok' }, { orderId: 'x' }, null]);
    assert.strictEqual(keys.length, 1);
    assert.match(keys[0], /^g_[0-9a-f]{40}$/);
});

test('appleRefundTarget：禮物（消耗性）用交易編號對收據', () => {
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'gift_pair', transactionId: '42' }, B), { kind: 'gift', receipt: 'a_42' });
});

test('旅行團的艾婭時光包退款', () => {
    const aiya = require('./aiya');
    const { tour } = aiya.APPS;
    const tx = { bundleId: tour.bundleId, productId: 'tour_aiya_time_20', transactionId: 't9' };
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', tx, tour.bundleId, tour.packs), { kind: 'pack', receipt: 'a_t9', credits: 20 });
    assert.strictEqual(r.appleRefundTarget('REFUND', tx, aiya.APPS.mw.bundleId), null);
});

test('通話時間包退款（Apple）', () => {
    assert.deepStrictEqual(r.appleRefundTarget('REFUND', { bundleId: B, productId: 'aiya_call_60', transactionId: '9' }, B), { kind: 'callpack', receipt: 'a_9' });
    const aiya = require('./aiya');
    assert.strictEqual(aiya.appOfProduct('tour_aiya_call_30').id, 'tour');
});
