"""心情據點：每家店的桌卡與窗貼印刷檔。

用法：python3 tool/make_place_print.py [店家 id …]（不給 id 就做全部）
需要：pip3 install --user segno（產生 QR code）、Google Chrome（把 HTML 印成 PDF）
輸入：places/places.json（先跑過 tool/build_places.py，落地頁才存在）
輸出：marketing/places/{id}/table-card.pdf、window-sticker.pdf，以及同名 .png 預覽

- 桌卡：A6（105×148 mm），四邊各留 3 mm 出血，PDF 為 111×154 mm。
- 窗貼：直徑 100 mm 的圓形模切貼紙，四邊留 3 mm 出血，PDF 為 106×106 mm。
- QR code 連到 /p/{id}.html（落地頁），再從那裡帶 ?ref=place-{id} 去報名，只用來數有幾個人從這家店來。
文案只寫已經做好的功能（雷達上的燈、名片）；店內留言本做好之前，不寫「有人留了話」。
"""
import json
import os
import subprocess
import sys
import tempfile

import segno

ROOT = os.path.join(os.path.dirname(__file__), "..")
SRC = os.path.join(ROOT, "places", "places.json")
OUT = os.path.join(ROOT, "marketing", "places")
SITE = "https://mood-whisper-f7de9.web.app"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

HEAD = """<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&family=Chakra+Petch:wght@500;600&display=swap">
<style>
@page { size: %(w)smm %(h)smm; margin: 0; }
* { box-sizing: border-box; }
html, body { margin: 0; width: %(w)smm; height: %(h)smm; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { font-family: "Noto Sans TC", "PingFang TC", sans-serif; color: #f3f0ff; }
.mono { font-family: "Chakra Petch", "Noto Sans TC", monospace; }
.rule { height: 0.5mm; border-radius: 0.5mm; background: linear-gradient(90deg, #b44cff, #4fc3f7); }
.brand { font-weight: 700; background: linear-gradient(90deg, #b44cff, #4fc3f7); -webkit-background-clip: text; background-clip: text; color: transparent; }
%(css)s
</style></head><body>%(body)s</body></html>"""

# 跟 App 裡的小燈同一個咖啡杯圖標（Material local_cafe_outlined）
CUP = ('<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="#ffc56b" d="M18.5 3H6c-1.1 0-2 .9-2 2v5.71c0 3.83 2.95 7.18 '
       '6.78 7.29 3.96.12 7.22-3.06 7.22-7v-1h.5c1.93 0 3.5-1.57 3.5-3.5S20.43 3 18.5 3zM16 5v3H6V5h10zm.02 5c0 2.76-2.24 '
       '5-5 5s-5-2.24-5-5V10h10zm2.48-3H18V5h.5c.83 0 1.5.67 1.5 1.5S19.33 8 18.5 8zM4 19h16v2H4z"/></svg>')


def number(pid):
    return f"№ {int(pid[1:]):02d}"


def table_card(p, qr_svg):
    css = """
body { background: #070b1f; padding: 13mm 12mm 11mm; display: flex; flex-direction: column; gap: 6mm; }
.top { display: flex; justify-content: space-between; align-items: center; font-size: 3.4mm; letter-spacing: 1mm; }
.top .tag { display: flex; align-items: center; gap: 1.6mm; color: #ffc56b; }
.top svg { width: 4.6mm; height: 4.6mm; }
.top .mono { color: #b9b6d6; letter-spacing: 0.8mm; }
h1 { margin: 2mm 0 0; font-size: 7.4mm; line-height: 1.5; letter-spacing: 0.5mm; text-wrap: balance; }
.rule { width: 17mm; }
.lead { margin: 0; font-size: 3.9mm; line-height: 1.85; color: #b9b6d6; }
.shop { margin: 0; font-size: 3.4mm; color: #8c89b0; letter-spacing: 0.4mm; }
.bottom { margin-top: auto; display: flex; gap: 5mm; align-items: flex-end; }
.qr { width: 34mm; height: 34mm; flex: none; border-radius: 3mm; background: #f3f0ff; padding: 2mm; }
.qr svg { width: 100%; height: 100%; display: block; }
.side { display: flex; flex-direction: column; gap: 1.4mm; min-width: 0; }
.side .brand { font-size: 5.8mm; letter-spacing: 1mm; }
.side span { font-size: 3.1mm; line-height: 1.6; color: #b9b6d6; }
"""
    body = f"""
<div class="top"><span class="tag">{CUP}心情據點</span><span class="mono">{number(p["id"])}</span></div>
<h1>這家店，<br>是雷達上的一盞燈。</h1>
<div class="rule"></div>
<p class="lead">打開城市低語，雷達上會亮起咖啡杯小燈。<br>點一下，讀這家店留給你的一句話。</p>
<p class="shop">{p["name"]}</p>
<div class="bottom">
  <div class="qr">{qr_svg}</div>
  <div class="side"><span class="brand">城市低語</span><span>匿名的夜晚心情地圖<br>掃描加入公測<br>限 18 歲以上 · 免費</span></div>
</div>"""
    return HEAD % {"w": 111, "h": 154, "css": css, "body": body}


