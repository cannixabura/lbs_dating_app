#!/usr/bin/env python3
"""Build the public design system site (hosting/design/) from design/system/.

design/system/ is a copy of the 城市低語夜光設計系統 artifact: README.md,
tokens.json and components/<Name>/{README.md,preview.html} plus bundle.css.
Run after updating that copy:

    python3 tool/build_design_site.py
"""
import html
import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "design" / "system"
OUT = ROOT / "hosting" / "design"
SITE = "https://mood-whisper-f7de9.web.app"

NAMES = {
    "RadarScreen": "雷達畫面", "ChatScreen": "聊天室", "MoodTrail": "心情軌跡",
    "MoodBubble": "心情氣泡", "EmptyRadar": "空雷達", "Dock": "底部選單",
    "EntryCard": "進場卡片", "KnockCard": "敲門卡片", "KnockRitual": "敲門儀式",
    "CountdownPill": "倒數條", "ChatBubble": "聊天泡泡", "Resonance": "共鳴",
    "Whisper": "低語", "CityMoodWeather": "城市心情天氣", "MoodCard": "心情卡",
    "ProfileEdit": "編輯個人狀態", "ReportSheet": "檢舉", "BlockList": "封鎖名單",
    "DeleteAccount": "刪除帳號", "GlassCard": "玻璃卡片", "GlassToast": "玻璃提示",
    "GradientButton": "漸層按鈕",
    "Gathering": "集會", "Beacon": "城市燈塔", "TimeWhisper": "低語穿越",
}
SUBTITLES = {
    "RadarScreen": "雷達上所有氣泡狀態、提示條與底部選單",
    "ChatScreen": "10 分鐘聊天室：倒數與檢舉、訊息、輸入中、送出，以及交集結束的方式",
    "MoodTrail": "我的心情軌跡：每週回顧、發光地圖、每日列表，以及空白與清除狀態",
    "EntryCard": "標題、心情欄位，勾選使用條款才能進入",
    "MoodBubble": "活躍、休息中、歷史殘影與敲門中的氣泡，浮在夜光地圖上",
    "EmptyRadar": "5 公里內沒有人時，取代空地圖的卡片",
    "Dock": "玻璃底部選單的三種說明文字狀態，以及它打開的設定",
    "KnockCard": "收到的敲門（含檢舉）、敲門者看到的畫面，以及封鎖確認",
    "KnockRitual": "等待回音的弧線與倒數、最後一分鐘，以及消散",
    "CountdownPill": "等待回音與最後一分鐘",
    "ChatBubble": "倒數與檢舉的標題列、訊息、輸入框",
    "Resonance": "氣泡選單、送出時的光點，以及收到的人看到什麼",
    "Whisper": "雷達上的信封、寫低語，以及閱讀（別人的與自己的）",
    "CityMoodWeather": "心情標籤、比例明細，以及少於 10 人時的安靜狀態",
    "MoodCard": "360×640 的分享卡（輸出 1080×1920），兩種心情",
    "ProfileEdit": "隨輸入變色的頭像光環、暱稱、心情，上傳中狀態與提示",
    "ReportSheet": "檢舉一個人（含封鎖）、檢舉一則低語（不封鎖），以及確認",
    "BlockList": "封鎖名單與「解除放逐」、空白狀態與提示",
    "DeleteAccount": "從設定到確認、刪除中、失敗，以及給已移除 App 的人的網頁流程",
    "GlassCard": "一般卡片與空的封鎖名單",
    "GlassToast": "新訊息、敲門已送出，以及失敗",
    "GradientButton": "主要、次要、暖色、危險、文字、停用",
    "Gathering": "雷達上的主持人光環、參加者與主持人看到的置頂公告、主持人面板，以及交棒",
    "Beacon": "雷達上的友善廁所標記、燈塔開關與篩選、被回報的地點，以及詳細資訊與回報",
    "TimeWhisper": "寫給未來的自己、封存與解封的標記、只讀一次的信，以及設定裡的列表",
}
GROUPS = [
    ("Screens", "完整畫面"), ("Onboarding", "引導"), ("Radar", "雷達"),
    ("Knocking", "敲門"), ("Chat", "聊天"), ("Resonance", "共鳴"),
    ("Whispers", "低語"), ("Gathering", "集會"), ("City", "城市"), ("Sharing", "分享"),
    ("Profile", "個人"), ("Safety", "安全"), ("Surfaces", "表面"),
    ("Actions", "按鈕"), ("Feedback", "回饋"),
]
FONTS = ("https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@300;400;500;600;700"
         "&family=Chakra+Petch:wght@500;600&display=swap")


