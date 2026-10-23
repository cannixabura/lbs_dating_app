"""故事型短片合成器：AI 真人鏡頭＋半透明 App 畫面疊加＋字幕＋結尾卡，輸出 9:16 與 16:9（無聲，配樂另加）。

用法：python3 tool/make_story_short.py marketing/shorts/pride.json
需要 Pillow 與 ffmpeg（環境變數 FFMPEG 指定路徑，預設用 PATH 裡的 ffmpeg）。

JSON：
{
  "out": "marketing/shorts/out/pride",          # 會輸出 pride_9x16.mp4 與 pride_16x9.mp4
  "crossfade": 0.5,
  "shots": [
    {"src": "footage/shot1.mov", "dur": 5, "caption": "字幕",
     "app": {"src": "footage/app.mov", "start": 15, "dur": 5}   # 或 {"image": "x.png", "crop": [l, t, r, b]}
    },
    {"end": true, "dur": 4, "title": "…", "subtitle": "…", "note": "…"}
  ]
}
- 真人鏡頭會延展或剪短到 dur（setpts 慢動作），統一 1080×1920、30fps。
- "audio": true 時另外輸出 *_ambient 版本：保留 AI 片段自帶的環境音（跟著慢動作拉長、鏡頭間交叉淡化，結尾卡靜音淡出）。
- App 畫面放在右下方的圓角手機框裡，88% 不透明，淡入 0.4 秒（app.y 可調高度）；字幕在上方三分之一的半透明膠囊裡。
"""
import json
import os
import shutil
import subprocess
import sys
import tempfile

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H, FPS = 1080, 1920, 30
FFMPEG = os.environ.get("FFMPEG") or shutil.which("ffmpeg") or "ffmpeg"
FONT = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
TC_SEMIBOLD, TC_REGULAR = 10, 2
APP_W = 430                       # 手機框寬度
APP_X, APP_Y = W - APP_W - 44, 640  # 右側偏下：避開臉，也避開 Shorts 底部按鈕區
CAPTION_Y = 250
ROOT = os.path.join(os.path.dirname(__file__), "..")


def font(size, index=TC_SEMIBOLD):
    return ImageFont.truetype(FONT, size, index=index)


def run(args):
    subprocess.run([FFMPEG, "-v", "error", "-y", *args], check=True)


def caption_png(text, path):
    """白字＋深色半透明膠囊，支援換行。"""
    f = font(58)
    lines = text.split("\n")
    widths = [f.getlength(l) for l in lines]
    lh = 82
    pad_x, pad_y = 44, 26
    bw, bh = int(max(widths) + pad_x * 2), int(lh * len(lines) + pad_y * 2)
    img = Image.new("RGBA", (W, bh + 40), (0, 0, 0, 0))
    x0 = (W - bw) // 2
    pill = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ImageDraw.Draw(pill).rounded_rectangle((x0, 20, x0 + bw, 20 + bh), radius=bh // 2 if len(lines) == 1 else 40, fill=(7, 11, 31, 150))
    img = Image.alpha_composite(img, pill.filter(ImageFilter.GaussianBlur(1)))
    d = ImageDraw.Draw(img)
    for i, (l, lw) in enumerate(zip(lines, widths)):
        d.text(((W - lw) / 2, 20 + pad_y + i * lh), l, font=f, fill=(243, 240, 255, 255))
    img.save(path)
    return img.size[1]


def phone_frame_mask(w, h, path):
    r = int(w * 0.09)
    m = Image.new("L", (w, h), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, w - 1, h - 1), radius=r, fill=224)  # 88% 不透明
    m.save(path)


def phone_border(w, h, path):
    r = int(w * 0.09)
    img = Image.new("RGBA", (w + 40, h + 40), (0, 0, 0, 0))
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ImageDraw.Draw(glow).rounded_rectangle((20, 20, 20 + w, 20 + h), radius=r, outline=(180, 120, 255, 160), width=10)
    img = Image.alpha_composite(img, glow.filter(ImageFilter.GaussianBlur(12)))
    ImageDraw.Draw(img).rounded_rectangle((20, 20, 20 + w, 20 + h), radius=r, outline=(196, 170, 255, 170), width=3)
    img.save(path)


