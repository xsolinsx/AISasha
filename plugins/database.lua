local function callback_group_database(extra, success, result)
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
            old_print_names = result.print_name:gsub("_"," "),
            lang = get_lang(result.peer_id),
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
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                    database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                    database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                end
                local username = 'NOUSER'
                if v.username then
                    username = '@' .. v.username
                end
                if database["users"][tostring(v.peer_id)]['username'] ~= username then
                    database["users"][tostring(v.peer_id)]['username'] = username
                    database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' .. username
                end
            else
                print('new user')
                local username = 'NOUSER'
                if v.username then
                    username = '@' .. v.username
                end
                database["users"][tostring(v.peer_id)] = {
                    print_name = v.print_name:gsub("_"," "),
                    old_print_names = v.print_name:gsub("_"," "),
                    username = username,
                    old_usernames = username,
                    long_id = v.id,
                    groups = { [tostring(chat_id)] = tonumber(chat_id) },
                }
            end
        end
    end
    save_data(_config.database.db, database)
    send_large_msg(extra.receiver, langs[get_lang(result.peer_id)].dataLeaked)
end

local function callback_supergroup_database(extra, success, result)
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
            local username = 'NOUSER'
            if extra.username then
                username = '@' .. extra.username
            end
            if database["groups"][tostring(chat_id)]['username'] ~= username then
                database["groups"][tostring(chat_id)]['username'] = username
                database["groups"][tostring(chat_id)]['old_usernames'] = database["groups"][tostring(chat_id)]['old_usernames'] .. ' ### ' .. username
            end
        end
    else
        print('new group')
        local username = 'NOUSER'
        if extra.username then
            username = '@' .. extra.username
        end
        database["groups"][tostring(chat_id)] = {
            print_name = extra.print_name:gsub("_"," "),
            old_print_names = extra.print_name:gsub("_"," "),
            lang = get_lang(string.match(extra.receiver,'%d+')),
            long_id = extra.id,
            username = username,
            old_usernames = username,
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
                if database["users"][tostring(v.peer_id)]['print_name'] ~= v.print_name:gsub("_", " ") then
                    database["users"][tostring(v.peer_id)]['print_name'] = v.print_name:gsub("_", " ")
                    database["users"][tostring(v.peer_id)]['old_print_names'] = database["users"][tostring(v.peer_id)]['old_print_names'] .. ' ### ' .. v.print_name:gsub("_", " ")
                end
                local username = 'NOUSER'
                if v.username then
                    username = '@' .. v.username
                end
                if database["users"][tostring(v.peer_id)]['username'] ~= username then
                    database["users"][tostring(v.peer_id)]['username'] = username
                    database["users"][tostring(v.peer_id)]['old_usernames'] = database["users"][tostring(v.peer_id)]['old_usernames'] .. ' ### ' .. username
                end
            else
                print('new user')
                local username = 'NOUSER'
                if v.username then
                    username = '@' .. v.username
                end
                database["users"][tostring(v.peer_id)] = {
                    print_name = v.print_name:gsub("_"," "),
                    old_print_names = v.print_name:gsub("_"," "),
                    username = username,
                    old_usernames = username,
                    long_id = v.id,
                    groups = { [tostring(chat_id)] = tonumber(chat_id) },
                }
            end
        end
    end
    save_data(_config.database.db, database)
    send_large_msg(extra.receiver, langs[get_lang(string.match(extra.receiver, '%d+'))].dataLeaked)
end

local function callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success and result then
        local file = '/home/pi/AISasha/data/database.json'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        send_large_msg(extra.receiver, langs[lang].databaseDownloaded .. file)
        database = load_data(_config.database.db)
    else
        send_large_msg(extra.receiver, langs[lang].errorDownloading)
    end
end

local function run(msg, matches)
    if is_sudo(msg) then
        if not msg.api_patch then
            if matches[1]:lower() == 'createdatabase' then
                local f = io.open(_config.database.db, 'w+')
                f:write('{"groups":{},"users":{}}')
                f:close()
                reply_msg(msg.id, langs[msg.lang].dbCreated, ok_cb, false)
                return
            end

            if matches[1]:lower() == 'dodatabase' or matches[1]:lower() == 'sasha esegui database' then
                local receiver = get_receiver(msg)
                if msg.to.type == 'channel' then
                    channel_get_users(receiver, callback_supergroup_database, { receiver = receiver, database = database, print_name = msg.to.print_name, username = (msg.to.username or nil), id = msg.to.peer_id })
                elseif msg.to.type == 'chat' then
                    chat_info(receiver, callback_group_database, { receiver = receiver, database = database })
                else
                    return
                end
            end

            if (matches[1]:lower() == 'dbsearch' or matches[1]:lower() == 'sasha cerca db' or matches[1]:lower() == 'cerca db') and matches[2] then
                if database['users'][tostring(matches[2])] then
                    return serpent.block(database['users'][tostring(matches[2])], { sortkeys = false, comment = false })
                elseif database['groups'][tostring(matches[2])] then
                    return serpent.block(database['groups'][tostring(matches[2])], { sortkeys = false, comment = false })
                else
                    return matches[2] .. langs[msg.lang].notFound
                end
            end

            if matches[1]:lower() == 'addrecord' and matches[2] and matches[3] then
                local t = matches[3]:split('\n')
                if matches[2]:lower() == 'user' then
                    local id = t[1]
                    local print_name = t[2]
                    local old_print_names = t[3]
                    local username = t[4]
                    local old_usernames = t[5]
                    local long_id = t[6]
                    local groups = { }
                    for k, v in pairs(t[7]:split(' ')) do
                        groups[tostring(v)] = tonumber(v)
                    end
                    print('new user')
                    database["users"][tostring(id)] = {
                        print_name = print_name:gsub("_"," "),
                        old_print_names = old_print_names:gsub("_"," "),
                        username = username,
                        old_usernames = old_usernames,
                        long_id = long_id,
                        groups = groups,
                    }
                    save_data(_config.database.db, database)
                    return langs[msg.lang].userManuallyAdded
                elseif matches[2]:lower() == 'group' then
                    local id = t[1]
                    local print_name = t[2]
                    local old_print_names = t[3]
                    local lang = t[4]
                    local long_id = t[5]
                    if t[6] and t[7] then
                        local username = t[6]
                        local old_usernames = t[7]
                        print('new group')
                        database["groups"][tostring(id)] = {
                            print_name = print_name:gsub("_"," "),
                            old_print_names = old_print_names:gsub("_"," "),
                            lang = lang,
                            long_id = long_id,
                            username = username,
                            old_usernames = old_usernames,
                        }
                    else
                        print('new group')
                        database["groups"][tostring(id)] = {
                            print_name = print_name:gsub("_"," "),
                            old_print_names = old_print_names:gsub("_"," "),
                            lang = lang,
                            long_id = long_id,
                        }
                    end
                    save_data(_config.database.db, database)
                    return langs[msg.lang].groupManuallyAdded
                else
                    return langs[msg.lang].errorUserOrGroup
                end
            end

            if (matches[1]:lower() == 'dbdelete' or matches[1]:lower() == 'sasha elimina db' or matches[1]:lower() == 'elimina db') and matches[2] then
                if database['users'][tostring(matches[2])] then
                    database['users'][tostring(matches[2])] = nil
                    save_data(_config.database.db, database)
                    return langs[msg.lang].userDeleted
                elseif database['groups'][tostring(matches[2])] then
                    database['groups'][tostring(matches[2])] = nil
                    save_data(_config.database.db, database)
                    return langs[msg.lang].groupDeleted
                else
                    return matches[2] .. langs[msg.lang].notFound
                end
            end

            if matches[1]:lower() == 'uploaddb' then
                print('SAVING USERS/GROUPS DATABASE')
                save_data(_config.database.db, database)
                if io.popen('find /home/pi/AISasha/data/database.json'):read("*all") ~= '' then
                    send_document_SUDOERS('/home/pi/AISasha/data/database.json', ok_cb, false)
                    return langs[msg.lang].databaseSent
                else
                    return langs[msg.lang].databaseMissing
                end
            end

            if matches[1]:lower() == 'replacedb' then
                if type(msg.reply_id) == "nil" then
                    return langs[msg.lang].useQuoteOnFile
                else
                    load_document(msg.reply_id, callback, { receiver = get_receiver(msg) })
                end
            end
        end
    else
        return langs[msg.lang].require_sudo
    end
end

local function pre_process(msg)
    if database then
        if msg.to.type == 'chat' then
            -- save group info
            if database["groups"][tostring(msg.to.id)] then
                print('already registered group')
                if database["groups"][tostring(msg.to.id)]['print_name'] ~= msg.to.print_name:gsub("_", " ") then
                    database["groups"][tostring(msg.to.id)]['print_name'] = msg.to.print_name:gsub("_", " ")
                    database["groups"][tostring(msg.to.id)]['old_print_names'] = database["groups"][tostring(msg.to.id)]['old_print_names'] .. ' ### ' .. msg.to.print_name:gsub("_", " ")
                end
            else
                print('new group')
                database["groups"][tostring(msg.to.id)] = {
                    print_name = msg.to.print_name:gsub("_"," "),
                    old_print_names = msg.to.print_name:gsub("_"," "),
                    lang = get_lang(msg.to.id),
                    long_id = msg.to.peer_id
                }
            end
        elseif msg.to.type == 'channel' then
            -- save supergroup info
            if database["groups"][tostring(msg.to.id)] then
                print('already registered group')
                if database["groups"][tostring(msg.to.id)]['print_name'] ~= msg.to.print_name:gsub("_", " ") then
                    database["groups"][tostring(msg.to.id)]['print_name'] = msg.to.print_name:gsub("_", " ")
                    database["groups"][tostring(msg.to.id)]['old_print_names'] = database["groups"][tostring(msg.to.id)]['old_print_names'] .. ' ### ' .. msg.to.print_name:gsub("_", " ")
                end
                if database["groups"][tostring(msg.to.id)]['username'] and database["groups"][tostring(msg.to.id)]['old_usernames'] then
                    local username = 'NOUSER'
                    if msg.to.username then
                        username = '@' .. msg.to.username
                    end
                    if database["groups"][tostring(msg.to.id)]['username'] ~= username then
                        database["groups"][tostring(msg.to.id)]['username'] = username
                        database["groups"][tostring(msg.to.id)]['old_usernames'] = database["groups"][tostring(msg.to.id)]['old_usernames'] .. ' ### ' .. username
                    end
                end
            else
                print('new group')
                local username = 'NOUSER'
                if msg.to.username then
                    username = '@' .. msg.to.username
                end
                database["groups"][tostring(msg.to.id)] = {
                    print_name = msg.to.print_name:gsub("_"," "),
                    old_print_names = msg.to.print_name:gsub("_"," "),
                    lang = get_lang(msg.to.id),
                    long_id = msg.to.peer_id,
                    username = username,
                    old_usernames = username,
                }
            end
        end
        -- save user info
        if msg.action then
            if msg.action.user then
                if msg.action.user.print_name then
                    if database["users"][tostring(msg.action.user.id)] then
                        print('already registered user action')
                        if database["users"][tostring(msg.action.user.id)]['groups'] then
                            if not database["users"][tostring(msg.action.user.id)]['groups'][tostring(msg.to.id)] then
                                database["users"][tostring(msg.action.user.id)]['groups'][tostring(msg.to.id)] = tonumber(msg.to.id)
                            end
                        else
                            database["users"][tostring(msg.action.user.id)]['groups'] = { [tostring(msg.to.id)] = tonumber(msg.to.id) }
                        end
                        if database["users"][tostring(msg.action.user.id)]['print_name'] ~= msg.action.user.print_name:gsub("_", " ") then
                            database["users"][tostring(msg.action.user.id)]['print_name'] = msg.action.user.print_name:gsub("_", " ")
                            database["users"][tostring(msg.action.user.id)]['old_print_names'] = database["users"][tostring(msg.action.user.id)]['old_print_names'] .. ' ### ' .. msg.action.user.print_name:gsub("_", " ")
                        end
                        local username = 'NOUSER'
                        if msg.action.user.username then
                            username = '@' .. msg.action.user.username
                        end
                        if database["users"][tostring(msg.action.user.id)]['username'] ~= username then
                            database["users"][tostring(msg.action.user.id)]['username'] = username
                            database["users"][tostring(msg.action.user.id)]['old_usernames'] = database["users"][tostring(msg.action.user.id)]['old_usernames'] .. ' ### ' .. username
                        end
                    else
                        print('new user action')
                        local username = 'NOUSER'
                        if msg.action.user.username then
                            username = '@' .. msg.action.user.username
                        end
                        database["users"][tostring(msg.action.user.id)] = {
                            print_name = msg.action.user.print_name:gsub("_"," "),
                            old_print_names = msg.action.user.print_name:gsub("_"," "),
                            username = username,
                            old_usernames = username,
                            long_id = msg.action.user.peer_id,
                            groups = { [tostring(msg.to.id)] = tonumber(msg.to.id) },
                        }
                    end
                end
            end
        end
        if msg.from.type == 'user' then
            if msg.from.print_name then
                if database["users"][tostring(msg.from.id)] then
                    print('already registered user')
                    if database["users"][tostring(msg.from.id)]['groups'] then
                        if not database["users"][tostring(msg.from.id)]['groups'][tostring(msg.to.id)] then
                            database["users"][tostring(msg.from.id)]['groups'][tostring(msg.to.id)] = tonumber(msg.to.id)
                        end
                    else
                        database["users"][tostring(msg.from.id)]['groups'] = { [tostring(msg.to.id)] = tonumber(msg.to.id) }
                    end
                    if database["users"][tostring(msg.from.id)]['print_name'] ~= msg.from.print_name:gsub("_", " ") then
                        database["users"][tostring(msg.from.id)]['print_name'] = msg.from.print_name:gsub("_", " ")
                        database["users"][tostring(msg.from.id)]['old_print_names'] = database["users"][tostring(msg.from.id)]['old_print_names'] .. ' ### ' .. msg.from.print_name:gsub("_", " ")
                    end
                    local username = 'NOUSER'
                    if msg.from.username then
                        username = '@' .. msg.from.username
                    end
                    if database["users"][tostring(msg.from.id)]['username'] ~= username then
                        database["users"][tostring(msg.from.id)]['username'] = username
                        database["users"][tostring(msg.from.id)]['old_usernames'] = database["users"][tostring(msg.from.id)]['old_usernames'] .. ' ### ' .. username
                    end
                else
                    print('new user')
                    local username = 'NOUSER'
                    if msg.from.username then
                        username = '@' .. msg.from.username
                    end
                    database["users"][tostring(msg.from.id)] = {
                        print_name = msg.from.print_name:gsub("_"," "),
                        old_print_names = msg.from.print_name:gsub("_"," "),
                        username = username,
                        old_usernames = username,
                        long_id = msg.from.peer_id,
                        groups = { [tostring(msg.to.id)] = tonumber(msg.to.id) },
                    }
                end
            end
        end
    else
        send_large_msg_SUDOERS(langs[msg.lang].databaseFuckedUp)
        local f = io.open(_config.database.db, 'w+')
        f:write('{"groups":{},"users":{}}')
        f:close()
    end
    return msg
end

return {
    description = "DATABASE",
    patterns =
    {
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Dd][Oo][Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Dd][Bb][Ss][Ee][Aa][Rr][Cc][Hh]) (%d+)$",
        "^[#!/]([Aa][Dd][Dd][Rr][Ee][Cc][Oo][Rr][Dd]) ([^%s]+) (.*)$",
        "^[#!/]([Dd][Ee][Ll][Ee][Tt][Ee]) (%d+)$",
        "^[#!/]([Uu][Pp][Ll][Oo][Aa][Dd][Dd][Bb])$",
        "^[#!/]([Rr][Ee][Pp][Ll][Aa][Cc][Ee][Dd][Bb])$",
        -- dodatabase
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Ee][Gg][Uu][Ii] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        -- dbsearch
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Ee][Rr][Cc][Aa] [Dd][Bb]) (%d+)$",
        "^([Cc][Ee][Rr][Cc][Aa] [Dd][Bb]) (%d+)$",
        -- dbdelete
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ll][Ii][Mm][Ii][Nn][Aa] [Dd][Bb]) (%d+)$",
        "^([Ee][Ll][Ii][Mm][Ii][Nn][Aa] [Dd][Bb]) (%d+)$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 4,
    syntax =
    {
        "SUDO",
        "#createdatabase",
        "(#dodatabase|sasha esegui database)",
        "(#dbsearch|[sasha] cerca db) <id>",
        "(#dbdelete|[sasha] elimina db) <id>",
        "#addrecord user <id>\n<print_name>\n<old_print_names>\n<username>\n<old_usernames>\n<long_id>\n<groups_ids_separated_by_space>",
        "#addrecord group <id>\n<print_name>\n<old_print_names>\n<lang>\n<long_id>\n[<username>\n<old_usernames>]",
        "#uploaddb",
    },
}