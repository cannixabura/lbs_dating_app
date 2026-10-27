// ============================================================================
// 城市心情天氣：把 20 公里內、24 小時內的匿名心情彙總成百分比
// 分類規則與 App 的氣泡顏色相同（lib/mood_keywords.dart），先符合者優先。
// 少於 MIN_PEOPLE 人時不給百分比，避免人少時能推測出誰是什麼心情。
// ============================================================================

const CITY_RADIUS_KM = 20;
const WINDOW_MS = 24 * 60 * 60 * 1000;
const MIN_PEOPLE = 10;

// 各語言的關鍵字在 mood_keywords.json；label 是給舊版 App 顯示用的繁中名稱，新版 App 依 key 自己翻譯
const KEYWORDS = require('./mood_keywords.json');
const LABELS = { joy: '開心', sad: '難過', angry: '生氣', calm: '平靜', passion: '熱情', love: '愛' };
const CATEGORIES = Object.keys(LABELS).map((key) => ({ key, label: LABELS[key], words: KEYWORDS[key] }));
const OTHER = { key: 'other', label: '其他' };

const LATIN = /[A-Za-z\u00C0-\u024F\u1E00-\u1EFF]/;
const escape = (w) => w.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

// 含拉丁字母的字詞要整個字相符、不分大小寫；中日韓文字只要出現就算
function matches(mood, word) {
    if (!LATIN.test(word)) return mood.includes(word);
    return new RegExp(`(^|[^\\p{L}])${escape(word)}($|[^\\p{L}])`, 'iu').test(mood);
}

function classifyMood(text) {
    const mood = String(text || '');
    for (const c of CATEGORIES) {
        if (c.words.some((w) => matches(mood, w))) return c.key;
    }
    return OTHER.key;
}

/**
 * @param {Array<{mood: string, lastSeen: number}>} people
 * @returns {{total: number, quiet: boolean, moods?: Array<{key, label, count, percent}>}}
 */
function summarize(people, now) {
    const recent = people.filter((p) => p.lastSeen && now - p.lastSeen <= WINDOW_MS);
    const total = recent.length;
    if (total < MIN_PEOPLE) return { total, quiet: true };

    const counts = {};
    for (const p of recent) {
        const k = classifyMood(p.mood);
        counts[k] = (counts[k] || 0) + 1;
    }
    const moods = [...CATEGORIES, OTHER]
        .map((c) => ({ key: c.key, label: c.label, count: counts[c.key] || 0 }))
        .filter((m) => m.count > 0)
        .sort((a, b) => b.count - a.count)
        .map((m) => ({ ...m, percent: Math.round((m.count / total) * 100) }));
    return { total, quiet: false, moods };
}

// 附近的人共用同一份快取：以約 5 公里的格子為單位
function cacheKey(lat, lng) {
    return `city_mood:${Math.round(lat / 0.05)}:${Math.round(lng / 0.05)}`;
}

module.exports = { CITY_RADIUS_KM, MIN_PEOPLE, CATEGORIES, OTHER, classifyMood, summarize, cacheKey };
