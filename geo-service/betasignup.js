// ============================================================================
// 公測報名：落地頁 beta.html 送來的報名資料驗證
// 資料只存在 RTDB /betaSignups（規則預設拒絕所有用戶端讀寫，只有管理員看得到）
// 同一個 Email 以雜湊當鍵，重複報名會覆蓋前一筆，不會重複
// ============================================================================

const crypto = require('crypto');

const PLATFORMS = ['ios', 'android'];
const AREAS = [
    '台北市', '新北市', '基隆市', '桃園市', '新竹', '苗栗', '台中市', '彰化', '南投', '雲林',
    '嘉義', '台南市', '高雄市', '屏東', '宜蘭', '花蓮', '台東', '離島', '海外',
];
const SOURCES = ['threads', 'instagram', 'facebook', 'dcard', 'line', 'friend', 'other'];
const EMAIL_RE = /^[^\s@]{1,64}@[^\s@]{1,190}\.[a-z]{2,}$/i;

/**
 * @returns {{error: string} | {key: string, record: object}}
 */
function validateSignup(body, now) {
    const b = body || {};
    if (b.website) return { error: 'bot' }; // 隱藏欄位：真人看不到，機器人會填
    const email = String(b.email || '').trim().toLowerCase();
    if (!EMAIL_RE.test(email)) return { error: '請填寫正確的 Email。' };
    const platform = String(b.platform || '');
    if (!PLATFORMS.includes(platform)) return { error: '請選擇你的手機是 iPhone 還是 Android。' };
    const area = String(b.area || '');
    if (!AREAS.includes(area)) return { error: '請選擇你常出沒的地區。' };
    if (b.agree !== true) return { error: '請先同意我們用這個 Email 寄送公測邀請。' };
    const source = SOURCES.includes(b.source) ? b.source : 'other';
    const ref = String(b.ref || '').slice(0, 40).replace(/[^\w-]/g, '');
    const key = crypto.createHash('sha256').update(email).digest('hex').slice(0, 32);
    return { key, record: { email, platform, area, source, ref, at: now } };
}

module.exports = { PLATFORMS, AREAS, SOURCES, validateSignup };
