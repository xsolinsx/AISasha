--[[local function usernameinfo(user)
    if user.username then
        return '@' .. user.username
    end
    if user.print_name then
        return user.print_name
    end
    local text = ''
    if user.first_name then
        text = user.last_name .. ' '
    end
    if user.lastname then
        text = text .. user.last_name
    end
    return text
end

local function whoisname(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    if chat_type == 'chat' then
        send_msg('chat#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. user_username .. ' (' .. user_id .. ')', ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. user_username .. ' (' .. user_id .. ')', ok_cb, false)
    end
end

local function whoisid(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = cb_extra.user_id
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. result.username .. ' (' .. user_id .. ')', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. result.username .. ' (' .. user_id .. ')', ok_cb, false)
    end
end

local function channelUserIDs(extra, success, result)
    local receiver = extra.receiver
    print('Result')
    vardump(result)
    local text = ''
    for k, user in ipairs(result) do
        local id = user.peer_id
        local username = usernameinfo(user)
        text = text ..("%s - %s\n"):format(username, id)
    end
    send_large_msg(receiver, text)
end

local function get_id_who(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        send_msg('chat#id' .. msg.to.id, '🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
    elseif msg.to.type == 'channel' then
        send_msg('channel#id' .. msg.to.id, '🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
    end
end

local function returnids(extra, success, result)
    local receiver = extra.receiver
    local chatname = result.print_name
    local id = result.peer_id
    local text =('ID for chat %s (%s):\n'):format(chatname, id)
    for k, user in ipairs(result.members) do
        local username = usernameinfo(user)
        local id = user.peer_id
        local userinfo =("%s - %s\n"):format(username, id)
        text = text .. userinfo
    end
    send_large_msg(receiver, text)
end]]

-- OLDINFOFUNCTIONS
local function callback_reply(extra, success, result)
    local text = 'INFO (<reply>)'
    if result.from.first_name then
        text = text .. '\nNome: ' .. result.from.first_name
    end
    if result.from.real_first_name then
        text = text .. '\nNome: ' .. result.from.real_first_name
    end
    if result.from.last_name then
        text = text .. '\nCognome: ' .. result.from.last_name
    end
    if result.from.real_last_name then
        text = text .. '\nCognome: ' .. result.from.real_last_name
    end
    if result.from.username then
        text = text .. '\nUsername: @' .. result.from.username
    end
    text = text .. '\nId: ' .. result.from.peer_id
    send_large_msg('chat#id' .. result.to.peer_id, text)
    send_large_msg('channel#id' .. result.to.peer_id, text)
end

local function callback_id(cb_extra, success, result)
    local text = 'INFO (<id>)'
    if result.first_name then
        text = text .. '\nNome: ' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\nNome: ' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\nCognome: ' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\nCognome: ' .. result.real_last_name
    end
    if result.username then
        text = text .. '\nUsername: @' .. result.username
    end
    text = text .. '\nId: ' .. result.peer_id
    send_large_msg('chat#id' .. cb_extra.msg.to.id, text)
    send_large_msg('channel#id' .. cb_extra.msg.to.id, text)
end

local function callback_username(extra, success, result)
    local text = 'INFO (<username>)'
    if result.first_name then
        text = text .. '\nNome: ' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\nNome: ' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\nCognome: ' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\nCognome: ' .. result.real_last_name
    end
    if result.username then
        text = text .. '\nUsername: @' .. result.username
    end
    text = text .. '\nId: ' .. result.peer_id
    send_large_msg('chat#id' .. extra.chatid, text)
    send_large_msg('channel#id' .. extra.chatid, text)
end

local function callback_from(extra, success, result)
    local text = 'INFO (<from>)'
    if result.fwd_from.first_name then
        text = text .. '\nNome: ' .. result.fwd_from.first_name
    end
    if result.fwd_from.real_first_name then
        text = text .. '\nNome: ' .. result.fwd_from.real_first_name
    end
    if result.fwd_from.last_name then
        text = text .. '\nCognome: ' .. result.fwd_from.last_name
    end
    if result.fwd_from.real_last_name then
        text = text .. '\nCognome: ' .. result.fwd_from.real_last_name
    end
    if result.fwd_from.username then
        text = text .. '\nUsername: @' .. result.fwd_from.username
    end
    text = text .. '\nId: ' .. result.fwd_from.peer_id
    send_large_msg('chat#id' .. result.to.peer_id, text)
    send_large_msg('channel#id' .. result.to.peer_id, text)
end

local function channel_callback_info(cb_extra, success, result)
    local title = lang_text('infoFor') .. result.title .. "\n"
    local user_num = lang_text('users') .. result.participants_count
    local admin_num = lang_text('admins') .. result.admins_count
    local kicked_num = lang_text('kickedUsers') .. result.kicked_count
    local channel_id = "\nID: " .. result.peer_id
    if result.username then
        channel_username = lang_text('username') .. "@" .. result.username
    else
        channel_username = ""
    end
    local text = title .. admin_num .. user_num .. kicked_num .. channel_id .. channel_username
    send_large_msg(cb_extra.receiver, text)
end

local function chat_callback_info(cb_extra, success, result)
    local title = lang_text('infoFor') .. result.title .. "\n"
    local user_num = lang_text('users') .. result.members_num
    local chat_id = "\nID: " .. result.peer_id
    local text = title .. user_num .. chat_id
    send_large_msg(cb_extra.receiver, text)
end

local function database(cb_extra, success, result)
    local text
    local id
    local db = io.open("./data/db.txt", "a")
    for k, v in pairs(result.members) do
        text = ''
        id = ''
        if v.first_name then
            text = text .. ' Nome: ' .. v.first_name
        end
        if v.real_first_name then
            text = text .. ' Nome: ' .. v.real_first_name
        end
        if v.last_name then
            text = text .. ' Cognome: ' .. v.last_name
        end
        if v.real_last_name then
            text = text .. ' Cognome: ' .. v.real_last_name
        end
        if v.username then
            text = text .. ' Username: @' .. v.username
        end
        text = text .. ' Id: ' .. v.peer_id
        text = text .. ' Long_id: ' .. v.id
        id = v.peer_id
        db:write('"' .. id .. '" = "' .. text .. '"\n')
    end
    db:flush()
    db:close()
    send_msg('chat#id' .. result.peer_id, "Data leak.", ok_cb, false)
    post_large_msg('channel#id' .. result.peer_id, "Data leak.")
end
-- OLDINFOFUNCTIONS
--[[
local function get_msgs_user_chat(user_id, chat_id)
    local user_info = { }
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:' .. user_id .. ':' .. chat_id
    user_info.msgs = tonumber(redis:get(um_hash) or 0)
    user_info.name = user_print_name(user) .. ' [' .. user_id .. ']'
    return user_info
end
local function chat_stats(chat_id)
    local hash = 'chat:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )
    local text = 'Chat stats:\n'
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    return text
end

local function get_group_type(target)
    local data = load_data(_config.moderation.data)
    local group_type = data[tostring(target)]['group_type']
    if not group_type or group_type == nil then
        return 'No group type available.\nUse /type in the group to set type.'
    end
    return group_type
end

local function get_description(target)
    local data = load_data(_config.moderation.data)
    local data_cat = 'description'
    if not data[tostring(target)][data_cat] then
        return 'No description available.'
    end
    local about = data[tostring(target)][data_cat]
    return about
end

local function get_rules(target)
    local data = load_data(_config.moderation.data)
    local data_cat = 'rules'
    if not data[tostring(target)][data_cat] then
        return 'No rules available.'
    end
    local rules = data[tostring(target)][data_cat]
    return rules
end


local function modlist(target)
    local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] or not data[tostring(groups)][tostring(target)] then
        return 'Group is not added or is Realm.'
    end
    if next(data[tostring(target)]['moderators']) == nil then
        return 'No moderator in this group.'
    end
    local i = 1
    local message = '\nList of moderators :\n'
    for k, v in pairs(data[tostring(target)]['moderators']) do
        message = message .. i .. ' - @' .. v .. ' [' .. k .. '] \n'
        i = i + 1
    end
    return message
end

local function get_link(target)
    local data = load_data(_config.moderation.data)
    local group_link = data[tostring(target)]['settings']['set_link']
    if not group_link or group_link == nil then
        return "No link"
    end
    return "Group link:\n" .. group_link
end

local function all(msg, target, receiver)
    local text = "All the things I know about this group\n\n"
    local group_type = get_group_type(target)
    text = text .. "Group Type: \n" .. group_type
    if group_type == "Group" or group_type == "Realm" then
        local settings = show_group_settingsmod(msg, target)
        text = text .. "\n\n" .. settings
    elseif group_type == "SuperGroup" then
        local settings = show_supergroup_settingsmod(msg, target)
        text = text .. '\n\n' .. settings
    end
    local rules = get_rules(target)
    text = text .. "\n\nRules: \n" .. rules
    local description = get_description(target)
    text = text .. "\n\nAbout: \n" .. description
    local modlist = modlist(target)
    text = text .. "\n\nMods: \n" .. modlist
    local link = get_link(target)
    text = text .. "\n\nLink: \n" .. link
    local stats = chat_stats(target)
    text = text .. "\n\n" .. stats
    local mutes_list = mutes_list(target)
    text = text .. "\n\n" .. mutes_list
    local muted_user_list = muted_user_list(target)
    text = text .. "\n\n" .. muted_user_list
    local ban_list = ban_list(target)
    text = text .. "\n\n" .. ban_list
    local file = io.open("./groups/all/" .. target .. "all.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(receiver, "./groups/all/" .. target .. "all.txt", ok_cb, false)
    return
end]]

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    -- OLDINFO
    if matches[1]:lower() == 'info' or matches[1]:lower() == 'sasha info' then
        if not matches[2] then
            if type(msg.reply_id) ~= 'nil' then
                if is_momod(msg) then
                    return get_message(msg.reply_id, callback_reply, false)
                else
                    return lang_text('require_mod')
                end
            else
                local text = lang_text('info') ..
                lang_text('youAre')
                if msg.from.first_name then
                    text = text .. lang_text('name') .. msg.from.first_name
                end
                if msg.from.real_first_name then
                    text = text .. lang_text('name') .. msg.from.real_first_name
                end
                if msg.from.last_name then
                    text = text .. lang_text('surname') .. msg.from.last_name
                end
                if msg.from.real_last_name then
                    text = text .. lang_text('surname') .. msg.from.real_last_name
                end
                if msg.from.username then
                    text = text .. lang_text('username') .. '@' .. msg.from.username
                end
                text = text .. '\nId: ' .. msg.from.id ..
                lang_text('youAreWriting')
                if chat_type == 'user' then
                    if msg.to.first_name then
                        text = text .. lang_text('name') .. msg.to.first_name
                    end
                    if msg.to.real_first_name then
                        text = text .. lang_text('name') .. msg.to.real_first_name
                    end
                    if msg.to.last_name then
                        text = text .. lang_text('surname') .. msg.to.last_name
                    end
                    if msg.to.real_last_name then
                        text = text .. lang_text('surname') .. msg.to.real_last_name
                    end
                    if msg.to.username then
                        text = text .. lang_text('username') .. '@' .. msg.to.username
                    end
                    text = text .. '\nId: ' .. msg.to.id
                    return text
                elseif chat_type == 'chat' then
                    text = text ..
                    lang_text('groupName') .. msg.to.print_name:gsub("_", " ") ..
                    lang_text('members') .. msg.to.members_num ..
                    '\nId: ' .. math.abs(msg.to.id)
                    return text
                elseif chat_type == 'channel' then
                    text = text ..
                    lang_text('supergroupName') .. msg.to.print_name:gsub("_", " ") ..
                    '\nId: ' .. math.abs(msg.to.id)
                    return text
                end
            end
        elseif chat_type == 'chat' or chat_type == 'channel' then
            if is_momod(msg) then
                if matches[2]:lower() == 'from' and type(msg.reply_id) ~= "nil" then
                    get_message(msg.reply_id, callback_from, { msg = msg })
                    return
                elseif string.match(matches[2], '^%d+$') then
                    user_info('user#id' .. matches[2], callback_id, { msg = msg })
                    return
                else
                    resolve_username(matches[2]:gsub("@", ""), callback_username, { chatid = msg.to.id })
                    return
                end
            else
                return lang_text('require_mod')
            end
        end
    end
    if matches[1]:lower() == 'groupinfo' or matches[1]:lower() == 'sasha info gruppo' or matches[1]:lower() == 'info gruppo' then
        if is_owner(msg) then
            if chat_type == 'channel' then
                channel_info(receiver, channel_callback_info, { receiver = receiver, msg = msg })
            elseif chat_type == 'chat' then
                chat_info(receiver, chat_callback_info, { receiver = receiver })
            end
        else
            return lang_text('require_owner')
        end
    end
    if matches[1]:lower() == 'database' or matches[1]:lower() == 'sasha database' then
        if is_sudo(msg) then
            if chat_type == 'channel' then
                channel_info(receiver, database, { receiver = receiver, msg = msg })
            elseif chat_type == 'chat' then
                chat_info(receiver, database, { receiver = receiver })
            end
        else
            return lang_text('require_sudo')
        end
    end
    -- OLDINFO

    --[[ Id of the user and info about group / channel
    if matches[1]:lower() == "#id" then
        if permissions(msg.from.id, msg.to.id, "id") then
            if msg.to.type == 'channel' then
                send_msg(msg.to.peer_id, '🔠 ' .. lang_text(chat, 'supergroupName') .. ': ' .. msg.to.print_name:gsub("_", " ") .. '\n👥 ' .. lang_text(chat, 'supergroup') .. ' ID: ' .. msg.to.id .. '\n🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
            elseif msg.to.type == 'chat' then
                send_msg(msg.to.peer_id, '🔠 ' .. lang_text(chat, 'chatName') .. ': ' .. msg.to.print_name:gsub("_", " ") .. '\n👥 ' .. lang_text(chat, 'chat') .. ' ID: ' .. msg.to.id .. '\n🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
            end
        end
    elseif matches[1]:lower() == 'whois' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, { receiver = get_receiver(msg) })
                return
            end
            if is_id(matches[2]) then
                print(1)
                user_info('user#id' .. matches[2], whoisid, { chat_type = chat_type, chat_id = chat_id, user_id = matches[2] })
                return
            else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, { chat_id = chat_id, member = member, chat_type = chat_type })
                return
            end
        else
            return '🚫 ' .. lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1]:lower() == 'chat' or matches[1]:lower() == 'channel' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            local type = matches[1]
            local chanId = matches[2]
            -- !ids? (chat) (%d+)
            if chanId then
                local chan =("%s#id%s"):format(type, chanId)
                if type == 'chat' then
                    chat_info(chan, returnids, { receiver = receiver })
                else
                    channel_get_users(chan, channelUserIDs, { receiver = receiver })
                end
            else
                -- !id chat/channel
                local chan =("%s#id%s"):format(msg.to.type, msg.to.id)
                if msg.to.type == 'channel' then
                    channel_get_users(chan, channelUserIDs, { receiver = receiver })
                end
                if msg.to.type == 'chat' then
                    chat_info(chan, returnids, { receiver = receiver })
                end
            end
        else
            return '🚫 ' .. lang_text(msg.to.id, 'require_mod')
        end
    end]]
end

return {
    description = "INFO",
    usage =
    {
        "[#]|[sasha] database: Sasha salva i dati di tutti gli utenti.",
        "[#]|[sasha] info [<id>|<username>|<reply>]: Sasha manda le info dell'utente e della chat o di se stessa. Se è specificato uno dei parametri manda le informazioni richieste.",
        "(#groupinfo|[sasha] info gruppo) [<group_id>]: Sasha manda le info del gruppo specificato.",
    },
    patterns =
    {
        --[["^#([Ww][Hh][Oo][Ii][Ss])$",
        "^#[Ii][Dd]$",
        "^#[Ii][Dd][Ss]? ([Cc][Hh][Aa][Tt])$",
        "^#[Ii][Dd][Ss]? ([Cc][Hh][Aa][Nn][Nn][Ee][Ll])$",
        "^#([Ww][Hh][Oo][Ii][Ss]) (.*)$",]]
        "^[!/#]([dD][aA][tT][aA][bB][aA][sS][eE])$",
        "^[!/#]([gG][rR][oO][uU][pP][iI][nN][fF][oO])$",
        "^[!/#]([iI][nN][fF][oO])$",
        "^[!/#]([iI][nN][fF][oO]) (.*)$",
        -- database
        "^([sS][aA][sS][hH][aA] [dD][aA][tT][aA][bB][aA][sS][eE])$",
        -- groupinfo
        "^([sS][aA][sS][hH][aA] [iI][nN][fF][oO] [gG][rR][uU][pP][pP][oO])$",
        "^([iI][nN][fF][oO] [gG][rR][uU][pP][pP][oO])$",
        -- info
        "^([sS][aA][sS][hH][aA] [iI][nN][fF][oO])$",
        "^([sS][aA][sS][hH][aA] [iI][nN][fF][oO]) (.*)$",
    },
    run = run,
    min_rank = 0
}