const test = require('node:test');
const assert = require('node:assert');
const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFileSync } = require('child_process');
const o = require('./orbs');

// 用 openssl 做一條和 Apple 同樣形狀的憑證鏈：根（P-384）→ 中繼（WWDR OID）→ 葉（收據簽章 OID，P-256）
function makeChain({ leafOid = '1.2.840.113635.100.6.11.1' } = {}) {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'orbs-'));
    const f = (n) => path.join(dir, n);
    const ssl = (...args) => execFileSync('openssl', args, { stdio: 'pipe' });
    ssl('req', '-x509', '-newkey', 'ec', '-pkeyopt', 'ec_paramgen_curve:P-384', '-nodes', '-keyout', f('root.key'), '-out', f('root.pem'), '-days', '30', '-subj', '/CN=Test Root',
        '-addext', 'basicConstraints=critical,CA:true');
    const issue = (name, curve, caKey, caPem, ext) => {
        ssl('req', '-newkey', 'ec', '-pkeyopt', `ec_paramgen_curve:${curve}`, '-nodes', '-keyout', f(`${name}.key`), '-out', f(`${name}.csr`), '-subj', `/CN=${name}`);
        fs.writeFileSync(f(`${name}.ext`), ext);
        ssl('x509', '-req', '-in', f(`${name}.csr`), '-CA', caPem, '-CAkey', caKey, '-CAcreateserial', '-out', f(`${name}.pem`), '-days', '30', '-extfile', f(`${name}.ext`));
    };
    issue('inter', 'P-384', f('root.key'), f('root.pem'), 'basicConstraints=critical,CA:true\n1.2.840.113635.100.6.2.1=ASN1:NULL\n');
    issue('leaf', 'prime256v1', f('inter.key'), f('inter.pem'), `${leafOid}=ASN1:NULL\n`);
    const der = (n) => new crypto.X509Certificate(fs.readFileSync(f(`${n}.pem`))).raw.toString('base64');
    const out = { rootPem: fs.readFileSync(f('root.pem'), 'utf8'), x5c: [der('leaf'), der('inter'), der('root')], leafKey: fs.readFileSync(f('leaf.key'), 'utf8') };
    fs.rmSync(dir, { recursive: true, force: true });
    return out;
}

function sign(chain, payload, { x5c = chain.x5c } = {}) {
    const head = Buffer.from(JSON.stringify({ alg: 'ES256', x5c })).toString('base64url');
    const body = Buffer.from(JSON.stringify(payload)).toString('base64url');
    const sig = crypto.sign('sha256', Buffer.from(`${head}.${body}`), { key: chain.leafKey, dsaEncoding: 'ieee-p1363' }).toString('base64url');
    return `${head}.${body}.${sig}`;
}

const tx = { bundleId: o.BUNDLE_ID, productId: 'orb_rainbow', transactionId: '2000000111', originalTransactionId: '2000000100', environment: 'Sandbox', type: 'Non-Consumable' };

test('a StoreKit 2 transaction signed by the pinned chain grants the rainbow orb', () => {
    const chain = makeChain();
    const got = o.verifyAppleJws(sign(chain, tx), { rootPem: chain.rootPem });
    assert.strictEqual(got.productId, 'orb_rainbow');
    assert.deepStrictEqual(o.appleGrant(got), { style: 'rainbow', receipt: 'a_2000000100' });
});

test('Apple JWS is rejected when the root, signature, leaf OID or payload is wrong', () => {
    const chain = makeChain();
    const other = makeChain();
    assert.throws(() => o.verifyAppleJws(sign(chain, tx), { rootPem: other.rootPem }), /untrusted_root/);
    assert.throws(() => o.verifyAppleJws(sign(chain, tx)), /untrusted_root/); // 測試根不是 Apple 的根
    const jws = sign(chain, tx).split('.');
    const forged = Buffer.from(JSON.stringify({ ...tx, productId: 'orb_other' })).toString('base64url');
    assert.throws(() => o.verifyAppleJws(`${jws[0]}.${forged}.${jws[2]}`, { rootPem: chain.rootPem }), /bad_signature/);
    // 葉憑證不是收據簽章用的
    const wrongLeaf = makeChain({ leafOid: '1.2.3.4' });
    assert.throws(() => o.verifyAppleJws(sign(wrongLeaf, tx), { rootPem: wrongLeaf.rootPem }), /bad_chain/);
    // 憑證過期
    assert.throws(() => o.verifyAppleJws(sign(chain, tx), { rootPem: chain.rootPem, now: Date.now() + 90 * 86400000 }), /expired_cert/);
    assert.throws(() => o.verifyAppleJws('abc', { rootPem: chain.rootPem }), /bad_jws/);
    assert.throws(() => o.appleGrant({ ...tx, bundleId: 'com.other.app' }), /wrong_app/);
    assert.throws(() => o.appleGrant({ ...tx, revocationDate: 1 }), /revoked/);
    assert.throws(() => o.appleGrant({ ...tx, productId: 'coins_100' }), /unknown_product/);
});

test('the pinned Apple root is Apple Root CA - G3', () => {
    const root = new crypto.X509Certificate(o.APPLE_ROOT_G3);
    assert.match(root.subject, /Apple Root CA - G3/);
    assert.strictEqual(root.fingerprint256, '63:34:3A:BF:B8:9A:6A:03:EB:B5:7E:9B:3F:5F:A7:BE:7C:4F:5C:75:6F:30:17:B3:A8:C4:88:C3:65:3E:91:79');
});

