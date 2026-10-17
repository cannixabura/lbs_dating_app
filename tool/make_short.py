"""YouTube Shorts 合成器（1080×1920、30fps、無聲；音樂之後在 YouTube Studio 或剪輯軟體加）。

用法：python3 tool/make_short.py marketing/shorts/01.json
需要 Pillow 與 ffmpeg（環境變數 FFMPEG 指定路徑，預設用 PATH 裡的 ffmpeg）。

JSON：
{
  "out": "marketing/shorts/out/01_preview.mp4",
  "crossfade": 0.4,
  "shots": [
    {"type": "image", "src": "...png", "dur": 2.5, "crop": "bottom", "zoom": [1.0, 1.12], "focus": [0.5, 0.6],
     "caption": "字幕", "placeholder": "預覽：真人鏡頭待替換"},
    {"type": "video", "src": "...mp4", "start": 0.2, "dur": 1.7, "caption": "…"},
    {"type": "end"}
  ]
}
- image：靜態圖加慢速推鏡（Ken Burns）。crop=bottom 代表只取圖的下半部（避開插畫自帶的標題）。
- video：取 src 的 [start, start+dur]，自動縮放裁切成 9:16。真人 AI 片段到了，把 image 換成 video 即可。
- 同一個 shot 可用 "parts": [{"src", "start", "dur"}, ...] 串接多段影片（中間硬切）。
- end：結尾卡（App 圖示＋城市低語｜公測招募中＋連結在說明欄）。
"""
import json
import math
import os
import shutil
import subprocess
import sys
import tempfile

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H, FPS = 1080, 1920, 30
FFMPEG = os.environ.get("FFMPEG") or shutil.which("ffmpeg") or "ffmpeg"
FONT = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
TC_MEDIUM, TC_SEMIBOLD, TC_REGULAR = 6, 10, 2
NIGHT = (7, 11, 31)
CAPTION_Y = 1180          # Shorts 下方約 25% 會被標題與按鈕蓋住，字幕放在中下方
CAPTION_FADE = 0.35


def font(size, index):
    return ImageFont.truetype(FONT, size, index=index)


# ---------------------------------------------------------------------------
# 素材
def cover(img, w=W, h=H, focus=(0.5, 0.5)):
    s = max(w / img.width, h / img.height)
    img = img.resize((math.ceil(img.width * s), math.ceil(img.height * s)), Image.LANCZOS)
    x = int((img.width - w) * focus[0])
    y = int((img.height - h) * focus[1])
    return img.crop((x, y, x + w, y + h))


def grade(img):
    """夜光調色：壓暗一點、偏藍紫，加暗角，讓插畫與 App 畫面的質感一致。"""
    img = img.convert("RGB")
    tint = Image.new("RGB", img.size, (40, 30, 90))
    img = Image.blend(img, tint, 0.12)
    vig = Image.new("L", img.size, 0)
    ImageDraw.Draw(vig).ellipse((-W * 0.25, -H * 0.15, W * 1.25, H * 1.15), fill=255)
    vig = vig.filter(ImageFilter.GaussianBlur(160))
    dark = Image.new("RGB", img.size, NIGHT)
    return Image.composite(img, dark, vig.point(lambda v: int(90 + v * 165 / 255)))


class ImageShot:
    def __init__(self, s):
        art = Image.open(s["src"]).convert("RGB")
        if s.get("crop") == "bottom":   # 插畫上方有自帶的標題，取下半部
            art = art.crop((0, int(art.height * 0.36), art.width, art.height))
        self.z0, self.z1 = s.get("zoom", [1.0, 1.1])
        self.fx, self.fy = s.get("focus", [0.5, 0.5])
        zmax = max(self.z0, self.z1)
        self.base = cover(art, int(W * zmax) + 2, int(H * zmax) + 2, (self.fx, self.fy))
        self.dur = s["dur"]

    def frame(self, t):
        p = min(1, max(0, t / self.dur))
        p = p * p * (3 - 2 * p)  # ease in-out
        z = self.z0 + (self.z1 - self.z0) * p
        bw, bh = self.base.size
        # base 的大小是畫面的 zmax 倍：z=1 看到整張 base，z=zmax 剛好看到一個畫面大小
        cw, ch = bw / z, bh / z
        x = (bw - cw) * self.fx
        y = (bh - ch) * self.fy
        return grade(self.base.resize((W, H), Image.BILINEAR, box=(x, y, x + cw, y + ch)))


