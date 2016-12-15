multiple_kicks = { }
preview_user = {
    id = '1234567890',
    first_name = 'FIRST_NAME',
    last_name = 'LAST_NAME',
    username = '@USERNAME',
    print_name = 'FIRST_NAME LAST_NAME'
}

local function set_welcome(chat_id, welcome)
    local lang = get_lang(chat_id)
    data[tostring(chat_id)]['welcome'] = welcome
    save_data(_config.moderation.data, data)
    return langs[lang].newWelcome .. welcome
end

local function get_welcome(chat_id)
    if not data[tostring(chat_id)]['welcome'] then
        return ''
    end
    local welcome = data[tostring(chat_id)]['welcome']
    return welcome
end

local function unset_welcome(chat_id)
    local lang = get_lang(chat_id)
    data[tostring(chat_id)]['welcome'] = ''
    save_data(_config.moderation.data, data)
    return langs[lang].welcomeRemoved
end

local function set_memberswelcome(chat_id, value)
    local lang = get_lang(chat_id)
    data[tostring(chat_id)]['welcomemembers'] = value
    save_data(_config.moderation.data, data)
    return string.gsub(langs[lang].newWelcomeNumber, 'X', tostring(value))
end

local function get_memberswelcome(chat_id)
    local lang = get_lang(chat_id)
    if not data[tostring(chat_id)]['welcomemembers'] then
        return langs[lang].noSetValue
    end
    local value = data[tostring(chat_id)]['welcomemembers']
    return value
end

local function set_goodbye(chat_id, goodbye)
    local lang = get_lang(chat_id)
    data[tostring(chat_id)]['goodbye'] = goodbye
    save_data(_config.moderation.data, data)
    return langs[lang].newGoodbye .. goodbye
end

local function get_goodbye(chat_id)
    if not data[tostring(chat_id)]['goodbye'] then
        return ''
    end
    local goodbye = data[tostring(chat_id)]['goodbye']
    return goodbye
end

local function unset_goodbye(chat_id)
    local lang = get_lang(chat_id)
    data[tostring(chat_id)]['goodbye'] = ''
    save_data(_config.moderation.data, data)
    return langs[lang].goodbyeRemoved
end

local function get_rules(chat_id)
    local lang = get_lang(chat_id)
    if not data[tostring(chat_id)]['rules'] then
        return langs[lang].noRules
    end
    local rules = data[tostring(chat_id)]['rules']
    return rules
end

local function adjust_goodbyewelcome(goodbyewelcome, chat, user)
    if string.find(goodbyewelcome, '$chatid') then
        goodbyewelcome = goodbyewelcome:gsub('$chatid', chat.id)
    end
    if string.find(goodbyewelcome, '$chatname') then
        goodbyewelcome = goodbyewelcome:gsub('$chatname', chat.title)
    end
    if string.find(goodbyewelcome, '$chatusername') then
        if chat.username then
            goodbyewelcome = goodbyewelcome:gsub('$chatusername', '@' .. chat.username)
        else
            goodbyewelcome = goodbyewelcome:gsub('$chatusername', 'NO CHAT USERNAME')
        end
    end
    if string.find(goodbyewelcome, '$rules') then
        goodbyewelcome = goodbyewelcome:gsub('$rules', get_rules(chat.id))
    end
    if string.find(goodbyewelcome, '$userid') then
        goodbyewelcome = goodbyewelcome:gsub('$userid', user.id)
    end
    if string.find(goodbyewelcome, '$firstname') then
        goodbyewelcome = goodbyewelcome:gsub('$firstname', user.first_name)
    end
    if string.find(goodbyewelcome, '$lastname') then
        if user.last_name then
            goodbyewelcome = goodbyewelcome:gsub('$lastname', user.last_name)
        end
    end
    if string.find(goodbyewelcome, '$printname') then
        user.print_name = user.first_name
        if user.last_name then
            user.print_name = user.print_name .. ' ' .. user.last_name
        end
        goodbyewelcome = goodbyewelcome:gsub('$printname', user.print_name)
    end
    if string.find(goodbyewelcome, '$username') then
        if user.username then
            goodbyewelcome = goodbyewelcome:gsub('$username', '@' .. user.username)
        else
            goodbyewelcome = goodbyewelcome:gsub('$username', 'NO USERNAME')
        end
    end
    return goodbyewelcome
end

