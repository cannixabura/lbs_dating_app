"""集會操作說明圖：把模擬器截圖裁成重點區域，配上步驟、標題與說明。

用法：
  python3 tool/make_gathering_guide.py marketing/outreach/gathering-guide/raw marketing/outreach/gathering-guide

raw/ 裡放 1_settings.png … 6_petals.png（iPhone 6.9 吋模擬器原始截圖，1320×2868）。
輸出 1080×1500 的 PNG（寄信、社群用）與 hosting/img/gathering/ 的 JPEG（官網集會指南用）。
說明文字不放表情符號：系統字型畫不出彩色表情。
"""
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(__file__))
from compose_store_screenshots import background, gradient_text, load_font, rounded, GLASS_LINE  # noqa: E402

# (檔名, 裁切範圍 (左, 上, 右, 下)，標題, 說明)
STEPS = [
    ("1_settings", (0, 760, 1320, 2230), "設定 → 集會主持人", "任何人都能開，不用申請、不用密碼"),
    ("2_create", (0, 1110, 1320, 2740), "填名稱、選一個圖標", "以你為中心 5 公里，最長 24 小時\n你走到哪，範圍就跟到哪"),
    ("3_participant_banner", (0, 300, 1320, 1900), "把圖標加進稱呼就參加", "參加者的雷達上方出現置頂公告\n鎖住螢幕也收得到推播"),
    ("4_host_ring", (0, 520, 1320, 1950), "一眼找到主持人", "頭像外的光環與「主持」標示\n人再多也不會被蓋住"),
    ("5_host_panel", (0, 640, 1320, 2740), "發公告、全場提問", "主持人看不到參加者是誰\n提問只看全場的心情比例"),
    ("6_petals", (0, 520, 1320, 2100), "人再多也點得到", "擠在一起的心情合成一顆光球\n點一下展開成一圈"),
]

W, H = 1080, 1500
INK_MUTED = (185, 182, 214)
STEP_COLOR = (140, 137, 176)


def card(raw_path, crop, title, subtitle, n):
    canvas = background(W, H)
    draw = ImageDraw.Draw(canvas)
    step_font = load_font(34)
    label = f"步驟 {n}"
    draw.text(((W - step_font.getlength(label)) / 2, 70), label, font=step_font, fill=STEP_COLOR)
    top = gradient_text(canvas, title, load_font(76), W / 2, 112)
    draw = ImageDraw.Draw(canvas)
    sub_font = load_font(38)
    y = top + 6
    for line in subtitle.split("\n"):
        draw.text(((W - sub_font.getlength(line)) / 2, y), line, font=sub_font, fill=INK_MUTED)
        y += 56

    shot = Image.open(raw_path).convert("RGB").crop(crop)
    box_top = y + 40
    max_w, max_h = int(W * 0.84), H - box_top - 60
    scale = min(max_w / shot.size[0], max_h / shot.size[1])
    shot = shot.resize((int(shot.size[0] * scale), int(shot.size[1] * scale)), Image.LANCZOS)
    radius = 44
    shot = rounded(shot, radius)
    x = (W - shot.size[0]) // 2
    canvas.paste(shot, (x, box_top), shot)
    border = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle((x, box_top, x + shot.size[0], box_top + shot.size[1]), radius=radius, outline=GLASS_LINE, width=3)
    return Image.alpha_composite(canvas.convert("RGBA"), border).convert("RGB")


def main():
    src, dst = sys.argv[1], sys.argv[2]
    web = os.path.join(os.path.dirname(__file__), "..", "hosting", "img", "gathering")
    os.makedirs(dst, exist_ok=True)
    os.makedirs(web, exist_ok=True)
    for n, (name, crop, title, subtitle) in enumerate(STEPS, start=1):
        img = card(os.path.join(src, f"{name}.png"), crop, title, subtitle, n)
        img.save(os.path.join(dst, f"{n}.png"), optimize=True)
        img.save(os.path.join(web, f"{n}.jpg"), quality=86, optimize=True)
        print(f"{n}. {title}")


if __name__ == "__main__":
    main()
