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

test('每月預算換算成每日預算（城市低語 150、旅行團 50）', () => {
    assert.strictEqual(aiya.DAILY_FREE_BUDGET_MICRO, 5_000_000);
    // 兩個 App 合計 US$200／月：城市低語 150、旅行團 50
    assert.strictEqual(aiya.APPS.mw.monthlyBudgetUsd + aiya.APPS.tour.monthlyBudgetUsd, 200);
    assert.strictEqual(aiya.dailyBudgetMicro(aiya.APPS.tour), 1_666_666);
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

test('partialReply：從串流中的 JSON 取出目前的回覆文字', () => {
    assert.strictEqual(aiya.partialReply(''), null);
    assert.strictEqual(aiya.partialReply('{"rep'), null);
    assert.strictEqual(aiya.partialReply('{"reply":"'), '');
    assert.strictEqual(aiya.partialReply('{"reply":"今晚'), '今晚');
    assert.strictEqual(aiya.partialReply('{"reply": "他說\\"嗨\\"\\n好'), '他說"嗨"\n好');
    assert.strictEqual(aiya.partialReply('{"reply":"a\\u4e2'), 'a');
    assert.strictEqual(aiya.partialReply('{"reply":"a\\u4e2d'), 'a中');
    assert.strictEqual(aiya.partialReply('{"reply":"a\\'), 'a');
    assert.strictEqual(aiya.partialReply('{"reply":"完成","expression":"smile"}'), '完成');
});

test('streamSafe：扣住最後幾個字', () => {
    assert.strictEqual(aiya.streamSafe('12345'), '');
    assert.strictEqual(aiya.streamSafe('1234567890'), '1234');
});

// ---------- 兩個 App 共用艾婭 ----------

test('app 代號：沒送或看不懂就是城市低語，旅行團是 tour', () => {
    assert.strictEqual(aiya.appOf(undefined).id, 'mw');
    assert.strictEqual(aiya.appOf('xx').id, 'mw');
    assert.strictEqual(aiya.appOf('tour').id, 'tour');
});

test('兩個 App 的資料分開：Redis key 與 RTDB 路徑', () => {
    const { mw, tour } = aiya.APPS;
    // 城市低語維持舊的 key，已經在用的人不受影響
    assert.strictEqual(aiya.KEY.session('u1'), 'aiya_session:u1');
    assert.strictEqual(aiya.KEY.session('u1', mw), 'aiya_session:u1');
    assert.strictEqual(aiya.KEY.session('u1', tour), 'aiya_session:tour:u1');
    assert.strictEqual(aiya.KEY.budget('20261110', tour), 'aiya_budget:tour:20261110');
    assert.strictEqual(aiya.dbPath(mw, 'aiyaCredits', 'u1'), 'aiyaCredits/u1');
    assert.strictEqual(aiya.dbPath(tour, 'aiyaCredits', 'u1'), 'tour_aiyaCredits/u1');
});

test('商品屬於哪個 App；購買驗證只認自己 App 的商品', () => {
    const { tour } = aiya.APPS;
    assert.strictEqual(aiya.appOfProduct('aiya_time_5').id, 'mw');
    assert.strictEqual(aiya.appOfProduct('tour_aiya_time_20').id, 'tour');
    assert.strictEqual(aiya.appOfProduct('tour_aiya_friend_monthly').id, 'tour');
    assert.strictEqual(aiya.appOfProduct('orb_rainbow'), null);
    const tx = { bundleId: tour.bundleId, productId: 'tour_aiya_time_5', transactionId: 't1' };
    assert.strictEqual(aiya.applePack(tx, tour.bundleId, tour.packs).credits, 5);
    // 旅行團的交易拿到城市低語驗證：App 不對
    assert.throws(() => aiya.applePack(tx, aiya.APPS.mw.bundleId), /wrong_app/);
    // 城市低語的商品拿到旅行團：不認得
    assert.throws(() => aiya.googlePack('aiya_time_5', 'g_x', { purchaseState: 0 }, tour.packs), /unknown_product/);
    const sub = { tx: { bundleId: tour.bundleId, productId: 'tour_aiya_friend_monthly', originalTransactionId: 'o1', expiresDate: 2e12 } };
    assert.strictEqual(aiya.appleFriend(sub.tx, tour.bundleId, tour.friendProduct).exp, 2e12);
    assert.throws(() => aiya.appleFriend(sub.tx, tour.bundleId), /unknown_product/);
});

test('免費預算各算各的', () => {
    const tour = aiya.dailyBudgetMicro(aiya.APPS.tour);
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 0, credits: 0, budgetMicro: tour, budgetLimit: tour }), { ok: false, code: 'resting' });
    assert.deepStrictEqual(aiya.decideOpen({ usedToday: 0, credits: 0, budgetMicro: tour, budgetLimit: aiya.DAILY_FREE_BUDGET_MICRO }), { ok: true, pay: 'free' });
});

