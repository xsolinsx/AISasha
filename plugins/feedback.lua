function run(msg, matches)
    local text = langs[msg.lang].feedStart
    if msg.from.first_name then
        text = text .. langs[msg.lang].feedName .. msg.from.first_name
    end
    if msg.from.last_name then
        text = text .. langs[msg.lang].feedSurname .. msg.from.last_name
    end
    if msg.from.username then
        text = text .. langs[msg.lang].feedUsername .. msg.from.username
    end
    text = text .. '\n🆔: ' .. msg.from.id ..
    '\n\nFeedback:\n' .. matches[1]
    send_large_msg('chat#id120307338', text)
    return langs[msg.lang].feedSent
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