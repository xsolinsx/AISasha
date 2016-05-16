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
    var_name = var_name:gsub(' ', '_')
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
            text = text .. names[i]:gsub('_', ' ') .. '\n'
        end
        return text
    end
end

local function run(msg, matches)
    local vars = list_variables(msg)

    if (matches[1]:lower() == 'get' or matches[1]:lower() == 'getlist' or matches[1]:lower() == 'sasha lista') and not matches[2] then
        return vars
    end

    if vars ~= nil then
        local t = vars:split('\n')
        for i, word in pairs(t) do
            local temp = word:lower()
            if word:lower() ~= 'get' and string.find(msg.text:lower(), temp) then
                local value = get_value(msg, word:lower())
                if value then
                    if not string.match(value, "^(.*)user%.(%d+)%.variables(.*)$") and not string.match(value, "^(.*)chat%.(%d+)%.variables(.*)$") and not string.match(value, "^(.*)channel%.(%d+)%.variables(.*)$") then
                        -- if not media
                        send_large_msg(get_receiver(msg), get_value(msg, word:lower()))
                    elseif string.match(value, "^(.*)user%.(%d+)%.variables(.*)%.jpg$") or string.match(value, "^(.*)chat%.(%d+)%.variables(.*)%.jpg$") or string.match(value, "^(.*)channel%.(%d+)%.variables(.*)%.jpg$") then
                        -- if picture
                        if io.popen('find ' .. value):read("*all") ~= '' then
                            send_photo(get_receiver(msg), value, ok_cb, false)
                        end
                    elseif string.match(value, "^(.*)user%.(%d+)%.variables(.*)%.ogg$") or string.match(value, "^(.*)chat%.(%d+)%.variables(.*)%.ogg$") or string.match(value, "^(.*)channel%.(%d+)%.variables(.*)%.ogg$") then
                        -- if audio
                        if io.popen('find ' .. value):read("*all") ~= '' then
                            send_audio(get_receiver(msg), value, ok_cb, false)
                        end
                    end
                end
            end
        end
    end
end

return {
    description = "GET",
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
    -- usage
    -- (#getlist|#get|sasha lista)
    -- [#get] <var_name>
}