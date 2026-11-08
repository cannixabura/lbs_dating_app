import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/mood_place.dart';
import 'package:lbs_dating_app/place_notes.dart';

final shop = MoodPlace.fromJson({'id': 't001', 'name': '測試', 'lat': 25.0485, 'lng': 121.5165, 'hours': const {}, 'story': ''});

void main() {
  test('距離：約 30 公尺、約 56 公尺', () {
    expect(metersBetween(25.0485, 121.5165, 25.0487, 121.5167), closeTo(30, 2));
    expect(metersBetween(25.0485, 121.5165, 25.0490, 121.5165), closeTo(56, 2));
  });

  // 不在店裡時只顯示說明，不會向伺服器要留言（測試環境沒有網路，有呼叫就會卡在讀取中）
  for (final (label, here) in [('沒有位置', null), ('在店外約 56 公尺', (lat: 25.0490, lng: 121.5165))]) {
    testWidgets('$label：留言本鎖著', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: PlaceGuestbook(place: shop, here: here, myUid: 'u1'))));
      expect(find.textContaining('40'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('留一句話'), findsNothing);
    });
  }
}
