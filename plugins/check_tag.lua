local function callback_sudo_ids(extra, success, result)
    -- check if username is in message
    local tagged = false
    if result.username then
        if extra.msg.text then
            if string.find(extra.msg.text:lower(), '@' .. result.username:lower()) or string.find(extra.msg.text, result.first_name) then
                tagged = true
            end
        end
        if extra.msg.media then
            if extra.msg.media.title then
                if string.find(extra.msg.media.title:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.title, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.description then
                if string.find(extra.msg.media.description:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.description, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.caption then
                if string.find(extra.msg.media.caption:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.caption, result.first_name) then
                    tagged = true
                end
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                if string.find(extra.msg.fwd_from.title:lower(), '@' .. result.username:lower()) or string.find(extra.msg.fwd_from.title, result.first_name) then
                    tagged = true
                end
            end
        end
    else
        if extra.msg.text then
            if string.find(extra.msg.text, result.first_name) then
                tagged = true
            end
        end
        if extra.msg.media then
            if extra.msg.media.title then
                if string.find(extra.msg.media.title, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.description then
                if string.find(extra.msg.media.description, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.caption then
                if string.find(extra.msg.media.caption, result.first_name) then
                    tagged = true
                end
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                if string.find(extra.msg.fwd_from.title, result.first_name) then
                    tagged = true
                end
            end
        end
    end
    if tagged then
        if msg.reply_id then
            fwd_msg('user#id' .. extra.user, msg.reply_id, ok_cb, false)
        end
        local text = langs[extra.msg.lang].receiver .. extra.msg.to.print_name:gsub("_", " ") .. ' [' .. extra.msg.to.id .. ']\n' .. langs[extra.msg.lang].sender
        if extra.msg.from.username then
            text = text .. '@' .. extra.msg.from.username .. ' [' .. extra.msg.from.id .. ']\n'
        else
            text = text .. extra.msg.from.print_name:gsub("_", " ") .. ' [' .. extra.msg.from.id .. ']\n'
        end
        text = text .. langs[extra.msg.lang].msgText

        if extra.msg.text then
            text = text .. extra.msg.text .. ' '
        end
        if extra.msg.media then
            if extra.msg.media.title then
                text = text .. extra.msg.media.title
            end
            if extra.msg.media.description then
                text = text .. extra.msg.media.description
            end
            if extra.msg.media.caption then
                text = text .. extra.msg.media.caption
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                text = text .. extra.msg.fwd_from.title
            end
        end
        send_large_msg('user#id' .. extra.user, text)
    end
end

-- send message to sudoers when tagged
local function pre_process(msg)
    if msg then
        -- exclude private chats with bot
        if (msg.to.type == 'chat' or msg.to.type == 'channel') then
            for v, user in pairs(_config.sudo_users) do
                -- exclude bot tags, autotags and tags of API version
                if tonumber(msg.from.id) ~= tonumber(our_id) and tonumber(msg.from.id) ~= tonumber(user) and tonumber(msg.from.id) ~= 202256859 then
                    user_info('user#id' .. user, callback_sudo_ids, { msg = msg, user = user })
                end
            end
        end
    end
    return msg
end

return {
    description = "CHECK_TAG",
    patterns = { },
    pre_process = pre_process,
    min_rank = 5
}