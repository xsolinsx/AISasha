local function run(msg, matches)
    if not msg.api_patch then
        if is_sudo(msg) then
            return loadstring(matches[1])()
        else
            return langs[msg.lang].require_sudo
        end
    end
end

return {
    description = "LUA_EXEC",
    patterns =
    {
        "^[#!/][Ll][Uu][Aa] (.*)",
    },
    run = run,
    min_rank = 5,
    syntax =
    {
        "SUDO",
        "#lua <command>",
    },
}