local function run(msg, matches)
    if not msg.api_patch then
        -- multiple_kicks
        if matches[1]:lower() == 'kickdeleted' or matches[1]:lower() == 'kickinactive' or matches[1]:lower() == 'kicknouser' then
            -- set multiple_kicks of the group as true, after 5 seconds it's set to false to restore goodbye
            multiple_kicks[tostring(msg.to.id)] = true
            local function post_multiple_kick_false()
                multiple_kicks[tostring(msg.to.id)] = false
            end
            postpone(post_multiple_kick_false, false, 30)
        end
        if msg.action then
            if (msg.action.type == "chat_add_user" or msg.action.type == "chat_add_user_link") and get_memberswelcome(msg.to.id) ~= langs[msg.lang].noSetValue then
                local hash
                if msg.to.type == 'channel' then
                    hash = 'channel:welcome' .. msg.to.id
                end
                if msg.to.type == 'chat' then
                    hash = 'chat:welcome' .. msg.to.id
                end
                redis:incr(hash)
                local hashonredis = redis:get(hash)
                if hashonredis then
                    if tonumber(hashonredis) >= tonumber(get_memberswelcome(msg.to.id)) and tonumber(get_memberswelcome(msg.to.id)) ~= 0 then
                        local function post_msg()
                            send_large_msg(get_receiver(msg), adjust_goodbyewelcome(get_welcome(msg.to.id), msg.to, msg.action.user or msg.from), ok_cb, false)
                        end
                        postpone(post_msg, false, 1)
                        redis:getset(hash, 0)
                    end
                else
                    redis:set(hash, 0)
                end
            end
            -- if there's someone kicked in the group with multiple_kicks = true it doesn't send goodbye messages
            if msg.action.type == "chat_del_user" and get_goodbye(msg.to.id) ~= '' and not multiple_kicks[tostring(msg.to.id)] then
                local function post_msg()
                    send_large_msg(get_receiver(msg), adjust_goodbyewelcome(get_goodbye(msg.to.id), msg.to, msg.action.user), ok_cb, false)
                end
                postpone(post_msg, false, 1)
            end
            return
        end
        if is_momod(msg) then
            if matches[1]:lower() == 'getwelcome' then
                return get_welcome(msg.to.id)
            end
            if matches[1]:lower() == 'getgoodbye' then
                return get_goodbye(msg.to.id)
            end
            if matches[1]:lower() == 'previewwelcome' then
                return adjust_goodbyewelcome(get_welcome(msg.to.id), msg.to, preview_user)
            end
            if matches[1]:lower() == 'previewgoodbye' then
                return adjust_goodbyewelcome(get_goodbye(msg.to.id), msg.to, preview_user)
            end
            if matches[1]:lower() == 'setwelcome' then
                if string.match(matches[2], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                    return langs[msg.lang].autoexecDenial
                end
                return set_welcome(msg.to.id, matches[2])
            end
            if matches[1]:lower() == 'setgoodbye' then
                if string.match(matches[2], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                    return langs[msg.lang].autoexecDenial
                end
                return set_goodbye(msg.to.id, matches[2])
            end
            if matches[1]:lower() == 'unsetwelcome' then
                return unset_welcome(msg.to.id)
            end
            if matches[1]:lower() == 'unsetgoodbye' then
                return unset_goodbye(msg.to.id)
            end
            if matches[1]:lower() == 'setmemberswelcome' then
                local text = set_memberswelcome(msg.to.id, matches[2])
                if matches[2] == '0' then
                    return langs[msg.lang].neverWelcome
                else
                    return text
                end
            end
            if matches[1]:lower() == 'getmemberswelcome' then
                return get_memberswelcome(msg.to.id)
            end
        else
            return langs[msg.lang].require_mod
        end
    end
end

return {
    description = "GOODBYEWELCOME",
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Pp][Rr][Ee][Vv][Ii][Ee][Ww][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee])$",
        "^[#!/]([Pp][Rr][Ee][Vv][Ii][Ee][Ww][Gg][Oo][Oo][Dd][Bb][Yy][Ee])$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^!!tgservice (.+)$",
        -- MULTIPLE KICKS PATTERNS TO PREVENT LOTS OF MESSAGES TO BE SENT
        "^[#!/]([Kk][Ii][Cc][Kk][Nn][Oo][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee]) (%d+)$",
        "^[#!/]([Kk][Ii][Cc][Kk][Dd][Ee][Ll][Ee][Tt][Ee][Dd])$",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "MOD",
        "#getwelcome",
        "#getgoodbye",
        "#previewwelcome",
        "#previewgoodbye",
        "#setwelcome <text>",
        "#setgoodbye <text>",
        "#unsetwelcome",
        "#unsetgoodbye",
        "#setmemberswelcome <value>",
        "#getmemberswelcome",
    },
}