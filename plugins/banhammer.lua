local function kick_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local function post_kick()
            kick_user_any(result.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(extra.chat_id, "[" .. extra.executer .. "] kicked user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] kicked user " .. result.peer_id .. " N")
    end
end

local function kick_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        local function post_kick()
            kick_user_any(result.from.peer_id, result.to.peer_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.from.peer_id .. " N")
    end
end

local function kick_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
        local function post_kick()
            kick_user(result.fwd_from.peer_id, result.to.peer_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.fwd_from.peer_id .. " from Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.fwd_from.peer_id .. " from N")
    end
end

local function ban_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local function post_kick()
            ban_user(result.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(extra.chat_id, "[" .. extra.executer .. "] banned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] banned user " .. result.peer_id .. " N")
    end
end

local function ban_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        local function post_kick()
            ban_user(result.from.peer_id, result.to.peer_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.from.peer_id .. " N")
    end
end

local function ban_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
        local function post_kick()
            ban_user(result.fwd_from.peer_id, result.to.peer_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.fwd_from.peer_id .. " from Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.fwd_from.peer_id .. " from N")
    end
end

local function unban_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local hash = 'banned:' .. extra.chat_id
        redis:srem(hash, result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].unbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unbanned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unbanned user " .. result.peer_id .. " N")
    end
end

local function unban_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        local hash = 'banned:' .. result.to.peer_id
        redis:srem(hash, result.from.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].unbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.from.peer_id .. " N")
    end
end

local function unban_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
        local hash = 'banned:' .. result.to.peer_id
        redis:srem(hash, result.fwd_from.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].unbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.fwd_from.peer_id .. " from Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.fwd_from.peer_id .. " from N")
    end
end

local function banall_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        banall_user(result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].gbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally banned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally banned user " .. result.peer_id .. " N")
    end
end

local function banall_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        local function post_kick()
            banall_user(result.from.peer_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].gbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.from.peer_id .. " N")
    end
end

local function banall_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
        banall_user(result.fwd_from.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].gbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.fwd_from.peer_id .. " from Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.fwd_from.peer_id .. " from N")
    end
end

local function unbanall_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unbanall_user(result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].ungbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally unbanned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally unbanned user " .. result.peer_id .. " N")
    end
end

local function unbanall_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
        unbanall_user(result.from.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].ungbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.from.peer_id .. " N")
    end
end

local function unbanall_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
        unbanall_user(result.fwd_from.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].ungbanned)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.fwd_from.peer_id .. " from Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.fwd_from.peer_id .. " from N")
    end
end

local function kickrandom_chat(extra, success, result)
    local kickable = false
    local id
    local lang = get_lang(extra.chat_id)

    while not kickable do
        id = result.members[math.random(#result.members)].peer_id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, extra.chat_id) or is_whitelisted(id)) then
            kickable = true
            send_large_msg('chat#id' .. extra.chat_id, 'ℹ️ ' .. id .. ' ' .. langs[lang].kicked)
            local function post_kick()
                kick_user_any(id, extra.chat_id)
            end
            postpone(post_kick, false, 1)
        else
            print('403')
        end
    end
end

local function kickrandom_channel(extra, success, result)
    local kickable = false
    local id
    local lang = get_lang(extra.chat_id)

    while not kickable do
        id = result[math.random(#result)].peer_id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, extra.chat_id) or is_whitelisted(id)) then
            kickable = true
            send_large_msg('channel#id' .. extra.chat_id, 'ℹ️ ' .. id .. ' ' .. langs[lang].kicked)
            local function post_kick()
                kick_user_any(id, extra.chat_id)
            end
            postpone(post_kick, false, 1)
        else
            print('403')
        end
    end
end

local function kick_nouser_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result.members) do
        if not v.username then
            if kicked == 20 then
                break
            end
            kick_user(v.peer_id, extra.chat_id)
            kicked = kicked + 1
            sleep(1)
        end
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_nouser_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result) do
        if not v.username then
            if kicked == 20 then
                break
            end
            kick_user(v.peer_id, extra.chat_id)
            kicked = kicked + 1
            sleep(1)
        end
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_deleted_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result.members) do
        if not v.print_name then
            if v.peer_id then
                if kicked == 20 then
                    break
                end
                kick_user(v.peer_id, extra.chat_id)
                kicked = kicked + 1
                sleep(1)
            end
        end
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_deleted_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result) do
        if not v.print_name then
            if v.peer_id then
                if kicked == 20 then
                    break
                end
                kick_user(v.peer_id, extra.chat_id)
                kicked = kicked + 1
                sleep(1)
            end
        end
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function user_msgs(user_id, chat_id)
    local user_info
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:' .. user_id .. ':' .. chat_id
    user_info = tonumber(redis:get(um_hash) or 0)
    return user_info
