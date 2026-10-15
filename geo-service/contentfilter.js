// ============================================================================
// 基本的不當字詞過濾（App Store 1.2：使用者產生的內容需要過濾機制）
//   - 低語：含不當字詞直接拒絕
//   - 心情、暱稱：不當字詞替換成「＊」
// 這是起步用的清單，之後依檢舉內容持續擴充；比對時忽略空白、標點與大小寫，擋住「幹 你 娘」這類拆字。
// ============================================================================

const BLOCKED_TERMS = [
    // 辱罵
    '幹你娘', '幹你老師', '操你媽', '操你妈', '肏你', '雞掰', '機掰', '雞巴', '機巴', '賤人', '婊子', '去死', '智障', '腦殘',
    // 性與招攬
    '約砲', '約炮', '援交', '打砲', '打炮', '做愛', '口交', '性交易', '一夜情', '裸照', '色情',
    // 英文
    'fuck', 'shit', 'bitch', 'cunt', 'dick', 'pussy', 'nigger', 'faggot',
];

const IGNORED = /[\s\p{P}\p{S}_]/gu;

function normalize(text) {
    return String(text || '').toLowerCase().replace(IGNORED, '');
}

/** 是否含有不當字詞 */
function hasBlockedTerm(text) {
    const n = normalize(text);
    return BLOCKED_TERMS.some((t) => n.includes(t));
}

/** 把不當字詞替換成等長的「＊」；拆字（中間夾空白或符號）的情況整段替換 */
function maskBlockedTerms(text) {
    let out = String(text || '');
    for (const term of BLOCKED_TERMS) {
        // 容許每個字之間夾任意空白或符號
        const pattern = new RegExp([...term].map((ch) => ch.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('[\\s\\p{P}\\p{S}_]*'), 'giu');
        out = out.replace(pattern, (m) => '＊'.repeat([...m.replace(IGNORED, '')].length || 1));
    }
    return out;
}

module.exports = { BLOCKED_TERMS, hasBlockedTerm, maskBlockedTerms };
