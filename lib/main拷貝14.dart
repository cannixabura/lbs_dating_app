import 'package:http/http.dart' as http;
import 'dart:convert';
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
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:ui' as ui; 

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

const String _darkStyleUrl = 'https://basemaps.cartocdn.com/gl/dark-matter-nolabels-gl-style/style.json';
const String _updateLocationUrl = 'https://us-central1-mood-whisper-f7de9.cloudfunctions.net/updateLocation';
const String _getNearbyUrl = 'https://us-central1-mood-whisper-f7de9.cloudfunctions.net/getNearby';

ui.FragmentProgram? bubbleShaderProgram;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('has_seen_intro');
  final bool hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;

  runApp(MoodWhisperApp(hasSeenIntro: hasSeenIntro));
}

class MoodWhisperApp extends StatelessWidget {
  final bool hasSeenIntro; 
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
  MapLibreMapController? _mapController; 
  
  final ValueNotifier<double> _headingNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _pitchNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);
  final ValueNotifier<List<Map<String, dynamic>>> _activeUsersNotifier = ValueNotifier([]);
  
  double _baseScale = 1.0; 

  Timer? _heartbeatTimer;
  Timer? _radarTimer;
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

  final Map<String, RequestStatus> _outgoingRequests = {};
  final Map<String, Timer> _pendingTimers = {}; 
  final Map<String, StreamSubscription<DatabaseEvent>> _requestSubscriptions = {}; 

  String? _currentKnockerUid;
  late String _myMood;
  String _myNickname = ''; 
  List<String> _blockedUids = [];      
  List<String> _blockedByUids = [];    
  Map<String, dynamic> _blockedUsersData = {}; // 🌟 新增：存放封鎖名單的快取資料

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

    _startAppSetup();
  }

  Future<void> _startAppSetup() async {
    try {
      bubbleShaderProgram = await ui.FragmentProgram.fromAsset('shaders/breathing_glow.frag');
    } catch (e) {}
    await _initPushNotifications();
    await _initSensors();
    if (_currentPosition != null) {
      _initPresence(); 
      _startRadarSweep();
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
        _updateMyLocationToServer(_currentPosition!);
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
                "• 導入 MapLibre 暗黑向量地圖\n"
                "• 支援手機仰角與 3D 建築連動\n"
                "• 引入 GLSL 呼吸光暈 Shader\n"
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
      
      // 🌟 修正：確保從 Firebase 收到的資料安全地轉換為 Map<String, dynamic>
      Map<String, dynamic> parsedData = {};
      if (event.snapshot.value != null) {
         // 使用 Map.from() 並不會改變內部元素的型別，我們用迴圈或 cast 來確保安全
         final rawMap = event.snapshot.value as Map;
         parsedData = rawMap.map((key, value) => MapEntry(key.toString(), value));
      }
      
      setState(() {
        _blockedUsersData = parsedData; // 🌟 這樣賦值就絕對安全了
        _blockedUids = List<String>.from(parsedData.keys);
      });
      _fetchNearbyUsers(); 
    });
    
    _blockedBySubscription = _dbRef.child('blockedBy/${widget.uid}').onValue.listen((event) {
      if (!mounted) return;
      
      Map<String, dynamic> parsedData = {};
      if (event.snapshot.value != null) {
         final rawMap = event.snapshot.value as Map;
         parsedData = rawMap.map((key, value) => MapEntry(key.toString(), value));
      }
      
      _blockedByUids = List<String>.from(parsedData.keys);
      _fetchNearbyUsers(); 
    });
  }

  // 🌟 核心修正：封鎖時，直接把對方的名字寫死進清單裡
  Future<void> _blockUser(String targetUid, String targetName) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').set(targetName); 
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
    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
    await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token;
      if (Platform.isIOS) {
        String? apnsToken; int retries = 0;
        while (apnsToken == null && retries < 15) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) { await Future.delayed(const Duration(milliseconds: 500)); retries++; }
        }
      }
      try {
        token = await messaging.getToken();
        if (token != null) await _dbRef.child('tokens/${widget.uid}').set(token);
      } catch (e) {}
      
      messaging.onTokenRefresh.listen((newToken) { _dbRef.child('tokens/${widget.uid}').set(newToken); });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${message.notification!.title}：${message.notification!.body}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.teal.withOpacity(0.9), duration: const Duration(seconds: 4), behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ));
        }
      });
    }
  }

  void _initPresence() {
    _dbRef.child('users/${widget.uid}').onDisconnect().remove();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (_currentPosition != null) _dbRef.child('users/${widget.uid}/timestamp').set(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void _updateMapCamera() {
    if (_mapController != null && _currentPosition != null) {
      double tiltDegrees = (_pitchNotifier.value * 180 / pi).clamp(0.0, 60.0); 
      double zoomLevel = 16.0 + (log(_scaleNotifier.value) / ln2);

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: zoomLevel,
            tilt: tiltDegrees, 
            bearing: _headingNotifier.value, 
          ),
        ),
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  void _onStyleLoaded() async {
    if (_mapController == null) return;
    try {
      await _mapController!.addFillExtrusionLayer(
        'carto', 
        '3d-buildings', 
        const FillExtrusionLayerProperties(
          fillExtrusionColor: '#1A1A1C', 
          fillExtrusionHeight: ['get', 'render_height'], 
          fillExtrusionBase: ['get', 'render_min_height'], 
          fillExtrusionOpacity: 0.65, 
        ),
        sourceLayer: 'building', 
      );
    } catch (e) {}
  }

  Future<void> _initSensors() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請至手機設定開啟 GPS 定位服務，才能感知城市。'), backgroundColor: Colors.redAccent));
        return; 
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('需要定位權限才能與附近的人產生交集。'), backgroundColor: Colors.orange));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('定位權限已被永久拒絕，請至系統設定中手動開啟。'), backgroundColor: Colors.redAccent));
        return;
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        try {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10));
          if (mounted) { setState(() => _currentPosition = position); _updateMyLocationToServer(position); }
        } catch (e) {}
        
        _positionStream?.cancel();
        _positionStream = Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2)).listen(
          (Position newPosition) {
            if (mounted) { setState(() => _currentPosition = newPosition); _updateMyLocationToServer(newPosition); _updateMapCamera(); }
          },
          onError: (dynamic error) {},
          cancelOnError: false,
        );
      }
    } catch (e) {}

    try {
      _compassStream?.cancel();
      _compassStream = FlutterCompass.events?.listen((CompassEvent event) {
        if (event.heading != null && mounted) { _headingNotifier.value = event.heading!; _updateMapCamera(); }
      }, onError: (e) {});
    } catch (e) {}

    try {
      _accelerometerStream?.cancel();
      _accelerometerStream = accelerometerEventStream().listen((AccelerometerEvent event) {
        double targetPitch = atan2(event.y, event.z).clamp(0.0, 80.0 * pi / 180.0);
        if (mounted) { _pitchNotifier.value += (targetPitch - _pitchNotifier.value) * 0.1; _updateMapCamera(); }
      }, onError: (e) {});
    } catch (e) {}
  }
  
  Future<void> _updateMyLocationToServer(Position position) async {
    try {
      await http.post(
        Uri.parse(_updateLocationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': widget.uid,
          'lat': position.latitude,
          'lng': position.longitude,
          'mood': _myMood,
          'nickname': _myNickname, 
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (e) {}
  }

  void _startRadarSweep() {
    _fetchNearbyUsers(); 
    _radarTimer?.cancel();
    _radarTimer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchNearbyUsers());
  }

  Future<void> _fetchNearbyUsers() async {
    if (_currentPosition == null) return;
    try {
      final response = await http.post(
        Uri.parse(_getNearbyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lat': _currentPosition!.latitude,
          'lng': _currentPosition!.longitude,
          'radiusKM': 5, 
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _processNearbyData(data['data'] as List);
        }
      }
    } catch (e) {}
  }

  void _processNearbyData(List rawData) {
    final List<Map<String, dynamic>> updatedUsers = [];
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    for (var user in rawData) {
      if (user['uid'] == widget.uid) continue;
      if (_blockedUids.contains(user['uid']) || _blockedByUids.contains(user['uid'])) continue;

      int lastActive = user['timestamp'] ?? 0;
      int timeDiff = currentTime - lastActive;

      if (timeDiff > 864000000) continue; 

      bool isShadow = false;
      double shadowOpacity = 1.0; 

      if (timeDiff > 300000) { 
        isShadow = true;
        if (timeDiff <= 7200000) {        
          shadowOpacity = 0.8;
        } else if (timeDiff <= 43200000) { 
          shadowOpacity = 0.6;
        } else if (timeDiff <= 172800000) { 
          shadowOpacity = 0.4;
        } else if (timeDiff <= 432000000) { 
          shadowOpacity = 0.2;
        } else {                            
          shadowOpacity = 0.1;
        }
      }

      updatedUsers.add({
        'uid': user['uid'],
        'lat': user['lat'],
        'lng': user['lng'],
        'mood': user['mood'] ?? '無言中...',
        'nickname': isShadow ? '' : (user['nickname'] ?? ''), 
        'isShadow': isShadow,
        'shadowOpacity': shadowOpacity, 
      });
    }

    if (mounted) {
      _activeUsersNotifier.value = updatedUsers;
      final activeUids = updatedUsers.map((e) => e['uid']).toSet();
      _outgoingRequests.keys.toList().forEach((pendingTargetUid) {
        if (!activeUids.contains(pendingTargetUid) && _outgoingRequests[pendingTargetUid] == RequestStatus.pending) {
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').remove();
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').onDisconnect().cancel();
          _pendingTimers[pendingTargetUid]?.cancel(); _requestSubscriptions[pendingTargetUid]?.cancel();
          setState(() => _outgoingRequests.remove(pendingTargetUid));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('對方已沒入城市，悄悄收回敲門聲...'), backgroundColor: Colors.white.withOpacity(0.1), duration: const Duration(seconds: 2)));
        }
      });
    }
  }

  void _listenToIncomingRequests() {
    _incomingRequestsStream = _dbRef.child('requests/${widget.uid}').onValue.listen((event) async {
      final data = event.snapshot.value != null ? Map<String, dynamic>.from(event.snapshot.value as Map) : {};
      
      if (_isDialogShowing && _currentKnockerUid != null) {
        final requestData = data[_currentKnockerUid];
        bool stillPending = false;
        if (requestData is Map && requestData['status'] == 'pending') stillPending = true;
        if (requestData == 'pending') stillPending = true;

        if (!stillPending) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          _isDialogShowing = false; _currentKnockerUid = null;
        }
      }

      data.forEach((senderUid, requestData) {
        if (_blockedUids.contains(senderUid) || _blockedByUids.contains(senderUid)) return;
        
        String status = '';
        String knockerName = '';

        // 🌟 核心修正：從接收到的 Payload 中直接解包出暱稱！
        if (requestData is Map) {
            status = requestData['status'] ?? '';
            knockerName = requestData['nickname'] ?? '';
        } else if (requestData is String) {
            status = requestData;
        }

        if (knockerName.isEmpty) {
            knockerName = '#${senderUid.substring(senderUid.length - 4).toUpperCase()}';
        }

        if (status == 'pending' && !_isDialogShowing) {
          _currentKnockerUid = senderUid;
          _triggerKnockAlert(senderUid, knockerName); // 直接傳送，無需二次查詢！
        }
      });
    });
  }

  Future<void> _triggerKnockAlert(String senderUid, String senderName) async {
    _isDialogShowing = true; 
    await _audioPlayer.play(AssetSource('audio/knock.mp3'));
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) Vibration.vibrate(duration: 400);

    if (mounted) _showIncomingRequestUI(senderUid, senderName);
  }

  void _showIncomingRequestUI(String senderUid, String senderName) {
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
            TextButton(onPressed: () { Navigator.pop(dialogContext); _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'rejected'}); }, child: const Text('婉拒', style: TextStyle(color: Colors.white54))),
            TextButton(onPressed: () { 
              Navigator.pop(dialogContext); 
              _isDialogShowing = false; 
              _currentKnockerUid = null; 
              // 🌟 核心修正：同意時，把自己的名字包進去送給對方！
              _dbRef.child('requests/${widget.uid}/$senderUid').set({
                'status': 'accepted',
                'nickname': _myNickname
              }); 
              _navigateToChatScreen(senderUid, senderName); 
            }, child: const Text('同意', style: TextStyle(color: Colors.orangeAccent))),
          ],
        );
      },
    ).then((_) { if (_isDialogShowing) { _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').remove(); } });
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

  void _showProfileEditDialog() {
    final TextEditingController moodController = TextEditingController(text: _myMood);
    final TextEditingController nicknameController = TextEditingController(text: _myNickname);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(child: Text('編輯個人狀態', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 2))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8), const Text('城市稱呼', style: TextStyle(color: Colors.white38, fontSize: 12)), const SizedBox(height: 4),
                TextField(controller: nicknameController, style: const TextStyle(color: Colors.white), maxLength: 10, decoration: const InputDecoration(hintText: '選填，例如：遊蕩的貓', hintStyle: TextStyle(color: Colors.white24, fontSize: 14), counterStyle: TextStyle(color: Colors.white24), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)))),
                const SizedBox(height: 16), const Text('當下心情', style: TextStyle(color: Colors.white38, fontSize: 12)), const SizedBox(height: 4),
                TextField(controller: moodController, style: const TextStyle(color: Colors.tealAccent), maxLength: 20, decoration: const InputDecoration(hintText: '例如：漫步在微雨中 🌿', hintStyle: TextStyle(color: Colors.white24, fontSize: 14), counterStyle: TextStyle(color: Colors.white24), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)))),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('取消', style: TextStyle(color: Colors.white38))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent.withOpacity(0.15), foregroundColor: Colors.tealAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              onPressed: () async {
                final String newMood = moodController.text.trim(); final String newNickname = nicknameController.text.trim();
                if (newMood.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('心情不能為空，給城市留下點微光吧。'), backgroundColor: Colors.white24)); return; }
                setState(() { _myMood = newMood; _myNickname = newNickname; });
                final prefs = await SharedPreferences.getInstance(); await prefs.setString('saved_mood', newMood); await prefs.setString('saved_nickname', newNickname);
                
                if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
                
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('狀態已更新，城市正感知你的呼吸。'), backgroundColor: Colors.teal, duration: Duration(seconds: 2)));
              },
              child: const Text('儲存'),
            ),
          ],
        );
      },
    );
  }

  void _showBlockListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Center(child: Text('沉入黑暗的名單', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 2))),
              content: SizedBox(
                width: double.maxFinite,
                child: _blockedUids.isEmpty
                    ? Padding(padding: const EdgeInsets.symmetric(vertical: 24.0), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.nights_stay_outlined, color: Colors.white24, size: 40), SizedBox(height: 12), Text('夜色清朗，你的城市未曾放逐任何人。', style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.4), textAlign: TextAlign.center)]))
                    : ListView.separated(
                        shrinkWrap: true, itemCount: _blockedUids.length, separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                        itemBuilder: (context, index) {
                          final String blockedUid = _blockedUids[index];
                          final val = _blockedUsersData[blockedUid];
                          
                          String displayName = '#${blockedUid.substring(blockedUid.length - 4).toUpperCase()}';
                          // 🌟 核心修正：直接讀取我們封鎖時存下的名字！瞬間顯示無延遲！
                          if (val is String && val.isNotEmpty) {
                              displayName = '$val ($displayName)';
                          }
                          
                          return ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 4), title: Text(displayName, style: const TextStyle(color: Colors.white70, fontSize: 14)), trailing: TextButton(style: TextButton.styleFrom(foregroundColor: Colors.tealAccent, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)), onPressed: () async { await _unblockUser(blockedUid); setDialogState(() { _blockedUids.remove(blockedUid); }); }, child: const Text('解除放逐', style: TextStyle(fontSize: 13))));
                        },
                      ),
              ),
              actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
              actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('關閉', style: TextStyle(color: Colors.white38)))],
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
              ListTile(leading: const Icon(Icons.waving_hand_rounded, color: Colors.orangeAccent), title: const Text('敲門 (產生交集)', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(dialogContext); _handleBubbleLongPress(targetUid, displayName); }),
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
            TextButton(onPressed: () { Navigator.pop(dialogContext); _blockUser(targetUid, displayName); }, child: const Text('確定封鎖', style: TextStyle(color: Colors.redAccent))),
          ],
        );
      },
    );
  }

  void _handleBubbleLongPress(String targetUid, String targetName) {
    if (_outgoingRequests[targetUid] == RequestStatus.pending) return;
    bool canProceed = _coolingSystem.canKnock(targetUid, (blockMessage) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(blockMessage, style: const TextStyle(color: Colors.white70)), backgroundColor: Colors.white.withOpacity(0.1), duration: const Duration(seconds: 2))); });
    if (!canProceed) return;

    _outgoingRequests.forEach((uid, status) { if (status == RequestStatus.pending) _dbRef.child('requests/$uid/${widget.uid}').remove(); });
    setState(() => _outgoingRequests.clear());

    _coolingSystem.recordKnock(); _coolingSystem.recordInteraction();
    setState(() => _outgoingRequests[targetUid] = RequestStatus.pending);

    // 🌟 核心修正：敲門時，把我的名字包裝成 Payload 直接發給對方！
    _dbRef.child('requests/$targetUid/${widget.uid}').set({
        'status': 'pending',
        'nickname': _myNickname
    });
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('敲門聲已送出，等待回音...'), backgroundColor: Colors.white.withOpacity(0.2), duration: const Duration(seconds: 3)));

    _pendingTimers[targetUid]?.cancel();
    _pendingTimers[targetUid] = Timer(const Duration(minutes: 5), () {
      if (_outgoingRequests[targetUid] == RequestStatus.pending) {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      }
    });

    _requestSubscriptions[targetUid]?.cancel(); 
    _requestSubscriptions[targetUid] = _dbRef.child('requests/$targetUid/${widget.uid}').onValue.listen((event) async {
      final requestData = event.snapshot.value;
      String status = '';
      String targetAcceptedName = targetName; 

      // 🌟 核心修正：接收對方同意時夾帶回來的名字
      if (requestData is Map) {
          status = requestData['status'] ?? '';
          if (requestData['nickname'] != null && requestData['nickname'].toString().isNotEmpty) {
              targetAcceptedName = requestData['nickname'];
          }
      } else if (requestData is String) {
          status = requestData;
      }

      if (status == 'accepted') {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); _pendingTimers[targetUid]?.cancel(); 
        if (mounted) {
          setState(() => _outgoingRequests.remove(targetUid));
          _navigateToChatScreen(targetUid, targetAcceptedName); // 將名字送入聊天室
        }
      } else if (status == 'rejected') {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); _pendingTimers[targetUid]?.cancel(); _coolingSystem.recordRejection(targetUid); 
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
      pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(myUid: widget.uid, targetUid: targetUid, targetName: targetName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child), transitionDuration: const Duration(milliseconds: 800),
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
    _incomingRequestsStream?.cancel(); _heartbeatTimer?.cancel(); _radarTimer?.cancel();
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
    final centerY = screenHeight / 2;
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
            MapLibreMap(
              onMapCreated: (controller) => _mapController = controller,
              onStyleLoadedCallback: _onStyleLoaded, 
              styleString: _darkStyleUrl,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 16.0,
              ),
              myLocationEnabled: true, 
              myLocationRenderMode: MyLocationRenderMode.normal,
              compassEnabled: false,
              logoViewMargins: const Point(-100, -100), 
              attributionButtonMargins: const Point(-100, -100), 
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
                        bool isShadow = user['isShadow'] ?? false; 

                        return Positioned(
                          left: (centerX + (rotX / w)) - 60, top: (centerY + (rotY / w)) - 60,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent, 
                            onLongPress: () {
                              if (isShadow) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('這只是一道歷史殘影，無法產生交集。'), backgroundColor: Colors.white24, duration: Duration(seconds: 2)));
                                return;
                              }
                              _showInteractionMenu(user['uid'], displayName);
                            },
                            child: Opacity(
                              opacity: renderData.opacity, 
                              child: Transform.scale(
                                scale: renderData.scale, 
                                child: _AnimatedBubbleUI(
                                  key: ValueKey(user['uid']), 
                                  moodText: user['mood'], 
                                  isFavored: renderData.isFavored, 
                                  status: _outgoingRequests[user['uid']] ?? RequestStatus.none, 
                                  displayName: displayName, 
                                  distance: renderData.distance.toInt(), 
                                  baseColor: _getMoodColor(user['mood']), 
                                  isShadow: isShadow,
                                  shadowOpacity: user['shadowOpacity'] ?? 1.0, 
                                )
                              )
                            ),
                          ),
                        );
                      }),
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
  final String moodText; 
  final bool isFavored; 
  final RequestStatus status; 
  final String displayName; 
  final int distance; 
  final Color baseColor; 
  final bool isShadow; 
  final double shadowOpacity; 

  const _AnimatedBubbleUI({
    super.key, 
    required this.moodText, 
    this.isFavored = false, 
    required this.status, 
    required this.displayName, 
    required this.distance, 
    required this.baseColor, 
    this.isShadow = false, 
    this.shadowOpacity = 1.0
  });

  @override 
  State<_AnimatedBubbleUI> createState() => _AnimatedBubbleUIState();
}

