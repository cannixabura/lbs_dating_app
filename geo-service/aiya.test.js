const test = require('node:test');
const assert = require('node:assert');
const aiya = require('./aiya');

test('dayKey 以台灣時間換日', () => {
    assert.strictEqual(aiya.dayKey(Date.UTC(2026, 10, 4, 15, 59)), '20261104');
    assert.strictEqual(aiya.dayKey(Date.UTC(2026, 10, 4, 16, 0)), '20261105');
});

test('costMicro：Haiku 5.5 的價格', () => {
    assert.strictEqual(aiya.costMicro({ input_tokens: 1_000_000, output_tokens: 0 }), 100_000); // US$0.10
    assert.strictEqual(aiya.costMicro({ input_tokens: 3000, output_tokens: 300 }), 450);
    assert.strictEqual(aiya.costMicro({ input_tokens: 100, output_tokens: 10, cache_read_input_tokens: 2000 }), 35);
    assert.strictEqual(aiya.costMicro(null), 0);
});

test('decideOpen：先用免費，再扣時光包', () => {
    const ok = { budgetMicro: 0, credits: 0 };
    assert.deepStrictEqual(aiya.decideOpen({ ...ok, usedToday: 0 }), { ok: true, pay: 'free' });
    assert.deepStrictEqual(aiya.decideOpen({ ...ok, usedToday: 2 }), { ok: true, pay: 'free' });
    assert.deepStrictEqual(aiya.decideOpen({ ...ok, usedToday: 3 }), { ok: false, code: 'no_quota' });
    assert.deepStrictEqual(aiya.decideOpen({ ...ok, usedToday: 3, credits: 5 }), { ok: true, pay: 'credit' });
});

test('decideOpen：全站免費預算用完時艾婭休息，但付費的人照樣能聊', () => {
    const full = aiya.DAILY_FREE_BUDGET_MICRO;
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 0, credits: 0, budgetMicro: full }), { ok: false, code: 'resting' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 0, credits: 2, budgetMicro: full }), { ok: true, pay: 'credit' });
});

test('decideOpen：每天最多 30 次，審查人員不受限制', () => {
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 30, credits: 99, budgetMicro: 0 }), { ok: false, code: 'daily_max' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 99, credits: 0, budgetMicro: 1e12, reviewer: true }), { ok: true, pay: 'free' });
});

test('每月 US$200 換算成每日預算', () => {
    assert.strictEqual(aiya.DAILY_FREE_BUDGET_MICRO, 6_666_666);
});

test('sessionAlive：10 分鐘或 20 則就結束', () => {
    const now = 1_000_000;
    assert.strictEqual(aiya.sessionAlive({ startedAt: now - 60_000, turns: 3 }, now), true);
    assert.strictEqual(aiya.sessionAlive({ startedAt: now - aiya.SESSION_MS, turns: 3 }, now), false);
    assert.strictEqual(aiya.sessionAlive({ startedAt: now, turns: 20 }, now), false);
    assert.strictEqual(aiya.sessionAlive(null, now), false);
    assert.deepStrictEqual(aiya.sessionView({ id: 's', startedAt: now - 60_000, turns: 5 }, now), { id: 's', endsAt: now - 60_000 + aiya.SESSION_MS, turnsLeft: 15, remainingMs: aiya.SESSION_MS - 60_000 });
});

test('cleanInput：去空白、限制 200 字（emoji 算一個字）', () => {
    assert.strictEqual(aiya.cleanInput('  嗨\n  艾婭  '), '嗨 艾婭');
    assert.strictEqual(aiya.cleanInput('   '), null);
    assert.strictEqual(aiya.visibleLength(aiya.cleanInput('😵‍💫'.repeat(300))), 200);
});

