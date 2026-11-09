// ============================================================================
// 旅行團（TourChip）API：HTTP、Redis、推播。純函式在 tourgroup.js。
// index.js 只負責把共用的工具（Redis、驗證、推播、內容過濾、內購驗證）傳進來：
//   const tour = require('./tourgroup_api').create({ ... });
//   exports.tourGroup = onRequest(..., (req, res) => cors(req, res, () => tour.handle(req, res)));
//   exports.remindTourGroups = onSchedule("every 1 minutes", tour.remind);
//
// 角色：host（團主）、cohost（共同團主，最多 2 位）、member（團員）
//   團主與共同團主：call / ping（單獨再叫一次）/ call_done / rollcall / roll_done / announce / note / assign / subs / stop_add / stop_remove / kick / rotate_qr / found
//   團主與共同團主也能：day_set（每日資訊卡）/ info_set（車輛、緊急聯絡）
//   只有團主：cohost_add / cohost_remove / handoff / dissolve / verify / redeem / trip（改出發日、天數）
//   所有團員：mdata（自己的飲食、健康、緊急聯絡人稱呼；只有團主與共同團主看得到）
//   團員：join / seen / ack / answer / lost / found（自己）/ leave
//   所有人：status；不必在團裡：create / join / buy_voucher / vouchers
// 團員的位置不會給團主；集合點是團主放的座標；「我迷路了」是團員自己按下才傳一次。
// ============================================================================

const tg = require('./tourgroup');

const COLOR_DOT = { violet: '🟣', pink: '🩷', blue: '🔵', teal: '🩵', green: '🟢', gold: '🟡', orange: '🟠', red: '🔴' };
const HOST_ONLY = ['cohost_add', 'cohost_remove', 'handoff', 'dissolve', 'verify', 'redeem', 'trip'];
const STAFF_ONLY = ['call', 'ping', 'call_done', 'rollcall', 'roll_done', 'announce', 'note', 'assign', 'subs', 'stop_add', 'stop_remove', 'kick', 'rotate_qr', 'day_set', 'info_set'];

/**
 * @param {object} d
 * @param {(cmd: any[]) => Promise<any>} d.cmd                Redis 單一指令
 * @param {(cmds: any[][]) => Promise<any[]>} d.pipe          Redis pipeline
 * @param {(req) => Promise<string|null>} d.verifyCaller       Firebase ID token → uid
 * @param {(text: string) => boolean} d.isDisallowed           內容過濾
 * @param {(uids, title, body, data, opts) => Promise<number>} d.push  推播（opts.urgent：時效性通知與專屬音效；opts.langs：每位收件人的語言）
 * @param {(req) => string} d.langOf
 * @param {(lang, text) => string} d.localize
 * @param {() => object} d.db                                  admin.database()
 * @param {(jws: string) => object} d.verifyAppleJws
 * @param {(src, id) => string} d.receiptKey
 * @param {(productId, token, pkg) => Promise<object>} d.playPurchase
 * @param {() => number} [d.clock]
 */
