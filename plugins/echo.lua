local function run(msg, matches)
    if is_momod(msg) then
        local text = matches[1]
        return text
    end
end

return {
    description = "ECHO",
    patterns =
    {
        "^[#!/][Ee][Cc][Hh][Oo] +(.+)$",
        -- echo
        "^[Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Pp][Ee][Tt][Ii] +(.+)$",
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- (#echo|sasha ripeti) <text>
}
