import 'package:shared_preferences/shared_preferences.dart';

class CityCoolingSystem {
  // 記錄各狀態的時間戳記與次數 (存於記憶體中)
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
  
  /// 2-1. 被婉拒冷卻 - 第一次 (5 分鐘)
  static const Duration rejectionCooldownTier1 = Duration(minutes: 5);
  
  /// 2-2. 被婉拒冷卻 - 第二次以上 (1 天)
  static const Duration rejectionCooldownTier2 = Duration(hours: 24);
  
  /// 3. 結束聊天後的專屬冷卻 (改為 1 分鐘)
  static const Duration postChatCooldown = Duration(minutes: 1);

  // ==========================================

  /// 檢查是否允許對特定用戶敲門
  bool canKnock(String targetUid, Function(String) onBlocked) {
    final now = DateTime.now();

    // 規則 A：全局防連點檢查
    if (_lastKnockTime != null && now.difference(_lastKnockTime!) < globalKnockCooldown) {
      onBlocked('敲門太頻繁，請感受一下城市的呼吸...');
      return false;
    }

    // 🌟 規則 B：漸進式婉拒冷卻檢查
    if (_rejectionTimes.containsKey(targetUid)) {
      // 取得被這個人拒絕的次數 (預設為 1)
      int currentRejectionCount = _rejectionCounts[targetUid] ?? 1;
      
      // 依據次數決定要套用的冷卻時間
      Duration requiredCooldown = currentRejectionCount >= 2 
          ? rejectionCooldownTier2 
          : rejectionCooldownTier1;
      
      if (now.difference(_rejectionTimes[targetUid]!) < requiredCooldown) {
        String timeHint = currentRejectionCount >= 2 ? '1 天' : '5 分鐘';
        onBlocked('對方目前不想被打擾，請給彼此一點空間 ($timeHint)。');
        return false;
      } else {
        // 冷卻時間已過，允許再次敲門，移除時間紀錄 (但不移除次數紀錄)
        _rejectionTimes.remove(targetUid);
      }
    }

    // 🌟 規則 C：結束交集冷卻檢查 (1 分鐘)
    if (_chatEndTimes.containsKey(targetUid)) {
      if (now.difference(_chatEndTimes[targetUid]!) < postChatCooldown) {
        onBlocked('你們才剛結束交集，讓回憶沉澱一下吧。');
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
  void recordRejection(String targetUid) {
    _rejectionTimes[targetUid] = DateTime.now();
    // 將該使用者的拒絕次數 + 1
    _rejectionCounts[targetUid] = (_rejectionCounts[targetUid] ?? 0) + 1;
  }

  /// 記錄結束聊天的對象與時間
  void recordChatEnd(String targetUid) {
    _chatEndTimes[targetUid] = DateTime.now();
    // 🌟 既然成功聊過天，就把之前的拒絕次數歸零，重新計算關係
    _rejectionCounts.remove(targetUid);
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