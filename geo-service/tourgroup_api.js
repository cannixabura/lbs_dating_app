// ============================================================================
// 旅行團（TourChip）API：HTTP、Redis、推播。純函式在 tourgroup.js。
// index.js 只負責把共用的工具（Redis、驗證、推播、內容過濾、內購驗證）傳進來：
//   const tour = require('./tourgroup_api').create({ ... });
//   exports.tourGroup = onRequest(..., (req, res) => cors(req, res, () => tour.handle(req, res)));
//   exports.remindTourGroups = onSchedule("every 1 minutes", tour.remind);
//
// 角色：host（團主）、cohost（共同團主，最多 2 位）、member（團員）
//   團主與共同團主：call / ping（單獨再叫一次）/ call_done / rollcall / roll_done / announce / note / assign / subs / stop_add / stop_remove / kick / rotate_qr / found
//   只有團主：cohost_add / cohost_remove / handoff / dissolve / verify / redeem
//   團員：join / seen / ack / answer / lost / found（自己）/ leave
//   所有人：status；不必在團裡：create / join / buy_voucher / vouchers
// 團員的位置不會給團主；集合點是團主放的座標；「我迷路了」是團員自己按下才傳一次。
// ============================================================================

const tg = require('./tourgroup');

const COLOR_DOT = { violet: '🟣', pink: '🩷', blue: '🔵', teal: '🩵', green: '🟢', gold: '🟡', orange: '🟠', red: '🔴' };
const HOST_ONLY = ['cohost_add', 'cohost_remove', 'handoff', 'dissolve', 'verify', 'redeem'];
const STAFF_ONLY = ['call', 'ping', 'call_done', 'rollcall', 'roll_done', 'announce', 'note', 'assign', 'subs', 'stop_add', 'stop_remove', 'kick', 'rotate_qr'];

