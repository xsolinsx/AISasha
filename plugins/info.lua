local function id_by_username(extra, success, result)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    send_large_msg(extra.receiver, result.peer_id)
end

local function id_by_reply(extra, success, result)
    if get_reply_receiver(result) == extra.receiver then
        local text = ''
        local action = false
        if result.action then
            if result.action.type ~= 'chat_add_user_link' then
                action = true
            end
        end

        if action and result.action.user then
            text = result.action.user.peer_id
        else
            text = result.from.peer_id
        end
        send_large_msg(extra.receiver, text)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function id_by_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        send_large_msg(extra.receiver, result.fwd_from.peer_id)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function username_by_id(extra, success, result)
    send_large_msg(extra.receiver, result.username or('NOUSER ' ..(result.first_name or result.title) .. ' ' ..(result.last_name or '')))
end

local function username_by_reply(extra, success, result)
    if get_reply_receiver(result) == extra.receiver then
        local text = ''
        local action = false
        if result.action then
            if result.action.type ~= 'chat_add_user_link' then
                action = true
            end
        end

        if action and result.action.user then
            text = result.action.user.username or('NOUSER ' .. result.action.user.first_name .. ' ' ..(result.action.user.last_name or ''))
        else
            text = result.from.username or('NOUSER ' .. result.from.first_name .. ' ' ..(result.from.last_name or ''))
        end
        send_large_msg(extra.receiver, text)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function username_by_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        send_large_msg(extra.receiver, result.fwd_from.username or('NOUSER ' ..(result.fwd_from.first_name or result.fwd_from.title) .. ' ' ..(result.fwd_from.last_name or '')))
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function get_rank_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    local rank = get_rank(result.peer_id, extra.chat_id)
    send_large_msg(extra.receiver, langs[lang].rank .. reverse_rank_table[rank + 1])
end

