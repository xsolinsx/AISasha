local function callback_reply(extra, success, result)
    if extra == 'code' then
        send_large_msg('chat#id' .. result.to.peer_id, "<code>" .. result.text .. "</code>")
        send_large_msg('channel#id' .. result.to.peer_id, "<code>" .. result.text .. "</code>")
    elseif extra == 'bold' then
        send_large_msg('chat#id' .. result.to.peer_id, "<b>" .. result.text .. "</b>")
        send_large_msg('channel#id' .. result.to.peer_id, "<b>" .. result.text .. "</b>")
    elseif extra == 'italic' then
        send_large_msg('chat#id' .. result.to.peer_id, "<i>" .. result.text .. "</i>")
        send_large_msg('channel#id' .. result.to.peer_id, "<i>" .. result.text .. "</i>")
    elseif extra == 'underline' then
        send_large_msg('chat#id' .. result.to.peer_id, "<u>" .. result.text .. "</u>")
        send_large_msg('channel#id' .. result.to.peer_id, "<u>" .. result.text .. "</u>")
    end
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    if matches[1]:lower() == 'codify' then
        if is_momod(msg) then
            if type(msg.reply_id) ~= 'nil' then
                return get_message(msg.reply_id, callback_reply, 'code')
            else
                send_large_msg(receiver, "<code>" .. matches[2] .. "</code>")
            end
        else
            return lang_text('require_mod')
        end
    end
    if matches[1]:lower() == 'boldify' then
        if is_momod(msg) then
            if type(msg.reply_id) ~= 'nil' then
                return get_message(msg.reply_id, callback_reply, 'bold')
            else
                send_large_msg(receiver, "<b>" .. matches[2] .. "</b>")
            end
        else
            return lang_text('require_mod')
        end
    end
    if matches[1]:lower() == 'italify' then
        if is_momod(msg) then
            if type(msg.reply_id) ~= 'nil' then
                return get_message(msg.reply_id, callback_reply, 'italic')
            else
                send_large_msg(receiver, "<i>" .. matches[2] .. "</i>")
            end
        else
            return lang_text('require_mod')
        end
    end
    if matches[1]:lower() == 'underify' then
        if is_momod(msg) then
            if type(msg.reply_id) ~= 'nil' then
                return get_message(msg.reply_id, callback_reply, 'underline')
            else
                send_large_msg(receiver, "<u>" .. matches[2] .. "</u>")
            end
        else
            return lang_text('require_mod')
        end
    end
end

return {
    description = "CODIFY",
    patterns =
    {
        "^[#!/]([Cc][Oo][Dd][Ii][Ff][Yy])$",
        "^[#!/]([Cc][Oo][Dd][Ii][Ff][Yy]) (.+)$",
        "^[#!/]([Bb][Oo][Ll][Dd][Ii][Ff][Yy])$",
        "^[#!/]([Bb][Oo][Ll][Dd][Ii][Ff][Yy]) (.+)$",
        "^[#!/]([Ii][Tt][Aa][Ll][Ii][Ff][Yy])$",
        "^[#!/]([Ii][Tt][Aa][Ll][Ii][Ff][Yy]) (.+)$",
        "^[#!/]([Uu][Nn][Dd][Ee][Rr][Ii][Ff][Yy])$",
        "^[#!/]([Uu][Nn][Dd][Ee][Rr][Ii][Ff][Yy]) (.+)$",
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- #codify <reply>
}