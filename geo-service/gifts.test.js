const test = require('node:test');
const assert = require('node:assert');
const g = require('./gifts');
const orbs = require('./orbs');

const B = 'com.softchip.moodwhisper';
const giftable = (s) => orbs.isStyle(s) && !orbs.isFree(s) && !orbs.STYLES[s].granted && orbs.onSale(s);

test('糾纏款光球不是免費款，也不能直接買', () => {
    assert.strictEqual(orbs.isStyle('pair'), true);
    assert.strictEqual(orbs.isFree('pair'), false);
    assert.strictEqual(orbs.resolveStyle('pair', null), 'glow');
    assert.strictEqual(orbs.resolveStyle('pair', { pair: {} }), 'pair');
    assert.strictEqual(orbs.FREE_STYLES.includes('pair'), false);
    assert.strictEqual(giftable('pair'), false);
});

test('appleGift／googleGift：三種禮物都是消耗性，每筆交易一份', () => {
    assert.deepStrictEqual(g.appleGift({ bundleId: B, productId: 'gift_pair', transactionId: '7' }, B), { kind: 'pair', receipt: 'a_7', productId: 'gift_pair' });
    assert.throws(() => g.appleGift({ bundleId: B, productId: 'orb_rainbow', transactionId: '7' }, B), /unknown_product/);
    assert.throws(() => g.appleGift({ bundleId: B, productId: 'gift_orb', transactionId: '7', revocationDate: 1 }, B), /revoked/);
    assert.deepStrictEqual(g.googleGift('gift_bouquet', 'g_x', { purchaseState: 0 }), { kind: 'bouquet', receipt: 'g_x', productId: 'gift_bouquet' });
    assert.throws(() => g.googleGift('gift_bouquet', 'g_x', { purchaseState: 1 }), /not_paid/);
});

test('canSend：封鎖、關掉接收、已擁有、已配對都不能送', () => {
    const base = { from: 'a', to: 'b', kind: 'orb', style: 'rainbow', giftableStyle: giftable };
    assert.deepStrictEqual(g.canSend(base), { ok: true });
    assert.strictEqual(g.canSend({ ...base, to: 'a' }).code, 'self');
    assert.strictEqual(g.canSend({ ...base, blocked: true }).code, 'blocked');
    assert.strictEqual(g.canSend({ ...base, recipientOff: true }).code, 'off');
    assert.strictEqual(g.canSend({ ...base, recipientOwned: { rainbow: {} } }).code, 'owned');
    assert.strictEqual(g.canSend({ ...base, style: 'glow' }).code, 'style'); // 免費款不用送
    assert.strictEqual(g.canSend({ ...base, style: 'pair' }).code, 'style'); // 糾纏款只能用糾纏款禮物
    assert.strictEqual(g.canSend({ ...base, kind: 'pair', senderPaired: true }).code, 'you_paired');
    assert.strictEqual(g.canSend({ ...base, kind: 'pair', recipientPaired: true }).code, 'paired');
    assert.deepStrictEqual(g.canSend({ ...base, kind: 'bouquet', style: undefined }), { ok: true });
});

test('expired／bouquetActive／giftView', () => {
    const now = 1_800_000_000_000;
    assert.strictEqual(g.expired({ status: 'pending', at: now - 8 * 86400000 }, now), true);
    assert.strictEqual(g.expired({ status: 'pending', at: now - 86400000 }, now), false);
    assert.strictEqual(g.expired({ status: 'accepted', at: 0 }, now), false);
    assert.strictEqual(g.bouquetActive(now + 1, now), true);
    assert.strictEqual(g.bouquetActive(null, now), false);
    assert.deepStrictEqual(g.giftView('x', { kind: 'orb', style: 'rings', fromName: '阿澄', at: 5, status: 'pending', receipt: 'a_1' }),
        { id: 'x', kind: 'orb', style: 'rings', fromName: '阿澄', at: 5, status: 'pending' });
});
