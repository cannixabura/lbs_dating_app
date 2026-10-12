import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String targetUid;
  const ChatScreen({super.key, required this.targetUid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String _myUid;
  late String _roomId;
  late String _targetShortId;

  List<Map<dynamic, dynamic>> _messages = [];
  
  StreamSubscription<DatabaseEvent>? _messageSubscription;
  StreamSubscription<DatabaseEvent>? _statusSubscription;
  StreamSubscription<DatabaseEvent>? _typingSubscription; // 🌟 新增：監聽對方輸入狀態

  Timer? _inactivityTimer;
  Timer? _typingTimer; // 🌟 新增：控制自己輸入狀態的計時器

  bool _isClosing = false;
  bool _isTargetTyping = false; // 🌟 新增：對方是否正在輸入
  
  // 🌟 新增：用於平順退出動畫的狀態變數
  bool _showLeaveOverlay = false; 
  String _leaveMessage = '';

  @override
  void initState() {
    super.initState();
    _myUid = _auth.currentUser!.uid;
    _targetShortId = widget.targetUid.substring(widget.targetUid.length - 4).toUpperCase();
    _initRoom();
  }

  void _initRoom() {
    List<String> uids = [_myUid, widget.targetUid];
    uids.sort();
    _roomId = "${uids[0]}_${uids[1]}";

    // 設定房間狀態與斷線遺囑
    _dbRef.child('chats/$_roomId/status').set('active');
    _dbRef.child('chats/$_roomId').onDisconnect().remove();
    _dbRef.child('chats/$_roomId/typing/$_myUid').onDisconnect().remove(); // 🌟 斷線時也清除輸入狀態

    // 1. 監聽房間狀態 (處理對方離開或斷線)
    _statusSubscription = _dbRef.child('chats/$_roomId/status').onValue.listen((event) {
      if (!mounted || _isClosing) return;
      if (event.snapshot.value == 'ended' || event.snapshot.value == null) {
        _remoteLeave();
      }
    });

    // 2. 監聽訊息
    _messageSubscription = _dbRef.child('chats/$_roomId/messages').onChildAdded.listen((event) {
      if (!mounted) return;
      if (event.snapshot.value != null) {
        setState(() {
          _messages.add(event.snapshot.value as Map<dynamic, dynamic>);
        });
        _resetInactivityTimer();
        _scrollToBottom();
      }
    });

    // 🌟 3. 新增：監聽對方的輸入狀態
    _typingSubscription = _dbRef.child('chats/$_roomId/typing/${widget.targetUid}').onValue.listen((event) {
      if (!mounted) return;
      setState(() {
        _isTargetTyping = (event.snapshot.value == true);
      });
      if (_isTargetTyping) _scrollToBottom(); // 對方輸入時自動滾到底部
    });

    _resetInactivityTimer();
  }

  // 🌟 新增：監聽文字框變化，更新 Firebase 上的輸入狀態
  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      _dbRef.child('chats/$_roomId/typing/$_myUid').set(true);
      _typingTimer?.cancel();
      // 停止打字 2 秒後，自動視為不在輸入中
      _typingTimer = Timer(const Duration(seconds: 2), () {
        _dbRef.child('chats/$_roomId/typing/$_myUid').set(false);
      });
    } else {
      _dbRef.child('chats/$_roomId/typing/$_myUid').set(false);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final msgData = {
      'sender': _myUid,
      'text': _messageController.text.trim(),
      'timestamp': ServerValue.timestamp,
    };

    _dbRef.child('chats/$_roomId/messages').push().set(msgData);
    
    _messageController.clear();
    _dbRef.child('chats/$_roomId/typing/$_myUid').set(false); // 🌟 發送後立刻清除輸入狀態
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 3), () {
      if (mounted && !_isClosing) _manualLeave(); 
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 🌟 修改：對方離開時，播放 2 秒的優雅退場動畫再退出
  void _remoteLeave() {
    if (_isClosing) return;
    _isClosing = true;
    _cancelAllTimers();

    setState(() {
      _showLeaveOverlay = true;
      _leaveMessage = '對方已沒入城市...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  // 🌟 修改：自己主動離開時，播放平順退場動畫，並刪除房間
  void _manualLeave() {
    if (_isClosing) return;
    _isClosing = true;
    _cancelAllTimers();

    _dbRef.child('chats/$_roomId').onDisconnect().cancel();
    _dbRef.child('chats/$_roomId/status').set('ended');

    setState(() {
      _showLeaveOverlay = true;
      _leaveMessage = '交集已結束...';
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });

    Future.delayed(const Duration(seconds: 3), () {
      _dbRef.child('chats/$_roomId').remove();
    });
  }

  void _cancelAllTimers() {
    _inactivityTimer?.cancel();
    _typingTimer?.cancel();
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    _typingSubscription?.cancel();
  }

  @override
  void dispose() {
    _cancelAllTimers();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '與 #$_targetShortId 的交集',
          style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w300, letterSpacing: 2)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 20),
          onPressed: _manualLeave,
        ),
      ),
      // 🌟 核心修改：使用 Stack 疊加漸層退場動畫
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isMe = msg['sender'] == _myUid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          msg['text'],
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 🌟 新增：動態顯示「對方正在輸入中...」
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isTargetTyping ? 24.0 : 0.0,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24, bottom: 4),
                child: _isTargetTyping 
                  ? const Text('對方正在輸入中...', style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic)) 
                  : const SizedBox.shrink(),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: _onTextChanged, // 🌟 綁定輸入狀態監聽
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '輕聲說點什麼...',
                          hintStyle: const TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white70, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🌟 新增：優雅的離線漸層遮罩 (Graceful Exit Overlay)
          if (_showLeaveOverlay)
            AnimatedOpacity(
              opacity: _showLeaveOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Container(
                color: const Color(0xFF121212).withOpacity(0.95), // 近乎純黑的遮罩
                child: Center(
                  child: Text(
                    _leaveMessage,
                    style: const TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}