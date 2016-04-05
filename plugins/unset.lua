local function unset_var(msg, name)
    if (not name) then
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
        redis:hdel(hash, name)
        return name .. lang_text('deleted')
    end
end

local function run(msg, matches)
    local name = string.sub(matches[1], 1, 50)

    if is_momod(msg) then
        return unset_var(msg, name:lower())
    else
        return lang_text('require_mod')
    end
end

return {
    description = "UNSET",
    usage = "(/unset|[sasha] unsetta) <var_name>: Sasha elimina <var_name>.",
    patterns =
    {
        "^[#!/][Uu][Nn][Ss][Ee][Tt] ([^%s]+)$",
        -- unset
        "^[Ss][Aa][Ss][Hh][Aa] [Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)$",
        "^[Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)$",
    },
    run = run,
    min_rank = 1
}