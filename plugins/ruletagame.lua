multiple_messages = { }

local function get_challenge(chat_id)
    local challenger_id = redis:get('ruleta:' .. chat_id .. ':challenger')
    local challenged_id = redis:get('ruleta:' .. chat_id .. ':challenged')
    local challenge_accepted = redis:get('ruleta:' .. chat_id .. ':accepted')
    local current_round = redis:get('ruleta:' .. chat_id .. ':rounds')
    if challenger_id and challenged_id and challenge_accepted and current_round then
        return { challenger_id, challenged_id, challenge_accepted, current_round }
    end
    return false
end

local function start_challenge(challenger_id, challenged_id, challenger, challenged, chat_id)
    local lang = get_lang(chat_id)
    local channel = 'channel#id' .. chat_id
    local chat = 'chat#id' .. chat_id

    if get_challenge(chat_id) and tonumber(get_challenge(chat_id)[3]) == 1 then
        send_large_msg(chat, langs[lang].errorOngoingChallenge)
        send_large_msg(channel, langs[lang].errorOngoingChallenge)
    else
        redis:set('ruleta:' .. chat_id .. ':challenger', challenger_id)
        redis:set('ruleta:' .. chat_id .. ':challenged', challenged_id)
        redis:set('ruleta:' .. chat_id .. ':accepted', 0)
        redis:set('ruleta:' .. chat_id .. ':rounds', 0)
        redis:set('ruletachallenge:' .. chat_id .. ':player', challenger_id)
        redis:set('ruletachallenger:' .. chat_id, challenger)
        redis:set('ruletachallenged:' .. chat_id, challenged)
        send_large_msg(chat, langs[lang].challengeSet:gsub('X', challenged))
        send_large_msg(channel, langs[lang].challengeSet:gsub('X', challenged))
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
    local lang = get_lang(string.match(get_receiver(extra.msg), '%d+'))
    if get_reply_receiver(result) == get_receiver(extra.msg) then
        local lang = get_lang(result.to.peer_id)
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            reply_msg(extra.msg.id, langs[lang].cantChallengeMe, ok_cb, false)
            return
        end
        if tonumber(extra.challenger) == tonumber(result.from.peer_id) then
            reply_msg(extra.msg.id, langs[lang].cantChallengeYourself, ok_cb, false)
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
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function Challenge_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    if tonumber(result.peer_id) == tonumber(our_id) then
        -- Ignore bot
        reply_msg(extra.msg.id, langs[lang].cantChallengeMe, ok_cb, false)
        return
    end
    if tonumber(extra.msg.from.id) == tonumber(result.peer_id) then
        reply_msg(extra.msg.id, langs[lang].cantChallengeYourself, ok_cb, false)
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

-- Returns a table with `name`
local function get_name(user_id)
    local user_info = { }
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    user_info.name = user_print_name(user):gsub('_', ' ')
    return user_info
end

local function leaderboards(users, lbtype, lang)
    local users_info = { }

    -- Get user name and param
    for k, user in pairs(users) do
        if user then
            local user_info = get_name(k)
            if lbtype == 'score' then
                user_info.param = tonumber(user.score)
            elseif lbtype == 'attempts' then
                user_info.param = tonumber(user.attempts)
            elseif lbtype == 'deaths' then
                user_info.param = tonumber(user.deaths)
            elseif lbtype == 'streak' then
                user_info.param = tonumber(user.longeststreak)
            elseif lbtype == 'challenges' then
                user_info.param = tonumber(user.duels)
            elseif lbtype == 'victories' then
                user_info.param = tonumber(user.wonduels)
            elseif lbtype == 'defeats' then
                user_info.param = tonumber(user.lostduels)
            else
                return langs[lang].opsError
            end
            table.insert(users_info, user_info)
        end
    end

    -- Sort users by param
    table.sort(users_info, function(a, b)
        if a.param and b.param then
            return a.param > b.param
        end
    end )

    local text = ''
    if lbtype == 'score' then
        text = langs[lang].scoreLeaderboard
    elseif lbtype == 'attempts' then
        text = langs[lang].attemptsLeaderboard
    elseif lbtype == 'deaths' then
        text = langs[lang].deathsLeaderboard
    elseif lbtype == 'streak' then
        text = langs[lang].streakLeaderboard
    elseif lbtype == 'challenges' then
        text = langs[lang].duelsLeaderboard
    elseif lbtype == 'victories' then
        text = langs[lang].victoriesLeaderboard
    elseif lbtype == 'defeats' then
        text = langs[lang].defeatsLeaderboard
    end
    local i = 0
    for k, user in pairs(users_info) do
        if user.name and user.param then
            if user.param > 0 then
                i = i + 1
                if user.param >= 1000 then
                    local j = 0
                    local mad = ''
                    local points = user.param
                    while points >= 1000 do
                        j = j + 1
                        points = points - 1000
                        mad = mad .. '☠'
                    end
                    text = text .. i .. '. ' .. user.name .. ' => ' .. mad .. ' ' .. tostring(tonumber(user.param) -(1000 * j)) .. '\n'
                else
                    text = text .. i .. '. ' .. user.name .. ' => ' .. user.param .. '\n'
                end
            end
        end
    end
    return text
