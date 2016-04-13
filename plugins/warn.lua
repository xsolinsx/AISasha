local data = load_data(_config.moderation.data)

local function set_warn(msg, value)
    if tonumber(value) < 1 or tonumber(value) > 10 then
        return lang_text('errorWarnRange')
    end
    local warn_max = value
    data[tostring(msg.to.id)]['settings']['warn_max'] = warn_max
    save_data(_config.moderation.data, data)
    savelog(msg.to.id, " [" .. msg.from.id .. "] set warn to [" .. value .. "]")
    return lang_text('warnSet') .. value
end

local function get_warn(msg)
    local warn_max = data[tostring(msg.to.id)]['settings']['warn_max']
    if not warn_max then
        return lang_text('noWarnSet')
    end
    return lang_text('warnSet') .. warn_max
end

local function get_user_warns(user_id, chat_id)
    local channel = 'channel#id' .. chat_id
    local chat = 'chat#id' .. chat_id
    local hash = chat_id .. ':warn:' .. user_id
    local hashonredis = redis:get(hash)
    local warn_msg = lang_text('yourWarnings')
    local warn_chat = string.match(get_warn( { from = { id = user_id }, to = { id = chat_id } }), "%d+")

    if hashonredis then
        warn_msg = string.gsub(string.gsub(warn_msg, 'Y', warn_chat), 'X', tostring(hashonredis))
        send_large_msg(chat, warn_msg, ok_cb, false)
        send_large_msg(channel, warn_msg, ok_cb, false)
    else
        warn_msg = string.gsub(string.gsub(warn_msg, 'Y', warn_chat), 'X', '0')
        send_large_msg(chat, warn_msg, ok_cb, false)
        send_large_msg(channel, warn_msg, ok_cb, false)
    end
end

local function warn_user(user_id, chat_id)
    local channel = 'channel#id' .. chat_id
    local chat = 'chat#id' .. chat_id
    local user = 'user#id' .. user_id
    print(get_warn( { from = { id = user_id }, to = { id = chat_id } }))
    local warn_chat = string.match(get_warn( { from = { id = user_id }, to = { id = chat_id } }), "%d+")
    local hash = chat_id .. ':warn:' .. user_id
    redis:incr(hash)
    local hashonredis = redis:get(hash)
    if hashonredis then
        if tonumber(hashonredis) >= tonumber(warn_chat) then
            chat_del_user(chat, user, ok_cb, false)
            channel_kick(channel, user, ok_cb, false)
            redis:getset(hash, 0)
        end
        send_large_msg(chat, string.gsub(lang_text('warned'), 'X', tostring(hashonredis)), ok_cb, false)
        send_large_msg(channel, string.gsub(lang_text('warned'), 'X', tostring(hashonredis)), ok_cb, false)
    else
        redis:set(hash, 1)
        send_large_msg(chat, string.gsub(lang_text('warned'), 'X', '1'), ok_cb, false)
        send_large_msg(channel, string.gsub(lang_text('warned'), 'X', '1'), ok_cb, false)
    end
end

local function unwarn_user(user_id, chat_id)
    local channel = 'channel#id' .. chat_id
    local chat = 'chat#id' .. chat_id
    local hash = chat_id .. ':warn:' .. user_id
    redis:set(hash, 0)
    send_large_msg(chat, string.gsub(lang_text('zeroWarnings'), 'X', tostring(hashonredis)), ok_cb, false)
    send_large_msg(channel, string.gsub(lang_text('zeroWarnings'), 'X', tostring(hashonredis)), ok_cb, false)
end

local function Warn_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_momod2(result.from.peer_id, result.to.peer_id) then
            -- Ignore mods,owner,admin
            return lang_text('cantWarnHigher')
        end
        warn_user(result.from.peer_id, result.to.peer_id)
    else
        return lang_text('useYourGroups')
    end
end

local function Warn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(receiver, lang_text('noUsernameFound'))
    end
    local user_id = result.peer_id
    local chat_id = extra.msg.to.id
    warn_user(user_id, chat_id)
end

local function Unwarn_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        unwarn_user(result.from.peer_id, result.to.peer_id)
    else
        return lang_text('useYourGroups')
    end
end

local function Unwarn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(receiver, lang_text('noUsernameFound'))
    end
    local user_id = result.peer_id
    local chat_id = extra.msg.to.id
    unwarn_user(user_id, chat_id)
