import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'chat_screen.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'login_screen.dart';
import 'whisper_engine.dart';
import 'city_cooling_system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'firebase_options.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

enum RequestStatus { none, pending, accepted }

Color _getMoodColor(String mood) {
  if (mood.isEmpty) return Colors.tealAccent; 
  if (mood.contains('😊') || mood.contains('開心') || mood.contains('笑')) return Colors.yellowAccent;
  if (mood.contains('😢') || mood.contains('難過') || mood.contains('哭')) return Colors.blueAccent;
  if (mood.contains('😡') || mood.contains('生氣') || mood.contains('怒')) return Colors.redAccent;
  if (mood.contains('🌿') || mood.contains('平靜') || mood.contains('發呆')) return Colors.greenAccent;
  if (mood.contains('🔥') || mood.contains('熱情')) return Colors.orangeAccent;
  if (mood.contains('💖') || mood.contains('愛') || mood.contains('心')) return Colors.pinkAccent;
  return Colors.tealAccent; 
}

const String _darkMapStyle = '''
[
  {"elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi", "stylers": [{"visibility": "off"}]},
  {"featureType": "transit", "stylers": [{"visibility": "off"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#2c2c2c"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#1e1e1e"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]},
  {"featureType": "landscape", "elementType": "geometry", "stylers": [{"color": "#121212"}]},
  {"featureType": "landscape.man_made", "elementType": "geometry", "stylers": [{"color": "#1a1a1a"}]}
]
''';

// 🌟 新增：這必須是一個全域 (頂層) 函式，不能寫在任何 Class 裡面
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 確保 Firebase 在背景也能初始化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("收到背景推播訊息: ${message.messageId}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🌟 新增：向 Firebase 註冊背景推播處理常式
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
      try {
        await mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
      } catch (e) {
        debugPrint('Android 最新渲染器初始化失敗: $e');
      }
    }
  }

  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // 🌟 測試除錯碼：強制抹除看過導覽頁的紀錄！
  // 加上這行後，每次啟動 App 都會回到全新未讀狀態。
  // (注意：等你確認導覽頁設計完畢、準備正式上線前，記得把這行刪掉或註解掉)
  await prefs.remove('has_seen_intro');

  // 讀取狀態 (因為上面已經強制定除，這裡一定會拿到 false)
  final bool hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;

  runApp(MoodWhisperApp(hasSeenIntro: hasSeenIntro));
}

class MoodWhisperApp extends StatelessWidget {
  final bool hasSeenIntro; // 🌟 接收判斷值

  const MoodWhisperApp({super.key, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '城市低語', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      // 🌟 邏輯判斷：沒看過就去 IntroScreen，看過了就去 LoginScreen
      home: hasSeenIntro ? const LoginScreen() : const IntroScreen(),
    );
  }
}

class BlankCanvasScreen extends StatefulWidget {
  final String uid;
  final String initialMood;

  const BlankCanvasScreen({super.key, required this.uid, required this.initialMood});

  @override
  State<BlankCanvasScreen> createState() => _BlankCanvasScreenState();
}

class _BlankCanvasScreenState extends State<BlankCanvasScreen> with WidgetsBindingObserver {
  Position? _currentPosition;
  GoogleMapController? _mapController; 
  
