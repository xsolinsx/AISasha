local sashaflamma = {
    "Davvero ritardato del cazzo stai zitto.",
    "Mi sembri peggio dei cristiani porcoddio.",
    "Dei calci in bocca meriti altrochè.",
    "Scusa eh ma quanto ti senti frocio da 1 a 10? no perchè a me il 10 sembra fisso.",
    "Sei sicuro di non avere qualche cromosoma in più?",
    "Dio se sei messo male amico.",
    "Per favore calate il banhammer sulla sua testa.",
    "Parla parla scemo del cazzo.",
    "SEI SICURO DI VOLERTI METTERE CONTRO UNA BOTTESSA?",
    "Vai a farti una vita reale sennò giuro che ti squarto.",
    "Dimmi un po', per caso hai i genitori parenti?",
    "CON CHE CORAGGIO PARLI ANCORA BRUTTA FOGNA?",
    "Ok adesso mi prenderò un attimo di tempo per te, dimmi, cosa ti turba?",
    "Finito il tempo, ops.",
}

local function flame_by_reply(extra, success, result)
    local hash
    local tokick
    if result.to.peer_type == 'channel' then
        hash = 'channel:flame' .. result.to.peer_id
        tokick = 'channel:tokick' .. result.to.peer_id
    end
    if result.to.peer_type == 'chat' then
        hash = 'chat:flame' .. result.to.peer_id
        tokick = 'chat:tokick' .. result.to.peer_id
    end
    redis:set(hash, 0);
    redis:set(tokick, result.from.peer_id);
end

local function flame_by_username(extra, success, result)
    local hash
    local tokick
    if extra.msg.to.type == 'channel' then
        hash = 'channel:flame' .. extra.msg.to.id
        tokick = 'channel:tokick' .. extra.msg.to.id
    end
    if extra.msg.to.type == 'chat' then
        hash = 'chat:flame' .. extra.msg.to.id
        tokick = 'chat:tokick' .. extra.msg.to.id
    end
    redis:set(hash, 0);
    redis:set(tokick, result.peer_id);
end

local function callback_id(cb_extra, success, result)
    local text = lang_text('flaming')
    if result.first_name then
        text = text .. '\n' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\n' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\n' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\n' .. result.real_last_name
    end
    if result.username then
        text = text .. '\n@' .. result.username
    end
    text = text .. '\n' .. result.peer_id
    send_large_msg('chat#id' .. cb_extra.msg.to.id, text)
    send_large_msg('channel#id' .. cb_extra.msg.to.id, text)
end

local function pre_process(msg)
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        local hash
        local tokick
        if msg.to.type == 'channel' then
            hash = 'channel:flame' .. msg.to.id
            tokick = 'channel:tokick' .. msg.to.id
        end
        if msg.to.type == 'chat' then
            hash = 'chat:flame' .. msg.to.id
            tokick = 'chat:tokick' .. msg.to.id
        end
        if tostring(msg.from.id) == tostring(redis:get(tokick)) then
            redis:incr(hash)
            local hashonredis = redis:get(hash)
            if hashonredis then
                reply_msg(msg.id, sashaflamma[tonumber(hashonredis)], ok_cb, false)
                if tonumber(hashonredis) == #sashaflamma then
                    kick_user_any(redis:get(tokick), msg.to.id)
                    redis:del(hash)
                    redis:del(tokick)
                end
            end
        end
    end
    return msg
end

local function run(msg, matches)
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        if is_momod(msg) then
            if matches[1]:lower() == 'startflame' or matches[1]:lower() == 'sasha flamma' or matches[1]:lower() == 'flamma' then
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, flame_by_reply, false)
                    return lang_text('hereIAm')
                elseif matches[2] then
                    if string.match(matches[2], '^%d+$') then
                        if tonumber(matches[2]) == tonumber(our_id) then
                            return lang_text('noAutoFlame')
                        end
                        local hash
                        local tokick
                        if msg.to.type == 'channel' then
                            hash = 'channel:flame' .. msg.to.id
                            tokick = 'channel:tokick' .. msg.to.id
                        end
                        if msg.to.type == 'chat' then
                            hash = 'chat:flame' .. msg.to.id
                            tokick = 'chat:tokick' .. msg.to.id
                        end
                        redis:set(hash, 0);
                        redis:set(tokick, matches[2]);
                        return lang_text('hereIAm')
                    elseif string.find(matches[2], '@') then
                        if string.gsub(matches[2], '@', ''):lower() == 'aisasha' then
                            return lang_text('noAutoFlame')
                        end
                        resolve_username(string.gsub(matches[2], '@', ''), flame_by_username, { msg = msg, })
                        return lang_text('hereIAm')
                    end
                end
            elseif matches[1]:lower() == 'stopflame' or matches[1]:lower() == 'sasha stop flame' or matches[1]:lower() == 'stop flame' then
                local hash
                local tokick
                if msg.to.type == 'channel' then
                    hash = 'channel:flame' .. msg.to.id
                    tokick = 'channel:tokick' .. msg.to.id
                end
                if msg.to.type == 'chat' then
                    hash = 'chat:flame' .. msg.to.id
                    tokick = 'chat:tokick' .. msg.to.id
                end
                redis:del(hash)
                redis:del(tokick)
                return lang_text('stopFlame')
            elseif matches[1]:lower() == 'flameinfo' or matches[1]:lower() == 'sasha info flame' or matches[1]:lower() == 'info flame' then
                local hash
                local tokick
                if msg.to.type == 'channel' then
                    hash = 'channel:flame' .. msg.to.id
                    tokick = 'channel:tokick' .. msg.to.id
                end
                if msg.to.type == 'chat' then
                    hash = 'chat:flame' .. msg.to.id
                    tokick = 'chat:tokick' .. msg.to.id
                end
                local hashonredis = redis:get(hash)
                local user = redis:get(tokick)
                if hashonredis and user then
                    user_info('user#id' .. user, callback_id, { msg = msg })
                else
                    return lang_text('errorParameter')
                end
            end
        else
            lang_text('require_mod')
        end
    else
        return lang_text('useYourGroups')
    end
end

return {
    description = "FLAME",
    patterns =
    {
        "^[#!/]([Ss][Tt][Aa][Rr][Tt][Ff][Ll][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Ss][Tt][Aa][Rr][Tt][Ff][Ll][Aa][Mm][Ee])$",
        "^[#!/]([Ss][Tt][Oo][Pp][Ff][Ll][Aa][Mm][Ee])$",
        "^[#!/]([Ff][Ll][Aa][Mm][Ee][Ii][Nn][Ff][Oo])$",
        -- startflame
        "^([Ss][Aa][Ss][Hh][Aa] [Ff][Ll][Aa][Mm][Mm][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ff][Ll][Aa][Mm][Mm][Aa])$",
        "^([Ff][Ll][Aa][Mm][Mm][Aa]) (.*)$",
        "^([Ff][Ll][Aa][Mm][Mm][Aa])$",
        -- stopflame
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Tt][Oo][Pp] [Ff][Ll][Aa][Mm][Ee])$",
        "^([Ss][Tt][Oo][Pp] [Ff][Ll][Aa][Mm][Ee])$",
        -- flameinfo
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Ff][Oo] [Ff][Ll][Aa][Mm][Ee])$",
        "^([Ii][Nn][Ff][Oo] [Ff][Ll][Aa][Mm][Ee])$",
    },
    pre_process = pre_process,
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- (#startflame|[sasha] flamma) <id>|<username>|<reply>
    -- (#stopflame|[sasha] stop flame)
    -- (#flameinfo|[sasha] info flame)
}