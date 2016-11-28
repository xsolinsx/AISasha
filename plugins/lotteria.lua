-- id 1054285638
local function run(msg, matches)
    if msg.to.id == 1054285638 then
        local hash = 'lotteria:' .. msg.to.id
        local hash2 = 'lotteria:' .. msg.to.id .. ':attiva'
        if matches[1]:lower() == 'biglietto' then
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
                    reply_msg(msg.id, 'La biglietteria è aperta, prendete un biglietto con /biglietto :)', ok_cb, false)
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
                if redis:get(hash2) then
                    redis:del(hash2)
                    local t = { }
                    for k, v in pairs(redis:hgetall(hash)) do
                        table.insert(t, v)
                        redis:hdel(hash, k)
                    end
                    if #t > 0 then
                        reply_msg(msg.id, 'Ci sono ' .. #t .. ' partecipanti.\nIl vincitore è... ' .. t[math.random(#t)] .. '!\nCongratulazioni!', ok_cb, false)
                    else
                        reply_msg(msg.id, 'Non ci sono partecipanti o la biglietteria non è stata aperta.', ok_cb, false)
                    end
                else
                    local t = { }
                    for k, v in pairs(redis:hgetall(hash)) do
                        table.insert(t, v)
                        redis:hdel(hash, k)
                    end
                    if #t > 0 then
                        reply_msg(msg.id, 'Ci sono ' .. #t .. ' partecipanti.\nIl vincitore è... ' .. t[math.random(#t)] .. '!\nCongratulazioni!', ok_cb, false)
                    else
                        reply_msg(msg.id, 'Non ci sono partecipanti o la biglietteria non è stata aperta.', ok_cb, false)
                    end
                end
            else
                return langs[msg.lang].require_mod
            end
        end
    end
end

return {
    description = "LOTTERIA",
    patterns =
    {
        "^[#!/]([Bb][Ii][Gg][Ll][Ii][Ee][Tt][Tt][Oo])$",
        "^[#!/]([Ss][Tt][Aa][Rr][Tt][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ss][Tt][Oo][Pp][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ii][Nn][Ff][Oo][Ll][Oo][Tt][Tt][Ee][Rr][Ii][Aa])$",
        "^[#!/]([Ee][Ss][Tt][Rr][Aa][Zz][Ii][Oo][Nn][Ee])$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#biglietto",
        "MOD",
        "#startlotteria",
        "#stoplotteria",
        "#infolotteria",
        "#estrazione",
    },
}
