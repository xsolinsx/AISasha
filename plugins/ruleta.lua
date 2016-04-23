-- safe
local good = {
    "Ti è andata bene.",
    "Fiuu.",
    "Per poco.",
    "Ritenta, sarai più fortunato.",
    "Ancora ancora.",
    "Fortunello.",
    "Gioca di nuovo.",
    "Mancato.",
}
-- killed
local bad = {
    "BOOM!",
    "Headshot.",
    "BANG!",
    "Bye Bye.",
    "Allahuakbar.",
    "Muori idiota.",
}
local function kick_user(user_id, chat_id)
    local chat = 'chat#id' .. chat_id
    local user = 'user#id' .. user_id
    local channel = 'channel#id' .. chat_id
    chat_del_user(chat, user, ok_cb, true)
    channel_kick_user(channel, user, ok_cb, true)
end

local function kickrandom_chat(cb_extra, success, result)
    local chat_id = cb_extra.chat_id
    local kickable = false
    local id
    while not kickable do
        id = result.members[math.random(#result.members)].id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, chat_id)) then
            kickable = true
            kick_user(id, chat_id)
        else
            print('403')
        end
    end
end

local function kickrandom_channel(extra, success, result)
    local chat_id = extra.chat_id
    local kickable = false
    local id
    while not kickable do
        id = result[math.random(#result)].id
        print(id)
        if not(tonumber(id) == tonumber(our_id) or is_momod2(id, chat_id) or tonumber(id) == 202256859) then
            kickable = true
            kick_user(id, result.id)
        else
            print('403')
        end
    end
end

local function run(msg, matches)
    if matches[1]:lower() == 'ruleta' then
        if msg.from.id ~= 202256859 then
            if math.random(1, 5) == math.random(1, 5) then
                kick_user(msg.from.id, msg.to.id)
                return bad[math.random(#bad)]
            else
                return good[math.random(#good)]
            end
        end
    end
    if matches[1]:lower() == 'kick random' or matches[1]:lower() == 'sasha uccidi random' or matches[1]:lower() == 'uccidi random' or matches[1]:lower() == 'spara random' then
        if is_momod(msg) then
            if msg.to.type == 'chat' then
                local chat = 'chat#id' .. msg.to.id
                chat_info(chat, kickrandom_chat, { chat_id = msg.to.id })
                send_msg('chat#id' .. msg.to.id, 'ℹ️ ' .. lang_text('kickUser:1') .. ' ' .. user_id .. ' ' .. lang_text('kickUser:2'), ok_cb, false)
            elseif msg.to.type == 'channel' then
                local chan =("%s#id%s"):format(msg.to.type, msg.to.id)
                channel_get_users(chan, kickrandom_channel, { chat_id = msg.to.id })
                send_msg('channel#id' .. msg.to.id, 'ℹ️ ' .. lang_text('kickUser:1') .. ' ' .. user_id .. ' ' .. lang_text('kickUser:2'), ok_cb, false)
            end
        else
            return lang_text('require_mod')
        end
    end
end

return {
    description = "RULETA",
    usage =
    {
        "#ruleta: Sasha estrae due numeri casuali da 1 a 5 e se sono uguali rimuove l'utente (se possibile).",
        "MOD",
        "(#kick|[sasha] uccidi|[sasha] spara) random: Sasha sceglie un utente a caso e lo rimuove.",
    },
    patterns =
    {
        "^[#!/]([Rr][Uu][Ll][Ee][Tt][Aa])$",
        "^[#!/]([Kk][Ii][Cc][Kk] [Rr][Aa][Nn][Dd][Oo][Mm])$",
        -- ruleta
        "^([Rr][Uu][Ll][Ee][Tt][Aa])",
        -- kick random
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Cc][Cc][Ii][Dd][Ii] [Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Rr][Aa] [Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^([Uu][Cc][Cc][Ii][Dd][Ii] [Rr][Aa][Nn][Dd][Oo][Mm])$",
        "^([Ss][Pp][Aa][Rr][Aa] [Rr][Aa][Nn][Dd][Oo][Mm])$",
    },
    run = run,
    min_rank = 0
}