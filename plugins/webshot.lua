local helpers = require "OAuth.helpers"

local base = 'https://screenshotmachine.com/'
local url = base .. 'processor.php'

local function get_webshot_url(param, psize)
    local response_body = { }
    local request_constructor = {
        url = url,
        method = "GET",
        sink = ltn12.sink.table(response_body),
        headers =
        {
            referer = base,
            dnt = "1",
            origin = base,
            ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36"
        },
        redirect = false
    }

    local arguments = {
        urlparam = param,
        size = psize
    }

    request_constructor.url = url .. "?" .. helpers.url_encode_arguments(arguments)

    local ok, response_code, response_headers, response_status_line = https.request(request_constructor)
    if not ok or response_code ~= 200 then
        return nil
    end

    local response = table.concat(response_body)
    return string.match(response, "href='(.-)'")
end

local function run(msg, matches)
    if is_momod(msg) then
        local size = 'X'
        if matches[2] then
            if matches[2]:lower() == 'fmob' or matches[2]:lower() == 'f' then
                if is_admin1(msg) then
                    size = matches[2]
                else
                    return lang_text('require_admin')
                end
            else
                size = matches[2]
            end
        end
        local find = get_webshot_url(matches[1], size)
        if find then
            local imgurl = base .. find
            local receiver = get_receiver(msg)
            send_photo_from_url(receiver, imgurl)
        end
    else
        return lang_text('require_mod')
    end
end

return {
    description = "WEBSHOT",
    usage =
    {
        "MOD",
        "[#]|[sasha] webshot <url> [<size>]: Sasha fa uno screenshot del sito e lo manda, se <size> è specificato lo manda con quella dimensione altrimenti con dimensione X.",
        "La dimensione può essere:",
        "'T': (120 x 90px) - molto grande",
        "'S': (200 x 150px) - piccola",
        "'E': (320 x 240px) - seminormale",
        "'N': (400 x 300px) - normale",
        "'M': (640 x 480px) - media",
        "'L': (800 x 600px) - grande",
        "'X': (1024 x 768px) - molto grande",
        "'Nmob': (480 x 800px) - normale",
        "ADMIN",
        "'F': Pagina intera (può essere un processo molto lungo)",
        "'Fmob': Pagina intera (può essere un processo lungo)",
    },
    patterns =
    {
        "^[#!/][Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[#!/][Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+)$",
        "^[#!/][Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[#!/][Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([%w-_%.%?%.:/%+=&]+)$",
        -- webshot
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt][Tt][Aa] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt][Tt][Aa] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt][Tt][Aa] ([%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt][Tt][Aa] ([%w-_%.%?%.:/%+=&]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([Hh][Tt][Tt][Pp][Ss]?://[%w-_%.%?%.:/%+=&]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([%w-_%.%?%.:/%+=&]+) (.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ee][Bb][Ss][Hh][Oo][Tt] ([%w-_%.%?%.:/%+=&]+)$",
    },
    run = run,
    min_rank = 1
}