class _AnimatedBubbleUIState extends State<_AnimatedBubbleUI> with SingleTickerProviderStateMixin {
  AnimationController? _controller;  
  late Animation<double> _glowAnimation;

  @override 
  void initState() {
    super.initState();
    if (!widget.isShadow) {
      _controller = AnimationController(vsync: this);
      _setupAnimation();
    } else {
      _glowAnimation = const AlwaysStoppedAnimation(0.0);
    }
  }

  void _setupAnimation() {
    if (_controller == null) return;
    bool isPending = widget.status == RequestStatus.pending;
    
    if (isPending) {
      _controller!.duration = const Duration(milliseconds: 1200);
      _glowAnimation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 15), 
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4).chain(CurveTween(curve: Curves.easeInOut)), weight: 15),    
        TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 15), 
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 55),    
      ]).animate(_controller!);
      _controller!.repeat(); 
    } else {
      _controller!.duration = const Duration(milliseconds: 2000);
      _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
      _controller!.repeat(reverse: true); 
    }
  }

  @override 
  void didUpdateWidget(covariant _AnimatedBubbleUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isShadow && widget.status != oldWidget.status) {
      _setupAnimation();
    }
  }

  @override 
  void dispose() { 
    _controller?.dispose(); 
    super.dispose(); 
  }

  @override 
  Widget build(BuildContext context) {
    bool isPending = widget.status == RequestStatus.pending;
    IconData iconData = isPending ? Icons.send_rounded : Icons.person;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        double glowValue = _glowAnimation.value;
        
        Color borderColor = isPending ? Colors.orangeAccent.withOpacity(0.3 + (0.4 * glowValue)) : (widget.isFavored ? widget.baseColor.withOpacity(0.5) : widget.baseColor.withOpacity(0.2));
        Color haloColor = isPending ? Colors.orangeAccent.withOpacity(0.1 + (0.2 * glowValue)) : widget.baseColor.withOpacity(0.1);
        Color iconColor = isPending ? Colors.orangeAccent.withOpacity(0.8) : widget.baseColor.withOpacity(0.6);

        return Opacity(
          opacity: widget.isShadow ? widget.shadowOpacity : 1.0,
          child: SizedBox(
            width: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  painter: SpeechBubblePainter(
                    color: widget.isFavored ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.08), 
                    borderColor: borderColor, 
                    baseColor: widget.isShadow ? Colors.grey : widget.baseColor, 
                    glowValue: glowValue, 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 14), 
                    child: Text(widget.moodText, textAlign: TextAlign.center, style: TextStyle(color: widget.isShadow ? Colors.white54 : Colors.white, fontSize: 12, fontWeight: FontWeight.w300))
                  ),
                ),
                const SizedBox(height: 2),
                Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: isPending ? haloColor : widget.baseColor.withOpacity(widget.isFavored ? 0.3 : 0.05), blurRadius: 10, spreadRadius: 2)]), child: Icon(iconData, color: widget.isShadow ? Colors.grey.withOpacity(0.5) : iconColor, size: isPending ? 18 : 24)),
                const SizedBox(height: 6),
                Text('${widget.displayName} · ${widget.distance}m', style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color color; 
  final Color borderColor; 
  final Color baseColor;
  final double glowValue;

  SpeechBubblePainter({
    required this.color, 
    required this.borderColor, 
    required this.baseColor,
    required this.glowValue,
  });

  @override 
  void paint(Canvas canvas, Size size) {
    if (bubbleShaderProgram != null) {
      final shader = bubbleShaderProgram!.fragmentShader();
      double glowWidth = size.width * 2.5;
      double glowHeight = size.height * 2.5;
      
      shader.setFloat(0, glowWidth);
      shader.setFloat(1, glowHeight);
      shader.setFloat(2, glowValue); 
      shader.setFloat(3, baseColor.red / 255.0);
      shader.setFloat(4, baseColor.green / 255.0);
      shader.setFloat(5, baseColor.blue / 255.0);
      shader.setFloat(6, baseColor.opacity);

      final glowPaint = Paint()..shader = shader;
      
      canvas.save();
      canvas.translate(-(glowWidth - size.width) / 2, -(glowHeight - size.height) / 2);
      canvas.drawRect(Rect.fromLTWH(0, 0, glowWidth, glowHeight), glowPaint);
      canvas.restore();
    }

    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = borderColor..strokeWidth = 1.0..style = PaintingStyle.stroke;
    
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height - 8.0), const Radius.circular(12.0)))
      ..moveTo(size.width / 2 - 6.0, size.height - 8.0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 + 6.0, size.height - 8.0)
      ..close();
      
    canvas.drawPath(path, paint);
    if (borderColor != Colors.transparent) canvas.drawPath(path, borderPaint);
  }
  
  @override 
  bool shouldRepaint(covariant SpeechBubblePainter oldDelegate) => 
      oldDelegate.glowValue != glowValue || oldDelegate.baseColor != baseColor;
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