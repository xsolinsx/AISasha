-- taken from jack-telegram-bot and translated to LUA
local function run(msg, matches)
    local url = "http://api.duckduckgo.com/?q=" .. URL.escape(matches[1]) .. "&format=json&pretty=1&no_html=1&skip_disambig=1"
    local jstr, res = https.request(url)
    if res ~= 200 then
        return langs.opsError
    end
    local jdat = JSON.decode(jstr)
    if not jdat.RelatedTopics[1] then
        return langs.opsError
    end
    local text = ""
    local i = 1
    for i, v in ipairs(jdat.RelatedTopics) do
        if jdat.RelatedTopics[i].Result and i <= 6 then
            url = jdat.RelatedTopics[i].FirstURL:gsub('_', '\\_')
            tit = jdat.RelatedTopics[i].Text
            text = text .. i .. ' - ' .. tit .. '\n' .. url .. '\n'
        end
    end
    return text
end

return {
    description = "DUCKDUCKGO",
    patterns =
    {
        "^[/!#][Dd][Uu][Cc][Kk][Gg][Oo] (.*)",
        "^[/!#][Dd][Uu][Cc][Kk][Dd][Uu][Cc][Kk][Gg][Oo] (.*)",
    },
    run = run,
    min_rank = 0
    -- usage
    -- #duck[duck]go <terms>:Sasha cerca <terms> su DuckDuckGo.
}