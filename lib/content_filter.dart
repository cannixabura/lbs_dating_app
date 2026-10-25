/// 聊天訊息的不當字詞過濾（App Store 1.2）。規則和伺服器的 geo-service/contentfilter.js 相同，
/// 兩邊的字詞清單由 test/content_filter_test.dart 比對，改一邊要同步改另一邊。
/// 訊息送出前先在手機上遮掉，伺服器收到後會再檢查一次（notifyOnChat）。

const blockedTerms = [
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

/// 聯絡方式：匿名社交最常見的詐騙與招攬入口
final _contactPatterns = [
  RegExp(r'09\d{2}[\s\-.]?\d{3}[\s\-.]?\d{3}', unicode: true),
  RegExp(r'\+?886[\s\-]?9\d{2}[\s\-.]?\d{3}[\s\-.]?\d{3}', unicode: true),
  RegExp(r'(https?:\/\/|www\.)\S+', caseSensitive: false, unicode: true),
  RegExp(r'\b[\w.-]+\.(com|net|org|tw|cc|me|io|xyz|top|link|app)\b', caseSensitive: false, unicode: true),
  RegExp(r'\bline\s*(id\s*)?[:：]\s*@?[a-z0-9._-]{3,}', caseSensitive: false, unicode: true),
  RegExp(r'\b(ig|instagram|tg|telegram|wechat|微信|discord)\s*[:：@]\s*\S{3,}', caseSensitive: false, unicode: true),
  RegExp(r'[@＠][a-z0-9._]{4,}', caseSensitive: false, unicode: true),
];

// 常見替代字還原（f*ck、5h1t）
const _lookalike = {'0': 'o', '1': 'i', '3': 'e', '4': 'a', '5': 's', '7': 't', '@': 'a', r'$': 's', '¢': 'c'};
const _sep = r'[\s\p{P}\p{S}_​-‍﻿]*';
final _ignored = RegExp(r'[\s\p{P}\p{S}_​-‍﻿]', unicode: true);

final _termPatterns = blockedTerms.map((term) {
  final chars = term.replaceAll(RegExp(r'\s'), '').runes.map((r) {
    final ch = String.fromCharCode(r);
    final alts = _lookalike.entries.where((e) => e.value == ch).map((e) => RegExp.escape(e.key)).toList();
    return alts.isEmpty ? RegExp.escape(ch) : '(?:${RegExp.escape(ch)}|${alts.join('|')})';
  });
  final body = chars.join(_sep);
  final latin = RegExp(r'^[a-z ]+$').hasMatch(term);
  final source = latin ? '(?<![a-z])$body(?:s|es|ing|ed|er|ers|y)?(?![a-z])' : body;
  return RegExp(source, caseSensitive: false, unicode: true);
}).toList();

/// 全形英數轉半形
String _toHalfWidth(String text) => String.fromCharCodes(text.runes.map((r) {
      if (r >= 0xFF01 && r <= 0xFF5E) return r - 0xFEE0;
      if (r == 0x3000) return 0x20;
      return r;
    }));

/// 把不當字詞與聯絡方式換成等長的「＊」；拆字（中間夾空白或符號）的情況整段替換。
/// 比對用轉成半形的文字，沒有命中的部分保留原文（全形標點不會被改掉）。
String maskBlockedTerms(String text) {
  // 半形轉換是一個字對一個字，位置不變，所以可以把命中的範圍套回原文
  var probe = _toHalfWidth(text);
  var out = text;
  void apply(RegExp re, String Function(String hit) mask) {
    final hits = re.allMatches(probe).toList().reversed;
    for (final m in hits) {
      final replacement = mask(m[0]!);
      probe = probe.replaceRange(m.start, m.end, replacement);
      out = out.replaceRange(m.start, m.end, replacement);
    }
  }

  for (final re in _termPatterns) {
    apply(re, (hit) {
      final n = hit.replaceAll(_ignored, '').runes.length;
      return '＊' * (n == 0 ? 1 : n);
    });
  }
  for (final re in _contactPatterns) {
    apply(re, (hit) => '＊' * (hit.runes.length < 8 ? hit.runes.length : 8));
  }
  return out;
}
