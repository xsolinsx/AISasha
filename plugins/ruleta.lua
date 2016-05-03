-- safe
local good = {
    "Ti è andata bene.",
    "Fiuu.",
    "Per poco.",
    "Ritenta, sarai più fortunato.",
    "Ancora ancora.",
    "Fortunello.",
    "Gioca di nuovo.",
    "Mancato.",
}
-- safe ruletagod
local godgood = {
    "Maledetto.",
    "Ma quanto culo hai?",
    "Mi riprenderò quei punti.",
    "Non hai le palle di rifarlo.",
    "No io non ci posso credere.",
}
-- killed
local bad = {
    "BOOM!",
    "Headshot.",
    "BANG!",
    "Bye Bye.",
    "Allahuakbar.",
    "Muori idiota.",
}

local function bubbleSortScore(users)
    local itemCount = #ids
    local hasChanged
    local t = { }
    local i = 0
    for v in users do
        i = i + 1
        t[i] = v
    end
    repeat
        hasChanged = false
        itemCount = itemCount - 1
        for k in t do
            if users[t[k]].score > users[t[k + 1]].score then
                users[t[k]].score, users[t[k + 1]].score = users[t[k + 1]].score, users[t[k]].score
                hasChanged = true
            end
        end
    until hasChanged == false
end

local function get_challenge(chat_id)
    local Whashonredis = redis:get('ruleta:' .. chat_id .. ':challenger')
    local Xhashonredis = redis:get('ruleta:' .. chat_id .. ':challenged')
    local Yhashonredis = redis:get('ruleta:' .. chat_id .. ':accepted')
    local Zhashonredis = redis:get('ruleta:' .. chat_id .. ':rounds')
    if Whashonredis and Xhashonredis and Yhashonredis and Zhashonredis then
        return { Whashonredis, Xhashonredis, Yhashonredis, Zhashonredis }
    end
    return false
end

local function start_challenge(challenger_id, challenged_id, challenger, challenged, chat_id)
    local channel = 'channel#id' .. chat_id
    local chat = 'chat#id' .. chat_id

    if get_challenge(chat_id) and tonumber(get_challenge(chat_id)[3]) == 1 then
        send_large_msg(chat, lang_text('errorOngoingChallenge'))
        send_large_msg(channel, lang_text('errorOngoingChallenge'))
    else
        redis:set('ruleta:' .. chat_id .. ':challenger', challenger_id)
        redis:set('ruleta:' .. chat_id .. ':challenged', challenged_id)
        redis:set('ruleta:' .. chat_id .. ':accepted', 0)
        redis:set('ruleta:' .. chat_id .. ':rounds', 0)
        redis:set('ruletachallenge:' .. chat_id .. ':player', challenger_id)
        redis:set('ruletachallenger:' .. chat_id, challenger)
        redis:set('ruletachallenged:' .. chat_id, challenged)
        send_large_msg(chat, lang_text('challengeSet'))
        send_large_msg(channel, lang_text('challengeSet'))
    end
end

local function reject_challenge(challenged_id, chat_id)
    local var = false
    if redis:get('ruleta:' .. chat_id .. ':challenged') == challenged_id then
        var = true
    end
    if is_momod( { from = { id = challenged_id }, to = { id = chat_id } }) then
        var = true
    end
    if our_id == challenged_id then
        var = true
    end

    if var then
        redis:del('ruleta:' .. chat_id .. ':challenger')
        redis:del('ruleta:' .. chat_id .. ':challenged')
        redis:del('ruleta:' .. chat_id .. ':accepted')
        redis:del('ruleta:' .. chat_id .. ':rounds')
        redis:del('ruletachallenge:' .. chat_id .. ':player')
        redis:del('ruletachallenger:' .. chat_id)
        redis:del('ruletachallenged:' .. chat_id)
    end
end

