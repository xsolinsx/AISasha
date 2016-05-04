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
    return false
end

local function set_value(msg, name, value)
    if (not name or not value) then
        return lang_text('errorTryAgain')
    end

    local hash = get_variables_hash(msg)
    if hash then
        redis:hset(hash, name, value)
        return name .. lang_text('saved')
    end
end

local function set_media(msg, name)
    if not name then
        return lang_text('errorTryAgain')
    end

    local hash = get_variables_hash(msg)
    if hash then
        redis:hset(hash, 'waiting', name)
        return lang_text('sendMedia')
    end
end

local function callback(extra, success, result)
    if success then
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
        print(file)
    else
        send_large_msg(extra.receiver, lang_text('errorDownloading') .. extra.hash .. ' - ' .. extra.name .. ' - ' .. extra.receiver)
    end
end

local function run(msg, matches)
    local hash = get_variables_hash(msg)
    if msg.media then
        if hash then
            local name = redis:hget(hash, 'waiting')
            if (msg.media.type == 'photo' or msg.media.type == 'audio') and name and is_momod(msg) then
                if msg.media.type == 'photo' then
                    load_photo(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                    return lang_text('mediaSaved')
                elseif msg.media.type == 'audio' then
                    load_document(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                    return lang_text('mediaSaved')
                end
            end
            return
        else
            return lang_text('nothingToSet')
        end
    end
    if matches[1]:lower() == 'cancel' or matches[1]:lower() == 'sasha annulla' or matches[1]:lower() == 'annulla' then
        if is_momod(msg) then
            redis:hdel(hash, 'waiting')
            return lang_text('cancelled')
        else
            return lang_text('require_mod')
        end
    elseif matches[1]:lower() == 'setmedia' or matches[1]:lower() == 'sasha setta media' or matches[1]:lower() == 'setta media' then
        if is_momod(msg) then
            local name = string.sub(matches[2]:lower(), 1, 50)
            return set_media(msg, name)
        else
            return lang_text('require_mod')
        end
    elseif matches[1]:lower() == 'set' or matches[1]:lower() == 'sasha setta' or matches[1]:lower() == 'setta' then
        if is_momod(msg) then
            local name = string.sub(matches[2]:lower(), 1, 50)
            local value = string.sub(matches[3], 1, 4096)
            return set_value(msg, name, value)
        else
            return lang_text('require_mod')
        end
    end
end

local function pre_process(msg)
    if not msg.text and msg.media then
        msg.text = '[' .. msg.media.type .. ']'
    end
    return msg
end

return {
    description = "SET",
    usage =
    {
        "MOD",
        "(#set|[sasha] setta) <var_name> <text>: Sasha salva <text> come risposta a <var_name>.",
        "(#setmedia|[sasha] setta media) <var_name>: Sasha salva il media (foto o audio) che le verrà inviato come risposta a <var_name>.",
        "(#cancel|[sasha] annulla): Sasha annulla un #setmedia.",
    },
    patterns =
    {
        "^[#!/]([Ss][Ee][Tt]) ([^%s]+) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        "^[#!/]([Cc][Aa][Nn][Cc][Ee][Ll])$",
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
    min_rank = 1
}