local function flame_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id, '%d+')
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    local hash
    local tokick
    if extra.chat_type == 'chat' then
        hash = 'chat:flame' .. extra.chat_id
        tokick = 'chat:tokick' .. extra.chat_id
    end
    if extra.chat_type == 'channel' then
        hash = 'channel:flame' .. extra.chat_id
        tokick = 'channel:tokick' .. extra.chat_id
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        redis:set(hash, 0);
        redis:set(tokick, result.peer_id);
        send_large_msg(extra.receiver, langs[lang].hereIAm)
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
    end
end

local function flame_by_reply(extra, success, result)
    local hash
    local tokick
    local lang = get_lang(result.to.peer_id)
    if get_reply_receiver(result) == extra.receiver then
        if result.to.peer_type == 'chat' then
            hash = 'chat:flame' .. result.to.peer_id
            tokick = 'chat:tokick' .. result.to.peer_id
        end
        if result.to.peer_type == 'channel' then
            hash = 'channel:flame' .. result.to.peer_id
            tokick = 'channel:tokick' .. result.to.peer_id
        end
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            redis:set(hash, 0);
            redis:set(tokick, result.from.peer_id);
            send_large_msg(extra.receiver, langs[lang].hereIAm)
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function flame_from(extra, success, result)
    local hash
    local tokick
    local lang = get_lang(result.to.peer_id)
    if get_reply_receiver(result) == extra.receiver then
        if result.to.peer_type == 'chat' then
            hash = 'chat:flame' .. result.to.peer_id
            tokick = 'chat:tokick' .. result.to.peer_id
        end
        if result.to.peer_type == 'channel' then
            hash = 'channel:flame' .. result.to.peer_id
            tokick = 'channel:tokick' .. result.to.peer_id
        end
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            redis:set(hash, 0);
            redis:set(tokick, result.fwd_from.peer_id);
            send_large_msg(extra.receiver, langs[lang].hereIAm)
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function callback_id(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local text = langs[lang].flaming
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
    send_large_msg(extra.receiver, text)
end

local function run(msg, matches)
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        if not msg.api_patch then
            if is_momod(msg) then
                if matches[1]:lower() == 'startflame' or matches[1]:lower() == 'sasha flamma' or matches[1]:lower() == 'flamma' then
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, flame_from, { receiver = get_receiver(msg), executer = msg.from.id })
                            else
                                get_message(msg.reply_id, flame_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, flame_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                        end
                    elseif matches[2] then
                        if string.match(matches[2], '^%d+$') then
                            local hash
                            local tokick
                            if msg.to.type == 'chat' then
                                hash = 'chat:flame' .. msg.to.id
                                tokick = 'chat:tokick' .. msg.to.id
                            end
                            if msg.to.type == 'channel' then
                                hash = 'channel:flame' .. msg.to.id
                                tokick = 'channel:tokick' .. msg.to.id
                            end
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                redis:set(hash, 0);
                                redis:set(tokick, matches[2]);
                                return langs[msg.lang].hereIAm
                            else
                                send_large_msg(get_receiver(msg), langs[msg.lang].require_rank)
                            end
                        elseif string.find(matches[2], '@') then
                            if string.gsub(matches[2], '@', ''):lower() == 'aisasha' then
                                return langs[msg.lang].noAutoFlame
                            end
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), flame_by_username, { executer = msg.from.id, chat_id = msg.to.id, chat_type = msg.to.type, receiver = get_receiver(msg) })
                        end
                    end
                elseif matches[1]:lower() == 'stopflame' or matches[1]:lower() == 'sasha stop flame' or matches[1]:lower() == 'stop flame' then
                    local hash
                    local tokick
                    if msg.to.type == 'chat' then
                        hash = 'chat:flame' .. msg.to.id
                        tokick = 'chat:tokick' .. msg.to.id
                    end
                    if msg.to.type == 'channel' then
                        hash = 'channel:flame' .. msg.to.id
                        tokick = 'channel:tokick' .. msg.to.id
                    end
                    -- ignore higher or same rank
                    if compare_ranks(msg.from.id, redis:get(tokick), msg.to.id) then
                        redis:del(hash)
                        redis:del(tokick)
                        return langs[msg.lang].stopFlame
                    else
                        send_large_msg(get_receiver(msg), langs[msg.lang].require_rank)
                    end
                elseif matches[1]:lower() == 'flameinfo' or matches[1]:lower() == 'sasha info flame' or matches[1]:lower() == 'info flame' then
                    local hash
                    local tokick
                    if msg.to.type == 'chat' then
                        hash = 'chat:flame' .. msg.to.id
                        tokick = 'chat:tokick' .. msg.to.id
                    end
                    if msg.to.type == 'channel' then
                        hash = 'channel:flame' .. msg.to.id
                        tokick = 'channel:tokick' .. msg.to.id
                    end
                    local hashonredis = redis:get(hash)
                    local user = redis:get(tokick)
                    if hashonredis and user then
                        user_info('user#id' .. user, callback_id, { receiver = get_receiver(msg) })
                    else
                        return langs[msg.lang].errorParameter
                    end
                end
            else
                return langs[msg.lang].require_mod
            end
        end
    else
        return langs[msg.lang].useYourGroups
    end
end

local function pre_process(msg)
    if msg then
        if not msg.api_patch then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                local hash
                local tokick
                if msg.to.type == 'chat' then
                    hash = 'chat:flame' .. msg.to.id
                    tokick = 'chat:tokick' .. msg.to.id
                end
                if msg.to.type == 'channel' then
                    hash = 'channel:flame' .. msg.to.id
                    tokick = 'channel:tokick' .. msg.to.id
                end
                if tostring(msg.from.id) == tostring(redis:get(tokick)) then
                    redis:incr(hash)
                    local hashonredis = redis:get(hash)
                    if hashonredis then
                        reply_msg(msg.id, langs.phrases.flame[tonumber(hashonredis)], ok_cb, false)
                        if tonumber(hashonredis) == #langs.phrases.flame then
                            local user_id = redis:get(tokick)
                            local function post_kick()
                                kick_user_any(user_id, msg.to.id)
                            end
                            postpone(post_kick, false, 3)
                            redis:del(hash)
                            redis:del(tokick)
                        end
                    end
                end
            end
        end
        return msg
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
    min_rank = 1,
    syntax =
    {
        "MOD",
        "(#startflame|[sasha] flamma) <id>|<username>|<reply>|from",
        "(#stopflame|[sasha] stop flame)",
        "(#flameinfo|[sasha] info flame)",
    },
}