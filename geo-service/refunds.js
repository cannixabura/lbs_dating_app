// 退款處理（純函式，方便測試）
//   Apple：App Store 伺服器通知 REFUND / REVOKE（家人共享被收回）
//   Google：每天查 voidedpurchases（退款、退單、被撤銷的購買）
//   收據標成 'refunded' 之後就不能再拿來兌換，同一筆退款處理第二次也不會重複扣。
const aiya = require('./aiya');
const orbs = require('./orbs');
const gifts = require('./gifts');
const assembly = require('./assembly');

const REFUNDED = 'refunded';
const REFUND_TYPES = new Set(['REFUND', 'REVOKE']);

/** Apple 退款通知要處理哪一筆收據；不是退款、或不是時光包／光球／造型就回 null */
function appleRefundTarget(notificationType, tx, bundleId, packs = aiya.PACKS) {
    if (!REFUND_TYPES.has(notificationType) || !tx || tx.bundleId !== bundleId) return null;
    const packCredits = packs[tx.productId];
    if (packCredits && tx.transactionId) {
        const qty = Number(tx.quantity) > 1 ? Number(tx.quantity) : 1;
        return { kind: 'pack', receipt: `a_${tx.transactionId}`, credits: packCredits * qty };
    }
    if (Object.values(aiya.CALL_PACKS).some((p) => p[tx.productId]) && tx.transactionId) return { kind: 'callpack', receipt: `a_${tx.transactionId}` };
    if (gifts.kindOfProduct(tx.productId) && tx.transactionId) return { kind: 'gift', receipt: `a_${tx.transactionId}` };
    if (assembly.planOfProduct(tx.productId) && tx.transactionId) return { kind: 'assembly', receipt: `a_${tx.transactionId}` };
    const style = orbs.styleOfProduct(tx.productId);
    const id = tx.originalTransactionId || tx.transactionId;
    if (style && id) return { kind: 'orb', receipt: orbs.receiptKey('apple', id), style };
    return null;
}

/** 扣掉退款的聊天次數，最少到 0（已經用掉的不追討） */
function deduct(current, credits) {
    return Math.max(0, (Number(current) || 0) - (Number(credits) || 0));
}

/** 帳號擁有的款式裡，是用這筆收據買的那些 */
function stylesWithReceipt(owned, receipt) {
    return Object.keys(owned || {}).filter((s) => owned[s] && owned[s].receipt === receipt);
}

/** Google voidedpurchases 回來的清單 → 收據 key（只看一次性商品；訂閱另有 subscriptionsv2 檢查） */
function googleVoidedReceipts(list) {
    return (Array.isArray(list) ? list : [])
        .filter((v) => v && typeof v.purchaseToken === 'string' && v.purchaseToken)
        .map((v) => orbs.receiptKey('google', v.purchaseToken));
}

module.exports = { REFUNDED, appleRefundTarget, deduct, stylesWithReceipt, googleVoidedReceipts };
