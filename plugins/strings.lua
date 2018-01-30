local function run(msg, matches)
    if not msg.api_patch then
        if (matches[1]:lower() == 'setlang' or matches[1]:lower() == 'lingua') and matches[2] then
            if msg.to.type == 'user' then
                redis:set('lang:' .. msg.to.id, matches[2]:lower())
                return langs[matches[2]:lower()].langSet
            elseif is_owner(msg) then
                redis:set('lang:' .. msg.to.id, matches[2]:lower())
                return langs[matches[2]:lower()].langSet
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'reloadstrings' or matches[1]:lower() == 'reloadlangs' then
            if is_sudo(msg) then
                print('Loading languages.lua...')
                langs = dofile('languages.lua')
                return langs[msg.lang].langUpdate
            else
                return langs[msg.lang].require_sudo
            end
        end
    end
end

return {
    description = "STRINGS",
    patterns =
    {
        '^[#!/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ii][Tt])$',
        '^[#!/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ee][Nn])$',
        '^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd][Ss][Tt][Rr][Ii][Nn][Gg][Ss])$',
        '^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd][Ll][Aa][Nn][Gg][Ss])$',
        -- setlang
        '^([Ll][Ii][Nn][Gg][Uu][Aa]) ([Ii][Tt])$',
        '^([Ll][Ii][Nn][Gg][Uu][Aa]) ([Ee][Nn])$',
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "USER",
        "(#setlang|lingua) (it|en)",
        "OWNER",
        "(#setlang|lingua) (it|en)",
        "SUDO",
        "(#reloadstrings|#reloadlangs)",
    },
}