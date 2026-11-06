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
import 'location_consent.dart';
import 'mood_card.dart';
import 'mood_trail.dart';
import 'mood_place.dart';
import 'package:characters/characters.dart';
import 'gathering.dart';
import 'time_whisper.dart';
import 'beacon.dart';
import 'gathering_keys.dart';
import 'guide_screen.dart';
import 'manual_location_picker.dart';
import 'whispers.dart';
import 'nightly_reminder.dart';
import 'report_sheet.dart';
import 'l10n/l10n.dart';
import 'parallel_universe.dart';
import 'quantum_live.dart';
import 'quantum_meet.dart';
import 'quantum_newyear.dart';
import 'quantum_orb.dart';
import 'quantum_world.dart';
import 'aiya/aiya_cameo.dart';
import 'aiya/aiya_screen.dart';
import 'aiya/aiya_store.dart';
import 'whisper_group/whisper_group.dart';
import 'package:app_links/app_links.dart';
import 'translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'hidden_content.dart';
import 'ui/knock_ritual.dart';
import 'ui/night.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'dart:ui' as ui; 

enum RequestStatus { none, pending, accepted }

/// 定位無法使用的原因：服務關閉、未授權、永久拒絕、只給大概位置、抓不到位置
enum _LocationIssue { none, serviceOff, denied, deniedForever, reduced, noFix }

Color _getMoodColor(String mood) => mood.isEmpty ? Night.moodDefault : moodStyleOf(mood).$2;

// 夜光地圖樣式：由 tool/build_night_map_style.py 從 dark-matter 重新上色、圖資用 OpenFreeMap，內建在 App 裡
const String _nightStyleAsset = 'assets/map/night_style.json';
const String _updateLocationUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/updateLocation';
const String _getNearbyUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/getNearby';
const String _deleteAccountUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/deleteAccount';
const String _cityMoodUrl = 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/getCityMood';

// 城市心情天氣的分類，與伺服器 geo-service/citymood.js 一致
Map<String, (String, Color)> get _cityMoodStyle => {
  'joy': (tr.moodJoy, Night.moodJoy),
  'sad': (tr.moodSad, Night.moodSad),
  'angry': (tr.moodAngry, Night.moodAngry),
  'calm': (tr.moodCalm, Night.moodCalm),
  'passion': (tr.moodPassion, Night.moodPassion),
  'love': (tr.moodLove, Night.moodLove),
  'other': (tr.moodOther, Night.moodDefault),
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

  await loadAppLocale();
  await loadParallelUniverse();
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
    return ValueListenableBuilder<Locale?>(
      valueListenable: appLocale,
      builder: (context, locale, _) => MaterialApp(
      onGenerateTitle: (context) => tr.appName,
      locale: locale,
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: resolveLocale,
      // 語言改變時更新 tr，讓不在 widget 裡的程式也拿得到目前語言的文字
      builder: (context, child) {
        tr = AppLocalizations.of(context);
        return child!;
      },
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Night.night900,
        useMaterial3: true,
      ),
      // AIYA_MOCK 只在本機測試艾婭畫面時開啟（假資料、不連伺服器），上架版本不會帶
      home: aiyaCameoTest ? const AiyaCameoTestScreen() : aiyaDirect ? const AiyaScreen() : ageBlocked ? const AgeBlockedScreen() : (hasSeenIntro ? const LoginScreen() : const IntroScreen()),
      ),
    );
  }
}

class BlankCanvasScreen extends StatefulWidget {
  final String uid;
  final String initialMood;

  /// 使用者在進入畫面按了「在這裡打卡」：拿到位置後立刻打卡
  final bool checkIn;
  const BlankCanvasScreen({super.key, required this.uid, required this.initialMood, this.checkIn = false});

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
  bool _locationServicesStarted = false; // 已打卡：在線狀態、雷達與位置回報都在運作
  // 打卡（App Store 5.1.2）：每次打開 App 都要自己按「在這裡打卡」才會出現在地圖上，不會自動打卡。
  // 別人看到的是打卡當下的位置；走遠了要再打卡一次才會更新。在背景超過 30 分鐘回來也要重新打卡。
  Position? _checkInPosition;
  static const _checkInMoveMeters = 1000.0;
  late bool _checkInRequested = widget.checkIn;
  // 按下「在這裡打卡」後的載入畫面至少停留幾秒，讓人讀完「城市太安靜時去平行宇宙／量子世界」的提示
  static const _sensingMinDuration = Duration(seconds: 4);
  late bool _sensingHold = widget.checkIn;
  // 進場鏡頭：從城市高空俯衝到街道，期間暫停羅盤與仰角對鏡頭的更新
  bool _introFlying = true;
  late final AnimationController _introFade = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
  bool _hasScanned = false; // 至少完成過一次雷達掃描（決定是否顯示「你是今晚第一道光」）
  bool _emptyCardDismissed = false; // 「你是今晚第一道光」卡片這次打卡不再顯示
  // 這張卡片一天最多出現一次：打卡在離開 App 時就結束，回來重新打卡時不要一直跳出來
  static const _emptyCardDayKey = 'emptyRadarCardDay';
  String? _emptyCardSeenDay;
  static String _today() { final n = DateTime.now(); return '${n.year}-${n.month}-${n.day}'; }
  Future<void> _loadEmptyCardDay() async {
    final day = (await SharedPreferences.getInstance()).getString(_emptyCardDayKey);
    if (!mounted) return;
    setState(() { _emptyCardSeenDay = day; if (day == _today()) _emptyCardDismissed = true; });
  }
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

  // ---------- 量子世界 ----------
  QuantumWalk? _quantumWalk; // 入場那一刻的真實位置：只用來算走了多遠
  ({double east, double north})? _quantumLastSent; // 上一次送給伺服器的位移
  Position? _quantumFix; // 最近一次精度夠好的定位：量子世界的位移只用它算，室內飄移、瞬間跳點不算數
  List<List<double>> _quantumDots = []; // 世界視角的遠方光點
  List<({double lat, double lng})> _quantumBursts = []; // 正在播放塌縮動畫的位置
  bool _quantumSelfCollapse = false;
  final Set<String> _seenCollapses = {};
  bool _quantumBusy = false;
  bool _quantumLeaving = false; // 塌縮動畫播放中：不再送心跳，也不重複離開
  static const _quantumWorldScale = 0.34; // 縮到比這更小就是世界視角（約 5 公里以外）
  String _quantumEntryCode = ''; // 入場儀式最後亮起的席位代號
  static const _quantumMaxAccuracy = 30.0; // 公尺：定位誤差比這大就不拿來算走了多遠
  late final AnimationController _quantumEntry = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
  late final AnimationController _quantumCollapse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final AnimationController _quantumGlow = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  // 第二期：讓世界活起來
  List<QuantumPartner> _quantumPartners = []; // 糾纏中的人：不管多遠都畫一道光線
  bool _quantumTunneled = false; // 這次入場已經穿隧過
  bool _quantumReform = false; // 穿隧：在新席位重組
  final Set<String> _quantumChatted = {}; // 這次入場聊過天的人，才能邀請糾纏
  final Set<String> _shownInvites = {};
  final List<QuantumFlight> _quantumFlights = []; // 飛向原點的報時微光
  final Set<String> _seenChimeFx = {};
  int _chimeCount = 0;
  int _chimeHour = -1; // 這次報時的編號：換整點就重來
  bool _chimeSent = false;
  bool _chimeWatchedShown = false;
  int _newYearCount = 0; // 量子跨年：台北午夜前後一起在量子世界的人數
  bool _nyTogetherShown = false;
  int? _nyZoneShown; // 剛跨年的時區：每個時區只提示一次
  final Map<String, QuantumMeetPerson> _meetAsked = {}; // 我邀請製作相遇卡的人：對方同意時用這份資料做卡
  final Set<String> _meetShown = {}; // 已經跳出過的相遇卡邀請
  int _quantumClockTicks = 0;
  Timer? _quantumClock;
  QuantumChimeBell? _chimeBell;
  final Map<String, int> _resonanceUntil = {}; // 共振光環：uid → 結束時間
  final List<QuantumSignalFloat> _signalFloats = [];
  List<StreamSubscription<DatabaseEvent>> _signalSubs = [];
  Map<String, int> _glimmersReceived = {}; // resonance/{我}：誰在什麼時候送了微光

  /// 雷達中心：平常是自己的真實位置；在量子世界是自己的顯示位置（席位＋走過的位移），兩次心跳之間依手機算的位移平順移動
  ({double lat, double lng}) get _radarCenter {
    final pos = _currentPosition!;
    final s = quantumSession.value;
    if (s == null) return (lat: pos.latitude, lng: pos.longitude);
    var lat = s.lat, lng = s.lng;
    final walk = _quantumWalk, sent = _quantumLastSent, fix = _quantumFix;
    if (walk != null && sent != null && fix != null) {
      final raw = walk.at(fix.latitude, fix.longitude);
      final dE = raw.east - sent.east, dN = raw.north - sent.north;
      if (dE * dE + dN * dN < 300 * 300) {
        lat += dN / 111320;
        lng += dE / (111320 * cos(lat * pi / 180));
      }
    }
    return (lat: lat, lng: lng);
  }