end

local function kick_inactive_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result.members) do
        if tonumber(v.peer_id) ~= tonumber(our_id) and not is_momod2(v.peer_id, extra.chat_id) then
            local user_info = user_msgs(v.peer_id, extra.chat_id)
            if tonumber(user_info) < tonumber(extra.num) then
                if kicked == 20 then
                    break
                end
                kick_user(v.peer_id, extra.chat_id)
                kicked = kicked + 1
                sleep(1)
            end
        end
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_inactive_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result) do
        if tonumber(v.peer_id) ~= tonumber(our_id) and not is_momod2(v.peer_id, extra.chat_id) then
            local user_info = user_msgs(v.peer_id, extra.chat_id)
            if tonumber(user_info) < tonumber(extra.num) then
                if kicked == 20 then
                    break
                end
                kick_user(v.peer_id, extra.chat_id)
                kicked = kicked + 1
                sleep(1)
            end
        end
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function run(msg, matches)
    if msg.action then
        if msg.action.type then
            return
        end
    end
    local receiver = get_receiver(msg)
    if matches[1]:lower() == 'kickme' or matches[1]:lower() == 'sasha uccidimi' then
        -- /kickme
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", "")
            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] left using kickme ")
            -- Save to logs
            local function post_kick()
                kick_user_any(msg.from.id, msg.to.id)
            end
            postpone(post_kick, false, 3)
            return langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
        else
            return langs[msg.lang].useYourGroups
        end
    end
    if is_momod(msg) then
        if matches[1]:lower() == 'kick' or matches[1]:lower() == 'sasha uccidi' or matches[1]:lower() == 'uccidi' or matches[1]:lower() == 'spara' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                -- /kick
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, kick_from, { receiver = receiver, executer = msg.from.id })
                        else
                            get_message(msg.reply_id, kick_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    else
                        get_message(msg.reply_id, kick_by_reply, { receiver = receiver, executer = msg.from.id })
                    end
                elseif string.match(matches[2], '^%d+$') then
                    -- ignore higher or same rank
                    if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                        local function post_kick()
                            kick_user(matches[2], msg.to.id)
                        end
                        postpone(post_kick, false, 3)
                        savelog(msg.to.id, "[" .. msg.from.id .. "] kicked user " .. matches[2] .. " Y")
                        return langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
                    else
                        savelog(msg.to.id, "[" .. msg.from.id .. "] kicked user " .. matches[2] .. " N")
                        return langs[msg.lang].require_rank
                    end
                else
                    resolve_username(matches[2]:gsub('@', ''), kick_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'kickrandom' then
            if msg.to.type == 'chat' then
                chat_info(receiver, kickrandom_chat, { chat_id = msg.to.id })
            elseif msg.to.type == 'channel' then
                channel_get_users(receiver, kickrandom_channel, { chat_id = msg.to.id })
            end
            return
        end
        if matches[1]:lower() == 'ban' or matches[1]:lower() == 'sasha banna' or matches[1]:lower() == 'sasha decompila' or matches[1]:lower() == 'banna' or matches[1]:lower() == 'decompila' or matches[1]:lower() == 'esplodi' or matches[1]:lower() == 'kaboom' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                -- /ban
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, ban_from, { receiver = receiver, executer = msg.from.id })
                        else
                            get_message(msg.reply_id, ban_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    else
                        get_message(msg.reply_id, ban_by_reply, { receiver = receiver, executer = msg.from.id })
                    end
                elseif string.match(matches[2], '^%d+$') then
                    -- ignore higher or same rank
                    if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                        local function post_kick()
                            ban_user(matches[2], msg.to.id)
                        end
                        postpone(post_kick, false, 3)
                        savelog(msg.to.id, "[" .. msg.from.id .. "] banned user " .. matches[2] .. " Y")
                        return langs[msg.lang].user .. matches[2] .. langs[msg.lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
                    else
                        savelog(msg.to.id, "[" .. msg.from.id .. "] banned user " .. matches[2] .. " N")
                        return langs[msg.lang].require_rank
                    end
                else
                    resolve_username(matches[2]:gsub('@', ''), ban_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'unban' or matches[1]:lower() == 'sasha sbanna' or matches[1]:lower() == 'sasha ricompila' or matches[1]:lower() == 'sasha compila' or matches[1]:lower() == 'sbanna' or matches[1]:lower() == 'ricompila' or matches[1]:lower() == 'compila' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                -- /unban
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, unban_from, { receiver = receiver, executer = msg.from.id })
                        else
                            get_message(msg.reply_id, unban_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    else
                        get_message(msg.reply_id, unban_by_reply, { receiver = receiver, executer = msg.from.id })
                    end
                elseif string.match(matches[2], '^%d+$') then
                    -- ignore higher or same rank
                    if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                        local hash = 'banned:' .. msg.to.id
                        redis:srem(hash, matches[2])
                        savelog(msg.to.id, "[" .. msg.from.id .. "] unbanned user " .. matches[2] .. " Y")
                        return langs[msg.lang].user .. matches[2] .. langs[msg.lang].unbanned
                    else
                        savelog(msg.to.id, "[" .. msg.from.id .. "] unbanned user " .. matches[2] .. " N")
                        return langs[msg.lang].require_rank
                    end
                else
                    resolve_username(matches[2]:gsub('@', ''), unban_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == "banlist" or matches[1]:lower() == "sasha lista ban" or matches[1]:lower() == "lista ban" then
            -- /banlist
            if matches[2] and is_admin1(msg) then
                return ban_list(matches[2])
            else
                if msg.to.type == 'chat' or msg.to.type == 'channel' then
                    return ban_list(msg.to.id)
                else
                    return langs[msg.lang].useYourGroups
                end
            end
        end
        if matches[1]:lower() == 'kickdeleted' then
            -- /kickdeleted
            if msg.to.type == 'chat' then
                chat_info(receiver, kick_deleted_chat, { receiver = get_receiver(msg), chat_id = msg.to.id })
            elseif msg.to.type == 'channel' then
                channel_get_users(receiver, kick_deleted_channel, { receiver = get_receiver(msg), chat_id = msg.to.id })
            end
            return
        end
        if is_owner(msg) then
            if matches[1]:lower() == 'kickinactive' then
                -- /kickinactive
                local num = 1
                if matches[2] then
                    num = matches[2]
                end
                if msg.to.type == 'chat' then
                    chat_info(receiver, kick_inactive_chat, { chat_id = msg.to.id, num = num, receiver = get_receiver(msg) })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kick_inactive_channel, { chat_id = msg.to.id, num = num, receiver = get_receiver(msg) })
                end
                return
            end
            if matches[1]:lower() == 'kicknouser' then
                -- /kicknouser
                if msg.to.type == 'chat' then
                    chat_info(receiver, kick_nouser_chat, { receiver = get_receiver(msg), chat_id = msg.to.id })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kick_nouser_channel, { receiver = get_receiver(msg), chat_id = msg.to.id })
                end
                return
            end
            if is_admin1(msg) then
                if matches[1]:lower() == 'gban' or matches[1]:lower() == 'sasha superbanna' or matches[1]:lower() == 'superbanna' then
                    -- /gban
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, banall_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, banall_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, banall_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                        return
                    elseif string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            banall_user(matches[2])
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally banned user " .. matches[2] .. " Y")
                            return langs[msg.lang].user .. matches[2] .. langs[msg.lang].gbanned
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally banned user " .. matches[2] .. " N")
                            return langs[msg.lang].require_rank
                        end
                    else
                        resolve_username(matches[2]:gsub('@', ''), banall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                    return
                end
                if matches[1]:lower() == 'ungban' or matches[1]:lower() == 'sasha supersbanna' or matches[1]:lower() == 'supersbanna' then
                    -- /ungban
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, unbanall_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, unbanall_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, unbanall_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                        return
                    elseif string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            unbanall_user(matches[2])
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally unbanned user " .. matches[2] .. " Y")
                            return langs[msg.lang].user .. matches[2] .. langs[msg.lang].ungbanned
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally unbanned user " .. matches[2] .. " N")
                            return langs[msg.lang].require_rank
                        end
                    else
                        resolve_username(matches[2]:gsub('@', ''), unbanall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                    return
                end
                if matches[1]:lower() == 'gbanlist' or matches[1]:lower() == 'sasha lista superban' or matches[1]:lower() == 'lista superban' then
                    -- /gbanlist
                    local list = banall_list()
                    local file = io.open("./groups/gbanlist.txt", "w")
                    file:write(list)
                    file:flush()
                    file:close()
                    send_document(receiver, "./groups/gbanlist.txt", ok_cb, false)
                    send_large_msg(receiver, list)
                    return list
                end
            else
                return langs[msg.lang].require_admin
            end
        else
            return langs[msg.lang].require_owner
        end
    else
        return langs[msg.lang].require_mod
    end
end

local function pre_process(msg)
    local data = load_data(_config.moderation.data)
    -- SERVICE MESSAGE
    if msg.action then
        if msg.action.type then
            -- Check if banned user joins chat by link
            if msg.action.type == 'chat_add_user_link' then
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
            if msg.action.type == 'chat_add_user' then
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

return {
    description = "BANHAMMER",
    patterns =
    {
        "^[#!/]([Kk][Ii][Cc][Kk][Mm][Ee])$",
        "^[#!/]([Kk][Ii][Cc][Kk]) (.*)$",
        "^[#!/]([Kk][Ii][Cc][Kk])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Nn][Oo][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee]) (%d+)$",
        "^[#!/]([Kk][Ii][Cc][Kk][Dd][Ee][Ll][Ee][Tt][Ee][Dd])$",
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
        -- kick
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii]) (.*)$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Ss][Pp][Aa][Rr][Aa]) (.*)$",
        "^([Ss][Pp][Aa][Rr][Aa])$",
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
    -- usage
    -- (#kickme|sasha uccidimi)
    -- MOD
    -- (#kick|spara|[sasha] uccidi) <id>|<username>|<reply>|from
    -- (#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>|from
    -- (#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>|from
    -- (#banlist|[sasha] lista ban)
    -- #kickrandom
    -- #kickdeleted
    -- OWNER
    -- #kicknouser
    -- #kickinactive [<msgs>]
    -- ADMIN
    -- (#banlist|[sasha] lista ban) <group_id>
    -- (#gban|[sasha] superbanna) <id>|<username>|<reply>|from
    -- (#ungban|[sasha] supersbanna) <id>|<username>|<reply>|from
    -- (#gbanlist|[sasha] lista superban)
}