local function run(msg, matches)
    if is_owner(msg) then
        if matches[1]:lower() == 'on' then
            enable_channel(get_receiver(msg), msg.to.id)
        end
        if matches[1]:lower() == 'off' then
            disable_channel(get_receiver(msg), msg.to.id)
        end
    else
        return lang_text('require_owner')
    end
    return
end

return {
    description = "BOT",
    patterns =
    {
        "^[#!/][Bb][Oo][Tt] ([Oo][Nn])",
        "^[#!/][Bb][Oo][Tt] ([Oo][Ff][Ff])",
        -- bot
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Nn])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Ff][Ff])"
    },
    run = run,
    pre_process = pre_process,
    min_rank = 2
    -- usage
    -- OWNER
    -- #bot|sasha on|off
}