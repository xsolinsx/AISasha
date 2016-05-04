local function run(msg, matches)
    if is_sudo(msg) then
        if matches[1]:lower() == 'on' then
            redis:set('writing', true)
        elseif matches[1]:lower() == 'off' then
            redis:del('writing')
        end
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "REACTIONS",
    usage =
    {
        "SUDO",
        "#writing on|off: Sasha (dà|smette di dare) di matto.",
    },
    patterns =
    {
        "^[#!/][Ww][Rr][Ii][Tt][Ii][Nn][Gg] ([Oo][Nn])$",
        "^[#!/][Ww][Rr][Ii][Tt][Ii][Nn][Gg] ([Oo][Ff][Ff])$",
    },
    run = run,
    min_rank = 5
}