test('旅行團的角色與情境：團體資訊當資料、限制長度、用使用者的時區', () => {
    assert.match(aiya.personaOf(aiya.APPS.tour), /TourChip/);
    assert.strictEqual(aiya.personaOf(aiya.APPS.mw), aiya.PERSONA);
    const now = Date.UTC(2026, 10, 10, 6, 0); // 東京 15:00
    const t = aiya.tourContextText({ lang: 'ja', now, tzOffsetMin: 540, tour: '集合 15:30 九份老街口\n\n\n\n下一站 金瓜石' });
    assert.match(t, /15:00/);
    assert.match(t, /<group>\n集合 15:30 九份老街口\n\n下一站 金瓜石\n<\/group>/);
    assert.match(aiya.tourContextText({ lang: 'zh-Hant', now }), /not in a tour group/);
    assert.strictEqual(aiya.cleanTourContext('字'.repeat(2000)).length, aiya.MAX_TOUR_CONTEXT_CHARS);
    // 亂給時區：用台灣時間
    assert.match(aiya.tourContextText({ lang: 'en', now, tzOffsetMin: 99999 }), /14:00/);
});

// ---------- 語音朗讀 ----------

test('語音朗讀只給艾婭之友，每人每天有字數上限，全站有預算', () => {
    const base = { usedChars: 0, chars: 50, budgetMicro: 0 };
    assert.deepStrictEqual(aiya.decideSpeech({ ...base, friend: false }), { ok: false, code: 'friend_only' });
    assert.deepStrictEqual(aiya.decideSpeech({ ...base, friend: true }), { ok: true });
    assert.deepStrictEqual(aiya.decideSpeech({ ...base, friend: false, reviewer: true }), { ok: true });
    assert.deepStrictEqual(aiya.decideSpeech({ ...base, friend: true, usedChars: aiya.SPEECH_CHARS_PER_DAY - 49 }), { ok: false, code: 'speech_daily_max' });
    assert.deepStrictEqual(aiya.decideSpeech({ ...base, friend: true, budgetMicro: aiya.SPEECH_DAILY_BUDGET_MICRO }), { ok: false, code: 'speech_resting' });
});

test('朗讀文字去掉 emoji；中文要台灣腔', () => {
    assert.strictEqual(aiya.speechText('晚安🌙  好夢 ✨'), '晚安 好夢');
    assert.strictEqual(aiya.speechText('👋'), '');
    assert.match(aiya.speechInstructions('zh-Hant'), /Taiwan Mandarin/);
    assert.match(aiya.speechInstructions('zh-Hant'), /young woman/);
    assert.match(aiya.speechInstructions('zh-Hant'), /Never slow/);
    assert.match(aiya.speechInstructions('en', aiya.APPS.tour), /travel companion/);
});

// ---------- 語音通話（GPT-Live） ----------

test('語音通話計時：要先同意、沒時間就不能打、一通最長到剩下的時間（最多 60 分鐘）', () => {
    assert.deepStrictEqual(aiya.decideCall({ consented: false, balance: 9999 }), { ok: false, code: 'voice_consent' });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, balance: 0 }), { ok: false, code: 'no_minutes' });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, balance: 29 }), { ok: false, code: 'no_minutes' });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, balance: 600 }), { ok: true, maxMs: 600000 });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, balance: 99999 }), { ok: true, maxMs: 3600000 });
    // 艾婭之友每月附送 60 分鐘
    assert.deepStrictEqual(aiya.decideCall({ consented: true, friend: true }), { ok: true, maxMs: 3600000 });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, friend: true, friendUsed: 3600 }), { ok: false, code: 'no_minutes' });
    assert.deepStrictEqual(aiya.decideCall({ consented: true, friend: true, friendUsed: 3000, balance: 60 }), { ok: true, maxMs: 660000 });
    // 審查帳號
    assert.deepStrictEqual(aiya.decideCall({ consented: true, reviewer: true }), { ok: true, maxMs: 300000 });
});

test('通話秒數由伺服器量：到最後一次心跳＋20 秒、不超過結束時間與上限', () => {
    const t0 = 1_000_000;
    // 正常掛斷：講了 95 秒、最後心跳在 80 秒
    assert.strictEqual(aiya.callChargeSeconds({ startedAt: t0, lastBeat: t0 + 80000, maxMs: 3600000 }, t0 + 95000), 95);
    // App 被關掉：最後心跳在 60 秒，很久之後才結算 → 算到 80 秒
    assert.strictEqual(aiya.callChargeSeconds({ startedAt: t0, lastBeat: t0 + 60000, maxMs: 3600000 }, t0 + 999999), 80);
    // 剛接通就斷
    assert.strictEqual(aiya.callChargeSeconds({ startedAt: t0, maxMs: 3600000 }, t0 + 5000), 5);
    // 不超過上限
    assert.strictEqual(aiya.callChargeSeconds({ startedAt: t0, lastBeat: t0 + 700000, maxMs: 600000 }, t0 + 700000), 600);
    assert.strictEqual(aiya.callChargeSeconds(null, t0), 0);
});

