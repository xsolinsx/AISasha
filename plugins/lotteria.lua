local function estrai(t, chat_id, msg_id, n)
    local hash = 'lotteria:' .. chat_id
    local tab = { }
    if n == false then
        for k, v in pairs(t) do
            table.insert(tab, v)
            redis:hdel(hash, k)
        end
        if #tab > 0 then
            reply_msg(msg_id, 'Ci sono ' .. #tab .. ' partecipanti.\nIl vincitore è... ' .. tab[math.random(#tab)] .. '!\nQuesta era l\'ultima estrazione :)', ok_cb, false)
        else
            reply_msg(msg_id, 'Non ci sono partecipanti o la biglietteria non è stata aperta.', ok_cb, false)
        end
    else
        for k, v in pairs(t) do
            table.insert(tab, v)
        end
        local rnd = math.random(#tab)
        local i = 0
        for k, v in pairs(t) do
            i = i + 1
            if i == rnd then
                reply_msg(msg_id, 'Ci sono ' .. #tab .. ' partecipanti.\nIl vincitore è... ' .. v .. '!\nProseguiamo con la prossima estrazione :)', ok_cb, false)
                redis:hdel(hash, k)
                return
            end
        end
    end
end

local function randomChoice(extra, success, result)
    local done = false
    local id
    while not done do
        id = result[math.random(#result)].peer_id
        if database['users'][tostring(id)] then
            if database['users'][tostring(id)].username then
                send_large_msg('channel#id' .. extra.chat_id, 'ℹ️ ' .. database['users'][tostring(id)].username .. ' ID: ' .. id)
                done = true
            else
                send_large_msg('channel#id' .. extra.chat_id, 'ℹ️ NO USERNAME ' .. database['users'][tostring(id)].print_name .. ' ID: ' .. id)
                done = true
            end
        else
            send_large_msg('channel#id' .. extra.chat_id, 'ℹ️ Utente non presente nel database ID: ' .. id)
            done = true
        end
    end
end

-- id 1078810985
local function run(msg, matches)
    if matches[1]:lower() == 'estrazionerandom' then
        if is_momod(msg) then
            channel_get_users(get_receiver(msg), randomChoice, { chat_id = msg.to.id })
            return
        else
            return langs[msg.lang].require_mod
        end
    end
    local n
    local hash = 'lotteria:' .. msg.to.id
    local hash2 = 'lotteria:' .. msg.to.id .. ':attiva'
    if matches[1]:lower() == 'ticket' then
        if redis:get(hash2) then
            if redis:hget(hash, msg.from.id) then
                reply_msg(msg.id, 'Hai già preso il biglietto!', ok_cb, false)
            else
                if msg.from.username then
                    redis:hset(hash, msg.from.id, '@' .. msg.from.username)
                    reply_msg(msg.id, 'Hai preso un biglietto!', ok_cb, false)
                else
                    reply_msg(msg.id, 'Devi avere un username per partecipare alla lotteria! Vai in impostazioni e settalo.', ok_cb, false)
                end
            end
        else
            reply_msg(msg.id, 'La biglietteria è chiusa :(', ok_cb, false)
        end
    elseif matches[1]:lower() == 'startlotteria' then
        if is_momod(msg) then
            if redis:get(hash2) then
                reply_msg(msg.id, 'La biglietteria è già aperta!', ok_cb, false)
            else
                redis:set(hash2, '1')
                reply_msg(msg.id, 'La biglietteria è aperta, prendete un biglietto con /ticket :)', ok_cb, false)
            end
        else
            return langs[msg.lang].require_mod
        end
    elseif matches[1]:lower() == 'stoplotteria' then
        if is_momod(msg) then
            if redis:get(hash2) then
                redis:del(hash2)
                reply_msg(msg.id, 'Ho chiuso la biglietteria!', ok_cb, false)
            else
                reply_msg(msg.id, 'La biglietteria è già chiusa!', ok_cb, false)
            end
        else
            return langs[msg.lang].require_mod
        end
    elseif matches[1]:lower() == 'infolotteria' then
        if is_momod(msg) then
            local t = { }
            for k, v in pairs(redis:hgetall(hash)) do
                table.insert(t, v)
            end
            reply_msg(msg.id, 'Sono stati presi ' .. #t .. ' biglietti.', ok_cb, false)
        else
            return langs[msg.lang].require_mod
        end
    elseif matches[1]:lower() == 'estrazione' then
        if is_momod(msg) then
            if msg.text:match('%d$') then
                n = true
            else
                n = false
            end
            if redis:get(hash2) then
                redis:del(hash2)
                estrai(redis:hgetall(hash), msg.to.id, msg.id, n)
            else
                estrai(redis:hgetall(hash), msg.to.id, msg.id, n)
            end
        else
            return langs[msg.lang].require_mod
        end
    end
end

return {
    description = "LOTTERIA",
    patterns =
    {
        "^[#!/]([Tt][Ii][Cc][Kk][Ee][Tt])$",
        "^[#!/]([Ss][Tt][Aa][Rr][Tt][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ss][Tt][Oo][Pp][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ii][Nn][Ff][Oo][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ee][Ss][Tt][Rr][Aa][Zz][Ii][Oo][Nn][Ee][Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^[#!/]([Ee][Ss][Tt][Rr][Aa][Zz][Ii][Oo][Nn][Ee])%d*$",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "USER",
        "#ticket",
        "MOD",
        "#estrazionerandom",
        "#startlotteria",
        "#stoplotteria",
        "#infolotteria",
        "#estrazione<numero>",
    },
}