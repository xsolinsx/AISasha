local function get_variables_hash(msg, global)
    if global then
        if not redis:get(msg.to.id .. ':gvariables') then
            return 'gvariables'
        end
        return false
    else
        if msg.to.type == 'channel' then
            return 'channel:' .. msg.to.id .. ':variables'
        end
        if msg.to.type == 'chat' then
            return 'chat:' .. msg.to.id .. ':variables'
        end
        if msg.to.type == 'user' then
            return 'user:' .. msg.from.id .. ':variables'
        end
        return false
    end
end

local function get_value(msg, var_name)
    var_name = var_name:gsub(' ', '_')
    if not redis:get(msg.to.id .. ':gvariables') then
        local hash = get_variables_hash(msg, true)
        if hash then
            local value = redis:hget(hash, var_name)
            if value then
                return value
            end
        end
    end

    local hash = get_variables_hash(msg, false)
    if hash then
        local value = redis:hget(hash, var_name)
        if value then
            return value
        end
    end
end

local function list_variables(msg, global)
    local hash = nil
    if global then
        hash = get_variables_hash(msg, true)
    else
        hash = get_variables_hash(msg, false)
    end

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
    if (matches[1]:lower() == 'get' or matches[1]:lower() == 'getlist' or matches[1]:lower() == 'sasha lista') then
        return list_variables(msg, false)
    end
    if (matches[1]:lower() == 'getglobal' or matches[1]:lower() == 'getgloballist' or matches[1]:lower() == 'sasha lista globali') then
        return list_variables(msg, true)
    end
    if matches[1]:lower() == 'enableglobal' then
        redis:del(msg.to.id .. ':gvariables')
    end
    if matches[1]:lower() == 'disableglobal' then
        redis:set(msg.to.id .. ':gvariables', true)
    end
end

local function pre_process(msg, matches)
    if msg.text then
        if not string.match(msg.text, "^[#!/][Uu][Nn][Ss][Ee][Tt] ([^%s]+)") and not string.match(msg.text, "^[Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)") and not string.match(msg.text, "^[Ss][Aa][Ss][Hh][Aa] [Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)") and not string.match(msg.text, "^[Uu][Nn][Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll] ([^%s]+)") then
            local vars = list_variables(msg, true)

            if vars ~= nil then
                local t = vars:split('\n')
                for i, word in pairs(t) do
                    local temp = word:lower()
                    if word:lower() ~= 'get' and string.find(msg.text:lower(), temp) then
                        local value = get_value(msg, word:lower())
                        if value then
                            reply_msg(msg.id, get_value(msg, word:lower()), ok_cb, false)
                        end
                    end
                end
            end

            local vars = list_variables(msg, false)

            if vars ~= nil then
                local t = vars:split('\n')
                for i, word in pairs(t) do
                    local temp = word:lower()
                    if word:lower() ~= 'get' and string.find(msg.text:lower(), temp) then
                        local value = get_value(msg, word:lower())
                        if value then
                            if not string.match(value, "^(.*)user%.(%d+)%.variables(.*)$") and not string.match(value, "^(.*)chat%.(%d+)%.variables(.*)$") and not string.match(value, "^(.*)channel%.(%d+)%.variables(.*)$") then
                                -- if not media
                                reply_msg(msg.id, get_value(msg, word:lower()), ok_cb, false)
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
    end
    return msg
end

return {
    description = "GET",
    patterns =
    {
        "^[#!/]([Gg][Ee][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Gg][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee][Gg][Ll][Oo][Bb][Aa][Ll])$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee][Gg][Ll][Oo][Bb][Aa][Ll])$",
        -- getlist
        "^[#!/]([Gg][Ee][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa])$",
        -- getgloballist
        "^[#!/]([Gg][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Gg][Ll][Oo][Bb][Aa][Ll][Ii])$",
    },
    pre_process = pre_process,
    run = run,
    min_rank = 0
    -- usage
    -- (#getlist|#get|sasha lista)
    -- (#getgloballist|#getglobal|sasha lista globali)
    -- OWNER
    -- #enableglobal
    -- #disableglobal
}