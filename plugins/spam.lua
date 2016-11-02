local function spam(chat, text, i)
    local function message()
        send_large_msg(chat, text)
    end
    postpone(message, false, i)
end

local function run(msg, matches)
    if is_owner(msg) then
        if (matches[1]:lower() == 'spam' or matches[1]:lower() == 'sasha spamma' or matches[1]:lower() == 'spamma') and matches[2] then
            if matches[3] and matches[4] then
                local i = 0
                while i <(tonumber(matches[2]) /(0.5 / tonumber(matches[3]))) / 2 do
                    i = i + matches[3]
                    spam(get_receiver(msg), matches[4], i)
                end
            else
                local i = 0
                while i <(5 /(0.5 / 2)) / 2 do
                    i = i + 2
                    spam(get_receiver(msg), matches[2], i)
                end
            end
        end
    else
        return langs[msg.lang].require_owner
    end
end

return {
    description = "SPAM",
    patterns =
    {
        "^[#!/]([Ss][Pp][Aa][Mm]) (%d+) (%d+) (.+)$",
        -- spam
        "^[#!/]([Ss][Pp][Aa][Mm]) (.+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+) (.+)$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+) (.+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa]) (.+)$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa]) (.+)$",
    },
    run = run,
    min_rank = 2,
    syntax =
    {
        "OWNER",
        "(#spam|[sasha] spamma) [<messages> <seconds>] <text>",
    },
}