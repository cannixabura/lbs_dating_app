import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/content_filter.dart';

void main() {
  test('blocked terms match the server list', () {
    final js = File('geo-service/contentfilter.js').readAsStringSync();
    final block = js.substring(js.indexOf('const BLOCKED_TERMS = ['), js.indexOf('];', js.indexOf('const BLOCKED_TERMS = [')));
    final serverTerms = RegExp(r"'([^']*)'").allMatches(block).map((m) => m[1]).toList();
    expect(blockedTerms, serverTerms);
  });

  test('masks insults, split words, lookalikes and contacts', () {
    expect(maskBlockedTerms('你這個智障'), '你這個＊＊');
    expect(maskBlockedTerms('幹 你 娘'), '＊＊＊');
    expect(maskBlockedTerms('what the f*ck'), 'what the ＊＊＊');
    expect(maskBlockedTerms('Ｆｕｃｋ'), '＊＊＊＊');
    expect(maskBlockedTerms('打給我 0912-345-678'), contains('＊'));
    expect(maskBlockedTerms('加我 line: abc123'), contains('＊'));
  });

  test('leaves ordinary words alone', () {
    expect(maskBlockedTerms('今天好累，想喝杯熱茶'), '今天好累，想喝杯熱茶');
    expect(maskBlockedTerms('Dickens is great'), 'Dickens is great');
    expect(maskBlockedTerms('大麻煩了'), '大麻煩了');
  });
}
