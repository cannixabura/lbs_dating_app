"""社群貼文圖產生器（1080×1350，IG／Threads／FB 都適用的 4:5 直式）。

用法：python3 tool/make_social_posts.py marketing/posts.json marketing/images
posts.json 每一則貼文有 id、template 與該模板需要的欄位；這支程式只負責畫圖，文案在 posts.json 與 marketing/*.md。
需要 Pillow。

模板：
  bubble    一顆發光的心情氣泡  {mood, color, kicker, headline}
  phone     手機截圖展示        {shot, headline, sub}
  scene     夜景插畫滿版        {art, headline, sub}
  steps     三步驟說明          {headline, steps:[[標題, 說明] x3]}
  question  問句＋心情色        {question, sub}
  poster    點亮之夜招募海報    {headline, when, sub}
"""
import json
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1080, 1350
FONT = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
TC = {"regular": 2, "medium": 6, "semibold": 10, "light": 14}
VIOLET, BLUE = (180, 140, 255), (120, 200, 255)
INK, MUTED, FAINT = (243, 240, 255), (185, 182, 214), (140, 137, 176)
MOODS = {  # 與 App 的心情色一致
    "calm": (74, 222, 154), "joy": (255, 209, 102), "love": (255, 107, 157), "sad": (96, 165, 250),
    "passion": (255, 138, 76), "angry": (248, 113, 113), "default": (169, 156, 255),
}
CTA = "公測報名 → 連結在個人檔案"


def font(size, weight="regular"):
    return ImageFont.truetype(FONT, size, index=TC[weight])


def night_bg(tint=(95, 60, 200)):
    bg = Image.new("RGB", (W, H))
    px = bg.load()
    for y in range(H):
        t = y / H
        c = (int(7 + 16 * t), int(11 + 8 * t), int(31 + 40 * t))
        for x in range(W):
            px[x, y] = c
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse((-200, -300, W + 200, 520), fill=120)
    glow = glow.filter(ImageFilter.GaussianBlur(160))
    return Image.composite(Image.new("RGB", (W, H), tint), bg, glow).convert("RGBA")


def glow_layer(size, shape_fn, color, blur, alpha=180):
    m = Image.new("L", size, 0)
    shape_fn(ImageDraw.Draw(m), alpha)
    layer = Image.new("RGBA", size, color + (0,))
    layer.putalpha(m.filter(ImageFilter.GaussianBlur(blur)))
    return layer


def gradient_text(canvas, text, f, cx=None, x=None, y=0, colors=(VIOLET, BLUE)):
    bb = f.getbbox(text)
    w, h = bb[2] - bb[0], bb[3] - bb[1]
    mask = Image.new("L", (w + 30, h + 30), 0)
    ImageDraw.Draw(mask).text((15 - bb[0], 15 - bb[1]), text, font=f, fill=255)
    grad = Image.new("RGBA", mask.size)
    gp = grad.load()
    for gx in range(mask.size[0]):
        t = gx / max(1, mask.size[0] - 1)
        c = tuple(int(colors[0][i] + (colors[1][i] - colors[0][i]) * t) for i in range(3)) + (255,)
        for gy in range(mask.size[1]):
            gp[gx, gy] = c
    grad.putalpha(mask)
    left = int(cx - mask.size[0] / 2) if cx is not None else x - 15
    halo = Image.new("RGBA", mask.size, (120, 90, 230, 0))
    halo.putalpha(mask.filter(ImageFilter.GaussianBlur(14)).point(lambda v: int(v * 0.5)))
    canvas.alpha_composite(halo, (left, y))
    canvas.alpha_composite(grad, (left, y))
    return y + mask.size[1] - 15


def wrap(text, f, max_w):
    """中文逐字換行，保留手動換行。"""
    lines = []
    for para in text.split("\n"):
        line = ""
        for ch in para:
            if f.getlength(line + ch) > max_w and line:
                lines.append(line)
                line = ch
            else:
                line += ch
        lines.append(line)
    return lines


