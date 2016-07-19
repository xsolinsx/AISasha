local data = load_data(_config.moderation.data)

local function set_warn(user_id, chat_id, value)
    if tonumber(value) < 0 or tonumber(value) > 10 then
        return langs['it'].errorWarnRange
    end
    local warn_max = value
    data[tostring(chat_id)]['settings']['warn_max'] = warn_max
    save_data(_config.moderation.data, data)
    savelog(chat_id, " [" .. user_id .. "] set warn to [" .. value .. "]")
    return langs['it'].warnSet .. value
end

local function get_warn(chat_id)
    local warn_max = data[tostring(chat_id)]['settings']['warn_max']
    if not warn_max then
        return langs['it'].noWarnSet
    end
    return langs['it'].warnSet .. warn_max
end

local function get_user_warns(user_id, chat_id)
    local hashonredis = redis:get(chat_id .. ':warn:' .. user_id)
    local warn_msg = langs['it'].yourWarnings
    local warn_chat = string.match(get_warn(chat_id), "%d+")

    if hashonredis then
        warn_msg = string.gsub(string.gsub(warn_msg, 'Y', warn_chat), 'X', tostring(hashonredis))
        send_large_msg('chat#id' .. chat_id, warn_msg)
        send_large_msg('channel#id' .. chat_id, warn_msg)
    else
        warn_msg = string.gsub(string.gsub(warn_msg, 'Y', warn_chat), 'X', '0')
        send_large_msg('chat#id' .. chat_id, warn_msg)
        send_large_msg('channel#id' .. chat_id, warn_msg)
    end
end

local function warn_user(user_id, chat_id)
    local warn_chat = string.match(get_warn(chat_id), "%d+")
    redis:incr(chat_id .. ':warn:' .. user_id)
    local hashonredis = redis:get(chat_id .. ':warn:' .. user_id)
    if not hashonredis then
        redis:set(chat_id .. ':warn:' .. user_id, 1)
        send_large_msg('chat#id' .. chat_id, string.gsub(langs['it'].warned, 'X', '1'))
        send_large_msg('channel#id' .. chat_id, string.gsub(langs['it'].warned, 'X', '1'))
        hashonredis = 1
    end
    if tonumber(warn_chat) ~= 0 then
        if tonumber(hashonredis) >= tonumber(warn_chat) then
            redis:getset(chat_id .. ':warn:' .. user_id, 0)
            local function post_kick()
                kick_user_any(user_id, chat_id)
            end
            postpone(post_kick, false, 3)
        end
        send_large_msg('chat#id' .. chat_id, string.gsub(langs['it'].warned, 'X', tostring(hashonredis)))
        send_large_msg('channel#id' .. chat_id, string.gsub(langs['it'].warned, 'X', tostring(hashonredis)))
    end
end

local function unwarn_user(user_id, chat_id)
    local warns = redis:get(chat_id .. ':warn:' .. user_id)
    if tonumber(warns) <= 0 then
        redis:set(chat_id .. ':warn:' .. user_id, 0)
        send_large_msg('chat#id' .. chat_id, langs['it'].alreadyZeroWarnings)
        send_large_msg('channel#id' .. chat_id, langs['it'].alreadyZeroWarnings)
    else
        redis:set(chat_id .. ':warn:' .. user_id, warns - 1)
        send_large_msg('chat#id' .. chat_id, langs['it'].unwarned)
        send_large_msg('channel#id' .. chat_id, langs['it'].unwarned)
    end
end

local function unwarnall_user(user_id, chat_id)
    redis:set(chat_id .. ':warn:' .. user_id, 0)
    send_large_msg('chat#id' .. chat_id, langs['it'].zeroWarnings)
    send_large_msg('channel#id' .. chat_id, langs['it'].zeroWarnings)
end

local function warn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, langs['it'].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        warn_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] warned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] warned user " .. result.peer_id .. " N")
    end
end

local function warn_by_reply(extra, success, result)
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        warn_user(result.from.peer_id, result.to.peer_id)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.from.peer_id .. " N")
    end
end

local function unwarn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, langs['it'].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unwarn_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarned user " .. result.peer_id .. " N")
    end
end

local function unwarn_by_reply(extra, success, result)
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        unwarn_user(result.from.peer_id, result.to.peer_id)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.from.peer_id .. " N")
    end
end

