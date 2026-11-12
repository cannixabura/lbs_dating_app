// 用暱稱找量子世界座位的 uid（只讀，不寫入）。
// 用法：把 Upstash 的 URL 和 TOKEN 各一行從 stdin 餵進來（不會印出），後面接要找的暱稱。
//   { firebase functions:secrets:access UPSTASH_REDIS_REST_URL; echo; firebase functions:secrets:access UPSTASH_REDIS_REST_TOKEN; echo; } \
//     | node tool/find_seat_by_nickname.js "暱稱A" "暱稱B"
// 空行略過（firebase secrets:access 本身可能已經帶換行）；URL 是 https 開頭那行，TOKEN 是之後的下一行
// 跟伺服器 cleanSecret 一樣：去掉空白與前後引號
const clean = (l) => l.trim().replace(/^["']|["']$/g, '').trim();
const lines = require('fs').readFileSync(0, 'utf8').split(/\r?\n/).map(clean).filter(Boolean);
const ui = lines.length >= 2 ? 0 : -1;
const url = ui >= 0 ? lines[0].replace(/\/+$/, '') : '';
const token = ui >= 0 ? lines[1] : '';
const want = process.argv.slice(2);
if (!url || !token || !want.length) {
  console.error(`需要 stdin 的 URL、TOKEN 和至少一個暱稱（收到 ${lines.length} 行非空白）`);
  process.exit(1);
}
const cmd = async (c) => {
  const r = await fetch(/^https?:\/\//.test(url) ? url : `https://${url}`, { method: 'POST', headers: { Authorization: `Bearer ${token}` }, body: JSON.stringify(c) });
  if (!r.ok) { console.error(`Upstash 回應 ${r.status}`); process.exit(1); }
  return (await r.json()).result;
};
(async () => {
  let cur = '0';
  const found = [];
  do {
    const [next, keys] = await cmd(['SCAN', cur, 'MATCH', 'quantum_seat:*', 'COUNT', '500']);
    cur = String(next);
    for (const k of keys || []) {
      const nick = await cmd(['HGET', k, 'nickname']);
      if (want.includes(nick)) found.push([nick, k.slice('quantum_seat:'.length)]);
    }
  } while (cur !== '0');
  console.log(JSON.stringify(found));
})();