  final ValueNotifier<double> _headingNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _pitchNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);
  final ValueNotifier<List<Map<String, dynamic>>> _activeUsersNotifier = ValueNotifier([]);
  
  double _baseScale = 1.0; 

  Timer? _heartbeatTimer;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
  StreamSubscription<AccelerometerEvent>? _accelerometerStream;
  StreamSubscription<DatabaseEvent>? _incomingRequestsStream;
  StreamSubscription<DatabaseEvent>? _blockSubscription;
  StreamSubscription<DatabaseEvent>? _blockedBySubscription;

  final CityCoolingSystem _coolingSystem = CityCoolingSystem();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDialogShowing = false;

  Map<String, dynamic> _allRawUsersData = {};
  final Map<String, RequestStatus> _outgoingRequests = {};
  final Map<String, Timer> _pendingTimers = {}; 
  final Map<String, StreamSubscription<DatabaseEvent>> _requestSubscriptions = {}; 

  String? _currentKnockerUid;
  late String _myMood;
  String _myNickname = ''; 
  List<String> _blockedUids = [];      
  List<String> _blockedByUids = [];    

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    _myMood = widget.initialMood; 
    _loadProfileData(); 
    _listenToBlockLists(); 
    _audioPlayer.setSource(AssetSource('audio/knock.mp3'));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowReleaseNotes();
    });

    // 🌟 核心修正：將原本散落的初始化，改為「依序執行」，避免安卓權限彈窗衝突
    _startAppSetup();
  }

  // 🌟 新增：統一管理的非同步啟動流程
  Future<void> _startAppSetup() async {
    // 步驟 1：先請求推播通知權限，並等待使用者點擊完成
    await _initPushNotifications();

    // 步驟 2：推播對話框消失後，才呼叫定位權限詢問
    await _initSensors();

    // 步驟 3：確定定位成功載入後，才開啟網路連線與地圖監聽
    if (_currentPosition != null) {
      _initPresence(); 
      _listenToOtherUsers();
      _listenToIncomingRequests(); 
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMood = prefs.getString('saved_mood');
    final savedNickname = prefs.getString('saved_nickname') ?? ''; 
    if (mounted) {
      setState(() {
        if (savedMood != null) _myMood = savedMood;
        _myNickname = savedNickname;
      });
      if (_currentPosition != null) {
        _updateMyLocationToFirebase(_currentPosition!);
      }
    }
  }

  Future<void> _checkAndShowReleaseNotes() async {
    final prefs = await SharedPreferences.getInstance();
    const String currentVersion = '1.0.0'; 
    final String? lastSeenVersion = prefs.getString('last_seen_version');

    if (lastSeenVersion != currentVersion) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("🚀 城市低語 內部測試版", style: TextStyle(color: Colors.white70, fontSize: 18)),
              content: const Text(
                "歡迎來到城市低語 1.0.0 版本！\n\n"
                "• 導入暗黑極簡地圖風格\n"
                "• 支援手機仰角與 3D 建築連動\n"
                "• 修復 Android 雙指縮放與定位對齊\n"
                "• 建立完整敲門與交集雷達機制\n\n"
                "請盡情探索這座城市，並期待你的回饋！",
                style: TextStyle(color: Colors.white54, height: 1.5, fontSize: 14),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () async {
                    await prefs.setString('last_seen_version', currentVersion);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("我知道了", style: TextStyle(color: Colors.tealAccent, fontSize: 16)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _listenToBlockLists() {
    _blockSubscription = _dbRef.child('blocks/${widget.uid}').onValue.listen((event) {
      if (!mounted) return;
      final data = event.snapshot.value != null ? Map<String, dynamic>.from(event.snapshot.value as Map) : {};
      _blockedUids = List<String>.from(data.keys);
      _refreshActiveUsers(); 
    });
    _blockedBySubscription = _dbRef.child('blockedBy/${widget.uid}').onValue.listen((event) {
      if (!mounted) return;
      final data = event.snapshot.value != null ? Map<String, dynamic>.from(event.snapshot.value as Map) : {};
      _blockedByUids = List<String>.from(data.keys);
      _refreshActiveUsers(); 
    });
  }

  Future<void> _blockUser(String targetUid) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').set(true);
    await _dbRef.child('blockedBy/$targetUid/${widget.uid}').set(true);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('已將此人沒入黑暗。', style: TextStyle(color: Colors.white70)), backgroundColor: Colors.redAccent.withOpacity(0.2), duration: const Duration(seconds: 2)));
  }

  Future<void> _unblockUser(String targetUid) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').remove();
    await _dbRef.child('blockedBy/$targetUid/${widget.uid}').remove();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('已解除封鎖，城市再次產生交集。', style: TextStyle(color: Colors.white)), backgroundColor: Colors.greenAccent.withOpacity(0.2), duration: const Duration(seconds: 2)));
  }

  Future<void> _initPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // 1. 請求通知權限
    NotificationSettings settings = await messaging.requestPermission(
      alert: true, 
      badge: true, 
      sound: true,
    );
    
    if (Platform.isAndroid) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token;

      // 2. iOS 實機專屬：等待 APNs Token 簽發
      if (Platform.isIOS) {
        String? apnsToken;
        int retries = 0;
        // 等待系統回傳 APNs token（實機通常在 1~3 秒內簽發完成）
        while (apnsToken == null && retries < 15) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(milliseconds: 500));
            retries++;
          }
        }

        if (apnsToken != null) {
          debugPrint('🍏 成功取得 iOS APNs Token: $apnsToken');
        } else {
          debugPrint('⚠️ 尚未取得 APNs Token，請確認 Xcode Capability 與 Apple 開發者帳號推播支援');
        }
      }

      // 3. 取得 FCM Token 並存入 Realtime Database
      try {
        token = await messaging.getToken();
        if (token != null) {
          await _dbRef.child('tokens/${widget.uid}').set(token);
          debugPrint('✅ 成功取得並儲存 FCM Token: $token (UID: ${widget.uid})');
        }
      } catch (e) { 
        debugPrint('⚠️ 取得 FCM Token 失敗: $e'); 
      }
      
      // 4. Token 刷新監聽
      messaging.onTokenRefresh.listen((newToken) {
        _dbRef.child('tokens/${widget.uid}').set(newToken);
      });

      // 5. 前景訊息監聽
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${message.notification!.title}：${message.notification!.body}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.teal.withOpacity(0.9),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }
      });
    }
  }

  void _initPresence() {
    _dbRef.child('users/${widget.uid}').onDisconnect().remove();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (_currentPosition != null) {
        _dbRef.child('users/${widget.uid}/timestamp').set(DateTime.now().millisecondsSinceEpoch);
      }
    });
  }

  void _updateMapCamera() {
    if (_mapController != null && _currentPosition != null) {
      double tiltDegrees = (_pitchNotifier.value * 180 / pi).clamp(0.0, 65.0);
      double zoomLevel = 18.0 + (log(_scaleNotifier.value) / ln2);

      _mapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: zoomLevel,
            tilt: tiltDegrees, 
            bearing: _headingNotifier.value, 
          ),
        ),
      );
    }
  }

  Future<void> _initSensors() async {
    try {
      // 1. 檢查 GPS 服務是否啟用
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('請至手機設定開啟 GPS 定位服務，才能感知城市。'), backgroundColor: Colors.redAccent),
          );
        }
        return; 
      }
      
      // 2. 檢查並請求權限
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('需要定位權限才能與附近的人產生交集。'), backgroundColor: Colors.orange),
            );
          }
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('定位權限已被永久拒絕，請至系統設定中手動開啟。'), backgroundColor: Colors.redAccent),
          );
        }
        return;
      }
      
      // 3. 權限確定允許後，以安全模式獲取初始位置
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10), // 避免 iOS 實機過度等待
          );
          if (mounted) {
            setState(() => _currentPosition = position);
            _updateMyLocationToFirebase(position);
          }
        } catch (e) {
          debugPrint('⚠️ 取得單次定位異常 (可能處於室內或訊號微弱): $e');
        }
        
        // 🌟 核心修正：為 getPositionStream 加上 onError 攔截，防止 kCLErrorDomain 導致 App 閃退
        _positionStream?.cancel();
        _positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2),
        ).listen(
          (Position newPosition) {
            if (mounted) {
              setState(() => _currentPosition = newPosition);
              _updateMyLocationToFirebase(newPosition);
              _updateMapCamera(); 
            }
          },
          onError: (dynamic error) {
            // 🌟 捕捉 kCLErrorDomain error 1 等原生錯誤，避免程式崩潰
            debugPrint('⚠️ 定位流監聽異常 (已攔截，不影響 App 運行): $error');
          },
          cancelOnError: false,
        );
      }
    } catch (e) {
      debugPrint('❌ _initSensors 執行異常: $e');
    }

    // 啟動電子羅盤 (加上 try/catch 保護)
    try {
      _compassStream?.cancel();
      _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
        if (event.heading != null && mounted) {
          _headingNotifier.value = event.heading!;
          _updateMapCamera(); 
        }
      }, onError: (e) => debugPrint('⚠️ 電子羅盤監聽異常: $e'));
    } catch (e) {
      debugPrint('⚠️ 初始化電子羅盤失敗: $e');
    }

    // 啟動陀螺儀 (加上 try/catch 保護)
    try {
      _accelerometerStream?.cancel();
      _accelerometerStream = accelerometerEventStream().listen((AccelerometerEvent event) {
        double targetPitch = atan2(event.y, event.z).clamp(0.0, 80.0 * pi / 180.0);
        if (mounted) {
          _pitchNotifier.value += (targetPitch - _pitchNotifier.value) * 0.1;
          _updateMapCamera(); 
        }
      }, onError: (e) => debugPrint('⚠️ 陀螺儀監聽異常: $e'));
    } catch (e) {
      debugPrint('⚠️ 初始化陀螺儀失敗: $e');
    }
  }
  
  void _updateMyLocationToFirebase(Position position) {
    _dbRef.child('users/${widget.uid}').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'mood': _myMood,
      'nickname': _myNickname,
      'timestamp': DateTime.now().millisecondsSinceEpoch, 
    });
  }

  void _listenToOtherUsers() {
    _dbRef.child('users').onValue.listen((DatabaseEvent event) {
      _allRawUsersData = event.snapshot.value == null ? {} : Map<String, dynamic>.from(event.snapshot.value as Map);
      _refreshActiveUsers();
    });
  }

  void _refreshActiveUsers() {
    final List<Map<String, dynamic>> updatedUsers = [];
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    // 移除掃描附近的除錯日誌
    _allRawUsersData.forEach((key, value) {
      if (key == widget.uid) return;

      if (_blockedUids.contains(key) || _blockedByUids.contains(key)) return; 

      try {
        final userData = Map<String, dynamic>.from(value as Map);
        
        int lastActive = 0;
        if (userData['timestamp'] != null) {
          if (userData['timestamp'] is int) {
            lastActive = userData['timestamp'];
          } else if (userData['timestamp'] is double) {
            lastActive = (userData['timestamp'] as double).toInt();
          }
        }
        
        if (currentTime - lastActive > 300000) return;

        if (userData['latitude'] != null && userData['longitude'] != null) {
          double lat = (userData['latitude'] is int) ? (userData['latitude'] as int).toDouble() : userData['latitude'];
          double lng = (userData['longitude'] is int) ? (userData['longitude'] as int).toDouble() : userData['longitude'];

          updatedUsers.add({
            'uid': key,
            'lat': lat,
            'lng': lng,
            'mood': userData['mood'] ?? '無言中...',
            'nickname': userData['nickname'] ?? '',
          });
        }
      } catch (e) {
        debugPrint('解析用戶 $key 的資料時發生錯誤: $e'); // 保留真正的錯誤捕捉即可
      }
    });

    if (mounted) {
      _activeUsersNotifier.value = updatedUsers;

      final activeUids = updatedUsers.map((e) => e['uid']).toSet();
      _outgoingRequests.keys.toList().forEach((pendingTargetUid) {
        if (!activeUids.contains(pendingTargetUid) && _outgoingRequests[pendingTargetUid] == RequestStatus.pending) {
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').remove();
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').onDisconnect().cancel();
          _pendingTimers[pendingTargetUid]?.cancel();
          _requestSubscriptions[pendingTargetUid]?.cancel();
          
          setState(() => _outgoingRequests.remove(pendingTargetUid));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('對方已沒入城市，悄悄收回敲門聲...'), backgroundColor: Colors.white.withOpacity(0.1), duration: const Duration(seconds: 2)),
          );
        }
      });
    }
  }

  void _listenToIncomingRequests() {
    _incomingRequestsStream = _dbRef.child('requests/${widget.uid}').onValue.listen((event) async {
      final data = event.snapshot.value != null ? Map<String, dynamic>.from(event.snapshot.value as Map) : {};
      if (_isDialogShowing && _currentKnockerUid != null) {
        if (!data.containsKey(_currentKnockerUid) || data[_currentKnockerUid] != 'pending') {
          if (Navigator.canPop(context)) Navigator.pop(context);
          _isDialogShowing = false;
          _currentKnockerUid = null;
        }
      }
      data.forEach((senderUid, status) {
        if (_blockedUids.contains(senderUid) || _blockedByUids.contains(senderUid)) return;
        if (status == 'pending' && !_isDialogShowing) {
          _currentKnockerUid = senderUid;
          _triggerKnockAlert(senderUid);
        }
      });
    });
  }

  Future<void> _triggerKnockAlert(String senderUid) async {
    _isDialogShowing = true;
    await _audioPlayer.play(AssetSource('audio/knock.mp3'));
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) Vibration.vibrate(duration: 400);
    if (mounted) _showIncomingRequestUI(senderUid);
  }

  void _showIncomingRequestUI(String senderUid) {
    String senderName = '#${senderUid.substring(senderUid.length - 4).toUpperCase()}';
    try {
      final user = _activeUsersNotifier.value.firstWhere((u) => u['uid'] == senderUid);
      if (user['nickname'].toString().isNotEmpty) senderName = user['nickname'];
    } catch (_) {}

    showDialog(
      context: context, barrierDismissible: true, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('片刻交集', style: TextStyle(color: Colors.white70, fontSize: 18)),
          content: Text('$senderName 正在敲門，\n想與你產生交集...', style: const TextStyle(color: Colors.white54), textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(onPressed: () { Navigator.pop(dialogContext); _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').remove(); }, child: const Text('略過', style: TextStyle(color: Colors.white38))),
            TextButton(onPressed: () { Navigator.pop(dialogContext); _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').set('rejected'); }, child: const Text('婉拒', style: TextStyle(color: Colors.white54))),
            TextButton(onPressed: () { Navigator.pop(dialogContext); _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').set('accepted'); _navigateToChatScreen(senderUid, senderName); }, child: const Text('同意', style: TextStyle(color: Colors.orangeAccent))),
          ],
        );
      },
    ).then((_) {
      if (_isDialogShowing) { _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').remove(); }
    });
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1E1E1E), isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Wrap(
              children: [
                const Padding(padding: EdgeInsets.only(top: 20, bottom: 10), child: Center(child: Text('設定', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2)))),
                const Divider(color: Colors.white12),
                ListTile(leading: const Icon(Icons.person, color: Colors.white70), title: const Text('編輯個人狀態', style: TextStyle(color: Colors.white)), subtitle: const Text('設定你的暱稱與心情', style: TextStyle(color: Colors.white38, fontSize: 12)), onTap: () { Navigator.pop(context); _showProfileEditDialog(); }),
                ListTile(leading: const Icon(Icons.block, color: Colors.redAccent), title: const Text('管理封鎖名單', style: TextStyle(color: Colors.white)), subtitle: const Text('查看或解除被你沒入黑暗的人', style: TextStyle(color: Colors.white38, fontSize: 12)), onTap: () { Navigator.pop(context); _showBlockListDialog(); }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🌟 完善：編輯個人狀態對話框
  void _showProfileEditDialog() {
    final TextEditingController moodController = TextEditingController(text: _myMood);
    final TextEditingController nicknameController = TextEditingController(text: _myNickname);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
            child: Text(
              '編輯個人狀態',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 2),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('城市稱呼', style: TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 4),
                TextField(
                  controller: nicknameController,
                  style: const TextStyle(color: Colors.white),
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: '選填，例如：遊蕩的貓',
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                    counterStyle: const TextStyle(color: Colors.white24),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('當下心情', style: TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 4),
                TextField(
                  controller: moodController,
                  style: const TextStyle(color: Colors.tealAccent),
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: '例如：漫步在微雨中 🌿',
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                    counterStyle: const TextStyle(color: Colors.white24),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消', style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent.withOpacity(0.15),
                foregroundColor: Colors.tealAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () async {
                final String newMood = moodController.text.trim();
                final String newNickname = nicknameController.text.trim();

                if (newMood.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('心情不能為空，給城市留下點微光吧。'),
                      backgroundColor: Colors.white24,
                    ),
                  );
                  return;
                }

                setState(() {
                  _myMood = newMood;
                  _myNickname = newNickname;
                });

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('saved_mood', newMood);
                await prefs.setString('saved_nickname', newNickname);

                if (_currentPosition != null) {
                  _updateMyLocationToFirebase(_currentPosition!);
                }

                if (dialogContext.mounted) Navigator.pop(dialogContext);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('狀態已更新，城市正感知你的呼吸。'),
                      backgroundColor: Colors.teal,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('儲存'),
            ),
          ],
        );
      },
    );
  }

  // 🌟 完善：即時互動式封鎖名單對話框
  void _showBlockListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Center(
                child: Text(
                  '沉入黑暗的名單',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 2),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: _blockedUids.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.nights_stay_outlined, color: Colors.white24, size: 40),
                            SizedBox(height: 12),
                            Text(
                              '夜色清朗，你的城市未曾放逐任何人。',
                              style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.4),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _blockedUids.length,
                        separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                        itemBuilder: (context, index) {
                          final String blockedUid = _blockedUids[index];
                          final String shortId = blockedUid.length >= 4 
                              ? blockedUid.substring(blockedUid.length - 4).toUpperCase() 
                              : blockedUid.toUpperCase();

                          return FutureBuilder<DatabaseEvent>(
                            future: _dbRef.child('users/$blockedUid/nickname').once(),
                            builder: (context, snapshot) {
                              String displayName = '#$shortId';
                              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                                final nick = snapshot.data!.snapshot.value.toString().trim();
                                if (nick.isNotEmpty) displayName = '$nick (#$shortId)';
                              }

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                title: Text(displayName, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.tealAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () async {
                                    await _unblockUser(blockedUid);
                                    setDialogState(() {
                                      _blockedUids.remove(blockedUid);
                                    });
                                  },
                                  child: const Text('解除放逐', style: TextStyle(fontSize: 13)),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('關閉', style: TextStyle(color: Colors.white38)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showInteractionMenu(String targetUid, String displayName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(child: Text('與 $displayName 的相遇', style: const TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 2))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.white12),
              ListTile(leading: const Icon(Icons.waving_hand_rounded, color: Colors.orangeAccent), title: const Text('敲門 (產生交集)', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(dialogContext); _handleBubbleLongPress(targetUid); }),
              ListTile(leading: const Icon(Icons.block, color: Colors.redAccent), title: const Text('封鎖 (沒入黑暗)', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(dialogContext); _showBlockConfirmationDialog(targetUid, displayName); }),
            ],
          ),
        );
      },
    );
  }

  void _showBlockConfirmationDialog(String targetUid, String displayName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('確認封鎖', style: TextStyle(color: Colors.white70, fontSize: 16)),
          content: Text('確定要將 $displayName 沒入黑暗嗎？\n封鎖後，雙方將永遠從彼此的城市中消失。', style: const TextStyle(color: Colors.white54, fontSize: 14)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('取消', style: TextStyle(color: Colors.white38))),
            TextButton(onPressed: () { Navigator.pop(dialogContext); _blockUser(targetUid); }, child: const Text('確定封鎖', style: TextStyle(color: Colors.redAccent))),
          ],
        );
      },
    );
  }

  void _handleBubbleLongPress(String targetUid) {
    if (_outgoingRequests[targetUid] == RequestStatus.pending) return;
    bool canProceed = _coolingSystem.canKnock(targetUid, (blockMessage) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(blockMessage, style: const TextStyle(color: Colors.white70)), backgroundColor: Colors.white.withOpacity(0.1), duration: const Duration(seconds: 2))); });
    if (!canProceed) return;

    _outgoingRequests.forEach((uid, status) { if (status == RequestStatus.pending) _dbRef.child('requests/$uid/${widget.uid}').remove(); });
    setState(() => _outgoingRequests.clear());

    _coolingSystem.recordKnock();
    _coolingSystem.recordInteraction();
    setState(() => _outgoingRequests[targetUid] = RequestStatus.pending);

    _dbRef.child('requests/$targetUid/${widget.uid}').set('pending');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('敲門聲已送出，等待回音...'), backgroundColor: Colors.white.withOpacity(0.2), duration: const Duration(seconds: 3)));

    _pendingTimers[targetUid]?.cancel();
    _pendingTimers[targetUid] = Timer(const Duration(minutes: 5), () {
      if (_outgoingRequests[targetUid] == RequestStatus.pending) {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      }
    });

    _requestSubscriptions[targetUid]?.cancel(); 
    _requestSubscriptions[targetUid] = _dbRef.child('requests/$targetUid/${widget.uid}').onValue.listen((event) {
      final status = event.snapshot.value;
      if (status == 'accepted') {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        _pendingTimers[targetUid]?.cancel(); 
        if (mounted) {
          setState(() => _outgoingRequests.remove(targetUid));
          String targetName = '#${targetUid.substring(targetUid.length - 4).toUpperCase()}';
          try {
            final user = _activeUsersNotifier.value.firstWhere((u) => u['uid'] == targetUid);
            if (user['nickname'].toString().isNotEmpty) targetName = user['nickname'];
          } catch (_) {}
          _navigateToChatScreen(targetUid, targetName); 
        }
      } else if (status == 'rejected') {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        _pendingTimers[targetUid]?.cancel(); 
        _coolingSystem.recordRejection(targetUid); 
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      } else if (status == null) {
        _pendingTimers[targetUid]?.cancel();
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      }
    });
  }

  Future<void> _navigateToChatScreen(String targetUid, String targetName) async {
    if (!mounted) return;
    await Navigator.of(context).push(PageRouteBuilder(
      // 🌟 這裡新增 myUid: widget.uid，把自己的 UID 傳給聊天室
      pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(myUid: widget.uid, targetUid: targetUid, targetName: targetName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 800),
    ));
    _coolingSystem.recordChatEnd(targetUid);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) { _dbRef.child('users/${widget.uid}').onDisconnect().cancel(); } 
    else if (state == AppLifecycleState.resumed) {
      _dbRef.child('users/${widget.uid}').onDisconnect().remove();
      if (_currentPosition != null) _dbRef.child('users/${widget.uid}/timestamp').set(DateTime.now().millisecondsSinceEpoch);
    } 
    else if (state == AppLifecycleState.detached) { _dbRef.child('users/${widget.uid}').remove(); }
  }

  @override
  void dispose() {
    _positionStream?.cancel(); _compassStream?.cancel(); _accelerometerStream?.cancel();
    _incomingRequestsStream?.cancel(); _heartbeatTimer?.cancel();
    _blockSubscription?.cancel(); _blockedBySubscription?.cancel();
    _headingNotifier.dispose(); _pitchNotifier.dispose(); _scaleNotifier.dispose(); _activeUsersNotifier.dispose();
    _dbRef.child('users/${widget.uid}').remove(); _dbRef.child('users/${widget.uid}').onDisconnect().cancel(); 
    WidgetsBinding.instance.removeObserver(this); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) return const Scaffold(body: Center(child: Text("正在感知這座城市...", style: TextStyle(color: Colors.white54, letterSpacing: 2))));

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight * (2 / 3);
    double currentRhythmScore = _coolingSystem.getRhythmScore();

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (details) => _baseScale = _scaleNotifier.value,
        onScaleUpdate: (details) {
          _scaleNotifier.value = (_baseScale * details.scale).clamp(0.2, 5.0);
          _updateMapCamera();
        },
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: screenHeight / 3),
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 18.0, 
              ),
              mapType: MapType.normal,
              buildingsEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController!.setMapStyle(_darkMapStyle); 
                _updateMapCamera(); 
              },
              compassEnabled: false, myLocationEnabled: false, myLocationButtonEnabled: false, zoomControlsEnabled: false, scrollGesturesEnabled: false, rotateGesturesEnabled: false, tiltGesturesEnabled: false, zoomGesturesEnabled: false, 
            ),

            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([_pitchNotifier, _headingNotifier, _scaleNotifier, _activeUsersNotifier]),
                builder: (context, child) {
                  final smoothPitch = _pitchNotifier.value;
                  final currentHeading = _headingNotifier.value;
                  final currentScale = _scaleNotifier.value;
                  final activeUsers = _activeUsersNotifier.value;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: centerX - 150, top: centerY - 150,  
                        child: Transform(transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateX(smoothPitch), alignment: FractionalOffset.center, child: RadarRipple(moodColor: _getMoodColor(_myMood))),
                      ),

                      ...activeUsers.map((user) {
                        BubbleRenderData renderData = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, user['lat'], user['lng'], currentHeading, user['uid'], currentRhythmScore);
                        
                        if (renderData.opacity <= 0.0) return const SizedBox.shrink();

                        double zoomedDistance = (renderData.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6) * currentScale;
                        double angleRad = renderData.relativeAngle * pi / 180.0;
                        double rotX = zoomedDistance * sin(angleRad); double rotY = -zoomedDistance * cos(angleRad) * cos(smoothPitch); double rotZ = -zoomedDistance * cos(angleRad) * sin(smoothPitch);
                        double w = max(0.01, 1.0 + (rotZ * 0.002));
                        
                        String shortId = user['uid'].toString().substring(user['uid'].toString().length - 4).toUpperCase();
                        String displayName = user['nickname'].toString().isNotEmpty ? user['nickname'] : '#$shortId';

                        return Positioned(
                          left: (centerX + (rotX / w)) - 60, top: (centerY + (rotY / w)) - 60,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent, onLongPress: () => _showInteractionMenu(user['uid'], displayName),
                            child: Opacity(opacity: renderData.opacity, child: Transform.scale(scale: renderData.scale, child: _AnimatedBubbleUI(key: ValueKey(user['uid']), moodText: user['mood'], isFavored: renderData.isFavored, status: _outgoingRequests[user['uid']] ?? RequestStatus.none, displayName: displayName, distance: renderData.distance.toInt(), baseColor: _getMoodColor(user['mood'])))),
                          ),
                        );
                      }),
                      Positioned(
                        left: centerX - 10, top: centerY - 10, 
                        // 移除除錯專用的雙擊手勢，還原為純粹的視覺白點
                        child: Container(width: 20, height: 20, decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 10, spreadRadius: 5)])),
                      ),
                      Positioned(right: 20, bottom: 40, child: IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white54, size: 28), onPressed: _showSettingsPanel, tooltip: '設定')),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBubbleUI extends StatefulWidget {
  final String moodText; final bool isFavored; final RequestStatus status; final String displayName; final int distance; final Color baseColor; 
  const _AnimatedBubbleUI({super.key, required this.moodText, this.isFavored = false, required this.status, required this.displayName, required this.distance, required this.baseColor});
  @override State<_AnimatedBubbleUI> createState() => _AnimatedBubbleUIState();
}

