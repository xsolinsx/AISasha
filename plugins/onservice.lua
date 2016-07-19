-- Will leave the group if be added
local function run(msg, matches)
    local bot_id = our_id
    local receiver = get_receiver(msg)
    if (matches[1]:lower() == 'leave' or matches[1]:lower() == 'sasha abbandona') and is_admin1(msg) then
        if not matches[2] then
            chat_del_user(receiver, 'user#id' .. bot_id, ok_cb, false)
            leave_channel(receiver, ok_cb, false)
        else
            chat_del_user("chat#id" .. matches[2], 'user#id' .. bot_id, ok_cb, false)
            leave_channel("channel#id" .. matches[2], ok_cb, false)
        end
    elseif msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then
        send_large_msg(receiver, langs['it'].notMyGroup, ok_cb, false)
        chat_del_user(receiver, 'user#id' .. bot_id, ok_cb, false)
        leave_channel(receiver, ok_cb, false)
    end
end

return {
    description = "ONSERVICE",
    patterns =
    {
        "^[#!/]([Ll][Ee][Aa][Vv][Ee]) (%d+)$",
        "^[#!/]([Ll][Ee][Aa][Vv][Ee])$",
        -- leave
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Bb][Bb][Aa][Nn][Dd][Oo][Nn][Aa]) (%d+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Bb][Bb][Aa][Nn][Dd][Oo][Nn][Aa])$",
        "^!!tgservice (.+)$",
    },
    run = run,
    min_rank = 4
    -- usage
    -- ADMIN
    -- (#leave|sasha abbandona) [<group_id>]
}