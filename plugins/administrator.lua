local function set_bot_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/bot.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        set_profile_photo(file, ok_cb, false)
        send_large_msg(receiver, lang_text('it:' .. 'botPicChanged'), ok_cb, false)
        redis:del("bot:photo")
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, lang_text('it:' .. 'errorTryAgain'), ok_cb, false)
    end
end

-- Function to add log supergroup
local function logadd(msg)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    local GBan_log = 'GBan_log'
    if not data[tostring(GBan_log)] then
        data[tostring(GBan_log)] = { }
        save_data(_config.moderation.data, data)
    end
    data[tostring(GBan_log)][tostring(msg.to.id)] = msg.to.peer_id
    save_data(_config.moderation.data, data)
    local text = lang_text('it:' .. 'logSet')
    reply_msg(msg.id, text, ok_cb, false)
    return
end

-- Function to remove log supergroup
local function logrem(msg)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    local GBan_log = 'GBan_log'
    if not data[tostring(GBan_log)] then
        data[tostring(GBan_log)] = nil
        save_data(_config.moderation.data, data)
    end
    data[tostring(GBan_log)][tostring(msg.to.id)] = nil
    save_data(_config.moderation.data, data)
    local text = lang_text('it:' .. 'logUnset')
    reply_msg(msg.id, text, ok_cb, false)
    return
end


local function parsed_url(link)
    local parsed_link = URL.parse(link)
    local parsed_path = URL.parse_path(parsed_link.path)
    return parsed_path[2]
end

local function get_contact_list_callback(cb_extra, success, result)
    local text = " "
    for k, v in pairs(result) do
        if v.print_name and v.id and v.phone then
            text = text .. string.gsub(v.print_name, "_", " ") .. " [" .. v.id .. "] = " .. v.phone .. "\n"
        end
    end
    if (cb_filetype == "txt") then
        local file = io.open("contact_list.txt", "w")
        file:write(text)
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "contact_list.txt", ok_cb, false)
        -- .txt format
    end
    if (cb_extra.filetype == "json") then
        local file = io.open("contact_list.json", "w")
        file:write(json:encode_pretty(result))
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "contact_list.json", ok_cb, false)
        -- json format
    end
end

local function get_dialog_list_callback(extra, success, result)
    local text = ""
    for k, v in pairsByKeys(result) do
        if v.peer then
            if v.peer.type == "chat" then
                text = text .. "group{" .. v.peer.title .. "}[" .. v.peer.id .. "](" .. v.peer.members_num .. ")"
            else
                if v.peer.print_name and v.peer.id then
                    text = text .. "user{" .. v.peer.print_name .. "}[" .. v.peer.id .. "]"
                end
                if v.peer.username then
                    text = text .. "(" .. v.peer.username .. ")"
                end
                if v.peer.phone then
                    text = text .. "'" .. v.peer.phone .. "'"
                end
            end
        end
        if v.message then
            text = text .. '\nlast msg >\nmsg id = ' .. v.message.id
            if v.message.text then
                text = text .. "\n text = " .. v.message.text
            end
            if v.message.action then
                text = text .. "\n" .. serpent.block(v.message.action, { comment = false })
            end
            if v.message.from then
                if v.message.from.print_name then
                    text = text .. "\n From > \n" .. string.gsub(v.message.from.print_name, "_", " ") .. "[" .. v.message.from.id .. "]"
                end
                if v.message.from.username then
                    text = text .. "( " .. v.message.from.username .. " )"
                end
                if v.message.from.phone then
                    text = text .. "' " .. v.message.from.phone .. " '"
                end
            end
        end
        text = text .. "\n\n"
    end
    if (extra.filetype == "txt") then
        local file = io.open("dialog_list.txt", "w")
        file:write(text)
        file:flush()
        file:close()
        send_document("user#id" .. extra.target, "dialog_list.txt", ok_cb, false)
        -- .txt format
    end
    if (extra.filetype == "json") then
        local file = io.open("dialog_list.json", "w")
        file:write(json:encode_pretty(result))
        file:flush()
        file:close()
        send_document("user#id" .. extra.target, "dialog_list.json", ok_cb, false)
        -- json format
    end
