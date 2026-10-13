import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _moodController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); 

  @override
  void initState() {
    super.initState();
    _prefillLastMood();

    // 🌟 核心修正：加入 400 毫秒的延遲。
    // 這是為了確保從 IntroScreen 切換過來的轉場動畫已經「完全結束」，
    // 再呼叫鍵盤，避免 iOS 系統因為動畫還在跑而把鍵盤擋下來。
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  // 再次進入 App 時，自動帶入上一次的心情（第一次使用則保持空白）
  Future<void> _prefillLastMood() async {
    final prefs = await SharedPreferences.getInstance();
    final String lastMood = prefs.getString('saved_mood')?.trim() ?? '';
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
    super.dispose();
  }

  Future<void> _enterCity() async {
    final mood = _moodController.text.trim();
    if (mood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請留下你此刻的心情，再沒入城市。'),
          backgroundColor: Colors.white24,
        ),
      );
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('無法連上城市，請檢查網路後再試一次。'), backgroundColor: Colors.redAccent),
        );
      }
      return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "此時此刻，\n你想對城市說什麼？",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                
                TextField(
                  controller: _moodController,
                  focusNode: _focusNode,
                  // 🌟 核心修正：將 autofocus 改為 false，完全交給我們上面的 Future.delayed 來精準控制
                  autofocus: false, 
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 18),
                  textAlign: TextAlign.center,
                  maxLength: 20, 
                  cursorColor: Colors.tealAccent,
                  textInputAction: TextInputAction.done, 
                  onSubmitted: (_) => _enterCity(), 
                  decoration: const InputDecoration(
                    hintText: '例如：喝了一杯好咖啡😊',
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 16),
                    counterStyle: TextStyle(color: Colors.white38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                ElevatedButton(
                  onPressed: _enterCity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "沒入城市",
                    style: TextStyle(fontSize: 16, letterSpacing: 4.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}