local function spam(chat, text, i)
    local function message()
        send_msg(chat, text, ok_cb, false)
    end
    postpone(message, false, i)
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    if is_owner(msg) then
        if matches[2] then
            if matches[1]:lower() == 'setspam' then
                text = matches[2]
                return lang_text('msgSet')
            elseif matches[1]:lower() == 'setmsgs' and tonumber(matches[2]) then
                num_msg = tonumber(matches[2])
                return lang_text('msgsToSend') .. tostring(num_msg)
            elseif matches[1]:lower() == 'setwait' and tonumber(matches[2]) then
                time_msg = tonumber(matches[2])
                return string.gsub(lang_text('timeBetweenMsgs'), 'X', tostring(time_msg))
            end
        elseif matches[1]:lower() == 'spam' or matches[1]:lower() == 'sasha spamma' or matches[1]:lower() == 'spamma' then
            local i = 0
            if text then
                if num_msg == "nil" then
                    while i < 10 do
                        if time_msg == "nil" then
                            i = i + 0.5
                            spam(receiver, text, i)
                        else
                            i = i + time_msg
                            spam(receiver, text, i)
                        end
                    end
                else
                    while i <(num_msg /(0.5 / time_msg)) / 2 do
                        if time_msg == "nil" then
                            i = i + 1
                            spam(receiver, text, i)
                        else
                            i = i + time_msg
                            spam(receiver, text, i)
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
        "/setspam <text>: Sasha imposta <text> come messaggio da spammare.",
        "/setmsgs <value>: Sasha imposta <value> come numero di messaggi da spammare.",
        "/setwait <seconds>: Sasha imposta <seconds> come intervallo di tempo tra i messaggi.",
        "/spam|[sasha] spamma: Sasha inizia a spammare.",
    },
    patterns =
    {
        "^[#!/]([Ss][Pp][Aa][Mm])$",
        "^[#!/]([Ss][Ee][Tt][Ss][Pp][Aa][Mm]) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ss][Gg][Ss]) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Ww][Aa][Ii][Tt]) (.+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa])$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa])$",
    },
    run = run
}