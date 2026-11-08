import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/mood_place.dart';

/// 台灣時間 → 真正的時刻（UTC）
DateTime tw(int y, int mo, int d, int h, [int mi = 0]) => DateTime.utc(y, mo, d, h, mi).subtract(const Duration(hours: 8));

MoodPlace place(Map<String, dynamic> hours, {List<String> closed = const []}) => MoodPlace.fromJson({
      'id': 't001', 'name': '測試', 'lat': 25.0, 'lng': 121.5, 'hours': hours, 'closed': closed, 'story': '',
    });

void main() {
  // 2026-10-27 是星期二、10-28 星期三、10-31 星期六、11-01 星期日
  group('營業時間（台灣時間）', () {
    final p = place({
      'tue': [['12:00', '22:00']],
      'wed': [['08:00', '11:00'], ['14:00', '20:30']],
      'sat': [['18:00', '26:00']],
    });

    test('一般時段：開始算營業、結束那一分鐘不算', () {
      expect(p.closingMinute(tw(2026, 10, 27, 11, 59)), isNull);
      expect(p.closingMinute(tw(2026, 10, 27, 12, 0)), 22 * 60);
      expect(p.closingMinute(tw(2026, 10, 27, 21, 59)), 22 * 60);
      expect(p.closingMinute(tw(2026, 10, 27, 22, 0)), isNull);
    });

    test('一天兩個時段，中間休息', () {
      expect(p.isOpen(tw(2026, 10, 28, 9)), isTrue);
      expect(p.isOpen(tw(2026, 10, 28, 12)), isFalse);
      expect(p.closingMinute(tw(2026, 10, 28, 20, 0)), 20 * 60 + 30);
    });

    test('跨午夜：星期六營業到隔天 02:00，星期日凌晨也算', () {
      expect(p.closingMinute(tw(2026, 10, 31, 23, 30)), 26 * 60);
      expect(p.closingMinute(tw(2026, 11, 1, 1, 59)), 2 * 60);
      expect(p.isOpen(tw(2026, 11, 1, 2, 0)), isFalse);
    });

    test('沒寫的日子不營業', () {
      expect(p.isOpen(tw(2026, 10, 26, 15)), isFalse); // 星期一
    });

    test('公休日：看時段開始的那一天', () {
      final c = place({'sat': [['18:00', '26:00']]}, closed: ['2026-10-31']);
      expect(c.isOpen(tw(2026, 10, 31, 20)), isFalse);
      expect(c.isOpen(tw(2026, 11, 1, 1)), isFalse);
      final c2 = place({'sat': [['18:00', '26:00']]}, closed: ['2026-11-01']);
      expect(c2.isOpen(tw(2026, 11, 1, 1)), isTrue);
    });

    test('跟手機時區無關：同一個時刻，用哪個時區表示結果都一樣', () {
      final instant = tw(2026, 10, 27, 13);
      expect(p.isOpen(instant.toLocal()), isTrue);
      expect(p.isOpen(instant.toUtc()), isTrue);
      expect(taiwanTime(DateTime.utc(2026, 10, 27, 20)).day, 28); // UTC 20:00 = 台灣隔天 04:00
    });
  });

  group('App 內提示頻率', () {
    final now = tw(2026, 10, 28, 20);
    int ms(DateTime d) => d.millisecondsSinceEpoch;

    test('沒提示過就可以', () {
      expect(PlaceHints.allowed({}, 'a', now), isTrue);
    });

    test('同一家店 7 天內只提示一次', () {
      expect(PlaceHints.allowed({'a': ms(now.subtract(const Duration(days: 6, hours: 23)))}, 'a', now), isFalse);
      expect(PlaceHints.allowed({'a': ms(now.subtract(const Duration(days: 7)))}, 'a', now), isTrue);
    });

    test('一天最多 2 次（所有店合計，以台灣日期計算）', () {
      final two = {'a': ms(tw(2026, 10, 28, 9)), 'b': ms(tw(2026, 10, 28, 18))};
      expect(PlaceHints.allowed(two, 'c', now), isFalse);
      final yesterday = {'a': ms(tw(2026, 10, 27, 23, 50)), 'b': ms(tw(2026, 10, 28, 0, 10))};
      expect(PlaceHints.allowed(yesterday, 'c', now), isTrue);
    });
  });

  group('App 內提示卡', () {
    Future<void> showHint(WidgetTester tester, VoidCallback onOpen) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (c) => Center(child: TextButton(onPressed: () => showPlaceHint(c, place(const {}), onOpen: onOpen), child: const Text('show')))),
      ));
      await tester.tap(find.text('show'));
      await tester.pump(const Duration(milliseconds: 600));
    }

    testWidgets('點提示卡會打開名片，提示卡同時關掉', (tester) async {
      var opened = 0;
      await showHint(tester, () => opened++);
      expect(find.textContaining('測試'), findsOneWidget);
      await tester.tap(find.textContaining('測試'));
      await tester.pump();
      expect(opened, 1);
      expect(find.textContaining('測試'), findsNothing);
    });

    testWidgets('約 6 秒後自動消失，不會打開名片', (tester) async {
      var opened = 0;
      await showHint(tester, () => opened++);
      await tester.pump(const Duration(seconds: 5));
      expect(find.textContaining('測試'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2)); // 計時從提示卡出現的那一個 frame 開始
      await tester.pump(); // 動畫結束後，下一個 frame 才移除
      expect(find.textContaining('測試'), findsNothing);
      expect(opened, 0);
    });
  });
}
