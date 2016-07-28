local function callback_group_database(extra, success, result)
    local database = extra.database
    local chat_id = result.peer_id

    -- save group info
    if database["groups"][tostring(chat_id)] then
        print('already registered group')
        if database["groups"][tostring(chat_id)]['print_name'] ~= result.print_name:gsub("_", " ") then
            if database["chat_id"][tostring(chat_id)]['print_name'] ~= result.print_name:gsub("_", " ") then
                database["chat_id"][tostring(chat_id)]['print_name'] = result.print_name:gsub("_", " ")
                database["chat_id"][tostring(chat_id)]['old_print_names'] = database["chat_id"][tostring(chat_id)]['old_print_names'] .. ' ### ' .. result.print_name:gsub("_", " ")
            end
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
        if database["users"][tostring(v.peer_id)] then
            print('already registered user')
            if database["users"][tostring(v.peer_id)]['groups'] then
                if not database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] then
                    database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] = tonumber(chat_id)
                end
            else
                database["users"][tostring(v.peer_id)]['groups'] = { [tostring(chat_id)] = tonumber(chat_id) }
            end
            if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") or database["users"][tostring(v.peer_id)]['username'] ~=(v.username or 'NOUSER') then
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                    database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                    database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                end
                if database["users"][tostring(v.peer_id)]['username'] ~=(v.username or 'NOUSER') then
                    database["users"][tostring(v.peer_id)]['username'] =(v.username or 'NOUSER')
                    database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' ..(v.username or 'NOUSER')
                end
            end
        else
            print('new user')
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                old_print_names = v.print_name:gsub("_"," "),
                old_usernames = v.username or 'NOUSER',
                long_id = v.id,
                groups = { [tostring(chat_id)] = tonumber(chat_id) }
            }
        end
    end
    local function post_save()
        save_data(_config.database.db, database)
        send_large_msg(extra.receiver, langs[get_lang(result.peer_id)].dataLeaked)
    end
    postpone(post_save, false, 10)
end

local function callback_supergroup_database(extra, success, result)
    local database = extra.database
    local chat_id = string.match(extra.receiver, '%d+')

    -- save supergroup info
    if database["groups"][tostring(chat_id)] then
        print('already registered group')
        if database["groups"][tostring(chat_id)]['print_name'] ~= extra.print_name:gsub("_", " ") or database["groups"][tostring(chat_id)]['username'] ~=(extra.username or 'NOUSER') then
            if database["chat_id"][tostring(chat_id)]['print_name'] ~= extra.print_name:gsub("_", " ") then
                database["chat_id"][tostring(chat_id)]['print_name'] = extra.print_name:gsub("_", " ")
                database["chat_id"][tostring(chat_id)]['old_print_names'] = database["chat_id"][tostring(chat_id)]['old_print_names'] .. ' ### ' .. extra.print_name:gsub("_", " ")
            end
            if database["chat_id"][tostring(chat_id)]['username'] ~=(extra.username or 'NOUSER') then
                database["chat_id"][tostring(chat_id)]['username'] =(extra.username or 'NOUSER')
                database["chat_id"][tostring(chat_id)]['old_usernames'] = database["chat_id"][tostring(chat_id)]['old_usernames'] .. ' ### ' ..(extra.username or 'NOUSER')
            end
        end
    else
        print('new group')
        database["groups"][tostring(chat_id)] = {
            print_name = extra.print_name:gsub("_"," "),
            username = extra.username or 'NOUSER',
            lang = get_lang(string.match(extra.receiver,'%d+')),
            old_print_names = extra.print_name:gsub("_"," "),
            old_usernames = extra.username or 'NOUSER',
            long_id = extra.id
        }
    end

    -- save users info
    for k, v in pairsByKeys(result) do
        if database["users"][tostring(v.peer_id)] then
            print('already registered user')
            if database["users"][tostring(v.peer_id)]['groups'] then
                if not database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] then
                    database["users"][tostring(v.peer_id)]['groups'][tostring(chat_id)] = tonumber(chat_id)
                end
            else
                database["users"][tostring(v.peer_id)]['groups'] = { [tostring(chat_id)] = tonumber(chat_id) }
            end
            if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") or database["users"][tostring(v.peer_id)]['username'] ~=(v.username or 'NOUSER') then
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                    database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                    database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                end
                if database["users"][tostring(v.peer_id)]['username'] ~=(v.username or 'NOUSER') then
                    database["users"][tostring(v.peer_id)]['username'] =(v.username or 'NOUSER')
                    database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' ..(v.username or 'NOUSER')
                end
            end
        else
            print('new user')
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                old_print_names = v.print_name:gsub("_"," "),
                old_usernames = v.username or 'NOUSER',
                long_id = v.id,
                groups = { [tostring(chat_id)] = tonumber(chat_id) }
            }
        end
    end
    local function post_save()
        save_data(_config.database.db, database)
        send_large_msg(extra.receiver, langs[get_lang(string.match(extra.receiver, '%d+'))].dataLeaked)
    end
    postpone(post_save, false, 10)
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

        local database = load_data(_config.database.db)

        if matches[1]:lower() == 'database' or matches[1]:lower() == 'sasha database' then
            local receiver = get_receiver(msg)
            if msg.to.type == 'channel' then
                channel_get_users(receiver, callback_supergroup_database, { receiver = receiver, database = database, print_name = msg.to.print_name, username = (msg.to.username or nil), id = msg.to.peer_id })
            elseif msg.to.type == 'chat' then
                chat_info(receiver, callback_group_database, { receiver = receiver, database = database })
            else
                return
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
        "^[#!/]([Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        -- database
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO
    -- #createdatabase
    -- (#database|[sasha] database)
}