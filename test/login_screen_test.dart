import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  await tester.pump(const Duration(milliseconds: 500)); // 讀取上次心情 + 自動聚焦的延遲
}

String moodFieldText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

void main() {
  testWidgets('first launch: mood field is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLoginScreen(tester);
    expect(moodFieldText(tester), isEmpty);
  });

  testWidgets('returning user: mood field shows the last mood', (tester) async {
    SharedPreferences.setMockInitialValues({'saved_mood': '喝了一杯好咖啡😊'});
    await pumpLoginScreen(tester);
    expect(moodFieldText(tester), '喝了一杯好咖啡😊');
  });

  testWidgets('empty mood cannot enter the city', (tester) async {
    SharedPreferences.setMockInitialValues({'saved_mood': '下雨天'});
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('請留下你此刻的心情，再沒入城市。'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
