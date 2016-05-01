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

local function kick_user(user_id, chat_id)
    local chat = 'chat#id' .. chat_id
    local user = 'user#id' .. user_id
    local channel = 'channel#id' .. chat_id
    chat_del_user(chat, user, ok_cb, true)
    channel_kick_user(channel, user, ok_cb, true)
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
        if matches[1]:lower() == 'createdb' and is_sudo(msg) then
            local f = io.open(_config.ruleta.db, 'w+')
            f:write('{"groups":{},"users":{},"challenges":{}}')
            f:close()
            reply_msg(msg.id, lang_text('ruletadbCreated'), ok_cb, false)
            return
        end

        local chat = tostring(msg.to.id)
        local user = tostring(msg.from.id)
        local ruletadata = load_data(_config.ruleta.db)

        if matches[1]:lower() == 'registragruppo' then
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

        if matches[1]:lower() == 'eliminagruppo' then
            if is_admin1(msg) then
                ruletadata['groups'][chat] = false
                save_data(_config.ruleta.db, ruletadata)
                reply_msg(msg.id, lang_text('ruletaGroupDeleted'), ok_cb, false)
            else
                return lang_text('require_admin')
            end
            return
        end

        if matches[1]:lower() == 'registrami' then
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
            if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.cylinder then
                if is_momod(msg) then
                    ruletadata['groups'][chat].caps = matches[2]
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('capsChanged') .. tonumber(matches[2]), ok_cb, false)
                else
                    return lang_text('require_mod')
                end
            else
                reply_msg(msg.id, lang_text('errorCapsRange'):gsub('X', groupstats.cylinder - 1), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'setchallengecaps' and matches[2] then
            if tonumber(matches[2]) > 0 and tonumber(matches[2]) < groupstats.challengecylinder then
                if is_momod(msg) then
                    ruletadata['groups'][chat].challengecaps = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('challengeCapsChanged') .. matches[2], ok_cb, false)
                else
                    return lang_text('require_mod')
                end
            else
                reply_msg(msg.id, lang_text('errorCapsRange'):gsub('X', groupstats.challengecylinder - 1), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'setcylinder' and matches[2] then
            if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                if is_owner(msg) then
                    ruletadata['groups'][chat].cylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('cylinderChanged') .. matches[2], ok_cb, false)
                else
                    return lang_text('require_owner')
                end
            else
                reply_msg(msg.id, lang_text('errorCylinderRange'), ok_cb, false)
            end
            return
        end

        if matches[1]:lower() == 'setchallengecylinder' and matches[2] then
            if tonumber(matches[2]) >= 5 and tonumber(matches[2]) <= 10 then
                if is_owner(msg) then
                    ruletadata['groups'][chat].challengecylinder = tonumber(matches[2])
                    save_data(_config.ruleta.db, ruletadata)
                    reply_msg(msg.id, lang_text('challengeCylinderChanged') .. matches[2], ok_cb, false)
                else
                    return lang_text('require_owner')
                end
            else
                reply_msg(msg.id, lang_text('errorCylinderRange'), ok_cb, false)
            end
            return
        end

        local userstats = ruletadata['users'][user]

        if not userstats then
            reply_msg(msg.id, lang_text('requireSignUp'), ok_cb, false)
            return
        end
        --
        if matches[1]:lower() == 'eliminami' and userstats.score >= 0 then
            ruletadata['users'][user] = false
            save_data(_config.ruleta.db, ruletadata)
            reply_msg(msg.id, lang_text('ruletaDeleted'), ok_cb, false)
            return
        end

        if matches[1]:lower() == 'mystats' then
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

        if matches[1]:lower() == 'ruletagod' then
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

        if matches[1]:lower() == 'sfida' then
            if type(msg.reply_id) ~= "nil" and is_momod(msg) then
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

        if matches[1]:lower() == 'challengeinfo' and challenge then
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
            return
        end

        if matches[1]:lower() == 'accetta' and challenge and accepted == 0 then
            local text = lang_text('challenger') .. redis:get('ruletachallenger:' .. chat) .. '\n' ..
            lang_text('challenged') .. redis:get('ruletachallenged:' .. chat)
            if redis:get('ruleta:' .. chat .. ':challenged') == user then
                redis:set('ruleta:' .. chat .. ':accepted', 1)
                redis:set('ruleta:' .. chat .. ':rounds', groupstats.challengecylinder)
                ruletadata['users'][challenger].duels = tonumber(ruletadata['users'][challenger].duels + 1)
                ruletadata['users'][challenged].duels = tonumber(ruletadata['users'][challenged].duels + 1)
            else
                text = lang_text('wrongPlayer')
            end
            reply_msg(msg.id, text, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'rifiuta' and challenge then
            if (user == challenger or user == challenged) then
                if user == challenged and accepted == 0 then
                    reply_msg(msg.id, lang_text('challengeRejected'), ok_cb, false)
                elseif is_momod(msg) then
                    reply_msg(msg.id, lang_text('challengeModTerminated'), ok_cb, false)
                elseif accepted == 1 then
                    reply_msg(msg.id, lang_text('challengeEnd'), ok_cb, false)
                    if user == challenger then
                        ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score - 20)
                        ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score + 20)
                        ruletadata['users'][challenger].lostduels = tonumber(ruletadata['users'][challenger].lostduels + 1)
                        ruletadata['users'][challenged].wonduels = tonumber(ruletadata['users'][challenged].wonduels + 1)
                    elseif user == challenged then
                        ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score + 20)
                        ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score - 20)
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

        if matches[1]:lower() == 'ruleta' then
            ruletadata['users'][user].attempts = tonumber(ruletadata['users'][user].attempts + 1)
            ruletadata['users'][user].actualstreak = tonumber(ruletadata['users'][user].actualstreak + 1)
            if tonumber(ruletadata['users'][user].actualstreak) > tonumber(ruletadata['users'][user].longeststreak) then
                ruletadata['users'][user].longeststreak = tonumber(ruletadata['users'][user].actualstreak)
            end

            if accepted == 1 and(user == challenger or user == challenged) and rounds > 0 then
                if user == redis:get('ruletachallenge:' .. chat .. ':player') then
                    local temp = tonumber(groupstats.challengecylinder) - rounds
                    if user == challenger then
                        redis:set('ruletachallenge:' .. chat .. ':player', challenged)
                    elseif user == challenged then
                        redis:set('ruletachallenge:' .. chat .. ':player', challenger)
                    end
                    redis:set('ruleta:' .. chat_id .. ':rounds', rounds + 1)
                    print(temp)
                    if math.random(tonumber(groupstats.challengecaps), tonumber(groupstats.challengecylinder) - temp) == math.random(tonumber(groupstats.challengecaps), tonumber(groupstats.challengecylinder) - temp) then
                        print('dead')
                        -- bot destroy challenge on redis
                        reject_challenge(our_id, chat)
                        reply_msg(msg.id, lang_text('challengeEnd'), ok_cb, false)

                        ruletadata['users'][user].deaths = tonumber(ruletadata['users'][user].deaths + 1)
                        ruletadata['users'][user].actualstreak = tonumber(0)
                        if user == challenger then
                            ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score - 20)
                            ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score + 20)
                            ruletadata['users'][challenger].lostduels = tonumber(ruletadata['users'][challenger].lostduels + 1)
                            ruletadata['users'][challenged].wonduels = tonumber(ruletadata['users'][challenged].wonduels + 1)
                        elseif user == challenged then
                            ruletadata['users'][challenger].score = tonumber(ruletadata['users'][challenger].score + 20)
                            ruletadata['users'][challenged].score = tonumber(ruletadata['users'][challenged].score - 20)
                            ruletadata['users'][challenger].wonduels = tonumber(ruletadata['users'][challenger].wonduels + 1)
                            ruletadata['users'][challenged].lostduels = tonumber(ruletadata['users'][challenged].lostduels + 1)
                        end

                        save_data(_config.ruleta.db, ruletadata)
                        kick_user(user, chat)
                    else
                        print('alive')
                        local text = good[math.random(#good)] .. '\n' ..
                        lang_text('shotsLeft')
                        local shots = ''
                        for var = 1, tonumber(groupstats.challengecylinder) do
                            shots = shots .. '🔵'
                            var = var + 1
                        end
                        print(string.len(shots) / 4, shots)
                        local shotted = string.sub(shots, 1, temp)
                        shotted = string.gsub(shotted, '🔵', '🔴')
                        print(string.len(shotted) / 4, shotted)
                        local notshotted = string.sub(shots, temp, tonumber(groupstats.challengecylinder))
                        print(string.len(notshotted) / 4, notshotted)
                        text = text .. shotted .. notshotted
                        print(text)
                        reply_msg(msg.id, text, ok_cb, false)
                        send_large_msg(get_receiver(msg), text)
                        -- blu,rosso
                        -- 🔵🔴

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
        "#registrami: Sasha registra l'utente alla roulette.",
        "#eliminami: Sasha elimina i dati dell'utente.",
        "#ruletainfo: Sasha manda le informazioni della roulette.",
        "#mystats: Sasha manda le statistiche dell'utente.",
        "#ruleta: Sasha cerca di ucciderti.",
        "#ruletagod: Sasha ti dà il 50% di probabilità di guadagnare 70 punti, con l'altro 50% li perdi tutti (richiede almeno 11 punti).",
        "#sfida <username>|<reply>: Sasha avvia una sfida tra il mittente e l'utente specificato.",
        "#accetta: Sasha conferma la sfida.",
        "#rifiuta: Sasha cancella la sfida.",
        "#challengeinfo: Sasha manda le informazioni della sfida in corso.",
        "MOD",
        "#setcaps <value>: Sasha mette <value> proiettili nel tamburo.",
        "#setchallengecaps <value>: Sasha mette <value> proiettili nel tamburo delle sfide.",
        "(#kick|[sasha] uccidi|[sasha] spara) random: Sasha sceglie un utente a caso e lo rimuove.",
        "OWNER",
        "#setcylinder <value>: Sasha imposta un tamburo da <value> colpi nel range [5-10].",
        "#setchallengecylinder <value>: Sasha imposta un tamburo da <value> colpi per le sfide nel range [5-10].",
        "ADMIN",
        "#registragruppo: Sasha abilita il gruppo a giocare a ruleta.",
        "#eliminagruppo: Sasha disabilita il gruppo per ruleta.",
        "SUDO",
        "#createdb: Sasha crea il database di ruleta.",
    },
    patterns =
    {
        "^[#!/]([Kk][Ii][Cc][Kk]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa][Mm][Ii])$",
        "^[#!/]([Ee][Ll][Ii][Mm][Ii][Nn][Aa][Mm][Ii])$",
        "^[#!/]([Rr][Ee][Gg][Ii][Ss][Tt][Rr][Aa][Gg][Rr][Uu][Pp][Pp][Oo])$",
        "^[#!/]([Ee][Ll][Ii][Mm][Ii][Nn][Aa][Gg][Rr][Uu][Pp][Pp][Oo])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa][Gg][Oo][Dd])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa])",
        "^[#!/]([Ss][Ff][Ii][Dd][Aa]) (.*)$",
        "^[#!/]([Ss][Ff][Ii][Dd][Aa])$",
        "^[#!/]([Aa][Cc][Cc][Ee][Tt][Tt][Aa])$",
        "^[#!/]([Rr][Ii][Ff][Ii][Uu][Tt][Aa])$",
        "^[#!/]([Rr][Ee][Ss][Ee][Tt])$",
        "^[#!/]([Mm][Yy][Ss][Tt][Aa][Tt][Ss])$",
        "^[#!/]([Ss][Ee][Tt][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Aa][Pp][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Cc][Yy][Ll][Ii][Nn][Dd][Ee][Rr]) (%d+)$",
        "^[#!/]([Cc][Hh][Aa][Ll][Ll][Ee][Nn][Gg][Ee][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Dd][Bb])$",
        -- kick random
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Rr][Aa]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
        "^([Ss][Pp][Aa][Rr][Aa]) [Rr][Aa][Nn][Dd][Oo][Mm]$",
    },
    run = run,
    min_rank = 0
}