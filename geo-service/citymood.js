// ============================================================================
// 城市心情天氣：把 20 公里內、24 小時內的匿名心情彙總成百分比
// 分類規則與 App 的氣泡顏色相同（lib/main.dart 的 _getMoodColor），先符合者優先。
// 少於 MIN_PEOPLE 人時不給百分比，避免人少時能推測出誰是什麼心情。
// ============================================================================

const CITY_RADIUS_KM = 20;
const WINDOW_MS = 24 * 60 * 60 * 1000;
const MIN_PEOPLE = 10;

const CATEGORIES = [
    { key: 'joy', label: '開心', words: ['😊', '開心', '笑'] },
    { key: 'sad', label: '難過', words: ['😢', '難過', '哭'] },
    { key: 'angry', label: '生氣', words: ['😡', '生氣', '怒'] },
    { key: 'calm', label: '平靜', words: ['🌿', '平靜', '發呆'] },
    { key: 'passion', label: '熱情', words: ['🔥', '熱情'] },
    { key: 'love', label: '愛', words: ['💖', '愛', '心'] },
];
const OTHER = { key: 'other', label: '其他' };

function classifyMood(text) {
    const mood = String(text || '');
    for (const c of CATEGORIES) {
        if (c.words.some((w) => mood.includes(w))) return c.key;
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

module.exports = { CITY_RADIUS_KM, MIN_PEOPLE, classifyMood, summarize, cacheKey };
