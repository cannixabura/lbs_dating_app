"""Google Play 主題圖片（1024×500）：左邊圓形圖示＋字標＋標語，右邊斜放一張雷達截圖。

用法：python3 tool/make_feature_graphic.py store_screenshots/raw/1.png store_screenshots/android/feature_graphic.png
需要 Pillow。
"""
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1024, 500
FONT = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
SEMIBOLD, REGULAR = 10, 2  # PingFang TC
VIOLET, BLUE = (180, 140, 255), (120, 200, 255)


def font(size, index):
    return ImageFont.truetype(FONT, size, index=index)


def background():
    bg = Image.new("RGB", (W, H))
    px = bg.load()
    for y in range(H):
        for x in range(W):
            t = 0.55 * (x / W) + 0.45 * (y / H)
            px[x, y] = (int(7 + 22 * t), int(11 + 12 * t), int(31 + 45 * t))
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse((-120, -160, 520, 420), fill=110)
    ImageDraw.Draw(glow).ellipse((560, 40, 1180, 640), fill=80)
    glow = glow.filter(ImageFilter.GaussianBlur(110))
    return Image.composite(Image.new("RGB", (W, H), (95, 60, 200)), bg, glow).convert("RGBA")


def gradient_text(canvas, text, f, x, y):
    bb = f.getbbox(text)
    mask = Image.new("L", (bb[2] - bb[0] + 20, bb[3] - bb[1] + 20), 0)
    ImageDraw.Draw(mask).text((10 - bb[0], 10 - bb[1]), text, font=f, fill=255)
    grad = Image.new("RGBA", mask.size)
    gp = grad.load()
    for gx in range(mask.size[0]):
        t = gx / max(1, mask.size[0] - 1)
        c = tuple(int(VIOLET[i] + (BLUE[i] - VIOLET[i]) * t) for i in range(3)) + (255,)
        for gy in range(mask.size[1]):
            gp[gx, gy] = c
    grad.putalpha(mask)
    halo = Image.new("RGBA", mask.size, (120, 90, 230, 0))
    halo.putalpha(mask.filter(ImageFilter.GaussianBlur(10)).point(lambda v: int(v * 0.55)))
    canvas.alpha_composite(halo, (x, y))
    canvas.alpha_composite(grad, (x, y))
    return y + mask.size[1]


def circle_icon(d):
    ic = Image.open("assets/images/app_icon.png").convert("RGBA").resize((d, d), Image.LANCZOS)
    m = Image.new("L", (d, d), 0)
    ImageDraw.Draw(m).ellipse((0, 0, d - 1, d - 1), fill=255)
    ic.putalpha(m)
    return ic


def phone(shot_path, width):
    shot = Image.open(shot_path).convert("RGB")
    h = int(shot.size[1] * width / shot.size[0])
    shot = shot.resize((width, h), Image.LANCZOS).convert("RGBA")
    r = int(width * 0.12)
    m = Image.new("L", shot.size, 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, width, h), radius=r, fill=255)
    shot.putalpha(m)
    frame = Image.new("RGBA", (width + 12, h + 12), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle((0, 0, width + 11, h + 11), radius=r + 6, fill=(30, 26, 70, 255), outline=(196, 170, 255, 150), width=3)
    frame.alpha_composite(shot, (6, 6))
    return frame


def main(shot_path, out_path):
    canvas = background()

    # 右側：微微傾斜的雷達畫面，底部超出畫面
    ph = phone(shot_path, 300).rotate(-8, resample=Image.BICUBIC, expand=True)
    glow = Image.new("L", (W, H), 0)
    gx, gy = 640, 40
    ImageDraw.Draw(glow).rounded_rectangle((gx + 30, gy + 30, gx + ph.size[0] - 30, H + 200), radius=60, fill=160)
    glow = glow.filter(ImageFilter.GaussianBlur(45))
    halo = Image.new("RGBA", (W, H), (110, 70, 220, 0))
    halo.putalpha(glow)
    canvas = Image.alpha_composite(canvas, halo)
    canvas.alpha_composite(ph, (gx, gy))

    # 左側：圖示、字標、標語
    d = 120
    icon_glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(icon_glow).ellipse((70, 88, 70 + d + 20, 88 + d + 20), fill=170)
    icon_glow = icon_glow.filter(ImageFilter.GaussianBlur(26))
    ig = Image.new("RGBA", (W, H), (120, 80, 235, 0))
    ig.putalpha(icon_glow)
    canvas = Image.alpha_composite(canvas, ig)
    canvas.alpha_composite(circle_icon(d), (80, 98))
    ring = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(ring).ellipse((80, 98, 80 + d, 98 + d), outline=(196, 170, 255, 150), width=3)
    canvas = Image.alpha_composite(canvas, ring)

    y = gradient_text(canvas, "城市低語", font(76, SEMIBOLD), 70, 240)
    draw = ImageDraw.Draw(canvas)
    draw.text((82, y + 8), "寫下心情，城市就亮起一道光", font=font(30, REGULAR), fill=(230, 226, 255))
    draw.text((82, y + 56), "匿名・附近・十分鐘後消散", font=font(22, REGULAR), fill=(170, 165, 210))

    canvas.convert("RGB").save(out_path, optimize=True)
    print(f"{out_path}  {W}×{H}")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
