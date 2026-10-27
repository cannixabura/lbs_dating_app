const test = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const path = require('path');
const { classifyMood } = require('./citymood');
const KEYWORDS = require('./mood_keywords.json');

test('各語言的心情都分得出來', () => {
    assert.strictEqual(classifyMood('今天好開心'), 'joy');
    assert.strictEqual(classifyMood('今天好开心'), 'joy');
    assert.strictEqual(classifyMood('So happy tonight'), 'joy');
    assert.strictEqual(classifyMood('悲しい夜'), 'sad');
    assert.strictEqual(classifyMood('너무 슬퍼'), 'sad');
    assert.strictEqual(classifyMood('Saya marah'), 'angry');
    assert.strictEqual(classifyMood('Lagi santai di kafe'), 'calm');
    assert.strictEqual(classifyMood('Đang rất hào hứng'), 'passion');
    assert.strictEqual(classifyMood('Yêu Sài Gòn'), 'love');
    assert.strictEqual(classifyMood('喝了一杯咖啡'), 'other');
});

test('拉丁字母的關鍵字要整個字相符', () => {
    assert.strictEqual(classifyMood('Sadie says hi'), 'other');
    assert.strictEqual(classifyMood('SAD!'), 'sad');
    assert.strictEqual(classifyMood('서울의 밤'), 'other'); // 「울」不能讓首爾變成難過
});

test('App 的 lib/mood_keywords.dart 與 mood_keywords.json 一致', () => {
    const dart = fs.readFileSync(path.join(__dirname, '..', 'lib', 'mood_keywords.dart'), 'utf8');
    for (const [key, words] of Object.entries(KEYWORDS)) {
        if (key.startsWith('_')) continue;
        const line = dart.split('\n').find((l) => l.trim().startsWith(`'${key}':`));
        assert.ok(line, `lib/mood_keywords.dart 少了 ${key}`);
        assert.deepStrictEqual([...line.matchAll(/'([^']*)'/g)].map((m) => m[1]).slice(1), words, key);
    }
});
