const test = require('node:test');
const assert = require('node:assert');
const crypto = require('crypto');

process.env.LIVEKIT_URL = 'wss://live.example.test';
process.env.LIVEKIT_API_KEY = 'APIkey';
process.env.LIVEKIT_API_SECRET = 'secret-secret-secret-secret-secret';
const lk = require('./livekit');

const decode = (jwt) => {
    const [h, b, sig] = jwt.split('.');
    const expect = crypto.createHmac('sha256', process.env.LIVEKIT_API_SECRET).update(`${h}.${b}`).digest('base64url');
    return { header: JSON.parse(Buffer.from(h, 'base64url')), body: JSON.parse(Buffer.from(b, 'base64url')), valid: sig === expect };
};

test('設定齊全才算可以用', () => {
    assert.strictEqual(lk.configured(), true);
    const old = process.env.LIVEKIT_URL;
    delete process.env.LIVEKIT_URL;
    assert.strictEqual(lk.configured(), false);
    process.env.LIVEKIT_URL = old;
});

test('身分不含 uid，同人同場固定、不同場不同', () => {
    const id1 = lk.identityOf('uid_abc', 'aaaaaaaaaaaa');
    assert.match(id1, /^p[0-9a-f]{16}$/);
    assert.ok(!id1.includes('uid_abc'));
    assert.strictEqual(lk.identityOf('uid_abc', 'aaaaaaaaaaaa'), id1);
    assert.notStrictEqual(lk.identityOf('uid_abc', 'bbbbbbbbbbbb'), id1);
    assert.notStrictEqual(lk.identityOf('uid_xyz', 'aaaaaaaaaaaa'), id1);
});

test('聽眾通行證：簽章正確、只能聽、只能用麥克風、15 分鐘到期', () => {
    const now = 1_800_000_000_000;
    const t = decode(lk.accessToken({ room: 'asm_x', identity: 'p1', name: '小光', canPublish: false, ttlSeconds: 900, now }));
    assert.strictEqual(t.valid, true);
    assert.strictEqual(t.header.alg, 'HS256');
    assert.strictEqual(t.body.iss, 'APIkey');
    assert.strictEqual(t.body.sub, 'p1');
    assert.strictEqual(t.body.exp - Math.floor(now / 1000), 900);
    assert.deepStrictEqual(
        [t.body.video.room, t.body.video.roomJoin, t.body.video.canSubscribe, t.body.video.canPublish, t.body.video.canPublishData],
        ['asm_x', true, true, false, false],
    );
    assert.deepStrictEqual(t.body.video.canPublishSources, ['microphone']);
    assert.strictEqual(t.body.video.roomAdmin, undefined);
});

test('主持人通行證可以發聲；管理通行證有 roomAdmin', () => {
    const host = decode(lk.accessToken({ room: 'asm_x', identity: 'p2', canPublish: true, ttlSeconds: 900 }));
    assert.strictEqual(host.body.video.canPublish, true);
    const admin = decode(lk.adminToken('asm_x'));
    assert.strictEqual(admin.valid, true);
    assert.strictEqual(admin.body.video.roomAdmin, true);
    assert.strictEqual(admin.body.video.room, 'asm_x');
});

test('wss 網址換成 https 呼叫 API', () => {
    assert.strictEqual(lk.httpBase('wss://live.example.test/'), 'https://live.example.test');
    assert.strictEqual(lk.httpBase('ws://localhost:7880'), 'http://localhost:7880');
});
