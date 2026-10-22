import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // 🌟 新增：處理圖片上傳
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'chat_screen.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show rootBundle, HapticFeedback, MethodChannel, SystemNavigator;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'login_screen.dart';
import 'whisper_engine.dart';
import 'city_cooling_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:ui' show PlatformDispatcher;
import 'package:firebase_storage/firebase_storage.dart'; // 🌟 新增：雲端儲存
import 'package:image_picker/image_picker.dart'; // 🌟 新增：圖片選擇器
import 'dart:io' show Platform;
import 'firebase_options.dart';
import 'legal.dart';
import 'mood_card.dart';
import 'mood_trail.dart';
import 'gathering.dart';
import 'guide_screen.dart';
import 'whispers.dart';
import 'nightly_reminder.dart';
import 'report_sheet.dart';
import 'ui/knock_ritual.dart';
import 'ui/night.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:ui' as ui; 

enum RequestStatus { none, pending, accepted }

/// 定位無法使用的原因：服務關閉、未授權、永久拒絕、只給大概位置、抓不到位置
enum _LocationIssue { none, serviceOff, denied, deniedForever, reduced, noFix }

Color _getMoodColor(String mood) {
  if (mood.isEmpty) return Night.moodDefault;
  if (mood.contains('😊') || mood.contains('開心') || mood.contains('笑')) return Night.moodJoy;
  if (mood.contains('😢') || mood.contains('難過') || mood.contains('哭')) return Night.moodSad;
  if (mood.contains('😡') || mood.contains('生氣') || mood.contains('怒')) return Night.moodAngry;
  if (mood.contains('🌿') || mood.contains('平靜') || mood.contains('發呆')) return Night.moodCalm;
  if (mood.contains('🔥') || mood.contains('熱情')) return Night.moodPassion;
  if (mood.contains('💖') || mood.contains('愛') || mood.contains('心')) return Night.moodLove;
  return Night.moodDefault;
}

// 夜光地圖樣式：由 tool/build_night_map_style.py 從 dark-matter 重新上色、圖資用 OpenFreeMap，內建在 App 裡
const String _nightStyleAsset = 'assets/map/night_style.json';
const String _updateLocationUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/updateLocation';
const String _getNearbyUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/getNearby';
const String _deleteAccountUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/deleteAccount';
const String _cityMoodUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/getCityMood';

// 城市心情天氣的分類，與伺服器 geo-service/citymood.js 一致
const Map<String, (String, Color)> _cityMoodStyle = {
  'joy': ('開心', Night.moodJoy),
  'sad': ('難過', Night.moodSad),
  'angry': ('生氣', Night.moodAngry),
  'calm': ('平靜', Night.moodCalm),
  'passion': ('熱情', Night.moodPassion),
  'love': ('愛', Night.moodLove),
  'other': ('其他', Night.moodDefault),
};

ui.FragmentProgram? bubbleShaderProgram;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 當機回報：Flutter 與平台層未處理的錯誤都送到 Firebase Crashlytics（除錯模式不送）
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('has_seen_intro');
  final bool hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;
  final bool ageBlocked = prefs.getBool(AgeGate.blockedKey) ?? false;

  runApp(MoodWhisperApp(hasSeenIntro: hasSeenIntro, ageBlocked: ageBlocked));
}

class MoodWhisperApp extends StatelessWidget {
  final bool hasSeenIntro; 
  final bool ageBlocked; // 曾回答未滿 18 歲：之後每次開啟都只顯示說明頁
  const MoodWhisperApp({super.key, required this.hasSeenIntro, this.ageBlocked = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '城市低語', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Night.night900,
        useMaterial3: true,
      ),
      home: ageBlocked ? const AgeBlockedScreen() : (hasSeenIntro ? const LoginScreen() : const IntroScreen()),
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

class _BlankCanvasScreenState extends State<BlankCanvasScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  Position? _currentPosition;
  MapLibreMapController? _mapController; 
  
  final ValueNotifier<double> _headingNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _pitchNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);
  final ValueNotifier<List<Map<String, dynamic>>> _activeUsersNotifier = ValueNotifier([]);
  
  double _baseScale = 1.0; 

  Timer? _heartbeatTimer;
  Timer? _radarTimer;
  StreamSubscription<DatabaseEvent>? _connectionSubscription;
  bool _isInForeground = true;
  bool _locationServicesStarted = false;
  // 進場鏡頭：從城市高空俯衝到街道，期間暫停羅盤與仰角對鏡頭的更新
  bool _introFlying = true;
  late final AnimationController _introFade = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
  bool _hasScanned = false; // 至少完成過一次雷達掃描（決定是否顯示「你是今晚第一道光」）
  bool _emptyCardDismissed = false; // 使用者關掉了「你是今晚第一道光」卡片（本次開啟期間不再出現）
  _LocationIssue _locationIssue = _LocationIssue.none; // 定位無法使用時顯示說明頁，不能進入雷達
  bool _checkingLocation = false;

  // ---------- 敲門儀式：虛線弧、倒數條、粒子消散 ----------
  static const int _knockSeconds = 300;
  String? _ritualTarget;
  String _ritualTargetName = '';
  DateTime? _ritualStart;
  Timer? _knockTicker;
  final ValueNotifier<int> _knockSecondsLeft = ValueNotifier(_knockSeconds);
  late final AnimationController _arcFlow = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final AnimationController _dissolve = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
  Offset? _dissolveAt;
  final Map<String, Offset> _bubbleAnchors = {}; // 每顆氣泡在畫面上的位置（虛線弧的終點、粒子的起點）

  // ---------- 集會 ----------
  StreamSubscription<List<Gathering>>? _gatheringSub;
  List<Gathering> _gatherings = [];
  final Map<String, Gathering> _shownGatherings = {}; // 曾經出現在我雷達上的活動：結束時提示一聲

  /// 我正在主持的活動
  Gathering? get _hostedGathering {
    for (final g in _gatherings) { if (g.hostUid == widget.uid) return g; }
    return null;
  }

  /// 我參加中的活動：稱呼裡有圖標、在 5 公里內、沒有和主持人互相封鎖（最近的那場）
  Gathering? get _joinedGathering {
    final pos = _currentPosition;
    if (pos == null) return null;
    final joined = _gatherings.where((g) => g.hostUid != widget.uid && !_blockedUids.contains(g.hostUid) && !_blockedByUids.contains(g.hostUid) && g.includes(_myNickname, pos.latitude, pos.longitude)).toList()
      ..sort((a, b) => a.distanceKmFrom(pos.latitude, pos.longitude).compareTo(b.distanceKmFrom(pos.latitude, pos.longitude)));
    return joined.isEmpty ? null : joined.first;
  }

  void _listenToGatherings() {
    _gatheringSub?.cancel();
    _gatheringSub = activeGatherings().listen((list) {
      if (!mounted) return;
      final activeIds = list.map((g) => g.id).toSet();
      for (final ended in _shownGatherings.values.where((g) => !activeIds.contains(g.id)).toList()) {
        _shownGatherings.remove(ended.id);
        if (ended.hostUid != widget.uid) showGlassToast(context, '${ended.emoji} ${ended.name} 已結束', icon: Icons.nights_stay_outlined);
      }
      setState(() => _gatherings = list);
      for (final g in [_hostedGathering, _joinedGathering]) { if (g != null) _shownGatherings[g.id] = g; }
    }, onError: (e) => debugPrint('gatherings listen failed: $e'));
  }

  void _openGatheringHost() {
    final pos = _currentPosition;
    if (pos == null) return;
    showGatheringHostSheet(context, hosting: _hostedGathering, lat: pos.latitude, lng: pos.longitude);
  }

  // ---------- 氣泡疊層與群聚 ----------
  String? _expandedCluster; // 展開成花瓣的群聚（以群聚最上層那顆的 uid 識別）
  int _clusterPage = 0; // 超過一圈能放的數量時，「更多」花瓣輪到下一批
  String? _focusUid; // 剛按住或雙擊的氣泡，暫時浮到最上層
  Timer? _focusTimer;

  // ---------- 共鳴：送出 / 收到一道微光 ----------
  StreamSubscription<DatabaseEvent>? _resonanceSubscription;
  int _resonanceCount = -1; // 24 小時內收到的微光數；-1 = 尚未載入（第一次載入不跳提示）
  late final AnimationController _sparkle = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  Offset? _sparkleAt;
  Color _sparkleColor = Night.moodDefault;

  // ---------- 城市心情天氣 ----------
  Map<String, dynamic>? _cityMood;
  Timer? _cityMoodTimer;

  // ---------- 低語（城市漂流瓶） ----------
  List<Whisper> _whispers = [];
  final Set<String> _seenWhisperIds = {};
  bool _whispersLoaded = false;
  int _radarTick = 0;
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
  String? _mapStyle; // 夜光地圖樣式 JSON，載入完成前先顯示「正在感知這座城市」
  String _myNickname = ''; 
  String _myAvatarUrl = ''; // 🌟 儲存本機大頭貼網址

