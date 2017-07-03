local function get_variables_hash(msg, global)
    if global then
        if not redis:get(msg.to.id .. ':gvariables') then
            return 'gvariables'
        end
        return false
    else
        if msg.to.type == 'user' then
            return 'user:' .. msg.from.id .. ':variables'
        end
        if msg.to.type == 'chat' then
            return 'chat:' .. msg.to.id .. ':variables'
        end
        if msg.to.type == 'channel' then
            return 'channel:' .. msg.to.id .. ':variables'
        end
        return false
    end
end

local function list_variables(msg, global)
    local hash = nil
    if global then
        hash = get_variables_hash(msg, true)
    else
        hash = get_variables_hash(msg, false)
    end

    if hash then
        local names = redis:hkeys(hash)
        local text = ''
        for i = 1, #names do
            text = text .. names[i]:gsub('_', ' ') .. '\n'
        end
        return text
    end
end

local function get_value(msg, var_name)
    var_name = var_name:gsub(' ', '_')
    if not redis:get(msg.to.id .. ':gvariables') then
        local hash = get_variables_hash(msg, true)
        if hash then
            local value = redis:hget(hash, var_name)
            if value then
                return value
            end
        end
    end

    local hash = get_variables_hash(msg, false)
    if hash then
        local value = redis:hget(hash, var_name)
        if value then
            return value
        end
    end
end

local function get_rules(chat_id)
    local lang = get_lang(chat_id)
    if not data[tostring(chat_id)]['rules'] then
        return langs[lang].noRules
    end
    local rules = data[tostring(chat_id)]['rules']
    return rules
end

local function adjust_value_reply(extra, success, result)
    local value = extra.value
    local chat = extra.to
    local user = extra.from
    local lang = get_lang(string.match(extra.receiver, '%d+'))

    value = adjust_value(value, chat, user)

    local replyuser = user
    local fwd_chat = chat
    local fwd_user = user
    if get_reply_receiver(result) == get_receiver(extra.msg) then
        -- replyuser
        if result then
            replyuser = result.from
        end
        -- forward chat
        if result.fwd_from then
            if result.fwd_from.peer_type == 'chat' or result.fwd_from.peer_type == 'channel' then
                fwd_chat = result.fwd_from
            end
        end
        -- forward user
        if result.fwd_from then
            if result.fwd_from.peer_type == 'user' then
                fwd_user = result.fwd_from
            end
        end
    end
    -- replyuser
    if string.find(value, '$replyuserid') then
        value = value:gsub('$replyuserid', replyuser.peer_id or replyuser.id)
    end
    if string.find(value, '$replyfirstname') then
        value = value:gsub('$replyfirstname', replyuser.first_name)
    end
    if string.find(value, '$replylastname') then
        if replyuser.last_name then
            value = value:gsub('$replylastname', replyuser.last_name)
        end
    end
    if string.find(value, '$replyprintname') then
        replyuser.print_name = replyuser.first_name
        if replyuser.last_name then
            replyuser.print_name = replyuser.print_name .. ' ' .. replyuser.last_name
        end
        value = value:gsub('$replyprintname', replyuser.print_name)
    end
    if string.find(value, '$replyusername') then
        if replyuser.username then
            value = value:gsub('$replyusername', '@' .. replyuser.username)
        else
            value = value:gsub('$replyusername', 'NO USERNAME')
        end
    end

    -- forward chat
    if string.find(value, '$forwardchatid') then
        value = value:gsub('$forwardchatid', fwd_chat.peer_id or fwd_chat.id)
    end
    if string.find(value, '$forwardchatname') then
        value = value:gsub('$forwardchatname', fwd_chat.title)
    end
    if string.find(value, '$forwardchatusername') then
        if fwd_chat.username then
            value = value:gsub('$forwardchatusername', '@' .. fwd_chat.username)
        else
            value = value:gsub('$forwardchatusername', 'NO CHAT USERNAME')
        end
    end

    -- forward user
    if string.find(value, '$forwarduserid') then
        value = value:gsub('$forwarduserid', fwd_user.peer_id or fwd_user.id)
    end
    if string.find(value, '$forwardfirstname') then
        value = value:gsub('$forwardfirstname', fwd_user.first_name)
    end
    if string.find(value, '$forwardlastname') then
        if fwd_user.last_name then
            value = value:gsub('$forwardlastname', fwd_user.last_name)
        end
    end
    if string.find(value, '$forwardprintname') then
        fwd_user.print_name = fwd_user.first_name
        if fwd_user.last_name then
            fwd_user.print_name = fwd_user.print_name .. ' ' .. fwd_user.last_name
        end
        value = value:gsub('$forwardprintname', fwd_user.print_name)
    end
    if string.find(value, '$forwardusername') then
        if fwd_user.username then
            value = value:gsub('$forwardusername', '@' .. fwd_user.username)
        else
            value = value:gsub('$forwardusername', 'NO USERNAME')
        end
    end
    reply_msg(extra.msg_id, value, ok_cb, false)
