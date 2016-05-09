local function callback_group_members(cb_extra, success, result)
    local i = 1
    local chat_id = "chat#id" .. result.peer_id
    local chatname = result.print_name
    local text = lang_text('usersIn') .. string.gsub(chatname, "_", " ") .. ' ' .. result.peer_id .. '\n'
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
    send_large_msg(cb_extra.receiver, text)
end

local function callback_supergroup_members(cb_extra, success, result)
    local text = lang_text('membersOf') .. cb_extra.receiver .. '\n'
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
    send_large_msg(cb_extra.receiver, text)
end

local function callback_kicked(cb_extra, success, result)
    -- vardump(result)
    local text = lang_text('membersKickedFrom') .. cb_extra.receiver .. '\n'
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
    send_large_msg(cb_extra.receiver, text)
end

local function callback_reply(extra, success, result)
    local text = lang_text('info') .. ' (<reply>)'
    if result.from.title then
        text = text .. lang_text('name') .. result.from.title
    end
    if result.from.first_name then
        text = text .. lang_text('name') .. result.from.first_name
    end
    if result.from.real_first_name then
        text = text .. lang_text('name') .. result.from.real_first_name
    end
    if result.from.last_name then
        text = text .. lang_text('surname') .. result.from.last_name
    end
    if result.from.real_last_name then
        text = text .. lang_text('surname') .. result.from.real_last_name
    end
    if result.from.username then
        text = text .. lang_text('username') .. '@' .. result.from.username
    end
    -- exclude bot phone
    if our_id ~= result.from.peer_id then
        if result.from.phone then
            text = text .. lang_text('phone') .. string.sub(result.from.phone, 1, 6) .. '******'
        end
    end
    local msgs = tonumber(redis:get('msgs:' .. result.from.peer_id .. ':' .. result.to.peer_id) or 0)
    text = text .. lang_text('rank') .. reverse_rank_table[get_rank(result.from.peer_id, result.to.peer_id) + 1] ..
    lang_text('date') .. os.date('%c') ..
    lang_text('totalMessages') .. msgs ..
    lang_text('otherInfo')
    if is_whitelisted(result.from.peer_id) then
        text = text .. 'WHITELISTED, '
    end
    if is_gbanned(result.from.peer_id) then
        text = text .. 'GBANNED, '
    end
    if is_banned(result.from.peer_id, result.to.peer_id) then
        text = text .. 'BANNED, '
    end
    if is_muted_user(result.to.peer_id, result.from.peer_id) then
        text = text .. 'MUTED, '
    end
    text = text .. '\n🆔: ' .. result.from.peer_id
    send_large_msg('chat#id' .. result.to.peer_id, text)
    send_large_msg('channel#id' .. result.to.peer_id, text)
end

local function callback_id(cb_extra, success, result)
    local text = lang_text('info') .. ' (<id>)'
    if result.title then
        text = text .. lang_text('name') .. result.title
    end
    if result.first_name then
        text = text .. lang_text('name') .. result.first_name
    end
    if result.real_first_name then
        text = text .. lang_text('name') .. result.real_first_name
    end
    if result.last_name then
        text = text .. lang_text('surname') .. result.last_name
    end
    if result.real_last_name then
        text = text .. lang_text('surname') .. result.real_last_name
    end
    if result.username then
        text = text .. lang_text('username') .. '@' .. result.username
    end
    -- exclude bot phone
    if our_id ~= result.peer_id then
        if result.phone then
            text = text .. lang_text('phone') .. string.sub(result.phone, 1, 6) .. '******'
        end
    end
    local msgs = tonumber(redis:get('msgs:' .. result.peer_id .. ':' .. cb_extra.msg.to.id) or 0)
    text = text .. lang_text('rank') .. reverse_rank_table[get_rank(result.peer_id, cb_extra.msg.to.id) + 1] ..
    lang_text('date') .. os.date('%c') ..
    lang_text('totalMessages') .. msgs ..
    lang_text('otherInfo')
    if is_whitelisted(result.peer_id) then
        text = text .. 'WHITELISTED, '
    end
    if is_gbanned(result.peer_id) then
        text = text .. 'GBANNED, '
    end
    if is_banned(result.peer_id, cb_extra.msg.to.id) then
        text = text .. 'BANNED, '
    end
    if is_muted_user(cb_extra.msg.to.id, result.peer_id) then
        text = text .. 'MUTED, '
    end
    text = text .. '\n🆔: ' .. result.peer_id
    '\n🆔: ' .. result.peer_id
    send_large_msg('chat#id' .. cb_extra.msg.to.id, text)
    send_large_msg('channel#id' .. cb_extra.msg.to.id, text)
