function run(msg, matches)
    local receiver = get_receiver(msg)
    local caption = ''
    local specdate = '*'

    local url = 'https://api.nasa.gov/planetary/apod?api_key=' .. 'DEMO_KEY'

    if matches[2] then
        url = url .. '&date=' .. URL.escape(matches[2])
        specdate = specdate .. matches[2]
    else
        specdate = specdate .. os.date("%F")
    end

    specdate = specdate .. '*\n'

    local jstr, res = https.request(url)
    if res ~= 200 then
        return langs[msg.lang].opsError
    end

    local jdat = json:decode(jstr)

    if jdat.error then
        return langs[msg.lang].opsError
    end

    local img_url = jdat.url

    if matches[1]:lower() == "apodhd" or matches[1]:lower() == "astrohd" then
        img_url = jdat.hdurl or jdat.url
    end

    local str = specdate .. '[' .. jdat.title .. '](' .. img_url .. ')'

    if matches[1]:lower() == "apodtext" or matches[1]:lower() == "astrotext" then
        str = str .. '\n' .. jdat.explanation
        return str
    else
        send_photo_from_url(receiver, img_url)
    end
end

return {
    description = "APOD",
    patterns =
    {
        "^[#!/]([Aa][Pp][Oo][Dd])$",
        "^[#!/]([Aa][Pp][Oo][Dd]) (%d%d%d%d%-%d%d%-%d%d)$",
        "^[#!/]([Aa][Pp][Oo][Dd][Hh][Dd])$",
        "^[#!/]([Aa][Pp][Oo][Dd][Hh][Dd]) (%d%d%d%d%-%d%d%-%d%d)$",
        "^[#!/]([Aa][Pp][Oo][Dd][Tt][Ee][Xx][Tt])$",
        "^[#!/]([Aa][Pp][Oo][Dd][Tt][Ee][Xx][Tt]) (%d%d%d%d%-%d%d%-%d%d)$",
        -- apod
        "^[#!/]([Aa][Ss][Tt][Rr][Oo])$",
        "^[#!/]([Aa][Ss][Tt][Rr][Oo]) (%d%d%d%d%-%d%d%-%d%d)$",
        -- apodhd
        "^[#!/]([Aa][Ss][Tt][Rr][Oo][Hh][Dd])$",
        "^[#!/]([Aa][Ss][Tt][Rr][Oo][Hh][Dd]) (%d%d%d%d%-%d%d%-%d%d)$",
        -- apodtext
        "^[#!/]([Aa][Ss][Tt][Rr][Oo][Tt][Ee][Xx][Tt])$",
        "^[#!/]([Aa][Ss][Tt][Rr][Oo][Tt][Ee][Xx][Tt]) (%d%d%d%d%-%d%d%-%d%d)$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#(apod|astro) [<date>]",
        "#(apod|astro)hd [<date>]",
        "#(apod|astro)text [<date>]",
    },
}