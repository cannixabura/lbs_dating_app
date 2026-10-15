import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'report_sheet.dart';
import 'ui/night.dart';

class ChatScreen extends StatefulWidget {
  /// 目前開著的聊天室；來自同一聊天室的推播不再另外跳出提示（訊息已經在畫面上）
  static String? activeRoomId;

  final String myUid;
  final String myName; // 接收自己的名字，用於發送訊息時夾帶[cite: 6]
  final String targetUid;
  final String targetName; // 接收對方的名字，用於顯示在畫面上[cite: 6]

  const ChatScreen({
    super.key, 
    required this.myUid, 
    required this.myName, 
    required this.targetUid, 
    required this.targetName
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String _roomId;
  List<Map<dynamic, dynamic>> _messages = [];
  
  StreamSubscription<DatabaseEvent>? _messageSubscription;
  StreamSubscription<DatabaseEvent>? _statusSubscription;
  StreamSubscription<DatabaseEvent>? _typingSubscription; 
  late final Stream<DatabaseEvent> _targetAvatarStream = FirebaseDatabase.instance.ref('user_avatars/${widget.targetUid}').onValue;

  Timer? _countdownTimer;
  Timer? _typingTimer; 
  
  int _remainingSeconds = 600; 
  DateTime? _expireTime;

  bool _isClosing = false;
  bool _isTargetTyping = false; 
  
  bool _showLeaveOverlay = false; 
  String _leaveMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initRoom();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _dbRef.child('chats/$_roomId').onDisconnect().cancel();
      _dbRef.child('chats/$_roomId/typing/${widget.myUid}').onDisconnect().cancel();
    } else if (state == AppLifecycleState.resumed) {
      _dbRef.child('chats/$_roomId').onDisconnect().remove();
      _dbRef.child('chats/$_roomId/typing/${widget.myUid}').onDisconnect().remove();
    }
  }

  void _initRoom() {
    List<String> uids = [widget.myUid, widget.targetUid];
    uids.sort();
    _roomId = "${uids[0]}_${uids[1]}";
    ChatScreen.activeRoomId = _roomId;

    _dbRef.child('chats/$_roomId/status').set('active');
    
    _dbRef.child('chats/$_roomId').onDisconnect().remove();
    _dbRef.child('chats/$_roomId/typing/${widget.myUid}').onDisconnect().remove(); 

    _statusSubscription = _dbRef.child('chats/$_roomId/status').onValue.listen((event) {
      if (!mounted || _isClosing) return;
      if (event.snapshot.value == 'ended' || event.snapshot.value == null) {
        _remoteLeave();
      }
    });

    _messageSubscription = _dbRef.child('chats/$_roomId/messages').onChildAdded.listen((event) {
      if (!mounted) return;
      if (event.snapshot.value != null) {
        setState(() {
          _messages.add(event.snapshot.value as Map<dynamic, dynamic>);
        });
        _resetCountdownTimer(); 
        _scrollToBottom();
      }
    });

    _typingSubscription = _dbRef.child('chats/$_roomId/typing/${widget.targetUid}').onValue.listen((event) {
      if (!mounted) return;
      setState(() {
        _isTargetTyping = (event.snapshot.value == true);
      });
      if (_isTargetTyping) _scrollToBottom(); 
    });

    _resetCountdownTimer(); 
  }

