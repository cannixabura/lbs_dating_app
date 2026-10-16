"""把模擬器截圖合成成商店用的行銷圖：夜空漸層背景＋上方標語＋圓角的 App 畫面。

用法：
  python3 tool/compose_store_screenshots.py <截圖資料夾> <輸出資料夾>

截圖資料夾裡放 1.png … 5.png（iPhone 6.9 吋模擬器的原始截圖，1320×2868），
輸出 ios/（1320×2868，App Store 6.9 吋）與 android/（1080×1920，Google Play 手機）兩組。
需要 Pillow：pip install pillow
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

TAGLINES = {
    1: "寫下心情，城市就亮起一道光",
    2: "敲門，等一個片刻交集",
    3: "十分鐘的對話，說完就消散",
    4: "留一句話，給下一個經過這裡的人",
    5: "今晚的城市，是什麼心情？",
}

# 設計系統的顏色
NIGHT_900 = (7, 11, 31)
NIGHT_SKY = (26, 20, 70)
AURORA_VIOLET = (180, 140, 255)
AURORA_BLUE = (120, 200, 255)
GLASS_LINE = (196, 170, 255, 110)

FONT_CANDIDATES = [
    "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc",
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/Library/Fonts/Arial Unicode.ttf",
]


def load_font(size):
    for path in FONT_CANDIDATES:
        if os.path.exists(path):
            # PingFang.ttc 第 10 個字型是 PingFang TC Semibold（繁體中文）；其他字型檔就用第一個
            for index in (10, 0):
                try:
                    return ImageFont.truetype(path, size, index=index)
                except (OSError, IndexError):
                    continue
    return ImageFont.load_default()


def background(w, h):
    """深藍到夜空紫的直向漸層，上方加一圈淡紫的光暈。"""
    bg = Image.new("RGB", (w, h), NIGHT_900)
    px = bg.load()
    for y in range(h):
        t = y / (h - 1)
        mix = min(1.0, t * 1.4)
        color = tuple(int(NIGHT_900[i] + (NIGHT_SKY[i] - NIGHT_900[i]) * mix) for i in range(3))
        for x in range(w):
            px[x, y] = color
    glow = Image.new("L", (w, h), 0)
    ImageDraw.Draw(glow).ellipse((-w * 0.2, -h * 0.12, w * 1.2, h * 0.32), fill=90)
    glow = glow.filter(ImageFilter.GaussianBlur(w * 0.12))
    violet = Image.new("RGB", (w, h), (90, 60, 190))
    return Image.composite(violet, bg, glow)


def gradient_text(canvas, text, font, center_x, top):
    """紫到藍的漸層文字，底下墊一層同色光暈。"""
    bbox = font.getbbox(text)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    mask = Image.new("L", (tw + 40, th + 40), 0)
    ImageDraw.Draw(mask).text((20 - bbox[0], 20 - bbox[1]), text, font=font, fill=255)
    grad = Image.new("RGB", mask.size)
    gp = grad.load()
    for x in range(mask.size[0]):
        t = x / max(1, mask.size[0] - 1)
        c = tuple(int(AURORA_VIOLET[i] + (AURORA_BLUE[i] - AURORA_VIOLET[i]) * t) for i in range(3))
        for y in range(mask.size[1]):
            gp[x, y] = c
    left = int(center_x - mask.size[0] / 2)
    halo = mask.filter(ImageFilter.GaussianBlur(18)).point(lambda v: int(v * 0.5))
    canvas.paste(Image.new("RGB", mask.size, (120, 90, 230)), (left, top), halo)
    canvas.paste(grad, (left, top), mask)
    return top + mask.size[1]


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, img.size[0], img.size[1]), radius=radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def compose(shot_path, tagline, w, h):
    canvas = background(w, h)
    scale = w / 1320
    # 標語太長時自動縮小字級，左右至少留 7% 的邊
    size = int(92 * scale)
    font = load_font(size)
    while font.getlength(tagline) > w * 0.86 and size > 40:
        size -= 2
        font = load_font(size)
    text_bottom = gradient_text(canvas, tagline, font, w / 2, int(250 * scale))

    shot = Image.open(shot_path).convert("RGB")
    target_w = int(w * 0.80)
    shot = shot.resize((target_w, int(shot.size[1] * target_w / shot.size[0])), Image.LANCZOS)
    radius = int(78 * scale)
    shot = rounded(shot, radius)
    x = (w - target_w) // 2
    y = text_bottom + int(110 * scale)

    # 畫面四周的紫色光暈與細邊框
    glow = Image.new("L", (w, h), 0)
    ImageDraw.Draw(glow).rounded_rectangle((x - 6, y - 6, x + target_w + 6, y + shot.size[1] + 6), radius=radius, fill=150)
    glow = glow.filter(ImageFilter.GaussianBlur(int(48 * scale)))
    canvas.paste(Image.new("RGB", (w, h), (110, 70, 220)), (0, 0), glow)
    canvas.paste(shot, (x, y), shot)
    border = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle((x, y, x + target_w, y + shot.size[1]), radius=radius, outline=GLASS_LINE, width=max(2, int(3 * scale)))
    canvas = Image.alpha_composite(canvas.convert("RGBA"), border).convert("RGB")
    return canvas  # 畫面底部超出畫布的部分自然裁掉


def main():
    src, dst = sys.argv[1], sys.argv[2]
    for folder, (w, h) in {"ios": (1320, 2868), "android": (1080, 1920)}.items():
        os.makedirs(os.path.join(dst, folder), exist_ok=True)
        for n, tagline in TAGLINES.items():
            shot = os.path.join(src, f"{n}.png")
            if not os.path.exists(shot):
                print(f"略過 {n}：找不到 {shot}")
                continue
            out = os.path.join(dst, folder, f"{n}.png")
            compose(shot, tagline, w, h).save(out, optimize=True)
            print(f"{out}  {w}×{h}")


if __name__ == "__main__":
    main()
