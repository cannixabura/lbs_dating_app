import 'dart:math';
import 'package:geolocator/geolocator.dart';

/// 傳遞給 main.dart 畫布渲染使用的資料結構
class BubbleRenderData {
  final double opacity;
  final double scale;
  final double distance;
  final double relativeAngle;
  final bool isFavored;

  BubbleRenderData({
    required this.opacity,
    required this.scale,
    required this.distance,
    required this.relativeAngle,
    required this.isFavored,
  });
}

class WhisperEngine {
  // 🌟 修正 1：將最大可視距離設定為 2000 公尺 (2 公里)
  // 如果你想讓使用者看到更遠的人，可以把這個數值調大
  static const double maxVisibleDistance = 2000.0;

  /// 計算氣泡的視覺屬性 (透明度、縮放、相對角度)
  static BubbleRenderData calculateBubbleVisuals(
    double myLat, double myLng,
    double targetLat, double targetLng,
    double currentHeading,
    String targetUid,
    double rhythmScore,
  ) {
    // 1. 計算兩點間的真實地理距離 (公尺)
    double distance = Geolocator.distanceBetween(myLat, myLng, targetLat, targetLng);

    // 2. 🌟 修正 2：重新設計透明度計算公式
    double opacity = 1.0;
    if (distance >= maxVisibleDistance) {
      opacity = 0.0; // 超過最大距離直接隱藏
    } else {
      // 線性淡出：距離越近越接近 1.0，距離越遠越接近 0.0
      // 舉例：距離 32.8m 時，opacity 會是 1.0 - (32.8 / 2000) ≈ 0.98 (非常清晰)
      opacity = 1.0 - (distance / maxVisibleDistance);
      
      // 加入一點節奏分數的影響，讓活躍的城市稍微調亮整體能見度
      opacity = opacity + (rhythmScore * 0.1); 
    }
    opacity = opacity.clamp(0.0, 1.0); // 確保數值安全落在 0~1 之間

    // 3. 計算縮放比例 (近大遠小)
    // 最近時為 1.0，最遠時縮小到 0.6
    double scale = 1.0 - (distance / maxVisibleDistance) * 0.4;
    scale = scale.clamp(0.6, 1.0);

    // 4. 計算相對方位角 (用於 3D 環繞顯示)
    double dLon = (targetLng - myLng) * pi / 180.0;
    double lat1 = myLat * pi / 180.0;
    double lat2 = targetLat * pi / 180.0;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x) * 180.0 / pi;
    bearing = (bearing + 360.0) % 360.0; // 確保羅盤方位在 0~360 之間

    // 相對角度 = 目標方位角 - 手機目前面朝的羅盤角度
    double relativeAngle = bearing - currentHeading;

    // 5. 特殊狀態標記 (未來可擴充：例如特定條件下氣泡發光)
    bool isFavored = distance < 50.0; // 距離小於 50 公尺時，給予微微的高光標記

    return BubbleRenderData(
      opacity: opacity,
      scale: scale,
      distance: distance,
      relativeAngle: relativeAngle,
      isFavored: isFavored,
    );
  }
}