/**
 * @param {object} d
 * @param {(cmd: any[]) => Promise<any>} d.cmd                Redis 單一指令
 * @param {(cmds: any[][]) => Promise<any[]>} d.pipe          Redis pipeline
 * @param {(req) => Promise<string|null>} d.verifyCaller       Firebase ID token → uid
 * @param {(text: string) => boolean} d.isDisallowed           內容過濾
 * @param {(uids, title, body, data, opts) => Promise<number>} d.push  推播（opts.urgent：時效性通知與專屬音效）
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
    const hashOf = (flat) => { const o = {}; for (let i = 0; i < (flat || []).length; i += 2) o[flat[i]] = flat[i + 1]; return o; };
    const ttlFor = (g, now) => String(Math.max(60, Math.ceil((g.endsAt + 86400000 - now) / 1000)));

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
        await d.pipe([
            ['DEL', tg.KEY.group(code), tg.KEY.members(code), tg.KEY.call(code), tg.KEY.acks(code), tg.KEY.roll(code), tg.KEY.answers(code), tg.KEY.lost(code), tg.KEY.ann(code), tg.KEY.stops(code)],
            ['SREM', tg.KEY.activeCalls, code],
            ...list.map((m) => ['DEL', tg.KEY.of(m.uid)]),
        ]);
    }

    /** 行程表改變後重算結束時間（最後一個集合點的當地時區），同步更新所有 key 的存活時間 */
    async function resetEnds(code, g, stops, list, now) {
        const endsAt = tg.computeEndsAt(g, stops);
        if (endsAt === g.endsAt) return g;
        const next = { ...g, endsAt };
        const ttl = ttlFor(next, now);
        await save(code, next, now);
        await d.pipe([
            ['EXPIRE', tg.KEY.members(code), ttl], ['EXPIRE', tg.KEY.stops(code), ttl], ['EXPIRE', tg.KEY.ann(code), ttl],
            ...list.map((m) => ['EXPIRE', tg.KEY.of(m.uid), ttl]),
        ]);
        return next;
    }

    async function vouchersOf(uid) {
        const codes = (await d.cmd(['SMEMBERS', tg.KEY.vouchersOf(uid)])) || [];
        const rows = await Promise.all(codes.map(async (v) => ({ code: v, ...((await json(tg.KEY.voucher(v))) || {}) })));
        return rows.filter((r) => r.createdAt).map((r) => ({ code: r.code, link: tg.voucherLink(r.code), createdAt: r.createdAt, used: !!r.usedBy, usedAt: r.usedAt || null }))
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
        const [list, call, roll, acksFlat, answersFlat, lostFlat, ann, stops] = await Promise.all([
            members(code), json(tg.KEY.call(code)), json(tg.KEY.roll(code)),
            d.cmd(['HGETALL', tg.KEY.acks(code)]), d.cmd(['HGETALL', tg.KEY.answers(code)]), d.cmd(['HGETALL', tg.KEY.lost(code)]),
            json(tg.KEY.ann(code)), json(tg.KEY.stops(code)),
        ]);
        const acks = hashOf(acksFlat), answers = hashOf(answersFlat), lostHash = hashOf(lostFlat);
        const me = list.find((m) => m.uid === uid);
        const role = tg.roleOf(g, uid);
        const staff = role !== 'member';
        const nicks = await d.pipe(list.map((m) => ['HGET', `user_data:${m.uid}`, 'nickname'])).catch(() => []);
        const nameOf = (u) => nicks[list.findIndex((m) => m.uid === u)] || '';
        const mySub = me ? me.sub ?? null : null;
        const forMe = (x) => staff || !x || x.sub === null || x.sub === undefined || x.sub === mySub;
        const view = {
            code, name: g.name, color: g.color, tz: g.tz, startDate: g.startDate, endDate: g.endDate, endsAt: g.endsAt,
            paid: !!g.paid, limit: tg.memberLimit(g), count: list.length, subs: g.subs || [],
            role, myNo: me ? me.no : null, mySub, hostName: nameOf(g.host),
            staff: [g.host, ...(g.cohosts || [])].map((u) => ({ uid: u, no: (list.find((m) => m.uid === u) || {}).no ?? 0, name: nameOf(u), role: u === g.host ? 'host' : 'cohost' })),
            call: tg.callLive(call, now) && forMe(call) ? { id: call.id, at: call.at, tz: call.tz, place: call.place, lat: call.lat, lng: call.lng, sub: call.sub, mine: acks[uid] || null } : null,
            roll: roll && forMe(roll) ? { id: roll.id, sentAt: roll.sentAt, sub: roll.sub, mine: answers[uid] || null } : null,
            announcements: tg.visibleAnnouncements(ann || [], mySub, staff),
            stops: (stops || []).filter((s) => forMe(s)),
            lostSent: tg.lostRoster(list.filter((m) => m.uid === uid), lostHash, now).length > 0,
        };
        if (staff) {
            view.qr = tg.groupLink(code, g.qrVer);
            const others = list.filter((m) => !tg.isStaff(g, m.uid)).map((m) => ({ uid: m.uid, no: m.no, note: m.note || '', sub: m.sub ?? null, name: nameOf(m.uid) }));
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
        const fail = (code, status = 200) => res.status(status).json({ success: false, code });
        const ok = async (extra = {}) => res.status(200).json({ success: true, ...(await statusView(uid, now)), ...extra });

        // 內購（7 天方案、團購券）共用的驗證
        async function verifyPurchase(p) {
            if (p.platform === 'apple') return tg.applePass(d.verifyAppleJws(p.data), tg.BUNDLE_ID);
            if (p.platform === 'google' && typeof p.token === 'string') return tg.googlePass(p.productId, d.receiptKey('google', p.token), await d.playPurchase(p.productId, p.token, tg.PLAY_PACKAGE));
            throw new Error('bad_request');
        }

        try {
            if (action === 'status') return ok();

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
                    ['SET', tg.KEY.voucher(v), JSON.stringify(tg.makeVoucher(uid, grant.receipt, now)), 'EX', String(tg.VOUCHER_TTL_DAYS * 86400)],
                    ['SADD', tg.KEY.vouchersOf(uid), v],
                    ['EXPIRE', tg.KEY.vouchersOf(uid), String(tg.VOUCHER_TTL_DAYS * 86400)],
                ]);
                return res.status(200).json({ success: true, result: 'granted', voucher: v, vouchers: await vouchersOf(uid) });
            }

            if (action === 'create') {
                if (await d.cmd(['GET', tg.KEY.of(uid)])) return fail('in_group');
                const made = tg.makeGroup({ host: uid, name: body.name, color: body.color, days: body.days, tz: body.tz }, now);
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
                    if (check.code === 'full') await d.push([g.host], title(g), '第 21 位團員正在等待入團，升級 7 天方案或使用團購券後就能加入。', { type: 'tgroup_full', code }).catch(() => 0);
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
                await d.push(targets, title(g), tg.callText(made.call, now), { type: 'tgroup_call', code, callId: made.call.id }, { urgent: true });
                return ok();
            }

            // 單獨呼叫：只對這一個人再送一次集合呼叫（或點名）
            if (action === 'ping') {
                const target = String(body.uid || '');
                const list = await members(code);
                if (!list.some((m) => m.uid === target) || tg.isStaff(g, target)) return fail('bad_request');
                const [call, roll] = await Promise.all([json(tg.KEY.call(code)), json(tg.KEY.roll(code))]);
                if (call && tg.callLive(call, now)) {
                    await d.push([target], title(g), tg.callText(call, now), { type: 'tgroup_call', code, callId: call.id }, { urgent: true });
                } else if (roll) {
                    await d.push([target], title(g), '點名：到了請按「我到了」', { type: 'tgroup_roll', code, rollId: roll.id }, { urgent: true });
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
                await d.push(targets, title(g), '點名：到了請按「我到了」', { type: 'tgroup_roll', code, rollId: roll.id }, { urgent: true });
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
                    await d.push([g.host, ...(g.cohosts || [])], title(g), `${me ? me.no : '?'} 號需要幫忙`, { type: 'tgroup_help', code }, { urgent: true });
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
                await d.push(targets, title(g), made.ann.text, { type: 'tgroup_ann', code });
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
                    ]);
                } else if (action === 'cohost_add') {
                    const r = tg.addCohost(g, target, list);
                    if (!r.ok) return fail(r.code);
                    await save(code, r.group, now);
                    await d.pipe([['HDEL', tg.KEY.acks(code), target], ['HDEL', tg.KEY.answers(code), target]]);
                    await d.push([target], title(g), '你成為這一團的共同團主了，可以發集合、點名和公告。', { type: 'tgroup_role', code });
                } else if (action === 'cohost_remove') {
                    await save(code, tg.removeCohost(g, target), now);
                } else {
                    // 交棒：團主交給這位成員；原團主留在團裡當共同團主（名額滿了就當團員）
                    const hostRow = list.find((x) => x.uid === g.host) || { joinedAt: now };
                    let cohosts = (g.cohosts || []).filter((u) => u !== target);
                    if (cohosts.length < tg.MAX_COHOSTS) cohosts = [...cohosts, g.host];
                    await save(code, { ...g, host: target, cohosts }, now);
                    await d.pipe([putMember(code, target, { ...m, no: 0 }), putMember(code, g.host, { ...hostRow, no: m.no || tg.nextNumber(list) })]);
                    await d.push([target], title(g), '你成為這一團的團主了。', { type: 'tgroup_role', code });
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
                await d.cmd(['SET', tg.KEY.stops(code), JSON.stringify(up.stops), 'EX', ttlFor(g2, now)]);
                return ok();
            }

            if (action === 'stop_remove') {
                const stops = tg.removeStop(await json(tg.KEY.stops(code)), String(body.id || ''));
                const g2 = await resetEnds(code, g, stops, await members(code), now);
                await d.cmd(['SET', tg.KEY.stops(code), JSON.stringify(stops), 'EX', ttlFor(g2, now)]);
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
                await d.push([g.host, ...(g.cohosts || [])], title(g), `${me ? me.no : '?'} 號迷路了，傳來了目前的位置`, { type: 'tgroup_lost', code }, { urgent: true });
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
                ]);
                return res.status(200).json({ success: true, group: null });
            }

            if (action === 'dissolve') {
                const list = await members(code);
                await destroy(code, list);
                await d.push(list.filter((m) => m.uid !== uid).map((m) => m.uid), title(g), '這一團已經解散，謝謝這幾天一起同行。', { type: 'tgroup_end', code });
                return res.status(200).json({ success: true, group: null });
            }

            if (action === 'verify') {
                // 7 天方案：一次購買＝目前帶的這一團付費到解散
                let grant;
                try { grant = await verifyPurchase(body.purchase || {}); } catch (e) { console.warn('tour pass verify failed:', e.message); return fail(e.message); }
                const claim = await d.db().ref(`tourPassReceipts/${grant.receipt}`).transaction((cur) => (cur == null || cur === code ? code : undefined));
                if (!claim.committed) return fail('used');
                if (!g.paid) await save(code, { ...g, paid: true }, now);
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
                await save(code, { ...g, paid: true }, now);
                return ok({ result: 'granted' });
            }

            return res.status(400).json({ success: false, error: d.localize(lang, '未知的操作') });
        } catch (error) {
            console.error('tourGroup failed:', error);
            return res.status(500).json({ success: false, code: 'busy' });
        }
    }

    /** 每分鐘：集合呼叫還沒按「收到」的人再提醒（每 60 秒、最多 3 次）；集合時間過 30 分鐘就收起來 */
    async function remind() {
        const now = clock();
        const codes = (await d.cmd(['SMEMBERS', tg.KEY.activeCalls])) || [];
        for (const code of codes) {
            try {
                const [g, call] = await Promise.all([load(code), json(tg.KEY.call(code))]);
                if (!g || !call || !tg.callLive(call, now)) { await d.cmd(['SREM', tg.KEY.activeCalls, code]); continue; }
                const list = (await members(code)).filter((m) => !tg.isStaff(g, m.uid)).map((m) => m.uid);
                const acks = hashOf(await d.cmd(['HGETALL', tg.KEY.acks(code)]));
                const due = tg.dueReminders(call, list, acks, now);
                if (!due.length) continue;
                await d.push(due, title(g), `再提醒一次：${tg.callText(call, now)}`, { type: 'tgroup_call', code, callId: call.id }, { urgent: true });
                for (const u of due) call.remind[u] = (call.remind[u] || 0) + 1;
                call.lastRemindAt = now;
                await d.cmd(['SET', tg.KEY.call(code), JSON.stringify(call), 'EX', String(Math.max(60, Math.ceil((call.at + tg.CALL_LINGER_MS - now) / 1000)))]);
            } catch (e) {
                console.error(`[旅行團] ${code} 提醒失敗:`, e);
            }
        }
    }

    return { handle, remind, statusView };
}

module.exports = { create, HOST_ONLY, STAFF_ONLY };