test('Google purchases grant only when paid', () => {
    const g = o.googleGrant('orb_rainbow', 'token-abc', { purchaseState: 0 });
    assert.strictEqual(g.style, 'rainbow');
    assert.match(g.receipt, /^g_[0-9a-f]{40}$/);
    assert.strictEqual(o.googleGrant('orb_rainbow', 'token-abc', { purchaseState: 0 }).receipt, g.receipt);
    assert.throws(() => o.googleGrant('orb_rainbow', 't', { purchaseState: 1 }), /not_paid/);
    assert.throws(() => o.googleGrant('orb_rainbow', 't', { purchaseState: 2 }), /not_paid/);
    assert.throws(() => o.googleGrant('nope', 't', { purchaseState: 0 }), /unknown_product/);
});

test('the shown orb falls back to the basic one unless free or owned', () => {
    assert.deepStrictEqual(o.FREE_STYLES, ['glow', 'ring']);
    assert.strictEqual(o.resolveStyle('ring', {}), 'ring');
    assert.strictEqual(o.resolveStyle('rainbow', {}), 'glow');
    assert.strictEqual(o.resolveStyle('rainbow', { rainbow: { at: 1 } }), 'rainbow');
    assert.strictEqual(o.resolveStyle('__proto__', {}), 'glow');
    assert.strictEqual(o.resolveStyle(undefined, null), 'glow');
});

test('onSale：限定款只在販售期間買得到，免費款不用買', () => {
    const o = require('./orbs');
    assert.strictEqual(o.onSale('rainbow', Date.parse('2030-01-01T00:00:00Z')), true);
    assert.strictEqual(o.onSale('xmas', Date.parse('2026-11-20T00:00:00+08:00')), true);
    assert.strictEqual(o.onSale('xmas', Date.parse('2026-12-26T00:00:00+08:00')), false);
    assert.strictEqual(o.onSale('newyear', Date.parse('2027-01-01T23:00:00+08:00')), true);
    assert.strictEqual(o.onSale('newyear', Date.parse('2027-01-02T00:00:01+08:00')), false);
    assert.strictEqual(o.onSale('glow'), false);
    assert.strictEqual(o.styleOfProduct('orb_xmas'), 'xmas');
    assert.strictEqual(o.resolveStyle('newyear', { newyear: {} }), 'newyear');
    assert.strictEqual(o.resolveStyle('newyear', {}), 'glow');
});

test('艾婭造型：和光球共用購買驗證，但不能當光球款式', () => {
    const o = require('./orbs');
    assert.strictEqual(o.styleOfProduct('aiya_skin_xmas'), 'aiya_xmas');
    assert.strictEqual(o.isSkin('aiya_xmas'), true);
    assert.strictEqual(o.isStyle('aiya_xmas'), false);
    assert.strictEqual(o.resolveStyle('aiya_xmas', { aiya_xmas: {} }), 'glow');
    assert.strictEqual(o.onSale('aiya_newyear', Date.parse('2026-12-30T00:00:00+08:00')), true);
    assert.strictEqual(o.onSale('aiya_xmas', Date.parse('2026-12-26T00:00:00+08:00')), false);
    assert.ok(!o.FREE_STYLES.includes('aiya_xmas'));
});

test('會長大的光球：心跳秒數、星星與年輪', () => {
    const orbs = require('./orbs');
    assert.strictEqual(orbs.isGrowing('startrail'), true);
    assert.strictEqual(orbs.isGrowing('rainbow'), false);
    assert.strictEqual(orbs.styleOfProduct('orb_rings'), 'rings');
    const now = 1_000_000_000;
    assert.strictEqual(orbs.beatSeconds(now - 15000, now), 15);
    assert.strictEqual(orbs.beatSeconds(now - 600000, now), 60); // 斷線很久：最多 60 秒
    assert.strictEqual(orbs.beatSeconds(undefined, now), 0);
    assert.deepStrictEqual(orbs.growthView(3 * 3600 * 2 + 5, 3), { stars: 3, rings: 2 });
    assert.deepStrictEqual(orbs.growthView(999 * 3600, 500), { stars: 24, rings: 12 });
    assert.strictEqual(orbs.growthField({ stars: 5, rings: 3 }), '5.3');
    assert.deepStrictEqual(orbs.parseGrowthField('5.3'), { stars: 5, rings: 3 });
    assert.strictEqual(orbs.parseGrowthField('x'), null);
    assert.strictEqual(orbs.meetPairKey('a', 'b'), orbs.meetPairKey('b', 'a'));
});

test('情人節、櫻花季限定款：商品代號與販售截止', () => {
    const orbs = require('./orbs');
    assert.strictEqual(orbs.styleOfProduct('orb_valentine'), 'valentine');
    assert.strictEqual(orbs.styleOfProduct('orb_sakura'), 'sakura');
    assert.strictEqual(orbs.onSale('valentine', Date.parse('2027-02-14T23:00:00+08:00')), true);
    assert.strictEqual(orbs.onSale('valentine', Date.parse('2027-02-15T00:00:01+08:00')), false);
    assert.strictEqual(orbs.onSale('sakura', Date.parse('2027-04-11T00:00:01+08:00')), false);
    assert.strictEqual(orbs.resolveStyle('sakura', { sakura: {} }), 'sakura');
});
