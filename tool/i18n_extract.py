"""列出 lib/ 裡所有寫死在程式裡的中文字串（多語系化用）。

用法：python3 tool/i18n_extract.py > /tmp/strings.json
輸出每一筆：檔案、行號、原始字串（含引號）、內插的變數。
略過註解、debugPrint/print、內容過濾字詞清單，以及心情顏色關鍵字（那些是比對用的資料，不是介面文字）。
"""
import json
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..", "lib")
SKIP_FILES = {"content_filter.dart", "firebase_options.dart", "gathering_keys.dart"}
CJK = re.compile(r"[㐀-鿿＀-￯　-〿]")
# 單引號或雙引號的 Dart 字串（不處理三引號）
STRING = re.compile(r"""(?<![A-Za-z0-9_])(r?)('(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*")""")
SKIP_LINE = re.compile(r"debugPrint|print\(|\.contains\(|//.*$")


def strip_comment(line):
    # 去掉行尾註解（不在字串裡的 //）
    out, quote, i = [], None, 0
    while i < len(line):
        c = line[i]
        if quote:
            out.append(c)
            if c == "\\":
                out.append(line[i + 1] if i + 1 < len(line) else "")
                i += 2
                continue
            if c == quote:
                quote = None
        else:
            if c in "'\"":
                quote = c
            elif line.startswith("//", i):
                break
            out.append(c)
        i += 1
    return "".join(out)


def main():
    rows = []
    for dirpath, _, files in os.walk(ROOT):
        for f in sorted(files):
            if not f.endswith(".dart") or f in SKIP_FILES or "l10n" in dirpath:
                continue
            path = os.path.join(dirpath, f)
            rel = os.path.relpath(path, os.path.join(ROOT, ".."))
            for n, line in enumerate(open(path, encoding="utf-8"), 1):
                code = strip_comment(line)
                if code.lstrip().startswith(("///", "*", "/*")) or re.search(r"debugPrint|\bprint\(", code):
                    continue
                for m in STRING.finditer(code):
                    s = m.group(2)
                    if not CJK.search(s):
                        continue
                    if re.search(r"\.contains\(\s*" + re.escape(s), code):
                        continue
                    interps = re.findall(r"\$\{([^}]*)\}|\$([A-Za-z_][A-Za-z0-9_.]*)", s)
                    rows.append({"file": rel, "line": n, "src": s, "vars": [a or b for a, b in interps]})
    json.dump(rows, sys.stdout, ensure_ascii=False, indent=1)
    print(f"\n{len(rows)} strings", file=sys.stderr)


if __name__ == "__main__":
    main()
