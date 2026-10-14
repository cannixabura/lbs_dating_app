import UIKit
import Flutter
import CoreHaptics

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var hapticEngine: CHHapticEngine?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 心跳觸覺：Dart 端呼叫 citywhisper/haptics 的 heartbeat
    if let registrar = self.registrar(forPlugin: "CityWhisperHaptics") {
      let channel = FlutterMethodChannel(name: "citywhisper/haptics", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "heartbeat" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.playHeartbeat()
        result(nil)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// 兩次「噗通－噗通」：每拍一輕一重，用 Core Haptics 精準控制時間與力道。
  private func playHeartbeat() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      // 不支援 Core Haptics 的裝置：用一般觸覺回饋模擬
      let light = UIImpactFeedbackGenerator(style: .medium)
      let heavy = UIImpactFeedbackGenerator(style: .heavy)
      light.impactOccurred()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) { heavy.impactOccurred() }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { light.impactOccurred() }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.91) { heavy.impactOccurred() }
      return
    }
    do {
      if hapticEngine == nil {
        hapticEngine = try CHHapticEngine()
        hapticEngine?.isAutoShutdownEnabled = true
      }
      try hapticEngine?.start()

      func beat(_ time: TimeInterval, _ intensity: Float, _ sharpness: Float) -> CHHapticEvent {
        CHHapticEvent(
          eventType: .hapticTransient,
          parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
          ],
          relativeTime: time)
      }
      let events = [
        beat(0.00, 0.55, 0.25), beat(0.16, 1.00, 0.35),  // 噗通
        beat(0.75, 0.55, 0.25), beat(0.91, 1.00, 0.35),  // 噗通
      ]
      let player = try hapticEngine?.makePlayer(with: CHHapticPattern(events: events, parameters: []))
      try player?.start(atTime: CHHapticTimeImmediate)
    } catch {
      UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
  }
}
