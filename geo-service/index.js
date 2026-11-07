const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onValueWritten } = require("firebase-functions/v2/database");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { defineSecret } = require("firebase-functions/params");
const cors = require("cors")({ origin: true });
const {
    DENSITY_RADIUS_KM, MAX_SHADOW_RETENTION_MS, shadowRetentionFor, classifyPresence,
} = require("./presence");
const { evaluateReports } = require("./moderation");
const { fuzzLocation } = require("./fuzz");
const citymood = require("./citymood");
const whisper = require("./whisper");
const { maskBlockedTerms, isDisallowed } = require("./contentfilter");
const demo = require("./demo");
const betasignup = require("./betasignup");
const gathering = require("./gathering");
const publicmood = require("./publicmood");
const timewhisper = require("./timewhisper");
const placenote = require("./placenote");
const beacon = require("./beacon");
const { langOf, localize } = require("./i18n");
const parallel = require("./parallel");
const quantum = require("./quantum");
const orbs = require("./orbs");
const aiya = require("./aiya");
const refunds = require("./refunds");
const gifts = require("./gifts");
const wgroup = require("./whispergroup");

// 位置模糊化開關（2026-10 暫時關閉，雷達顯示真實位置；距離仍由 App 分級顯示）。
// 重新開啟：改成 true 並重新部署 geo-service，同時更新隱私權政策與使用條款的位置說明。
const FUZZ_LOCATION = false;

if (!admin.apps.length) admin.initializeApp();

// 🔐 金鑰改由 Firebase Secret Manager 提供，設定方式：
//    firebase functions:secrets:set UPSTASH_REDIS_REST_URL
//    firebase functions:secrets:set UPSTASH_REDIS_REST_TOKEN
const UPSTASH_URL = defineSecret("UPSTASH_REDIS_REST_URL");
const UPSTASH_TOKEN = defineSecret("UPSTASH_REDIS_REST_TOKEN");
const UPSTASH_SECRETS = [UPSTASH_URL, UPSTASH_TOKEN];

const MAX_RADIUS_KM = 5;
const MAX_MOOD_LENGTH = 20;
const MAX_NICKNAME_LENGTH = 10;
const MAX_NEARBY_RESULTS = 300;

