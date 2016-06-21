local function set_welcome(msg, welcome)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcome'
    data[tostring(msg.to.id)][data_cat] = welcome
    save_data(_config.moderation.data, data)
    return lang_text('newWelcome') .. welcome
end

local function get_welcome(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcome'
    if not data[tostring(msg.to.id)][data_cat] then
        return ''
    end
    local welcome = data[tostring(msg.to.id)][data_cat]
    return welcome
end

local function unset_welcome(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcome'
    data[tostring(msg.to.id)][data_cat] = ''
    save_data(_config.moderation.data, data)
    return lang_text('welcomeRemoved')
end

local function set_memberswelcome(msg, value)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcomemembers'
    data[tostring(msg.to.id)][data_cat] = value
    save_data(_config.moderation.data, data)
    return string.gsub(lang_text('newWelcomeNumber'), 'X', tostring(value))
end

local function get_memberswelcome(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcomemembers'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noSetValue')
    end
    local value = data[tostring(msg.to.id)][data_cat]
    return value
end

local function set_goodbye(msg, goodbye)
    local data = load_data(_config.moderation.data)
    local data_cat = 'goodbye'
    data[tostring(msg.to.id)][data_cat] = goodbye
    save_data(_config.moderation.data, data)
    return lang_text('newGoodbye') .. goodbye
end

local function get_goodbye(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'goodbye'
    if not data[tostring(msg.to.id)][data_cat] then
        return ''
    end
    local goodbye = data[tostring(msg.to.id)][data_cat]
    return goodbye
end

local function unset_goodbye(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'goodbye'
    data[tostring(msg.to.id)][data_cat] = ''
    save_data(_config.moderation.data, data)
    return lang_text('goodbyeRemoved')
end

local function get_rules(msg)
    local data = load_data(_config.moderation.data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noRules')
    end
    local rules = data[tostring(msg.to.id)][data_cat]
    return rules
end

local function run(msg, matches)
    if matches[1]:lower() == 'getwelcome' then
        if tonumber(msg.to.id) == 1026492373 then
            if is_momod(msg) then
                -- moderatore del canile abusivo usa getwelcome allora ok altrimenti return
                return get_welcome(msg)
            else
                return
            end
        else
            return get_welcome(msg)
        end
    end
    if matches[1]:lower() == 'getgoodbye' then
        if tonumber(msg.to.id) == 1026492373 then
            if is_momod(msg) then
                -- moderatore del canile abusivo usa getgoodbye allora ok altrimenti return
                return get_goodbye(msg)
            else
                return
            end
        else
            return get_goodbye(msg)
        end
    end
    if matches[1]:lower() == 'setwelcome' and is_momod(msg) then
        return set_welcome(msg, matches[2])
    end
    if matches[1]:lower() == 'setgoodbye' and is_momod(msg) then
        return set_goodbye(msg, matches[2])
    end
    if matches[1]:lower() == 'unsetwelcome' and is_momod(msg) then
        return unset_welcome(msg)
    end
    if matches[1]:lower() == 'unsetgoodbye' and is_momod(msg) then
        return unset_goodbye(msg)
    end
    if matches[1]:lower() == 'setmemberswelcome' and is_momod(msg) then
        local msg = set_memberswelcome(msg, matches[2])
        if matches[2] == '0' then
            return lang_text('neverWelcome')
        else
            return msg
        end
    end
    if matches[1]:lower() == 'getmemberswelcome' and is_momod(msg) then
        return get_memberswelcome(msg)
    end
    if (msg.action.type == "chat_add_user" or msg.action.type == "chat_add_user_link") and get_memberswelcome(msg) ~= lang_text('noSetValue') then
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
            if tonumber(hashonredis) >= tonumber(get_memberswelcome(msg)) and tonumber(get_memberswelcome(msg)) ~= 0 then
                local function post_msg()
                    send_large_msg(get_receiver(msg), get_welcome(msg) .. '\n' .. get_rules(msg), ok_cb, false)
                end
                postpone(post_msg, false, 1)
                redis:getset(hash, 0)
            end
        else
            redis:set(hash, 0)
        end
    end
    if msg.action.type == "chat_del_user" and get_goodbye(msg) ~= '' then
        local function post_msg()
            send_large_msg(get_receiver(msg), get_goodbye(msg) .. ' ' .. msg.action.user.print_name:gsub('_', ' '), ok_cb, false)
        end
        postpone(post_msg, false, 1)
    end
end

return {
    description = "GOODBYEWELCOME",
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee])$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Gg][Oo][Oo][Dd][Bb][Yy][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^!!tgservice (.+)$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- #getwelcome: Sasha manda il benvenuto.
    -- #getgoodbye: Sasha manda l'addio.
    -- MOD
    -- #setwelcome <text>: Sasha imposta <text> come benvenuto.
    -- #setgoodbye <text>: Sasha imposta <text> come addio.
    -- #unsetwelcome: Sasha elimina il benvenuto
    -- #unsetgoodbye: Sasha elimina l'addio
    -- #setmemberswelcome <value>: Sasha dopo <value> membri manderà il benvenuto con le regole, se zero il benvenuto non verrà più mandato.
    -- #getmemberswelcome: Sasha manda il numero di membri entrati dopo i quali invia il benvenuto.
}