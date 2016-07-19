local function run(msg, matches)
    if is_owner(msg) then
        if not string.match(matches[1], '^%d+$') then
            if matches[1]:lower() == 'on' then
                enable_channel(get_receiver(msg), msg.to.id)
            end
            if matches[1]:lower() == 'off' then
                disable_channel(get_receiver(msg), msg.to.id)
            end
        elseif is_admin1(msg) then
            if matches[2]:lower() == 'on' then
                enable_channel(get_receiver(msg), matches[1])
            end
            if matches[2]:lower() == 'off' then
                disable_channel(get_receiver(msg), matches[1])
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
        "^[#!/][Bb][Oo][Tt] (%d+) ([Oo][Nn])",
        "^[#!/][Bb][Oo][Tt] (%d+) ([Oo][Ff][Ff])",
        -- bot
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Nn])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Ff][Ff])",
        "^[Ss][Aa][Ss][Hh][Aa] (%d+) ([Oo][Nn])",
        "^[Ss][Aa][Ss][Hh][Aa] (%d+) ([Oo][Ff][Ff])",
    },
    run = run,
    min_rank = 2
    -- usage
    -- OWNER
    -- #bot|sasha on|off
    -- ADMIN
    -- #bot|sasha [<group_id>] on|off
}