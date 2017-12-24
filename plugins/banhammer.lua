local function muteuser_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local user_id = -1
        if result.service then
            if result.action.type == 'chat_add_user' or result.action.type == 'chat_del_user' or result.action.type == 'chat_rename' or result.action.type == 'chat_change_photo' then
                if result.action.user then
                    user_id = result.action.user.peer_id
                end
            end
        else
            user_id = result.from.peer_id
        end
        if user_id ~= -1 then
            if compare_ranks(extra.executer, result.from.peer_id, string.match(extra.receiver, '%d+')) then
                if is_muted_user(string.match(extra.receiver, '%d+'), user_id) then
                    mute_user(string.match(extra.receiver, '%d+'), user_id)
                    send_large_msg(extra.receiver, user_id .. langs[lang].muteUserRemove)
                else
                    unmute_user(string.match(extra.receiver, '%d+'), user_id)
                    send_large_msg(extra.receiver, user_id .. langs[lang].muteUserAdd)
                end
            else
                send_large_msg(extra.receiver, langs[lang].require_rank)
            end
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function muteuser_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
                unmute_user(result.to.peer_id, result.fwd_from.peer_id)
                send_large_msg(extra.receiver, result.fwd_from.peer_id .. langs[lang].muteUserRemove)
            else
                mute_user(result.to.peer_id, result.fwd_from.peer_id)
                send_large_msg(extra.receiver, result.fwd_from.peer_id .. langs[lang].muteUserAdd)
            end
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function muteuser_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, string.match(extra.receiver, '%d+')) then
        if is_muted_user(string.match(extra.receiver, '%d+'), result.peer_id) then
            unmute_user(string.match(extra.receiver, '%d+'), result.peer_id)
            send_large_msg(extra.receiver, result.peer_id .. langs[lang].muteUserRemove)
        else
            mute_user(string.match(extra.receiver, '%d+'), result.peer_id)
            send_large_msg(extra.receiver, result.peer_id .. langs[lang].muteUserAdd)
        end
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
    end
end

local function warn_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        warn_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] warned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] warned user " .. result.peer_id .. " N")
    end
end

local function warn_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            warn_user(result.from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function warn_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            warn_user(result.fwd_from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.fwd_from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] warned user " .. result.fwd_from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unwarn_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unwarn_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarned user " .. result.peer_id .. " N")
    end
end

local function unwarn_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            unwarn_user(result.from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unwarn_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            unwarn_user(result.fwd_from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.fwd_from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarned user " .. result.fwd_from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unwarnall_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unwarnall_user(result.peer_id, extra.chat_id)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarnedall user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unwarnedall user " .. result.peer_id .. " N")
    end
end

local function unwarnall_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            unwarnall_user(result.from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unwarnall_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            unwarnall_user(result.fwd_from.peer_id, result.to.peer_id)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.fwd_from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unwarnedall user " .. result.fwd_from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function getWarn_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    send_large_msg('chat#id' .. extra.chat_id, get_user_warns(result.peer_id, extra.chat_id))
    send_large_msg('channel#id' .. extra.chat_id, get_user_warns(result.peer_id, extra.chat_id))
    savelog(extra.chat_id, "[" .. extra.executer .. "] get warns of " .. result.peer_id .. " Y")
end

local function getWarn_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        send_large_msg(extra.receiver, get_user_warns(result.from.peer_id, result.to.peer_id))
        savelog(result.to.peer_id, "[" .. extra.executer .. "] get warns of " .. result.from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function getWarn_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        send_large_msg(extra.receiver, get_user_warns(result.fwd_from.peer_id, result.to.peer_id))
        savelog(result.to.peer_id, "[" .. extra.executer .. "] get warns of " .. result.fwd_from.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function kick_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local function post_kick()
            kick_user_any(result.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(extra.chat_id, "[" .. extra.executer .. "] kicked user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] kicked user " .. result.peer_id .. " N")
    end
end

local function kick_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            local function post_kick()
                kick_user_any(result.from.peer_id, result.to.peer_id)
            end
            postpone(post_kick, false, 3)
            send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
            savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function kick_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            local function post_kick()
                kick_user(result.fwd_from.peer_id, result.to.peer_id)
            end
            postpone(post_kick, false, 3)
            send_large_msg(extra.receiver, langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
            savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.fwd_from.peer_id .. " from Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] kicked user " .. result.fwd_from.peer_id .. " from N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function ban_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local function post_kick()
            ban_user(result.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 3)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
        savelog(extra.chat_id, "[" .. extra.executer .. "] banned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] banned user " .. result.peer_id .. " N")
    end
end

local function ban_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            local function post_kick()
                ban_user(result.from.peer_id, result.to.peer_id)
            end
            postpone(post_kick, false, 3)
            send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
            savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function ban_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            local function post_kick()
                ban_user(result.fwd_from.peer_id, result.to.peer_id)
            end
            postpone(post_kick, false, 3)
            send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)])
            savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.fwd_from.peer_id .. " from Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] banned user " .. result.fwd_from.peer_id .. " from N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unban_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        local hash = 'banned:' .. extra.chat_id
        redis:srem(hash, result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].unbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unbanned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] unbanned user " .. result.peer_id .. " N")
    end
end

local function unban_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            local hash = 'banned:' .. result.to.peer_id
            redis:srem(hash, result.from.peer_id)
            send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].unbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unban_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            local hash = 'banned:' .. result.to.peer_id
            redis:srem(hash, result.fwd_from.peer_id)
            send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].unbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.fwd_from.peer_id .. " from Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] unbanned user " .. result.fwd_from.peer_id .. " from N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function banall_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        banall_user(result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].gbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally banned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally banned user " .. result.peer_id .. " N")
    end
