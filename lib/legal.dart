import 'package:url_launcher/url_launcher.dart';

/// 使用條款與隱私權政策。條款內容有實質變更時，把 [termsVersion] 往後改，
/// 所有人下次進入 App 時都會被要求重新同意。
class Legal {
  Legal._();

  static const termsVersion = '2026-10';
  static const contactEmail = 'cannixabura@gmail.com';
  static final termsUrl = Uri.parse('https://mood-whisper-f7de9.web.app/terms.html');
  static final privacyUrl = Uri.parse('https://mood-whisper-f7de9.web.app/privacy.html');

  static Future<void> open(Uri url) => launchUrl(url, mode: LaunchMode.inAppBrowserView);

  static Future<void> emailUs() => launchUrl(Uri(scheme: 'mailto', path: contactEmail, query: 'subject=城市低語 意見回報'));
}
