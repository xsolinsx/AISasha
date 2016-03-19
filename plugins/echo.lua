local function run(msg, matches)
    local text = matches[1]
    return text
end

return {
    description = "ECHO",
    usage = "(/echo|sasha ripeti) <text>: Sasha ripete il testo specificato.",
    patterns =
    {
        "^[#!/][Ee][Cc][Hh][Oo] +(.+)$",
        -- echo
        "^[Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Pp][Ee][Tt][Ii] +(.+)$",
    },
    run = run
}