def window_sticker(p):
    css = """
body { background: #070b1f; display: grid; place-items: center; }
.disc { width: 100mm; height: 100mm; border-radius: 50%; border: 0.6mm solid rgba(196,170,255,0.5);
  box-shadow: 0 0 9mm rgba(180,76,255,0.35), inset 0 0 6mm rgba(79,195,247,0.12);
  display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 3mm; text-align: center; }
.disc svg { width: 12mm; height: 12mm; filter: drop-shadow(0 0 1.5mm rgba(255,197,107,0.8)); }
.title { margin: 0; font-size: 8mm; font-weight: 700; letter-spacing: 1.6mm; }
.no { margin: 0; font-size: 4mm; letter-spacing: 1mm; color: #b9b6d6; }
.rule { width: 15mm; }
.lead { margin: 0; font-size: 3.6mm; line-height: 1.7; color: #b9b6d6; }
.brand { margin: 0; font-size: 4.2mm; letter-spacing: 0.8mm; }
"""
    body = f"""
<div class="disc">{CUP}
  <p class="title">心情據點</p>
  <p class="no mono">{number(p["id"])}</p>
  <div class="rule"></div>
  <p class="lead">打開城市低語<br>這家店會在雷達上亮起</p>
  <p class="brand">城市低語</p>
</div>"""
    return HEAD % {"w": 106, "h": 106, "css": css, "body": body}


def render(html, pdf, png, w_mm, h_mm):
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as f:
        f.write(html)
    common = [CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--virtual-time-budget=8000"]
    subprocess.run(common + ["--no-pdf-header-footer", f"--print-to-pdf={pdf}", f"file://{f.name}"],
                   check=True, capture_output=True)
    px = lambda mm: round(mm / 25.4 * 96)  # CSS 像素；放大 2 倍約 190 dpi 的預覽
    subprocess.run(common + [f"--window-size={px(w_mm)},{px(h_mm)}", "--force-device-scale-factor=2",
                             f"--screenshot={png}", f"file://{f.name}"], check=True, capture_output=True)
    os.remove(f.name)


def main():
    places = json.load(open(SRC, encoding="utf-8"))["places"]
    want = set(sys.argv[1:])
    for p in places:
        if want and p["id"] not in want:
            continue
        url = f"{SITE}/p/{p['id']}.html"
        qr_svg = segno.make(url, error="m").svg_inline(dark="#070b1f", light=None, border=0, omitsize=True)
        out = os.path.join(OUT, p["id"])
        os.makedirs(out, exist_ok=True)
        render(table_card(p, qr_svg), os.path.join(out, "table-card.pdf"), os.path.join(out, "table-card.png"), 111, 154)
        render(window_sticker(p), os.path.join(out, "window-sticker.pdf"), os.path.join(out, "window-sticker.png"), 106, 106)
        print(f"✓ {p['id']} {p['name']} → marketing/places/{p['id']}/（QR：{url}）")


if __name__ == "__main__":
    main()
