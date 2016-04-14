local phrases = {
    "Ancora ancora ancora! 😍",
    "الله أَكْبَر",
    "Datemene un altro dai dai.",
    "R.I.P.",
    "Ora dovremmo nascondere il corpo. 🚔",
    "MUORI MUORI BASTARDO!",
    "Lalalalalala",
    "Oh che bel castello marcondirondirondello, oh che bel castello marcondirondironBAN.",
    "Oddio cos'ho fatto? 😱",
    "Giro giro tondo, casca il mondo, casca la terra, tutti giù per BAN.",
    "Tempo presente del verbo Bannare:\nIo banno, Tu vieni bannato.",
    "Bim Bum BAN",
}

-- kick by reply for mods and owner
local function Kick_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_momod2(result.from.peer_id, result.to.peer_id) then
            -- Ignore mods,owner,admin
            send_large_msg(chat, lang_text('cantKickHigher'))
            send_large_msg(channel, lang_text('cantKickHigher'))
        end
        kick_user(result.from.peer_id, result.to.peer_id)
        send_large_msg(chat, phrases[math.random(#phrases)])
        send_large_msg(channel, phrases[math.random(#phrases)])
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

-- Kick by reply for admins
local function Kick_by_reply_admins(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_admin2(result.from.peer_id) then
            -- Ignore admins
            return
        end
        kick_user(result.from.peer_id, result.to.peer_id)
        send_large_msg(chat, phrases[math.random(#phrases)])
        send_large_msg(channel, phrases[math.random(#phrases)])
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

-- Ban by reply for admins
local function ban_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_momod2(result.from.peer_id, result.to.peer_id) then
            -- Ignore mods,owner,admin
            send_large_msg(chat, lang_text('cantKickHigher'))
            send_large_msg(channel, lang_text('cantKickHigher'))
        end
        ban_user(result.from.peer_id, result.to.peer_id)
        send_large_msg(chat, lang_text('user') .. result.from.peer_id .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)])
        send_large_msg(channel, lang_text('user') .. result.from.peer_id .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)])
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

-- Ban by reply for admins
local function ban_by_reply_admins(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_admin2(result.from.peer_id) then
            -- Ignore admins
            return
        end
        ban_user(result.from.peer_id, result.to.peer_id)
        send_large_msg(chat, lang_text('user') .. result.from.peer_id .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)])
        send_large_msg(channel, lang_text('user') .. result.from.peer_id .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)])
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

-- Unban by reply
local function unban_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        send_large_msg(chat, lang_text('user') .. result.from.peer_id .. lang_text('unbanned'))
        send_large_msg(channel, lang_text('user') .. result.from.peer_id .. lang_text('unbanned'))
        -- Save on redis
        local hash = 'banned:' .. result.to.peer_id
        redis:srem(hash, result.from.peer_id)
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

local function banall_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_admin2(result.from.peer_id) then
            -- Ignore admins
            return
        end
        local name = user_print_name(result.from)
        banall_user(result.from.peer_id)
        kick_user(result.from.peer_id, result.to.peer_id)
        send_large_msg(chat, lang_text('user') .. name .. "[" .. result.from.peer_id .. "]" .. lang_text('gbanned'))
        send_large_msg(channel, lang_text('user') .. name .. "[" .. result.from.peer_id .. "]" .. lang_text('gbanned'))
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

local function unbanall_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        if tonumber(result.from.peer_id) == tonumber(our_id) then
            -- Ignore bot
            return
        end
        if is_admin2(result.from.peer_id) then
            -- Ignore admins
            return
        end
        local name = user_print_name(result.from)
        unbanall_user(result.from.peer_id)
        send_large_msg(chat, lang_text('user') .. name .. "[" .. result.from.peer_id .. "]" .. lang_text('ungbanned'))
        send_large_msg(channel, lang_text('user') .. name .. "[" .. result.from.peer_id .. "]" .. lang_text('ungbanned'))
    else
        send_large_msg(chat, lang_text('useYourGroups'))
        send_large_msg(channel, lang_text('useYourGroups'))
    end
end

local function pre_process(msg)
    local data = load_data(_config.moderation.data)
    -- SERVICE MESSAGE
    if msg.action and msg.action.type then
        local action = msg.action.type
        -- Check if banned user joins chat by link
        if action == 'chat_add_user_link' then
            local user_id = msg.from.id
            print('Checking invited user ' .. user_id)
            if is_banned(user_id, msg.to.id) or is_gbanned(user_id) then
                -- Check it with redis
                print('User is banned!')
                local print_name = user_print_name(msg.from):gsub("‮", "")
                local name = print_name:gsub("_", "")
                savelog(msg.to.id, name .. " [" .. msg.from.id .. "] is banned and kicked ! ")
                -- Save to logs
                kick_user(user_id, msg.to.id)
            end
        end
        -- Check if banned user joins chat
        if action == 'chat_add_user' then
            local user_id = msg.action.user.id
            print('Checking invited user ' .. user_id)
            if is_banned(user_id, msg.to.id) and not is_momod2(msg.from.id, msg.to.id) or is_gbanned(user_id) and not is_admin2(msg.from.id) then
                -- Check it with redis
                print('User is banned!')
                local print_name = user_print_name(msg.from):gsub("‮", "")
                local name = print_name:gsub("_", "")
                savelog(msg.to.id, name .. " [" .. msg.from.id .. "] added a banned user >" .. msg.action.user.id)
                -- Save to logs
                kick_user(user_id, msg.to.id)
                local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                redis:incr(banhash)
                local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                local banaddredis = redis:get(banhash)
                if banaddredis then
                    if tonumber(banaddredis) >= 4 and not is_owner(msg) then
                        kick_user(msg.from.id, msg.to.id)
                        -- Kick user who adds ban ppl more than 3 times
                    end
                    if tonumber(banaddredis) >= 8 and not is_owner(msg) then
                        ban_user(msg.from.id, msg.to.id)
                        -- Kick user who adds ban ppl more than 7 times
                        local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                        redis:set(banhash, 0)
                        -- Reset the Counter
                    end
                end
            end
            if data[tostring(msg.to.id)] then
                if data[tostring(msg.to.id)]['settings'] then
                    if data[tostring(msg.to.id)]['settings']['lock_bots'] then
                        bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
                    end
                end
            end
            if msg.action.user.username ~= nil then
                if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) and bots_protection == "yes" then
                    --- Will kick bots added by normal users
                    local print_name = user_print_name(msg.from):gsub("‮", "")
                    local name = print_name:gsub("_", "")
                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] added a bot > @" .. msg.action.user.username)
                    -- Save to logs
                    kick_user(msg.action.user.id, msg.to.id)
                end
            end
        end
        -- No further checks
        return msg
    end
    -- banned user is talking !
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        local group = msg.to.id
        local texttext = 'groups'
        -- if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
        -- chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
        -- return
        -- end
        local user_id = msg.from.id
        local chat_id = msg.to.id
        if is_banned(user_id, msg.to.id) or is_gbanned(user_id) then
            -- Check it with redis
            print('Banned user talking!')
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] banned user is talking !")
            -- Save to logs
            kick_user(user_id, chat_id)
            msg.text = ''
        end
    end
    return msg
end

local function kick_ban_res(extra, success, result)
    local chat_id = extra.chat_id
    local chat_type = extra.chat_type
    if chat_type == "chat" then
        receiver = 'chat#id' .. chat_id
    else
        receiver = 'channel#id' .. chat_id
    end
    if success == 0 then
        return send_large_msg(receiver, lang_text('noUsernameFound'))
    end
    local member_id = result.peer_id
    local user_id = member_id
    local member = result.username
    local from_id = extra.from_id
    local get_cmd = extra.get_cmd
    if get_cmd == "kick" then
        if member_id == from_id then
            send_large_msg(receiver, lang_text('noAutoKick'))
            return
        end
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, lang_text('cantKickHigher'))
            return
        end
        kick_user(member_id, chat_id)
        send_large_msg(receiver, phrases[math.random(#phrases)])
    elseif get_cmd == 'ban' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, lang_text('cantKickHigher'))
            return
        end
        send_large_msg(receiver, lang_text('user') .. '@' .. member .. ' [' .. member_id .. ']' .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)])
        ban_user(member_id, chat_id)
    elseif get_cmd == 'unban' then
        send_large_msg(receiver, lang_text('user') .. '@' .. member .. ' [' .. member_id .. ']' .. lang_text('unbanned'))
        local hash = 'banned:' .. chat_id
        redis:srem(hash, member_id)
        send_large_msg(receiver, lang_text('user') .. user_id .. lang_text('unbanned'))
        return
    elseif get_cmd == 'banall' then
        send_large_msg(receiver, lang_text('user') .. '@' .. member .. ' [' .. member_id .. ']' .. lang_text('gbanned'))
        banall_user(member_id)
    elseif get_cmd == 'unbanall' then
        send_large_msg(receiver, lang_text('user') .. '@' .. member .. ' [' .. member_id .. ']' .. lang_text('ungbanned'))
        unbanall_user(member_id)
    end
end

local function kickidsnouser(cb_extra, success, result)
    for k, v in pairs(result.members) do
        if not v.username then
            kick_user(v.id, result.id)
        end
    end
end

local function run(msg, matches)
    local support_id = msg.from.id
    if matches[1]:lower() == 'kickme' or matches[1]:lower() == 'uccidimi' then
        -- /kickme
        local receiver = get_receiver(msg)
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] left using kickme ")
            -- Save to logs
            kick_user(msg.from.id, msg.to.id)
            return phrases[math.random(#phrases)]
        end
    end

    if not is_momod(msg) then
        -- Ignore normal users
        return
    end

    if matches[1]:lower() == 'kick' or matches[1]:lower() == 'sasha uccidi' or matches[1]:lower() == 'uccidi' or matches[1]:lower() == 'spara' then
        if type(msg.reply_id) ~= "nil" and is_momod(msg) then
            if is_admin1(msg) then
                msgr = get_message(msg.reply_id, Kick_by_reply_admins, false)
            else
                msgr = get_message(msg.reply_id, Kick_by_reply, false)
            end
        elseif string.match(matches[2], '^%d+$') then
            if tonumber(matches[2]) == tonumber(our_id) then
                return
            end
            if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
                return lang_text('cantKickHigher')
            end
            if tonumber(matches[2]) == tonumber(msg.from.id) then
                return lang_text('noAutoKick')
            end
            local user_id = matches[2]
            local chat_id = msg.to.id
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] kicked user " .. matches[2])
            kick_user(user_id, chat_id)
            return phrases[math.random(#phrases)]
        else
            local cbres_extra = {
                chat_id = msg.to.id,
                get_cmd = 'kick',
                from_id = msg.from.id,
                chat_type = msg.to.type
            }
            local username = string.gsub(matches[2], '@', '')
            resolve_username(username, kick_ban_res, cbres_extra)
        end
    end

    if matches[1]:lower() == 'ban' or matches[1]:lower() == 'sasha banna' or matches[1]:lower() == 'sasha decompila' or matches[1]:lower() == 'banna' or matches[1]:lower() == 'decompila' or matches[1]:lower() == 'esplodi' or matches[1]:lower() == 'kaboom' then
        -- /ban
        if type(msg.reply_id) ~= "nil" and is_momod(msg) then
            if is_admin1(msg) then
                msgr = get_message(msg.reply_id, ban_by_reply_admins, false)
            else
                msgr = get_message(msg.reply_id, ban_by_reply, false)
            end
        elseif string.match(matches[2], '^%d+$') then
            if tonumber(matches[2]) == tonumber(our_id) then
                return
            end
            if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
                return lang_text('cantKickHigher')
            end
            if tonumber(matches[2]) == tonumber(msg.from.id) then
                return lang_text('noAutoBan')
            end
            local user_id = matches[2]
            local chat_id = msg.to.id
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            local receiver = get_receiver(msg)
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] banned user " .. matches[2])
            ban_user(matches[2], msg.to.id)
            return lang_text('user') .. matches[2] .. lang_text('banned') .. '\n' .. phrases[math.random(#phrases)]
        else
            local cbres_extra = {
                chat_id = msg.to.id,
                get_cmd = 'ban',
                from_id = msg.from.id,
                chat_type = msg.to.type
            }
            local username = string.gsub(matches[2], '@', '')
            resolve_username(username, kick_ban_res, cbres_extra)
        end
    end

    if matches[1]:lower() == 'unban' or matches[1]:lower() == 'sasha sbanna' or matches[1]:lower() == 'sasha ricompila' or matches[1]:lower() == 'sasha compila' or matches[1]:lower() == 'sbanna' or matches[1]:lower() == 'ricompila' or matches[1]:lower() == 'compila' then
        -- /unban
        if type(msg.reply_id) ~= "nil" and is_momod(msg) then
            msgr = get_message(msg.reply_id, unban_by_reply, false)
            return
        end
        local user_id = matches[2]
        local chat_id = msg.to.id
        local targetuser = matches[2]
        if string.match(targetuser, '^%d+$') then
            local user_id = targetuser
            local hash = 'banned:' .. chat_id
            redis:srem(hash, user_id)
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] unbanned user " .. matches[2])
            return lang_text('user') .. user_id .. lang_text('unbanned')
        else
            local cbres_extra = {
                chat_id = msg.to.id,
                get_cmd = 'unban',
                from_id = msg.from.id,
                chat_type = msg.to.type
            }
            local username = string.gsub(matches[2], '@', '')
            resolve_username(username, kick_ban_res, cbres_extra)
        end
    end

    if matches[1]:lower() == "banlist" or matches[1]:lower() == "sasha lista ban" or matches[1]:lower() == "lista ban" then
        -- Ban list !
        local chat_id = msg.to.id
        if matches[2] and is_admin1(msg) then
            chat_id = matches[2]
        end
        return ban_list(chat_id)
    end

    if not is_owner(msg) then
        return
    end

    if matches[1]:lower() == 'kicknouser' or matches[1]:lower() == 'sasha uccidi nouser' or matches[1]:lower() == 'spara nouser' then
        local receiver = get_receiver(msg)
        chat_info(receiver, kickidsnouser, { receiver = receiver })
    end

    if not is_admin1(msg) and not is_support(support_id) then
        return
    end

    if matches[1]:lower() == 'gban' or matches[1]:lower() == 'sasha superbanna' or matches[1]:lower() == 'superbanna' then
        -- Global ban
        if type(msg.reply_id) ~= "nil" and is_admin1(msg) then
            banall = get_message(msg.reply_id, banall_by_reply, false)
            return
        end
        local user_id = matches[2]
        local chat_id = msg.to.id
        local targetuser = matches[2]
        if string.match(targetuser, '^%d+$') then
            if tonumber(matches[2]) == tonumber(our_id) then
                return false
            end
            banall_user(targetuser)
            return lang_text('user') .. user_id .. lang_text('gbanned')
        else
            local cbres_extra = {
                chat_id = msg.to.id,
                get_cmd = 'banall',
                from_id = msg.from.id,
                chat_type = msg.to.type
            }
            local username = string.gsub(matches[2], '@', '')
            resolve_username(username, kick_ban_res, cbres_extra)
        end
    end
    if matches[1]:lower() == 'ungban' or matches[1]:lower() == 'sasha supersbanna' or matches[1]:lower() == 'supersbanna' then
        -- Global unban
        if type(msg.reply_id) ~= "nil" and is_admin1(msg) then
            unbanall = get_message(msg.reply_id, unbanall_by_reply, false)
            return
        end
        local user_id = matches[2]
        local chat_id = msg.to.id
        if string.match(matches[2], '^%d+$') then
            if tonumber(matches[2]) == tonumber(our_id) then
                return false
            end
            unbanall_user(user_id)
            return lang_text('user') .. user_id .. lang_text('ungbanned')
        else
            local cbres_extra = {
                chat_id = msg.to.id,
                get_cmd = 'unbanall',
                from_id = msg.from.id,
                chat_type = msg.to.type
            }
            local username = string.gsub(matches[2], '@', '')
            resolve_username(username, kick_ban_res, cbres_extra)
        end
    end
    if matches[1]:lower() == 'gbanlist' or matches[1]:lower() == 'sasha lista superban' or matches[1]:lower() == 'lista superban' then
        -- Global ban list
        local list = banall_list()
        local file = io.open("./groups/gbanlist.txt", "w")
        file:write(list)
        file:flush()
        file:close()
        send_document(get_receiver(msg), "./groups/gbanlist.txt", ok_cb, false)
        send_large_msg(get_receiver(msg), list)
        return list
    end
end

return {
    description = "BANHAMMER",
    usage =
    {
        "#kickme|uccidimi: Sasha rimuove l'utente.",
        "MOD",
        "#kick|[sasha] uccidi|spara <id>|<username>|<reply>: Sasha rimuove l'utente specificato.",
        "#ban|[sasha] banna|[sasha] decompila|esplodi|kaboom <id>|<username>|<reply>: Sasha banna l'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.",
        "(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>: Sasha sbanna l'utente specificato.",
        "(#banlist|[sasha] lista ban) [<group_id>]: Sasha mostra la lista di utenti bannati dal gruppo o da <group_id>.",
        "OWNER",
        "#kicknouser|[sasha] uccidi nouser|spara nouser: Sasha rimuove gli utenti senza username.",
        "SUPPORT",
        "(#gban|[sasha] superbanna) <id>|<username>|<reply>: Sasha superbanna l'utente specificato e lo rimuove, se tenta di rientrare viene nuovamente rimosso.",
        "(#ungban|[sasha] supersbanna) <id>|<username>|<reply>: Sasha supersbanna l'utente specificato.",
        "#gbanlist|[sasha] lista superban: Sasha mostra la lista di utenti super bannati.",
    },
    patterns =
    {
        "^[#!/]([Kk][Ii][Cc][Kk][Mm][Ee])$",
        "^[#!/]([Kk][Ii][Cc][Kk]) (.*)$",
        "^[#!/]([Kk][Ii][Cc][Kk])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Nn][Oo][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Bb][Aa][Nn]) (.*)$",
        "^[#!/]([Bb][Aa][Nn])$",
        "^[#!/]([Uu][Nn][Bb][Aa][Nn]) (.*)$",
        "^[#!/]([Uu][Nn][Bb][Aa][Nn])$",
        "^[#!/]([Bb][Aa][Nn][Ll][Ii][Ss][Tt]) (.*)$",
        "^[#!/]([Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Gg][Bb][Aa][Nn]) (.*)$",
        "^[#!/]([Gg][Bb][Aa][Nn])$",
        "^[#!/]([Uu][Nn][Gg][Bb][Aa][Nn]) (.*)$",
        "^[#!/]([Uu][Nn][Gg][Bb][Aa][Nn])$",
        "^[#!/]([Gg][Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
        "^!!tgservice (.+)$",
        -- kickme
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii][Mm][Ii])$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii][Mm][Ii])$",
        -- kick
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii]) (.*)$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Ss][Pp][Aa][Rr][Aa]) (.*)$",
        "^([Ss][Pp][Aa][Rr][Aa])$",
        -- kicknouser
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii] [Nn][Oo][Uu][Ss][Ee][Rr])$",
        "^([Ss][Pp][Aa][Rr][Aa] [Nn][Oo][Uu][Ss][Ee][Rr])$",
        -- ban
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Bb][Aa][Nn][Nn][Aa])$",
        "^([Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ee][Ss][Pp][Ll][Oo][Dd][Ii]) (.*)$",
        "^([Ee][Ss][Pp][Ll][Oo][Dd][Ii])$",
        "^([Kk][Aa][Bb][Oo][Oo][Mm]) (.*)$",
        "^([Kk][Aa][Bb][Oo][Oo][Mm])$",
        -- unban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ss][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Cc][Oo][Mm][Pp][Ii][Ll][Aa]) (.*)$",
        "^([Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        -- banlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn]) (.*)$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn])$",
        -- gban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa])$",
        -- ungban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa]) (.*)$",
        "^([Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa])$",
        -- gbanlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0
}