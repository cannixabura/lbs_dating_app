import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 平行宇宙：其他城市也開啟的人，依城市比例投影到你的雷達上（伺服器負責投影與模糊化）。
/// 預設關閉；開啟時同時「看得到別人」與「被別人看到」。
final parallelUniverseOn = ValueNotifier<bool>(false);

/// 伺服器判定你所在的城市；null = 不在任何支援的城市（或還沒掃描到）
final parallelHomeCity = ValueNotifier<String?>(null);

const _prefKey = 'parallel_universe';

Future<void> loadParallelUniverse() async {
  final prefs = await SharedPreferences.getInstance();
  parallelUniverseOn.value = prefs.getBool(_prefKey) ?? false;
}

Future<void> setParallelUniverse(bool on) async {
  parallelUniverseOn.value = on;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_prefKey, on);
}

/// 伺服器的城市代碼 → 目前語言的城市名稱
String parallelCityName(String id) => switch (id) {
      'taipei' => tr.cityTaipei,
      'taichung' => tr.cityTaichung,
      'kaohsiung' => tr.cityKaohsiung,
      'tokyo' => tr.cityTokyo,
      'osaka' => tr.cityOsaka,
      'seoul' => tr.citySeoul,
      'busan' => tr.cityBusan,
      'hongkong' => tr.cityHongkong,
      'macau' => tr.cityMacau,
      'singapore' => tr.citySingapore,
      'kualalumpur' => tr.cityKualalumpur,
      'jakarta' => tr.cityJakarta,
      'hochiminh' => tr.cityHochiminh,
      'hanoi' => tr.cityHanoi,
      _ => id,
    };

/// 開啟前先說明會發生什麼事；按「進入」才開啟
Future<bool> confirmParallelUniverse(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x99070B1F),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Night.space6),
      child: GlassCard(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.public, color: Night.auroraViolet, size: 36),
          const SizedBox(height: Night.space3),
          Text(tr.parallelUniverseIntroTitle, style: Night.title, textAlign: TextAlign.center),
          const SizedBox(height: Night.space2),
          Text(tr.parallelUniverseIntroBody, style: Night.body),
          const SizedBox(height: Night.space4),
          Row(children: [
            Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext, false))),
            const SizedBox(width: Night.space2),
            Expanded(child: NightButton(tr.parallelUniverseEnter, icon: Icons.public, onPressed: () => Navigator.pop(dialogContext, true))),
          ]),
        ]),
      ),
    ),
  );
  return ok == true;
}
