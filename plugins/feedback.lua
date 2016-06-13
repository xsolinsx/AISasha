function run(msg, matches)
    local text = lang_text('feedStart')
    if msg.from.first_name then
        text = text .. lang_text('feedName') .. msg.from.first_name
    end
    if msg.from.last_name then
        text = text .. lang_text('feedSurname') .. msg.from.last_name
    end
    if msg.from.username then
        text = text .. lang_text('feedUsername') .. msg.from.username
    end
    text = text .. '\n🆔: ' .. msg.from.id ..
    '\n\nFeedback:\n' .. matches[1]
    send_large_msg('chat#id120307338', text)
    return lang_text('feedSent')
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