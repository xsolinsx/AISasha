local function callback_group_database(extra, success, result)
    local database = extra.database
    local chat_id = result.peer_id

    -- save group info
    if database["groups"][tostring(chat_id)] then
        database["groups"][tostring(chat_id)] = {
            print_name = result.print_name:gsub("_"," "),
            lang = get_lang(result.peer_id),
            old_print_names = database["users"][tostring(v.peer_id)].old_print_names .. ' ### ' .. result.print_name:gsub("_"," "),
            long_id = result.id
        }
    else
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
            table.insert(database["users"][tostring(v.peer_id)].groups, chat_id)
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                old_print_names = database["users"][tostring(v.peer_id)].old_print_names .. ' ### ' .. v.print_name:gsub("_"," "),
                old_usernames = database["users"][tostring(v.peer_id)].old_usernames .. ' ### ' ..(v.username or 'NOUSER'),
                long_id = v.id
            }
        else
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                groups = { chat_id },
                old_print_names = v.print_name:gsub("_"," "),
                old_usernames = v.username or 'NOUSER',
                long_id = v.id
            }
        end
    end
    send_large_msg(extra.receiver, languages[get_lang(result.peer_id)].dataLeaked)
end

local function callback_supergroup_database(extra, success, result)
    local database = extra.database
    local chat_id = string.match(extra.receiver, '%d+')

    -- save supergroup info
    if database["groups"][tostring(chat_id)] then
        database["groups"][tostring(chat_id)] = {
            print_name = extra.print_name:gsub("_"," "),
            username = extra.username or 'NOUSER',
            lang = get_lang(string.match(extra.receiver,'%d+')),
            old_print_names = database["users"][tostring(v.peer_id)].old_print_names .. ' ### ' .. extra.print_name:gsub("_"," "),
            old_usernames = database["users"][tostring(v.peer_id)].old_usernames .. ' ### ' ..(extra.username or 'NOUSER'),
            long_id = extra.id
        }
    else
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
            table.insert(database["users"][tostring(v.peer_id)].groups, chat_id)
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                old_print_names = database["users"][tostring(v.peer_id)].old_print_names .. ' ### ' .. v.print_name:gsub("_"," "),
                old_usernames = database["users"][tostring(v.peer_id)].old_usernames .. ' ### ' ..(v.username or 'NOUSER'),
                long_id = v.id
            }
        else
            database["users"][tostring(v.peer_id)] = {
                print_name = v.print_name:gsub("_"," "),
                username = v.username or 'NOUSER',
                groups = { chat_id },
                old_print_names = v.print_name:gsub("_"," "),
                old_usernames = v.username or 'NOUSER',
                long_id = v.id
            }
        end
    end
    send_large_msg(extra.receiver, languages[get_lang(string.match(extra.receiver, '%d+'))].dataLeaked)
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
            if chat_type == 'channel' then
                channel_get_users(receiver, callback_supergroup_database, { receiver = receiver, database = database, print_name = msg.to.print_name, username = (msg.to.username or nil), id = msg.to.peer_id })
            elseif chat_type == 'chat' then
                chat_info(receiver, callback_group_database, { receiver = receiver, database = database })
            else
                return
            end
            save_data(_config.database.db, database)
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