end

local function run(msg, matches)
    if msg.to.type ~= 'user' then
        if matches[1]:lower() == 'createruletadb' then
            if is_sudo(msg) then
                local f = io.open(_config.ruleta.db, 'w+')
                f:write('{"groups":{},"users":{},"challenges":{}}')
                f:close()
                reply_msg(msg.id, langs[msg.lang].ruletadbCreated, ok_cb, false)
            else
                return langs[msg.lang].require_sudo
            end
            return
        end

        local chat = tostring(msg.to.id)
        local user = tostring(msg.from.id)
        local ruletadata = load_data(_config.ruleta.db)

        if matches[1]:lower() == 'registergroupruleta' or matches[1]:lower() == 'registra gruppo ruleta' then
            if is_admin1(msg) then
                if ruletadata['groups'][chat] then
                    reply_msg(msg.id, langs[msg.lang].groupAlreadySignedUp, ok_cb, false)
                else
                    ruletadata['groups'][chat] = {
                        cylinder = tonumber(6),
                        challengecylinder = tonumber(6),
                        caps = tonumber(1),
                        challengecaps = tonumber(1),
                    }
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, langs[msg.lang].groupSignedUp, ok_cb, false)
                end
            else
                return langs[msg.lang].require_admin
            end
            return
        end

        local groupstats = ruletadata['groups'][chat]

        if not groupstats then
            -- reply_msg(msg.id, langs[msg.lang].requireGroupSignUp, ok_cb, false)
            print('group not registered')
            return
        end

        if matches[1]:lower() == 'deletegroupruleta' or matches[1]:lower() == 'elimina gruppo ruleta' then
            if is_admin1(msg) then
                ruletadata['groups'][chat] = false
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, langs[msg.lang].ruletaGroupDeleted, ok_cb, false)
            else
                return langs[msg.lang].require_admin
            end
            return
        end

        if (matches[1]:lower() == 'leaderboard' or matches[1]:lower() == 'classifica') then
            local leaderboard = ''
            if not matches[2] then
                leaderboard = leaderboards(ruletadata['users'], 'score', msg.lang)
            elseif matches[2]:lower() == 'attempts' or matches[2]:lower() == 'tentativi' then
                leaderboard = leaderboards(ruletadata['users'], 'attempts', msg.lang)
            elseif matches[2]:lower() == 'deaths' or matches[2]:lower() == 'morti' then
                leaderboard = leaderboards(ruletadata['users'], 'deaths', msg.lang)
            elseif matches[2]:lower() == 'streak' or matches[2]:lower() == 'serie' then
                leaderboard = leaderboards(ruletadata['users'], 'streak', msg.lang)
            elseif matches[2]:lower() == 'challenges' or matches[2]:lower() == 'sfide' then
                leaderboard = leaderboards(ruletadata['users'], 'challenges', msg.lang)
            elseif matches[2]:lower() == 'victories' or matches[2]:lower() == 'vittorie' then
                leaderboard = leaderboards(ruletadata['users'], 'victories', msg.lang)
            elseif matches[2]:lower() == 'defeats' or matches[2]:lower() == 'sconfitte' then
                leaderboard = leaderboards(ruletadata['users'], 'defeats', msg.lang)
            end
            send_large_msg(get_receiver(msg), leaderboard)
            return
        end

        if matches[1]:lower() == 'registerme' or matches[1]:lower() == 'registrami' then
            if ruletadata['users'][user] then
                reply_msg(msg.id, langs[msg.lang].ruletaAlreadySignedUp, ok_cb, false)
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
                reply_msg(msg.id, langs[msg.lang].ruletaSignedUp, ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'ruletainfo' then
            local percentage =(tonumber(groupstats.caps) * 100) / tonumber(groupstats.cylinder)
            percentage = string.format('%d', percentage)

            local info = langs[msg.lang].cylinderCapacity .. groupstats.cylinder .. '\n' ..
            langs[msg.lang].capsNumber .. groupstats.caps .. '\n' ..
            langs[msg.lang].ruletaDeathPercentage .. percentage .. '%\n' ..
            langs[msg.lang].challengeCylinderCapacity .. groupstats.challengecylinder .. '\n' ..
            langs[msg.lang].challengeCapsNumber .. groupstats.challengecaps .. '\n'
            return info
        end

        if matches[1]:lower() == 'setcaps' and matches[2] then
            if is_momod(msg) then
                if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.cylinder then
                    ruletadata['groups'][chat].caps = matches[2]
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, langs[msg.lang].capsChanged .. tonumber(matches[2]), ok_cb, false)
                else
                    reply_msg(msg.id, langs[msg.lang].errorCapsRange:gsub('X', groupstats.cylinder - 1), ok_cb, false)
                end
            else
                return langs[msg.lang].require_mod
            end
            return
        end

        if matches[1]:lower() == 'setchallengecaps' and matches[2] then
            if is_momod(msg) then
                if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.challengecylinder then
                    ruletadata['groups'][chat].challengecaps = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, langs[msg.lang].challengeCapsChanged .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, langs[msg.lang].errorCapsRange:gsub('X', groupstats.challengecylinder - 1), ok_cb, false)
                end
            else
                return langs[msg.lang].require_mod
            end
            return
        end

        if matches[1]:lower() == 'setcylinder' and matches[2] then
            if is_owner(msg) then
                if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                    ruletadata['groups'][chat].cylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, langs[msg.lang].cylinderChanged .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, langs[msg.lang].errorCylinderRange, ok_cb, false)
                end
            else
                return langs[msg.lang].require_owner
            end
            return
        end

        if matches[1]:lower() == 'setchallengecylinder' and matches[2] then
            if is_owner(msg) then
                if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                    ruletadata['groups'][chat].challengecylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, langs[msg.lang].challengeCylinderChanged .. matches[2], ok_cb, false)
                else
                    reply_msg(msg.id, langs[msg.lang].errorCylinderRange, ok_cb, false)
                end
            else
                return langs[msg.lang].require_owner
            end
            return
        end

        local userstats = ruletadata['users'][user]

        if not userstats then
            reply_msg(msg.id, langs[msg.lang].ruletaRequireSignUp, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'deleteme' or matches[1]:lower() == 'eliminami' then
            if userstats.score >= 0 then
                ruletadata['users'][user] = false
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, langs[msg.lang].ruletaDeleted, ok_cb, false)
            else
                reply_msg(msg.id, langs[msg.lang].ruletaRequireZeroPoints, ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'mystats' or matches[1]:lower() == 'punti' then
            local stats = langs[msg.lang].attempts .. userstats.attempts .. '\n' ..
            langs[msg.lang].score .. userstats.score .. '\n' ..
            langs[msg.lang].deaths .. userstats.deaths .. '\n' ..
            langs[msg.lang].duels .. userstats.duels .. '\n' ..
            langs[msg.lang].wonduels .. userstats.wonduels .. '\n' ..
            langs[msg.lang].lostduels .. userstats.lostduels .. '\n' ..
            langs[msg.lang].actualstreak .. userstats.actualstreak .. '\n' ..
            langs[msg.lang].longeststreak .. userstats.longeststreak .. '\n' ..
            langs[msg.lang].scoreAttemptsRatio .. tostring((tonumber(userstats.score) * 100) / tonumber(userstats.attempts)) .. '/100'
            reply_msg(msg.id, stats, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'challenge' or matches[1]:lower() == 'sfida' then
            if type(msg.reply_id) ~= "nil" then
                get_message(msg.reply_id, Challenge_by_reply, { challenger = user, msg = msg })
            elseif matches[2] and matches[2] ~= '' then
                resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), Challenge_by_username, { challenger = user, chat_id = chat, msg = msg })
            else
                local name = ''
                if msg.from.username then
                    name = '@' .. msg.from.username
                else
                    name = string.gsub(msg.from.print_name, '_', ' ')
                end
                start_challenge(msg.from.id, 0, name, langs[msg.lang].everyone, msg.to.id)
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
                local text = langs[msg.lang].challenge .. '\n' ..
                langs[msg.lang].challenger .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
                langs[msg.lang].challenged .. redis:get('ruletachallenged:' .. chat) .. '\n'
                if accepted == 0 then
                    text = text .. langs[msg.lang].notAccepted .. '\n'
                elseif accepted == 1 then
                    text = text .. langs[msg.lang].accepted .. '\n'
                end
                text = text .. langs[msg.lang].roundsLeft .. rounds
                reply_msg(msg.id, text, ok_cb, false)
            else
                reply_msg(msg.id, langs[msg.lang].noChallenge, ok_cb, false)
            end
            return
        end

        if (matches[1]:lower() == 'accept' or matches[1]:lower() == 'accetta') and challenge and accepted == 0 then
            if tonumber(challenged) == 0 then
                if tonumber(user) ~= tonumber(challenger) then
                    local name = ''
                    if msg.from.username then
                        name = '@' .. msg.from.username
                    else
                        name = string.gsub(msg.from.print_name, '_', ' ')
                    end
                    local text = langs[msg.lang].challenger .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
                    langs[msg.lang].challenged .. name
                    challenged = user
                    redis:set('ruleta:' .. chat .. ':challenged', user)
                    redis:set('ruletachallenged:' .. chat, msg.from.username or string.gsub(msg.from.print_name, '_', ' '))
                    redis:set('ruleta:' .. chat .. ':accepted', 1)
                    redis:set('ruleta:' .. chat .. ':rounds', groupstats.challengecylinder)
                    ruletadata['users'][challenger].duels = tonumber(ruletadata['users'][challenger].duels + 1)
                    ruletadata['users'][challenged].duels = tonumber(ruletadata['users'][challenged].duels + 1)
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, text, ok_cb, false)
                else
                    reply_msg(msg.id, langs[msg.lang].cantChallengeYourself, ok_cb, false)
                end
            else
                local text = langs[msg.lang].challenger .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
                langs[msg.lang].challenged .. redis:get('ruletachallenged:' .. chat)
                if redis:get('ruleta:' .. chat .. ':challenged') == user then
                    redis:set('ruleta:' .. chat .. ':accepted', 1)
                    redis:set('ruleta:' .. chat .. ':rounds', groupstats.challengecylinder)
                    ruletadata['users'][challenger].duels = tonumber(ruletadata['users'][challenger].duels + 1)
                    ruletadata['users'][challenged].duels = tonumber(ruletadata['users'][challenged].duels + 1)
                    save_data(_config.ruleta.db, ruletadata)
                else
                    text = langs[msg.lang].wrongPlayer:gsub('X', redis:get('ruletachallenged:' .. chat))
                end
                reply_msg(msg.id, text, ok_cb, false)
            end
            return
        end

        if (matches[1]:lower() == 'reject' or matches[1]:lower() == 'rifiuta') and challenge then
            if (user == challenger or user == challenged) then
                if user == challenged and accepted == 0 then
                    reply_msg(msg.id, langs[msg.lang].challengeRejected:gsub('X', redis:get('ruletachallenged:' .. chat)), ok_cb, false)
                elseif is_momod(msg) then
                    reply_msg(msg.id, langs[msg.lang].challengeModTerminated, ok_cb, false)
                elseif accepted == 1 then
                    reply_msg(msg.id, langs[msg.lang].challengeEnd, ok_cb, false)
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
                    local function post_kick()
                        kick_user_any(user, chat)
                    end
                    postpone(post_kick, false, 1)
                end
                reject_challenge(user, chat)
            elseif not is_momod(msg) then
                reply_msg(msg.id, langs[msg.lang].wrongPlayer:gsub('X', redis:get('ruletachallenged:' .. chat)), ok_cb, false)
            else
                reject_challenge(user, chat)
            end
            return
        end

        if matches[1]:lower() == 'addpoints' and matches[2] and matches[3] and is_sudo(msg) then
            ruletadata['users'][matches[2]].score = tonumber(ruletadata['users'][matches[2]].score + matches[3])
            save_data(_config.ruleta.db, ruletadata)
            reply_msg(msg.id, langs[msg.lang].cheating, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'rempoints' and matches[2] and matches[3] and is_sudo(msg) then
            ruletadata['users'][matches[2]].score = tonumber(ruletadata['users'][matches[2]].score - matches[3])
            save_data(_config.ruleta.db, ruletadata)
            reply_msg(msg.id, langs[msg.lang].cheating, ok_cb, false)
            return
        end

        if msg.fwd_from then
            if not multiple_messages[tostring(msg.from.id)] then
                -- set multiple_messages of the user as true, after 30 seconds it's set to false to restore warning and kick
                multiple_messages[tostring(msg.from.id)] = true
                local function post_multiple_messages_false()
                    multiple_messages[tostring(msg.from.id)] = false
                end
                postpone(post_multiple_messages_false, false, 30)
                local function post_kick()
                    kick_user_any(user, chat)
                end
                postpone(post_kick, false, 1)
                reply_msg(msg.id, langs[msg.lang].forwardingRuleta, ok_cb, false)
            end
        else
            if matches[1]:lower() == 'godruleta' then
                if userstats.score > 10 then
                    userstats.attempts = tonumber(userstats.attempts + 1)
                    userstats.actualstreak = tonumber(userstats.actualstreak + 1)
                    if userstats.actualstreak > userstats.longeststreak then
                        userstats.longeststreak = tonumber(userstats.actualstreak)
                    end

                    if math.random(1, 2) == math.random(1, 2) then
                        reply_msg(msg.id, langs.phrases.ruletagame.killed[math.random(#langs.phrases.ruletagame.killed)], ok_cb, false)

                        userstats.score = tonumber(0)
                        userstats.deaths = tonumber(userstats.deaths + 1)
                        userstats.actualstreak = tonumber(0)
                        ruletadata['users'][user] = userstats

                        save_data(_config.ruleta.db, ruletadata)
                        local function post_kick()
                            kick_user_any(user, chat)
                        end
                        postpone(post_kick, false, 1)
                    else
                        reply_msg(msg.id, langs.phrases.ruletagame.godsafe[math.random(#langs.phrases.ruletagame.godsafe)], ok_cb, false)

                        userstats.score = tonumber(userstats.score + 70)
                        ruletadata['users'][user] = userstats

                        save_data(_config.ruleta.db, ruletadata)
                    end
                else
                    reply_msg(msg.id, langs[msg.lang].ruletaRequirePoints, ok_cb, false)
                end
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
                        local temp = tonumber(groupstats.challengecylinder) - rounds
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
                            reply_msg(msg.id, langs[msg.lang].challengeEnd, ok_cb, false)

                            ruletadata['users'][user].deaths = tonumber(ruletadata['users'][user].deaths + 1)
                            ruletadata['users'][user].actualstreak = tonumber(0)
                            ruletadata['users'][user].score = tonumber(ruletadata['users'][user].score + 1)
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
                            local function post_kick()
                                kick_user_any(user, chat)
                            end
                            postpone(post_kick, false, 1)
                        else
                            -- blue red
                            -- 🔵    🔴
                            local shotted = ''
                            local notshotted = ''
                            for var = 1, tonumber(temp + 1) do
                                shotted = shotted .. '🔴'
                                var = var + 1
                            end
                            for var = 1, tonumber(groupstats.challengecylinder - temp - 1) do
                                notshotted = notshotted .. '🔵'
                                var = var + 1
                            end
                            local percentage =(groupstats.challengecaps * 100) /(groupstats.challengecylinder - temp - 1)
                            percentage = string.format('%d', percentage)
                            reply_msg(msg.id, langs.phrases.ruletagame.safe[math.random(#langs.phrases.ruletagame.safe)] .. '\n' .. langs[msg.lang].shotsLeft .. notshotted .. shotted .. '\n' .. langs[msg.lang].ruletaDeathPercentage .. percentage .. '%\n' .. nextplayeruser .. langs[msg.lang].yourTurn .. '\n/ruleta', ok_cb, false)

                            ruletadata['users'][user].score = tonumber(ruletadata['users'][user].score + 1)

                            save_data(_config.ruleta.db, ruletadata)
                        end
                    else
                        reply_msg(msg.id, langs[msg.lang].notYourTurn, ok_cb, false)
                    end
                else
                    if math.random(tonumber(groupstats.caps), tonumber(groupstats.cylinder)) == math.random(tonumber(groupstats.caps), tonumber(groupstats.cylinder)) then
                        reply_msg(msg.id, langs.phrases.ruletagame.killed[math.random(#langs.phrases.ruletagame.killed)], ok_cb, false)

                        ruletadata['users'][user].deaths = tonumber(ruletadata['users'][user].deaths + 1)
                        ruletadata['users'][user].actualstreak = tonumber(0)

                        save_data(_config.ruleta.db, ruletadata)
                        local function post_kick()
                            kick_user_any(user, chat)
                        end
                        postpone(post_kick, false, 1)
                    else
                        reply_msg(msg.id, langs.phrases.ruletagame.safe[math.random(#langs.phrases.ruletagame.safe)], ok_cb, false)

                        ruletadata['users'][user].score = tonumber(ruletadata['users'][user].score + 1)

                        save_data(_config.ruleta.db, ruletadata)
                    end
                end
            end
        end
    end
end

return {
    description = "RULETAGAME",
    patterns =
    {
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Rr][Uu][Ll][Ee][Tt][Aa][Dd][Bb])$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Ee][Rr][Gg][Rr][Oo][Uu][Pp][Rr][Uu][Ll][Ee][Tt][Aa])$",
        "^[#!/]([Dd][Ee][Ll][Ee][Tt][Ee][Gg][Rr][Oo][Uu][Pp][Rr][Uu][Ll][Ee][Tt][Aa])$",
        "^[#!/]([Ll][Ee][Aa][Dd][Ee][Rr][Bb][Oo][Aa][Rr][Dd]) ([^%s]+)$",
        "^[#!/]([Ll][Ee][Aa][Dd][Ee][Rr][Bb][Oo][Aa][Rr][Dd])$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Ee][Rr][Mm][Ee])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Ss][Ee][Tt][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Dd][Ee][Ll][Ee][Tt][Ee][Mm][Ee])$",
        "^[#!/]([Mm][Yy][Ss][Tt][Aa][Tt][Ss])$",
        "^[#!/]?([Gg][Oo][Dd][Rr][Uu][Ll][Ee][Tt][Aa])$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee]) ([^%s]+)$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee])$",
        "^[#!/]([Aa][Cc][Cc][Ee][Pp][Tt])$",
        "^[#!/]([Rr][Ee][Jj][Ee][Cc][Tt])$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Aa][Dd][Dd][Pp][Oo][Ii][Nn][Tt][Ss]) (%d+) (%d+)$",
        "^[#!/]([Rr][Ee][Mm][Pp][Oo][Ii][Nn][Tt][Ss]) (%d+) (%d+)$",
        "^[#!/]?([Rr][Uu][Ll][Ee][Tt][Aa])",
        -- registergroupruleta
        "^([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa] [Gg][Rr][Uu][Pp][Pp][Oo] [Rr][Uu][Ll][Ee][Tt][Aa])$",
        -- deletegroup
        "^([Ee][Ll][Ii][Mm][Ii][Nn][Aa] [Gg][Rr][Uu][Pp][Pp][Oo] [Rr][Uu][Ll][Ee][Tt][Aa])$",
        -- leaderboard
        "^[#!/]([Cc][Ll][Aa][Ss][Ss][Ii][Ff][Ii][Cc][Aa]) ([^%s]+)$",
        "^[#!/]([Cc][Ll][Aa][Ss][Ss][Ii][Ff][Ii][Cc][Aa])$",
        -- registerme
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa][Mm][Ii])$",
        -- deleteme
        "^[#!/]([Ee][Ll][Ii][Mm][Ii][Nn][Aa][Mm][Ii])$",
        -- mystats
        "^[#!/]([Pp][Uu][Nn][Tt][Ii])$",
        -- challenge
        "^[#!/]([Ss][Ff][Ii][Dd][Aa]) ([^%s]+)$",
        "^[#!/]([Ss][Ff][Ii][Dd][Aa])$",
        -- accept
        "^[#!/]([Aa][Cc][Cc][Ee][Tt][Tt][Aa])$",
        -- reject
        "^[#!/]([Rr][Ii][Ff][Ii][Uu][Tt][Aa])$",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "USER",
        "#registerme|#registrami",
        "#deleteme|#eliminami",
        "#ruletainfo",
        "#mystats|#punti",
        "#ruleta",
        "#godruleta",
        "#challenge|#sfida [<username>|<reply>]",
        "#accept|#accetta",
        "#reject|#rifiuta",
        "#challengeinfo",
        "#leaderboard [(attempts|tentativi)|(deaths|morti)|(streak|serie)|(challenges|sfide)|(victories|vittorie)|(defeats|sconfitte)]",
        "MOD",
        "#setcaps <value>",
        "#setchallengecaps <value>",
        "OWNER",
        "#setcylinder <value>",
        "#setchallengecylinder <value>",
        "ADMIN",
        "#registergroupruleta|registra gruppo ruleta",
        "#deletegroupruleta|elimina gruppo ruleta",
        "SUDO",
        "#createruletadb",
        "#addpoints <id> <value>",
        "#rempoints <id> <value>",
    },
}