# ---------- tiny markdown (headings, nested lists, tables, paragraphs, inline) ----------
def inline(s):
    s = html.escape(s, quote=False)
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", s)
    s = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', s)
    return s


def markdown(text):
    out, para, lists, table = [], [], [], []

    def flush_para():
        if para:
            out.append("<p>" + inline(" ".join(para)) + "</p>")
            para.clear()

    def close_lists(depth=0):
        while len(lists) > depth:
            lists.pop()
            out.append("</li></ul>")

    def flush_table():
        if not table:
            return
        rows = [r for r in table if not re.fullmatch(r"\|[\s\-|:]+\|", r)]
        cells = [[c.strip() for c in r.strip("|").split("|")] for r in rows]
        out.append('<div class="table"><table><thead><tr>'
                   + "".join(f"<th>{inline(c)}</th>" for c in cells[0]) + "</tr></thead><tbody>"
                   + "".join("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>"
                             for r in cells[1:])
                   + "</tbody></table></div>")
        table.clear()

    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("|"):
            flush_para()
            table.append(stripped)
            continue
        flush_table()
        m = re.match(r"^( *)- (.*)$", line)
        if m:
            flush_para()
            depth = len(m.group(1)) // 2 + 1
            if depth > len(lists):
                while len(lists) < depth:
                    lists.append(1)
                    out.append("<ul><li>")
            else:
                close_lists(depth)
                out.append("</li><li>")
            out.append(inline(m.group(2)))
            continue
        if not stripped:
            flush_para()
            continue
        if lists and line.startswith("  "):
            out.append(" " + inline(stripped))
            continue
        close_lists()
        h = re.match(r"^(#{1,4}) (.*)$", stripped)
        if h:
            flush_para()
            level = len(h.group(1)) + 1
            out.append(f"<h{level}>{inline(h.group(2))}</h{level}>")
            continue
        para.append(stripped)
    flush_para()
    flush_table()
    close_lists()
    return "\n".join(out)


# ---------- tokens ----------
def tokens_css(tokens):
    lines = [":root {"]
    for t in tokens["color"]["tokens"]:
        lines.append(f"  --{t['name']}: {t['value']};")
    for key in ("spacing", "radius", "shadow", "opacity"):
        for t in tokens[key]["tokens"]:
            lines.append(f"  --{t['name']}: {t['value']};")
    for fam, stack in tokens["type"]["families"].items():
        lines.append(f"  --font-{fam}: {stack};")
    lines.append("}")
    return "\n".join(lines) + "\n"


def card_meta(preview):
    m = re.search(r"@dsCard([^>]*)-->", preview)
    attrs = m.group(1) if m else ""
    get = lambda k: (re.search(k + r'="([^"]*)"', attrs) or [None, ""])[1]
    height = re.search(r"height=(\d+)", attrs)
    return {"group": get("group"), "subtitle": get("subtitle"),
            "height": int(height.group(1)) if height else 400, "page": " page" in attrs}


def preview_page(name, preview):
    """The artifact's preview with the token and component styles linked in."""
    preview = re.sub(r"^<!--.*?-->\s*", "", preview, flags=re.S)
    head = ('<meta name="viewport" content="width=device-width, initial-scale=1">'
            '<meta name="robots" content="noindex">'
            '<link rel="stylesheet" href="../tokens.css"><link rel="stylesheet" href="../bundle.css">')
    if name == "Cover":
        head += "<style>.cover .name { max-width: 600px; }</style>"
    return preview.replace("<head>", "<head>" + head, 1)


