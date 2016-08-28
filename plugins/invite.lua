local function invite_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    chat_add_user(extra.receiver, 'user#id' .. result.peer_id, ok_cb, false)
    channel_invite(extra.receiver, 'user#id' .. result.peer_id, ok_cb, false)
end

local function invite_by_reply(extra, success, result)
    chat_add_user(extra.receiver, 'user#id' .. result.from.peer_id, ok_cb, false)
    channel_invite(extra.receiver, 'user#id' .. result.from.peer_id, ok_cb, false)
end

local function invite_from(extra, success, result)
    chat_add_user(extra.receiver, 'user#id' .. result.fwd_from.peer_id, ok_cb, false)
    channel_invite(extra.receiver, 'user#id' .. result.fwd_from.peer_id, ok_cb, false)
end

local function run(msg, matches)
    -- if is_owner(msg) then
    if is_admin1(msg) then
        local data = load_data(_config.moderation.data)
        local receiver = get_receiver(msg)
        if not is_realm(msg) then
            if data[tostring(msg.to.id)]['settings']['lock_member'] == 'yes' and not is_admin1(msg) then
                return langs[msg.lang].privateGroup
            end
        end
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            if type(msg.reply_id) ~= "nil" then
                if matches[2] then
                    if matches[2]:lower() == 'from' then
                        get_message(msg.reply_id, invite_from, { receiver = receiver })
                        return
                    else
                        get_message(msg.reply_id, invite_by_reply, { receiver = receiver })
                    end
                else
                    get_message(msg.reply_id, invite_by_reply, { receiver = receiver })
                end
            elseif string.match(matches[2], '^%d+$') then
                chat_add_user(receiver, 'user#id' .. matches[2], ok_cb, false)
                channel_invite(receiver, 'user#id' .. matches[2], ok_cb, false)
            else
                resolve_username(matches[2]:gsub('@', ''), invite_by_username, { receiver = receiver })
            end
        else
            return langs[msg.lang].useYourGroups
        end
    else
        -- return langs[msg.lang].require_owner
        return langs[msg.lang].require_admin
    end
end

return {
    description = "INVITE",
    patterns =
    {
        "^[#!/]([Ii][Nn][Vv][Ii][Tt][Ee]) (.*)$",
        "^[#!/]([Ii][Nn][Vv][Ii][Tt][Ee])$",
        -- add|invite
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Vv][Ii][Tt][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Vv][Ii][Tt][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ee][Ss][Uu][Ss][Cc][Ii][Tt][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ee][Ss][Uu][Ss][Cc][Ii][Tt][Aa])$",
        "^([Ii][Nn][Vv][Ii][Tt][Aa]) (.*)$",
        "^([Ii][Nn][Vv][Ii][Tt][Aa])$",
        "^([Rr][Ee][Ss][Uu][Ss][Cc][Ii][Tt][Aa]) (.*)$",
        "^([Rr][Ee][Ss][Uu][Ss][Cc][Ii][Tt][Aa])$",
    },
    run = run,
    min_rank = 3,
    syntax =
    {
        "ADMIN",
        "(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>|from",
    },
}