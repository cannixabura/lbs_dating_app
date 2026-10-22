"""每日審查清單：列出需要人工處理的檢舉（使用條款承諾 24 小時內處理）。

用法（需要已登入 Firebase CLI）：
  python3 tool/daily_review.py                  列出上次審查之後的新檢舉、待審的隱藏帳號、被檢舉的集會
  python3 tool/daily_review.py --all            列出最近 7 天的全部檢舉
  python3 tool/daily_review.py keep <uid>       確認違規：帳號維持隱藏，標記已審查
  python3 tool/daily_review.py unhide <uid>     檢舉不成立：解除隱藏，標記已審查
  python3 tool/daily_review.py gathering-ok <gid>     集會檢舉不成立：標記已審查
  python3 tool/daily_review.py end-gathering <gid>    確認違規：結束這場集會（主持人下次連線時移除「主持」標記）
  python3 tool/daily_review.py unhide-announcement <gid> <aid>   公告檢舉不成立：恢復這則公告

每次列出後會記下時間（tool/.review_last，不進 git），下次只列新的檢舉。
"""
import datetime
import json
import os
import subprocess
import sys
import time

PROJECT = "mood-whisper-f7de9"
MARK = os.path.join(os.path.dirname(__file__), ".review_last")
REASONS = {"harassment": "騷擾或霸凌", "sexual": "色情或性暗示", "scam": "詐騙或廣告", "hate": "仇恨或暴力", "impersonation": "冒充他人", "other": "其他"}
CONTEXTS = {"bubble": "氣泡", "knock": "敲門", "chat": "聊天", "whisper": "低語", "gathering": "集會"}


def db_get(path):
    out = subprocess.run(["firebase", "database:get", path, "--project", PROJECT], check=True, capture_output=True, text=True).stdout
    return json.loads(out or "null") or {}


def db_update(path, data):
    subprocess.run(["firebase", "database:update", path, json.dumps(data, ensure_ascii=False), "--project", PROJECT, "--force"], check=True, capture_output=True, text=True)


def db_remove(path):
    subprocess.run(["firebase", "database:remove", path, "--project", PROJECT, "--force"], check=True, capture_output=True, text=True)


def when(ms):
    return datetime.datetime.fromtimestamp(ms / 1000).strftime("%m/%d %H:%M")


def name_of(uid, profiles):
    nick = (profiles.get(uid) or {}).get("nickname") or ""
    return f"{nick}（{uid}）" if nick else uid


def listing(show_all):
    now = time.time() * 1000
    since = now - 7 * 86400_000
    if not show_all and os.path.exists(MARK):
        since = float(open(MARK).read().strip() or since)
    reports = [r for r in db_get("/reports").values() if isinstance(r, dict) and r.get("at", 0) > since]
    profiles = db_get("/profiles")
    moderation = db_get("/moderation")
    review = db_get("/gatheringReview")

    print(f"\n=== 新檢舉（{when(since)} 之後，共 {len(reports)} 則）===")
    by_target = {}
    for r in sorted(reports, key=lambda r: r["at"]):
        by_target.setdefault(r["target"], []).append(r)
    for target, items in by_target.items():
        ctx = CONTEXTS.get(items[0].get("context"), items[0].get("context"))
        shown = target if ":" in target else name_of(target, profiles)
        print(f"\n[{ctx}] {shown}　{len({i['reporter'] for i in items})} 人檢舉")
        for i in items:
            detail = f"：{i['detail']}" if i.get("detail") else ""
            print(f"  {when(i['at'])}  {REASONS.get(i['reason'], i['reason'])}{detail}")
    if not reports:
        print("  沒有新檢舉。")

    pending = {uid: m for uid, m in moderation.items() if isinstance(m, dict) and m.get("hidden") and not m.get("reviewed")}
    print(f"\n=== 自動隱藏、等待審查的帳號（{len(pending)}）===")
    for uid, m in pending.items():
        print(f"  {name_of(uid, profiles)}　{when(m.get('at', 0))}　{m.get('reason', '')}")
        print(f"    確認違規：python3 tool/daily_review.py keep {uid}")
        print(f"    不成立：  python3 tool/daily_review.py unhide {uid}")
    if not pending:
        print("  沒有。")

    flagged = {gid: g for gid, g in review.items() if isinstance(g, dict) and g.get("flagged") and not g.get("reviewed")}
    print(f"\n=== 被檢舉的集會（{len(flagged)}）===")
    for gid, g in flagged.items():
        gathering = db_get(f"/gatherings/{gid}")
        status = "進行中" if gathering.get("status") == "active" else "已結束"
        print(f"  {g.get('emoji', '')} {g.get('name', '')}（{gid}，{status}）主持人 {name_of(g.get('hostUid', ''), profiles)}")
        announcements = db_get(f"/gatheringAnnouncements/{gid}")
        for aid, a in sorted(announcements.items(), key=lambda kv: kv[1].get("at", 0)):
            mark = "【已隱藏】" if a.get("hidden") else ""
            print(f"    {when(a.get('at', 0))} {mark}{a.get('text', '')}　(公告 {aid})")
        print(f"    不成立：    python3 tool/daily_review.py gathering-ok {gid}")
        print(f"    結束活動：  python3 tool/daily_review.py end-gathering {gid}")
    if not flagged:
        print("  沒有。")

    print("\n低語被 3 人檢舉會自動隱藏；要恢復，請到 Upstash 主控台把 whisper:<id> 的 hidden 改成 0。")
    if not show_all:
        with open(MARK, "w") as f:
            f.write(str(now))


def main():
    args = sys.argv[1:]
    if not args or args[0] == "--all":
        return listing(show_all=bool(args))
    cmd = args[0]
    now = int(time.time() * 1000)
    if cmd == "keep":
        db_update(f"/moderation/{args[1]}", {"hidden": True, "reviewed": True, "reviewedAt": now})
    elif cmd == "unhide":
        db_update(f"/moderation/{args[1]}", {"hidden": False, "reviewed": True, "reviewedAt": now})
    elif cmd == "gathering-ok":
        db_update(f"/gatheringReview/{args[1]}", {"reviewed": True, "reviewedAt": now})
    elif cmd == "end-gathering":
        gid = args[1]
        host = db_get(f"/gatherings/{gid}/hostUid")
        db_update(f"/gatherings/{gid}", {"status": "ended", "endedReason": "moderator", "endedAt": now})
        if host:
            db_remove(f"/hosting/{host}")
        db_update(f"/gatheringReview/{gid}", {"reviewed": True, "reviewedAt": now, "action": "ended"})
    elif cmd == "unhide-announcement":
        db_update(f"/gatheringAnnouncements/{args[1]}/{args[2]}", {"hidden": False})
    else:
        print(__doc__)
        return
    print("完成。")


if __name__ == "__main__":
    main()
