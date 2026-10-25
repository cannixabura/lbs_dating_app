import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 檢舉後立刻從自己的畫面移除的內容（App Store 1.2：使用者要能立即把內容從畫面上移除）。
/// 記在手機上，重開 App 也不會再出現；伺服器另外依檢舉門檻對所有人隱藏，並由人工在 24 小時內審查。
class HiddenContent extends ChangeNotifier {
  HiddenContent._();
  static final instance = HiddenContent._();

  static const _usersKey = 'hidden_users';
  static const _whispersKey = 'hidden_whispers';
  static const _announcementsKey = 'hidden_announcements';

  final Set<String> users = {};
  final Set<String> whispers = {};
  final Set<String> announcements = {}; // "<gid>:<announcementId>"

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    users.addAll(prefs.getStringList(_usersKey) ?? const []);
    whispers.addAll(prefs.getStringList(_whispersKey) ?? const []);
    announcements.addAll(prefs.getStringList(_announcementsKey) ?? const []);
    notifyListeners();
  }

  /// 依檢舉的對象隱藏：一般是使用者的 uid；低語是 "whisper:<id>"；集會公告是 "gathering:<gid>:<aid>"
  Future<void> hideReported(String target) async {
    if (target.startsWith('whisper:')) {
      whispers.add(target.substring(8));
    } else if (target.startsWith('gathering:')) {
      final parts = target.split(':');
      if (parts.length == 3) announcements.add('${parts[1]}:${parts[2]}');
    } else {
      users.add(target);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_usersKey, users.toList());
    await prefs.setStringList(_whispersKey, whispers.toList());
    await prefs.setStringList(_announcementsKey, announcements.toList());
  }

  bool isAnnouncementHidden(String gid, String? announcementId) => announcementId != null && announcements.contains('$gid:$announcementId');
}
