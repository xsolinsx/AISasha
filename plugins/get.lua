local function get_variables_hash(msg)
    if msg.to.type == 'channel' then
        return 'channel:' .. msg.to.id .. ':variables'
    end
    if msg.to.type == 'chat' then
        return 'chat:' .. msg.to.id .. ':variables'
    end
    if msg.to.type == 'user' then
        return 'user:' .. msg.from.id .. ':variables'
    end
end

local function get_value(msg, var_name)
    local hash = get_variables_hash(msg)
    if hash then
        local value = redis:hget(hash, var_name)
        if value then
            return value
        else
            return
        end
    end
end

local function list_variables(msg)
    local hash = get_variables_hash(msg)

    if hash then
        local names = redis:hkeys(hash)
        local text = ''
        for i = 1, #names do
            text = text .. names[i] .. '\n'
        end
        return text
    end
end

local function run(msg, matches)
    if (matches[1]:lower() == 'get' or matches[1]:lower() == 'getlist' or matches[1]:lower() == 'sasha lista') and not matches[2] then
        return list_variables(msg)
    else
        local vars = list_variables(msg)
        if vars ~= nil then
            local t = vars:split('\n')
            for i, word in pairs(t) do
                local temp = word:lower():gsub("_", " ")
                if word:lower() ~= 'get' and string.find(msg.text:lower(), temp) then
                    local value = get_value(msg, word:lower())
                    if io.popen('find ' .. value):read("*all") == '' then
                        send_large_msg(get_receiver(msg), get_value(msg, word:lower()))
                    else
                        send_photo(get_receiver(msg), value, ok_cb, false)
                    end
                end
            end
        end
        --[[
        for i, word in pairs(matches) do
            if word ~= 'get' then
                return get_value(msg, string.lower(word))
            end
        end]]
    end
end

return {
    description = "GET",
    usage =
    {
        "(#getlist|#get|sasha lista): Sasha mostra una lista delle variabili settate.",
        "[#get] <var_name>: Sasha manda il valore di <var_name>.",
    },
    patterns =
    {
        "^[#!/]([Gg][Ee][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Gg][Ee][Tt]) ([^%s]+)$",
        -- getlist
        "^[#!/]([Gg][Ee][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa])$",
        -- get
        "^([^%s]+) (.+)$",
        "^([^%s]+)$",
    },
    run = run,
    min_rank = 0
}