// 去除貼上 Secret 時誤帶的空白、換行與引號
function cleanSecret(secret) {
    return secret.value().trim().replace(/^["']|["']$/g, '').trim();
}

async function upstashFetch(path, body) {
    const response = await fetch(cleanSecret(UPSTASH_URL).replace(/\/+$/, '') + path, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${cleanSecret(UPSTASH_TOKEN)}`, 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });
    if (!response.ok) throw new Error(`Upstash API Error: ${response.status}`);
    return response.json();
}

async function sendUpstashCommand(commandArray) {
    const data = await upstashFetch('', commandArray);
    if (data.error) throw new Error(`Redis Error: ${data.error}`);
    return data.result;
}

// 🚀 Pipeline：多個指令合併成一次 HTTP 請求，回傳每個指令的 result
async function sendUpstashPipeline(commands) {
    if (commands.length === 0) return [];
    const data = await upstashFetch('/pipeline', commands);
    return data.map((item) => {
        if (item.error) throw new Error(`Redis Error: ${item.error}`);
        return item.result;
    });
}

// 備用金庫：向 Redis 查詢最新暱稱
async function getNicknameFromRedis(uid) {
    try {
        return await sendUpstashCommand(["HGET", `user_data:${uid}`, "nickname"]);
    } catch (e) { console.error('Redis lookup failed:', e); }
    return null;
}

// 使用者的語言（App 每次更新位置時回報；查不到就用繁中）
async function getLangFromRedis(uid) {
    try { return await sendUpstashCommand(["HGET", `user_data:${uid}`, "lang"]); } catch (e) { return null; }
}

// 驗證 Firebase ID Token，回傳真實的 uid；失敗則回傳 null
async function verifyCaller(req) {
    const match = (req.headers.authorization || '').match(/^Bearer (.+)$/);
    if (!match) return null;
    try {
        const decoded = await admin.auth().verifyIdToken(match[1]);
        return decoded.uid;
    } catch (e) { return null; }
}

// 以「肉眼看到的字數」截斷（emoji 如 😵‍💫 算 1 個字），與 App 輸入框的 maxLength 一致
const graphemeSegmenter = new Intl.Segmenter('zh', { granularity: 'grapheme' });
function truncateVisible(value, maxChars) {
    const chars = Array.from(graphemeSegmenter.segment(String(value || '')), (seg) => seg.segment);
    return chars.slice(0, maxChars).join('');
}

function isValidCoordinate(lat, lng) {
    return typeof lat === 'number' && typeof lng === 'number' &&
        Number.isFinite(lat) && Number.isFinite(lng) &&
        lat >= -85 && lat <= 85 && lng >= -180 && lng <= 180;
}

// ============================================================================
// API 1 & 2: 地理雷達運算 (維持在亞洲區，加速你的地圖讀取)
// ============================================================================
exports.updateLocation = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    // 🔐 uid 只信任 ID Token，不再接受 body 傳入，防止冒用他人身分
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });

    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(langOf(req), "座標格式錯誤") });
    // 不當字詞替換成「＊」（App Store 1.2 的內容過濾）
    // 審核通關碼：心情欄輸入後開啟審核示範對象，通關碼本身不會出現在雷達上
    const reviewCode = demo.isReviewCode(req.body.mood);
    const mood = reviewCode ? demo.REVIEW_MOOD : maskBlockedTerms(truncateVisible(req.body.mood, MAX_MOOD_LENGTH));
    const nickname = maskBlockedTerms(truncateVisible(req.body.nickname, MAX_NICKNAME_LENGTH));
    const timestamp = Date.now();
    try {
      if (reviewCode) await sendUpstashCommand(["SADD", demo.REVIEWERS_KEY, uid]);
      // 🔒 先算出對外公開的模糊位置（100m 網格，含遲滯）；精確座標只進地理索引，不會回傳給任何人
      const fuzzFields = [];
      if (FUZZ_LOCATION) {
          const [prevRow, prevCol] = await sendUpstashCommand(["HMGET", `user_data:${uid}`, "cellRow", "cellCol"]);
          const previousCell = prevRow != null && prevCol != null ? { row: parseInt(prevRow, 10), col: parseInt(prevCol, 10) } : null;
          const pub = fuzzLocation(lat, lng, uid, previousCell, timestamp);
          fuzzFields.push("flat", pub.lat.toString(), "flng", pub.lng.toString(), "cellRow", String(pub.row), "cellCol", String(pub.col));
      }
      // 平行宇宙：開啟且在支援的城市裡才放進 parallel_users，否則移除（舊版 App 不會送，等於關閉）
      const parallelOn = req.body.parallel === true && !!parallel.cityOf(lat, lng);
      const [, , hostingGid] = await sendUpstashPipeline([
          ["GEOADD", "city_users", lng.toString(), lat.toString(), uid],
          // 只有前景的 App 會呼叫，因此同時視為「活躍」心跳
          ["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "lang", langOf(req), "timestamp", timestamp.toString(),
              "state", "active", "stateAt", timestamp.toString(), ...fuzzFields],
          ["HGET", `user_data:${uid}`, "host"],
          parallelOn ? ["GEOADD", parallel.GEO_KEY, lng.toString(), lat.toString(), uid] : ["ZREM", parallel.GEO_KEY, uid],
      ]);
      // 集會的中心跟著主持人走（遊行隊伍會移動）；活動已被結束（例如人工審查）就移除「主持」標記
      if (hostingGid) {
          try {
              const status = (await admin.database().ref(`gatherings/${hostingGid}/status`).once('value')).val();
              if (status === 'active') await admin.database().ref(`gatherings/${hostingGid}`).update(gathering.publicCenter(lat, lng));
              else await sendUpstashCommand(["HDEL", `user_data:${uid}`, "host", "hostEmoji"]);
          } catch (e) { console.error('gathering centre update failed:', e); }
      }
      res.status(200).json({ success: true, message: "更新成功" });
    } catch (error) {
      console.error('updateLocation failed:', error);
      res.status(500).json({ success: false, error: localize(langOf(req), "更新失敗") });
    }
  });
});

/**
 * 附近的示範對象：台北示範（所有人）＋審核示範（只給輸入過通關碼的帳號）。
 * 不計入密度，也不在 city_users 裡，所以不影響殘影留存與城市心情天氣。
 * realCount：附近的真人數（不含殘影）；真人多時台北示範減量，審核示範不受影響。
 */
async function nearbyDemoBots(viewerUid, lat, lng, radiusKM, realCount = 0, lang = null) {
    const here = { lat, lng };
    const found = []; // [uid, distanceKm, {lat, lng}]
    const publicHits = await sendUpstashCommand([
        "GEOSEARCH", demo.PUBLIC_GEO_KEY, "FROMLONLAT", lng.toString(), lat.toString(),
        "BYRADIUS", radiusKM.toString(), "km", "ASC", "COUNT",
        String(realCount >= demo.CROWDED_REAL_USERS ? demo.CROWDED_MAX_RESULTS : demo.PUBLIC_MAX_RESULTS), "WITHDIST", "WITHCOORD",
    ]);
    for (const m of Array.isArray(publicHits) ? publicHits : []) {
        if (Array.isArray(m) && m[0]) found.push([m[0], parseFloat(m[1]), { lat: parseFloat(m[2][1]), lng: parseFloat(m[2][0]) }]);
    }

    const isReviewer = await sendUpstashCommand(["SISMEMBER", demo.REVIEWERS_KEY, viewerUid]);
    if (isReviewer === 1) {
        // 錨點跟著審核人員：第一次或移動超過 5 公里時重新放置
        const [aLat, aLng] = (await sendUpstashCommand(["HMGET", `demo_anchor:${viewerUid}`, "lat", "lng"])) || [];
        let anchor = aLat && aLng ? { lat: parseFloat(aLat), lng: parseFloat(aLng) } : null;
        if (!anchor || demo.distanceKm(anchor, here) > demo.REVIEW_REANCHOR_KM) {
            anchor = here;
            await sendUpstashCommand(["HSET", `demo_anchor:${viewerUid}`, "lat", String(lat), "lng", String(lng)]);
        }
        for (const bot of demo.reviewBots(anchor)) {
            const d = demo.distanceKm(here, bot);
            if (d <= radiusKM) found.push([bot.uid, d, { lat: bot.lat, lng: bot.lng }]);
        }
    }
    if (found.length === 0) return [];

    const profiles = await sendUpstashPipeline(found.map(([botUid]) => ["HMGET", `user_data:${botUid}`, "mood", "nickname", "hidden", "hostEmoji"]));
    const now = Date.now();
    const bots = [];
    found.forEach(([botUid, , pos], i) => {
        const [mood, nickname, hidden, hostEmoji] = profiles[i] || [];
        if (hidden === "1" || !nickname) return; // 被檢舉隱藏，或尚未建立資料
        bots.push({ uid: botUid, lat: pos.lat, lng: pos.lng, mood: localize(lang, mood || ""), nickname: localize(lang, nickname), status: 'active', shadowAge: 0, timestamp: now, demo: true, ...(hostEmoji ? { hostEmoji } : {}) });
    });
    return bots;
}

// 開啟平行宇宙的人（沒開的人只看得到他們），每個伺服器執行個體快取 10 秒
let parallelSnapshot = { at: 0, members: [] };
async function parallelMembers(now) {
    if (now - parallelSnapshot.at < 10000) return parallelSnapshot.members;
    const list = await sendUpstashCommand(parallel.snapshotCommand());
    const members = (Array.isArray(list) ? list : []).filter((m) => Array.isArray(m) && m[0])
        .map((m) => [m[0], { lat: parseFloat(m[1][1]), lng: parseFloat(m[1][0]) }]);
    parallelSnapshot = { at: now, members };
    return members;
}

// 現在有人的城市（每個伺服器執行個體每分鐘檢查一次）；檢查失敗就不過濾，照舊搜所有城市
let liveCityCache = { at: 0, live: null };
async function liveParallelCities(now) {
    if (now - liveCityCache.at < 60000) return liveCityCache.live;
    liveCityCache.at = now;
    try {
        liveCityCache.live = parallel.liveCities(await sendUpstashPipeline(parallel.liveCheckCommands()));
    } catch (e) {
        liveCityCache.live = null;
    }
    return liveCityCache.live;
}

/**
 * 平行宇宙的訪客：對應國家的城市裡、正開著 App（活躍）的人，以中心車站對齊疊到觀看者的城市。
 * 只要一方開啟就看得到：觀看者開啟 → 其他城市所有人；沒開 → 只有開啟的人。
 * 不回傳真實距離與真實位置；休息中與殘影都不跨城市，對方一離開就消失，不留痕跡。
 */
async function parallelVisitors(viewerUid, viewerCity, viewerOn, here, radiusKM, now, lang) {
    const found = []; // [uid, fromCity, {lat, lng}]
    const consider = (memberUid, pos, onlyCity) => {
        if (!memberUid || memberUid === viewerUid || memberUid.startsWith(demo.DEMO_PREFIX)) return;
        // 屬於離中心車站最近的那座城市；只疊台灣 ↔ 其他國家
        const home = parallel.cityOf(pos.lat, pos.lng);
        if (!home || !parallel.paired(home, viewerCity) || (onlyCity && home.id !== onlyCity)) return;
        found.push([memberUid, home, pos]);
    };
    if (viewerOn) {
        const { others, commands } = parallel.searchCommands(viewerCity, here.lat, here.lng, radiusKM, parallel.ALL_KEY, await liveParallelCities(now));
        (await sendUpstashPipeline(commands)).forEach((list, i) => {
            for (const m of Array.isArray(list) ? list : []) {
                if (Array.isArray(m)) consider(m[0], { lat: parseFloat(m[1][1]), lng: parseFloat(m[1][0]) }, others[i].id);
            }
        });
    } else {
        for (const [memberUid, pos] of await parallelMembers(now)) consider(memberUid, pos, null);
    }

    // 先投影、只留雷達圈內的人，再去拿資料
    const inRange = [];
    for (const [memberUid, home, pos] of found) {
        const shown = parallel.project(home, viewerCity, pos.lat, pos.lng, memberUid, now);
        if (parallel.distanceKm(here, shown) <= radiusKM) inRange.push({ memberUid, home, shown });
    }
    if (inRange.length === 0) return [];

    const profiles = await sendUpstashPipeline(inRange.map((c) => ["HMGET", `user_data:${c.memberUid}`, "mood", "nickname", "timestamp", "state", "stateAt", "hidden"]));
    const visitors = [];
    inRange.forEach(({ memberUid, home, shown }, i) => {
        const [mood, nickname, timestamp, state, stateAt, hidden] = profiles[i] || [];
        if (hidden === "1" || !nickname) return;
        const lastSeen = parseInt(timestamp || "0", 10);
        if (!lastSeen) return;
        const { status } = classifyPresence(state || null, parseInt(stateAt || "0", 10), lastSeen, now);
        if (status !== 'active') return; // 只顯示正開著 App 的人：休息中、殘影都不跨城市
        visitors.push({ uid: memberUid, lat: shown.lat, lng: shown.lng, mood: mood || "", nickname, status, shadowAge: 0, timestamp: lastSeen, parallel: home.id, parallelName: parallel.nameOf(home.id, lang) });
    });
    // 最近活動的優先，避免把雷達塞滿
    return visitors.sort((a, b) => b.timestamp - a.timestamp).slice(0, parallel.MAX_RESULTS);
}

exports.getNearby = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });

    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(langOf(req), "座標格式錯誤") });
    const radiusKM = Math.min(Math.max(Number(req.body.radiusKM) || MAX_RADIUS_KM, 0.1), MAX_RADIUS_KM);
    try {
      // 1 次請求：由近到遠取出半徑內的人，座標與距離直接由地理索引帶回
      const nearby = await sendUpstashCommand([
          "GEOSEARCH", "city_users", "FROMLONLAT", lng.toString(), lat.toString(),
          "BYRADIUS", radiusKM.toString(), "km", "ASC", "COUNT", MAX_NEARBY_RESULTS.toString(), "WITHDIST", "WITHCOORD"
      ]);
      // 每筆格式：[uid, 距離(km), [lng, lat]]
      const members = (Array.isArray(nearby) ? nearby : []).filter((m) => Array.isArray(m) && m[0] && m[0] !== uid);

      // 1 次請求：以 pipeline 一口氣取回所有人的資料
      const profiles = await sendUpstashPipeline(
          members.map(([memberUid]) => ["HMGET", `user_data:${memberUid}`, "mood", "nickname", "timestamp", "state", "stateAt", "hidden", "flat", "flng", "hostEmoji"])
      );

      const now = Date.now();
      const staleUids = [];
      const candidates = [];
      members.forEach(([memberUid, dist, coord], i) => {
          const [mood, nickname, timestamp, state, stateAt, hidden, flat, flng, hostEmoji] = profiles[i] || [];
          if (hidden === "1") return; // 被檢舉自動隱藏或人工隱藏，不出現在任何人的雷達上
          const lastSeen = parseInt(timestamp || "0", 10);
          if (!lastSeen) { staleUids.push(memberUid); return; }
          const presence = classifyPresence(state || null, parseInt(stateAt || "0", 10), lastSeen, now);
          // 超過最長留存（10 天）的殘影，任何密度下都不會再顯示，直接清除
          if (presence.status === 'shadow' && now - presence.shadowSince > MAX_SHADOW_RETENTION_MS) { staleUids.push(memberUid); return; }
          const precise = { lat: parseFloat(coord[1]), lng: parseFloat(coord[0]) };
          // 模糊化開啟時只回傳模糊位置；舊資料沒有存模糊位置時，當場由精確座標換算（無遲滯）
          const pub = !FUZZ_LOCATION ? precise
              : flat && flng ? { lat: parseFloat(flat), lng: parseFloat(flng) }
              : fuzzLocation(precise.lat, precise.lng, memberUid, null, now);
          candidates.push({ memberUid, dist: parseFloat(dist), pub, mood, nickname, lastSeen, presence, hostEmoji });
      });

      // 密度：觀看者周圍 1 公里內的人數，決定殘影能留存多久
      const peopleNearby = candidates.filter((c) => c.dist <= DENSITY_RADIUS_KM).length;
      const retentionMs = shadowRetentionFor(peopleNearby);

      const results = [];
      for (const c of candidates) {
          const { status } = c.presence;
          // Apple 5.1.2(i)：只顯示此刻打卡中、開著 App 的人；離開或切到背景就從地圖消失（休息中、殘影都不顯示）
          if (status !== 'active') continue;
          results.push({
              uid: c.memberUid, lng: c.pub.lng, lat: c.pub.lat,
              mood: c.mood || "",
              nickname: c.nickname || "",
              status,
              shadowAge: 0, // 舊版 App 仍會讀這個欄位
              timestamp: c.lastSeen,
              // 正在主持集會：雷達上顯示「主持」光環與活動圖標
              ...(c.hostEmoji ? { hostEmoji: c.hostEmoji } : {}),
          });
      }

      const realCount = results.filter((r) => r.status !== 'shadow').length;
      const demoBots = await nearbyDemoBots(uid, lat, lng, radiusKM, realCount, langOf(req));
      results.push(...demoBots);

      // 平行宇宙：其他城市的人投影到這裡（只要一方開啟）
      const viewerCity = parallel.cityOf(lat, lng);
      if (viewerCity && req.body.parallel === true) {
          // 審核示範對象（只有輸入過通關碼的帳號看得到）有一部分扮演對應城市來的訪客
          for (const bot of demoBots) {
              const from = demo.parallelDemoCity(bot.uid, viewerCity.country === parallel.TAIWAN);
              if (from) Object.assign(bot, demo.parallelDemoPosition(bot.uid, { lat, lng }), { nickname: demo.PARALLEL_DEMO_NAMES[from], parallel: from, parallelName: parallel.nameOf(from, langOf(req)) });
          }
      }
      if (viewerCity) {
          try {
              const seen = new Set(results.map((r) => r.uid));
              results.push(...(await parallelVisitors(uid, viewerCity, req.body.parallel === true, { lat, lng }, radiusKM, now, langOf(req))).filter((r) => !seen.has(r.uid)));
          } catch (e) { console.error('parallel visitors failed:', e); }
      }

      // 🧹 順手清掉過期的殘影，避免地理索引無限膨脹
      if (staleUids.length > 0) {
          try {
              await sendUpstashPipeline([["ZREM", "city_users", ...staleUids], ["ZREM", parallel.GEO_KEY, ...staleUids], ...staleUids.map((u) => ["DEL", `user_data:${u}`])]);
          } catch (e) { console.error('stale cleanup failed:', e); }
      }

      res.status(200).json({ success: true, data: results, density: { peopleNearby, shadowRetentionHours: retentionMs / 3600000 }, parallelCity: viewerCity ? viewerCity.id : null, parallelCityName: viewerCity ? parallel.nameOf(viewerCity.id, langOf(req)) : null });
    } catch (error) {
      console.error('getNearby failed:', error);
      res.status(500).json({ success: false, error: localize(langOf(req), "掃描失敗") });
    }
  });
});

// ============================================================================
// 量子世界：全世界一個房間，以台北 101 為原點排成蜂巢（規則見 quantum.js）
//   enter：入場（真實位置只用來排除中國大陸，不存）；3 分鐘內重新入場回到原本的席位
//   beat ：心跳＋掃描（位移、心情、量子寧靜），回傳附近的人、世界視角的光點、塌縮動畫、在線人數
//   leave：主動離開，席位立刻釋放，旁邊的人看到塌縮動畫
//   ── 第二期 ──
//   entangle：量子糾纏（invite / accept / decline / cut），任一方離開就塌縮
//   tunnel  ：量子穿隧，每次入場一次，跳到隨機一個空席位
//   chime   ：整點報時時送出一道報時微光
// ============================================================================

/** 釋放席位：空位放回清單，這次入場的資料全部刪掉 */
function releaseSeatCommands(uid, ordinal, region) {
    return [
        ...(ordinal != null ? [["ZADD", quantum.KEY.free, String(ordinal), String(ordinal)]] : []),
        ["DEL", quantum.KEY.seat(uid)],
        ["ZREM", quantum.KEY.beats, uid],
        ["ZREM", quantum.KEY.region(region || 'other'), uid],
        ["ZREM", quantum.KEY.geo, uid],
        ["HDEL", quantum.KEY.tz, uid],
    ];
}

/** 釋放席位，連同這次入場的糾纏：對方的光線斷掉，下一次心跳看到「糾纏已塌縮」 */
async function quantumReleaseCommands(list) {
    if (list.length === 0) return [];
    const info = await sendUpstashPipeline(list.flatMap(({ uid }) => [["SMEMBERS", quantum.KEY.ent(uid)], ["HGET", quantum.KEY.seat(uid), "nickname"]]));
    return list.flatMap(({ uid, ord, region }, i) => {
        const partners = Array.isArray(info[2 * i]) ? info[2 * i] : [];
        const nickname = info[2 * i + 1] || "";
        return [
            ...releaseSeatCommands(uid, ord, region),
            ["DEL", quantum.KEY.ent(uid), quantum.KEY.invites(uid), quantum.KEY.entGone(uid)],
            ...partners.flatMap((p) => [["SREM", quantum.KEY.ent(p), uid], ["RPUSH", quantum.KEY.entGone(p), nickname], ["EXPIRE", quantum.KEY.entGone(p), "600"]]),
        ];
    });
}

/** 順手釋放超過 3 分鐘沒心跳的席位 */
async function sweepQuantumSeats(now) {
    const stale = await sendUpstashCommand(["ZRANGEBYSCORE", quantum.KEY.beats, "-inf", String(now - quantum.GRACE_MS), "LIMIT", "0", String(quantum.STALE_SWEEP)]);
    if (!Array.isArray(stale) || stale.length === 0) return;
    const seats = await sendUpstashPipeline(stale.map((u) => ["HMGET", quantum.KEY.seat(u), "ord", "region"]));
    await sendUpstashPipeline(await quantumReleaseCommands(stale.map((u, i) => ({ uid: u, ord: seats[i]?.[0] ?? null, region: seats[i]?.[1] }))));
}

/** 第二期的個人設定：時區（晝夜色調）、是否顯示當地時間、量子同頻主題 */
function quantumProfileFields(body) {
    const fields = [];
    if (quantum.validTz(body.tz)) fields.push("tz", String(body.tz));
    if (typeof body.showTime === "boolean") fields.push("showTime", body.showTime ? "1" : "0");
    if (Array.isArray(body.topics)) fields.push("topics", quantum.cleanTopics(body.topics).join(","));
    return fields;
}

/**
 * 量子化身：App 想用的款式和目前的不一樣時才查擁有權（特殊款要買過），沒買過就用基本款。
 * @returns {Promise<string[]>} 要寫進席位的欄位
 */
async function quantumOrbFields(uid, requested, current) {
    if (typeof requested !== "string" || requested === current) return [];
    const owned = orbs.isFree(requested) ? null : (await admin.database().ref(`orbOwned/${uid}`).once("value")).val();
    return ["orb", orbs.resolveStyle(requested, owned)];
}

/** 量子跨年用：世界視角的光點只帶座標，時區另外放在一個 hash */
const quantumTzCommands = (uid, body) => (quantum.validTz(body.tz) ? [["HSET", quantum.KEY.tz, uid, String(body.tz)]] : []);

const parseTopics = (v) => (v ? String(v).split(",").map(Number).filter((t) => Number.isInteger(t)) : []);

/** 兩人之間有沒有封鎖（任一方） */
async function eitherBlocked(a, b) {
    const db = admin.database();
    const [x, y] = await Promise.all([db.ref(`blocks/${a}/${b}`).once("value"), db.ref(`blocks/${b}/${a}`).once("value")]);
    return x.exists() || y.exists();
}

/** 心跳附帶的第二期資料：糾纏的人（不管多遠都回傳位置）、糾纏邀請、剛塌縮的糾纏、整點報時 */
async function quantumExtras(uid, now) {
    const hour = quantum.chimeHour(now);
    const chiming = quantum.inChime(now);
    const nyAt = quantum.newYearAt(now);
    const together = quantum.newYearTogether(now);
    const [partners, invitesRaw, gone, chimeCount, chimeFx, nyCount, pairUid] = await sendUpstashPipeline([
        ["SMEMBERS", quantum.KEY.ent(uid)],
        ["HGETALL", quantum.KEY.invites(uid)],
        ["LRANGE", quantum.KEY.entGone(uid), "0", "-1"],
        chiming ? ["ZCARD", quantum.KEY.chime(hour)] : ["ECHO", ""],
        chiming ? ["ZRANGE", quantum.KEY.chimeFx(hour), String(-quantum.CHIME_FX_MAX), "-1"] : ["ECHO", ""],
        together ? ["ZCARD", quantum.KEY.newYear(nyAt)] : ["ECHO", ""],
        ["GET", gifts.pairKey(uid)],
    ]);
    const partnerList = Array.isArray(partners) ? partners : [];
    const invites = Object.entries(hashToObject(invitesRaw)).filter(([, at]) => now - parseInt(at, 10) <= quantum.INVITE_MS).map(([from]) => from);
    const seats = await sendUpstashPipeline([...partnerList, ...invites].map((u) => ["HMGET", quantum.KEY.seat(u), "ord", "east", "north", "nickname", "beat"]));
    const ent = [], cleanup = [];
    partnerList.forEach((p, i) => {
        const [ord, east, north, nickname, beat] = seats[i] || [];
        if (ord == null) { cleanup.push(["SREM", quantum.KEY.ent(uid), p]); return; }
        if (now - parseInt(beat || "0", 10) > quantum.VISIBLE_MS) return; // 斷線中先不畫光線
        const st = quantumState({ ord, east, north });
        ent.push({ uid: p, nickname: nickname || "", code: st.s.code, lat: st.pos.lat, lng: st.pos.lng });
    });
    const invitesOut = [];
    invites.forEach((from, j) => {
        const [ord, , , nickname] = seats[partnerList.length + j] || [];
        if (ord != null && !partnerList.includes(from)) invitesOut.push({ uid: from, nickname: nickname || "", code: quantum.seat(parseInt(ord, 10)).code });
    });
    const goneList = Array.isArray(gone) ? gone : [];
    if (goneList.length > 0) cleanup.push(["DEL", quantum.KEY.entGone(uid)]);
    if (cleanup.length > 0) await sendUpstashPipeline(cleanup);
    const out = { ent, invites: invitesOut, entGone: goneList };
    // 糾纏款：配對的對方也在量子世界時，回傳他的位置畫光繩（不管多遠）
    if (typeof pairUid === "string" && pairUid) {
        const [ord, east, north, nickname, beat] = (await sendUpstashCommand(["HMGET", quantum.KEY.seat(pairUid), "ord", "east", "north", "nickname", "beat"])) || [];
        if (ord != null && now - parseInt(beat || "0", 10) <= quantum.VISIBLE_MS) {
            const st = quantumState({ ord, east, north });
            out.pair = { uid: pairUid, nickname: nickname || "", code: st.s.code, lat: st.pos.lat, lng: st.pos.lng };
        }
    }
    if (chiming) {
        out.chime = {
            at: quantum.nearestHour(now), strikes: quantum.chimeStrikes(now), count: Number(chimeCount) || 0,
            fx: (Array.isArray(chimeFx) ? chimeFx : []).map((e) => String(e).split("|")).filter((x) => x[0] !== uid).map((x) => [parseFloat(x[1]), parseFloat(x[2])]),
        };
    }
    // 量子跨年：台北午夜的時間（測試時可以改），以及一起跨年的人數
    if (quantum.inNewYear(now)) out.newYear = { at: nyAt, ...(together ? { count: Number(nyCount) || 0 } : {}) };
    return out;
}

function hashToObject(list) {
    const out = {};
    for (let i = 0; Array.isArray(list) && i + 1 < list.length; i += 2) out[list[i]] = list[i + 1];
    return out;
}

/** 席位資料 → 這次入場的狀態（席位、累計位移、顯示位置） */
function quantumState(h) {
    const s = quantum.seat(parseInt(h.ord, 10));
    const east = parseFloat(h.east) || 0, north = parseFloat(h.north) || 0;
    return { s, east, north, pos: quantum.toLatLng(s.east + east, s.north + north) };
}

/** 塌縮動畫：旁邊的人在接下來幾秒的掃描裡會看到光點散掉 */
function collapseCommands(uid, pos, now) {
    return [
        ["ZADD", quantum.KEY.collapses, String(now), `${uid}|${pos.lat.toFixed(6)}|${pos.lng.toFixed(6)}|${now}`],
        ["ZREMRANGEBYSCORE", quantum.KEY.collapses, "-inf", String(now - quantum.COLLAPSE_MS)],
    ];
}

function quantumMe(st) {
    return { code: st.s.code, ring: st.s.ring, lat: st.pos.lat, lng: st.pos.lng, east: st.east, north: st.north };
}

// 在線人數：每個伺服器執行個體快取 15 秒
let quantumOnline = { at: 0, value: { total: 0, regions: {} } };
async function quantumOnlineCounts(now) {
    if (now - quantumOnline.at < 15000) return quantumOnline.value;
    const since = String(now - quantum.VISIBLE_MS);
    const counts = await sendUpstashPipeline([
        ["ZCOUNT", quantum.KEY.beats, since, "+inf"],
        ...quantum.REGIONS.map((r) => ["ZCOUNT", quantum.KEY.region(r), since, "+inf"]),
    ]);
    const value = { total: counts[0] || 0, regions: quantum.regionCounts(counts.slice(1)) };
    quantumOnline = { at: now, value };
    return value;
}

/** 心跳後的掃描：附近的人（帶心情）、世界視角的光點、剛離開的人 */
async function quantumScan(uid, me, radiusKM, lang, now) {
    const center = [String(me.lng), String(me.lat)];
    const near = Math.min(radiusKM, quantum.RADAR_KM);
    const [visibleUids, nearby, dotsRaw, collapsesRaw, isReviewer] = await sendUpstashPipeline([
        ["ZRANGEBYSCORE", quantum.KEY.beats, String(now - quantum.VISIBLE_MS), "+inf"],
        ["GEOSEARCH", quantum.KEY.geo, "FROMLONLAT", ...center, "BYRADIUS", String(near), "km", "ASC", "COUNT", String(quantum.MAX_RESULTS), "WITHCOORD"],
        // 世界視角：超過一般雷達半徑時，遠處的人只回傳光點（不帶心情）
        radiusKM > quantum.RADAR_KM
            ? ["GEOSEARCH", quantum.KEY.geo, "FROMLONLAT", ...center, "BYRADIUS", String(radiusKM), "km", "COUNT", String(quantum.WORLD_MAX_DOTS), "WITHCOORD"]
            : ["ECHO", ""],
        ["ZRANGEBYSCORE", quantum.KEY.collapses, String(now - quantum.COLLAPSE_MS), "+inf"],
        ["SISMEMBER", demo.REVIEWERS_KEY, uid],
    ]);
    const nyWave = quantum.inNewYear(now);
    // 斷線保留席位的 3 分鐘內不顯示任何東西（這不是殘影）
    const visible = new Set(Array.isArray(visibleUids) ? visibleUids : []);
    const coordOf = (m) => ({ lat: parseFloat(m[1][1]), lng: parseFloat(m[1][0]) });

    const members = (Array.isArray(nearby) ? nearby : []).filter((m) => Array.isArray(m) && m[0] !== uid && visible.has(m[0]));
    const profiles = await sendUpstashPipeline(members.map(([u]) => ["HMGET", quantum.KEY.seat(u), "ord", "mood", "nickname", "hidden", "quiet", "beat", "tz", "showTime", "topics", "orb", "grow", "bq"]));
    const users = [];
    members.forEach((m, i) => {
        const [ord, mood, nickname, hidden, quiet, beat, tzRaw, showTime, topics, orb, growRaw, bq] = profiles[i] || [];
        const grow = orbs.isGrowing(orb) ? orbs.parseGrowthField(growRaw) : null;
        if (ord == null || hidden === "1" || !nickname) return;
        const tz = tzRaw == null ? NaN : parseInt(tzRaw, 10);
        users.push({ uid: m[0], ...coordOf(m), mood: mood || "", nickname, status: 'active', shadowAge: 0, timestamp: parseInt(beat || "0", 10),
            quantum: quantum.seat(parseInt(ord, 10)).code, orb: orbs.isStyle(orb) ? orb : orbs.DEFAULT_STYLE, ...(quiet === "1" ? { quiet: true } : {}),
            // 晝夜色調一律有；當地時間只在對方同意時才給
            ...(quantum.validTz(tz) ? { day: quantum.dayPart(tz, now), ...(showTime === "1" ? { tz } : {}) } : {}),
            ...(topics ? { topics: parseTopics(topics) } : {}),
            // 會長大的光球：星軌的星星數、年輪的圈數
            ...(grow ? { grow: [grow.stars, grow.rings] } : {}),
            // 光之花束：收到花束 24 小時內，光球旁邊有一圈花瓣光點
            ...(bq === "1" ? { bouquet: true } : {}),
            // 量子跨年：這個人的時區已經跨年
            ...(nyWave && quantum.validTz(tz) && quantum.crossedNewYear(tz, now) ? { ny: true } : {}) });
    });

    // 審核示範對象：只有輸入過通關碼的帳號看得到，放在自己周圍
    if (isReviewer === 1) {
        const bots = demo.reviewBots({ lat: me.lat, lng: me.lng }).filter((b) => demo.distanceKm(me, b) <= near);
        const botProfiles = await sendUpstashPipeline(bots.map((b) => ["HMGET", `user_data:${b.uid}`, "mood", "nickname", "hidden"]));
        bots.forEach((b, i) => {
            const [mood, nickname, hidden] = botProfiles[i] || [];
            const local = quantum.toLocal(b.lat, b.lng);
            const code = quantum.nearestCode(local.east, local.north);
            if (hidden === "1" || !nickname || !code) return;
            users.push({ uid: b.uid, lat: b.lat, lng: b.lng, mood: localize(lang, mood || ""), nickname: localize(lang, nickname), status: 'active', shadowAge: 0, timestamp: now, demo: true, quantum: code });
        });
    }

    const dotMembers = (Array.isArray(dotsRaw) ? dotsRaw : []).filter((m) => Array.isArray(m) && m[0] !== uid && visible.has(m[0]));
    // 量子跨年：已經跨年的光點多帶一個 1，世界視角看得到一波波亮起來
    const dotTz = nyWave && dotMembers.length > 0 ? await sendUpstashCommand(["HMGET", quantum.KEY.tz, ...dotMembers.map((m) => m[0])]) : [];
    const dots = dotMembers.map((m, i) => {
        const c = coordOf(m);
        const tz = Array.isArray(dotTz) && dotTz[i] != null ? parseInt(dotTz[i], 10) : NaN;
        return quantum.validTz(tz) && quantum.crossedNewYear(tz, now) ? [c.lat, c.lng, 1] : [c.lat, c.lng];
    });
    const collapses = (Array.isArray(collapsesRaw) ? collapsesRaw : []).map((entry) => {
        const [who, lat, lng] = String(entry).split('|');
        return { uid: who, lat: parseFloat(lat), lng: parseFloat(lng) };
    }).filter((c) => c.uid !== uid && Number.isFinite(c.lat) && demo.distanceKm(me, c) <= radiusKM);
    return { data: users, dots, collapses };
}

exports.quantum = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const lang = langOf(req);
    const action = req.body.action;
    const now = Date.now();
    try {
      if (action === "enter") {
        const { lat, lng } = req.body;
        if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(lang, "座標格式錯誤") });
        // 中國大陸一律不開放；真實位置只用在這裡和大區判斷，不寫進量子世界的資料
        if (quantum.isMainlandChina(lat, lng)) return res.status(403).json({ success: false, code: "closed" });
        await sweepQuantumSeats(now);

        const reviewCode = demo.isReviewCode(req.body.mood);
        const mood = reviewCode ? demo.REVIEW_MOOD : maskBlockedTerms(truncateVisible(req.body.mood, MAX_MOOD_LENGTH));
        const nickname = maskBlockedTerms(truncateVisible(req.body.nickname, MAX_NICKNAME_LENGTH));
        const [existing, hidden, growRaw, bouquet] = await sendUpstashPipeline([["HGETALL", quantum.KEY.seat(uid)], ["HGET", `user_data:${uid}`, "hidden"], ["HMGET", orbs.growthKey(uid), "sec", "stars"], ["EXISTS", gifts.bouquetKey(uid)]]);
        const prev = hashToObject(existing);
        const growth = orbs.growthView(...(growRaw || []));
        let resumed = false;
        if (prev.ord != null && now - parseInt(prev.beat || "0", 10) < quantum.GRACE_MS) {
            resumed = true; // 斷線 3 分鐘內回來：回到原本的席位
        } else {
            if (prev.ord != null) await sendUpstashPipeline(await quantumReleaseCommands([{ uid, ord: prev.ord, region: prev.region }]));
            // 先補別人離開留下的空位，沒有空位才往外排
            const popped = await sendUpstashCommand(["ZPOPMIN", quantum.KEY.free, "1"]);
            const ordinal = Array.isArray(popped) && popped.length > 0 ? parseInt(popped[0], 10) : (await sendUpstashCommand(["INCR", quantum.KEY.next])) - 1;
            Object.keys(prev).forEach((k) => delete prev[k]);
            Object.assign(prev, { ord: String(ordinal), enteredAt: String(now), east: "0", north: "0", rawEast: "0", rawNorth: "0", region: quantum.regionOf(lat, lng), quiet: "0" });
        }
        const region = prev.region || 'other';
        const st = quantumState(prev);
        await sendUpstashPipeline([
            ["HSET", quantum.KEY.seat(uid), "ord", prev.ord, "enteredAt", prev.enteredAt || String(now), "east", String(st.east), "north", String(st.north),
                // 入場後手機從 0 開始算位移；回到原位時手機會接著原本的累計位移
                "rawEast", resumed ? String(st.east) : "0", "rawNorth", resumed ? String(st.north) : "0", "rawAt", String(now),
                // 入場的地方：走回這裡時位移歸位（斷線回來就從回來的地方算）
                "homeEast", resumed ? String(st.east) : "0", "homeNorth", resumed ? String(st.north) : "0",
                "homeAccEast", resumed ? String(st.east) : "0", "homeAccNorth", resumed ? String(st.north) : "0",
                ...quantumProfileFields(req.body),
                ...(await quantumOrbFields(uid, req.body.orb, resumed ? prev.orb : undefined)),
                "region", region, "quiet", prev.quiet || "0", "beat", String(now), "mood", mood, "nickname", nickname, "hidden", hidden === "1" ? "1" : "0", "grow", orbs.growthField(growth), "bq", bouquet === 1 ? "1" : "0"],
            ["ZADD", quantum.KEY.beats, String(now), uid],
            ...quantumTzCommands(uid, req.body),
            ["ZADD", quantum.KEY.region(region), String(now), uid],
            ["GEOADD", quantum.KEY.geo, String(st.pos.lng), String(st.pos.lat), uid],
            // 進入量子世界時，暫時離開一般雷達和平行宇宙
            ["ZREM", "city_users", uid],
            ["ZREM", parallel.GEO_KEY, uid],
            ["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "lang", lang, "timestamp", String(now), "state", "active", "stateAt", String(now)],
            ...(reviewCode ? [["SADD", demo.REVIEWERS_KEY, uid]] : []),
        ]);
        return res.status(200).json({ success: true, resumed, me: { ...quantumMe(st), tunneled: prev.tunneled === "1" }, quiet: prev.quiet === "1", growth, bouquet: bouquet === 1 });
      }

      if (action === "beat") {
        const [existing, hidden, growRaw, bouquet] = await sendUpstashPipeline([["HGETALL", quantum.KEY.seat(uid)], ["HGET", `user_data:${uid}`, "hidden"], ["HMGET", orbs.growthKey(uid), "sec", "stars"], ["EXISTS", gifts.bouquetKey(uid)]]);
        const h = hashToObject(existing);
        if (h.ord == null) return res.status(410).json({ success: false, code: "expired" }); // 席位已釋放，要重新入場
        // 年輪：累積在量子世界待的秒數（跟著帳號，不管現在用哪一款）
        const addSec = orbs.beatSeconds(h.beat, now);
        const [growSec, growStars] = growRaw || [];
        const growth = orbs.growthView((Number(growSec) || 0) + addSec, growStars);
        const { east, north } = req.body;
        let acc = { east: parseFloat(h.east) || 0, north: parseFloat(h.north) || 0 };
        const raw = quantum.validDisplacement(east, north) ? { east, north } : null;
        if (raw) {
            acc = quantum.accumulate({ ...acc, rawEast: parseFloat(h.rawEast) || 0, rawNorth: parseFloat(h.rawNorth) || 0, rawAt: parseInt(h.rawAt || h.beat || "0", 10),
                homeEast: h.homeEast == null ? undefined : parseFloat(h.homeEast), homeNorth: h.homeNorth == null ? undefined : parseFloat(h.homeNorth),
                homeAccEast: h.homeAccEast == null ? undefined : parseFloat(h.homeAccEast), homeAccNorth: h.homeAccNorth == null ? undefined : parseFloat(h.homeAccNorth) }, raw, now);
        }
        const st = quantumState({ ...h, east: acc.east, north: acc.north });
        const fields = ["east", String(acc.east), "north", String(acc.north), "beat", String(now), "hidden", hidden === "1" ? "1" : "0", "grow", orbs.growthField(growth), "bq", bouquet === 1 ? "1" : "0"];
        if (raw) fields.push("rawEast", String(raw.east), "rawNorth", String(raw.north), "rawAt", String(now));
        if (typeof req.body.quiet === "boolean") fields.push("quiet", req.body.quiet ? "1" : "0");
        fields.push(...quantumProfileFields(req.body), ...(await quantumOrbFields(uid, req.body.orb, h.orb)));
        const profile = [];
        if (typeof req.body.mood === "string" || typeof req.body.nickname === "string") {
            const mood = maskBlockedTerms(truncateVisible(req.body.mood, MAX_MOOD_LENGTH));
            const nickname = maskBlockedTerms(truncateVisible(req.body.nickname, MAX_NICKNAME_LENGTH));
            fields.push("mood", mood, "nickname", nickname);
            profile.push(["HSET", `user_data:${uid}`, "mood", mood, "nickname", nickname, "lang", lang, "timestamp", String(now), "state", "active", "stateAt", String(now)]);
        }
        await sendUpstashPipeline([
            ["HSET", quantum.KEY.seat(uid), ...fields],
            ...(addSec > 0 ? [["HINCRBY", orbs.growthKey(uid), "sec", String(addSec)]] : []),
            ["ZADD", quantum.KEY.beats, String(now), uid],
            ...quantumTzCommands(uid, req.body),
            ...(quantum.newYearTogether(now) ? [["ZADD", quantum.KEY.newYear(quantum.newYearAt(now)), "NX", String(now), uid], ["EXPIRE", quantum.KEY.newYear(quantum.newYearAt(now)), "172800"]] : []),
            ["ZADD", quantum.KEY.region(h.region || 'other'), String(now), uid],
            ["GEOADD", quantum.KEY.geo, String(st.pos.lng), String(st.pos.lat), uid],
            ...profile,
        ]);
        const radiusKM = quantum.clampRadius(req.body.radiusKM);
        const [scan, online, extras] = await Promise.all([quantumScan(uid, st.pos, radiusKM, lang, now), quantumOnlineCounts(now), quantumExtras(uid, now)]);
        if (Math.random() < 0.1) sweepQuantumSeats(now).catch((e) => console.error('quantum sweep failed:', e));
        return res.status(200).json({ success: true, me: { ...quantumMe(st), tunneled: h.tunneled === "1" }, ...scan, ...extras, online, growth, bouquet: bouquet === 1 });
      }

      if (action === "leave") {
        const h = hashToObject(await sendUpstashCommand(["HGETALL", quantum.KEY.seat(uid)]));
        if (h.ord == null) return res.status(200).json({ success: true });
        const st = quantumState(h);
        await sendUpstashPipeline([
            ...(await quantumReleaseCommands([{ uid, ord: h.ord, region: h.region }])),
            // 塌縮離場：旁邊的人在接下來幾秒的掃描裡會看到光點散掉
            ...collapseCommands(uid, st.pos, now),
        ]);
        return res.status(200).json({ success: true });
      }

      if (action === "tunnel") {
        // 量子穿隧：每次入場一次，跳到蜂巢裡隨機一個空席位，換一群鄰居；原本的席位釋放
        const h = hashToObject(await sendUpstashCommand(["HGETALL", quantum.KEY.seat(uid)]));
        if (h.ord == null) return res.status(410).json({ success: false, code: "expired" });
        if (h.tunneled === "1") return res.status(409).json({ success: false, code: "used" });
        const from = quantumState(h);
        let ordinal = null;
        for (let tries = 0; tries < 5 && ordinal == null; tries++) {
            const pick = await sendUpstashCommand(["ZRANDMEMBER", quantum.KEY.free]);
            if (pick == null) break;
            if ((await sendUpstashCommand(["ZREM", quantum.KEY.free, String(pick)])) === 1) ordinal = parseInt(pick, 10);
        }
        if (ordinal == null) ordinal = (await sendUpstashCommand(["INCR", quantum.KEY.next])) - 1; // 沒有空位就到最外圈
        const st = quantumState({ ord: String(ordinal), east: "0", north: "0" });
        const rawE = h.rawEast ?? "0", rawN = h.rawNorth ?? "0";
        await sendUpstashPipeline([
            ["ZADD", quantum.KEY.free, h.ord, h.ord],
            // 新席位從 0 開始算位移；走回穿隧的地方時歸位到新席位
            ["HSET", quantum.KEY.seat(uid), "ord", String(ordinal), "east", "0", "north", "0", "tunneled", "1",
                "homeEast", rawE, "homeNorth", rawN, "homeAccEast", "0", "homeAccNorth", "0", "beat", String(now)],
            ["ZADD", quantum.KEY.beats, String(now), uid],
            ["GEOADD", quantum.KEY.geo, String(st.pos.lng), String(st.pos.lat), uid],
            ...collapseCommands(uid, from.pos, now),
        ]);
        return res.status(200).json({ success: true, me: { ...quantumMe(st), tunneled: true }, from: { lat: from.pos.lat, lng: from.pos.lng } });
      }

      if (action === "chime") {
        // 整點報時：送出一道報時微光，光點從自己的席位飛向原點
        if (!quantum.chimeOpen(now)) return res.status(409).json({ success: false, code: "closed" });
        const h = hashToObject(await sendUpstashCommand(["HGETALL", quantum.KEY.seat(uid)]));
        if (h.ord == null) return res.status(410).json({ success: false, code: "expired" });
        const st = quantumState(h);
        const hour = quantum.chimeHour(now);
        const [added, , count] = await sendUpstashPipeline([
            ["ZADD", quantum.KEY.chime(hour), "NX", String(now), uid],
            ["ZADD", quantum.KEY.chimeFx(hour), String(now), `${uid}|${st.pos.lat.toFixed(6)}|${st.pos.lng.toFixed(6)}`],
            ["ZCARD", quantum.KEY.chime(hour)],
            ["EXPIRE", quantum.KEY.chime(hour), "3600"],
            ["EXPIRE", quantum.KEY.chimeFx(hour), "3600"],
        ]);
        return res.status(200).json({ success: true, first: added === 1, count: Number(count) || 0 });
      }

      if (action === "entangle") {
        const { op } = req.body;
        const other = typeof req.body.uid === "string" && req.body.uid.length <= 128 ? req.body.uid : null;
        if (!other || other === uid || !["invite", "accept", "decline", "cut"].includes(op)) return res.status(400).json({ success: false });
        if (op === "decline") {
            await sendUpstashCommand(["HDEL", quantum.KEY.invites(uid), other]);
            return res.status(200).json({ success: true });
        }
        if (op === "cut") {
            const [, removed, nickname] = await sendUpstashPipeline([
                ["SREM", quantum.KEY.ent(uid), other], ["SREM", quantum.KEY.ent(other), uid], ["HGET", quantum.KEY.seat(uid), "nickname"]]);
            if (removed === 1) await sendUpstashPipeline([["RPUSH", quantum.KEY.entGone(other), nickname || ""], ["EXPIRE", quantum.KEY.entGone(other), "600"]]);
            return res.status(200).json({ success: true });
        }
        const [mine, theirs, myCount, theirCount, invitedAt, already] = await sendUpstashPipeline([
            ["HGET", quantum.KEY.seat(uid), "ord"], ["HGET", quantum.KEY.seat(other), "ord"],
            ["SCARD", quantum.KEY.ent(uid)], ["SCARD", quantum.KEY.ent(other)],
            ["HGET", quantum.KEY.invites(uid), other], ["SISMEMBER", quantum.KEY.ent(uid), other]]);
        if (mine == null) return res.status(410).json({ success: false, code: "expired" });
        if (theirs == null) return res.status(404).json({ success: false, code: "gone" }); // 對方已經離開量子世界
        if (already === 1) return res.status(200).json({ success: true, entangled: true });
        if (myCount >= quantum.MAX_ENTANGLED) return res.status(409).json({ success: false, code: "full" });
        if (theirCount >= quantum.MAX_ENTANGLED) return res.status(409).json({ success: false, code: "theirFull" });
        if (await eitherBlocked(uid, other)) return res.status(404).json({ success: false, code: "gone" });
        if (op === "invite") {
            await sendUpstashPipeline([["HSET", quantum.KEY.invites(other), uid, String(now)], ["EXPIRE", quantum.KEY.invites(other), "600"]]);
            return res.status(200).json({ success: true });
        }
        // accept：邀請 2 分鐘內有效
        if (invitedAt == null || now - parseInt(invitedAt, 10) > quantum.INVITE_MS) return res.status(410).json({ success: false, code: "inviteExpired" });
        await sendUpstashPipeline([
            ["SADD", quantum.KEY.ent(uid), other], ["SADD", quantum.KEY.ent(other), uid],
            ["HDEL", quantum.KEY.invites(uid), other], ["HDEL", quantum.KEY.invites(other), uid]]);
        return res.status(200).json({ success: true, entangled: true });
      }

      res.status(400).json({ success: false, error: "unknown action" });
    } catch (error) {
      console.error(`quantum ${action} failed:`, error);
      res.status(500).json({ success: false, error: localize(lang, "掃描失敗") });
    }
  });
});

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function replyAsDemoBot(roomId, botUid) {
    const room = admin.database().ref(`/chats/${roomId}`);
    try {
        await room.child(`typing/${botUid}`).set(true);
        await sleep(1800);
        const [status, messagesSnap] = await Promise.all([room.child('status').once('value'), room.child('messages').once('value')]);
        if (status.val() !== 'active') return; // 使用者已經離開
        let botMessages = 0;
        messagesSnap.forEach((m) => { if (m.child('sender').val() === botUid) botMessages++; });
        // 示範對象用對方的語言說話
        const lang = await getLangFromRedis(roomId.split('_').find((id) => id !== botUid));
        const botName = localize(lang, (await getNicknameFromRedis(botUid)) || '示範對象');
        await room.child('messages').push({ sender: botUid, senderName: botName, text: localize(lang, demo.chatReply(botMessages)), timestamp: Date.now() });
    } catch (e) {
        console.error(`demo bot reply failed (${roomId}):`, e);
    } finally {
        await room.child(`typing/${botUid}`).remove().catch(() => {});
    }
}

// ============================================================================
// 推播：全專案唯一的推播出口（其他 codebase 的重複推播已移除）
// ============================================================================
async function sendPush(targetUid, title, body, data) {
    const tokenSnap = await admin.database().ref(`/tokens/${targetUid}`).once('value');
    const token = tokenSnap.val();
    if (!token) return;
    // 推播用收件人的語言（App 每次更新位置時回報）
    const lang = await getLangFromRedis(targetUid);
    title = localize(lang, title); body = localize(lang, body);
    try {
        await admin.messaging().send({
            token,
            notification: { title, body },
            data,
            android: { priority: 'high', notification: { sound: 'default' } },
            apns: { headers: { 'apns-priority': '10' }, payload: { aps: { sound: 'default', badge: 1 } } },
        });
    } catch (error) {
        console.error(`推播失敗 (${data.type} → ${targetUid}):`, error);
    }
}

// ============================================================================
// API 3: 敲門推播通知
// ============================================================================
exports.notifyOnKnock = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/requests/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const data = change.after.val(); const beforeData = change.before.val();
    if (!data || data.status !== 'pending') return null;
    if (beforeData && beforeData.status === 'pending') return null;

    const targetUid = context.params.targetUid; const senderUid = context.params.senderUid;

    // 示範對象：稍等一下（讓敲門儀式的虛線弧跑一會兒）就自動同意
    if (demo.isDemoUid(targetUid)) {
        await sleep(2500);
        const ref = admin.database().ref(`/requests/${targetUid}/${senderUid}`);
        const current = (await ref.once('value')).val();
        if (current && current.status === 'pending') {
            const botName = localize(await getLangFromRedis(senderUid), (await getNicknameFromRedis(targetUid)) || '示範對象');
            await ref.set({ status: 'accepted', nickname: botName });
        }
        return null;
    }

    let senderName = data.nickname;
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const redisName = await getNicknameFromRedis(senderUid);
        if (redisName && redisName.trim() !== '') senderName = redisName;
    }
    if (!senderName || senderName.trim() === '') senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;

    await sendPush(targetUid, '片刻交集', `${senderName} 正在敲門，想與你產生交集...`, { type: 'knock_request', senderUid });
    return null;
  });

// ============================================================================
// API 4: 聊天推播通知
// ============================================================================
exports.notifyOnChat = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/chats/{roomId}/messages/{msgId}')
  .onCreate(async (snapshot, context) => {
    const msg = snapshot.val(); if (!msg) return null;
    // 第二道過濾：舊版 App 或繞過 App 寫入的訊息，在這裡遮掉不當字詞與聯絡方式
    if (isDisallowed(msg.text)) {
        msg.text = maskBlockedTerms(String(msg.text || ''));
        await snapshot.ref.child('text').set(msg.text);
    }
    const senderUid = msg.sender;
    const roomId = context.params.roomId;
    const targetUid = roomId.split('_').find(id => id !== senderUid);
    if (!targetUid) return null;

    // 示範對象：輸入中一下，再依序回覆說明；示範對象沒有推播權杖，不需要推播
    if (demo.isDemoUid(targetUid)) {
        await replyAsDemoBot(roomId, targetUid);
        return null;
    }
    if (demo.isDemoUid(senderUid)) return null; // 使用者正在聊天室裡，訊息已在畫面上

    // 第一防線：抓取訊息夾帶的名字
    let senderName = msg.senderName;
    
    // 第二防線：若無名字，強制去 Redis 找
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        const redisName = await getNicknameFromRedis(senderUid);
        if (redisName && redisName.trim() !== '') senderName = redisName;
    }
    
    // 第三防線：真的沒有才給代號
    if (!senderName || senderName.trim() === '' || senderName.startsWith('#')) {
        senderName = `#${senderUid.substring(senderUid.length - 4).toUpperCase()}`;
    }

    await sendPush(targetUid, `來自 ${senderName} 的低語`, String(msg.text || ''), { type: 'chat_message', roomId: context.params.roomId, senderUid });
    return null;
  });

// ============================================================================
// API 5: 在線狀態同步 —— 把 RTDB 的 presence/{uid} 同步到 Redis 供雷達判定
// ============================================================================
exports.syncPresence = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/presence/{uid}')
  .onWrite(async (change, context) => {
    const data = change.after.val();
    if (!data || !data.state || !data.at) return null;
    const uid = context.params.uid;
    try {
        // 只接受比 Redis 現有狀態更新的事件，避免延遲送達的舊事件覆蓋新狀態
        const [currentAt] = await sendUpstashCommand(["HMGET", `user_data:${uid}`, "stateAt"]);
        if (currentAt && parseInt(currentAt, 10) > data.at) return null;
        await sendUpstashCommand(["HSET", `user_data:${uid}`, "state", data.state, "stateAt", String(data.at)]);
    } catch (e) {
        console.error(`syncPresence failed (${uid}):`, e);
    }
    return null;
  });

// ============================================================================
// API 6: 檢舉 —— 24 小時內被 3 個不同的人檢舉，自動從雷達隱藏並等待人工審查
// ============================================================================
exports.onReportCreated = functionsV1.runWith({ secrets: UPSTASH_SECRETS, timeoutSeconds: 300 }).database.ref('/reports/{reportId}')
  .onCreate(async (snapshot) => {
    const report = snapshot.val();
    if (!report || !report.target) return null;
    const target = report.target;
    // 集會的檢舉：一律進人工審查；達到門檻只隱藏那一則公告，活動不自動結束
    if (report.context === 'gathering') {
        try { await handleGatheringReport(target, report); } catch (e) { console.error(`[檢舉] 集會處理失敗 (${target}):`, e); }
        return null;
    }
    // 低語的檢舉：target = "whisper:<id>"，3 個不同的人檢舉就隱藏這則低語
    if (report.context === 'whisper' && String(target).startsWith('whisper:')) {
        try {
            const all = (await admin.database().ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {};
            const { hide, reporters } = evaluateReports(Object.values(all), Date.now());
            console.log(`[檢舉] 低語 ${target} 被檢舉（${report.reason}），24 小時內共 ${reporters} 人`);
            if (hide) {
                await sendUpstashCommand(["HSET", `whisper:${target.slice(8)}`, "hidden", "1"]);
                console.warn(`[檢舉] 低語 ${target} 已自動隱藏，請到 Firebase 主控台審查`);
            }
        } catch (e) { console.error(`[檢舉] 低語處理失敗 (${target}):`, e); }
        return null;
    }
    // 店內留言本的檢舉：target = "place_note:<id>"，跟低語一樣 3 個不同的人檢舉就隱藏
    if (report.context === 'placeNote' && String(target).startsWith('place_note:')) {
        try {
            const all = (await admin.database().ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {};
            const { hide, reporters } = evaluateReports(Object.values(all), Date.now());
            console.log(`[檢舉] 留言 ${target} 被檢舉（${report.reason}），24 小時內共 ${reporters} 人`);
            if (hide) {
                await sendUpstashCommand(["HSET", target, "hidden", "1"]);
                console.warn(`[檢舉] 留言 ${target} 已自動隱藏，請到 Firebase 主控台審查`);
            }
        } catch (e) { console.error(`[檢舉] 留言處理失敗 (${target}):`, e); }
        return null;
    }
    try {
        const all = (await admin.database().ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {};
        const { hide, reporters } = evaluateReports(Object.values(all), Date.now());
        console.log(`[檢舉] ${target} 被 ${report.reporter} 檢舉（${report.reason}），24 小時內共 ${reporters} 人`);
        if (!hide) return null;
        const modRef = admin.database().ref(`/moderation/${target}`);
        const current = (await modRef.once('value')).val();
        if (current && current.hidden === true) return null;
        await modRef.set({ hidden: true, at: Date.now(), reason: `auto: ${reporters} reporters in 24h`, reviewed: false });
        console.warn(`[檢舉] ${target} 已自動隱藏，請在 24 小時內到 Firebase 主控台審查 reports 與 moderation/${target}`);
    } catch (e) {
        console.error(`[檢舉] 處理失敗 (${target}):`, e);
    }
    return null;
  });

// 審核狀態同步到 Redis：getNearby 依此過濾。人工解除隱藏 = 把 moderation/{uid}/hidden 改成 false 或刪除
exports.syncModeration = functionsV1.runWith({ secrets: UPSTASH_SECRETS }).database.ref('/moderation/{uid}')
  .onWrite(async (change, context) => {
    const data = change.after.val();
    const hidden = !!(data && data.hidden === true);
    try {
        await sendUpstashCommand(["HSET", `user_data:${context.params.uid}`, "hidden", hidden ? "1" : "0"]);
    } catch (e) {
        console.error(`syncModeration failed (${context.params.uid}):`, e);
    }
    return null;
  });

// ============================================================================
// API 7: 刪除帳號（Apple 5.1.1(v)：App 內可建立帳號，就必須能在 App 內刪除）
// 刪除：雷達位置、心情與暱稱、大頭貼、推播權杖、在線狀態、封鎖名單、敲門請求、聊天室、同意紀錄、登入身分。
// 保留：檢舉紀錄與審核狀態（隱私權政策載明保存 1 年，用於防止濫用）。
// ============================================================================
// 量子化身：驗證 Apple / Google 的內購，把款式記到帳號上（規則見 orbs.js）
const PLAY_PACKAGE = "com.softchip.moodwhisper";

/** Google Play Developer API：查一筆一次性商品的購買。Cloud Functions 的服務帳號要先在 Play Console 加入使用者並給「查看財務資料」權限 */
async function playPurchase(productId, token) {
    const { GoogleAuth } = require("google-auth-library");
    const client = await new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/androidpublisher"] }).getClient();
    const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${PLAY_PACKAGE}/purchases/products/${encodeURIComponent(productId)}/tokens/${encodeURIComponent(token)}`;
    return (await client.request({ url })).data;
}

/** Google Play 訂閱的查詢結果（subscriptionsv2） */
async function playSubscription(token) {
    const { GoogleAuth } = require("google-auth-library");
    const client = await new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/androidpublisher"] }).getClient();
    const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${PLAY_PACKAGE}/purchases/subscriptionsv2/tokens/${encodeURIComponent(token)}`;
    return (await client.request({ url })).data;
}

/** 把款式記到帳號上；同一筆購買已經屬於別的帳號就拒絕 */
async function grantOrb(uid, src, { style, receipt }) {
    const db = admin.database();
    const result = await db.ref(`orbReceipts/${receipt}`).transaction((cur) => (cur == null || cur === uid ? uid : undefined));
    if (!result.committed) return false;
    await db.ref(`orbOwned/${uid}/${style}`).set({ at: admin.database.ServerValue.TIMESTAMP, src, receipt });
    return true;
}

exports.orbs = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    try {
      if (req.body.action === "verify") {
        // 一次可以送好幾筆（恢復購買時）；每筆各自驗證，回傳這次確認的款式
        const items = (Array.isArray(req.body.purchases) ? req.body.purchases : []).slice(0, 20);
        const granted = [], failed = [];
        for (const p of items) {
          try {
            let grant;
            if (p.platform === "apple") grant = orbs.appleGrant(orbs.verifyAppleJws(p.data));
            else if (p.platform === "google" && typeof p.token === "string" && typeof p.productId === "string") grant = orbs.googleGrant(p.productId, p.token, await playPurchase(p.productId, p.token));
            else throw new Error("bad_request");
            if (await grantOrb(uid, p.platform, grant)) granted.push(grant.style); else failed.push({ productId: p.productId, code: "owned_elsewhere" });
          } catch (e) {
            console.warn("orb verify failed:", e.message);
            failed.push({ productId: p.productId, code: e.message });
          }
        }
        const owned = Object.keys((await admin.database().ref(`orbOwned/${uid}`).once("value")).val() || {});
        return res.status(200).json({ success: true, granted, failed, owned });
      }
      return res.status(400).json({ success: false, error: "unknown action" });
    } catch (error) {
      console.error("orbs failed:", error);
      return res.status(500).json({ success: false });
    }
  });
});

