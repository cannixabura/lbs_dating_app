"""字串換成 tr.xxx 之後，外層的 const 會變成錯誤（invalid_constant 等）。
這支程式依 flutter analyze 回報的位置，拿掉包住那個位置、最近的 const，重複到沒有這類錯誤為止。

用法：python3 tool/i18n_fix_const.py lib/main.dart [其他檔案…]
"""
import os
import re
import subprocess
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..")
CODES = ("invalid_constant", "const_with_non_const", "non_constant_list_element", "const_initialized_with_non_constant_value",
         "non_constant_map_value", "const_constructor_param_type_mismatch", "non_constant_default_value")
ERR = re.compile(r"error • .* • (\S+):(\d+):(\d+) • (\S+)")


def analyze(paths):
    out = subprocess.run(["flutter", "analyze", "--no-pub", *paths], cwd=ROOT, capture_output=True, text=True).stdout
    return [(f, int(l), int(c)) for f, l, c, code in ERR.findall(out) if code in CODES]


def remove_const(path, line, col):
    lines = open(os.path.join(ROOT, path), encoding="utf-8").read().split("\n")
    # 從錯誤位置往前找最近的 "const "（同一行在錯誤位置之前，或往上最多 12 行）
    for ln in range(line - 1, max(-1, line - 14), -1):
        text = lines[ln]
        limit = col - 1 if ln == line - 1 else len(text)
        idx = text.rfind("const ", 0, limit)
        if idx >= 0 and (idx == 0 or not (text[idx - 1].isalnum() or text[idx - 1] == "_")):
            lines[ln] = text[:idx] + text[idx + 6:]
            open(os.path.join(ROOT, path), "w", encoding="utf-8").write("\n".join(lines))
            return True
    return False


def main():
    paths = sys.argv[1:]
    subprocess.run(["flutter", "gen-l10n"], cwd=ROOT, capture_output=True)  # 先產生最新的 AppLocalizations
    for round_ in range(30):
        errors = analyze(paths)
        if not errors:
            print(f"done after {round_} rounds")
            return
        # 同一行只處理一次，從下往上改才不會影響前面的位置
        seen = set()
        for f, l, c in sorted(errors, key=lambda e: (e[0], -e[1], -e[2])):
            if (f, l) in seen:
                continue
            seen.add((f, l))
            if not remove_const(f, l, c):
                print(f"could not fix {f}:{l}:{c}")
    print("gave up after 30 rounds")


if __name__ == "__main__":
    main()