  List<String> _blockedUids = [];      
  List<String> _blockedByUids = [];    
  Map<String, dynamic> _blockedUsersData = {}; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    _myMood = widget.initialMood; 
    _loadProfileData(); 
    _coolingSystem.loadRejections();
    rootBundle.loadString(_nightStyleAsset).then((style) { if (mounted) setState(() => _mapStyle = style); });
    _listenToBlockLists(); 
    _audioPlayer.setSource(AssetSource('audio/knock.mp3'));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowReleaseNotes();
    });

    _startAppSetup();
  }

  Future<void> _startAppSetup() async {
    _ensureConsentRecorded();
    try {
      bubbleShaderProgram = await ui.FragmentProgram.fromAsset('shaders/breathing_glow.frag');
    } catch (e) {}
    await _initPushNotifications();
    NightlyReminder.reschedule(); // 每次進入城市重新排定未來 7 晚的提醒
    _listenToResonance();
    // 敲門監聽不需要定位，先啟動，避免定位較慢時漏接敲門
    _listenToIncomingRequests();
    await _initSensors();
    if (_currentPosition != null) _startLocationServices();
  }

  /// 條款同意紀錄：登入畫面寫入失敗時（網路不穩、剛登入的權杖還沒生效），進城後補寫一次。
  /// 審核或爭議時要能證明這個帳號同意過哪一版條款。
  Future<void> _ensureConsentRecorded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final version = prefs.getString('terms_accepted_version');
      if (version == null) return;
      final ref = _dbRef.child('consents/${widget.uid}');
      final existing = await ref.child('version').get();
      if (existing.value == version) return;
      await ref.set({'version': version, 'at': ServerValue.timestamp});
    } catch (e) {
      debugPrint('consent backfill failed: $e');
    }
  }

  // 取得第一個定位後才啟動在線狀態與雷達；首次定位逾時（>10 秒）時改由定位串流觸發
  void _startLocationServices() {
    if (_locationServicesStarted) return;
    _locationServicesStarted = true;
    _initPresence();
    _startRadarSweep();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMood = prefs.getString('saved_mood');
    final savedNickname = prefs.getString('saved_nickname') ?? ''; 
    final savedAvatar = prefs.getString('saved_avatar') ?? ''; 

    if (mounted) {
      setState(() {
        if (savedMood != null) _myMood = savedMood;
        _myNickname = savedNickname;
        _myAvatarUrl = savedAvatar;
      });
      
      if (_myNickname.isNotEmpty) {
        _dbRef.child('profiles/${widget.uid}/nickname').set(_myNickname);
      }
      // 🌟 將大頭貼寫入專屬廣播頻道，確保對方抓得到
      if (_myAvatarUrl.isNotEmpty) {
        _dbRef.child('user_avatars/${widget.uid}').set(_myAvatarUrl);
      }

      if (_currentPosition != null) {
        _updateMyLocationToServer(_currentPosition!);
      }
    }
  }

  Future<void> _checkAndShowReleaseNotes() async {
    final prefs = await SharedPreferences.getInstance();
    const String currentVersion = '1.1.0'; 
    final String? lastSeenVersion = prefs.getString('last_seen_version');

    if (lastSeenVersion != currentVersion) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, barrierColor: const Color(0x99070B1F),
          builder: (context) {
            Widget line(IconData icon, String text) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(icon, color: Night.auroraBlue, size: 18),
                    const SizedBox(width: Night.space3),
                    Expanded(child: Text(text, style: const TextStyle(color: Night.inkMuted, fontSize: 14, height: 1.5))),
                  ]),
                );
            return Dialog(
              backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
              child: GlassCard(
                glow: true,
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('城市低語 1.1 內部測試版', style: Night.title, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space2),
                  const Text('這座城市換上了夜色。', style: Night.body, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space4),
                  line(Icons.map_outlined, '全新夜光地圖：深藍街區、微光道路、霓虹建築'),
                  line(Icons.bubble_chart_outlined, '心情氣泡改為深色玻璃，在哪裡都看得清楚'),
                  line(Icons.nights_stay_outlined, '休息中與歷史殘影：鎖屏也能被敲門'),
                  line(Icons.flag_outlined, '檢舉與封鎖：讓城市保持安全'),
                  const SizedBox(height: Night.space4),
                  NightButton('我知道了', onPressed: () async {
                    await prefs.setString('last_seen_version', currentVersion);
                    if (context.mounted) Navigator.pop(context);
                  }),
                ]),
              ),
            );
          },
        );
      }
    }
  }

  void _listenToBlockLists() {
    _listenToGatherings();
    _blockSubscription = _dbRef.child('blocks/${widget.uid}').onValue.listen((event) {
      if (!mounted) return;
      
      Map<String, dynamic> parsedData = {};
      if (event.snapshot.value != null) {
        final rawMap = event.snapshot.value as Map;
        rawMap.forEach((key, value) {
          parsedData[key.toString()] = value;
        });
      }
      
      setState(() {
        _blockedUsersData = parsedData; 
        _blockedUids = parsedData.keys.toList();
      });
      _fetchNearbyUsers(); 
    });

    _blockedBySubscription = _dbRef.child('blockedBy/${widget.uid}').onValue.listen((event) {
      if (!mounted) return;
      
      Map<String, dynamic> parsedData = {};
      if (event.snapshot.value != null) {
        final rawMap = event.snapshot.value as Map;
        rawMap.forEach((key, value) {
          parsedData[key.toString()] = value;
        });
      }
      
      _blockedByUids = parsedData.keys.toList();
      _fetchNearbyUsers(); 
    });
  }

  Future<void> _blockUser(String targetUid, String targetName) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').set(targetName); 
    await _dbRef.child('blockedBy/$targetUid/${widget.uid}').set(true);
    if (mounted) showGlassToast(context, '已將此人沒入黑暗。', icon: Icons.block, danger: true);
  }

  Future<void> _unblockUser(String targetUid) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').remove();
    await _dbRef.child('blockedBy/$targetUid/${widget.uid}').remove();
    if (mounted) showGlassToast(context, '已解除封鎖，城市再次產生交集。', icon: Icons.nights_stay_outlined);
  }

  Future<void> _initPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
    // App 在前景時不顯示系統通知（與 Android 行為一致），改由下方 onMessage 的 App 內提示條處理
    await messaging.setForegroundNotificationPresentationOptions(alert: false, badge: false, sound: false);
    
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
        // 正在和這個人聊天時，訊息已經出現在聊天室裡，不再重複跳出提示
        if (message.data['type'] == 'chat_message' && message.data['roomId'] == ChatScreen.activeRoomId) return;
        if (message.notification != null && mounted) {
          showGlassToast(context, '${message.notification!.title}：${message.notification!.body}', icon: Icons.chat_bubble_outline);
        }
      });
    }
  }

  // ==========================================
  // 在線狀態：active(前景) / background(鎖屏、背景，可被敲門) / exited(結束 App → 殘影)
  // ==========================================
  DatabaseReference get _presenceRef => _dbRef.child('presence/${widget.uid}');

  Future<void> _setPresence(String state) async {
    try {
      final onDisconnect = _presenceRef.onDisconnect();
      if (state == 'active') {
        // 前景時連線中斷 = App 被結束（例如從 App 切換器滑掉），伺服器自動標記為已離開
        await onDisconnect.set({'state': 'exited', 'at': ServerValue.timestamp});
      } else {
        // 背景時系統遲早會切斷連線，那不代表離開，所以取消自動標記
        await onDisconnect.cancel();
      }
      await _presenceRef.set({'state': state, 'at': ServerValue.timestamp});
    } catch (e) {
      debugPrint('presence $state failed: $e');
    }
  }

  void _initPresence() {
    _setPresence('active');
    // 網路斷線重連後，重新登記在線（斷線時 onDisconnect 可能已標記為已離開）
    _connectionSubscription?.cancel();
    _connectionSubscription = _dbRef.child('.info/connected').onValue.skip(1).listen((event) {
      if (event.snapshot.value == true && _isInForeground) _setPresence('active');
    });
    _startForegroundHeartbeat();
  }

  // 前景心跳：即使沒有移動也每 60 秒回報一次，讓別人看到你是「活躍」而不是殘影
  void _startForegroundHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (_isInForeground && _currentPosition != null) _updateMyLocationToServer(_currentPosition!);
    });
  }

  void _updateMapCamera() {
    if (_introFlying) return;
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

  /// 進場鏡頭：從約 4 公里高空、正上方俯視，2.6 秒俯衝到街道並傾斜成 3D，夜光地圖同時從黑暗中亮起。
  /// 系統開啟「減少動態效果」時直接到位。
  Future<void> _playIntroFlight() async {
    if (_mapController == null || _currentPosition == null) return;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    _introFade.forward();
    final target = CameraPosition(
      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      zoom: 16.0, tilt: 50.0, bearing: _headingNotifier.value,
    );
    try {
      if (reduceMotion) {
        await _mapController!.moveCamera(CameraUpdate.newCameraPosition(target));
      } else {
        await _mapController!.animateCamera(CameraUpdate.newCameraPosition(target), duration: const Duration(milliseconds: 2600));
      }
    } catch (_) {}
    // 讓仰角從鏡頭的 50° 平順接回感測器
    _pitchNotifier.value = 50.0 * pi / 180.0;
    if (mounted) setState(() => _introFlying = false);
  }

  void _onStyleLoaded() async {
    if (_mapController == null) return;
    try {
      await _mapController!.addFillExtrusionLayer(
        'openmaptiles',
        '3d-buildings', 
        const FillExtrusionLayerProperties(
          // 夜色建築：以藍灰深藍為主，越高越亮，只有最高的建築帶一點淡紫
          fillExtrusionColor: [
            'interpolate', ['linear'], ['get', 'render_height'],
            0, '#181D44',
            20, '#22285A',
            60, '#2F3570',
            150, '#4A3F8C',
          ],
          fillExtrusionHeight: ['get', 'render_height'], 
          fillExtrusionBase: ['get', 'render_min_height'], 
          fillExtrusionOpacity: 0.72, 
        ),
        sourceLayer: 'building', 
      );
    } catch (e) {}
    _playIntroFlight();
  }

  Future<void> _initSensors() async {
    await _checkLocation();
    _startMotionSensors();
  }

  void _setLocationIssue(_LocationIssue issue) {
    if (mounted && _locationIssue != issue) setState(() => _locationIssue = issue);
  }

  /// 檢查定位：服務開啟、已授權、精確位置。任何一項不符合就顯示說明頁，不進入雷達。
  /// 從系統設定回到 App 時會再檢查一次（didChangeAppLifecycleState）。
  Future<void> _checkLocation() async {
    if (_checkingLocation) return;
    _checkingLocation = true;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return _setLocationIssue(_LocationIssue.serviceOff);
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return _setLocationIssue(_LocationIssue.deniedForever);
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return _setLocationIssue(_LocationIssue.denied);
      }
      // 精確位置：iOS 可以臨時要求一次；Android 再請求一次權限會出現「改成精確」的選項
      LocationAccuracyStatus accuracy = await Geolocator.getLocationAccuracy();
      if (accuracy == LocationAccuracyStatus.reduced) {
        try {
          if (Platform.isIOS) {
            accuracy = await Geolocator.requestTemporaryFullAccuracy(purposeKey: 'Radar');
          } else {
            await Geolocator.requestPermission();
            accuracy = await Geolocator.getLocationAccuracy();
          }
        } catch (e) {
          debugPrint('full accuracy request failed: $e');
        }
      }
      if (accuracy == LocationAccuracyStatus.reduced) return _setLocationIssue(_LocationIssue.reduced);
      if (_locationIssue != _LocationIssue.noFix) _setLocationIssue(_LocationIssue.none);
      _startPositionUpdates();
    } catch (e) {
      debugPrint('location check failed: $e');
    } finally {
      _checkingLocation = false;
    }
  }

  void _startPositionUpdates() {
    _positionStream ??= Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2)).listen(
      (Position newPosition) {
        if (!mounted) return;
        setState(() {
          _currentPosition = newPosition;
          if (_locationIssue == _LocationIssue.noFix) _locationIssue = _LocationIssue.none;
        });
        _updateMyLocationToServer(newPosition);
        _updateMapCamera();
        _startLocationServices();
      },
      onError: (dynamic error) => debugPrint('position stream error: $error'),
      cancelOnError: false,
    );
    if (_currentPosition != null) return;
    // 第一個定位：10 秒內拿不到就說明原因（室內訊號弱；模擬器沒有設定位置），而不是一直停在載入畫面
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10)).then((position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        if (_locationIssue == _LocationIssue.noFix) _locationIssue = _LocationIssue.none;
      });
      _updateMyLocationToServer(position);
      _startLocationServices();
    }).catchError((Object e) {
      debugPrint('initial position failed: $e');
      if (mounted && _currentPosition == null) _setLocationIssue(_LocationIssue.noFix);
    });
  }

  void _startMotionSensors() {
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

  /// 定位無法使用時的說明頁（取代雷達）
  Widget _buildLocationBlocker() {
    final issue = _locationIssue;
    final (IconData icon, String title, String body) = switch (issue) {
      _LocationIssue.serviceOff => (Icons.location_off_outlined, '請開啟定位服務', '城市低語需要知道你在城市的哪個角落，才能讓附近的人看見你的心情。請到手機的「設定」開啟「定位服務」。'),
      _LocationIssue.reduced => (Icons.my_location, '請開啟「精確位置」',
          Platform.isIOS ? '你目前只分享了大概的位置，雷達無法判斷誰在你附近。請到「設定」›「城市低語」›「位置」，打開「精確位置」。'
                         : '你目前只分享了大概的位置，雷達無法判斷誰在你附近。請在位置權限中選擇「精確」。'),
      _LocationIssue.noFix => (Icons.gps_not_fixed, '暫時抓不到你的位置', '可能在室內或訊號較弱。請到窗邊或戶外、開啟 Wi-Fi 後再試一次。'),
      _ => (Icons.location_off_outlined, '需要使用你的位置',
          '城市低語只在你使用 App 時取得位置，用來顯示附近 5 公里內的心情；雷達上只顯示大概的距離，不會顯示地址。\n請在設定中允許「使用 App 期間」取用位置，並開啟「精確位置」。'),
    };
    final bool needsSettings = issue != _LocationIssue.noFix;
    return Scaffold(
      backgroundColor: Night.night900,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Night.space6),
            child: GlassCard(
              glow: true,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Icon(icon, color: Night.auroraBlue, size: 44),
                const SizedBox(height: Night.space3),
                Text(title, style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space3),
                Text(body, style: Night.body, textAlign: TextAlign.center),
                if (kDebugMode && issue == _LocationIssue.noFix) ...[
                  const SizedBox(height: Night.space2),
                  const Text('（開發提示：模擬器請在 Features › Location 選一個位置）', style: Night.caption, textAlign: TextAlign.center),
                ],
                const SizedBox(height: Night.space6),
                if (needsSettings)
                  NightButton('前往設定', icon: Icons.settings_outlined, expand: true, onPressed: () {
                    issue == _LocationIssue.serviceOff ? Geolocator.openLocationSettings() : Geolocator.openAppSettings();
                  }),
                if (needsSettings) const SizedBox(height: Night.space2),
                NightButton(needsSettings ? '我已開啟，重新檢查' : '再試一次', kind: needsSettings ? NightButtonKind.ghost : NightButtonKind.primary,
                    icon: Icons.refresh, expand: true, onPressed: () {
                  if (issue == _LocationIssue.noFix) _setLocationIssue(_LocationIssue.none);
                  _checkLocation();
                }),
                if (Platform.isAndroid) ...[
                  const SizedBox(height: Night.space2),
                  NightButton('離開', kind: NightButtonKind.text, expand: true, onPressed: () => SystemNavigator.pop()),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // 🔐 呼叫 geo-service 時附上 Firebase ID Token，伺服器據此辨識身分
  Future<Map<String, String>> _authHeaders() async {
    final String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (idToken != null) 'Authorization': 'Bearer $idToken',
    };
  }

  Future<void> _updateMyLocationToServer(Position position) async {
    // 伺服器把這個呼叫視為「活躍」心跳，背景時（例如 Android 背景定位回呼）不可送出
    if (!_isInForeground) return;
    MoodTrail.record(_myMood, position.latitude, position.longitude); // 只存在手機上
    try {
      await http.post(
        Uri.parse(_updateLocationUrl),
        headers: await _authHeaders(),
        body: jsonEncode({
          'lat': position.latitude,
          'lng': position.longitude,
          'mood': _myMood,
          'nickname': _myNickname, 
        }),
      );
    } catch (e) {}
  }

  void _startRadarSweep() {
    _fetchNearbyUsers(); 
    _radarTimer?.cancel();
    _radarTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchNearbyUsers();
      if (++_radarTick % 3 == 0) _fetchWhispers(); // 低語每 30 秒更新一次
    });
    _fetchWhispers();
    _fetchCityMood();
    _cityMoodTimer?.cancel();
    _cityMoodTimer = Timer.periodic(const Duration(minutes: 5), (_) => _fetchCityMood());
  }

  Future<void> _fetchWhispers() async {
    if (_currentPosition == null || !_isInForeground) return;
    final list = await WhisperApi.list(_currentPosition!.latitude, _currentPosition!.longitude);
    if (!mounted) return;
    final fresh = list.where((w) => !w.mine && !_seenWhisperIds.contains(w.id)).toList();
    _seenWhisperIds.addAll(list.map((w) => w.id));
    setState(() => _whispers = list);
    if (fresh.isEmpty) return;
    HapticFeedback.lightImpact();
    showGlassToast(context,
        !_whispersLoaded && fresh.length > 1 ? '你附近有 ${fresh.length} 則低語，點信封讀讀看。' : '你經過了一則低語，點信封讀讀看。',
        icon: Icons.mail_outline);
    _whispersLoaded = true;
  }

  Future<void> _composeWhisper() async {
    if (_currentPosition == null) return;
    final posted = await showWhisperComposer(context, lat: _currentPosition!.latitude, lng: _currentPosition!.longitude, mood: _myMood);
    if (!posted || !mounted) return;
    showGlassToast(context, '你的低語留在這裡了，7 天後消散。', icon: Icons.mail_outline);
    _fetchWhispers();
  }

  Future<void> _openWhisper(Whisper w) async {
    final color = (_cityMoodStyle[w.mood] ?? _cityMoodStyle['other']!).$2;
    final deleted = await showWhisperReader(context, w, color: color, myUid: widget.uid);
    if (!mounted) return;
    if (deleted) {
      setState(() => _whispers.removeWhere((x) => x.id == w.id));
      showGlassToast(context, '低語已經收回。', icon: Icons.mail_outline);
    } else {
      _fetchWhispers(); // 更新「已被 N 個人收下」
    }
  }

  /// 雷達上的低語信封：與氣泡用同一套 3D 投影
  Widget _buildWhisperMarker(Whisper w) {
    final color = (_cityMoodStyle[w.mood] ?? _cityMoodStyle['other']!).$2;
    return Semantics(
      button: true,
      label: w.mine ? '你留下的低語' : '一則低語，點一下閱讀',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _openWhisper(w),
        child: SizedBox(
          width: 44, height: 44,
          child: Center(
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Night.night700,
                border: Border.all(color: color, width: 1.5),
                boxShadow: [BoxShadow(color: color.withOpacity(0.55), blurRadius: 14, spreadRadius: 1)],
              ),
              child: Icon(w.mine ? Icons.edit_note : Icons.mail_outline, color: color, size: 16),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchCityMood() async {
    if (_currentPosition == null || !_isInForeground) return;
    try {
      final response = await http.post(
        Uri.parse(_cityMoodUrl),
        headers: await _authHeaders(),
        body: jsonEncode({'lat': _currentPosition!.latitude, 'lng': _currentPosition!.longitude}),
      );
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) setState(() => _cityMood = Map<String, dynamic>.from(data['data']));
    } catch (_) {}
  }

  Future<void> _fetchNearbyUsers() async {
    if (_currentPosition == null) return;
    try {
      final response = await http.post(
        Uri.parse(_getNearbyUrl),
        headers: await _authHeaders(),
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

    for (var user in rawData) {
      if (user['uid'] == widget.uid) continue;
      if (_blockedUids.contains(user['uid']) || _blockedByUids.contains(user['uid'])) continue;

      // 狀態由伺服器判定（active / inactive / shadow），殘影留存時間依當地密度而定
      final String status = user['status'] ?? 'active';
      final bool isShadow = status == 'shadow';
      final double shadowAge = ((user['shadowAge'] ?? 0) as num).toDouble().clamp(0.0, 1.0);

      updatedUsers.add({
        'uid': user['uid'],
        'lat': user['lat'],
        'lng': user['lng'],
        'mood': user['mood'] ?? '無言中...',
        'nickname': isShadow ? '' : (user['nickname'] ?? ''), 
        'isShadow': isShadow,
        'isInactive': status == 'inactive',
        // 示範對象（導覽員機器人）：名字前一律標示「示範」
        'isDemo': user['demo'] == true,
        // 正在主持集會：「主持」光環與活動圖標
        'hostEmoji': user['hostEmoji'],
        // 殘影隨時間淡出：剛離開 0.8 → 即將消失 0.1
        'shadowOpacity': isShadow ? 0.8 - 0.7 * shadowAge : 1.0, 
      });
    }

    if (mounted) {
      _activeUsersNotifier.value = updatedUsers;
      if (!_hasScanned) setState(() => _hasScanned = true);
      // 可敲門的對象 = 活躍 + 休息中；對方離開雷達或變成殘影時收回敲門
      final knockableUids = updatedUsers.where((e) => e['isShadow'] != true).map((e) => e['uid']).toSet();
      _outgoingRequests.keys.toList().forEach((pendingTargetUid) {
        if (!knockableUids.contains(pendingTargetUid) && _outgoingRequests[pendingTargetUid] == RequestStatus.pending) {
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').remove();
          _dbRef.child('requests/$pendingTargetUid/${widget.uid}').onDisconnect().cancel();
          _pendingTimers[pendingTargetUid]?.cancel(); _requestSubscriptions[pendingTargetUid]?.cancel();
          _endKnockRitual(pendingTargetUid, dissolve: true);
          setState(() => _outgoingRequests.remove(pendingTargetUid));
          showGlassToast(context, '對方已沒入城市，悄悄收回敲門聲…', icon: Icons.nights_stay_outlined);
        }
      });
    }
  }

  void _listenToIncomingRequests() {
    _incomingRequestsStream = _dbRef.child('requests/${widget.uid}').onValue.listen((event) async {
      final data = event.snapshot.value != null ? Map<dynamic, dynamic>.from(event.snapshot.value as Map) : {};
      
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

      data.forEach((senderUidRaw, requestData) {
        final String senderUid = senderUidRaw.toString();
        if (_blockedUids.contains(senderUid) || _blockedByUids.contains(senderUid)) return;
        
        String status = '';
        String knockerName = '';

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
          _triggerKnockAlert(senderUid, knockerName); 
        }
      });
    });
  }

  Future<void> _triggerKnockAlert(String senderUid, String senderName) async {
    _isDialogShowing = true; 
    await _audioPlayer.play(AssetSource('audio/knock.mp3'));
    _heartbeatVibration();

    if (mounted) _showIncomingRequestUI(senderUid, senderName);
  }

  /// 心跳震動：兩次「噗通－噗通」（一輕一重），取代單一的嗡嗡聲
  Future<void> _heartbeatVibration() async {
    try {
      if (Platform.isIOS) {
        // iPhone：用原生 Core Haptics 播放（見 ios/Runner/AppDelegate.swift），比一般震動更有心跳感
        await const MethodChannel('citywhisper/haptics').invokeMethod('heartbeat');
        return;
      }
      if (!(await Vibration.hasVibrator())) return;
      if (await Vibration.hasCustomVibrationsSupport()) {
        // 時間軸（毫秒）：等待, 震, 停, 震 ...；強度對應每一段（0 = 停）
        Vibration.vibrate(
          pattern: const [0, 55, 110, 85, 560, 55, 110, 85],
          intensities: const [0, 150, 0, 255, 0, 150, 0, 255],
        );
      } else {
        // 不支援自訂震動的裝置：用兩下觸覺回饋模擬
        HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 160));
        HapticFeedback.heavyImpact();
      }
    } catch (_) {}
  }

  void _showIncomingRequestUI(String senderUid, String senderName) {
    void close(BuildContext dialogContext) {
      Navigator.pop(dialogContext);
      _isDialogShowing = false;
      _currentKnockerUid = null;
    }

    showDialog(
      context: context, barrierDismissible: true, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
          child: GlassCard(
            glow: true,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Night.night700, border: Border.all(color: Night.auroraViolet, width: 2), boxShadow: const [Night.glowViolet]),
                child: const Icon(Icons.person_outline, color: Night.inkMuted, size: 30),
              ),
              const SizedBox(height: Night.space3),
              const Text('片刻交集', style: Night.title),
              const SizedBox(height: Night.space2),
              Text('$senderName 正在敲門，\n想與你產生交集…', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton('略過', kind: NightButtonKind.text, onPressed: () { close(dialogContext); _dbRef.child('requests/${widget.uid}/$senderUid').remove(); })),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton('婉拒', kind: NightButtonKind.ghost, onPressed: () { close(dialogContext); _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'rejected'}); })),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton('同意', kind: NightButtonKind.warm, onPressed: () {
                  close(dialogContext);
                  _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'accepted', 'nickname': _myNickname});
                  _navigateToChatScreen(senderUid, senderName);
                })),
              ]),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Night.inkFaint, minimumSize: const Size(44, 44)),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('檢舉這個人', style: Night.caption),
                onPressed: () {
                  // 檢舉時一併婉拒這次敲門，對方會進入冷卻
                  close(dialogContext);
                  _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'rejected'});
                  showReportSheet(context, myUid: widget.uid, targetUid: senderUid, targetName: senderName, reportContext: ReportContext.knock);
                },
              ),
            ]),
          ),
        );
      },
    ).then((_) { if (_isDialogShowing) { _isDialogShowing = false; _currentKnockerUid = null; _dbRef.child('requests/${widget.uid}/$senderUid').remove(); } });
  }

  /// 頂部左上角的城市心情小標籤：今晚城市最多的心情
  Widget _buildCityMoodChip() {
    final mood = _cityMood;
    final bool quiet = mood == null || mood['quiet'] == true || (mood['moods'] as List?)?.isEmpty != false;
    String text = '今晚的城市還很安靜';
    Color dot = Night.moodDefault;
    if (!quiet) {
      final top = (mood['moods'] as List).first;
      final style = _cityMoodStyle[top['key']] ?? _cityMoodStyle['other']!;
      text = '今晚的城市 · ${style.$1} ${top['percent']}%';
      dot = style.$2;
    }
    return Semantics(
      button: true,
      label: '$text，查看城市心情天氣',
      child: GestureDetector(
        onTap: _showCityMoodSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: 7),
          decoration: BoxDecoration(
            color: Night.glassFill,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Night.glassLine),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dot, boxShadow: [BoxShadow(color: dot.withOpacity(0.7), blurRadius: 6)])),
            const SizedBox(width: Night.space2),
            Text(text, style: const TextStyle(color: Night.ink, fontSize: 13)),
          ]),
        ),
      ),
    );
  }

  void _showCityMoodSheet() {
    final mood = _cityMood;
    final int total = (mood?['total'] as num?)?.toInt() ?? 0;
    final List moods = (mood?['moods'] as List?) ?? const [];
    final bool quiet = mood == null || mood['quiet'] == true || moods.isEmpty;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, barrierColor: const Color(0x99070B1F),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            glow: true,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ShaderMask(
                shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                child: const Text('今晚的城市心情', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 2)),
              ),
              const SizedBox(height: Night.space2),
              Text(quiet ? '城市還很安靜，今晚有 $total 個人留下心情。' : '20 公里內，今晚有 $total 個人留下心情',
                  style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              if (quiet)
                const Text('多一點心情，城市就多一點光。寫下此刻的你，成為點亮城市的人。', style: Night.body, textAlign: TextAlign.center)
              else
                ...moods.map((m) {
                  final style = _cityMoodStyle[m['key']] ?? _cityMoodStyle['other']!;
                  final int pct = (m['percent'] as num).toInt();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      SizedBox(width: 44, child: Text(style.$1, style: const TextStyle(color: Night.ink, fontSize: 14))),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(children: [
                            Container(height: 10, color: Night.night700),
                            FractionallySizedBox(
                              widthFactor: (pct / 100).clamp(0.02, 1.0),
                              child: Container(height: 10, decoration: BoxDecoration(color: style.$2, boxShadow: [BoxShadow(color: style.$2.withOpacity(0.6), blurRadius: 8)])),
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(width: Night.space3),
                      SizedBox(width: 40, child: Text('$pct%', textAlign: TextAlign.right, style: const TextStyle(color: Night.inkMuted, fontSize: 13, fontFeatures: [FontFeature.tabularFigures()]))),
                    ]),
                  );
                }),
              const SizedBox(height: Night.space4),
              const Text('匿名統計 24 小時內的心情；少於 10 人時不顯示比例。', style: Night.caption, textAlign: TextAlign.center),
            ]),
          ),
        ),
      ),
    );
  }

  /// 空雷達卡片：附近 5 公里內沒有人時顯示，取代一片空白
  Widget _buildEmptyRadarCard() {
    return Stack(children: [
      _buildEmptyRadarCardBody(),
      // 不想邀請或分享也能關掉；本次開啟期間不再出現
      Positioned(
        top: 2, right: 2,
        child: IconButton(
          tooltip: '關閉',
          icon: const Icon(Icons.close, color: Night.inkFaint, size: 20),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          onPressed: () => setState(() => _emptyCardDismissed = true),
        ),
      ),
    ]);
  }

  Widget _buildEmptyRadarCardBody() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: Night.space6, vertical: Night.space4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ShaderMask(
          shaderCallback: (rect) => Night.brightGradient.createShader(rect),
          child: const Text('你是今晚第一道光', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 2)),
        ),
        const SizedBox(height: Night.space2),
        const Text('附近還沒有人。你的心情已經在城市裡發光，\n有人經過時，就會看見你。也可以留一則低語，給下一個經過這裡的人。', style: Night.body, textAlign: TextAlign.center),
        if (_cityMood != null && _cityMood!['quiet'] != true && (_cityMood!['moods'] as List?)?.isNotEmpty == true) ...[
          const SizedBox(height: Night.space2),
          Text('今晚城市裡有 ${_cityMood!['total']} 個人，多半感到「${(_cityMoodStyle[(_cityMood!['moods'] as List).first['key']] ?? _cityMoodStyle['other']!).$1}」',
              style: Night.caption, textAlign: TextAlign.center),
        ],
        const SizedBox(height: Night.space3),
        NightButton('邀請朋友點亮街區', icon: Icons.group_add_outlined, onPressed: () => shareInvite(context)),
        const SizedBox(height: Night.space2),
        NightButton('分享我的心情卡', kind: NightButtonKind.ghost, icon: Icons.ios_share, onPressed: () => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood))),
      ]),
    );
  }

  /// 底部玻璃選單：自己的大頭貼與心情（點一下編輯）＋設定
  Widget _buildDock() {
    final Color myColor = _getMoodColor(_myMood);
    return Container(
      height: 64,
      padding: const EdgeInsets.only(left: Night.space3, right: Night.space2),
      decoration: BoxDecoration(
        color: Night.glassFill,
        borderRadius: BorderRadius.circular(Night.radiusLg),
        border: Border.all(color: Night.glassLine),
        boxShadow: const [Night.lift],
      ),
      child: Row(children: [
        Expanded(
          child: Semantics(
            button: true,
            label: '編輯你的心情',
            child: InkWell(
              borderRadius: BorderRadius.circular(Night.radiusMd),
              onTap: _showProfileEditDialog,
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Night.night700, border: Border.all(color: myColor, width: 1.5),
                      boxShadow: [BoxShadow(color: myColor.withOpacity(0.35), blurRadius: 10)]),
                  child: ClipOval(
                    child: _myAvatarUrl.isNotEmpty
                        ? Image.network(_myAvatarUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person_outline, color: Night.inkMuted, size: 20))
                        : const Icon(Icons.person_outline, color: Night.inkMuted, size: 20),
                  ),
                ),
                const SizedBox(width: Night.space3),
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_myMood, style: const TextStyle(color: Night.ink, fontSize: 15, height: 1.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      _resonanceCount > 0
                          ? '今晚 $_resonanceCount 道微光與你共鳴'
                          : (_myNickname.isNotEmpty ? '$_myNickname · 你的心情' : '你的心情 · 點一下修改'),
                      style: _resonanceCount > 0 ? Night.caption.copyWith(color: Night.knockPink) : Night.caption,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
        IconButton(
          tooltip: '留下一則低語',
          onPressed: _composeWhisper,
          icon: const Icon(Icons.edit_note, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 48),
        ),
        IconButton(
          tooltip: '分享我的心情卡',
          onPressed: () => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood)),
          icon: const Icon(Icons.ios_share, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        IconButton(
          tooltip: '設定',
          onPressed: _showSettingsPanel,
          icon: const Icon(Icons.tune_rounded, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ]),
    );
  }

  Future<void> _showSettingsPanel() async {
    bool reminderOn = await NightlyReminder.isEnabled();
    if (!mounted) return;
    Widget item(IconData icon, String title, {String? subtitle, Color color = Night.inkMuted, Color titleColor = Night.ink, required VoidCallback onTap}) => InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Night.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Night.space3, horizontal: Night.space2),
            child: Row(children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: Night.space4),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(color: titleColor, fontSize: 15)),
                  if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle, style: Night.caption)],
                ]),
              ),
              const Icon(Icons.chevron_right, color: Night.inkFaint, size: 20),
            ]),
          ),
        );
    Widget section(String label) => Padding(
          padding: const EdgeInsets.only(left: Night.space2, top: Night.space4, bottom: Night.space1),
          child: Text(label, style: Night.caption),
        );

    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext sheetContext) {
        void go(VoidCallback action) { Navigator.pop(sheetContext); action(); }
        final reminderRow = StatefulBuilder(builder: (context, setRowState) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Night.space1, horizontal: Night.space2),
          child: Row(children: [
            const Icon(Icons.nightlight_outlined, color: Night.inkMuted, size: 22),
            const SizedBox(width: Night.space4),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('每晚提醒', style: TextStyle(color: Night.ink, fontSize: 15)),
                SizedBox(height: 2),
                Text('每晚 21:30 一則溫和的提醒', style: Night.caption),
              ]),
            ),
            Switch(
              value: reminderOn,
              activeThumbColor: Night.onDeep,
              activeTrackColor: Night.deepViolet,
              inactiveTrackColor: Night.night700,
              onChanged: (v) { setRowState(() => reminderOn = v); NightlyReminder.setEnabled(v); },
            ),
          ]),
        ));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Night.space4),
            child: GlassCard(
              padding: const EdgeInsets.fromLTRB(Night.space4, Night.space3, Night.space4, Night.space4),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  // 設定比螢幕還高時點不到外面，標題列右邊一定要有關閉鈕
                  Stack(alignment: Alignment.center, children: [
                    const Text('設定', style: Night.title, textAlign: TextAlign.center),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: '關閉設定',
                        icon: const Icon(Icons.close, color: Night.inkMuted),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ),
                  ]),
                  section('我'),
                  item(Icons.person_outline, '編輯個人狀態', subtitle: '大頭貼、城市稱呼與心情', onTap: () => go(_showProfileEditDialog)),
                  item(Icons.block, '管理封鎖名單', subtitle: '查看或解除被你沒入黑暗的人', color: Night.danger, onTap: () => go(_showBlockListDialog)),
                  item(Icons.timeline, '我的心情軌跡', subtitle: '只存在你的手機上', onTap: () => go(() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MoodTrailScreen())))),
                  reminderRow,
                  section('集會'),
                  item(Icons.campaign_outlined, '集會主持人',
                      subtitle: _hostedGathering == null ? '以你為中心 5 公里，開一場活動' : '你正在主持 ${_hostedGathering!.emoji} ${_hostedGathering!.name}',
                      onTap: () => go(_openGatheringHost)),
                  section('分享'),
                  item(Icons.ios_share, '分享我的心情卡', subtitle: '一張夜景心情卡，適合 IG 限時動態', onTap: () => go(() => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood)))),
                  item(Icons.group_add_outlined, '邀請朋友點亮街區', subtitle: '附近的人越多，城市越亮', onTap: () => go(() => shareInvite(context))),
                  section('關於'),
                  item(Icons.menu_book_outlined, '操作說明', subtitle: '從寫下心情到開一場集會，一次看懂', onTap: () => go(() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen())))),
                  item(Icons.description_outlined, '使用條款', onTap: () => Legal.open(Legal.termsUrl)),
                  item(Icons.privacy_tip_outlined, '隱私權政策', onTap: () => Legal.open(Legal.privacyUrl)),
                  item(Icons.mail_outline, '聯絡我們', subtitle: Legal.contactEmail, onTap: () => Legal.emailUs()),
                  const Divider(color: Night.night600, height: Night.space6),
                  item(Icons.delete_forever_outlined, '刪除帳號與資料', subtitle: '永久抹除你在城市留下的一切', color: Night.danger, titleColor: Night.danger, onTap: () => go(_confirmDeleteAccount)),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProfileEditDialog() {
    final TextEditingController moodController = TextEditingController(text: _myMood);
    final TextEditingController nicknameController = TextEditingController(text: _myNickname);
    bool isUploading = false; 
    bool isPicking = false; // 相簿開著時再點一次，會讓前一個請求被取消並丟出例外
    String pendingAvatarUrl = _myAvatarUrl; // 按下「儲存」才生效，取消則不改變

    InputDecoration nightInput(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Night.inkFaint, fontSize: 14),
          counterStyle: Night.caption,
          filled: true,
          fillColor: Night.night700,
          contentPadding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.glassLine)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.auroraViolet, width: 2)),
        );

    showDialog(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            // 心情色即時預覽：輸入心情時光環跟著變色，先看到自己的氣泡會是什麼顏色
            final Color previewColor = _getMoodColor(moodController.text.trim());

            Future<void> pickAvatar() async {
              final picker = ImagePicker();
              if (isPicking) return;
              isPicking = true;
              final XFile? image;
              try {
                image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
              } catch (e) {
                debugPrint('avatar pick failed: $e');
                return;
              } finally {
                isPicking = false;
              }
              if (image == null) return;
              setDialogState(() => isUploading = true);
              try {
                final storageRef = FirebaseStorage.instance.ref().child('avatars/${widget.uid}.jpg');
                await storageRef.putFile(File(image.path), SettableMetadata(contentType: 'image/jpeg'));
                // 同一路徑覆寫時網址不變，加上版本參數讓各裝置的圖片快取失效
                final downloadUrl = '${await storageRef.getDownloadURL()}&v=${DateTime.now().millisecondsSinceEpoch}';
                setDialogState(() {
                  pendingAvatarUrl = downloadUrl;
                  isUploading = false;
                });
              } catch (e) {
                setDialogState(() => isUploading = false);
                debugPrint('avatar upload failed: $e');
                if (mounted) showGlassToast(context, '大頭貼上傳失敗，請稍後再試。', icon: Icons.error_outline, danger: true);
              }
            }

            Future<void> save() async {
              final String newMood = moodController.text.trim(); final String newNickname = nicknameController.text.trim();
              if (newMood.isEmpty) { showGlassToast(context, '心情不能為空，給城市留下點微光吧。', icon: Icons.edit_outlined); return; }
              
              setState(() { _myMood = newMood; _myNickname = newNickname; _myAvatarUrl = pendingAvatarUrl; });
              final prefs = await SharedPreferences.getInstance(); 
              await prefs.setString('saved_mood', newMood); 
              await prefs.setString('saved_nickname', newNickname);
              await prefs.setString('saved_avatar', _myAvatarUrl); 
              
              try {
                await _dbRef.child('profiles/${widget.uid}/nickname').set(newNickname);
                // 🌟 上傳完成後，寫入專屬的廣播頻道
                if (_myAvatarUrl.isNotEmpty) {
                  await _dbRef.child('user_avatars/${widget.uid}').set(_myAvatarUrl);
                }
              } catch (e) {
                debugPrint('profile write failed: $e');
                if (mounted) showGlassToast(context, '狀態同步失敗，請稍後再試。', icon: Icons.error_outline, danger: true);
              }

              if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
              
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              if (mounted) showGlassToast(context, '狀態已更新，城市正感知你的呼吸。', icon: Icons.auto_awesome_outlined);
            }

            return Dialog(
              backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
              child: GlassCard(
                glow: true,
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Text('編輯個人狀態', style: Night.title, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    Center(
                      child: Semantics(
                        button: true,
                        label: '更換大頭貼',
                        child: GestureDetector(
                          onTap: isUploading ? null : pickAvatar,
                          child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 92, height: 92,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [previewColor, Night.auroraViolet], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                boxShadow: [BoxShadow(color: previewColor.withOpacity(0.45), blurRadius: 22)],
                              ),
                              child: Container(
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Night.night700),
                                child: ClipOval(
                                  child: pendingAvatarUrl.isNotEmpty
                                      ? Image.network(pendingAvatarUrl, fit: BoxFit.cover, width: 86, height: 86)
                                      : const Icon(Icons.person_outline, color: Night.inkMuted, size: 38),
                                ),
                              ),
                            ),
                            if (isUploading) const SizedBox(width: 92, height: 92, child: CircularProgressIndicator(color: Night.auroraViolet, strokeWidth: 2)),
                            Positioned(
                              right: -2, bottom: -2,
                              child: Container(
                                width: 30, height: 30,
                                decoration: BoxDecoration(shape: BoxShape.circle, gradient: Night.deepGradient, border: Border.all(color: Night.night700, width: 2)),
                                child: const Icon(Icons.photo_camera_outlined, color: Night.onDeep, size: 16),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: Night.space2),
                    const Text('輕觸更換大頭貼 · 光環是你的心情色', style: Night.caption, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    const Text('城市稱呼', style: Night.caption),
                    const SizedBox(height: Night.space2),
                    TextField(controller: nicknameController, style: const TextStyle(color: Night.ink, fontSize: 15), maxLength: 10, cursorColor: Night.auroraViolet, decoration: nightInput('選填，例如：遊蕩的貓')),
                    const SizedBox(height: Night.space2),
                    const Text('當下心情', style: Night.caption),
                    const SizedBox(height: Night.space2),
                    TextField(
                      controller: moodController, maxLength: 20, cursorColor: Night.auroraViolet,
                      onChanged: (_) => setDialogState(() {}),
                      style: const TextStyle(color: Night.ink, fontSize: 15),
                      decoration: nightInput('例如：漫步在微雨中 🌿'),
                    ),
                    const SizedBox(height: Night.space3),
                    Row(children: [
                      Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext))),
                      const SizedBox(width: Night.space2),
                      Expanded(child: NightButton('儲存', onPressed: isUploading ? null : save)),
                    ]),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBlockListDialog() {
    showDialog(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
              child: GlassCard(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('沉入黑暗的名單', style: Night.title, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space3),
                  if (_blockedUids.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: Night.space4),
                      child: Column(children: [
                        Icon(Icons.nights_stay_outlined, color: Night.inkFaint, size: 40),
                        SizedBox(height: Night.space3),
                        Text('夜色清朗，你的城市未曾放逐任何人。', style: Night.body, textAlign: TextAlign.center),
                      ]),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _blockedUids.length,
                        separatorBuilder: (context, index) => const Divider(color: Night.night600, height: 1),
                        itemBuilder: (context, index) {
                          final String blockedUid = _blockedUids[index];
                          final val = _blockedUsersData[blockedUid];
                          String displayName = '#${blockedUid.substring(blockedUid.length - 4).toUpperCase()}';
                          if (val is String && val.isNotEmpty) displayName = '$val ($displayName)';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: Night.space2),
                            child: Row(children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Night.night700, border: Border.all(color: Night.glassLine)),
                                child: const Icon(Icons.person_outline, color: Night.inkFaint, size: 20),
                              ),
                              const SizedBox(width: Night.space3),
                              Expanded(child: Text(displayName, style: const TextStyle(color: Night.ink, fontSize: 15), overflow: TextOverflow.ellipsis)),
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: Night.auroraBlue, minimumSize: const Size(44, 44)),
                                onPressed: () async { await _unblockUser(blockedUid); setDialogState(() { _blockedUids.remove(blockedUid); }); },
                                child: const Text('解除放逐', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: Night.space4),
                  NightButton('關閉', kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext)),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (dialogContext) {
        bool deleting = false;
        return StatefulBuilder(builder: (dialogContext, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
            child: GlassCard(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.delete_forever_outlined, color: Night.danger, size: 36),
                const SizedBox(height: Night.space3),
                const Text('刪除帳號與資料', style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space2),
                const Text('你的位置、心情、城市稱呼、大頭貼、留下的低語、微光、封鎖名單與進行中的對話都會被永久刪除，無法復原。\n\n為了防止濫用，檢舉紀錄會依隱私權政策保留 1 年。',
                    style: Night.body, textAlign: TextAlign.center),
                const SizedBox(height: Night.space4),
                Row(children: [
                  Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: deleting ? null : () => Navigator.pop(dialogContext))),
                  const SizedBox(width: Night.space2),
                  Expanded(child: NightButton(deleting ? '刪除中…' : '永久刪除', kind: NightButtonKind.danger, onPressed: deleting ? null : () async {
                    setDialogState(() => deleting = true);
                    final ok = await _deleteAccount();
                    if (!ok && dialogContext.mounted) {
                      setDialogState(() => deleting = false);
                      showGlassToast(context, '刪除沒有完成，請檢查網路後再試一次。', icon: Icons.error_outline, danger: true);
                    }
                  })),
                ]),
              ]),
            ),
          );
        });
      },
    );
  }

  /// 刪除帳號：先停止所有回報，避免刪除後又被心跳或斷線標記寫回資料；成功後清空本機並回到起點。
  Future<bool> _deleteAccount() async {
    _heartbeatTimer?.cancel(); _radarTimer?.cancel(); _positionStream?.cancel();
    _isInForeground = false; // 讓 _updateMyLocationToServer 不再送出
    try {
      await _presenceRef.onDisconnect().cancel();
      final response = await http.post(Uri.parse(_deleteAccountUrl), headers: await _authHeaders(), body: '{}');
      if (response.statusCode != 200) throw Exception('deleteAccount ${response.statusCode}');
    } catch (e) {
      debugPrint('delete account failed: $e');
      // 失敗時恢復正常運作
      _isInForeground = true;
      _setPresence('active');
      _startForegroundHeartbeat();
      _startRadarSweep();
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const IntroScreen()), (_) => false);
    }
    return true;
  }

  // ---------- 氣泡疊層與群聚 ----------

  /// 疊層規則（由下到上）：殘影 < 示範 < 休息中 < 活躍真人 < 和你有關的人（敲門中）< 剛按住的那顆。
  /// 同一層裡越近（畫面越下方）越上面。
  int _bubbleTier(Map<String, dynamic> user, {bool withFocus = true}) {
    final uid = user['uid'].toString();
    if (withFocus && uid == _focusUid) return 5;
    if (user['isShadow'] == true) return 0;
    if (_ritualTarget == uid || _outgoingRequests[uid] == RequestStatus.pending) return 4;
    if (user['hostEmoji'] != null) return 4; // 集會主持人浮在一般人上面
    if (user['isDemo'] == true) return 1;
    if (user['isInactive'] == true) return 2;
    return 3;
  }

  static int _comparePaintOrder(_PlacedBubble a, _PlacedBubble b) =>
      a.tier != b.tier ? a.tier.compareTo(b.tier) : a.pos.dy.compareTo(b.pos.dy);

  void _focusBubble(String uid) {
    _focusTimer?.cancel();
    setState(() => _focusUid = uid);
    _focusTimer = Timer(const Duration(seconds: 4), () { if (mounted) setState(() => _focusUid = null); });
  }

  void _collapseCluster() {
    if (_expandedCluster != null) setState(() { _expandedCluster = null; _clusterPage = 0; });
  }

  List<Widget> _buildBubbleLayer(List<Map<String, dynamic>> users, double centerX, double centerY, double screenWidth, double screenHeight,
      double pitch, double heading, double scale, double rhythm) {
    final placed = <_PlacedBubble>[];
    for (final user in users) {
      final r = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, user['lat'], user['lng'], heading, user['uid'], rhythm);
      if (r.opacity <= 0.0) continue;
      final d = (r.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6) * scale;
      final a = r.relativeAngle * pi / 180.0;
      final rotX = d * sin(a); final rotY = -d * cos(a) * cos(pitch); final rotZ = -d * cos(a) * sin(pitch);
      final w = max(0.01, 1.0 + (rotZ * 0.002));
      placed.add(_PlacedBubble(user, r, Offset(centerX + rotX / w, centerY + rotY / w), _bubbleTier(user), _bubbleTier(user, withFocus: false)));
    }

    // 群聚：從最上層開始，和某個群聚核心重疊到會點錯的氣泡就歸進那個群聚。
    // 同層用 uid 排，不用畫面位置：羅盤微動時核心才不會換來換去，點擊也不會落空。
    // 剛按住的那顆不參與分群排序，否則長按花瓣時核心換人，展開的花瓣會自己收起來
    placed.sort((a, b) => a.groupTier != b.groupTier ? b.groupTier.compareTo(a.groupTier) : a.uid.compareTo(b.uid));
    final clusters = <List<_PlacedBubble>>[];
    for (final p in placed) {
      List<_PlacedBubble>? home;
      // 集會主持人永遠單獨顯示（疊在最上層），參加者才找得到他
      if (p.user['hostEmoji'] != null) { clusters.add([p]); continue; }
      for (final c in clusters) {
        final core = c.first;
        if (core.user['hostEmoji'] != null) continue;
        final s = (core.render.scale + p.render.scale) / 2;
        if ((core.pos.dx - p.pos.dx).abs() < 88 * s && (core.pos.dy - p.pos.dy).abs() < 76 * s) { home = c; break; }
      }
      home == null ? clusters.add([p]) : home.add(p);
    }
    clusters.sort((a, b) => _comparePaintOrder(a.first, b.first));

    final widgets = <Widget>[];
    List<_PlacedBubble>? expanded;
    for (final c in clusters) {
      if (c.length == 1) {
        widgets.add(_placedBubbleWidget(c.first, c.first.pos));
      } else if (c.any((p) => p.uid == _expandedCluster)) {
        expanded = c;
        for (final p in c) { _bubbleAnchors[p.uid] = c.first.pos; }
      } else {
        widgets.add(_clusterOrb(c));
      }
    }
    if (_expandedCluster != null && expanded == null) {
      // 鏡頭拉近後群聚已散開，或成員離開：收起來
      WidgetsBinding.instance.addPostFrameCallback((_) => _collapseCluster());
    }
    if (expanded != null) widgets.add(_clusterPetals(expanded, screenWidth, screenHeight));
    return widgets;
  }

  Widget _placedBubbleWidget(_PlacedBubble p, Offset at, {double extraScale = 1.0, bool petal = false}) {
    final user = p.user;
    final uid = p.uid;
    final shortId = uid.substring(uid.length - 4).toUpperCase();
    final displayName = user['nickname'].toString().isNotEmpty ? user['nickname'] : '#$shortId';
    final isShadow = user['isShadow'] ?? false;
    _bubbleAnchors[uid] = at + const Offset(0, 10);
    return Positioned(
      key: ValueKey('bubble:$uid'), // 疊層每幀重排，固定 key 才不會在手指按下時換掉元件
      left: at.dx - 66, top: at.dy - 60,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () {
          _focusBubble(uid);
          _showInteractionMenu(uid, isShadow ? '歷史殘影' : displayName, isShadow: isShadow, isDemo: user['isDemo'] == true, moodColor: _getMoodColor(user['mood']));
        },
        // 雙擊氣泡：直接送出一道微光
        onDoubleTap: () {
          _focusBubble(uid);
          _sendResonance(uid, _getMoodColor(user['mood']));
        },
        child: Opacity(
          // 花瓣不依距離淡出、也不縮小：展開就是為了每顆都看得清楚
          opacity: petal ? 1.0 : p.render.opacity,
          child: Transform.scale(
            scale: petal ? extraScale : p.render.scale * extraScale,
            child: _AnimatedBubbleUI(
              key: ValueKey(uid),
              uid: uid, // 🌟 傳入 UID 給 StreamBuilder 監聽
              moodText: user['mood'],
              isFavored: p.render.isFavored,
              status: _outgoingRequests[uid] ?? RequestStatus.none,
              displayName: displayName,
              distanceLabel: WhisperEngine.formatDistance(p.render.distance),
              baseColor: _getMoodColor(user['mood']),
              isShadow: isShadow,
              isInactive: user['isInactive'] ?? false,
              isDemo: user['isDemo'] ?? false,
              hostEmoji: user['hostEmoji'] as String?,
              shadowOpacity: user['shadowOpacity'] ?? 1.0,
            ),
          ),
        ),
      ),
    );
  }

  /// 群聚裡最多的心情顏色，同票時取上層的
  Color _clusterColor(List<_PlacedBubble> c) {
    final counts = <Color, int>{};
    for (final p in c.where((p) => p.user['isShadow'] != true)) {
      final color = _getMoodColor(p.user['mood']);
      counts[color] = (counts[color] ?? 0) + 1;
    }
    if (counts.isEmpty) return Night.shadowInk;
    return counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }

  Widget _clusterOrbFace(List<_PlacedBubble> c, {double size = 64}) {
    final color = _clusterColor(c);
    final dots = c.map((p) => p.user['isShadow'] == true ? Night.shadowInk : _getMoodColor(p.user['mood'])).take(5).toList();
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Night.glassFill,
        border: Border.all(color: color, width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.45), blurRadius: 18, spreadRadius: 1)],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('${c.length}', style: const TextStyle(color: Night.ink, fontSize: 20, height: 1.1, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
        const SizedBox(height: 3),
        Row(mainAxisSize: MainAxisSize.min, children: [
          for (final d in dots)
            Container(width: 5, height: 5, margin: const EdgeInsets.symmetric(horizontal: 1.5), decoration: BoxDecoration(shape: BoxShape.circle, color: d)),
        ]),
      ]),
    );
  }

  /// 重疊的氣泡合成一顆：「這裡有 N 個心情」，點一下展開成一圈花瓣
  Widget _clusterOrb(List<_PlacedBubble> c) {
    final core = c.first;
    for (final p in c) { _bubbleAnchors[p.uid] = core.pos; }
    final opacity = c.map((p) => p.render.opacity).reduce(max);
    return Positioned(
      key: ValueKey('cluster:${core.uid}'),
      left: core.pos.dx - 60, top: core.pos.dy - 44,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() { _expandedCluster = core.uid; _clusterPage = 0; }),
        child: Opacity(
          opacity: opacity,
          child: SizedBox(
            width: 120,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _clusterOrbFace(c),
              const SizedBox(height: 8),
              Text('這裡有 ${c.length} 個心情', style: Night.caption.copyWith(shadows: const [Shadow(color: Night.night900, blurRadius: 6)])),
            ]),
          ),
        ),
      ),
    );
  }

  /// 展開的群聚：每顆氣泡排成一圈（人多時兩圈），每顆都點得到；點空白處或中心收起
  Widget _clusterPetals(List<_PlacedBubble> c, double screenWidth, double screenHeight) {
    const perPage = 14; // 兩圈最多 15 個位置；超過時最後一個位置是「更多」
    final paged = c.length > perPage + 1;
    final pages = paged ? (c.length / perPage).ceil() : 1;
    final page = _clusterPage % pages;
    final shown = paged ? c.skip(page * perPage).take(perPage).toList() : c;
    final slots = shown.length + (paged ? 1 : 0);

    final inner = min(slots, 7);
    final outer = slots - inner;
    final r1 = outer == 0 ? max(118.0, inner * 140 / (2 * pi)) : 122.0;
    const r2 = 226.0;
    final maxR = outer == 0 ? r1 : r2;
    // 氣泡比較寬，橫向拉開一點
    final rx1 = min(r1 * 1.2, screenWidth / 2 - 62);
    final rx2 = min(r2 * 1.1, screenWidth / 2 - 58);

    // 整圈要留在畫面裡：上面避開狀態列與城市心情，下面避開底部選單
    final pad = MediaQuery.of(context).padding;
    double clampOr(double v, double lo, double hi, double fallback) => lo > hi ? fallback : v.clamp(lo, hi);
    final center = Offset(
      clampOr(c.first.pos.dx, rx1 + 66, screenWidth - rx1 - 66, screenWidth / 2),
      clampOr(c.first.pos.dy, pad.top + 110 + maxR, screenHeight - pad.bottom - 130 - maxR, screenHeight / 2),
    );

    final targets = <Offset>[];
    for (var i = 0; i < slots; i++) {
      final onInner = i < inner;
      final n = onInner ? inner : outer;
      final k = onInner ? i : i - inner;
      final angle = -pi / 2 + 2 * pi * k / n + (onInner ? 0 : pi / n);
      // 錨點在頭像，氣泡本體在上方約 30pt：往下挪，讓整圈看起來以中心為圓心
      targets.add(center + Offset((onInner ? rx1 : rx2) * cos(angle), (onInner ? r1 : r2) * sin(angle) + 30));
    }
    final color = _clusterColor(c);

    return Positioned.fill(
      key: const ValueKey('petals'),
      child: TweenAnimationBuilder<double>(
        key: ValueKey('${c.first.uid}#$page'),
        tween: Tween(begin: 0, end: 1),
        duration: MediaQuery.of(context).disableAnimations ? Duration.zero : const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, t, _) {
          final at = [for (final p in targets) Offset.lerp(center, p, t)!];
          return Stack(clipBehavior: Clip.none, children: [
            // 背景變暗一點；點空白處收起
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _collapseCluster,
                child: ColoredBox(color: Night.night900.withOpacity(0.72 * t.clamp(0.0, 1.0))),
              ),
            ),
            Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _PetalStemPainter(center, at, color.withOpacity(0.35))))),
            Positioned(
              left: center.dx - 32, top: center.dy - 32,
              child: GestureDetector(onTap: _collapseCluster, child: _clusterOrbFace(c)),
            ),
            for (var i = 0; i < shown.length; i++) _placedBubbleWidget(shown[i], at[i], extraScale: 0.9, petal: true),
            if (paged)
              Positioned(
                left: at.last.dx - 30, top: at.last.dy - 30,
                child: GestureDetector(
                  onTap: () => setState(() => _clusterPage = page + 1),
                  child: Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Night.glassFill, border: Border.all(color: Night.glassLine)),
                    alignment: Alignment.center,
                    child: Text(page + 1 < pages ? '更多\n+${c.length - (page + 1) * perPage}' : '回到\n第一批',
                        textAlign: TextAlign.center, style: Night.caption.copyWith(color: Night.ink)),
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }

  void _showInteractionMenu(String targetUid, String displayName, {bool isShadow = false, bool isDemo = false, Color moodColor = Night.moodDefault}) {
    Widget item(IconData icon, Color color, String label, VoidCallback onTap) => InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Night.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Night.space3, horizontal: Night.space2),
            child: Row(children: [Icon(icon, color: color), const SizedBox(width: Night.space3), Text(label, style: const TextStyle(color: Night.ink, fontSize: 15))]),
          ),
        );

    showDialog(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
          child: GlassCard(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(isShadow ? '一道歷史殘影' : '與 $displayName 的相遇', style: Night.title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
              if (isShadow) ...[
                const SizedBox(height: Night.space2),
                const Text('這只是一道歷史殘影，無法產生交集。', style: Night.body, textAlign: TextAlign.center),
              ],
              if (isDemo) ...[
                const SizedBox(height: Night.space2),
                const Text('這是示範對象，由程式自動回應，不是真人。可以用它體驗敲門、聊天、微光、檢舉與封鎖。', style: Night.body, textAlign: TextAlign.center),
              ],
              const SizedBox(height: Night.space3),
              item(Icons.auto_awesome, moodColor, '送出一道微光 (共鳴)', () { Navigator.pop(dialogContext); _sendResonance(targetUid, moodColor); }),
              if (!isShadow) ...[
                item(Icons.waving_hand_outlined, Night.knockPink, '敲門 (產生交集)', () { Navigator.pop(dialogContext); _handleBubbleLongPress(targetUid, displayName); }),
                item(Icons.block, Night.danger, '封鎖 (沒入黑暗)', () { Navigator.pop(dialogContext); _showBlockConfirmationDialog(targetUid, displayName); }),
              ],
              item(Icons.flag_outlined, Night.danger, '檢舉', () {
                Navigator.pop(dialogContext);
                showReportSheet(context, myUid: widget.uid, targetUid: targetUid, targetName: displayName, reportContext: ReportContext.bubble);
              }),
            ]),
          ),
        );
      },
    );
  }

  void _showBlockConfirmationDialog(String targetUid, String displayName) {
    showDialog(
      context: context, barrierColor: const Color(0x99070B1F),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
          child: GlassCard(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Icon(Icons.block, color: Night.danger, size: 36),
              const SizedBox(height: Night.space3),
              const Text('確認封鎖', style: Night.title, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              Text('確定要將 $displayName 沒入黑暗嗎？\n封鎖後，雙方將從彼此的城市中消失。', style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton('取消', kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext))),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton('確定封鎖', kind: NightButtonKind.danger, icon: Icons.block, onPressed: () { Navigator.pop(dialogContext); _blockUser(targetUid, displayName); })),
              ]),
            ]),
          ),
        );
      },
    );
  }

  /// 收到的微光：只計 24 小時內的，並順手清掉更舊的紀錄
  void _listenToResonance() {
    _resonanceSubscription?.cancel();
    _resonanceSubscription = _dbRef.child('resonance/${widget.uid}').onValue.listen((event) {
      final raw = event.snapshot.value;
      final now = DateTime.now().millisecondsSinceEpoch;
      int count = 0;
      if (raw is Map) {
        raw.forEach((sender, at) {
          if (at is int && now - at <= 86400000) {
            count++;
          } else {
            _dbRef.child('resonance/${widget.uid}/$sender').remove();
          }
        });
      }
      if (!mounted) return;
      final bool isNew = _resonanceCount >= 0 && count > _resonanceCount;
      setState(() => _resonanceCount = count);
      if (isNew) {
        HapticFeedback.lightImpact();
        showGlassToast(context, '有人送你一道微光，與你的心情共鳴。', icon: Icons.auto_awesome);
      }
    });
  }

  /// 送出一道微光（共鳴）：不需要聊天，同一人 24 小時一次
  Future<void> _sendResonance(String targetUid, Color moodColor) async {
    try {
      await _dbRef.child('resonance/$targetUid/${widget.uid}').set(ServerValue.timestamp);
      HapticFeedback.selectionClick();
      final anchor = _bubbleAnchors[targetUid];
      if (mounted && anchor != null && !MediaQuery.of(context).disableAnimations) {
        setState(() { _sparkleAt = anchor; _sparkleColor = moodColor; });
        _sparkle.forward(from: 0);
      }
      if (mounted) showGlassToast(context, '你送出了一道微光。', icon: Icons.auto_awesome);
    } catch (e) {
      // 規則拒絕：24 小時內已送過、被封鎖，或帳號被隱藏
      if (mounted) showGlassToast(context, '今天已經送過微光給對方了，明天再來吧。', icon: Icons.auto_awesome_outlined);
    }
  }

  void _startKnockRitual(String targetUid, String targetName) {
    _ritualTarget = targetUid;
    _ritualTargetName = targetName;
    _ritualStart = DateTime.now();
    _knockSecondsLeft.value = _knockSeconds;
    _knockTicker?.cancel();
    _knockTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      final start = _ritualStart;
      if (start == null) return;
      _knockSecondsLeft.value = (_knockSeconds - DateTime.now().difference(start).inSeconds).clamp(0, _knockSeconds);
    });
    if (!MediaQuery.of(context).disableAnimations) _arcFlow.repeat();
    setState(() {});
  }

  /// 結束敲門儀式。[dissolve] 為 true 時，光在對方的位置化成粒子散去。
  void _endKnockRitual(String targetUid, {bool dissolve = false, String? message}) {
    if (_ritualTarget != targetUid) return;
    _knockTicker?.cancel();
    _arcFlow.stop();
    final anchor = _bubbleAnchors[targetUid];
    if (!mounted) return;
    setState(() {
      _ritualTarget = null;
      _ritualStart = null;
      if (dissolve && anchor != null && !MediaQuery.of(context).disableAnimations) {
        _dissolveAt = anchor;
        _dissolve.forward(from: 0);
      }
    });
    if (message != null) showGlassToast(context, message, icon: Icons.nights_stay_outlined);
  }

  void _handleBubbleLongPress(String targetUid, String targetName) {
    if (_outgoingRequests[targetUid] == RequestStatus.pending) return;
    bool canProceed = _coolingSystem.canKnock(targetUid, (blockMessage) { showGlassToast(context, blockMessage, icon: Icons.hourglass_empty); });
    if (!canProceed) return;

    _outgoingRequests.forEach((uid, status) { if (status == RequestStatus.pending) _dbRef.child('requests/$uid/${widget.uid}').remove(); });
    setState(() => _outgoingRequests.clear());

    _coolingSystem.recordKnock(); _coolingSystem.recordInteraction();
    setState(() => _outgoingRequests[targetUid] = RequestStatus.pending);
    _startKnockRitual(targetUid, targetName);

    _dbRef.child('requests/$targetUid/${widget.uid}').set({
        'status': 'pending',
        'nickname': _myNickname
    }).then((_) {
      if (mounted) showGlassToast(context, '敲門聲已送出，等待回音…', icon: Icons.waving_hand_outlined);
    }).catchError((Object e) {
      // 寫入被拒（規則驗證失敗、網路中斷等）時收回狀態並告知，不再默默失敗
      debugPrint('knock write failed: $e');
      _pendingTimers[targetUid]?.cancel(); _requestSubscriptions[targetUid]?.cancel();
      _endKnockRitual(targetUid);
      if (mounted) {
        setState(() => _outgoingRequests.remove(targetUid));
        showGlassToast(context, '敲門沒有送出，請稍後再試。', icon: Icons.error_outline, danger: true);
      }
    });

    _pendingTimers[targetUid]?.cancel();
    _pendingTimers[targetUid] = Timer(const Duration(minutes: 5), () {
      if (_outgoingRequests[targetUid] == RequestStatus.pending) {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        _endKnockRitual(targetUid, dissolve: true, message: '沒有回音，敲門聲悄悄消散了。');
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      }
    });

    _requestSubscriptions[targetUid]?.cancel(); 
    _requestSubscriptions[targetUid] = _dbRef.child('requests/$targetUid/${widget.uid}').onValue.listen((event) async {
      final requestData = event.snapshot.value;
      String status = '';
      String targetAcceptedName = targetName; 

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
        _endKnockRitual(targetUid);
        if (mounted) {
          setState(() => _outgoingRequests.remove(targetUid));
          _navigateToChatScreen(targetUid, targetAcceptedName); 
        }
      } else if (status == 'rejected') {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); _pendingTimers[targetUid]?.cancel(); _coolingSystem.recordRejection(targetUid); 
        _endKnockRitual(targetUid, dissolve: true, message: '這次沒有交集，讓彼此保留一點空間。');
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      } else if (status.isEmpty && _outgoingRequests[targetUid] == RequestStatus.pending) {
        // 對方按「略過」會直接刪除請求 → 收回敲門中的狀態
        // （同意 / 婉拒後由自己刪除請求時，狀態已先移除，不會走到這裡）
        _pendingTimers[targetUid]?.cancel();
        _endKnockRitual(targetUid, dissolve: true, message: '對方先略過了，敲門聲悄悄消散。');
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      }
    });
  }

  Future<void> _navigateToChatScreen(String targetUid, String fallbackName) async {
    if (!mounted) return;
    
    String myCurrentName = _myNickname.trim().isNotEmpty 
        ? _myNickname.trim() 
        : '#${widget.uid.substring(widget.uid.length - 4).toUpperCase()}';
        
    String finalTargetName = fallbackName;
    try {
      final user = _activeUsersNotifier.value.firstWhere((u) => u['uid'] == targetUid);
      if (user['nickname'] != null && user['nickname'].toString().trim().isNotEmpty) {
        finalTargetName = user['nickname'].toString();
      }
    } catch (_) {}

    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
        myUid: widget.uid, 
        myName: myCurrentName, 
        targetUid: targetUid, 
        targetName: finalTargetName 
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child), transitionDuration: const Duration(milliseconds: 800),
    ));
    _coolingSystem.recordChatEnd(targetUid);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 從系統設定回來：重新檢查定位權限與精確位置
      if (_locationIssue != _LocationIssue.none) _checkLocation();
      // 回到前景：立刻回報為活躍，並馬上刷新雷達
      if (_isInForeground) return;
      _isInForeground = true;
      if (!_locationServicesStarted) return;
      _setPresence('active');
      if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
      _startForegroundHeartbeat();
      _startRadarSweep();
    } else if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      // 鎖屏 / 切到背景：標記為休息中（仍可被敲門），停止前景心跳與雷達掃描
      // 註：iOS 開啟 App 切換器只會進入 inactive，此時從切換器滑掉 App 會觸發 onDisconnect → exited
      if (!_isInForeground) return;
      _isInForeground = false;
      _heartbeatTimer?.cancel();
      _radarTimer?.cancel();
      _cityMoodTimer?.cancel();
      if (_locationServicesStarted) _setPresence('background');
    } else if (state == AppLifecycleState.detached) {
      _presenceRef.set({'state': 'exited', 'at': ServerValue.timestamp});
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel(); _compassStream?.cancel(); _accelerometerStream?.cancel();
    _incomingRequestsStream?.cancel(); _heartbeatTimer?.cancel(); _radarTimer?.cancel();
    _blockSubscription?.cancel(); _blockedBySubscription?.cancel(); _connectionSubscription?.cancel();
    _headingNotifier.dispose(); _pitchNotifier.dispose(); _scaleNotifier.dispose(); _activeUsersNotifier.dispose(); _introFade.dispose();
    _knockTicker?.cancel(); _knockSecondsLeft.dispose(); _arcFlow.dispose(); _dissolve.dispose();
    _resonanceSubscription?.cancel(); _sparkle.dispose(); _cityMoodTimer?.cancel(); _focusTimer?.cancel(); _gatheringSub?.cancel();
    // 刪除帳號後已登出，不再寫入
    if (FirebaseAuth.instance.currentUser != null) _presenceRef.set({'state': 'exited', 'at': ServerValue.timestamp});
    WidgetsBinding.instance.removeObserver(this); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_locationIssue != _LocationIssue.none && _currentPosition == null) return _buildLocationBlocker();
    if (_currentPosition == null || _mapStyle == null) return const Scaffold(backgroundColor: Night.night900, body: Center(child: Text("正在感知這座城市...", style: TextStyle(color: Night.inkMuted, letterSpacing: 2))));

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
          _scaleNotifier.value = (_baseScale * details.scale).clamp(0.2, 8.0);
          _updateMapCamera();
        },
        child: Stack(
          children: [
            MapLibreMap(
              onMapCreated: (controller) => _mapController = controller,
              onStyleLoadedCallback: _onStyleLoaded, 
              styleString: _mapStyle!,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 12.0, // 進場鏡頭的起點：城市高空
              ),
              // 有大頭貼時由下方的大頭貼標示自己，不再畫系統藍點
              myLocationEnabled: _myAvatarUrl.isEmpty,
              myLocationRenderMode: MyLocationRenderMode.normal,
              compassEnabled: false,
              logoViewMargins: const Point(-100, -100), 
              attributionButtonMargins: const Point(-100, -100), 
            ),

            // 夜光地圖從黑暗中亮起（進場鏡頭期間）
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _introFade,
                builder: (context, _) {
                  final v = Curves.easeInOut.transform(_introFade.value);
                  return v >= 1 ? const SizedBox.shrink() : Container(color: Night.night900.withOpacity(1 - v));
                },
              ),
            ),

            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _introFlying ? 0 : 1,
                duration: const Duration(milliseconds: 600),
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
                      // 夜空：地圖傾斜時，地平線上方漸層成深藍紫的夜空；平放時不顯示
                      Positioned(
                        left: 0, right: 0, top: 0, height: screenHeight * 0.32,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: (smoothPitch / 0.8).clamp(0.0, 1.0),
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                  colors: [Night.night900, Color(0xE61A1446), Color(0x553A1F6B), Color(0x00070B1F)],
                                  stops: [0.0, 0.45, 0.75, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: centerX - 150, top: centerY - 150,  
                        child: Transform(transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateX(smoothPitch), alignment: FractionalOffset.center, child: RadarRipple(moodColor: _getMoodColor(_myMood))),
                      ),

                      // 🌟 完美維持你自己的定位點縮小設定
                      if (_myAvatarUrl.isNotEmpty) 
                        Positioned(
                          left: centerX - 13.5, 
                          top: centerY - 13.5,
                          child: CircleAvatar(
                            radius: 13.5,
                            backgroundColor: Colors.white, 
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(_myAvatarUrl),
                            ),
                          ),
                        ),

                      // 低語信封（畫在氣泡底下）
                      ..._whispers.map((w) {
                        final v = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, w.lat, w.lng, currentHeading, w.id, currentRhythmScore);
                        final d = (v.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6) * currentScale;
                        final a = v.relativeAngle * pi / 180.0;
                        final rx = d * sin(a); final ry = -d * cos(a) * cos(smoothPitch); final rz = -d * cos(a) * sin(smoothPitch);
                        final ww = max(0.01, 1.0 + (rz * 0.002));
                        return Positioned(left: centerX + rx / ww - 22, top: centerY + ry / ww - 22, child: _buildWhisperMarker(w));
                      }),
                      // 敲門中：從自己到對方的流動虛線弧（畫在氣泡底下）
                      if (_ritualTarget != null && _bubbleAnchors[_ritualTarget] != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _arcFlow,
                              builder: (context, _) => CustomPaint(
                                painter: KnockArcPainter(from: Offset(centerX, centerY), to: _bubbleAnchors[_ritualTarget]!, phase: _arcFlow.value),
                              ),
                            ),
                          ),
                        ),
                      ..._buildBubbleLayer(activeUsers, centerX, centerY, screenWidth, screenHeight, smoothPitch, currentHeading, currentScale, currentRhythmScore),
                      // 地圖資料授權要求可見的出處標示（OpenStreetMap ODbL、OpenMapTiles）
                      Positioned(left: 20, bottom: MediaQuery.of(context).padding.bottom + 96, child: const IgnorePointer(child: Text('© OpenMapTiles © OpenStreetMap', style: TextStyle(color: Night.inkFaint, fontSize: 10, letterSpacing: 0.5)))),
                      // 被婉拒、逾時或對方略過：光在對方的位置化成粒子散去
                      if (_dissolveAt != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _dissolve,
                              builder: (context, _) => _dissolve.isAnimating
                                  ? CustomPaint(painter: ParticleBurstPainter(origin: _dissolveAt!, progress: _dissolve.value))
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      // 送出微光：氣泡迸出心情色的光點
                      if (_sparkleAt != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _sparkle,
                              builder: (context, _) => _sparkle.isAnimating
                                  ? CustomPaint(painter: ParticleBurstPainter(origin: _sparkleAt!, progress: _sparkle.value, color: _sparkleColor))
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      // 等待回音的倒數條
                      // 集會的置頂公告，以及等待回音的倒數條（依序排在城市心情下方）
                      if (_ritualTarget != null || _hostedGathering != null || _joinedGathering != null)
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 56, left: Night.space4, right: Night.space4,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            if ((_hostedGathering ?? _joinedGathering) case final g?)
                              GatheringBanner(key: ValueKey('gathering:${g.id}'), gathering: g, myUid: widget.uid, isHost: g.hostUid == widget.uid, onManage: _openGatheringHost),
                            if (_ritualTarget != null) ...[
                              const SizedBox(height: Night.space2),
                              Center(
                                child: ValueListenableBuilder<int>(
                                  valueListenable: _knockSecondsLeft,
                                  builder: (context, left, _) => KnockCountdownPill(secondsLeft: left, totalSeconds: _knockSeconds, targetName: _ritualTargetName),
                                ),
                              ),
                            ],
                          ]),
                        ),
                      // 城市心情天氣
                      Positioned(top: MediaQuery.of(context).padding.top + 10, left: Night.space4, child: _buildCityMoodChip()),
                      // 空雷達：附近沒有人時，不留白，告訴使用者他正在發光
                      if (_hasScanned && activeUsers.isEmpty && !_emptyCardDismissed)
                        Positioned(left: Night.space6, right: Night.space6, bottom: MediaQuery.of(context).padding.bottom + 112, child: _buildEmptyRadarCard()),
                      Positioned(left: Night.space4, right: Night.space4, bottom: MediaQuery.of(context).padding.bottom + 16, child: _buildDock()),
                    ],
                  );
                },
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBubbleUI extends StatefulWidget {
  final String uid; 
  final String moodText; 
  final bool isFavored; 
  final RequestStatus status; 
  final String displayName; 
  final String distanceLabel; 
  final Color baseColor; 
  final bool isShadow; 
  final bool isInactive; // 休息中（鎖屏 / 背景）：可敲門，但降低亮度、停止呼吸光暈
  final bool isDemo; // 示範對象：名字前面加上「示範」
  final String? hostEmoji; // 正在主持集會：「主持」光環，名字前面加上「主持 🌈」
  final double shadowOpacity; 

  const _AnimatedBubbleUI({
    super.key, 
    required this.uid,
    required this.moodText, 
    this.isFavored = false, 
    required this.status, 
    required this.displayName, 
    required this.distanceLabel, 
    required this.baseColor, 
    this.isShadow = false, 
    this.isInactive = false,
    this.isDemo = false,
    this.hostEmoji,
    this.shadowOpacity = 1.0
  });

  @override 
  State<_AnimatedBubbleUI> createState() => _AnimatedBubbleUIState();
}

