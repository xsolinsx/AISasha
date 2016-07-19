function run(msg, matches)
    local text = langs['it'].feedStart
    if msg.from.first_name then
        text = text .. langs['it'].feedName .. msg.from.first_name
    end
    if msg.from.last_name then
        text = text .. langs['it'].feedSurname .. msg.from.last_name
    end
    if msg.from.username then
        text = text .. langs['it'].feedUsername .. msg.from.username
    end
    text = text .. '\n🆔: ' .. msg.from.id ..
    '\n\nFeedback:\n' .. matches[1]
    send_large_msg('chat#id120307338', text)
    return langs['it'].feedSent
end

return {
    description = "FEEDBACK",
    patterns =
    {
        "^[#!/][Ff][Ee][Ee][Dd][Bb][Aa][Cc][Kk] (.*)$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- #feedback <text>
}