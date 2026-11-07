// 記憶體裡的迷你 Redis：只實作量子世界用到的指令，給測試與本機開發用（index.js 不會用到）
const db = new Map();
const zset = (k) => { if (!db.has(k)) db.set(k, new Map()); return db.get(k); };
const hash = (k) => { if (!db.has(k)) db.set(k, new Map()); return db.get(k); };
const score = (s) => (s === '-inf' ? -Infinity : s === '+inf' ? Infinity : Number(s));
const sorted = (k) => [...zset(k).entries()].sort((a, b) => a[1] - b[1] || (a[0] < b[0] ? -1 : 1));
const R = 6372797.560856;
const distM = (a, b) => {
    const r = Math.PI / 180;
    const h = Math.sin((b.lat - a.lat) * r / 2) ** 2 + Math.cos(a.lat * r) * Math.cos(b.lat * r) * Math.sin((b.lng - a.lng) * r / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(h));
};
const geo = new Map(); // key → Map(member → {lat, lng})

function run([cmd, ...a]) {
    switch (cmd.toUpperCase()) {
        case 'ECHO': return a[0];
        case 'DEL': return a.filter((k) => db.delete(k) || geo.delete(k)).length;
        case 'SET': db.set(a[0], String(a[1])); return 'OK';
        case 'INCR': { const v = Number(db.get(a[0]) || 0) + 1; db.set(a[0], String(v)); return v; }
        case 'HSET': { const h = hash(a[0]); for (let i = 1; i < a.length; i += 2) h.set(a[i], String(a[i + 1])); return 1; }
        case 'HINCRBY': { const h = hash(a[0]); const v = (parseInt(h.get(a[1]) || '0', 10) || 0) + parseInt(a[2], 10); h.set(a[1], String(v)); return v; }
        case 'HGET': return db.has(a[0]) ? (hash(a[0]).get(a[1]) ?? null) : null;
        case 'HMGET': return a.slice(1).map((f) => (db.has(a[0]) ? (hash(a[0]).get(f) ?? null) : null));
        case 'HGETALL': return db.has(a[0]) ? [...hash(a[0]).entries()].flat() : [];
        case 'GET': return db.has(a[0]) ? db.get(a[0]) : null;
        case 'EXISTS': return a.filter((k) => db.has(k)).length;
        case 'EXPIRE': return db.has(a[0]) ? 1 : 0;
        case 'HDEL': { if (!db.has(a[0])) return 0; let n = 0; a.slice(1).forEach((f) => { if (hash(a[0]).delete(f)) n++; }); return n; }
        case 'SADD': { const h = hash(a[0]); a.slice(1).forEach((m) => h.set(m, 1)); return 1; }
        case 'SREM': { if (!db.has(a[0])) return 0; let n = 0; a.slice(1).forEach((m) => { if (hash(a[0]).delete(m)) n++; }); return n; }
        case 'SMEMBERS': return db.has(a[0]) ? [...hash(a[0]).keys()] : [];
        case 'SCARD': return db.has(a[0]) ? hash(a[0]).size : 0;
        case 'RPUSH': { if (!db.has(a[0])) db.set(a[0], []); db.get(a[0]).push(...a.slice(1).map(String)); return db.get(a[0]).length; }
        case 'LRANGE': { const l = db.get(a[0]) || []; const end = Number(a[2]) < 0 ? l.length + Number(a[2]) + 1 : Number(a[2]) + 1; return l.slice(Number(a[1]), end); }
        case 'SISMEMBER': return db.has(a[0]) && hash(a[0]).has(a[1]) ? 1 : 0;
        case 'ZADD': {
            if (a[1] === 'NX') { if (zset(a[0]).has(a[3])) return 0; zset(a[0]).set(a[3], Number(a[2])); return 1; }
            zset(a[0]).set(a[2], Number(a[1])); return 1;
        }
        case 'ZCARD': return db.has(a[0]) ? zset(a[0]).size : 0;
        case 'ZRANDMEMBER': { const all = sorted(a[0]); return all.length ? all[Math.floor(Math.random() * all.length)][0] : null; }
        case 'ZRANGE': {
            const all = sorted(a[0]).map(([m]) => m);
            const from = Number(a[1]) < 0 ? Math.max(0, all.length + Number(a[1])) : Number(a[1]);
            const to = Number(a[2]) < 0 ? all.length + Number(a[2]) : Number(a[2]);
            return all.slice(from, to + 1);
        }
        case 'ZREM': {
            let n = 0;
            for (const m of a.slice(1)) { if (zset(a[0]).delete(m)) n++; if (geo.get(a[0])?.delete(m)) n++; }
            return n;
        }
        case 'ZPOPMIN': { const [first] = sorted(a[0]); if (!first) return []; zset(a[0]).delete(first[0]); return [first[0], String(first[1])]; }
        case 'ZCOUNT': return sorted(a[0]).filter(([, s]) => s >= score(a[1]) && s <= score(a[2])).length;
        case 'ZRANGEBYSCORE': {
            let out = sorted(a[0]).filter(([, s]) => s >= score(a[1]) && s <= score(a[2])).map(([m]) => m);
            const li = a.indexOf('LIMIT');
            if (li >= 0) out = out.slice(Number(a[li + 1]), Number(a[li + 1]) + Number(a[li + 2]));
            return out;
        }
        case 'ZREMRANGEBYSCORE': {
            const z = zset(a[0]);
            for (const [m, s] of [...z]) if (s >= score(a[1]) && s <= score(a[2])) z.delete(m);
            return 1;
        }
        case 'GEOADD': { if (!geo.has(a[0])) geo.set(a[0], new Map()); geo.get(a[0]).set(a[3], { lng: Number(a[1]), lat: Number(a[2]) }); return 1; }
        case 'GEOSEARCH': {
            const here = { lng: Number(a[a.indexOf('FROMLONLAT') + 1]), lat: Number(a[a.indexOf('FROMLONLAT') + 2]) };
            const km = Number(a[a.indexOf('BYRADIUS') + 1]);
            const count = a.includes('COUNT') ? Number(a[a.indexOf('COUNT') + 1]) : Infinity;
            return [...(geo.get(a[0]) || new Map())].map(([m, p]) => [m, p, distM(here, p)])
                .filter(([, , d]) => d <= km * 1000).sort((x, y) => x[2] - y[2]).slice(0, count)
                .map(([m, p]) => [m, [String(p.lng), String(p.lat)]]);
        }
        default: throw new Error(`mini redis: ${cmd} not implemented`);
    }
}

module.exports = { run, db, geo, distM };
