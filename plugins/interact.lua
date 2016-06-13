-- how are you?
local comeva = {
    "Benissimo sto mangiando lamponi :3",
    "Bene tesoro tu?",
    "Mi sento un po' bipolare",
    "Non mi sento tanto bene",
    "Levati",
    "Oggi non va",
    "Non voglio parlarne",
}
-- no
local nosasha = {
    "Ma anche no",
    "Non provarci nemmeno",
    "Sognatelo",
    "No",
    "No ti prego",
    "No solo perchè sei te",
    "Ovvio che no",
    "Ma no dai",
    "Assolutamente no",
    "Direi di no",
    "Per me è no",
}
-- i don't know
local bohsasha = {
    "Decidi tu",
    "Non lo so",
    "Mah",
    "Dipende da te",
    "Lascio a te la scelta",
    "Forse",
    "Se ne sei convinto",
    "Vedi te",
}
-- yes
local sisasha = {
    "Siiiiiii",
    "Yeee",
    "Awww :3",
    "😍😍😍",
    "E perchè no?",
    "Si",
    "Si ti prego",
    "Si solo perchè sei te",
    "Ovvio che si",
    "Massì dai",
    "Assolutamente si",
    "Direi di si",
    "Per me è si",
}
-- i love you
local tiamo = {
    "Awww :3",
    "Caroo grazie",
    "Owww :3",
    "Anche io ti voglio bene ❤️",
    "Ti vedo più come un utente",
}

local function run(msg, matches)
    if (matches[1]:lower() == 'echo' or matches[1]:lower() == 'sasha ripeti') and matches[2] then
        if is_momod(msg) then
            if type(msg.reply_id) ~= "nil" then
                reply_msg(msg.reply_id, matches[2], ok_cb, false)
            else
                return matches[2]
            end
        else
            return lang_text('require_mod')
        end
    end
    -- interact
    if matches[1]:lower() == 'sasha come va?' then
        reply_msg(msg.id, comeva[math.random(#comeva)], ok_cb, false)
    end
    if matches[1]:lower() == 'sasha' and string.match(matches[2], '.*%?') then
        local rnd = math.random(0, 2)
        if rnd == 0 then
            reply_msg(msg.id, nosasha[math.random(#nosasha)], ok_cb, false)
        elseif rnd == 1 then
            reply_msg(msg.id, bohsasha[math.random(#bohsasha)], ok_cb, false)
        elseif rnd == 2 then
            reply_msg(msg.id, sisasha[math.random(#sisasha)], ok_cb, false)
        end
    end
    if matches[1]:lower() == 'sasha ti amo' or matches[1]:lower() == 'ti amo sasha' then
        reply_msg(msg.id, tiamo[math.random(#tiamo)], ok_cb, false)
    end
    -- words
    if matches[1]:lower() == 'gangbang' then
        reply_msg(msg.id, ".    👇🏿\n👉🏾👌🏻👈🏾\n      👆🏿", ok_cb, false)
    end
    if matches[1]:lower() == 'maometto' or matches[1]:lower() == 'maometo' or matches[1]:lower() == 'cancaroman' then
        reply_msg(msg.id, "D\n  I\n    O\n     o\n     o\n      o\n     o\n     。\n    。\n   .\n   .\n    .\n    .\nC \nA\n  N\n    C\n  A\n    R\n      o\n       o\n      o\n     。\n    。\n   .\n   .\n    .\n    .\n🚴", ok_cb, false)
    end
    if matches[1]:lower() == 'mohammed' then
        reply_msg(msg.id, "☁️☀️    ☁️         ☁️  ☁️\n       ☁️                🚁   ☁️\n\n_🌵_🌻________🌵_____\n                 /  |   \\\n        🌴  / 🚔    \\ 🌴\n             /      |       \\\n    🌴   /      🚔      \\ 🌴\n         /          |    🚔  \\\n⛽️  /  🚔     |   🚔     \\ 🌴\n     /            🚔             \\ 🌴\n   /                |                \\\n /                  |        👳🏿      \\\n", ok_cb, false)
    end
    if matches[1]:lower() == 'nazismo' or matches[1]:lower() == 'nazista' or matches[1]:lower() == 'hitler' then
        reply_msg(msg.id, "❤️❤️❤️❤️❤️❤️❤️❤️❤️\n❤️⚫️❤️❤️⚫️⚫️⚫️⚫️❤️\n❤️⚫️❤️❤️⚫️❤️❤️❤️❤️\n❤️⚫️❤️❤️⚫️❤️❤️❤️❤️\n❤️⚫️⚫️⚫️⚫️⚫️⚫️⚫️❤️\n❤️❤️❤️❤️⚫️❤️❤️⚫️❤️\n❤️❤️❤️❤️⚫️❤️❤️⚫️❤️\n❤️⚫️⚫️⚫️⚫️❤️❤️⚫️❤️\n❤️❤️❤️❤️❤️❤️❤️❤️❤️", ok_cb, false)
    end
end

return {
    description = "INTERACT",
    patterns =
    {
        "^[#!/]([Ee][Cc][Hh][Oo]) +(.+)$",
        -- echo
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ii][Pp][Ee][Tt][Ii]) +(.+)$",
        -- react
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Oo][Mm][Ee] [Vv][Aa]%?)$",
        "^([Ss][Aa][Ss][Hh][Aa])(.*%?)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Tt][Ii] [Aa][Mm][Oo])$",
        "^([Tt][Ii] [Aa][Mm][Oo] [Ss][Aa][Ss][Hh][Aa])$",
        -- words
        "([Gg][Aa][Nn][Gg][Bb][Aa][Nn][Gg])",
        "([Mm][Aa][Oo][Mm][Ee][Tt][Tt][Oo])",
        "([Mm][Aa][Oo][Mm][Ee][Tt][Oo])",
        "([Cc][Aa][Nn][Cc][Aa][Rr][Oo][Mm][Aa][Nn])",
        "([Mm][Oo][Hh][Aa][Mm][Mm][Ee][Dd])",
        "([Nn][Aa][Zz][Ii][Ss][Mm][Oo])",
        "([Nn][Aa][Zz][Ii][Ss][Tt][Aa])",
        "([Hh][Ii][Tt][Ll][Ee][Rr])",
    },
    run = run,
    min_rank = 0
}
-- usage
-- MOD
-- (#echo|sasha ripeti) <text>