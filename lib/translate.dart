import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 聊天翻譯：完全在手機上進行（Google ML Kit），訊息不會上傳。
/// 先顯示原文，點一下才翻譯；第一次翻某種語言要下載模型（約 30 MB），下載前先問。
class ChatTranslator {
  ChatTranslator._();

  static final _identifier = LanguageIdentifier(confidenceThreshold: 0.5);
  static final _models = OnDeviceTranslatorModelManager();
  static final Map<String, OnDeviceTranslator> _translators = {};
  static final Map<String, TranslateLanguage?> _detected = {};

  /// App 的語言 → ML Kit 的語言（App 支援的 8 種語言都有）
  static TranslateLanguage targetOf(Locale locale) => switch (locale.languageCode) {
        'en' => TranslateLanguage.english,
        'ja' => TranslateLanguage.japanese,
        'ko' => TranslateLanguage.korean,
        'ms' => TranslateLanguage.malay,
        'id' => TranslateLanguage.indonesian,
        'vi' => TranslateLanguage.vietnamese,
        _ => TranslateLanguage.chinese,
      };

  /// ML Kit 的中文只會輸出簡體，繁體使用者要再轉換
  static bool wantsTraditional(Locale locale) => locale.languageCode == 'zh' && locale.scriptCode != 'Hans';

  /// 這則訊息是什麼語言；認不出來回傳 null。結果會快取。
  static Future<TranslateLanguage?> detect(String text) async {
    if (_detected.containsKey(text)) return _detected[text];
    TranslateLanguage? found;
    try {
      final code = await _identifier.identifyLanguage(text);
      found = code == 'und' ? null : BCP47Code.fromRawValue(code.split('-').first);
    } catch (_) {}
    return _detected[text] = found;
  }

  /// 需要翻譯（或繁簡轉換）才回傳 true
  static Future<bool> needsTranslation(String text, Locale locale) async {
    final source = await detect(text);
    if (source == null) return false;
    final target = targetOf(locale);
    if (source != target) return true;
    return source == TranslateLanguage.chinese && wantsTraditional(locale) && ChineseConverter.toTraditional(text) != text;
  }

  static Future<bool> _hasModel(TranslateLanguage l) => _models.isModelDownloaded(l.bcpCode);

  /// 翻譯；需要下載模型時先問使用者。使用者取消或失敗回傳 null。
  static Future<String?> translate(BuildContext context, String text, Locale locale) async {
    final source = await detect(text);
    if (source == null) return null;
    final target = targetOf(locale);
    final traditional = wantsTraditional(locale);
    await ChineseConverter.load();
    if (source == target) return traditional ? ChineseConverter.toTraditional(text) : text;

    final missing = [for (final l in {source, target}) if (!await _hasModel(l)) l];
    if (missing.isNotEmpty) {
      if (!context.mounted || !await _confirmDownload(context)) return null;
      for (final l in missing) {
        if (!await _models.downloadModel(l.bcpCode, isWifiRequired: false)) return null;
      }
    }
    final translator = _translators.putIfAbsent('${source.bcpCode}>${target.bcpCode}',
        () => OnDeviceTranslator(sourceLanguage: source, targetLanguage: target));
    final out = await translator.translateText(text);
    return traditional && target == TranslateLanguage.chinese ? ChineseConverter.toTraditional(out) : out;
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
