local function run(msg, matches)
    return
end

return {
    description = "BOT",
    usage =
    {
        "OWNER",
        "#bot|sasha on|off: Sasha si attiva|disattiva.",
    },
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
}