function create(d) {
    const clock = d.clock || Date.now;

    const json = async (key) => {
        const raw = await d.cmd(['GET', key]);
        try { return raw ? JSON.parse(raw) : null; } catch (e) { return null; }
    };
    const parseProfile = (raw) => { try { return raw ? JSON.parse(raw) : {}; } catch (e) { return {}; } };
    const hashOf = (flat) => { const o = {}; for (let i = 0; i < (flat || []).length; i += 2) o[flat[i]] = flat[i + 1]; return o; };
    const ttlFor = (g, now) => String(Math.max(60, Math.ceil((g.endsAt + 86400000 - now) / 1000)));

    // 推播用收件人自己的語言（記在 tgroup_lang；不讀城市低語的 user_data）
    const push = async (uids, title, body, data, opts = {}) => {
        const langs = uids.length ? await d.pipe(uids.map((u) => ['HGET', tg.KEY.lang, u])).catch(() => []) : [];
        return d.push(uids, title, body, data, { ...opts, langs });
    };

    async function load(code) {
        if (!tg.isCode(code)) return null;
        return json(tg.KEY.group(code));
    }
    async function save(code, g, now) {
        await d.cmd(['SET', tg.KEY.group(code), JSON.stringify(g), 'EX', ttlFor(g, now)]);
    }
    async function members(code) {
        const flat = (await d.cmd(['HGETALL', tg.KEY.members(code)])) || [];
        const out = [];
        for (let i = 0; i < flat.length; i += 2) {
            try { const m = JSON.parse(flat[i + 1]); out.push({ uid: flat[i], sub: null, ...m }); } catch (e) { /* 壞掉的列略過 */ }
        }
        return out.sort((a, b) => a.no - b.no);
    }
    const putMember = (code, uid, m) => ['HSET', tg.KEY.members(code), uid, JSON.stringify({ no: m.no, note: m.note || '', sub: m.sub ?? null, joinedAt: m.joinedAt })];
    const title = (g) => `${COLOR_DOT[g.color] || '🟣'} ${g.name}`;

    async function destroy(code, list) {
        const stops = (await json(tg.KEY.stops(code)).catch(() => null)) || [];
        await d.pipe([
            ['DEL', tg.KEY.group(code), tg.KEY.members(code), tg.KEY.call(code), tg.KEY.acks(code), tg.KEY.roll(code), tg.KEY.answers(code), tg.KEY.lost(code), tg.KEY.ann(code), tg.KEY.stops(code),
                tg.KEY.pos(code), tg.KEY.bubble(code), tg.KEY.msgs(code), tg.KEY.blocks(code), tg.KEY.seen(code), tg.KEY.days(code), tg.KEY.info(code), tg.KEY.mdata(code)],
            ...stops.map((x) => ['ZREM', tg.KEY.stopDue, `${code}|${x.id}`]),
            ...list.map((m) => ['ZREM', tg.KEY.pingDue, `${code}|${m.uid}`]),
            ['SREM', tg.KEY.activeCalls, code],
            ...list.map((m) => ['DEL', tg.KEY.of(m.uid)]),
        ]);
    }

    /** 行程表改變後重算結束時間（最後一個集合點的當地時區），同步更新所有 key 的存活時間 */
    async function resetEnds(code, g, stops, list, now, force = false) {
        const endsAt = tg.computeEndsAt(g, stops);
        if (endsAt === g.endsAt && !force) return g;
        const next = { ...g, endsAt };
        const ttl = ttlFor(next, now);
        await save(code, next, now);
        await d.pipe([
            ['EXPIRE', tg.KEY.members(code), ttl], ['EXPIRE', tg.KEY.stops(code), ttl], ['EXPIRE', tg.KEY.ann(code), ttl],
            ['EXPIRE', tg.KEY.days(code), ttl], ['EXPIRE', tg.KEY.info(code), ttl], ['EXPIRE', tg.KEY.mdata(code), ttl],
            ...list.map((m) => ['EXPIRE', tg.KEY.of(m.uid), ttl]),
        ]);
        return next;
    }

    /** 出發日、天數或天數券改變後：重算結束日與結束時間，同步所有 key 的存活時間 */
    async function saveTrip(code, next, now) {
        const stops = (await json(tg.KEY.stops(code))) || [];
        return resetEnds(code, next, stops, await members(code), now, true);
    }

    async function vouchersOf(uid) {
        const codes = (await d.cmd(['SMEMBERS', tg.KEY.vouchersOf(uid)])) || [];
        const rows = await Promise.all(codes.map(async (v) => ({ code: v, ...((await json(tg.KEY.voucher(v))) || {}) })));
        return rows.filter((r) => r.createdAt).map((r) => ({ code: r.code, link: tg.voucherLink(r.code), kind: r.kind === 'days' ? 'days' : 'people', createdAt: r.createdAt, used: !!r.usedBy, usedAt: r.usedAt || null }))
            .sort((a, b) => Number(a.used) - Number(b.used) || b.createdAt - a.createdAt);
    }

    /** 給 App 的狀態：團主、共同團主看得到名單與回覆；團員只看到自己的 */
    async function statusView(uid, now) {
        const code = await d.cmd(['GET', tg.KEY.of(uid)]);
        if (!code) return { group: null };
        const g = await load(code);
        if (!g || !tg.isOpen(g, now)) {
            if (g) await destroy(code, await members(code));
            else await d.cmd(['DEL', tg.KEY.of(uid)]);
            return { group: null };
        }
        const [list, call, roll, acksFlat, answersFlat, lostFlat, ann, stops, posFlat, bubbleFlat, msgList, myBlocks, seenFlat, daysFlat, info, mdataFlat] = await Promise.all([
            members(code), json(tg.KEY.call(code)), json(tg.KEY.roll(code)),
            d.cmd(['HGETALL', tg.KEY.acks(code)]), d.cmd(['HGETALL', tg.KEY.answers(code)]), d.cmd(['HGETALL', tg.KEY.lost(code)]),
            json(tg.KEY.ann(code)), json(tg.KEY.stops(code)),
            d.cmd(['HGETALL', tg.KEY.pos(code)]), d.cmd(['HGETALL', tg.KEY.bubble(code)]), d.cmd(['LRANGE', tg.KEY.msgs(code), '0', '-1']),
            d.cmd(['HGET', tg.KEY.blocks(code), uid]), d.cmd(['HGETALL', tg.KEY.seen(code)]),
            d.cmd(['HGETALL', tg.KEY.days(code)]), json(tg.KEY.info(code)), d.cmd(['HGETALL', tg.KEY.mdata(code)]),
        ]);
        const parse = (raw) => { try { return raw ? JSON.parse(raw) : null; } catch (e) { return null; } };
        const days = Object.values(hashOf(daysFlat)).map(parse).filter(Boolean).sort((a, b) => (a.date < b.date ? -1 : 1));
        const mdata = Object.fromEntries(Object.entries(hashOf(mdataFlat)).map(([u, raw]) => [u, parse(raw)]).filter(([, v]) => v));
        const acks = hashOf(acksFlat), answers = hashOf(answersFlat), lostHash = hashOf(lostFlat);
        const me = list.find((m) => m.uid === uid);
        const role = tg.roleOf(g, uid);
        const staff = role !== 'member';
        // 暱稱與頭像：旅行團自己的 tgroup_profile（不讀城市低語的 user_data）
        const profs = (await d.pipe(list.map((m) => ['HGET', tg.KEY.profile, m.uid])).catch(() => [])).map((raw) => { try { return raw ? JSON.parse(raw) : {}; } catch (e) { return {}; } });
        const profOf = (u) => profs[list.findIndex((m) => m.uid === u)] || {};
        const nameOf = (u) => profOf(u).name || '';
        const avatarOf = (u) => profOf(u).avatar || '';
        const shareFlat = await d.pipe(list.map((m) => ['HGET', tg.KEY.share, m.uid])).catch(() => []);
        const shareHash = Object.fromEntries(list.map((m, i) => [m.uid, shareFlat[i]]));
        let blockedByMe = [];
        try { blockedByMe = myBlocks ? JSON.parse(myBlocks) : []; } catch (e) { blockedByMe = []; }
        const bubbleHash = hashOf(bubbleFlat);
        let myBubble = '';
        try { myBubble = bubbleHash[uid] ? JSON.parse(bubbleHash[uid]).text || '' : ''; } catch (e) { myBubble = ''; }
        const mySub = me ? me.sub ?? null : null;
        const forMe = (x) => staff || !x || x.sub === null || x.sub === undefined || x.sub === mySub;
        const view = {
            code, name: g.name, color: g.color, tz: g.tz, startDate: g.startDate, endDate: g.endDate, endsAt: g.endsAt,
            days: tg.tripDays(g), allowedDays: tg.allowedDays(g), dayPasses: g.dayPasses || 0, daysNeeded: tg.daysPassesNeeded(g),
            dayCards: days, info: info || { buses: [], emergency: {} }, myData: mdata[uid] || null,
            paid: !!g.paid, limit: tg.memberLimit(g), count: list.length, subs: g.subs || [],
            role, myNo: me ? me.no : null, mySub, hostName: nameOf(g.host),
            staff: [g.host, ...(g.cohosts || [])].map((u) => ({ uid: u, no: (list.find((m) => m.uid === u) || {}).no ?? 0, name: nameOf(u), avatar: avatarOf(u), role: u === g.host ? 'host' : 'cohost' })),
            call: tg.callLive(call, now) && forMe(call) ? { id: call.id, at: call.at, tz: call.tz, place: call.place, lat: call.lat, lng: call.lng, sub: call.sub, mine: acks[uid] || null } : null,
            roll: roll && forMe(roll) ? { id: roll.id, sentAt: roll.sentAt, sub: roll.sub, mine: answers[uid] || null } : null,
            announcements: tg.visibleAnnouncements(ann || [], mySub, staff),
            stops: (stops || []).filter((s) => forMe(s)),
            lostSent: tg.lostRoster(list.filter((m) => m.uid === uid), lostHash, now).length > 0,
            // 同團互相看得到：地圖上的人、氣泡、私訊
            share: tg.shareState(shareHash[uid]),
            people: tg.peopleView({ g, list, me: uid, posHash: hashOf(posFlat), bubbleHash, shareHash, seenHash: hashOf(seenFlat), profOf: (u) => ({ name: nameOf(u), avatar: avatarOf(u) }), blockedByMe, now }),
            myBubble, blocked: blockedByMe,
            messages: tg.messagesFor(msgList, uid, blockedByMe).map((m) => ({ ...m, mine: m.from === uid })),
            names: Object.fromEntries(list.map((m) => [m.uid, { no: m.no, name: nameOf(m.uid), avatar: avatarOf(m.uid), role: tg.roleOf(g, m.uid) }])),
        };
        if (staff) {
            view.qr = tg.groupLink(code, g.qrVer);
            const others = list.filter((m) => !tg.isStaff(g, m.uid)).map((m) => ({ uid: m.uid, no: m.no, note: m.note || '', sub: m.sub ?? null, name: nameOf(m.uid), avatar: avatarOf(m.uid), data: mdata[m.uid] || null }));
            view.members = others;
            const inCall = (rows, x) => (x && x.targets && x.targets.length ? rows.filter((m) => x.targets.includes(m.uid)) : rows);
            if (view.call) view.callRoster = tg.callRoster(inCall(others, call), acks);
            if (view.roll) view.rollRoster = tg.rollRoster(inCall(others, roll), answers);
            view.lost = tg.lostRoster(others, lostHash, now);
        }
        return { group: view };
    }

    async function handle(req, res) {
        if (req.method !== 'POST') return res.status(405).send('Method Not Allowed');
        const lang = d.langOf(req);
        const uid = await d.verifyCaller(req);
        if (!uid) return res.status(401).json({ success: false, error: d.localize(lang, '未授權') });
        const body = req.body || {};
        const action = body.action, now = clock();
        // pong 來自背景收到的無聲推播：那時 App 的語言設定可能還沒載入，不更新推播語言
        if (action !== 'pong') await d.cmd(['HSET', tg.KEY.lang, uid, lang]).catch(() => 0);
        // 有聯絡就記下時間（地圖上不變灰），並把下次無聲推播往後排
        const myCode = await d.cmd(['GET', tg.KEY.of(uid)]).catch(() => null);
        if (myCode) {
            await d.pipe([
                ['HSET', tg.KEY.seen(myCode), uid, String(now)], ['EXPIRE', tg.KEY.seen(myCode), String(14 * 86400)],
                ['ZADD', tg.KEY.pingDue, String(now + tg.PING_EVERY_MS), `${myCode}|${uid}`],
            ]).catch(() => 0);
        }
        if (action === 'pong') return res.status(200).json({ success: true });
        const fail = (code, status = 200) => res.status(status).json({ success: false, code });
        const ok = async (extra = {}) => res.status(200).json({ success: true, ...(await statusView(uid, now)), ...extra });

        // 內購（人數券、天數券、團購券）共用的驗證
        async function verifyPurchase(p) {
            if (p.platform === 'apple') return tg.applePass(d.verifyAppleJws(p.data), tg.BUNDLE_ID);
            if (p.platform === 'google' && typeof p.token === 'string') return tg.googlePass(p.productId, d.receiptKey('google', p.token), await d.playPurchase(p.productId, p.token, tg.PLAY_PACKAGE));
            throw new Error('bad_request');
        }

        try {
            if (action === 'status') {
                const raw = await d.cmd(['HGET', tg.KEY.profile, uid]).catch(() => null);
                let profile = { name: '', avatar: '' };
                try { if (raw) profile = { ...profile, ...JSON.parse(raw) }; } catch (e) { /* 壞掉的資料當成沒有 */ }
                return ok({ profile });
            }

            // ---------- 個人資料：暱稱、頭像（設定頁；不必在團裡） ----------
            if (action === 'profile') {
                const prof = tg.cleanProfile(body, uid);
                if (prof && prof.name && d.isDisallowed(prof.name)) return fail('filtered');
                await d.cmd(prof ? ['HSET', tg.KEY.profile, uid, JSON.stringify(prof)] : ['HDEL', tg.KEY.profile, uid]);
                return ok({ profile: prof || { name: '', avatar: '' } });
            }

            // ---------- 分享位置的開關與同意（不必在團裡） ----------
            if (action === 'share') {
                const cur = tg.shareState(await d.cmd(['HGET', tg.KEY.share, uid]));
                const consent = cur.consent || body.consent === true;
                const on = consent && body.on !== false;
                await d.cmd(['HSET', tg.KEY.share, uid, JSON.stringify({ consent, on, at: now })]);
                if (!on) {
                    const c = await d.cmd(['GET', tg.KEY.of(uid)]);
                    if (c) await d.cmd(['HDEL', tg.KEY.pos(c), uid]);
                }
                return ok();
            }

            // ---------- 團購券：不必在團裡（旅行社的人買來發給領隊） ----------
            if (action === 'vouchers') return res.status(200).json({ success: true, vouchers: await vouchersOf(uid) });

            if (action === 'buy_voucher') {
                let grant;
                try { grant = await verifyPurchase(body.purchase || {}); } catch (e) { console.warn('tour voucher verify failed:', e.message); return fail(e.message); }
                const v = tg.newVoucherCode();
                const claim = await d.db().ref(`tourPassReceipts/${grant.receipt}`).transaction((cur) => (cur == null ? `v:${v}` : undefined));
                if (!claim.committed) {
                    // 同一筆購買再送一次（例如上次回應沒收到）：已經是這個人的券就當成功
                    return res.status(200).json({ success: true, result: 'exists', vouchers: await vouchersOf(uid) });
                }
                await d.pipe([
                    ['SET', tg.KEY.voucher(v), JSON.stringify(tg.makeVoucher(uid, grant.receipt, now, grant.productId)), 'EX', String(tg.VOUCHER_TTL_DAYS * 86400)],
                    ['SADD', tg.KEY.vouchersOf(uid), v],
                    ['EXPIRE', tg.KEY.vouchersOf(uid), String(tg.VOUCHER_TTL_DAYS * 86400)],
                ]);
                return res.status(200).json({ success: true, result: 'granted', voucher: v, vouchers: await vouchersOf(uid) });
            }

            if (action === 'create') {
                if (await d.cmd(['GET', tg.KEY.of(uid)])) return fail('in_group');
                const made = tg.makeGroup({ host: uid, name: body.name, color: body.color, days: body.days, tz: body.tz, start: body.start }, now);
                if (!made.ok) return fail(made.code);
                if (d.isDisallowed(made.group.name)) return fail('filtered');
                const subs = tg.cleanSubs(body.subs || []);
                if (!subs.ok) return fail(subs.code);
                if (subs.subs.some((s) => d.isDisallowed(s))) return fail('filtered');
                made.group.subs = subs.subs;
                let code = tg.newCode();
                for (let i = 0; i < 3 && (await d.cmd(['EXISTS', tg.KEY.group(code)])) === 1; i++) code = tg.newCode();
                await save(code, made.group, now);
                const ttl = ttlFor(made.group, now);
                await d.pipe([
                    putMember(code, uid, { no: 0, note: '', sub: null, joinedAt: now }),
                    ['EXPIRE', tg.KEY.members(code), ttl],
                    ['SET', tg.KEY.of(uid), code, 'EX', ttl],
                ]);
                return ok();
            }

            if (action === 'join') {
                const code = String(body.code || '').toUpperCase();
                const g = await load(code);
                if (!g) return fail('not_found');
                const current = await d.cmd(['GET', tg.KEY.of(uid)]);
                if (current && current !== code) return fail('in_group');
                const list = await members(code);
                const check = tg.canJoin(g, { count: list.length, qrVer: body.v, alreadyMember: list.some((m) => m.uid === uid) }, now);
                if (!check.ok) {
                    if (check.code === 'already') return ok();
                    // 第 21 位：通知團主買方案或用團購券
                    if (check.code === 'full') await push([g.host], title(g), '第 21 位團員正在等待入團，買人數券或使用團購券後就能加入。', { type: 'tgroup_full', code }).catch(() => 0);
                    return fail(check.code);
                }
                const no = tg.nextNumber(list);
                await d.pipe([
                    ['HSETNX', tg.KEY.members(code), uid, JSON.stringify({ no, note: '', sub: null, joinedAt: now })],
                    ['SET', tg.KEY.of(uid), code, 'EX', ttlFor(g, now)],
                ]);
                return ok();
            }

            // ---------- 以下都要已經在團裡 ----------
            const code = await d.cmd(['GET', tg.KEY.of(uid)]);
            const g = code ? await load(code) : null;
            if (!g || !tg.isOpen(g, now)) return fail('no_group');
            const role = tg.roleOf(g, uid);
            if (HOST_ONLY.includes(action) && role !== 'host') return fail('not_host', 403);
            if (STAFF_ONLY.includes(action) && role === 'member') return fail('not_host', 403);

            // ---------- 同團互相看得到：位置、氣泡、私訊、封鎖、檢舉 ----------
            const shareMe = async () => tg.shareState(await d.cmd(['HGET', tg.KEY.share, uid]));
            const keep = (key) => ['EXPIRE', key, ttlFor(g, now)];

            if (action === 'pos') {
                const lat = Number(body.lat), lng = Number(body.lng);
                if (!tg.validPos(lat, lng)) return fail('bad_request');
                if (!(await shareMe()).on) return fail('not_sharing');
                await d.pipe([['HSET', tg.KEY.pos(code), uid, JSON.stringify({ lat, lng, at: now })], keep(tg.KEY.pos(code))]);
                return res.status(200).json({ success: true });
            }

            if (action === 'bubble') {
                if (!(await shareMe()).consent) return fail('need_consent');
                const text = tg.clip(body.text, tg.MAX_BUBBLE);
                if (text && d.isDisallowed(text)) return fail('filtered');
                await d.pipe(text
                    ? [['HSET', tg.KEY.bubble(code), uid, JSON.stringify({ text, at: now })], keep(tg.KEY.bubble(code))]
                    : [['HDEL', tg.KEY.bubble(code), uid]]);
                return ok();
            }

            if (action === 'msg') {
                if (!(await shareMe()).consent) return fail('need_consent');
                const to = String(body.to || '');
                const list = await members(code);
                const target = list.find((m) => m.uid === to);
                if (!target) return fail('bad_request');
                const made = tg.makeMessage({ from: uid, to, text: body.text }, now);
                if (!made.ok) return fail(made.code);
                if (d.isDisallowed(made.msg.text)) return fail('filtered');
                const rate = await d.cmd(['INCR', tg.KEY.msgRate(uid)]);
                if (rate === 1) await d.cmd(['EXPIRE', tg.KEY.msgRate(uid), '60']);
                if (rate > tg.MSG_RATE) return fail('too_fast');
                let theirBlocks = [];
                try { theirBlocks = JSON.parse((await d.cmd(['HGET', tg.KEY.blocks(code), to])) || '[]'); } catch (e) { theirBlocks = []; }
                // 被對方封鎖：照樣回成功（不讓對方知道被封鎖），但不存、不推播
                if (theirBlocks.includes(uid)) return ok({ sent: made.msg.id });
                await d.pipe([
                    ['RPUSH', tg.KEY.msgs(code), JSON.stringify(made.msg)],
                    ['LTRIM', tg.KEY.msgs(code), String(-tg.MAX_MSGS), '-1'],
                    keep(tg.KEY.msgs(code)),
                ]);
                const me = list.find((m) => m.uid === uid);
                const prof = parseProfile(await d.cmd(['HGET', tg.KEY.profile, uid]));
                const who = prof.name ? `${prof.name}：` : `${me ? me.no : '?'} 號：`;
                await push([to], title(g), `${who}${made.msg.text}`, { type: 'tgroup_msg', code, from: uid });
                return ok({ sent: made.msg.id });
            }

            if (action === 'block') {
                const target = String(body.uid || '');
                if (!target || target === uid) return fail('bad_request');
                let mine = [];
                try { mine = JSON.parse((await d.cmd(['HGET', tg.KEY.blocks(code), uid])) || '[]'); } catch (e) { mine = []; }
                mine = body.on === false ? mine.filter((u) => u !== target) : [...new Set([...mine, target])];
                await d.pipe([['HSET', tg.KEY.blocks(code), uid, JSON.stringify(mine)], keep(tg.KEY.blocks(code))]);
                return ok();
            }

            if (action === 'report') {
                const target = String(body.uid || '');
                if (!target || target === uid) return fail('bad_request');
                const report = { code, from: uid, target, reason: tg.clip(body.reason, 200), at: now };
                await d.pipe([['LPUSH', tg.KEY.reports, JSON.stringify(report)], ['LTRIM', tg.KEY.reports, '0', '999']]);
                console.warn('tour report:', JSON.stringify(report));
                return res.status(200).json({ success: true });
            }

            if (action === 'call') {
                if (!tg.validSub(g, body.sub)) return fail('bad_request');
                const list = await members(code);
                const targets = tg.targetUids(g, list, body.sub);
                const made = tg.makeCall({ at: body.at, tz: body.tz, place: body.place, lat: body.lat, lng: body.lng, sub: body.sub, targets }, now);
                if (!made.ok) return fail(made.code);
                if (made.call.place && d.isDisallowed(made.call.place)) return fail('filtered');
                await d.pipe([
                    ['SET', tg.KEY.call(code), JSON.stringify(made.call), 'EX', String(Math.ceil((made.call.at + tg.CALL_LINGER_MS - now) / 1000))],
                    ['DEL', tg.KEY.acks(code)],
                    ['SADD', tg.KEY.activeCalls, code],
                ]);
                await push(targets, title(g), tg.callText(made.call, now), { type: 'tgroup_call', code, callId: made.call.id }, { urgent: true });
                return ok();
            }

            // 單獨呼叫：只對這一個人再送一次集合呼叫（或點名）
            if (action === 'ping') {
                const target = String(body.uid || '');
                const list = await members(code);
                if (!list.some((m) => m.uid === target) || tg.isStaff(g, target)) return fail('bad_request');
                const [call, roll] = await Promise.all([json(tg.KEY.call(code)), json(tg.KEY.roll(code))]);
                if (call && tg.callLive(call, now)) {
                    await push([target], title(g), tg.callText(call, now), { type: 'tgroup_call', code, callId: call.id }, { urgent: true });
                } else if (roll) {
                    await push([target], title(g), '點名：到了請按「我到了」', { type: 'tgroup_roll', code, rollId: roll.id }, { urgent: true });
                } else return fail('ended');
                return ok();
            }

            if (action === 'seen' || action === 'ack') {
                const call = await json(tg.KEY.call(code));
                if (!call || call.id !== body.callId) return fail('ended');
                if (action === 'ack') await d.cmd(['HSET', tg.KEY.acks(code), uid, 'ack']);
                else await d.cmd(['HSETNX', tg.KEY.acks(code), uid, 'seen']);
                return ok();
            }

            if (action === 'call_done') {
                await d.pipe([['DEL', tg.KEY.call(code), tg.KEY.acks(code)], ['SREM', tg.KEY.activeCalls, code]]);
                return ok();
            }

            if (action === 'rollcall') {
                if (!tg.validSub(g, body.sub)) return fail('bad_request');
                const targets = tg.targetUids(g, await members(code), body.sub);
                const roll = { id: now.toString(36), sentAt: now, sub: tg.normSub(body.sub), targets };
                await d.pipe([['SET', tg.KEY.roll(code), JSON.stringify(roll), 'EX', ttlFor(g, now)], ['DEL', tg.KEY.answers(code)]]);
                await push(targets, title(g), '點名：到了請按「我到了」', { type: 'tgroup_roll', code, rollId: roll.id }, { urgent: true });
                return ok();
            }

            if (action === 'roll_done') {
                await d.cmd(['DEL', tg.KEY.roll(code), tg.KEY.answers(code)]);
                return ok();
            }

            if (action === 'answer') {
                const roll = await json(tg.KEY.roll(code));
                if (!roll || roll.id !== body.rollId) return fail('ended');
                if (!tg.ANSWERS.includes(body.answer)) return fail('bad_request');
                await d.cmd(['HSET', tg.KEY.answers(code), uid, body.answer]);
                if (body.answer === 'help') {
                    const me = (await members(code)).find((m) => m.uid === uid);
                    await push([g.host, ...(g.cohosts || [])], title(g), `${me ? me.no : '?'} 號需要幫忙`, { type: 'tgroup_help', code }, { urgent: true });
                }
                return ok();
            }

            if (action === 'announce') {
                if (!tg.validSub(g, body.sub)) return fail('bad_request');
                const made = tg.makeAnnouncement({ text: body.text, sub: body.sub }, uid, now);
                if (!made.ok) return fail(made.code);
                if (d.isDisallowed(made.ann.text)) return fail('filtered');
                const list = tg.pushAnnouncement(await json(tg.KEY.ann(code)), made.ann);
                await d.cmd(['SET', tg.KEY.ann(code), JSON.stringify(list), 'EX', ttlFor(g, now)]);
                const targets = tg.targetUids(g, await members(code), body.sub);
                await push(targets, title(g), made.ann.text, { type: 'tgroup_ann', code });
                return ok();
            }

            if (action === 'subs') {
                const cleaned = tg.cleanSubs(body.subs);
                if (!cleaned.ok) return fail(cleaned.code);
                if (cleaned.subs.some((s) => d.isDisallowed(s))) return fail('filtered');
                // 刪掉的分組：原本在那組的團員改回「未分組」；名稱改了但位置沒變的保留
                const keep = cleaned.subs.length;
                const list = await members(code);
                await save(code, { ...g, subs: cleaned.subs }, now);
                const fix = list.filter((m) => m.sub !== null && m.sub >= keep).map((m) => putMember(code, m.uid, { ...m, sub: null }));
                if (fix.length) await d.pipe(fix);
                return ok();
            }

            if (action === 'note' || action === 'assign' || action === 'kick' || action === 'handoff' || action === 'cohost_add' || action === 'cohost_remove') {
                const target = String(body.uid || '');
                const list = await members(code);
                const m = list.find((x) => x.uid === target);
                if (!m || target === g.host) return fail('bad_request');
                if (action === 'note') {
                    const note = tg.clip(body.note, tg.MAX_NOTE);
                    if (note && d.isDisallowed(note)) return fail('filtered');
                    await d.cmd(putMember(code, target, { ...m, note }));
                } else if (action === 'assign') {
                    if (!tg.validSub(g, body.sub)) return fail('bad_request');
                    await d.cmd(putMember(code, target, { ...m, sub: tg.normSub(body.sub) }));
                } else if (action === 'kick') {
                    if (role === 'cohost' && tg.isStaff(g, target)) return fail('not_host', 403);
                    await save(code, tg.removeCohost(g, target), now);
                    await d.pipe([
                        ['HDEL', tg.KEY.members(code), target], ['DEL', tg.KEY.of(target)], ['HDEL', tg.KEY.acks(code), target],
                        ['HDEL', tg.KEY.answers(code), target], ['HDEL', tg.KEY.lost(code), target],
                        ['HDEL', tg.KEY.pos(code), target], ['HDEL', tg.KEY.bubble(code), target], ['HDEL', tg.KEY.seen(code), target], ['ZREM', tg.KEY.pingDue, `${code}|${target}`],
                        ['HDEL', tg.KEY.mdata(code), target],
                    ]);
                } else if (action === 'cohost_add') {
                    const r = tg.addCohost(g, target, list);
                    if (!r.ok) return fail(r.code);
                    await save(code, r.group, now);
                    await d.pipe([['HDEL', tg.KEY.acks(code), target], ['HDEL', tg.KEY.answers(code), target]]);
                    await push([target], title(g), '你成為這一團的共同團主了，可以發集合、點名和公告。', { type: 'tgroup_role', code });
                } else if (action === 'cohost_remove') {
                    await save(code, tg.removeCohost(g, target), now);
                } else {
                    // 交棒：團主交給這位成員；原團主留在團裡當共同團主（名額滿了就當團員）
                    const hostRow = list.find((x) => x.uid === g.host) || { joinedAt: now };
                    let cohosts = (g.cohosts || []).filter((u) => u !== target);
                    if (cohosts.length < tg.MAX_COHOSTS) cohosts = [...cohosts, g.host];
                    await save(code, { ...g, host: target, cohosts }, now);
                    await d.pipe([putMember(code, target, { ...m, no: 0 }), putMember(code, g.host, { ...hostRow, no: m.no || tg.nextNumber(list) })]);
                    await push([target], title(g), '你成為這一團的團主了。', { type: 'tgroup_role', code });
                }
                return ok();
            }

            if (action === 'stop_add') {
                const made = tg.makeStop({ id: body.id, at: body.at, tz: body.tz, place: body.place, lat: body.lat, lng: body.lng, sub: body.sub }, g, now);
                if (!made.ok) return fail(made.code);
                if (d.isDisallowed(made.stop.place)) return fail('filtered');
                const up = tg.upsertStop(await json(tg.KEY.stops(code)), made.stop);
                if (!up.ok) return fail(up.code);
                const g2 = await resetEnds(code, g, up.stops, await members(code), now);
                const remindAt = tg.stopRemindAt(made.stop, now);
                await d.pipe([
                    ['SET', tg.KEY.stops(code), JSON.stringify(up.stops), 'EX', ttlFor(g2, now)],
                    remindAt ? ['ZADD', tg.KEY.stopDue, String(remindAt), `${code}|${made.stop.id}`] : ['ZREM', tg.KEY.stopDue, `${code}|${made.stop.id}`],
                ]);
                return ok();
            }

            if (action === 'stop_remove') {
                const stops = tg.removeStop(await json(tg.KEY.stops(code)), String(body.id || ''));
                const g2 = await resetEnds(code, g, stops, await members(code), now);
                await d.pipe([
                    ['SET', tg.KEY.stops(code), JSON.stringify(stops), 'EX', ttlFor(g2, now)],
                    ['ZREM', tg.KEY.stopDue, `${code}|${String(body.id || '')}`],
                ]);
                return ok();
            }

            // ---------- 出發日、天數（團主） ----------
            if (action === 'trip') {
                const r = tg.changeTrip(g, { start: body.start, days: body.days }, (await json(tg.KEY.stops(code))) || [], now);
                if (!r.ok) return fail(r.code);
                await saveTrip(code, r.group, now);
                return ok();
            }

            // ---------- 每日資訊卡（團主、共同團主建，全團隨時看） ----------
            if (action === 'day_set') {
                const made = tg.makeDay({ date: body.date, note: body.note, hotel: body.hotel, links: body.links }, g);
                if (!made.ok) return fail(made.code);
                if (tg.dayTexts(made.card).some((x) => d.isDisallowed(x))) return fail('filtered');
                await d.pipe(made.card
                    ? [['HSET', tg.KEY.days(code), made.card.date, JSON.stringify(made.card)], keep(tg.KEY.days(code))]
                    : [['HDEL', tg.KEY.days(code), String(body.date)]]);
                return ok();
            }

            // ---------- 團體資訊：車輛、緊急聯絡 ----------
            if (action === 'info_set') {
                const made = tg.makeInfo({ buses: body.buses, emergency: body.emergency }, g);
                if (!made.ok) return fail(made.code);
                if (tg.infoTexts(made.info).some((x) => d.isDisallowed(x))) return fail('filtered');
                await d.cmd(['SET', tg.KEY.info(code), JSON.stringify(made.info), 'EX', ttlFor(g, now)]);
                return ok();
            }

            // ---------- 團員資料：自己填，只有團主與共同團主看得到；退團、解散就刪除 ----------
            if (action === 'mdata') {
                const data = tg.cleanMemberData(body);
                await d.pipe(data
                    ? [['HSET', tg.KEY.mdata(code), uid, JSON.stringify(data)], keep(tg.KEY.mdata(code))]
                    : [['HDEL', tg.KEY.mdata(code), uid]]);
                return ok();
            }

            if (action === 'lost') {
                if (role !== 'member') return fail('bad_request');
                const made = tg.makeLost({ lat: body.lat, lng: body.lng }, now);
                if (!made.ok) return fail(made.code);
                await d.pipe([
                    ['HSET', tg.KEY.lost(code), uid, JSON.stringify(made.entry)],
                    ['EXPIRE', tg.KEY.lost(code), String(Math.ceil(tg.LOST_TTL_MS / 1000))],
                ]);
                const me = (await members(code)).find((m) => m.uid === uid);
                await push([g.host, ...(g.cohosts || [])], title(g), `${me ? me.no : '?'} 號迷路了，傳來了目前的位置`, { type: 'tgroup_lost', code }, { urgent: true });
                return ok();
            }

            if (action === 'found') {
                const target = role !== 'member' ? String(body.uid || '') : uid;
                if (!target) return fail('bad_request');
                await d.cmd(['HDEL', tg.KEY.lost(code), target]);
                return ok();
            }

            if (action === 'rotate_qr') {
                await save(code, { ...g, qrVer: (g.qrVer || 1) + 1 }, now);
                return ok();
            }

            if (action === 'leave') {
                if (role === 'host') return fail('host');
                await save(code, tg.removeCohost(g, uid), now);
                await d.pipe([
                    ['HDEL', tg.KEY.members(code), uid], ['DEL', tg.KEY.of(uid)], ['HDEL', tg.KEY.acks(code), uid],
                    ['HDEL', tg.KEY.answers(code), uid], ['HDEL', tg.KEY.lost(code), uid],
                    ['HDEL', tg.KEY.pos(code), uid], ['HDEL', tg.KEY.bubble(code), uid], ['HDEL', tg.KEY.seen(code), uid], ['ZREM', tg.KEY.pingDue, `${code}|${uid}`],
                    ['HDEL', tg.KEY.mdata(code), uid],
                ]);
                return res.status(200).json({ success: true, group: null });
            }

            if (action === 'dissolve') {
                const list = await members(code);
                await destroy(code, list);
                await push(list.filter((m) => m.uid !== uid).map((m) => m.uid), title(g), '這一團已經解散，謝謝這幾天一起同行。', { type: 'tgroup_end', code });
                return res.status(200).json({ success: true, group: null });
            }

            if (action === 'verify') {
                // 人數券：這一團升到 100 人到解散；天數券：這一團多 7 天（同一筆購買只算一次）
                let grant;
                try { grant = await verifyPurchase(body.purchase || {}); } catch (e) { console.warn('tour pass verify failed:', e.message); return fail(e.message); }
                const days = tg.kindOf(grant.productId) === 'days';
                if (days && tg.allowedDays(g) >= tg.MAX_DAYS) return fail('max_days');
                const claim = await d.db().ref(`tourPassReceipts/${grant.receipt}`).transaction((cur) => (cur == null ? code : undefined));
                if (!claim.committed) {
                    // 同一筆購買再送一次（上次回應沒收到）：已經算在這一團就當成功
                    const prev = claim.snapshot && typeof claim.snapshot.val === 'function' ? claim.snapshot.val() : null;
                    return prev === code ? ok({ result: 'granted' }) : fail('used');
                }
                if (days) {
                    const r = tg.addDayPass(g, []);
                    if (r.ok) await saveTrip(code, r.group, now);
                } else if (!g.paid) await save(code, { ...g, paid: true }, now);
                return ok({ result: 'granted' });
            }

            if (action === 'redeem') {
                const v = String(body.voucher || '').toUpperCase();
                if (!tg.isVoucherCode(v)) return fail('voucher_not_found');
                const rec = await json(tg.KEY.voucher(v));
                const check = tg.canRedeem(rec, g, now);
                if (!check.ok) return fail(check.code);
                // 先在 RTDB 搶下這張券（避免兩個團同時用同一張）
                const claim = await d.db().ref(`tourVoucherUsed/${v}`).transaction((cur) => (cur == null || cur === code ? code : undefined));
                if (!claim.committed) return fail('voucher_used');
                await d.cmd(['SET', tg.KEY.voucher(v), JSON.stringify({ ...rec, usedBy: code, usedAt: now }), 'KEEPTTL']);
                if (rec.kind === 'days') {
                    const r = tg.addDayPass(g, []);
                    if (r.ok) await saveTrip(code, r.group, now);
                } else await save(code, { ...g, paid: true }, now);
                return ok({ result: 'granted', kind: rec.kind === 'days' ? 'days' : 'people' });
            }

            return res.status(400).json({ success: false, error: d.localize(lang, '未知的操作') });
        } catch (error) {
            console.error('tourGroup failed:', error);
            return res.status(500).json({ success: false, code: 'busy' });
        }
    }

    /** 每分鐘：12 分鐘沒聯絡的人送一個無聲推播（App 在背景時會回 pong；被關掉或關機就收不到 → 30 分鐘後變灰） */
    async function pingIdle(now) {
        const due = (await d.cmd(['ZRANGEBYSCORE', tg.KEY.pingDue, '-inf', String(now), 'LIMIT', '0', '500']).catch(() => [])) || [];
        if (!due.length) return;
        const alive = [];
        for (const item of due) {
            const [code, uid] = String(item).split('|');
            // 已經不在這一團（退團、被移出、解散、到期）：不再送
            if (!code || !uid || (await d.cmd(['GET', tg.KEY.of(uid)])) !== code) { await d.cmd(['ZREM', tg.KEY.pingDue, item]); continue; }
            alive.push({ item, uid, code });
        }
        if (alive.length) await d.push(alive.map((a) => a.uid), '', '', { type: 'tgroup_ping' }, { silent: true });
        if (alive.length) await d.pipe(alive.map((a) => ['ZADD', tg.KEY.pingDue, String(now + tg.PING_EVERY_MS), a.item]));
    }

    /** 每分鐘：行程表上 15 分鐘後的集合點提醒該組的人（同一個時間已經有集合呼叫就不重複） */
    async function remindStops(now) {
        const due = (await d.cmd(['ZRANGEBYSCORE', tg.KEY.stopDue, '-inf', String(now), 'LIMIT', '0', '200']).catch(() => [])) || [];
        for (const item of due) {
            await d.cmd(['ZREM', tg.KEY.stopDue, item]);
            const [code, id] = String(item).split('|');
            try {
                const [g, stops, call] = await Promise.all([load(code), json(tg.KEY.stops(code)), json(tg.KEY.call(code))]);
                if (!g || !tg.isOpen(g, now)) continue;
                const stop = (stops || []).find((x) => x.id === id);
                // 已經刪掉、時間過了、或提醒排得太晚（例如伺服器停擺）就不送
                if (!stop || now >= stop.at || stop.at - now > tg.PRE_REMIND_MS + 60 * 1000) continue;
                if (call && tg.callLive(call, now) && Math.abs(call.at - stop.at) < 10 * 60 * 1000) continue;
                const targets = tg.targetUids(g, await members(code), stop.sub);
                if (targets.length) await push(targets, title(g), tg.callText({ at: stop.at, tz: stop.tz, place: stop.place }, now), { type: 'tgroup_stop', code, stopId: stop.id }, { urgent: true });
            } catch (e) {
                console.error(`[旅行團] ${code} 行程提醒失敗:`, e);
            }
        }
    }

    /** 每分鐘：集合前 15 分鐘提醒一次；還沒按「收到」的人再提醒（每 60 秒、最多 3 次）；集合時間過 30 分鐘就收起來 */
    async function remind() {
        const now = clock();
        try { await pingIdle(now); } catch (e) { console.error('[旅行團] 無聲推播失敗:', e); }
        try { await remindStops(now); } catch (e) { console.error('[旅行團] 行程提醒失敗:', e); }
        const codes = (await d.cmd(['SMEMBERS', tg.KEY.activeCalls])) || [];
        for (const code of codes) {
            try {
                const [g, call] = await Promise.all([load(code), json(tg.KEY.call(code))]);
                if (!g || !call || !tg.callLive(call, now)) { await d.cmd(['SREM', tg.KEY.activeCalls, code]); continue; }
                const list = (await members(code)).filter((m) => !tg.isStaff(g, m.uid)).map((m) => m.uid);
                if (tg.preRemindDue(call, now)) {
                    // 集合前 15 分鐘：這次集合的對象全部再響一次（按過「收到」的也會）
                    const targets = call.targets && call.targets.length ? list.filter((u) => call.targets.includes(u)) : list;
                    call.pre = now;
                    await d.cmd(['SET', tg.KEY.call(code), JSON.stringify(call), 'EX', String(Math.max(60, Math.ceil((call.at + tg.CALL_LINGER_MS - now) / 1000)))]);
                    if (targets.length) await push(targets, title(g), tg.callText(call, now), { type: 'tgroup_call', code, callId: call.id, pre: '1' }, { urgent: true });
                    continue;
                }
                const acks = hashOf(await d.cmd(['HGETALL', tg.KEY.acks(code)]));
                const due = tg.dueReminders(call, list, acks, now);
                if (!due.length) continue;
                await push(due, title(g), `再提醒一次：${tg.callText(call, now)}`, { type: 'tgroup_call', code, callId: call.id }, { urgent: true });
                for (const u of due) call.remind[u] = (call.remind[u] || 0) + 1;
                call.lastRemindAt = now;
                await d.cmd(['SET', tg.KEY.call(code), JSON.stringify(call), 'EX', String(Math.max(60, Math.ceil((call.at + tg.CALL_LINGER_MS - now) / 1000)))]);
            } catch (e) {
                console.error(`[旅行團] ${code} 提醒失敗:`, e);
            }
        }
    }

    return { handle, remind, statusView, pingIdle, remindStops };
}

module.exports = { create, HOST_ONLY, STAFF_ONLY };