# ---------- shared chrome ----------
STYLE = """
:root {
  color-scheme: dark;
  --night-900: #070b1f; --night-800: #0e1433; --night-700: #1a1f4a; --night-600: #2a2f66;
  --glass-fill: rgba(26, 31, 74, 0.72); --glass-line: rgba(196, 170, 255, 0.38);
  --ink: #f3f0ff; --ink-muted: #b9b6d6; --ink-faint: #8c89b0;
  --aurora-violet: #b44cff; --aurora-blue: #4fc3f7;
  --font-body: "Noto Sans TC", "PingFang TC", "Microsoft JhengHei", system-ui, sans-serif;
  --font-num: "Chakra Petch", "Noto Sans TC", ui-monospace, monospace;
}
* { box-sizing: border-box; }
html, body { margin: 0; }
body { padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); background: var(--night-900); color: var(--ink); font: 400 15px/1.75 var(--font-body); -webkit-font-smoothing: antialiased; }
.wrap { max-width: 1040px; margin: 0 auto; padding-left: max(16px, env(safe-area-inset-left, 0px)); padding-right: max(16px, env(safe-area-inset-right, 0px)); padding-block: 0 72px; overflow-x: clip; }
h1, h2, h3, h4 { text-wrap: balance; margin: 0; }
p { margin: 0; }
a { color: var(--aurora-blue); }
code { font-family: var(--font-num); font-size: .9em; background: var(--night-700); border-radius: 6px; padding: 1px 6px; color: var(--ink); overflow-wrap: anywhere; }
:focus-visible { outline: 2px solid var(--aurora-violet); outline-offset: 2px; border-radius: 6px; }
.top { display: flex; gap: 16px; align-items: center; justify-content: space-between; padding-block: 20px; font-size: 13px; color: var(--ink-faint); flex-wrap: wrap; }
.top a { color: var(--ink-muted); text-decoration: none; }
.top a:hover { color: var(--ink); }
.eyebrow { font-size: 12px; letter-spacing: 3px; color: var(--ink-faint); }
.grad-text { background: linear-gradient(90deg, var(--aurora-violet), var(--aurora-blue)); -webkit-background-clip: text; background-clip: text; color: transparent; }
section { padding-block: 40px 8px; display: grid; gap: 18px; border-top: 1px solid var(--night-600); }
section > .head { display: grid; gap: 6px; }
section > .head h2 { font-size: 22px; font-weight: 700; letter-spacing: 1.5px; }
section > .head p { color: var(--ink-muted); max-width: 40em; }
.prose { display: grid; gap: 14px; max-width: 46em; color: var(--ink-muted); min-width: 0; }
.prose h2 { font-size: 19px; color: var(--ink); letter-spacing: 1px; margin-top: 18px; }
.prose h3 { font-size: 16px; color: var(--ink); margin-top: 10px; }
.prose strong { color: var(--ink); font-weight: 600; }
.prose ul { margin: 0; padding-left: 1.3em; display: grid; gap: 6px; }
.prose ul ul { margin-top: 6px; }
.prose li::marker { color: var(--aurora-violet); }
.table { overflow-x: auto; border: 1px solid var(--night-600); border-radius: 14px; }
table { border-collapse: collapse; width: 100%; font-size: 14px; }
th, td { text-align: left; padding: 8px 14px; border-bottom: 1px solid var(--night-600); white-space: nowrap; }
th { color: var(--ink); font-weight: 500; background: var(--night-800); }
tr:last-child td { border-bottom: 0; }
footer { padding-block: 40px 0; border-top: 1px solid var(--night-600); color: var(--ink-faint); font-size: 13px; line-height: 2; }
footer nav { display: flex; flex-wrap: wrap; gap: 6px 20px; }
footer a { color: var(--ink-muted); text-decoration: none; }
footer a:hover { color: var(--ink); text-decoration: underline; }
"""

