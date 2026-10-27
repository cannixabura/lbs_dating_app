import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel, rootBundle;

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 聊天與心情翻譯：完全在手機上進行，訊息不會上傳。
/// iPhone 用 Apple 翻譯（iOS 18，需要下載語言時系統會自己問），
/// Android 用 Google ML Kit（第一次翻某種語言要下載約 30 MB 的模型，下載前先問）。
/// 原生程式在 AppDelegate.swift 與 Translator.kt。
class ChatTranslator {
  ChatTranslator._();

  static const _channel = MethodChannel('citywhisper/translate');
  static final Map<String, String?> _detected = {};
  static final Map<String, bool> _pairSupported = {};

  /// App 的語言 → 翻譯用的語言代碼。iPhone 的中文分繁簡；ML Kit 的中文只有簡體，繁體之後再轉換。
  static String targetOf(Locale locale) {
    final lang = const {'en', 'ja', 'ko', 'ms', 'id', 'vi'}.contains(locale.languageCode) ? locale.languageCode : 'zh';
    if (lang == 'zh' && Platform.isIOS) return wantsTraditional(locale) ? 'zh-Hant' : 'zh-Hans';
    return lang;
  }

  static bool wantsTraditional(Locale locale) => locale.languageCode == 'zh' && locale.scriptCode != 'Hans';

  static String _base(String code) => code.split('-').first;

  /// 這段文字是什麼語言；認不出來回傳 null。結果會快取。
  static Future<String?> detect(String text) async {
    if (_detected.containsKey(text)) return _detected[text];
    String? found;
    try {
      final code = await _channel.invokeMethod<String>('identify', {'text': text});
      if (code != null && code != 'und') found = Platform.isIOS ? code : _base(code);
    } catch (_) {}
    return _detected[text] = found;
  }

  static Future<bool> _supported(String source, String target) async {
    final key = '$source>$target';
    final known = _pairSupported[key];
    if (known != null) return known;
    var ok = false;
    try {
      ok = Platform.isIOS
          ? await _channel.invokeMethod<String>('status', {'source': source, 'target': target}) != 'unsupported'
          : await _channel.invokeMethod<bool>('supported', {'lang': source}) == true;
    } catch (_) {}
    return _pairSupported[key] = ok;
  }

  /// 跟使用者的語言不同（或是簡體而使用者用繁體）、而且翻得了，才回傳 true
  static Future<bool> needsTranslation(String text, Locale locale) async {
    if (text.trim().isEmpty) return false;
    final source = await detect(text);
    if (source == null) return false;
    final target = targetOf(locale);
    if (_base(source) == _base(target)) {
      if (_base(target) != 'zh' || !wantsTraditional(locale)) return false;
      await ChineseConverter.load();
      return ChineseConverter.toTraditional(text) != text;
    }
    return _supported(source, target);
  }

  static Future<bool> _hasModel(String lang) async =>
      await _channel.invokeMethod<bool>('isDownloaded', {'lang': lang}) == true;

  /// 翻譯；Android 需要下載模型時先問使用者。取消或失敗回傳 null。
  static Future<String?> translate(BuildContext context, String text, Locale locale) async {
    final source = await detect(text);
    if (source == null) return null;
    final target = targetOf(locale);
    final traditional = wantsTraditional(locale);
    await ChineseConverter.load();
    if (_base(source) == _base(target)) return traditional ? ChineseConverter.toTraditional(text) : text;

    if (!Platform.isIOS) {
      final missing = [for (final l in {source, target}) if (!await _hasModel(l)) l];
      if (missing.isNotEmpty) {
        if (!context.mounted || !await _confirmDownload(context)) return null;
        for (final l in missing) {
          if (await _channel.invokeMethod<bool>('download', {'lang': l}) != true) return null;
        }
      }
    }
    final out = await _channel.invokeMethod<String>('translate', {'text': text, 'source': source, 'target': target});
    if (out == null) return null;
    return traditional && _base(target) == 'zh' ? ChineseConverter.toTraditional(out) : out;
  }

  static Future<bool> _confirmDownload(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x99070B1F),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(Night.space6),
        child: GlassCard(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Icon(Icons.translate, color: Night.auroraViolet, size: 32),
            const SizedBox(height: Night.space3),
            Text(tr.translateDownloadTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space2),
            Text(tr.translateDownloadBody, style: Night.body),
            const SizedBox(height: Night.space4),
            Row(children: [
              Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext, false))),
              const SizedBox(width: Night.space2),
              Expanded(child: NightButton(tr.translateDownload, icon: Icons.download, onPressed: () => Navigator.pop(dialogContext, true))),
            ]),
          ]),
        ),
      ),
    );
    return ok == true;
  }
}

/// 簡體轉繁體（台灣用語）。對照表取自 OpenCC（Apache 2.0），見 assets/opencc/NOTICE.txt。
/// 先比對詞（最長優先），再逐字轉換，最後套用台灣慣用詞。
class ChineseConverter {
  ChineseConverter._();

  static final Map<String, String> _chars = {};
  static final Map<String, String> _phrases = {};
  static final Map<String, String> _tw = {};
  static final Map<String, String> _twVariants = {};
  static int _maxPhrase = 1, _maxTw = 1;
  static Future<void>? _loading;

  static Future<void> load() => _loading ??= () async {
        final text = await rootBundle.loadString('assets/opencc/s2t.txt');
        Map<String, String> section = _chars;
        for (final line in text.split('\n')) {
          if (line.startsWith('# ')) {
            section = switch (line) { '# phrases' => _phrases, '# tw' => _tw, '# twv' => _twVariants, _ => _chars };
            continue;
          }
          final tab = line.indexOf('\t');
          if (tab > 0) section[line.substring(0, tab)] = line.substring(tab + 1);
        }
        for (final k in _phrases.keys) { if (k.length > _maxPhrase) _maxPhrase = k.length; }
        for (final k in _tw.keys) { if (k.length > _maxTw) _maxTw = k.length; }
      }();

  /// 必須先 [load]；還沒載入時原樣回傳
  static String toTraditional(String s) {
    if (_chars.isEmpty) return s;
    final t = _replace(s, _phrases, _maxPhrase, (c) => _chars[c] ?? c);
    return _replace(t, _tw, _maxTw, (c) => _twVariants[c] ?? c);
  }

  static String _replace(String s, Map<String, String> phrases, int maxLen, String Function(String) single) {
    final out = StringBuffer();
    var i = 0;
    while (i < s.length) {
      var matched = false;
      for (var len = maxLen < s.length - i ? maxLen : s.length - i; len > 1; len--) {
        final hit = phrases[s.substring(i, i + len)];
        if (hit != null) { out.write(hit); i += len; matched = true; break; }
      }
      if (!matched) { out.write(single(s[i])); i++; }
    }
    return out.toString();
  }
}
