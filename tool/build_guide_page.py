"""把 App 的操作說明輸出成官網的 hosting/guide.html。

App 是唯一的來源：文字在 lib/l10n/app_zh.arb（guideIntro、guideS<節>Title、guideS<節>L<句>），
每一節的圖示在 lib/guide_screen.dart。改了之後重新執行這支程式，網站就會一致。
用法：python3 tool/build_guide_page.py
"""
import html
import json
import os
import re

ROOT = os.path.join(os.path.dirname(__file__), "..")
SRC = os.path.join(ROOT, "lib", "guide_screen.dart")
ARB = os.path.join(ROOT, "lib", "l10n", "app_zh.arb")
OUT = os.path.join(ROOT, "hosting", "guide.html")

# 網頁上每一節的小圖示（App 用 Material Icons，網頁用相近的符號）
ICONS = {
    "edit_outlined": "✎", "space_dashboard_outlined": "▤", "radar": "◎", "back_hand_outlined": "✋",
    "auto_awesome": "✦", "mail_outline": "✉", "wb_twilight": "◐", "campaign_outlined": "📣",
    "wc": "🚻", "ios_share": "⇪", "tune": "⚙", "flag_outlined": "⚑", "lock_outline": "🔒", "public": "🪐", "translate": "文", "local_cafe_outlined": "☕",
}


# 每一節搭配的插畫（hosting/img/features/），依標題關鍵字對應
IMAGES = [
    ("雷達", "radar", "男生坐在高處看著城市，手機雷達上浮著不同心情的氣泡"),
    ("敲門", "knock", "河堤步道上，男生對前方走過的女生輕輕敲門"),
    ("微光", "resonance", "女生坐在長椅上，一顆粉紅色的光心從手機飄向夜空"),
    ("低語", "whisper", "女生在河堤欄杆上放下一封發光的信"),
    ("城市心情天氣", "mood-weather", "城市上空浮著一朵由不同心情顏色組成的雲"),
    ("集會", "gathering", "一群人圍坐在河邊聊天，頭上浮著集會的圖示"),
    ("城市燈塔", "beacon", "河濱公園的無障礙廁所，上方有發光的定位標記"),
    ("心情卡", "mood-card", "女生拿著一張發光的城市明信片"),
]


def image_for(title):
    for key, name, alt in IMAGES:
        if key in title:
            return name, alt
    return None


def parse(source):
    arb = json.load(open(ARB, encoding="utf-8"))
    body = source[source.index("_sections"):source.index("];", source.index("_sections"))]
    sections = []
    for icon, n in re.findall(r"\(Icons\.(\w+), tr\.guideS(\d+)Title,", body):
        lines, i = [], 1
        while f"guideS{n}L{i}" in arb:
            lines.append(arb[f"guideS{n}L{i}"])
            i += 1
        sections.append((icon, arb[f"guideS{n}Title"], lines))
    return arb["guideIntro"], sections


def link_terms(text):
    """《使用條款》《隱私權政策》在網頁上連到對應頁面"""
    text = text.replace("《使用條款》", '<a href="terms.html">《使用條款》</a>')
    return text.replace("《隱私權政策》", '<a href="privacy.html">《隱私權政策》</a>')


def render(intro, sections):
    toc = "\n".join(
        f'      <li><a href="#s{n}">{html.escape(title)}</a></li>' for n, (_, title, _) in enumerate(sections, 1)
    )
    blocks = []
    for n, (icon, title, lines) in enumerate(sections, 1):
        items = "\n".join(f"        <li>{link_terms(html.escape(l))}</li>" for l in lines)
        extra = ""
        if "集會" in title:
            extra = '\n      <p class="more"><a href="gathering.html">集會指南：情境、畫面與常見問題 →</a></p>'
        if "城市心情天氣" in title:
            extra = '\n      <p class="more"><a href="mood.html">今晚的台灣心情：全台各區的心情地圖 →</a></p>'
        img = image_for(title)
        figure = f'\n      <img class="art" src="img/features/{img[0]}.webp" alt="{html.escape(img[1])}" loading="lazy" width="720" height="1280">' if img else ""
        blocks.append(f"""    <section class="sec{' has-art' if img else ''}" id="s{n}">{figure}
      <h2><span class="ico" aria-hidden="true">{ICONS.get(icon, "•")}</span>{html.escape(title)}</h2>
      <ul>
{items}
      </ul>{extra}
    </section>""")
    return TEMPLATE.replace("{{INTRO}}", html.escape(intro)).replace("{{TOC}}", toc).replace("{{SECTIONS}}", "\n".join(blocks))


