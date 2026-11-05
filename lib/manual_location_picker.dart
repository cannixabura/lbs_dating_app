import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// 抓不到定位時的備案（例如沒有 GPS 的 iPad、訊號很弱的室內）：
/// 在地圖上移動，讓中間的光點對準自己現在的位置。回傳選好的經緯度，取消回傳 null。
class ManualLocationPicker extends StatefulWidget {
  final String mapStyle;
  final LatLng initial;
  const ManualLocationPicker({super.key, required this.mapStyle, required this.initial});

  @override
  State<ManualLocationPicker> createState() => _ManualLocationPickerState();
}

class _ManualLocationPickerState extends State<ManualLocationPicker> {
  MapLibreMapController? _map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Night.night900,
      body: Stack(children: [
        MapLibreMap(
          styleString: widget.mapStyle,
          initialCameraPosition: CameraPosition(target: widget.initial, zoom: 14),
          trackCameraPosition: true,
          onMapCreated: (c) => _map = c,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          logoViewMargins: const Point(-100, -100),
          attributionButtonMargins: const Point(-100, -100),
        ),
        // 中間的光點：地圖移動，光點固定在畫面中央
        IgnorePointer(
          child: Center(
            child: Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Night.auroraBlue, width: 3),
                boxShadow: const [BoxShadow(color: Night.auroraBlue, blurRadius: 18, spreadRadius: 2)],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Night.space4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              GlassCard(
                child: Row(children: [
                  IconButton(icon: const Icon(Icons.close, color: Night.ink), onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: Night.space2),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text(tr.locationPickTitle, style: Night.title),
                      const SizedBox(height: 4),
                      Text(tr.locationPickHint, style: Night.caption),
                    ]),
                  ),
                ]),
              ),
              const Spacer(),
              NightButton(tr.locationPickConfirm, icon: Icons.check, expand: true, onPressed: () {
                final target = _map?.cameraPosition?.target ?? widget.initial;
                Navigator.pop(context, target);
              }),
            ]),
          ),
        ),
      ]),
    );
  }
}