  // ---------- 集會 ----------
  StreamSubscription<List<Gathering>>? _gatheringSub;
  StreamSubscription<DatabaseEvent>? _handoffOfferSub;
  bool _handoffOfferShowing = false;
  String? _lastHostedGid; // 上一次我主持的活動：被交棒出去時自動把圖標補進稱呼
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
    final joined = _gatherings.where((g) => g.hostUid != widget.uid && !_blockedUids.contains(g.hostUid) && !_blockedByUids.contains(g.hostUid) && !HiddenContent.instance.users.contains(g.hostUid) && g.includes(_myNickname, pos.latitude, pos.longitude)).toList()
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
        if (ended.hostUid != widget.uid) showGlassToast(context, tr.gatheringEnded(ended.emoji, ended.name), icon: Icons.nights_stay_outlined);
      }
      setState(() => _gatherings = list);
      _checkHandedOff(list);
      for (final g in [_hostedGathering, _joinedGathering]) { if (g != null) _shownGatherings[g.id] = g; }
    }, onError: (e) => debugPrint('gatherings listen failed: $e'));
  }

  /// 我主持的活動還在、但主持人換成別人：我交棒出去了 → 把圖標補進稱呼，繼續當參加者
  void _checkHandedOff(List<Gathering> list) {
    final hosted = _hostedGathering;
    final previous = _lastHostedGid;
    _lastHostedGid = hosted?.id;
    if (hosted != null || previous == null) return;
    final g = list.where((e) => e.id == previous).firstOrNull;
    if (g == null) return; // 活動結束了，不是交棒
    if (emojiKeysIn(_myNickname).contains(g.emojiKey)) {
      showGlassToast(context, tr.handedOffStillJoined(g.emoji, g.name), icon: Icons.campaign_outlined);
      return;
    }
    final updated = '$_myNickname${g.emoji}';
    if (updated.characters.length > 10) {
      showGlassToast(context, tr.handedOffNicknameFull(g.emoji), icon: Icons.campaign_outlined);
      return;
    }
    _saveNickname(updated);
    showGlassToast(context, tr.handedOffEmojiAdded(g.emoji), icon: Icons.campaign_outlined);
  }

  Future<void> _saveNickname(String nickname) async {
    setState(() => _myNickname = nickname);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_nickname', nickname);
    try { await _dbRef.child('profiles/${widget.uid}/nickname').set(nickname); } catch (e) { debugPrint('nickname write failed: $e'); }
    if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
  }

  /// 有人邀請我接下主持
  void _listenToHandoffOffers() {
    _handoffOfferSub?.cancel();
    _handoffOfferSub = _dbRef.child('gatheringHandoffs/${widget.uid}').onValue.listen((event) {
      final offer = event.snapshot.value;
      if (offer is! Map || !mounted || _handoffOfferShowing) return;
      final expiresAt = (offer['expiresAt'] as num?)?.toInt() ?? 0;
      if (expiresAt < DateTime.now().millisecondsSinceEpoch) return;
      _handoffOfferShowing = true;
      showHandoffOffer(context, offer).whenComplete(() => _handoffOfferShowing = false);
    }, onError: (e) => debugPrint('handoff offers listen failed: $e'));
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
  // 低語穿越：寫給未來的自己，只有我看得到
  List<TimeWhisper> _timeWhispers = [];
  final Set<String> _timeWhisperTried = {}; // 這次開啟期間已嘗試打開的，避免重複跳出
  bool _timeWhisperShowing = false;
  // 城市燈塔：附近的友善公廁（開關與篩選記在手機上）
  bool _beaconOn = false;
  final Set<BeaconFeature> _beaconFilters = {};
  List<BeaconToilet> _beaconToilets = [];
  Position? _beaconFetchedAt;
  bool _beaconLoading = false;
  // 心情據點：營業中、在店門口 150 公尺內的店（只在手機上判斷）
  final Set<String> _nearPlaces = {};
  final Set<String> _seenWhisperIds = {};
  bool _whispersLoaded = false;
  int _radarTick = 0;
  // 最近一次「有動靜」：手指碰螢幕或位置移動。靜止超過 1 分鐘，雷達改成每 30 秒更新（省伺服器請求）
  DateTime _lastRadarActivity = DateTime.now();
  void _markRadarActive() => _lastRadarActivity = DateTime.now();
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
    if (_sensingHold) Future.delayed(_sensingMinDuration, () { if (mounted) setState(() => _sensingHold = false); });
    WidgetsBinding.instance.addObserver(this); 
    _myMood = widget.initialMood; 
    _loadProfileData(); 
    _loadEmptyCardDay();
    _coolingSystem.loadRejections();
    _loadBeaconPrefs();
    _loadMoodPlaces();
    HiddenContent.instance.addListener(_onHiddenContentChanged);
    HiddenContent.instance.load();
    quantumSession.value = null; // 每次打開 App 都從一般雷達開始
    quantumSession.addListener(_onQuantumChanged);
    QuantumPrefs.load().then((_) => QuantumChimeReminder.reschedule());
    // 量子化身：聽商店的購買結果（包含上次沒完成的交易），讀自己買過的款式
    OrbStore.init();
    AiyaStore.init();
    AiyaPrefs.load();
    MapConsent.load();
    // 低語團：讀自己目前所在的團（不在團裡就不顯示地圖按鈕）、聽購買結果、聽分享連結／QR code
    GroupPassStore.init();
    WhisperGroup.createAndroidChannel();
    WhisperGroup.refresh();
    WhisperGroup.incomingCall.addListener(_onWgIncomingCall);
    WhisperGroup.incomingRoll.addListener(_onWgIncomingRoll);
    _listenGroupLinks();
    OrbPrefs.load().then((_) => OrbStore.loadOwned());
    rootBundle.loadString(_nightStyleAsset).then((style) { if (mounted) setState(() => _mapStyle = style); });
    _listenToBlockLists(); 
    _audioPlayer.setSource(AssetSource('audio/knock.mp3'));
    
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

  /// 使用者按下打卡按鈕：沒同意過在地圖上顯示位置就先問（可以拒絕），同意才打卡
  Future<void> _tapCheckIn() async {
    if (!await ensureMapConsent(context) || !mounted) return;
    _checkIn();
  }

  /// 打卡：把此刻的位置公開在地圖上，啟動在線狀態與雷達。只由使用者按下按鈕觸發。
  void _checkIn() {
    if (!MapConsent.allowed.value) { _checkInRequested = false; return; }
    final pos = _currentPosition;
    if (pos == null) return;
    _checkInRequested = false;
    setState(() { _checkInPosition = pos; _emptyCardDismissed = _emptyCardSeenDay == _today(); });
    if (!_locationServicesStarted) {
      _locationServicesStarted = true;
      _initPresence();
      _startRadarSweep();
    }
    _updateMyLocationToServer(pos);
    _checkPlaces();
  }

  /// 結束打卡：使用者按下「結束打卡」或切到背景。伺服器標記為已離開，立刻從別人的地圖上消失
  void _checkOut() {
    _presenceRef.onDisconnect().cancel().catchError((_) {});
    _presenceRef.set({'state': 'exited', 'at': ServerValue.timestamp}).catchError((_) {});
    _endCheckIn();
  }

  /// 打卡結束：停止回報與掃描，雷達清空，等使用者重新打卡
  void _endCheckIn() {
    if (quantumOn) _resetQuantum();
    _heartbeatTimer?.cancel(); _radarTimer?.cancel(); _cityMoodTimer?.cancel();
    _locationServicesStarted = false;
    _activeUsersNotifier.value = [];
    setState(() { _checkInPosition = null; _hasScanned = false; _whispers = []; _nearPlaces.clear(); });
  }

  bool get _movedFarFromCheckIn {
    final from = _checkInPosition, now = _currentPosition;
    if (from == null || now == null) return false;
    return Geolocator.distanceBetween(from.latitude, from.longitude, now.latitude, now.longitude) > _checkInMoveMeters;
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

  void _listenToBlockLists() {
    _listenToGatherings();
    _listenToHandoffOffers();
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
    if (mounted) showGlassToast(context, tr.blockedToast, icon: Icons.block, danger: true);
  }

  Future<void> _unblockUser(String targetUid) async {
    await _dbRef.child('blocks/${widget.uid}/$targetUid').remove();
    await _dbRef.child('blockedBy/$targetUid/${widget.uid}').remove();
    if (mounted) showGlassToast(context, tr.unblockedToast, icon: Icons.nights_stay_outlined);
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
      // 點推播打開 App：低語團的通知直接打開低語團面板
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _openFromPush(m.data));
      FirebaseMessaging.instance.getInitialMessage().then((m) { if (m != null) _openFromPush(m.data); });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // 低語團：重新整理；集合呼叫會跳出全螢幕卡片，不另外顯示提示
        if ('${message.data['type']}'.startsWith('wgroup_')) {
          WhisperGroup.onPush(message.data);
          if (message.data['type'] == 'wgroup_call' || message.data['type'] == 'wgroup_roll') return;
        }
        // 正在和這個人聊天時，訊息已經出現在聊天室裡，不再重複跳出提示
        if (message.data['type'] == 'chat_message' && message.data['roomId'] == ChatScreen.activeRoomId) return;
        if (message.notification != null && mounted) {
          showGlassToast(context, tr.notificationToast(message.notification!.title ?? '', message.notification!.body ?? ''), icon: Icons.chat_bubble_outline);
        }
      });
    }
  }

  // ---------- 低語團 ----------
  StreamSubscription<Uri>? _linkSub;
  bool _wgOverlayOpen = false;

  /// QR code／分享連結：https://mood-whisper-f7de9.web.app/g/<團代碼>?v=<版本>
  void _listenGroupLinks() {
    final links = AppLinks();
    void handle(Uri? uri) {
      final parsed = uri == null ? null : WhisperGroup.parseLink(uri);
      if (parsed == null || !mounted) return;
      joinWhisperGroup(context, parsed.$1, parsed.$2);
    }
    links.getInitialLink().then(handle).catchError((_) {});
    _linkSub = links.uriLinkStream.listen(handle, onError: (_) {});
  }

  void _openFromPush(Map<String, dynamic> data) {
    if (!'${data['type']}'.startsWith('wgroup_')) return;
    WhisperGroup.refresh().then((_) { if (mounted && WhisperGroup.current.value != null) showWhisperGroupPanel(context); });
  }

  /// 前景收到集合呼叫：全螢幕卡片＋震動
  void _onWgIncomingCall() {
    final call = WhisperGroup.incomingCall.value;
    if (call == null || !mounted || _wgOverlayOpen) return;
    WhisperGroup.incomingCall.value = null;
    _wgOverlayOpen = true;
    showWgCallOverlay(context, call).whenComplete(() => _wgOverlayOpen = false);
  }

  /// 前景收到點名：全螢幕卡片＋震動（和集合呼叫一樣明顯）
  void _onWgIncomingRoll() {
    final rollId = WhisperGroup.incomingRoll.value;
    if (rollId == null || !mounted || _wgOverlayOpen) return;
    WhisperGroup.incomingRoll.value = null;
    _wgOverlayOpen = true;
    showWgRollOverlay(context, rollId).whenComplete(() => _wgOverlayOpen = false);
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
      if (event.snapshot.value == true && _isInForeground && _locationServicesStarted) _setPresence('active');
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
      final center = _radarCenter;

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(center.lat, center.lng),
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
    _checkPlaces();
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

  // 測試用（--dart-define=FORCE_NO_FIX=true）：假裝完全抓不到定位，用來測試「在地圖上選擇位置」
  static const _forceNoFix = bool.fromEnvironment('FORCE_NO_FIX');

  void _startPositionUpdates() {
    if (_forceNoFix) { if (_currentPosition == null) _setLocationIssue(_LocationIssue.noFix); return; }
    _positionStream ??= Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2)).listen(
      (Position newPosition) {
        if (!mounted) return;
        setState(() {
          _currentPosition = newPosition;
          if (newPosition.accuracy <= _quantumMaxAccuracy) _quantumFix = newPosition;
          if (_locationIssue == _LocationIssue.noFix) _locationIssue = _LocationIssue.none;
        });
        _markRadarActive();
        _updateMapCamera();
        if (_checkInRequested) _checkIn();
        _checkTimeWhispers();
        _maybeFetchBeacon();
        _checkPlaces();
        MoodPlaces.refresh().then((changed) { if (changed && mounted) { setState(() {}); _checkPlaces(); } });
      },
      onError: (dynamic error) => debugPrint('position stream error: $error'),
      cancelOnError: false,
    );
    if (_currentPosition != null) return;
    _acquireFirstFix();
  }

  /// 第一個定位，一層一層退：精確定位 10 秒 → 系統最近一次的位置 → 說明頁，同時背景再用低精度（Wi-Fi／基地台）試 30 秒。
  /// 沒有 GPS 的 iPad、室內訊號弱時精確定位常常拿不到，但低精度通常拿得到；真的都拿不到，說明頁可以在地圖上手動選位置。
  Future<void> _acquireFirstFix() async {
    void use(Position position) {
      if (!mounted || _currentPosition != null) return;
      setState(() {
        _currentPosition = position;
        if (_locationIssue == _LocationIssue.noFix) _locationIssue = _LocationIssue.none;
      });
      if (_checkInRequested) _checkIn();
    }
    try {
      return use(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10)));
    } catch (e) {
      debugPrint('initial position (high) failed: $e');
    }
    if (_currentPosition != null) return;
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return use(last);
    } catch (e) {
      debugPrint('last known position failed: $e');
    }
    if (!mounted || _currentPosition != null) return;
    _setLocationIssue(_LocationIssue.noFix);
    try {
      use(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low, timeLimit: const Duration(seconds: 30)));
    } catch (e) {
      debugPrint('initial position (low) failed: $e');
    }
  }

  /// 手動選位置：定位一直拿不到時的備案。之後真的定位到了，位置串流會自動換成真實位置
  Future<void> _pickLocationManually() async {
    final style = _mapStyle ?? await rootBundle.loadString(_nightStyleAsset);
    if (!mounted) return;
    final picked = await Navigator.push<LatLng>(context, MaterialPageRoute(
      builder: (_) => ManualLocationPicker(mapStyle: style, initial: const LatLng(25.0478, 121.5170)), // 台北車站
    ));
    if (picked == null || !mounted || _currentPosition != null) return;
    setState(() {
      _currentPosition = Position(latitude: picked.latitude, longitude: picked.longitude, timestamp: DateTime.now(),
          accuracy: 50, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
      _locationIssue = _LocationIssue.none;
    });
    if (_checkInRequested) _checkIn();
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
      _LocationIssue.serviceOff => (Icons.location_off_outlined, tr.locationServiceOffTitle, tr.locationServiceOffBody),
      _LocationIssue.reduced => (Icons.my_location, tr.locationReducedTitle,
          Platform.isIOS ? tr.locationReducedBodyIos
                         : tr.locationReducedBodyAndroid),
      _LocationIssue.noFix => (Icons.gps_not_fixed, tr.locationNoFixTitle, tr.locationNoFixBody),
      _ => (Icons.location_off_outlined, tr.locationNeededTitle,
          tr.locationNeededBody),
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
                  Text(tr.locationSimulatorHint, style: Night.caption, textAlign: TextAlign.center),
                ],
                const SizedBox(height: Night.space6),
                if (needsSettings)
                  NightButton(tr.openSettings, icon: Icons.settings_outlined, expand: true, onPressed: () {
                    issue == _LocationIssue.serviceOff ? Geolocator.openLocationSettings() : Geolocator.openAppSettings();
                  }),
                if (needsSettings) const SizedBox(height: Night.space2),
                NightButton(needsSettings ? tr.locationRecheck : tr.tryAgain, kind: needsSettings ? NightButtonKind.ghost : NightButtonKind.primary,
                    icon: Icons.refresh, expand: true, onPressed: () {
                  if (issue == _LocationIssue.noFix) _setLocationIssue(_LocationIssue.none);
                  _checkLocation();
                }),
                if (issue == _LocationIssue.noFix) ...[
                  const SizedBox(height: Night.space2),
                  NightButton(tr.locationPickOnMap, kind: NightButtonKind.ghost, icon: Icons.map_outlined, expand: true, onPressed: _pickLocationManually),
                ],
                if (Platform.isAndroid) ...[
                  const SizedBox(height: Night.space2),
                  NightButton(tr.leaveApp, kind: NightButtonKind.text, expand: true, onPressed: () => SystemNavigator.pop()),
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
      'Accept-Language': currentLanguageTag,
      if (idToken != null) 'Authorization': 'Bearer $idToken',
    };
  }

  /// 回報位置與心情（也是「活躍」心跳）。只在打卡後送出，而且一律送打卡當下的位置，不會跟著移動更新。
  Future<void> _updateMyLocationToServer(Position _) async {
    // 伺服器把這個呼叫視為「活躍」心跳，背景時（例如 Android 背景定位回呼）不可送出
    // 在量子世界：不回報真實位置，改送一次心跳（例如剛改了心情）
    if (quantumOn) return _quantumBeat();
    final position = _checkInPosition;
    if (!_isInForeground || !_locationServicesStarted || position == null) return;
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
          'parallel': parallelUniverseOn.value,
        }),
      );
    } catch (e) {}
  }

  void _startRadarSweep() {
    _fetchNearbyUsers(); 
    _radarTimer?.cancel();
    _radarTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final idle = DateTime.now().difference(_lastRadarActivity) > const Duration(minutes: 1);
      if (!idle || _radarTick % 3 == 2) _fetchNearbyUsers(); // 有動靜時每 10 秒，靜止時每 30 秒
      if (++_radarTick % 3 == 0) _fetchWhispers(); // 低語每 30 秒更新一次
      if (_radarTick % 30 == 0) _fetchTimeWhispers(); // 低語穿越每 5 分鐘更新一次
    });
    _fetchWhispers();
    _fetchTimeWhispers();
    _fetchCityMood();
    _cityMoodTimer?.cancel();
    _cityMoodTimer = Timer.periodic(const Duration(minutes: 5), (_) => _fetchCityMood());
  }

  Future<void> _fetchWhispers() async {
    if (_currentPosition == null || !_isInForeground || quantumOn) return; // 量子世界裡沒有低語
    final list = (await WhisperApi.list(_currentPosition!.latitude, _currentPosition!.longitude))
        .where((w) => !HiddenContent.instance.whispers.contains(w.id)) // 檢舉過的低語不再出現
        .toList();
    if (!mounted) return;
    final fresh = list.where((w) => !w.mine && !_seenWhisperIds.contains(w.id)).toList();
    _seenWhisperIds.addAll(list.map((w) => w.id));
    setState(() => _whispers = list);
    if (fresh.isEmpty) return;
    HapticFeedback.lightImpact();
    showGlassToast(context,
        !_whispersLoaded && fresh.length > 1 ? tr.whispersNearby(fresh.length) : tr.whisperPassed,
        icon: Icons.mail_outline);
    _whispersLoaded = true;
  }

  Future<void> _composeWhisper() async {
    if (_currentPosition == null) return;
    final result = await showWhisperComposer(context, lat: _currentPosition!.latitude, lng: _currentPosition!.longitude, mood: _myMood);
    if (result == null || !mounted) return;
    if (result == 'whisper') {
      showGlassToast(context, tr.whisperLeft, icon: Icons.mail_outline);
      _fetchWhispers();
    } else {
      showGlassToast(context, (result == 'year' ? tr.timeWhisperSealedYear : tr.timeWhisperSealedMonth), icon: Icons.hourglass_bottom);
      _fetchTimeWhispers();
    }
  }

  /// 檢舉後立刻把那個人、那則低語從畫面移除，不等下一次更新
  void _onHiddenContentChanged() {
    if (!mounted) return;
    final hidden = HiddenContent.instance;
    _activeUsersNotifier.value = _activeUsersNotifier.value.where((u) => !hidden.users.contains(u['uid'])).toList();
    setState(() {
      _whispers = _whispers.where((w) => !hidden.whispers.contains(w.id)).toList(); // 集會的置頂公告由 build 依隱藏清單重新判斷
    });
  }

  // ---------- 城市燈塔 ----------
  static const _beaconRefetchMeters = 300.0;

  Future<void> _loadMoodPlaces() async {
    await PlaceHints.load();
    await MoodPlaces.refresh(force: true);
    if (!mounted) return;
    setState(() {});
    _checkPlaces();
  }

  /// 心情據點：已打卡、在前景時，找出營業中、150 公尺內的店（走出 170 公尺才熄，避免定位飄動時一直閃）。
  /// 剛走進某家店的範圍時，在 App 裡輕聲提示一次；頻率限制在 PlaceHints（同一家 7 天一次、一天最多 2 次）。
  void _checkPlaces() {
    final pos = _currentPosition;
    // 進場鏡頭還在飛時先不亮燈、不提示，飛完再判斷一次
    if (pos == null || !_locationServicesStarted || !_isInForeground || _introFlying || quantumOn) return; // 量子世界裡沒有心情據點
    final now = DateTime.now();
    final near = <String>{};
    final entered = <(MoodPlace, double)>[];
    for (final p in MoodPlaces.places) {
      if (!p.isOpen(now)) continue;
      final d = Geolocator.distanceBetween(pos.latitude, pos.longitude, p.lat, p.lng);
      final wasNear = _nearPlaces.contains(p.id);
      if (d > (wasNear ? MoodPlaces.leaveMeters : MoodPlaces.nearMeters)) continue;
      near.add(p.id);
      if (!wasNear) entered.add((p, d));
    }
    if (near.length != _nearPlaces.length || !near.containsAll(_nearPlaces)) setState(() => _nearPlaces..clear()..addAll(near));
    entered.sort((a, b) => a.$2.compareTo(b.$2));
    for (final (p, _) in entered) {
      if (!PlaceHints.canHint(p.id, now)) continue;
      PlaceHints.recordHint(p.id, now);
      showPlaceHint(context, p, onOpen: () => _openPlace(p));
      break;
    }
  }

  /// 心情據點的小燈：保留真實方向，預設比例下離中心至少 72 像素（不壓在自己的頭像上），再跟著雙指縮放等比例移動；營業時間過了就熄。
  /// [seen] 選今天看過名片的（背景柔光）或還在呼吸的（畫在氣泡上面）；兩組在同一個 Stack 裡，靠 key 保留狀態。
  Iterable<Widget> _placeLamps({required bool seen, required double centerX, required double centerY, required double screenHeight,
      required double pitch, required double heading, required double scale, required double rhythm}) {
    final now = DateTime.now();
    return MoodPlaces.places.where((p) => _nearPlaces.contains(p.id) && p.isOpen(now) && PlaceHints.seenToday(p.id, now) == seen).map((p) {
      final v = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, p.lat, p.lng, heading, p.id, rhythm);
      final d = max(MoodPlaces.minRadiusPx, (v.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6)) * scale;
      final a = v.relativeAngle * pi / 180.0;
      final rx = d * sin(a); final ry = -d * cos(a) * cos(pitch); final rz = -d * cos(a) * sin(pitch);
      final ww = max(0.01, 1.0 + (rz * 0.002));
      return Positioned(
        key: ValueKey('place:${p.id}'),
        left: centerX + rx / ww - 22, top: centerY + ry / ww - 22,
        child: MoodPlaceLamp(place: p, breathing: !seen, onTap: () => _openPlace(p)),
      );
    });
  }

  // 打開名片後，這盞燈今天改成靜止的柔光
  void _openPlace(MoodPlace p) {
    final pos = _currentPosition;
    showMoodPlaceCard(context, p, here: pos == null ? null : (lat: pos.latitude, lng: pos.longitude), myUid: widget.uid)
        .then((_) { if (mounted) setState(() {}); });
  }

  Future<void> _loadBeaconPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final filters = prefs.getStringList('beacon_filters') ?? const [];
    if (!mounted) return;
    setState(() {
      _beaconOn = prefs.getBool('beacon_on') ?? false;
      _beaconFilters.addAll(BeaconFeature.values.where((f) => filters.contains(f.name)));
    });
    _maybeFetchBeacon();
  }

  Future<void> _saveBeaconPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('beacon_on', _beaconOn);
    await prefs.setStringList('beacon_filters', _beaconFilters.map((f) => f.name).toList());
  }

  /// 打開時才抓；走超過 300 公尺再抓一次
  Future<void> _maybeFetchBeacon({bool force = false}) async {
    final pos = _currentPosition;
    if (!_beaconOn || pos == null || _beaconLoading || !_isInForeground) return;
    final last = _beaconFetchedAt;
    if (!force && last != null && Geolocator.distanceBetween(last.latitude, last.longitude, pos.latitude, pos.longitude) < _beaconRefetchMeters) return;
    _beaconLoading = true;
    final list = await BeaconApi.nearby(pos.latitude, pos.longitude);
    _beaconLoading = false;
    if (!mounted || list == null) return;
    _beaconFetchedAt = pos;
    setState(() => _beaconToilets = list);
  }

  void _toggleBeacon() {
    HapticFeedback.selectionClick();
    setState(() => _beaconOn = !_beaconOn);
    _saveBeaconPrefs();
    if (_beaconOn) {
      _maybeFetchBeacon(force: true);
    } else {
      setState(() { _beaconToilets = []; _beaconFetchedAt = null; });
    }
  }

  void _toggleBeaconFilter(BeaconFeature f) {
    HapticFeedback.selectionClick();
    setState(() => _beaconFilters.contains(f) ? _beaconFilters.remove(f) : _beaconFilters.add(f));
    _saveBeaconPrefs();
  }

  /// 沒選篩選就全部顯示；有選就顯示符合任一種的
  List<BeaconToilet> get _visibleBeaconToilets =>
      _beaconFilters.isEmpty ? _beaconToilets : _beaconToilets.where((t) => _beaconFilters.any(t.has)).toList();

  // ---------- 低語穿越 ----------
  Future<void> _fetchTimeWhispers() async {
    if (!_isInForeground) return;
    final list = await TimeWhisperApi.list();
    if (!mounted) return;
    setState(() => _timeWhispers = list);
    _checkTimeWhispers();
  }

  /// 解封、還沒打開、人在 100 公尺內 → 打開並跳出來
  Future<void> _checkTimeWhispers() async {
    final pos = _currentPosition;
    if (pos == null || _timeWhisperShowing || !_isInForeground || quantumOn) return;
    for (final w in _timeWhispers) {
      if (w.opened || !w.isUnlocked || _timeWhisperTried.contains(w.id)) continue;
      if (w.metersFrom(pos.latitude, pos.longitude) > timeWhisperOpenMeters) continue;
      _timeWhisperTried.add(w.id);
      _timeWhisperShowing = true;
      final (opened, error) = await TimeWhisperApi.open(w.id, pos.latitude, pos.longitude);
      if (!mounted) return;
      if (opened == null) {
        _timeWhisperShowing = false;
        debugPrint('time whisper open failed: $error');
        continue;
      }
      HapticFeedback.mediumImpact();
      setState(() => _timeWhispers.removeWhere((x) => x.id == w.id)); // 伺服器已刪除：只讀一次
      await showTimeWhisperReader(context, opened);
      _timeWhisperShowing = false;
      return;
    }
  }

  /// 雷達上我的低語穿越（只有我看得到）：上鎖／解鎖的沙漏，畫在最底層、不能按，也不擋別人的訊息
  Widget _buildTimeWhisperMarker(TimeWhisper w) {
    final color = w.isUnlocked ? Night.auroraViolet : Night.inkFaint;
    return IgnorePointer(
      child: Opacity(
        opacity: 0.75,
        child: Container(
          width: 26, height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Night.night800,
            border: Border.all(color: color, width: 1.2),
            boxShadow: w.isUnlocked ? [BoxShadow(color: color.withOpacity(0.45), blurRadius: 10)] : null,
          ),
          child: Icon(w.isUnlocked ? Icons.lock_open : Icons.lock_clock, color: color, size: 14),
        ),
      ),
    );
  }

  Future<void> _openWhisper(Whisper w) async {
    final color = (_cityMoodStyle[w.mood] ?? _cityMoodStyle['other']!).$2;
    final deleted = await showWhisperReader(context, w, color: color, myUid: widget.uid);
    if (!mounted) return;
    if (deleted) {
      setState(() => _whispers.removeWhere((x) => x.id == w.id));
      showGlassToast(context, tr.whisperWithdrawn, icon: Icons.mail_outline);
    } else {
      _fetchWhispers(); // 更新「已被 N 個人收下」
    }
  }

  /// 雷達上的低語信封：與氣泡用同一套 3D 投影
  Widget _buildWhisperMarker(Whisper w) {
    final color = (_cityMoodStyle[w.mood] ?? _cityMoodStyle['other']!).$2;
    return Semantics(
      button: true,
      label: w.mine ? tr.whisperMineLabel : tr.whisperTapToRead,
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

  /// 雷達右上角的平行宇宙開關：開啟前先說明，關閉直接關
  Future<void> _toggleParallelUniverse() async {
    final on = !parallelUniverseOn.value;
    if (on && !await confirmParallelUniverse(context)) return;
    await setParallelUniverse(on);
    parallelHomeCity.value = null; // 等下一次掃描再顯示所在城市
    _applyParallelUniverse();
  }

  /// 平行宇宙開關改變：馬上告訴伺服器（加入或離開），並重新掃描雷達
  void _applyParallelUniverse() {
    final pos = _currentPosition;
    if (pos != null) _updateMyLocationToServer(pos).then((_) => _fetchNearbyUsers());
  }

  // ---------- 量子世界 ----------

  void _onQuantumChanged() {
    if (!mounted) return;
    quantumOn ? _quantumGlow.repeat(reverse: true) : _quantumGlow.stop();
    if (quantumOn && _quantumClock == null) {
      _quantumClock = Timer.periodic(const Duration(seconds: 1), (_) => _quantumTick());
      _signalSubs = [...QuantumSignals.listen(widget.uid, _onQuantumSignal), ...QuantumMeetCards.listen(widget.uid, onAsk: _onMeetAsk, onYes: _onMeetYes)];
    } else if (!quantumOn && _quantumClock != null) {
      _quantumClock?.cancel(); _quantumClock = null;
      for (final sub in _signalSubs) { sub.cancel(); }
      _signalSubs = [];
    }
    setState(() {});
  }

  /// 每秒一次：整點報時（倒數、鐘聲、報時期間加快心跳）
  int? _chimeLookedHour; // 這個整點已經自動看過原點

  /// 這次整點是不是量子跨年（量子中心午夜）
  bool _isNewYearChime(DateTime now) => QuantumNewYear.serverAt != null && QuantumChime.hourKey(now) * 3600000 == QuantumNewYear.serverAt;

  /// 每一聲的時間；量子跨年不敲 24 聲，午夜一聲之後就是光爆和煙火
  List<double> _strikeTimes(DateTime now) => _isNewYearChime(now) ? const [0.3] : QuantumChime.strikeTimes(QuantumChime.strikes(now));

  void _quantumTick() {
    if (!quantumOn || !mounted) return;
    final now = DateTime.now();
    // 量子跨年：各時區跨年時提示一次
    if (QuantumNewYear.serverAt case final at?) {
      final zone = QuantumNewYear.zoneJustCrossed(at, now.millisecondsSinceEpoch);
      if (zone != null && zone != _nyZoneShown) {
        _nyZoneShown = zone;
        showGlassToast(context, tr.quantumNyZone(QuantumNewYear.places(zone)), icon: Icons.celebration_outlined);
        HapticFeedback.mediumImpact();
      }
    }
    if (!QuantumChime.active(now)) return;
    final t = QuantumChime.offset(now);
    final hour = QuantumChime.hourKey(now);
    if (hour != _chimeHour) {
      _chimeHour = hour; _chimeSent = false; _chimeWatchedShown = false; _chimeCount = 0; _seenChimeFx.clear(); _nyTogetherShown = false;
    }
    // 整點前 5 秒：鏡頭自動拉遠看 101，不然原點在畫面外就看不到光之使者
    if (t >= -5 && t < QuantumChime.show && _chimeLookedHour != hour) {
      _chimeLookedHour = hour;
      _lookAtOrigin();
    }
    // 能送報時微光的那 1 分鐘每 3 秒心跳一次，報時微光和人數才跟得上；之後的光環儀式靠一般心跳更新人數
    if (t <= QuantumChime.send + 5 && _quantumClockTicks++ % 3 == 0) _quantumBeat();
    if (t >= -1.2 && t < QuantumChime.show && _chimeBell == null && _isInForeground) {
      _chimeBell = QuantumChimeBell()..schedule(_strikeTimes(now), max(0, t), onStrike: HapticFeedback.selectionClick);
    }
    final newYear = _isNewYearChime(now);
    if (newYear && t >= 0 && t < 1) HapticFeedback.heavyImpact();
    if (newYear && t >= QuantumNewYearBanner.from && !_nyTogetherShown) {
      _nyTogetherShown = true;
      HapticFeedback.mediumImpact();
    }
    if (t >= QuantumChime.send + 2 && !_chimeWatchedShown) {
      _chimeWatchedShown = true;
      final watched = max(max(1, quantumSession.value?.online ?? 1), _chimeCount);
      if (!newYear) showGlassToast(context, tr.quantumChimeWatched(watched), icon: Icons.notifications_active_outlined);
      Future.delayed(const Duration(seconds: 4), () { _chimeBell?.dispose(); _chimeBell = null; });
    }
    setState(() {});
  }

  /// 整點前：鏡頭拉遠，看得到 101 原點
  void _lookAtOrigin() {
    final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
    final dist = max(300.0, sqrt(c.east * c.east + c.north * c.north));
    _scaleNotifier.value = (1100 / dist).clamp(0.03, 1.0);
    _baseScale = _scaleNotifier.value;
    HapticFeedback.selectionClick();
  }

  /// 報時期間送出一道報時微光：光點從自己的席位飛向原點
  Future<void> _sendChimeGlimmer() async {
    if (_chimeSent) return;
    setState(() => _chimeSent = true);
    final me = quantumLocal(_radarCenter.lat, _radarCenter.lng);
    _quantumFlights.add(QuantumFlight(me.east, me.north, DateTime.now().millisecondsSinceEpoch));
    HapticFeedback.lightImpact();
    showGlassToast(context, tr.quantumChimeSent, icon: Icons.auto_awesome);
    final (status, data) = await QuantumApi.chime();
    if (status == 200 && mounted) setState(() => _chimeCount = max(_chimeCount, (data['count'] as num?)?.toInt() ?? 0));
  }

  /// 心跳帶回的第二期資料：糾纏、邀請、剛塌縮的糾纏、整點報時
  void _applyQuantumLive(Map<String, dynamic> data) {
    _quantumPartners = [for (final e in (data['ent'] as List? ?? const [])) if (QuantumPartner.fromJson(e) case final p?) if (!_blockedUids.contains(p.uid)) p];
    final me = data['me'];
    if (me is Map && me['tunneled'] == true) _quantumTunneled = true;
    for (final name in (data['entGone'] as List? ?? const [])) {
      showGlassToast(context, tr.quantumEntangleCollapsed('$name'), icon: Icons.all_inclusive);
    }
    final ny = data['newYear'];
    QuantumNewYear.serverAt = ny is Map && ny['at'] is num ? (ny['at'] as num).toInt() : (QuantumNewYear.testAt > 0 ? QuantumNewYear.testAt : null);
    if (ny is Map && ny['count'] is num) _newYearCount = max(_newYearCount, (ny['count'] as num).toInt());
    final chime = data['chime'];
    if (chime is Map) {
      _chimeCount = max(_chimeCount, (chime['count'] as num?)?.toInt() ?? 0);
      final now = DateTime.now().millisecondsSinceEpoch;
      var stagger = 0;
      for (final f in (chime['fx'] as List? ?? const [])) {
        if (f is! List || f.length != 2 || !_seenChimeFx.add('${f[0]}|${f[1]}')) continue;
        final o = quantumLocal((f[0] as num).toDouble(), (f[1] as num).toDouble());
        _quantumFlights.add(QuantumFlight(o.east, o.north, now + 180 * stagger++)); // 一道一道飛，不擠在同一瞬間
      }
    }
    _quantumFlights.removeWhere((f) => DateTime.now().millisecondsSinceEpoch - f.startMs > QuantumFlight.durationMs + 6000);
    for (final inv in (data['invites'] as List? ?? const [])) {
      if (inv is! Map || inv['uid'] is! String) continue;
      final from = inv['uid'] as String;
      if (_blockedUids.contains(from) || _isDialogShowing || !_shownInvites.add(from)) continue;
      _answerEntangleInvite(from, '${inv['nickname'] ?? ''}', '${inv['code'] ?? ''}');
      break; // 一次只問一個
    }
  }

  Future<void> _answerEntangleInvite(String from, String name, String code) async {
    _isDialogShowing = true;
    HapticFeedback.mediumImpact();
    final yes = await showQuantumEntangleInvite(context, name: name, code: code);
    _isDialogShowing = false;
    if (!mounted || !quantumOn) return;
    final (status, data) = await QuantumApi.entangle(yes ? 'accept' : 'decline', from);
    if (!mounted || !yes) return;
    if (status == 200 && data['entangled'] == true) {
      showGlassToast(context, tr.quantumEntangled(name), icon: Icons.all_inclusive);
      _quantumBeat();
    } else {
      _showEntangleError(status, data);
    }
  }

  void _showEntangleError(int status, Map<String, dynamic> data) {
    final msg = switch (data['code']) {
      'full' => tr.quantumEntangleFull,
      'theirFull' => tr.quantumEntangleTheirFull,
      'gone' => tr.quantumEntangleGone,
      'inviteExpired' => tr.quantumEntangleExpired,
      _ => tr.quantumUnavailable,
    };
    showGlassToast(context, msg, icon: Icons.all_inclusive);
  }

  Future<void> _inviteEntangle(String uid, String name) async {
    final (status, data) = await QuantumApi.entangle('invite', uid);
    if (!mounted) return;
    if (status == 200 && data['entangled'] == true) { _quantumBeat(); return; }
    status == 200 ? showGlassToast(context, tr.quantumEntangleInvited(name), icon: Icons.all_inclusive) : _showEntangleError(status, data);
  }

  Future<void> _cutEntangle(String uid) async {
    setState(() => _quantumPartners = _quantumPartners.where((p) => p.uid != uid).toList());
    await QuantumApi.entangle('cut', uid);
  }

  /// 量子穿隧：原位化成光點，在新席位重組
  Future<void> _quantumTunnel() async {
    if (_quantumTunneled || _quantumLeaving) return;
    final (status, data) = await QuantumApi.tunnel();
    if (!mounted || !quantumOn) return;
    if (status == 409) { setState(() => _quantumTunneled = true); showGlassToast(context, tr.quantumTunnelUsed, icon: Icons.blur_on); return; }
    if (status != 200 || data['success'] != true) { showGlassToast(context, tr.quantumUnavailable, icon: Icons.error_outline, danger: true); return; }
    final me = Map<String, dynamic>.from(data['me'] as Map);
    _quantumTunneled = true;
    HapticFeedback.mediumImpact();
    final animate = !MediaQuery.of(context).disableAnimations;
    if (animate) {
      setState(() { _quantumSelfCollapse = true; _quantumBursts = []; });
      await _quantumCollapse.forward(from: 0);
      if (!mounted || !quantumOn) return;
    }
    quantumSession.value = quantumSession.value!.copyWith(me: me);
    _jumpCamera(quantumSession.value!.lat, quantumSession.value!.lng);
    _activeUsersNotifier.value = [];
    if (animate) {
      setState(() { _quantumSelfCollapse = false; _quantumReform = true; });
      await _quantumCollapse.reverse(from: 1);
      if (!mounted) return;
    }
    setState(() { _quantumSelfCollapse = false; _quantumReform = false; });
    showGlassToast(context, tr.quantumTunnelDone('${me['code']}'), icon: Icons.blur_on);
    _quantumBeat();
  }

  // ---------- 量子相遇卡 ----------

  QuantumMeetPerson? _meetPersonOf(String uid, int? tz) {
    final user = _activeUsersNotifier.value.where((u) => u['uid'] == uid).firstOrNull;
    if (user == null || user['quantumSeat'] == null) return null;
    final name = '${user['nickname'] ?? ''}'.trim();
    return QuantumMeetPerson(nickname: name.isEmpty ? '#${uid.substring(max(0, uid.length - 4)).toUpperCase()}' : name,
        code: '${user['quantumSeat']}', mood: '${user['mood'] ?? ''}', tz: tz);
  }

  QuantumMeetPerson get _meetMe => QuantumMeetPerson(nickname: _myNickname, code: '${quantumSession.value?.code ?? ''}', mood: _myMood,
      tz: DateTime.now().timeZoneOffset.inMinutes);

  Future<void> _askMeetCard(String uid) async {
    final them = _meetPersonOf(uid, null);
    if (them == null) return;
    final ok = await QuantumMeetCards.ask(widget.uid, uid);
    if (!mounted) return;
    if (!ok) { showGlassToast(context, tr.quantumMeetWait, icon: Icons.timer_outlined); return; }
    _meetAsked[uid] = them;
    HapticFeedback.selectionClick();
    showGlassToast(context, tr.quantumMeetAsked(them.nickname), icon: Icons.style_outlined);
  }

  /// 收到邀請：同意就回覆，並打開自己的那一張
  Future<void> _onMeetAsk(String sender, int? tz) async {
    if (!mounted || !quantumOn || _isDialogShowing || _blockedUids.contains(sender) || _blockedByUids.contains(sender) || HiddenContent.instance.users.contains(sender)) return;
    final them = _meetPersonOf(sender, tz);
    if (them == null || !_meetShown.add(sender)) return;
    _isDialogShowing = true;
    HapticFeedback.mediumImpact();
    final yes = await showQuantumMeetAsk(context, name: them.nickname, code: them.code);
    _isDialogShowing = false;
    _meetShown.remove(sender); // 之後再邀請還會跳出
    if (!yes || !mounted || !quantumOn) return;
    if (!await QuantumMeetCards.accept(widget.uid, sender)) {
      if (mounted) showGlassToast(context, tr.quantumUnavailable, icon: Icons.style_outlined);
      return;
    }
    if (mounted) showQuantumMeetCard(context, me: _meetMe, them: them);
  }

  /// 對方同意了我的邀請：打開我的那一張
  void _onMeetYes(String sender, int? tz) {
    final asked = _meetAsked.remove(sender);
    if (asked == null || !mounted || !quantumOn) return;
    HapticFeedback.mediumImpact();
    final them = QuantumMeetPerson(nickname: asked.nickname, code: _meetPersonOf(sender, tz)?.code ?? asked.code, mood: asked.mood, tz: tz);
    showQuantumMeetCard(context, me: _meetMe, them: them);
  }

  /// 量子訊號：點一下就送，在對方氣泡旁浮出 3 秒
  Future<void> _sendQuantumSignal(String uid, int signal) async {
    final ok = await QuantumSignals.send(widget.uid, uid, signal);
    if (!mounted) return;
    if (!ok) { showGlassToast(context, tr.quantumSignalWait, icon: Icons.timer_outlined); return; }
    HapticFeedback.selectionClick();
    setState(() => _signalFloats.add(QuantumSignalFloat(uid, signal, DateTime.now().millisecondsSinceEpoch)));
  }

  void _onQuantumSignal(String sender, int signal) {
    if (!mounted || !quantumOn || _blockedUids.contains(sender) || _blockedByUids.contains(sender) || HiddenContent.instance.users.contains(sender)) return;
    HapticFeedback.lightImpact();
    setState(() => _signalFloats.add(QuantumSignalFloat(sender, signal, DateTime.now().millisecondsSinceEpoch)));
    // 對方不在畫面上：用提示告訴我是誰
    if (_bubbleAnchors[sender] == null) {
      final user = _activeUsersNotifier.value.where((u) => u['uid'] == sender).firstOrNull;
      final name = '${user?['nickname'] ?? ''}'.trim();
      showGlassToast(context, '${quantumSignalEmoji[signal]} ${tr.quantumSignalReceived(name.isEmpty ? '#${sender.substring(max(0, sender.length - 4)).toUpperCase()}' : name)}');
    }
  }

  /// 量子共振：24 小時內互送微光，兩顆氣泡同時亮起共振光環 10 秒
  void _resonate(String uid) {
    if (!mounted || !quantumOn) return;
    final user = _activeUsersNotifier.value.where((u) => u['uid'] == uid).firstOrNull;
    if (user == null) return; // 對方不在量子世界裡
    setState(() => _resonanceUntil[uid] = DateTime.now().millisecondsSinceEpoch + 10000);
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 180), HapticFeedback.heavyImpact);
    final name = '${user['nickname'] ?? ''}'.trim();
    showGlassToast(context, tr.quantumResonance(name.isEmpty ? '#${uid.substring(max(0, uid.length - 4)).toUpperCase()}' : name), icon: Icons.auto_awesome);
  }

  /// 艾婭在光柱現身時的位置：光柱底部的畫面座標與光柱高度（和 QuantumHivePainter 畫光柱的算法一致）
  (Offset, double)? _aiyaPillarAnchor(double screenWidth, double screenHeight) {
    final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
    final proj = QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: _headingNotifier.value, pitch: _pitchNotifier.value,
        scale: _scaleNotifier.value, screenHeight: screenHeight, center: Offset(screenWidth / 2, screenHeight / 2));
    final hit = proj.project(0, 0);
    if (hit == null) return null;
    final base = hit.$1;
    if (base.dx < -40 || base.dx > screenWidth + 40 || base.dy < 0 || base.dy > screenHeight + 200) return null;
    final boost = _chimeBoost(QuantumChime.offset(DateTime.now()));
    final height = (180 + 120 * _scaleNotifier.value).clamp(120.0, 420.0) * (0.6 + 0.4 * sin(_pitchNotifier.value).abs()) * (1 + 0.5 * boost);
    return (base, height);
  }

  /// 整點報時的光柱亮度：整點前 1 分鐘慢慢變亮，報時後慢慢退回
  double _chimeBoost(double t) => t < -QuantumChime.lead || t > QuantumChime.tail ? 0
      : t < 0 ? (t + QuantumChime.lead) / QuantumChime.lead
      : t <= QuantumChime.send ? 1 : 1 - (t - QuantumChime.send) / (QuantumChime.tail - QuantumChime.send);

  /// 糾纏光線的另一端：對方在畫面裡就連到對方，不在就沿著方向連到畫面邊緣
  (Offset, bool)? _entangleEnd(QuantumProjector proj, Rect screen, double east, double north) {
    final hit = proj.project(east, north);
    if (hit != null && screen.contains(hit.$1)) return (hit.$1, false);
    var lo = 0.0, hi = 1.0;
    Offset? best;
    for (var i = 0; i < 18; i++) {
      final mid = (lo + hi) / 2;
      final h = proj.project(proj.centerEast + (east - proj.centerEast) * mid, proj.centerNorth + (north - proj.centerNorth) * mid);
      if (h != null && screen.contains(h.$1)) { best = h.$1; lo = mid; } else { hi = mid; }
    }
    return best == null ? null : (best, true);
  }

  /// 鏡頭直接跳到某處（進出量子世界時，距離太遠不適合動畫）
  void _jumpCamera(double lat, double lng) {
    _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng), zoom: 16.0 + (log(_scaleNotifier.value) / ln2),
      tilt: (_pitchNotifier.value * 180 / pi).clamp(0.0, 60.0), bearing: _headingNotifier.value,
    )));
  }

  /// 右上角的量子世界按鈕：不在場時說明後進入（按「進入」就是這次的打卡），在場時打開面板
  Future<void> _toggleQuantum() async {
    if (quantumOn) return _openQuantumSheet();
    final pos = _currentPosition;
    if (pos == null || _quantumBusy) return;
    if (isQuantumClosedAt(pos.latitude, pos.longitude)) {
      showGlassToast(context, tr.quantumClosedRegion, icon: Icons.block);
      return;
    }
    if (!await ensureMapConsent(context) || !mounted) return;
    if (!await confirmQuantumWorld(context) || !mounted) return;
    _quantumBusy = true;
    final (status, data) = await QuantumApi.enter(lat: pos.latitude, lng: pos.longitude, mood: _myMood, nickname: _myNickname, extra: QuantumPrefs.payload);
    _quantumBusy = false;
    if (!mounted) return;
    if (status == 403) { showGlassToast(context, tr.quantumClosedRegion, icon: Icons.block); return; }
    if (status != 200 || data['success'] != true) { showGlassToast(context, tr.quantumUnavailable, icon: Icons.error_outline, danger: true); return; }

    // 進入量子世界時暫時離開平行宇宙（伺服器已把自己從一般雷達移除）
    if (parallelUniverseOn.value) { await setParallelUniverse(false); parallelHomeCity.value = null; }
    if (!mounted) return;
    final me = Map<String, dynamic>.from(data['me'] as Map);
    final base = (east: (me['east'] as num?)?.toDouble() ?? 0, north: (me['north'] as num?)?.toDouble() ?? 0);
    void arrive() {
      _quantumWalk = QuantumWalk(pos.latitude, pos.longitude, baseEast: base.east, baseNorth: base.north);
      _quantumFix = pos;
      _quantumLastSent = base;
      _quantumDots = [];
      _seenCollapses.clear();
      _activeUsersNotifier.value = [];
      _scaleNotifier.value = 1.0;
      _quantumTunneled = me['tunneled'] == true;
      quantumSession.value = QuantumSession.fromMe(me, quiet: data['quiet'] == true);
      _jumpCamera(quantumSession.value!.lat, quantumSession.value!.lng);
      _fetchNearbyUsers();
    }
    HapticFeedback.mediumImpact();
    if (MediaQuery.of(context).disableAnimations) return arrive();
    // 入場儀式：畫面全黑（光點飛向東方）時才換到 101，看不到鏡頭跳過去
    setState(() => _quantumEntryCode = me['code'] as String? ?? '');
    _quantumEntry.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) arrive();
  }

  void _openQuantumSheet() => showQuantumSheet(context, onQuietChanged: _setQuantumQuiet, onLeave: _leaveQuantum,
      extras: (sheetContext) => QuantumSheetExtras(
            tunneled: _quantumTunneled,
            partners: _quantumPartners,
            onTunnel: () { Navigator.pop(sheetContext); _quantumTunnel(); },
            onCut: (p) { Navigator.pop(sheetContext); _cutEntangle(p.uid); },
            onPrefsChanged: _quantumBeat,
            moodColor: _getMoodColor(_myMood),
            avatarUrl: _myAvatarUrl,
          ));

  void _setQuantumQuiet(bool quiet) {
    final s = quantumSession.value;
    if (s == null) return;
    quantumSession.value = s.copyWith(quiet: quiet);
    _quantumBeat();
  }

  /// 量子世界的心跳＋掃描（取代一般雷達的掃描）：送出位移與心情，拿回附近的人、遠方光點、塌縮動畫、在線人數
  Future<void> _quantumBeat() async {
    final s = quantumSession.value, walk = _quantumWalk, pos = _currentPosition, fix = _quantumFix;
    if (s == null || walk == null || pos == null || fix == null || !_isInForeground || _quantumLeaving) return;
    // 在場期間移動進入中國大陸：自動離開
    if (isQuantumClosedAt(pos.latitude, pos.longitude)) return _leaveQuantum(message: tr.quantumLeftClosed);
    final raw = walk.at(fix.latitude, fix.longitude);
    // 世界視角：縮得越小，向伺服器要越大的範圍（超過 5 公里的人只回傳光點）
    final radius = _scaleNotifier.value >= _quantumWorldScale ? 5.0 : (1.7 / _scaleNotifier.value).clamp(5.0, 60.0);
    final (status, data) = await QuantumApi.beat(east: raw.east, north: raw.north, mood: _myMood, nickname: _myNickname, quiet: s.quiet, radiusKM: radius, extra: QuantumPrefs.payload);
    if (!mounted || quantumSession.value == null || _quantumLeaving) return;
    if (status == 410) return _leaveQuantum(message: tr.quantumSeatExpired, notifyServer: false); // 席位已釋放（斷線超過 3 分鐘）
    if (status != 200 || data['success'] != true) return;
    _quantumLastSent = raw;
    final online = data['online'] is Map ? Map<String, dynamic>.from(data['online'] as Map) : const <String, dynamic>{};
    quantumSession.value = quantumSession.value!.copyWith(
      me: Map<String, dynamic>.from(data['me'] as Map),
      online: (online['total'] as num?)?.toInt(),
      regions: (online['regions'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
    );
    // 第三個值是 1：這個人的時區已經跨年（量子跨年期間才有）
    _quantumDots = [for (final d in (data['dots'] as List? ?? const [])) if (d is List && d.length >= 2) [(d[0] as num).toDouble(), (d[1] as num).toDouble(), if (d.length > 2) 1.0]];
    // 旁邊的人主動離開：播一次塌縮動畫
    final fresh = <({double lat, double lng})>[];
    for (final c in (data['collapses'] as List? ?? const [])) {
      final key = '${c['uid']}|${c['lat']}|${c['lng']}';
      if (_seenCollapses.add(key)) fresh.add((lat: (c['lat'] as num).toDouble(), lng: (c['lng'] as num).toDouble()));
    }
    if (fresh.isNotEmpty && !_quantumCollapse.isAnimating) {
      _quantumBursts = fresh;
      _quantumCollapse.forward(from: 0);
    }
    _applyQuantumLive(data);
    _processNearbyData(data['data'] as List? ?? const []);
    _updateMapCamera();
  }

  /// 離開量子世界：席位立刻釋放，自己的氣泡化成光點散掉，回到原本打卡的雷達
  Future<void> _leaveQuantum({String? message, bool notifyServer = true}) async {
    if (!quantumOn || _quantumLeaving) return;
    _quantumLeaving = true;
    if (notifyServer) QuantumApi.leave();
    if (!MediaQuery.of(context).disableAnimations) {
      setState(() { _quantumSelfCollapse = true; _quantumBursts = []; });
      await _quantumCollapse.forward(from: 0);
      if (!mounted) return;
    }
    _resetQuantum();
    final pos = _currentPosition;
    if (pos != null) _jumpCamera(pos.latitude, pos.longitude);
    showGlassToast(context, message ?? tr.quantumLeft, icon: Icons.hive_outlined);
    // 回到一般雷達：重新出現在原本打卡的位置
    if (_checkInPosition != null) _updateMyLocationToServer(_checkInPosition!).then((_) => _fetchNearbyUsers());
  }

  void _resetQuantum() {
    _quantumWalk = null; _quantumLastSent = null; _quantumFix = null; _quantumDots = []; _quantumBursts = [];
    // 第二期的公開內容離場即消失：糾纏、訊號、共振都不留
    _quantumPartners = []; _quantumTunneled = false; _quantumReform = false; _quantumChatted.clear(); _shownInvites.clear();
    _newYearCount = 0; _nyTogetherShown = false; _nyZoneShown = null;
    _quantumFlights.clear(); _seenChimeFx.clear(); _resonanceUntil.clear(); _signalFloats.clear();
    _chimeBell?.dispose(); _chimeBell = null; _chimeHour = -1;
    QuantumSignals.clear(widget.uid);
    QuantumMeetCards.clear(widget.uid); _meetAsked.clear(); _meetShown.clear();
    _quantumSelfCollapse = false;
    _quantumLeaving = false;
    _hasScanned = false; // 回到雷達後等第一次掃描，不先閃出「你是今晚第一道光」
    _activeUsersNotifier.value = [];
    _scaleNotifier.value = _scaleNotifier.value.clamp(0.2, 8.0);
    quantumSession.value = null;
  }

  Future<void> _fetchNearbyUsers() async {
    if (_currentPosition == null || !_locationServicesStarted) return; // 打卡後才看得到附近的人
    if (quantumOn) return _quantumBeat();
    try {
      final response = await http.post(
        Uri.parse(_getNearbyUrl),
        headers: await _authHeaders(),
        body: jsonEncode({
          'lat': _currentPosition!.latitude,
          'lng': _currentPosition!.longitude,
          'radiusKM': 5, 
          'parallel': parallelUniverseOn.value,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          parallelHomeCity.value = parallelUniverseOn.value ? (data['parallelCityName'] as String? ?? data['parallelCity'] as String? ?? '') : null;
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
      if (HiddenContent.instance.users.contains(user['uid'])) continue; // 檢舉過的人，立刻從自己的雷達移除

      // 狀態由伺服器判定（active / inactive / shadow），殘影留存時間依當地密度而定
      final String status = user['status'] ?? 'active';
      final bool isShadow = status == 'shadow';
      final double shadowAge = ((user['shadowAge'] ?? 0) as num).toDouble().clamp(0.0, 1.0);

      updatedUsers.add({
        'uid': user['uid'],
        'lat': user['lat'],
        'lng': user['lng'],
        'mood': user['mood'] ?? tr.noMoodYet,
        'nickname': isShadow ? '' : (user['nickname'] ?? ''), 
        'isShadow': isShadow,
        'isInactive': status == 'inactive',
        // 示範對象（導覽員機器人）：名字前一律標示「示範」
        'isDemo': user['demo'] == true,
        // 正在主持集會：「主持」光環與活動圖標
        'hostEmoji': user['hostEmoji'],
        // 平行宇宙：其他城市投影過來的人，值是對方所在的城市代碼
        'parallelCity': user['parallelName'] ?? user['parallel'], // 伺服器給的城市名稱（使用者的語言）
        // 量子世界：席位代號，以及對方是否開啟量子寧靜（不能敲門）
        'quantumSeat': user['quantum'],
        // 量子化身：光球款式（主色仍然是心情色）
        'quantumOrb': user['quantum'] != null ? orbStyleOf(user['orb']) : null,
        'quiet': user['quiet'] == true,
        // 第二期：晝夜色調、當地時間（對方同意才有）、量子同頻主題
        'day': user['day'],
        'tz': user['tz'],
        'topics': quantumTopicsOf(user['topics']),
        // 第三期：量子跨年，對方的時區已經跨年
        'ny': user['ny'] == true,
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
          showGlassToast(context, tr.knockWithdrawnByLeaving, icon: Icons.nights_stay_outlined);
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
        if (HiddenContent.instance.users.contains(senderUid)) return;
        
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

        // 量子寧靜：別人不能敲門，收到的敲門直接略過
        if (status == 'pending' && quantumSession.value?.quiet == true) {
          _dbRef.child('requests/${widget.uid}/$senderUid').remove();
          return;
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
              Text(tr.knockCardTitle, style: Night.title),
              const SizedBox(height: Night.space2),
              Text(tr.knockCardBody(senderName), style: Night.body, textAlign: TextAlign.center),
              // 量子同頻：雙方共同的主題亮起來，讓聊天有開頭
              if (quantumOn)
                if ([for (final t in quantumTopicsOf(_activeUsersNotifier.value.where((u) => u['uid'] == senderUid).firstOrNull?['topics'])) if (QuantumPrefs.topics.value.contains(t)) t]
                    case final common when common.isNotEmpty) ...[
                  const SizedBox(height: Night.space2),
                  Text(tr.quantumTopicsCommon(common.map((t) => '${quantumTopicEmoji[t]} ${quantumTopicName(t)}').join('、')),
                      style: Night.caption.copyWith(color: Night.cityAmber), textAlign: TextAlign.center),
                ],
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton(tr.skip, kind: NightButtonKind.text, onPressed: () { close(dialogContext); _dbRef.child('requests/${widget.uid}/$senderUid').remove(); })),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton(tr.decline, kind: NightButtonKind.ghost, onPressed: () { close(dialogContext); _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'rejected'}); })),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton(tr.accept, kind: NightButtonKind.warm, onPressed: () {
                  close(dialogContext);
                  _dbRef.child('requests/${widget.uid}/$senderUid').set({'status': 'accepted', 'nickname': _myNickname});
                  _navigateToChatScreen(senderUid, senderName);
                })),
              ]),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Night.inkFaint, minimumSize: const Size(44, 44)),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: Text(tr.reportThisPerson, style: Night.caption),
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
    String text = tr.cityQuietTonight;
    Color dot = Night.moodDefault;
    if (!quiet) {
      final top = (mood['moods'] as List).first;
      final style = _cityMoodStyle[top['key']] ?? _cityMoodStyle['other']!;
      text = tr.cityMoodChip(style.$1, '${top['percent']}');
      dot = style.$2;
    }
    return Semantics(
      button: true,
      label: tr.cityMoodChipLabel(text),
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
                child: Text(tr.cityMoodTitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 2)),
              ),
              const SizedBox(height: Night.space2),
              Text(quiet ? tr.cityMoodQuietCount(total) : tr.cityMoodCount(total),
                  style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              if (quiet)
                Text(tr.cityMoodQuietInvite, style: Night.body, textAlign: TextAlign.center)
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
              Text(tr.cityMoodFootnote, style: Night.caption, textAlign: TextAlign.center),
            ]),
          ),
        ),
      ),
    );
  }

  /// 空雷達卡片：附近 5 公里內沒有人時顯示，取代一片空白
  Widget _buildEmptyRadarCard() {
    // 第一次顯示就記下今天：這次打卡期間照常顯示（直到關掉），之後重新打卡就不再出現
    final today = _today();
    if (_emptyCardSeenDay != today) {
      _emptyCardSeenDay = today;
      SharedPreferences.getInstance().then((p) => p.setString(_emptyCardDayKey, today));
    }
    return Stack(children: [
      _buildEmptyRadarCardBody(),
      // 不想邀請或分享也能關掉；本次開啟期間不再出現
      Positioned(
        top: 2, right: 2,
        child: IconButton(
          tooltip: tr.close,
          icon: const Icon(Icons.close, color: Night.inkFaint, size: 20),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          onPressed: () => setState(() => _emptyCardDismissed = true),
        ),
      ),
    ]);
  }

  Widget _buildCheckInCard() {
    return GlassCard(
      glow: true,
      padding: const EdgeInsets.symmetric(horizontal: Night.space6, vertical: Night.space4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.where_to_vote_outlined, color: Night.auroraViolet, size: 32),
        const SizedBox(height: Night.space2),
        Text(tr.checkInTitle, style: Night.title, textAlign: TextAlign.center),
        const SizedBox(height: Night.space2),
        Text(tr.checkInBody, style: Night.body, textAlign: TextAlign.center),
        const SizedBox(height: Night.space4),
        NightButton(tr.checkInButton, icon: Icons.where_to_vote, onPressed: _currentPosition == null ? null : _tapCheckIn),
      ]),
    );
  }

  Widget _buildReCheckInPill() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: _tapCheckIn,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space2),
          decoration: BoxDecoration(color: Night.glassFill, borderRadius: BorderRadius.circular(999), border: Border.all(color: Night.auroraViolet)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.where_to_vote_outlined, color: Night.auroraViolet, size: 18),
            const SizedBox(width: Night.space2),
            Text(tr.checkInAgain, style: const TextStyle(color: Night.ink, fontSize: 14)),
          ]),
        ),
      ),
    );
  }

  /// 打卡中：隨時可以自己結束打卡，立刻從地圖上消失
  Widget _buildCheckOutPill() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () { _checkOut(); showGlassToast(context, tr.checkedOutToast, icon: Icons.location_off_outlined); },
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Night.space3, vertical: Night.space2),
          decoration: BoxDecoration(color: Night.glassFill, borderRadius: BorderRadius.circular(999), border: Border.all(color: Night.glassLine)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.where_to_vote, color: Night.auroraViolet, size: 16),
            const SizedBox(width: Night.space1),
            Text(tr.checkOutButton, style: const TextStyle(color: Night.inkMuted, fontSize: 13)),
          ]),
        ),
      ),
    );
  }

  Widget _buildEmptyRadarCardBody() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: Night.space6, vertical: Night.space4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ShaderMask(
          shaderCallback: (rect) => Night.brightGradient.createShader(rect),
          child: Text(tr.emptyRadarTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 2)),
        ),
        const SizedBox(height: Night.space2),
        Text(tr.emptyRadarBody, style: Night.body, textAlign: TextAlign.center),
        if (_cityMood != null && _cityMood!['quiet'] != true && (_cityMood!['moods'] as List?)?.isNotEmpty == true) ...[
          const SizedBox(height: Night.space2),
          Text(tr.emptyRadarCityMood('${_cityMood!['total']}', (_cityMoodStyle[(_cityMood!['moods'] as List).first['key']] ?? _cityMoodStyle['other']!).$1),
              style: Night.caption, textAlign: TextAlign.center),
        ],
        const SizedBox(height: Night.space3),
        NightButton(tr.inviteFriends, icon: Icons.group_add_outlined, onPressed: () => shareInvite(context)),
        const SizedBox(height: Night.space2),
        NightButton(tr.shareMoodCard, kind: NightButtonKind.ghost, icon: Icons.ios_share, onPressed: () => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood))),
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
            label: tr.editYourMood,
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
                          ? tr.resonanceTonight(_resonanceCount)
                          : (_myNickname.isNotEmpty ? tr.dockNicknameMood(_myNickname) : tr.dockTapToEdit),
                      style: _resonanceCount > 0 ? Night.caption.copyWith(color: Night.knockPink) : Night.caption,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
        if (!quantumOn) IconButton(
          tooltip: tr.leaveWhisper,
          onPressed: _composeWhisper,
          icon: const Icon(Icons.edit_note, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 48),
        ),
        IconButton(
          tooltip: tr.shareMoodCard,
          onPressed: () => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood)),
          icon: const Icon(Icons.ios_share, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        IconButton(
          tooltip: tr.settings,
          onPressed: _showSettingsPanel,
          icon: const Icon(Icons.tune_rounded, color: Night.inkMuted),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ]),
    );
  }

  String _languageName(Locale? locale) =>
      locale == null ? tr.languageSystem : languageOptions.firstWhere((o) => o.$1 == locale, orElse: () => (null, tr.languageSystem)).$2;

  /// 語言選單：各語言用自己的寫法顯示，選了立刻切換
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true, barrierColor: const Color(0x99070B1F),
      useSafeArea: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            padding: const EdgeInsets.fromLTRB(Night.space4, Night.space4, Night.space4, Night.space3),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(tr.language, style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space2),
                for (final (locale, name) in languageOptions)
                  InkWell(
                    borderRadius: BorderRadius.circular(Night.radiusSm),
                    onTap: () { Navigator.pop(sheetContext); setAppLocale(locale); },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Night.space3, horizontal: Night.space2),
                      child: Row(children: [
                        Expanded(child: Text(locale == null ? tr.languageSystem : name, style: const TextStyle(color: Night.ink, fontSize: 15))),
                        if (appLocale.value == locale) const Icon(Icons.check, color: Night.knockPink, size: 20),
                      ]),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
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
      useSafeArea: true, // 設定比螢幕高時，標題與關閉鈕不能被狀態列蓋住
      builder: (BuildContext sheetContext) {
        void go(VoidCallback action) { Navigator.pop(sheetContext); action(); }
        Widget switchRow(IconData icon, String title, String subtitle, bool Function() value, ValueChanged<bool> onChanged) => StatefulBuilder(builder: (context, setRowState) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Night.space1, horizontal: Night.space2),
          child: Row(children: [
            Icon(icon, color: Night.inkMuted, size: 22),
            const SizedBox(width: Night.space4),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: Night.ink, fontSize: 15)),
                SizedBox(height: 2),
                Text(subtitle, style: Night.caption),
              ]),
            ),
            Switch(
              value: value(),
              activeThumbColor: Night.onDeep,
              activeTrackColor: Night.deepViolet,
              inactiveTrackColor: Night.night700,
              onChanged: (v) => setRowState(() => onChanged(v)),
            ),
          ]),
        ));
        final reminderRow = switchRow(Icons.nightlight_outlined, tr.nightlyReminder, tr.nightlyReminderSubtitle, () => reminderOn, (v) { reminderOn = v; NightlyReminder.setEnabled(v); });
        final placeHintRow = switchRow(Icons.local_cafe_outlined, tr.placeHintsSetting, tr.placeHintsSettingSubtitle, () => PlaceHints.enabled, PlaceHints.setEnabled);
        final aiyaRow = switchRow(Icons.auto_awesome_outlined, tr.aiyaSetting, tr.aiyaSettingSubtitle, () => AiyaPrefs.enabled.value, AiyaPrefs.setEnabled);
        // 在地圖上顯示我的位置：關掉就立刻結束打卡、離開量子世界；下次打卡會再問一次
        final mapConsentRow = switchRow(Icons.where_to_vote_outlined, tr.mapConsentSetting, tr.mapConsentSettingSubtitle, () => MapConsent.allowed.value, (v) {
          MapConsent.set(v);
          if (!v) {
            if (quantumOn) _leaveQuantum();
            if (_checkInPosition != null) _checkOut();
          }
        });
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Night.space4),
            child: GlassCard(
              padding: const EdgeInsets.fromLTRB(Night.space4, Night.space3, Night.space4, Night.space4),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  // 設定比螢幕還高時點不到外面，標題列右邊一定要有關閉鈕
                  Stack(alignment: Alignment.center, children: [
                    Text(tr.settings, style: Night.title, textAlign: TextAlign.center),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: tr.closeSettings,
                        icon: const Icon(Icons.close, color: Night.inkMuted),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ),
                  ]),
                  section(tr.settingsSectionMe),
                  item(Icons.person_outline, tr.editProfile, subtitle: tr.editProfileSubtitle, onTap: () => go(_showProfileEditDialog)),
                  mapConsentRow,
                  item(Icons.block, tr.manageBlockList, subtitle: tr.manageBlockListSubtitle, color: Night.danger, onTap: () => go(_showBlockListDialog)),
                  item(Icons.hourglass_bottom, tr.myTimeWhispers, subtitle: tr.myTimeWhispersSubtitle,
                      onTap: () => go(() => showTimeWhisperList(context, lat: _currentPosition?.latitude, lng: _currentPosition?.longitude).then((_) => _fetchTimeWhispers()))),
                  item(Icons.timeline, tr.myMoodTrail, subtitle: tr.myMoodTrailSubtitle, onTap: () => go(() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MoodTrailScreen())))),
                  reminderRow,
                  placeHintRow,
                  aiyaRow,
                  item(Icons.translate, tr.language, subtitle: _languageName(appLocale.value), onTap: () => go(_showLanguagePicker)),
                  section(tr.settingsSectionGatherings),
                  item(Icons.campaign_outlined, tr.gatheringHost,
                      subtitle: _hostedGathering == null ? tr.gatheringHostSubtitle : tr.gatheringHosting(_hostedGathering!.emoji, _hostedGathering!.name),
                      onTap: () => go(_openGatheringHost)),
                  // 低語團：在團裡就打開面板；不在團裡可以開團或輸入團代碼加入
                  if (WhisperGroup.current.value case final g?)
                    item(Icons.groups_2_outlined, tr.wgSettingOpen(g.name), subtitle: tr.wgCount(g.count, g.limit), onTap: () => go(() => showWhisperGroupPanel(context)))
                  else ...[
                    item(Icons.groups_2_outlined, tr.wgSettingCreate, subtitle: tr.wgSettingCreateSub, onTap: () => go(() => showCreateWhisperGroup(context))),
                    item(Icons.qr_code_2, tr.wgSettingJoin, subtitle: tr.wgSettingJoinSub, onTap: () => go(() => showJoinByCode(context))),
                  ],
                  section(tr.settingsSectionShare),
                  item(Icons.ios_share, tr.shareMoodCard, subtitle: tr.shareMoodCardSubtitle, onTap: () => go(() => showMoodCard(context, mood: _myMood, moodColor: _getMoodColor(_myMood)))),
                  item(Icons.group_add_outlined, tr.inviteFriends, subtitle: tr.inviteFriendsSubtitle, onTap: () => go(() => shareInvite(context))),
                  section(tr.settingsSectionAbout),
                  item(Icons.menu_book_outlined, tr.guide, subtitle: tr.guideSubtitle, onTap: () => go(() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen())))),
                  item(Icons.description_outlined, tr.termsOfUse, onTap: () => Legal.open(Legal.termsUrl)),
                  item(Icons.privacy_tip_outlined, tr.privacyPolicy, onTap: () => Legal.open(Legal.privacyUrl)),
                  item(Icons.mail_outline, tr.contactUs, subtitle: Legal.contactEmail, onTap: () => Legal.emailUs()),
                  const Divider(color: Night.night600, height: Night.space6),
                  item(Icons.delete_forever_outlined, tr.deleteAccount, subtitle: tr.deleteAccountSubtitle, color: Night.danger, titleColor: Night.danger, onTap: () => go(_confirmDeleteAccount)),
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
                if (mounted) showGlassToast(context, tr.avatarUploadFailed, icon: Icons.error_outline, danger: true);
              }
            }

            Future<void> save() async {
              final String newMood = moodController.text.trim(); final String newNickname = nicknameController.text.trim();
              if (newMood.isEmpty) { showGlassToast(context, tr.moodEmpty, icon: Icons.edit_outlined); return; }
              
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
                if (mounted) showGlassToast(context, tr.profileSyncFailed, icon: Icons.error_outline, danger: true);
              }

              if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
              
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              if (mounted) showGlassToast(context, tr.profileUpdated, icon: Icons.auto_awesome_outlined);
            }

            return Dialog(
              backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(Night.space6),
              child: GlassCard(
                glow: true,
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(tr.editProfile, style: Night.title, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    Center(
                      child: Semantics(
                        button: true,
                        label: tr.changeAvatar,
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
                    Text(tr.avatarHint, style: Night.caption, textAlign: TextAlign.center),
                    const SizedBox(height: Night.space4),
                    Text(tr.cityName, style: Night.caption),
                    const SizedBox(height: Night.space2),
                    TextField(controller: nicknameController, style: const TextStyle(color: Night.ink, fontSize: 15), maxLength: 10, cursorColor: Night.auroraViolet, decoration: nightInput(tr.cityNameHint)),
                    const SizedBox(height: Night.space2),
                    Text(tr.currentMood, style: Night.caption),
                    const SizedBox(height: Night.space2),
                    TextField(
                      controller: moodController, maxLength: 20, cursorColor: Night.auroraViolet,
                      onChanged: (_) => setDialogState(() {}),
                      style: const TextStyle(color: Night.ink, fontSize: 15),
                      decoration: nightInput(tr.currentMoodHint),
                    ),
                    const SizedBox(height: Night.space3),
                    Row(children: [
                      Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext))),
                      const SizedBox(width: Night.space2),
                      Expanded(child: NightButton(tr.save, onPressed: isUploading ? null : save)),
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
                  Text(tr.blockListTitle, style: Night.title, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space3),
                  if (_blockedUids.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Night.space4),
                      child: Column(children: [
                        Icon(Icons.nights_stay_outlined, color: Night.inkFaint, size: 40),
                        SizedBox(height: Night.space3),
                        Text(tr.blockListEmpty, style: Night.body, textAlign: TextAlign.center),
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
                                child: Text(tr.unblock, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: Night.space4),
                  NightButton(tr.close, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext)),
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
                Text(tr.deleteAccount, style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space2),
                Text(tr.deleteAccountBody,
                    style: Night.body, textAlign: TextAlign.center),
                const SizedBox(height: Night.space4),
                Row(children: [
                  Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: deleting ? null : () => Navigator.pop(dialogContext))),
                  const SizedBox(width: Night.space2),
                  Expanded(child: NightButton(deleting ? tr.deleting : tr.deletePermanently, kind: NightButtonKind.danger, onPressed: deleting ? null : () async {
                    setDialogState(() => deleting = true);
                    final ok = await _deleteAccount();
                    if (!ok && dialogContext.mounted) {
                      setDialogState(() => deleting = false);
                      showGlassToast(context, tr.deleteFailed, icon: Icons.error_outline, danger: true);
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
    final center = _radarCenter;
    for (final user in users) {
      final r = WhisperEngine.calculateBubbleVisuals(center.lat, center.lng, user['lat'], user['lng'], heading, user['uid'], rhythm);
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

  // 氣泡上的心情翻譯：key 是「uid|原文」，心情換了就自動回到原文
  final Map<String, String> _moodTranslations = {};
  final Set<String> _showingMoodTranslation = {};

  dynamic _shownMood(String uid, dynamic mood) {
    final key = '$uid|$mood';
    return _showingMoodTranslation.contains(key) ? _moodTranslations[key] : mood;
  }

  /// 點氣泡：心情不是你的語言就翻譯；同一種語言（不用翻譯）就改開互動選單（送微光、敲門、封鎖、檢舉）
  Future<void> _toggleMoodTranslation(String uid, String mood, {VoidCallback? otherwise}) async {
    final key = '$uid|$mood';
    if (_showingMoodTranslation.contains(key)) { setState(() => _showingMoodTranslation.remove(key)); return; }
    if (_moodTranslations.containsKey(key)) { setState(() => _showingMoodTranslation.add(key)); return; }
    final locale = Localizations.localeOf(context);
    final needs = await ChatTranslator.needsTranslation(mood, locale);
    if (!mounted) return;
    if (!needs) { otherwise?.call(); return; }
    String? out;
    try { out = await ChatTranslator.translate(context, mood, locale); } catch (_) {}
    if (out == null || !mounted) return;
    setState(() { _moodTranslations[key] = out!; _showingMoodTranslation.add(key); });
  }

  Widget _placedBubbleWidget(_PlacedBubble p, Offset at, {double extraScale = 1.0, bool petal = false}) {
    final user = p.user;
    final uid = p.uid;
    final shortId = uid.substring(uid.length - 4).toUpperCase();
    final displayName = user['nickname'].toString().isNotEmpty ? user['nickname'] : '#$shortId';
    final isShadow = user['isShadow'] ?? false;
    void openMenu() {
      _focusBubble(uid);
      _showInteractionMenu(uid, isShadow ? tr.fadingEcho : displayName, isShadow: isShadow, isDemo: user['isDemo'] == true, parallelCity: user['parallelCity'] as String?,
          quantumSeat: user['quantumSeat'] as String?, quiet: user['quiet'] == true, moodColor: _getMoodColor(user['mood']), user: user);
    }
    _bubbleAnchors[uid] = at + const Offset(0, 10);
    return Positioned(
      key: ValueKey('bubble:$uid'), // 疊層每幀重排，固定 key 才不會在手指按下時換掉元件
      left: at.dx - 66, top: at.dy - 60,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: openMenu,
        // 點一下：心情不是你的語言就直接翻譯，再點一下回到原文；不用翻譯時打開互動選單
        onTap: isShadow ? openMenu : () => _toggleMoodTranslation(uid, '${user['mood'] ?? ''}', otherwise: openMenu),
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
              moodText: _shownMood(uid, user['mood']),
              isFavored: p.render.isFavored,
              status: _outgoingRequests[uid] ?? RequestStatus.none,
              displayName: displayName,
              // 量子世界的位置不是真實距離：顯示席位代號
              // 量子同頻的主題用小圖示接在後面
              distanceLabel: user['quantumSeat'] != null
                  ? ['⬡ ${user['quantumSeat']}', ...[for (final t in (user['topics'] as List<int>? ?? const [])) quantumTopicEmoji[t]], if (user['ny'] == true) '🎆'].join(' ')
                  : WhisperEngine.formatDistance(p.render.distance),
              dayTint: quantumDayTint(user['day']),
              newYear: user['ny'] == true,
              baseColor: _getMoodColor(user['mood']),
              isShadow: isShadow,
              isInactive: user['isInactive'] ?? false,
              isDemo: user['isDemo'] ?? false,
              hostEmoji: user['hostEmoji'] as String?,
              parallelCity: user['parallelCity'] as String?,
              shadowOpacity: user['shadowOpacity'] ?? 1.0,
              orb: user['quantumOrb'] as String?,
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
              Text(tr.clusterCount(c.length), style: Night.caption.copyWith(shadows: const [Shadow(color: Night.night900, blurRadius: 6)])),
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
                    child: Text(page + 1 < pages ? tr.clusterMore(c.length - (page + 1) * perPage) : tr.clusterBackToFirst,
                        textAlign: TextAlign.center, style: Night.caption.copyWith(color: Night.ink)),
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }

  void _showInteractionMenu(String targetUid, String displayName, {bool isShadow = false, bool isDemo = false, String? parallelCity,
      String? quantumSeat, bool quiet = false, Color moodColor = Night.moodDefault, Map<String, dynamic>? user}) {
    final localTime = quantumLocalTimeLabel(user?['tz'], user?['day']);
    final common = [for (final t in quantumTopicsOf(user?['topics'])) if (QuantumPrefs.topics.value.contains(t)) t];
    final entangled = _quantumPartners.any((p) => p.uid == targetUid);
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
              Text(isShadow ? tr.fadingEchoTitle : tr.encounterWith(displayName), style: Night.title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
              if (isShadow) ...[
                const SizedBox(height: Night.space2),
                Text(tr.fadingEchoBody, style: Night.body, textAlign: TextAlign.center),
              ],
              if (isDemo) ...[
                const SizedBox(height: Night.space2),
                Text(tr.demoPersonBody, style: Night.body, textAlign: TextAlign.center),
              ],
              if (parallelCity != null) ...[
                const SizedBox(height: Night.space2),
                Text(tr.parallelPersonBody(parallelCityName(parallelCity)), style: Night.body, textAlign: TextAlign.center),
              ],
              if (quantumSeat != null) ...[
                const SizedBox(height: Night.space2),
                Text(tr.quantumPersonBody(quantumSeat), style: Night.body, textAlign: TextAlign.center),
                // 地球時間窗（對方同意才有）、量子同頻的共同主題
                if (localTime != null) ...[
                  const SizedBox(height: Night.space1),
                  Text(localTime, style: Night.caption.copyWith(color: quantumDayTint(user?['day']) ?? Night.inkMuted), textAlign: TextAlign.center),
                ],
                if (common.isNotEmpty) ...[
                  const SizedBox(height: Night.space1),
                  Text(tr.quantumTopicsCommon(common.map((t) => '${quantumTopicEmoji[t]} ${quantumTopicName(t)}').join('、')),
                      style: Night.caption.copyWith(color: Night.cityAmber), textAlign: TextAlign.center),
                ],
                if (!isDemo) ...[
                  const SizedBox(height: Night.space3),
                  Semantics(
                    label: tr.quantumSignalsTitle,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      for (var i = 0; i < quantumSignalEmoji.length; i++)
                        InkResponse(
                          onTap: () { Navigator.pop(dialogContext); _sendQuantumSignal(targetUid, i); },
                          radius: 24,
                          child: SizedBox(width: 44, height: 44, child: Center(child: Text(quantumSignalEmoji[i], style: const TextStyle(fontSize: 24)))),
                        ),
                    ]),
                  ),
                ],
              ],
              const SizedBox(height: Night.space3),
              item(Icons.auto_awesome, moodColor, tr.sendGlimmer, () { Navigator.pop(dialogContext); _sendResonance(targetUid, moodColor); }),
              if (!isShadow) ...[
                item(Icons.waving_hand_outlined, quiet ? Night.inkFaint : Night.knockPink, tr.knock, () {
                  Navigator.pop(dialogContext);
                  // 對方開啟量子寧靜：只能送微光，不能敲門
                  if (quiet) { showGlassToast(context, tr.quantumQuietTarget, icon: Icons.do_not_disturb_on_outlined); return; }
                  _handleBubbleLongPress(targetUid, displayName);
                }),
                // 量子糾纏：聊過天之後才能邀請；糾纏中可以解除
                if (quantumSeat != null && !isDemo && entangled)
                  item(Icons.all_inclusive, Night.inkMuted, tr.quantumEntangleCut, () { Navigator.pop(dialogContext); _cutEntangle(targetUid); })
                else if (quantumSeat != null && !isDemo && _quantumChatted.contains(targetUid))
                  item(Icons.all_inclusive, Night.knockPink, tr.quantumEntangleInvite, () { Navigator.pop(dialogContext); _inviteEntangle(targetUid, displayName); }),
                // 量子相遇卡：聊過天（或糾纏中）的人，雙方同意後各拿一張分享卡
                if (quantumSeat != null && !isDemo && (entangled || _quantumChatted.contains(targetUid)))
                  item(Icons.style_outlined, Night.cityAmber, tr.quantumMeetAction, () { Navigator.pop(dialogContext); _askMeetCard(targetUid); }),
                // 我正在主持：可以把活動交給這位參加者
                // 集會是在地的：平行宇宙的人不能接主持
                if (!isDemo && parallelCity == null && quantumSeat == null && _hostedGathering != null)
                  item(Icons.swap_horiz, Night.auroraBlue, tr.handOverHost, () {
                    Navigator.pop(dialogContext);
                    showHandoffDialog(context, gathering: _hostedGathering!, toUid: targetUid, toName: displayName);
                  }),
              ],
              item(Icons.block, Night.danger, tr.blockAction, () { Navigator.pop(dialogContext); _showBlockConfirmationDialog(targetUid, displayName); }),
              item(Icons.flag_outlined, Night.danger, tr.report, () {
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
              Text(tr.confirmBlockTitle, style: Night.title, textAlign: TextAlign.center),
              const SizedBox(height: Night.space2),
              Text(tr.confirmBlockBody(displayName), style: Night.body, textAlign: TextAlign.center),
              const SizedBox(height: Night.space4),
              Row(children: [
                Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext))),
                const SizedBox(width: Night.space2),
                Expanded(child: NightButton(tr.confirmBlock, kind: NightButtonKind.danger, icon: Icons.block, onPressed: () { Navigator.pop(dialogContext); _blockUser(targetUid, displayName); })),
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
      final received = <String, int>{};
      if (raw is Map) {
        raw.forEach((sender, at) {
          if (at is int && now - at <= 86400000) {
            count++;
            received['$sender'] = at;
          } else {
            _dbRef.child('resonance/${widget.uid}/$sender').remove();
          }
        });
      }
      // 量子共振：剛收到的微光來自 24 小時內我也送過的人
      if (_resonanceCount >= 0) {
        for (final e in received.entries) {
          if (_glimmersReceived[e.key] == e.value) continue;
          QuantumResonance.sentRecently(e.key).then((yes) { if (yes) _resonate(e.key); });
        }
      }
      _glimmersReceived = received;
      if (!mounted) return;
      final bool isNew = _resonanceCount >= 0 && count > _resonanceCount;
      setState(() => _resonanceCount = count);
      if (isNew) {
        HapticFeedback.lightImpact();
        showGlassToast(context, tr.glimmerReceived, icon: Icons.auto_awesome);
      }
    });
  }

  /// 送出一道微光（共鳴）：不需要聊天，同一人 24 小時一次
  Future<void> _sendResonance(String targetUid, Color moodColor) async {
    try {
      await _dbRef.child('resonance/$targetUid/${widget.uid}').set(ServerValue.timestamp);
      HapticFeedback.selectionClick();
      QuantumResonance.recordSent(targetUid);
      // 量子共振：對方 24 小時內也送過我微光
      final theirs = _glimmersReceived[targetUid];
      if (theirs != null && DateTime.now().millisecondsSinceEpoch - theirs <= 86400000) _resonate(targetUid);
      final anchor = _bubbleAnchors[targetUid];
      if (mounted && anchor != null && !MediaQuery.of(context).disableAnimations) {
        setState(() { _sparkleAt = anchor; _sparkleColor = moodColor; });
        _sparkle.forward(from: 0);
      }
      if (mounted) showGlassToast(context, tr.glimmerSent, icon: Icons.auto_awesome);
    } catch (e) {
      // 規則拒絕：24 小時內已送過、被封鎖，或帳號被隱藏
      if (mounted) showGlassToast(context, tr.glimmerAlreadySent, icon: Icons.auto_awesome_outlined);
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
      if (mounted) showGlassToast(context, tr.knockSent, icon: Icons.waving_hand_outlined);
    }).catchError((Object e) {
      // 寫入被拒（規則驗證失敗、網路中斷等）時收回狀態並告知，不再默默失敗
      debugPrint('knock write failed: $e');
      _pendingTimers[targetUid]?.cancel(); _requestSubscriptions[targetUid]?.cancel();
      _endKnockRitual(targetUid);
      if (mounted) {
        setState(() => _outgoingRequests.remove(targetUid));
        showGlassToast(context, tr.knockFailed, icon: Icons.error_outline, danger: true);
      }
    });

    _pendingTimers[targetUid]?.cancel();
    _pendingTimers[targetUid] = Timer(const Duration(minutes: 5), () {
      if (_outgoingRequests[targetUid] == RequestStatus.pending) {
        _dbRef.child('requests/$targetUid/${widget.uid}').remove(); 
        _endKnockRitual(targetUid, dissolve: true, message: tr.knockNoAnswer);
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
        _endKnockRitual(targetUid, dissolve: true, message: tr.knockDeclined);
        if (mounted) setState(() => _outgoingRequests.remove(targetUid));
      } else if (status.isEmpty && _outgoingRequests[targetUid] == RequestStatus.pending) {
        // 對方按「略過」會直接刪除請求 → 收回敲門中的狀態
        // （同意 / 婉拒後由自己刪除請求時，狀態已先移除，不會走到這裡）
        _pendingTimers[targetUid]?.cancel();
        _endKnockRitual(targetUid, dissolve: true, message: tr.knockSkipped);
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
    String? targetTag;
    try {
      final user = _activeUsersNotifier.value.firstWhere((u) => u['uid'] == targetUid);
      if (user['nickname'] != null && user['nickname'].toString().trim().isNotEmpty) {
        finalTargetName = user['nickname'].toString();
      }
      if (user['quantumSeat'] != null) targetTag = tr.quantumChatTag(user['quantumSeat'] as String);
    } catch (_) {}
    if (quantumOn) _quantumChatted.add(targetUid); // 聊過天之後才能邀請糾纏

    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
        myUid: widget.uid, 
        myName: myCurrentName, 
        targetUid: targetUid, 
        targetName: finalTargetName,
        targetTag: targetTag,
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
      WhisperGroup.refresh();
      // 回到前景：立刻回報為活躍，並馬上刷新雷達
      if (_isInForeground) return;
      _isInForeground = true;
      if (!_locationServicesStarted) return;
      _setPresence('active');
      if (_currentPosition != null) _updateMyLocationToServer(_currentPosition!);
      _startForegroundHeartbeat();
      _startRadarSweep();
    } else if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      // 鎖屏 / 切到背景：打卡立刻結束、從地圖上消失，回來要自己重新打卡（Apple 5.1.2(i)）
      // 註：iOS 開啟 App 切換器只會進入 inactive，此時從切換器滑掉 App 會觸發 onDisconnect → exited
      WhisperGroup.pause();
      if (!_isInForeground) return;
      _isInForeground = false;
      _heartbeatTimer?.cancel();
      _radarTimer?.cancel();
      _cityMoodTimer?.cancel();
      if (_locationServicesStarted) _checkOut();
    } else if (state == AppLifecycleState.detached) {
      _presenceRef.set({'state': 'exited', 'at': ServerValue.timestamp});
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    WhisperGroup.incomingCall.removeListener(_onWgIncomingCall);
    WhisperGroup.incomingRoll.removeListener(_onWgIncomingRoll);
    HiddenContent.instance.removeListener(_onHiddenContentChanged);
    quantumSession.removeListener(_onQuantumChanged);
    _quantumEntry.dispose(); _quantumCollapse.dispose(); _quantumGlow.dispose();
    _quantumClock?.cancel(); _chimeBell?.dispose();
    for (final sub in _signalSubs) { sub.cancel(); }
    _positionStream?.cancel(); _compassStream?.cancel(); _accelerometerStream?.cancel();
    _incomingRequestsStream?.cancel(); _heartbeatTimer?.cancel(); _radarTimer?.cancel();
    _blockSubscription?.cancel(); _blockedBySubscription?.cancel(); _connectionSubscription?.cancel();
    _headingNotifier.dispose(); _pitchNotifier.dispose(); _scaleNotifier.dispose(); _activeUsersNotifier.dispose(); _introFade.dispose();
    _knockTicker?.cancel(); _knockSecondsLeft.dispose(); _arcFlow.dispose(); _dissolve.dispose();
    _resonanceSubscription?.cancel(); _sparkle.dispose(); _cityMoodTimer?.cancel(); _focusTimer?.cancel(); _gatheringSub?.cancel(); _handoffOfferSub?.cancel();
    // 刪除帳號後已登出，不再寫入
    if (FirebaseAuth.instance.currentUser != null) _presenceRef.set({'state': 'exited', 'at': ServerValue.timestamp});
    WidgetsBinding.instance.removeObserver(this); super.dispose();
  }

  Widget _buildSensingScreen() => Scaffold(
        backgroundColor: Night.night900,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Night.space6),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(tr.sensingCity, style: const TextStyle(color: Night.inkMuted, letterSpacing: 2)),
              if (widget.checkIn) ...[
                const SizedBox(height: Night.space4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(tr.sensingCityHint, style: Night.caption.copyWith(height: 1.6), textAlign: TextAlign.center),
                ),
              ],
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_locationIssue != _LocationIssue.none && _currentPosition == null) return _buildLocationBlocker();
    if (_currentPosition == null || _mapStyle == null || _sensingHold) return _buildSensingScreen();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;
    double currentRhythmScore = _coolingSystem.getRhythmScore();

    return Scaffold(
      body: Listener(
        onPointerDown: (_) => _markRadarActive(),
        child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (details) => _baseScale = _scaleNotifier.value,
        onScaleUpdate: (details) {
          // 量子世界：兩指縮小可以看到整個蜂巢
          _scaleNotifier.value = (_baseScale * details.scale).clamp(quantumOn ? 0.03 : 0.2, 8.0);
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
              // 量子世界裡不畫系統藍點：那是真實位置
              myLocationEnabled: _myAvatarUrl.isEmpty && !quantumOn,
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

                      // 量子世界的蜂巢：格點、自己的席位、101 光柱、世界視角的遠方光點
                      if (quantumSession.value case final qs?)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) {
                                final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
                                return CustomPaint(
                                  painter: QuantumHivePainter(
                                    p: QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: currentHeading, pitch: smoothPitch,
                                        scale: currentScale, screenHeight: screenHeight, center: Offset(centerX, centerY)),
                                    seat: qs.seatCenter, dots: _quantumDots, glow: _quantumGlow.value,
                                    boost: _chimeBoost(QuantumChime.offset(DateTime.now())),
                                    cameo: AiyaPrefs.enabled.value ? aiyaCameoPresence : 0,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      // 艾婭偶爾在光柱裡現身（整點、每天第一次進來、偶遇）；設定關掉就不出現
                      if (quantumSession.value != null)
                        Positioned.fill(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: AiyaPrefs.enabled,
                            builder: (context, aiyaOn, _) => !aiyaOn ? const SizedBox.shrink()
                                : AiyaCameo(anchor: () => _aiyaPillarAnchor(screenWidth, screenHeight), onTap: () => openAiya(context)),
                          ),
                        ),
                      // 艾婭：101 光柱底下的「艾婭 · AI」標籤，點了就敲門（設定裡可以關掉）
                      if (quantumSession.value != null)
                        Positioned.fill(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: AiyaPrefs.enabled,
                            builder: (context, aiyaOn, _) => !aiyaOn ? const SizedBox.shrink() : AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) {
                                final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
                                final proj = QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: currentHeading, pitch: smoothPitch,
                                    scale: currentScale, screenHeight: screenHeight, center: Offset(centerX, centerY));
                                final hit = proj.project(0, 0);
                                if (hit == null) return const SizedBox.shrink();
                                final at = hit.$1;
                                if (at.dx < 0 || at.dx > screenWidth || at.dy < 0 || at.dy > screenHeight) return const SizedBox.shrink();
                                return Stack(children: [
                                  Positioned(left: at.dx - 70, top: at.dy - 2, width: 140, child: AiyaPillarChip(onTap: () => openAiya(context))),
                                ]);
                              },
                            ),
                          ),
                        ),
                      // 低語團的集合點：團色光柱（畫面外就在邊緣出現箭頭）；只在一般雷達、有進行中的集合呼叫時顯示
                      if (!quantumOn && _currentPosition != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: ValueListenableBuilder<WgGroup?>(
                              valueListenable: WhisperGroup.current,
                              builder: (context, g, _) {
                                final call = g?.call;
                                if (g == null || call == null) return const SizedBox.shrink();
                                final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
                                final o = quantumLocal(call.lat, call.lng);
                                final proj = QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: currentHeading, pitch: smoothPitch,
                                    scale: currentScale, screenHeight: screenHeight, center: Offset(centerX, centerY));
                                final screen = (Offset.zero & Size(screenWidth, screenHeight)).deflate(36);
                                final end = _entangleEnd(proj, screen, o.east, o.north);
                                if (end == null) return const SizedBox.shrink();
                                final pos = _currentPosition!;
                                final dist = Geolocator.distanceBetween(pos.latitude, pos.longitude, call.lat, call.lng);
                                final distText = dist < 1000 ? '${dist.round()} m' : '${(dist / 1000).toStringAsFixed(1)} km';
                                return CustomPaint(painter: WgPillarPainter(
                                  at: end.$1, offscreen: end.$2, center: Offset(centerX, centerY), color: g.tint,
                                  label: [if (call.place.isNotEmpty) call.place, distText].join('\n'), glow: 0.5,
                                ));
                              },
                            ),
                          ),
                        ),
                      // 整點報時（光之使者、鐘聲光圈、光波、報時微光）與糾纏光線：畫在氣泡底下
                      if (quantumOn)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) {
                                final now = DateTime.now();
                                final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
                                final proj = QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: currentHeading, pitch: smoothPitch,
                                    scale: currentScale, screenHeight: screenHeight, center: Offset(centerX, centerY));
                                final screen = (Offset.zero & Size(screenWidth, screenHeight)).deflate(24);
                                final ends = <(Offset, String)>[], offscreen = <bool>[];
                                for (final partner in _quantumPartners) {
                                  final o = quantumLocal(partner.lat, partner.lng);
                                  if (_entangleEnd(proj, screen, o.east, o.north) case (final at, final out)?) {
                                    ends.add((at, out || currentScale < _quantumWorldScale ? partner.nickname : ''));
                                    offscreen.add(out);
                                  }
                                }
                                final chiming = QuantumChime.active(now);
                                return Stack(children: [
                                  if (chiming || _quantumFlights.isNotEmpty)
                                    Positioned.fill(child: CustomPaint(painter: QuantumChimePainter(
                                      p: proj, t: QuantumChime.offset(now), strikes: _strikeTimes(now),
                                      count: _chimeCount, flights: _quantumFlights, nowMs: now.millisecondsSinceEpoch,
                                    ))),
                                  if (ends.isNotEmpty && !_quantumSelfCollapse)
                                    Positioned.fill(child: CustomPaint(painter: QuantumEntanglePainter(
                                      me: Offset(centerX, centerY), ends: ends, offscreen: offscreen, phase: (now.millisecondsSinceEpoch % 2400) / 2400,
                                    ))),
                                ]);
                              },
                            ),
                          ),
                        ),
                      // 量子世界裡自己也是球型頭像（款式和心情色同別人看到的一樣；不畫系統藍點，那是真實位置）
                      if (quantumOn && !_quantumSelfCollapse && !_quantumReform)
                        Positioned(
                          left: centerX - 28, top: centerY - 28,
                          child: IgnorePointer(child: ValueListenableBuilder<String>(
                            valueListenable: OrbPrefs.style,
                            builder: (context, style, _) => QuantumOrb(style: style, color: _getMoodColor(_myMood), size: 56, image: orbImage(_myAvatarUrl)),
                          )),
                        ),

                      // 🌟 完美維持你自己的定位點縮小設定
                      if (!quantumOn && _myAvatarUrl.isNotEmpty && !_quantumSelfCollapse && !_quantumReform) 
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

                      // 城市燈塔的友善公廁：最底層，在低語穿越、信封與氣泡下面
                      // 量子世界裡沒有公廁燈塔、心情據點、低語穿越與低語：只留下此刻在場的人
                      if (_beaconOn && !quantumOn)
                        ..._visibleBeaconToilets.map((t) {
                          final v = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, t.lat, t.lng, currentHeading, t.id, currentRhythmScore);
                          if (v.opacity <= 0.0) return const SizedBox.shrink();
                          final d = (v.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6) * currentScale;
                          final a = v.relativeAngle * pi / 180.0;
                          final rx = d * sin(a); final ry = -d * cos(a) * cos(smoothPitch); final rz = -d * cos(a) * sin(smoothPitch);
                          final ww = max(0.01, 1.0 + (rz * 0.002));
                          return Positioned(left: centerX + rx / ww - 20, top: centerY + ry / ww - 20, child: BeaconMarker(toilet: t, onTap: () => showBeaconSheet(context, t)));
                        }),
                      // 今天看過名片的心情據點：靜止的柔光，退到背景，不擋氣泡
                      if (!quantumOn) ..._placeLamps(seen: true, centerX: centerX, centerY: centerY, screenHeight: screenHeight, pitch: smoothPitch, heading: currentHeading, scale: currentScale, rhythm: currentRhythmScore),
                      // 我的低語穿越（只有自己看得到）：在信封與氣泡下面
                      if (!quantumOn) ..._timeWhispers.map((w) {
                        final v = WhisperEngine.calculateBubbleVisuals(_currentPosition!.latitude, _currentPosition!.longitude, w.lat, w.lng, currentHeading, w.id, currentRhythmScore);
                        if (v.opacity <= 0.0) return const SizedBox.shrink();
                        final d = (v.distance / WhisperEngine.maxVisibleDistance) * (screenHeight * 0.6) * currentScale;
                        final a = v.relativeAngle * pi / 180.0;
                        final rx = d * sin(a); final ry = -d * cos(a) * cos(smoothPitch); final rz = -d * cos(a) * sin(smoothPitch);
                        final ww = max(0.01, 1.0 + (rz * 0.002));
                        return Positioned(left: centerX + rx / ww - 13, top: centerY + ry / ww - 13, child: _buildTimeWhisperMarker(w));
                      }),
                      // 低語信封（畫在氣泡底下）
                      if (!quantumOn) ..._whispers.map((w) {
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
                      // 量子世界的世界視角（縮到超過一般雷達範圍）：每個人都只是一個光點，不顯示心情；放大回來才看得到
                      if (!quantumOn || currentScale >= _quantumWorldScale)
                        ..._buildBubbleLayer(activeUsers, centerX, centerY, screenWidth, screenHeight, smoothPitch, currentHeading, currentScale, currentRhythmScore),
                      // 量子共振光環、量子訊號：浮在氣泡上面
                      if (quantumOn && (_resonanceUntil.isNotEmpty || _signalFloats.isNotEmpty))
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) {
                                final now = DateTime.now().millisecondsSinceEpoch;
                                _resonanceUntil.removeWhere((_, until) => until < now);
                                _signalFloats.removeWhere((f) => now - f.startMs > QuantumSignalFloat.durationMs);
                                final ring = <(Offset, Offset?)>[];
                                var ringT = 0.0;
                                for (final e in _resonanceUntil.entries) {
                                  ringT = 1 - (e.value - now) / 10000;
                                  ring.add((Offset(centerX, centerY), _bubbleAnchors[e.key]));
                                }
                                return Stack(children: [
                                  if (ring.isNotEmpty) Positioned.fill(child: CustomPaint(painter: QuantumResonancePainter(pairs: ring, t: ringT.clamp(0.0, 1.0)))),
                                  for (final f in _signalFloats)
                                    if (_bubbleAnchors[f.uid] case final at?)
                                      Builder(builder: (context) {
                                        final k = (now - f.startMs) / QuantumSignalFloat.durationMs;
                                        return Positioned(
                                          left: at.dx + 26, top: at.dy - 70 - 36 * k,
                                          child: Opacity(opacity: (k < 0.15 ? k / 0.15 : 1 - max(0.0, k - 0.6) / 0.4).clamp(0.0, 1.0),
                                              child: Text(quantumSignalEmoji[f.signal], style: TextStyle(fontSize: 26 + 6 * sin(k * pi)))),
                                        );
                                      }),
                                ]);
                              },
                            ),
                          ),
                        ),
                      // 還在呼吸的心情據點小燈畫在氣泡上面，才點得到（只有 150 公尺內的一兩盞）
                      if (!quantumOn) ..._placeLamps(seen: false, centerX: centerX, centerY: centerY, screenHeight: screenHeight, pitch: smoothPitch, heading: currentHeading, scale: currentScale, rhythm: currentRhythmScore),
                      // 地圖資料授權要求可見的出處標示（OpenStreetMap ODbL、OpenMapTiles）
                      // 放在底部選單下方的空間，不佔地圖
                      Positioned(left: 20, bottom: max(1.0, MediaQuery.of(context).padding.bottom - 14), child: const IgnorePointer(child: Text('© OpenMapTiles © OpenStreetMap', style: TextStyle(color: Night.inkFaint, fontSize: 10, letterSpacing: 0.5)))),
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
                      // 塌縮離場：自己或旁邊的人主動離開量子世界，氣泡化成光點散掉
                      if (_quantumCollapse.isAnimating && (_quantumSelfCollapse || _quantumReform || _quantumBursts.isNotEmpty))
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumCollapse,
                              builder: (context, _) {
                                final c = quantumLocal(_radarCenter.lat, _radarCenter.lng);
                                final proj = QuantumProjector(centerEast: c.east, centerNorth: c.north, heading: currentHeading, pitch: smoothPitch,
                                    scale: currentScale, screenHeight: screenHeight, center: Offset(centerX, centerY));
                                return Stack(children: [
                                  // 穿隧時在新席位重組：倒著播，光點往中心聚攏
                                  if (_quantumSelfCollapse || _quantumReform)
                                    Positioned.fill(child: CustomPaint(painter: ParticleBurstPainter(origin: Offset(centerX, centerY), progress: _quantumCollapse.value, color: Night.auroraBlue))),
                                  for (final b in _quantumBursts)
                                    if (proj.project(quantumLocal(b.lat, b.lng).east, quantumLocal(b.lat, b.lng).north) case (final at, _)?)
                                      Positioned.fill(child: CustomPaint(painter: ParticleBurstPainter(origin: at, progress: _quantumCollapse.value, color: Night.auroraBlue))),
                                ]);
                              },
                            ),
                          ),
                        ),
                      // 等待回音的倒數條
                      // 集會的置頂公告，以及等待回音的倒數條（依序排在城市心情下方）
                      if (_ritualTarget != null || (!quantumOn && (_hostedGathering != null || _joinedGathering != null)))
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 56, left: Night.space4, right: Night.space4,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            if (quantumOn ? null : (_hostedGathering ?? _joinedGathering) case final g?)
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
                      // 整點報時的倒數與報時微光
                      if (quantumOn && QuantumChime.active(DateTime.now()))
                        Positioned(
                          top: MediaQuery.of(context).padding.top + (_ritualTarget != null ? 104 : 56), left: Night.space4, right: Night.space4,
                          child: Center(child: QuantumChimeBanner(
                            t: QuantumChime.offset(DateTime.now()), hour: QuantumChime.strikes(DateTime.now()) % 24,
                            sent: _chimeSent, count: _chimeCount, onLook: _lookAtOrigin, onSend: _sendChimeGlimmer,
                          )),
                        ),
                      // 量子跨年：一起跨年的人數，在報時列下面留 1 分鐘
                      if (quantumOn && _isNewYearChime(DateTime.now()) && QuantumChime.offset(DateTime.now()) >= QuantumNewYearBanner.from && QuantumChime.offset(DateTime.now()) <= QuantumNewYearBanner.until)
                        Positioned(
                          top: MediaQuery.of(context).padding.top + (_ritualTarget != null ? 104 : 56) + 54, left: Night.space4, right: Night.space4,
                          child: Center(child: QuantumNewYearBanner(count: max(max(1, quantumSession.value?.online ?? 1), _newYearCount))),
                        ),
                      // 城市心情天氣
                      // 城市心情天氣；在量子世界改成席位代號＋世界在線人數
                      Positioned(top: MediaQuery.of(context).padding.top + 10, left: Night.space4,
                          child: quantumOn ? QuantumOnlineChip(onTap: _openQuantumSheet) : _buildCityMoodChip()),
                      // 平行宇宙開關（右上角，只有圖標）；進入量子世界時暫時離開平行宇宙
                      if (!quantumOn)
                        Positioned(top: MediaQuery.of(context).padding.top + 10, right: Night.space4, child: ParallelUniverseButton(onToggle: _toggleParallelUniverse)),
                      // 量子世界開關：打卡後才能進入（平行宇宙開關下方；在場時移到最上面）
                      if (_locationServicesStarted)
                        Positioned(top: MediaQuery.of(context).padding.top + (quantumOn ? 10 : 62), right: Night.space4, child: QuantumWorldButton(onTap: _toggleQuantum)),
                      // 打卡：還沒打卡時只看得到地圖，按下才會出現在地圖上、看到附近的人
                      if (!_locationServicesStarted && !_checkInRequested)
                        Positioned(left: Night.space6, right: Night.space6, bottom: MediaQuery.of(context).padding.bottom + 152, child: _buildCheckInCard()),
                      // 走離打卡的地方：別人看到的還是打卡的位置，提醒可以重新打卡
                      if (_locationServicesStarted && _movedFarFromCheckIn && !quantumOn)
                        Positioned(left: 0, right: 0, bottom: MediaQuery.of(context).padding.bottom + 152, child: Center(child: _buildReCheckInPill())),
                      // 空雷達：附近沒有人時，不留白，告訴使用者他正在發光
                      if (_locationServicesStarted && _hasScanned && activeUsers.isEmpty && !_emptyCardDismissed && !_movedFarFromCheckIn && !quantumOn)
                        Positioned(left: Night.space6, right: Night.space6, bottom: MediaQuery.of(context).padding.bottom + 152, child: _buildEmptyRadarCard()),
                      // 城市燈塔開關與篩選（底部選單左上方）
                      if (!quantumOn)
                      Positioned(
                        left: Night.space4, bottom: MediaQuery.of(context).padding.bottom + 92,
                        // 低語團按鈕：只有在團裡（團主或團員）才出現，放在城市燈塔旁
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          BeaconControls(on: _beaconOn, filters: _beaconFilters, count: _visibleBeaconToilets.length, onToggle: _toggleBeacon, onFilter: _toggleBeaconFilter),
                          const SizedBox(width: Night.space2),
                          const WhisperGroupButton(),
                        ]),
                      ),
                      // 結束打卡（底部選單右上方）
                      if (_locationServicesStarted && !quantumOn)
                        Positioned(right: Night.space4, bottom: MediaQuery.of(context).padding.bottom + 92, child: _buildCheckOutPill()),
                      Positioned(left: Night.space4, right: Night.space4, bottom: MediaQuery.of(context).padding.bottom + 16, child: _buildDock()),
                      // 整點前 10 秒的大倒數
                      if (quantumOn && QuantumChime.offset(DateTime.now()) >= -11 && QuantumChime.offset(DateTime.now()) < 0)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) => CustomPaint(painter: QuantumCountdownPainter(t: QuantumChime.offset(DateTime.now()))),
                            ),
                          ),
                        ),
                      // 量子跨年：量子中心午夜的光爆、新年數字和 5 分鐘煙火
                      if (quantumOn && _isNewYearChime(DateTime.now()) && QuantumChime.offset(DateTime.now()) >= -1 && QuantumChime.offset(DateTime.now()) <= QuantumFireworksPainter.duration)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumGlow,
                              builder: (context, _) => CustomPaint(painter: QuantumFireworksPainter(
                                t: QuantumChime.offset(DateTime.now()), year: QuantumNewYear.year(QuantumNewYear.serverAt!),
                                intensity: min(1.0, sqrt(max(_newYearCount, _chimeCount).toDouble()) / 10),
                              )),
                            ),
                          ),
                        ),
                      // 量子世界的入場儀式：蓋在最上面
                      if (_quantumEntry.isAnimating)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _quantumEntry,
                              builder: (context, _) => CustomPaint(painter: QuantumEntryPainter(t: _quantumEntry.value, code: _quantumEntryCode)),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              ),
            ),
          ],
        ),
      ),
      ), // Listener
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
  final String? parallelCity; // 平行宇宙的人：虛線光環，用城市取代距離
  final Color? dayTint; // 量子世界的晝夜色調：依主人的當地時間
  final bool newYear; // 量子跨年：主人的時區已經跨年，頭像外一圈金色光環
  final String? orb; // 量子化身：量子世界裡用光球取代大頭貼
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
    this.parallelCity,
    this.dayTint,
    this.newYear = false,
    this.orb,
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
                      // 平行宇宙的人：頭像外一圈淡紫色細環，和身邊的人一眼分得出來
                      if (widget.parallelCity != null)
                        Container(
                          width: avatarSize + 12, height: avatarSize + 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Night.auroraViolet.withOpacity(0.75), width: 1),
                            boxShadow: [BoxShadow(color: Night.auroraViolet.withOpacity(0.25), blurRadius: 10)],
                          ),
                        ),
                      // 晝夜蜂巢：頭像外一圈主人當地時間的色調（清晨淡金、白天亮白、黃昏橘紫、深夜深藍）
                      if (widget.dayTint case final tint?)
                        Container(
                          width: avatarSize + 10, height: avatarSize + 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: tint.withOpacity(0.85), width: 2),
                            boxShadow: [BoxShadow(color: tint.withOpacity(0.35), blurRadius: 10)],
                          ),
                        ),
                      // 量子跨年：已經跨年的人，頭像外一圈金色光環
                      if (widget.newYear)
                        Container(
                          width: avatarSize + 16, height: avatarSize + 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFD54F), width: 2.5),
                            boxShadow: const [BoxShadow(color: Color(0x99FFD54F), blurRadius: 18, spreadRadius: 2)],
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
                      if (widget.orb case final orb?)
                        // 量子化身：大頭貼合成的球型頭像，球緣和光暈是心情色；敲門中、殘影的顏色規則和大頭貼一樣
                        QuantumOrb(style: orb, color: accent, size: 56, glow: glowValue, image: orbImage(peerAvatarUrl),
                            dim: widget.isShadow || (widget.isInactive && !isPending))
                      else
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
                Text([
                  if (widget.hostEmoji != null) '${tr.labelHost} ${widget.hostEmoji}',
                  if (widget.isDemo) tr.labelDemo,
                  widget.displayName,
                  if (widget.parallelCity == null) widget.distanceLabel,
                  if (widget.isInactive) tr.labelResting,
                ].join(' · '), style: Night.caption.copyWith(shadows: const [Shadow(color: Night.night900, blurRadius: 6)]), overflow: TextOverflow.ellipsis),
                // 平行宇宙的位置是投影的，不顯示距離；對方的城市獨立一行，名字長也不會被截掉
                if (widget.parallelCity != null)
                  Text('🪐 ${parallelCityName(widget.parallelCity!)}', style: Night.caption.copyWith(color: Night.auroraViolet, shadows: const [Shadow(color: Night.night900, blurRadius: 6)]), overflow: TextOverflow.ellipsis),
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