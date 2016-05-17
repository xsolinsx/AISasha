-- modify lua-tg.c, search for case lq_msg and replace 0 with TGLMF_HTML, save and make
local function callback_reply(extra, success, result)
    send_large_msg('chat#id' .. result.to.peer_id, "<code>" .. result.text .. "</code>")
    send_large_msg('channel#id' .. result.to.peer_id, "<code>" .. result.text .. "</code>")
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    local chat_type = msg.to.type

    if matches[1]:lower() == 'codify' then
        if is_momod(msg) then
            if type(msg.reply_id) ~= 'nil' then
                return get_message(msg.reply_id, callback_reply, false)
            else
                send_large_msg(receiver, "<code>" .. matches[2] .. "</code>")
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
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- #codify <text>|<reply>
}
-- thanks to @Mehran_HPR