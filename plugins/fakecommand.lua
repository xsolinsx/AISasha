-- no "SUDO" because there's no rank higher than "SUDO" (yes there's "BOT" but it's not a real rank)
-- "USER" can't use this because there's no rank lower than "USER"
local function run(msg, matches)
    if is_momod(msg) then
        local rank = get_rank(msg.from.id, msg.to.id)
        local fakerank = rank_table[matches[1]:upper()]
        print(rank, fakerank)
        if fakerank <= rank then
            -- yes
            -- remove "[#!/]<rank> " from message so it's like a normal message
            msg.text = msg.text:gsub('#' .. matches[1] .. ' ', '')
            msg.text = msg.text:gsub('!' .. matches[1] .. ' ', '')
            msg.text = msg.text:gsub('/' .. matches[1] .. ' ', '')
            -- replace the id of the executer with a '-' followed by the rank value so when it's checked with (i.e.) is_momod(msg) bot knows it's a fakecommand
            msg.from.id = - rank_table[matches[1]:upper()]
            match_plugins(msg)
        else
            -- no
            return langs[msg.lang].fakecommandYouTried
        end
    else
        return langs[msg.lang].require_mod
    end
end

return {
    description = "FAKECOMMAND",
    patterns =
    {
        "^[#!/]([Uu][Ss][Ee][Rr]) (.*)",
        "^[#!/]([Mm][Oo][Dd]) (.*)",
        "^[#!/]([Oo][Ww][Nn][Ee][Rr]) (.*)",
        "^[#!/]([Ss][Uu][Pp][Pp][Oo][Rr][Tt]) (.*)",
        "^[#!/]([Aa][Dd][Mm][Ii][Nn]) (.*)",
    },
    run = run,
    min_rank = 1
    -- usage
    -- (#user|#mod|#owner|#support|#admin) <command>
}