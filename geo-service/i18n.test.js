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
    assert.strictEqual(normalizeLang('fr'), 'zh-Hant');
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
