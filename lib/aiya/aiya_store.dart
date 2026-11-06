import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

const _aiyaUrl = String.fromEnvironment('AIYA_URL', defaultValue: 'https://asia-southeast1-mood-whisper-f7de9.cloudfunctions.net/aiya');

/// 本機測試用：flutter run --dart-define=AIYA_MOCK=true，App 直接打開艾婭，伺服器回應用假資料
const aiyaMock = bool.fromEnvironment('AIYA_MOCK');
/// 本機測試用：--dart-define=AIYA_LIVE=true，App 直接打開艾婭但連正式伺服器
const aiyaLive = bool.fromEnvironment('AIYA_LIVE');
const aiyaDirect = aiyaMock || aiyaLive;
int _mockTurns = 0;
const _mockReplies = [
  ('今晚的台北有點安靜，好多人都寫了「累」。你也是嗎？', 'think'),
  ('哇，聽起來你今天走了好長一段路。', 'surprise'),
  ('我會在光裡陪你一下，慢慢說就好。', 'smile'),
  ('偷偷告訴你，第 4 圈今晚有好多人睡不著。', 'wink'),
];

Future<Map<String, dynamic>> _mockCall(String action, Map<String, dynamic> body) async {
  await Future.delayed(Duration(milliseconds: action == 'say' ? 1200 : 300));
  final session = {'id': 'mock', 'turnsLeft': 20 - _mockTurns, 'remainingMs': 600000};
  return switch (action) {
    'status' => {'success': true, 'freeLeft': 3, 'credits': 0, 'consented': false, 'session': null},
    'open' => {'success': true, 'resumed': false, 'freeLeft': 2, 'credits': 0, 'session': session},
    'say' => () { final r = _mockReplies[_mockTurns++ % _mockReplies.length]; return {'success': true, 'reply': r.$1, 'expression': r.$2, 'session': session}; }(),
    _ => {'success': true},
  };
}

/// 呼叫伺服器的艾婭 API；連不上時回傳 {success: false, code: 'busy'}
Future<Map<String, dynamic>> aiyaCall(String action, [Map<String, dynamic> body = const {}]) async {
  if (aiyaMock) return _mockCall(action, body);
  try {
    if (aiyaLive && FirebaseAuth.instance.currentUser == null) await FirebaseAuth.instance.signInAnonymously();
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http
        .post(Uri.parse(_aiyaUrl),
            headers: {'Content-Type': 'application/json', 'Accept-Language': currentLanguageTag, if (token != null) 'Authorization': 'Bearer $token'},
            body: jsonEncode({'action': action, 'lang': currentLanguageTag, ...body}))
        .timeout(const Duration(seconds: 40));
    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : {'success': false, 'code': 'busy'};
  } catch (_) {
    return {'success': false, 'code': 'busy'};
  }
}

/// 設定裡的「艾婭」開關：關掉後量子世界的光柱不再顯示艾婭
class AiyaPrefs {
  AiyaPrefs._();
  static final enabled = ValueNotifier<bool>(true);
  static const _key = 'aiyaEnabled';

  static Future<void> load() async {
    try { enabled.value = (await SharedPreferences.getInstance()).getBool(_key) ?? true; } catch (_) {}
  }

  static Future<void> setEnabled(bool v) async {
    enabled.value = v;
    try { await (await SharedPreferences.getInstance()).setBool(_key, v); } catch (_) {}
  }
}

/// 艾婭時光包（消耗型）與艾婭之友（自動續訂月費）。和量子化身共用同一個購買串流，各自只處理自己的商品。
class AiyaStore {
  AiyaStore._();

  static const products = {'aiya_time_5': 5, 'aiya_time_20': 20};
  static const friendProduct = 'aiya_friend_monthly';
  static final details = ValueNotifier<Map<String, ProductDetails>>(const {});
  static final busy = ValueNotifier<bool>(false);
  static final credits = ValueNotifier<int?>(null);
  /// 艾婭之友的到期時間（伺服器驗證過的）；null = 還不知道，0 = 不是艾婭之友
  static final friendExp = ValueNotifier<int?>(null);
  static bool get isFriend => (friendExp.value ?? 0) > DateTime.now().millisecondsSinceEpoch;
  /// 正在恢復購買：結果要告訴使用者（找到或沒找到）
  static bool _restoring = false;

  /// 伺服器回傳的狀態（status / open / verify 都有）
  static void applyStatus(Map<String, dynamic> s) {
    if (s['friendExp'] is num) friendExp.value = (s['friendExp'] as num).toInt();
  }

  /// 管理訂閱：Apple 或 Google 的訂閱設定頁（取消、變更都在那裡）
  static Uri get manageUrl => Platform.isIOS
      ? Uri.parse('https://apps.apple.com/account/subscriptions')
      : Uri.parse('https://play.google.com/store/account/subscriptions?sku=$friendProduct&package=com.softchip.moodwhisper');
  /// 購買結果的提示文字（畫面顯示一次後清掉）
  static final notice = ValueNotifier<String?>(null);
  static StreamSubscription<List<PurchaseDetails>>? _sub;