end

local function adjust_value(value, chat, user)
    if string.find(value, '$chatid') then
        value = value:gsub('$chatid', chat.id)
    end
    if string.find(value, '$chatname') then
        value = value:gsub('$chatname', chat.title)
    end
    if string.find(value, '$chatusername') then
        if chat.username then
            value = value:gsub('$chatusername', '@' .. chat.username)
        else
            value = value:gsub('$chatusername', 'NO CHAT USERNAME')
        end
    end
    if string.find(value, '$rules') then
        value = value:gsub('$rules', get_rules(chat.id))
    end
    if string.find(value, '$userid') then
        value = value:gsub('$userid', user.id)
    end
    if string.find(value, '$firstname') then
        value = value:gsub('$firstname', user.first_name)
    end
    if string.find(value, '$lastname') then
        if user.last_name then
            value = value:gsub('$lastname', user.last_name)
        end
    end
    if string.find(value, '$printname') then
        user.print_name = user.first_name
        if user.last_name then
            user.print_name = user.print_name .. ' ' .. user.last_name
        end
        value = value:gsub('$printname', user.print_name)
    end
    if string.find(value, '$username') then
        if user.username then
            value = value:gsub('$username', '@' .. user.username)
        else
            value = value:gsub('$username', 'NO USERNAME')
        end
    end
    if string.find(value, '$grouplink') then
        if data[tostring(chat.id)].settings.set_link then
            value = value:gsub('$grouplink', data[tostring(chat.id)].settings.set_link)
        else
            value = value:gsub('$grouplink', 'NO GROUP LINK SET')
        end
    end
    return value
end

local function set_unset_variables_hash(msg, global)
    if global then
        return 'gvariables'
    else
        if msg.to.type == 'user' then
            return 'user:' .. msg.from.id .. ':variables'
        end
        if msg.to.type == 'chat' then
            return 'chat:' .. msg.to.id .. ':variables'
        end
        if msg.to.type == 'channel' then
            return 'channel:' .. msg.to.id .. ':variables'
        end
        return false
    end
end

local function set_value(msg, name, value, global)
    if (not name or not value) then
        return langs[msg.lang].errorTryAgain
    end

    local hash = set_unset_variables_hash(msg, global)
    if hash then
        redis:hset(hash, name, value)
        if global then
            return name .. langs[msg.lang].gSaved
        else
            return name .. langs[msg.lang].saved
        end
    end
end

local function set_media(msg, name)
    if not name then
        return langs[msg.lang].errorTryAgain
    end

    local hash = set_unset_variables_hash(msg)
    if hash then
        redis:hset(hash, 'waiting', name)
        return langs[msg.lang].sendMedia
    end
end

local function unset_var(msg, name, global)
    if (not name) then
        return langs[msg.lang].errorTryAgain
    end

    local hash = set_unset_variables_hash(msg, global)
    if hash then
        redis:hdel(hash, name)
        if global then
            return name .. langs[msg.lang].gDeleted
        else
            return name .. langs[msg.lang].deleted
        end
    end
end