// ============================================================================
// API：平行座標 —— 你現在的位置對到每座平行城市的哪一點（只算給自己看，不儲存）
// ============================================================================
exports.parallelCoords = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const lat = Number(req.body.lat), lng = Number(req.body.lng);
    if (!Number.isFinite(lat) || !Number.isFinite(lng) || Math.abs(lat) > 90 || Math.abs(lng) > 180) return res.status(400).json({ success: false });
    const out = parallel.mirrors(lat, lng, uid, Date.now(), langOf(req));
    return res.status(200).json(out ? { success: true, ...out } : { success: true, home: null, list: [] });
  });
});

// ============================================================================
// API：送禮與糾纏款 —— action: status / send / accept / decline / prefs / unpair（規格 docs/gifting-spec.md，規則在 gifts.js）
// ============================================================================
const giftableStyle = (s) => orbs.isStyle(s) && !orbs.isFree(s) && !orbs.STYLES[s].granted && orbs.onSale(s);

async function giftNickname(uid) {
    return (await sendUpstashCommand(["HGET", `user_data:${uid}`, "nickname"])) || "";
}

/** 把一份禮物退回給送的人（變成禮券），通知對方 */
async function returnGift(id, g, { notify = true } = {}) {
    const db = admin.database();
    await db.ref().update({
        [`gifts/${id}/status`]: "returned",
        [`giftInbox/${g.to}/${id}`]: null,
        [`giftPending/${id}`]: null,
        [`giftVouchers/${g.from}/${id}`]: { kind: g.kind, ...(g.style ? { style: g.style } : {}), at: admin.database.ServerValue.TIMESTAMP },
    });
    if (notify) await sendPush(g.from, "禮物退回了", "這份禮物已經退回給你，可以再送給別人。", { type: "gift_returned", giftId: id });
}

