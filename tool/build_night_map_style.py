"""把 CARTO dark-matter-nolabels 樣式改成城市低語的「夜光」地圖。

用法：python3 tool/build_night_map_style.py <下載的 style.json> assets/map/night_style.json
顏色取自設計系統 tokens.json：深藍地面、暖橘發光道路、深藍水域加藍色光邊。
3D 霓虹建築與夜空漸層在 App 端（main.dart）加上。
"""
import copy
import json
import sys

NIGHT_800 = "#0e1433"   # 地面
NIGHT_700 = "#1a1f4a"
PARK = "#111a3e"
WATER = "#0b1d52"
WATER_EDGE = "#2a63d4"
AMBER = "#c98a3d"       # 主要道路（比 city-amber 暗一階，避免像霓虹燈管）
AMBER_MID = "#9c6a32"   # 次要道路
AMBER_DIM = "#5f4228"   # 小巷
AMBER_FAINT = "#3a3038" # 步道、服務道路
VIOLET_LINE = "#3a2f80" # 鐵路、邊界

def scale_width(width, factor):
    if isinstance(width, (int, float)):
        return width * factor
    if isinstance(width, dict) and "stops" in width:
        w = copy.deepcopy(width)
        w["stops"] = [[z, v * factor] for z, v in w["stops"]]
        return w
    return width

def road_rank(layer_id):
    if any(k in layer_id for k in ("_mot_", "_trunk_", "_pri_")):
        return "major"
    if "_sec_" in layer_id:
        return "secondary"
    if "_minor_" in layer_id:
        return "minor"
    return "faint"

def recolor(style):
    out = []
    for layer in style["layers"]:
        lid, paint = layer["id"], layer.setdefault("paint", {})
        if lid == "background":
            paint["background-color"] = NIGHT_800
        elif lid in ("landcover", "landuse"):
            paint["fill-color"] = NIGHT_800
        elif lid.startswith("park_"):
            paint["fill-color"] = PARK
        elif lid == "landuse_residential":
            paint["fill-color"] = "rgba(7, 11, 31, 0.35)"
        elif lid == "water":
            paint["fill-color"] = WATER
            paint["fill-outline-color"] = WATER_EDGE
        elif lid == "waterway":
            paint["line-color"] = WATER_EDGE
            paint["line-opacity"] = 0.7
        elif lid.startswith("boundary_"):
            paint["line-color"] = VIOLET_LINE
        elif lid.startswith("aeroway"):
            paint["line-color"] = NIGHT_700
        elif lid in ("rail", "tunnel_rail", "bridge_rail"):
            paint["line-color"] = VIOLET_LINE
        elif lid.endswith("rail_dash"):
            paint["line-color"] = NIGHT_800
        elif layer.get("source-layer") == "transportation" and layer["type"] == "line":
            rank = road_rank(lid)
            color = {"major": AMBER, "secondary": AMBER_MID, "minor": AMBER_DIM, "faint": AMBER_FAINT}[rank]
            tunnel = lid.startswith("tunnel_")
            if "_case" in lid:
                # 道路外框改成模糊的橘色光暈，形成「發光的道路」
                paint["line-color"] = color
                paint["line-blur"] = 6 if rank == "major" else 4
                paint["line-opacity"] = (0.08 if tunnel else 0.22) if rank in ("major", "secondary") else (0.05 if tunnel else 0.12)
                paint["line-width"] = scale_width(paint.get("line-width", 1), 2.6)
            else:
                paint["line-color"] = color
                paint["line-opacity"] = 0.3 if tunnel else 0.85
        elif lid == "building":
            paint["fill-color"] = NIGHT_700
            paint["fill-opacity"] = 0.6
        elif lid == "building-top":
            # 3D 霓虹建築由 App 疊加，這層只留很淡的輪廓
            paint["fill-color"] = "rgba(26, 31, 74, 0.25)"
            paint["fill-outline-color"] = "rgba(120, 110, 200, 0.25)"
        out.append(layer)
    style["layers"] = out
    style["name"] = "城市低語 夜光"
    return style

if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    style = recolor(json.load(open(src, encoding="utf-8")))
    with open(dst, "w", encoding="utf-8") as f:
        json.dump(style, f, ensure_ascii=False, separators=(",", ":"))
    print(f"wrote {dst} ({len(style['layers'])} layers)")
