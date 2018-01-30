local function run(msg, matches)
    if is_owner(msg) then
        if not matches[2] then
            if matches[1]:lower() == 'on' then
                enable_channel(get_receiver(msg), msg.to.id)
            end
            if matches[1]:lower() == 'off' then
                disable_channel(get_receiver(msg), msg.to.id)
            end
        elseif is_admin1(msg) then
            if matches[1]:lower() == 'on' then
                enable_channel(get_receiver(msg), matches[2])
            end
            if matches[1]:lower() == 'off' then
                disable_channel(get_receiver(msg), matches[2])
            end
        else
            return langs[msg.lang].require_admin
        end
    else
        return langs[msg.lang].require_owner
    end
end

return {
    description = "BOT",
    patterns =
    {
        "^[#!/][Bb][Oo][Tt] ([Oo][Nn])",
        "^[#!/][Bb][Oo][Tt] ([Oo][Ff][Ff])",
        "^[#!/][Bb][Oo][Tt] ([Oo][Nn]) (%d+)",
        "^[#!/][Bb][Oo][Tt] ([Oo][Ff][Ff]) (%d+)",
        -- bot
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Nn])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Ff][Ff])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Nn]) (%d+)",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Ff][Ff]) (%d+)",
    },
    run = run,
    min_rank = 3,
    syntax =
    {
        "OWNER",
        "#bot|sasha on|off",
        "ADMIN",
        "#bot|sasha on|off [<group_id>]",
    }
}