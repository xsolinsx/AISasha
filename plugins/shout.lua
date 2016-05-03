local function run(msg, matches)
    matches[1] = matches[1]:trim()

    if matches[1]:len() > 20 then
        matches[1] = matches[1]:sub(1, 20)
    end

    matches[1] = matches[1]:upper()
    local res = ''
    local inc = 0
    for mtch in matches[1]:gmatch('.') do
        res = res .. mtch .. ' '
    end
    res = res .. '\n'
    for mtch in matches[1]:sub(2):gmatch('.') do
        local spacing = ''
        for i = 1, inc do
            spacing = spacing .. '  '
        end
        inc = inc + 1
        res = res .. mtch .. ' ' .. spacing .. mtch .. '\n'
    end
    res = res:trim()
    return res
end

return {
    description = "SHOUT",
    usage = "(#shout|[sasha] grida|[sasha] urla) <text>: Sasha \"urla\" <text>.",
    patterns =
    {
        "^[#!/][Ss][Hh][Oo][Uu][Tt] (.*)$",
        -- shout
        "^[Ss][Aa][Ss][Hh][Aa] [Gg][Rr][Ii][Dd][Aa] (.*)$",
        "^[Ss][Aa][Ss][Hh][Aa] [Uu][Rr][Ll][Aa] (.*)$",
        "^[Gg][Rr][Ii][Dd][Aa] (.*)$",
        "^[Uu][Rr][Ll][Aa] (.*)$",
    },
    run = run,
    min_rank = 0
}