  /// App 啟動時呼叫一次；Android 上次沒完成的交易由量子化身的 restorePurchases 一起帶回來
  static void init() {
    _sub ??= InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (_) => busy.value = false);
  }

  static Future<void> loadProducts() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) return;
      final response = await InAppPurchase.instance.queryProductDetails({...products.keys, friendProduct});
      details.value = {for (final p in response.productDetails) p.id: p};
    } catch (_) {}
  }

  static Future<void> buy(String productId) async {
    final product = details.value[productId];
    if (product == null) { notice.value = tr.aiyaStoreUnavailable; return; }
    busy.value = true;
    try {
      // 先由伺服器驗證、加次數，再結束交易（Android 會在結束時消耗掉，之後可以再買）
      final started = await InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: product), autoConsume: true);
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.aiyaPurchaseFailed;
    }
  }

  /// 訂閱艾婭之友（自動續訂）
  static Future<void> buyFriend() async {
    final product = details.value[friendProduct];
    if (product == null) { notice.value = tr.aiyaStoreUnavailable; return; }
    busy.value = true;
    try {
      final started = await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
      if (!started) busy.value = false;
    } catch (_) {
      busy.value = false;
      notice.value = tr.aiyaPurchaseFailed;
    }
  }

  /// 恢復購買：找回這個 Apple ID／Google 帳戶的艾婭之友訂閱（時光包是消耗型，無法恢復）
  static Future<void> restore() async {
    _restoring = true;
    busy.value = true;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (_) {
      notice.value = tr.aiyaPurchaseFailed;
    }
    // 沒有可恢復的購買時商店不會回傳任何東西：稍後重新問一次伺服器就結束
    Future.delayed(const Duration(seconds: 5), () async {
      if (!_restoring) return;
      _restoring = false;
      applyStatus(await aiyaCall('status'));
      busy.value = false;
      notice.value = isFriend ? tr.aiyaFriendRestored : tr.aiyaFriendNotFound;
    });
  }

  static Future<void> _onPurchases(List<PurchaseDetails> list) async {
    final mine = [for (final p in list) if (products.containsKey(p.productID) || p.productID == friendProduct) p];
    if (mine.isEmpty) return;
    final toVerify = <PurchaseDetails>[];
    for (final p in mine) {
      switch (p.status) {
        case PurchaseStatus.pending:
          busy.value = true;
        case PurchaseStatus.canceled:
          busy.value = false;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.error:
          busy.value = false;
          notice.value = tr.aiyaPurchaseFailed;
          if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
        case PurchaseStatus.purchased || PurchaseStatus.restored:
          toVerify.add(p);
      }
    }
    if (toVerify.isEmpty) return;
    final data = await aiyaCall('verify', {
      'purchases': [
        for (final p in toVerify)
          Platform.isIOS
              ? {'platform': 'apple', 'productId': p.productID, 'data': p.verificationData.serverVerificationData}
              : {'platform': 'google', 'productId': p.productID, 'token': p.verificationData.serverVerificationData},
      ],
    });
    busy.value = false;
    final wasRestoring = _restoring;
    _restoring = false;
    if (data['success'] != true) { notice.value = tr.aiyaPurchaseFailed; return; } // 交易留著，下次啟動再送
    final wasFriend = isFriend;
    applyStatus(data);
    if (data['credits'] is num) credits.value = (data['credits'] as num).toInt();
    var added = 0;
    var friendNew = false, friendElsewhere = false;
    final results = (data['results'] as List? ?? const []).whereType<Map>().toList();
    for (var i = 0; i < toVerify.length; i++) {
      final result = i < results.length ? '${results[i]['result']}' : '';
      // 加過了（或這筆已經屬於別的帳號、不必再試）才結束交易；連不上或驗證失敗時留著
      if (result == 'granted' || result == 'already' || result == 'owned_elsewhere') {
        if (toVerify[i].productID == friendProduct) {
          if (result == 'granted' && toVerify[i].status == PurchaseStatus.purchased) friendNew = true;
          if (result == 'owned_elsewhere') friendElsewhere = true;
        } else if (result == 'granted') {
          added += products[toVerify[i].productID] ?? 0;
        }
        if (toVerify[i].pendingCompletePurchase) await InAppPurchase.instance.completePurchase(toVerify[i]);
      }
    }
    // 自動續訂、啟動時補送的交易不打擾使用者，只有自己按的購買和恢復購買才提示
    if (friendElsewhere) {
      notice.value = tr.aiyaFriendElsewhere;
    } else if (friendNew || (wasRestoring && isFriend) || (!wasFriend && isFriend && toVerify.any((p) => p.productID == friendProduct && p.status == PurchaseStatus.purchased))) {
      notice.value = wasRestoring ? tr.aiyaFriendRestored : tr.aiyaFriendWelcome;
    } else if (added > 0) {
      notice.value = tr.aiyaPurchased(added);
    } else if (wasRestoring) {
      notice.value = isFriend ? tr.aiyaFriendRestored : tr.aiyaFriendNotFound;
    } else if (toVerify.any((p) => products.containsKey(p.productID))) {
      notice.value = tr.aiyaPurchaseFailed;
    }
  }
}
