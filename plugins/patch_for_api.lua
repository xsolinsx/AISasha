local function run(msg, matches)
    if is_owner(msg) then
        if matches[1]:lower() == 'enable' then
            redis:sadd('apipatch', msg.to.id)
            return langs[msg.lang].groupPatched
        end
        if matches[1]:lower() == 'disable' then
            redis:srem('apipatch', msg.to.id)
            return langs[msg.lang].groupUnpatched
        end
    else
        return langs[msg.lang].require_owner
    end
end

return {
    description = "PATCH_FOR_API",
    patterns =
    {
        "^[#!/][Aa][Pp][Ii][Pp][Aa][Tt][Cc][Hh] ([Dd][Ii][Ss][Aa][Bb][Ll][Ee])$",
        "^[#!/][Aa][Pp][Ii][Pp][Aa][Tt][Cc][Hh] ([Ee][Nn][Aa][Bb][Ll][Ee])$",
    },
    run = run,
    min_rank = 3,
    syntax =
    {
        "OWNER",
        "#apipatch (disable|enable)",
    },
}