class VideoShot:
    def __init__(self, s, tmp, idx):
        parts = s.get("parts") or [{"src": s["src"], "start": s.get("start", 0), "dur": s["dur"]}]
        self.frames = []
        for j, part in enumerate(parts):
            d = os.path.join(tmp, f"v{idx}_{j}")
            os.makedirs(d)
            vf = (f"fps={FPS},scale='if(gt(a,{W}/{H}),-2,{W})':'if(gt(a,{W}/{H}),{H},-2)',"
                  f"crop={W}:{H}:(iw-{W})/2:(ih-{H})/2")
            # 模擬器錄影是可變幀率，用 -t 限制輸入長度不可靠；直接限制輸出的幀數
            subprocess.run([FFMPEG, "-hide_banner", "-loglevel", "error", "-ss", str(part["start"]), "-i", part["src"],
                            "-vf", vf, "-frames:v", str(round(part["dur"] * FPS)), os.path.join(d, "%05d.png")], check=True)
            self.frames += sorted(os.path.join(d, f) for f in os.listdir(d))
        self.dur = s["dur"]
        self.grade = s.get("grade", False)

    def frame(self, t):
        i = min(len(self.frames) - 1, max(0, int(t * FPS)))
        img = Image.open(self.frames[i]).convert("RGB")
        return grade(img) if self.grade else img


