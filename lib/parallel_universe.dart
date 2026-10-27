import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 平行宇宙：其他城市也開啟的人，依城市比例投影到你的雷達上（伺服器負責投影與模糊化）。
/// 預設關閉；開啟時同時「看得到別人」與「被別人看到」。
final parallelUniverseOn = ValueNotifier<bool>(false);

/// 伺服器判定你所在的城市：null = 還不知道（關閉或還沒掃描到），'' = 不在支援的城市
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

/// 雷達右上角的開關：只有圖標，開啟時發紫光（跟左下角的城市燈塔一樣）
class ParallelUniverseButton extends StatelessWidget {
  final VoidCallback onToggle;
  const ParallelUniverseButton({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: parallelUniverseOn,
      builder: (context, on, _) => ValueListenableBuilder<String?>(
        valueListenable: parallelHomeCity,
        builder: (context, city, _) {
          // 伺服器回覆前不下結論：null = 還不知道，'' = 不在支援的城市
          final status = !on || city == null ? tr.parallelUniverseSubtitle
              : city.isEmpty ? tr.parallelUniverseNoCity
              : tr.parallelFrom(parallelCityName(city));
          return Semantics(
            button: true,
            toggled: on,
            label: '${tr.parallelUniverse}，$status',
            child: Tooltip(
              message: status,
              child: GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Night.glassFill,
                    shape: BoxShape.circle,
                    border: Border.all(color: on ? Night.auroraViolet : Night.glassLine),
                    boxShadow: on ? [BoxShadow(color: Night.auroraViolet.withOpacity(0.45), blurRadius: 14)] : null,
                  ),
                  child: Icon(Icons.public, size: 22, color: on ? Night.auroraViolet : Night.inkMuted),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
