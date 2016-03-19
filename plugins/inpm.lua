local function pre_process(msg)
    local to = msg.to.type
    local service = msg.service
    if to == 'user' and msg.fwd_from then
        if not is_support(msg.from.id) and not is_admin1(msg) then
            return
        end
        local user = 'user#id' .. msg.from.id
        local from_id = msg.fwd_from.peer_id
        if msg.fwd_from.first_name then
            from_first_name = msg.fwd_from.first_name:gsub("_", " ")
        else
            from_first_name = lang_text('none')
        end
        if msg.fwd_from.last_name then
            from_last_name = msg.fwd_from.last_name:gsub("_", " ")
        else
            from_last_name = lang_text('none')
        end
        if msg.fwd_from.username then
            from_username = "@" .. msg.fwd_from.username
        else
            from_username = lang_text('none')
        end
        text = lang_text('userInfo') .. "\n\nID: " .. from_id .. lang_text('name') .. from_first_name .. lang_text('surname') .. from_last_name .. lang_text('username') .. from_username
        send_large_msg(user, text)
    end
    return msg
end

local function chat_list(msg)
    i = 1
    local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return lang_text('noGroups')
    end
    local message = lang_text('groupsJoin')
    for k, v in pairsByKeys(data[tostring(groups)]) do
        local group_id = v
        if data[tostring(group_id)] then
            settings = data[tostring(group_id)]['settings']
        end
        if settings then
            if not settings.public then
                public = 'no'
            else
                public = settings.public
            end
        end
        for m, n in pairsByKeys(settings) do
            -- if m == 'public' then
            -- public = n
            -- end
            if public == 'no' then
                group_info = ""
            elseif m == 'set_name' and public == 'yes' then
                name = n:gsub("", "")
                chat_name = name:gsub("‮", "")
                group_name_id = name .. '\n(ID: ' .. group_id .. ')\n\n'
                if name:match("[\216-\219][\128-\191]") then
                    group_info = i .. '. \n' .. group_name_id
                else
                    group_info = i .. '. ' .. group_name_id
                end
                i = i + 1
            end
        end
        message = message .. group_info
    end
    local file = io.open("./groups/lists/listed_groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

local function run(msg, matches)
    local to = msg.to.type
    local service = msg.service
    local name_log = user_print_name(msg.from)
    if to == 'user' or service or is_admin1(msg) and to == "chat" or to == "channel" then
        if is_gbanned(msg.from.id) then
            return lang_text('youGbanned')
        end
        if matches[1]:lower() == 'join' then
            local data = load_data(_config.moderation.data)
            if string.match(matches[2], '^%d+$') then
                local long_id = tostring(data[tostring(matches[2])]['long_id'])
                if not data[tostring(matches[2])] then
                    return lang_text('chatNotFound')
                end
                group_name = data[tostring(matches[2])]['settings']['set_name']
                if is_admin1(msg) then
                    user_type = 'admin'
                    local receiver = get_receiver(msg)
                    local chat = long_id
                    local channel = long_id
                    local user = msg.from.peer_id
                    chat_add_user(chat, user, ok_cb, false)
                    channel_set_admin(channel, user, ok_cb, false)
                end
                if is_support(msg.from.id) and not is_admin1(msg) and not is_owner2(msg.fom.id, matches[2]) then
                    user_type = "support"
                    local receiver = get_receiver(msg)
                    local chat = long_id
                    local channel = long_id
                    local user = msg.from.peer_id
                    chat_add_user(chat, user, ok_cb, false)
                    channel_set_mod(channel, user, ok_cb, false)
                end
                if is_banned(msg.from.id, matches[2]) then
                    return lang_text('youBanned')
                end
                if data[tostring(matches[2])]['settings']['lock_member'] == 'yes' and not is_owner2(msg.from.id, matches[2]) then
                    return lang_text('privateGroup')
                end
                if not is_support(msg.from.id) and not is_admin1(msg) then
                    user_type = "regular"
                    local chat = long_id
                    local channel = long_id
                    local user = msg.from.peer_id
                    chat_add_user(chat, user, ok_cb, false)
                    channel_invite(channel, user, ok_cb, false)
                end
            end
        end
    end

    if msg.service and user_type == "support" and msg.action.type == "chat_add_user" and msg.from.id == 0 then
        local user_id = msg.action.user.id
        local user_name = msg.action.user.print_name
        local username = msg.action.user.username
        local group_name = string.gsub(msg.to.print_name, '_', ' ')
        savelog(msg.from.id, "Added Support member " .. user_name .. " to chat " .. group_name .. " (ID:" .. msg.to.id .. ")")
        if username then
            send_large_msg("user#id" .. user_id, lang_text('supportAdded') .. "@" .. username .. " " .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        else
            send_large_msg("user#id" .. user_id, lang_text('supportAdded') .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        end
    end
    if msg.service and user_type == "admin" and msg.action.type == "chat_add_user" and msg.from.id == 0 then
        local user_id = msg.action.user.id
        local user_name = msg.action.user.print_name
        local username = msg.action.user.username
        savelog(msg.from.id, "Added Admin " .. user_name .. "  " .. user_id .. " to chat " .. group_name .. " (ID:" .. msg.to.id .. ")")
        if username then
            send_large_msg("user#id" .. user_id, lang_text('adminAdded') .. "@" .. username .. "[" .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        else
            send_large_msg("user#id" .. user_id, lang_text('adminAdded') .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        end
    end

    if msg.service and user_type == "regular" and msg.action.type == "chat_add_user" and msg.from.id == 0 then
        local user_id = msg.action.user.id
        local user_name = msg.action.user.print_name
        print("Added " .. user_id .. " to chat " .. msg.to.print_name .. " (ID:" .. msg.to.id .. ")")
        savelog(msg.from.id, "Added " .. user_name .. " to chat " .. msg.to.print_name .. " ID:" .. msg.to.id)
        send_large_msg("user#id" .. user_id, lang_text('addedTo') .. group_name .. " ID:" .. msg.to.id)
    end

    if matches[1]:lower() == 'chats' and is_admin1(msg) then
        return chat_list(msg)
    elseif matches[1] == 'chats' and to == 'user' then
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] Used /chats")
        return chat_list(msg)
    end

    if matches[1]:lower() == 'chatlist' then
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] Used /chatlist")
        if is_admin1(msg) and msg.to.type == 'chat' or msg.to.type == 'channel' then
            chat_list(msg)
            send_document("chat#id" .. msg.to.id, "./groups/lists/listed_groups.txt", ok_cb, false)
            send_document("channel#id" .. msg.to.id, "./groups/lists/listed_groups.txt", ok_cb, false)
        elseif msg.to.type == 'user' then
            chat_list(msg)
            send_document("user#id" .. msg.from.id, "./groups/lists/listed_groups.txt", ok_cb, false)
        end
    end
end

return {
    description = "INPM",
    usage =
    {
        "/chats: Sasha mostra un elenco di chat.",
        "/chatlist: Sasha manda un file con un elenco di chat.",
        "/join <chat_id> [support]: Sasha tenta di aggiungere l'utente a <chat_id>.",
    },
    patterns =
    {
        "^[#!/]([cC][hH][aA][tT][sS])$",
        "^[#!/]([cC][hH][aA][tT][lL][iI][sS][tT])$",
        "^[#!/]([jJ][oO][iI][nN]) (%d+)$",
        "^[#!/]([jJ][oO][iI][nN]) (.*) ([sS][uU][pP][pP][oO][rR][tT])$",
        "^!!tgservice (chat_add_user)$",
    },
    run = run,
    pre_process = pre_process
}