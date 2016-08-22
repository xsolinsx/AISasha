local function run(msg, matches)
    if matches[1] == 'br' and is_admin1(msg) then
        local response = matches[3]
        send_large_msg("chat#id" .. matches[2], response)
        send_large_msg("channel#id" .. matches[2], response)
    end
    if matches[1] == 'broadcast' and is_sudo(msg) then
        -- Only sudo!
        local data = load_data(_config.moderation.data)
        local groups = 'groups'
        local response = matches[2]
        for k, v in pairs(data[tostring(groups)]) do
            chat_id = v
            local chat = 'chat#id' .. chat_id
            local channel = 'channel#id' .. chat_id
            send_large_msg(chat, response)
            send_large_msg(channel, response)
        end
    end
end

return {
    description = "BROADCAST",
    patterns =
    {
        "^[#!/]([Bb][Rr][Oo][Aa][Dd][Cc][Aa][Ss][Tt]) +(.+)$",
        "^[#!/]([Bb][Rr]) (%d+) (.*)$"
    },
    run = run,
    min_rank = 3
    -- usage
    -- ADMIN
    -- #br <group_id> <text>: Sasha invia <text> a <group_id>.
    -- SUDO
    -- #broadcast <text>: Sasha invia <text> a tutti i gruppi.
}