local function callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success and result then
        local file
        if extra.media == 'photo' then
            file = 'data/savedmedia/' .. extra.hash .. extra.name .. '.jpg'
        elseif extra.media == 'audio' then
            file = 'data/savedmedia/' .. extra.hash .. extra.name .. '.ogg'
        end
        file = file:gsub(':', '.')
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        redis:hset(extra.hash, extra.name, file)
        redis:hdel(extra.hash, 'waiting')
        print(file)
        send_large_msg(extra.receiver, langs[lang].mediaSaved)
    else
        send_large_msg(extra.receiver, langs[lang].errorDownloading .. extra.hash .. ' - ' .. extra.name .. ' - ' .. extra.receiver)
    end
end

local function run(msg, matches)
    local hash = set_unset_variables_hash(msg, false)
    if msg.media then
        if hash then
            local name = redis:hget(hash, 'waiting')
            if name then
                if is_momod(msg) then
                    if msg.media.type == 'photo' then
                        load_photo(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                    elseif msg.media.type == 'audio' then
                        load_document(msg.id, callback, { receiver = get_receiver(msg), hash = hash, name = name, media = msg.media.type })
                    end
                    return
                else
                    return langs[msg.lang].require_mod
                end
            end
            return
        else
            return langs[msg.lang].nothingToSet
        end
    end

    if not msg.api_patch then
        if matches[1]:lower() == 'get' or matches[1]:lower() == 'getlist' or matches[1]:lower() == 'sasha lista' then
            if not matches[2] then
                return list_variables(msg, false)
            else
                local vars = list_variables(msg, true)
                if vars ~= nil then
                    local t = vars:split('\n')
                    for i, word in pairs(t) do
                        local found = false
                        local temp = word:lower()
                        if msg.text then
                            if string.match(msg.text:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media then
                            if msg.media.title then
                                if string.match(msg.media.title:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                            if msg.media.description then
                                if string.match(msg.media.description:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                            if msg.media.caption then
                                if string.match(msg.media.caption:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                        end
                        if msg.fwd_from then
                            if msg.fwd_from.title then
                                if string.match(msg.fwd_from.title:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                        end
                        if found then
                            return langs[msg.lang].getCommand:gsub('X', word:lower()) .. answer
                        end
                    end
                end
                local vars = list_variables(msg, false)
                if vars ~= nil then
                    local t = vars:split('\n')
                    for i, word in pairs(t) do
                        local found = false
                        local temp = word:lower()
                        if msg.text then
                            if string.match(msg.text:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media then
                            if msg.media.title then
                                if string.match(msg.media.title:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                            if msg.media.description then
                                if string.match(msg.media.description:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                            if msg.media.caption then
                                if string.match(msg.media.caption:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                        end
                        if msg.fwd_from then
                            if msg.fwd_from.title then
                                if string.match(msg.fwd_from.title:lower(), temp) then
                                    local value = get_value(msg, temp)
                                    if value then
                                        answer = value
                                        found = true
                                    end
                                end
                            end
                        end
                        if found then
                            return langs[msg.lang].getCommand:gsub('X', word:lower()) .. answer
                        end
                    end
                end
                return langs[msg.lang].noSetValue
            end
        end

        if (matches[1]:lower() == 'getglobal' or matches[1]:lower() == 'getgloballist' or matches[1]:lower() == 'sasha lista globali') then
            return list_variables(msg, true)
        end

        if matches[1]:lower() == 'exportgroupsets' then
            if is_owner(msg) then
                if list_variables(msg, false) then
                    local tab = list_variables(msg, false):split('\n')
                    local newtab = { }
                    for i, word in pairs(tab) do
                        newtab[word] = get_value(msg, word:lower())
                    end
                    local text = ''
                    for word, answer in pairs(newtab) do
                        text = text .. '/set ' .. word:gsub(' ', '_') .. ' ' .. answer .. '\nXXXxxxXXX\n'
                    end
                    send_large_msg(get_receiver(msg), text)
                end
            else
                return langs[msg.lang].require_owner
            end
        end

        if matches[1]:lower() == 'exportglobalsets' then
            if is_admin1(msg) then
                if list_variables(msg, true) then
                    local tab = list_variables(msg, true):split('\n')
                    local newtab = { }
                    for i, word in pairs(tab) do
                        newtab[word] = get_value(msg, word:lower())
                    end
                    local text = ''
                    for word, answer in pairs(newtab) do
                        text = text .. '/setglobal ' .. word:gsub(' ', '_') .. ' ' .. answer .. '\nXXXxxxXXX\n'
                    end
                    send_large_msg(get_receiver(msg), text)
                end
            else
                return langs[msg.lang].require_admin
            end
        end

        if matches[1]:lower() == 'enableglobal' then
            if is_owner(msg) then
                redis:del(msg.to.id .. ':gvariables')
                return langs[msg.lang].globalEnable
            else
                return langs[msg.lang].require_owner
            end
        end

        if matches[1]:lower() == 'disableglobal' then
            if is_owner(msg) then
                redis:set(msg.to.id .. ':gvariables', true)
                return langs[msg.lang].globalDisable
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'importgroupsets' and matches[2] then
            if is_owner(msg) then
                local tab = matches[2]:split('\nXXXxxxXXX\n')
                local i = 0
                for k, command in pairs(tab) do
                    local name, value = string.match(command, '/set ([^%s]+) (.+)')
                    name = string.sub(name:lower(), 1, 50)
                    value = string.sub(value, 1, 4096)
                    if string.match(value, '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                        return langs[msg.lang].autocrossexecDenial
                    end
                    if string.match(value, '[Cc][Rr][Oo][Ss][Ss][Ee][Xx][Ee][Cc]') then
                        return langs[msg.lang].autocrossexecDenial
                    end
                    set_value(msg, name, value, false)
                    i = i + 1
                end
                return i .. langs[msg.lang].setsRestored
            else
                return langs[msg.lang].require_owner
            end
        end

        if matches[1]:lower() == 'importglobalsets' and matches[2] then
            if is_admin1(msg) then
                local tab = matches[2]:split('\nXXXxxxXXX\n')
                local i = 0
                vardump(tab)
                for k, command in pairs(tab) do
                    local name, value = string.match(command, '/setglobal ([^%s]+) (.+)')
                    name = string.sub(name:lower(), 1, 50)
                    value = string.sub(value, 1, 4096)
                    if string.match(value, '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                        return langs[msg.lang].autocrossexecDenial
                    end
                    if string.match(value, '[Cc][Rr][Oo][Ss][Ss][Ee][Xx][Ee][Cc]') then
                        return langs[msg.lang].autocrossexecDenial
                    end
                    set_value(msg, name, value, true)
                    i = i + 1
                end
                return i .. langs[msg.lang].globalSetsRestored
            else
                return langs[msg.lang].require_admin
            end
        end

        if matches[1]:lower() == 'cancel' or matches[1]:lower() == 'sasha annulla' or matches[1]:lower() == 'annulla' then
            if is_momod(msg) then
                redis:hdel(hash, 'waiting')
                return langs[msg.lang].cancelled
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'setmedia' or matches[1]:lower() == 'sasha setta media' or matches[1]:lower() == 'setta media' then
            if is_momod(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                return set_media(msg, name)
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'set' or matches[1]:lower() == 'sasha setta' or matches[1]:lower() == 'setta' then
            if string.match(matches[3], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if string.match(matches[3], '[Cc][Rr][Oo][Ss][Ss][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if is_momod(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                local value = string.sub(matches[3], 1, 4096)
                return set_value(msg, name, value, false)
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'setglobal' then
            if string.match(matches[3], '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if string.match(matches[3], '[Cc][Rr][Oo][Ss][Ss][Ee][Xx][Ee][Cc]') then
                return langs[msg.lang].autocrossexecDenial
            end
            if is_admin1(msg) then
                local name = string.sub(matches[2]:lower(), 1, 50)
                local value = string.sub(matches[3], 1, 4096)
                return set_value(msg, name, value, true)
            else
                return langs[msg.lang].require_admin
            end
        end

        if matches[1]:lower() == 'unset' or matches[1]:lower() == 'sasha unsetta' or matches[1]:lower() == 'unsetta' then
            if is_momod(msg) then
                return unset_var(msg, string.gsub(string.sub(matches[2], 1, 50), ' ', '_'):lower(), false)
            else
                return langs[msg.lang].require_mod
            end
        end

        if matches[1]:lower() == 'unsetglobal' then
            if is_admin1(msg) then
                return unset_var(msg, string.gsub(string.sub(matches[2], 1, 50), ' ', '_'):lower(), true)
            else
                return langs[msg.lang].require_admin
            end
        end
    end
end

local function pre_process(msg, matches)
    if msg then
        if not msg.api_patch then
            -- local
            local vars = list_variables(msg, false)
            local answer = nil

            if vars ~= nil then
                local t = vars:split('\n')
                for i, word in pairs(t) do
                    local found = false
                    local temp = word:lower()
                    if msg.text then
                        if not string.match(msg.text, "^[#!/][Gg][Ee][Tt] (.*)$") and not string.match(msg.text, "^[#!/][Uu][Nn][Ss][Ee][Tt] ([^%s]+)$") and not string.match(msg.text, "^[Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)$") and not string.match(msg.text, "^[Ss][Aa][Ss][Hh][Aa] [Uu][Nn][Ss][Ee][Tt][Tt][Aa] ([^%s]+)$") and not string.match(msg.text, "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Rr][Oo][Uu][Pp][Ss][Ee][Tt][Ss]) (.+)$") then
                            if string.match(msg.text:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if msg.media then
                        if msg.media.title then
                            if string.match(msg.media.title:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media.description then
                            if string.match(msg.media.description:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media.caption then
                            if string.match(msg.media.caption:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if msg.fwd_from then
                        if msg.fwd_from.title then
                            if string.match(msg.fwd_from.title:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if found then
                        print('GET FOUND')
                        if not string.match(answer, "^(.*)user%.(%d+)%.variables(.*)$") and not string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)$") and not string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)$") then
                            -- if not media
                            if msg.reply_id then
                                get_message(msg.reply_id, adjust_value_reply, { msg_id = msg.id, receiver = get_receiver(msg), from = msg.from, to = msg.to, value = get_value(msg, word:lower()) })
                            else
                                reply_msg(msg.id, adjust_value(get_value(msg, word:lower()), msg.to, msg.from), ok_cb, false)
                            end
                            return msg
                        elseif string.match(answer, "^(.*)user%.(%d+)%.variables(.*)%.jpg$") or string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)%.jpg$") or string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)%.jpg$") then
                            -- if picture
                            if io.popen('find ' .. answer):read("*all") ~= '' then
                                send_photo(get_receiver(msg), answer, ok_cb, false)
                                return msg
                            end
                        elseif string.match(answer, "^(.*)user%.(%d+)%.variables(.*)%.ogg$") or string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)%.ogg$") or string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)%.ogg$") then
                            -- if audio
                            if io.popen('find ' .. answer):read("*all") ~= '' then
                                send_audio(get_receiver(msg), answer, ok_cb, false)
                                return msg
                            end
                        end
                    end
                end
            end
            -- global
            local vars = list_variables(msg, true)
            local answer = nil

            if vars ~= nil then
                local t = vars:split('\n')
                for i, word in pairs(t) do
                    local found = false
                    local temp = word:lower()
                    if msg.text then
                        if not string.match(msg.text, "^[#!/][Gg][Ee][Tt] (.*)$") and not string.match(msg.text, "^[#!/][Uu][Nn][Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll] ([^%s]+)$") and not string.match(msg.text, "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ss][Ee][Tt][Ss]) (.+)$") then
                            if string.match(msg.text:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if msg.media then
                        if msg.media.title then
                            if string.match(msg.media.title:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media.description then
                            if string.match(msg.media.description:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                        if msg.media.caption then
                            if string.match(msg.media.caption:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if msg.fwd_from then
                        if msg.fwd_from.title then
                            if string.match(msg.fwd_from.title:lower(), temp) then
                                local value = get_value(msg, temp)
                                if value then
                                    answer = value
                                    found = true
                                end
                            end
                        end
                    end
                    if found then
                        if not string.match(answer, "^(.*)user%.(%d+)%.variables(.*)$") and not string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)$") and not string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)$") then
                            -- if not media
                            if msg.reply_id then
                                get_message(msg.reply_id, adjust_value_reply, { msg_id = msg.id, receiver = get_receiver(msg), from = msg.from, to = msg.to, value = get_value(msg, word:lower()) })
                            else
                                reply_msg(msg.id, adjust_value(get_value(msg, word:lower()), msg.to, msg.from), ok_cb, false)
                            end
                            return msg
                        elseif string.match(answer, "^(.*)user%.(%d+)%.variables(.*)%.jpg$") or string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)%.jpg$") or string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)%.jpg$") then
                            -- if picture
                            if io.popen('find ' .. answer):read("*all") ~= '' then
                                send_photo(get_receiver(msg), answer, ok_cb, false)
                                return msg
                            end
                        elseif string.match(answer, "^(.*)user%.(%d+)%.variables(.*)%.ogg$") or string.match(answer, "^(.*)chat%.(%d+)%.variables(.*)%.ogg$") or string.match(answer, "^(.*)channel%.(%d+)%.variables(.*)%.ogg$") then
                            -- if audio
                            if io.popen('find ' .. answer):read("*all") ~= '' then
                                send_audio(get_receiver(msg), answer, ok_cb, false)
                                return msg
                            end
                        end
                    end
                end
            end
        end
        return msg
    end
end

return {
    description = "GETSETUNSET",
    patterns =
    {
        --- GET
        "^[#!/]([Gg][Ee][Tt]) (.*)$",
        "^[#!/]([Gg][Ee][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Gg][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee][Gg][Ll][Oo][Bb][Aa][Ll])$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee][Gg][Ll][Oo][Bb][Aa][Ll])$",
        -- "^[#!/]([Ee][Xx][Pp][Oo][Rr][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ss][Ee][Tt][Ss])$",
        -- "^[#!/]([Ee][Xx][Pp][Oo][Rr][Tt][Gg][Rr][Oo][Uu][Pp][Ss][Ee][Tt][Ss])$",
        -- getlist
        "^[#!/]([Gg][Ee][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa])$",
        -- getgloballist
        "^[#!/]([Gg][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Gg][Ll][Oo][Bb][Aa][Ll][Ii])$",

        --- SET
        "^[#!/]([Ss][Ee][Tt]) ([^%s]+) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll]) ([^%s]+) (.+)$",
        "^[#!/]([Ss][Ee][Tt][Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        "^[#!/]([Cc][Aa][Nn][Cc][Ee][Ll])$",
        -- "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Ll][Oo][Bb][Aa][Ll][Ss][Ee][Tt][Ss]) (.+)$",
        -- "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt][Gg][Rr][Oo][Uu][Pp][Ss][Ee][Tt][Ss]) (.+)$",
        "%[(photo)%]",
        "%[(audio)%]",
        -- set
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Tt][Tt][Aa]) ([^%s]+) (.+)$",
        "^([Ss][Ee][Tt][Tt][Aa]) ([^%s]+) (.+)$",
        -- setmedia
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Tt][Tt][Aa] [Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        "^([Ss][Ee][Tt][Tt][Aa] [Mm][Ee][Dd][Ii][Aa]) ([^%s]+)$",
        -- cancel
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Nn][Nn][Uu][Ll][Ll][Aa])$",
        "^([Aa][Nn][Nn][Uu][Ll][Ll][Aa])$",

        --- UNSET
        "^[#!/]([Uu][Nn][Ss][Ee][Tt]) (.*)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Gg][Ll][Oo][Bb][Aa][Ll]) (.*)$",
        -- unset
        "^([Ss][Aa][Ss][Hh][Aa] [Uu][Nn][Ss][Ee][Tt][Tt][Aa]) (.*)$",
        "^([Uu][Nn][Ss][Ee][Tt][Tt][Aa]) (.*)$",
    },
    pre_process = pre_process,
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#get <var_name>",
        "(#get|#getlist|sasha lista)",
        "(#getgloballist|#getglobal|sasha lista globali)",
        "MOD",
        "(#set|[sasha] setta) <var_name>|<pattern> <text>",
        "(#setmedia|[sasha] setta media) <var_name>|<pattern>",
        "(#cancel|[sasha] annulla)",
        "(#unset|[sasha] unsetta) <var_name>|<pattern>",
        "OWNER",
        "#enableglobal",
        "#disableglobal",
        "ADMIN",
        "#setglobal <var_name>|<pattern> <text>",
        "#unsetglobal <var_name>|<pattern>",
    },
}