end

local function tableshow(t, name, indent)
    local cart
    -- a container
    local autoref
    -- for self references

    --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize(o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return string.format("%q", so .. ", C function")
            else
                -- the information is defined through lines
                return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
            end
        elseif type(o) == "number" or type(o) == "boolean" then
            return so
        else
            return string.format("%q", so)
        end
    end

    local function addtocart(value, name, indent, saved, field)
        indent = indent or ""
        saved = saved or { }
        field = field or name

        cart = cart .. indent .. field

        if type(value) ~= "table" then
            cart = cart .. " = " .. basicSerialize(value) .. ";\n"
        else
            if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value]
                .. " (self reference)\n"
                autoref = autoref .. name .. " = " .. saved[value] .. ";\n"
            else
                saved[value] = name
                -- if tablecount(value) == 0 then
                if isemptytable(value) then
                    cart = cart .. " = {};\n"
                else
                    cart = cart .. " = {\n"
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = string.format("%s[%s]", name, k)
                        field = string.format("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. "   ", saved, field)
                    end
                    cart = cart .. indent .. "};\n"
                end
            end
        end
    end

    name = name or "__unnamed__"
    if type(t) ~= "table" then
        return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    print(cart)
    print(autoref)
    return cart .. autoref
end

local function vardump_msg(extra, success, result)
    local name = 'msg'
    if extra.name == 'reply' then
        name = 'VARDUMP (<reply>)'
    end
    if extra.name == 'msg_id' then
        name = 'VARDUMP (<msg_id>)'
    end
    print('in')
    print(extra.name)
    print(extra.receiver)
    local text = tableshow(result, name)
    send_large_msg(extra.receiver, text)
end

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    local print_name = user_print_name(msg.from):gsub("‮", "")
    local name_log = print_name:gsub("_", " ")
    if is_admin1(msg) then
        if msg.media then
            if msg.media.type == 'photo' and redis:get("bot:photo") then
                if redis:get("bot:photo") == 'waiting' then
                    load_photo(msg.id, set_bot_photo, msg)
                end
            end
        end
        if matches[1]:lower() == "setbotphoto" or matches[1]:lower() == "sasha setta foto" then
            redis:set("bot:photo", "waiting")
            return lang_text('it:' .. 'sendNewPic')
        end
        if matches[1] == "markread" or matches[1]:lower() == "sasha segna letto" then
            if matches[2] == "on" then
                redis:set("bot:markread", "on")
                return lang_text('it:' .. 'markRead') .. " > on"
            end
            if matches[2] == "off" then
                redis:del("bot:markread")
                return lang_text('it:' .. 'markRead') .. " > off"
            end
            return
        end
        if matches[1]:lower() == "pm" or matches[1]:lower() == "sasha messaggia" then
            send_large_msg("user#id" .. matches[2], matches[3])
            return lang_text('it:' .. 'pmSent')
        end
        if matches[1]:lower() == "pmblock" or matches[1]:lower() == "sasha blocca" then
            if is_admin2(matches[2]) then
                return lang_text('it:' .. 'cantBlockAdmin')
            end
            block_user("user#id" .. matches[2], ok_cb, false)
            return lang_text('it:' .. 'userBlocked')
        end
        if matches[1]:lower() == "pmunblock" or matches[1]:lower() == "sasha sblocca" then
            unblock_user("user#id" .. matches[2], ok_cb, false)
            return lang_text('it:' .. 'userUnblocked')
        end
        if matches[1]:lower() == "import" then
            -- join by group link
            local hash = parsed_url(matches[2])
            import_chat_link(hash, ok_cb, false)
        end
        if is_sudo(msg) then
            if matches[1]:lower() == "contactlist" or matches[1]:lower() == "sasha lista contatti" then
                if not matches[2] then
                    get_contact_list(get_contact_list_callback, { target = msg.from.id, filetype = "txt" })
                else
                    get_contact_list(get_contact_list_callback, { target = msg.from.id, filetype = matches[2]:lower() })
                end
                return lang_text('it:' .. 'contactListSent')
            end
            if matches[1]:lower() == "delcontact" or matches[1]:lower() == "sasha elimina contatto" and matches[2] then
                del_contact("user#id" .. matches[2], ok_cb, false)
                return lang_text('it:' .. 'user') .. matches[2] .. lang_text('it:' .. 'removedFromContacts')
            end
            if matches[1]:lower() == "addcontact" or matches[1]:lower() == "sasha aggiungi contatto" and matches[2] then
                phone = matches[2]
                first_name = matches[3]
                last_name = matches[4]
                add_contact(phone, first_name, last_name, ok_cb, false)
                return lang_text('it:' .. 'user') .. phone .. lang_text('it:' .. 'addedToContacts')
            end
            if matches[1]:lower() == "sendcontact" or matches[1]:lower() == "sasha invia contatto" then
                phone = matches[2]
                first_name = matches[3]
                last_name = matches[4]
                send_contact(get_receiver(msg), phone, first_name, last_name, ok_cb, false)
            end
            if matches[1]:lower() == "mycontact" or matches[1]:lower() == "sasha mio contatto" then
                if not msg.from.phone then
                    return lang_text('it:' .. 'contactMissing')
                end
                phone = msg.from.phone
                first_name =(msg.from.first_name or msg.from.phone)
                last_name =(msg.from.last_name or msg.from.id)
                send_contact(get_receiver(msg), phone, first_name, last_name, ok_cb, false)
            end
            if matches[1]:lower() == "dialoglist" or matches[1]:lower() == "sasha lista chat" then
                if not matches[2] then
                    get_dialog_list(get_dialog_list_callback, { target = msg.from.id, filetype = "txt" })
                else
                    get_dialog_list(get_dialog_list_callback, { target = msg.from.id, filetype = matches[2]:lower() })
                end
                return lang_text('it:' .. 'chatListSent')
            end
            if matches[1]:lower() == "sync_gbans" or matches[1]:lower() == "sasha sincronizza lista superban" then
                local url = "http://seedteam.org/Teleseed/Global_bans.json"
                local SEED_gbans = http.request(url)
                local jdat = json:decode(SEED_gbans)
                for k, v in pairs(jdat) do
                    redis:hset('user:' .. v, 'print_name', k)
                    banall_user(v)
                    print(k, v .. " Globally banned")
                end
                return lang_text('it:' .. 'gbansSync')
            end
            if matches[1]:lower() == "backup" or matches[1]:lower() == "sasha esegui backup" then
                local time = os.time()
                local log = io.popen('cd "/home/pi/BACKUPS/" && tar -zcvf backupAISasha' .. time .. '.tar.gz /home/pi/AISashaExp'):read('*all')
                local file = io.open("/home/pi/BACKUPS/backupLog" .. time .. ".txt", "w")
                file:write(log)
                file:flush()
                file:close()
                send_document("user#id" .. msg.from.id, "/home/pi/BACKUPS/backupLog" .. time .. ".txt", ok_cb, false)
                return lang_text('it:' .. 'backupDone')
            end
            if matches[1]:lower() == 'vardump' then
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, vardump_msg, { receiver = get_receiver(msg), name = 'reply' })
                elseif matches[2] then
                    msgr = get_message(matches[2], vardump_msg, { receiver = get_receiver(msg), name = 'msg_id' })
                else
                    local text = tableshow(msg, 'VARDUMP (<msg>)')
                    send_large_msg(get_receiver(msg), text)
                end
            end
        end
        --[[*For Debug*
	    if matches[1] == "vardumpmsg" then
		local text = serpent.block(msg, {comment=false})
		send_large_msg("channel#id"..msg.to.id, text)
	end]]
        if matches[1]:lower() == 'updateid' or matches[1]:lower() == 'sasha aggiorna longid' then
            local data = load_data(_config.moderation.data)
            local long_id = data[tostring(msg.to.id)]['long_id']
            if not long_id then
                data[tostring(msg.to.id)]['long_id'] = msg.to.peer_id
                save_data(_config.moderation.data, data)
                return lang_text('it:' .. 'longidUpdate')
            end
        end
        if matches[1]:lower() == 'addlog' or matches[1]:lower() == 'sasha aggiungi log' and not matches[2] then
            if is_log_group(msg) then
                return lang_text('it:' .. 'alreadyLog')
            end
            print("Log_SuperGroup " .. msg.to.title .. "(" .. msg.to.id .. ") added")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added Log_SuperGroup")
            logadd(msg)
        end
        if matches[1]:lower() == 'remlog' or matches[1]:lower() == 'sasha rimuovi log' and not matches[2] then
            if not is_log_group(msg) then
                return lang_text('it:' .. 'notLog')
            end
            print("Log_SuperGroup " .. msg.to.title .. "(" .. msg.to.id .. ") removed")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added Log_SuperGroup")
            logrem(msg)
        end
    end
