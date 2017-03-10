local function get_variables_hash(msg, global)
    if global then
        return 'gvariables'
    else
        if msg.to.type == 'user' then
            return 'user:' .. msg.from.id .. ':variables'
        end
        if msg.to.type == 'chat' then
            return 'chat:' .. msg.to.id .. ':variables'
        end
        if msg.to.type == 'channel' then
            return 'channel:' .. msg.to.id .. ':variables'
        end
        return false
    end
end

local function set_value(msg, name, value, global)
    if (not name or not value) then
        return langs[msg.lang].errorTryAgain
    end

    local hash = get_variables_hash(msg, global)
    if hash then
        redis:hset(hash, name, value)
        if global then
            return name .. langs[msg.lang].gSaved
        else
            return name .. langs[msg.lang].saved
        end
    end
end

local function set_media(msg, name)
    if not name then
        return langs[msg.lang].errorTryAgain
    end

    local hash = get_variables_hash(msg)
    if hash then
        redis:hset(hash, 'waiting', name)
        return langs[msg.lang].sendMedia
    end
end

local function callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success and result then
        local file
        if extra.media == 'photo' then
            file = 'data/savedmedia/' .. extra.hash .. extra.name .. '.jpg'
        elseif extra.media == 'audio' then
            file = 'data/savedmedia/' .. extra.hash .. extra.name .. '.ogg'
        end
        file = file:gsub(':', '.')
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        redis:hset(extra.hash, extra.name, file)
        redis:hdel(extra.hash, 'waiting')
        print(file)
        send_large_msg(extra.receiver, langs[lang].mediaSaved)
    else
        send_large_msg(extra.receiver, langs[lang].errorDownloading .. extra.hash .. ' - ' .. extra.name .. ' - ' .. extra.receiver)
    end
end

local function run(msg, matches)
    if not msg.api_patch then
        local hash = get_variables_hash(msg, false)
        if msg.media then
            if hash then
                local name = redis:hget(hash, 'waiting')
                if name then
                    if is_momod(msg) then
                        if msg.media.type == 'photo' then
                            return load_photo(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                        elseif msg.media.type == 'audio' then
                            return load_document(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                        end
                    else
                        return langs[msg.lang].require_mod
                    end
                end
                return
            else
                return langs[msg.lang].nothingToSet
            end
        end

        if matches[1]:lower() == 'importgroupsets' and matches[2] then
            if is_owner(msg) then
                local tab = matches[2]:split('\nXXXxxxXXX\n')
                local i = 0
                for k, command in pairs(tab) do
                    local name, value = string.match(command, '/set ([^%s]+) (.+)')
                    name = string.sub(name:lower(), 1, 50)
                    value = string.sub(value, 1, 4096)
                    set_value(msg, name, value, false)
                    i = i + 1
                end
                return i .. langs[msg.lang].setsRestored
            else
                return langs[msg.lang].require_owner
            end
        end

        if matches[1]:lower() == 'importglobalsets' and matches[2] then
            if is_admin1(msg) then
                local tab = matches[2]:split('\nXXXxxxXXX\n')
                local i = 0
                vardump(tab)
                for k, command in pairs(tab) do
                    local name, value = string.match(command, '/setglobal ([^%s]+) (.+)')
                    name = string.sub(name:lower(), 1, 50)
                    value = string.sub(value, 1, 4096)
                    set_value(msg, name, value, true)
                    i = i + 1
                end
                return i .. langs[msg.lang].globalSetsRestored
            else
                return langs[msg.lang].require_admin
            end
        end

        if matches[1]:lower() == 'cancel' or matches[1]:lower() == 'sasha annulla' or matches[1]:lower() == 'annulla' then
            if is_momod(msg) then
                redis:hdel(hash, 'waiting')
                return langs[msg.lang].cancelled
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'setmedia' or matches[1]:lower() == 'sasha setta media' or matches[1]:lower() == 'setta media' then
            if is_momod(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                return set_media(msg, name)
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'set' or matches[1]:lower() == 'sasha setta' or matches[1]:lower() == 'setta' then
            if string.match(matches[3], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autoexecDenial
            end
            if is_momod(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                local value = string.sub(matches[3], 1, 4096)
                return set_value(msg, name, value, false)
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'setglobal' then
            if string.match(matches[3], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autoexecDenial
            end
            if is_admin1(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                local value = string.sub(matches[3], 1, 4096)
                return set_value(msg, name, value, true)
            else
                return langs[msg.lang].require_admin
            end
        end
    end
end

return {
    description = "SET",
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt]) ([^%s]+) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll]) ([^%s]+) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        "^[#!/]([Cc][Aa][Nn][Cc][Ee][Ll])$",
        "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ss][Ee][Tt][Ss]) (.+)$",
        "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Rr][Oo][Uu][Pp][Ss][Ee][Tt][Ss]) (.+)$",
        "%[(photo)%]",
        "%[(audio)%]",
        -- set
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Tt][Tt][Aa]) ([^%s]+) (.+)$",
        "^([Ss][Ee][Tt][Tt][Aa]) ([^%s]+) (.+)$",
        -- setmedia
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Tt][Tt][Aa] [Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        "^([Ss][Ee][Tt][Tt][Aa] [Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        -- cancel
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Nn][Nn][Uu][Ll][Ll][Aa])$",
        "^([Aa][Nn][Nn][Uu][Ll][Ll][Aa])$",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "MOD",
        "(#set|[sasha] setta) <var_name>|<pattern> <text>",
        "(#setmedia|[sasha] setta media) <var_name>|<pattern>",
        "(#cancel|[sasha] annulla)",
        "ADMIN",
        "#setglobal <var_name>|<pattern> <text>",
    },
}