FOOTER = """<footer><nav>
<a href="../">城市低語</a><a href="./">設計系統</a><a href="../colors.html">品牌用色</a>
<a href="../privacy.html">隱私權政策</a><a href="../terms.html">使用條款</a><a href="../beta.html">加入公測</a>
</nav>© Softchip 城市低語 · 介面設計規範，供合作夥伴與開發參考</footer>"""


def head(title, desc, path, extra_style=""):
    return f"""<!doctype html>
<html lang="zh-Hant">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="{html.escape(desc)}">
<meta name="theme-color" content="#070b1f">
<meta property="og:type" content="website">
<meta property="og:site_name" content="城市低語">
<meta property="og:title" content="{html.escape(title)}">
<meta property="og:description" content="{html.escape(desc)}">
<meta property="og:image" content="{SITE}/img/beta_og.jpg">
<meta property="og:url" content="{SITE}/design/{path}">
<title>{html.escape(title)}</title>
<link rel="icon" href="../img/icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="{FONTS}">
<style>{STYLE}{extra_style}</style>
</head>
<body>
"""


# ---------- index ----------
INDEX_STYLE = """
.hero { padding-block: 24px 40px; display: grid; gap: 18px; position: relative; isolation: isolate; }
.hero::before { content: ""; position: absolute; inset: -40px 0 auto; height: 360px; z-index: -1; background: radial-gradient(60% 70% at 30% 20%, rgba(142,45,226,.35), transparent 70%); }
.hero h1 { font-size: clamp(32px, 6vw, 54px); line-height: 1.2; font-weight: 700; letter-spacing: 3px; }
.hero p { color: var(--ink-muted); max-width: 36em; font-size: 16px; }
.cover { width: 100%; aspect-ratio: 960 / 288; border-radius: 24px; overflow: hidden; border: 1px solid var(--night-600); position: relative; max-width: 100%; }
.cover iframe { position: absolute; left: 0; top: 0; width: 960px; height: 288px; border: 0; transform-origin: 0 0; pointer-events: none; }
.sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; }
.toc { display: flex; flex-wrap: wrap; gap: 8px; }
.toc a { border: 1px solid var(--glass-line); border-radius: 999px; padding: 4px 14px; color: var(--ink-muted); text-decoration: none; font-size: 13px; }
.toc a:hover { color: var(--ink); border-color: var(--aurora-violet); }
.swatches { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px; }
.sw { border-radius: 14px; overflow: hidden; border: 1px solid var(--night-600); background: var(--night-800); min-width: 0; }
.sw i { display: block; height: 56px; }
.sw div { padding: 8px 10px; font-size: 12px; line-height: 1.5; }
.sw b { display: block; font-weight: 500; font-size: 13px; overflow-wrap: anywhere; }
.sw span { font-family: var(--font-num); color: var(--ink-faint); overflow-wrap: anywhere; }
.type { display: grid; gap: 10px; }
.type-row { display: grid; grid-template-columns: 120px minmax(0, 1fr); gap: 16px; align-items: baseline; padding: 14px 16px; border-radius: 14px; background: var(--night-800); border: 1px solid var(--night-600); }
.type-row .meta { font-family: var(--font-num); font-size: 12px; color: var(--ink-faint); line-height: 1.5; }
.type-row .sample { min-width: 0; overflow-wrap: anywhere; }
.scales { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 14px; }
.scale { border-radius: 18px; background: var(--night-800); border: 1px solid var(--night-600); padding: 16px; display: grid; gap: 12px; align-content: start; min-width: 0; }
.scale h3 { font-size: 15px; font-weight: 500; }
.scale .row { display: grid; grid-template-columns: 92px auto minmax(0, 1fr); gap: 12px; align-items: center; font-size: 12px; }
.scale .row code { background: none; padding: 0; color: var(--ink-muted); }
.scale .row small { color: var(--ink-faint); font-family: var(--font-num); }
.bar { height: 10px; border-radius: 4px; background: linear-gradient(90deg, var(--aurora-violet), var(--aurora-blue)); }
.rad { width: 44px; height: 44px; border: 1.5px solid var(--aurora-violet); background: var(--night-700); }
.glowbox { width: 44px; height: 30px; border-radius: 10px; background: var(--night-700); }
.dot { width: 30px; height: 30px; border-radius: 50%; background: #a99cff; }
.group { display: grid; gap: 12px; }
.group h3 { font-size: 14px; letter-spacing: 2px; color: var(--ink-faint); font-weight: 500; }
.cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 14px; }
.card { display: grid; grid-template-rows: auto 1fr; border-radius: 20px; overflow: hidden; border: 1px solid var(--night-600); background: var(--night-800); text-decoration: none; color: inherit; min-width: 0; transition: border-color .2s; }
.card:hover, .card:focus-visible { border-color: var(--aurora-violet); }
.thumb { position: relative; height: 190px; overflow: hidden; background: var(--night-900); border-bottom: 1px solid var(--night-600); }
.thumb iframe { position: absolute; left: 0; top: 0; width: 1000px; height: 560px; border: 0; transform: scale(.34); transform-origin: 0 0; pointer-events: none; }
.card .txt { padding: 12px 14px 14px; display: grid; gap: 2px; align-content: start; }
.card b { font-weight: 500; }
.card b span { color: var(--ink-faint); font-family: var(--font-num); font-weight: 400; font-size: 12px; margin-left: 6px; }
.card p { font-size: 13px; color: var(--ink-muted); line-height: 1.6; }
@media (max-width: 520px) { .type-row { grid-template-columns: 1fr; gap: 4px; } }
"""


