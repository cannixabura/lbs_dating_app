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
    
    // 🌟 核心修正：加入 400 毫秒的延遲。
    // 這是為了確保從 IntroScreen 切換過來的轉場動畫已經「完全結束」，
    // 再呼叫鍵盤，避免 iOS 系統因為動畫還在跑而把鍵盤擋下來。
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
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

    if (!mounted) return;
    
    _focusNode.unfocus(); 

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlankCanvasScreen(
          uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
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