/** 收禮的人現在的狀態：用來判斷這份禮物能不能送 */
async function giftContext(from, to, kind, style) {
    const db = admin.database();
    const [blocked, prefs, owned, toPair, fromPair] = await Promise.all([
        eitherBlocked(from, to),
        db.ref(`giftPrefs/${to}`).once("value"),
        kind === "orb" ? db.ref(`orbOwned/${to}`).once("value") : null,
        kind === "pair" ? db.ref(`orbPair/${to}`).once("value") : null,
        kind === "pair" ? db.ref(`orbPair/${from}`).once("value") : null,
    ]);
    return {
        from, to, kind, style, blocked, giftableStyle,
        recipientOff: !!(prefs.val() && prefs.val().off),
        recipientOwned: owned ? owned.val() : null,
        recipientPaired: !!(toPair && toPair.val()),
        senderPaired: !!(fromPair && fromPair.val()),
    };
}

/** 建立一份禮物並送出；收不了就直接變成送的人的禮券 */
async function deliverGift(from, to, kind, style, receipt) {
    const db = admin.database();
    const id = db.ref("gifts").push().key;
    const fromName = await giftNickname(from);
    const g = { from, to: to || "", kind, ...(kind === "orb" && style ? { style } : {}), status: "pending", at: Date.now(), receipt, fromName };
    await db.ref(`gifts/${id}`).set(g);
    const check = to ? gifts.canSend(await giftContext(from, to, kind, style)) : { ok: false, code: "self" };
    if (!check.ok) {
        await returnGift(id, g, { notify: false });
        return { id, delivered: false, code: check.code };
    }
    await db.ref().update({ [`giftInbox/${to}/${id}`]: g.at, [`giftPending/${id}`]: g.at });
    const body = kind === "bouquet" ? `${fromName} 送你一束光之花束` : kind === "orb" ? `${fromName} 送你一款光球` : `${fromName} 想和你配成糾纏款`;
    await sendPush(to, "收到一份禮物", body, { type: "gift", giftId: id });
    return { id, delivered: true };
}

exports.gifts = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const db = admin.database();
    const action = req.body.action, now = Date.now();
    try {
      if (action === "status") {
        // 收到的禮物（過了 7 天的先退回）、自己的禮券、接收開關、配對對象、花束
        const [inboxSnap, vouchersSnap, prefsSnap, pairSnap, bouquetSnap] = await Promise.all([
          db.ref(`giftInbox/${uid}`).once("value"), db.ref(`giftVouchers/${uid}`).once("value"), db.ref(`giftPrefs/${uid}`).once("value"),
          db.ref(`orbPair/${uid}`).once("value"), db.ref(`giftBouquet/${uid}`).once("value"),
        ]);
        const inbox = [];
        for (const id of Object.keys(inboxSnap.val() || {})) {
          const g = (await db.ref(`gifts/${id}`).once("value")).val();
          if (!g || g.status !== "pending") { await db.ref(`giftInbox/${uid}/${id}`).remove(); continue; }
          if (gifts.expired(g, now)) { await returnGift(id, g); continue; }
          inbox.push(gifts.giftView(id, g));
        }
        const vouchers = Object.entries(vouchersSnap.val() || {}).map(([id, v]) => ({ id, kind: v.kind, ...(v.style ? { style: v.style } : {}) }));
        const partner = pairSnap.val();
        return res.status(200).json({
          success: true, inbox, vouchers, off: !!(prefsSnap.val() && prefsSnap.val().off),
          pair: partner ? { uid: partner, nickname: await giftNickname(partner) } : null,
          bouquetUntil: gifts.bouquetActive(bouquetSnap.val(), now) ? Number(bouquetSnap.val()) : 0,
        });
      }

      if (action === "check") {
        // 付款前先檢查：對方收不收得到這份禮物（已經有這款光球、關掉接收、已經配對⋯⋯就先不讓付款）
        const to = typeof req.body.to === "string" && req.body.to ? req.body.to : null;
        const kind = String(req.body.kind || "");
        const style = typeof req.body.style === "string" ? req.body.style : undefined;
        const check = gifts.canSend(await giftContext(uid, to, kind, style));
        return res.status(200).json({ success: true, ok: check.ok, ...(check.ok ? {} : { code: check.code }) });
      }

      if (action === "send") {
        // 用剛買的禮物（purchase）或一張退回的禮券（voucherId）送給 to
        const to = typeof req.body.to === "string" && req.body.to ? req.body.to : null;
        const style = typeof req.body.style === "string" ? req.body.style : undefined;
        if (typeof req.body.voucherId === "string") {
          const v = (await db.ref(`giftVouchers/${uid}/${req.body.voucherId}`).once("value")).val();
          if (!v) return res.status(200).json({ success: false, code: "no_voucher" });
          const old = (await db.ref(`gifts/${req.body.voucherId}`).once("value")).val();
          const kind = v.kind, useStyle = kind === "orb" ? (style || v.style) : undefined;
          const check = gifts.canSend(await giftContext(uid, to, kind, useStyle));
          if (!check.ok) return res.status(200).json({ success: false, code: check.code });
          await db.ref(`giftVouchers/${uid}/${req.body.voucherId}`).remove();
          const r = await deliverGift(uid, to, kind, useStyle, old ? old.receipt : `voucher_${req.body.voucherId}`);
          if (old && old.receipt) await db.ref(`giftReceipts/${old.receipt}`).set(r.id);
          return res.status(200).json({ success: true, ...r });
        }
        const p = req.body.purchase || {};
        let grant;
        if (p.platform === "apple") grant = gifts.appleGift(orbs.verifyAppleJws(p.data), orbs.BUNDLE_ID);
        else if (p.platform === "google" && typeof p.token === "string" && typeof p.productId === "string") grant = gifts.googleGift(p.productId, orbs.receiptKey("google", p.token), await playPurchase(p.productId, p.token));
        else return res.status(400).json({ success: false, code: "bad_request" });
        // 同一筆購買只算一份禮物（App 重送、恢復購買時不會變兩份）
        const claim = await db.ref(`giftReceipts/${grant.receipt}`).transaction((cur) => (cur == null ? "claiming" : cur));
        if (claim.snapshot.val() !== "claiming") return res.status(200).json({ success: true, already: true });
        const r = await deliverGift(uid, to, grant.kind, style, grant.receipt);
        await db.ref(`giftReceipts/${grant.receipt}`).set(r.id);
        return res.status(200).json({ success: true, ...r });
      }

      if (action === "accept" || action === "decline") {
        const id = String(req.body.id || "");
        const g = (await db.ref(`gifts/${id}`).once("value")).val();
        if (!g || g.to !== uid || g.status !== "pending") return res.status(200).json({ success: false, code: "gone" });
        if (action === "decline" || gifts.expired(g, now)) {
          await returnGift(id, g);
          return res.status(200).json({ success: true, returned: true });
        }
        const updates = { [`gifts/${id}/status`]: "accepted", [`giftInbox/${uid}/${id}`]: null, [`giftPending/${id}`]: null };
        if (g.kind === "bouquet") {
          const cur = Number((await db.ref(`giftBouquet/${uid}`).once("value")).val()) || 0;
          const until = Math.max(cur, now) + gifts.BOUQUET_MS;
          updates[`giftBouquet/${uid}`] = until;
          await sendUpstashCommand(["SET", gifts.bouquetKey(uid), "1", "PX", String(until - now)]);
        } else if (g.kind === "orb") {
          const owned = (await db.ref(`orbOwned/${uid}/${g.style}`).once("value")).val();
          if (owned) { await returnGift(id, g); return res.status(200).json({ success: false, code: "owned" }); }
          updates[`orbOwned/${uid}/${g.style}`] = { at: now, src: "gift", receipt: `gift_${id}` };
        } else if (g.kind === "pair") {
          const [a, b] = await Promise.all([db.ref(`orbPair/${uid}`).once("value"), db.ref(`orbPair/${g.from}`).once("value")]);
          if (a.val() || b.val()) { await returnGift(id, g); return res.status(200).json({ success: false, code: "paired" }); }
          updates[`orbOwned/${uid}/pair`] = { at: now, src: "gift", receipt: `gift_${id}` };
          updates[`orbOwned/${g.from}/pair`] = { at: now, src: "gift", receipt: `gift_${id}` };
          updates[`orbPair/${uid}`] = g.from;
          updates[`orbPair/${g.from}`] = uid;
          await sendUpstashPipeline([["SET", gifts.pairKey(uid), g.from], ["SET", gifts.pairKey(g.from), uid]]);
        }
        await db.ref().update(updates);
        await sendPush(g.from, "禮物送到了", `${await giftNickname(uid)} 收下了你的禮物`, { type: "gift_accepted", giftId: id });
        return res.status(200).json({ success: true, kind: g.kind, ...(g.style ? { style: g.style } : {}) });
      }

      if (action === "prefs") {
        await db.ref(`giftPrefs/${uid}`).set(req.body.off === true ? { off: true } : null);
        return res.status(200).json({ success: true });
      }

      if (action === "unpair") {
        // 解除糾纏款配對：兩人都保留糾纏款光球，只是不再有光繩相連
        const partner = (await db.ref(`orbPair/${uid}`).once("value")).val();
        if (partner) {
          await db.ref().update({ [`orbPair/${uid}`]: null, [`orbPair/${partner}`]: null });
          await sendUpstashPipeline([["DEL", gifts.pairKey(uid)], ["DEL", gifts.pairKey(partner)]]);
        }
        return res.status(200).json({ success: true });
      }

      return res.status(400).json({ success: false, error: "unknown action" });
    } catch (error) {
      console.error("gifts failed:", error);
      return res.status(500).json({ success: false, code: "busy" });
    }
  });
});

/** 每天把超過 7 天沒回應的禮物退回給送的人 */
exports.expireGifts = onSchedule({ schedule: "every day 05:00", timeZone: "Asia/Taipei", region: "asia-southeast1", secrets: UPSTASH_SECRETS }, async () => {
  const db = admin.database();
  const snap = await db.ref("giftPending").orderByValue().endAt(Date.now() - gifts.PENDING_MS).limitToFirst(500).once("value");
  let n = 0;
  for (const id of Object.keys(snap.val() || {})) {
    const g = (await db.ref(`gifts/${id}`).once("value")).val();
    if (g && g.status === "pending") { await returnGift(id, g); n++; } else await db.ref(`giftPending/${id}`).remove();
  }
  console.log("expireGifts: returned", n);
});

// ============================================================================
// API：艾婭 A.I.Y.A（量子世界中心光柱裡的 AI）—— action: status / consent / open / say / close / report / verify
//   規格 docs/aiya-spec.md；純函式在 aiya.js
//   送給 Claude 的只有：使用者打的字、App 語言、匿名的聚合統計。不送 uid、暱稱、座位、位置。
//   API 金鑰：firebase functions:secrets:set ANTHROPIC_API_KEY
// ============================================================================
const ANTHROPIC_KEY = defineSecret("ANTHROPIC_API_KEY");
let anthropicClient = null;
function claude() {
    if (!anthropicClient) {
        const { default: Anthropic } = require("@anthropic-ai/sdk");
        anthropicClient = new Anthropic({ apiKey: cleanSecret(ANTHROPIC_KEY), maxRetries: 1, timeout: 25000 });
    }
    return anthropicClient;
}

/** 這個人今天的額度狀態 */
/**
 * 艾婭之友的訂閱紀錄。Google 的訂閱過期時重新查一次（每小時最多一次），有續訂就延長；
 * Apple 的續訂由 App Store 伺服器通知（appStoreNotify）和 App 每次啟動時送來的交易更新。
 */
async function aiyaFriendRecord(uid, now) {
    const db = admin.database();
    const rec = (await db.ref(`aiyaFriend/${uid}`).once("value")).val();
    if (!rec || aiya.friendActive(rec, now) || rec.src !== "google" || now - (Number(rec.checkedAt) || 0) < 3600 * 1000) return rec;
    try {
        const token = (await db.ref(`aiyaFriendTokens/${rec.receipt}`).once("value")).val();
        if (!token) return rec;
        let exp = Number(rec.exp) || 0;
        try { exp = aiya.googleFriend(rec.product || aiya.FRIEND_PRODUCT, rec.receipt, await playSubscription(token)).exp; } catch (e) { /* 已過期或取消：維持原本的到期時間 */ }
        await db.ref(`aiyaFriend/${uid}`).update({ exp, checkedAt: now });
        return { ...rec, exp, checkedAt: now };
    } catch (e) {
        console.warn("aiya friend recheck:", e.message);
        return rec;
    }
}

/** 把訂閱記到帳號上；同一個訂閱已經屬於別的帳號就拒絕。restore 會送來舊的交易，所以到期時間只往後延（退款除外） */
async function grantAiyaFriend(uid, src, { exp, receipt, productId, revoked }, token) {
    const db = admin.database();
    const claim = await db.ref(`aiyaFriendReceipts/${receipt}`).transaction((cur) => (cur == null || cur === uid ? uid : undefined));
    if (!claim.committed) return "owned_elsewhere";
    const prev = (await db.ref(`aiyaFriend/${uid}`).once("value")).val();
    const keep = prev && prev.receipt === receipt && !revoked ? Math.max(Number(prev.exp) || 0, exp) : exp;
    await db.ref(`aiyaFriend/${uid}`).set({ exp: keep, src, receipt, product: productId, at: admin.database.ServerValue.TIMESTAMP });
    if (token) await db.ref(`aiyaFriendTokens/${receipt}`).set(token);
    return "granted";
}

async function aiyaStatus(uid, now) {
    const day = aiya.dayKey(now);
    const [usedRaw, budgetRaw, reviewer, sessionRaw] = await sendUpstashPipeline([
        ["GET", aiya.KEY.quota(uid, day)], ["GET", aiya.KEY.budget(day)], ["SISMEMBER", demo.REVIEWERS_KEY, uid], ["GET", aiya.KEY.session(uid)],
    ]);
    const db = admin.database();
    const [creditsSnap, consentSnap, friendRec] = await Promise.all([db.ref(`aiyaCredits/${uid}`).once("value"), db.ref(`aiyaConsent/${uid}`).once("value"), aiyaFriendRecord(uid, now)]);
    const consent = consentSnap.val();
    let session = null;
    try { session = sessionRaw ? JSON.parse(sessionRaw) : null; } catch (e) { session = null; }
    return {
        day, usedToday: parseInt(usedRaw || "0", 10), budgetMicro: parseInt(budgetRaw || "0", 10), reviewer: reviewer === 1,
        credits: Math.max(0, Number(creditsSnap.val()) || 0), consented: !!consent && consent.v >= aiya.CONSENT_VERSION,
        session: aiya.sessionAlive(session, now) ? session : null,
        friend: aiya.friendActive(friendRec, now), friendExp: friendRec ? Number(friendRec.exp) || 0 : 0,
    };
}

function aiyaStatusView(st, now) {
    return {
        freeLeft: st.reviewer ? aiya.FREE_PER_DAY : Math.max(0, (st.friend ? aiya.FRIEND_PER_DAY : aiya.FREE_PER_DAY) - st.usedToday),
        credits: st.credits, consented: st.consented,
        resting: !st.reviewer && !st.friend && st.budgetMicro >= aiya.DAILY_FREE_BUDGET_MICRO,
        friend: st.friend, friendExp: st.friendExp,
        session: st.session ? aiya.sessionView(st.session, now) : null,
    };
}

async function saveAiyaSession(uid, session) {
    await sendUpstashCommand(["SET", aiya.KEY.session(uid), JSON.stringify(session), "EX", String(aiya.SESSION_TTL_S)]);
}

/** 艾婭的情境：量子世界在線人數、台北今晚的心情（有快取才用）、離整點報時幾分鐘 */
async function aiyaContext(lang, now) {
    let online, cityMood;
    try { online = (await quantumOnlineCounts(now)).total; } catch (e) { /* 拿不到就不提 */ }
    try {
        const cached = await sendUpstashCommand(["GET", citymood.cacheKey(25.033964, 121.564468)]);
        if (cached) cityMood = JSON.parse(cached);
    } catch (e) { /* 同上 */ }
    const minute = new Date(now).getUTCMinutes();
    return aiya.contextText({ lang, now, online, cityMood, minutesToChime: minute === 0 ? 0 : 60 - minute });
}

/** 時光包加到帳號上；同一筆收據只加一次 */
async function grantAiyaPack(uid, { credits, receipt }) {
    const db = admin.database();
    const claim = await db.ref(`aiyaReceipts/${receipt}`).transaction((cur) => (cur == null ? uid : undefined));
    if (!claim.committed) return (await db.ref(`aiyaReceipts/${receipt}`).once("value")).val() === uid ? "already" : "owned_elsewhere";
    await db.ref(`aiyaCredits/${uid}`).transaction((cur) => (Number(cur) || 0) + credits);
    await db.ref(`aiyaPackCredits/${receipt}`).set(credits); // 退款時知道要扣幾次（Google 的退款清單沒有商品編號）
    return "granted";
}

/**
 * 退款：收據標成 refunded（之後不能再兌換），時光包扣回次數（最少到 0），光球／艾婭造型從帳號拿掉。
 * 同一筆收據處理第二次不會重複扣。credits 有給（Apple 通知裡算得出來）就用它，否則看兌換時記下的次數。
 */
async function applyRefund(receipt, credits) {
    const db = admin.database();
    const done = [];
    const packOwner = (await db.ref(`aiyaReceipts/${receipt}`).once("value")).val();
    if (typeof packOwner === "string" && packOwner !== refunds.REFUNDED) {
        const n = Number(credits) || Number((await db.ref(`aiyaPackCredits/${receipt}`).once("value")).val()) || 0;
        const mark = await db.ref(`aiyaReceipts/${receipt}`).transaction((cur) => (cur === packOwner ? refunds.REFUNDED : undefined));
        if (mark.committed && n > 0) await db.ref(`aiyaCredits/${packOwner}`).transaction((cur) => refunds.deduct(cur, n));
        if (mark.committed) done.push(`pack-${n}`);
    }
    // 禮物：還沒收下的取消、變成禮券的刪掉、已經收下的光球從對方帳號拿掉（花束、配對不追回）
    const giftId = (await db.ref(`giftReceipts/${receipt}`).once("value")).val();
    if (typeof giftId === "string" && giftId !== refunds.REFUNDED && giftId !== "claiming") {
        const g = (await db.ref(`gifts/${giftId}`).once("value")).val();
        const updates = { [`giftReceipts/${receipt}`]: refunds.REFUNDED, [`gifts/${giftId}/status`]: "refunded" };
        if (g) {
            updates[`giftInbox/${g.to}/${giftId}`] = null;
            updates[`giftPending/${giftId}`] = null;
            updates[`giftVouchers/${g.from}/${giftId}`] = null;
            if (g.status === "accepted" && g.kind === "orb" && g.style) updates[`orbOwned/${g.to}/${g.style}`] = null;
        }
        await db.ref().update(updates);
        done.push(`gift-${g ? g.kind : "?"}`);
    }
    const orbOwner = (await db.ref(`orbReceipts/${receipt}`).once("value")).val();
    if (typeof orbOwner === "string" && orbOwner !== refunds.REFUNDED) {
        const owned = (await db.ref(`orbOwned/${orbOwner}`).once("value")).val() || {};
        const updates = { [`orbReceipts/${receipt}`]: refunds.REFUNDED };
        for (const style of refunds.stylesWithReceipt(owned, receipt)) { updates[`orbOwned/${orbOwner}/${style}`] = null; done.push(style); }
        await db.ref().update(updates);
    }
    return done;
}

