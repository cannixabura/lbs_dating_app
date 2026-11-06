import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 在地圖上顯示位置的同意（Apple 5.1.2(i)：要先詢問、使用者可以拒絕）。
/// 第一次打卡（雷達或量子世界）前問一次；拒絕就不打卡、不出現在任何人的地圖上。
/// 設定裡可以隨時關掉，關掉後目前的打卡立即結束，下次打卡會再問一次。
class MapConsent {
  MapConsent._();
  static const _key = 'map_location_consent';
  static final allowed = ValueNotifier<bool>(false);

  static Future<void> load() async {
    try { allowed.value = (await SharedPreferences.getInstance()).getBool(_key) ?? false; } catch (_) {}
  }

  static Future<void> set(bool v) async {
    allowed.value = v;
    try { await (await SharedPreferences.getInstance()).setBool(_key, v); } catch (_) {}
  }
}

/// 已經同意就直接回 true；否則顯示說明，讓使用者選「允許」或「不允許」
Future<bool> ensureMapConsent(BuildContext context) async {
  await MapConsent.load();
  if (MapConsent.allowed.value) return true;
  if (!context.mounted) return false;
  final ok = await showModalBottomSheet<bool>(
    context: context, isDismissible: false, enableDrag: false, backgroundColor: Colors.transparent, isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        // 先墊一層實心底色，後面的條款文字才不會透出來
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Icon(Icons.where_to_vote_outlined, color: Night.auroraViolet, size: 32),
            const SizedBox(height: Night.space3),
            Text(tr.mapConsentTitle, style: Night.title, textAlign: TextAlign.center),
            const SizedBox(height: Night.space3),
            Text(tr.mapConsentBody, style: Night.body),
            const SizedBox(height: Night.space4),
            NightButton(tr.mapConsentAllow, icon: Icons.check, onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: Night.space2),
            NightButton(tr.mapConsentDecline, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(ctx, false)),
          ]),
          ),
        ),
      ),
    ),
  );
  if (ok == true) {
    await MapConsent.set(true);
    return true;
  }
  if (context.mounted) showGlassToast(context, tr.mapConsentDeclined, icon: Icons.visibility_off_outlined);
  return false;
}
