// ============================================================================
// LiveKit（自架語音直播主機）：Q2 量子集會用
//
// 伺服器只做兩件事：
// 1. 發通行證（JWT，HS256）給 App 連進房間，決定能不能發聲；
// 2. 用 RoomService API 管理房間：改發聲權限、禁音、踢人、關房間。
// 不錄音：這裡沒有任何錄音（Egress）功能。
//
// 設定（環境變數）：LIVEKIT_URL（wss://…）、LIVEKIT_API_KEY、LIVEKIT_API_SECRET。
// 沒設定時 configured() 是 false，Q2 不開放。
// ============================================================================

const crypto = require('crypto');

function config() {
    const url = process.env.LIVEKIT_URL || '';
    const key = process.env.LIVEKIT_API_KEY || '';
    const secret = process.env.LIVEKIT_API_SECRET || '';
    return { url, key, secret };
}

const configured = () => {
    const c = config();
    return !!(c.url && c.key && c.secret);
};

const b64url = (buf) => Buffer.from(buf).toString('base64').replace(/=+$/, '').replace(/\+/g, '-').replace(/\//g, '_');

/** HS256 JWT */
function sign(payload, secret) {
    const head = b64url(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
    const body = b64url(JSON.stringify(payload));
    const sig = b64url(crypto.createHmac('sha256', secret).update(`${head}.${body}`).digest());
    return `${head}.${body}.${sig}`;
}

/**
 * 房間裡的身分：不放 uid（其他人看得到身分字串），用 uid＋集會 id 算出來的代號。
 * 同一個人在同一場永遠是同一個代號，伺服器可以反推來管理（禁音、踢人）。
 */
function identityOf(uid, asmId, secret = config().secret) {
    return 'p' + crypto.createHmac('sha256', secret || 'dev').update(`${asmId}:${uid}`).digest('hex').slice(0, 16);
}

/**
 * App 連進房間的通行證。
 * canPublish：主持人和台上來賓 true（只能發麥克風，不能發視訊）；聽眾 false。
 */
function accessToken({ room, identity, name, canPublish, ttlSeconds, now = Date.now() }) {
    const { key, secret } = config();
    const iat = Math.floor(now / 1000);
    return sign({
        iss: key,
        sub: identity,
        name: name || '',
        nbf: iat - 10,
        exp: iat + ttlSeconds,
        video: {
            room,
            roomJoin: true,
            canSubscribe: true,
            canPublish: !!canPublish,
            canPublishData: false,
            canPublishSources: ['microphone'],
            canUpdateOwnMetadata: false,
        },
    }, secret);
}

/** 管理用通行證（伺服器呼叫 RoomService 用） */
function adminToken(room, now = Date.now()) {
    const { key, secret } = config();
    const iat = Math.floor(now / 1000);
    return sign({ iss: key, nbf: iat - 10, exp: iat + 60, video: { room, roomAdmin: true, roomCreate: true } }, secret);
}

const httpBase = (url) => url.replace(/^wss:/, 'https:').replace(/^ws:/, 'http:').replace(/\/+$/, '');

/** RoomService（Twirp JSON） */
async function roomService(method, room, body) {
    const { url } = config();
    const res = await fetch(`${httpBase(url)}/twirp/livekit.RoomService/${method}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken(room)}` },
        body: JSON.stringify(body),
    });
    if (!res.ok) {
        const text = await res.text().catch(() => '');
        // 對方不在房間裡（not_found）不算錯：可能剛好離開
        if (res.status === 404 || /not_found/.test(text)) return null;
        throw new Error(`livekit ${method} ${res.status} ${text.slice(0, 200)}`);
    }
    return res.json().catch(() => ({}));
}

/** 改發聲權限（舉手被同意上台／請下台） */
const setCanPublish = (room, identity, canPublish) =>
    roomService('UpdateParticipant', room, {
        room,
        identity,
        permission: { can_subscribe: true, can_publish: !!canPublish, can_publish_data: false, can_publish_sources: ['MICROPHONE'] },
    });

/** 把某人在房間裡的所有聲音關掉（主持人禁音） */
async function muteAll(room, identity) {
    const p = await roomService('GetParticipant', room, { room, identity });
    const tracks = (p && p.tracks) || [];
    for (const t of tracks) await roomService('MutePublishedTrack', room, { room, identity, track_sid: t.sid, muted: true });
}

const removeParticipant = (room, identity) => roomService('RemoveParticipant', room, { room, identity });

const deleteRoom = (room) => roomService('DeleteRoom', room, { room });

module.exports = { config, configured, sign, identityOf, accessToken, adminToken, httpBase, setCanPublish, muteAll, removeParticipant, deleteRoom };
