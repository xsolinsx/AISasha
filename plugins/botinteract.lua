local function callback_setbot(extra, success, result)
    if success == 0 then
        send_large_msg('chat#id' .. extra.chatid, lang_text('noUsernameFound'))
        send_large_msg('channel#id' .. extra.chatid, lang_text('noUsernameFound'))
        return
    end
    local hash = 'botinteract'
    redis:sadd(hash, extra.chatid .. ':' .. result.peer_id)
    send_large_msg('chat#id' .. extra.chatid, result.first_name .. ' - ' .. result.username .. lang_text('botSet'))
    send_large_msg('channel#id' .. extra.chatid, result.first_name .. ' - ' .. result.username .. lang_text('botSet'))
end

local function callback_unsetbot(extra, success, result)
    if success == 0 then
        send_large_msg('chat#id' .. extra.chatid, lang_text('noUsernameFound'))
        send_large_msg('channel#id' .. extra.chatid, lang_text('noUsernameFound'))
        return
    end
    local hash = 'botinteract'
    redis:srem(hash, extra.chatid .. ':' .. result.peer_id)
    send_large_msg('chat#id' .. extra.chatid, result.first_name .. ' - ' .. result.username .. lang_text('botUnset'))
    send_large_msg('channel#id' .. extra.chatid, result.first_name .. ' - ' .. result.username .. lang_text('botUnset'))
end

local function list_botinteract(msg)
    local list = redis:smembers('botinteract')
    local text = ''

    for k, v in pairs(list) do
        text = text .. v .. "\n"
    end
    return text
end

local function run(msg, matches)
    if matches[1]:lower() == "setbot" or matches[1]:lower() == "sasha imposta bot" and string.sub(matches[2]:lower(), -3) == 'bot' then
        if is_admin1(msg) then
            resolve_username(matches[2]:gsub("@", ""), callback_setbot, { chatid = msg.to.id })
            return
        else
            return lang_text('require_admin')
        end
    end
    if matches[1]:lower() == "unsetbot" or matches[1]:lower() == "sasha rimuovi bot" and string.sub(matches[2]:lower(), -3) == 'bot' then
        if is_momod(msg) then
            resolve_username(matches[2]:gsub("@", ""), callback_unsetbot, { chatid = msg.to.id })
            return
        else
            return lang_text('require_owner')
        end
    end
    if matches[1] == '$' then
        local chat = ''
        local bot = ''
        local t = list_botinteract(msg):split('\n')
        for i, v in pairs(t) do
            chat, bot = v:match("(%d+):(%d+)")
            if tonumber(msg.to.id) == tonumber(chat) then
                msg.text = msg.text:gsub('$', '')
                send_large_msg('user#id' .. bot, msg.text)
            end
        end
    end
    if matches[1] == 'getchar' then
        return '$'
    end
    if matches[1] == 'sendmedia' then
        redis:set(msg.to.id, 'waiting')
        return lang_text('sendMeMedia')
    end
    if matches[1]:lower() == 'undo' then
        redis:del(msg.to.id)
        return lang_text('cancelled')
    end
    if (matches[1] == '[photo]' or matches[1] == '[document]' or matches[1] == '[video]' or matches[1] == '[audio]' or matches[1] == '[contact]' or matches[1] == '[geo]') and redis:get(msg.to.id) then
        local chat = ''
        local bot = ''
        local t = list_botinteract(msg):split('\n')
        for i, v in pairs(t) do
            chat, bot = v:match("(%d+):(%d+)")
            if tonumber(msg.to.id) == tonumber(chat) then
                fwd_msg('user#id' .. bot, msg.id, ok_cb, false)
            end
        end
        redis:del(msg.to.id)
        return lang_text('mediaForwarded')
    end
end

local function pre_process(msg)
    if not msg.text and msg.media then
        msg.text = '[' .. msg.media.type .. ']'
    end
    if msg.to.type == 'user' then
        local chat = ''
        local bot = ''
        local t = list_botinteract(msg):split('\n')
        for i, v in pairs(t) do
            chat, bot = v:match("(%d+):(%d+)")
            if tonumber(msg.from.id) == tonumber(bot) then
                if not msg.media then
                    fwd_msg('chat#id' .. chat, msg.id, ok_cb, false)
                    fwd_msg('channel#id' .. chat, msg.id, ok_cb, false)
                else
                    fwd_msg('chat#id' .. chat, msg.id, ok_cb, false)
                    fwd_msg('channel#id' .. chat, msg.id, ok_cb, false)
                end
            end
        end
    end
    return msg
end

return {
    description = "BOTINTERACT",
    patterns =
    {
        "^(%$).*$",
        "^[#!/]([Gg][Ee][Tt][Cc][Hh][Aa][Rr])$",
        "^[#!/]([Ss][Ee][Nn][Dd][Mm][Ee][Dd][Ii][Aa])$",
        "^[#!/]([Ss][Ee][Tt][Bb][Oo][Tt]) (.*)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Bb][Oo][Tt]) (.*)$",
        "^[#!/]([Uu][Nn][Dd][Oo])$",
        "(%[(document)%])",
        "(%[(photo)%])",
        "(%[(video)%])",
        "(%[(audio)%])",
        "(%[(contact)%])",
        "(%[(geo)%])",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0
    -- usage
    -- #getchar
    -- $<text>
    -- #sendmedia
    -- MOD
    -- (#unsetbot|sasha rimuovi bot)
    -- ADMIN
    -- (#setbot|sasha imposta bot)
}