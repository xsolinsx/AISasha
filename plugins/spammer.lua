local function spam(chat_id, testo, i)
    local function messaggio()
        send_msg(chat_id, testo, ok_cb, false)
    end
    postpone(messaggio, false, i)
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    if is_owner(msg) then
        if matches[1]:lower() == 'setspam' then
            testo = matches[2]
            return lang_text('msgSet')
        elseif matches[1]:lower() == 'setmsgs' then
            num_msg = tonumber(matches[2])
            return lang_text('msgToSend') .. matches[2]
        elseif matches[1]:lower() == 'setwait' then
            time_msg = tonumber(matches[2])
            return string.gsub(lang_text('timeBetweenMsgs'), 'X', tostring(matches[2]))
        elseif matches[1]:lower() == 'spam' then
            local i = 0
            if testo then
                if num_msg == nil then
                    while i < 10 do
                        if time_msg == nil then
                            i = i + 0.5
                            spam(receiver, testo, i)
                        else
                            i = i + time_msg
                            spam(receiver, testo, i)
                        end
                    end
                else
                    while i <(num_msg /(0.5 / time_msg)) / 2 do
                        if time_msg == nil then
                            i = i + 1
                            spam(receiver, testo, i)
                        else
                            i = i + time_msg
                            spam(receiver, testo, i)
                        end
                    end
                end
            else
                return lang_text('msgNotSet')
            end
        end
    else
        return lang_text('require_owner')
    end
end

return {
    description = "SPAMMER",
    usage =
    {
        "/setspam <text>: Sasha spammerà <text>.",
        "/setmsgs <value>: Sasha spammerà per <value> messaggi.",
        "/setwait <value>: Sasha spammerà ogni <value> secondi.",
        "/spam|[sasha] spamma: Sasha inizierà lo spam.",
    },
    patterns =
    {
        "^[#!/]([Ss][Pp][Aa][Mm])",
        "^[#!/]([Ss][Ee][Tt][Ss][Pp][Aa][Mm]) (.+)",
        "^[#!/]([Ss][Ee][Tt][Mm][Ss][Gg][Ss]) (.+)",
        "^[#!/]([Ss][Ee][Tt][Ww][Aa][Ii][Tt]) (.+)",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa])$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa])$",
    },
    run = run
}


-- ORIGINAL SPAMMER
--[[local id_admin = 41400331

local function spam(chat_id, testo, i)
    local function messaggio()
        send_msg('chat#id' .. chat_id, testo, ok_cb, false)
    end
    postpone(messaggio, false, i)
end

local function adminid(user_id)
    local carica = load_data('spam.json')
    for k, v in pairs(carica) do
        if tostring(user_id) == v then
            val = 1
        end
    end
    if val == 1 then
        val = nil
        return true
    else
        return false
    end
end

local function run(msg, matches)
    if msg.from.id == id_admin or adminid(msg.from.id) then
        if matches[1]:lower() == 'setspam' then
            testo = matches[2]
            return 'Spam settato.'
        elseif matches[1]:lower() == 'setmsg' then
            num_msg = tonumber(matches[2])
            return 'Messaggi settati: ' .. matches[2]
        elseif matches[1]:lower() == 'setwait' then
            time_msg = tonumber(matches[2])
            return 'Tempo tra ogni messaggio: ' .. matches[2]
        elseif msg.to.type == 'chat' and matches[1]:lower() == 'spam' then
            local i = 0
            if testo then
                if num_msg == nil then
                    while i < 10 do
                        if time_msg == nil then
                            i = i + 0.5
                            spam(msg.to.id, testo, i)
                        else
                            i = i + time_msg
                            spam(msg.to.id, testo, i)
                        end
                    end
                else
                    while i <(num_msg /(0.5 / time_msg)) / 2 do
                        if time_msg == nil then
                            i = i + 1
                            spam(msg.to.id, testo, i)
                        else
                            i = i + time_msg
                            spam(msg.to.id, testo, i)
                        end
                    end
                end
            else
                return 'Non hai settato il messaggio, usa /setspam'
            end
        elseif matches[1]:lower() == 'setid' then
            local carica = load_data('spam.json')
            local matches = tostring(matches[2])
            if carica[matches] == matches then
                carica[matches] = 'eliminato'
                save_data('spam.json', carica)
                return 'Id eliminato dalla lista admin.'
            else
                carica[matches] = matches
                save_data('spam.json', carica)
                return 'Id aggiunto alla lista admin.'
            end
        end
    end
end

return {
    description = "Mostra versione",
    usage = ">version: Mostra versione",
    patterns =
    {
        "^/([Ss]pam)",
        "^/([Ss]et[Ss]pam) (.+)",
        "^/([Ss]et[Mm]sg) (.+)",
        "^/([Ss]et[Ww]ait) (.+)",
        "^/([Ss]et[Ii]d) (%d+)"
    },
    run = run
}]]