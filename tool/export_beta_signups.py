"""匯出公測報名名單。

用法：python3 tool/export_beta_signups.py [輸出資料夾，預設 beta_signups]
需要已登入 Firebase CLI（firebase login）。

產出：
  all.csv            全部報名（Email、手機、地區、來源、報名時間）
  ios_emails.txt     iPhone 報名者，一行一個（貼到 TestFlight → 外部測試者 → 新增）
  android_emails.txt Android 報名者，一行一個（加進 Google 群組，或貼到 Play Console 的測試者清單）
並印出各地區、各來源的人數，幫你判斷點亮之夜要辦在哪裡、哪個平台的貼文最有效。
注意：輸出含個人資料，資料夾已在 .gitignore 中，請勿上傳或分享。
"""
import csv
import collections
import datetime
import json
import os
import subprocess
import sys

out = sys.argv[1] if len(sys.argv) > 1 else "beta_signups"
raw = subprocess.run(
    ["firebase", "database:get", "/betaSignups", "--project", "mood-whisper-f7de9"],
    check=True, capture_output=True, text=True,
).stdout
rows = sorted((json.loads(raw) or {}).values(), key=lambda r: r.get("at", 0))
os.makedirs(out, exist_ok=True)

with open(os.path.join(out, "all.csv"), "w", newline="", encoding="utf-8-sig") as f:  # utf-8-sig 讓 Excel 正確顯示中文
    w = csv.writer(f)
    w.writerow(["Email", "手機", "地區", "來源", "報名時間"])
    for r in rows:
        when = datetime.datetime.fromtimestamp(r.get("at", 0) / 1000).strftime("%Y-%m-%d %H:%M")
        w.writerow([r["email"], "iPhone" if r["platform"] == "ios" else "Android", r["area"], r.get("source", ""), when])

for platform in ("ios", "android"):
    with open(os.path.join(out, f"{platform}_emails.txt"), "w", encoding="utf-8") as f:
        f.write("\n".join(r["email"] for r in rows if r["platform"] == platform) + "\n")

print(f"共 {len(rows)} 人報名，已寫入 {out}/")
for title, key in (("手機", "platform"), ("地區", "area"), ("來源", "source")):
    counts = collections.Counter(r.get(key, "") for r in rows)
    print(f"  {title}：" + "、".join(f"{k} {v}" for k, v in counts.most_common()))
