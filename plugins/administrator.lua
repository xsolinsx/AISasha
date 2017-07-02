local function admin_promote(user, user_id, lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    if data.admins[tostring(user_id)] then
        if string.match(user, '^%d+$') then
            return user_id .. langs[lang].alreadyAdmin
        else
            return '@' .. user .. langs[lang].alreadyAdmin
        end
    end
    data.admins[tostring(user_id)] = user
    save_data(_config.moderation.data, data)
    if string.match(user, '^%d+$') then
        return user_id .. langs[lang].promoteAdmin
    else
        return '@' .. user .. langs[lang].promoteAdmin
    end
end

local function admin_demote(user, user_id, lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    if not data.admins[tostring(user_id)] then
        if string.match(user, '^%d+$') then
            return user_id .. langs[lang].notAdmin
        else
            return '@' .. user .. langs[lang].notAdmin
        end
    end
    data.admins[tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
    if string.match(user, '^%d+$') then
        return user_id .. langs[lang].demoteAdmin
    else
        return '@' .. user .. langs[lang].demoteAdmin
    end
end

local function promote_admin_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    send_large_msg(extra.receiver, admin_promote(result.username, result.peer_id, lang))
end

local function demote_admin_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    send_large_msg(extra.receiver, admin_demote(result.username, result.peer_id, lang))
end

local function admin_list(lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    local message = langs[lang].adminListStart
    for k, v in pairs(data.admins) do
        message = message .. '@' .. v .. ' - ' .. k .. '\n'
    end
    return message
end

local function groups_list(msg)
    if not data.groups then
        return langs[msg.lang].noGroups
    end
    local message = langs[msg.lang].groupListStart
    for k, v in pairs(data.groups) do
        if data[tostring(v)] then
            for m, n in pairs(data[tostring(v)]) do
                if m == 'set_name' then
                    name = n
                end
            end
            local group_owner = "No owner"
            if data[tostring(v)]['set_owner'] then
                group_owner = tostring(data[tostring(v)]['set_owner'])
            end
            local group_link = "No link"
            if data[tostring(v)].settings['set_link'] then
                group_link = data[tostring(v)].settings['set_link']
            end
            message = message .. name .. ' ' .. v .. ' - ' .. group_owner .. '\n{' .. group_link .. "}\n"
        end
    end
    local file = io.open("./groups/lists/groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

local function realms_list(msg)
    if not data.realms then
        return langs[msg.lang].noRealms
    end
    local message = langs[msg.lang].realmListStart
    for k, v in pairs(data.realms) do
        for m, n in pairs(data[tostring(v)]) do
            if m == 'set_name' then
                name = n
            end
        end
        local group_owner = "No owner"
        if data[tostring(v)]['admins_in'] then
            group_owner = tostring(data[tostring(v)]['admins_in'])
        end
        local group_link = "No link"
        if data[tostring(v)].settings['set_link'] then
            group_link = data[tostring(v)].settings['set_link']
        end
        message = message .. name .. ' ' .. v .. ' - ' .. group_owner .. '\n{' .. group_link .. "}\n"
    end
    local file = io.open("./groups/lists/realms.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

local function set_bot_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/bot.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        set_profile_photo(file, ok_cb, false)
        send_large_msg(receiver, langs[msg.lang].botPicChanged, ok_cb, false)
        redis:del("bot:photo")
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, langs[msg.lang].errorTryAgain, ok_cb, false)
    end
end

local function parsed_url(link)
    local parsed_link = URL.parse(link)
    local parsed_path = URL.parse_path(parsed_link.path)
    return parsed_path[2]
end

local function vardump_msg(extra, success, result)
    if get_reply_receiver(result) == extra.receiver then
        local name = 'msg'
        if extra.name == 'reply' then
            name = 'VARDUMP (<reply>)\n'
        end
        if extra.name == 'msg_id' then
            name = 'VARDUMP (<msg_id>)\n'
        end
        if result.to.phone then
            result.to.phone = ''
        end
        if result.from.phone then
            result.from.phone = ''
        end
        if result.fwd_from then
            if result.fwd_from.phone then
                result.fwd_from.phone = ''
            end
        end
        local text = name .. serpent.block(result, { sortkeys = false, comment = false })
        send_large_msg(extra.receiver, text)
    else
        send_large_msg(extra.receiver, langs[get_lang(string.match(extra.receiver, '^%d+$'))].oldMessage)
    end
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    local print_name = user_print_name(msg.from):gsub("‮", "")
    local name_log = print_name:gsub("_", " ")
    if is_admin1(msg) then
        if msg.media then
            if msg.media.type == 'photo' and redis:get("bot:photo") then
                if redis:get("bot:photo") == 'waiting' then
                    load_photo(msg.id, set_bot_photo, msg)
                end
            end
        end
        if matches[1]:lower() == "setbotphoto" or matches[1]:lower() == "sasha setta foto" then
            redis:set("bot:photo", "waiting")
            return langs[msg.lang].sendNewPic
        end
        if matches[1] == "markread" or matches[1]:lower() == "sasha segna letto" then
            if matches[2] == "on" then
                redis:set("bot:markread", "on")
                return langs[msg.lang].markRead .. " > on"
            end
            if matches[2] == "off" then
                redis:del("bot:markread")
                return langs[msg.lang].markRead .. " > off"
            end
            return
        end
        if matches[1]:lower() == "ping" then
            return 'Pong'
        end
        if matches[1]:lower() == "laststart" then
            return start_time
        end
        if not msg.api_patch then
            if matches[1]:lower() == "pm" then
                send_large_msg("user#id" .. matches[2], matches[3])
                return langs[msg.lang].pmSent
            end
            if matches[1]:lower() == "pmblock" or matches[1]:lower() == "sasha blocca pm" then
                if is_admin2(matches[2]) then
                    return langs[msg.lang].cantBlockAdmin
                end
                block_user("user#id" .. matches[2], ok_cb, false)
                return langs[msg.lang].userBlocked
            end
            if matches[1]:lower() == "pmunblock" or matches[1]:lower() == "sasha sblocca pm" then
                unblock_user("user#id" .. matches[2], ok_cb, false)
                return langs[msg.lang].userUnblocked
            end
        end
        if matches[1]:lower() == "import" then
            -- join by group link
            local hash = parsed_url(matches[2])
            import_chat_link(hash, ok_cb, false)
        end
        if matches[1]:lower() == 'list' then
            if matches[2]:lower() == 'admins' then
                return admin_list(msg.lang)
            elseif matches[2]:lower() == 'groups' then
                -- groups_list(msg)
                -- send_document("user#id" .. msg.from.id, "./groups/lists/groups.txt", ok_cb, false)
                -- send_document("chat#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
                -- send_document("channel#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
                -- return langs[msg.lang].groupListCreated
                return group_list(msg)
            elseif matches[2]:lower() == 'realms' then
                -- realms_list(msg)
                -- send_document("user#id" .. msg.from.id, "./groups/lists/realms.txt", ok_cb, false)
                -- send_document("chat#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
                -- send_document("channel#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
                -- return langs[msg.lang].realmListCreated
                return realms_list(msg)
            end
        end
        if is_sudo(msg) then
            if matches[1]:lower() == 'addadmin' then
                if string.match(matches[2], '^%d+$') then
                    print("user " .. matches[2] .. " has been promoted as admin")
                    return admin_promote(matches[2], matches[2], msg.lang)
                else
                    resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), promote_admin_by_username, { receiver = get_receiver(msg) })
                    return
                end
            end
            if matches[1]:lower() == 'removeadmin' then
                if string.match(matches[2], '^%d+$') then
                    print("user " .. matches[2] .. " has been demoted")
                    return admin_demote(matches[2], matches[2], msg.lang)
                else
                    resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), promote_admin_by_username, { receiver = get_receiver(msg) })
                    return
                end
            end
            if matches[1]:lower() == "reloaddata" then
                data = load_data(_config.moderation.data)
                return langs[msg.lang].dataReloaded
            end
            if matches[1]:lower() == "update" then
                return io.popen('git pull'):read('*all')
            end
            if matches[1]:lower() == "authorizereboot" and matches[2] then
                redis:hset('rebootallowed', matches[2], matches[2])
                return langs[msg.lang].userAuthorized
            end
            if matches[1]:lower() == "deauthorizereboot" and matches[2] then
                redis:hdel('rebootallowed', matches[2])
                return langs[msg.lang].userDeauthorized
            end
            if matches[1]:lower() == "list reboot authorized" then
                local ids = redis:hkeys('rebootallowed')
                local text = ''
                for i = 1, #ids do
                    text = text .. ids[i] .. '\n'
                end
                return text
            end
            if not msg.api_patch then
                if matches[1]:lower() == "backup" or matches[1]:lower() == "sasha esegui backup" then
                    doSendBackup()
                    return langs[msg.lang].backupDone
                end
                if matches[1]:lower() == 'vardump' then
                    if type(msg.reply_id) ~= "nil" then
                        msgr = get_message(msg.reply_id, vardump_msg, { receiver = get_receiver(msg), name = 'reply' })
                    elseif matches[2] and matches[2] ~= '' then
                        msgr = get_message(matches[2], vardump_msg, { receiver = get_receiver(msg), name = 'msg_id' })
                    else
                        msg.to.phone = ''
                        msg.from.phone = ''
                        local text = 'VARDUMP (<msg>)\n' .. serpent.block(msg, { sortkeys = false, comment = false })
                        send_large_msg(get_receiver(msg), text)
                    end
                end
            end
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'checkspeed' then
                return os.date('%S', os.difftime(tonumber(os.time()), tonumber(msg.date)))
            end
        end
    end
end

return {
    description = "ADMINISTRATOR",
    patterns =
    {
        "^[#!/]([Pp][Mm]) (%d+) (.*)$",
        "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/]([Pp][Mm][Uu][Nn][Bb][Ll][Oo][Cc][Kk]) (%d+)$",
        "^[#!/]([Pp][Mm][Bb][Ll][Oo][Cc][Kk]) (%d+)$",
        "^[#!/]([Mm][Aa][Rr][Kk][Rr][Ee][Aa][Dd]) ([Oo][Nn])$",
        "^[#!/]([Mm][Aa][Rr][Kk][Rr][Ee][Aa][Dd]) ([Oo][Ff][Ff])$",
        "^[#!/]([Ss][Ee][Tt][Bb][Oo][Tt][Pp][Hh][Oo][Tt][Oo])$",
        "^[#!/]([Bb][Aa][Cc][Kk][Uu][Pp])$",
        "^[#!/]([Uu][Pp][Dd][Aa][Tt][Ee])$",
        "^[#!/]([Aa][Dd][Dd][Ll][Oo][Gg])$",
        "^[#!/]([Rr][Ee][Mm][Ll][Oo][Gg])$",
        "^[#!/]([Vv][Aa][Rr][Dd][Uu][Mm][Pp]) (.*)$",
        "^[#!/]([Vv][Aa][Rr][Dd][Uu][Mm][Pp])$",
        "^[#!/]([Cc][Hh][Ee][Cc][Kk][Ss][Pp][Ee][Ee][Dd])$",
        "^[#!/]([Pp][Ii][Nn][Gg])$",
        "^[#!/]([Ll][Aa][Ss][Tt][Ss][Tt][Aa][Rr][Tt])$",
        "^[#!/]([Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Ee][Rr][Ee][Bb][Oo][Oo][Tt]) (%d+)$",
        "^[#!/]([Dd][Ee][Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Ee][Rr][Ee][Bb][Oo][Oo][Tt]) (%d+)$",
        "^[#!/]([Ll][Ii][Ss][Tt] [Rr][Ee][Bb][Oo][Oo][Tt] [Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Ee][Dd])$",
        "^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd][Dd][Aa][Tt][Aa])$",
        "%[(photo)%]",
        -- pm
        "^([Ss][Aa][Ss][Hh][Aa] [Mm][Ee][Ss][Ss][Aa][Gg][Gg][Ii][Aa]) (%d+) (.*)$",
        -- pmunblock
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Ll][Oo][Cc][Cc][Aa] [Pp][Mm]) (%d+)$",
        -- pmblock
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Ll][Oo][Cc][Cc][Aa] [Pp][Mm]) (%d+)$",
        -- markread
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Gg][Nn][Aa] [Ll][Ee][Tt][Tt][Oo]) ([Oo][Nn])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Gg][Nn][Aa] [Ll][Ee][Tt][Tt][Oo]) ([Oo][Ff][Ff])$",
        -- setbotphoto
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Aa][Mm][Bb][Ii][Aa] [Ff][Oo][Tt][Oo])$",
        -- backup
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Ee][Gg][Uu][Ii] [Bb][Aa][Cc][Kk][Uu][Pp])$",
    },
    run = run,
    min_rank = 3,
    syntax =
    {
        "ADMIN",
        "#pm <user_id> <msg>",
        "#import <group_link>",
        "(#pmblock|sasha blocca pm) <user_id>",
        "(#pmunblock|sasha sblocca pm) <user_id>",
        "(#markread|sasha segna letto) (on|off)",
        "(#setbotphoto|sasha cambia foto)",
        "#list admins|groups|realms",
        "#checkspeed",
        "#ping",
        "#laststart",
        "SUDO",
        "(#backup|sasha esegui backup)",
        "#update",
        "#vardump [<reply>|<msg_id>]",
        "#authorizereboot <user_id>",
        "#deauthorizereboot <user_id>",
        "#list reboot authorized",
        "#reloaddata",
        "#addadmin <user_id>|<username>",
        "#removeadmin <user_id>|<username>",
    },
}
-- By @imandaneshi :)
-- https://github.com/SEEDTEAM/TeleSeed/blob/test/plugins/admin.lua
--- Modified by @Rondoozle for supergroups
