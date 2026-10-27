import 'l10n/l10n.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CityCoolingSystem {
  // 記錄各狀態的時間戳記與次數；婉拒紀錄另存於手機，重開 App 也不會重置
  DateTime? _lastKnockTime;
  final Map<String, DateTime> _rejectionTimes = {};
  final Map<String, int> _rejectionCounts = {}; // 🌟 新增：用來追蹤被同一個人拒絕的次數
  final Map<String, DateTime> _chatEndTimes = {};
  int _interactionCount = 0; 

  // ==========================================
  // 🌟 冷卻時間設定區 (依照你的最新機制)
  // ==========================================
  
  /// 1. 全局敲門冷卻 (防連點)
  static const Duration globalKnockCooldown = Duration(seconds: 3);
  
  /// 2. 被同一個人婉拒的漸進冷卻：第 1 次 5 分鐘、第 2 次 10 分鐘、第 3 次以上 24 小時
  static const List<Duration> rejectionCooldownTiers = [
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(hours: 24),
  ];
  static const String _rejectionPrefsKey = 'cooling_rejections';
  
  /// 3. 結束聊天後的專屬冷卻 (改為 1 分鐘)
  static const Duration postChatCooldown = Duration(minutes: 1);

  // ==========================================

  /// 檢查是否允許對特定用戶敲門
  bool canKnock(String targetUid, Function(String) onBlocked) {
    final now = DateTime.now();

    // 規則 A：全局防連點檢查
    if (_lastKnockTime != null && now.difference(_lastKnockTime!) < globalKnockCooldown) {
      onBlocked(tr.knockTooOften);
      return false;
    }

    // 🌟 規則 B：漸進式婉拒冷卻檢查
    if (_rejectionTimes.containsKey(targetUid)) {
      // 取得被這個人拒絕的次數 (預設為 1)，依次數決定冷卻時間，第 3 次以上都是 24 小時
      int currentRejectionCount = _rejectionCounts[targetUid] ?? 1;
      final int tier = (currentRejectionCount - 1).clamp(0, rejectionCooldownTiers.length - 1);
      Duration requiredCooldown = rejectionCooldownTiers[tier];
      
      if (now.difference(_rejectionTimes[targetUid]!) < requiredCooldown) {
        if (tier == rejectionCooldownTiers.length - 1) {
          onBlocked(tr.otherNotNow);
        } else {
          onBlocked(tr.otherNotNowMinutes(requiredCooldown.inMinutes));
        }
        return false;
      } else {
        // 冷卻時間已過，允許再次敲門，移除時間紀錄 (但不移除次數紀錄)
        _rejectionTimes.remove(targetUid);
      }
    }

    // 🌟 規則 C：結束交集冷卻檢查 (1 分鐘)
    if (_chatEndTimes.containsKey(targetUid)) {
      if (now.difference(_chatEndTimes[targetUid]!) < postChatCooldown) {
        onBlocked(tr.justEndedRest);
        return false;
      } else {
        _chatEndTimes.remove(targetUid); // 冷卻完畢，解鎖限制
      }
    }

    return true; // 所有檢查通過，允許敲門
  }

  /// 記錄敲門動作 (更新全局時間)
  void recordKnock() {
    _lastKnockTime = DateTime.now();
  }

  /// 🌟 記錄被婉拒的對象、時間與次數
  Future<void> recordRejection(String targetUid) {
    _rejectionTimes[targetUid] = DateTime.now();
    // 將該使用者的拒絕次數 + 1
    _rejectionCounts[targetUid] = (_rejectionCounts[targetUid] ?? 0) + 1;
    return _saveRejections();
  }

  /// 記錄結束聊天的對象與時間
  Future<void> recordChatEnd(String targetUid) {
    _chatEndTimes[targetUid] = DateTime.now();
    // 🌟 既然成功聊過天，就把之前的拒絕次數歸零，重新計算關係
    _rejectionCounts.remove(targetUid);
    _rejectionTimes.remove(targetUid);
    return _saveRejections();
  }

  /// App 啟動時載入婉拒紀錄（重開 App 不能用來繞過 24 小時冷卻）
  Future<void> loadRejections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_rejectionPrefsKey);
      if (raw == null) return;
      final Map<String, dynamic> data = jsonDecode(raw);
      data.forEach((uid, value) {
        _rejectionCounts[uid] = value['count'] as int;
        final int? at = value['at'] as int?;
        if (at != null) _rejectionTimes[uid] = DateTime.fromMillisecondsSinceEpoch(at);
      });
    } catch (_) {
      // 紀錄損毀時直接忽略，最壞情況只是冷卻被重置
    }
  }

  Future<void> _saveRejections() async {
    final Map<String, dynamic> data = {
      for (final uid in _rejectionCounts.keys)
        uid: {'count': _rejectionCounts[uid], 'at': _rejectionTimes[uid]?.millisecondsSinceEpoch},
    };
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_rejectionPrefsKey, jsonEncode(data));
    } catch (_) {}
  }

  /// 記錄整體互動頻率 (可用於視覺特效)
  void recordInteraction() {
    _interactionCount++;
  }

  /// 取得城市節奏分數 (回傳 0.0 ~ 1.0)
  double getRhythmScore() {
    // 依據互動次數計算活躍度，分數越高代表當下越活躍
    return (_interactionCount * 0.1).clamp(0.0, 1.0);
  }
}