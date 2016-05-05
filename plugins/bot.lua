local function run(msg, matches)
    -- code is in function msg_valid(msg) (seedbot.lua)
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