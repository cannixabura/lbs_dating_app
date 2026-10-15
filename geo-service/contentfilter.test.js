// 內容過濾的回歸測試：擴充詞表後執行 `node --test` 確認沒有誤擋日常用語。
const test = require('node:test');
const assert = require('node:assert');
const { isDisallowed, hasBlockedTerm, hasContactInfo, maskBlockedTerms } = require('./contentfilter');

const BLOCKED = [
    '幹 你 娘', '操你媽啦', '雞 掰', '幹​你​娘', '你是智障嗎',
    'Ｆｕｃｋ you', 'f*ck', '5h1t', 'fucking hell', 'bitches', 'f u c k',
    '約砲嗎', '有人要約p', '找砲友', '外送茶',
    '老師帶單穩賺', '保證獲利', '賣大麻', '毒咖啡包',
    '支那豬', '死gay',
];

const CONTACTS = [
    '加我賴', '加line聊', 'LINE ID: abc123', 'line：mood88',
    '0912-345-678', '0912345678', '+886 912 345 678',
    'https://bit.ly/xyz', '看這 www.scam.tw', 'ig: lonely_cat', '@lonelycat99',
];

// 不可以誤擋的日常用語
const HARMLESS = [
    '今天好累，想幹嘛都不想', '大麻煩又來了', '去藥局買藥', '我家喵喵好可愛', '我好白痴忘記帶傘',
    '花了426元', '打開房間的窗', 'line up 排隊', '在線上 online', '今晚的風很溫柔', '想找人一起喝杯咖啡',
    '漫步在微雨中🌧️', '終於下班了😊', '下雨天好難過', '靠北，又下雨', '屌打全場的表演',
    'Dickens 的小說', 'assessment 寫完了', 'scunthorpe', 'shitake 香菇', 'class 下課', '手機 09 點的鬧鐘',
];

test('blocks abusive, sexual, scam and hateful terms, including split and look-alike spellings', () => {
    for (const t of BLOCKED) assert.ok(hasBlockedTerm(t), t);
});

test('blocks contact info that whispers must not carry', () => {
    for (const t of CONTACTS) assert.ok(isDisallowed(t), t);
});

test('does not block everyday language', () => {
    for (const t of HARMLESS) assert.ok(!isDisallowed(t), t);
});

test('masks only the offending part, keeping the rest of the mood', () => {
    assert.strictEqual(maskBlockedTerms('幹 你 娘 啦'), '＊＊＊ 啦');
    assert.strictEqual(maskBlockedTerms('Ｆｕｃｋ this'), '＊＊＊＊ this');
    assert.strictEqual(maskBlockedTerms('Dickens 好看'), 'Dickens 好看');
    assert.ok(!/\d{3}/.test(maskBlockedTerms('我是阿明 0912-345-678')));
    assert.strictEqual(maskBlockedTerms('今天好累'), '今天好累');
    assert.ok(hasContactInfo('0912345678'));
});
