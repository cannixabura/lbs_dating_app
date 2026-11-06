// ============================================================================
// 量子化身：量子世界的光球頭像（規格：docs/quantum-world-spec.md §5.5）
//
// 光球的主色永遠跟著心情；款式只改變紋路與光暈，不影響任何權益。
// 基本款免費；特殊款用 Apple / Google 內購買斷，買過的款式跟著帳號保存。
//
// Realtime Database（只有伺服器寫得進去）：
//   orbOwned/{uid}/{style}  = { at, src: 'apple' | 'google', receipt }   App 只讀得到自己的
//   orbReceipts/{receipt}   = uid   一筆購買只能給一個帳號；刪除帳號時釋放，換新帳號可以恢復購買
// ============================================================================

const crypto = require('crypto');

const BUNDLE_ID = 'com.softchip.moodwhisper';
const DEFAULT_STYLE = 'glow';

/**
 * 所有款式：product 是商店的商品代號，沒有 product 的是免費款。
 * until 是限定款的最後販售時間（台北時間）；過了就不再賣，買過的人永久保留、可以恢復購買。
 */
const STYLES = {
    glow: {}, // 光球
    ring: {}, // 星環
    rainbow: { product: 'orb_rainbow' }, // 彩虹（長期販售）
    xmas: { product: 'orb_xmas', until: Date.parse('2026-12-25T23:59:59+08:00') }, // 聖誕限定
    newyear: { product: 'orb_newyear', until: Date.parse('2027-01-01T23:59:59+08:00') }, // 量子跨年 2026→2027 限定
    // 艾婭節日造型：只有買的人看到自己的艾婭換造型；和光球共用購買驗證與擁有紀錄（orbOwned），但不是光球款式
    aiya_xmas: { product: 'aiya_skin_xmas', until: Date.parse('2026-12-25T23:59:59+08:00'), skin: true },
    aiya_newyear: { product: 'aiya_skin_newyear', until: Date.parse('2027-01-01T23:59:59+08:00'), skin: true },
};

/** 這一款現在買不買得到：免費款不用買；限定款過了販售期就買不到 */
const onSale = (s, now = Date.now()) => (isStyle(s) || isSkin(s)) && !!STYLES[s].product && !(STYLES[s].until && now > STYLES[s].until);

const FREE_STYLES = Object.keys(STYLES).filter((s) => !STYLES[s].product);
const styleOfProduct = (productId) => Object.keys(STYLES).find((s) => STYLES[s].product === productId) || null;
/** 光球款式（艾婭造型不算：不能拿來當量子世界的頭像） */
const isStyle = (s) => typeof s === 'string' && Object.prototype.hasOwnProperty.call(STYLES, s) && !STYLES[s].skin;
const isSkin = (s) => typeof s === 'string' && Object.prototype.hasOwnProperty.call(STYLES, s) && !!STYLES[s].skin;
const isFree = (s) => isStyle(s) && !STYLES[s].product;

/** 一筆購買的代號：Apple 用 originalTransactionId，Google 用購買憑證的雜湊（憑證很長，也不必存原文） */
const receiptKey = (src, id) => src === 'apple' ? `a_${id}` : `g_${crypto.createHash('sha256').update(String(id)).digest('hex').slice(0, 40)}`;

// ---------- Apple：StoreKit 2 的 JWS 交易 ----------

// Apple Root CA - G3（https://www.apple.com/certificateauthority/），SHA-256 指紋 63:34:3A:BF:…:91:79
const APPLE_ROOT_G3 = `-----BEGIN CERTIFICATE-----
MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwS
QXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9u
IEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcN
MTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBS
b290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49
AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtf
TjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517
IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySr
MA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gA
MGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4
at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM
6BgD56KyKA==
-----END CERTIFICATE-----`;

