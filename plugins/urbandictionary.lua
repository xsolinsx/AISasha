function run(msg, matches)
    if not msg.api_patch then
        local term = matches[1]
        local url = 'http://api.urbandictionary.com/v0/define?term=' .. URL.escape(term)

        local jstr, res = http.request(url)
        if res ~= 200 then
            return langs[msg.lang].opsError
        end

        local jdat = JSON.decode(jstr)
        if jdat.result_type == "no_results" then
            return langs[msg.lang].opsError
        end

        local res = '*' .. jdat.list[1].word .. '*\n\n' .. jdat.list[1].definition:trim()
        if string.len(jdat.list[1].example) > 0 then
            res = res .. '_\n\n' .. jdat.list[1].example:trim() .. '_'
        end

        res = res:gsub('%[', ''):gsub('%]', '')

        return res
    end
end

return {
    description = 'URBANDICTIONARY',
    patterns =
    {
        "^[#!/][Uu][Rr][Bb][Aa][Nn][Dd][Ii][Cc][Tt][Ii][Oo][Nn][Aa][Rr][Yy] (.+)$",
        "^[#!/][Uu][Rr][Bb][Aa][Nn] (.+)$",
        "^[#!/][Uu][Dd] (.+)$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "(#urbandictionary|#urban|#ud) <text>",
    },
}