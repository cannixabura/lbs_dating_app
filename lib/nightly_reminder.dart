import 'l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 每晚提醒：每天 21:30 一則溫和的通知，7 天文案輪替，可在設定中關閉。
/// 完全在手機端排程（不經伺服器、不需要精確鬧鐘權限），每次開啟 App 時重新排定未來 7 天。
class NightlyReminder {
  NightlyReminder._();

  static const _prefsKey = 'nightly_reminder_enabled';
  static const _hour = 21;
  static const _minute = 30;
  static const _baseId = 2100; // 2100–2106

  static List<String> get _lines => [
    tr.nightly1,
    tr.nightly2,
    tr.nightly3,
    tr.nightly4,
    tr.nightly5,
    tr.nightly6,
    tr.nightly7,
  ];

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? true; // 預設開啟
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    await reschedule();
  }

  static Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Taipei'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        // 通知權限已在推播初始化時請求過，這裡不再重複跳出
        iOS: DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false),
      ),
    );
    _ready = true;
  }

  /// 取消舊的排程，若開啟則重新排定接下來 7 個晚上。
  static Future<void> reschedule() async {
    try {
      await _init();
      for (var i = 0; i < _lines.length; i++) {
        await _plugin.cancel(id: _baseId + i);
      }
      if (!await isEnabled()) return;

      final now = tz.TZDateTime.now(tz.local);
      var first = tz.TZDateTime(tz.local, now.year, now.month, now.day, _hour, _minute);
      if (!first.isAfter(now)) first = first.add(const Duration(days: 1));

      for (var i = 0; i < _lines.length; i++) {
        final when = first.add(Duration(days: i));
        await _plugin.zonedSchedule(
          id: _baseId + i,
          scheduledDate: when,
          title: tr.appName,
          body: _lines[(when.day + i) % _lines.length],
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails('nightly_reminder', tr.nightlyChannel, channelDescription: tr.nightlyChannelDesc),
            // App 正開著時不跳橫幅，只收進通知中心
            iOS: DarwinNotificationDetails(presentBanner: false, presentList: true, presentSound: false),
          ),
        );
      }
    } catch (e) {
      debugPrint('nightly reminder schedule failed: $e');
    }
  }
}
