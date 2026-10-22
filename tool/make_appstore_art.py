"""App Store Connect 的產品頁素材。

用法：python3 tool/make_appstore_art.py
輸出到 store_screenshots/：
  ios-medium/1.png … 5.png   「配備動態島的 iPhone（中型顯示器）」截圖 1206×2622（必填的尺寸）
  appstore_title.png          產品頁「標題」素材 3840×1646
  appstore_search.png         「搜尋結果」素材 1920×1280
「標題」與「搜尋結果」會依裝置裁切邊緣，文字與手機畫面都放在中間的安全範圍內。
"""
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(__file__))
from compose_store_screenshots import background, gradient_text, load_font, rounded, GLASS_LINE  # noqa: E402

ROOT = os.path.join(os.path.dirname(__file__), "..", "store_screenshots")
INK_MUTED = (185, 182, 214)


def medium_screenshots():
    out = os.path.join(ROOT, "ios-medium")
    os.makedirs(out, exist_ok=True)
    for n in range(1, 6):
        img = Image.open(os.path.join(ROOT, "ios", f"{n}.png")).convert("RGB")  # 不能有透明通道
        img.resize((1206, 2622), Image.LANCZOS).save(os.path.join(out, f"{n}.png"), optimize=True)
    print("ios-medium/1-5.png  1206×2622")


def phone(path, height):
    shot = Image.open(path).convert("RGB")
    w = int(shot.size[0] * height / shot.size[1])
    return rounded(shot.resize((w, height), Image.LANCZOS), int(height * 0.055))


def banner(w, h, out_name, shots_from=(2, 1, 5), phone_h=900, align_right=False):
    canvas = background(w, h).convert("RGB")
    s = h / 1280  # 以 1920×1280 為基準縮放
    # 左半：圖示、名稱、標語（放在垂直置中的安全範圍）
    icon = Image.open(os.path.join(ROOT, "android", "icon_512.png")).convert("RGB").resize((int(200 * s), int(200 * s)), Image.LANCZOS)
    icon = rounded(icon, int(46 * s))
    left = int(w * 0.5 - 860 * s)
    top = int(h / 2 - 330 * s)
    canvas.paste(icon, (left, top), icon)
    title_font = load_font(int(150 * s))
    name_w = title_font.getlength("城市低語")
    y = gradient_text(canvas, "城市低語", title_font, left + name_w / 2 + 10 * s, top + int(230 * s))
    draw = ImageDraw.Draw(canvas)
    draw.text((left, y + 10 * s), "Mood Whisper", font=load_font(int(56 * s)), fill=INK_MUTED)
    draw.text((left, y + 100 * s), "匿名寫下此刻的心情，看見附近的人", font=load_font(int(52 * s)), fill=(243, 240, 255))
    # 右半：三支手機畫面
    ph = int(phone_h * s)
    shots = [phone(os.path.join(ROOT, "raw", f"{n}.png"), ph) for n in shots_from]
    pw = shots[0].size[0]
    gap = int(40 * s)
    if align_right:  # 窄的畫布：手機靠右排，右邊留和左邊文字一樣的邊距
        x0 = int(w - (len(shots) * pw + (len(shots) - 1) * gap) - (w * 0.5 - 860 * s))
    else:  # 寬的畫布：手機從中線右邊開始排
        x0 = int(w * 0.5 + 120 * s)
    for i, img in enumerate(shots):
        x = x0 + i * (pw + gap)
        yy = int(h / 2 - ph / 2 + (0 if i % 2 else 50 * s))
        glow = Image.new("L", (w, h), 0)
        ImageDraw.Draw(glow).rounded_rectangle((x, yy, x + pw, yy + ph), radius=int(50 * s), fill=120)
        canvas.paste(Image.new("RGB", (w, h), (110, 70, 220)), (0, 0), glow.filter(__import__("PIL.ImageFilter").ImageFilter.GaussianBlur(int(40 * s))))
        canvas.paste(img, (x, yy), img)
        ImageDraw.Draw(canvas).rounded_rectangle((x, yy, x + pw, yy + ph), radius=int(50 * s), outline=GLASS_LINE[:3], width=max(2, int(3 * s)))
    canvas.save(os.path.join(ROOT, out_name), optimize=True)
    print(f"{out_name}  {w}×{h}")


if __name__ == "__main__":
    medium_screenshots()
    banner(3840, 1646, "appstore_title.png")
    banner(1920, 1280, "appstore_search.png", shots_from=(2, 5), phone_h=760, align_right=True)