end

local function callback_username(extra, success, result)
    local text = lang_text('info') .. ' (<username>)'
    if result.title then
        text = text .. lang_text('name') .. result.title
    end
    if result.first_name then
        text = text .. lang_text('name') .. result.first_name
    end
    if result.real_first_name then
        text = text .. lang_text('name') .. result.real_first_name
    end
    if result.last_name then
        text = text .. lang_text('surname') .. result.last_name
    end
    if result.real_last_name then
        text = text .. lang_text('surname') .. result.real_last_name
    end
    if result.username then
        text = text .. lang_text('username') .. '@' .. result.username
    end
    -- exclude bot phone
    if our_id ~= result.peer_id then
        if result.phone then
            text = text .. lang_text('phone') .. string.sub(result.phone, 1, 6) .. '******'
        end
    end
    local msgs = tonumber(redis:get('msgs:' .. result.peer_id .. ':' .. extra.chatid) or 0)
    text = text .. lang_text('rank') .. reverse_rank_table[get_rank(result.peer_id, extra.chatid) + 1] ..
    lang_text('date') .. os.date('%c') ..
    lang_text('totalMessages') .. msgs ..
    lang_text('otherInfo')
    if is_whitelisted(result.peer_id) then
        text = text .. 'WHITELISTED, '
    end
    if is_gbanned(result.peer_id) then
        text = text .. 'GBANNED, '
    end
    if is_banned(result.peer_id, extra.chatid) then
        text = text .. 'BANNED, '
    end
    if is_muted_user(extra.chatid, result.peer_id) then
        text = text .. 'MUTED, '
    end
    text = text .. '\n🆔: ' .. result.peer_id
    send_large_msg('chat#id' .. extra.chatid, text)
    send_large_msg('channel#id' .. extra.chatid, text)
end

local function callback_from(extra, success, result)
    local text = lang_text('info') .. ' (<from>)'
    if result.fwd_from.title then
        text = text .. lang_text('name') .. result.fwd_from.title
    end
    if result.fwd_from.first_name then
        text = text .. lang_text('name') .. result.fwd_from.first_name
    end
    if result.fwd_from.real_first_name then
        text = text .. lang_text('name') .. result.fwd_from.real_first_name
    end
    if result.fwd_from.last_name then
        text = text .. lang_text('surname') .. result.fwd_from.last_name
    end
    if result.fwd_from.real_last_name then
        text = text .. lang_text('surname') .. result.fwd_from.real_last_name
    end
    if result.fwd_from.username then
        text = text .. lang_text('username') .. '@' .. result.fwd_from.username
    end
    -- exclude bot phone
    if our_id ~= result.fwd_from.peer_id then
        if result.fwd_from.phone then
            text = text .. lang_text('phone') .. string.sub(result.fwd_from.phone, 1, 6) .. '******'
        end
    end
    local msgs = tonumber(redis:get('msgs:' .. result.fwd_from.peer_id .. ':' .. result.to.peer_id) or 0)
    text = text .. lang_text('rank') .. reverse_rank_table[get_rank(result.fwd_from.peer_id, result.to.peer_id) + 1] ..
    lang_text('date') .. os.date('%c') ..
    lang_text('totalMessages') .. msgs ..
    lang_text('otherInfo')
    if is_whitelisted(result.fwd_from.peer_id) then
        text = text .. 'WHITELISTED, '
    end
    if is_gbanned(result.fwd_from.peer_id) then
        text = text .. 'GBANNED, '
    end
    if is_banned(result.fwd_from.peer_id, result.to.peer_id) then
        text = text .. 'BANNED, '
    end
    if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
        text = text .. 'MUTED, '
    end
    text = text .. '\n🆔: ' .. result.fwd_from.peer_id
    send_large_msg('chat#id' .. result.to.peer_id, text)
    send_large_msg('channel#id' .. result.to.peer_id, text)
end

