import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// 目前語言的介面文字。MaterialApp 的 builder 每次語言改變時更新，
/// 所以不在 widget 裡的程式（通知、管理器）也可以直接用 `tr.xxx`。
/// 第一個畫面建好之前（main、背景推播）先用手機語言，避免還沒初始化。
AppLocalizations tr = _initialTr();

AppLocalizations _initialTr() {
  final device = PlatformDispatcher.instance.locale;
  return lookupAppLocalizations(resolveLocale(device, AppLocalizations.supportedLocales));
}

/// 使用者在設定裡選的語言；null = 跟隨手機
final appLocale = ValueNotifier<Locale?>(null);

const _localeKey = 'app_locale';

/// 設定裡「語言」選單的選項：顯示名稱用各語言自己的寫法
const languageOptions = <(Locale?, String)>[
  (null, ''), // 跟隨系統：名稱由 tr.languageSystem 提供
  (Locale('zh'), '繁體中文'),
  (Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), '简体中文'),
  (Locale('en'), 'English'),
  (Locale('ja'), '日本語'),
  (Locale('ko'), '한국어'),
  (Locale('ms'), 'Bahasa Melayu'),
  (Locale('id'), 'Bahasa Indonesia'),
  (Locale('vi'), 'Tiếng Việt'),
];

String _encode(Locale l) => [l.languageCode, if (l.scriptCode != null) l.scriptCode].join('_');

Locale? _decode(String? s) {
  if (s == null || s.isEmpty) return null;
  final parts = s.split('_');
  return parts.length > 1 ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]) : Locale(parts[0]);
}

Future<void> loadAppLocale() async {
  final prefs = await SharedPreferences.getInstance();
  appLocale.value = _decode(prefs.getString(_localeKey));
  if (appLocale.value != null) tr = lookupAppLocalizations(appLocale.value!);
}

Future<void> setAppLocale(Locale? locale) async {
  appLocale.value = locale;
  final prefs = await SharedPreferences.getInstance();
  if (locale == null) {
    await prefs.remove(_localeKey);
  } else {
    await prefs.setString(_localeKey, _encode(locale));
  }
}

/// 跟隨手機時選哪個語言：中文依字體或地區分繁簡（新加坡、馬來西亞用簡體），
/// 其他語言比對語言代碼，都沒有就用繁體中文。
Locale resolveLocale(Locale? device, Iterable<Locale> supported) {
  if (device == null) return const Locale('zh');
  if (device.languageCode == 'zh') {
    final hans = device.scriptCode == 'Hans' || (device.scriptCode == null && const {'CN', 'SG', 'MY'}.contains(device.countryCode));
    return hans ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans') : const Locale('zh');
  }
  return supported.firstWhere((l) => l.languageCode == device.languageCode && l.scriptCode == null, orElse: () => const Locale('zh'));
}

/// 伺服器與推播要知道使用者的語言：送出 zh-Hant / zh-Hans / en / ja …
String languageTag(Locale locale) {
  if (locale.languageCode == 'zh') return locale.scriptCode == 'Hans' ? 'zh-Hans' : 'zh-Hant';
  return locale.languageCode;
}

/// 目前畫面用的語言，送給伺服器（Accept-Language）讓錯誤訊息與推播用同一種語言
String get currentLanguageTag => tr.localeName == 'zh_Hans' ? 'zh-Hans' : (tr.localeName == 'zh' ? 'zh-Hant' : tr.localeName);
