local function send_title(extra, success, result)
    if success then
        send_msg(extra[1], extra[2], ok_cb, false)
    end
end

local function run(msg, matches)
    if not msg.api_patch then
        local eq = URL.escape(matches[1])

        local url = "http://latex.codecogs.com/png.download?"
        .. "\\dpi{300}%20\\LARGE%20" .. eq

        local receiver = get_receiver(msg)
        local title = "Edit LaTeX on www.codecogs.com/eqnedit.php?latex=" .. eq
        send_photo_from_url(receiver, url, send_title, { receiver, title })
    end
end

return {
    description = "TEX",
    patterns =
    {
        "^[#!/][Tt][Ee][Xx] (.+)$",
        -- tex
        "^[Ss][Aa][Ss][Hh][Aa] [Ee][Qq][Uu][Aa][Zz][Ii][Oo][Nn][Ee] (.+)$",
        "^[Ee][Qq][Uu][Aa][Zz][Ii][Oo][Nn][Ee] (.+)$",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "USER",
        "(#tex|[sasha] equazione) <equation>",
    },
}