local function get_rank_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local rank = get_rank(result.from.peer_id, result.to.peer_id)
        send_large_msg(extra.receiver, langs[lang].rank .. reverse_rank_table[rank + 1])
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function callback_group_members(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local i = 1
    local chatname = result.print_name
    local text = langs[lang].usersIn .. string.gsub(chatname, "_", " ") .. ' ' .. result.peer_id .. '\n'
    for k, v in pairs(result.members) do
        if v.print_name then
            name = v.print_name:gsub("_", " ")
        else
            name = ""
        end
        if v.username then
            username = "@" .. v.username
        else
            username = "NOUSER"
        end
        text = text .. "\n" .. i .. ". " .. name .. "|" .. username .. "|" .. v.peer_id
        i = i + 1
    end
    local file = io.open("./groups/lists/" .. result.peer_id .. "memberlist.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_large_msg(extra.receiver, text)
    send_document(extra.receiver, "./groups/lists/" .. string.match(extra.receiver, '%d+') .. "memberlist.txt", ok_cb, false)
end

local function callback_supergroup_members(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local text = langs[lang].membersOf .. extra.receiver .. '\n'
    local i = 1
    for k, v in pairsByKeys(result) do
        if v.print_name then
            name = v.print_name:gsub("_", " ")
        else
            name = ""
        end
        if v.username then
            username = "@" .. v.username
        else
            username = "NOUSER"
        end
        text = text .. "\n" .. i .. ". " .. name .. "|" .. username .. "|" .. v.peer_id
        i = i + 1
    end
    local file = io.open("./groups/lists/" .. string.match(extra.receiver, '%d+') .. "memberlist.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_large_msg(extra.receiver, text)
    send_document(extra.receiver, "./groups/lists/" .. string.match(extra.receiver, '%d+') .. "memberlist.txt", ok_cb, false)
end

local function callback_kicked(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local text = langs[lang].membersKickedFrom .. extra.receiver .. '\n'
    local i = 1
    for k, v in pairsByKeys(result) do
        if v.print_name then
            name = v.print_name:gsub("_", " ")
        else
            name = ""
        end
        if v.username then
            username = "@" .. v.username
        else
            username = "NOUSER"
        end
        text = text .. "\n" .. i .. ". " .. name .. "|" .. username .. "|" .. v.peer_id
        i = i + 1
    end
    send_large_msg(extra.receiver, text)
end

local function chat_callback_ishere(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local user = extra.user
    local text = langs[lang].ishereNo
    for k, v in pairs(result.members) do
        if tonumber(user) then
            if tonumber(v.peer_id) == tonumber(user) then
                text = langs[lang].ishereYes
            end
        elseif v.username then
            if v.username:lower() == user:lower() then
                text = langs[lang].ishereYes
            end
        end
    end
    send_large_msg(extra.receiver, text)
end

local function channel_callback_ishere(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local user = extra.user
    local text = langs[lang].ishereNo
    for k, v in pairsByKeys(result) do
        if tonumber(user) then
            if tonumber(v.peer_id) == tonumber(user) then
                text = langs[lang].ishereYes
            end
        elseif v.username then
            if v.username:lower() == user:lower() then
                text = langs[lang].ishereYes
            end
        end
    end
    send_large_msg(extra.receiver, text)
end

local function info_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    local text = langs[lang].infoWord .. ' (<username>)'
    if result.peer_type == 'channel' then
        if result.title then
            text = text .. langs[lang].name .. result.title
        end
        if result.username then
            text = text .. langs[lang].username .. '@' .. result.username
        end
        text = text .. langs[lang].date .. os.date('%c') ..
        langs[lang].peer_id .. result.peer_id ..
        langs[lang].long_id .. result.id
    elseif result.peer_type == 'user' then
        if result.first_name then
            text = text .. langs[lang].name .. result.first_name
        end
        if result.real_first_name then
            text = text .. langs[lang].name .. result.real_first_name
        end
        if result.last_name then
            text = text .. langs[lang].surname .. result.last_name
        end
        if result.real_last_name then
            text = text .. langs[lang].surname .. result.real_last_name
        end
        if result.username then
            text = text .. langs[lang].username .. '@' .. result.username
        end
        -- exclude bot phone
        if our_id ~= result.peer_id then
            --[[
            if result.phone then
                text = text .. langs[lang].phone .. '+' .. string.sub(result.phone, 1, 6) .. '******'
            end
            ]]
        end
        local msgs = tonumber(redis:get('msgs:' .. result.peer_id .. ':' .. extra.chat_id) or 0)
        text = text .. langs[lang].rank .. reverse_rank_table[get_rank(result.peer_id, extra.chat_id) + 1] ..
        langs[lang].date .. os.date('%c') ..
        langs[lang].totalMessages .. msgs
        local otherinfo = langs[lang].otherInfo
        if is_whitelisted(extra.chat_id, result.peer_id) then
            otherinfo = otherinfo .. 'WHITELISTED '
        end
        if is_whitelisted_gban(extra.chat_id, result.peer_id) then
            otherinfo = otherinfo .. 'GBANWHITELISTED '
        end
        if is_gbanned(result.peer_id) then
            otherinfo = otherinfo .. 'GBANNED '
        end
        if is_banned(result.peer_id, extra.chat_id) then
            otherinfo = otherinfo .. 'BANNED '
        end
        if is_muted_user(extra.chat_id, result.peer_id) then
            otherinfo = otherinfo .. 'MUTED '
        end
        if string.match(get_user_warns(result.peer_id, extra.chat_id), '%d+') then
            otherinfo = otherinfo .. string.match(get_user_warns(result.peer_id, extra.chat_id), '%d+') .. ' WARN '
        end
        if otherinfo == langs[lang].otherInfo then
            otherinfo = otherinfo .. langs[lang].noOtherInfo
        end
        text = text .. otherinfo ..
        langs[lang].peer_id .. result.peer_id ..
        langs[lang].long_id .. result.id
    else
        text = langs[lang].peerTypeUnknown
    end
    send_large_msg(extra.receiver, text)
end

local function info_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local text = langs[lang].infoWord .. ' (<reply>)'
        local action = false
        if result.action then
            if result.action.type ~= 'chat_add_user_link' then
                action = true
            end
        end

        if action and result.action.user then
            if result.action.user.first_name then
                text = text .. langs[lang].name .. result.action.user.first_name
            end
            if result.action.user.real_first_name then
                text = text .. langs[lang].name .. result.action.user.real_first_name
            end
            if result.action.user.last_name then
                text = text .. langs[lang].surname .. result.action.user.last_name
            end
            if result.action.user.real_last_name then
                text = text .. langs[lang].surname .. result.action.user.real_last_name
            end
            if result.action.user.username then
                text = text .. langs[lang].username .. '@' .. result.action.user.username
            end
            -- exclude bot phone
            if our_id ~= result.action.user.peer_id then
                --[[
            if result.action.user.phone then
                text = text .. langs[lang].phone .. '+' .. string.sub(result.action.user.phone, 1, 6) .. '******'
            end
            ]]
            end
            local msgs = tonumber(redis:get('msgs:' .. result.action.user.peer_id .. ':' .. result.to.peer_id) or 0)
            text = text .. langs[lang].rank .. reverse_rank_table[get_rank(result.action.user.peer_id, result.to.peer_id) + 1] ..
            langs[lang].date .. os.date('%c') ..
            langs[lang].totalMessages .. msgs
            local otherinfo = langs[lang].otherInfo
            if is_whitelisted(result.to.peer_id, result.action.user.peer_id) then
                otherinfo = otherinfo .. 'WHITELISTED '
            end
            if is_whitelisted_gban(result.to.peer_id, result.action.user.peer_id) then
                otherinfo = otherinfo .. 'GBANWHITELISTED '
            end
            if is_gbanned(result.action.user.peer_id) then
                otherinfo = otherinfo .. 'GBANNED '
            end
            if is_banned(result.action.user.peer_id, result.to.peer_id) then
                otherinfo = otherinfo .. 'BANNED '
            end
            if is_muted_user(result.to.peer_id, result.action.user.peer_id) then
                otherinfo = otherinfo .. 'MUTED '
            end
            if string.match(get_user_warns(result.action.user.peer_id, result.to.peer_id), '%d+') then
                otherinfo = otherinfo .. string.match(get_user_warns(result.action.user.peer_id, result.to.peer_id), '%d+') .. ' WARN '
            end
            if otherinfo == langs[lang].otherInfo then
                otherinfo = otherinfo .. langs[lang].noOtherInfo
            end
            text = text .. otherinfo ..
            langs[lang].peer_id .. result.action.user.peer_id ..
            langs[lang].long_id .. result.action.user.id
        else
            if result.from.first_name then
                text = text .. langs[lang].name .. result.from.first_name
            end
            if result.from.real_first_name then
                text = text .. langs[lang].name .. result.from.real_first_name
            end
            if result.from.last_name then
                text = text .. langs[lang].surname .. result.from.last_name
            end
            if result.from.real_last_name then
                text = text .. langs[lang].surname .. result.from.real_last_name
            end
            if result.from.username then
                text = text .. langs[lang].username .. '@' .. result.from.username
            end
            -- exclude bot phone
            if our_id ~= result.from.peer_id then
                --[[
            if result.from.phone then
                text = text .. langs[lang].phone .. '+' .. string.sub(result.from.phone, 1, 6) .. '******'
            end
            ]]
            end
            local msgs = tonumber(redis:get('msgs:' .. result.from.peer_id .. ':' .. result.to.peer_id) or 0)
            text = text .. langs[lang].rank .. reverse_rank_table[get_rank(result.from.peer_id, result.to.peer_id) + 1] ..
            langs[lang].date .. os.date('%c') ..
            langs[lang].totalMessages .. msgs
            local otherinfo = langs[lang].otherInfo
            if is_whitelisted(result.to.peer_id, result.from.peer_id) then
                otherinfo = otherinfo .. 'WHITELISTED '
            end
            if is_whitelisted_gban(result.to.peer_id, result.from.peer_id) then
                otherinfo = otherinfo .. 'GBANWHITELISTED '
            end
            if is_gbanned(result.from.peer_id) then
                otherinfo = otherinfo .. 'GBANNED '
            end
            if is_banned(result.from.peer_id, result.to.peer_id) then
                otherinfo = otherinfo .. 'BANNED '
            end
            if is_muted_user(result.to.peer_id, result.from.peer_id) then
                otherinfo = otherinfo .. 'MUTED '
            end
            if string.match(get_user_warns(result.from.peer_id, result.to.peer_id), '%d+') then
                otherinfo = otherinfo .. string.match(get_user_warns(result.from.peer_id, result.to.peer_id), '%d+') .. ' WARN '
            end
            if otherinfo == langs[lang].otherInfo then
                otherinfo = otherinfo .. langs[lang].noOtherInfo
            end
            text = text .. otherinfo ..
            langs[lang].peer_id .. result.from.peer_id ..
            langs[lang].long_id .. result.from.id
        end
        send_large_msg(extra.receiver, text)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function info_by_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local text = langs[lang].infoWord .. ' (<from>)'
        if result.fwd_from.peer_type == 'channel' then
            if result.fwd_from.title then
                text = text .. langs[lang].name .. result.fwd_from.title
            end
            if result.fwd_from.username then
                text = text .. langs[lang].username .. '@' .. result.fwd_from.username
            end
            text = text .. langs[lang].date .. os.date('%c') ..
            langs[lang].peer_id .. result.fwd_from.peer_id ..
            langs[lang].long_id .. result.fwd_from.id
        elseif result.fwd_from.peer_type == 'user' then
            if result.fwd_from.first_name then
                text = text .. langs[lang].name .. result.fwd_from.first_name
            end
            if result.fwd_from.real_first_name then
                text = text .. langs[lang].name .. result.fwd_from.real_first_name
            end
            if result.fwd_from.last_name then
                text = text .. langs[lang].surname .. result.fwd_from.last_name
            end
            if result.fwd_from.real_last_name then
                text = text .. langs[lang].surname .. result.fwd_from.real_last_name
            end
            if result.fwd_from.username then
                text = text .. langs[lang].username .. '@' .. result.fwd_from.username
            end
            -- exclude bot phone
            if our_id ~= result.fwd_from.peer_id then
                --[[
            if result.fwd_from.phone then
                text = text .. langs[lang].phone .. '+' .. string.sub(result.fwd_from.phone, 1, 6) .. '******'
            end
            ]]
            end
            local msgs = tonumber(redis:get('msgs:' .. result.fwd_from.peer_id .. ':' .. result.to.peer_id) or 0)
            text = text .. langs[lang].rank .. reverse_rank_table[get_rank(result.fwd_from.peer_id, result.to.peer_id) + 1] ..
            langs[lang].date .. os.date('%c') ..
            langs[lang].totalMessages .. msgs
            local otherinfo = langs[lang].otherInfo
            if is_whitelisted(result.to.peer_id, result.fwd_from.peer_id) then
                otherinfo = otherinfo .. 'WHITELISTED '
            end
            if is_whitelisted_gban(result.to.peer_id, result.fwd_from.peer_id) then
                otherinfo = otherinfo .. 'GBANWHITELISTED '
            end
            if is_gbanned(result.fwd_from.peer_id) then
                otherinfo = otherinfo .. 'GBANNED '
            end
            if is_banned(result.fwd_from.peer_id, result.to.peer_id) then
                otherinfo = otherinfo .. 'BANNED '
            end
            if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
                otherinfo = otherinfo .. 'MUTED '
            end
            if string.match(get_user_warns(result.fwd_from.peer_id, result.to.peer_id), '%d+') then
                otherinfo = otherinfo .. string.match(get_user_warns(result.fwd_from.peer_id, result.to.peer_id), '%d+') .. ' WARN '
            end
            if otherinfo == langs[lang].otherInfo then
                otherinfo = otherinfo .. langs[lang].noOtherInfo
            end
            text = text .. otherinfo ..
            langs[lang].peer_id .. result.fwd_from.peer_id ..
            langs[lang].long_id .. result.fwd_from.id
        else
            text = langs[lang].peerTypeUnknown
        end
        send_large_msg(extra.receiver, text)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function info_by_id(extra, success, result)
    local lang = get_lang(extra.chat_id)
    local text = langs[lang].infoWord .. ' (<id>)'
    if result.first_name then
        text = text .. langs[lang].name .. result.first_name
    end
    if result.real_first_name then
        text = text .. langs[lang].name .. result.real_first_name
    end
    if result.last_name then
        text = text .. langs[lang].surname .. result.last_name
    end
    if result.real_last_name then
        text = text .. langs[lang].surname .. result.real_last_name
    end
    if result.username then
        text = text .. langs[lang].username .. '@' .. result.username
    end
    -- exclude bot phone
    if our_id ~= result.peer_id then
        --[[
        if result.phone then
            text = text .. langs[lang].phone .. '+' .. string.sub(result.phone, 1, 6) .. '******'
        end
        ]]
    end
    local msgs = tonumber(redis:get('msgs:' .. result.peer_id .. ':' .. extra.chat_id) or 0)
    text = text .. langs[lang].rank .. reverse_rank_table[get_rank(result.peer_id, extra.chat_id) + 1] ..
    langs[lang].date .. os.date('%c') ..
    langs[lang].totalMessages .. msgs
    local otherinfo = langs[lang].otherInfo
    if is_whitelisted(extra.chat_id, result.peer_id) then
        otherinfo = otherinfo .. 'WHITELISTED '
    end
    if is_whitelisted_gban(extra.chat_id, result.peer_id) then
        otherinfo = otherinfo .. 'GBANWHITELISTED '
    end
    if is_gbanned(result.peer_id) then
        otherinfo = otherinfo .. 'GBANNED '
    end
    if is_banned(result.peer_id, extra.chat_id) then
        otherinfo = otherinfo .. 'BANNED '
    end
    if is_muted_user(extra.chat_id, result.peer_id) then
        otherinfo = otherinfo .. 'MUTED '
    end
    if string.match(get_user_warns(result.peer_id, extra.chat_id), '%d+') then
        otherinfo = otherinfo .. string.match(get_user_warns(result.peer_id, extra.chat_id), '%d+') .. ' WARN '
    end
    if otherinfo == langs[lang].otherInfo then
        otherinfo = otherinfo .. langs[lang].noOtherInfo
    end
    text = text .. otherinfo ..
    langs[lang].peer_id .. result.peer_id ..
    langs[lang].long_id .. result.id
    send_large_msg(extra.receiver, text)
end

local function channel_callback_info(extra, success, result)
    local lang = get_lang(result.peer_id)
    local title = langs[lang].supergroupName .. result.title
    local user_num = langs[lang].users .. tostring(result.participants_count)
    local admin_num = langs[lang].admins .. tostring(result.admins_count)
    local kicked_num = langs[lang].bannedUsers .. tostring(result.kicked_count)
    local channel_id = langs[lang].peer_id .. result.peer_id
    local long_id = langs[lang].long_id .. result.id
    if result.username then
        channel_username = langs[lang].username .. "@" .. result.username
    else
        channel_username = ""
    end
    local text = title .. admin_num .. user_num .. kicked_num .. channel_username .. channel_id .. long_id
    send_large_msg(extra.receiver, text)
end

local function chat_callback_info(extra, success, result)
    local lang = get_lang(result.peer_id)
    local title = langs[lang].groupName .. result.title
    local user_num = langs[lang].users .. tostring(result.members_num)
    local chat_id = langs[lang].peer_id .. result.peer_id
    local long_id = langs[lang].long_id .. result.id
    local text = title .. user_num .. chat_id .. long_id
    send_large_msg(extra.receiver, text)
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    if not msg.api_patch then
        if matches[1]:lower() == "id" then
            if type(msg.reply_id) ~= "nil" then
                if is_momod(msg) then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, id_by_from, { receiver = receiver })
                            return
                        else
                            get_message(msg.reply_id, id_by_reply, { receiver = receiver })
                            return
                        end
                    else
                        get_message(msg.reply_id, id_by_reply, { receiver = receiver })
                        return
                    end
                else
                    return langs[msg.lang].require_mod
                end
            elseif matches[2] and matches[2] ~= '' then
                if is_momod(msg) then
                    resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), id_by_username, { receiver = receiver })
                    return
                else
                    return langs[msg.lang].require_mod
                end
            else
                return msg.from.id .. '\n' .. msg.to.id
            end
        end
        if matches[1]:lower() == "username" then
            if type(msg.reply_id) ~= "nil" then
                if is_momod(msg) then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, username_by_from, { receiver = receiver })
                            return
                        else
                            get_message(msg.reply_id, username_by_reply, { receiver = receiver })
                            return
                        end
                    else
                        get_message(msg.reply_id, username_by_reply, { receiver = receiver })
                        return
                    end
                else
                    return langs[msg.lang].require_mod
                end
            elseif matches[2] and matches[2] ~= '' then
                if is_momod(msg) then
                    user_info('user#id' .. matches[2], username_by_id, { receiver = receiver })
                    return
                else
                    return langs[msg.lang].require_mod
                end
            else
                return(msg.from.username or('NOUSER ' .. msg.from.first_name .. ' ' ..(msg.from.last_name or ''))) .. '\n' ..(msg.to.username or('NOUSER ' .. msg.to.title))
            end
        end
        if matches[1]:lower() == "getrank" or matches[1]:lower() == "rango" then
            if type(msg.reply_id) ~= "nil" then
                get_message(msg.reply_id, get_rank_by_reply, { receiver = receiver })
                return
            elseif matches[2] and matches[2] ~= '' then
                if string.match(matches[2], '^%d+$') then
                    return langs[msg.lang].rank .. reverse_rank_table[get_rank(matches[2], chat) + 1]
                else
                    resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), get_rank_by_username, { receiver = receiver, chat_id = chat })
                    return
                end
            else
                return langs[msg.lang].rank .. reverse_rank_table[get_rank(msg.from.id, chat) + 1]
            end
        end
        vardump(matches)
        if matches[1]:lower() == 'ishere' and matches[2] then
            print('in')
            if string.match(matches[2], '^%d+$') then
                print('id')
                if chat_type == 'channel' then
                    print('channel')
                    channel_get_users(receiver, channel_callback_ishere, { receiver = receiver, user = matches[2] })
                elseif chat_type == 'chat' then
                    chat_info(receiver, chat_callback_ishere, { receiver = receiver, user = matches[2] })
                end
            else
                print('username')
                if chat_type == 'channel' then
                    print('channel')
                    channel_get_users(receiver, channel_callback_ishere, { receiver = receiver, user = matches[2]:gsub('@', '') })
                elseif chat_type == 'chat' then
                    chat_info(receiver, chat_callback_ishere, { receiver = receiver, user = matches[2]:gsub('@', '') })
                end
            end
            return
        end
        if matches[1]:lower() == 'info' or matches[1]:lower() == 'sasha info' then
            if type(msg.reply_id) ~= 'nil' then
                if is_momod(msg) then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, info_by_from, { receiver = receiver })
                            return
                        else
                            get_message(msg.reply_id, info_by_reply, { receiver = receiver })
                            return
                        end
                    else
                        get_message(msg.reply_id, info_by_reply, { receiver = receiver })
                        return
                    end
                else
                    return langs[msg.lang].require_mod
                end
            elseif matches[2] and matches[2] ~= '' then
                if is_momod(msg) then
                    if string.match(matches[2], '^%d+$') then
                        user_info('user#id' .. matches[2], info_by_id, { chat_id = msg.to.id, receiver = receiver })
                        return
                    else
                        resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), info_by_username, { chat_id = msg.to.id, receiver = receiver })
                        return
                    end
                else
                    return langs[msg.lang].require_mod
                end
            else
                local text = langs[msg.lang].infoWord ..
                langs[msg.lang].youAre
                if msg.from.title then
                    text = text .. langs[msg.lang].name .. msg.from.title
                end
                if msg.from.first_name then
                    text = text .. langs[msg.lang].name .. msg.from.first_name
                end
                if msg.from.real_first_name then
                    text = text .. langs[msg.lang].name .. msg.from.real_first_name
                end
                if msg.from.last_name then
                    text = text .. langs[msg.lang].surname .. msg.from.last_name
                end
                if msg.from.real_last_name then
                    text = text .. langs[msg.lang].surname .. msg.from.real_last_name
                end
                if msg.from.username then
                    text = text .. langs[msg.lang].username .. '@' .. msg.from.username
                end
                -- exclude bot phone
                if our_id ~= msg.from.id then
                    --[[
                if msg.from.phone then
                    text = text .. langs[msg.lang].phone .. '+' .. string.sub(msg.from.phone, 1, 6) .. '******'
                end
                ]]
                end
                local msgs = tonumber(redis:get('msgs:' .. msg.from.id .. ':' .. msg.to.id) or 0)
                text = text .. langs[msg.lang].rank .. reverse_rank_table[get_rank(msg.from.id, chat) + 1] ..
                langs[msg.lang].date .. os.date('%c') ..
                langs[msg.lang].totalMessages .. msgs
                local otherinfo = langs[msg.lang].otherInfo
                if is_whitelisted(msg.to.id, msg.from.id) then
                    otherinfo = otherinfo .. 'WHITELISTED, '
                end
                if is_whitelisted_gban(msg.to.id, msg.from.id) then
                    otherinfo = otherinfo .. 'GBANWHITELISTED '
                end
                if is_gbanned(msg.from.id) then
                    otherinfo = otherinfo .. 'GBANNED, '
                end
                if is_banned(msg.from.id, chat) then
                    otherinfo = otherinfo .. 'BANNED, '
                end
                if is_muted_user(chat, msg.from.id) then
                    otherinfo = otherinfo .. 'MUTED, '
                end
                if string.match(get_user_warns(msg.from.id, chat), '%d+') then
                    otherinfo = otherinfo .. string.match(get_user_warns(msg.from.id, chat), '%d+') .. ' WARN '
                end
                if otherinfo == langs[msg.lang].otherInfo then
                    otherinfo = otherinfo .. langs[msg.lang].noOtherInfo
                end
                text = text .. otherinfo ..
                langs[msg.lang].peer_id .. msg.from.id ..
                langs[msg.lang].long_id .. msg.from.peer_id ..
                langs[msg.lang].youAreWriting
                if chat_type == 'user' then
                    text = text .. ' 👤'
                    if msg.to.first_name then
                        text = text .. langs[msg.lang].name .. msg.to.first_name
                    end
                    if msg.to.real_first_name then
                        text = text .. langs[msg.lang].name .. msg.to.real_first_name
                    end
                    if msg.to.last_name then
                        text = text .. langs[msg.lang].surname .. msg.to.last_name
                    end
                    if msg.to.real_last_name then
                        text = text .. langs[msg.lang].surname .. msg.to.real_last_name
                    end
                    if msg.to.username then
                        text = text .. langs[msg.lang].username .. '@' .. msg.to.username
                    end
                    -- exclude bot phone
                    if our_id ~= msg.to.id then
                        --[[
                    if msg.to.phone then
                        text = text .. langs[msg.lang].phone .. '+' .. string.sub(msg.to.phone, 1, 6) .. '******'
                    end
                    ]]
                    end
                    text = text .. langs[msg.lang].rank .. reverse_rank_table[get_rank(msg.to.id, chat) + 1] ..
                    langs[msg.lang].date .. os.date('%c') ..
                    langs[msg.lang].peer_id .. msg.to.id ..
                    langs[msg.lang].long_id .. msg.to.peer_id
                elseif chat_type == 'chat' then
                    text = text .. ' 👥' ..
                    langs[msg.lang].groupName .. msg.to.title ..
                    langs[msg.lang].users .. tostring(msg.to.members_num) ..
                    langs[msg.lang].peer_id .. math.abs(msg.to.id) ..
                    langs[msg.lang].long_id .. msg.to.peer_id
                elseif chat_type == 'channel' then
                    text = text .. ' 👥' ..
                    langs[msg.lang].supergroupName .. msg.to.title
                    if msg.to.username then
                        text = text .. langs[msg.lang].username .. "@" .. msg.to.username
                    end
                    text = text .. langs[msg.lang].peer_id .. math.abs(msg.to.id) ..
                    langs[msg.lang].long_id .. msg.to.peer_id
                end
                return text
            end
        end
    end
    if matches[1]:lower() == "whoami" then
        local text = langs[msg.lang].infoWord ..
        langs[msg.lang].youAre
        if msg.from.title then
            text = text .. langs[msg.lang].name .. msg.from.title
        end
        if msg.from.first_name then
            text = text .. langs[msg.lang].name .. msg.from.first_name
        end
        if msg.from.real_first_name then
            text = text .. langs[msg.lang].name .. msg.from.real_first_name
        end
        if msg.from.last_name then
            text = text .. langs[msg.lang].surname .. msg.from.last_name
        end
        if msg.from.real_last_name then
            text = text .. langs[msg.lang].surname .. msg.from.real_last_name
        end
        if msg.from.username then
            text = text .. langs[msg.lang].username .. '@' .. msg.from.username
        end
        -- exclude bot phone
        if our_id ~= msg.from.id then
            --[[
                if msg.from.phone then
                    text = text .. langs[msg.lang].phone .. '+' .. string.sub(msg.from.phone, 1, 6) .. '******'
                end
                ]]
        end
        local msgs = tonumber(redis:get('msgs:' .. msg.from.id .. ':' .. msg.to.id) or 0)
        text = text .. langs[msg.lang].rank .. reverse_rank_table[get_rank(msg.from.id, chat) + 1] ..
        langs[msg.lang].date .. os.date('%c') ..
        langs[msg.lang].totalMessages .. msgs
        local otherinfo = langs[msg.lang].otherInfo
        if is_whitelisted(msg.to.id, msg.from.id) then
            otherinfo = otherinfo .. 'WHITELISTED, '
        end
        if is_whitelisted_gban(msg.to.id, msg.from.id) then
            otherinfo = otherinfo .. 'GBANWHITELISTED '
        end
        if is_gbanned(msg.from.id) then
            otherinfo = otherinfo .. 'GBANNED, '
        end
        if is_banned(msg.from.id, chat) then
            otherinfo = otherinfo .. 'BANNED, '
        end
        if is_muted_user(chat, msg.from.id) then
            otherinfo = otherinfo .. 'MUTED, '
        end
        if string.match(get_user_warns(msg.from.id, chat), '%d+') then
            otherinfo = otherinfo .. string.match(get_user_warns(msg.from.id, chat), '%d+') .. ' WARN '
        end
        if otherinfo == langs[msg.lang].otherInfo then
            otherinfo = otherinfo .. langs[msg.lang].noOtherInfo
        end
        text = text .. otherinfo ..
        langs[msg.lang].peer_id .. msg.from.id ..
        langs[msg.lang].long_id .. msg.from.peer_id
        return text
    end
    if matches[1]:lower() == 'groupinfo' or matches[1]:lower() == 'sasha info gruppo' or matches[1]:lower() == 'info gruppo' then
        if not matches[2] then
            if chat_type == 'channel' then
                channel_info(receiver, channel_callback_info, { receiver = receiver })
            elseif chat_type == 'chat' then
                chat_info(receiver, chat_callback_info, { receiver = receiver })
            end
        else
            if is_admin1(msg) then
                channel_info('channel#id' .. matches[2], channel_callback_info, { receiver = receiver })
                chat_info('chat#id' .. matches[2], chat_callback_info, { receiver = receiver })
            else
                return langs[msg.lang].require_admin
            end
        end
    end
    if not msg.api_patch then
        if matches[1]:lower() == 'grouplink' or matches[1]:lower() == 'sasha link gruppo' or matches[1]:lower() == 'link gruppo' and matches[2] then
            if is_admin1(msg) then
                local group_link = data[tostring(matches[2])]['settings']['set_link']
                if not group_link then
                    return langs[msg.lang].noLinkAvailable
                end
                return matches[2] .. '\n' .. group_link
            else
                return langs[msg.lang].require_admin
            end
        end
        if (matches[1]:lower() == "who" or matches[1]:lower() == "members" or matches[1]:lower() == "sasha lista membri" or matches[1]:lower() == "lista membri") and not matches[2] then
            if is_momod(msg) then
                if chat_type == 'channel' then
                    channel_get_users(receiver, callback_supergroup_members, { receiver = receiver })
                elseif chat_type == 'chat' then
                    chat_info(receiver, callback_group_members, { receiver = receiver })
                end
            else
                return langs[msg.lang].require_mod
            end
        end
    end
    if matches[1]:lower() == "kicked" or matches[1]:lower() == "sasha lista rimossi" or matches[1]:lower() == "lista rimossi" then
        if chat_type == 'channel' then
            if is_momod(msg) then
                channel_get_kicked(receiver, callback_kicked, { receiver = receiver })
            else
                return langs[msg.lang].require_mod
            end
        end
    end
