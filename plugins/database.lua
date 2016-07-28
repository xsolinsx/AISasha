local function callback_all_supergroups_members(extra, success, result)
    local database = extra.database
    local chat_id = string.match(extra.receiver, '%d+')
    print('supergroups members ' .. chat_id)

    -- save users info
    for k, v in pairsByKeys(result) do
        if v.print_name then
            if database["users"][tostring(v.peer_id)] then
                print('already registered user')
                if database["users"][tostring(v.peer_id)]['groups'] then
                    if not database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] then
                        database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] = tonumber(chat_id)
                    end
                else
                    database["users"][tostring(v.peer_id)]['groups'] = { [tostring(chat_id)] = tonumber(chat_id) }
                end
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") or database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                    if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                        database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                        database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                    end
                    if database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                        database["users"][tostring(v.peer_id)]['username'] =(('@' .. v.username) or 'NOUSER')
                        database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' ..(('@' .. v.username) or 'NOUSER')
                    end
                end
            else
                print('new user')
                database["users"][tostring(v.peer_id)] = {
                    print_name = v.print_name:gsub("_"," "),
                    username = ('@' .. v.username) or 'NOUSER',
                    old_print_names = v.print_name:gsub("_"," "),
                    old_usernames = ('@' .. v.username) or 'NOUSER',
                    long_id = v.id,
                    groups = { [tostring(chat_id)] = tonumber(chat_id) }
                }
            end
        end
    end
    save_data(_config.database.db, database)
end

local function callback_all_supergroups_info(extra, success, result)
    local database = extra.database
    local chat_id = result.peer_id
    print('supergroups info ' .. chat_id)

    -- save supergroup info
    if database["groups"][tostring(chat_id)] then
        print('already registered group')
        if database["groups"][tostring(chat_id)]['print_name'] ~= result.print_name:gsub("_", " ") then
            database["groups"][tostring(chat_id)]['print_name'] = result.print_name:gsub("_", " ")
            database["groups"][tostring(chat_id)]['old_print_names'] = database["groups"][tostring(chat_id)]['old_print_names'] .. ' ### ' .. result.print_name:gsub("_", " ")
        end
        if database["groups"][tostring(chat_id)]['username'] and database["groups"][tostring(chat_id)]['old_usernames'] then
            if database["groups"][tostring(chat_id)]['username'] ~=(('@' .. result.username) or 'NOUSER') then
                database["groups"][tostring(chat_id)]['username'] =(('@' .. result.username) or 'NOUSER')
                database["groups"][tostring(chat_id)]['old_usernames'] = database["groups"][tostring(chat_id)]['old_usernames'] .. ' ### ' ..(('@' .. result.username) or 'NOUSER')
            end
        end
    else
        print('new group')
        database["groups"][tostring(chat_id)] = {
            print_name = result.print_name:gsub("_"," "),
            username = ('@' .. result.username) or 'NOUSER',
            lang = get_lang(result.peer_id),
            old_print_names = result.print_name:gsub("_"," "),
            old_usernames = ('@' .. result.username) or 'NOUSER',
            long_id = result.id
        }
    end
end

