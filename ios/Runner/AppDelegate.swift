import UIKit
import Flutter
import CoreHaptics
import NaturalLanguage
import SwiftUI
import Translation

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
    // 聊天與心情翻譯：Dart 端 citywhisper/translate（Android 用 ML Kit，見 Translator.kt）
    if let registrar = self.registrar(forPlugin: "CityWhisperTranslate") {
      let channel = FlutterMethodChannel(name: "citywhisper/translate", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { [weak self] call, result in
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {
        case "identify":
          result(identifyLanguage(args["text"] as? String ?? ""))
        case "status":
          AppleTranslator.status(source: args["source"] as? String ?? "", target: args["target"] as? String ?? "") { result($0) }
        case "translate":
          // 用了 SceneDelegate，AppDelegate 的 window 是 nil，要從場景找
          let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first { $0.isKeyWindow } ?? self?.window
          guard let window else { result(FlutterError(code: "translate", message: "no window", details: nil)); return }
          AppleTranslator.shared.translate(
            args["text"] as? String ?? "", source: args["source"] as? String ?? "", target: args["target"] as? String ?? "", in: window
          ) { text in
            if let text { result(text) } else { result(FlutterError(code: "translate", message: "failed", details: nil)) }
          }
        default:
          result(FlutterMethodNotImplemented)
        }
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

/// 這段文字是什麼語言（例如 en、ja、zh-Hans、zh-Hant）；認不出來回傳 und
private func identifyLanguage(_ text: String) -> String {
  let recognizer = NLLanguageRecognizer()
  recognizer.processString(text)
  guard let (language, confidence) = recognizer.languageHypotheses(withMaximum: 1).first, confidence >= 0.5 else { return "und" }
  return language.rawValue
}

/// Apple 翻譯（iOS 18）：完全在手機上進行；需要下載語言時，系統會自己問使用者。
/// 翻譯只能透過 SwiftUI 的 translationTask 取得，所以在畫面上放一個看不見的 1×1 視圖。
final class AppleTranslator: ObservableObject {
  static let shared = AppleTranslator()

  struct Job {
    let text: String
    let source: Locale.Language
    let target: Locale.Language
    let completion: (String?) -> Void
  }

  @Published var configuration: TranslationSession.Configuration?
  private var queue: [Job] = []
  private var current: Job?
  private var host: UIHostingController<TranslationHost>?

  static func status(source: String, target: String, completion: @escaping (String) -> Void) {
    Task {
      let status = await LanguageAvailability().status(from: Locale.Language(identifier: source), to: Locale.Language(identifier: target))
      let text: String
      switch status {
      case .installed: text = "installed"
      case .supported: text = "supported"
      default: text = "unsupported"
      }
      await MainActor.run { completion(text) }
    }
  }

  func translate(_ text: String, source: String, target: String, in window: UIWindow, completion: @escaping (String?) -> Void) {
    attach(to: window)
    queue.append(Job(text: text, source: Locale.Language(identifier: source), target: Locale.Language(identifier: target), completion: completion))
    startNext()
  }

  private func attach(to window: UIWindow) {
    guard host == nil, let root = window.rootViewController else { return }
    let controller = UIHostingController(rootView: TranslationHost(translator: self))
    controller.view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    controller.view.backgroundColor = .clear
    controller.view.isUserInteractionEnabled = false
    root.addChild(controller)
    root.view.addSubview(controller.view)
    controller.didMove(toParent: root)
    host = controller
  }

  private func startNext() {
    guard current == nil, !queue.isEmpty else { return }
    let job = queue.removeFirst()
    current = job
    if let config = configuration, config.source == job.source, config.target == job.target {
      configuration?.invalidate() // 同一組語言：重新觸發 translationTask
    } else {
      configuration = TranslationSession.Configuration(source: job.source, target: job.target)
    }
  }

  @MainActor
  func run(_ session: TranslationSession) async {
    guard let job = current else { return }
    var out: String?
    do { out = try await session.translate(job.text).targetText } catch { out = nil }
    current = nil
    job.completion(out)
    startNext()
  }
}

struct TranslationHost: View {
  @ObservedObject var translator: AppleTranslator

  var body: some View {
    Color.clear
      .frame(width: 1, height: 1)
      .translationTask(translator.configuration) { session in
        await translator.run(session)
      }
  }
}
