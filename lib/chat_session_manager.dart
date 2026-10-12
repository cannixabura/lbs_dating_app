import 'dart:async';

/// 對話消散事件的回呼定義
typedef OnChatDissolved = void Function(String message);

/// Mood Whisper 專屬：15 分鐘自然消散的聊天對話管理器
class ChatSessionManager {
  // --- 常數設定 ---
  // 為了方便開發測試，你可以暫時改為 Duration(seconds: 30) 來快速驗證
  static const Duration sessionTimeout = Duration(minutes: 1); 

  String? currentChatPartnerUid;
  Timer? _dissolveTimer;
  DateTime? _lastActivityTime;
  
  // 當聊天室消散時，通知前端 UI 的回呼函式
  OnChatDissolved? onChatDissolved;

  /// 1. 建立交集：開始一場新的對話
  void startSession(String partnerUid, {OnChatDissolved? onDissolved}) {
    currentChatPartnerUid = partnerUid;
    onChatDissolved = onDissolved;
    _lastActivityTime = DateTime.now();
    
    // 啟動倒數計時
    _startTimer();
  }

  /// 2. 延續交集：雙方有任何發言，就重新刷新 15 分鐘的生命週期
  void refreshSession() {
    if (currentChatPartnerUid == null) return;

    _lastActivityTime = DateTime.now();
    _startTimer(); // 取消舊計時器，啟動新計時器
  }

  /// 3. 鎖屏/離開觸發：當系統偵測到使用者鎖屏或退回背景，強制啟動倒數
  /// (實務上這可以透過 Flutter 的 AppLifecycleState 監聽來呼叫)
  void userLeftScreen() {
    // 概念上，離開螢幕並不直接切斷，而是確保計時器正在運作
    // 如果對方在 15 分鐘內沒有任何回應，就會自然消散
    _startTimer();
  }

  /// 啟動或重置計時器的內部方法
  void _startTimer() {
    // 取消之前可能正在運行的計時器
    _dissolveTimer?.cancel();

    // 重新設定 15 分鐘的倒數
    _dissolveTimer = Timer(sessionTimeout, _triggerDissolve);
  }

  /// 時間耗盡：對話自然消散
  void _triggerDissolve() {
    _dissolveTimer?.cancel();
    
    // 通知前端 UI 顯示告別語句
    if (onChatDissolved != null) {
      onChatDissolved!("你們各自回到城市裡了");
    }

    // 徹底清除本地狀態，不留痕跡
    _clearSessionData();
  }

  /// 4. 提早結束：如果使用者主動選擇離開
  void endSessionManually() {
    _dissolveTimer?.cancel();
    _clearSessionData();
  }

  /// 清除記憶體中的對話資料 (貫徹不留痕跡的原則)
  void _clearSessionData() {
    currentChatPartnerUid = null;
    _lastActivityTime = null;
    onChatDissolved = null;
  }
}