class _AnimatedBubbleUIState extends State<_AnimatedBubbleUI> with SingleTickerProviderStateMixin {
  AnimationController? _controller;  
  late Animation<double> _glowAnimation;
  // 🌟 串流只建立一次：若在 build 內呼叫 onValue，每一幀都會產生新串流、反覆重新訂閱，大頭貼永遠載不出來
  late Stream<DatabaseEvent> _avatarStream;

  @override 
  void initState() {
    super.initState();
    _avatarStream = FirebaseDatabase.instance.ref('user_avatars/${widget.uid}').onValue;
    // 一律建立 controller：殘影 / 休息中的人回到活躍時，呼吸光暈要能重新亮起
    _controller = AnimationController(vsync: this);
    _setupAnimation();
  }

  void _setupAnimation() {
    if (_controller == null) return;
    bool isPending = widget.status == RequestStatus.pending;
    
    if (widget.isShadow || (widget.isInactive && !isPending)) {
      _controller!.stop();
      _glowAnimation = const AlwaysStoppedAnimation(0.0);
    } else if (isPending) {
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
    if (widget.uid != oldWidget.uid) {
      _avatarStream = FirebaseDatabase.instance.ref('user_avatars/${widget.uid}').onValue;
    }
    if (widget.status != oldWidget.status || widget.isShadow != oldWidget.isShadow || widget.isInactive != oldWidget.isInactive) {
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
    const double avatarSize = 26.0;
    // 氣泡的主色：敲門中＝粉紅，殘影＝灰，其餘＝心情色
    final Color accent = isPending ? Night.knockPink : (widget.isShadow ? Night.shadowInk : widget.baseColor);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        double glowValue = _glowAnimation.value;
        final Color borderColor = widget.isShadow
            ? Night.shadowInk.withOpacity(0.7)
            : accent.withOpacity(isPending ? 0.55 + 0.45 * glowValue : (widget.isFavored ? 0.95 : 0.75));

        return Opacity(
          opacity: widget.isShadow ? widget.shadowOpacity : (widget.isInactive ? 0.62 : 1.0),
          child: SizedBox(
            width: 132,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  painter: SpeechBubblePainter(
                    // 深色玻璃底：任何道路或建築上都讀得清楚
                    color: widget.isFavored ? const Color(0xD91A1F4A) : Night.glassFill,
                    borderColor: borderColor,
                    baseColor: accent,
                    glowValue: (widget.isShadow || widget.isInactive) && !isPending ? 0.0 : glowValue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 17),
                    child: Text(widget.moodText, textAlign: TextAlign.center,
                        style: TextStyle(color: widget.isShadow ? Night.inkMuted : Night.ink, fontSize: 14, height: 1.4)),
                  ),
                ),
                const SizedBox(height: 4),

                StreamBuilder<DatabaseEvent>(
                  stream: _avatarStream,
                  builder: (context, snapshot) {
                    String peerAvatarUrl = '';
                    if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                      peerAvatarUrl = snapshot.data!.snapshot.value.toString();
                    }
                    final Widget fallback = Icon(iconData, color: accent.withOpacity(0.9), size: 16);
                    return Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
                      // 地面漣漪：讓人像「站在」地圖上
                      Positioned(
                        bottom: -6,
                        child: Container(
                          width: 46, height: 14,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.elliptical(23, 7)),
                            border: Border.all(color: accent.withOpacity(widget.isShadow ? 0.3 : 0.55), width: 1.2),
                          ),
                        ),
                      ),
                      // 集會主持人：頭像外一圈亮漸層光環
                      if (widget.hostEmoji != null && !widget.isShadow)
                        Container(
                          width: avatarSize + 10, height: avatarSize + 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(colors: [Night.auroraViolet, Night.auroraBlue, Night.auroraViolet]),
                            boxShadow: [BoxShadow(color: Color(0x734FC3F7), blurRadius: 14)],
                          ),
                        ),
                      Container(
                        width: avatarSize, height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Night.night700,
                          border: Border.all(color: accent, width: 1.5),
                          boxShadow: widget.isShadow ? null : [BoxShadow(color: accent.withOpacity(isPending ? 0.25 + 0.35 * glowValue : 0.35), blurRadius: 12, spreadRadius: 1)],
                        ),
                        child: ClipOval(
                          child: peerAvatarUrl.isNotEmpty
                              ? ColorFiltered(
                                  // 殘影的大頭貼去色，和活躍的人一眼分得出來
                                  colorFilter: widget.isShadow
                                      ? const ColorFilter.matrix(<double>[0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0.33,0.33,0.33,0,0, 0,0,0,1,0])
                                      : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                                  child: Image.network(peerAvatarUrl, width: avatarSize, height: avatarSize, fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => fallback),
                                )
                              : Center(child: fallback),
                        ),
                      ),
                    ]);
                  }
                ),

                const SizedBox(height: 10),
                Text('${widget.hostEmoji != null ? '主持 ${widget.hostEmoji} · ' : ''}${widget.isDemo ? '示範 · ' : ''}${widget.displayName} · ${widget.distanceLabel}${widget.isInactive ? ' · 休息中' : ''}', style: Night.caption.copyWith(shadows: const [Shadow(color: Night.night900, blurRadius: 6)]), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }
    );
  }
}

