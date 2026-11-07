// ============================================================================
// 送禮與糾纏款（規格 docs/gifting-spec.md）
//
// 三種禮物，商店上一律是「消耗性」商品（非消耗性每個帳號只能買一次，送不了第二個人）：
//   gift_bouquet NT$30  光之花束：對方收下時畫面綻開一束光粒子花，之後 24 小時光球旁邊多一圈花瓣光點
//   gift_orb     NT$90  送一款光球（送的人挑款式）：對方收下後永久擁有
//   gift_pair    NT$90  糾纏款：一人買、送給對方；對方收下後兩人都得到糾纏款光球並配成一對
// 對方可以收下或婉拒；婉拒、7 天沒回應、或送出時對方收不了，禮物都退回給送的人，變成一張可以再送別人的禮券。
//
// Realtime Database（只有伺服器寫得進去）：
//   gifts/{id}            = { from, to, kind, style?, status: pending|accepted|returned|refunded, at, receipt, fromName }
//   giftInbox/{uid}/{id}  = at        收到、還沒回覆的禮物
//   giftVouchers/{uid}/{id} = { kind, style?, at }   退回的禮物（可以再送）
//   giftReceipts/{receipt} = id       一筆購買只算一份禮物
//   giftPrefs/{uid}       = { off: true }   設定裡關掉「接收禮物」
//   orbPair/{uid}         = 對方 uid（Redis 也存一份 orb_pair:{uid}，量子世界每次心跳要用）
//   giftBouquet/{uid}     = 到期時間（毫秒）
// ============================================================================

const PRODUCTS = {
    gift_bouquet: 'bouquet',
    gift_orb: 'orb',
    gift_pair: 'pair',
};
const KINDS = new Set(Object.values(PRODUCTS));
const PENDING_MS = 7 * 86400000; // 7 天沒回應就退回
const BOUQUET_MS = 24 * 3600000; // 花束在光球旁邊 24 小時
const pairKey = (uid) => `orb_pair:${uid}`;
const bouquetKey = (uid) => `gift_bouquet:${uid}`; // Redis：花束還在的時候存在（量子世界心跳用）

const kindOfProduct = (productId) => PRODUCTS[productId] || null;

/** Apple 的禮物交易：消耗性，每筆 transactionId 一份 */
function appleGift(tx, bundleId) {
    if (!tx || tx.bundleId !== bundleId) throw new Error('wrong_app');
    if (tx.revocationDate) throw new Error('revoked');
    const kind = kindOfProduct(tx.productId);
    if (!kind) throw new Error('unknown_product');
    if (!tx.transactionId) throw new Error('bad_tx');
    return { kind, receipt: `a_${tx.transactionId}`, productId: tx.productId };
}

/** Google 的禮物購買（products.get 的結果） */
function googleGift(productId, receiptKey, purchase) {
    const kind = kindOfProduct(productId);
    if (!kind) throw new Error('unknown_product');
    if (!purchase || purchase.purchaseState !== 0) throw new Error('not_paid');
    return { kind, receipt: receiptKey, productId };
}

/**
 * 這份禮物現在能不能送給對方。不能送時回傳原因，禮物會變成送的人的禮券。
 * ctx: { from, to, kind, style, blocked, recipientOff, recipientOwned (物件), recipientPaired, senderPaired, giftableStyle (函式) }
 */
function canSend(ctx) {
    if (!ctx.to || ctx.to === ctx.from) return { ok: false, code: 'self' };
    if (!KINDS.has(ctx.kind)) return { ok: false, code: 'kind' };
    if (ctx.blocked) return { ok: false, code: 'blocked' };
    if (ctx.recipientOff) return { ok: false, code: 'off' };
    if (ctx.kind === 'orb') {
        if (!ctx.giftableStyle(ctx.style)) return { ok: false, code: 'style' };
        if (ctx.recipientOwned && ctx.recipientOwned[ctx.style]) return { ok: false, code: 'owned' };
    }
    if (ctx.kind === 'pair') {
        if (ctx.senderPaired) return { ok: false, code: 'you_paired' };
        if (ctx.recipientPaired) return { ok: false, code: 'paired' };
    }
    return { ok: true };
}

/** 等待中的禮物是不是已經過了 7 天 */
const expired = (gift, now) => !!gift && gift.status === 'pending' && now - Number(gift.at || 0) > PENDING_MS;

/** 花束還在不在 */
const bouquetActive = (until, now) => Number(until) > now;

/** 給 App 看的禮物（不帶收據） */
function giftView(id, g) {
    return { id, kind: g.kind, ...(g.style ? { style: g.style } : {}), fromName: g.fromName || '', at: Number(g.at) || 0, status: g.status };
}

module.exports = { PRODUCTS, KINDS, PENDING_MS, BOUQUET_MS, pairKey, bouquetKey, kindOfProduct, appleGift, googleGift, canSend, expired, bouquetActive, giftView };
