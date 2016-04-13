local function set_value(msg, name, value)
    if (not name or not value) then
        return lang_text('errorTryAgain')
    end

    local hash = nil
    if msg.to.type == 'channel' then
        hash = 'channel:' .. msg.to.id .. ':variables'
    end
    if msg.to.type == 'chat' then
        hash = 'chat:' .. msg.to.id .. ':variables'
    end
    if msg.to.type == 'user' then
        hash = 'user:' .. msg.from.id .. ':variables'
    end
    if hash then
        redis:hset(hash, name, value)
        return name .. lang_text('saved')
    end
end

local function run(msg, matches)
    local name = string.sub(matches[1]:lower(), 1, 50)
    local value = string.sub(matches[2], 1, 1000)

    if is_momod(msg) then
        return set_value(msg, name, value)
    else
        return lang_text('require_mod')
    end
end

return {
    description = "SET",
    usage =
    {
        "MOD",
        "(#set|[sasha] setta) <var_name> <text>: Sasha salva <text> come risposta a <var_name>.",
    },
    patterns =
    {
        "^[#!/][Ss][Ee][Tt] ([^%s]+) (.+)$",
        -- set
        "^[Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Tt][Tt][Aa] ([^%s]+) (.+)$",
        "^[Ss][Ee][Tt][Tt][Aa] ([^%s]+) (.+)$",
    },
    run = run,
    min_rank = 1
}