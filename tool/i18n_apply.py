"""把一批介面文字寫進語言檔，並把程式裡寫死的中文換成 tr.xxx。

用法：python3 tool/i18n_apply.py <catalog.json>

catalog.json：
{
  "file": "lib/main.dart",            // 預設要改的檔案
  "entries": [
    {"key": "close", "zh": "關閉", "en": "Close"},
    {"key": "gatheringEnded", "zh": "{emoji} {name} 已結束", "en": "{emoji} {name} has ended",
     "ph": {"emoji": "String", "name": "String"},
     "edits": [["'${ended.emoji} ${ended.name} 已結束'", "tr.gatheringEnded(ended.emoji, ended.name)"]]}
  ]
}
- 沒有 edits 的條目：把 '<zh>'（單引號字串）換成 tr.<key>。
- edits 的每一筆是 [舊字串, 新字串] 或 [檔案, 舊字串, 新字串]；舊字串一定要找得到，找不到就停下來。
- 已經在語言檔裡、而且中文相同的 key 會沿用；同名但中文不同就停下來，避免一個 key 兩種意思。
- 其他語言（ja、ko…）另外由 tool/i18n_translate.py 寫入。
"""
import json
import os
import sys
from collections import OrderedDict

ROOT = os.path.join(os.path.dirname(__file__), "..")
ARB_DIR = os.path.join(ROOT, "lib", "l10n")


def load_arb(lang):
    path = os.path.join(ARB_DIR, f"app_{lang}.arb")
    if not os.path.exists(path):
        return path, OrderedDict([("@@locale", lang)])
    return path, json.load(open(path, encoding="utf-8"), object_pairs_hook=OrderedDict)


def save_arb(path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def main():
    catalog = json.load(open(sys.argv[1], encoding="utf-8"))
    default_file = catalog.get("file")
    zh_path, zh = load_arb("zh")
    en_path, en = load_arb("en")
    files = {}
    errors = []

    def text(path):
        if path not in files:
            files[path] = open(os.path.join(ROOT, path), encoding="utf-8").read()
        return files[path]

    for e in catalog["entries"]:
        key = e["key"]
        if key in zh and zh[key] != e["zh"]:
            errors.append(f"{key}: 語言檔裡已有不同的中文「{zh[key]}」")
            continue
        zh[key] = e["zh"]
        en[key] = e["en"]
        if e.get("ph"):
            meta = {"placeholders": {name: {"type": t} for name, t in e["ph"].items()}}
            zh["@" + key] = meta
        edits = e.get("edits")
        if edits is None:
            edits = [["'" + e["zh"] + "'", "tr." + key]]
        for ed in edits:
            path, old, new = (ed if len(ed) == 3 else [e.get("file", default_file)] + ed)
            src = text(path)
            n = src.count(old)
            if n == 0:
                errors.append(f"{key}: 在 {path} 找不到 {old}")
                continue
            files[path] = src.replace(old, new)

    if errors:
        print("\n".join(errors))
        sys.exit(1)
    for path, src in files.items():
        open(os.path.join(ROOT, path), "w", encoding="utf-8").write(src)
    save_arb(zh_path, zh)
    save_arb(en_path, en)
    print(f"{len(catalog['entries'])} entries, {len(files)} files")


if __name__ == "__main__":
    main()