local function Challenge_by_reply(extra, success, result)
    if tonumber(result.from.peer_id) == tonumber(our_id) then
        -- Ignore bot
        reply_msg(extra.msg.id, lang_text('cantChallengeYourself'), ok_cb, false)
        return
    end
    if tonumber(extra.challenger) == tonumber(result.from.peer_id) then
        reply_msg(extra.msg.id, lang_text('cantChallengeMe'), ok_cb, false)
        return
    end
    local challenger = ''
    local challenged = ''
    if extra.msg.from.username then
        challenger = '@' .. extra.msg.from.username
    else
        challenger = string.gsub(extra.msg.from.print_name, '_', ' ')
    end
    if result.from.username then
        challenged = '@' .. result.from.username
    else
        challenged = string.gsub(result.from.print_name, '_', ' ')
    end
    start_challenge(extra.challenger, result.from.peer_id, challenger, challenged, result.to.peer_id)
end

local function Challenge_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, lang_text('noUsernameFound'))
    end
    if tonumber(result.peer_id) == tonumber(our_id) then
        -- Ignore bot
        reply_msg(extra.msg.id, lang_text('cantChallengeMe'), ok_cb, false)
        return
    end
    if tonumber(extra.msg.from.id) == tonumber(result.peer_id) then
        reply_msg(extra.msg.id, lang_text('cantChallengeYourself'), ok_cb, false)
        return
    end
    local challenger = ''
    local challenged = ''
    if extra.msg.from.username then
        challenger = '@' .. extra.msg.from.username
    else
        challenger = string.gsub(extra.msg.from.print_name, '_', ' ')
    end
    if result.username then
        challenged = '@' .. result.username
    else
        challenged = string.gsub(result.print_name, '_', ' ')
    end
    start_challenge(extra.challenger, result.peer_id, challenger, challenged, extra.chat_id)
end

local function callback_id(cb_extra, success, result)
    local text = result.print_name:gsub("_", " ")
    send_large_msg('chat#id' .. cb_extra.msg.to.id, text)
    send_large_msg('channel#id' .. cb_extra.msg.to.id, text)
end

local function kick_user(user_id, chat_id)
    local chat = 'chat#id' .. chat_id
    local user = 'user#id' .. user_id
    local channel = 'channel#id' .. chat_id
    chat_del_user(chat, user, ok_cb, true)
    channel_kick(channel, user, ok_cb, true)
end