def public_readme(readme):
    """Drop developer-only file paths from the principles before publishing."""
    readme = readme.replace("（`assets/map/night_style.json`），由 `tool/build_night_map_style.py` 從", "，從")
    readme = readme.replace("要調整顏色就改腳本再重新產生。", "")
    assert "assets/" not in readme and "tool/" not in readme, "README still mentions a file path"
    return readme


def build_index(tokens, readme, comps):
    colors = "".join(
        f'<div class="sw"><i style="background:{t["value"]}"></i><div><b>{t["name"]}</b>'
        f'<span>{html.escape(t["value"])}</span></div></div>' for t in tokens["color"]["tokens"])
    fams = tokens["type"]["families"]
    type_rows = ""
    for g in tokens["type"]["groups"]:
        for s in g["styles"]:
            style = (f"font-family:{fams[g['family']]};font-size:{s['fontSize']};line-height:{s['lineHeight']};"
                     f"font-weight:{s['fontWeight']};letter-spacing:{s.get('letterSpacing', 'normal')}")
            if s["name"] == "numeral":
                style += ";font-variant-numeric:tabular-nums;color:#ff5fd2"
            type_rows += (f'<div class="type-row"><div class="meta">{s["name"]}<br>{s["fontSize"]} / '
                          f'{s["lineHeight"]} · {s["fontWeight"]}</div>'
                          f'<div class="sample" style="{html.escape(style)}">{html.escape(s["sample"])}</div></div>')

    def scale(title, key, sample):
        rows = "".join(f'<div class="row"><code>{t["name"]}</code>{sample(t)}<small>{html.escape(t["value"])}</small></div>'
                       for t in tokens[key]["tokens"])
        return f'<div class="scale"><h3>{title}</h3>{rows}</div>'

    scales = (
        scale("間距", "spacing", lambda t: f'<i class="bar" style="width:{t["value"]}"></i>')
        + scale("圓角", "radius", lambda t: f'<i class="rad" style="border-radius:{t["value"]}"></i>')
        + scale("光暈與陰影", "shadow", lambda t: f'<i class="glowbox" style="box-shadow:{t["value"]}"></i>')
        + scale("透明度", "opacity", lambda t: f'<i class="dot" style="opacity:{t["value"]}"></i>'))

    groups = ""
    for gid, glabel in GROUPS:
        items = [c for c in comps if c["group"] == gid]
        if not items:
            continue
        cards = "".join(
            f'<a class="card" href="{c["name"]}.html"><div class="thumb">'
            f'<iframe src="preview/{c["name"]}.html" loading="lazy" tabindex="-1" aria-hidden="true" title=""></iframe></div>'
            f'<div class="txt"><b>{NAMES.get(c["name"], c["name"])}<span>{c["name"]}</span></b>'
            f'<p>{html.escape(c["subtitle"])}</p></div></a>' for c in items)
        groups += f'<div class="group"><h3>{glabel}</h3><div class="cards">{cards}</div></div>'

    desc = "城市低語的夜光設計系統：語氣、色彩、字體、玻璃與光、動態、無障礙規範，以及 22 個介面元件的即時預覽。"
    page = head("城市低語 夜光設計系統", desc, "", INDEX_STYLE) + f"""<div class="wrap">
<div class="top"><a href="../">← 城市低語</a><span>設計系統 v{tokens["version"]}</span></div>
<header class="hero">
  <div class="cover" id="cover"><iframe src="preview/Cover.html" title="" tabindex="-1" aria-hidden="true"></iframe></div>
  <p class="eyebrow">MOOD WHISPER · NIGHT DESIGN SYSTEM</p>
  <h1 class="sr-only">城市低語 夜光設計系統</h1>
  <p>城市低語整套介面只有一個主題「夜」。這裡是 App 的設計規範：怎麼說話、用什麼顏色和字、玻璃與光怎麼疊，以及每個元件與畫面的即時預覽。</p>
  <nav class="toc"><a href="#principles">設計原則</a><a href="#color">色彩</a><a href="#type">字體</a><a href="#scales">間距與圓角</a><a href="#components">元件</a><a href="../colors.html">完整用色指南 ↗</a></nav>
</header>
<section id="principles"><div class="head"><h2>設計原則</h2><p>語氣、色彩、地圖、玻璃與光、動態、匿名與無障礙。</p></div>
<div class="prose">{markdown(readme)}</div></section>
<section id="color"><div class="head"><h2>色彩 token</h2><p>每個顏色可以放在哪些底上、對比多少，詳見<a href="../colors.html">用色指南</a>。</p></div>
<div class="swatches">{colors}</div></section>
<section id="type"><div class="head"><h2>字體</h2><p>全部用 Noto Sans TC；倒數計時用 Chakra Petch 等寬數字。caption 是最小字級。</p></div>
<div class="type">{type_rows}</div></section>
<section id="scales"><div class="head"><h2>間距、圓角、光暈、透明度</h2></div>
<div class="scales">{scales}</div></section>
<section id="components"><div class="head"><h2>元件與畫面</h2><p>點進每個元件可看完整預覽與規格說明。</p></div>
{groups}</section>
{FOOTER}
</div>
<script>
(function () {{
  var box = document.getElementById('cover'), f = box.querySelector('iframe');
  function fit() {{ f.style.transform = 'scale(' + (box.clientWidth / 960) + ')'; }}
  fit(); window.addEventListener('resize', fit);
}})();
</script>
</body>
</html>
"""
    (OUT / "index.html").write_text(page, encoding="utf-8")