test('parseReply：只接受 schema 裡的表情', () => {
    assert.deepStrictEqual(aiya.parseReply('{"reply":"今晚好安靜。","expression":"smile"}'), { reply: '今晚好安靜。', expression: 'smile' });
    assert.deepStrictEqual(aiya.parseReply('{"reply":"嗨","expression":"angry"}'), { reply: '嗨', expression: 'calm' });
    assert.strictEqual(aiya.parseReply('not json'), null);
    assert.strictEqual(aiya.parseReply('{"reply":"   ","expression":"calm"}'), null);
    assert.strictEqual(aiya.visibleLength(aiya.parseReply(JSON.stringify({ reply: '字'.repeat(500), expression: 'calm' })).reply), aiya.MAX_REPLY_CHARS);
});

test('contextText：只有聚合資料，人少時不給比例', () => {
    const now = Date.UTC(2026, 10, 4, 14, 5); // 台北 22:05
    const busy = aiya.contextText({ lang: 'ja', now, online: 42, minutesToChime: 55, cityMood: { quiet: false, moods: [{ key: 'sad', percent: 40 }, { key: 'joy', percent: 30 }] } });
    assert.match(busy, /Japanese/);
    assert.match(busy, /22:05/);
    assert.match(busy, /42/);
    assert.match(busy, /40% sad or tired, 30% happy/);
    assert.match(aiya.contextText({ lang: 'xx', now, cityMood: { quiet: true } }), /quiet tonight/);
    assert.match(aiya.contextText({ lang: 'xx', now }), /Traditional Chinese/);
});

test('角色設定固定不變（才能快取），也寫明不透露任何人的位置', () => {
    assert.match(aiya.PERSONA, /Never reveal, guess or help find anyone's location/);
    assert.ok(!/\d{4}-\d{2}-\d{2}/.test(aiya.PERSONA));
    assert.deepStrictEqual(aiya.REPLY_SCHEMA.properties.expression.enum, aiya.EXPRESSIONS);
});

test('求助專線：偵測到輕生的字詞時附上當地專線', () => {
    assert.strictEqual(aiya.mentionsCrisis('我真的不想活了'), true);
    assert.strictEqual(aiya.mentionsCrisis('I want to die'), true);
    assert.strictEqual(aiya.mentionsCrisis('死にたい'), true);
    assert.strictEqual(aiya.mentionsCrisis('今天好累'), false);
    assert.match(aiya.hotline('zh-Hant'), /1925/);
    assert.match(aiya.hotline('ko'), /109/);
    assert.strictEqual(aiya.hotline('xx'), aiya.hotline('en'));
});

test('applePack：消耗型每筆收據不同、數量會乘上去', () => {
    const tx = { bundleId: 'com.softchip.moodwhisper', productId: 'aiya_time_5', transactionId: '2000001' };
    assert.deepStrictEqual(aiya.applePack(tx, 'com.softchip.moodwhisper'), { credits: 5, receipt: 'a_2000001', productId: 'aiya_time_5' });
    assert.strictEqual(aiya.applePack({ ...tx, productId: 'aiya_time_20', quantity: 2 }, 'com.softchip.moodwhisper').credits, 40);
    assert.throws(() => aiya.applePack({ ...tx, bundleId: 'x' }, 'com.softchip.moodwhisper'), /wrong_app/);
    assert.throws(() => aiya.applePack({ ...tx, revocationDate: 1 }, 'com.softchip.moodwhisper'), /revoked/);
    assert.throws(() => aiya.applePack({ ...tx, productId: 'orb_rainbow' }, 'com.softchip.moodwhisper'), /unknown_product/);
});

test('googlePack：要付款完成才加次數', () => {
    assert.deepStrictEqual(aiya.googlePack('aiya_time_20', 'g_x', { purchaseState: 0 }), { credits: 20, receipt: 'g_x', productId: 'aiya_time_20' });
    assert.throws(() => aiya.googlePack('aiya_time_5', 'g_x', { purchaseState: 1 }), /not_paid/);
    assert.throws(() => aiya.googlePack('orb_rainbow', 'g_x', { purchaseState: 0 }), /unknown_product/);
});

test('fullWidthPunct：中日文旁的半形標點改全形，英文和時間不動', () => {
    assert.strictEqual(aiya.fullWidthPunct('辛苦了,是哪一段?'), '辛苦了，是哪一段？');
    assert.strictEqual(aiya.fullWidthPunct('Hi, how are you?'), 'Hi, how are you?');
    assert.strictEqual(aiya.fullWidthPunct('時間:10:30'), '時間：10:30');
    assert.strictEqual(aiya.parseReply('{"reply":"好啊,一起看星星!","expression":"smile"}').reply, '好啊，一起看星星！');
});

test('decideOpen：艾婭之友每天 20 次、不受全站預算影響，用完再扣時光包', () => {
    const full = aiya.DAILY_FREE_BUDGET_MICRO;
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 0, credits: 0, budgetMicro: full, friend: true }), { ok: true, pay: 'friend' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 19, credits: 0, budgetMicro: 0, friend: true }), { ok: true, pay: 'friend' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 20, credits: 0, budgetMicro: 0, friend: true }), { ok: false, code: 'no_quota' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 20, credits: 3, budgetMicro: 0, friend: true }), { ok: true, pay: 'credit' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 30, credits: 3, budgetMicro: 0, friend: true }), { ok: false, code: 'daily_max' });
});