class _AnimatedBubbleUIState extends State<_AnimatedBubbleUI> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _glowAnimation;
  @override void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.status == RequestStatus.pending) _controller.repeat(reverse: true);
  }
  @override void didUpdateWidget(covariant _AnimatedBubbleUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == RequestStatus.pending && oldWidget.status != RequestStatus.pending) _controller.repeat(reverse: true);
    else if (widget.status != RequestStatus.pending && oldWidget.status == RequestStatus.pending) { _controller.stop(); _controller.value = 0.0; }
  }
  @override void dispose() { _controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    bool isPending = widget.status == RequestStatus.pending;
    double glowValue = _glowAnimation.value;
    Color borderColor = isPending ? Colors.orangeAccent.withOpacity(0.3 + (0.4 * glowValue)) : (widget.isFavored ? widget.baseColor.withOpacity(0.5) : widget.baseColor.withOpacity(0.2));
    Color haloColor = isPending ? Colors.orangeAccent.withOpacity(0.1 + (0.2 * glowValue)) : widget.baseColor.withOpacity(0.1);
    IconData iconData = isPending ? Icons.send_rounded : Icons.person;
    Color iconColor = isPending ? Colors.orangeAccent.withOpacity(0.8) : widget.baseColor.withOpacity(0.6);

    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            painter: SpeechBubblePainter(color: widget.isFavored ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.08), borderColor: borderColor, haloColor: haloColor, haloSpread: 4.0 * glowValue),
            child: Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 14), child: Text(widget.moodText, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300))),
          ),
          const SizedBox(height: 2),
          Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: isPending ? haloColor : widget.baseColor.withOpacity(widget.isFavored ? 0.3 : 0.05), blurRadius: 10, spreadRadius: 2)]), child: Icon(iconData, color: iconColor, size: isPending ? 18 : 24)),
          const SizedBox(height: 6),
          Text('${widget.displayName} · ${widget.distance}m', style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color color; final Color borderColor; final Color haloColor; final double haloSpread;
  SpeechBubblePainter({required this.color, required this.borderColor, this.haloColor = Colors.transparent, this.haloSpread = 0.0});
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = borderColor..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height - 8.0), const Radius.circular(12.0)))
      ..moveTo(size.width / 2 - 6.0, size.height - 8.0)..lineTo(size.width / 2, size.height)..lineTo(size.width / 2 + 6.0, size.height - 8.0)..close();
    if (haloColor != Colors.transparent) {
      final glowPaint = Paint()..color = haloColor..style = PaintingStyle.stroke..strokeWidth = 4.0 + haloSpread..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 + haloSpread);
      canvas.drawPath(path, glowPaint);
    }
    canvas.drawPath(path, paint);
    if (borderColor != Colors.transparent) canvas.drawPath(path, borderPaint);
  }
  @override bool shouldRepaint(covariant SpeechBubblePainter oldDelegate) => true;
}

class RadarRipple extends StatefulWidget {
  final Color moodColor; 
  const RadarRipple({super.key, required this.moodColor});
  @override State<RadarRipple> createState() => _RadarRippleState();
}

class _RadarRippleState extends State<RadarRipple> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { return CustomPaint(size: const Size(300, 300), painter: RadarPainter(_controller, widget.moodColor)); }
}

class RadarPainter extends CustomPainter {
  final Animation<double> animation; final Color baseColor; 
  RadarPainter(this.animation, this.baseColor) : super(repaint: animation);
  @override void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); final maxRadius = size.width / 2;
    for (int i = 0; i < 3; i++) {
      double progress = (animation.value - (i * 0.33)) % 1.0;
      if (progress < 0) progress += 1.0;
      final radius = maxRadius * progress;
      final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.3; 
      final paint = Paint()..color = baseColor.withOpacity(opacity)..style = PaintingStyle.stroke..strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }
  }
  @override bool shouldRepaint(RadarPainter oldDelegate) => true;
}