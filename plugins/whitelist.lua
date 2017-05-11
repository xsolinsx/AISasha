local function whitelist_reply(extra, success, result)
    local receiver = extra.receiver
    local lang = get_lang(string.match(receiver, '%d+'))
    if get_reply_receiver(result) == receiver then
        if result.service then
            local action = result.action.type
            if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
                if result.action.user then
                    user_id = result.action.user.peer_id
                end
            end
        else
            user_id = result.from.peer_id
        end
        local hash = "whitelist:" .. string.match(receiver, '%d+')
        local is_whitelisted = redis:sismember(hash, user_id)
        if is_whitelisted then
            redis:srem(hash, user_id)
            send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistRemoved)
        else
            redis:sadd(hash, user_id)
            send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistAdded)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function whitelist_res(extra, success, result)
    local receiver = extra.receiver
    local lang = get_lang(string.match(receiver, '%d+'))
    local user_id = result.peer_id
    local hash = "whitelist:" .. string.match(receiver, '%d+')
    local is_whitelisted = redis:sismember(hash, user_id)
    if is_whitelisted then
        redis:srem(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistRemoved)
    else
        redis:sadd(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistAdded)
    end
end

local function whitelist_gban_reply(extra, success, result)
    local receiver = extra.receiver
    local lang = get_lang(string.match(receiver, '%d+'))
    if get_reply_receiver(result) == receiver then
        if result.service then
            local action = result.action.type
            if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
                if result.action.user then
                    user_id = result.action.user.peer_id
                end
            end
        else
            user_id = result.from.peer_id
        end
        local hash = "whitelist:gban:" .. string.match(receiver, '%d+')
        local is_whitelisted = redis:sismember(hash, user_id)
        if is_whitelisted then
            redis:srem(hash, user_id)
            send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistGbanRemoved)
        else
            redis:sadd(hash, user_id)
            send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistGbanAdded)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function whitelist_gban_res(extra, success, result)
    local receiver = extra.receiver
    local lang = get_lang(string.match(receiver, '%d+'))
    local user_id = result.peer_id
    local hash = "whitelist:gban:" .. string.match(receiver, '%d+')
    local is_whitelisted = redis:sismember(hash, user_id)
    if is_whitelisted then
        redis:srem(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistGbanRemoved)
    else
        redis:sadd(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistGbanAdded)
    end
end

local function run(msg, matches)
    if not msg.api_patch then
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            if matches[1]:lower() == "whitelist" then
                local hash = "whitelist:" .. msg.to.id
                local user_id = ""
                if type(msg.reply_id) ~= "nil" then
                    if is_owner(msg) then
                        local receiver = get_receiver(msg)
                        get_message(msg.reply_id, whitelist_reply, { receiver = receiver })
                    else
                        return langs[msg.lang].require_owner
                    end
                elseif matches[2] and matches[2] ~= '' then
                    if is_owner(msg) then
                        if string.match(matches[2], '^%d+$') then
                            local user_id = matches[2]
                            local is_whitelisted = redis:sismember(hash, user_id)
                            if is_whitelisted then
                                redis:srem(hash, user_id)
                                return langs[msg.lang].userBot .. user_id .. langs[msg.lang].whitelistRemoved
                            else
                                redis:sadd(hash, user_id)
                                return langs[msg.lang].userBot .. user_id .. langs[msg.lang].whitelistAdded
                            end
                        else
                            local receiver = get_receiver(msg)
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), whitelist_res, { receiver = receiver })
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                else
                    local hash = 'whitelist:' .. msg.to.id
                    local list = redis:smembers(hash)
                    local text = langs[msg.lang].whitelistStart .. msg.to.print_name .. '\n'
                    for k, v in pairs(list) do
                        local user_info = redis:hgetall('user:' .. v)
                        if user_info and user_info.print_name then
                            local print_name = string.gsub(user_info.print_name, "_", " ")
                            text = text .. k .. " - " .. print_name .. " [" .. v .. "]\n"
                        else
                            text = text .. k .. " - " .. v .. "\n"
                        end
                    end
                    return text
                end
            end
            if matches[1]:lower() == "clean whitelist" then
                if is_owner(msg) then
                    redis:del('whitelist:' .. msg.to.id)
                    return langs[msg.lang].whitelistCleaned
                else
                    return langs[msg.lang].require_owner
                end
            end
            if matches[1]:lower() == "whitelistgban" then
                local hash = "whitelist:gban:" .. msg.to.id
                local user_id = ""
                if type(msg.reply_id) ~= "nil" then
                    if is_owner(msg) then
                        local receiver = get_receiver(msg)
                        get_message(msg.reply_id, whitelist_gban_reply, { receiver = receiver })
                    else
                        return langs[msg.lang].require_owner
                    end
                elseif matches[2] and matches[2] ~= '' then
                    if is_owner(msg) then
                        if string.match(matches[2], '^%d+$') then
                            local user_id = matches[2]
                            local is_whitelisted = redis:sismember(hash, user_id)
                            if is_whitelisted then
                                redis:srem(hash, user_id)
                                return langs[msg.lang].userBot .. user_id .. langs[msg.lang].whitelistGbanRemoved
                            else
                                redis:sadd(hash, user_id)
                                return langs[msg.lang].userBot .. user_id .. langs[msg.lang].whitelistGbanAdded
                            end
                        else
                            local receiver = get_receiver(msg)
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), whitelist_gban_res, { receiver = receiver })
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                else
                    local hash = 'whitelist:gban:' .. msg.to.id
                    local list = redis:smembers(hash)
                    local text = langs[msg.lang].whitelistGbanStart .. msg.to.print_name .. '\n'
                    for k, v in pairs(list) do
                        local user_info = redis:hgetall('user:' .. v)
                        if user_info and user_info.print_name then
                            local print_name = string.gsub(user_info.print_name, "_", " ")
                            text = text .. k .. " - " .. print_name .. " [" .. v .. "]\n"
                        else
                            text = text .. k .. " - " .. v .. "\n"
                        end
                    end
                    return text
                end
            end
            if matches[1]:lower() == "clean whitelistgban" then
                if is_owner(msg) then
                    redis:del('whitelist:gban:' .. msg.to.id)
                    return langs[msg.lang].whitelistGbanCleaned
                else
                    return langs[msg.lang].require_owner
                end
            end
        end
    end
end

return {
    description = "WHITELIST",
    patterns =
    {
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt][Gg][Bb][Aa][Nn])$",
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt]) ([^%s]+)$",
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt][Gg][Bb][Aa][Nn]) ([^%s]+)$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn] [Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn] [Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt][Gg][Bb][Aa][Nn])$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#whitelist",
        "#whitelistgban",
        "OWNER",
        "#whitelist <id>|<username>|<reply>",
        "#whitelistgban <id>|<username>|<reply>",
        "#clean whitelist",
        "#clean whitelistgban",
    },
}