# ---------- component pages ----------
COMP_STYLE = """
.title { padding-block: 16px 24px; display: grid; gap: 8px; }
.title h1 { font-size: clamp(28px, 5vw, 40px); letter-spacing: 2px; }
.title h1 span { font-family: var(--font-num); font-size: .45em; color: var(--ink-faint); letter-spacing: 1px; margin-left: 10px; font-weight: 500; }
.title p { color: var(--ink-muted); }
.stage { border-radius: 24px; overflow: hidden; border: 1px solid var(--night-600); background: var(--night-900); }
.stage iframe { display: block; width: 100%; border: 0; }
.pager { display: flex; justify-content: space-between; gap: 12px; flex-wrap: wrap; padding-block: 32px; }
.pager a { color: var(--ink-muted); text-decoration: none; border: 1px solid var(--glass-line); border-radius: 999px; padding: 6px 16px; font-size: 14px; }
.pager a:hover { color: var(--ink); border-color: var(--aurora-violet); }
"""


def build_component(c, prev, nxt):
    name, zh = c["name"], NAMES.get(c["name"], c["name"])
    readme = c["readme"]
    readme = re.sub(r"^# .*\n+", "", readme)
    desc = f"城市低語設計系統元件「{zh}」：{c['subtitle']}"
    nav = (f'<a href="{prev["name"]}.html">← {NAMES.get(prev["name"], prev["name"])}</a>' if prev else "<span></span>") + \
          (f'<a href="{nxt["name"]}.html">{NAMES.get(nxt["name"], nxt["name"])} →</a>' if nxt else "")
    page = head(f"{zh} · 城市低語設計系統", desc, f"{name}.html", COMP_STYLE) + f"""<div class="wrap">
<div class="top"><a href="./">← 夜光設計系統</a><span>{dict(GROUPS).get(c["group"], "")}</span></div>
<header class="title"><h1>{zh}<span>{name}</span></h1><p>{html.escape(c["subtitle"])}</p></header>
<div class="stage"><iframe id="pv" src="preview/{name}.html" title="{zh} 預覽" style="height:{c["height"]}px"></iframe></div>
<section><div class="head"><h2>規格</h2></div><div class="prose">{markdown(readme)}</div></section>
<nav class="pager">{nav}</nav>
{FOOTER}
</div>
<script>
(function () {{
  var f = document.getElementById('pv');
  function fit() {{
    try {{ var d = f.contentDocument; if (d && d.body) f.style.height = Math.max(120, d.documentElement.scrollHeight) + 'px'; }} catch (e) {{}}
  }}
  f.addEventListener('load', function () {{ fit(); setTimeout(fit, 400); setTimeout(fit, 1500); }});
  window.addEventListener('resize', function () {{ setTimeout(fit, 100); }});
}})();
</script>
</body>
</html>
"""
    (OUT / f"{name}.html").write_text(page, encoding="utf-8")


