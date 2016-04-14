-- invite by reply
local function Invite_by_reply(extra, success, result)
    if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
        local chat = 'chat#id' .. result.to.peer_id
        local channel = 'channel#id' .. result.to.peer_id
        chat_add_user(chat, 'user#id' .. result.from.peer_id, ok_cb, false)
        channel_invite(channel, 'user#id' .. result.from.peer_id, ok_cb, false)
    else
        return lang_text('useYourGroups')
    end
end

local function callbackres(extra, success, result)
    local user = 'user#id' .. result.peer_id
    local chat = 'chat#id' .. extra.chatid
    local channel = 'channel#id' .. extra.chatid
    if is_banned(result.id, extra.chatid) then
        send_large_msg(chat, lang_text('userBanned'))
        send_large_msg(channel, lang_text('userBanned'))
    elseif is_gbanned(result.id) then
        send_large_msg(chat, lang_text('userGbanned'))
        send_large_msg(channel, lang_text('userGbanned'))
    else
        chat_add_user(chat, user, ok_cb, false)
        channel_invite(channel, user, ok_cb, false)
    end
end
function run(msg, matches)
    local data = load_data(_config.moderation.data)
    -- if is_owner(msg) then
    if is_admin1(msg) then
        if not is_realm(msg) then
            if data[tostring(msg.to.id)]['settings']['lock_member'] == 'yes' and not is_admin1(msg) then
                return lang_text('privateGroup')
            end
        end
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            local chat = 'chat#id' .. msg.to.id
            local channel = 'channel#id' .. msg.to.id
            if type(msg.reply_id) ~= "nil" then
                local msgr = get_message(msg.reply_id, Invite_by_reply, false)
            elseif string.match(matches[2], '^%d+$') then
                -- User submitted an id
                user = 'user#id' .. user
                -- The message must come from a chat group
                chat_add_user(chat, user, callback, false)
                channel_invite(channel, user, callback, false)
            else
                local user = matches[2]
                -- User submitted a user name
                local cbres_extra = { chatid = msg.to.id }
                resolve_username(user:gsub("@", ""), callbackres, cbres_extra)
            end
        else
            return lang_text('useYourGroups')
        end
    else
        -- return lang_text('require_owner')
        return lang_text('require_admin')
    end
end

return {
    description = "INVITE",
    usage =
    {
        -- "OWNER",
        "ADMIN",
        "(#invite|[sasha] invita|[sasha] resuscita) <id>|<username>|<reply>: Sasha invita l'utente specificato.",
    },
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
    -- min_rank = 2
    min_rank = 4
}