local function channel_callback_info(cb_extra, success, result)
    local title = lang_text('supergroupName') .. result.title .. "\n"
    local user_num = lang_text('users') .. result.participants_count
    local admin_num = lang_text('admins') .. result.admins_count
    local kicked_num = lang_text('kickedUsers') .. result.kicked_count
    local channel_id = "\n🆔: " .. result.peer_id
    if result.username then
        channel_username = lang_text('username') .. "@" .. result.username
    else
        channel_username = ""
    end
    local text = title .. admin_num .. user_num .. kicked_num .. channel_id .. channel_username
    send_large_msg(cb_extra.receiver, text)
end

local function chat_callback_info(cb_extra, success, result)
    local title = lang_text('groupName') .. result.title .. "\n"
    local user_num = lang_text('users') .. result.members_num
    local chat_id = "\n🆔: " .. result.peer_id
    local text = title .. user_num .. chat_id
    send_large_msg(cb_extra.receiver, text)
end

local function database(cb_extra, success, result)
    local text
    local id
    local db = io.open("./data/db.txt", "a")
    for k, v in pairs(result.members) do
        text = ''
        id = ''
        if v.title then
            text = text .. ' Nome: ' .. v.title
        end
        if v.first_name then
            text = text .. ' Nome: ' .. v.first_name
        end
        if v.real_first_name then
            text = text .. ' Nome: ' .. v.real_first_name
        end
        if v.last_name then
            text = text .. ' Cognome: ' .. v.last_name
        end
        if v.real_last_name then
            text = text .. ' Cognome: ' .. v.real_last_name
        end
        if v.username then
            text = text .. ' Username: @' .. v.username
        end
        if v.phone then
            text = text .. 'Telefono: ' .. string.sub(v.phone, 1, 6) .. '******'
        end
        text = text .. 'Rango: ' .. reverse_rank_table[get_rank(v.peer_id, result.peer_id) + 1]
        .. 'Data: ' .. os.date('%c')
        .. 'Altre informazioni:  '
        if is_whitelisted(v.peer_id) then
            text = text .. 'WHITELISTED, '
        end
        if is_gbanned(v.peer_id) then
            text = text .. 'GBANNED, '
        end
        if is_banned(v.peer_id, result.peer_id) then
            text = text .. 'BANNED, '
        end
        if is_muted_user(result.peer_id, v.peer_id) then
            text = text .. 'MUTED, '
        end
        text = text .. '\nId: ' .. v.peer_id
        .. ' Long_id: ' .. v.id
        id = v.peer_id
        db:write('"' .. id .. '" = "' .. text .. '"\n')
    end
    db:flush()
    db:close()
    send_msg('chat#id' .. result.peer_id, "Data leak.", ok_cb, false)
    post_large_msg('channel#id' .. result.peer_id, "Data leak.")
end