test('sessionAlive：艾婭之友的對話 20 分鐘、40 則', () => {
    const t0 = 1_000_000;
    const friend = { id: 'f', startedAt: t0, turns: 25, pay: 'friend' };
    const free = { id: 'n', startedAt: t0, turns: 5, pay: 'free' };
    assert.strictEqual(aiya.sessionAlive(friend, t0 + 15 * 60 * 1000), true);
    assert.strictEqual(aiya.sessionAlive(free, t0 + 15 * 60 * 1000), false);
    assert.strictEqual(aiya.sessionAlive({ ...friend, turns: 40 }, t0), false);
    assert.strictEqual(aiya.sessionView(friend, t0).turnsLeft, 15);
    assert.strictEqual(aiya.sessionView(friend, t0).remainingMs, 20 * 60 * 1000);
});

test('appleFriend：用 originalTransactionId 當收據，退款時到期時間提前', () => {
    const b = 'com.softchip.moodwhisper';
    const tx = { bundleId: b, productId: 'aiya_friend_monthly', transactionId: '9', originalTransactionId: '1', expiresDate: 5000 };
    assert.deepStrictEqual(aiya.appleFriend(tx, b), { exp: 5000, receipt: 'a_1', productId: 'aiya_friend_monthly' });
    assert.strictEqual(aiya.appleFriend({ ...tx, revocationDate: 3000 }, b).exp, 3000);
    assert.throws(() => aiya.appleFriend({ ...tx, productId: 'aiya_time_5' }, b), /unknown_product/);
    assert.throws(() => aiya.appleFriend({ ...tx, bundleId: 'x' }, b), /wrong_app/);
    assert.strictEqual(aiya.friendActive({ exp: 5000 }, 4999), true);
    assert.strictEqual(aiya.friendActive({ exp: 5000 }, 5000), false);
    assert.strictEqual(aiya.friendActive(null, 0), false);
});

test('googleFriend：有效、寬限期、已取消但未到期都算；取最晚到期', () => {
    const sub = (state) => ({ subscriptionState: state, lineItems: [{ productId: 'aiya_friend_monthly', expiryTime: '2026-12-05T00:00:00Z' }] });
    assert.strictEqual(aiya.googleFriend('aiya_friend_monthly', 'g_x', sub('SUBSCRIPTION_STATE_ACTIVE')).exp, Date.parse('2026-12-05T00:00:00Z'));
    assert.strictEqual(aiya.googleFriend('aiya_friend_monthly', 'g_x', sub('SUBSCRIPTION_STATE_CANCELED')).receipt, 'g_x');
    assert.throws(() => aiya.googleFriend('aiya_friend_monthly', 'g_x', sub('SUBSCRIPTION_STATE_EXPIRED')), /not_paid/);
    assert.throws(() => aiya.googleFriend('aiya_time_5', 'g_x', sub('SUBSCRIPTION_STATE_ACTIVE')), /unknown_product/);
});
