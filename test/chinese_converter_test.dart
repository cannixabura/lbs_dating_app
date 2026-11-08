import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/translate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('simplified Chinese becomes Taiwan traditional', () async {
    await ChineseConverter.load();
    expect(ChineseConverter.toTraditional('东京这边下雨了，你那边呢？'), '東京這邊下雨了，你那邊呢？');
    expect(ChineseConverter.toTraditional('头发'), '頭髮');
    expect(ChineseConverter.toTraditional('发现'), '發現');
    expect(ChineseConverter.toTraditional('这个软件很好用'), '這個軟體很好用');
    expect(ChineseConverter.toTraditional('Hello 台北'), 'Hello 台北');
  });
}