  void _resetCountdownTimer() {
    _countdownTimer?.cancel();
    _expireTime = DateTime.now().add(const Duration(seconds: 600));

    setState(() {
      _remainingSeconds = 600; 
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isClosing || _expireTime == null) {
        timer.cancel();
        return;
      }
      
      final int secondsLeft = _expireTime!.difference(DateTime.now()).inSeconds;
      
      if (secondsLeft > 0) {
        setState(() {
          _remainingSeconds = secondsLeft;
        });
      } else {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
        _manualLeave(reason: '時間已盡，交集消散...');
      }
    });
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      _dbRef.child('chats/$_roomId/typing/${widget.myUid}').set(true);
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        _dbRef.child('chats/$_roomId/typing/${widget.myUid}').set(false);
      });
    } else {
      _dbRef.child('chats/$_roomId/typing/${widget.myUid}').set(false);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final msgData = {
      'sender': widget.myUid,
      'senderName': widget.myName, 
      'text': _messageController.text.trim(),
      'timestamp': ServerValue.timestamp,
    };

    _dbRef.child('chats/$_roomId/messages').push().set(msgData);
    
    _messageController.clear();
    _dbRef.child('chats/$_roomId/typing/${widget.myUid}').set(false); 
    _resetCountdownTimer(); 
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

  void _manualLeave({String reason = '交集已結束...'}) {
    if (_isClosing) return;
    _isClosing = true;
    _cancelAllTimers();

    _dbRef.child('chats/$_roomId').onDisconnect().cancel();
    _dbRef.child('chats/$_roomId/status').set('ended');

    setState(() {
      _showLeaveOverlay = true;
      _leaveMessage = reason;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });

    Future.delayed(const Duration(seconds: 3), () {
      _dbRef.child('chats/$_roomId').remove();
    });
  }

  Future<void> _report() async {
    final result = await showReportSheet(
      context,
      myUid: widget.myUid,
      targetUid: widget.targetUid,
      targetName: widget.targetName,
      reportContext: ReportContext.chat,
    );
    // 選擇同時封鎖時，立刻結束這場交集
    if (result != null && result.blocked && mounted) _manualLeave(reason: '已封鎖對方，交集結束。');
  }

  void _cancelAllTimers() {
    _countdownTimer?.cancel();
    _typingTimer?.cancel();
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    _typingSubscription?.cancel();
  }

  @override
  void dispose() {
    if (ChatScreen.activeRoomId == _roomId) ChatScreen.activeRoomId = null;
    WidgetsBinding.instance.removeObserver(this);
    _cancelAllTimers();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.targetName.startsWith('#') ? '匿名' : widget.targetName;

    String minutesStr = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final bool lastMinute = _remainingSeconds <= 60;

    return Scaffold(
      backgroundColor: Night.night800,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ---------- 玻璃標頭：返回、對方大頭貼與名字、倒數、檢舉 ----------
                Padding(
                  padding: const EdgeInsets.fromLTRB(Night.space2, Night.space2, Night.space2, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Night.space1, vertical: Night.space2),
                    decoration: BoxDecoration(
                      color: Night.glassFill,
                      borderRadius: BorderRadius.circular(Night.radiusLg),
                      border: Border.all(color: Night.glassLine),
                    ),
                    child: Row(children: [
                      IconButton(
                        tooltip: '離開對話',
                        icon: const Icon(Icons.arrow_back_ios_new, color: Night.inkMuted, size: 20),
                        onPressed: () => _manualLeave(),
                      ),
                      StreamBuilder<DatabaseEvent>(
                        stream: _targetAvatarStream,
                        builder: (context, snapshot) {
                          final url = snapshot.data?.snapshot.value?.toString() ?? '';
                          return Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Night.night700, border: Border.all(color: Night.auroraViolet, width: 1.5)),
                            child: ClipOval(
                              child: url.isNotEmpty
                                  ? Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person_outline, color: Night.inkMuted, size: 20))
                                  : const Icon(Icons.person_outline, color: Night.inkMuted, size: 20),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: Night.space3),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('與 $displayTitle 的交集', style: const TextStyle(color: Night.ink, fontSize: 15, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text.rich(TextSpan(style: Night.caption, children: [
                            const TextSpan(text: '倒數 '),
                            TextSpan(
                              text: '$minutesStr:$secondsStr',
                              style: TextStyle(color: lastMinute ? Night.danger : Night.knockPink, fontWeight: FontWeight.w600, fontFeatures: const [FontFeature.tabularFigures()]),
                            ),
                            const TextSpan(text: ' 消散'),
                          ])),
                        ]),
                      ),
                      IconButton(
                        tooltip: '檢舉',
                        icon: const Icon(Icons.flag_outlined, color: Night.inkMuted),
                        onPressed: _isClosing ? null : _report,
                      ),
                    ]),
                  ),
                ),

                // 示範對話：對方是自動回覆的示範對象，要讓使用者一眼知道
                if (widget.targetUid.startsWith('demo-'))
                  const Padding(
                    padding: EdgeInsets.fromLTRB(Night.space4, Night.space2, Night.space4, 0),
                    child: Text('示範對話：對方由程式自動回覆，不是真人。', style: Night.caption, textAlign: TextAlign.center),
                  ),

                // ---------- 訊息 ----------
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space3),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final bool isMe = msg['sender'] == widget.myUid;
                      // 同一人連續發言時，只在第一則上方顯示名字
                      final bool firstOfRun = index == 0 || _messages[index - 1]['sender'] != msg['sender'];

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (!isMe && firstOfRun)
                              Padding(
                                padding: const EdgeInsets.only(left: Night.space2, top: Night.space2, bottom: 2),
                                child: Text(widget.targetName, style: Night.caption),
                              ),
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isMe ? const LinearGradient(colors: [Night.deepViolet, Night.deepBlue], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                                color: isMe ? null : Night.night700,
                                border: isMe ? null : Border.all(color: Night.glassLine),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(Night.radiusMd),
                                  topRight: const Radius.circular(Night.radiusMd),
                                  bottomLeft: Radius.circular(isMe ? Night.radiusMd : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : Night.radiusMd),
                                ),
                              ),
                              child: Text(
                                msg['text'],
                                style: TextStyle(color: isMe ? Night.onDeep : Night.ink, fontSize: 15, height: 1.6),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isTargetTyping ? 24.0 : 0.0,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: Night.space6, bottom: 4),
                  child: _isTargetTyping 
                    ? const Text('對方正在輸入中…', style: TextStyle(color: Night.inkFaint, fontSize: 12, fontStyle: FontStyle.italic)) 
                    : const SizedBox.shrink(),
                ),

                // ---------- 輸入列 ----------
                Padding(
                  padding: const EdgeInsets.fromLTRB(Night.space4, Night.space2, Night.space4, Night.space4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onChanged: _onTextChanged, 
                          style: const TextStyle(color: Night.ink, fontSize: 15),
                          cursorColor: Night.auroraViolet,
                          maxLength: 1000,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: '輕聲說點什麼…',
                            hintStyle: const TextStyle(color: Night.inkFaint),
                            counterText: '',
                            filled: true,
                            fillColor: Night.night700,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Night.glassLine)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Night.auroraViolet, width: 1.5)),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: Night.space3),
                      Semantics(
                        button: true,
                        label: '送出',
                        child: GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 48, height: 48,
                            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Night.deepGradient, boxShadow: [Night.glowViolet]),
                            child: const Icon(Icons.send_rounded, color: Night.onDeep, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_showLeaveOverlay)
            AnimatedOpacity(
              opacity: _showLeaveOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Container(
                color: Night.night900.withOpacity(0.96), 
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.nights_stay_outlined, color: Night.inkFaint, size: 36),
                    const SizedBox(height: Night.space4),
                    Text(
                      _leaveMessage,
                      style: const TextStyle(color: Night.inkMuted, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w300),
                    ),
                  ]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