def end_card(shot, path):
    img = Image.new("RGB", (W, H), (7, 11, 31))
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse((-200, 300, W + 200, 1300), fill=120)
    img = Image.composite(Image.new("RGB", (W, H), (70, 40, 150)), img, glow.filter(ImageFilter.GaussianBlur(200)))
    icon = Image.open(os.path.join(ROOT, "store_screenshots/android/icon_512.png")).convert("RGB").resize((260, 260), Image.LANCZOS)
    m = Image.new("L", icon.size, 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, 259, 259), radius=58, fill=255)
    img.paste(icon, ((W - 260) // 2, 520), m)
    d = ImageDraw.Draw(img)
    for text, y, f, color in [
        (shot["title"], 880, font(60), (243, 240, 255)),
        (shot["subtitle"], 990, font(46, TC_REGULAR), (185, 182, 214)),
        (shot.get("note", ""), 1600, font(30, TC_REGULAR), (140, 137, 176)),
    ]:
        for i, line in enumerate(text.split("\n")):
            d.text(((W - f.getlength(line)) / 2, y + i * int(f.size * 1.4)), line, font=f, fill=color)
    img.save(path)


def build_audio(i, shot, base, tmp):
    """這一鏡的環境音：跟影片同樣的放慢比例，長度補齊到 dur；結尾卡是靜音。"""
    out = os.path.join(tmp, f"a{i:02d}.wav")
    dur = shot["dur"]
    if shot.get("end"):
        run(["-f", "lavfi", "-t", str(dur), "-i", "anullsrc=r=48000:cl=stereo", out])
        return out
    src = os.path.join(base, shot["src"])
    probe = subprocess.run([FFMPEG, "-i", src], capture_output=True, text=True).stderr
    hms = probe.split("Duration: ")[1].split(",")[0].split(":")
    src_dur = float(hms[0]) * 3600 + float(hms[1]) * 60 + float(hms[2])
    speed = max(0.5, min(1.0, src_dur / dur))
    run(["-i", src, "-af", f"atempo={speed},aresample=48000,apad,atrim=duration={dur},afade=in:d=0.3,afade=out:st={dur - 0.5}:d=0.5",
         "-ac", "2", out])
    return out


def build_shot(i, shot, base, tmp):
    out = os.path.join(tmp, f"s{i:02d}.mp4")
    dur = shot["dur"]
    if shot.get("end"):
        png = os.path.join(tmp, f"end{i}.png")
        end_card(shot, png)
        run(["-loop", "1", "-t", str(dur), "-i", png, "-vf", f"fps={FPS},format=yuv420p,fade=in:st=0:d=0.6", "-c:v", "libx264", "-crf", "18", out])
        return out

    src = os.path.join(base, shot["src"])
    probe = subprocess.run([FFMPEG, "-i", src], capture_output=True, text=True).stderr
    hms = probe.split("Duration: ")[1].split(",")[0].split(":")
    src_dur = float(hms[0]) * 3600 + float(hms[1]) * 60 + float(hms[2])
    speed = min(1.0, src_dur / dur)  # 片段比目標短就放慢
    inputs = ["-i", src]
    graph = [f"[0:v]setpts=PTS/{speed},scale={W}:{H}:force_original_aspect_ratio=increase,crop={W}:{H},fps={FPS},trim=duration={dur},setpts=PTS-STARTPTS,"
             f"eq=brightness=-0.02:saturation=1.05[base]"]
    last = "base"
    n = 1
    app = shot.get("app")
    if app:
        app_h = int(APP_W * 2868 / 1320)
        mask = os.path.join(tmp, "mask.png")
        border = os.path.join(tmp, "border.png")
        if not os.path.exists(mask):
            phone_frame_mask(APP_W, app_h, mask)
            phone_border(APP_W, app_h, border)
        if "image" in app:
            img = Image.open(os.path.join(base, app["image"])).convert("RGB")
            if "crop" in app:
                img = img.crop(tuple(app["crop"]))
            img = img.resize((APP_W, int(APP_W * img.height / img.width)), Image.LANCZOS)
            app_h = img.height
            mask = os.path.join(tmp, f"mask{i}.png")
            border = os.path.join(tmp, f"border{i}.png")
            phone_frame_mask(APP_W, app_h, mask)
            phone_border(APP_W, app_h, border)
            still = os.path.join(tmp, f"app{i}.png")
            img.save(still)
            inputs += ["-loop", "1", "-t", str(dur), "-i", still]
            app_chain = f"[{n}:v]fps={FPS},format=rgba"
        else:
            inputs += ["-ss", str(app["start"]), "-t", str(app["dur"]), "-i", os.path.join(base, app["src"])]
            sp = app["dur"] / dur
            app_chain = f"[{n}:v]setpts=PTS/{sp},fps={FPS},scale={APP_W}:{app_h},format=rgba"
        inputs += ["-loop", "1", "-i", mask, "-loop", "1", "-i", border]
        a_in = app.get("in", 0.4)
        graph.append(f"{app_chain}[a{i}];[{n + 1}:v]format=gray,scale={APP_W}:{app_h}[m{i}];[a{i}][m{i}]alphamerge,fade=in:st={a_in}:d=0.4:alpha=1[am{i}]")
        graph.append(f"[{n + 2}:v]format=rgba,fade=in:st={a_in}:d=0.4:alpha=1[b{i}]")
        y = app.get("y", APP_Y)  # 特寫鏡頭可以把手機框放低，避開臉
        graph.append(f"[{last}][b{i}]overlay={APP_X - 20}:{y - 20}:shortest=1[t1];[t1][am{i}]overlay={APP_X}:{y}:shortest=1[withapp]")
        last = "withapp"
        n += 3
    if shot.get("caption"):
        cap = os.path.join(tmp, f"cap{i}.png")
        caption_png(shot["caption"], cap)
        inputs += ["-loop", "1", "-i", cap]
        c0, c1 = shot.get("caption_in", 0.5), dur - 0.6
        graph.append(f"[{n}:v]format=rgba,fade=in:st={c0}:d=0.4:alpha=1,fade=out:st={c1}:d=0.4:alpha=1[c{i}];[{last}][c{i}]overlay=0:{CAPTION_Y}:shortest=1[cap]")
        last = "cap"
        n += 1
    graph.append(f"[{last}]trim=duration={dur},format=yuv420p[v]")
    run([*inputs, "-filter_complex", ";".join(graph), "-map", "[v]", "-an", "-c:v", "libx264", "-crf", "18", "-r", str(FPS), out])
    return out


def main():
    cfg_path = sys.argv[1]
    cfg = json.load(open(cfg_path))
    base = os.path.dirname(os.path.abspath(cfg_path))
    out = os.path.join(ROOT, cfg["out"])
    os.makedirs(os.path.dirname(out), exist_ok=True)
    xf = cfg.get("crossfade", 0.5)
    with tempfile.TemporaryDirectory() as tmp:
        parts = []
        for i, shot in enumerate(cfg["shots"]):
            parts.append(build_shot(i, shot, base, tmp))
            print(f"shot {i + 1}/{len(cfg['shots'])}")
        durs = [s["dur"] for s in cfg["shots"]]
        inputs, chain, offset, last = [], [], 0.0, "0:v"
        for p in parts:
            inputs += ["-i", p]
        for k in range(1, len(parts)):
            offset += durs[k - 1] - xf
            chain.append(f"[{last}][{k}:v]xfade=transition=fade:duration={xf}:offset={offset:.2f}[x{k}]")
            last = f"x{k}"
        vertical = out + "_9x16.mp4"
        run([*inputs, "-filter_complex", ";".join(chain), "-map", f"[{last}]", "-an", "-c:v", "libx264", "-crf", "18", "-pix_fmt", "yuv420p", "-movflags", "+faststart", vertical])
        if cfg.get("audio"):
            # 環境音：每鏡一段，鏡頭交界用與畫面相同長度的交叉淡化
            auds = [build_audio(i, s, base, tmp) for i, s in enumerate(cfg["shots"])]
            a_in, a_chain, a_last = [], [], "0:a"
            for a in auds:
                a_in += ["-i", a]
            for k in range(1, len(auds)):
                a_chain.append(f"[{a_last}][{k}:a]acrossfade=d={xf}:c1=tri:c2=tri[y{k}]")
                a_last = f"y{k}"
            mix = os.path.join(tmp, "ambient.m4a")
            run([*a_in, "-filter_complex", ";".join(a_chain) + f";[{a_last}]loudnorm=I=-20:TP=-2[o]", "-map", "[o]", "-c:a", "aac", "-b:a", "192k", mix])
            cfg["_mix"] = mix
            run(["-i", vertical, "-i", mix, "-map", "0:v", "-map", "1:a", "-c:v", "copy", "-c:a", "copy", "-shortest", "-movflags", "+faststart", out + "_ambient_9x16.mp4"])
        # 16:9：中間放直式畫面，兩側用同一段畫面放大模糊當背景
        run(["-i", vertical, "-filter_complex",
             "[0:v]split[a][b];[a]scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,boxblur=40:2,eq=brightness=-0.12[bg];"
             "[b]scale=-2:1080[fg];[bg][fg]overlay=(W-w)/2:0,format=yuv420p[v]",
             "-map", "[v]", "-an", "-c:v", "libx264", "-crf", "19", "-movflags", "+faststart", out + "_16x9.mp4"])
        if cfg.get("audio"):
            run(["-i", out + "_16x9.mp4", "-i", cfg["_mix"], "-map", "0:v", "-map", "1:a", "-c:v", "copy", "-c:a", "copy", "-shortest", "-movflags", "+faststart", out + "_ambient_16x9.mp4"])
    print(vertical)
    print(out + "_16x9.mp4")


if __name__ == "__main__":
    main()
