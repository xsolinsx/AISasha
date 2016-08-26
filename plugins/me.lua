local function get_group_stats(extra, success, result)
    local lang = get_lang(extra.chat)
    local usermsgs = tonumber(redis:get('msgs:' .. extra.user .. ':' .. extra.chat) or 0)
    local chattotal = 0
    for k, v in pairs(result.members) do
        local tmpmsgs = tonumber(redis:get('msgs:' .. v.peer_id .. ':' .. extra.chat) or 0)
        chattotal = chattotal + tmpmsgs
    end
    if chattotal == 0 then
        chattotal = 1
    end
    local percentage =(usermsgs * 100) / chattotal
    send_large_msg(extra.receiver, string.gsub(string.gsub(string.gsub(langs[lang].meString, 'W', tostring(usermsgs)), 'X', string.format('%d', percentage)), 'Z', tostring(chattotal)))
end

local function get_supergroup_stats(extra, success, result)
    local lang = get_lang(extra.chat)
    local usermsgs = tonumber(redis:get('msgs:' .. extra.user .. ':' .. extra.chat) or 0)
    local chattotal = 0
    for k, v in pairsByKeys(result) do
        local tmpmsgs = tonumber(redis:get('msgs:' .. v.peer_id .. ':' .. extra.chat) or 0)
        chattotal = chattotal + tmpmsgs
    end
    if chattotal == 0 then
        chattotal = 1
    end
    local percentage =(usermsgs * 100) / chattotal
    send_large_msg(extra.receiver, string.gsub(string.gsub(string.gsub(langs[lang].meString, 'W', tostring(usermsgs)), 'X', string.format('%d', percentage)), 'Z', tostring(chattotal)))
end

local function run(msg, matches)
    if matches[1]:lower() == 'me' then
        if msg.to.type == 'chat' then
            chat_info(get_receiver(msg), get_group_stats, { receiver = get_receiver(msg), user = msg.from.id, chat = msg.to.id })
        elseif msg.to.type == 'channel' then
            channel_get_users(get_receiver(msg), get_supergroup_stats, { receiver = get_receiver(msg), user = msg.from.id, chat = msg.to.id })
        elseif msg.to.type == 'user' then
            local usermsgs = tonumber(redis:get('msgs:' .. msg.from.id .. ':' .. msg.to.id) or 0)
            send_large_msg(get_receiver(msg), string.gsub(string.gsub(string.gsub(langs[msg.lang].meString, 'W', tostring(usermsgs)), 'X', '100%'), 'Z', tostring(usermsgs)))
        end
        return
    end
end

return {
    description = "ME",
    patterns =
    {
        "^[#!/]([Mm][Ee])$",
    },
    run = run,
    min_rank = 0,
    -- usage
    -- #me
}
-- idea taken from jack-telegram-bot