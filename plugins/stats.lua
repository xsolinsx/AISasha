-- Returns a table with `name` and `msgs`
local function get_msgs_user_chat(user_id, chat_id)
    local user_info = { }
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:' .. user_id .. ':' .. chat_id
    user_info.msgs = tonumber(redis:get(um_hash) or 0)
    user_info.name = user_print_name(user) .. ' [' .. user_id .. ']'
    return user_info
end

local function chat_stats(receiver, chat_id)
    -- Users on chat
    local hash = 'chat:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }
    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end
    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )
    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    local file = io.open("./groups/lists/" .. chat_id .. "stats.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(receiver, "./groups/lists/" .. chat_id .. "stats.txt", ok_cb, false)
    return
    -- text
end

local function chat_stats2(chat_id)
    -- Users on chat
    local hash = 'chat:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }

    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end

    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )

    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    return text
end

local function bot_stats()

    local redis_scan = "local cursor = '0'" ..
    "local count = 0" ..
    "repeat" ..
    "local r = redis.call(\"SCAN\", cursor, \"MATCH\", KEYS[1])" ..
    "cursor = r[1]" ..
    "count = count + #r[2]" ..
    "until cursor == '0'" ..
    "return count"

    -- Users
    local hash = 'msgs:*:' .. our_id
    local r = redis:eval(redis_scan, 1, hash)
    local text = lang_text('users') .. r

    hash = 'chat:*:users'
    r = redis:eval(redis_scan, 1, hash)
    text = text .. lang_text('groups') .. r
    return text
end

local function run(msg, matches)
    if matches[1]:lower() == 'aisasha' then
        -- Put everything you like :)
        local about = _config.about_text
        local name = user_print_name(msg.from)
        savelog(msg.to.id, name .. " [" .. msg.from.id .. "] used /aisasha ")
        return about
    end
    --[[ file
        if matches[1]:lower() == "statslist" then
            if not is_momod(msg) then
                return lang_text('require_mod')
            end
            local chat_id = msg.to.id
            local name = user_print_name(msg.from)
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] requested group stats ")
            return chat_stats2(chat_id)
        end]]
    -- message
    if matches[1]:lower() == "stats" or matches[1]:lower() == "statslist" or matches[1]:lower() == "messages" or matches[1]:lower() == "sasha statistiche" or matches[1]:lower() == "sasha lista statistiche" or matches[1]:lower() == "sasha messaggi" then
        if not matches[2] then
            if not is_momod(msg) then
                return lang_text('require_mod')
            end
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                local receiver = get_receiver(msg)
                local chat_id = msg.to.id
                local name = user_print_name(msg.from)
                savelog(msg.to.id, name .. " [" .. msg.from.id .. "] requested group stats ")
                send_large_msg(receiver, chat_stats2(chat_id))
            else
                return
            end
        end
        if matches[2]:lower() == "aisasha" and matches[1]:lower() ~= "messages" and matches[1]:lower() ~= "sasha messaggi" then
            -- Put everything you like :)
            if not is_admin1(msg) then
                return lang_text('require_admin')
            else
                return bot_stats()
            end
        end
        if matches[2]:lower() == "group" or matches[2]:lower() == "gruppo" then
            if not is_admin1(msg) then
                return lang_text('require_admin')
            else
                send_large_msg(receiver, chat_stats2(matches[3]))
            end
        end
    end
end

return {
    description = "STATS",
    patterns =
    {
        "^[#!/]([Ss][Tt][Aa][Tt][Ss])$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss]) ([Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss]) ([Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",-- Put everything you like :)
        "^[#!/]?([Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",-- Put everything you like :)
                                                 -- stats
        "^[#!/]([Mm][Ee][Ss][Ss][Aa][Gg][Ee][Ss])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Mm][Ee][Ss][Ss][Aa][Gg][Gg][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Hh][Ee])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Hh][Ee])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Hh][Ee]) ([Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Hh][Ee]) ([Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",-- Put everything you like :)
    },
    run = run,
    min_rank = 0
    -- usage
    -- [#]aisasha
    -- MOD
    -- (#stats|#statslist|#messages|sasha statistiche|sasha lista statistiche|sasha messaggi)
    -- ADMIN
    -- (#stats|#statslist|#messages|sasha statistiche|sasha lista statistiche|sasha messaggi) group|gruppo <group_id>
    -- (#stats|#statslist|sasha statistiche|sasha lista statistiche) aisasha
}