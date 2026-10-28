"""心情據點：檢查 places/places.json、把照片調成夜景色調，輸出 App 下載的清單。

用法：python3 tool/build_places.py
輸入：places/places.json、places/photos/{id}.jpg（或 .jpeg/.png/.webp）
輸出：hosting/places/v1.json、hosting/img/place/{id}.webp
有任何欄位不對就列出來並停下，不寫檔。之後由使用者部署網站（firebase deploy --only hosting）。
"""
import json
import os
import re
import sys
from datetime import datetime, timedelta, timezone

from PIL import Image, ImageEnhance

ROOT = os.path.join(os.path.dirname(__file__), "..")
SRC = os.path.join(ROOT, "places", "places.json")
PHOTOS = os.path.join(ROOT, "places", "photos")
OUT_JSON = os.path.join(ROOT, "hosting", "places", "v1.json")
OUT_IMG = os.path.join(ROOT, "hosting", "img", "place")

DAYS = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
TIME = re.compile(r"^([0-2]\d|3[0]):([0-5]\d)$")
DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
ID = re.compile(r"^[a-z]\d{3}$")
STORY_MAX = 40
# 台灣本島與離島（含金門、馬祖、澎湖、綠島、蘭嶼）；不收中國大陸
LAT_RANGE, LNG_RANGE = (21.8, 26.5), (118.1, 122.1)
PHOTO_WIDTH = 960


def minutes(t):
    h, m = t.split(":")
    return int(h) * 60 + int(m)


def check(places):
    errors, ids = [], set()
    for i, p in enumerate(places):
        where = p.get("id") or f"第 {i + 1} 家"
        for key in ("id", "name", "lat", "lng", "address", "hours", "story"):
            if key not in p:
                errors.append(f"{where}: 缺少 {key}")
        if errors:
            continue
        if not ID.match(p["id"]):
            errors.append(f"{where}: id 要像 p001（一個小寫字母加三位數字）")
        if p["id"] in ids:
            errors.append(f"{where}: id 重複")
        ids.add(p["id"])
        if not (LAT_RANGE[0] <= p["lat"] <= LAT_RANGE[1] and LNG_RANGE[0] <= p["lng"] <= LNG_RANGE[1]):
            errors.append(f"{where}: 座標不在台灣範圍內")
        if len(p["story"]) > STORY_MAX:
            errors.append(f"{where}: 心情故事 {len(p['story'])} 字，最多 {STORY_MAX} 字")
        for day, ranges in p["hours"].items():
            if day not in DAYS:
                errors.append(f"{where}: 營業時間的 {day} 不是 mon～sun")
                continue
            for r in ranges:
                if len(r) != 2 or not all(TIME.match(t) for t in r):
                    errors.append(f"{where}: {day} 的時間 {r} 要寫成 [\"12:00\", \"22:00\"]")
                elif not minutes(r[0]) < minutes(r[1]) <= 30 * 60 or minutes(r[0]) >= 24 * 60:
                    errors.append(f"{where}: {day} 的時間 {r} 不合理（開始要早於結束，最晚到隔天 06:00，例如 26:00）")
        for d in p.get("closed", []):
            if not DATE.match(d):
                errors.append(f"{where}: 公休日 {d} 要寫成 2026-12-31")
        if photo_path(p["id"]) is None:
            errors.append(f"{where}: 找不到照片 places/photos/{p['id']}.jpg")
    return errors


def photo_path(pid):
    for ext in ("jpg", "jpeg", "png", "webp"):
        path = os.path.join(PHOTOS, f"{pid}.{ext}")
        if os.path.exists(path):
            return path
    return None


def night_grade(src, dst):
    """統一的夜景色調：稍微壓暗、降低飽和，再疊一層藍紫"""
    img = Image.open(src).convert("RGB")
    if img.width > PHOTO_WIDTH:
        img = img.resize((PHOTO_WIDTH, round(img.height * PHOTO_WIDTH / img.width)), Image.LANCZOS)
    img = ImageEnhance.Brightness(img).enhance(0.82)
    img = ImageEnhance.Color(img).enhance(0.85)
    tint = Image.new("RGB", img.size, (42, 31, 102))
    img = Image.blend(img, tint, 0.16)
    img.save(dst, "WEBP", quality=78, method=6)


def main():
    places = json.load(open(SRC, encoding="utf-8"))["places"]
    errors = check(places)
    if errors:
        print("\n".join(errors))
        sys.exit(1)
    os.makedirs(OUT_IMG, exist_ok=True)
    out = []
    for p in places:
        night_grade(photo_path(p["id"]), os.path.join(OUT_IMG, f"{p['id']}.webp"))
        out.append({
            "id": p["id"], "name": p["name"], "lat": p["lat"], "lng": p["lng"],
            "address": p["address"], "phone": p.get("phone", ""),
            "hours": {d: p["hours"].get(d, []) for d in DAYS},
            "closed": p.get("closed", []), "story": p["story"],
            "photo": f"img/place/{p['id']}.webp", "test": p.get("test", False),
        })
    # 下架的店：照片一併刪掉
    keep = {f"{p['id']}.webp" for p in places}
    for f in os.listdir(OUT_IMG):
        if f not in keep:
            os.remove(os.path.join(OUT_IMG, f))
    updated = datetime.now(timezone(timedelta(hours=8))).strftime("%Y-%m-%dT%H:%M+08:00")
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump({"version": 1, "updated": updated, "places": out}, f, ensure_ascii=False, separators=(",", ":"))
    real = sum(not p["test"] for p in out)
    print(f"✓ {len(out)} 家（正式 {real}、測試 {len(out) - real}）→ hosting/places/v1.json")


if __name__ == "__main__":
    main()