end

local function banall_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            local function post_kick()
                banall_user(result.from.peer_id)
            end
            postpone(post_kick, false, 3)
            send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].gbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function banall_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            banall_user(result.fwd_from.peer_id)
            send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].gbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.fwd_from.peer_id .. " from Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally banned user " .. result.fwd_from.peer_id .. " from N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unbanall_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        send_large_msg(extra.receiver, langs[lang].noUsernameFound)
        return
    end
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, extra.chat_id) then
        unbanall_user(result.peer_id)
        send_large_msg(extra.receiver, langs[lang].user .. result.peer_id .. langs[lang].ungbanned)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally unbanned user " .. result.peer_id .. " Y")
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
        savelog(extra.chat_id, "[" .. extra.executer .. "] globally unbanned user " .. result.peer_id .. " N")
    end
end

local function unbanall_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.from.peer_id, result.to.peer_id) then
            unbanall_user(result.from.peer_id)
            send_large_msg(extra.receiver, langs[lang].user .. result.from.peer_id .. langs[lang].ungbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.from.peer_id .. " Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.from.peer_id .. " N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function unbanall_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        -- ignore higher or same rank
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            unbanall_user(result.fwd_from.peer_id)
            send_large_msg(extra.receiver, langs[lang].user .. result.fwd_from.peer_id .. langs[lang].ungbanned)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.fwd_from.peer_id .. " from Y")
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
            savelog(result.to.peer_id, "[" .. extra.executer .. "] globally unbanned user " .. result.fwd_from.peer_id .. " from N")
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function kickrandom_chat(extra, success, result)
    local kickable = false
    local id
    local lang = get_lang(extra.chat_id)

    while not kickable do
        id = result.members[math.random(#result.members)].peer_id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, extra.chat_id) or is_whitelisted(extra.chat_id, id)) then
            kickable = true
            send_large_msg('chat#id' .. extra.chat_id, 'ℹ️ ' .. id .. ' ' .. langs[lang].kicked)
            local function post_kick()
                kick_user_any(id, extra.chat_id)
            end
            postpone(post_kick, false, 1)
        else
            print('403')
        end
    end
end

local function kickrandom_channel(extra, success, result)
    local kickable = false
    local id
    local lang = get_lang(extra.chat_id)

    while not kickable do
        id = result[math.random(#result)].peer_id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, extra.chat_id) or is_whitelisted(extra.chat_id, id)) then
            kickable = true
            send_large_msg('channel#id' .. extra.chat_id, 'ℹ️ ' .. id .. ' ' .. langs[lang].kicked)
            local function post_kick()
                kick_user_any(id, extra.chat_id)
            end
            postpone(post_kick, false, 1)
        else
            print('403')
        end
    end
end

local function kick_deleted_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result.members) do
        if not v.print_name then
            if v.peer_id then
                local rnd = math.random(1000)
                local function post_kick()
                    kick_user(v.peer_id, extra.chat_id)
                end
                postpone(post_kick, false, math.fmod(rnd, 30) + 1)
                kicked = kicked + 1
            end
        end
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_deleted_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)

    for k, v in pairs(result) do
        if not v.print_name then
            if v.peer_id then
                local rnd = math.random(1000)
                local function post_kick()
                    kick_user(v.peer_id, extra.chat_id)
                end
                postpone(post_kick, false, math.fmod(rnd, 30) + 1)
                kicked = kicked + 1
            end
        end
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_nouser_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)
    local ids = ''

    for k, v in pairs(result.members) do
        if not v.username then
            ids = ids .. v.peer_id .. ' '
            local rnd = math.random(1000)
            local function post_kick()
                kick_user(v.peer_id, extra.chat_id)
            end
            postpone(post_kick, false, math.fmod(rnd, 30) + 1)
            kicked = kicked + 1
        end
    end
    local function post_msg_unban()
        if ids ~= '' then
            send_large_msg('chat#id' .. extra.chat_id, '/multipleunban ' .. ids)
        end
    end
    if redis:sismember('apipatch', extra.chat_id) then
        postpone(post_msg_unban, false, 2)
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_nouser_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)
    local ids = ''

    for k, v in pairs(result) do
        if not v.username then
            ids = ids .. v.peer_id .. ' '
            local rnd = math.random(1000)
            local function post_kick()
                kick_user(v.peer_id, extra.chat_id)
            end
            postpone(post_kick, false, math.fmod(rnd, 30) + 1)
            kicked = kicked + 1
        end
    end
    local function post_msg_unban()
        if ids ~= '' then
            send_large_msg('channel#id' .. extra.chat_id, '/multipleunban ' .. ids)
        end
    end
    if redis:sismember('apipatch', extra.chat_id) then
        postpone(post_msg_unban, false, 2)
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function user_msgs(user_id, chat_id, chat_type)
    local api_patch = redis:sismember('apipatch', chat_id) or false

    local user_info
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:' .. user_id .. ':' .. chat_id
    if api_patch and chat_type == 'channel' then
        um_hash = 'msgs:' .. user_id .. ':-100' .. chat_id
    elseif api_patch and chat_type == 'chat' then
        um_hash = 'msgs:' .. user_id .. ':-' .. chat_id
    end
    user_info = tonumber(redis:get(um_hash) or 0)
    return user_info