end

local function pre_process(msg)
    if not msg.text and msg.media then
        msg.text = '[' .. msg.media.type .. ']'
    end
    return msg
end

return {
    description = "ADMINISTRATOR",
    usage =
    {
        "ADMIN",
        "(#pm|sasha messaggia) <user_id> <msg>: Sasha invia <msg> a <user_id>.",
        "#import <group_link>: Sasha entra nel gruppo tramite <group_link>.",
        "(#block|sasha blocca) <user_id>: Sasha blocca <user_id>.",
        "(#unblock|sasha sblocca) <user_id>: Sasha sblocca <user_id>.",
        "(#markread|sasha segna letto) (on|off): Sasha segna come [non] letti i messaggi ricevuti.",
        "(#setbotphoto|sasha cambia foto): Sasha chiede la foto da settare come profilo.",
        "(#updateid|sasha aggiorna longid): Sasha salva il long_id.",
        "(#addlog|sasha aggiungi log): Sasha aggiunge il log.",
        "(#remlog|sasha rimuovi log): Sasha rimuove il log.",
        "SUDO",
        "(#contactlist|sasha lista contatti) (txt|json): Sasha manda la lista dei contatti.",
        "(#dialoglist|sasha lista chat) (txt|json): Sasha manda la lista delle chat.",
        "(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha aggiunge il contatto specificato.",
        "(#delcontact|sasha elimina contatto) <user_id>: Sasha elimina il contatto <user_id>.",
        "(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha invia il contatto specificato.",
        "(#mycontact|sasha mio contatto): Sasha invia il contatto del richiedente.",
        "(#sync_gbans|sasha sincronizza superban): Sasha sincronizza la lista dei superban con quella offerta da TeleSeed.",
        "(#backup|sasha esegui backup): Sasha esegue un backup di se stessa e invia il log al richiedente.",
        "#vardump [<reply>|<msg_id>]: Sasha esegue il vardump del messaggio specificato.",
    },
    patterns =
    {
        "^[#!/]([Pp][Mm]) (%d+) (.*)$",
        "^[#!/]([Ii][Mm][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/]([Pp][Mm][Uu][Nn][Bb][Ll][Oo][Cc][Kk]) (%d+)$",
        "^[#!/]([Pp][Mm][Bb][Ll][Oo][Cc][Kk]) (%d+)$",
        "^[#!/]([Mm][Aa][Rr][Kk][Rr][Ee][Aa][Dd]) ([Oo][Nn])$",
        "^[#!/]([Mm][Aa][Rr][Kk][Rr][Ee][Aa][Dd]) ([Oo][Ff][Ff])$",
        "^[#!/]([Ss][Ee][Tt][Bb][Oo][Tt][Pp][Hh][Oo][Tt][Oo])$",
        "^[#!/]([Cc][Oo][Nn][Tt][Aa][Cc][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Dd][Ii][Aa][Ll][Oo][Gg][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Dd][Ee][Ll][Cc][Oo][Nn][Tt][Aa][Cc][Tt]) (%d+)$",
        "^[#!/]([Aa][Dd][Dd][Cc][Oo][Nn][Tt][Aa][Cc][Tt]) (.*) (.*) (.*)$",
        "^[#!/]([Ss][Ee][Nn][Dd][Cc][Oo][Nn][Tt][Aa][Cc][Tt]) (.*) (.*) (.*)$",
        "^[#!/]([Mm][Yy][Cc][Oo][Nn][Tt][Aa][Cc][Tt])$",
        "^[#!/]([Ss][Yy][Nn][Cc]_[Gg][Bb][Aa][Nn][Ss])$",
        -- sync your global bans with seed
        "^[#!/]([Bb][Aa][Cc][Kk][Uu][Pp])$",
        "^[#!/]([Uu][Pp][Dd][Aa][Tt][Ee][Ii][Dd])$",
        "^[#!/]([Aa][Dd][Dd][Ll][Oo][Gg])$",
        "^[#!/]([Rr][Ee][Mm][Ll][Oo][Gg])$",
        "^[#!/]([Vv][Aa][Rr][Dd][Uu][Mm][Pp]) (.*)$",
        "^[#!/]([Vv][Aa][Rr][Dd][Uu][Mm][Pp])$",
        "%[(photo)%]",
        -- pm
        "^([Ss][Aa][Ss][Hh][Aa] [Mm][Ee][Ss][Ss][Aa][Gg][Gg][Ii][Aa]) (%d+) (.*)$",
        -- pmunblock
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (%d+)$",
        -- pmblock
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Ll][Oo][Cc][Cc][Aa]) (%d+)$",
        -- markread
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Gg][Nn][Aa] [Ll][Ee][Tt][Tt][Oo]) ([Oo][Nn])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ee][Gg][Nn][Aa] [Ll][Ee][Tt][Tt][Oo]) ([Oo][Ff][Ff])$",
        -- setbotphoto
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Aa][Mm][Bb][Ii][Aa] [Ff][Oo][Tt][Oo])$",
        -- contactlist
        "^[#!/]([Cc][Oo][Nn][Tt][Aa][Cc][Tt][Ll][Ii][Ss][Tt]) ([Tt][Xx][Tt])$",
        "^[#!/]([Cc][Oo][Nn][Tt][Aa][Cc][Tt][Ll][Ii][Ss][Tt]) ([Jj][Ss][Oo][Nn])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Ii])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Ii]) ([Tt][Xx][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Ii]) ([Jj][Ss][Oo][Nn])$",
        -- dialoglist
        "^[#!/]([Dd][Ii][Aa][Ll][Oo][Gg][Ll][Ii][Ss][Tt]) ([Tt][Xx][Tt])$",
        "^[#!/]([Dd][Ii][Aa][Ll][Oo][Gg][Ll][Ii][Ss][Tt]) ([Jj][Ss][Oo][Nn])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Hh][Aa][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Hh][Aa][Tt]) ([Tt][Xx][Tt])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Cc][Hh][Aa][Tt]) ([Jj][Ss][Oo][Nn])$",
        -- delcontact
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ll][Ii][Mm][Ii][Nn][Aa] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Oo]) (%d+)$",
        -- addcontact
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Gg][Gg][Ii][Uu][Nn][Gg][Ii] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Oo]) (.*) (.*) (.*)$",
        -- sendcontact
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Vv][Ii][Aa] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Oo]) (.*) (.*) (.*)$",
        -- mycontact
        "^([Ss][Aa][Ss][Hh][Aa] [Mm][Ii][Oo] [Cc][Oo][Nn][Tt][Aa][Tt][Tt][Oo])$",
        -- sync_gbans
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ii][Nn][Cc][Rr][Oo][Nn][Ii][Zz][Zz][Aa] [Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
        -- backup
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ss][Ee][Gg][Uu][Ii] [Bb][Aa][Cc][Kk][Uu][Pp])$",
        -- updateid
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Gg][Gg][Ii][Oo][Rr][Nn][Aa] [Ll][Oo][Nn][Gg][Ii][Dd])$",
        -- addlog
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Gg][Gg][Ii][Uu][Nn][Gg][Ii] [Ll][Oo][Gg])$",
        -- remlog
        "^[Ss][Aa][Ss][Hh][Aa] ([Rr][Ii][Mm][Uu][Oo][Vv][Ii] [Ll][Oo][Gg])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 4
}
-- By @imandaneshi :)
-- https://github.com/SEEDTEAM/TeleSeed/blob/test/plugins/admin.lua
--- Modified by @Rondoozle for supergroups
