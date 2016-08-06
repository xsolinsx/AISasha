local function run(msg, matches)
    if is_sudo(msg) then
        return loadstring('return ' .. matches[1])()
    end
end

return {
    description = "LUA_EXEC",
    patterns =
    {
        "^[#!/][Ll][Uu][Aa] (.*)",
    },
    run = run,
    min_rank = 5
    -- usage
    -- SUDO
    -- #lua <command>
}