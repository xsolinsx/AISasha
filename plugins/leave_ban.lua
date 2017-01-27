local function run(msg, matches)
    if msg.action then
        if msg.action.type then
            if data[tostring(msg.to.id)] then
                if data[tostring(msg.to.id)]['settings'] then
                    if data[tostring(msg.to.id)]['settings']['leave_ban'] then
                        leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
                    end
                end
            end
            if msg.action.type == 'chat_del_user' and not is_momod2(msg.action.user.id) and leave_ban then
                local user_id = msg.action.user.id
                local chat_id = msg.to.id
                ban_user(user_id, chat_id)
            end
        end
    end
end

return {
    description = "LEAVE_BAN",
    patterns =
    {
        "^!!tgservice (.+)$"
    },
    run = run,
    min_rank = 5
}