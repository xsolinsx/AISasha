local function lock_group_namemod(msg, data, target)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'yes' then
        return lang_text('nameAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_name'] = 'yes'
        save_data(_config.moderation.data, data)
        rename_chat('chat#id' .. target, group_name_set, ok_cb, false)
        return lang_text('nameLocked')
    end
end

local function unlock_group_namemod(msg, data, target)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'no' then
        return lang_text('nameAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_name'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('nameUnocked')
    end
end

local function lock_group_floodmod(msg, data, target)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'yes' then
        return lang_text('floodAlreadyLocked')
    else
        data[tostring(target)]['settings']['flood'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('floodLocked')
    end
end

local function unlock_group_floodmod(msg, data, target)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'no' then
        return lang_text('floodAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['flood'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('floodUnlocked')
    end
end

local function lock_group_membermod(msg, data, target)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'yes' then
        return lang_text('membersAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_member'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('membersLocked')
    end
end

local function unlock_group_membermod(msg, data, target)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'no' then
        return lang_text('membersAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_member'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('membersUnlocked')
    end
end

local function lock_group_photomod(msg, data, target)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'yes' then
        return lang_text('photoAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_photo'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('photoLocked')
    end
end

local function unlock_group_photomod(msg, data, target)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'no' then
        return lang_text('photoAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_photo'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('photoUnlocked')
    end
end

local function lock_group_arabic(msg, data, target)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'yes' then
        return lang_text('arabicAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('arabicLocked')
    end
end

local function unlock_group_arabic(msg, data, target)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'no' then
        return lang_text('arabicAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('arabicUnlocked')
    end
end

local function lock_group_links(msg, data, target)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'yes' then
        return lang_text('linksAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_link'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('linkLocked')
    end
end

local function unlock_group_links(msg, data, target)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'no' then
        return lang_text('linksAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_link'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('linksUnlocked')
    end
end

local function lock_group_spam(msg, data, target)

    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'yes' then
        return lang_text('spamAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_spam'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('spamLocked')
    end
end

local function unlock_group_spam(msg, data, target)

    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'no' then
        return lang_text('spamAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_spam'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('spamUnlocked')
    end
end

local function lock_group_sticker(msg, data, target)

    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'yes' then
        return lang_text('stickersAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('stickersLocked')
    end
end

local function unlock_group_sticker(msg, data, target)

    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'no' then
        return lang_text('stickersAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('stickersUnlocked')
    end
end

local function lock_group_contacts(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'yes' then
        return lang_text('contactsAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('contactsLocked')
    end
end

local function unlock_group_contacts(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'no' then
        return lang_text('contactsAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('contactsUnlocked')
    end
end

local function enable_strict_rules(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['strict']
    if strict == 'yes' then
        return lang_text('strictrulesAlreadyLocked')
    else
        data[tostring(target)]['settings']['strict'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('strictrulesLocked')
    end
end

local function disable_strict_rules(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_contacts_lock = data[tostring(target)]['settings']['strict']
    if strict == 'no' then
        return lang_text('strictrulesAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['strict'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('strictrulesUnlocked')
    end
end

-- Show group settings
local function show_group_settingsmod(msg, data, target)
    if data[tostring(target)] then
        if data[tostring(target)]['settings']['flood_msg_max'] then
            NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
            print('custom' .. NUM_MSG_MAX)
        else
            NUM_MSG_MAX = 5
        end
    end
    local bots_protection = "Yes"
    if data[tostring(target)]['settings']['lock_bots'] then
        bots_protection = data[tostring(target)]['settings']['lock_bots']
    end
    local leave_ban = "no"
    if data[tostring(target)]['settings']['leave_ban'] then
        leave_ban = data[tostring(target)]['settings']['leave_ban']
    end
    local public = "no"
    if data[tostring(target)]['settings'] then
        if data[tostring(target)]['settings']['public'] then
            public = data[tostring(target)]['settings']['public']
        end
    end
    local settings = data[tostring(target)]['settings']
    local text = lang_text('groupSettings') ..
    lang_text('nameLock') .. settings.lock_name ..
    lang_text('photoLock') .. settings.lock_photo ..
    lang_text('membersLock') .. settings.lock_member ..
    lang_text('leaveLock') .. leave_ban ..
    lang_text('floodSensibility') .. NUM_MSG_MAX ..
    lang_text('botsLock') .. bots_protection ..
    lang_text('public') .. public
    return text
end

-- Show SuperGroup settings
local function show_super_group_settings(msg, data, target)
    if data[tostring(target)] then
        if data[tostring(target)]['settings']['flood_msg_max'] then
            NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
            print('custom' .. NUM_MSG_MAX)
        else
            NUM_MSG_MAX = 5
        end
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['public'] then
            data[tostring(target)]['settings']['public'] = 'no'
        end
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['lock_rtl'] then
            data[tostring(target)]['settings']['lock_rtl'] = 'no'
        end
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['lock_member'] then
            data[tostring(target)]['settings']['lock_member'] = 'no'
        end
    end
    local settings = data[tostring(target)]['settings']
    local text = lang_text('supergroupSettings') .. target ..
    lang_text('linksLock') .. settings.lock_link ..
    lang_text('floodLock') .. settings.flood ..
    lang_text('spamLock') .. settings.lock_spam ..
    lang_text('arabicLock') .. settings.lock_arabic ..
    lang_text('membersLock') .. settings.lock_member ..
    lang_text('rtlLock') .. settings.lock_rtl ..
    lang_text('stickersLock') .. settings.lock_sticker ..
    lang_text('public') .. settings.public ..
    lang_text('strictrules') .. settings.strict
    return text
end

local function set_rules(target, rules)
    local data = load_data(_config.moderation.data)
    local data_cat = 'rules'
    data[tostring(target)][data_cat] = rules
    save_data(_config.moderation.data, data)
    return lang_text('newRules') .. rules
end

local function set_description(target, about)
    local data = load_data(_config.moderation.data)
    local data_cat = 'description'
    data[tostring(target)][data_cat] = about
    save_data(_config.moderation.data, data)
    return lang_text('newDescription') .. about
end

local function run(msg, matches)
    if msg.to.type == 'user' then
        if is_owner2(msg.from.id, chat_id) then
            local print_name = user_print_name(msg.from):gsub("‮", "")
            local name = print_name:gsub("_", " ")
            local chat_id = matches[1]
            local receiver = get_receiver(msg)
            local data = load_data(_config.moderation.data)
            if matches[2]:lower() == 'ban' then
                local chat_id = matches[1]
                if tonumber(matches[3]) == tonumber(our_id) then return false end
                local user_id = matches[3]
                if tonumber(matches[3]) == tonumber(msg.from.id) then
                    return lang_text('noAutoBan')
                end
                ban_user(matches[3], matches[1])
                local name = user_print_name(msg.from)
                savelog(matches[1], name .. " [" .. msg.from.id .. "] banned user " .. matches[3])
                return lang_text('user') .. user_id .. lang_text('banned')
            end

            if matches[2]:lower() == 'unban' then
                if tonumber(matches[3]) == tonumber(our_id) then return false end
                local chat_id = matches[1]
                local user_id = matches[3]
                if tonumber(matches[3]) == tonumber(msg.from.id) then
                    return lang_text('noAutoUnban')
                end
                local hash = 'banned:' .. matches[1]
                redis:srem(hash, user_id)
                savelog(matches[1], name .. " [" .. msg.from.id .. "] unbanned user " .. matches[3])
                return lang_text('user') .. user_id .. lang_text('unbanned')
            end

            if matches[2]:lower() == 'kick' then
                local chat_id = matches[1]
                if tonumber(matches[3]) == tonumber(our_id) then return false end
                local user_id = matches[3]
                if tonumber(matches[3]) == tonumber(msg.from.id) then
                    return lang_text('noAutoKick')
                end
                kick_user(matches[3], chat_id)
                savelog(matches[1], name .. " [" .. msg.from.id .. "] kicked user " .. matches[3])
                return lang_text('user') .. user_id .. lang_text('kicked')
            end

            if matches[2]:lower() == 'clean' then
                if matches[3]:lower() == 'modlist' then
                    for k, v in pairs(data[tostring(matches[1])]['moderators']) do
                        data[tostring(matches[1])]['moderators'][tostring(k)] = nil
                        save_data(_config.moderation.data, data)
                    end
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] cleaned modlist")
                    return lang_text('modlistCleaned')
                end
                if matches[3]:lower() == 'rules' then
                    local data_cat = 'rules'
                    data[tostring(matches[1])][data_cat] = nil
                    save_data(_config.moderation.data, data)
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] cleaned rules")
                    return lang_text('rulesCleaned')
                end
                if matches[3]:lower() == 'about' then
                    local data_cat = 'description'
                    data[tostring(matches[1])][data_cat] = nil
                    save_data(_config.moderation.data, data)
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] cleaned about")
                    channel_set_about(receiver, about_text, ok_cb, false)
                    return lang_text('descriptionCleaned')
                end
                if matches[3]:lower() == 'mutelist' then
                    chat_id = string.match(matches[1], '^%d+$')
                    local hash = 'mute_user:' .. chat_id
                    redis:del(hash)
                    return lang_text('mutelistCleaned')
                end
            end

            if matches[2]:lower() == "setflood" then
                if tonumber(matches[3]) < 3 or tonumber(matches[3]) > 200 then
                    return lang_text('errorFloodRange')
                end
                local flood_max = matches[3]
                data[tostring(matches[1])]['settings']['flood_msg_max'] = flood_max
                save_data(_config.moderation.data, data)
                savelog(matches[1], name .. " [" .. msg.from.id .. "] set flood to [" .. matches[3] .. "]")
                return lang_text('floodSet') .. matches[3]
            end

            if matches[2]:lower() == 'lock' then
                local target = matches[1]
                local group_type = data[tostring(matches[1])]['group_type']
                if matches[3]:lower() == 'name' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked name ")
                    return lock_group_namemod(msg, data, target)
                end
                if matches[3]:lower() == 'member' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked member ")
                    return lock_group_membermod(msg, data, target)
                end
                if matches[3]:lower() == 'arabic' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked arabic ")
                    return lock_group_arabic(msg, data, target)
                end
                if matches[3]:lower() == 'links' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked links ")
                    return lock_group_links(msg, data, target)
                end
                if matches[3]:lower() == 'spam' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked spam ")
                    return lock_group_spam(msg, data, target)
                end
                if matches[3]:lower() == 'rtl' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked RTL chars. in names")
                    return unlock_group_rtl(msg, data, target)
                end
                if matches[3]:lower() == 'sticker' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] locked sticker")
                    return lock_group_sticker(msg, data, target)
                end

            end

            if matches[2]:lower() == 'unlock' then
                local target = matches[1]
                local group_type = data[tostring(matches[1])]['group_type']
                if matches[3]:lower() == 'name' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked name ")
                    return unlock_group_namemod(msg, data, target)
                end
                if matches[3]:lower() == 'member' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked member ")
                    return unlock_group_membermod(msg, data, target)
                end
                if matches[3]:lower() == 'arabic' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked arabic ")
                    return unlock_group_arabic(msg, data, target)
                end
                if matches[3]:lower() == 'links' and group_type == "SuperGroup" then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked links ")
                    return unlock_group_links(msg, data, target)
                end
                if matches[3]:lower() == 'spam' and group_type == "SuperGroup" then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked spam ")
                    return unlock_group_spam(msg, data, target)
                end
                if matches[3]:lower() == 'rtl' then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked RTL chars. in names")
                    return unlock_group_rtl(msg, data, target)
                end
                if matches[3]:lower() == 'sticker' and group_type == "SuperGroup" then
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] unlocked sticker")
                    return unlock_group_sticker(msg, data, target)
                end
                if matches[3]:lower() == 'contacts' and group_type == "SuperGroup" then
                    savelog(matches[1], name_log .. " [" .. msg.from.id .. "] locked contact posting")
                    return lock_group_contacts(msg, data, target)
                end
                if matches[3]:lower() == 'strict' and group_type == "SuperGroup" then
                    savelog(matches[1], name_log .. " [" .. msg.from.id .. "] locked enabled strict settings")
                    return enable_strict_rules(msg, data, target)
                end
            end

            if matches[2]:lower() == 'new' then
                if matches[3]:lower() == 'link' then
                    local group_type = data[tostring(matches[1])]['group_type']
                    local function callback_grouplink(extra, success, result)
                        local receiver = 'chat#id' .. matches[1]
                        if success == 0 then
                            send_large_msg(receiver, lang_text('errorCreateLink'))
                        end
                        data[tostring(matches[1])]['settings']['set_link'] = result
                        save_data(_config.moderation.data, data)
                        return
                    end
                    local function callback_superlink(extra, success, result)
                        vardump(result)
                        local receiver = 'channel#id' .. matches[1]
                        local user = extra.user
                        if success == 0 then
                            data[tostring(matches[1])]['settings']['set_link'] = nil
                            save_data(_config.moderation.data, data)
                            return send_large_msg(user, lang_text('errorCreateSuperLink'))
                        else
                            data[tostring(matches[1])]['settings']['set_link'] = result
                            save_data(_config.moderation.data, data)
                            return send_large_msg(user, lang_text('linkCreated'))
                        end
                    end
                    if group_type == "Group" then
                        local receiver = 'chat#id' .. matches[1]
                        savelog(matches[1], name .. " [" .. msg.from.id .. "] created/revoked group link ")
                        export_chat_link(receiver, callback_grouplink, false)
                        return lang_text('linkCreated')
                    elseif group_type == "SuperGroup" then
                        local receiver = 'channel#id' .. matches[1]
                        local user = 'user#id' .. msg.from.id
                        savelog(matches[1], name .. " [" .. msg.from.id .. "] attempted to create a new SuperGroup link")
                        export_channel_link(receiver, callback_superlink, { user = user })
                    end
                end
            end

            if matches[2]:lower() == 'get' then
                if matches[3]:lower() == 'link' then
                    local group_link = data[tostring(matches[1])]['settings']['set_link']
                    if not group_link then
                        return lang_text('createLinkInfo')
                    end
                    savelog(matches[1], name .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
                    return lang_text('groupLink') .. group_link
                end
            end

            if matches[1]:lower() == 'changeabout' and matches[2] then
                local group_type = data[tostring(matches[2])]['group_type']
                if group_type == "Group" or group_type == "Realm" then
                    local target = matches[2]
                    local about = matches[3]
                    local name = user_print_name(msg.from)
                    savelog(matches[2], name .. " [" .. msg.from.id .. "] has changed group description to [" .. matches[3] .. "]")
                    return set_description(target, about)
                elseif group_type == "SuperGroup" then
                    local channel = 'channel#id' .. matches[2]
                    local about_text = matches[3]
                    local data_cat = 'description'
                    local target = matches[2]
                    channel_set_about(channel, about_text, ok_cb, false)
                    data[tostring(target)][data_cat] = about_text
                    save_data(_config.moderation.data, data)
                    savelog(matches[2], name .. " [" .. msg.from.id .. "] has changed SuperGroup description to [" .. matches[3] .. "]")
                    return lang_text('newDescription') .. matches[2]
                end
            end

            if matches[1]:lower() == 'viewsettings' and data[tostring(matches[2])]['settings'] then
                local target = matches[2]
                local group_type = data[tostring(matches[2])]['group_type']
                if group_type == "Group" or group_type == "Realm" then
                    savelog(matches[2], name .. " [" .. msg.from.id .. "] requested group settings ")
                    return show_group_settings(msg, data, target)
                elseif group_type == "SuperGroup" then
                    savelog(matches[2], name .. " [" .. msg.from.id .. "] requested SuperGroup settings ")
                    return show_super_group_settings(msg, data, target)
                end
            end

            if matches[1]:lower() == 'changerules' then
                local rules = matches[3]
                local target = matches[2]
                local name = user_print_name(msg.from)
                savelog(matches[2], name .. " [" .. msg.from.id .. "] has changed group rules to [" .. matches[3] .. "]")
                return set_rules(target, rules)
            end
            if matches[1]:lower() == 'changename' then
                local new_name = string.gsub(matches[3], '_', ' ')
                data[tostring(matches[2])]['settings']['set_name'] = new_name
                local group_name_set = data[tostring(matches[2])]['settings']['set_name']
                save_data(_config.moderation.data, data)
                local chat_to_rename = 'chat#id' .. matches[2]
                local channel_to_rename = 'channel#id' .. matches[2]
                savelog(matches[2], "Group name changed to [ " .. new_name .. " ] by " .. name .. " [" .. msg.from.id .. "]")
                rename_chat(chat_to_rename, group_name_set, ok_cb, false)
                rename_channel(channel_to_rename, group_name_set, ok_cb, false)
            end

            if matches[1]:lower() == 'loggroup' and matches[2] then
                savelog(matches[2], "log file created by owner/support/admin")
                send_document("user#id" .. msg.from.id, "./groups/logs/" .. matches[2] .. "log.txt", ok_cb, false)
            end
        else
            return lang_text('notTheOwner')
        end
    end
end

return {
    description = "OWNERS",
    usage =
    {
        -- "🖊[#!/]owners <group_id>: Sasha invia il log di <group_id>.",
        "/changeabout <group_id> <text>: Sasha cambia la descrizione di <group_id> con <text>.",
        "/changerules <group_id> <text>: Sasha cambia le regole di <group_id> con <text>.",
        "/changename <group_id> <text>: Sasha cambia il nome di <group_id> con <text>.",
        "/viewsettings <group_id>: Sasha manda le impostazioni di <group_id>.",
        "/loggroup <group_id>: Sasha invia il log di <group_id>.",
    },
    patterns =
    {
        -- "^[#!/][oO][wW][nN][eE][rR][sS] (%d+) ([^%s]+) (.*)$",
        -- "^[#!/][oO][wW][nN][eE][rR][sS] (%d+) ([^%s]+)$",
        "^[#!/]([cC][hH][aA][nN][gG][eE][aA][bB][oO][uU][tT]) (%d+) (.*)$",
        "^[#!/]([cC][hH][aA][nN][gG][eE][rR][uU][lL][eE][sS]) (%d+) (.*)$",
        "^[#!/]([cC][hH][aA][nN][gG][eE][nN][aA][mM][eE]) (%d+) (.*)$",
        "^[#!/]([vV][iI][eE][wW][sS][eE][tT][tT][iI][nN][gG][sS]) (%d+)$",
        "^[#!/]([lL][oO][gG][gG][rR][oO][uU][pP]) (%d+)$"
    },
    run = run,
    min_rank = 2
}