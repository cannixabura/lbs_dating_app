/// 定義請求的三種狀態
enum RequestStatus { 
  none,     // 尚未發出請求
  pending,  // 等待回應中 (10 分鐘內)
  accepted, // 對方已同意，準備進入聊天
  expired   // 已經超過 10 分鐘，請求消散
}

/// 單一交談請求的資料模型
class ChatRequest {
  final String targetUid;
  final DateTime sentTime;
  RequestStatus status;

  ChatRequest({
    required this.targetUid,
    required this.sentTime,
    this.status = RequestStatus.pending,
  });

  /// 檢查此請求是否已經超過 10 分鐘
  bool get isExpired {
    return DateTime.now().difference(sentTime).inMinutes >= 10;
  }
}

/// Mood Whisper 專屬：交談請求管理器
class ChatRequestManager {
  // 記錄目前本機發出的所有請求 (Key: 對方 UID, Value: 請求物件)
  final Map<String, ChatRequest> _outgoingRequests = {};

  /// 1. 觸發動作：長按氣泡，發出交談請求
  void sendRequest(String targetUid) {
    _outgoingRequests[targetUid] = ChatRequest(
      targetUid: targetUid,
      sentTime: DateTime.now(),
    );
  }

  /// 2. 狀態檢查：UI 渲染氣泡時，檢查該氣泡目前的請求狀態
  RequestStatus checkRequestStatus(String targetUid) {
    ChatRequest? request = _outgoingRequests[targetUid];
    
    if (request == null) return RequestStatus.none;
    
    // 如果還在等待中，且已經超時，自動轉為過期
    if (request.status == RequestStatus.pending && request.isExpired) {
      request.status = RequestStatus.expired;
      
      // 請求自然消散後，從記錄中移除，不留痕跡
      _outgoingRequests.remove(targetUid);
      return RequestStatus.none; 
    }
    
    return request.status;
  }

  /// 3. 接收訊號：對方同意了請求 (未來將由 Firebase 監聽觸發)
  void targetAccepted(String targetUid) {
    // 必須在請求清單內，且還沒超過 10 分鐘
    if (_outgoingRequests.containsKey(targetUid) && !_outgoingRequests[targetUid]!.isExpired) {
      _outgoingRequests[targetUid]!.status = RequestStatus.accepted;
    }
  }
  
  /// 4. 結束流程：成功進入聊天程序後，清除此請求紀錄
  void clearRequest(String targetUid) {
    _outgoingRequests.remove(targetUid);
  }
}