end

local function pre_process(msg)
    if msg then
        if msg.to.type == 'user' and msg.fwd_from then
            if get_rank(msg.from.id, msg.to.id) > 0 then
                -- if moderator in some group or higher
                local text = langs[msg.lang].infoWord .. ' (<private_from>)'
                if msg.fwd_from.peer_type == 'channel' then
                    if msg.fwd_from.title then
                        text = text .. langs[msg.lang].name .. msg.fwd_from.title
                    end
                    if msg.fwd_from.username then
                        text = text .. langs[msg.lang].username .. '@' .. msg.fwd_from.username
                    end
                    text = text .. langs[msg.lang].date .. os.date('%c') ..
                    langs[msg.lang].peer_id .. msg.fwd_from.peer_id ..
                    langs[msg.lang].long_id .. msg.fwd_from.id
                elseif msg.fwd_from.peer_type == 'user' then
                    if msg.fwd_from.first_name then
                        text = text .. langs[msg.lang].name .. msg.fwd_from.first_name
                    end
                    if msg.fwd_from.real_first_name then
                        text = text .. langs[msg.lang].name .. msg.fwd_from.real_first_name
                    end
                    if msg.fwd_from.last_name then
                        text = text .. langs[msg.lang].surname .. msg.fwd_from.last_name
                    end
                    if msg.fwd_from.real_last_name then
                        text = text .. langs[msg.lang].surname .. msg.fwd_from.real_last_name
                    end
                    if msg.fwd_from.username then
                        text = text .. langs[msg.lang].username .. '@' .. msg.fwd_from.username
                    end
                    -- exclude bot phone
                    if our_id ~= msg.fwd_from.peer_id then
                        --[[
                    if msg.fwd_from.phone then
                        text = text .. langs[msg.lang].phone .. '+' .. string.sub(msg.fwd_from.phone, 1, 6) .. '******'
                    end
                    ]]
                    end
                    text = text .. langs[msg.lang].rank .. reverse_rank_table[get_rank(msg.fwd_from.peer_id, msg.to.id) + 1] ..
                    langs[msg.lang].date .. os.date('%c')
                    local otherinfo = langs[msg.lang].otherInfo
                    if is_whitelisted(msg.to.id, msg.fwd_from.peer_id) then
                        otherinfo = otherinfo .. 'WHITELISTED '
                    end
                    if is_whitelisted_gban(msg.to.id, msg.fwd_from.peer_id) then
                        otherinfo = otherinfo .. 'GBANWHITELISTED '
                    end
                    if is_gbanned(msg.fwd_from.peer_id) then
                        otherinfo = otherinfo .. 'GBANNED '
                    end
                    if is_banned(msg.fwd_from.peer_id, msg.to.id) then
                        otherinfo = otherinfo .. 'BANNED '
                    end
                    if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
                        otherinfo = otherinfo .. 'MUTED '
                    end
                    if string.match(get_user_warns(msg.fwd_from.peer_id, msg.to.id), '%d+') then
                        otherinfo = otherinfo .. string.match(get_user_warns(msg.fwd_from.peer_id, msg.to.id), '%d+') .. ' WARN '
                    end
                    if otherinfo == langs[msg.lang].otherInfo then
                        otherinfo = otherinfo .. langs[msg.lang].noOtherInfo
                    end
                    text = text .. otherinfo ..
                    langs[msg.lang].peer_id .. msg.fwd_from.peer_id ..
                    langs[msg.lang].long_id .. msg.fwd_from.id
                else
                    text = langs[msg.lang].peerTypeUnknown
                end
                send_large_msg('user#id' .. msg.from.id, text)
            end
        end
        return msg
    end
