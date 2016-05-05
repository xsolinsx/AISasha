local function chat_list(msg)
    local text = ''
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
                group_name_id = name .. '\n(ID: ' .. group_id .. ')\n'
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
    text = message

    i = 1
    local realms = 'realms'
    if not data[tostring(realms)] then
        return lang_text('noRealms')
    end
    message = lang_text('realmsJoin')
    for k, v in pairsByKeys(data[tostring(realms)]) do
        local realm_id = v
        if data[tostring(realm_id)] then
            settings = data[tostring(realm_id)]['settings']
        end
        for m, n in pairsByKeys(settings) do
            if m == 'set_name' then
                name = n:gsub("", "")
                chat_name = name:gsub("‮", "")
                realm_name_id = name .. '\n(ID: ' .. realm_id .. ')\n'
                if name:match("[\216-\219][\128-\191]") then
                    realm_info = i .. '. \n' .. realm_name_id
                else
                    realm_info = i .. '. ' .. realm_name_id
                end
                i = i + 1
            end
        end
        message = message .. realm_info
    end
    local file = io.open("./groups/lists/listed_realms.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return text
end

local function all_chats(msg)
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
        for m, n in pairsByKeys(settings) do
            if m == 'set_name' then
                name = n:gsub("", "")
                chat_name = name:gsub("‮", "")
                group_name_id = name .. '\n(ID: ' .. group_id .. ')\n'
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

    i = 1
    local realms = 'realms'
    if not data[tostring(realms)] then
        return lang_text('noRealms')
    end
    message = message .. '\n\n' .. lang_text('realmsJoin')
    for k, v in pairsByKeys(data[tostring(realms)]) do
        local realm_id = v
        if data[tostring(realm_id)] then
            settings = data[tostring(realm_id)]['settings']
        end
        for m, n in pairsByKeys(settings) do
            if m == 'set_name' then
                name = n:gsub("", "")
                chat_name = name:gsub("‮", "")
                realm_name_id = name .. '\n(ID: ' .. realm_id .. ')\n'
                if name:match("[\216-\219][\128-\191]") then
                    realm_info = i .. '. \n' .. realm_name_id
                else
                    realm_info = i .. '. ' .. realm_name_id
                end
                i = i + 1
            end
        end
        message = message .. realm_info
    end
    local file = io.open("./groups/lists/all_listed_groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

local function set_alias(msg, alias, groupid)
    local hash = 'groupalias'
    redis:hset(hash, alias, groupid)
    return lang_text('aliasSaved')
end

local function unset_alias(msg, alias)
    local hash = 'groupalias'
    redis:hdel(hash, alias)
    return lang_text('aliasDeleted')
end

-- TODO: add lock and unlock joins
local function run(msg, matches)
    local to = msg.to.type
    local service = msg.service
    local name_log = user_print_name(msg.from)
    if to == 'user' or service or is_admin1(msg) and to == "chat" or to == "channel" then
        if is_gbanned(msg.from.id) then
            return lang_text('youGbanned')
        end
        if matches[1]:lower() == 'join' and is_admin1(msg) then
            if string.match(matches[2], '^%d+$') then
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
                        -- local chat = long_id
                        -- local channel = long_id
                        local chat = 'chat#id' .. matches[2]
                        local channel = 'channel#id' .. matches[2]
                        local user = msg.from.peer_id
                        chat_add_user(chat, user, ok_cb, false)
                        channel_invite(channel, user, ok_cb, false)
                        -- channel_set_admin(channel, user, ok_cb, false)
                    end
                    if is_support(msg.from.id) and not is_admin1(msg) and not is_owner2(msg.fom.id, matches[2]) then
                        user_type = "support"
                        local receiver = get_receiver(msg)
                        -- local chat = long_id
                        -- local channel = long_id
                        local chat = 'chat#id' .. matches[2]
                        local channel = 'channel#id' .. matches[2]
                        local user = msg.from.peer_id
                        chat_add_user(chat, user, ok_cb, false)
                        channel_invite(channel, user, ok_cb, false)
                        -- channel_set_mod(channel, user, ok_cb, false)
                    end
                    if is_banned(msg.from.id, matches[2]) then
                        return lang_text('youBanned')
                    end
                    if data[tostring(matches[2])]['settings']['lock_member'] == 'yes' and not is_owner2(msg.from.id, matches[2]) then
                        return lang_text('privateGroup')
                    end
                    if not is_support(msg.from.id) and not is_admin1(msg) then
                        user_type = "regular"
                        -- local chat = long_id
                        -- local channel = long_id
                        local chat = 'chat#id' .. matches[2]
                        local channel = 'channel#id' .. matches[2]
                        local user = msg.from.peer_id
                        chat_add_user(chat, user, ok_cb, false)
                        channel_invite(channel, user, ok_cb, false)
                    end
                end
            else
                local hash = 'groupalias'
                local value = redis:hget(hash, matches[2]:lower())
                if value then
                    local chat = 'chat#id' .. value
                    local channel = 'channel#id' .. value
                    local user = msg.from.peer_id
                    chat_add_user(chat, user, ok_cb, false)
                    channel_invite(channel, user, ok_cb, false)
                    return
                else
                    return lang_text('noAliasFound')
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
            -- send_large_msg("user#id" .. user_id, lang_text('supportAdded') .. "@" .. username .. " " .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        else
            -- send_large_msg("user#id" .. user_id, lang_text('supportAdded') .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        end
    end
    if msg.service and user_type == "admin" and msg.action.type == "chat_add_user" and msg.from.id == 0 then
        local user_id = msg.action.user.id
        local user_name = msg.action.user.print_name
        local username = msg.action.user.username
        savelog(msg.from.id, "Added Admin " .. user_name .. "  " .. user_id .. " to chat " .. group_name .. " (ID:" .. msg.to.id .. ")")
        if username then
            -- send_large_msg("user#id" .. user_id, lang_text('adminAdded') .. "@" .. username .. " " .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        else
            -- send_large_msg("user#id" .. user_id, lang_text('adminAdded') .. user_id .. lang_text('toChat') .. group_name .. " ID:" .. msg.to.id)
        end
    end

    if msg.service and user_type == "regular" and msg.action.type == "chat_add_user" and msg.from.id == 0 then
        local user_id = msg.action.user.id
        local user_name = msg.action.user.print_name
        print("Added " .. user_id .. " to chat " .. msg.to.print_name .. " (ID:" .. msg.to.id .. ")")
        savelog(msg.from.id, "Added " .. user_name .. " to chat " .. msg.to.print_name .. " ID:" .. msg.to.id)
        -- send_large_msg("user#id" .. user_id, lang_text('addedTo') .. group_name .. " ID:" .. msg.to.id)
    end

    if matches[1]:lower() == 'chats' and is_admin1(msg) then
        return chat_list(msg)
    elseif matches[1] == 'chats' and to == 'user' then
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] Used /chats")
        return chat_list(msg)
    end

    if matches[1]:lower() == 'allchats' then
        if is_sudo(msg) then
            return all_chats(msg)
        else
            return lang_text('require_sudo')
        end
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

    if matches[1]:lower() == 'allchatslist' then
        if is_sudo(msg) then
            all_chats(msg)
            send_document("chat#id" .. msg.to.id, "./groups/lists/all_listed_groups.txt", ok_cb, false)
            send_document("channel#id" .. msg.to.id, "./groups/lists/all_listed_groups.txt", ok_cb, false)
        else
            return lang_text('require_sudo')
        end
    end

    if matches[1]:lower() == 'setalias' then
        if is_sudo(msg) then
            return set_alias(msg, matches[2]:gsub('_', ' '), matches[3])
        else
            return lang_text('require_sudo')
        end
    end

    if matches[1]:lower() == 'unsetalias' then
        if is_sudo(msg) then
            return unset_alias(msg, matches[2])
        else
            return lang_text('require_sudo')
        end
    end

    if matches[1]:lower() == 'getaliaslist' then
        if is_admin1(msg) then
            local hash = 'groupalias'
            local names = redis:hkeys(hash)
            local ids = redis:hvals(hash)
            local text = ''
            for i = 1, #names do
                text = text .. names[i] .. ' - ' .. ids[i] .. '\n'
            end
            return text
        else
            return lang_text('require_admin')
        end
    end
end

return {
    description = "INPM",
    patterns =
    {
        "^[#!/]([Cc][Hh][Aa][Tt][Ss])$",
        "^[#!/]([Cc][Hh][Aa][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Jj][Oo][Ii][Nn]) (%d+)$",
        "^[#!/]([Jj][Oo][Ii][Nn]) (.*) ([Ss][Uu][Pp][Pp][Oo][Rr][Tt])$",
        "^[#!/]([Aa][Ll][Ll][Cc][Hh][Aa][Tt][Ss])$",
        "^[#!/]([Aa][Ll][Ll][Cc][Hh][Aa][Tt][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ss][Ee][Tt][Aa][Ll][Ii][Aa][Ss]) ([^%s]+) (%d+)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Aa][Ll][Ii][Aa][Ss]) ([^%s]+)$",
        "^[#!/]([Gg][Ee][Tt][Aa][Ll][Ii][Aa][Ss][Ll][Ii][Ss][Tt])$",
        "^!!tgservice (chat_add_user)$",
        -- join
        "^[#!/]([Jj][Oo][Ii][Nn]) (.*)$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0
    -- usage
    -- #chats
    -- #chatlist
    -- ADMIN
    -- #join <chat_id>|<alias> [support]
    -- #getaliaslist
    -- SUDO
    -- #allchats
    -- #allchatlist
    -- #setalias <alias> <group_id>
    -- #unsetalias <alias>
}