import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 🌟 只保留 Google Maps 的金鑰初始化 (請確認這裡有填入你的真實 API Key)
    // GMSServices.provideAPIKey("AIzaSyDWdhgdEvCCg3o-SybUSfFX3fOhwiS_0pE")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}