class EndCard:
    def __init__(self, s):
        self.dur = s.get("dur", 1.5)
        c = Image.new("RGB", (W, H), NIGHT)
        glow = Image.new("L", (W, H), 0)
        ImageDraw.Draw(glow).ellipse((W / 2 - 300, 560, W / 2 + 300, 1160), fill=150)
        glow = glow.filter(ImageFilter.GaussianBlur(120))
        c = Image.composite(Image.new("RGB", (W, H), (110, 70, 220)), c, glow).convert("RGBA")
        d = 300
        icon = Image.open("assets/images/app_icon.png").convert("RGBA").resize((d, d), Image.LANCZOS)
        m = Image.new("L", (d, d), 0)
        ImageDraw.Draw(m).ellipse((0, 0, d - 1, d - 1), fill=255)
        icon.putalpha(m)
        c.alpha_composite(icon, ((W - d) // 2, 600))
        dr = ImageDraw.Draw(c)
        f1, f2, f3 = font(84, TC_SEMIBOLD), font(44, TC_MEDIUM), font(34, TC_REGULAR)
        for text, f, y, col in (("城市低語", f1, 960, (243, 240, 255)), ("公測招募中", f2, 1090, (200, 180, 255)),
                                ("報名連結在說明欄", f3, 1170, (185, 182, 214))):
            dr.text(((W - f.getlength(text)) / 2, y), text, font=f, fill=col)
        self.img = c.convert("RGB")

    def frame(self, t):
        return self.img


# ---------------------------------------------------------------------------
# 字幕
def caption_layer(text, y0=CAPTION_Y):
    """字幕：白字＋柔和陰影，底下墊一塊半透明的夜色膠囊，壓在 App 畫面上也讀得清楚。"""
    f = font(58, TC_MEDIUM)
    lines = text.split("\n")
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    lw = max(f.getlength(line) for line in lines)
    pill = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(pill).rounded_rectangle(((W - lw) / 2 - 44, y0 - 26, (W + lw) / 2 + 44, y0 + 88 * len(lines) + 4),
                                           radius=44, fill=NIGHT + (150,))
    layer.alpha_composite(pill)
    shadow = Image.new("L", (W, H), 0)
    sd = ImageDraw.Draw(shadow)
    y = y0
    pos = []
    for line in lines:
        x = (W - f.getlength(line)) / 2
        pos.append((x, y, line))
        sd.text((x, y), line, font=f, fill=255)
        y += 88
    shadow = shadow.filter(ImageFilter.GaussianBlur(10))
    sh = Image.new("RGBA", (W, H), (0, 0, 0, 255))
    sh.putalpha(shadow.point(lambda v: int(v * 0.85)))
    layer.alpha_composite(sh)
    d = ImageDraw.Draw(layer)
    for x, y, line in pos:
        d.text((x, y), line, font=f, fill=(246, 244, 255, 255))
    return layer


def placeholder_layer(text):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    f = font(30, TC_MEDIUM)
    tw = f.getlength(text)
    d.rounded_rectangle((40, 140, 40 + tw + 48, 200), radius=30, fill=(255, 95, 210, 200))
    d.text((64, 150), text, font=f, fill=(255, 255, 255, 255))
    return layer


def with_alpha(layer, a):
    if a >= 1:
        return layer
    l2 = layer.copy()
    l2.putalpha(layer.getchannel("A").point(lambda v: int(v * a)))
    return l2


# ---------------------------------------------------------------------------
def main(spec_path):
    spec = json.load(open(spec_path, encoding="utf-8"))
    xf = spec.get("crossfade", 0.4)
    tmp = tempfile.mkdtemp(prefix="short_")
    shots = []
    for i, s in enumerate(spec["shots"]):
        if s["type"] == "image":
            src = ImageShot(s)
        elif s["type"] == "video":
            src = VideoShot(s, tmp, i)
        else:
            src = EndCard(s)
        shots.append({"src": src, "cap": caption_layer(s["caption"], s.get("caption_y", CAPTION_Y)) if s.get("caption") else None,
                      "ph": placeholder_layer(s["placeholder"]) if s.get("placeholder") else None})
    # 時間軸：相鄰鏡頭重疊 xf 秒做交叉淡化
    t = 0
    for sh in shots:
        sh["start"] = t
        t += sh["src"].dur - xf
    total = t + xf
    out = spec["out"]
    os.makedirs(os.path.dirname(out), exist_ok=True)
    enc = subprocess.Popen([FFMPEG, "-hide_banner", "-loglevel", "error", "-y", "-f", "rawvideo", "-pix_fmt", "rgb24",
                            "-s", f"{W}x{H}", "-r", str(FPS), "-i", "-", "-c:v", "libx264", "-pix_fmt", "yuv420p",
                            "-preset", "medium", "-crf", "18", "-movflags", "+faststart", out], stdin=subprocess.PIPE)

    def render(sh, lt):
        img = sh["src"].frame(lt).convert("RGBA")
        d = sh["src"].dur
        if sh["cap"]:
            a = min(1, max(0, (lt - 0.15) / CAPTION_FADE), max(0, (d - xf - lt) / CAPTION_FADE))
            img.alpha_composite(with_alpha(sh["cap"], a))
        if sh["ph"]:
            img.alpha_composite(sh["ph"])
        return img.convert("RGB")

    n = int(round(total * FPS))
    for k in range(n):
        tt = k / FPS
        cur = [sh for sh in shots if sh["start"] <= tt < sh["start"] + sh["src"].dur]
        if len(cur) >= 2:  # 交叉淡化
            a, b = cur[0], cur[1]
            p = (tt - b["start"]) / xf
            frame = Image.blend(render(a, tt - a["start"]), render(b, tt - b["start"]), max(0, min(1, p)))
        else:
            sh = cur[0] if cur else shots[-1]
            frame = render(sh, tt - sh["start"])
        if k == 0:  # 開頭從黑淡入
            frame = Image.blend(Image.new("RGB", (W, H), NIGHT), frame, 0.0)
        elif k < 9:
            frame = Image.blend(Image.new("RGB", (W, H), NIGHT), frame, k / 9)
        enc.stdin.write(frame.tobytes())
    enc.stdin.close()
    enc.wait()
    shutil.rmtree(tmp, ignore_errors=True)
    print(f"{out}  {total:.1f} 秒")


if __name__ == "__main__":
    main(sys.argv[1])
