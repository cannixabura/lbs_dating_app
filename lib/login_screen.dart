import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'legal.dart';
import 'main.dart'; 
import 'ui/night.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _moodController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); 
  // 使用條款：第一次使用、或條款版本更新後，必須勾選同意才能進入
  bool _needsConsent = true;
  bool _agreed = false;
  // 年齡：第一次使用先單獨詢問（中立的年齡確認，不預設答案）；未滿 18 歲直接進入說明頁
  bool _ageConfirmed = false;
  bool _ready = false; // 讀完偏好設定前不顯示，避免年齡問題閃一下
  late final TapGestureRecognizer _termsTap = TapGestureRecognizer()..onTap = () => Legal.open(Legal.termsUrl);
  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer()..onTap = () => Legal.open(Legal.privacyUrl);

  @override
  void initState() {
    super.initState();
    _prefillLastMood();

    // 🌟 核心修正：加入 400 毫秒的延遲。
    // 這是為了確保從 IntroScreen 切換過來的轉場動畫已經「完全結束」，
    // 再呼叫鍵盤，避免 iOS 系統因為動畫還在跑而把鍵盤擋下來。
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && _ageConfirmed) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  // 再次進入 App 時，自動帶入上一次的心情（第一次使用則保持空白）
  Future<void> _prefillLastMood() async {
    final prefs = await SharedPreferences.getInstance();
    final String lastMood = prefs.getString('saved_mood')?.trim() ?? '';
    if (mounted) {
      setState(() {
        if (prefs.getString('terms_accepted_version') == Legal.termsVersion) _needsConsent = false;
        _ageConfirmed = prefs.getBool(AgeGate.confirmedKey) ?? false;
        _ready = true;
      });
    }
    // 使用者已經開始輸入就不覆蓋
    if (!mounted || lastMood.isEmpty || _moodController.text.isNotEmpty) return;
    _moodController.value = TextEditingValue(
      text: lastMood,
      selection: TextSelection.collapsed(offset: lastMood.length), // 游標放在最後，方便接著修改
    );
  }

  @override
  void dispose() {
    _moodController.dispose();
    _focusNode.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  Future<void> _enterCity() async {
    final mood = _moodController.text.trim();
    if (mood.isEmpty) {
      showGlassToast(context, '請留下你此刻的心情，再沒入城市。', icon: Icons.edit_outlined);
      return;
    }
    if (_needsConsent && !_agreed) {
      showGlassToast(context, '請先閱讀並勾選同意使用條款與隱私權政策。', icon: Icons.description_outlined);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_mood', mood);

    // 🔐 以 Firebase 匿名登入取得 uid：不需註冊，但伺服器與資料庫規則能驗證身分
    String finalUid;
    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
      if (user == null) throw Exception('anonymous sign-in returned no user');
      finalUid = user.uid;
    } catch (e) {
      if (mounted) showGlassToast(context, '無法連上城市，請檢查網路後再試一次。', icon: Icons.wifi_off, danger: true);
      return;
    }

    if (_needsConsent) {
      // 記錄同意的條款版本：手機上一份，資料庫一份（審核時可佐證）
      await prefs.setString('terms_accepted_version', Legal.termsVersion);
      FirebaseDatabase.instance.ref('consents/$finalUid')
          .set({'version': Legal.termsVersion, 'at': ServerValue.timestamp})
          .catchError((Object e) => debugPrint('consent write failed: $e'));
    }

    if (!mounted) return;
    
    _focusNode.unfocus(); 

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlankCanvasScreen(
          // 🌟 這裡傳入型態絕對安全的 finalUid，編譯器就不會再報錯了！
          uid: finalUid, 
          initialMood: mood,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Future<void> _answerAge(bool adult) async {
    final prefs = await SharedPreferences.getInstance();
    if (!adult) {
      await prefs.setBool(AgeGate.blockedKey, true);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AgeBlockedScreen()), (_) => false);
      return;
    }
    await prefs.setBool(AgeGate.confirmedKey, true);
    if (!mounted) return;
    setState(() => _ageConfirmed = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  Widget _ageCard() {
    return GlassCard(
      glow: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('請問你已年滿 18 歲了嗎？', style: Night.title, textAlign: TextAlign.center),
        const SizedBox(height: Night.space2),
        const Text('城市低語會與附近的陌生人互動，僅限 18 歲以上使用。', style: Night.body, textAlign: TextAlign.center),
        const SizedBox(height: Night.space4),
        Row(children: [
          Expanded(child: NightButton('未滿 18 歲', kind: NightButtonKind.ghost, onPressed: () => _answerAge(false))),
          const SizedBox(width: Night.space2),
          Expanded(child: NightButton('已滿 18 歲', kind: NightButtonKind.ghost, onPressed: () => _answerAge(true))),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canEnter = !_needsConsent || _agreed;
    if (!_ready) return const Scaffold(backgroundColor: Night.night900);
    return Scaffold(
      backgroundColor: Night.night900,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Night.space6, vertical: Night.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (rect) => Night.brightGradient.createShader(rect),
                          child: const Text('準備好', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 2)),
                        ),
                      ),
                      const TextSpan(text: '相遇了嗎？'),
                    ]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Night.ink, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 2),
                  ),
                  const SizedBox(height: Night.space3),
                  Center(child: Container(width: 128, height: 2, decoration: BoxDecoration(gradient: Night.brightGradient, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: Night.space3),
                  const Text('閉上眼睛，感受手機的震動與心跳。\n現在，寫下你此刻的心情，走進城市低語。', style: Night.body, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space8),
                  if (!_ageConfirmed) _ageCard() else GlassCard(
                    glow: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('此時此刻，你想對城市說什麼？', style: Night.caption),
                        const SizedBox(height: Night.space2),
                        TextField(
                          controller: _moodController,
                          focusNode: _focusNode,
                          // 🌟 核心修正：將 autofocus 改為 false，完全交給我們上面的 Future.delayed 來精準控制
                          autofocus: false, 
                          style: const TextStyle(color: Night.ink, fontSize: 17),
                          maxLength: 20, 
                          cursorColor: Night.auroraViolet,
                          textInputAction: TextInputAction.done, 
                          onSubmitted: (_) => _enterCity(), 
                          decoration: InputDecoration(
                            hintText: '例如：喝了一杯好咖啡😊',
                            hintStyle: const TextStyle(color: Night.inkFaint, fontSize: 15),
                            counterStyle: Night.caption,
                            filled: true,
                            fillColor: Night.night700,
                            contentPadding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: 14),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.glassLine)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.auroraViolet, width: 2)),
                          ),
                        ),
                        if (_needsConsent) ...[
                          const SizedBox(height: Night.space2),
                          _consentRow(),
                        ],
                        const SizedBox(height: Night.space4),
                        NightButton('走進城市低語', expand: true, onPressed: canEnter ? _enterCity : null),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _consentRow() {
    const linkStyle = TextStyle(color: Night.auroraBlue, decoration: TextDecoration.underline, decorationColor: Night.auroraBlue);
    return Semantics(
      checked: _agreed,
      label: '我已閱讀並同意使用條款與隱私權政策',
      child: InkWell(
        onTap: () => setState(() => _agreed = !_agreed),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Night.space2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 22, height: 22,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: _agreed ? Night.deepViolet : Night.night700,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _agreed ? Night.auroraViolet : Night.glassLine, width: 1.5),
              ),
              child: _agreed ? const Icon(Icons.check, size: 16, color: Night.onDeep) : null,
            ),
            const SizedBox(width: Night.space3),
            Expanded(
              child: Text.rich(
                TextSpan(style: const TextStyle(color: Night.inkMuted, fontSize: 13, height: 1.6), children: [
                  const TextSpan(text: '我已閱讀及同意'),
                  TextSpan(text: '《使用條款》', style: linkStyle, recognizer: _termsTap),
                  const TextSpan(text: '與'),
                  TextSpan(text: '《隱私權政策》', style: linkStyle, recognizer: _privacyTap),
                  const TextSpan(text: '。城市低語對騷擾、色情與仇恨等不當內容零容忍，違者將被移出城市。'),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


/// 年齡確認的偏好設定鍵
class AgeGate {
  static const confirmedKey = 'age_confirmed_18';
  static const blockedKey = 'age_blocked_under_18';
}

/// 未滿 18 歲：只顯示說明，無法進入城市。
/// iOS 不允許 App 自行結束（審核會視為當機），所以以這一頁取代；Android 另外提供「離開」。
class AgeBlockedScreen extends StatelessWidget {
  const AgeBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Night.night900,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Night.space6),
            child: GlassCard(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.nights_stay_outlined, color: Night.inkMuted, size: 44),
                const SizedBox(height: Night.space3),
                const Text('城市低語僅限 18 歲以上使用', style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space3),
                const Text('謝謝你的誠實。這座城市會與陌生人互動，等你滿 18 歲，我們再見。', style: Night.body, textAlign: TextAlign.center),
                if (Platform.isAndroid) ...[
                  const SizedBox(height: Night.space6),
                  NightButton('離開', kind: NightButtonKind.ghost, expand: true, onPressed: () => SystemNavigator.pop()),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
