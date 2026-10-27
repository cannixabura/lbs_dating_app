"""把一份翻譯（key → 文字）寫成 lib/l10n/app_<locale>.arb，順序跟 app_zh.arb 一樣。

用法：python3 tool/i18n_translate.py <locale> <translations.json>
例如：python3 tool/i18n_translate.py zh_Hans zh_Hans.json

會檢查：
- 每個 key 都有翻譯，也沒有多出 app_zh.arb 裡沒有的 key
- 每個 {placeholder} 都還在（ICU 複數裡的 {count} 也算）
缺少或多出的翻譯會列出來並停下，不寫檔。
"""
import json
import os
import re
import sys
from collections import OrderedDict

ROOT = os.path.join(os.path.dirname(__file__), "..")
ARB_DIR = os.path.join(ROOT, "lib", "l10n")
PLACEHOLDER = re.compile(r"\{(\w+)[,}]")


def main():
    locale, src = sys.argv[1], sys.argv[2]
    zh = json.load(open(os.path.join(ARB_DIR, "app_zh.arb"), encoding="utf-8"), object_pairs_hook=OrderedDict)
    tr = json.load(open(src, encoding="utf-8"))
    keys = [k for k in zh if not k.startswith("@")]
    errors = [f"缺少 {k}" for k in keys if k not in tr]
    errors += [f"多出 {k}" for k in tr if k not in zh]
    for k in keys:
        if k not in tr:
            continue
        want = set(zh.get("@" + k, {}).get("placeholders", {}))
        got = set(PLACEHOLDER.findall(tr[k])) - {"plural", "select"}
        if want - got:
            errors.append(f"{k}: 少了 {sorted(want - got)}")
        if got - want:
            errors.append(f"{k}: 多了 {sorted(got - want)}")
    if errors:
        print("\n".join(errors))
        sys.exit(1)
    out = OrderedDict([("@@locale", locale)])
    for k in keys:
        out[k] = tr[k]
    with open(os.path.join(ARB_DIR, f"app_{locale}.arb"), "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"app_{locale}.arb: {len(keys)} strings")


if __name__ == "__main__":
    main()
