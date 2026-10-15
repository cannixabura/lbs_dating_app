// ============================================================================
// 基本的不當字詞過濾（App Store 1.2：使用者產生的內容需要過濾機制）
//   - 低語：含不當字詞或聯絡方式直接拒絕
//   - 心情、暱稱：不當字詞與聯絡方式替換成「＊」
// 比對時忽略空白、標點、符號與大小寫，並把全形英數轉半形、常見替代字還原，擋住「幹 你 娘」「Ｆｕｃｋ」「f*ck」這類變形。
// 清單刻意不收單字（幹、屌、靠）與會誤擋日常用語的詞（大麻→大麻煩、買藥、喵喵、白痴、數字 426），寧可漏擋也不要誤擋日常用語；之後依檢舉內容持續擴充。
// ============================================================================

const BLOCKED_TERMS = [
    // 辱罵、髒話
    '幹你娘', '幹妳娘', '幹恁娘', '幹拎娘', '幹林娘', '幹你老師', '幹你老母', '操你媽', '操你妈', '操你娘', '肏你', '草泥馬', '草你媽',
    '雞掰', '機掰', '雞巴', '機巴', '鷄巴', '老二很小', '賤人', '賤貨', '賤婊', '婊子', '破麻', '去死', '去吃屎', '吃屎啦',
    '智障', '腦殘', '低能兒', '廢物東西', '垃圾人', '死胖子', '醜八怪', '人渣', '畜生', '狗娘養', '王八蛋', '王八羔子',
    'ㄍㄋㄇ', 'ㄋㄇㄉ', 'ㄐㄅ',
    // 性與招攬
    '約砲', '約炮', '約p', '援交', '援助交際', '打砲', '打炮', '做愛', '口交', '肛交', '性交易', '一夜情', '裸照', '裸聊', '色情',
    '找砲友', '砲友', '炮友', '包養', '甜心爸爸', '定點茶', '外送茶', '喝茶服務', '叫小姐', '魚訊', '買春', '賣淫', '性服務',
    '奶子', '巨乳', '大奶', '小穴', '陰莖', '陰道', '自慰', '打手槍', '摸奶', '看奶', '傳裸照', '私密照',
    // 詐騙、廣告、博弈、毒品
    '投資群', '帶你賺', '保證獲利', '穩賺不賠', '高報酬', '虛擬幣投資', '飆股', '老師帶單', '帶單', '博弈', '娛樂城', '百家樂', '線上賭場',
    '代辦貸款', '借錢找我', '加我賴', '加賴', '加line', '加我line', '私訊賴', 'line id', 'lineid',
    '安非他命', '冰毒', 'k他命', '愷他命', '搖頭丸', '抽大麻', '賣大麻', '大麻煙', '彩虹煙', '毒咖啡包',
    // 仇恨與歧視
    '支那', '台巴子', '死gay', '死同性戀', '死娘炮', '黑鬼', '阿六仔', '外勞滾',
    // 英文
    'fuck', 'fck', 'fuk', 'shit', 'bitch', 'cunt', 'dick', 'pussy', 'whore', 'slut', 'nigger', 'nigga', 'faggot', 'retard',
    'porn', 'nude', 'nudes', 'onlyfans', 'sexting', 'hookup', 'escort',
];

// 聯絡方式：匿名社交最常見的詐騙與招攬入口
const CONTACT_PATTERNS = [
    /09\d{2}[\s\-.]?\d{3}[\s\-.]?\d{3}/u,               // 台灣手機
    /\+?886[\s\-]?9\d{2}[\s\-.]?\d{3}[\s\-.]?\d{3}/u,  // +886 手機
    /(https?:\/\/|www\.)\S+/iu,                          // 網址
    /\b[\w.-]+\.(com|net|org|tw|cc|me|io|xyz|top|link|app)\b/iu, // 網域
    /\bline\s*(id\s*)?[:：]\s*@?[a-z0-9._-]{3,}/iu,      // LINE: xxx、LINE ID：xxx
    /\b(ig|instagram|tg|telegram|wechat|微信|discord)\s*[:：@]\s*\S{3,}/iu, // 其他社群帳號
    /[@＠][a-z0-9._]{4,}/iu,                              // @帳號
];

// 全形英數轉半形，常見替代字還原（讓 f*ck、Ｆｕｃｋ、fu¢k 也比得到）
const LOOKALIKE = { '0': 'o', '1': 'i', '3': 'e', '4': 'a', '5': 's', '7': 't', '@': 'a', '$': 's', '¢': 'c' };

function toHalfWidth(text) {
    return String(text || '').replace(/[\uFF01-\uFF5E]/g, (ch) => String.fromCharCode(ch.charCodeAt(0) - 0xFEE0)).replace(/\u3000/g, ' ');
}

const IGNORED = /[\s\p{P}\p{S}_\u200B-\u200D\uFEFF]/gu;

const isLatin = (term) => /^[a-z ]+$/.test(term);
const SEP = '[\\s\\p{P}\\p{S}_\\u200B-\\u200D\\uFEFF]*';
const escapeRe = (ch) => ch.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

/**
 * 每個詞一個比對式：字與字之間容許夾空白或符號（拆字）。
 * 英文詞另外容許替代字（f*ck、5h1t），並要求整個單字（Dickens 不算 dick），但允許 -s/-ing/-ed 等字尾。
 */
const TERM_PATTERNS = BLOCKED_TERMS.map((term) => {
    const chars = [...term.replace(/\s/g, '')].map((ch) => {
        const alts = Object.keys(LOOKALIKE).filter((k) => LOOKALIKE[k] === ch).map(escapeRe);
        return alts.length ? `(?:${escapeRe(ch)}|${alts.join('|')})` : escapeRe(ch);
    });
    const body = chars.join(SEP);
    const source = isLatin(term) ? `(?<![a-z])${body}(?:s|es|ing|ed|er|ers|y)?(?![a-z])` : body;
    return new RegExp(source, 'giu');
});

/** 是否含有不當字詞（不含聯絡方式） */
function hasBlockedTerm(text) {
    const t = toHalfWidth(text).toLowerCase();
    return TERM_PATTERNS.some((re) => { re.lastIndex = 0; return re.test(t); });
}

/** 是否含有電話、網址、LINE 等聯絡方式 */
function hasContactInfo(text) {
    const t = toHalfWidth(text);
    return CONTACT_PATTERNS.some((re) => re.test(t));
}

/** 低語用：不當字詞或聯絡方式都算 */
function isDisallowed(text) {
    return hasBlockedTerm(text) || hasContactInfo(text);
}

/** 把不當字詞與聯絡方式替換成等長的「＊」；拆字（中間夾空白或符號）的情況整段替換 */
function maskBlockedTerms(text) {
    let out = toHalfWidth(text);
    for (const re of TERM_PATTERNS) {
        re.lastIndex = 0;
        out = out.replace(re, (m) => '＊'.repeat([...m.replace(IGNORED, '')].length || 1));
    }
    for (const re of CONTACT_PATTERNS) {
        out = out.replace(new RegExp(re.source, 'giu'), (m) => '＊'.repeat(Math.min([...m].length, 8)));
    }
    return out;
}

module.exports = { BLOCKED_TERMS, CONTACT_PATTERNS, hasBlockedTerm, hasContactInfo, isDisallowed, maskBlockedTerms };
