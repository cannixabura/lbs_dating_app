import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'ui/night.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 🌟 這裡為你設計了 5 頁的簡短文案，並指定了圖片檔名
  final List<Map<String, String>> _introData = [
    {
      "image": "assets/images/intro_1.png",
      "title": "沒入這座城市",
      "description": "拋開繁雜的社交標籤，在極簡的暗黑畫布上，只留下你最真實的情緒與座標。"
    },
    {
      "image": "assets/images/intro_2.png",
      "title": "片刻的交集",
      "description": "看見附近浮動的心情氣泡？輕輕敲門，與擦肩而過的人產生一期一會的對話。"
    },
    {
      "image": "assets/images/intro_3.png",
      "title": "城市的節奏",
      "description": "我們在意你的感受。發送敲門後請靜待回音，若無緣交集，300 秒後氣泡將悄悄消散。"
    },
    {
      "image": "assets/images/intro_4.png",
      "title": "溫柔的距離",
      "description": "不想被打擾？點擊婉拒或封鎖。專屬的冷卻系統會為你隔絕喧囂，還你安靜的角落。"
    },
    {
      "image": "assets/images/intro_5.png",
      "title": "準備好相遇了嗎？",
      "description": "閉上眼睛，感受手機的震動與心跳。現在，寫下你此刻的心情，走進城市低語。"
    },
  ];

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_intro', true); // 記錄使用者已看過
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Night.night900,
      body: Stack(
        children: [
          // 滑動的頁面內容
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _introData.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 圖片區域 (如果找不到圖片會顯示灰色佔位符，方便你開發時不報錯)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset(
                        _introData[index]["image"]!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Center(child: Text("等待載入高清圖片...", style: TextStyle(color: Colors.white38))),
                        ),
                      ),
                    ),
                  ),
                  // 文字區域
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          Text(
                            _introData[index]["title"]!,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _introData[index]["description"]!,
                            style: const TextStyle(color: Colors.white54, fontSize: 16, height: 1.6),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 頂部的跳過按鈕 (Skip)
          if (_currentPage < _introData.length - 1)
            Positioned(
              top: 50, right: 20,
              child: TextButton(
                onPressed: _completeIntro,
                child: const Text("略過", style: TextStyle(color: Night.inkMuted, fontSize: 16)),
              ),
            ),

          // 底部的指示器與下一步按鈕
          Positioned(
            bottom: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 圓點指示器
                Row(
                  children: List.generate(
                    _introData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        gradient: _currentPage == index ? Night.brightGradient : null,
                        color: _currentPage == index ? null : Night.night600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                // 按鈕
                _currentPage == _introData.length - 1
                    ? NightButton('開始探索', onPressed: _completeIntro)
                    : IconButton(
                        onPressed: () {
                          _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        tooltip: '下一頁',
                        icon: const Icon(Icons.arrow_forward_ios, color: Night.auroraBlue),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}