local function pre_process(msg)
    if msg.to.type == 'user' and msg.fwd_from then
        if is_support(msg.from.id) or is_admin1(msg) then
            local text = lang_text('info') .. ' (<private_from>)'
            if msg.fwd_from.title then
                text = text .. lang_text('name') .. msg.fwd_from.title
            end
            if msg.fwd_from.first_name then
                text = text .. lang_text('name') .. msg.fwd_from.first_name
            end
            if msg.fwd_from.real_first_name then
                text = text .. lang_text('name') .. msg.fwd_from.real_first_name
            end
            if msg.fwd_from.last_name then
                text = text .. lang_text('surname') .. msg.fwd_from.last_name
            end
            if msg.fwd_from.real_last_name then
                text = text .. lang_text('surname') .. msg.fwd_from.real_last_name
            end
            if msg.fwd_from.username then
                text = text .. lang_text('username') .. '@' .. msg.fwd_from.username
            end
            if our_id ~= result.fwd_from.peer_id then
                if msg.fwd_from.phone then
                    text = text .. lang_text('phone') .. string.sub(msg.fwd_from.phone, 1, 6) .. '****'
                end
            end
            text = text .. lang_text('rank') .. reverse_rank_table[get_rank(msg.fwd_from.peer_id, msg.to.id) + 1] ..
            lang_text('date') .. os.date('%c') ..
            lang_text('otherInfo')
            if is_whitelisted(msg.fwd_from.peer_id) then
                text = text .. 'WHITELISTED, '
            end
            if is_gbanned(msg.fwd_from.peer_id) then
                text = text .. 'GBANNED, '
            end
            if is_banned(msg.fwd_from.peer_id, msg.to.id) then
                text = text .. 'BANNED, '
            end
            if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
                text = text .. 'MUTED, '
            end
            text = text .. '\n🆔: ' .. msg.fwd_from.peer_id
            send_large_msg('user#id' .. msg.from.id, text)
        else
            return
        end
    end
    return msg
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    if matches[1]:lower() == "getrank" or matches[1]:lower() == "rango" then
        if type(msg.reply_id) ~= "nil" then
            return get_message(msg.reply_id, get_rank_by_reply, false)
        elseif matches[2] then
            if string.match(matches[2], '^%d+$') then
                return lang_text('rank') .. reverse_rank_table[get_rank(matches[2], chat) + 1]
            else
                return resolve_username(string.gsub(matches[2], '@', ''), get_rank_by_username, { chat_id = chat })
            end
        else
            return lang_text('rank') .. reverse_rank_table[get_rank(msg.from.id, chat) + 1]
        end
    end
    if matches[1]:lower() == 'info' or matches[1]:lower() == 'sasha info' then
        if not matches[2] then
            if type(msg.reply_id) ~= 'nil' then
                if is_momod(msg) then
                    return get_message(msg.reply_id, callback_reply, false)
                else
                    return lang_text('require_mod')
                end
            else
                local text = lang_text('info') ..
                lang_text('youAre')
                if msg.from.title then
                    text = text .. lang_text('name') .. msg.from.title
                end
                if msg.from.first_name then
                    text = text .. lang_text('name') .. msg.from.first_name
                end
                if msg.from.real_first_name then
                    text = text .. lang_text('name') .. msg.from.real_first_name
                end
                if msg.from.last_name then
                    text = text .. lang_text('surname') .. msg.from.last_name
                end
                if msg.from.real_last_name then
                    text = text .. lang_text('surname') .. msg.from.real_last_name
                end
                if msg.from.username then
                    text = text .. lang_text('username') .. '@' .. msg.from.username
                end
                if msg.from.phone then
                    text = text .. lang_text('phone') .. string.sub(msg.from.phone, 1, 6) .. '****'
                end
                local msgs = tonumber(redis:get('msgs:' .. msg.from.id .. ':' .. msg.to.id) or 0)
                text = text .. lang_text('rank') .. reverse_rank_table[get_rank(msg.from.id, chat) + 1] ..
                lang_text('date') .. os.date('%c') ..
                lang_text('totalMessages') .. msgs ..
                lang_text('otherInfo')
                if is_whitelisted(msg.from.id) then
                    text = text .. 'WHITELISTED, '
                end
                if is_gbanned(msg.from.id) then
                    text = text .. 'GBANNED, '
                end
                if is_banned(msg.from.id, chat) then
                    text = text .. 'BANNED, '
                end
                if is_muted_user(chat, msg.from.id) then
                    text = text .. 'MUTED, '
                end
                text = text .. '\n🆔: ' .. msg.from.id ..
                lang_text('youAreWriting')
                if chat_type == 'user' then
                    text = text .. ' 👤'
                    if msg.to.first_name then
                        text = text .. lang_text('name') .. msg.to.first_name
                    end
                    if msg.to.real_first_name then
                        text = text .. lang_text('name') .. msg.to.real_first_name
                    end
                    if msg.to.last_name then
                        text = text .. lang_text('surname') .. msg.to.last_name
                    end
                    if msg.to.real_last_name then
                        text = text .. lang_text('surname') .. msg.to.real_last_name
                    end
                    if msg.to.username then
                        text = text .. lang_text('username') .. '@' .. msg.to.username
                    end
                    -- exclude bot phone
                    if our_id ~= msg.to.id then
                        if msg.to.phone then
                            text = text .. lang_text('phone') .. string.sub(msg.to.phone, 1, 6) .. '****'
                        end
                    end
                    text = text .. lang_text('rank') .. reverse_rank_table[get_rank(msg.to.id, chat) + 1] ..
                    lang_text('date') .. os.date('%c') ..
                    '\n🆔: ' .. msg.to.id
                    return text
                elseif chat_type == 'chat' then
                    text = text .. ' 👥' ..
                    lang_text('groupName') .. msg.to.title .. "\n" ..
                    lang_text('users') .. msg.to.members_num
                    '\n🆔: ' .. math.abs(msg.to.id)
                    return text
                elseif chat_type == 'channel' then
                    text = text .. ' 👥' ..
                    lang_text('supergroupName') .. msg.to.title .. "\n" ..
                    lang_text('users') .. msg.to.participants_count ..
                    lang_text('admins') .. msg.to.admins_count ..
                    lang_text('kickedUsers') .. msg.to.kicked_count
                    if msg.to.username then
                        text = text .. lang_text('username') .. "@" .. msg.to.username
                    end
                    local text = title .. admin_num .. user_num .. kicked_num .. channel_id .. channel_username
                    "\n🆔: " .. math.abs(msg.to.id)
                    return text
                end
            end
        elseif chat_type == 'chat' or chat_type == 'channel' then
            if is_momod(msg) then
                if matches[2]:lower() == 'from' and type(msg.reply_id) ~= "nil" then
                    get_message(msg.reply_id, callback_from, { msg = msg })
                    return
                elseif string.match(matches[2], '^%d+$') then
                    user_info('user#id' .. matches[2], callback_id, { msg = msg })
                    return
                else
                    resolve_username(matches[2]:gsub("@", ""), callback_username, { chatid = msg.to.id })
                    return
                end
            else
                return lang_text('require_mod')
            end
        end
    end
    if matches[1]:lower() == 'groupinfo' or matches[1]:lower() == 'sasha info gruppo' or matches[1]:lower() == 'info gruppo' and matches[2] then
        if is_owner(msg) then
            if chat_type == 'channel' then
                channel_info('channel#id' .. matches[2], channel_callback_info, { receiver = receiver, msg = msg })
            elseif chat_type == 'chat' then
                chat_info('chat#id' .. matches[2], chat_callback_info, { receiver = receiver })
            end
        else
            return lang_text('require_owner')
        end
    end
    if matches[1]:lower() == 'database' or matches[1]:lower() == 'sasha database' then
        if is_sudo(msg) then
            if chat_type == 'channel' then
                channel_info(receiver, database, { receiver = receiver, msg = msg })
            elseif chat_type == 'chat' then
                chat_info(receiver, database, { receiver = receiver })
            end
        else
            return lang_text('require_sudo')
        end
    end
    if (matches[1]:lower() == "who" or matches[1]:lower() == "members" or matches[1]:lower() == "sasha lista membri" or matches[1]:lower() == "lista membri") and not matches[2] then
        if is_momod(msg) then
            local user_id = msg.from.peer_id
            if chat_type == 'channel' then
                channel_get_users(receiver, callback_supergroup_members, { receiver = receiver })
            elseif chat_type == 'chat' then
                chat_info(receiver, callback_group_members, { receiver = receiver })
            end
        else
            return lang_text('require_mod')
        end
    end
    if matches[1]:lower() == "kicked" or matches[1]:lower() == "sasha lista rimossi" or matches[1]:lower() == "lista rimossi" then
        if chat_type == 'channel' then
            if is_momod(msg) then
                channel_get_kicked(receiver, callback_kicked, { receiver = receiver })
            else
                return lang_text('require_mod')
            end
        end
    end
