-- no "SUDO" because there's no rank higher than "SUDO" (yes there's "BOT" but it's not a real rank)
-- "USER" can't use this because there's no rank lower than "USER"
local function run(msg, matches)
    if not msg.api_patch then
        if is_momod(msg) then
            local rank = get_rank(msg.from.id, msg.to.id)
            local fakerank = rank_table[matches[1]:upper()]
            print(rank, fakerank)
            if fakerank <= rank then
                -- yes
                -- remove "[#!/]<rank> " from message so it's like a normal message
                local copied_msg = clone_table(msg)
                copied_msg.text = copied_msg.text:gsub('#' .. matches[1] .. ' ', '')
                copied_msg.text = copied_msg.text:gsub('!' .. matches[1] .. ' ', '')
                copied_msg.text = copied_msg.text:gsub('/' .. matches[1] .. ' ', '')
                -- replace the id of the executer with a '-' followed by the rank value so when it's checked with (i.e.) is_momod(msg) bot knows it's a fakecommand
                copied_msg.from.id = - rank_table[matches[1]:upper()]
                match_plugins(copied_msg)
            else
                -- no
                return langs[msg.lang].fakecommandYouTried
            end
        else
            return langs[msg.lang].require_mod
        end
    end
end

return {
    description = "FAKECOMMAND",
    patterns =
    {
        "^[#!/]([Uu][Ss][Ee][Rr]) (.*)",
        "^[#!/]([Mm][Oo][Dd]) (.*)",
        "^[#!/]([Oo][Ww][Nn][Ee][Rr]) (.*)",
        "^[#!/]([Aa][Dd][Mm][Ii][Nn]) (.*)",
    },
    run = run,
    min_rank = 1,
    syntax =
    {
        "MOD",
        "(#user|#mod|#owner|#admin) <command>",
    },
}