local function run(msg, matches)
    if is_sudo(msg) then
        -- code for writing is in on_msg_receive(msg) (seedbot.lua)
        if matches[1]:lower() == 'on' then
            redis:set('writing', true)
        elseif matches[1]:lower() == 'off' then
            redis:del('writing')
        end
    else
        return langs[msg.lang].require_sudo
    end
end

return {
    description = "REACTIONS",
    patterns =
    {
        "^[#!/][Ww][Rr][Ii][Tt][Ii][Nn][Gg] ([Oo][Nn])$",
        "^[#!/][Ww][Rr][Ii][Tt][Ii][Nn][Gg] ([Oo][Ff][Ff])$",
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO
    -- #writing on|off
}