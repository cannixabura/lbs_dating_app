import 'package:flutter_test/flutter_test.dart';
import 'package:lbs_dating_app/city_cooling_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? blockedMessage(CityCoolingSystem cooling, String uid) {
  String? message;
  final allowed = cooling.canKnock(uid, (m) => message = m);
  return allowed ? null : message;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('rejection cooldown escalates 5 min → 10 min → 24 h', () {
    final cooling = CityCoolingSystem();

    cooling.recordRejection('bob');
    expect(blockedMessage(cooling, 'bob'), '對方目前不想被打擾，請給彼此一點空間 (5 分鐘)。');

    cooling.recordRejection('bob');
    expect(blockedMessage(cooling, 'bob'), '對方目前不想被打擾，請給彼此一點空間 (10 分鐘)。');

    cooling.recordRejection('bob');
    expect(blockedMessage(cooling, 'bob'), '對方目前不想被打擾，請給彼此一點空間。');

    // 第 4 次以上仍是 24 小時
    cooling.recordRejection('bob');
    expect(blockedMessage(cooling, 'bob'), '對方目前不想被打擾，請給彼此一點空間。');
  });

  test('cooldown is per person', () {
    final cooling = CityCoolingSystem();
    cooling.recordRejection('bob');
    expect(blockedMessage(cooling, 'carol'), isNull);
  });

  test('24 h cooldown survives an app restart', () async {
    final cooling = CityCoolingSystem();
    for (var i = 0; i < 3; i++) {
      await cooling.recordRejection('bob');
    }

    final afterRestart = CityCoolingSystem();
    await afterRestart.loadRejections();
    expect(blockedMessage(afterRestart, 'bob'), '對方目前不想被打擾，請給彼此一點空間。');
  });

  test('a successful chat resets the rejection history', () async {
    final cooling = CityCoolingSystem();
    await cooling.recordRejection('bob');
    await cooling.recordChatEnd('bob');

    final afterRestart = CityCoolingSystem();
    await afterRestart.loadRejections();
    // 只剩聊天後的 1 分鐘冷卻，不再有婉拒冷卻
    expect(blockedMessage(afterRestart, 'bob'), isNull);
  });
}