end

local function getWarn_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        get_user_warns(result.from.peer_id, result.to.peer_id)
    else
        return lang_text('useYourGroups')
    end
end

local function getWarn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(receiver, lang_text('noUsernameFound'))
    end
    local user_id = result.peer_id
    local chat_id = extra.msg.to.id
    get_user_warns(user_id, chat_id)
end

local function run(msg, matches)
    if is_momod(msg) then
        if matches[1]:lower() == 'setwarn' and matches[2] then
            return set_warn(msg, matches[2])
        end
        if matches[1]:lower() == 'getwarn' then
            return get_warn(msg)
        end
        if get_warn(msg) == lang_text('noWarnSet') then
            return lang_text('noWarnSet')
        else
            if matches[1]:lower() == 'getuserwarns' or matches[1]:lower() == 'sasha ottieni avvertimenti' or matches[1]:lower() == 'ottieni avvertimenti' then
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, getWarn_by_reply, false)
                elseif string.match(matches[2], '^%d+$') then
                    return get_user_warns(msg.from.id, msg.to.id)
                else
                    resolve_username(string.gsub(matches[2], '@', ''), getWarn_by_username, { msg = msg })
                end
            end
            if matches[1]:lower() == 'warn' or matches[1]:lower() == 'sasha avverti' or matches[1]:lower() == 'avverti' then
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, Warn_by_reply, false)
                elseif string.match(matches[2], '^%d+$') then
                    if tonumber(matches[2]) == tonumber(our_id) then
                        return
                    end
                    if is_momod2(matches[2], msg.to.id) then
                        return lang_text('cantWarnHigher')
                    end
                    local user_id = matches[2]
                    local chat_id = msg.to.id
                    local print_name = user_print_name(msg.from):gsub("‮", "")
                    local name = print_name:gsub("_", "")
                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] warned user " .. matches[2])
                    warn_user(user_id, chat_id)
                else
                    resolve_username(string.gsub(matches[2], '@', ''), Warn_by_username, { msg = msg })
                end
            end
            if matches[1]:lower() == 'unwarn' or matches[1]:lower() == 'sasha azzera avvertimenti' or matches[1]:lower() == 'azzera avvertimenti' then
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, Unwarn_by_reply, false)
                elseif string.match(matches[2], '^%d+$') then
                    local user_id = matches[2]
                    local chat_id = msg.to.id
                    local print_name = user_print_name(msg.from):gsub("‮", "")
                    local name = print_name:gsub("_", "")
                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] unwarned user " .. matches[2])
                    unwarn_user(user_id, chat_id)
                else
                    resolve_username(string.gsub(matches[2], '@', ''), Unwarn_by_username, { msg = msg })
                end
            end
        end
    else
        return lang_text('require_mod')
    end
end

return {
    description = "WARN",
    usage =
    {
        "MOD",
        "#setwarn <value>: Sasha imposta gli avvertimenti massimi a <value>.",
        "#getwarn: Sasha manda il numero di avvertimenti massimi.",
        "(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>: Sasha manda il numero di avvertimenti ricevuti dall'utente.",
        "(#warn|[sasha] avverti) <id>|<username>|<reply>: Sasha avverte l'utente.",
        "(#unwarn|[sasha] azzera avvertimenti) <id>|<username>|<reply>: Sasha azzera gli avvertimenti dell'utente.",
    },
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt][Ww][Aa][Rr][Nn]) (%d+)$",
        "^[#!/]([Gg][Ee][Tt][Ww][Aa][Rr][Nn])$",
        "^[#!/]([Gg][Ee][Tt][Uu][Ss][Ee][Rr][Ww][Aa][Rr][Nn][Ss]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Uu][Ss][Ee][Rr][Ww][Aa][Rr][Nn][Ss])$",
        "^[#!/]([Ww][Aa][Rr][Nn]) (.*)$",
        "^[#!/]([Ww][Aa][Rr][Nn])$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn]) (.*)$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn])$",
        -- getuserwarns
        "^([Ss][Aa][Ss][Hh][Aa] [Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        "^([Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        -- warn
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii])$",
        "^([Aa][Vv][Vv][Ee][Rr][Tt][Ii]) (.*)$",
        "^([Aa][Vv][Vv][Ee][Rr][Tt][Ii])$",
        -- unwarn
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
    },
    run = run,
    min_rank = 1
}