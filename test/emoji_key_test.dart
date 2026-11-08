import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/gathering_keys.dart';

// 必須和 geo-service/gathering.js 的 emojiKeysIn 結果完全相同（見 geo-service/gathering.test.js）
void main() {
  test('emoji keys match the server', () {
    expect(emojiKeysIn('遊行🏳️‍🌈小雨☔️'), {'1f3f3_200d_1f308', '2614'});
    expect(emojiKeysIn('❤️'), {'2764'});
    expect(emojiKeysIn('🇹🇼'), {'1f1f9_1f1fc'});
    expect(emojiKeysIn('1️⃣'), {'31_20e3'});
    expect(emojiKeysIn('👍🏽'), {'1f44d_1f3fd'});
    expect(emojiKeysIn('彩虹'), <String>{});
  });

  test('event icon must be exactly one emoji', () {
    expect(singleEmoji('🌈'), '🌈');
    expect(singleEmoji(' 🏳️‍🌈 '), '🏳️‍🌈');
    expect(singleEmoji('🌈🌈'), isNull);
    expect(singleEmoji('彩虹'), isNull);
  });
}
