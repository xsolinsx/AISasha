local function get_message_callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
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
    local receiver = extra.receiver
    local hash = "whitelist"
    local is_whitelisted = redis:sismember(hash, user_id)
    if is_whitelisted then
        redis:srem(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistRemoved)
    else
        redis:sadd(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistAdded)
    end
end

local function whitelist_res(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local user_id = result.peer_id
    local receiver = extra.receiver
    local hash = "whitelist"
    local is_whitelisted = redis:sismember(hash, user_id)
    if is_whitelisted then
        redis:srem(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistRemoved)
    else
        redis:sadd(hash, user_id)
        send_large_msg(receiver, langs[lang].userBot .. user_id .. langs[lang].whitelistAdded)
    end
end

local function run(msg, matches)
    if matches[1]:lower() == "whitelist" and is_admin1(msg) then
        local hash = "whitelist"
        local user_id = ""
        if type(msg.reply_id) ~= "nil" then
            local receiver = get_receiver(msg)
            get_message(msg.reply_id, get_message_callback, { receiver = receiver })
        elseif matches[2] then
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
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                resolve_username(username, whitelist_res, { receiver = receiver })
            end
        else
            local hash = 'whitelist'
            local list = redis:smembers(hash)
            local text = langs[msg.lang].whitelistStart
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

    if matches[1]:lower() == "clean whitelist" and is_admin1(msg) then
        local hash = 'whitelist'
        redis:del(hash)
        return langs[msg.lang].whitelistCleaned
    end
end

return {
    description = "WHITELIST",
    patterns =
    {
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt]) (.*)$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn] [Ww][Hh][Ii][Tt][Ee][Ll][Ii][Ss][Tt])$"
    },
    run = run,
    min_rank = 3
    -- usage
    -- ADMIN
    -- #whitelist <id>|<username>|<reply>
    -- #clean whitelist
}