end

return {
    description = "INFO",
    patterns =
    {
        "^[#!/]([Ii][Dd])$",
        "^[#!/]([Ii][Dd]) ([^%s]+)$",
        "^[#!/]([Uu][Ss][Ee][Rr][Nn][Aa][Mm][Ee])$",
        "^[#!/]([Uu][Ss][Ee][Rr][Nn][Aa][Mm][Ee]) ([^%s]+)$",
        "^[#!/]([Gg][Rr][Oo][Uu][Pp][Ii][Nn][Ff][Oo]) (%d+)$",
        "^[#!/]([Gg][Rr][Oo][Uu][Pp][Ii][Nn][Ff][Oo])$",
        "^[#!/]([Gg][Rr][Oo][Uu][Pp][Ll][Ii][Nn][Kk]) (%d+)$",
        "^[#!/]([Ii][Ss][Hh][Ee][Rr][Ee]) ([^%s]+)$",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk]) ([^%s]+)$",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk])$",
        "^[#!/]([Ii][Nn][Ff][Oo]) ([^%s]+)$",
        "^[#!/]([Ii][Nn][Ff][Oo])$",
        "^[#!/]([Ww][Hh][Oo][Aa][Mm][Ii])$",
        "^[#!/]([Ww][Hh][Oo])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ee][Dd])$",
        -- groupinfo
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo])$",
        "^([Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        "^([Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo])$",
        -- grouplink
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Nn][Kk] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        "^([Ll][Ii][Nn][Kk] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        -- getrank
        "^([Rr][Aa][Nn][Gg][Oo]) ([^%s]+)$",
        "^([Rr][Aa][Nn][Gg][Oo])$",
        -- info
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo]) ([^%s]+)$",
        -- who
        "^[#!/]([Mm][Ee][Mm][Bb][Ee][Rr][Ss])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Mm][Ee][Mm][Bb][Rr][Ii])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Ee][Mm][Bb][Rr][Ii])$",
        -- kicked
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Rr][Ii][Mm][Oo][Ss][Ss][Ii])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Rr][Ii][Mm][Oo][Ss][Ss][Ii])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#id",
        "#username",
        "#getrank|rango [<id>|<username>|<reply>|from]",
        "#whoami",
        "(#info|[sasha] info)",
        "#ishere <id>|<username>",
        "(#groupinfo|[sasha] info gruppo)",
        "MOD",
        "#id <username>|<reply>|from",
        "#username <is>|<reply>|from",
        "(#info|[sasha] info) <id>|<username>|<reply>|from",
        "(#who|#members|[sasha] lista membri)",
        "(#kicked|[sasha] lista rimossi)",
        "ADMIN",
        "(#groupinfo|[sasha] info gruppo) <group_id>",
        "(#grouplink|[sasha] link gruppo) <group_id>",
    },
}