local counter = 0

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

local function set_memberswelcome(msg, value)
    local data = load_data(_config.moderation.data)
    local data_cat = 'welcomemembers'
    data[tostring(msg.to.id)][data_cat] = value
    save_data(_config.moderation.data, data)
    return string.gsub(lang_text('newWelcomeNumber'), 'X', tostring(value)) .. value
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
        return get_welcome(msg)
    end
    if matches[1]:lower() == 'setwelcome' and is_owner(msg) then
        return set_welcome(msg, matches[2])
    end
    if matches[1]:lower() == 'setmemberswelcome' and is_owner(msg) then
        return set_memberswelcome(msg, matches[2])
    end
    if matches[1]:lower() == 'getmemberswelcome' and is_owner(msg) then
        return get_memberswelcome(msg)
    end
    if msg.action.type == "chat_add_user" or msg.action.type == "chat_add_user_link" and is_owner(msg) then
        local hash
        if msg.to.type == 'channel' then
            hash = 'channel:welcome' .. msg.to.id
        end
        if msg.to.type == 'chat' then
            hash = 'chat:welcome' .. msg.to.id
        end
        redis:incr(hash)
        local hashonredis = redis:get(hash)
        -- Check if user has spammed is group more than 4 times
        if hashonredis then
            if tonumber(hashonredis) == tonumber(get_memberswelcome(msg)) then
                send_large_msg(receiver, get_welcome(msg) .. '\n' .. get_rules(msg), ok_cb, false)
                redis:getset(hash, 0)
            end
        else
            redis:set(hash, 0)
        end
    end
end

return {
    description = "WELCOME",
    usage =
    {
        "/setwelcome <text>: Sasha imposta <text> come benvenuto.",
        "/getwelcome: Sasha manda il benvenuto.",
        "/setmemberswelcome <value>: Sasha dopo <value> membri manderà il benvenuto con le regole.",
        "/getmemberswelcome: Sasha manda il numero di membri entrati dopo i quali invia il benvenuto.",
    },
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ww][Ee][Ll][Cc][Oo][Mm][Ee])$",
        "^!!tgservice (.+)$",
    },
    run = run
}