exports.aiya = onRequest({ region: "asia-southeast1", secrets: [...UPSTASH_SECRETS, ANTHROPIC_KEY], timeoutSeconds: 60 }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const lang = langOf(req);
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(lang, "未授權") });
    const action = req.body.action, now = Date.now();
    try {
      if (action === "status") {
        return res.status(200).json({ success: true, ...aiyaStatusView(await aiyaStatus(uid, now), now) });
      }

      if (action === "consent") {
        await admin.database().ref(`aiyaConsent/${uid}`).set({ v: aiya.CONSENT_VERSION, at: admin.database.ServerValue.TIMESTAMP });
        return res.status(200).json({ success: true });
      }

      if (action === "open") {
        const st = await aiyaStatus(uid, now);
        if (!st.consented) return res.status(200).json({ success: false, code: "consent" });
        // 10 分鐘內回來算同一次，不重複扣
        if (st.session) return res.status(200).json({ success: true, resumed: true, ...aiyaStatusView(st, now) });
        const decision = aiya.decideOpen(st);
        if (!decision.ok) return res.status(200).json({ success: false, code: decision.code, ...aiyaStatusView(st, now) });
        if (decision.pay === "credit") {
          // Admin SDK 的 transaction 第一次會用本機快取（通常是 null）呼叫；這時回傳 undefined 會直接放棄、不去伺服器拿真正的值，
          // 所以有次數也扣不到。改成看不到值就原樣回傳，讓它拿到伺服器的值重跑，最後一次執行的結果才算數
          let charged = false;
          const paid = await admin.database().ref(`aiyaCredits/${uid}`).transaction((cur) => {
            const n = Number(cur) || 0;
            charged = n > 0;
            return charged ? n - 1 : cur;
          });
          if (!paid.committed || !charged) return res.status(200).json({ success: false, code: "no_quota", ...aiyaStatusView(st, now) });
          st.credits = Math.max(0, st.credits - 1);
        }
        await sendUpstashPipeline([["INCR", aiya.KEY.quota(uid, st.day)], ["EXPIRE", aiya.KEY.quota(uid, st.day), "172800"]]);
        st.usedToday += 1;
        st.session = { id: `${now.toString(36)}${Math.random().toString(36).slice(2, 6)}`, startedAt: now, turns: 0, pay: decision.pay, lang, msgs: [] };
        await saveAiyaSession(uid, st.session);
        return res.status(200).json({ success: true, resumed: false, ...aiyaStatusView(st, now) });
      }

      if (action === "say") {
        const raw = await sendUpstashCommand(["GET", aiya.KEY.session(uid)]);
        let session = null;
        try { session = raw ? JSON.parse(raw) : null; } catch (e) { session = null; }
        if (!session || session.id !== req.body.sessionId || !aiya.sessionAlive(session, now)) return res.status(200).json({ success: false, code: "ended" });
        const text = aiya.cleanInput(req.body.text);
        if (!text) return res.status(200).json({ success: false, code: "empty" });
        if (isDisallowed(text)) return res.status(200).json({ success: false, code: "filtered" });

        session.msgs.push({ role: "user", content: text });
        session.turns += 1;
        // stream: true（1.0.5 起）→ 一行一個 JSON：{t:"delta",text} 是到目前為止（已遮蔽）的回覆，最後 {t:"done",…} 跟一般回應一樣
        const wantStream = req.body.stream === true;
        const send = (o) => res.write(JSON.stringify(o) + "\n");
        const finish = (body) => {
          if (!wantStream) return res.status(200).json(body);
          send({ t: "done", ...body });
          return res.end();
        };
        if (wantStream) {
          res.status(200);
          res.setHeader("Content-Type", "application/x-ndjson; charset=utf-8");
          res.setHeader("Cache-Control", "no-cache");
          res.flushHeaders();
        }
        let parsed = null, code = null;
        try {
          const params = {
            model: aiya.MODEL,
            max_tokens: 1024,
            output_config: { effort: "low", format: { type: "json_schema", schema: aiya.REPLY_SCHEMA } },
            system: [
              { type: "text", text: aiya.PERSONA, cache_control: { type: "ephemeral" } },
              { type: "text", text: await aiyaContext(session.lang || lang, now) },
            ],
            messages: session.msgs,
          };
          let response;
          if (wantStream) {
            let shownLen = 0;
            const stream = claude().messages.stream(params);
            stream.on("text", (_delta, snapshot) => {
              const partial = aiya.partialReply(snapshot);
              if (partial == null) return;
              const shown = aiya.streamSafe(maskBlockedTerms(partial));
              if (shown.length > shownLen) { shownLen = shown.length; send({ t: "delta", text: shown }); }
            });
            response = await stream.finalMessage();
          } else {
            response = await claude().messages.create(params);
          }
          const spent = aiya.costMicro(response.usage);
          const day = aiya.dayKey(now);
          const budgetKey = session.pay === "free" ? aiya.KEY.budget(day) : `aiya_paid:${day}`;
          sendUpstashPipeline([["INCRBY", budgetKey, String(spent)], ["EXPIRE", budgetKey, "172800"]]).catch((e) => console.warn("aiya budget:", e.message));
          if (response.stop_reason === "refusal") code = "refused";
          else {
            const textBlock = response.content.find((b) => b.type === "text");
            parsed = aiya.parseReply(textBlock && textBlock.text);
            if (!parsed) code = "busy";
          }
        } catch (e) {
          console.error("aiya claude failed:", e && e.status, e && e.message);
          code = "busy";
        }
        if (!parsed) {
          // 沒拿到回覆：把這則從紀錄拿掉、不算次數，讓使用者可以再試
          session.msgs.pop();
          session.turns -= 1;
          await saveAiyaSession(uid, session);
          return finish({ success: false, code, session: aiya.sessionView(session, now) });
        }
        let reply = maskBlockedTerms(parsed.reply);
        if (aiya.mentionsCrisis(text)) reply = `${reply} ${aiya.hotline(session.lang || lang)}`;
        session.msgs.push({ role: "assistant", content: JSON.stringify({ reply: parsed.reply, expression: parsed.expression }) });
        await saveAiyaSession(uid, session);
        return finish({ success: true, reply, expression: parsed.expression, session: aiya.sessionView(session, now) });
      }

      if (action === "close") {
        await sendUpstashCommand(["DEL", aiya.KEY.session(uid)]);
        return res.status(200).json({ success: true });
      }

      if (action === "report") {
        // 檢舉艾婭的某一句回覆：連同使用者前一句一起存，供人工檢視（Apple 1.2、Google Play AI 內容政策）
        const reply = String(req.body.reply || "").slice(0, 400);
        let lastUser = "";
        try {
          const s = JSON.parse((await sendUpstashCommand(["GET", aiya.KEY.session(uid)])) || "null");
          const users = s ? s.msgs.filter((m) => m.role === "user") : [];
          lastUser = users.length ? users[users.length - 1].content : "";
        } catch (e) { /* 對話已結束也照樣收檢舉 */ }
        await admin.database().ref("aiyaReports").push({ uid, reply, lastUser, reason: String(req.body.reason || "").slice(0, 40), lang, at: admin.database.ServerValue.TIMESTAMP });
        return res.status(200).json({ success: true });
      }

      if (action === "verify") {
        const items = (Array.isArray(req.body.purchases) ? req.body.purchases : []).slice(0, 20);
        const results = [];
        for (const p of items) {
          try {
            // 艾婭之友（訂閱）和時光包（消耗型）分開處理
            if (p.platform === "apple") {
              const tx = orbs.verifyAppleJws(p.data);
              if (tx.productId === aiya.FRIEND_PRODUCT) {
                const g = aiya.appleFriend(tx, orbs.BUNDLE_ID);
                results.push({ productId: g.productId, result: await grantAiyaFriend(uid, "apple", { ...g, revoked: !!tx.revocationDate }) });
                continue;
              }
              const grant = aiya.applePack(tx, orbs.BUNDLE_ID);
              results.push({ productId: grant.productId, result: await grantAiyaPack(uid, grant) });
              continue;
            }
            if (p.platform !== "google" || typeof p.token !== "string" || typeof p.productId !== "string") throw new Error("bad_request");
            if (p.productId === aiya.FRIEND_PRODUCT) {
              const g = aiya.googleFriend(p.productId, orbs.receiptKey("google", p.token), await playSubscription(p.token));
              results.push({ productId: g.productId, result: await grantAiyaFriend(uid, "google", g, p.token) });
              continue;
            }
            const grant = aiya.googlePack(p.productId, orbs.receiptKey("google", p.token), await playPurchase(p.productId, p.token));
            results.push({ productId: grant.productId, result: await grantAiyaPack(uid, grant) });
          } catch (e) {
            console.warn("aiya verify failed:", e.message);
            results.push({ productId: p.productId, result: e.message });
          }
        }
        const credits = Math.max(0, Number((await admin.database().ref(`aiyaCredits/${uid}`).once("value")).val()) || 0);
        const friendRec = (await admin.database().ref(`aiyaFriend/${uid}`).once("value")).val();
        return res.status(200).json({ success: true, results, credits, friend: aiya.friendActive(friendRec, now), friendExp: friendRec ? Number(friendRec.exp) || 0 : 0 });
      }

      return res.status(400).json({ success: false, error: localize(lang, "未知的操作") });
    } catch (error) {
      console.error("aiya failed:", error);
      if (res.headersSent) {
        // 串流已經開始：用最後一行告訴 App 失敗
        try { res.write(JSON.stringify({ t: "done", success: false, code: "busy" }) + "\n"); res.end(); } catch (e) { /* 連線已斷 */ }
        return;
      }
      return res.status(500).json({ success: false, code: "busy" });
    }
  });
});

// ============================================================================
// App Store 伺服器通知 V2（App Store Connect → App 資訊 → App Store 伺服器通知，正式和沙盒都填這個網址）
//   艾婭之友續訂、到期、退款時 Apple 會送簽章過的通知；用同一個 Apple Root CA 驗證，不需要 API 金鑰。
//   一律回 200（否則 Apple 會一直重送）；看不懂或驗證失敗的只記 log。
// ============================================================================
exports.appStoreNotify = onRequest({ region: "asia-southeast1" }, async (req, res) => {
  if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
  try {
    const payload = orbs.verifyAppleJws(req.body && req.body.signedPayload);
    const info = payload.data && payload.data.signedTransactionInfo;
    if (!info) return res.status(200).send("ok");
    const tx = orbs.verifyAppleJws(info);
    const refund = refunds.appleRefundTarget(payload.notificationType, tx, orbs.BUNDLE_ID);
    if (refund) {
      console.log("appStoreNotify refund:", payload.notificationType, tx.productId, (await applyRefund(refund.receipt, refund.credits)).join(",") || "nothing to undo");
      return res.status(200).send("ok");
    }
    if (tx.productId !== aiya.FRIEND_PRODUCT) {
      console.log("appStoreNotify:", payload.notificationType, tx.productId);
      return res.status(200).send("ok");
    }
    const g = aiya.appleFriend(tx, orbs.BUNDLE_ID);
    const db = admin.database();
    const uid = (await db.ref(`aiyaFriendReceipts/${g.receipt}`).once("value")).val();
    if (uid) {
      const prev = (await db.ref(`aiyaFriend/${uid}`).once("value")).val();
      const exp = tx.revocationDate ? g.exp : Math.max(prev && prev.receipt === g.receipt ? Number(prev.exp) || 0 : 0, g.exp);
      await db.ref(`aiyaFriend/${uid}`).update({ exp, src: "apple", receipt: g.receipt, product: g.productId });
    }
    console.log("appStoreNotify:", payload.notificationType, payload.subtype || "", uid ? "matched" : "no account");
  } catch (e) {
    console.warn("appStoreNotify failed:", e.message);
  }
  return res.status(200).send("ok");
});

// ============================================================================
// API：低語團（私人團體）—— 規格 docs/whisper-group-spec.md；純函式在 whispergroup.js
//   團主：create / call / call_done / rollcall / note / kick / rotate_qr / handoff / dissolve / verify
//   團員：join / seen / ack / answer / leave
//   所有人：status
//   團員的位置不會給團主；集合點是團主自己放的座標。
// ============================================================================
const WG_COLOR_DOT = { violet: "🟣", pink: "🩷", blue: "🔵", teal: "🩵", green: "🟢", gold: "🟡", orange: "🟠", red: "🔴" };

async function wgLoad(code) {
  if (!wgroup.isCode(code)) return null;
  const raw = await sendUpstashCommand(["GET", wgroup.KEY.group(code)]);
  try { return raw ? JSON.parse(raw) : null; } catch (e) { return null; }
}

async function wgSaveGroup(code, g) {
  const ttl = String(Math.max(60, Math.ceil((g.endsAt + 86400000 - Date.now()) / 1000)));
  await sendUpstashCommand(["SET", wgroup.KEY.group(code), JSON.stringify(g), "EX", ttl]);
}

async function wgMembers(code) {
  const flat = (await sendUpstashCommand(["HGETALL", wgroup.KEY.members(code)])) || [];
  const out = [];
  for (let i = 0; i < flat.length; i += 2) {
    try { out.push({ uid: flat[i], ...JSON.parse(flat[i + 1]) }); } catch (e) { /* 壞掉的列略過 */ }
  }
  return out.sort((a, b) => a.no - b.no);
}

const wgHash = (flat) => { const o = {}; for (let i = 0; i < (flat || []).length; i += 2) o[flat[i]] = flat[i + 1]; return o; };

async function wgJson(key) {
  const raw = await sendUpstashCommand(["GET", key]);
  try { return raw ? JSON.parse(raw) : null; } catch (e) { return null; }
}

/** 推給團員：集合呼叫用時效性通知（iOS 穿透專注模式）與專屬音效／震動頻道 */
async function wgPush(uids, title, body, data, { urgent = false } = {}) {
  if (!uids.length) return 0;
  const [snaps, langs] = await Promise.all([
    Promise.all(uids.map((u) => admin.database().ref(`tokens/${u}`).once("value"))),
    sendUpstashPipeline(uids.map((u) => ["HGET", `user_data:${u}`, "lang"])).catch(() => []),
  ]);
  const messages = [];
  snaps.forEach((snap, i) => {
    const token = snap.val();
    if (!token) return;
    const lang = langs[i];
    messages.push({
      token,
      notification: { title: localize(lang, title), body: localize(lang, body) },
      data,
      android: urgent
        ? { priority: "high", notification: { channelId: "group_call", sound: "group_call", defaultVibrateTimings: false, vibrateTimingsMillis: [0, 150, 100, 150, 100, 600] } }
        : { priority: "high", notification: { sound: "default" } },
      apns: {
        headers: { "apns-priority": "10", "apns-push-type": "alert" },
        payload: { aps: urgent ? { sound: "group_call.caf", "interruption-level": "time-sensitive" } : { sound: "default" } },
      },
    });
  });
  let sent = 0;
  for (let i = 0; i < messages.length; i += 500) {
    try { sent += (await admin.messaging().sendEach(messages.slice(i, i + 500))).successCount; } catch (e) { console.error("whisper group push failed:", e); }
  }
  return sent;
}

/** 集合呼叫的推播文字（繁中原文，送出時翻成收件人的語言） */
function wgCallText(call, now) {
  const mins = Math.max(0, Math.round((call.at - now) / 60000));
  if (call.place) return mins > 0 ? `${mins} 分鐘後到「${call.place}」集合` : `現在到「${call.place}」集合`;
  return mins > 0 ? `${mins} 分鐘後集合，打開 App 看集合點` : "現在集合，打開 App 看集合點";
}

/** 整團刪掉（解散、過期） */
async function wgDestroy(code, members) {
  await sendUpstashPipeline([
    ["DEL", wgroup.KEY.group(code), wgroup.KEY.members(code), wgroup.KEY.call(code), wgroup.KEY.acks(code), wgroup.KEY.roll(code), wgroup.KEY.answers(code), wgroup.KEY.lost(code)],
    ["SREM", wgroup.KEY.activeCalls, code],
    ...members.map((m) => ["DEL", wgroup.KEY.of(m.uid)]),
  ]);
}

/** 給 App 的狀態：團主看得到名單與每個人的回覆；團員只看到自己的 */
async function wgStatusView(uid, now) {
  const code = await sendUpstashCommand(["GET", wgroup.KEY.of(uid)]);
  if (!code) return { group: null };
  const g = await wgLoad(code);
  if (!g || !wgroup.isOpen(g, now)) {
    if (g) await wgDestroy(code, await wgMembers(code));
    else await sendUpstashCommand(["DEL", wgroup.KEY.of(uid)]);
    return { group: null };
  }
  const [members, call, roll, acksFlat, answersFlat, lostFlat] = await Promise.all([
    wgMembers(code), wgJson(wgroup.KEY.call(code)), wgJson(wgroup.KEY.roll(code)),
    sendUpstashCommand(["HGETALL", wgroup.KEY.acks(code)]), sendUpstashCommand(["HGETALL", wgroup.KEY.answers(code)]),
    sendUpstashCommand(["HGETALL", wgroup.KEY.lost(code)]),
  ]);
  const lostHash = wgHash(lostFlat);
  const acks = wgHash(acksFlat), answers = wgHash(answersFlat);
  const me = members.find((m) => m.uid === uid);
  const isHost = g.host === uid;
  const nicks = await sendUpstashPipeline(members.map((m) => ["HGET", `user_data:${m.uid}`, "nickname"])).catch(() => []);
  const hostIdx = members.findIndex((m) => m.uid === g.host);
  const view = {
    code, name: g.name, color: g.color, endsAt: g.endsAt, paid: !!g.paid, limit: wgroup.memberLimit(g), count: members.length,
    role: isHost ? "host" : "member", myNo: me ? me.no : null, hostName: hostIdx >= 0 ? (nicks[hostIdx] || "") : "",
    call: wgroup.callLive(call, now) ? { id: call.id, at: call.at, place: call.place, lat: call.lat, lng: call.lng, mine: acks[uid] || null } : null,
    roll: roll ? { id: roll.id, sentAt: roll.sentAt, mine: answers[uid] || null } : null,
    lostSent: wgroup.lostRoster(members.filter((m) => m.uid === uid), lostHash, now).length > 0,
  };
  if (isHost) {
    view.qr = `https://mood-whisper-f7de9.web.app/g/${code}?v=${g.qrVer}`;
    const others = members.filter((m) => m.uid !== g.host).map((m) => ({ uid: m.uid, no: m.no, note: m.note || "", name: nicks[members.indexOf(m)] || "" }));
    view.members = others;
    if (view.call) view.callRoster = wgroup.callRoster(others, acks);
    if (view.roll) view.rollRoster = wgroup.rollRoster(others, answers);
    view.lost = wgroup.lostRoster(others, lostHash, now);
  }
  return { group: view };
}

