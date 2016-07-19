local function run(msg, matches)
    if is_sudo(msg) then
        print('Loading languages.lua...')
        langs = dofile('languages.lua')
        return langs['it'].langUpdate
    else
        return langs['it'].require_sudo
    end
end

return {
    description = "STRINGS",
    patterns =
    {
        '^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        -- reloadstrings
        '^([Ss][Aa][Ss][Hh][Aa] [Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
        '^([Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ss][Tt][Rr][Ii][Nn][Gg][Hh][Ee])$',
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO,
    -- (#reloadstrings|[sasha] aggiorna stringhe)
}