def text_block(draw, text, f, y, fill, cx=W / 2, max_w=W - 160, spacing=1.55, align="center", x=80):
    lh = int(f.size * spacing)
    for line in wrap(text, f, max_w):
        if align == "center":
            draw.text((cx - f.getlength(line) / 2, y), line, font=f, fill=fill)
        else:
            draw.text((x, y), line, font=f, fill=fill)
        y += lh
    return y


def brand(canvas, cta=CTA):
    d = ImageDraw.Draw(canvas)
    icon = Image.open("assets/images/app_icon.png").convert("RGBA").resize((64, 64), Image.LANCZOS)
    m = Image.new("L", (64, 64), 0)
    ImageDraw.Draw(m).ellipse((0, 0, 63, 63), fill=255)
    icon.putalpha(m)
    canvas.alpha_composite(icon, (64, H - 112))
    d.text((144, H - 104), "城市低語", font=font(32, "semibold"), fill=INK)
    d.text((144, H - 62), "Mood Whisper", font=font(20), fill=FAINT)
    if cta:
        f = font(26, "medium")
        tw = f.getlength(cta)
        pad = 26
        box = (W - 64 - tw - pad * 2, H - 110, W - 64, H - 54)
        d.rounded_rectangle(box, radius=28, fill=(26, 31, 74, 220), outline=(196, 170, 255, 120), width=2)
        d.text((box[0] + pad, box[1] + 11), cta, font=f, fill=INK)


def glass(canvas, box, radius=36, glow=None):
    if glow:
        canvas.alpha_composite(glow_layer((W, H), lambda d, a: d.rounded_rectangle(box, radius=radius, fill=a), glow, 40, 140))
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(layer).rounded_rectangle(box, radius=radius, fill=(26, 31, 74, 200), outline=(196, 170, 255, 110), width=2)
    canvas.alpha_composite(layer)


