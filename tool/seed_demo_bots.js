// 建立或移除示範對象（台北 200 位、審核 20 位）。
//
// 用法（需要 Upstash 的網址與權杖，從 Firebase Secret Manager 讀出後放進環境變數）：
//   UPSTASH_URL=... UPSTASH_TOKEN=... node tool/seed_demo_bots.js          建立／更新
//   UPSTASH_URL=... UPSTASH_TOKEN=... node tool/seed_demo_bots.js --remove 全部移除
//
// 可以重複執行：位置與名字由固定種子產生，每次結果相同。

const demo = require('../geo-service/demo');

const url = (process.env.UPSTASH_URL || '').replace(/^"|"$/g, '');
const token = (process.env.UPSTASH_TOKEN || '').replace(/^"|"$/g, '');
if (!url || !token) {
    console.error('請先設定 UPSTASH_URL 與 UPSTASH_TOKEN');
    process.exit(1);
}

async function pipeline(commands) {
    const res = await fetch(`${url}/pipeline`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
        body: JSON.stringify(commands),
    });
    if (!res.ok) throw new Error(`Upstash ${res.status}: ${await res.text()}`);
    const out = await res.json();
    const failed = out.filter((r) => r.error);
    if (failed.length) throw new Error(`Upstash errors: ${JSON.stringify(failed.slice(0, 3))}`);
    return out;
}

async function main() {
    const taipei = demo.taipeiBots();
    const review = demo.reviewBotProfiles();
    const remove = process.argv.includes('--remove');

    if (remove) {
        await pipeline([
            ['DEL', demo.PUBLIC_GEO_KEY],
            ...[...taipei, ...review].map((b) => ['DEL', `user_data:${b.uid}`]),
        ]);
        console.log(`已移除 ${taipei.length} 位台北示範對象與 ${review.length} 位審核示範對象`);
        return;
    }

    const commands = [];
    for (const b of taipei) {
        commands.push(['GEOADD', demo.PUBLIC_GEO_KEY, String(b.lng), String(b.lat), b.uid]);
        commands.push(['HSET', `user_data:${b.uid}`, 'mood', b.mood, 'nickname', b.nickname, 'demo', '1']);
    }
    for (const b of review) {
        commands.push(['HSET', `user_data:${b.uid}`, 'mood', b.mood, 'nickname', b.nickname, 'demo', '1']);
    }
    // 分批送出，避免單一請求過大
    for (let i = 0; i < commands.length; i += 200) await pipeline(commands.slice(i, i + 200));
    console.log(`已建立 ${taipei.length} 位台北示範對象（${demo.PUBLIC_GEO_KEY}）與 ${review.length} 位審核示範對象`);
}

main().catch((e) => { console.error(e); process.exit(1); });
