local function run(msg, matches)
    if not msg.api_patch then
        if (matches[1]:lower() == 'echo' or matches[1]:lower() == 'sasha ripeti') and matches[2] then
            if string.match(matches[2], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if string.match(matches[2], '[Cc][Rr][Oo][Ss][Ss][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if is_momod(msg) then
                if type(msg.reply_id) ~= "nil" then
                    reply_msg(msg.reply_id, matches[2], ok_cb, false)
                else
                    return matches[2]
                end
            else
                return langs[msg.lang].require_mod
            end
        end
        -- interact
        if matches[1]:lower() == 'sasha come va?' then
            reply_msg(msg.id, langs.phrases.interact.howareyou[math.random(#langs.phrases.interact.howareyou)], ok_cb, false)
        end
        if matches[1]:lower() == 'sasha' and string.match(matches[2], '.*%?') then
            local rnd = math.random(0, 2)
            if rnd == 0 then
                reply_msg(msg.id, langs.phrases.interact.no[math.random(#langs.phrases.interact.no)], ok_cb, false)
            elseif rnd == 1 then
                reply_msg(msg.id, langs.phrases.interact.idontknow[math.random(#langs.phrases.interact.idontknow)], ok_cb, false)
            elseif rnd == 2 then
                reply_msg(msg.id, langs.phrases.interact.yes[math.random(#langs.phrases.interact.yes)], ok_cb, false)
            end
        end
        if matches[1]:lower() == 'sasha ti amo' or matches[1]:lower() == 'ti amo sasha' then
            reply_msg(msg.id, langs.phrases.interact.iloveyou[math.random(#langs.phrases.interact.iloveyou)], ok_cb, false)
        end
    end
    if matches[1]:lower() == '@aisasha' then
        local rnd = math.random(0, 2)
        if rnd == 0 then
            reply_msg(msg.id, langs.phrases.interact.no[math.random(#langs.phrases.interact.no)], ok_cb, false)
        elseif rnd == 1 then
            reply_msg(msg.id, langs.phrases.interact.idontknow[math.random(#langs.phrases.interact.idontknow)], ok_cb, false)
        elseif rnd == 2 then
            reply_msg(msg.id, langs.phrases.interact.yes[math.random(#langs.phrases.interact.yes)], ok_cb, false)
        end
    end
end

return {
    description = "INTERACT",
    patterns =
    {
        "^[#!/]([Ee][Cc][Hh][Oo]) +(.+)$",
        -- echo
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Pp][Ee][Tt][Ii]) +(.+)$",
        -- react
        "^(@[Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Ee] [Vv][Aa]%?)$",
        "^([Ss][Aa][Ss][Hh][Aa])(.*%?)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Tt][Ii] [Aa][Mm][Oo])$",
        "^([Tt][Ii] [Aa][Mm][Oo] [Ss][Aa][Ss][Hh][Aa])$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "MOD",
        "(#echo|sasha ripeti) <text>",
    },
}