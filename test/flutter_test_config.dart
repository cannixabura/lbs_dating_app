import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lbs_dating_app/l10n/l10n.dart';

/// 測試都以繁體中文撰寫：測試環境的手機語言是英文，所以在每個測試檔開始前
/// 把 tr 換成繁體中文，不在 widget 裡的程式（管理器、引擎）也拿到中文文字。
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  tr = lookupAppLocalizations(const Locale('zh'));
  await testMain();
}