local function kickrandom_chat(cb_extra, success, result)
    local chat_id = cb_extra.chat_id
    local kickable = false
    local id
    while not kickable do
        id = result.members[math.random(#result.members)].id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, chat_id) or is_whitelisted(id)) then
            kickable = true
            send_large_msg('chat#id' .. chat_id, 'ℹ️ ' .. id .. ' ' .. lang_text('kicked'))
            kick_user(id, chat_id)
        else
            print('403')
        end
    end
end

local function kickrandom_channel(extra, success, result)
    local chat_id = extra.chat_id
    local kickable = false
    local id
    while not kickable do
        id = result[math.random(#result)].id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, chat_id) or is_whitelisted(id)) then
            kickable = true
            send_large_msg('channel#id' .. result.id, 'ℹ️ ' .. id .. ' ' .. lang_text('kicked'))
            kick_user(id, result.id)
        else
            print('403')
        end
    end
end

local function run(msg, matches)
    if msg.to.type ~= 'user' then
        if matches[1]:lower() == 'kick' or matches[1]:lower() == 'sasha uccidi' or matches[1]:lower() == 'uccidi' or matches[1]:lower() == 'spara' then
            if is_momod(msg) then
                if msg.to.type == 'chat' then
                    local chat = 'chat#id' .. msg.to.id
                    chat_info(chat, kickrandom_chat, { chat_id = msg.to.id })
                elseif msg.to.type == 'channel' then
                    local channel = 'channel#id' .. msg.to.id
                    channel_get_users(channel, kickrandom_channel, { chat_id = msg.to.id })
                end
                return
            else
                return lang_text('require_mod')
            end
        end
        -- RULETA
        if matches[1]:lower() == 'createdb' then
            if is_sudo(msg) then
                local f = io.open(_config.ruleta.db, 'w+')
                f:write('{"groups":{},"users":{},"challenges":{}}')
                f:close()
                reply_msg(msg.id, lang_text('ruletadbCreated'), ok_cb, false)
            else
                return lang_text('require_sudo')
            end
            return
        end

        local chat = tostring(msg.to.id)
        local user = tostring(msg.from.id)
        local ruletadata = load_data(_config.ruleta.db)

        if matches[1]:lower() == 'registergroup' or matches[1]:lower() == 'registragruppo' then
            if is_admin1(msg) then
                if ruletadata['groups'][chat] then
                    reply_msg(msg.id, lang_text('groupAlreadySignedUp'), ok_cb, false)
                else
                    ruletadata['groups'][chat] = {
                        cylinder = tonumber(6),
                        challengecylinder = tonumber(6),
                        caps = tonumber(1),
                        challengecaps = tonumber(1),
                    }
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('groupSignedUp'), ok_cb, false)
                end
            else
                return lang_text('require_admin')
            end
            return
        end

        local groupstats = ruletadata['groups'][chat]

        if not groupstats then
            reply_msg(msg.id, lang_text('requireGroupSignUp'), ok_cb, false)
            return
        end

        if (matches[1]:lower() == 'leaderboard' or matches[1]:lower() == 'classifica') and matches[2] then
            if matches[2]:lower() == 'score' or matches[2]:lower() == 'punti' then
                bubbleSortScore(ruletadata['users'])
                local text = lang_text('scoreLeaderboard')
                local i = 0
                for k, v in ruletadata['users'] do
                    i = i + 1
                    text = text .. i .. '. ' .. k .. v.score
                end
                reply_msg(msg.id, text, ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'deletegroup' or matches[1]:lower() == 'eliminagruppo' then
            if is_admin1(msg) then
                ruletadata['groups'][chat] = false
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, lang_text('ruletaGroupDeleted'), ok_cb, false)
            else
                return lang_text('require_admin')
            end
            return
        end

        if matches[1]:lower() == 'registerme' or matches[1]:lower() == 'registrami' then
            if ruletadata['users'][user] then
                reply_msg(msg.id, lang_text('alreadySignedUp'), ok_cb, false)
            else
                ruletadata['users'][user] = {
                    attempts = tonumber(0),
                    score = tonumber(0),
                    deaths = tonumber(0),
                    duels = tonumber(0),
                    wonduels = tonumber(0),
                    lostduels = tonumber(0),
                    actualstreak = tonumber(0),
                    longeststreak = tonumber(0),
                }
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, lang_text('signedUp'), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'ruletainfo' then
            local info = lang_text('cylinderCapacity') .. groupstats.cylinder .. '\n' ..
            lang_text('capsNumber') .. groupstats.caps .. '\n' ..
            lang_text('challengeCylinderCapacity') .. groupstats.challengecylinder .. '\n' ..
            lang_text('challengeCapsNumber') .. groupstats.challengecaps .. '\n'
            return info
        end

        if matches[1]:lower() == 'setcaps' and matches[2] then
            if is_momod(msg) then
                if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.cylinder then
                    ruletadata['groups'][chat].caps = matches[2]
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('capsChanged') .. tonumber(matches[2]), ok_cb, false)
                else
                    reply_msg(msg.id, lang_text('errorCapsRange'):gsub('X', groupstats.cylinder - 1), ok_cb, false)
                end
            else
                return lang_text('require_mod')
            end
            return
        end

        if matches[1]:lower() == 'setchallengecaps' and matches[2] then
            if is_momod(msg) then
                if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.challengecylinder then
                    ruletadata['groups'][chat].challengecaps = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('challengeCapsChanged') .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, lang_text('errorCapsRange'):gsub('X', groupstats.challengecylinder - 1), ok_cb, false)
                end
            else
                return lang_text('require_mod')
            end
            return
        end

        if matches[1]:lower() == 'setcylinder' and matches[2] then
            if is_owner(msg) then
                if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                    ruletadata['groups'][chat].cylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('cylinderChanged') .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, lang_text('errorCylinderRange'), ok_cb, false)
                end
            else
                return lang_text('require_owner')
            end
            return
        end

        if matches[1]:lower() == 'setchallengecylinder' and matches[2] then
            if is_owner(msg) then
                if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                    ruletadata['groups'][chat].challengecylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('challengeCylinderChanged') .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, lang_text('errorCylinderRange'), ok_cb, false)
                end
            else
                return lang_text('require_owner')
            end
            return
        end

        local userstats = ruletadata['users'][user]

        if not userstats then
            reply_msg(msg.id, lang_text('requireSignUp'), ok_cb, false)
            return
        end

        if matches[1]:lower() == 'deleteme' or matches[1]:lower() == 'eliminami' then
            if userstats.score >= 0 then
                ruletadata['users'][user] = false
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, lang_text('ruletaDeleted'), ok_cb, false)
            else
                reply_msg(msg.id, lang_text('requireZeroPoints'), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'mystats' or matches[1]:lower() == 'punti' then
            local stats = lang_text('attempts') .. userstats.attempts .. '\n' ..
            lang_text('score') .. userstats.score .. '\n' ..
            lang_text('deaths') .. userstats.deaths .. '\n' ..
            lang_text('duels') .. userstats.duels .. '\n' ..
            lang_text('wonduels') .. userstats.wonduels .. '\n' ..
            lang_text('lostduels') .. userstats.lostduels .. '\n' ..
            lang_text('actualstreak') .. userstats.actualstreak .. '\n' ..
            lang_text('longeststreak') .. userstats.longeststreak
            reply_msg(msg.id, stats, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'godruleta' then
            if userstats.score > 10 then
                userstats.attempts = tonumber(userstats.attempts + 1)
                userstats.actualstreak = tonumber(userstats.actualstreak + 1)
                if userstats.actualstreak > userstats.longeststreak then
                    userstats.longeststreak = tonumber(userstats.actualstreak)
                end

                if math.random(1, 2) == math.random(1, 2) then
                    reply_msg(msg.id, bad[math.random(#bad)], ok_cb, false)

                    userstats.score = tonumber(0)
                    userstats.deaths = tonumber(userstats.deaths + 1)
                    userstats.actualstreak = tonumber(0)
                    ruletadata['users'][user] = userstats

                    save_data(_config.ruleta.db, ruletadata)
                    kick_user(user, chat)
                else
                    reply_msg(msg.id, godgood[math.random(#godgood)], ok_cb, false)

                    userstats.score = tonumber(userstats.score + 70)
                    ruletadata['users'][user] = userstats

                    save_data(_config.ruleta.db, ruletadata)
                end
            else
                reply_msg(msg.id, lang_text('requirePoints'), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'challenge' or matches[1]:lower() == 'sfida' then
            if type(msg.reply_id) ~= "nil" then
                get_message(msg.reply_id, Challenge_by_reply, { challenger = user, msg = msg })
            elseif matches[2] then
                resolve_username(matches[2]:gsub("@", ""), Challenge_by_username, { challenger = user, chat_id = chat, msg = msg })
            end
            return
        end

        local challenge = get_challenge(msg.to.id)
        local challenger
        local challenged
        local accepted
        local rounds
        if challenge then
            challenger = challenge[1]
            challenged = challenge[2]
            accepted = tonumber(challenge[3])
            rounds = tonumber(challenge[4])
        end

        if matches[1]:lower() == 'challengeinfo' then
            if challenge then
                local text = lang_text('challenge') .. '\n' ..
                lang_text('challenger') .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
                lang_text('challenged') .. redis:get('ruletachallenged:' .. chat) .. '\n'
                if accepted == 0 then
                    text = text .. lang_text('notAccepted') .. '\n'
                elseif accepted == 1 then
                    text = text .. lang_text('accepted') .. '\n'
                end
                text = text .. lang_text('roundsLeft') .. rounds
                reply_msg(msg.id, text, ok_cb, false)
            else
                reply_msg(msg.id, lang_text('noChallenge'), ok_cb, false)
            end
            return
        end

        if (matches[1]:lower() == 'accept' or matches[1]:lower() == 'accetta') and challenge and accepted == 0 then
            local text = lang_text('challenger') .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
            lang_text('challenged') .. redis:get('ruletachallenged:' .. chat)
            if redis:get('ruleta:' .. chat .. ':challenged') == user then
                redis:set('ruleta:' .. chat .. ':accepted', 1)
                redis:set('ruleta:' .. chat .. ':rounds', groupstats.challengecylinder)
                ruletadata['users'][challenger].duels = tonumber(ruletadata['users'][challenger].duels + 1)
                ruletadata['users'][challenged].duels = tonumber(ruletadata['users'][challenged].duels + 1)
                save_data(_config.ruleta.db, ruletadata)
            else
                text = lang_text('wrongPlayer')
            end
            reply_msg(msg.id, text, ok_cb, false)
            return
        end

        if (matches[1]:lower() == 'reject' or matches[1]:lower() == 'rifiuta') and challenge then
            if (user == challenger or user == challenged) then
                if user == challenged and accepted == 0 then
                    reply_msg(msg.id, lang_text('challengeRejected'), ok_cb, false)
                elseif is_momod(msg) then
                    reply_msg(msg.id, lang_text('challengeModTerminated'), ok_cb, false)
                elseif accepted == 1 then
                    reply_msg(msg.id, lang_text('challengeEnd'), ok_cb, false)
                    if user == challenger then
                        if tonumber(ruletadata['users'][challenger].score) -20 < 0 then
                            ruletadata['users'][challenger].score = tonumber(0)
                        else
                            ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score - 20)
                        end
                        ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score + 20)
                        ruletadata['users'][challenger].lostduels = tonumber(ruletadata['users'][challenger].lostduels + 1)
                        ruletadata['users'][challenged].wonduels = tonumber(ruletadata['users'][challenged].wonduels + 1)
                    elseif user == challenged then
                        ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score + 20)
                        if tonumber(ruletadata['users'][challenged].score) -20 < 0 then
                            ruletadata['users'][challenged].score = tonumber(0)
                        else
                            ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score - 20)
                        end
                        ruletadata['users'][challenger].wonduels = tonumber(ruletadata['users'][challenger].wonduels + 1)
                        ruletadata['users'][challenged].lostduels = tonumber(ruletadata['users'][challenged].lostduels + 1)
                    end
                    save_data(_config.ruleta.db, ruletadata)
                    kick_user(user, chat)
                end
            elseif not is_momod(msg) then
                reply_msg(msg.id, lang_text('wrongPlayer'), ok_cb, false)
                return
            end
            reject_challenge(user, chat)
            return
        end

        if matches[1]:lower() == 'addpoints' and matches[2] and matches[3] and is_sudo(msg) then
            ruletadata['users'][matches[2]].score = tonumber(ruletadata['users'][matches[2]].score + matches[3])
            save_data(_config.ruleta.db, ruletadata)
            reply_msg(msg.id, lang_text('cheating'), ok_cb, false)
            return
        end

        if matches[1]:lower() == 'ruleta' then
            ruletadata['users'][user].attempts = tonumber(ruletadata['users'][user].attempts + 1)
            ruletadata['users'][user].actualstreak = tonumber(ruletadata['users'][user].actualstreak + 1)
            if tonumber(ruletadata['users'][user].actualstreak) > tonumber(ruletadata['users'][user].longeststreak) then
                ruletadata['users'][user].longeststreak = tonumber(ruletadata['users'][user].actualstreak)
            end

            if accepted == 1 and(user == challenger or user == challenged) and rounds > 0 then
                if user == redis:get('ruletachallenge:' .. chat .. ':player') then
                    local temp = tonumber(groupstats.challengecylinder) - rounds + 1
                    local nextplayeruser = ''
                    if user == challenger then
                        nextplayeruser = redis:get('ruletachallenged:' .. chat)
                        redis:set('ruletachallenge:' .. chat .. ':player', challenged)
                    elseif user == challenged then
                        nextplayeruser = redis:get('ruletachallenger:' .. chat)
                        redis:set('ruletachallenge:' .. chat .. ':player', challenger)
                    end
                    redis:set('ruleta:' .. chat .. ':rounds', rounds - 1)
                    print(temp)
                    if math.random(tonumber(groupstats.challengecaps), tonumber(groupstats.challengecylinder) - temp) == math.random(tonumber(groupstats.challengecaps), tonumber(groupstats.challengecylinder) - temp) then
                        -- bot destroy challenge on redis
                        reject_challenge(our_id, chat)
                        reply_msg(msg.id, lang_text('challengeEnd'), ok_cb, false)

                        ruletadata['users'][user].deaths = tonumber(ruletadata['users'][user].deaths + 1)
                        ruletadata['users'][user].actualstreak = tonumber(0)
                        local loserpoints = 0
                        if user == challenger then
                            if tonumber(ruletadata['users'][challenger].score) -20 < 0 then
                                loserpoints = tonumber(ruletadata['users'][challenger].score)
                                ruletadata['users'][challenger].score = tonumber(0)
                                ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score + loserpoints)
                            else
                                loserpoints = 20
                                ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score - loserpoints)
                                ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score + loserpoints)
                            end
                            ruletadata['users'][challenger].lostduels = tonumber(ruletadata['users'][challenger].lostduels + 1)
                            ruletadata['users'][challenged].wonduels = tonumber(ruletadata['users'][challenged].wonduels + 1)
                        elseif user == challenged then
                            if tonumber(ruletadata['users'][challenged].score) -20 < 0 then
                                loserpoints = tonumber(ruletadata['users'][challenged].score)
                                ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score + loserpoints)
                                ruletadata['users'][challenged].score = tonumber(0)
                            else
                                loserpoints = 20
                                ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score + loserpoints)
                                ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score - loserpoints)
                            end
                            ruletadata['users'][challenger].wonduels = tonumber(ruletadata['users'][challenger].wonduels + 1)
                            ruletadata['users'][challenged].lostduels = tonumber(ruletadata['users'][challenged].lostduels + 1)
                        end

                        save_data(_config.ruleta.db, ruletadata)
                        kick_user(user, chat)
                    else
                        -- blue red
                        -- 🔵    🔴
                        local shotted = ''
                        local notshotted = ''
                        for var = 1, tonumber(temp) do
                            shotted = shotted .. '🔴'
                            var = var + 1
                        end
                        for var = 1, tonumber(groupstats.challengecylinder - temp) do
                            notshotted = notshotted .. '🔵'
                            var = var + 1
                        end
                        reply_msg(msg.id, good[math.random(#good)] .. '\n' .. lang_text('shotsLeft') .. notshotted .. shotted .. '\n' .. nextplayeruser .. lang_text('yourTurn'), ok_cb, false)

                        ruletadata['users'][user].score = tonumber(ruletadata['users'][user].score + 1)

                        save_data(_config.ruleta.db, ruletadata)
                    end
                else
                    reply_msg(msg.id, lang_text('notYourTurn'), ok_cb, false)
                end
            else
                if math.random(tonumber(groupstats.caps), tonumber(groupstats.cylinder)) == math.random(tonumber(groupstats.caps), tonumber(groupstats.cylinder)) then
                    reply_msg(msg.id, bad[math.random(#bad)], ok_cb, false)

                    ruletadata['users'][user].deaths = tonumber(ruletadata['users'][user].deaths + 1)
                    ruletadata['users'][user].actualstreak = tonumber(0)

                    save_data(_config.ruleta.db, ruletadata)
                    kick_user(user, chat)
                else
                    reply_msg(msg.id, good[math.random(#good)], ok_cb, false)

                    ruletadata['users'][user].score = tonumber(ruletadata['users'][user].score + 1)

                    save_data(_config.ruleta.db, ruletadata)
                end
            end
            return
        end
    end
end

return {
    description = "RULETA",
    usage =
    {
        "Ruleta by AISasha, inspired from Leia (#RIP) and Arya. Ruleta è la roulette russa con la pistola, tamburo da tot colpi con tot proiettili al suo interno, si gira il tamburo e se c'è il proiettile sei fuori altrimenti rimani.",
        "#registerme|#registrami: Sasha registra l'utente alla roulette.",
        "#deleteme|#eliminami: Sasha elimina i dati dell'utente.",
        "#ruletainfo: Sasha manda le informazioni della roulette.",
        "#mystats|#punti: Sasha manda le statistiche dell'utente.",
        "#ruleta: Sasha cerca di ucciderti.",
        "#godruleta: Sasha ti dà il 50% di probabilità di guadagnare 70 punti, con l'altro 50% li perdi tutti (richiede almeno 11 punti).",
        "#challenge|#sfida <username>|<reply>: Sasha avvia una sfida tra il mittente e l'utente specificato.",
        "#accept|#accetta: Sasha conferma la sfida.",
        "#reject|#rifiuta: Sasha cancella la sfida.",
        "#challengeinfo: Sasha manda le informazioni della sfida in corso.",
        "MOD",
        "#setcaps <value>: Sasha mette <value> proiettili nel tamburo.",
        "#setchallengecaps <value>: Sasha mette <value> proiettili nel tamburo delle sfide.",
        "(#kick|spara|[sasha] uccidi) random: Sasha sceglie un utente a caso e lo rimuove.",
        "OWNER",
        "#setcylinder <value>: Sasha imposta un tamburo da <value> colpi nel range [5-10].",
        "#setchallengecylinder <value>: Sasha imposta un tamburo da <value> colpi per le sfide nel range [5-10].",
        "ADMIN",
        "#registergroup|#registragruppo: Sasha abilita il gruppo a giocare a ruleta.",
        "#deletegroup|#eliminagruppo: Sasha disabilita il gruppo per ruleta.",
        "SUDO",
        "#createdb: Sasha crea il database di ruleta.",
        "#addpoints <id> <value>: Sasha aggiunge <value> punti all'utente specificato.",
    },
    patterns =
    {
        "^[#!/]([Kk][Ii][Cc][Kk]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Dd][Bb])$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Ee][Rr][Gg][Rr][Oo][Uu][Pp])$",
        "^[#!/]([Dd][Ee][Ll][Ee][Tt][Ee][Gg][Rr][Oo][Uu][Pp])$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Ee][Rr][Mm][Ee])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Ss][Ee][Tt][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Dd][Ee][Ll][Ee][Tt][Ee][Mm][Ee])$",
        "^[#!/]([Mm][Yy][Ss][Tt][Aa][Tt][Ss])$",
        "^[#!/]?([Gg][Oo][Dd][Rr][Uu][Ll][Ee][Tt][Aa])$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee]) (.*)$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee])$",
        "^[#!/]([Aa][Cc][Cc][Ee][Pp][Tt])$",
        "^[#!/]([Rr][Ee][Jj][Ee][Cc][Tt])$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Aa][Dd][Dd][Pp][Oo][Ii][Nn][Tt][Ss]) (%d+) (%d+)$",
        "^[#!/]?([Rr][Uu][Ll][Ee][Tt][Aa])",
        -- registerme
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa][Mm][Ii])$",
        -- deleteme
        "^[#!/]([Ee][Ll][Ii][Mm][Ii][Nn][Aa][Mm][Ii])$",
        -- registergroup
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa][Gg][Rr][Uu][Pp][Pp][Oo])$",
        -- deletegroup
        "^[#!/]([Ee][Ll][Ii][Mm][Ii][Nn][Aa][Gg][Rr][Uu][Pp][Pp][Oo])$",
        -- challenge
        "^[#!/]([Ss][Ff][Ii][Dd][Aa]) (.*)$",
        "^[#!/]([Ss][Ff][Ii][Dd][Aa])$",
        -- accept
        "^[#!/]([Aa][Cc][Cc][Ee][Tt][Tt][Aa])$",
        -- reject
        "^[#!/]([Rr][Ii][Ff][Ii][Uu][Tt][Aa])$",
        -- mystats
        "^[#!/]([Pp][Uu][Nn][Tt][Ii])$",
        -- kick random
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Rr][Aa]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Ss][Pp][Aa][Rr][Aa]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
    },
    run = run,
    min_rank = 0
}