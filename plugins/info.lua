--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--       Developers: @Josepdal & @MaSkAoS       --
--     Support: @Skneos,  @iicc1 & @serx666     --
--                                              --
--------------------------------------------------

local function usernameinfo(user)
    if user.username then
        return '@' .. user.username
    end
    if user.print_name then
        return user.print_name
    end
    local text = ''
    if user.first_name then
        text = user.last_name .. ' '
    end
    if user.lastname then
        text = text .. user.last_name
    end
    return text
end

local function whoisname(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    if chat_type == 'chat' then
        send_msg('chat#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. user_username .. ' (' .. user_id .. ')', ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. user_username .. ' (' .. user_id .. ')', ok_cb, false)
    end
end

local function whoisid(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = cb_extra.user_id
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. result.username .. ' (' .. user_id .. ')', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id' .. chat_id, '👤 ' .. lang_text(chat_id, 'user') .. ' @' .. result.username .. ' (' .. user_id .. ')', ok_cb, false)
    end
end

local function channelUserIDs(extra, success, result)
    local receiver = extra.receiver
    print('Result')
    vardump(result)
    local text = ''
    for k, user in ipairs(result) do
        local id = user.peer_id
        local username = usernameinfo(user)
        text = text ..("%s - %s\n"):format(username, id)
    end
    send_large_msg(receiver, text)
end

local function get_id_who(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        send_msg('chat#id' .. msg.to.id, '🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
    elseif msg.to.type == 'channel' then
        send_msg('channel#id' .. msg.to.id, '🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
    end
end

local function returnids(extra, success, result)
    local receiver = extra.receiver
    local chatname = result.print_name
    local id = result.peer_id
    local text =('ID for chat %s (%s):\n'):format(chatname, id)
    for k, user in ipairs(result.members) do
        local username = usernameinfo(user)
        local id = user.peer_id
        local userinfo =("%s - %s\n"):format(username, id)
        text = text .. userinfo
    end
    send_large_msg(receiver, text)
end

-- OLDINFOFUNCTIONS
local function get_message_callback_id(extra, success, result)
    local text = 'INFO (<reply_user>)'
    if result.from.first_name then
        text = text .. '\nNome: ' .. result.from.first_name
    end
    if result.from.real_first_name then
        text = text .. '\nNome: ' .. result.from.real_first_name
    end
    if result.from.last_name then
        text = text .. '\nCognome: ' .. result.from.last_name
    end
    if result.from.real_last_name then
        text = text .. '\nCognome: ' .. result.from.real_last_name
    end
    if result.from.username then
        text = text .. '\nUsername: @' .. result.from.username
    end
    text = text .. '\nId: ' .. result.from.peer_id
    send_large_msg('chat#id' .. result.to.peer_id, text)
    send_large_msg('channel#id' .. result.to.peer_id, text)
end

local function user_info_callback(cb_extra, success, result)
    local text = 'INFO (<user_id>)'
    if result.first_name then
        text = text .. '\nNome: ' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\nNome: ' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\nCognome: ' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\nCognome: ' .. result.real_last_name
    end
    if result.username then
        text = text .. '\nUsername: @' .. result.username
    end
    text = text .. '\nId: ' .. result.peer_id
    send_large_msg('chat#id' .. result.peer_id, text)
    send_large_msg('channel#id' .. result.peer_id, text)
end

local function callbackres(extra, success, result)
    local text = 'INFO (<username>)'
    if result.first_name then
        text = text .. '\nNome: ' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\nNome: ' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\nCognome: ' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\nCognome: ' .. result.real_last_name
    end
    if result.username then
        text = text .. '\nUsername: @' .. result.username
    end
    text = text .. '\nId: ' .. result.peer_id
    send_large_msg('chat#id' .. result.peer_id, text)
    send_large_msg('channel#id' .. result.peer_id, text)
end

local function database(cb_extra, success, result)
    local text
    local id
    local db = io.open("./data/db.txt", "a")
    for k, v in pairs(result.members) do
        text = ''
        id = ''
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
        text = text .. ' Id: ' .. v.peer_id
        text = text .. ' Long_id: ' .. v.id
        id = v.peer_id
        db:write('"' .. id .. '" = "' .. text .. '"\n')
    end
    db:flush()
    db:close()
    send_msg('chat#id' .. result.peer_id, "Data leak.", ok_cb, false)
    post_large_msg('channel#id' .. result.peer_id, "Data leak.")
end
-- OLDINFOFUNCTIONS

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    -- OLDINFO
    if matches[1]:lower() == 'info' or matches[1]:lower() == 'sasha info' then
        if not matches[2] then
            if type(msg.reply_id) ~= "nil" then
                if is_momod(msg) then
                    return get_message(msg.reply_id, get_message_callback_id, false)
                else
                    return lang_text('require_mod')
                end
            else
                local text = lang_text('info') ..
                lang_text('youAre')
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
                text = text .. '\nId: ' .. msg.from.id ..
                lang_text('youAreWriting')
                if chat_type == "user" then
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
                    text = text .. '\nId: ' .. msg.to.id
                    return text
                elseif chat_type == 'chat' then
                    text = text ..
                    lang_text('groupName') .. msg.to.print_name:gsub("_", " ") ..
                    lang_text('members') .. msg.to.members_num ..
                    '\nId: ' .. math.abs(msg.to.id)
                    return text
                elseif chat_type == 'channel' then
                    text = text ..
                    lang_text('supergroupName') .. msg.to.print_name:gsub("_", " ") ..
                    '\nId: ' .. math.abs(msg.to.id)
                    return text
                end
            end
        elseif chat_type == 'chat' or chat_type == 'channel' then
            if is_momod(msg) then
                if string.match(matches[2], '^%d+$') then
                    return user_info("user#id" .. matches[2], user_info_callback, { msg = msg })
                else
                    return resolve_username(matches[2]:gsub("@", ""), callbackres, { chatid = msg.to.id })
                end
            else
                return lang_text('require_mod')
            end
        end
    end
    if (matches[1]:lower() == 'database' or matches[1]:lower() == 'sasha database') and msg.to.type ~= 'user' and is_sudo(msg) then
        return chat_info(get_receiver(msg), database, { receiver = get_receiver(msg) })
    end
    -- OLDINFO

    --[[ Id of the user and info about group / channel
    if matches[1]:lower() == "#id" then
        if permissions(msg.from.id, msg.to.id, "id") then
            if msg.to.type == 'channel' then
                send_msg(msg.to.peer_id, '🔠 ' .. lang_text(chat, 'supergroupName') .. ': ' .. msg.to.print_name:gsub("_", " ") .. '\n👥 ' .. lang_text(chat, 'supergroup') .. ' ID: ' .. msg.to.id .. '\n🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
            elseif msg.to.type == 'chat' then
                send_msg(msg.to.peer_id, '🔠 ' .. lang_text(chat, 'chatName') .. ': ' .. msg.to.print_name:gsub("_", " ") .. '\n👥 ' .. lang_text(chat, 'chat') .. ' ID: ' .. msg.to.id .. '\n🆔 ' .. lang_text(chat, 'user') .. ' ID: ' .. msg.from.id, ok_cb, false)
            end
        end
    elseif matches[1]:lower() == 'whois' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, { receiver = get_receiver(msg) })
                return
            end
            if is_id(matches[2]) then
                print(1)
                user_info('user#id' .. matches[2], whoisid, { chat_type = chat_type, chat_id = chat_id, user_id = matches[2] })
                return
            else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, { chat_id = chat_id, member = member, chat_type = chat_type })
                return
            end
        else
            return '🚫 ' .. lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1]:lower() == 'chat' or matches[1]:lower() == 'channel' then
        if permissions(msg.from.id, msg.to.id, "whois") then
            local type = matches[1]
            local chanId = matches[2]
            -- !ids? (chat) (%d+)
            if chanId then
                local chan =("%s#id%s"):format(type, chanId)
                if type == 'chat' then
                    chat_info(chan, returnids, { receiver = receiver })
                else
                    channel_get_users(chan, channelUserIDs, { receiver = receiver })
                end
            else
                -- !id chat/channel
                local chan =("%s#id%s"):format(msg.to.type, msg.to.id)
                if msg.to.type == 'channel' then
                    channel_get_users(chan, channelUserIDs, { receiver = receiver })
                end
                if msg.to.type == 'chat' then
                    chat_info(chan, returnids, { receiver = receiver })
                end
            end
        else
            return '🚫 ' .. lang_text(msg.to.id, 'require_mod')
        end
    end]]
end

return {

    description = "INFO",
    usage =
    {
        "[/]|[sasha] database: Sasha salva i dati di tutti gli utenti.",
        "[/]|[sasha] info [<id>|<username>|<reply>]: Sasha manda le info dell'utente e della chat o di se stessa. Se è specificato uno dei parametri manda le informazioni richieste.",
    },
    patterns =
    {
        --[["^#([Ww][Hh][Oo][Ii][Ss])$",
        "^#[Ii][Dd]$",
        "^#[Ii][Dd][Ss]? ([Cc][Hh][Aa][Tt])$",
        "^#[Ii][Dd][Ss]? ([Cc][Hh][Aa][Nn][Nn][Ee][Ll])$",
        "^#([Ww][Hh][Oo][Ii][Ss]) (.*)$",]]
        "^[!/#]([dD][aA][tT][aA][bB][aA][sS][eE])$",
        "^[!/#]([iI][nN][fF][oO])$",
        "^[!/#]([iI][nN][fF][oO]) (.*)$",
        -- database
        "^([sS][aA][sS][hH][aA] [dD][aA][tT][aA][bB][aA][sS][eE])$",
        -- info
        "^([sS][aA][sS][hH][aA] [iI][nN][fF][oO])$",
        "^([sS][aA][sS][hH][aA] [iI][nN][fF][oO]) (.*)$",
    },
    run = run
}