# ---------------------------------------------------------------------------
def t_bubble(p):
    c = night_bg()
    col = MOODS.get(p.get("color", "default"), MOODS["default"])
    d = ImageDraw.Draw(c)
    y = text_block(d, p.get("kicker", ""), font(34, "medium"), 170, MUTED)
    f = font(76, "semibold")
    lines = wrap(p["mood"], f, 860)
    bw = int(max(f.getlength(l) for l in lines)) + 120
    bh = len(lines) * 106 + 80
    top = 420
    box = ((W - bw) // 2, top, (W + bw) // 2, top + bh)
    c.alpha_composite(glow_layer((W, H), lambda dr, a: dr.rounded_rectangle(box, radius=48, fill=a), col, 60, 200))
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.rounded_rectangle(box, radius=48, fill=(18, 22, 58, 235), outline=col + (255,), width=5)
    tip = [(W // 2 - 26, box[3] - 2), (W // 2 + 26, box[3] - 2), (W // 2, box[3] + 34)]
    ld.polygon(tip, fill=(18, 22, 58, 235))
    ld.line([tip[0], tip[2], tip[1]], fill=col + (255,), width=5)
    c.alpha_composite(layer)
    d = ImageDraw.Draw(c)
    ty = top + 40
    for line in lines:
        d.text((W / 2 - f.getlength(line) / 2, ty), line, font=f, fill=INK)
        ty += 106
    pin_y = box[3] + 80
    c.alpha_composite(glow_layer((W, H), lambda dr, a: dr.ellipse((W / 2 - 22, pin_y - 22, W / 2 + 22, pin_y + 22), fill=a), col, 18, 255))
    d.ellipse((W / 2 - 14, pin_y - 14, W / 2 + 14, pin_y + 14), fill=col)
    d.ellipse((W / 2 - 90, pin_y + 26, W / 2 + 90, pin_y + 62), outline=col + (150,), width=3)
    gradient_text(c, p["headline"], font(54, "semibold"), cx=W / 2, y=pin_y + 130)
    brand(c)
    return c


def t_phone(p):
    c = night_bg((70, 60, 210))
    y = gradient_text(c, p["headline"], font(66, "semibold"), cx=W / 2, y=110)
    d = ImageDraw.Draw(c)
    text_block(d, p.get("sub", ""), font(32), y + 22, MUTED, max_w=880)
    shot = Image.open(p["shot"]).convert("RGB")
    if p.get("focus") == "bottom":  # 重點在畫面下半（例如低語卡片），只取下半部
        shot = shot.crop((0, int(shot.size[1] * 0.42), shot.size[0], shot.size[1]))
    pw = 520
    ph = int(shot.size[1] * pw / shot.size[0])
    shot = shot.resize((pw, ph), Image.LANCZOS).convert("RGBA")
    m = Image.new("L", shot.size, 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, pw, ph), radius=64, fill=255)
    shot.putalpha(m)
    px, py = (W - pw) // 2, 400
    c.alpha_composite(glow_layer((W, H), lambda dr, a: dr.rounded_rectangle((px, py, px + pw, py + ph), radius=64, fill=a), (120, 80, 235), 60, 170))
    frame = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle((px - 8, py - 8, px + pw + 8, py + ph + 8), radius=72, fill=(30, 26, 70, 255), outline=(196, 170, 255, 140), width=3)
    c.alpha_composite(frame)
    c.alpha_composite(shot, (px, py))
    # 底部漸層蓋住手機下半，放品牌列
    fade = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    fp = fade.load()
    for yy in range(H - 330, H):
        a = int(255 * min(1, (yy - (H - 330)) / 200))
        for xx in range(W):
            fp[xx, yy] = (7, 11, 31, a)
    c.alpha_composite(fade)
    brand(c)
    return c


def t_scene(p):
    art = Image.open(p["art"]).convert("RGB")
    s = max(W / art.size[0], H / art.size[1])
    art = art.resize((int(art.size[0] * s), int(art.size[1] * s)), Image.LANCZOS)
    # 取插畫下半部：上方是插畫自帶的標題文字，不能和我們的標語疊在一起
    left = (art.size[0] - W) // 2
    art = art.crop((left, art.size[1] - H, left + W, art.size[1])).convert("RGBA")
    shade = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sp = shade.load()
    for yy in range(H):
        t = yy / H
        # 上方 24% 幾乎全黑（蓋掉插畫本身的文字與介面），再到 44% 漸漸透出；底部再暗下來放品牌列
        if t < 0.24:
            a = 248
        elif t < 0.44:
            a = int(248 * (1 - (t - 0.24) / 0.20))
        else:
            a = int(225 * max(0, (t - 0.62) / 0.38))
        for xx in range(W):
            sp[xx, yy] = (7, 11, 31, a)
    art.alpha_composite(shade)
    y = gradient_text(art, p["headline"], font(72, "semibold"), cx=W / 2, y=120)
    d = ImageDraw.Draw(art)
    text_block(d, p.get("sub", ""), font(34), y + 26, INK, max_w=860)
    brand(art)
    return art


def t_steps(p):
    c = night_bg()
    y = gradient_text(c, p["headline"], font(68, "semibold"), cx=W / 2, y=120) + 60
    d = ImageDraw.Draw(c)
    colors = [MOODS["calm"], MOODS["love"], BLUE]
    for i, (title, body) in enumerate(p["steps"]):
        box = (80, y, W - 80, y + 250)
        glass(c, box, glow=colors[i])
        d = ImageDraw.Draw(c)
        cx, cy = 170, y + 125
        d.ellipse((cx - 50, cy - 50, cx + 50, cy + 50), outline=colors[i], width=4)
        num = str(i + 1)
        fn = font(52, "semibold")
        d.text((cx - fn.getlength(num) / 2, cy - 36), num, font=fn, fill=colors[i])
        d.text((260, y + 52), title, font=font(42, "semibold"), fill=INK)
        text_block(d, body, font(30), y + 120, MUTED, max_w=W - 80 - 260 - 40, align="left", x=260, spacing=1.5)
        y += 290
    brand(c)
    return c


def t_question(p):
    c = night_bg((80, 50, 180))
    d = ImageDraw.Draw(c)
    keys = ["calm", "joy", "love", "sad", "passion", "default"]
    labels = ["平靜", "開心", "愛", "難過", "熱情", "其他"]
    f = font(80, "semibold")
    y = 260
    for line in wrap(p["question"], f, 860):
        y = gradient_text(c, line, f, cx=W / 2, y=y) + 10
    d = ImageDraw.Draw(c)
    y = text_block(d, p.get("sub", ""), font(34), y + 30, MUTED, max_w=860) + 70
    gap = 150
    x0 = W / 2 - gap * 2.5
    for i, k in enumerate(keys):
        cx, cy = x0 + gap * i, y + 50
        c.alpha_composite(glow_layer((W, H), lambda dr, a: dr.ellipse((cx - 46, cy - 46, cx + 46, cy + 46), fill=a), MOODS[k], 22, 220))
        d = ImageDraw.Draw(c)
        d.ellipse((cx - 34, cy - 34, cx + 34, cy + 34), fill=MOODS[k])
        lf = font(28, "medium")
        d.text((cx - lf.getlength(labels[i]) / 2, cy + 58), labels[i], font=lf, fill=INK)
    brand(c, cta="留言告訴我們 👇" if p.get("comment_cta") else CTA)
    return c


def t_poster(p):
    c = night_bg((110, 50, 200))
    # 遠方的城市光點
    d = ImageDraw.Draw(c)
    import random
    rnd = random.Random(7)
    for _ in range(140):
        x, y = rnd.randint(0, W), rnd.randint(700, 1100)
        col = MOODS[rnd.choice(list(MOODS))]
        r = rnd.choice([3, 4, 5, 7])
        c.alpha_composite(glow_layer((W, H), lambda dr, a, x=x, y=y, r=r: dr.ellipse((x - r * 3, y - r * 3, x + r * 3, y + r * 3), fill=a), col, 8, 120))
        d = ImageDraw.Draw(c)
        d.ellipse((x - r, y - r, x + r, y + r), fill=col)
    d.text((W / 2 - font(36, "medium").getlength("公測招募") / 2, 150), "公測招募", font=font(36, "medium"), fill=MUTED)
    y = 220
    for line in p["headline"].split("\n"):
        y = gradient_text(c, line, font(92, "semibold"), cx=W / 2, y=y) + 6
    d = ImageDraw.Draw(c)
    box = (W / 2 - 330, y + 40, W / 2 + 330, y + 140)
    glass(c, box, radius=50, glow=(180, 120, 255))
    d = ImageDraw.Draw(c)
    wf = font(44, "semibold")
    d.text((W / 2 - wf.getlength(p["when"]) / 2, y + 62), p["when"], font=wf, fill=INK)
    text_block(d, p.get("sub", ""), font(32), 1140, INK, max_w=860)
    brand(c)
    return c


TEMPLATES = {"bubble": t_bubble, "phone": t_phone, "scene": t_scene, "steps": t_steps, "question": t_question, "poster": t_poster}


def main(spec, out):
    os.makedirs(out, exist_ok=True)
    posts = json.load(open(spec, encoding="utf-8"))["posts"]
    only = set(sys.argv[3:])
    for p in posts:
        if only and p["id"] not in only:
            continue
        img = TEMPLATES[p["template"]](p).convert("RGB")
        path = os.path.join(out, f'{p["id"]}.jpg')
        img.save(path, quality=90, optimize=True)
        print(path)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
