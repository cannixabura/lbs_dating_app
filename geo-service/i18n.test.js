const test = require('node:test');
const assert = require('node:assert');
const { TABLE, LANGS, normalizeLang, localize } = require('./i18n');

test('每一列都有八種語言，變數名稱一致', () => {
    for (const row of TABLE) {
        assert.strictEqual(row.length, LANGS.length, row[0]);
        const vars = (t) => [...t.matchAll(/\{(\w+)\}/g)].map((m) => m[1]).sort().join();
        for (const t of row) assert.strictEqual(vars(t), vars(row[0]), `${row[0]} → ${t}`);
    }
});

test('語言標籤', () => {
    assert.strictEqual(normalizeLang('zh-Hant-TW'), 'zh-Hant');
    assert.strictEqual(normalizeLang('zh-Hans'), 'zh-Hans');
    assert.strictEqual(normalizeLang('zh_CN'), 'zh-Hans');
    assert.strictEqual(normalizeLang('en-US,en;q=0.9'), 'en');
    assert.strictEqual(normalizeLang('in-ID'), 'id');
    assert.strictEqual(normalizeLang('fr'), 'en');
    assert.strictEqual(normalizeLang('pt-BR'), 'pt');
    assert.strictEqual(normalizeLang('es-419'), 'es');
    assert.strictEqual(normalizeLang('hi-IN'), 'hi');
    assert.strictEqual(normalizeLang(null), 'zh-Hant');
});

test('翻譯範本與變數', () => {
    assert.strictEqual(localize('en', '來自 小貓 的低語'), 'A whisper from 小貓');
    assert.strictEqual(localize('ko', '一年前的你，在某個地方留下了一句話。回到那裡，就能讀到。').startsWith('1년 전의'), true);
    assert.strictEqual(localize('ja', '示範對象 07'), 'デモ 07');
    assert.strictEqual(localize('vi', '主持人問：今晚好嗎？'), 'Người tổ chức hỏi: 今晚好嗎？');
    assert.strictEqual(localize('en', '使用者自己寫的公告'), '使用者自己寫的公告');
    assert.strictEqual(localize('zh-Hant', '未授權'), '未授權');
});

test('旅行團推播：英文都有翻譯', () => {
    const { localize: L } = require('./i18n');
    const tg = require('./tourgroup');
    const at = Date.UTC(2026, 10, 17, 0, 30);
    const cases = [
        [tg.callText({ at, tz: 'Asia/Taipei', place: '台北車站' }, at - 5 * 60000), 'Meet at "台北車站" at 08:30 (5 min left)'],
        [tg.callText({ at, tz: 'Asia/Taipei' }, at - 5 * 60000), 'Meet at 08:30 (5 min left). Open the app to see the meeting point.'],
        [tg.callText({ at, tz: 'Asia/Taipei', place: '台北車站' }, at), 'Meet at "台北車站" now'],
        [tg.callText({ at, tz: 'Asia/Taipei' }, at), 'Meet now. Open the app to see the meeting point.'],
        ['第 21 位團員正在等待入團，升級 7 天方案或使用團購券後就能加入。', 'Member 21 is waiting to join. Upgrade to the 7-day pass or use a voucher to let them in.'],
        ['你成為這一團的共同團主了，可以發集合、點名和公告。', "You're now a co-leader of this group. You can call meetups, take roll calls and post notices."],
        ['你成為這一團的團主了。', "You're now the leader of this group."],
        ['這一團已經解散，謝謝這幾天一起同行。', 'This group has ended. Thanks for traveling together.'],
        ['點名：到了請按「我到了」', 'Roll call: tap "I\'m here" when you arrive'],
        ['12 號需要幫忙', 'No. 12 needs help'],
        ['12 號迷路了，傳來了目前的位置', 'No. 12 is lost and shared their location'],
    ];
    for (const [zh, en] of cases) assert.equal(L('en', zh), en);
    assert.equal(L('en', `再提醒一次：${cases[0][0]}`), `Reminder: ${cases[0][1]}`);
});