local function callback_group_database(extra, success, result)
    local database = extra.database
    local chat_id = result.peer_id
    print('group info and members ' .. chat_id)

    -- save group info
    if database["groups"][tostring(chat_id)] then
        print('already registered group')
        if database["groups"][tostring(chat_id)]['print_name'] ~= result.print_name:gsub("_", " ") then
            database["groups"][tostring(chat_id)]['print_name'] = result.print_name:gsub("_", " ")
            database["groups"][tostring(chat_id)]['old_print_names'] = database["groups"][tostring(chat_id)]['old_print_names'] .. ' ### ' .. result.print_name:gsub("_", " ")
        end
    else
        print('new group')
        database["groups"][tostring(chat_id)] = {
            print_name = result.print_name:gsub("_"," "),
            lang = get_lang(result.peer_id),
            old_print_names = result.print_name:gsub("_"," "),
            long_id = result.id
        }
    end

    -- save users info
    for k, v in pairs(result.members) do
        if v.print_name then
            if database["users"][tostring(v.peer_id)] then
                print('already registered user')
                if database["users"][tostring(v.peer_id)]['groups'] then
                    if not database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] then
                        database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] = tonumber(chat_id)
                    end
                else
                    database["users"][tostring(v.peer_id)]['groups'] = { [tostring(chat_id)] = tonumber(chat_id) }
                end
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") or database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                    if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                        database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                        database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                    end
                    if database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                        database["users"][tostring(v.peer_id)]['username'] =(('@' .. v.username) or 'NOUSER')
                        database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' ..(('@' .. v.username) or 'NOUSER')
                    end
                end
            else
                print('new user')
                database["users"][tostring(v.peer_id)] = {
                    print_name = v.print_name:gsub("_"," "),
                    username = ('@' .. v.username) or 'NOUSER',
                    old_print_names = v.print_name:gsub("_"," "),
                    old_usernames = ('@' .. v.username) or 'NOUSER',
                    long_id = v.id,
                    groups = { [tostring(chat_id)] = tonumber(chat_id) }
                }
            end
        end
    end
    save_data(_config.database.db, database)
    send_large_msg(extra.receiver, langs[get_lang(result.peer_id)].dataLeaked)
end

local function callback_supergroup_database(extra, success, result)
    local database = extra.database
    local chat_id = string.match(extra.receiver, '%d+')
    print('supergroup info and members ' .. chat_id)

    -- save supergroup info
    if database["groups"][tostring(chat_id)] then
        print('already registered group')
        if database["groups"][tostring(chat_id)]['print_name'] ~= extra.print_name:gsub("_", " ") then
            database["groups"][tostring(chat_id)]['print_name'] = extra.print_name:gsub("_", " ")
            database["groups"][tostring(chat_id)]['old_print_names'] = database["groups"][tostring(chat_id)]['old_print_names'] .. ' ### ' .. extra.print_name:gsub("_", " ")
        end
        if database["groups"][tostring(chat_id)]['username'] and database["groups"][tostring(chat_id)]['old_usernames'] then
            if database["groups"][tostring(chat_id)]['username'] ~=(('@' .. extra.username) or 'NOUSER') then
                database["groups"][tostring(chat_id)]['username'] =(('@' .. extra.username) or 'NOUSER')
                database["groups"][tostring(chat_id)]['old_usernames'] = database["groups"][tostring(chat_id)]['old_usernames'] .. ' ### ' ..(('@' .. extra.username) or 'NOUSER')
            end
        end
    else
        print('new group')
        database["groups"][tostring(chat_id)] = {
            print_name = extra.print_name:gsub("_"," "),
            username = ('@' .. extra.username) or 'NOUSER',
            lang = get_lang(string.match(extra.receiver,'%d+')),
            old_print_names = extra.print_name:gsub("_"," "),
            old_usernames = ('@' .. extra.username) or 'NOUSER',
            long_id = extra.id
        }
    end

    -- save users info
    for k, v in pairsByKeys(result) do
        if v.print_name then
            if database["users"][tostring(v.peer_id)] then
                print('already registered user')
                if database["users"][tostring(v.peer_id)]['groups'] then
                    if not database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] then
                        database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] = tonumber(chat_id)
                    end
                else
                    database["users"][tostring(v.peer_id)]['groups'] = { [tostring(chat_id)] = tonumber(chat_id) }
                end
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") or database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                    if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                        database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                        database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                    end
                    if database["users"][tostring(v.peer_id)]['username'] ~=(('@' .. v.username) or 'NOUSER') then
                        database["users"][tostring(v.peer_id)]['username'] =(('@' .. v.username) or 'NOUSER')
                        database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' ..(('@' .. v.username) or 'NOUSER')
                    end
                end
            else
                print('new user')
                database["users"][tostring(v.peer_id)] = {
                    print_name = v.print_name:gsub("_"," "),
                    username = ('@' .. v.username) or 'NOUSER',
                    old_print_names = v.print_name:gsub("_"," "),
                    old_usernames = ('@' .. v.username) or 'NOUSER',
                    long_id = v.id,
                    groups = { [tostring(chat_id)] = tonumber(chat_id) }
                }
            end
        end
    end
    save_data(_config.database.db, database)
    send_large_msg(extra.receiver, langs[get_lang(string.match(extra.receiver, '%d+'))].dataLeaked)
