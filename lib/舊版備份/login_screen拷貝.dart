import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // 引入以跳轉到 BlankCanvasScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  bool _isLoading = true;
  final TextEditingController _moodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signInAnonymously();
    _loadSavedMood(); // 🌟 核心修正 1：啟動時自動載入上次儲存的心情
  }

  // 🌟 新增：讀取本地儲存的心情並填入輸入框
  Future<void> _loadSavedMood() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMood = prefs.getString('saved_mood');
    if (savedMood != null && mounted) {
      setState(() {
        _moodController.text = savedMood;
      });
    }
  }

  // 1. 執行 Firebase 匿名登入
  Future<void> _signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      if (mounted) {
        setState(() {
          _currentUser = userCredential.user;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("登入失敗: $e");
    }
  }

  // 2. 帶著 UID 與心情進入城市畫布
  // 🌟 核心修正 2：改為非同步，進入城市前強制儲存最新心情到本地
  Future<void> _enterCity() async {
    if (_moodController.text.trim().isEmpty) return;

    // 將心情存入手機本地記憶體
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_mood', _moodController.text.trim());

    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlankCanvasScreen(
          uid: _currentUser!.uid,
          initialMood: _moodController.text.trim(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _moodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white54)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "此時此刻，你想對城市說什麼？",
                      style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 2),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _moodController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                      maxLength: 15,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        counterText: "", // 隱藏字數限制提示
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSubmitted: (_) => _enterCity(),
                    ),
                    const SizedBox(height: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
                      onPressed: _enterCity,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}