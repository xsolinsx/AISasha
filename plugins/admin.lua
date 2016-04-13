local function set_bot_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/bot.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        set_profile_photo(file, ok_cb, false)
        send_large_msg(receiver, lang_text('botPicChanged'), ok_cb, false)
        redis:del("bot:photo")
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, lang_text('errorTryAgain'), ok_cb, false)
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
    local text = lang_text('logSet')
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
    local text = lang_text('logUnset')
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
    local filetype = cb_extra.filetype
    for k, v in pairs(result) do
        if v.print_name and v.id and v.phone then
            text = text .. string.gsub(v.print_name, "_", " ") .. " [" .. v.id .. "] = " .. v.phone .. "\n"
        end
    end
    if (filetype == "txt") then
        local file = io.open("contact_list.txt", "w")
        file:write(text)
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "contact_list.txt", ok_cb, false)
        -- .txt format
    end
    if (filetype == "json") then
        local file = io.open("contact_list.json", "w")
        file:write(json:encode_pretty(result))
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "contact_list.json", ok_cb, false)
        -- json format
    end
end

local function get_dialog_list_callback(cb_extra, success, result)
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
    if (filetype == "txt") then
        local file = io.open("dialog_list.txt", "w")
        file:write(text)
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "dialog_list.txt", ok_cb, false)
        -- .txt format
    end
    if (filetype == "json") then
        local file = io.open("dialog_list.json", "w")
        file:write(json:encode_pretty(result))
        file:flush()
        file:close()
        send_document("user#id" .. cb_extra.target, "dialog_list.json", ok_cb, false)
        -- json format
    end
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
            return lang_text('sendNewPic')
        end
        if matches[1] == "markread" or matches[1]:lower() == "sasha segna letto" then
            if matches[2] == "on" then
                redis:set("bot:markread", "on")
                return lang_text('markRead') .. " > on"
            end
            if matches[2] == "off" then
                redis:del("bot:markread")
                return lang_text('markRead') .. " > off"
            end
            return
        end
        if matches[1]:lower() == "pm" or matches[1]:lower() == "sasha messaggia" then
            send_large_msg("user#id" .. matches[2], matches[3])
            return lang_text('pmSent')
        end
        if matches[1]:lower() == "pmblock" or matches[1]:lower() == "sasha blocca" then
            if is_admin2(matches[2]) then
                return lang_text('cantBlockAdmin')
            end
            block_user("user#id" .. matches[2], ok_cb, false)
            return lang_text('userBlocked')
        end
        if matches[1]:lower() == "pmunblock" or matches[1]:lower() == "sasha sblocca" then
            unblock_user("user#id" .. matches[2], ok_cb, false)
            return lang_text('userUnblocked')
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
                return lang_text('contactListSent')
            end
            if matches[1]:lower() == "delcontact" or matches[1]:lower() == "sasha elimina contatto" and matches[2] then
                del_contact("user#id" .. matches[2], ok_cb, false)
                return lang_text('user') .. matches[2] .. lang_text('removedFromContacts')
            end
            if matches[1]:lower() == "addcontact" or matches[1]:lower() == "sasha aggiungi contatto" and matches[2] then
                phone = matches[2]
                first_name = matches[3]
                last_name = matches[4]
                add_contact(phone, first_name, last_name, ok_cb, false)
                return lang_text('user') .. phone .. lang_text('addedToContacts')
            end
            if matches[1]:lower() == "sendcontact" or matches[1]:lower() == "sasha invia contatto" then
                phone = matches[2]
                first_name = matches[3]
                last_name = matches[4]
                send_contact(get_receiver(msg), phone, first_name, last_name, ok_cb, false)
            end
            if matches[1]:lower() == "mycontact" or matches[1]:lower() == "sasha mio contatto" then
                if not msg.from.phone then
                    return lang_text('contactMissing')
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
                return lang_text('chatListSent')
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
                return lang_text('gbansSync')
            end
            if matches[1]:lower() == "backup" or matches[1]:lower() == "sasha esegui backup" then
                local time = os.time()
                local log = io.popen('cd "/home/pi/BACKUPS/" && tar -zcvf backupAISasha' .. time .. '.tar.gz /home/pi/AISashaExp'):read('*all')
                local file = io.open("/home/pi/BACKUPS/backupLog" .. time .. ".txt", "w")
                file:write(log)
                file:flush()
                file:close()
                send_document("user#id" .. msg.from.id, "/home/pi/BACKUPS/backupLog" .. time .. ".txt", ok_cb, false)
                return lang_text('backupDone')
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
                return lang_text('longidUpdate')
            end
        end
        if matches[1]:lower() == 'addlog' or matches[1]:lower() == 'sasha aggiungi log' and not matches[2] then
            if is_log_group(msg) then
                return lang_text('alreadyLog')
            end
            print("Log_SuperGroup " .. msg.to.title .. "(" .. msg.to.id .. ") added")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added Log_SuperGroup")
            logadd(msg)
        end
        if matches[1]:lower() == 'remlog' or matches[1]:lower() == 'sasha rimuovi log' and not matches[2] then
            if not is_log_group(msg) then
                return lang_text('notLog')
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
    description = "ADMIN",
    usage =
    {
        "ADMIN",
        "(#pm|sasha messaggia) <user_id> <msg>: Sasha invia <msg> a <user_id>.",
        "#import <group_link>: Sasha entra nel gruppo tramite <group_link>.",
        "(#block|sasha blocca) <user_id>: Sasha blocca <user_id>.",
        "(#unblock|sasha sblocca) <user_id>: Sasha sblocca <user_id>.",
        "(#markread|sasha segna letto) (on|off): Sasha segna come [non] letti i messaggi ricevuti.",
        "#setbotphoto|sasha cambia foto: Sasha chiede la foto da settare come profilo.",
        "#updateid|sasha aggiorna longid: Sasha salva il long_id.",
        "#addlog|sasha aggiungi log: Sasha aggiunge il log.",
        "#remlog|sasha rimuovi log: Sasha rimuove il log.",
        "SUDO",
        "(#contactlist|sasha lista contatti) (txt|json): Sasha manda la lista dei contatti.",
        "(#dialoglist|sasha lista chat) (txt|json): Sasha manda la lista delle chat.",
        "(#addcontact|sasha aggiungi contatto) <phone> <name> <surname>: Sasha aggiunge il contatto specificato.",
        "(#delcontact|sasha elimina contatto) <user_id>: Sasha elimina il contatto <user_id>.",
        "(#sendcontact|sasha invia contatto) <phone> <name> <surname>: Sasha invia il contatto specificato.",
        "(#mycontact|sasha mio contatto): Sasha invia il contatto del richiedente.",
        "#sync_gbans|sasha sincronizza lista superban: Sasha sincronizza la lista dei superban con quella offerta da TeleSeed.",
        "#backup|sasha esegui backup: Sasha esegue un backup di se stessa e invia il log al richiedente.",
    },
    patterns =
    {
        "^[#!/]([pP][mM]) (%d+) (.*)$",
        "^[#!/]([iI][mM][pP][oO][rR][tT]) (.*)$",
        "^[#!/]([pP][mM][uU][nN][bB][lL][oO][cC][kK]) (%d+)$",
        "^[#!/]([pP][mM][bB][lL][oO][cC][kK]) (%d+)$",
        "^[#!/]([mM][aA][rR][kK][rR][eE][aA][dD]) ([oO][nN])$",
        "^[#!/]([mM][aA][rR][kK][rR][eE][aA][dD]) ([oO][fF][fF])$",
        "^[#!/]([sS][eE][tT][bB][oO][tT][pP][hH][oO][tT][oO])$",
        "^[#!/]([cC][oO][nN][tT][aA][cC][tT][lL][iI][sS][tT])$",
        "^[#!/]([dD][iI][aA][lL][oO][gG][lL][iI][sS][tT])$",
        "^[#!/]([dD][eE][lL][cC][oO][nN][tT][aA][cC][tT]) (%d+)$",
        "^[#!/]([aA][dD][dD][cC][oO][nN][tT][aA][cC][tT]) (.*) (.*) (.*)$",
        "^[#!/]([Ss][Ee][Nn][Dd][Cc][Oo][Nn][Tt][Aa][Cc][Tt]) (.*) (.*) (.*)$",
        "^[#!/]([Mm][Yy][Cc][Oo][Nn][Tt][Aa][Cc][Tt])$",
        "^[#!/]([sS][yY][nN][cC]_[gG][bB][aA][nN][sS])$",
        -- sync your global bans with seed
        "^[#!/]([Bb][Aa][Cc][Kk][Uu][Pp])$",
        "^[#!/]([uU][pP][dD][aA][tT][eE][iI][dD])$",
        "^[#!/]([aA][dD][dD][lL][oO][gG])$",
        "^[#!/]([rR][eE][mM][lL][oO][gG])$",
        "%[(photo)%]",
        -- pm
        "^([sS][aA][sS][hH][aA] [mM][eE][sS][sS][aA][gG][gG][iI][aA]) (%d+) (.*)$",
        -- pmunblock
        "^([sS][aA][sS][hH][aA] [sS][bB][lL][oO][cC][cC][aA]) (%d+)$",
        -- pmblock
        "^([sS][aA][sS][hH][aA] [bB][lL][oO][cC][cC][aA]) (%d+)$",
        -- markread
        "^([sS][aA][sS][hH][aA] [sS][eE][gG][nN][aA] [lL][eE][tT][tT][oO]) ([oO][nN])$",
        "^([sS][aA][sS][hH][aA] [sS][eE][gG][nN][aA] [lL][eE][tT][tT][oO]) ([oO][fF][fF])$",
        -- setbotphoto
        "^([sS][aA][sS][hH][aA] [cC][aA][mM][bB][iI][aA] [fF][oO][tT][oO])$",
        -- contactlist
        "^[#!/]([cC][oO][nN][tT][aA][cC][tT][lL][iI][sS][tT]) ([tT][xX][tT])$",
        "^[#!/]([cC][oO][nN][tT][aA][cC][tT][lL][iI][sS][tT]) ([jJ][sS][oO][nN])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][oO][nN][tT][aA][tT][tT][iI])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][oO][nN][tT][aA][tT][tT][iI]) ([tT][xX][tT])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][oO][nN][tT][aA][tT][tT][iI]) ([jJ][sS][oO][nN])$",
        -- dialoglist
        "^[#!/]([dD][iI][aA][lL][oO][gG][lL][iI][sS][tT]) ([tT][xX][tT])$",
        "^[#!/]([dD][iI][aA][lL][oO][gG][lL][iI][sS][tT]) ([jJ][sS][oO][nN])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][hH][aA][tT])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][hH][aA][tT]) ([tT][xX][tT])$",
        "^([sS][aA][sS][hH][aA] [lL][iI][sS][tT][aA] [cC][hH][aA][tT]) ([jJ][sS][oO][nN])$",
        -- delcontact
        "^([sS][aA][sS][hH][aA] [eE][lL][iI][mM][iI][nN][aA] [cC][oO][nN][tT][aA][tT][tT][oO]) (%d+)$",
        -- addcontact
        "^([sS][aA][sS][hH][aA] [aA][gG][gG][iI][uU][nN][gG][iI] [cC][oO][nN][tT][aA][tT][tT][oO]) (.*) (.*) (.*)$",
        -- sendcontact
        "^([sS][aA][sS][hH][aA] [Ii][Nn][Vv][iI][Aa] [cC][oO][nN][tT][aA][tT][tT][oO]) (.*) (.*) (.*)$",
        -- mycontact
        "^([sS][aA][sS][hH][aA] [Mm][Ii][Oo] [cC][oO][nN][tT][aA][tT][tT][oO])$",
        -- sync_gbans
        "^([sS][aA][sS][hH][aA] [sS][iI][nN][cC][rR][oO][nN][iI][zZ][zZ][aA] [lL][iI][sS][tT][aA] [sS][uU][pP][eE][rR][bB][aA][nN])$",
        -- backup
        "^([sS][aA][sS][hH][aA] [Ee][Ss][Ee][Gg][Uu][Ii] [Bb][Aa][Cc][Kk][Uu][Pp])$",
        -- updateid
        "^[sS][aA][sS][hH][aA] ([aA][gG][gG][iI][oO][rR][nN][aA] [lL][oO][nN][gG][iI][dD])$",
        -- addlog
        "^[sS][aA][sS][hH][aA] ([aA][gG][gG][iI][uU][nN][gG][iI] [lL][oO][gG])$",
        -- remlog
        "^[sS][aA][sS][hH][aA] ([rR][iI][mM][uU][oO][vV][iI] [lL][oO][gG])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 4
}
-- By @imandaneshi :)
-- https://github.com/SEEDTEAM/TeleSeed/blob/test/plugins/admin.lua
--- Modified by @Rondoozle for supergroups