end

local function kick_inactive_chat(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)
    local ids = ''

    for k, v in pairs(result.members) do
        if tonumber(v.peer_id) ~= tonumber(our_id) and not is_momod2(v.peer_id, extra.chat_id) then
            local user_info = user_msgs(v.peer_id, extra.chat_id, 'chat')
            if tonumber(user_info) < tonumber(extra.num) then
                ids = ids .. v.peer_id .. ' '
                local rnd = math.random(1000)
                local function post_kick()
                    kick_user(v.peer_id, extra.chat_id)
                end
                postpone(post_kick, false, math.fmod(rnd, 30) + 1)
                kicked = kicked + 1
            end
        end
    end
    local function post_msg_unban()
        if ids ~= '' then
            send_large_msg('chat#id' .. extra.chat_id, '/multipleunban ' .. ids)
        end
    end
    if redis:sismember('apipatch', extra.chat_id) then
        postpone(post_msg_unban, false, 2)
    end
    local function post_msg()
        send_large_msg('chat#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function kick_inactive_channel(extra, success, result)
    local kicked = 0
    local lang = get_lang(extra.chat_id)
    local ids = ''

    for k, v in pairs(result) do
        if tonumber(v.peer_id) ~= tonumber(our_id) and not is_momod2(v.peer_id, extra.chat_id) then
            local user_info = user_msgs(v.peer_id, extra.chat_id, 'channel')
            if tonumber(user_info) < tonumber(extra.num) then
                ids = ids .. v.peer_id .. ' '
                local rnd = math.random(1000)
                local function post_kick()
                    kick_user(v.peer_id, extra.chat_id)
                end
                postpone(post_kick, false, math.fmod(rnd, 30) + 1)
                kicked = kicked + 1
            end
        end
    end
    local function post_msg_unban()
        if ids ~= '' then
            send_large_msg('channel#id' .. extra.chat_id, '/multipleunban ' .. ids)
        end
    end
    if redis:sismember('apipatch', extra.chat_id) then
        postpone(post_msg_unban, false, 2)
    end
    local function post_msg()
        send_large_msg('channel#id' .. extra.chat_id, langs[lang].massacre:gsub('X', kicked))
    end
    postpone(post_msg, false, 1)
end

local function run(msg, matches)
    if msg.action then
        return
    end
    local receiver = get_receiver(msg)
    if not msg.api_patch then
        if matches[1]:lower() == 'kickme' or matches[1]:lower() == 'sasha uccidimi' or matches[1]:lower() == 'sasha esplodimi' or matches[1]:lower() == 'sasha sparami' or matches[1]:lower() == 'sasha decompilami' or matches[1]:lower() == 'sasha bannami' then
            -- /kickme
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                local print_name = user_print_name(msg.from):gsub("‮", "")
                local name = print_name:gsub("_", "")
                savelog(msg.to.id, name .. " [" .. msg.from.id .. "] left using kickme ")
                -- Save to logs
                local function post_kick()
                    kick_user_any(msg.from.id, msg.to.id)
                end
                postpone(post_kick, false, 3)
                return langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
            else
                return langs[msg.lang].useYourGroups
            end
            return
        end
        if matches[1]:lower() == 'getuserwarns' or matches[1]:lower() == 'sasha ottieni avvertimenti' or matches[1]:lower() == 'ottieni avvertimenti' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    if get_warn(msg.to.id) == langs[msg.lang].noWarnSet then
                        return langs[msg.lang].noWarnSet
                    end
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, getWarn_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, getWarn_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, getWarn_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            send_large_msg(get_receiver(msg), get_user_warns(msg.from.id, msg.to.id))
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), getWarn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                    return
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == "muteuser" or matches[1]:lower() == 'voce' then
            if is_momod(msg) then
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, muteuser_from, { receiver = get_receiver(msg), executer = msg.from.id })
                        else
                            muteuser = get_message(msg.reply_id, muteuser_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                        end
                    else
                        muteuser = get_message(msg.reply_id, muteuser_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                    end
                    return
                elseif matches[2] and matches[2] ~= '' then
                    if string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            if is_muted_user(msg.to.id, matches[2]) then
                                unmute_user(msg.to.id, matches[2])
                                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed [" .. matches[2] .. "] from the muted users list")
                                return matches[2] .. langs[msg.lang].muteUserRemove
                            else
                                mute_user(msg.to.id, matches[2])
                                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. matches[2] .. "] to the muted users list")
                                return matches[2] .. langs[msg.lang].muteUserAdd
                            end
                        else
                            return langs[msg.lang].require_rank
                        end
                    else
                        resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), muteuser_by_username, { receiver = get_receiver(msg), executer = msg.from.id })
                        return
                    end
                end
            else
                return langs[msg.lang].require_mod
            end
        end
        if matches[1]:lower() == "mutelist" or matches[1]:lower() == "lista utenti muti" then
            if is_momod(msg) then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
                return muted_user_list(msg.to.id, msg.to.print_name)
            else
                return langs[msg.lang].require_mod
            end
        end
        if matches[1]:lower() == 'warn' or matches[1]:lower() == 'sasha avverti' or matches[1]:lower() == 'avverti' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    if get_warn(msg.to.id) == langs[msg.lang].noWarnSet then
                        return langs[msg.lang].noWarnSet
                    end
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, warn_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, warn_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, warn_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                warn_user(matches[2], msg.to.id)
                                savelog(msg.to.id, "[" .. msg.from.id .. "] warned user " .. matches[2])
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] warned user " .. matches[2])
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), warn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                    return
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'unwarn' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    if get_warn(msg.to.id) == langs[msg.lang].noWarnSet then
                        return langs[msg.lang].noWarnSet
                    end
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, unwarn_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, unwarn_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, unwarn_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                unwarn_user(matches[2], msg.to.id)
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unwarned user " .. matches[2])
                                return
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unwarned user " .. matches[2])
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), unwarn_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'unwarnall' or matches[1]:lower() == 'sasha azzera avvertimenti' or matches[1]:lower() == 'azzera avvertimenti' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    if get_warn(msg.to.id) == langs[msg.lang].noWarnSet then
                        return langs[msg.lang].noWarnSet
                    end
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, unwarnall_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, unwarnall_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, unwarnall_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                unwarnall_user(matches[2], msg.to.id)
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unwarnedall user " .. matches[2])
                                return
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unwarnedall user " .. matches[2])
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), unwarnall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'kick' or matches[1]:lower() == 'sasha uccidi' or matches[1]:lower() == 'uccidi' or matches[1]:lower() == 'spara' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    -- /kick
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, kick_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, kick_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, kick_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                local function post_kick()
                                    kick_user(matches[2], msg.to.id)
                                end
                                postpone(post_kick, false, 3)
                                savelog(msg.to.id, "[" .. msg.from.id .. "] kicked user " .. matches[2] .. " Y")
                                return langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] kicked user " .. matches[2] .. " N")
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), kick_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'kickrandom' then
            if is_momod(msg) then
                if msg.to.type == 'chat' then
                    chat_info(receiver, kickrandom_chat, { chat_id = msg.to.id })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kickrandom_channel, { chat_id = msg.to.id })
                end
                return
            else
                return langs[msg.lang].require_mod
            end
        end
        if matches[1]:lower() == 'ban' or matches[1]:lower() == 'sasha banna' or matches[1]:lower() == 'sasha decompila' or matches[1]:lower() == 'banna' or matches[1]:lower() == 'decompila' or matches[1]:lower() == 'esplodi' or matches[1]:lower() == 'kaboom' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    -- /ban
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, ban_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, ban_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, ban_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                local function post_kick()
                                    ban_user(matches[2], msg.to.id)
                                end
                                postpone(post_kick, false, 3)
                                savelog(msg.to.id, "[" .. msg.from.id .. "] banned user " .. matches[2] .. " Y")
                                return langs[msg.lang].user .. matches[2] .. langs[msg.lang].banned .. '\n' .. langs.phrases.banhammer[math.random(#langs.phrases.banhammer)]
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] banned user " .. matches[2] .. " N")
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), ban_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == 'unban' or matches[1]:lower() == 'sasha sbanna' or matches[1]:lower() == 'sasha ricompila' or matches[1]:lower() == 'sasha compila' or matches[1]:lower() == 'sbanna' or matches[1]:lower() == 'ricompila' or matches[1]:lower() == 'compila' then
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                if is_momod(msg) then
                    -- /unban
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, unban_from, { receiver = receiver, executer = msg.from.id })
                            else
                                get_message(msg.reply_id, unban_by_reply, { receiver = receiver, executer = msg.from.id })
                            end
                        else
                            get_message(msg.reply_id, unban_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    elseif matches[2] and matches[2] ~= '' then
                        if string.match(matches[2], '^%d+$') then
                            -- ignore higher or same rank
                            if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                                local hash = 'banned:' .. msg.to.id
                                redis:srem(hash, matches[2])
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unbanned user " .. matches[2] .. " Y")
                                return langs[msg.lang].user .. matches[2] .. langs[msg.lang].unbanned
                            else
                                savelog(msg.to.id, "[" .. msg.from.id .. "] unbanned user " .. matches[2] .. " N")
                                return langs[msg.lang].require_rank
                            end
                        else
                            resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), unban_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                        end
                    end
                else
                    return langs[msg.lang].require_mod
                end
                return
            else
                return langs[msg.lang].useYourGroups
            end
        end
        if matches[1]:lower() == "banlist" or matches[1]:lower() == "sasha lista ban" or matches[1]:lower() == "lista ban" then
            -- /banlist
            if matches[2] and is_admin1(msg) then
                return ban_list(matches[2])
            elseif is_momod(msg) then
                if msg.to.type == 'chat' or msg.to.type == 'channel' then
                    return ban_list(msg.to.id)
                else
                    return langs[msg.lang].useYourGroups
                end
            else
                return langs[msg.lang].require_mod
            end
            return
        end
        if matches[1]:lower() == 'kickdeleted' then
            if is_momod(msg) then
                -- /kickdeleted
                if msg.to.type == 'chat' then
                    chat_info(receiver, kick_deleted_chat, { receiver = get_receiver(msg), chat_id = msg.to.id })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kick_deleted_channel, { receiver = get_receiver(msg), chat_id = msg.to.id })
                end
                return
            else
                return langs[msg.lang].require_mod
            end
        end
        if matches[1]:lower() == 'kickinactive' then
            if is_owner(msg) then
                -- /kickinactive
                local num = 1
                if matches[2] then
                    num = matches[2]
                end
                if msg.to.type == 'chat' then
                    chat_info(receiver, kick_inactive_chat, { chat_id = msg.to.id, num = num, receiver = get_receiver(msg) })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kick_inactive_channel, { chat_id = msg.to.id, num = num, receiver = get_receiver(msg) })
                end
                return
            else
                return langs[msg.lang].require_owner
            end
            return
        end
        if matches[1]:lower() == 'kicknouser' then
            if is_owner(msg) then
                -- /kicknouser
                if msg.to.type == 'chat' then
                    chat_info(receiver, kick_nouser_chat, { receiver = get_receiver(msg), chat_id = msg.to.id })
                elseif msg.to.type == 'channel' then
                    channel_get_users(receiver, kick_nouser_channel, { receiver = get_receiver(msg), chat_id = msg.to.id })
                end
                return
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'gban' or matches[1]:lower() == 'sasha superbanna' or matches[1]:lower() == 'superbanna' then
            if is_admin1(msg) then
                -- /gban
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, banall_from, { receiver = receiver, executer = msg.from.id })
                        else
                            get_message(msg.reply_id, banall_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    else
                        get_message(msg.reply_id, banall_by_reply, { receiver = receiver, executer = msg.from.id })
                    end
                    return
                elseif matches[2] and matches[2] ~= '' then
                    if string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            banall_user(matches[2])
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally banned user " .. matches[2] .. " Y")
                            return langs[msg.lang].user .. matches[2] .. langs[msg.lang].gbanned
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally banned user " .. matches[2] .. " N")
                            return langs[msg.lang].require_rank
                        end
                    else
                        resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), banall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                end
                return
            else
                return langs[msg.lang].require_admin
            end
            return
        end
        if matches[1]:lower() == 'ungban' or matches[1]:lower() == 'sasha supersbanna' or matches[1]:lower() == 'supersbanna' then
            if is_admin1(msg) then
                -- /ungban
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, unbanall_from, { receiver = receiver, executer = msg.from.id })
                        else
                            get_message(msg.reply_id, unbanall_by_reply, { receiver = receiver, executer = msg.from.id })
                        end
                    else
                        get_message(msg.reply_id, unbanall_by_reply, { receiver = receiver, executer = msg.from.id })
                    end
                    return
                elseif matches[2] and matches[2] ~= '' then
                    if string.match(matches[2], '^%d+$') then
                        -- ignore higher or same rank
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            unbanall_user(matches[2])
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally unbanned user " .. matches[2] .. " Y")
                            return langs[msg.lang].user .. matches[2] .. langs[msg.lang].ungbanned
                        else
                            savelog(msg.to.id, "[" .. msg.from.id .. "] globally unbanned user " .. matches[2] .. " N")
                            return langs[msg.lang].require_rank
                        end
                    else
                        resolve_username(string.match(matches[2], '^[^%s]+'):gsub('@', ''), unbanall_by_username, { executer = msg.from.id, chat_id = msg.to.id, receiver = receiver })
                    end
                end
                return
            else
                return langs[msg.lang].require_admin
            end
            return
        end
        if matches[1]:lower() == 'gbanlist' or matches[1]:lower() == 'sasha lista superban' or matches[1]:lower() == 'lista superban' then
            if is_admin1(msg) then
                -- /gbanlist
                local list = banall_list(msg.to.id)
                local file = io.open("./groups/gbanlist.txt", "w")
                file:write(list)
                file:flush()
                file:close()
                send_document(receiver, "./groups/gbanlist.txt", ok_cb, false)
                send_large_msg(receiver, list)
                return list
            else
                return langs[msg.lang].require_admin
            end
            return
        end
    end
