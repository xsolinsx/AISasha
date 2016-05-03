antiarabic = { }
-- An empty table for solving multiple kicking problem
local function run(msg, matches)
    if not is_momod(msg) then
        local data = load_data(_config.moderation.data)
        if data[tostring(msg.to.id)]['settings']['lock_arabic'] then
            if data[tostring(msg.to.id)]['settings']['lock_arabic'] == 'yes' then
                if is_whitelisted(msg.from.id) then
                    return
                end
                if antiarabic[msg.from.id] == true then
                    return
                end
                if msg.to.type == 'chat' then
                    local receiver = get_receiver(msg)
                    local username = msg.from.username
                    local name = msg.from.first_name
                    if username and is_super_group(msg) then
                        send_large_msg(receiver, lang_text('arabicNotAllowed') .. "@" .. username .. " " .. msg.from.id .. '\n' .. lang_text('statusRemovedMsgDeleted'))
                    else
                        send_large_msg(receiver, lang_text('arabicNotAllowed') .. lang_text('name') .. name .. " " .. msg.from.id .. '\n' .. lang_text('statusRemovedMsgDeleted'))
                    end
                    local name = user_print_name(msg.from)
                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] kicked (arabic was locked) ")
                    local chat_id = msg.to.id
                    local user_id = msg.from.id
                    kick_user(user_id, chat_id)
                end
                antiarabic[msg.from.id] = true
            end
        end
    end
end

local function cron()
    antiarabic = { }
    -- Clear antiarabic table
end

return {
    description = "ARABIC_LOCK",
    usage = "Sasha blocca l'arabo nei gruppi.",
    patterns =
    {
        "([\216-\219][\128-\191])"
    },
    run = run,
    cron = cron,
    min_rank = 0
}