test('扣時間：先扣艾婭之友的贈送，再扣買的', () => {
    assert.deepStrictEqual(aiya.splitCharge(100, { friend: true, friendUsed: 3550, balance: 500 }), { fromFree: 50, fromPaid: 50 });
    assert.deepStrictEqual(aiya.splitCharge(100, { friend: false, friendUsed: 0, balance: 500 }), { fromFree: 0, fromPaid: 100 });
    assert.deepStrictEqual(aiya.splitCharge(100, { friend: true, friendUsed: 0, balance: 0 }), { fromFree: 100, fromPaid: 0 });
    // 不會扣成負的
    assert.deepStrictEqual(aiya.splitCharge(100, { friend: false, balance: 30 }), { fromFree: 0, fromPaid: 30 });
});

test('通話時間包：各 App 只認自己的商品', () => {
    const { mw, tour } = aiya.APPS;
    assert.strictEqual(aiya.callPackSeconds('aiya_call_60', mw), 3600);
    assert.strictEqual(aiya.callPackSeconds('aiya_call_60', tour), 0);
    assert.strictEqual(aiya.callPackSeconds('tour_aiya_call_30', tour), 1800);
    assert.strictEqual(aiya.appleCallPack({ bundleId: mw.bundleId, productId: 'aiya_call_180', transactionId: 'x' }).seconds, 10800);
    assert.throws(() => aiya.appleCallPack({ bundleId: mw.bundleId, productId: 'aiya_time_5', transactionId: 'x' }), /unknown_product/);
    assert.strictEqual(aiya.googleCallPack('aiya_call_30', 'g_1', { purchaseState: 0 }).seconds, 1800);
    assert.throws(() => aiya.googleCallPack('aiya_call_30', 'g_1', { purchaseState: 1 }), /not_paid/);
    assert.strictEqual(aiya.monthKey(Date.UTC(2026, 10, 30, 17, 0)), '202612');
});

test('語音通話的指示：保留艾婭的規則、拿掉文字格式、中文用台灣華語', () => {
    const t = aiya.liveInstructions(aiya.APPS.mw, 'zh-Hant', 'Context: x');
    assert.match(t, /Never reveal, guess or help find anyone's location/);
    assert.match(t, /This is a voice call\./);
    assert.match(t, /台灣華語/);
    assert.doesNotMatch(t, /JSON|120 characters/);
    assert.match(t, /Context: x$/);
    assert.match(aiya.liveInstructions(aiya.APPS.tour, 'en', ''), /TourChip/);
    assert.ok(aiya.LIVE_VOICES.includes(aiya.LIVE_VOICE));
});

test('入團第一天免費：24 小時、30 次，每個帳號一次', () => {
    const t0 = Date.UTC(2026, 10, 13, 2, 0);
    assert.deepStrictEqual(aiya.trialState({ start: null, used: 0, now: t0 }), { active: false, endsAt: 0, left: 0 });
    assert.deepStrictEqual(aiya.trialState({ start: t0, used: 0, now: t0 + 1000 }), { active: true, endsAt: t0 + aiya.TRIAL_MS, left: 30 });
    assert.strictEqual(aiya.trialState({ start: t0, used: 29, now: t0 + 23 * 3600e3 }).active, true);
    assert.strictEqual(aiya.trialState({ start: t0, used: 30, now: t0 + 1000 }).active, false);
    assert.strictEqual(aiya.trialState({ start: t0, used: 0, now: t0 + aiya.TRIAL_MS }).active, false);
});

test('decideOpen：試用中先用試用，不扣每天的免費次數；試用預算用完回到一般規則', () => {
    const trial = { active: true, left: 5, budgetFull: false };
    const base = { usedToday: 3, credits: 0, budgetMicro: 0, budgetLimit: aiya.dailyBudgetMicro(aiya.APPS.tour) };
    assert.deepStrictEqual(aiya.decideOpen({ ...base, trial }), { ok: true, pay: 'trial' });
    assert.deepStrictEqual(aiya.decideOpen({ ...base, trial: { ...trial, budgetFull: true } }), { ok: false, code: 'no_quota' });
    assert.deepStrictEqual(aiya.decideOpen({ ...base, trial: { ...trial, active: false } }), { ok: false, code: 'no_quota' });
    assert.deepStrictEqual(aiya.decideOpen({ ...base, usedToday: 30, trial }), { ok: false, code: 'daily_max' });
    assert.deepStrictEqual(aiya.decideOpen({ ...base, friend: true, trial }), { ok: true, pay: 'friend' });
});