/// 一顆已經算好畫面位置的氣泡
class _PlacedBubble {
  final Map<String, dynamic> user;
  final BubbleRenderData render;
  final Offset pos;
  final int tier; // 疊層（含剛按住的那顆）
  final int groupTier; // 分群用（不含剛按住的那顆）
  _PlacedBubble(this.user, this.render, this.pos, this.tier, this.groupTier);
  String get uid => user['uid'].toString();
}

/// 展開的群聚：從中心連到每片花瓣的細線
class _PetalStemPainter extends CustomPainter {
  final Offset center;
  final List<Offset> petals;
  final Color color;
  _PetalStemPainter(this.center, this.petals, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1..style = PaintingStyle.stroke;
    for (final p in petals) { canvas.drawLine(center, p + const Offset(0, 8), paint); }
  }

  @override
  bool shouldRepaint(_PetalStemPainter old) => old.center != center || old.petals != petals || old.color != color;
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
    final borderPaint = Paint()..color = borderColor..strokeWidth = 1.5..style = PaintingStyle.stroke;
    
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height - 8.0), const Radius.circular(16.0)))
      ..moveTo(size.width / 2 - 6.0, size.height - 8.0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 + 6.0, size.height - 8.0)
      ..close();
      
    canvas.drawPath(path, paint);
    if (borderColor != Colors.transparent) canvas.drawPath(path, borderPaint);
  }
  
  @override 
  bool shouldRepaint(covariant SpeechBubblePainter oldDelegate) => 
      oldDelegate.glowValue != glowValue || oldDelegate.baseColor != baseColor || oldDelegate.borderColor != borderColor || oldDelegate.color != color;
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