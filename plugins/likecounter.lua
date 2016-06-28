local function like(likedata, chat, user)
    if user ~= our_id then
        if not likedata[chat] then
            likedata[chat] = { }
        end
        if not likedata[chat][user] then
            likedata[chat][user] = 0
        end
        likedata[chat][user] = tonumber(likedata[chat][user] + 1)
        save_data(_config.likecounter.db, likedata)
    end
end

local function dislike(likedata, chat, user)
    if user ~= our_id then
        if not likedata[chat] then
            likedata[chat] = { }
        end
        if not likedata[chat][user] then
            likedata[chat][user] = 0
        end
        likedata[chat][user] = tonumber(likedata[chat][user] -1)
        save_data(_config.likecounter.db, likedata)
    end
end

local function like_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, lang_text('noUsernameFound'))
    end
    like(extra.likedata, extra.chat, result.peer_id)
end

local function like_by_reply(extra, success, result)
    like(extra.likedata, result.to.peer_id, result.from.peer_id)
end

local function like_from(extra, success, result)
    like(extra.likedata, result.to.peer_id, result.fwd_from.peer_id)
end

local function dislike_by_username(extra, success, result)
    if success == 0 then
        return send_large_msg(extra.receiver, lang_text('noUsernameFound'))
    end
    dislike(extra.likedata, extra.chat, result.peer_id)
end

local function dislike_by_reply(extra, success, result)
    dislike(extra.likedata, result.to.peer_id, result.from.peer_id)
end

local function dislike_from(extra, success, result)
    dislike(extra.likedata, result.to.peer_id, result.fwd_from.peer_id)
end

-- Returns a table with `name`
local function get_name(user_id)
    local user_info = { }
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    user_info.name = user_print_name(user):gsub('_', ' ')
    return user_info
end

local function likes_leaderboard(users, lbtype)
    local users_info = { }

    -- Get user name and param
    for k, user in pairs(users) do
        if user then
            local user_info = get_name(k)
            user_info.param = tonumber(user)
            table.insert(users_info, user_info)
        end
    end

    -- Sort users by param
    table.sort(users_info, function(a, b)
        if a.param and b.param then
            return a.param > b.param
        end
    end )

    local text = lang_text('likesLeaderboard')
    local i = 0
    for k, user in pairs(users_info) do
        if user.name and user.param then
            i = i + 1
            text = text .. i .. '. ' .. user.name .. ' => ' .. user.param .. '\n'
        end
    end
    return text
end

local function run(msg, matches)
    if msg.to.type ~= 'user' then
        if matches[1]:lower() == 'createlikesdb' then
            if is_sudo(msg) then
                local f = io.open(_config.likecounter.db, 'w+')
                f:write('{}')
                f:close()
                reply_msg(msg.id, lang_text('likesdbCreated'), ok_cb, false)
            else
                return lang_text('require_sudo')
            end
            return
        end

        local chat = tostring(msg.to.id)
        local user = tostring(msg.from.id)
        local likedata = load_data(_config.likecounter.db)

        if not likedata[chat] then
            likedata[chat] = { }
            save_data(_config.likecounter.db, likedata)
            likedata = load_data(_config.likecounter.db)
        end

        if matches[1]:lower() == 'addlikes' and matches[2] and matches[3] and is_sudo(msg) then
            likedata[chat][matches[2]] = tonumber(likedata[chat][matches[2]] + matches[3])
            save_data(_config.likecounter.db, likedata)
            reply_msg(msg.id, lang_text('cheating'), ok_cb, false)
            return
        end

        if matches[1]:lower() == 'remlikes' and matches[2] and matches[3] and is_sudo(msg) then
            likedata[chat][matches[2]] = tonumber(likedata[chat][matches[2]] - matches[3])
            save_data(_config.likecounter.db, likedata)
            reply_msg(msg.id, lang_text('cheating'), ok_cb, false)
            return
        end

        if (matches[1]:lower() == 'likes') then
            send_large_msg(get_receiver(msg), likes_leaderboard(likedata[chat]))
            return
        end

        if msg.fwd_from then
            reply_msg(msg.id, lang_text('forwardingLike'), ok_cb, false)
        else
            if matches[1]:lower() == 'like' then
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, like_from, { likedata = likedata })
                            return
                        else
                            get_message(msg.reply_id, like_by_reply, { likedata = likedata })
                        end
                    else
                        get_message(msg.reply_id, like_by_reply, { likedata = likedata })
                    end
                elseif string.match(matches[2], '^%d+$') then
                    like(likedata, chat, user)
                else
                    resolve_username(matches[2]:gsub('@', ''), like_by_username, { chat = chat, likedata = likedata })
                end
            elseif matches[1]:lower() == 'dislike' then
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, dislike_from, { likedata = likedata })
                            return
                        else
                            get_message(msg.reply_id, dislike_by_reply, { likedata = likedata })
                        end
                    else
                        get_message(msg.reply_id, dislike_by_reply, { likedata = likedata })
                    end
                elseif string.match(matches[2], '^%d+$') then
                    dislike(likedata, chat, user)
                else
                    resolve_username(matches[2]:gsub('@', ''), dislike_by_username, { chat = chat, likedata = likedata })
                end
            end
        end
    end
end

return {
    description = "LIKECOUNTER",
    patterns =
    {
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Ll][Ii][Kk][Ee][Ss][Dd][Bb])$",
        "^[#!/]([Ll][Ii][Kk][Ee]) (.*)$",
        "^[#!/]([Ll][Ii][Kk][Ee])$",
        "^[#!/]([Dd][Ii][Ss][Ll][Ii][Kk][Ee]) (.*)$",
        "^[#!/]([Dd][Ii][Ss][Ll][Ii][Kk][Ee])$",
        "^[#!/]([Ll][Ii][Kk][Ee][Ss])$",
        "^[#!/]([Aa][Dd][Dd][Ll][Ii][Kk][Ee][Ss]) (%d+) (%d+)$",
        "^[#!/]([Rr][Ee][Mm][Ll][Ii][Kk][Ee][Ss]) (%d+) (%d+)$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- #like <id>|<username>|<reply>|from
    -- #dislike <id>|<username>|<reply>|from
    -- #likes
    -- SUDO
    -- #createlikesdb
    -- #addlikes <id> <value>
    -- #remlikes <id> <value>
}