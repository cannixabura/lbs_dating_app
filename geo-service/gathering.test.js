const test = require('node:test');
const assert = require('node:assert');
const g = require('./gathering');

test('emoji keys ignore the variation selector and keep ZWJ sequences whole', () => {
    assert.strictEqual(g.emojiKey('❤️'), g.emojiKey('❤'));
    assert.strictEqual(g.emojiKey('🏳️‍🌈'), '1f3f3_200d_1f308');
    assert.deepStrictEqual([...g.emojiKeysIn('遊行🏳️‍🌈小雨☔️')], ['1f3f3_200d_1f308', '2614']);
    assert.strictEqual(g.emojiKeysIn('沒有符號').size, 0);
});

test('the event icon must be exactly one emoji', () => {
    assert.ok(g.validateEmoji('🌈').emoji);
    assert.ok(g.validateEmoji(' 🇹🇼 ').emoji);
    assert.ok(g.validateEmoji('🏳️‍🌈').emoji);
    assert.ok(g.validateEmoji('1️⃣').emoji);
    assert.ok(g.validateEmoji('🌈🌈').error);
    assert.ok(g.validateEmoji('彩虹').error);
    assert.ok(g.validateEmoji('').error);
});

test('times: start within 24h, end after start, at most 24h long', () => {
    const now = Date.UTC(2026, 9, 31, 10);
    const h = 3600 * 1000;
    assert.ok(!g.validateTimes(now, now + 3 * h, now).error);
    assert.ok(g.validateTimes(now - h, now + h, now).error);
    assert.ok(g.validateTimes(now + 25 * h, now + 26 * h, now).error);
    assert.ok(g.validateTimes(now, now, now).error);
    assert.ok(g.validateTimes(now, now + 25 * h, now).error);
});

test('the same emoji conflicts only when centres are within 10 km', () => {
    const taipei = { lat: 25.0375, lng: 121.5637 };
    const mainStation = { lat: 25.0478, lng: 121.5170 };
    const kaohsiung = { lat: 22.6273, lng: 120.3014 };
    assert.ok(g.conflicts([mainStation], taipei));
    assert.ok(!g.conflicts([kaohsiung], taipei));
});

test('announcements go through the content filter', () => {
    assert.ok(!g.validateAnnouncement('隊伍在忠孝東路口集合').error);
    assert.ok(g.validateAnnouncement('加我 line: abc123').error);
    assert.ok(g.validateAnnouncement('   ').error);
});

test('question tally hides ratios under 10 answers', () => {
    assert.deepStrictEqual(g.tally(['joy', 'calm']), { total: 2, quiet: true });
    const t = g.tally([...Array(6).fill('joy'), ...Array(4).fill('calm')]);
    assert.strictEqual(t.quiet, false);
    assert.deepStrictEqual(t.moods.map((m) => [m.label, m.percent]), [['開心', 60], ['平靜', 40]]);
});

test('report threshold: 10 people or 10% of participants, whichever is larger', () => {
    assert.strictEqual(g.reportThreshold(0), 10);
    assert.strictEqual(g.reportThreshold(80), 10);
    assert.strictEqual(g.reportThreshold(500), 50);
    assert.strictEqual(g.reportThreshold(501), 51);
});

test('report targets name an announcement or the whole event', () => {
    assert.deepStrictEqual(g.parseReportTarget('gathering:-Pabc:-Pxyz'), { gid: '-Pabc', aid: '-Pxyz' });
    assert.deepStrictEqual(g.parseReportTarget('gathering:-Pabc'), { gid: '-Pabc', aid: null });
    assert.strictEqual(g.parseReportTarget('whisper:1'), null);
});

test('handoff goes only to a participant in range who is not hosting', () => {
    const g = { emoji: '🎆', emojiKey: g_key('🎆'), lat: 25.034, lng: 121.5645 };
    const near = { lat: 25.04, lng: 121.56 };
    assert.strictEqual(g_problem(g, { nickname: '跨年的貓🎆', pos: near }), null);
    assert.match(g_problem(g, { nickname: '跨年的貓', pos: near }), /還沒加入/);
    assert.match(g_problem(g, { nickname: '🎆', pos: { lat: 22.6, lng: 120.3 } }), /5 公里/);
    assert.match(g_problem(g, { nickname: '🎆', pos: near, hosting: '-other' }), /另一場/);
    assert.match(g_problem(g, { nickname: '🎆', pos: near, hidden: '1' }), /無法接下/);
    assert.match(g_problem(g, { nickname: '🎆', pos: near, blocked: true }), /無法把活動/);
});
function g_key(e) { return g.emojiKey(e); }
function g_problem(gg, b) { return g.handoffProblem(gg, b); }