exports.whisperGroup = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const lang = langOf(req);
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(lang, "未授權") });
    const action = req.body.action, now = Date.now();
    const fail = (code, status = 200) => res.status(status).json({ success: false, code });
    const ok = async (extra = {}) => res.status(200).json({ success: true, ...(await wgStatusView(uid, now)), ...extra });
    try {
      if (action === "status") return ok();

      if (action === "create") {
        if (await sendUpstashCommand(["GET", wgroup.KEY.of(uid)])) return fail("in_group");
        const made = wgroup.makeGroup({ host: uid, name: req.body.name, color: req.body.color, days: req.body.days }, now);
        if (!made.ok) return fail(made.code);
        if (isDisallowed(made.group.name)) return fail("filtered");
        let code = wgroup.newCode();
        for (let i = 0; i < 3 && (await sendUpstashCommand(["EXISTS", wgroup.KEY.group(code)])) === 1; i++) code = wgroup.newCode();
        await wgSaveGroup(code, made.group);
        const ttl = String(Math.ceil((made.group.endsAt + 86400000 - now) / 1000));
        await sendUpstashPipeline([
          ["HSET", wgroup.KEY.members(code), uid, JSON.stringify({ no: 0, note: "", joinedAt: now })],
          ["EXPIRE", wgroup.KEY.members(code), ttl],
          ["SET", wgroup.KEY.of(uid), code, "EX", ttl],
        ]);
        return ok();
      }

      if (action === "join") {
        const code = String(req.body.code || "").toUpperCase();
        const g = await wgLoad(code);
        if (!g) return fail("not_found");
        const current = await sendUpstashCommand(["GET", wgroup.KEY.of(uid)]);
        if (current && current !== code) return fail("in_group");
        const members = await wgMembers(code);
        const check = wgroup.canJoin(g, { count: members.length, qrVer: req.body.v, alreadyMember: members.some((m) => m.uid === uid) }, now);
        if (!check.ok) return check.code === "already" ? ok() : fail(check.code);
        const no = wgroup.nextNumber(members);
        const ttl = String(Math.ceil((g.endsAt + 86400000 - now) / 1000));
        await sendUpstashPipeline([
          ["HSETNX", wgroup.KEY.members(code), uid, JSON.stringify({ no, note: "", joinedAt: now })],
          ["SET", wgroup.KEY.of(uid), code, "EX", ttl],
        ]);
        return ok();
      }

      // 以下都要已經在團裡
      const code = await sendUpstashCommand(["GET", wgroup.KEY.of(uid)]);
      const g = code ? await wgLoad(code) : null;
      if (!g || !wgroup.isOpen(g, now)) return fail("no_group");
      const isHost = g.host === uid;
      const hostOnly = ["call", "call_done", "rollcall", "note", "kick", "rotate_qr", "handoff", "dissolve", "verify"];
      if (hostOnly.includes(action) && !isHost) return fail("not_host", 403);

      if (action === "call") {
        const made = wgroup.makeCall({ at: req.body.at, place: req.body.place, lat: req.body.lat, lng: req.body.lng }, now);
        if (!made.ok) return fail(made.code);
        if (made.call.place && isDisallowed(made.call.place)) return fail("filtered");
        await sendUpstashPipeline([
          ["SET", wgroup.KEY.call(code), JSON.stringify(made.call), "EX", String(Math.ceil((made.call.at + wgroup.CALL_LINGER_MS - now) / 1000))],
          ["DEL", wgroup.KEY.acks(code)],
          ["SADD", wgroup.KEY.activeCalls, code],
        ]);
        const others = (await wgMembers(code)).filter((m) => m.uid !== g.host).map((m) => m.uid);
        await wgPush(others, `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, wgCallText(made.call, now), { type: "wgroup_call", code, callId: made.call.id }, { urgent: true });
        return ok();
      }

      if (action === "seen" || action === "ack") {
        const call = await wgJson(wgroup.KEY.call(code));
        if (!call || call.id !== req.body.callId) return fail("ended");
        if (action === "ack") await sendUpstashCommand(["HSET", wgroup.KEY.acks(code), uid, "ack"]);
        else await sendUpstashCommand(["HSETNX", wgroup.KEY.acks(code), uid, "seen"]);
        return ok();
      }

      if (action === "call_done") {
        await sendUpstashPipeline([["DEL", wgroup.KEY.call(code), wgroup.KEY.acks(code)], ["SREM", wgroup.KEY.activeCalls, code]]);
        return ok();
      }

      if (action === "rollcall") {
        const roll = { id: `${now.toString(36)}`, sentAt: now };
        const ttl = String(Math.ceil((g.endsAt + 86400000 - now) / 1000));
        await sendUpstashPipeline([["SET", wgroup.KEY.roll(code), JSON.stringify(roll), "EX", ttl], ["DEL", wgroup.KEY.answers(code)]]);
        const others = (await wgMembers(code)).filter((m) => m.uid !== g.host).map((m) => m.uid);
        await wgPush(others, `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, "點名：到了請按「我到了」", { type: "wgroup_roll", code, rollId: roll.id }, { urgent: true });
        return ok();
      }

      if (action === "answer") {
        const roll = await wgJson(wgroup.KEY.roll(code));
        if (!roll || roll.id !== req.body.rollId) return fail("ended");
        if (!wgroup.ANSWERS.includes(req.body.answer)) return fail("bad_request");
        await sendUpstashCommand(["HSET", wgroup.KEY.answers(code), uid, req.body.answer]);
        if (req.body.answer === "help") {
          const me = (await wgMembers(code)).find((m) => m.uid === uid);
          await wgPush([g.host], `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, `${me ? me.no : "?"} 號需要幫忙`, { type: "wgroup_help", code }, { urgent: true });
        }
        return ok();
      }

      if (action === "note" || action === "kick" || action === "handoff") {
        const target = String(req.body.uid || "");
        const members = await wgMembers(code);
        const m = members.find((x) => x.uid === target);
        if (!m || target === g.host) return fail("bad_request");
        if (action === "note") {
          const note = wgroup.cleanNote(req.body.note);
          if (note && isDisallowed(note)) return fail("filtered");
          await sendUpstashCommand(["HSET", wgroup.KEY.members(code), target, JSON.stringify({ no: m.no, note, joinedAt: m.joinedAt })]);
        } else if (action === "kick") {
          await sendUpstashPipeline([["HDEL", wgroup.KEY.members(code), target], ["DEL", wgroup.KEY.of(target)], ["HDEL", wgroup.KEY.acks(code), target], ["HDEL", wgroup.KEY.answers(code), target], ["HDEL", wgroup.KEY.lost(code), target]]);
        } else {
          // 交棒：直接把團主交給這位團員（例如副領隊）；原團主留在團裡當團員
          const hostRow = members.find((x) => x.uid === g.host);
          await wgSaveGroup(code, { ...g, host: target });
          await sendUpstashPipeline([
            ["HSET", wgroup.KEY.members(code), target, JSON.stringify({ no: 0, note: "", joinedAt: m.joinedAt })],
            ["HSET", wgroup.KEY.members(code), g.host, JSON.stringify({ no: m.no, note: "", joinedAt: hostRow ? hostRow.joinedAt : now })],
          ]);
          await wgPush([target], `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, "你成為這個低語團的團主了。", { type: "wgroup_handoff", code });
        }
        return ok();
      }

      // 我迷路了：團員自己按下才把此刻的位置傳一次給團主（30 分鐘後自動消失，不會持續追蹤）
      if (action === "lost") {
        if (isHost) return fail("bad_request");
        const made = wgroup.makeLost({ lat: req.body.lat, lng: req.body.lng }, now);
        if (!made.ok) return fail(made.code);
        await sendUpstashPipeline([
          ["HSET", wgroup.KEY.lost(code), uid, JSON.stringify(made.entry)],
          ["EXPIRE", wgroup.KEY.lost(code), String(Math.ceil(wgroup.LOST_TTL_MS / 1000))],
        ]);
        const me = (await wgMembers(code)).find((m) => m.uid === uid);
        await wgPush([g.host], `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, `${me ? me.no : "?"} 號迷路了，傳來了目前的位置`, { type: "wgroup_lost", code }, { urgent: true });
        return ok();
      }

      // 找到團了：團員自己取消，或團主幫他清掉
      if (action === "found") {
        const target = isHost ? String(req.body.uid || "") : uid;
        if (!target) return fail("bad_request");
        await sendUpstashCommand(["HDEL", wgroup.KEY.lost(code), target]);
        return ok();
      }

      if (action === "rotate_qr") {
        await wgSaveGroup(code, { ...g, qrVer: (g.qrVer || 1) + 1 });
        return ok();
      }

      if (action === "leave") {
        if (isHost) return fail("host"); // 團主要先交棒或解散
        await sendUpstashPipeline([["HDEL", wgroup.KEY.members(code), uid], ["DEL", wgroup.KEY.of(uid)], ["HDEL", wgroup.KEY.acks(code), uid], ["HDEL", wgroup.KEY.answers(code), uid], ["HDEL", wgroup.KEY.lost(code), uid]]);
        return res.status(200).json({ success: true, group: null });
      }

      if (action === "dissolve") {
        const members = await wgMembers(code);
        await wgDestroy(code, members);
        await wgPush(members.filter((m) => m.uid !== uid).map((m) => m.uid), `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, "低語團已解散，謝謝這幾天一起同行。", { type: "wgroup_end", code });
        return res.status(200).json({ success: true, group: null });
      }

      if (action === "verify") {
        // 低語團 7 天方案：一次購買＝目前帶的這一團付費到解散
        const p = req.body.purchase || {};
        let grant;
        try {
          if (p.platform === "apple") grant = wgroup.applePass(orbs.verifyAppleJws(p.data), orbs.BUNDLE_ID);
          else if (p.platform === "google" && typeof p.token === "string") grant = wgroup.googlePass(p.productId, orbs.receiptKey("google", p.token), await playPurchase(p.productId, p.token));
          else return fail("bad_request");
        } catch (e) {
          console.warn("whisper group verify failed:", e.message);
          return fail(e.message);
        }
        const db = admin.database();
        const claim = await db.ref(`groupPassReceipts/${grant.receipt}`).transaction((cur) => (cur == null || cur === code ? code : undefined));
        if (!claim.committed) return fail("used");
        if (!g.paid) await wgSaveGroup(code, { ...g, paid: true });
        return ok({ result: "granted" });
      }

      return res.status(400).json({ success: false, error: localize(lang, "未知的操作") });
    } catch (error) {
      console.error("whisperGroup failed:", error);
      return res.status(500).json({ success: false, code: "busy" });
    }
  });
});

// 每分鐘：集合呼叫還沒按「收到」的團員再提醒（每 60 秒、最多 3 次）；集合時間過 30 分鐘就收起來
// ============================================================================
// 星軌：量子相遇卡完成（對方按下同意，quantumMeet/{邀請的人}/{同意的人}.op = 'yes'）時，兩人各多一顆星。
// 同一對 24 小時內只算一次；只記數量，不記是誰和誰。
// ============================================================================
exports.orbMeetStars = onValueWritten({ ref: "/quantumMeet/{asker}/{accepter}", region: "asia-southeast1", secrets: UPSTASH_SECRETS }, async (event) => {
  const after = event.data.after.val();
  const before = event.data.before.val();
  if (!after || after.op !== "yes" || (before && before.op === "yes")) return;
  const { asker, accepter } = event.params;
  if (asker === accepter) return;
  const first = await sendUpstashCommand(["SET", orbs.meetPairKey(asker, accepter), "1", "NX", "EX", "86400"]);
  if (first !== "OK") return;
  await sendUpstashPipeline([["HINCRBY", orbs.growthKey(asker), "stars", "1"], ["HINCRBY", orbs.growthKey(accepter), "stars", "1"]]);
});

