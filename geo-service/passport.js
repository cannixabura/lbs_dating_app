// ============================================================================
// 平行護照：跟一座平行城市的人聊天（雙方都至少說過一句話），就在那座城市蓋一個章。
//
// 只記「哪座城市、哪一天」，不記對方是誰、聊了什麼。
// Realtime Database（只有伺服器寫得進去，App 只讀得到自己的）：
//   passport/{uid}/{cityId} = { at, country, names: [9 種語言的城市名稱] }
// 集滿 REWARD_CITIES 座城市，送一款「護照款」光球（orbOwned/{uid}/passport，src: 'passport'）。
//
// 判定用 Redis pp_room:{roomId}：每個人在這個聊天室第一次說話時，記下他當時打卡所在的城市；
// 兩個人都說過話、而且兩座城市互相配對（台灣 ↔ 國外），就各自蓋上對方城市的章（每個聊天室只蓋一次）。
// ============================================================================

const parallel = require('./parallel');

const REWARD_CITIES = 5;
const REWARD_STYLE = 'passport';
const ROOM_TTL_SEC = 3 * 86400;
const NO_CITY = '-';
const DONE = '_done';

const roomKey = (roomId) => `pp_room:${roomId}`;

/** 聊天室成員：roomId 是兩個 uid 以 _ 相連 */
function roomMembers(roomId) {
    const parts = String(roomId).split('_');
    return parts.length === 2 && parts[0] && parts[1] && parts[0] !== parts[1] ? parts : null;
}

/** 這個人說話時所在的城市代號（不在任何城市就是 '-'） */
function cityField(pos) {
    if (!pos) return NO_CITY;
    const c = parallel.cityOf(pos.lat, pos.lng);
    return c ? c.id : NO_CITY;
}

/**
 * 看聊天室紀錄決定要蓋哪些章。
 * @param {Record<string,string>} room  HGETALL pp_room:{roomId}
 * @returns {{uid:string, city:string}[]}  空陣列 = 還不能蓋（或已經蓋過）
 */
function stampsFor(roomId, room) {
    const members = roomMembers(roomId);
    if (!members || !room || room[DONE]) return [];
    const [a, b] = members;
    const ca = parallel.CITY_BY_ID[room[a]], cb = parallel.CITY_BY_ID[room[b]];
    if (!ca || !cb || !parallel.paired(ca, cb)) return [];
    return [{ uid: a, city: cb.id }, { uid: b, city: ca.id }];
}

/** 要寫進 passport/{uid}/{city} 的內容 */
function stampRecord(cityId, now) {
    const c = parallel.CITY_BY_ID[cityId];
    return { at: now, country: c.country, names: c.names };
}

/** 蓋完這個章之後，該不該送護照款 */
const earnsReward = (count) => count >= REWARD_CITIES;

module.exports = { REWARD_CITIES, REWARD_STYLE, ROOM_TTL_SEC, NO_CITY, DONE, roomKey, roomMembers, cityField, stampsFor, stampRecord, earnsReward };
