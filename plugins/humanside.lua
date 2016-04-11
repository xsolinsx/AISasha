local function run(msg, matches)
    if is_sudo(msg) then
        if matches[1] == 'live' or matches[1] == 'sasha prendi vita' then
            redis:set("bot:life", "yes")
            return lang_text('live')
        end
        if matches[1] == 'die' or matches[1] == 'sasha muori' then
            redis:del("bot:life")
            return lang_text('die')
        end
    end
    if redis:get("bot:life") == "yes" then
        send_typing(msg.to.id, math.random(1, 10))
    else
        send_typing_abort(msg.to.id)
    end
    -- {"send_typing", {ca_peer, ca_number | ca_optional, ca_none}, do_send_typing, "send_typing <peer> [status]\tSends typing notification. You can supply a custom status (range 0-10): none, typing, cancel, record video, upload video, record audio, upload audio, upload photo, upload document, geo, choose contact.", NULL},
    -- {"send_typing_abort", {ca_peer, ca_none}, do_send_typing_abort, "send_typing_abort <peer>\tSends typing notification abort", NULL},

end


return {
    description = "HUMANSIDE",
    usage = "#updatestrings|#installstrings|[sasha] installa|aggiorna stringhe: Sasha aggiorna le stringhe di testo.",
    patterns =
    {
        "^(.*)$",
        '^[#!/]([Ll][Ii][Vv][Ee])$',
        '^[#!/]([Dd][Ii][Ee])$',
        -- live
        '^([Ss][Aa][Ss][Hh][Aa] [Pp][Rr][Ee][Nn][Dd][Ii] [Vv][Ii][Tt][Aa])$',
        -- die
        '^([Ss][Aa][Ss][Hh][Aa] [Mm][Uu][Oo][Rr][Ii])$',
    },
    run = run,
    min_rank = 5
}