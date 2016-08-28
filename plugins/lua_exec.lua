local function run(msg, matches)
    if is_sudo(msg) then
        return loadstring(matches[1])()
    else
        return langs[msg.lang].require_sudo
    end
end

return {
    description = "LUA_EXEC",
    patterns =
    {
        "^[#!/][Ll][Uu][Aa] (.*)",
    },
    run = run,
    min_rank = 4,
    syntax =
    {
        "SUDO",
        "#lua <command>",
    },
}