// ============================================================================
// Google Play 退款：每天查最近 3 天被退款／退單／撤銷的一次性購買（時光包、光球、艾婭造型）
// ============================================================================
exports.googleRefunds = onSchedule({ schedule: "every day 04:30", timeZone: "Asia/Taipei", region: "asia-southeast1" }, async () => {
  const { GoogleAuth } = require("google-auth-library");
  const client = await new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/androidpublisher"] }).getClient();
  const startTime = Date.now() - 3 * 86400000;
  let pageToken, handled = 0;
  do {
    const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${PLAY_PACKAGE}/purchases/voidedpurchases?startTime=${startTime}&maxResults=1000${pageToken ? `&token=${encodeURIComponent(pageToken)}` : ""}`;
    const data = (await client.request({ url })).data || {};
    for (const receipt of refunds.googleVoidedReceipts(data.voidedPurchases)) {
      try {
        if ((await applyRefund(receipt)).length) handled++;
      } catch (e) {
        console.warn("googleRefunds failed:", e.message);
      }
    }
    pageToken = data.tokenPagination && data.tokenPagination.nextPageToken;
  } while (pageToken);
  console.log("googleRefunds: handled", handled);
});

exports.remindWhisperGroups = onSchedule({ schedule: "every 1 minutes", region: "asia-southeast1", secrets: UPSTASH_SECRETS }, async () => {
  const now = Date.now();
  const codes = (await sendUpstashCommand(["SMEMBERS", wgroup.KEY.activeCalls])) || [];
  for (const code of codes) {
    try {
      const [g, call] = await Promise.all([wgLoad(code), wgJson(wgroup.KEY.call(code))]);
      if (!g || !call || !wgroup.callLive(call, now)) { await sendUpstashCommand(["SREM", wgroup.KEY.activeCalls, code]); continue; }
      const members = (await wgMembers(code)).filter((m) => m.uid !== g.host).map((m) => m.uid);
      const acks = wgHash(await sendUpstashCommand(["HGETALL", wgroup.KEY.acks(code)]));
      const due = wgroup.dueReminders(call, members, acks, now);
      if (!due.length) continue;
      await wgPush(due, `${WG_COLOR_DOT[g.color] || "🟣"} ${g.name}`, `再提醒一次：${wgCallText(call, now)}`, { type: "wgroup_call", code, callId: call.id }, { urgent: true });
      for (const u of due) call.remind[u] = (call.remind[u] || 0) + 1;
      call.lastRemindAt = now;
      await sendUpstashCommand(["SET", wgroup.KEY.call(code), JSON.stringify(call), "EX", String(Math.max(60, Math.ceil((call.at + wgroup.CALL_LINGER_MS - now) / 1000)))]);
    } catch (e) {
      console.error(`[低語團] ${code} 提醒失敗:`, e);
    }
  }
});

exports.deleteAccount = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });

    const db = admin.database();
    try {
      // 正在主持的集會先結束（通知參加的人），再刪資料
      const hostingGid = (await db.ref(`hosting/${uid}`).once("value")).val();
      if (hostingGid) await endGathering(hostingGid, 'host_left');
      const [quantumOrd, quantumRegion] = (await sendUpstashCommand(["HMGET", quantum.KEY.seat(uid), "ord", "region"])) || [];
      await sendUpstashPipeline([["ZREM", "city_users", uid], ["ZREM", parallel.GEO_KEY, uid], ["DEL", `user_data:${uid}`], ["DEL", orbs.growthKey(uid)], ["SREM", demo.REVIEWERS_KEY, uid], ["DEL", `demo_anchor:${uid}`], ["DEL", aiya.KEY.session(uid)],
          ...(await quantumReleaseCommands([{ uid, ord: quantumOrd ?? null, region: quantumRegion }]))]);
      const myWhispers = (await sendUpstashCommand(["SMEMBERS", `whispers_by:${uid}`])) || [];
      if (myWhispers.length > 0) {
          await sendUpstashPipeline([["ZREM", "whispers", ...myWhispers], ...myWhispers.map((id) => ["DEL", `whisper:${id}`, `whisper_readers:${id}`]), ["DEL", `whispers_by:${uid}`]]);
      }
      // 店內留言本裡自己的留言
      const myNotes = (await sendUpstashCommand(["SMEMBERS", `place_notes_by:${uid}`])) || [];
      if (myNotes.length > 0) {
          const places = await sendUpstashPipeline(myNotes.map((id) => ["HGET", `place_note:${id}`, "place"]));
          await sendUpstashPipeline([
              ...myNotes.flatMap((id, i) => (places[i] ? [["ZREM", `place_notes:${places[i]}`, id]] : [])),
              ...myNotes.map((id) => ["DEL", `place_note:${id}`]),
              ["DEL", `place_notes_by:${uid}`],
          ]);
      }
      // 收下別人低語時留下的讀者紀錄（只保留匿名的收下次數）
      const allWhispers = (await sendUpstashCommand(["ZRANGE", "whispers", "0", "-1"])) || [];
      if (allWhispers.length > 0) {
          await sendUpstashPipeline(allWhispers.map((id) => ["SREM", `whisper_readers:${id}`, uid]));
      }

      const updates = {};
      for (const path of ["presence", "profiles", "user_avatars", "tokens", "blocks", "blockedBy", "consents", "requests", "resonance", "resonancePush", "gatheringHandoffs", "timeWhispers", "beaconReportsByUser"]) {
          updates[`${path}/${uid}`] = null;
      }
      // 量子化身：刪掉擁有紀錄，並釋放購買憑證，之後用新帳號可以恢復購買
      const myOrbs = (await db.ref(`orbOwned/${uid}`).once("value")).val() || {};
      updates[`orbOwned/${uid}`] = null;
      for (const owned of Object.values(myOrbs)) if (owned && typeof owned.receipt === "string") updates[`orbReceipts/${owned.receipt}`] = null;
      // 艾婭：剩下的時光包次數與同意紀錄一起刪除（消耗型無法恢復，條款已說明）；收據紀錄保留，避免同一筆購買重複加次數
      // 低語團：團主就整團解散，團員就退出
      const myGroup = await sendUpstashCommand(["GET", wgroup.KEY.of(uid)]);
      if (myGroup) {
        const wg = await wgLoad(myGroup);
        if (wg && wg.host === uid) await wgDestroy(myGroup, await wgMembers(myGroup));
        else await sendUpstashPipeline([["HDEL", wgroup.KEY.members(myGroup), uid], ["DEL", wgroup.KEY.of(uid)], ["HDEL", wgroup.KEY.acks(myGroup), uid], ["HDEL", wgroup.KEY.answers(myGroup), uid], ["HDEL", wgroup.KEY.lost(myGroup), uid]]);
      }
      updates[`aiyaCredits/${uid}`] = null;
      updates[`aiyaConsent/${uid}`] = null;
      // 送禮：收到還沒回覆的禮物退回給送的人；自己的禮券、接收設定、花束刪掉；糾纏款配對解除
      for (const id of Object.keys((await db.ref(`giftInbox/${uid}`).once("value")).val() || {})) {
        const g = (await db.ref(`gifts/${id}`).once("value")).val();
        if (g && g.status === "pending") await returnGift(id, g);
      }
      // 送禮紀錄：自己送出或收到的都刪掉（隱私權政策：保存到任一方刪除帳號為止）
      for (const field of ["from", "to"]) {
        const mine = (await db.ref("gifts").orderByChild(field).equalTo(uid).once("value")).val() || {};
        for (const [id, g] of Object.entries(mine)) {
          updates[`gifts/${id}`] = null;
          updates[`giftPending/${id}`] = null;
          if (g && g.to && g.to !== uid) updates[`giftInbox/${g.to}/${id}`] = null; // 我送出、對方還沒回覆的禮物一起收回
          if (g && g.receipt) updates[`giftReceipts/${g.receipt}`] = refunds.REFUNDED; // 同一筆購買不能再兌換
        }
      }
      updates[`giftInbox/${uid}`] = null;
      updates[`giftVouchers/${uid}`] = null;
      updates[`giftPrefs/${uid}`] = null;
      updates[`giftBouquet/${uid}`] = null;
      const myPartner = (await db.ref(`orbPair/${uid}`).once("value")).val();
      updates[`orbPair/${uid}`] = null;
      if (myPartner) { updates[`orbPair/${myPartner}`] = null; await sendUpstashCommand(["DEL", gifts.pairKey(myPartner)]); }
      await sendUpstashCommand(["DEL", gifts.pairKey(uid)]);
      // 艾婭之友：刪掉訂閱紀錄並釋放收據，之後用新帳號可以恢復購買（訂閱本身要到 Apple／Google 取消）
      const myFriend = (await db.ref(`aiyaFriend/${uid}`).once("value")).val();
      updates[`aiyaFriend/${uid}`] = null;
      if (myFriend && typeof myFriend.receipt === "string") {
        updates[`aiyaFriendReceipts/${myFriend.receipt}`] = null;
        updates[`aiyaFriendTokens/${myFriend.receipt}`] = null;
      }
      // 自己寫在別人底下的資料：封鎖對方時的 blockedBy、對別人的敲門
      const myBlocks = (await db.ref(`blocks/${uid}`).once("value")).val() || {};
      for (const target of Object.keys(myBlocks)) updates[`blockedBy/${target}/${uid}`] = null;
      const requestTargets = (await db.ref("requests").once("value")).val() || {};
      for (const [target, senders] of Object.entries(requestTargets)) {
          if (senders && Object.prototype.hasOwnProperty.call(senders, uid)) updates[`requests/${target}/${uid}`] = null;
      }
      // 送給別人的微光
      const resonanceTargets = (await db.ref("resonance").once("value")).val() || {};
      for (const [target, senders] of Object.entries(resonanceTargets)) {
          if (target !== uid && senders && Object.prototype.hasOwnProperty.call(senders, uid)) updates[`resonance/${target}/${uid}`] = null;
      }
      // 城市燈塔的回報
      const myBeaconReports = (await db.ref(`beaconReportsByUser/${uid}`).once("value")).val() || {};
      for (const key of Object.keys(myBeaconReports)) {
          const [siteId, reason] = key.split("~");
          updates[`beaconReports/${siteId}/${reason}/${uid}`] = null;
      }
      // 低語穿越的解封提醒排程
      const twQueue = (await db.ref("timeWhisperQueue").orderByChild("uid").equalTo(uid).once("value")).val() || {};
      for (const id of Object.keys(twQueue)) updates[`timeWhisperQueue/${id}`] = null;
      const rooms = (await db.ref("chats").once("value")).val() || {};
      for (const roomId of Object.keys(rooms)) {
          if (roomId.split("_").includes(uid)) updates[`chats/${roomId}`] = null;
      }
      await db.ref().update(updates);

      try {
          await admin.storage().bucket().file(`avatars/${uid}.jpg`).delete();
      } catch (e) {
          if (e.code !== 404) console.error(`deleteAccount avatar (${uid}):`, e);
      }
      await admin.auth().deleteUser(uid);

      console.log(`[刪除帳號] ${uid} 已刪除（${Object.keys(updates).length} 個資料節點）`);
      res.status(200).json({ success: true });
    } catch (error) {
      console.error(`deleteAccount failed (${uid}):`, error);
      res.status(500).json({ success: false, error: localize(langOf(req), "刪除失敗") });
    }
  });
});

// ============================================================================
// API 8: 共鳴推播 —— 有人送你一道微光；同一人 30 分鐘內最多一則，避免洗版
// ============================================================================
const RESONANCE_PUSH_THROTTLE_MS = 30 * 60 * 1000;

exports.notifyOnResonance = functionsV1.database.ref('/resonance/{targetUid}/{senderUid}')
  .onWrite(async (change, context) => {
    const after = change.after.val();
    const before = change.before.val();
    if (typeof after !== 'number' || (typeof before === 'number' && before >= after)) return null; // 刪除或舊值，不推播
    const targetUid = context.params.targetUid;

    // 示範對象收到微光：回送一道，讓使用者也體驗「收到微光」（24 小時一次，和真人規則相同）
    if (demo.isDemoUid(targetUid)) {
        const senderUid = context.params.senderUid;
        if (demo.isDemoUid(senderUid)) return null;
        await sleep(3000);
        const back = admin.database().ref(`/resonance/${senderUid}/${targetUid}`);
        const last = (await back.once('value')).val();
        if (typeof last !== 'number' || Date.now() - last > 24 * 60 * 60 * 1000) await back.set(Date.now());
        return null;
    }
    const throttleRef = admin.database().ref(`/resonancePush/${targetUid}`);
    try {
        // 用交易確保同時多道微光只推一次
        const result = await throttleRef.transaction((last) => {
            if (typeof last === 'number' && Date.now() - last < RESONANCE_PUSH_THROTTLE_MS) return; // 放棄寫入
            return Date.now();
        });
        if (!result.committed) return null;
        await sendPush(targetUid, '城市低語', '有人在附近，與你的心情共鳴了。', { type: 'resonance' });
    } catch (e) {
        console.error(`notifyOnResonance failed (${targetUid}):`, e);
    }
    return null;
  });

// ============================================================================
// API 9: 城市心情天氣 —— 20 公里內、24 小時內的匿名心情百分比（少於 10 人只回「城市還很安靜」）
// ============================================================================
const CITY_MOOD_CACHE_SECONDS = 300;
const CITY_MOOD_MAX_PEOPLE = 3000;

// ============================================================================
// API: 公測報名（落地頁 beta.html）。不需登入；以隱藏欄位與 IP 頻率限制擋機器人
// ============================================================================
exports.betaSignup = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const checked = betasignup.validateSignup(req.body, Date.now());
    if (checked.error === "bot") return res.status(200).json({ success: true }); // 不讓機器人知道被擋
    if (checked.error) return res.status(400).json({ success: false, error: localize(langOf(req), checked.error) });
    try {
      const ip = String(req.headers["x-forwarded-for"] || req.ip || "").split(",")[0].trim() || "unknown";
      const n = await sendUpstashCommand(["INCR", `beta_rl:${ip}`]);
      if (n === 1) await sendUpstashCommand(["EXPIRE", `beta_rl:${ip}`, "600"]);
      if (n > 5) return res.status(429).json({ success: false, error: localize(langOf(req), "報名太頻繁了，請稍後再試。") });
      await admin.database().ref(`betaSignups/${checked.key}`).set(checked.record);
      res.status(200).json({ success: true });
    } catch (e) {
      console.error("betaSignup failed:", e);
      res.status(500).json({ success: false, error: localize(langOf(req), "報名沒有送出，請稍後再試。") });
    }
  });
});

exports.getCityMood = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const { lat, lng } = req.body;
    if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(langOf(req), "座標格式錯誤") });

    const key = citymood.cacheKey(lat, lng);
    try {
      const cached = await sendUpstashCommand(["GET", key]);
      if (cached) return res.status(200).json({ success: true, data: JSON.parse(cached), cached: true });

      const members = await sendUpstashCommand([
          "GEOSEARCH", "city_users", "FROMLONLAT", lng.toString(), lat.toString(),
          "BYRADIUS", String(citymood.CITY_RADIUS_KM), "km", "COUNT", String(CITY_MOOD_MAX_PEOPLE),
      ]);
      const uids = Array.isArray(members) ? members.filter(Boolean) : [];
      const rows = await sendUpstashPipeline(uids.map((u) => ["HMGET", `user_data:${u}`, "mood", "timestamp", "hidden"]));
      const people = rows
          .filter((r) => r && r[2] !== "1")
          .map(([mood, ts]) => ({ mood, lastSeen: parseInt(ts || "0", 10) }));
      const summary = citymood.summarize(people, Date.now());

      await sendUpstashCommand(["SET", key, JSON.stringify(summary), "EX", String(CITY_MOOD_CACHE_SECONDS)]);
      res.status(200).json({ success: true, data: summary });
    } catch (error) {
      console.error('getCityMood failed:', error);
      res.status(500).json({ success: false, error: localize(langOf(req), "讀取失敗") });
    }
  });
});

// ============================================================================
// API 10: 低語（城市漂流瓶）—— action: post / list / collect / delete
//   作者永遠不回傳給其他人；位置對齊到 100 公尺網格；7 天後自動消失
// ============================================================================
const WHISPER_TTL = String(whisper.TTL_SECONDS);

async function blockedUidsFor(uid) {
    const [mine, byOthers] = await Promise.all([
        admin.database().ref(`blocks/${uid}`).once('value'),
        admin.database().ref(`blockedBy/${uid}`).once('value'),
    ]);
    return new Set([...Object.keys(mine.val() || {}), ...Object.keys(byOthers.val() || {})]);
}

exports.whisper = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const { action, lat, lng, id } = req.body || {};
    const now = Date.now();
    try {
      if (action === "post") {
        if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(langOf(req), "座標格式錯誤") });
        const checked = whisper.validateText(req.body.text);
        if (checked.error) return res.status(400).json({ success: false, error: localize(langOf(req), checked.error) });
        const moderation = (await admin.database().ref(`moderation/${uid}/hidden`).once('value')).val();
        if (moderation === true) return res.status(403).json({ success: false, error: localize(langOf(req), "你的帳號正在審查中，暫時無法留下低語。") });

        // 每人同時最多 3 則（先清掉已過期的）
        const mine = (await sendUpstashCommand(["SMEMBERS", `whispers_by:${uid}`])) || [];
        const alive = mine.length ? await sendUpstashPipeline(mine.map((w) => ["EXISTS", `whisper:${w}`])) : [];
        const expired = mine.filter((_, i) => !alive[i]);
        if (expired.length) await sendUpstashPipeline([["SREM", `whispers_by:${uid}`, ...expired], ["ZREM", "whispers", ...expired]]);
        if (mine.length - expired.length >= whisper.MAX_ACTIVE_PER_USER) {
            return res.status(429).json({ success: false, error: localize(langOf(req), `你已經在城市裡留下 ${whisper.MAX_ACTIVE_PER_USER} 則低語了，等其中一則消散再留吧。`) });
        }
        // 每 10 分鐘最多 1 則
        const ok = await sendUpstashCommand(["SET", `whisper_rl:${uid}`, "1", "EX", String(whisper.POST_COOLDOWN_SECONDS), "NX"]);
        if (ok !== "OK") return res.status(429).json({ success: false, error: localize(langOf(req), "剛剛才留過低語，過幾分鐘再來吧。") });

        const wid = `${now.toString(36)}${Math.random().toString(36).slice(2, 8)}`;
        const pos = whisper.snapToCell(lat, lng);
        const moodKey = citymood.classifyMood(req.body.mood);
        await sendUpstashPipeline([
            ["GEOADD", "whispers", pos.lng.toString(), pos.lat.toString(), wid],
            ["HSET", `whisper:${wid}`, "text", checked.text, "author", uid, "createdAt", String(now), "mood", moodKey, "reads", "0", "hidden", "0"],
            ["EXPIRE", `whisper:${wid}`, WHISPER_TTL],
            ["SADD", `whispers_by:${uid}`, wid],
            ["EXPIRE", `whispers_by:${uid}`, WHISPER_TTL],
        ]);
        return res.status(200).json({ success: true, data: { id: wid } });
      }

      if (action === "list") {
        if (!isValidCoordinate(lat, lng)) return res.status(400).json({ success: false, error: localize(langOf(req), "座標格式錯誤") });
        const found = await sendUpstashCommand([
            "GEOSEARCH", "whispers", "FROMLONLAT", lng.toString(), lat.toString(),
            "BYRADIUS", String(whisper.DISCOVER_RADIUS_KM), "km", "ASC", "COUNT", String(whisper.MAX_RESULTS), "WITHCOORD",
        ]);
        const items = (Array.isArray(found) ? found : []).filter((f) => Array.isArray(f) && f[0]);
        const rows = await sendUpstashPipeline(items.map(([wid]) => ["HMGET", `whisper:${wid}`, "text", "author", "createdAt", "mood", "reads", "hidden"]));
        const blocked = await blockedUidsFor(uid);
        const gone = [];
        const data = [];
        items.forEach(([wid, coord], i) => {
            const [text, author, createdAt, mood, reads, hidden] = rows[i] || [];
            if (!text) { gone.push(wid); return; }             // 已過期
            if (hidden === "1" || blocked.has(author)) return;  // 被檢舉隱藏，或與作者互相封鎖
            data.push({
                id: wid, text, mood: mood || "other",
                createdAt: parseInt(createdAt, 10), reads: parseInt(reads || "0", 10),
                lat: parseFloat(coord[1]), lng: parseFloat(coord[0]),
                mine: author === uid,                            // 作者本人才知道是自己的；從不回傳作者 uid
            });
        });
        if (gone.length) await sendUpstashCommand(["ZREM", "whispers", ...gone]);
        return res.status(200).json({ success: true, data });
      }

      if (action === "collect") {
        const author = await sendUpstashCommand(["HGET", `whisper:${id}`, "author"]);
        if (!author) return res.status(404).json({ success: false, error: localize(langOf(req), "這則低語已經消散了。") });
        if (author === uid) return res.status(200).json({ success: true });
        const added = await sendUpstashCommand(["SADD", `whisper_readers:${id}`, uid]);
        if (added === 1) {
            await sendUpstashPipeline([["HINCRBY", `whisper:${id}`, "reads", "1"], ["EXPIRE", `whisper_readers:${id}`, WHISPER_TTL]]);
        }
        return res.status(200).json({ success: true });
      }

      if (action === "delete") {
        const author = await sendUpstashCommand(["HGET", `whisper:${id}`, "author"]);
        if (author !== uid) return res.status(403).json({ success: false, error: localize(langOf(req), "只能收回自己的低語。") });
        await sendUpstashPipeline([["ZREM", "whispers", id], ["DEL", `whisper:${id}`, `whisper_readers:${id}`], ["SREM", `whispers_by:${uid}`, id]]);
        return res.status(200).json({ success: true });
      }

      return res.status(400).json({ success: false, error: localize(langOf(req), "未知的操作") });
    } catch (error) {
      console.error(`whisper ${action} failed:`, error);
      res.status(500).json({ success: false, error: localize(langOf(req), "低語暫時無法使用，請稍後再試。") });
    }
  });
});


// ============================================================================
// API 10b: 店內留言本（心情據點）—— action: list / post / delete
//   人要在店的 40 公尺內才讀得到、寫得了；作者永遠不回傳；30 天後消失；同一家店每人每天 1 則
// ============================================================================
const PLACE_NOTE_TTL = String(placenote.TTL_SECONDS);

exports.placeNote = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const lang = langOf(req);
    const fail = (status, text) => res.status(status).json({ success: false, error: localize(lang, text) });
    const uid = await verifyCaller(req);
    if (!uid) return fail(401, "未授權");
    const { action, place: pid, lat, lng, id } = req.body || {};
    const now = Date.now();
    try {
      if (action === "list" || action === "post") {
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        const place = (await placenote.loadPlaces(now)).get(String(pid || ""));
        const problem = placenote.placeProblem(place, { lat, lng });
        if (problem) return fail(403, problem);
        const key = `place_notes:${place.id}`;

        if (action === "post") {
          const checked = placenote.validateText(req.body.text);
          if (checked.error) return fail(400, checked.error);
          const moderation = (await admin.database().ref(`moderation/${uid}/hidden`).once("value")).val();
          if (moderation === true) return fail(403, "你的帳號正在審查中，暫時無法留言。");
          const ok = await sendUpstashCommand(["SET", `place_note_rl:${place.id}:${uid}`, "1", "EX", String(placenote.COOLDOWN_SECONDS), "NX"]);
          if (ok !== "OK") return fail(429, "你今天已經在這家店留過一句了，明天再來吧。");
          const nid = `${now.toString(36)}${Math.random().toString(36).slice(2, 8)}`;
          await sendUpstashPipeline([
            ["HSET", `place_note:${nid}`, "text", checked.text, "author", uid, "createdAt", String(now), "place", place.id, "hidden", "0"],
            ["EXPIRE", `place_note:${nid}`, PLACE_NOTE_TTL],
            ["ZADD", key, String(now), nid],
            ["ZREMRANGEBYSCORE", key, "-inf", String(now - placenote.TTL_SECONDS * 1000)],
            ["ZREMRANGEBYRANK", key, "0", String(-(placenote.MAX_KEPT + 1))],
            ["SADD", `place_notes_by:${uid}`, nid],
            ["EXPIRE", `place_notes_by:${uid}`, PLACE_NOTE_TTL],
          ]);
          return res.status(200).json({ success: true, data: placenote.forReader(nid, { text: checked.text, author: uid, createdAt: String(now) }, uid) });
        }

        const ids = (await sendUpstashCommand(["ZREVRANGE", key, "0", String(placenote.MAX_KEPT - 1)])) || [];
        const rows = ids.length ? await sendUpstashPipeline(ids.map((nid) => ["HMGET", `place_note:${nid}`, "text", "author", "createdAt", "hidden"])) : [];
        const blocked = await blockedUidsFor(uid);
        const gone = [];
        const data = [];
        ids.forEach((nid, i) => {
          const [text, author, createdAt, hidden] = rows[i] || [];
          if (!text) { gone.push(nid); return; }             // 已過期
          if (hidden === "1" || blocked.has(author)) return;  // 被檢舉隱藏，或與作者互相封鎖
          if (data.length < placenote.MAX_SHOWN) data.push(placenote.forReader(nid, { text, author, createdAt }, uid));
        });
        if (gone.length) await sendUpstashCommand(["ZREM", key, ...gone]);
        return res.status(200).json({ success: true, data });
      }

      if (action === "delete") {
        const [author, placeId] = (await sendUpstashCommand(["HMGET", `place_note:${id}`, "author", "place"])) || [];
        if (author !== uid) return fail(403, "只能收回自己的留言。");
        await sendUpstashPipeline([["ZREM", `place_notes:${placeId}`, id], ["DEL", `place_note:${id}`], ["SREM", `place_notes_by:${uid}`, id]]);
        return res.status(200).json({ success: true });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`placeNote ${action} failed:`, error);
      return fail(500, "留言本暫時無法使用，請稍後再試。");
    }
  });
});

// ============================================================================
// API 11: 集會 —— action: create / end / announce / ask / answer
//   任何人都能開；以主持人的位置為中心 5 公里；用一個表情符號識別。
//   稱呼裡有這個符號、又在範圍內的人就是參加者：看得到置頂公告、收得到推播、可以回答提問。
//   主持人看不到參加者是誰；提問只回傳比例（少於 10 人不給比例）。
// ============================================================================
const GATHERING_AUDIENCE_MAX = 100000; // 遊行等大型集會：5 公里內所有人都要能篩到
const GATHERING_LOOKUP_CHUNK = 1000;
const GATHERING_AUDIENCE_FRESH_MS = 12 * 60 * 60 * 1000; // 12 小時內出現過的人才推播

async function readGathering(gid) {
    return (await admin.database().ref(`gatherings/${gid}`).once('value')).val();
}

/** 參加者：主持人 5 公里內、稱呼裡有活動圖標、沒有和主持人互相封鎖、沒有被隱藏 */
async function gatheringAudience(g) {
    const found = await sendUpstashCommand([
        "GEOSEARCH", "city_users", "FROMLONLAT", String(g.lng), String(g.lat),
        "BYRADIUS", String(gathering.PARTICIPANT_RADIUS_KM), "km", "COUNT", String(GATHERING_AUDIENCE_MAX),
    ]);
    const uids = (Array.isArray(found) ? found : []).filter((u) => u && u !== g.hostUid && !u.startsWith(demo.DEMO_PREFIX));
    if (uids.length === 0) return [];
    const rows = [];
    for (let i = 0; i < uids.length; i += GATHERING_LOOKUP_CHUNK) {
        rows.push(...await sendUpstashPipeline(uids.slice(i, i + GATHERING_LOOKUP_CHUNK).map((u) => ["HMGET", `user_data:${u}`, "nickname", "timestamp", "hidden"])));
    }
    const blocked = await blockedUidsFor(g.hostUid);
    const now = Date.now();
    return uids.filter((u, i) => {
        const [nickname, ts, hidden] = rows[i] || [];
        if (hidden === "1" || blocked.has(u)) return false;
        if (now - parseInt(ts || "0", 10) > GATHERING_AUDIENCE_FRESH_MS) return false;
        return gathering.emojiKeysIn(nickname).has(g.emojiKey);
    });
}

/** 一次推給很多人：每批 500 則 */
async function pushToMany(uids, title, body, data) {
    if (uids.length === 0) return 0;
    const tokens = []; // [token, 語言]
    for (let i = 0; i < uids.length; i += GATHERING_LOOKUP_CHUNK) {
        const chunk = uids.slice(i, i + GATHERING_LOOKUP_CHUNK);
        const [snaps, langs] = await Promise.all([
            Promise.all(chunk.map((u) => admin.database().ref(`tokens/${u}`).once('value'))),
            sendUpstashPipeline(chunk.map((u) => ["HGET", `user_data:${u}`, "lang"])).catch(() => []),
        ]);
        snaps.forEach((snap, j) => { if (snap.val()) tokens.push([snap.val(), langs[j]]); });
    }
    let sent = 0;
    for (let i = 0; i < tokens.length; i += 500) {
        const messages = tokens.slice(i, i + 500).map(([token, lang]) => ({
            token,
            notification: { title: localize(lang, title), body: localize(lang, body) },
            data,
            android: { priority: 'high', notification: { sound: 'default' } },
            apns: { headers: { 'apns-priority': '10' }, payload: { aps: { sound: 'default' } } },
        }));
        try {
            const result = await admin.messaging().sendEach(messages);
            sent += result.successCount;
        } catch (e) { console.error('gathering push batch failed:', e); }
    }
    return sent;
}

async function notifyGathering(gid, g, body) {
    try {
        const audience = await gatheringAudience(g);
        const sent = await pushToMany(audience, `${g.emoji} ${g.name}`, body, { type: 'gathering', gid });
        console.log(`[集會] ${gid} 推播 ${sent}/${audience.length} 人`);
    } catch (e) { console.error(`[集會] ${gid} 推播失敗:`, e); }
}

const GATHERING_END_MESSAGES = {
    host: '活動結束了，謝謝你今晚一起在這裡。',
    expired: '活動時間到了，謝謝你今晚一起在這裡。',
    host_left: '主持人已離開，活動結束。',
};

/** 結束活動：主持人變回一般使用者，圖標釋出給下一位；通知參加的人 */
async function endGathering(gid, reason) {
    const ref = admin.database().ref(`gatherings/${gid}`);
    const before = (await ref.once('value')).val();
    if (!before || before.status !== 'active') return false;
    // 交易的第一次執行常拿到本地快取的 null：當成還在進行中，伺服器會用真實值再跑一次
    const result = await ref.child('status').transaction((status) => (status === 'active' || status === null ? 'ended' : undefined));
    if (!result.committed) return false;
    const g = before;
    await Promise.all([
        ref.update({ endedAt: Date.now(), endedReason: reason }),
        admin.database().ref(`hosting/${g.hostUid}`).remove(),
        sendUpstashCommand(["HDEL", `user_data:${g.hostUid}`, "host", "hostEmoji"]).catch(() => {}),
    ]);
    await notifyGathering(gid, g, GATHERING_END_MESSAGES[reason] || GATHERING_END_MESSAGES.host);
    return true;
}

exports.gathering = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const { action, gid } = req.body || {};
    const db = admin.database();
    const now = Date.now();
    const fail = (code, error) => res.status(code).json({ success: false, error: localize(langOf(req), error) });
    try {
      if (action === "create") {
        const { lat, lng } = req.body;
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        if ((await db.ref(`moderation/${uid}/hidden`).once('value')).val() === true) return fail(403, "你的帳號正在審查中，暫時無法主持活動。");
        const current = (await db.ref(`hosting/${uid}`).once('value')).val();
        if (current) {
            const g = await readGathering(current);
            if (g && g.status === 'active') return fail(409, "你已經在主持一場活動了，先結束它再開新的。");
        }
        const name = gathering.validateName(req.body.name);
        if (name.error) return fail(400, name.error);
        const emoji = gathering.validateEmoji(req.body.emoji);
        if (emoji.error) return fail(400, emoji.error);
        const times = gathering.validateTimes(Number(req.body.startAt), Number(req.body.endAt), now);
        if (times.error) return fail(400, times.error);

        const center = gathering.publicCenter(lat, lng);
        const sameEmoji = Object.values((await db.ref('gatherings').orderByChild('emojiKey').equalTo(emoji.key).once('value')).val() || {})
            .filter((g) => g.status === 'active');
        if (gathering.conflicts(sameEmoji, center)) {
            return fail(409, `附近已經有人用 ${emoji.emoji} 開了活動，等它結束或換一個圖標吧。`);
        }

        const newGid = db.ref('gatherings').push().key;
        await db.ref().update({
            [`gatherings/${newGid}`]: {
                name: name.text, emoji: emoji.emoji, emojiKey: emoji.key,
                startAt: times.startAt, endAt: times.endAt, createdAt: now,
                hostUid: uid, status: 'active', ...center,
            },
            [`hosting/${uid}`]: newGid,
        });
        await sendUpstashCommand(["HSET", `user_data:${uid}`, "host", newGid, "hostEmoji", emoji.emoji]);
        console.log(`[集會] ${uid} 開了 ${newGid} ${emoji.emoji} ${name.text}`);
        return res.status(200).json({ success: true, data: { gid: newGid } });
      }

      // 被邀請接下主持的人：接受或婉拒（不需要是主持人，也不從 body 帶 gid）
      if (action === "accept-handoff" || action === "decline-handoff") {
        const offerRef = db.ref(`gatheringHandoffs/${uid}`);
        const offer = (await offerRef.once('value')).val();
        if (!offer || offer.expiresAt < now) {
            await offerRef.remove();
            return fail(410, "這個邀請已經失效了。");
        }
        const og = await readGathering(offer.gid);
        const stillValid = og && og.status === 'active' && og.hostUid === offer.fromUid;
        await Promise.all([offerRef.remove(), db.ref(`gatherings/${offer.gid}/pendingHandoff`).remove()]);
        if (!stillValid) return fail(410, "這場活動已經結束或換了主持人。");
        if (action === "decline-handoff") {
            await sendPush(offer.fromUid, `${og.emoji} ${og.name}`, "對方婉拒了接下主持。", { type: 'gathering_handoff', gid: offer.gid });
            return res.status(200).json({ success: true });
        }
        const problem = gathering.handoffProblem(og, await handoffCandidate(og, uid));
        if (problem) return fail(409, problem);
        await transferHost(offer.gid, og, uid, offer.quiet === true);
        return res.status(200).json({ success: true });
      }

      const g = gid ? await readGathering(gid) : null;
      if (!g) return fail(404, "找不到這場活動。");
      if (g.status !== 'active') return fail(410, "這場活動已經結束了。");
      const isHost = g.hostUid === uid;

      if (action === "end") {
        if (!isHost) return fail(403, "只有主持人可以結束活動。");
        if (!(await endGathering(gid, 'host'))) return fail(409, "活動沒有結束成功，請再試一次。");
        return res.status(200).json({ success: true });
      }

      if (action === "handoff") {
        if (!isHost) return fail(403, "只有主持人可以轉移活動。");
        const toUid = String(req.body.toUid || '');
        if (!toUid || toUid === uid || toUid.startsWith(demo.DEMO_PREFIX)) return fail(400, "無法把活動交給這位使用者。");
        const problem = gathering.handoffProblem(g, await handoffCandidate(g, toUid));
        if (problem) return fail(409, problem);
        const quiet = req.body.quiet === true;
        const expiresAt = now + gathering.HANDOFF_TTL_MS;
        const toName = (await getNicknameFromRedis(toUid)) || '';
        await db.ref().update({
            [`gatheringHandoffs/${toUid}`]: { gid, fromUid: uid, quiet, name: g.name, emoji: g.emoji, at: now, expiresAt },
            [`gatherings/${gid}/pendingHandoff`]: { toName, expiresAt },
        });
        await sendPush(toUid, `${g.emoji} ${g.name}`, "主持人想把這場活動交給你主持，打開 App 回覆。", { type: 'gathering_handoff', gid });
        return res.status(200).json({ success: true });
      }

      if (action === "cancel-handoff") {
        if (!isHost) return fail(403, "只有主持人可以取消。");
        const pending = (await db.ref('gatheringHandoffs').orderByChild('gid').equalTo(gid).once('value')).val() || {};
        const updates = { [`gatherings/${gid}/pendingHandoff`]: null };
        for (const target of Object.keys(pending)) updates[`gatheringHandoffs/${target}`] = null;
        await db.ref().update(updates);
        return res.status(200).json({ success: true });
      }

      if (action === "announce") {
        if (!isHost) return fail(403, "只有主持人可以發公告。");
        const checked = gathering.validateAnnouncement(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const aRef = db.ref(`gatheringAnnouncements/${gid}`).push();
        const latest = { id: aRef.key, text: checked.text, at: now };
        await aRef.set({ text: checked.text, at: now });
        await db.ref(`gatherings/${gid}/latest`).set(latest);
        await notifyGathering(gid, g, checked.text);
        return res.status(200).json({ success: true });
      }

      if (action === "ask") {
        if (!isHost) return fail(403, "只有主持人可以提問。");
        const checked = gathering.validateQuestion(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const qid = `${now.toString(36)}`;
        await db.ref().update({
            [`gatherings/${gid}/question`]: { id: qid, text: checked.text, at: now },
            [`gatheringTally/${gid}`]: { qid, total: 0, quiet: true },
        });
        await notifyGathering(gid, g, `主持人問：${checked.text}`);
        return res.status(200).json({ success: true });
      }

      if (action === "answer") {
        const q = g.question;
        if (!q || q.id !== req.body.qid) return fail(410, "這個問題已經換了。");
        const checked = gathering.validateAnswer(req.body.text);
        if (checked.error) return fail(400, checked.error);
        // 只有參加者能回答：稱呼裡有圖標、人在範圍內
        const [[nickname], pos] = await sendUpstashPipeline([
            ["HMGET", `user_data:${uid}`, "nickname"],
            ["GEOPOS", "city_users", uid],
        ]);
        const here = Array.isArray(pos) && pos[0] ? { lng: parseFloat(pos[0][0]), lat: parseFloat(pos[0][1]) } : null;
        if (!gathering.emojiKeysIn(nickname).has(g.emojiKey)) return fail(403, `把 ${g.emoji} 加進你的城市稱呼，就能參加這場活動。`);
        if (!here || gathering.distanceKm(here, g) > gathering.PARTICIPANT_RADIUS_KM) return fail(403, "你離活動有點遠，靠近一點再回答吧。");

        const answersRef = db.ref(`gatheringAnswers/${gid}/${q.id}`);
        await answersRef.child(uid).set(citymood.classifyMood(checked.text));
        const all = Object.values((await answersRef.once('value')).val() || {});
        await db.ref(`gatheringTally/${gid}`).set({ qid: q.id, ...gathering.tally(all) });
        return res.status(200).json({ success: true });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`gathering ${action} failed:`, error);
      res.status(500).json({ success: false, error: localize(langOf(req), "活動功能暫時無法使用，請稍後再試。") });
    }
  });
});

/**
 * 集會檢舉的三層防護（防止選舉造勢等場合被對手惡意檢舉）：
 *   1. 檢舉針對單則公告；達門檻只隱藏那一則，活動照常進行。整場活動不因檢舉自動結束。
 *   2. 門檻 = max(10, 參加人數 10%)。
 *   3. 只計算「活動開始前就存在的帳號」且「此刻是參加者」的檢舉人；其他檢舉仍留紀錄給人工審查。
 * 每一則檢舉都會在 gatheringReview/<gid> 標記，24 小時內人工處理。
 */
async function handleGatheringReport(target, report) {
    const parsed = gathering.parseReportTarget(target);
    if (!parsed) return;
    const { gid, aid } = parsed;
    const db = admin.database();
    const g = await readGathering(gid);
    if (!g) return;
    await db.ref(`gatheringReview/${gid}`).update({ flagged: true, lastReportAt: Date.now(), name: g.name, emoji: g.emoji, hostUid: g.hostUid });
    console.warn(`[檢舉] 集會 ${gid}${aid ? ` 公告 ${aid}` : '（整場）'} 被檢舉（${report.reason}），已標記人工審查`);
    if (!aid || g.status !== 'active') return;

    const all = Object.values((await db.ref('/reports').orderByChild('target').equalTo(target).once('value')).val() || {});
    const reporters = [...new Set(all.map((r) => r.reporter).filter(Boolean))];
    const audience = new Set(await gatheringAudience(g));
    const threshold = gathering.reportThreshold(audience.size);
    let valid = 0;
    for (const uid of reporters) {
        if (!audience.has(uid)) continue;
        try {
            const created = Date.parse((await admin.auth().getUser(uid)).metadata.creationTime);
            if (created < g.startAt) valid++;
        } catch (e) { /* 帳號已刪除：不計入 */ }
    }
    console.log(`[檢舉] 公告 ${gid}/${aid}：有效檢舉 ${valid}/${threshold}（共 ${reporters.length} 人檢舉，參加者 ${audience.size} 人）`);
    if (valid < threshold) return;
    await hideAnnouncement(gid, aid);
    console.warn(`[檢舉] 公告 ${gid}/${aid} 已自動隱藏，請到 Firebase 主控台審查 gatheringReview/${gid}`);
}

/** 隱藏一則公告；若它是置頂的那則，改成前一則沒被隱藏的公告 */
async function hideAnnouncement(gid, aid) {
    const db = admin.database();
    await db.ref(`gatheringAnnouncements/${gid}/${aid}/hidden`).set(true);
    const latest = (await db.ref(`gatherings/${gid}/latest`).once('value')).val();
    if (!latest || latest.id !== aid) return;
    const items = (await db.ref(`gatheringAnnouncements/${gid}`).orderByChild('at').once('value')).val() || {};
    const visible = Object.entries(items).filter(([, a]) => !a.hidden).sort((a, b) => b[1].at - a[1].at);
    await db.ref(`gatherings/${gid}/latest`).set(visible.length ? { id: visible[0][0], text: visible[0][1].text, at: visible[0][1].at } : null);
}

/** 交棒對象目前的狀態（給 gathering.handoffProblem 判斷） */
async function handoffCandidate(g, uid) {
    const [[nickname, hidden], pos] = await sendUpstashPipeline([
        ["HMGET", `user_data:${uid}`, "nickname", "hidden"],
        ["GEOPOS", "city_users", uid],
    ]);
    const hostingGid = (await admin.database().ref(`hosting/${uid}`).once('value')).val();
    const hostingActive = hostingGid ? ((await readGathering(hostingGid)) || {}).status === 'active' : false;
    const blocked = (await blockedUidsFor(g.hostUid)).has(uid);
    const here = Array.isArray(pos) && pos[0] ? { lng: parseFloat(pos[0][0]), lat: parseFloat(pos[0][1]) } : null;
    return { nickname, hidden, pos: here, hosting: hostingActive ? hostingGid : null, blocked };
}

/** 交棒：活動不變，只換主持人；中心改跟著新主持人。公開交棒才通知參加者。 */
async function transferHost(gid, g, toUid, quiet) {
    const db = admin.database();
    const fromUid = g.hostUid;
    const [pos] = await sendUpstashPipeline([["GEOPOS", "city_users", toUid]]);
    const center = Array.isArray(pos) && pos[0] ? gathering.publicCenter(parseFloat(pos[0][1]), parseFloat(pos[0][0])) : {};
    const now = Date.now();
    await db.ref().update({
        [`gatherings/${gid}/hostUid`]: toUid,
        ...Object.fromEntries(Object.entries(center).map(([k, v]) => [`gatherings/${gid}/${k}`, v])),
        [`gatherings/${gid}/pendingHandoff`]: null,
        ...(quiet ? {} : { [`gatherings/${gid}/handoffAt`]: now }),
        [`gatheringHandoffLog/${gid}/${now}`]: { from: fromUid, to: toUid, quiet },
        [`hosting/${fromUid}`]: null,
        [`hosting/${toUid}`]: gid,
    });
    await sendUpstashPipeline([
        ["HDEL", `user_data:${fromUid}`, "host", "hostEmoji"],
        ["HSET", `user_data:${toUid}`, "host", gid, "hostEmoji", g.emoji],
    ]);
    console.log(`[集會] ${gid} 主持人 ${fromUid} → ${toUid}${quiet ? '（安靜交棒）' : ''}`);
    await sendPush(fromUid, `${g.emoji} ${g.name}`, "對方接下了主持，你回到了城市裡。", { type: 'gathering_handoff', gid });
    if (!quiet) await notifyGathering(gid, { ...g, ...center, hostUid: toUid }, "主持人已交棒，活動繼續進行。");
}

// 時間到的活動自動結束（每 5 分鐘檢查一次）；結束滿 30 天的活動連同公告、提問與回答一併刪除（隱私權政策第 2 節）
const GATHERING_RETENTION_MS = 30 * 24 * 60 * 60 * 1000;

exports.endExpiredGatherings = onSchedule({ schedule: "every 5 minutes", region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, async () => {
    const db = admin.database();
    const active = (await db.ref('gatherings').orderByChild('status').equalTo('active').once('value')).val() || {};
    const now = Date.now();
    for (const [gid, g] of Object.entries(active)) {
        if (g.endAt <= now) {
            try { await endGathering(gid, 'expired'); } catch (e) { console.error(`[集會] ${gid} 自動結束失敗:`, e); }
        }
    }
    const ended = (await db.ref('gatherings').orderByChild('status').equalTo('ended').once('value')).val() || {};
    const updates = {};
    for (const [gid, g] of Object.entries(ended)) {
        if (now - (g.endedAt || g.endAt || 0) < GATHERING_RETENTION_MS) continue;
        for (const path of ['gatherings', 'gatheringAnnouncements', 'gatheringTally', 'gatheringAnswers', 'gatheringHandoffLog', 'gatheringReview']) updates[`${path}/${gid}`] = null;
    }
    if (Object.keys(updates).length) {
        await db.ref().update(updates);
        console.log(`[集會] 刪除 ${Object.keys(updates).length / 6} 場結束滿 30 天的活動`);
    }
});

// ============================================================================
// 今晚的台灣心情：每 15 分鐘把全台 24 小時內的心情匯總成比例，寫到 RTDB publicMood/（公開可讀）
//   latest：最新一筆；hourly/<整點時間>：每小時一筆趨勢，保留 7 天
//   只有比例，少於 10 人的區域不給比例；示範對象與被隱藏的帳號不算
// ============================================================================
const PUBLIC_MOOD_CHUNK = 1000;
const PUBLIC_MOOD_KEEP_MS = 7 * 24 * 60 * 60 * 1000;

exports.updatePublicMood = onSchedule({ schedule: "every 15 minutes", region: "asia-southeast1", secrets: UPSTASH_SECRETS, timeoutSeconds: 300, memory: "512MiB" }, async () => {
    const uids = ((await sendUpstashCommand(["ZRANGE", "city_users", "0", "-1"])) || []).filter((u) => u && !u.startsWith(demo.DEMO_PREFIX));
    const people = [];
    for (let i = 0; i < uids.length; i += PUBLIC_MOOD_CHUNK) {
        const chunk = uids.slice(i, i + PUBLIC_MOOD_CHUNK);
        const [positions, ...rows] = await sendUpstashPipeline([
            ["GEOPOS", "city_users", ...chunk],
            ...chunk.map((u) => ["HMGET", `user_data:${u}`, "mood", "timestamp", "hidden"]),
        ]);
        chunk.forEach((u, k) => {
            const pos = positions && positions[k];
            const [mood, ts, hidden] = rows[k] || [];
            if (!pos || hidden === "1") return;
            people.push({ lng: parseFloat(pos[0]), lat: parseFloat(pos[1]), mood, lastSeen: parseInt(ts || "0", 10) });
        });
    }
    const now = Date.now();
    const snapshot = publicmood.aggregate(people, now);
    const hour = Math.floor(now / 3600000) * 3600000;
    const db = admin.database();
    const updates = { "publicMood/latest": snapshot, [`publicMood/hourly/${hour}`]: publicmood.hourlyPoint(snapshot) };
    const old = (await db.ref("publicMood/hourly").orderByKey().endAt(String(now - PUBLIC_MOOD_KEEP_MS)).once("value")).val() || {};
    for (const k of Object.keys(old)) updates[`publicMood/hourly/${k}`] = null;
    await db.ref().update(updates);
    console.log(`[台灣心情] ${people.length} 人，全台 ${snapshot.taiwan.total} 人在 24 小時內出現`);
});

// ============================================================================
// API 12: 低語穿越 —— action: create / list / open / delete
//   寫給未來的自己：只有作者讀得到；一個月或一年後解封，回到 100 公尺內才能打開，讀過一次就刪除。
//   timeWhispers/{uid}/{id}：內容與精確位置（只有伺服器讀寫）
//   timeWhisperQueue/{id}：{uid, unlockAt}，解封時推播一次
// ============================================================================
exports.timeWhisper = onRequest({ region: "asia-southeast1" }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const { action, id, lat, lng } = req.body || {};
    const db = admin.database();
    const mine = db.ref(`timeWhispers/${uid}`);
    const now = Date.now();
    const fail = (code, error) => res.status(code).json({ success: false, error: localize(langOf(req), error) });
    try {
      if (action === "create") {
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        const checked = timewhisper.validateText(req.body.text);
        if (checked.error) return fail(400, checked.error);
        const unlockAt = timewhisper.unlockAtFor(req.body.delay, now);
        if (!unlockAt) return fail(400, "請選一個月後或一年後。");
        const all = (await mine.once("value")).val() || {};
        if (Object.values(all).filter((w) => !w.openedAt).length >= timewhisper.MAX_ACTIVE) {
            return fail(429, `你已經有 ${timewhisper.MAX_ACTIVE} 封還沒打開的低語穿越了，先讀完一封再寫吧。`);
        }
        const ref = mine.push();
        await db.ref().update({
            [`timeWhispers/${uid}/${ref.key}`]: { text: checked.text, lat, lng, createdAt: now, unlockAt },
            [`timeWhisperQueue/${ref.key}`]: { uid, unlockAt },
        });
        return res.status(200).json({ success: true, data: timewhisper.forOwner(ref.key, { lat, lng, createdAt: now, unlockAt }, now) });
      }

      if (action === "list") {
        const all = (await mine.once("value")).val() || {};
        const data = Object.entries(all).map(([k, w]) => timewhisper.forOwner(k, w, now)).sort((a, b) => a.unlockAt - b.unlockAt);
        return res.status(200).json({ success: true, data });
      }

      if (action === "open") {
        const w = (await mine.child(String(id || "")).once("value")).val();
        const here = isValidCoordinate(lat, lng) ? { lat, lng } : null;
        const problem = timewhisper.openProblem(w, here, now);
        if (problem) return fail(403, problem);
        // 只讀一次：回傳內容後立刻刪除
        await db.ref().update({ [`timeWhispers/${uid}/${id}`]: null, [`timeWhisperQueue/${id}`]: null });
        return res.status(200).json({ success: true, data: timewhisper.forOwner(id, { ...w, openedAt: now }, now) });
      }

      if (action === "delete") {
        await db.ref().update({ [`timeWhispers/${uid}/${id}`]: null, [`timeWhisperQueue/${id}`]: null });
        return res.status(200).json({ success: true });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`timeWhisper ${action} failed:`, error);
      res.status(500).json({ success: false, error: localize(langOf(req), "低語穿越暫時無法使用，請稍後再試。") });
    }
  });
});

// 每小時：解封的低語穿越推播給作者一次
exports.unlockTimeWhispers = onSchedule({ schedule: "every 60 minutes", region: "asia-southeast1" }, async () => {
    const db = admin.database();
    const due = (await db.ref("timeWhisperQueue").orderByChild("unlockAt").endAt(Date.now()).once("value")).val() || {};
    for (const [id, q] of Object.entries(due)) {
        try {
            const w = (await db.ref(`timeWhispers/${q.uid}/${id}`).once("value")).val();
            if (w && !w.openedAt) {
                const ago = Math.round((w.unlockAt - w.createdAt) / 86400000) >= 365 ? "一年前" : "一個月前";
                await sendPush(q.uid, "低語穿越", `${ago}的你，在某個地方留下了一句話。回到那裡，就能讀到。`, { type: "time_whisper", id });
            }
            await db.ref(`timeWhisperQueue/${id}`).remove();
        } catch (e) { console.error(`[低語穿越] ${id} 提醒失敗:`, e); }
    }
    if (Object.keys(due).length) console.log(`[低語穿越] 解封提醒 ${Object.keys(due).length} 封`);
});

// ============================================================================
// API 13: 城市燈塔 —— 友善公廁（性別友善／無障礙／親子）
//   資料每月從環境部「全國公廁建檔資料」同步到 Redis：
//     beacon_toilets：地點的 geo set；beacon_toilet:{id}：地點資料（JSON）；beacon_flags:{id}：達到門檻的回報
//   回報：beaconReports/{id}/{reason}/{uid} = 時間；beaconReportsByUser/{uid}/{id~reason}（刪帳號用）
//   金鑰：firebase functions:secrets:set MOENV_API_KEY（到 data.moenv.gov.tw 註冊會員後免費申請）
// ============================================================================
const MOENV_API_KEY = defineSecret("MOENV_API_KEY");
const BEACON_SOURCE = "https://data.moenv.gov.tw/api/v2/fac_p_07";
const BEACON_PAGE = 1000;
const BEACON_WRITE_CHUNK = 500;

async function fetchToiletRecords() {
    const records = [];
    for (let offset = 0; ; offset += BEACON_PAGE) {
        const url = `${BEACON_SOURCE}?api_key=${encodeURIComponent(cleanSecret(MOENV_API_KEY))}&limit=${BEACON_PAGE}&offset=${offset}&format=JSON`;
        let page = null;
        for (let attempt = 0; attempt < 3 && !page; attempt++) {
            try {
                const response = await fetch(url);
                if (response.ok) page = await response.json();
            } catch (e) { console.warn(`[城市燈塔] offset ${offset} 第 ${attempt + 1} 次失敗:`, e.message); }
            if (!page) await sleep(3000);
        }
        if (!Array.isArray(page)) throw new Error(`公廁資料下載失敗（offset ${offset}）`);
        records.push(...page);
        if (page.length < BEACON_PAGE) return records;
    }
}

async function syncBeaconToilets() {
    const records = await fetchToiletRecords();
    const sites = beacon.buildSites(records);
    // 資料異常（例如來源只回了一部分）就不要覆蓋舊資料
    if (sites.length < 1000) throw new Error(`地點太少（${records.length} 筆 → ${sites.length} 個），不更新`);
    for (let i = 0; i < sites.length; i += BEACON_WRITE_CHUNK) {
        const chunk = sites.slice(i, i + BEACON_WRITE_CHUNK);
        await sendUpstashPipeline([
            ["GEOADD", "beacon_toilets", ...chunk.flatMap((s) => [String(s.lng), String(s.lat), s.id])],
            ...chunk.map((s) => ["SET", `beacon_toilet:${s.id}`, JSON.stringify(s)]),
        ]);
    }
    // 這個月的資料裡已經沒有的地點
    const keep = new Set(sites.map((s) => s.id));
    const stale = ((await sendUpstashCommand(["ZRANGE", "beacon_toilets", "0", "-1"])) || []).filter((id) => !keep.has(id));
    for (let i = 0; i < stale.length; i += BEACON_WRITE_CHUNK) {
        const chunk = stale.slice(i, i + BEACON_WRITE_CHUNK);
        await sendUpstashPipeline([["ZREM", "beacon_toilets", ...chunk], ...chunk.map((id) => ["DEL", `beacon_toilet:${id}`])]);
    }
    console.log(`[城市燈塔] ${records.length} 筆 → ${sites.length} 個地點，移除 ${stale.length} 個`);
    return { records: records.length, sites: sites.length, removed: stale.length };
}

// 每月 2 日凌晨 4 點（環境部每月更新）
exports.syncBeacon = onSchedule({ schedule: "0 4 2 * *", timeZone: "Asia/Taipei", region: "asia-southeast1", secrets: [...UPSTASH_SECRETS, MOENV_API_KEY], timeoutSeconds: 540, memory: "1GiB" }, async () => {
    await syncBeaconToilets();
});

exports.beacon = onRequest({ region: "asia-southeast1", secrets: UPSTASH_SECRETS }, (req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");
    const uid = await verifyCaller(req);
    if (!uid) return res.status(401).json({ success: false, error: localize(langOf(req), "未授權") });
    const { action, lat, lng, id, reason } = req.body || {};
    const fail = (code, error) => res.status(code).json({ success: false, error: localize(langOf(req), error) });
    try {
      if (action === "nearby") {
        if (!isValidCoordinate(lat, lng)) return fail(400, "座標格式錯誤");
        const found = (await sendUpstashCommand(["GEOSEARCH", "beacon_toilets", "FROMLONLAT", String(lng), String(lat), "BYRADIUS", String(beacon.SEARCH_RADIUS_M), "m", "ASC", "COUNT", String(beacon.MAX_RESULTS), "WITHDIST"])) || [];
        if (found.length === 0) return res.status(200).json({ success: true, data: [] });
        const ids = found.map(([siteId]) => siteId);
        const [sites, flags] = await sendUpstashPipeline([
            ["MGET", ...ids.map((s) => `beacon_toilet:${s}`)],
            ["MGET", ...ids.map((s) => `beacon_flags:${s}`)],
        ]);
        const data = [];
        found.forEach(([, dist], k) => {
            if (!sites[k]) return;
            data.push({ ...JSON.parse(sites[k]), distance: Math.round(parseFloat(dist)), flags: flags[k] ? flags[k].split(",") : [] });
        });
        return res.status(200).json({ success: true, data });
      }

      if (action === "report") {
        const siteId = String(id || "");
        if (!/^[A-Za-z0-9.,_-]{1,40}$/.test(siteId) || !beacon.validateReason(reason)) return fail(400, "回報格式錯誤");
        if (!(await sendUpstashCommand(["EXISTS", `beacon_toilet:${siteId}`]))) return fail(404, "找不到這個地點");
        const db = admin.database();
        const now = Date.now();
        await db.ref().update({
            [`beaconReports/${siteId}/${reason}/${uid}`]: now,
            [`beaconReportsByUser/${uid}/${siteId}~${reason}`]: now,
        });
        const reports = (await db.ref(`beaconReports/${siteId}`).once("value")).val() || {};
        const flagged = beacon.flagsFrom(reports, now);
        await sendUpstashCommand(flagged.length ? ["SET", `beacon_flags:${siteId}`, flagged.join(",")] : ["DEL", `beacon_flags:${siteId}`]);
        return res.status(200).json({ success: true, data: { flags: flagged } });
      }

      return fail(400, "未知的操作");
    } catch (error) {
      console.error(`beacon ${action} failed:`, error);
      res.status(500).json({ success: false, error: localize(langOf(req), "城市燈塔暫時無法使用，請稍後再試。") });
    }
  });
});
