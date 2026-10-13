// ============================================================================
// 雷達上的三種狀態判定 + 歷史殘影的密度分級留存
//   active   ：App 在前景（每 60 秒有心跳）
//   inactive ：鎖屏 / 背景（休息中），仍可敲門，由推播喚醒
//   shadow   ：已結束 App，或在背景超過 1 小時；可讀不可敲門，依密度決定留存多久
// 所有門檻都集中在這裡，調整後重新部署 geo-service 即可，不需更新 App。
// ============================================================================

const MINUTE = 60 * 1000;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;

// 前景心跳逾時：超過這段時間沒心跳，視為失去連線 → 當作休息中
const ACTIVE_HEARTBEAT_TIMEOUT_MS = 3 * MINUTE;

// 保底機制：iOS 被滑掉時常常收不到「已離開」訊號，背景超過此時間即視為已結束 App
const BACKGROUND_TO_SHADOW_MS = 1 * HOUR;

// 密度 = 觀看者周圍此半徑內的人數（含活躍、休息中、殘影）
const DENSITY_RADIUS_KM = 1;

// 6 級密度 → 殘影留存時間（由疏到密）
const SHADOW_RETENTION_TIERS = [
    { maxPeople: 5, retentionMs: 10 * DAY },
    { maxPeople: 15, retentionMs: 5 * DAY },
    { maxPeople: 40, retentionMs: 1 * DAY },
    { maxPeople: 100, retentionMs: 12 * HOUR },
    { maxPeople: 250, retentionMs: 6 * HOUR },
    { maxPeople: Infinity, retentionMs: 2 * HOUR },
];

// 最長留存：超過這個時間的殘影在任何密度下都看不到，可從 Redis 清除
const MAX_SHADOW_RETENTION_MS = Math.max(...SHADOW_RETENTION_TIERS.map((t) => t.retentionMs));

function shadowRetentionFor(peopleNearby) {
    return SHADOW_RETENTION_TIERS.find((t) => peopleNearby <= t.maxPeople).retentionMs;
}

/**
 * @param {string|null} state      presence 狀態：active / background / exited（舊資料可能沒有）
 * @param {number} stateAt         狀態變更時間 (ms)
 * @param {number} lastSeen        最後一次前景心跳時間 (ms)
 * @returns {{status: 'active'|'inactive'|'shadow', shadowSince?: number}}
 */
function classifyPresence(state, stateAt, lastSeen, now) {
    if (state === 'exited') return { status: 'shadow', shadowSince: stateAt || lastSeen };
    if (state !== 'background' && now - lastSeen <= ACTIVE_HEARTBEAT_TIMEOUT_MS) return { status: 'active' };

    // 背景 / 鎖屏，或前景心跳中斷（斷網、當機）：從最後的生命跡象開始計算休息時間
    const restingSince = state === 'background' ? (stateAt || lastSeen) : lastSeen;
    if (now - restingSince <= BACKGROUND_TO_SHADOW_MS) return { status: 'inactive' };
    return { status: 'shadow', shadowSince: restingSince + BACKGROUND_TO_SHADOW_MS };
}

module.exports = {
    DENSITY_RADIUS_KM,
    SHADOW_RETENTION_TIERS,
    MAX_SHADOW_RETENTION_MS,
    shadowRetentionFor,
    classifyPresence,
};
