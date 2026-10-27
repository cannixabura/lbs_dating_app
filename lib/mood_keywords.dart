/// 心情文字 → 分類（joy、sad、angry、calm、passion、love，其餘 other）。
/// 關鍵字與 geo-service/mood_keywords.json 相同（城市心情天氣用同一套），先符合者優先。
/// 含拉丁字母的字詞要整個字相符、不分大小寫（避免 sad 比對到 Sadie）；中日韓文字只要出現就算。
const moodKeywords = <String, List<String>>{
  'joy': ['😊', '開心', '笑', '开心', 'happy', 'glad', 'joy', 'laugh', 'haha', 'うれしい', '嬉しい', '楽しい', '기쁨', '기뻐', '행복', '웃', 'gembira', 'seronok', 'ketawa', 'senang', 'bahagia', 'tertawa', 'vui', 'hạnh phúc', 'cười'],
  'sad': ['😢', '難過', '哭', '难过', 'sad', 'cry', 'crying', 'tears', 'かなしい', '悲しい', '泣', '슬픔', '슬퍼', '눈물', '울고', '울어', 'sedih', 'menangis', 'nangis', 'buồn', 'khóc'],
  'angry': ['😡', '生氣', '怒', '生气', 'angry', 'mad', 'furious', 'ムカつく', '腹立つ', '화남', '화나', '짜증', 'marah', 'geram', 'kesal', 'giận', 'tức'],
  'calm': ['🌿', '平靜', '發呆', '平静', '发呆', 'calm', 'chill', 'peaceful', 'relaxed', 'おだやか', '穏やか', '落ち着', 'ぼんやり', '평온', '편안', '멍때', 'tenang', 'santai', 'bình yên', 'thư giãn'],
  'passion': ['🔥', '熱情', '热情', 'fired up', 'excited', 'passion', 'hyped', '情熱', 'ワクワク', 'わくわく', '열정', '신나', '설레', 'bersemangat', 'teruja', 'semangat', 'nhiệt huyết', 'hào hứng'],
  'love': ['💖', '愛', '心', '爱', 'love', 'heart', '❤️', '好き', 'ハート', '사랑', 'cinta', 'sayang', 'yêu', 'thương'],
};

final _latin = RegExp(r'[A-Za-z\u00C0-\u024F\u1E00-\u1EFF]');

bool _matches(String mood, String word) {
  if (!_latin.hasMatch(word)) return mood.contains(word);
  return RegExp('(^|[^\\p{L}])${RegExp.escape(word)}(\$|[^\\p{L}])', unicode: true, caseSensitive: false).hasMatch(mood);
}

String moodKeyOf(String mood) {
  for (final e in moodKeywords.entries) {
    if (e.value.any((w) => _matches(mood, w))) return e.key;
  }
  return 'other';
}