// 憑證裡 Apple 自訂延伸欄位的 OID（DER 編碼）：App Store 收據簽章的葉憑證、WWDR 中繼憑證
const OID_RECEIPT_SIGNING = Buffer.from('2a864886f76364060b01', 'hex'); // 1.2.840.113635.100.6.11.1
const OID_WWDR_INTERMEDIATE = Buffer.from('2a864886f76364060201', 'hex'); // 1.2.840.113635.100.6.2.1

const b64url = (s) => Buffer.from(s, 'base64url');

/**
 * 驗證 StoreKit 2 的交易 JWS：憑證鏈接到 Apple Root CA G3、簽章正確，回傳交易內容。
 * @param {string} jws
 * @param {{rootPem?: string, now?: number}} opts rootPem 只在測試時換掉
 * @returns {object} 交易內容（productId、originalTransactionId、bundleId…）
 */
function verifyAppleJws(jws, { rootPem = APPLE_ROOT_G3, now = Date.now() } = {}) {
    const parts = String(jws || '').split('.');
    if (parts.length !== 3) throw new Error('bad_jws');
    const header = JSON.parse(b64url(parts[0]).toString('utf8'));
    if (header.alg !== 'ES256' || !Array.isArray(header.x5c) || header.x5c.length !== 3) throw new Error('bad_header');
    const [leaf, intermediate, root] = header.x5c.map((c) => new crypto.X509Certificate(Buffer.from(c, 'base64')));
    const pinned = new crypto.X509Certificate(rootPem);
    if (root.fingerprint256 !== pinned.fingerprint256) throw new Error('untrusted_root');
    if (!intermediate.verify(pinned.publicKey) || !leaf.verify(intermediate.publicKey)) throw new Error('bad_chain');
    if (!intermediate.raw.includes(OID_WWDR_INTERMEDIATE) || !leaf.raw.includes(OID_RECEIPT_SIGNING)) throw new Error('bad_chain');
    for (const c of [leaf, intermediate, pinned]) {
        if (now < Date.parse(c.validFrom) || now > Date.parse(c.validTo)) throw new Error('expired_cert');
    }
    const ok = crypto.verify('sha256', Buffer.from(`${parts[0]}.${parts[1]}`), { key: leaf.publicKey, dsaEncoding: 'ieee-p1363' }, b64url(parts[2]));
    if (!ok) throw new Error('bad_signature');
    return JSON.parse(b64url(parts[1]).toString('utf8'));
}

/**
 * Apple 交易 → 要給的款式。審核與 TestFlight 用 Sandbox，正式上架用 Production，兩種都收。
 * @returns {{style: string, receipt: string}}
 */
function appleGrant(tx) {
    if (!tx || tx.bundleId !== BUNDLE_ID) throw new Error('wrong_app');
    if (tx.revocationDate) throw new Error('revoked');
    const style = styleOfProduct(tx.productId);
    if (!style) throw new Error('unknown_product');
    const id = tx.originalTransactionId || tx.transactionId;
    if (!id) throw new Error('bad_tx');
    return { style, receipt: receiptKey('apple', id) };
}

// ---------- Google Play ----------

/**
 * Google Play Developer API 的購買資料 → 要給的款式。purchaseState 0 = 已付款（1 取消、2 處理中）。
 * @returns {{style: string, receipt: string}}
 */
function googleGrant(productId, token, purchase) {
    const style = styleOfProduct(productId);
    if (!style) throw new Error('unknown_product');
    if (!purchase || purchase.purchaseState !== 0) throw new Error('not_paid');
    return { style, receipt: receiptKey('google', token) };
}

/** 量子世界要顯示的款式：免費款直接用，特殊款要買過，否則回到基本款 */
function resolveStyle(requested, owned) {
    if (!isStyle(requested)) return DEFAULT_STYLE;
    if (isFree(requested)) return requested;
    return owned && owned[requested] ? requested : DEFAULT_STYLE;
}

module.exports = {
    BUNDLE_ID, DEFAULT_STYLE, STYLES, FREE_STYLES, APPLE_ROOT_G3,
    styleOfProduct, isStyle, isSkin, isFree, onSale, receiptKey, verifyAppleJws, appleGrant, googleGrant, resolveStyle,
};
