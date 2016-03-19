-- http://git.io/vUA4M
local socket = require "socket"
local JSON = require "cjson"

local Wikipedia = {
    -- http://meta.wikimedia.org/wiki/List_of_Wikipedias
    wiki_server = "https://%s.wikipedia.org",
    wiki_path = "/w/api.php",
    wiki_load_params =
    {
        action = "query",
        prop = "extracts",
        format = "json",
        exchars = 300,
        exsectionformat = "plain",
        explaintext = "",
        redirects = ""
    },
    wiki_search_params =
    {
        action = "query",
        list = "search",
        srlimit = 20,
        format = "json",
    },
    default_lang = "it",
}

function Wikipedia:getWikiServer(lang)
    return string.format(self.wiki_server, lang or self.default_lang)
end

--[[
--  return decoded JSON table from Wikipedia
--]]
function Wikipedia:loadPage(text, lang, intro, plain, is_search)
    local request, sink = { }, { }
    local query = ""
    local parsed

    if is_search then
        for k, v in pairs(self.wiki_search_params) do
            query = query .. k .. '=' .. v .. '&'
        end
        parsed = URL.parse(self:getWikiServer(lang))
        parsed.path = self.wiki_path
        parsed.query = query .. "srsearch=" .. URL.escape(text)
    else
        self.wiki_load_params.explaintext = plain and "" or nil
        for k, v in pairs(self.wiki_load_params) do
            query = query .. k .. '=' .. v .. '&'
        end
        parsed = URL.parse(self:getWikiServer(lang))
        parsed.path = self.wiki_path
        parsed.query = query .. "titles=" .. URL.escape(text)
    end

    -- HTTP request
    request['url'] = URL.build(parsed)
    print(request['url'])
    request['method'] = 'GET'
    request['sink'] = ltn12.sink.table(sink)

    local httpRequest = parsed.scheme == 'http' and http.request or https.request
    local code, headers, status = socket.skip(1, httpRequest(request))

    if not headers or not sink then
        return nil
    end

    local content = table.concat(sink)
    if content ~= "" then
        local ok, result = pcall(JSON.decode, content)
        if ok and result then
            return result
        else
            return nil
        end
    else
        return nil
    end
end

-- extract intro passage in wiki page
function Wikipedia:wikintro(text, lang)
    local result = self:loadPage(text, lang, true, true)

    if result and result.query then

        local query = result.query
        if query and query.normalized then
            text = query.normalized[1].to or text
        end

        local page = query.pages[next(query.pages)]

        if page and page.extract then
            return text .. ": " .. page.extract
        else
            return lang_text('extractNotFound')
        end
    else
        return lang_text('opsError')
    end
end

-- search for term in wiki
function Wikipedia:wikisearch(text, lang)
    local result = self:loadPage(text, lang, true, true, true)

    if result and result.query then
        local titles = ""
        for i, item in pairs(result.query.search) do
            titles = titles .. "\n" .. item["title"]
        end
        titles = titles ~= "" and titles or lang_text('noResult')
        return titles
    else
        return lang_text('opsError')
    end

end

local function run(msg, matches)
    -- TODO: Remember language (i18 on future version)
    -- TODO: Support for non Wikipedias but Mediawikis
    local search, term, lang
    if matches[1] and matches[1]:lower() == "search" then
        search = true
        term = matches[2]
        lang = nil
    elseif matches[2] and matches[2]:lower() == "search" then
        search = true
        term = matches[3]
        lang = matches[1]
    else
        term = matches[2]
        lang = matches[1]
    end
    if not term then
        term = lang
        lang = nil
    end

    local result
    if search then
        result = Wikipedia:wikisearch(term, lang)
    else
        -- TODO: Show the link
        result = Wikipedia:wikintro(term, lang)
    end
    return result
end

return {
    description = "WIKI",
    usage =
    {
        "[/]|[sasha] wiki[lang] <text>: Sasha manda un estratto da [lang] Wikipedia. Esempio: !wiki[it] ciao",
        "[/]|[sasha] wiki[lang] search <text>: Sasha cerca gli articoli su [lang] Wikipedia. Esempio: !wiki[it] search ciao",
    },
    patterns =
    {
        "^[#!/][Ww][Ii][Kk][Ii](%w+) ([Ss][Ee][Aa][Rr][Cc][Hh]) (.+)$",
        "^[#!/][Ww][Ii][Kk][Ii] ([Ss][Ee][Aa][Rr][Cc][Hh]) ?(.*)$",
        "^[#!/][Ww][Ii][Kk][Ii](%w+) (.+)$",
        "^[#!/][Ww][Ii][Kk][Ii] ?(.*)$",
        -- wiki
        "^[Ww][Ii][Kk][Ii](%w+) ([Ss][Ee][Aa][Rr][Cc][Hh]) (.+)$",
        "^[Ww][Ii][Kk][Ii] ([Ss][Ee][Aa][Rr][Cc][Hh]) ?(.*)$",
        "^[Ww][Ii][Kk][Ii](%w+) (.+)$",
        "^[Ww][Ii][Kk][Ii] ?(.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ii][Kk][Ii](%w+) ([Ss][Ee][Aa][Rr][Cc][Hh]) (.+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ii][Kk][Ii] ([Ss][Ee][Aa][Rr][Cc][Hh]) ?(.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ii][Kk][Ii](%w+) (.+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ww][Ii][Kk][Ii] ?(.*)$",
    },
    run = run
}