TEMPLATE = """<!doctype html>
<html lang="zh-Hant">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>城市低語 操作說明</title>
<meta name="description" content="城市低語的完整操作說明：雷達與氣泡、敲門與聊天、微光、低語與低語穿越、城市心情天氣、集會、城市燈塔、檢舉與隱私。">
<meta name="theme-color" content="#070b1f">
<meta property="og:type" content="article">
<meta property="og:site_name" content="城市低語">
<meta property="og:title" content="城市低語 操作說明">
<meta property="og:description" content="從走進城市到敲門、低語、集會與城市燈塔，一次看懂城市低語怎麼用。">
<meta property="og:image" content="https://mood-whisper-f7de9.web.app/img/intro_1.jpg">
<meta property="og:url" content="https://mood-whisper-f7de9.web.app/guide.html">
<link rel="icon" href="img/icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap">
<!-- 這個檔案由 tool/build_guide_page.py 從 lib/guide_screen.dart 產生，請改 App 的內容後重新產生，不要直接改這裡 -->
<style>
  :root {
    color-scheme: dark;
    --night-900: #070b1f; --night-800: #0e1433; --night-700: #1a1f4a; --night-600: #2a2f66;
    --glass-line: rgba(196, 170, 255, 0.38);
    --ink: #f3f0ff; --ink-muted: #b9b6d6; --ink-faint: #8c89b0;
    --aurora-violet: #b44cff; --aurora-blue: #4fc3f7;
    --sans: "Noto Sans TC", "PingFang TC", "Microsoft JhengHei", system-ui, sans-serif;
  }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }
  html, body { margin: 0; background: var(--night-900); color: var(--ink); font-family: var(--sans); -webkit-font-smoothing: antialiased; }
  a { color: var(--aurora-blue); }
  .wrap { max-width: 760px; margin: 0 auto; padding-left: max(20px, env(safe-area-inset-left)); padding-right: max(20px, env(safe-area-inset-right)); padding-block: 24px 56px; }
  .back { color: var(--ink-muted); text-decoration: none; font-size: 14px; }
  h1 { margin: 28px 0 0; font-size: clamp(30px, 6vw, 42px); letter-spacing: 3px; text-wrap: balance; }
  h1 em { font-style: normal; background: linear-gradient(90deg, var(--aurora-violet), var(--aurora-blue)); -webkit-background-clip: text; background-clip: text; color: transparent; }
  .rule { width: 112px; height: 2px; margin: 18px 0; border-radius: 2px; background: linear-gradient(90deg, var(--aurora-violet), var(--aurora-blue)); }
  .lead { margin: 0; color: var(--ink-muted); line-height: 1.85; font-size: 16px; }
  .note { margin: 10px 0 0; color: var(--ink-faint); font-size: 13px; }
  .toc { margin: 28px 0 8px; padding: 18px 20px; border-radius: 20px; background: var(--night-800); border: 1px solid var(--night-600); }
  .toc ol { margin: 0; padding: 0; list-style: none; columns: 2; column-gap: 24px; }
  .toc li { break-inside: avoid; line-height: 2.1; font-size: 15px; }
  .toc a { color: var(--ink-muted); text-decoration: none; }
  .toc a:hover, .toc a:focus-visible { color: var(--ink); text-decoration: underline; }
  .sec { margin-top: 16px; padding: 20px 22px 8px; border-radius: 20px; background: var(--night-800); border: 1px solid var(--night-600); scroll-margin-top: 16px; }
  .sec h2 { margin: 0 0 10px; font-size: 19px; font-weight: 500; letter-spacing: 1px; display: flex; gap: 10px; align-items: center; }
  .ico { width: 32px; height: 32px; flex: none; display: inline-grid; place-items: center; border-radius: 10px; background: var(--night-700); color: var(--aurora-violet); font-size: 16px; }
  .sec ul { margin: 0; padding: 0 0 8px; list-style: none; }
  .sec li { position: relative; padding-left: 16px; margin-bottom: 10px; color: var(--ink-muted); line-height: 1.8; font-size: 15px; }
  .sec li::before { content: ""; position: absolute; left: 0; top: 11px; width: 5px; height: 5px; border-radius: 50%; background: var(--aurora-blue); }
  .more { margin: 0 0 14px; font-size: 14px; }
  .art { display: block; width: 100%; height: auto; max-width: 240px; margin: 0 auto 16px; aspect-ratio: 9 / 16; object-fit: cover; border-radius: 16px; border: 1px solid var(--glass-line); }
  .sec::after { content: ""; display: block; clear: both; }
  @media (min-width: 640px) { .art { float: right; width: 180px; margin: 0 0 12px 20px; } }
  footer { margin-top: 40px; padding-top: 24px; border-top: 1px solid var(--night-600); color: var(--ink-faint); font-size: 13px; line-height: 2; }
  footer nav { display: flex; flex-wrap: wrap; gap: 6px 20px; }
  footer a { color: var(--ink-muted); text-decoration: none; }
  :focus-visible { outline: 2px solid var(--aurora-violet); outline-offset: 2px; }
  @media (max-width: 480px) { .toc ol { columns: 1; } }
</style>
</head>
<body>
<main class="wrap">
  <a class="back" href="./">← 城市低語</a>
  <h1><em>操作說明</em></h1>
  <div class="rule"></div>
  <p class="lead">{{INTRO}}</p>
  <p class="note">與 App 內「設定 › 關於 › 操作說明」的內容相同。</p>
  <nav class="toc" aria-label="目錄">
    <ol>
{{TOC}}
    </ol>
  </nav>
{{SECTIONS}}
  <footer>
    <nav aria-label="更多">
      <a href="./">首頁</a>
      <a href="gathering.html">集會指南</a>
      <a href="mood.html">今晚的台灣心情</a>
      <a href="terms.html">使用條款</a>
      <a href="privacy.html">隱私權政策</a>
      <a href="delete-account.html">刪除帳號</a>
      <a href="mailto:service.softchip@gmail.com">聯絡我們</a>
    </nav>
    © 2026 Softchip · 城市低語
  </footer>
</main>
</body>
</html>
"""


if __name__ == "__main__":
    intro, sections = parse(open(SRC, encoding="utf-8").read())
    assert len(sections) >= 10, f"只讀到 {len(sections)} 節，guide_screen.dart 的格式可能變了"
    open(OUT, "w", encoding="utf-8").write(render(intro, sections))
    print(f"{OUT}：{len(sections)} 節，{sum(len(s[2]) for s in sections)} 條")