local function unwarnall_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, langs['it'].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unwarnall_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarnedall user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarnedall user " .. result.peer_id .. " N")
    end
end

local function unwarnall_by_reply(extra, success, result)
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        unwarnall_user(result.from.peer_id, result.to.peer_id)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs['it'].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.from.peer_id .. " N")
    end
end

local function getWarn_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, langs['it'].noUsernameFound)
    end
    get_user_warns(result.peer_id, extra.chat_id)
    savelog(extra.chat_id, "[" .. extra.executer .. "] get warns of " .. result.peer_id .. " Y")
end

local function getWarn_by_reply(extra, success, result)
    get_user_warns(result.from.peer_id, result.to.peer_id)
    savelog(result.to.peer_id, "[" .. extra.executer .. "] get warns of " .. result.from.peer_id .. " Y")
end

local function run(msg, matches)
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        if is_momod(msg) then
            if matches[1]:lower() == 'setwarn' and matches[2] then
                local txt = set_warn(msg.from.id, msg.to.id, matches[2])
                if matches[2] == '0' then
                    return langs['it'].neverWarn
                else
                    return txt
                end
            end
            if matches[1]:lower() == 'getwarn' then
                return get_warn(msg.to.id)
            end
            if get_warn(msg.to.id) == langs['it'].noWarnSet then
                return langs['it'].noWarnSet
            else
                if matches[1]:lower() == 'getuserwarns' or matches[1]:lower() == 'sasha ottieni avvertimenti' or matches[1]:lower() == 'ottieni avvertimenti' then
                    if type(msg.reply_id) ~= "nil" then
                        get_message(msg.reply_id, getWarn_by_reply, { executer = msg.from.id })
                    elseif string.match(matches[2], '^%d+$') then
                        get_user_warns(msg.from.id, msg.to.id)
                    else
                        resolve_username(string.gsub(matches[2], '@', ''), getWarn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                    return
                end
                if matches[1]:lower() == 'warn' or matches[1]:lower() == 'sasha avverti' or matches[1]:lower() == 'avverti' then
                    if type(msg.reply_id) ~= "nil" then
                        get_message(msg.reply_id, warn_by_reply, { receiver = receiver, executer = msg.from.id })
                    elseif string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            warn_user(matches[2], msg.to.id)
                            savelog(msg.to.id, "[" .. msg.from.id .. "] warned user " .. matches[2])
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] warned user " .. matches[2])
                            return langs['it'].require_rank
                        end
                    else
                        resolve_username(string.gsub(matches[2], '@', ''), warn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                    return
                end
                if matches[1]:lower() == 'unwarn' then
                    if type(msg.reply_id) ~= "nil" then
                        get_message(msg.reply_id, unwarn_by_reply, { receiver = receiver, executer = msg.from.id })
                    elseif string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            unwarn_user(matches[2], msg.to.id)
                            savelog(msg.to.id, "[" .. msg.from.id .. "] unwarned user " .. matches[2])
                            return
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] unwarned user " .. matches[2])
                            return langs['it'].require_rank
                        end
                    else
                        resolve_username(string.gsub(matches[2], '@', ''), unwarn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                end
                if matches[1]:lower() == 'unwarnall' or matches[1]:lower() == 'sasha azzera avvertimenti' or matches[1]:lower() == 'azzera avvertimenti' then
                    if type(msg.reply_id) ~= "nil" then
                        get_message(msg.reply_id, unwarnall_by_reply, { receiver = receiver, executer = msg.from.id })
                    elseif string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            unwarnall_user(matches[2], msg.to.id)
                            savelog(msg.to.id, "[" .. msg.from.id .. "] unwarnedall user " .. matches[2])
                            return
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] unwarnedall user " .. matches[2])
                            return langs['it'].require_rank
                        end
                    else
                        resolve_username(string.gsub(matches[2], '@', ''), unwarnall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                end
            end
        else
            return langs['it'].require_mod
        end
    else
        return langs['it'].useYourGroups
    end
end

return {
    description = "WARN",
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
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn][Aa][Ll][Ll]) (.*)$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn][Aa][Ll][Ll])$",
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
        -- unwarnall
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) (.*)$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- #setwarn <value>
    -- #getwarn
    -- (#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>
    -- (#warn|[sasha] avverti) <id>|<username>|<reply>
    -- #unwarn <id>|<username>|<reply>
    -- (#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>
}