import 'package:characters/characters.dart';

/// 集會的表情符號識別碼。規則必須和伺服器 geo-service/gathering.js 的 emojiKey 完全相同：
/// 以「肉眼看到的一個字」為單位，去掉變體選擇符 FE0F（❤️ 和 ❤ 視為同一個），其餘碼位以 "_" 相接。

final _emojiRe = RegExp(r'\p{Extended_Pictographic}|\p{Regional_Indicator}|⃣', unicode: true);

bool isEmojiGrapheme(String g) => _emojiRe.hasMatch(g);

String emojiKey(String grapheme) =>
    grapheme.runes.where((c) => c != 0xfe0f).map((c) => c.toRadixString(16)).join('_');

/// 稱呼裡出現的所有表情符號識別碼
Set<String> emojiKeysIn(String text) => text.characters.where(isEmojiGrapheme).map(emojiKey).toSet();

/// 剛好是一個表情符號就回傳它，否則回傳 null
String? singleEmoji(String raw) {
  final chars = raw.trim().characters;
  if (chars.length != 1 || !isEmojiGrapheme(chars.first)) return null;
  return chars.first;
}
