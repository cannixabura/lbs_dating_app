const test = require('node:test');
const assert = require('node:assert');
const tw = require('./timewhisper');

const now = Date.UTC(2026, 9, 24);
const DAY = 86400000;

test('only a month or a year', () => {
    assert.strictEqual(tw.unlockAtFor('month', now), now + 30 * DAY);
    assert.strictEqual(tw.unlockAtFor('year', now), now + 365 * DAY);
    assert.strictEqual(tw.unlockAtFor('tomorrow', now), null);
});

test('opens only after unlock and within 100 m', () => {
    const w = { lat: 25.0340, lng: 121.5645, unlockAt: now + DAY };
    assert.match(tw.openProblem(w, { lat: 25.0340, lng: 121.5645 }, now), /還沒到時間/);
    assert.strictEqual(tw.openProblem(w, { lat: 25.0346, lng: 121.5650 }, now + 2 * DAY), null); // 約 80 m
    assert.match(tw.openProblem(w, { lat: 25.0400, lng: 121.5645 }, now + 2 * DAY), /100 公尺/);
});

test('sealed letters never reveal their text', () => {
    const sealed = tw.forOwner('a', { lat: 1, lng: 2, createdAt: now, unlockAt: now + DAY, text: 'secret' }, now);
    assert.ok(!('text' in sealed));
    assert.strictEqual(sealed.unlocked, false);
    const opened = tw.forOwner('a', { lat: 1, lng: 2, createdAt: now, unlockAt: now, text: 'hi', openedAt: now }, now);
    assert.strictEqual(opened.text, 'hi');
});

test('text is required and capped', () => {
    assert.ok(tw.validateText('  ').error);
    assert.ok(tw.validateText('字'.repeat(121)).error);
    assert.strictEqual(tw.validateText(' 明年此地再見 ').text, '明年此地再見');
});