end

local function pre_process(msg)
    if msg then
        local continue = false
        if not msg.api_patch then
            continue = true
        elseif msg.from.username then
            if string.sub(msg.from.username:lower(), -3) == 'bot' then
                continue = true
            end
        end
        if continue then
            -- SERVICE MESSAGE
            if msg.action then
                if msg.action.type then
                    -- Check if banned user joins chat by link
                    if msg.action.type == 'chat_add_user_link' then
                        local user_id = msg.from.id
                        print('Checking invited user ' .. user_id)
                        if is_banned(user_id, msg.to.id) or(is_gbanned(user_id) and not is_whitelisted_gban(msg.to.id, user_id)) then
                            -- Check it with redis
                            print('User is banned!')
                            local print_name = user_print_name(msg.from):gsub("‮", "")
                            local name = print_name:gsub("_", "")
                            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] is banned and kicked ! ")
                            -- Save to logs
                            kick_user(user_id, msg.to.id)
                        end
                    end
                    -- Check if banned user joins chat
                    if msg.action.type == 'chat_add_user' then
                        local user_id = msg.action.user.id
                        print('Checking invited user ' .. user_id)
                        if is_banned(user_id, msg.to.id) and not is_momod2(msg.from.id, msg.to.id) or(is_gbanned(user_id) and not(is_admin2(msg.from.id) or is_whitelisted_gban(msg.to.id, user_id))) then
                            -- Check it with redis
                            print('User is banned!')
                            local print_name = user_print_name(msg.from):gsub("‮", "")
                            local name = print_name:gsub("_", "")
                            savelog(msg.to.id, name .. " [" .. msg.from.id .. "] added a banned user >" .. msg.action.user.id)
                            -- Save to logs
                            kick_user(user_id, msg.to.id)
                            local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                            redis:incr(banhash)
                            local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                            local banaddredis = redis:get(banhash)
                            if banaddredis then
                                if tonumber(banaddredis) >= 4 and not is_owner(msg) then
                                    kick_user(msg.from.id, msg.to.id)
                                    -- Kick user who adds ban ppl more than 3 times
                                end
                                if tonumber(banaddredis) >= 8 and not is_owner(msg) then
                                    ban_user(msg.from.id, msg.to.id)
                                    -- Kick user who adds ban ppl more than 7 times
                                    local banhash = 'addedbanuser:' .. msg.to.id .. ':' .. msg.from.id
                                    redis:set(banhash, 0)
                                    -- Reset the Counter
                                end
                            end
                        end
                    end
                    -- No further checks
                    return msg
                end
            end
            -- banned user is talking !
            if msg.to.type == 'chat' or msg.to.type == 'channel' then
                local group = msg.to.id
                local texttext = 'groups'
                -- if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
                -- chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
                -- return
                -- end
                local user_id = msg.from.id
                local chat_id = msg.to.id
                if is_banned(user_id, msg.to.id) or(is_gbanned(user_id) and not is_whitelisted_gban(msg.to.id, msg.from.id)) then
                    -- Check it with redis
                    print('Banned user talking!')
                    local print_name = user_print_name(msg.from):gsub("‮", "")
                    local name = print_name:gsub("_", "")
                    kick_user(user_id, chat_id)
                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] banned user is talking !")
                    -- Save to logs
                    msg.text = ''
                end
            end
        end
        return msg
    end