end

local function run(msg, matches)
    if is_sudo(msg) then
        if matches[1]:lower() == 'createdatabase' then
            local f = io.open(_config.database.db, 'w+')
            f:write('{"groups":{},"users":{}}')
            f:close()
            reply_msg(msg.id, langs[msg.lang].dbCreated, ok_cb, false)
            return
        end

        if matches[1]:lower() == 'dogroupdatabase' or matches[1]:lower() == 'sasha esegui database gruppo' then
            local receiver = get_receiver(msg)
            local database = load_data(_config.database.db)
            if msg.to.type == 'channel' then
                channel_get_users(receiver, callback_supergroup_database, { receiver = receiver, database = database, print_name = msg.to.print_name, username = (msg.to.username or nil), id = msg.to.peer_id })
            elseif msg.to.type == 'chat' then
                chat_info(receiver, callback_group_database, { receiver = receiver, database = database })
            else
                return
            end
        end

        if matches[1]:lower() == 'dodatabase' or matches[1]:lower() == 'sasha esegui database' then
            local data = load_data(_config.moderation.data)
            if data['groups'] then
                local i = 1
                for k, v in pairsByKeys(data['groups']) do
                    local function post_get_db_groups()
                        local database = load_data(_config.database.db)
                        channel_get_users('channel#id' .. tostring(v), callback_all_supergroups_members, { receiver = 'channel#id' .. tostring(v), database = database })
                        channel_info('channel#id' .. tostring(v), callback_all_supergroups_info, { receiver = 'channel#id' .. tostring(v), database = database })
                        chat_info('chat#id' .. tostring(v), callback_group_database, { receiver = 'chat#id' .. tostring(v), database = database })
                    end
                    postpone(post_get_db_groups, false, i)
                    i = i + 5
                end
            end

            if data['realms'] then
                for k, v in pairsByKeys(data['realms']) do
                    local function post_get_db_groups()
                        local database = load_data(_config.database.db)
                        chat_info('chat#id' .. tostring(v), callback_all_groups, { receiver = 'chat#id' .. tostring(v), database = database })
                    end
                    postpone(post_get_db_groups, false, i)
                    i = i + 5
                end
            end
            return langs[msg.lang].dataLeaked
        end

        if (matches[1]:lower() == 'search' or matches[1]:lower() == 'sasha cerca' or matches[1]:lower() == 'cerca') and matches[2] then
            local database = load_data(_config.database.db)
            if database['users'][tostring(matches[2])] then
                return serpent.block(database['users'][tostring(matches[2])], { sortkeys = false, comment = false })
            elseif database['groups'][tostring(matches[2])] then
                return serpent.block(database['groups'][tostring(matches[2])], { sortkeys = false, comment = false })
            else
                return matches[2] .. langs[msg.lang].notFound
            end
        end
    else
        return langs[msg.lang].require_sudo
    end
end

return {
    description = "DATABASE",
    patterns =
    {
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Dd][Oo][Gg][Rr][Oo][Uu][Pp][Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Dd][Oo][Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Ss][Ee][Aa][Rr][Cc][Hh]) (%d+)$",
        -- dogroupdatabase
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Ee][Gg][Uu][Ii] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee] [Gg][Rr][Uu][Pp][Pp][Oo])$",
        -- dodatabase
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Ee][Gg][Uu][Ii] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        -- search
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Ee][Rr][Cc][Aa]) (%d+)$",
        "^([Cc][Ee][Rr][Cc][Aa]) (%d+)$",
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO
    -- #createdatabase
    -- (#dogroupdatabase|sasha esegui database gruppo)
    -- (#dodatabase|sasha esegui database)
    -- (#search|[sasha] cerca) <id>
}