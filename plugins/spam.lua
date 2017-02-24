local function send_spam(receiver, text, i)
    local function message()
        send_large_msg(receiver, text)
    end
    postpone(message, false, i)
end

local function forward_spam(receiver, message_id, i)
    local function fwd_message()
        fwd_msg(receiver, message_id, ok_cb, false)
    end
    postpone(fwd_message, false, i)
end

local function cycle_spam(receiver, text, messages, time_between_messages)
    local i = 0
    while i <(tonumber(messages or 5) /(0.5 / tonumber(time_between_messages or 2))) / 2 do
        i = i + tonumber(time_between_messages or 2)
        send_spam(receiver, text, i)
    end
end

local function cycle_spam_forward(receiver, message_to_forward, messages, time_between_messages)
    local i = 0
    while i <(tonumber(messages or 5) /(0.5 / tonumber(time_between_messages or 2))) / 2 do
        i = i + tonumber(time_between_messages or 2)
        forward_spam(receiver, message_to_forward, i)
    end
end

local function run(msg, matches)
    if matches[1]:lower() == 'spam' or matches[1]:lower() == 'sasha spamma' or matches[1]:lower() == 'spamma' then
        if is_owner(msg) then
            if type(msg.reply_id) ~= "nil" then
                if matches[2] and matches[3] then
                    cycle_spam_forward(get_receiver(msg), msg.reply_id, matches[2], matches[3])
                else
                    cycle_spam_forward(get_receiver(msg), msg.reply_id)
                end
            else
                if matches[3] and matches[4] then
                    cycle_spam(get_receiver(msg), matches[4], matches[2], matches[3])
                else
                    cycle_spam(get_receiver(msg), matches[2])
                end
            end
        else
            return langs[msg.lang].require_owner
        end
    end
end

return {
    description = "SPAM",
    patterns =
    {
        -- specified values
        "^[#!/]([Ss][Pp][Aa][Mm]) (%d+) (%d+) (.+)$",
        -- reply specified values
        "^[#!/]([Ss][Pp][Aa][Mm]) (%d+) (%d+)$",
        -- default values
        "^[#!/]([Ss][Pp][Aa][Mm]) (.+)$",
        -- reply default values
        "^[#!/]([Ss][Pp][Aa][Mm])$",
        -- spam
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+) (.+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa]) (.+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Pp][Aa][Mm][Mm][Aa])$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+) (.+)$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa]) (%d+) (%d+)$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa]) (.+)$",
        "^([Ss][Pp][Aa][Mm][Mm][Aa])$",
    },
    run = run,
    min_rank = 2,
    syntax =
    {
        "OWNER",
        "(#spam|[sasha] spamma) [<messages> <seconds>] <reply>|<text>",
    },
}