end

return {
    description = "INFO",
    patterns =
    {
        "^[#!/]([Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        "^[#!/]([Gg][Rr][Oo][Uu][Pp][Ii][Nn][Ff][Oo]) (%d+)$",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk])$",
        "^[#!/]([Ii][Nn][Ff][Oo]) (.*)$",
        "^[#!/]([Ii][Nn][Ff][Oo])$",
        "^[#!/]([Ww][Hh][Oo])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ee][Dd])$",
        -- database
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])$",
        -- groupinfo
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        "^([Ii][Nn][Ff][Oo] [Gg][Rr][Uu][Pp][Pp][Oo]) (%d+)$",
        -- getrank
        "^([Rr][Aa][Nn][Gg][Oo]) (.*)$",
        "^([Rr][Aa][Nn][Gg][Oo])$",
        -- info
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo]) (.*)$",
        -- who
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Mm][Ee][Mm][Bb][Rr][Ii])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Ee][Mm][Bb][Rr][Ii])$",
        -- kicked
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Rr][Ii][Mm][Oo][Ss][Ss][Ii])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Rr][Ii][Mm][Oo][Ss][Ss][Ii])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0
    -- usage
    -- #getrank|rango [<id>|<username>|<reply>]
    -- (#info|[sasha] info)
    -- MOD
    -- (#info|[sasha] info) <id>|<username>|<reply>|from
    -- (#who|#members|[sasha] lista membri)
    -- (#kicked|[sasha] lista rimossi)
    -- OWNER
    -- (#groupinfo|[sasha] info gruppo) <group_id>
    -- SUDO
    -- (#database|[sasha] database)
}