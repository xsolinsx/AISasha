local function get_variables_hash(msg, global)
    if global then
        return 'gvariables'
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

local function unset_var(msg, name, global)
    if (not name) then
        return langs.errorTryAgain
    end

    local hash = get_variables_hash(msg, global)
    if hash then
        redis:hdel(hash, name)
        if global then
            return name .. langs.gDeleted
        else
            return name .. langs.deleted
        end
    end
end

local function run(msg, matches)
    local name = string.sub(matches[2], 1, 50)

    if is_momod(msg) then
        if matches[1]:lower() == 'unset' or matches[1]:lower() == 'sasha unsetta' or matches[1]:lower() == 'unsetta' then
            return unset_var(msg, name:lower(), false)
        end
        if is_admin1(msg) then
            if matches[1]:lower() == 'unsetglobal' then
                unset_var(msg, name:lower(), true)
            end
        else
            return langs.require_admin
        end
    else
        return langs.require_mod
    end
end

return {
    description = "UNSET",
    patterns =
    {
        "^[#!/]([Uu][Nn][Ss][Ee][Tt]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll]) ([^%s]+)$",
        -- unset
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Nn][Ss][Ee][Tt][Tt][Aa]) ([^%s]+)$",
        "^([Uu][Nn][Ss][Ee][Tt][Tt][Aa]) ([^%s]+)$",
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- (#unset|[sasha] unsetta) <var_name>
    -- ADMIN
    -- #unsetglobal <var_name>
}