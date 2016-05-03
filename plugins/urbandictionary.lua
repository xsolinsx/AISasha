function run(msg, matches)
    local term = matches[1]
    if msg.reply_to_message and msg.reply_to_message.text then
        term = msg.reply_to_message.text
    end

    local url = 'http://api.urbandictionary.com/v0/define?term=' .. URL.escape(term)

    local jstr, res = http.request(url)
    if res ~= 200 then
        return lang_text('it:' .. 'opsError')
    end

    local jdat = JSON.decode(jstr)
    if jdat.result_type == "no_results" then
        return lang_text('it:' .. 'opsError')
    end

    local res = '*' .. jdat.list[1].word .. '*\n\n' .. jdat.list[1].definition:trim()
    if string.len(jdat.list[1].example) > 0 then
        res = res .. '_\n\n' .. jdat.list[1].example:trim() .. '_'
    end

    res = res:gsub('%[', ''):gsub('%]', '')

    return res
end

return {
    description = 'URBANDICTIONARY',
    usage = "(#urbandictionary|#urban|#ud|[sasha] urban|[sasha] ud) <text>: Sasha mostra la definizione di <text> dall'Urban Dictionary.",
    patterns =
    {
        "^[#!/][Uu][Rr][Bb][Aa][Nn][Dd][Ii][Cc][Tt][Ii][Oo][Nn][Aa][Rr][Yy] (.+)$",
        "^[#!/][Uu][Rr][Bb][Aa][Nn] (.+)$",
        "^[#!/][Uu][Dd] (.+)$",
        -- urban dictionary
        "^[Ss][Aa][Ss][Hh][Aa] [Uu][Rr][Bb][Aa][Nn] (.+)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Uu][Dd] (.+)$",
    },
    run = run,
    min_rank = 0
}