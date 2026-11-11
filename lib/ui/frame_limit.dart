import 'package:flutter/foundation.dart';

/// 把動畫的重畫頻率限制在每秒 [fps] 張。
///
/// 給慢動作的環境動畫用（量子世界的呼吸光、雷達漣漪、泡泡光暈）：
/// iPhone 開了 120Hz，這些幾秒一次的呼吸原本每秒重畫 120 次，畫面看不出差別卻很耗電、發燙（11/11）。
/// 動畫本身照常跑（數值一樣），只是通知重畫的次數變少；捲動、點按不受影響。
class FrameLimited extends ChangeNotifier {
  final Listenable source;
  final int _gapUs;
  final Stopwatch _clock = Stopwatch()..start();
  int _lastUs = -1 << 40;

  FrameLimited(this.source, {int fps = 30}) : _gapUs = 1000000 ~/ fps - 2000 {
    source.addListener(_onTick);
  }

  void _onTick() {
    final now = _clock.elapsedMicroseconds;
    if (now - _lastUs < _gapUs) return;
    _lastUs = now;
    notifyListeners();
  }

  @override
  void dispose() {
    source.removeListener(_onTick);
    super.dispose();
  }
}