def main():
    tokens = json.loads((SRC / "tokens.json").read_text(encoding="utf-8"))
    if OUT.exists():
        shutil.rmtree(OUT)
    (OUT / "preview").mkdir(parents=True)
    (OUT / "tokens.css").write_text(tokens_css(tokens), encoding="utf-8")
    shutil.copy(SRC / "components" / "bundle.css", OUT / "bundle.css")

    comps = []
    for d in sorted(p for p in (SRC / "components").iterdir() if p.is_dir()):
        preview = (d / "preview.html").read_text(encoding="utf-8")
        (OUT / "preview" / f"{d.name}.html").write_text(preview_page(d.name, preview), encoding="utf-8")
        if d.name == "Cover":
            continue
        meta = card_meta(preview)
        meta["subtitle"] = SUBTITLES.get(d.name, meta["subtitle"])
        readme_path = d / "README.md"
        meta.update(name=d.name, readme=readme_path.read_text(encoding="utf-8") if readme_path.exists() else "")
        comps.append(meta)

    order = [g for g, _ in GROUPS]
    comps.sort(key=lambda c: (order.index(c["group"]) if c["group"] in order else 99, c["name"]))
    build_index(tokens, public_readme((SRC / "README.md").read_text(encoding="utf-8")), comps)
    for i, c in enumerate(comps):
        build_component(c, comps[i - 1] if i else None, comps[i + 1] if i + 1 < len(comps) else None)
    print(f"built {len(comps)} components into {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
