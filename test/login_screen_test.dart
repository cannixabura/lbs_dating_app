import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/l10n/l10n.dart';
import 'package:lbs_dating_app/legal.dart';
import 'package:lbs_dating_app/login_screen.dart';
import 'package:lbs_dating_app/ui/night.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    locale: Locale('zh'),
    localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: LoginScreen(),
  ));
  await tester.pump(const Duration(milliseconds: 500)); // 讀取上次心情 + 自動聚焦的延遲
}

String moodFieldText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

// 打卡只由按鈕觸發（App Store 5.1.2），鍵盤的完成鍵只收起鍵盤
final enterButton = find.widgetWithText(NightButton, '在這裡打卡，走進城市');

bool enterButtonEnabled(WidgetTester tester) => tester.widget<NightButton>(enterButton).onPressed != null;

final consentRow = find.textContaining('零容忍');

void main() {
  testWidgets('first launch: mood field is empty', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true});
    await pumpLoginScreen(tester);
    expect(moodFieldText(tester), isEmpty);
  });

  testWidgets('returning user: mood field shows the last mood', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true, 'saved_mood': '喝了一杯好咖啡😊'});
    await pumpLoginScreen(tester);
    expect(moodFieldText(tester), '喝了一杯好咖啡😊');
  });

  testWidgets('empty mood cannot enter the city', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true, 'saved_mood': '下雨天', 'terms_accepted_version': Legal.termsVersion});
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(enterButton);
    await tester.pump();

    expect(find.text('請留下你此刻的心情，再沒入城市。'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('first launch: must agree to the terms before entering', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true});
    await pumpLoginScreen(tester);

    expect(consentRow, findsOneWidget);
    expect(enterButtonEnabled(tester), isFalse);

    await tester.tap(consentRow);
    await tester.pump();
    expect(enterButtonEnabled(tester), isTrue);
  });

  testWidgets('already agreed to this terms version: no checkbox, button enabled', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true, 'saved_mood': '下雨天', 'terms_accepted_version': Legal.termsVersion});
    await pumpLoginScreen(tester);

    expect(consentRow, findsNothing);
    expect(enterButtonEnabled(tester), isTrue);
  });

  testWidgets('terms updated since last agreement: asked again', (tester) async {
    SharedPreferences.setMockInitialValues({AgeGate.confirmedKey: true, 'saved_mood': '下雨天', 'terms_accepted_version': '2000-01'});
    await pumpLoginScreen(tester);

    expect(consentRow, findsOneWidget);
    expect(enterButtonEnabled(tester), isFalse);
  });

  testWidgets('first launch: asks the age question before the mood field', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLoginScreen(tester);
    expect(find.text('請問你已年滿 18 歲了嗎？'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('answering 18+ shows the mood field and remembers it', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLoginScreen(tester);
    await tester.tap(find.widgetWithText(NightButton, '已滿 18 歲'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(TextField), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getBool(AgeGate.confirmedKey), isTrue);
  });

  testWidgets('answering under 18 blocks the app and remembers it', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLoginScreen(tester);
    await tester.tap(find.widgetWithText(NightButton, '未滿 18 歲'));
    await tester.pumpAndSettle();
    expect(find.byType(AgeBlockedScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect((await SharedPreferences.getInstance()).getBool(AgeGate.blockedKey), isTrue);
  });
}