end

return {
    description = "BANHAMMER",
    patterns =
    {
        "^[#!/]([Kk][Ii][Cc][Kk][Mm][Ee])$",
        "^[#!/]([Gg][Ee][Tt][Uu][Ss][Ee][Rr][Ww][Aa][Rr][Nn][Ss]) ([^%s]+)$",
        "^[#!/]([Gg][Ee][Tt][Uu][Ss][Ee][Rr][Ww][Aa][Rr][Nn][Ss])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) ([^%s]+)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])",
        "^[#!/]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])",
        "^[#!/]([Ww][Aa][Rr][Nn]) ([^%s]+)$",
        "^[#!/]([Ww][Aa][Rr][Nn])$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn])$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn][Aa][Ll][Ll]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Ww][Aa][Rr][Nn][Aa][Ll][Ll])$",
        "^[#!/]([Kk][Ii][Cc][Kk]) ([^%s]+)$",
        "^[#!/]([Kk][Ii][Cc][Kk])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Nn][Oo][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ii][Nn][Aa][Cc][Tt][Ii][Vv][Ee]) (%d+)$",
        "^[#!/]([Kk][Ii][Cc][Kk][Dd][Ee][Ll][Ee][Tt][Ee][Dd])$",
        "^[#!/]([Bb][Aa][Nn]) ([^%s]+)$",
        "^[#!/]([Bb][Aa][Nn])$",
        "^[#!/]([Uu][Nn][Bb][Aa][Nn]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Bb][Aa][Nn])$",
        "^[#!/]([Bb][Aa][Nn][Ll][Ii][Ss][Tt]) ([^%s]+)$",
        "^[#!/]([Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Gg][Bb][Aa][Nn]) ([^%s]+)$",
        "^[#!/]([Gg][Bb][Aa][Nn])$",
        "^[#!/]([Uu][Nn][Gg][Bb][Aa][Nn]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Gg][Bb][Aa][Nn])$",
        "^[#!/]([Gg][Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
        "^!!tgservice (.+)$",
        -- kickme
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii][Mm][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Pp][Ll][Oo][Dd][Ii][Mm][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Rr][Aa][Mm][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa][Mm][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Aa][Nn][Nn][Aa][Mm][Ii])$",
        -- getuserwarns
        "^([Ss][Aa][Ss][Hh][Aa] [Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        "^([Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) ([^%s]+)$",
        "^([Oo][Tt][Tt][Ii][Ee][Nn][Ii] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        -- muteuser
        "^([Vv][Oo][Cc][Ee])$",
        "^([Vv][Oo][Cc][Ee]) ([^%s]+)$",
        -- mutelist
        "^([Ll][Ii][Ss][Tt][Aa] [Uu][Tt][Ee][Nn][Tt][Ii] [Mm][Uu][Tt][Ii])$",
        -- warn
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii])$",
        "^([Aa][Vv][Vv][Ee][Rr][Tt][Ii]) ([^%s]+)$",
        "^([Aa][Vv][Vv][Ee][Rr][Tt][Ii])$",
        -- unwarnall
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii]) ([^%s]+)$",
        "^([Aa][Zz][Zz][Ee][Rr][Aa] [Aa][Vv][Vv][Ee][Rr][Tt][Ii][Mm][Ee][Nn][Tt][Ii])$",
        -- kick
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii]) ([^%s]+)$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii])$",
        "^([Ss][Pp][Aa][Rr][Aa]) ([^%s]+)$",
        "^([Ss][Pp][Aa][Rr][Aa])$",
        -- ban
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Bb][Aa][Nn][Nn][Aa])$",
        "^([Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Dd][Ee][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ee][Ss][Pp][Ll][Oo][Dd][Ii]) ([^%s]+)$",
        "^([Ee][Ss][Pp][Ll][Oo][Dd][Ii])$",
        "^([Kk][Aa][Bb][Oo][Oo][Mm]) ([^%s]+)$",
        "^([Kk][Aa][Bb][Oo][Oo][Mm])$",
        -- unban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Ss][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Rr][Ii][Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        "^([Cc][Oo][Mm][Pp][Ii][Ll][Aa]) ([^%s]+)$",
        "^([Cc][Oo][Mm][Pp][Ii][Ll][Aa])$",
        -- banlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn]) ([^%s]+)$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Aa][Nn])$",
        -- gban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Nn][Aa])$",
        -- ungban
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa])$",
        "^([Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa]) ([^%s]+)$",
        "^([Ss][Uu][Pp][Ee][Rr][Ss][Bb][Aa][Nn][Nn][Aa])$",
        -- gbanlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0,
    syntax =
    {
        "USER",
        "(#kickme|sasha (uccidimi|esplodimi|sparami|decompilami|bannami))",
        "MOD",
        "(#getuserwarns|[sasha] ottieni avvertimenti) <id>|<username>|<reply>|from",
        "#muteuser|voce <id>|<username>|<reply>|from",
        "(#mutelist|lista utenti muti)",
        "(#warn|[sasha] avverti) <id>|<username>|<reply>|from",
        "#unwarn <id>|<username>|<reply>|from",
        "(#unwarnall|[sasha] azzera avvertimenti) <id>|<username>|<reply>|from",
        "(#kick|spara|[sasha] uccidi) <id>|<username>|<reply>|from",
        "(#ban|esplodi|kaboom|[sasha] banna|[sasha] decompila) <id>|<username>|<reply>|from",
        "(#unban|[sasha] sbanna|[sasha] [ri]compila) <id>|<username>|<reply>|from",
        "(#banlist|[sasha] lista ban)",
        "#kickrandom",
        "#kickdeleted",
        "OWNER",
        "#kicknouser",
        "#kickinactive [<msgs>]",
        "ADMIN",
        "(#banlist|[sasha] lista ban) <group_id>",
        "(#gban|[sasha] superbanna) <id>|<username>|<reply>|from",
        "(#ungban|[sasha] supersbanna) <id>|<username>|<reply>|from",
        "(#gbanlist|[sasha] lista superban)",
    },
}