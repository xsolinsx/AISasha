-- Begin supergroup.lua
-- Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
    if success == 0 then
        send_large_msg(receiver, lang_text('promoteBotAdmin'))
    end
    for k, v in pairs(result) do
        local member_id = v.peer_id
        if member_id ~= our_id then
            -- SuperGroup configuration
            data[tostring(msg.to.id)] = {
                group_type = 'SuperGroup',
                long_id = msg.to.peer_id,
                moderators = { },
                set_owner = member_id,
                settings =
                {
                    set_name = string.gsub(msg.to.title,'_',' '),
                    lock_arabic = 'no',
                    lock_link = "no",
                    flood = 'yes',
                    lock_spam = 'yes',
                    lock_sticker = 'no',
                    member = 'no',
                    public = 'no',
                    lock_rtl = 'no',
                    lock_contacts = 'no',
                    strict = 'no'
                }
            }
            save_data(_config.moderation.data, data)
            local groups = 'groups'
            if not data[tostring(groups)] then
                data[tostring(groups)] = { }
                save_data(_config.moderation.data, data)
            end
            data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
            save_data(_config.moderation.data, data)
            local text = lang_text('supergroupAdded')
            return reply_msg(msg.id, text, ok_cb, false)
        end
    end
end

-- Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
    for k, v in pairs(result) do
        local member_id = v.id
        if member_id ~= our_id then
            -- Group configuration removal
            data[tostring(msg.to.id)] = nil
            save_data(_config.moderation.data, data)
            local groups = 'groups'
            if not data[tostring(groups)] then
                data[tostring(groups)] = nil
                save_data(_config.moderation.data, data)
            end
            data[tostring(groups)][tostring(msg.to.id)] = nil
            save_data(_config.moderation.data, data)
            local text = lang_text('supergroupRemoved')
            return reply_msg(msg.id, text, ok_cb, false)
        end
    end
end

-- Function to Add supergroup
local function superadd(msg)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super, { receiver = receiver, data = data, msg = msg })
end

-- Function to remove supergroup
local function superrem(msg)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem, { receiver = receiver, data = data, msg = msg })
end

-- Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
    local i = 1
    local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
    local member_type = cb_extra.member_type
    local text = member_type .. " " .. chat_name .. ":\n"
    for k, v in pairsByKeys(result) do
        if not v.first_name then
            name = " "
        else
            vname = v.first_name:gsub("‮", "")
            name = vname:gsub("_", " ")
        end
        text = text .. "\n" .. i .. ". " .. name .. " " .. v.peer_id
        i = i + 1
    end
    send_large_msg(cb_extra.receiver, text)
end

-- Get and output info about supergroup
local function callback_info(cb_extra, success, result)
    local title = lang_text('infoFor') .. result.title .. "\n\n"
    local admin_num = lang_text('adminListStart') .. result.admins_count
    local user_num = lang_text('users') .. result.participants_count
    local kicked_num = lang_text('kickedUsers') .. result.kicked_count
    local channel_id = "\nID: " .. result.peer_id
    if result.username then
        channel_username = lang_text('username') .. "@" .. result.username
    else
        channel_username = ""
    end
    local text = title .. admin_num .. user_num .. kicked_num .. channel_id .. channel_username
    send_large_msg(cb_extra.receiver, text)
end

-- Get and output members of supergroup
local function callback_who(cb_extra, success, result)
    local text = lang_text('membersOf') .. cb_extra.receiver
    local i = 1
    for k, v in pairsByKeys(result) do
        if not v.print_name then
            name = " "
        else
            vname = v.print_name:gsub("‮", "")
            name = vname:gsub("_", " ")
        end
        if v.username then
            username = " @" .. v.username
        else
            username = ""
        end
        text = text .. "\n" .. i .. ". " .. name .. " " .. username .. " " .. v.peer_id .. "\n"
        -- text = text.."\n"..username
        i = i + 1
    end
    local file = io.open("./groups/lists/supergroups/" .. cb_extra.receiver .. ".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver, "./groups/lists/supergroups/" .. cb_extra.receiver .. ".txt", ok_cb, false)
    post_msg(cb_extra.receiver, text, ok_cb, false)
end

-- Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
    -- vardump(result)
    local text = lang_text('membersKickedFrom') .. cb_extra.receiver .. "\n\n"
    local i = 1
    for k, v in pairsByKeys(result) do
        if not v.print_name then
            name = " "
        else
            vname = v.print_name:gsub("‮", "")
            name = vname:gsub("_", " ")
        end
        if v.username then
            name = name .. " @" .. v.username
        end
        text = text .. "\n" .. i .. ". " .. name .. " " .. v.peer_id .. "\n"
        i = i + 1
    end
    local file = io.open("./groups/lists/supergroups/kicked/" .. cb_extra.receiver .. ".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver, "./groups/lists/supergroups/kicked/" .. cb_extra.receiver .. ".txt", ok_cb, false)
    -- send_large_msg(cb_extra.receiver, text)
end

-- Begin supergroup locks
local function lock_group_links(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'yes' then
        return lang_text('linksAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_link'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('linksLocked')
    end
end

local function unlock_group_links(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'no' then
        return lang_text('spamAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_spam'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('spamUnlocked')
    end
end

local function lock_group_flood(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'yes' then
        return lang_text('floodAlreadyLocked')
    else
        data[tostring(target)]['settings']['flood'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('floodLocked')
    end
end

local function unlock_group_flood(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'no' then
        return lang_text('floodAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['flood'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('floodUnlocked')
    end
end

local function lock_group_arabic(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'no' then
        return lang_text('arabicAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('arabicUnlocked')
    end
end

local function lock_group_membermod(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'no' then
        return lang_text('membersAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_member'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('membersUnlocked')
    end
end

local function lock_group_rtl(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'yes' then
        return lang_text('rtlAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('rtlLocked')
    end
end

local function unlock_group_rtl(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'no' then
        return lang_text('rtlAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('rtlUnlocked')
    end
end

local function lock_group_sticker(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
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
        return lang_text('require_mod')
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
        return lang_text('require_mod')
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
        return lang_text('require_mod')
    end
    local group_strict_lock = data[tostring(target)]['settings']['strict']
    if group_strict_lock == 'yes' then
        return lang_text('strictrulesAlreadyLocked')
    else
        data[tostring(target)]['settings']['strict'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('strictrulesLocked')
    end
end

local function disable_strict_rules(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_strict_lock = data[tostring(target)]['settings']['strict']
    if group_strict_lock == 'no' then
        return lang_text('strictrulesAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['strict'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('strictrulesUnlocked')
    end
end
-- End supergroup locks

-- 'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local data_cat = 'rules'
    data[tostring(target)][data_cat] = rules
    save_data(_config.moderation.data, data)
    return lang_text('newRules')
end

-- 'Get supergroup rules' function
local function get_rules(msg, data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noRules')
    end
    local rules = data[tostring(msg.to.id)][data_cat]
    local group_name = data[tostring(msg.to.id)]['settings']['set_name']
    local rules = group_name .. lang_text('rules') .. '\n\n' .. rules:gsub("/n", " ")
    return rules
end

-- Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local group_public_lock = data[tostring(target)]['settings']['public']
    local long_id = data[tostring(target)]['long_id']
    if not long_id then
        data[tostring(target)]['long_id'] = msg.to.peer_id
        save_data(_config.moderation.data, data)
    end
    if group_public_lock == 'yes' then
        return lang_text('publicAlreadyYes')
    else
        data[tostring(target)]['settings']['public'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('publicYes')
    end
end

local function unset_public_membermod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_public_lock = data[tostring(target)]['settings']['public']
    local long_id = data[tostring(target)]['long_id']
    if not long_id then
        data[tostring(target)]['long_id'] = msg.to.peer_id
        save_data(_config.moderation.data, data)
    end
    if group_public_lock == 'no' then
        return lang_text('publicAlreadyNo')
    else
        data[tostring(target)]['settings']['public'] = 'no'
        data[tostring(target)]['long_id'] = msg.to.long_id
        save_data(_config.moderation.data, data)
        return lang_text('publicNo')
    end
end

-- Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
    if not is_momod(msg) then
        return
    end
    local data = load_data(_config.moderation.data)
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
    local text = lang_text('supergroupSettings') ..
    lang_text('linksLock') .. settings.lock_link ..
    lang_text('flood') .. settings.flood ..
    lang_text('floodSensibility') .. NUM_MSG_MAX ..
    lang_text('spamLock') .. settings.lock_spam ..
    lang_text('arabicLock') .. settings.lock_arabic ..
    lang_text('membersLock') .. settings.lock_member ..
    lang_text('rtlLock') .. settings.lock_rtl ..
    lang_text('stickersLock') .. settings.lock_sticker ..
    lang_text('public') .. settings.public ..
    lang_text('strictrules') .. settings.strict
    return text
end

local function promote_admin(receiver, member_username, user_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'channel#id', '')
    local member_tag_username = string.gsub(member_username, '@', '(at)')
    if not data[group] then
        return
    end
    if data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. lang_text('alreadyMod'))
    end
    data[group]['moderators'][tostring(user_id)] = member_tag_username
    save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'channel#id', '')
    if not data[group] then
        return
    end
    if not data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. lang_text('notMod'))
    end
    data[group]['moderators'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'channel#id', '')
    local member_tag_username = string.gsub(member_username, '@', '(at)')
    if not data[group] then
        return send_large_msg(receiver, lang_text('supergroupNotAdded'))
    end
    if data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. lang_text('alreadyMod'))
    end
    data[group]['moderators'][tostring(user_id)] = member_tag_username
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, member_username .. lang_text('promoteMod'))
end

local function demote2(receiver, member_username, user_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'channel#id', '')
    if not data[group] then
        return send_large_msg(receiver, lang_text('supergroupNotAdded'))
    end
    if not data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. lang_text('notMod'))
    end
    data[group]['moderators'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, member_username .. lang_text('demoteMod'))
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local groups = "groups"
    if not data[tostring(groups)][tostring(msg.to.id)] then
        return lang_text('supergroupNotAdded')
    end
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['moderators']) == nil then
        return lang_text('noGroupMods')
    end
    local i = 1
    local message = lang_text('modListStart') .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
    for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
        message = message .. i .. '. ' .. v .. ' - ' .. k .. '\n'
        i = i + 1
    end
    return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
    local get_cmd = extra.get_cmd
    local msg = extra.msg
    local data = load_data(_config.moderation.data)
    local print_name = user_print_name(msg.from):gsub("‮", "")
    local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
        local channel = 'channel#id' .. result.to.peer_id
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] obtained id for: [" .. result.from.peer_id .. "]")
        id1 = send_large_msg(channel, result.from.peer_id)
    elseif get_cmd == 'id' and result.action then
        local action = result.action.type
        if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
            if result.action.user then
                user_id = result.action.user.peer_id
            else
                user_id = result.peer_id
            end
            local channel = 'channel#id' .. result.to.peer_id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] obtained id by service msg for: [" .. user_id .. "]")
            id1 = send_large_msg(channel, user_id)
        end
    elseif get_cmd == "idfrom" then
        local channel = 'channel#id' .. result.to.peer_id
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] obtained id for msg fwd from: [" .. result.fwd_from.peer_id .. "]")
        id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
        local member_id = result.from.peer_id
        local channel_id = result.to.peer_id
        if member_id == msg.from.id then
            return send_large_msg("channel#id" .. channel_id, lang_text('leftKickme'))
        end
        if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
            return send_large_msg("channel#id" .. channel_id, lang_text('cantKickHigher'))
        end
        if is_admin2(member_id) then
            return send_large_msg("channel#id" .. channel_id, lang_text('cantKickOtherAdmin'))
        end
        -- savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
        kick_user(member_id, channel_id)
    elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
        local user_id = result.action.user.peer_id
        local channel_id = result.to.peer_id
        if member_id == msg.from.id then
            return send_large_msg("channel#id" .. channel_id, lang_text('leftKickme'))
        end
        if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
            return send_large_msg("channel#id" .. channel_id, lang_text('cantKickHigher'))
        end
        if is_admin2(member_id) then
            return send_large_msg("channel#id" .. channel_id, lang_text('cantKickOtherAdmin'))
        end
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] kicked: [" .. user_id .. "] by reply to sev. msg.")
        kick_user(user_id, channel_id)
    elseif get_cmd == "del" then
        delete_msg(result.id, ok_cb, false)
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] deleted a message by reply")
    elseif get_cmd == "setadmin" then
        local user_id = result.from.peer_id
        local channel_id = "channel#id" .. result.to.peer_id
        channel_set_admin(channel_id, "user#id" .. user_id, ok_cb, false)
        if result.from.username then
            text = "@" .. result.from.username .. lang_text('promoteSupergroupMod')
        else
            text = user_id .. lang_text('promoteSupergroupMod')
        end
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted: [" .. user_id .. "] as admin by reply")
        send_large_msg(channel_id, text)
    elseif get_cmd == "demoteadmin" then
        local user_id = result.from.peer_id
        local channel_id = "channel#id" .. result.to.peer_id
        if is_admin2(result.from.peer_id) then
            return send_large_msg(channel_id, lang_text('cantDemoteOtherAdmin'))
        end
        channel_demote(channel_id, "user#id" .. user_id, ok_cb, false)
        if result.from.username then
            text = "@" .. result.from.username .. lang_text('demoteSupergroupMod')
        else
            text = user_id .. lang_text('demoteSupergroupMod')
        end
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted: [" .. user_id .. "] as admin by reply")
        send_large_msg(channel_id, text)
    elseif get_cmd == "setowner" then
        local group_owner = data[tostring(result.to.peer_id)]['set_owner']
        if group_owner then
            local channel_id = 'channel#id' .. result.to.peer_id
            if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
                local user = "user#id" .. group_owner
                channel_demote(channel_id, user, ok_cb, false)
            end
            local user_id = "user#id" .. result.from.peer_id
            channel_set_admin(channel_id, user_id, ok_cb, false)
            data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
            save_data(_config.moderation.data, data)
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set: [" .. result.from.peer_id .. "] as owner by reply")
            if result.from.username then
                text = "@" .. result.from.username .. " " .. result.from.peer_id .. lang_text('setOwner')
            else
                text = result.from.peer_id .. lang_text('setOwner')
            end
            send_large_msg(channel_id, text)
        end
    elseif get_cmd == "promote" then
        local receiver = result.to.peer_id
        local full_name =(result.from.first_name or '') .. ' ' ..(result.from.last_name or '')
        local member_name = full_name:gsub("‮", "")
        local member_username = member_name:gsub("_", " ")
        if result.from.username then
            member_username = '@' .. result.from.username
        end
        local member_id = result.from.peer_id
        if result.to.peer_type == 'channel' then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted mod: @" .. member_username .. "[" .. result.from.peer_id .. "] by reply")
            promote2("channel#id" .. result.to.peer_id, member_username, member_id)
            -- channel_set_mod(channel_id, user, ok_cb, false)
        end
    elseif get_cmd == "demote" then
        local full_name =(result.from.first_name or '') .. ' ' ..(result.from.last_name or '')
        local member_name = full_name:gsub("‮", "")
        local member_username = member_name:gsub("_", " ")
        if result.from.username then
            member_username = '@' .. result.from.username
        end
        local member_id = result.from.peer_id
        -- local user = "user#id"..result.peer_id
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted mod: @" .. member_username .. "[" .. result.from.peer_id .. "] by reply")
        demote2("channel#id" .. result.to.peer_id, member_username, member_id)
        -- channel_demote(channel_id, user, ok_cb, false)
    elseif get_cmd == 'mute_user' then
        if result.service then
            local action = result.action.type
            if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
                if result.action.user then
                    user_id = result.action.user.peer_id
                end
            end
            if action == 'chat_add_user_link' then
                if result.from then
                    user_id = result.from.peer_id
                end
            end
        else
            user_id = result.from.peer_id
        end
        local receiver = extra.receiver
        local chat_id = msg.to.id
        print(user_id)
        print(chat_id)
        if is_muted_user(chat_id, user_id) then
            unmute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserRemove'))
        elseif is_momod(msg) then
            mute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
        end
    end
end
-- End by reply actions

-- By ID actions
local function cb_user_info(extra, success, result)
    local receiver = extra.receiver
    local user_id = result.peer_id
    local get_cmd = extra.get_cmd
    local data = load_data(_config.moderation.data)
    --[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
    if get_cmd == "demoteadmin" then
        if is_admin2(result.peer_id) then
            return send_large_msg(receiver, lang_text('cantDemoteOtherAdmin'))
        end
        local user_id = "user#id" .. result.peer_id
        channel_demote(receiver, user_id, ok_cb, false)
        if result.username then
            text = "@" .. result.username .. lang_text('demoteSupergroupMod')
            send_large_msg(receiver, text)
        else
            text = result.peer_id .. lang_text('demoteSupergroupMod')
            send_large_msg(receiver, text)
        end
    elseif get_cmd == "promote" then
        if result.username then
            member_username = "@" .. result.username
        else
            member_username = string.gsub(result.print_name, '_', ' ')
        end
        promote2(receiver, member_username, user_id)
    elseif get_cmd == "demote" then
        if result.username then
            member_username = "@" .. result.username
        else
            member_username = string.gsub(result.print_name, '_', ' ')
        end
        demote2(receiver, member_username, user_id)
    end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
    local member_id = result.peer_id
    local member_username = "@" .. result.username
    local get_cmd = extra.get_cmd
    if get_cmd == "res" then
        local user = result.peer_id
        local name = string.gsub(result.print_name, "_", " ")
        local channel = 'channel#id' .. extra.channelid
        send_large_msg(channel, user .. '\n' .. name)
        return user
    elseif get_cmd == "id" then
        local user = result.peer_id
        local channel = 'channel#id' .. extra.channelid
        send_large_msg(channel, user)
        return user
    elseif get_cmd == "invite" then
        local receiver = extra.channel
        local user_id = "user#id" .. result.peer_id
        channel_invite(receiver, user_id, ok_cb, false)
        --[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, lang_text('leftKickme'))
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, lang_text('cantKickHigher'))
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, lang_text('cantKickOtherAdmin'))
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username..lang_text('promoteSupergroupMod')
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id..lang_text('promoteSupergroupMod')
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.." "..result.peer_id..lang_text('setOwner')
		else
			text = result.peer_id..lang_text('setOwner')
		end
		send_large_msg(receiver, text)
  end]]
    elseif get_cmd == "promote" then
        local receiver = extra.channel
        local user_id = result.peer_id
        -- local user = "user#id"..result.peer_id
        promote2(receiver, member_username, user_id)
        -- channel_set_mod(receiver, user, ok_cb, false)
    elseif get_cmd == "demote" then
        local receiver = extra.channel
        local user_id = result.peer_id
        local user = "user#id" .. result.peer_id
        demote2(receiver, member_username, user_id)
    elseif get_cmd == "demoteadmin" then
        local user_id = "user#id" .. result.peer_id
        local channel_id = extra.channel
        if is_admin2(result.peer_id) then
            return send_large_msg(channel_id, lang_text('cantDemoteOtherAdmin'))
        end
        channel_demote(channel_id, user_id, ok_cb, false)
        if result.username then
            text = "@" .. result.username .. lang_text('demoteSupergroupMod')
            send_large_msg(channel_id, text)
        else
            text = "@" .. result.peer_id .. lang_text('demoteSupergroupMod')
            send_large_msg(channel_id, text)
        end
        local receiver = extra.channel
        local user_id = result.peer_id
        demote_admin(receiver, member_username, user_id)
    elseif get_cmd == 'mute_user' then
        local user_id = result.peer_id
        local receiver = extra.receiver
        local chat_id = string.gsub(receiver, 'channel#id', '')
        if is_muted_user(chat_id, user_id) then
            unmute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserRemove'))
        elseif is_owner(extra.msg) then
            mute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
        end
    end
end
-- End resolve username actions

-- Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
    local get_cmd = cb_extra.get_cmd
    local receiver = cb_extra.receiver
    local msg = cb_extra.msg
    local data = load_data(_config.moderation.data)
    local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
    local name_log = print_name:gsub("_", " ")
    local member = cb_extra.username
    local memberid = cb_extra.user_id
    if member then
        text = lang_text('none') .. '@' .. member .. lang_text('inThisSupergroup')
    else
        text = lang_text('none') .. memberid .. lang_text('inThisSupergroup')
    end
    if get_cmd == "channel_block" then
        for k, v in pairs(result) do
            vusername = v.username
            vpeer_id = tostring(v.peer_id)
            if vusername == member or vpeer_id == memberid then
                local user_id = v.peer_id
                local channel_id = cb_extra.msg.to.id
                local sender = cb_extra.msg.from.id
                if user_id == sender then
                    return send_large_msg("channel#id" .. channel_id, lang_text('leftKickme'))
                end
                if is_momod2(user_id, channel_id) and not is_admin2(sender) then
                    return send_large_msg("channel#id" .. channel_id, lang_text('cantKickHigher'))
                end
                if is_admin2(user_id) then
                    return send_large_msg("channel#id" .. channel_id, lang_text('cantKickOtherAdmin'))
                end
                if v.username then
                    text = ""
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] kicked: @" .. v.username .. " [" .. v.peer_id .. "]")
                else
                    text = ""
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] kicked: [" .. v.peer_id .. "]")
                end
                kick_user(user_id, channel_id)
            end
        end
    elseif get_cmd == "setadmin" then
        for k, v in pairs(result) do
            vusername = v.username
            vpeer_id = tostring(v.peer_id)
            if vusername == member or vpeer_id == memberid then
                local user_id = "user#id" .. v.peer_id
                local channel_id = "channel#id" .. cb_extra.msg.to.id
                channel_set_admin(channel_id, user_id, ok_cb, false)
                if v.username then
                    text = "@" .. v.username .. " " .. v.peer_id .. lang_text('promoteSupergroupMod')
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set admin @" .. v.username .. " [" .. v.peer_id .. "]")
                else
                    text = v.peer_id .. lang_text('promoteSupergroupMod')
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set admin " .. v.peer_id)
                end
                if v.username then
                    member_username = "@" .. v.username
                else
                    member_username = string.gsub(v.print_name, '_', ' ')
                end
                local receiver = channel_id
                local user_id = v.peer_id
                promote_admin(receiver, member_username, user_id)
            end
            send_large_msg(channel_id, text)
        end
    elseif get_cmd == 'setowner' then
        for k, v in pairs(result) do
            vusername = v.username
            vpeer_id = tostring(v.peer_id)
            if vusername == member or vpeer_id == memberid then
                local channel = string.gsub(receiver, 'channel#id', '')
                local from_id = cb_extra.msg.from.id
                local group_owner = data[tostring(channel)]['set_owner']
                if group_owner then
                    if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
                        local user = "user#id" .. group_owner
                        channel_demote(receiver, user, ok_cb, false)
                    end
                    local user_id = "user#id" .. v.peer_id
                    channel_set_admin(receiver, user_id, ok_cb, false)
                    data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
                    save_data(_config.moderation.data, data)
                    savelog(channel, name_log .. "[" .. from_id .. "] set [" .. v.peer_id .. "] as owner by username")
                    if result.username then
                        text = member_username .. " " .. v.peer_id .. lang_text('setOwner')
                    else
                        text = v.peer_id .. lang_text('setOwner')
                    end
                end
            elseif memberid and vusername ~= member and vpeer_id ~= memberid then
                local channel = string.gsub(receiver, 'channel#id', '')
                local from_id = cb_extra.msg.from.id
                local group_owner = data[tostring(channel)]['set_owner']
                if group_owner then
                    if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
                        local user = "user#id" .. group_owner
                        channel_demote(receiver, user, ok_cb, false)
                    end
                    data[tostring(channel)]['set_owner'] = tostring(memberid)
                    save_data(_config.moderation.data, data)
                    savelog(channel, name_log .. "[" .. from_id .. "] set [" .. memberid .. "] as owner by username")
                    text = memberid .. lang_text('setOwner')
                end
            end
        end
    end
    send_large_msg(receiver, text)
end
-- End non-channel_invite username actions

-- 'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/channel_photo_' .. msg.to.id .. '.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        channel_set_photo(receiver, file, ok_cb, false)
        data[tostring(msg.to.id)]['settings']['set_photo'] = file
        save_data(_config.moderation.data, data)
        send_large_msg(receiver, lang_text('photoSaved'), ok_cb, false)
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, lang_text('errorTryAgain'), ok_cb, false)
    end
end

-- Run function
local function run(msg, matches)
    if msg.to.type == 'chat' then
        if matches[1]:lower() == 'tosuper' then
            if not is_admin1(msg) then
                return
            end
            local receiver = get_receiver(msg)
            chat_upgrade(receiver, ok_cb, false)
        end
    elseif msg.to.type == 'channel' then
        if matches[1]:lower() == 'tosuper' then
            if not is_admin1(msg) then
                return
            end
            return lang_text('errorAlreadySupergroup')
        end
    end
    if msg.to.type == 'channel' then
        local support_id = msg.from.id
        local receiver = get_receiver(msg)
        local print_name = user_print_name(msg.from):gsub("‮", "")
        local name_log = print_name:gsub("_", " ")
        local data = load_data(_config.moderation.data)
        if matches[1]:lower() == 'add' and not matches[2] then
            if not is_admin1(msg) and not is_support(support_id) then
                return
            end
            if is_super_group(msg) then
                return reply_msg(msg.id, lang_text('supergroupAlreadyAdded'), ok_cb, false)
            end
            print("SuperGroup " .. msg.to.print_name .. "(" .. msg.to.id .. ") added")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added SuperGroup")
            superadd(msg)
            set_mutes(msg.to.id)
            channel_set_admin(receiver, 'user#id' .. msg.from.id, ok_cb, false)
        end

        if matches[1]:lower() == 'rem' and is_admin1(msg) and not matches[2] then
            if not is_super_group(msg) then
                return reply_msg(msg.id, lang_text('supergroupRemoved'), ok_cb, false)
            end
            print("SuperGroup " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed")
            superrem(msg)
            rem_mutes(msg.to.id)
        end

        if matches[1]:lower() == "info" then
            if not is_owner(msg) then
                return
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup info")
            channel_info(receiver, callback_info, { receiver = receiver, msg = msg })
        end

        if matches[1]:lower() == "admins" then
            if not is_owner(msg) and not is_support(msg.from.id) then
                return
            end
            member_type = 'Admins'
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup Admins list")
            admins = channel_get_admins(receiver, callback, { receiver = receiver, msg = msg, member_type = member_type })
        end

        if matches[1]:lower() == "owner" then
            local group_owner = data[tostring(msg.to.id)]['set_owner']
            if not group_owner then
                return lang_text('noOwnerCallAdmin')
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] used /owner")
            return lang_text('ownerIs') .. group_owner
        end

        if matches[1]:lower() == "modlist" then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group modlist")
            return modlist(msg)
            -- channel_get_admins(receiver,callback, {receiver = receiver})
        end

        if matches[1]:lower() == "bots" and is_momod(msg) then
            member_type = 'Bots'
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup bots list")
            channel_get_bots(receiver, callback, { receiver = receiver, msg = msg, member_type = member_type })
        end

        if matches[1]:lower() == "who" and not matches[2] and is_momod(msg) then
            local user_id = msg.from.peer_id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup users list")
            channel_get_users(receiver, callback_who, { receiver = receiver })
        end

        if matches[1]:lower() == "kicked" and is_momod(msg) then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested Kicked users list")
            channel_get_kicked(receiver, callback_kicked, { receiver = receiver })
        end

        if matches[1]:lower() == 'del' and is_momod(msg) then
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'del',
                    msg = msg
                }
                delete_msg(msg.id, ok_cb, false)
                get_message(msg.reply_id, get_message_callback, cbreply_extra)
            end
        end

        if matches[1]:lower() == 'block' and is_momod(msg) then
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'channel_block',
                    msg = msg
                }
                get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'block' and string.match(matches[2], '^%d+$') then
                --[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, lang_text('cantKickHigher'))
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
                local get_cmd = 'channel_block'
                local msg = msg
                local user_id = matches[2]
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, user_id = user_id })
            elseif msg.text:match("@[%a%d]") then
                --[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
                local get_cmd = 'channel_block'
                local msg = msg
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, username = username })
            end
        end

        if matches[1]:lower() == 'id' then
            if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
                local cbreply_extra = {
                    get_cmd = 'id',
                    msg = msg
                }
                get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif type(msg.reply_id) ~= "nil" and matches[2]:lower() == "from" and is_momod(msg) then
                local cbreply_extra = {
                    get_cmd = 'idfrom',
                    msg = msg
                }
                get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif msg.text:match("@[%a%d]") then
                local cbres_extra = {
                    channelid = msg.to.id,
                    get_cmd = 'id'
                }
                local username = matches[2]
                local username = username:gsub("@", "")
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested ID for: @" .. username)
                resolve_username(username, callbackres, cbres_extra)
            else
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup ID")
                return "ID " .. string.gsub(msg.to.print_name, "_", " ") .. ":\n\n" .. msg.to.id
            end
        end

        if matches[1]:lower() == 'kickme' then
            if msg.to.type == 'channel' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] left via kickme")
                channel_kick("channel#id" .. msg.to.id, "user#id" .. msg.from.id, ok_cb, false)
            end
        end

        if matches[1]:lower() == 'newlink' and is_momod(msg) then
            local function callback_link(extra, success, result)
                local receiver = get_receiver(msg)
                if success == 0 then
                    send_large_msg(receiver, lang_text('errorCreateSuperLink'))
                    data[tostring(msg.to.id)]['settings']['set_link'] = nil
                    save_data(_config.moderation.data, data)
                else
                    send_large_msg(receiver, lang_text('linkCreated'))
                    data[tostring(msg.to.id)]['settings']['set_link'] = result
                    save_data(_config.moderation.data, data)
                end
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to create a new SuperGroup link")
            export_channel_link(receiver, callback_link, false)
        end

        if matches[1]:lower() == 'setlink' and is_owner(msg) then
            data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
            save_data(_config.moderation.data, data)
            return lang_text('sendLink')
        end

        if msg.text then
            if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
                data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
                save_data(_config.moderation.data, data)
                return lang_text('linkSaved')
            end
        end

        if matches[1]:lower() == 'link' then
            if not is_momod(msg) then
                return
            end
            local group_link = data[tostring(msg.to.id)]['settings']['set_link']
            if not group_link then
                return lang_text('errorCreateSuperLink')
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
            return lang_text('groupLink') .. group_link
        end

        if matches[1]:lower() == "invite" and is_sudo(msg) then
            local cbres_extra = {
                channel = get_receiver(msg),
                get_cmd = "invite"
            }
            local username = matches[2]
            local username = username:gsub("@", "")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] invited @" .. username)
            resolve_username(username, callbackres, cbres_extra)
        end

        if matches[1]:lower() == 'res' and is_owner(msg) then
            local cbres_extra = {
                channelid = msg.to.id,
                get_cmd = 'res'
            }
            local username = matches[2]
            local username = username:gsub("@", "")
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] resolved username: @" .. username)
            resolve_username(username, callbackres, cbres_extra)
        end

        --[[if matches[1]:lower() == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end]]

        if matches[1]:lower() == 'setadmin' then
            if not is_support(msg.from.id) and not is_owner(msg) then
                return
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'setadmin',
                    msg = msg
                }
                setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'setadmin' and string.match(matches[2], '^%d+$') then
                --[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
                local get_cmd = 'setadmin'
                local msg = msg
                local user_id = matches[2]
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, user_id = user_id })
            elseif matches[1]:lower() == 'setadmin' and not string.match(matches[2], '^%d+$') then
                --[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
                local get_cmd = 'setadmin'
                local msg = msg
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, username = username })
            end
        end

        if matches[1]:lower() == 'demoteadmin' then
            if not is_support(msg.from.id) and not is_owner(msg) then
                return
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'demoteadmin',
                    msg = msg
                }
                demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'demoteadmin' and string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'demoteadmin'
                user_info(user_id, cb_user_info, { receiver = receiver, get_cmd = get_cmd })
            elseif matches[1]:lower() == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
                local cbres_extra = {
                    channel = get_receiver(msg),
                    get_cmd = 'demoteadmin'
                }
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted admin @" .. username)
                resolve_username(username, callbackres, cbres_extra)
            end
        end

        if matches[1]:lower() == 'setowner' and is_owner(msg) then
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'setowner',
                    msg = msg
                }
                setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'setowner' and string.match(matches[2], '^%d+$') then
                --[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = matches[2]..lang_text('setOwner')
					return text
				end]]
                local get_cmd = 'setowner'
                local msg = msg
                local user_id = matches[2]
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, user_id = user_id })
            elseif matches[1]:lower() == 'setowner' and not string.match(matches[2], '^%d+$') then
                local get_cmd = 'setowner'
                local msg = msg
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, username = username })
            end
        end

        if matches[1]:lower() == 'promote' then
            if not is_momod(msg) then
                return
            end
            if not is_owner(msg) then
                return lang_text('require_owner')
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'promote',
                    msg = msg
                }
                promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'promote' and string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'promote'
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted user#id" .. matches[2])
                user_info(user_id, cb_user_info, { receiver = receiver, get_cmd = get_cmd })
            elseif matches[1]:lower() == 'promote' and not string.match(matches[2], '^%d+$') then
                local cbres_extra = {
                    channel = get_receiver(msg),
                    get_cmd = 'promote',
                }
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted @" .. username)
                return resolve_username(username, callbackres, cbres_extra)
            end
        end

        if matches[1]:lower() == 'mp' and is_sudo(msg) then
            channel = get_receiver(msg)
            user_id = 'user#id' .. matches[2]
            channel_set_mod(channel, user_id, ok_cb, false)
            return "ok"
        end
        if matches[1]:lower() == 'md' and is_sudo(msg) then
            channel = get_receiver(msg)
            user_id = 'user#id' .. matches[2]
            channel_demote(channel, user_id, ok_cb, false)
            return "ok"
        end

        if matches[1]:lower() == 'demote' then
            if not is_momod(msg) then
                return
            end
            if not is_owner(msg) then
                return lang_text('require_owner')
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'demote',
                    msg = msg
                }
                demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif matches[1]:lower() == 'demote' and string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'demote'
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted user#id" .. matches[2])
                user_info(user_id, cb_user_info, { receiver = receiver, get_cmd = get_cmd })
            elseif not string.match(matches[2], '^%d+$') then
                local cbres_extra = {
                    channel = get_receiver(msg),
                    get_cmd = 'demote'
                }
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted @" .. username)
                return resolve_username(username, callbackres, cbres_extra)
            end
        end

        if matches[1]:lower() == "setname" and is_momod(msg) then
            local receiver = get_receiver(msg)
            local set_name = string.gsub(matches[2], '_', '')
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] renamed SuperGroup to: " .. matches[2])
            rename_channel(receiver, set_name, ok_cb, false)
        end

        if msg.service and msg.action.type == 'chat_rename' then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] renamed SuperGroup to: " .. msg.to.title)
            data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
            save_data(_config.moderation.data, data)
        end

        if matches[1]:lower() == "setabout" and is_momod(msg) then
            local receiver = get_receiver(msg)
            local about_text = matches[2]
            local data_cat = 'description'
            local target = msg.to.id
            data[tostring(target)][data_cat] = about_text
            save_data(_config.moderation.data, data)
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup description to: " .. about_text)
            channel_set_about(receiver, about_text, ok_cb, false)
            return lang_text('newDescription') .. about_text
        end

        if matches[1]:lower() == "setusername" and is_admin1(msg) then
            local function ok_username_cb(extra, success, result)
                local receiver = extra.receiver
                if success == 1 then
                    send_large_msg(receiver, lang_text('supergroupUsernameChanged'))
                elseif success == 0 then
                    send_large_msg(receiver, lang_text('errorChangeUsername'))
                end
            end
            local username = string.gsub(matches[2], '@', '')
            channel_set_username(receiver, username, ok_username_cb, { receiver = receiver })
        end

        if matches[1]:lower() == 'setrules' and is_momod(msg) then
            rules = matches[2]
            local target = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group rules to [" .. matches[2] .. "]")
            return set_rulesmod(msg, data, target)
        end

        if msg.media then
            if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set new SuperGroup photo")
                load_photo(msg.id, set_supergroup_photo, msg)
                return
            end
        end
        if matches[1]:lower() == 'setphoto' and is_momod(msg) then
            data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
            save_data(_config.moderation.data, data)
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] started setting new SuperGroup photo")
            return lang_text('sendNewGroupPic')
        end

        if matches[1]:lower() == 'clean' then
            if not is_owner(msg) then
                return lang_text('require_owner')
            end
            if matches[2]:lower() == 'modlist' then
                if next(data[tostring(msg.to.id)]['moderators']) == nil then
                    return lang_text('noGroupMods')
                end
                for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
                    data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
                    save_data(_config.moderation.data, data)
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned modlist")
                return lang_text('modlistCleaned')
            end
            if matches[2]:lower() == 'rules' then
                local data_cat = 'rules'
                if data[tostring(msg.to.id)][data_cat] == nil then
                    return lang_text('noRules')
                end
                data[tostring(msg.to.id)][data_cat] = nil
                save_data(_config.moderation.data, data)
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned rules")
                return lang_text('rulesCleaned')
            end
            if matches[2]:lower() == 'about' then
                local receiver = get_receiver(msg)
                local about_text = ' '
                local data_cat = 'description'
                if data[tostring(msg.to.id)][data_cat] == nil then
                    return lang_text('noDescription')
                end
                data[tostring(msg.to.id)][data_cat] = nil
                save_data(_config.moderation.data, data)
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned about")
                channel_set_about(receiver, about_text, ok_cb, false)
                return lang_text('descriptionCleaned')
            end
            if matches[2]:lower() == 'mutelist' then
                chat_id = msg.to.id
                local hash = 'mute_user:' .. chat_id
                redis:del(hash)
                return lang_text('mutelistCleaned')
            end
            if matches[2]:lower() == 'username' and is_admin1(msg) then
                local function ok_username_cb(extra, success, result)
                    local receiver = extra.receiver
                    if success == 1 then
                        send_large_msg(receiver, lang_text('usernameCleaned'))
                    elseif success == 0 then
                        send_large_msg(receiver, lang_text('errorCleanUsername'))
                    end
                end
                local username = ""
                channel_set_username(receiver, username, ok_username_cb, { receiver = receiver })
            end
        end

        if matches[1]:lower() == 'lock' and is_momod(msg) then
            local target = msg.to.id
            if matches[2]:lower() == 'links' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked link posting ")
                return lock_group_links(msg, data, target)
            end
            if matches[2]:lower() == 'spam' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked spam ")
                return lock_group_spam(msg, data, target)
            end
            if matches[2]:lower() == 'flood' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked flood ")
                return lock_group_flood(msg, data, target)
            end
            if matches[2]:lower() == 'arabic' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked arabic ")
                return lock_group_arabic(msg, data, target)
            end
            if matches[2]:lower() == 'member' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked member ")
                return lock_group_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'rtl' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked rtl chars. in names")
                return lock_group_rtl(msg, data, target)
            end
            if matches[2]:lower() == 'sticker' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked sticker posting")
                return lock_group_sticker(msg, data, target)
            end
            if matches[2]:lower() == 'contacts' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked contact posting")
                return lock_group_contacts(msg, data, target)
            end
            if matches[2]:lower() == 'strict' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked enabled strict settings")
                return enable_strict_rules(msg, data, target)
            end
        end

        if matches[1]:lower() == 'unlock' and is_momod(msg) then
            local target = msg.to.id
            if matches[2]:lower() == 'links' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked link posting")
                return unlock_group_links(msg, data, target)
            end
            if matches[2]:lower() == 'spam' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked spam")
                return unlock_group_spam(msg, data, target)
            end
            if matches[2]:lower() == 'flood' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked flood")
                return unlock_group_flood(msg, data, target)
            end
            if matches[2]:lower() == 'arabic' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked Arabic")
                return unlock_group_arabic(msg, data, target)
            end
            if matches[2]:lower() == 'member' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked member ")
                return unlock_group_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'rtl' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked RTL chars. in names")
                return unlock_group_rtl(msg, data, target)
            end
            if matches[2]:lower() == 'sticker' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked sticker posting")
                return unlock_group_sticker(msg, data, target)
            end
            if matches[2]:lower() == 'contacts' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked contact posting")
                return unlock_group_contacts(msg, data, target)
            end
            if matches[2]:lower() == 'strict' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked disabled strict settings")
                return disable_strict_rules(msg, data, target)
            end
        end

        if matches[1]:lower() == 'setflood' then
            if not is_momod(msg) then
                return
            end
            if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
                return lang_text('errorFloodRange')
            end
            local flood_max = matches[2]
            data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
            save_data(_config.moderation.data, data)
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set flood to [" .. matches[2] .. "]")
            return lang_text('floodSet') .. matches[2]
        end
        if matches[1]:lower() == 'public' and is_momod(msg) then
            local target = msg.to.id
            if matches[2]:lower() == 'yes' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: public")
                return set_public_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'no' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: not public")
                return unset_public_membermod(msg, data, target)
            end
        end

        if matches[1]:lower() == 'mute' and is_owner(msg) then
            local chat_id = msg.to.id
            if matches[2]:lower() == 'audio' then
                local msg_type = 'Audio'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
        end
        if matches[1]:lower() == 'unmute' and is_momod(msg) then
            local chat_id = msg.to.id
            if matches[2]:lower() == 'audio' then
                local msg_type = 'Audio'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute message")
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
        end


        if matches[1]:lower() == "muteuser" and is_momod(msg) then
            local chat_id = msg.to.id
            local hash = "mute_user" .. chat_id
            local user_id = ""
            if type(msg.reply_id) ~= "nil" then
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                muteuser = get_message(msg.reply_id, get_message_callback, { receiver = receiver, get_cmd = get_cmd, msg = msg })
            elseif matches[1]:lower() == "muteuser" and string.match(matches[2], '^%d+$') then
                local user_id = matches[2]
                if is_muted_user(chat_id, user_id) then
                    unmute_user(chat_id, user_id)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed [" .. user_id .. "] from the muted users list")
                    return user_id .. lang_text('muteUserRemoved')
                elseif is_owner(msg) then
                    mute_user(chat_id, user_id)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. user_id .. "] to the muted users list")
                    return user_id .. lang_text('muteUserAdd')
                end
            elseif matches[1]:lower() == "muteuser" and not string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                resolve_username(username, callbackres, { receiver = receiver, get_cmd = get_cmd, msg = msg })
            end
        end

        if matches[1]:lower() == "muteslist" and is_momod(msg) then
            local chat_id = msg.to.id
            if not has_mutes(chat_id) then
                set_mutes(chat_id)
                return mutes_list(chat_id)
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup muteslist")
            return mutes_list(chat_id)
        end
        if matches[1]:lower() == "mutelist" and is_momod(msg) then
            local chat_id = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
            return muted_user_list(chat_id)
        end

        if matches[1]:lower() == 'settings' and is_momod(msg) then
            local target = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup settings ")
            return show_supergroup_settingsmod(msg, target)
        end

        if matches[1]:lower() == 'rules' then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group rules")
            return get_rules(msg, data)
        end

        if matches[1]:lower() == 'peer_id' and is_admin1(msg) then
            text = msg.to.peer_id
            reply_msg(msg.id, text, ok_cb, false)
            post_large_msg(receiver, text)
        end

        if matches[1]:lower() == 'msg.to.id' and is_admin1(msg) then
            text = msg.to.id
            reply_msg(msg.id, text, ok_cb, false)
            post_large_msg(receiver, text)
        end

        -- Admin Join Service Message
        if msg.service then
            local action = msg.action.type
            if action == 'chat_add_user_link' then
                if is_owner2(msg.from.id) then
                    local receiver = get_receiver(msg)
                    local user = "user#id" .. msg.from.id
                    savelog(msg.to.id, name_log .. " Admin [" .. msg.from.id .. "] joined the SuperGroup via link")
                    channel_set_admin(receiver, user, ok_cb, false)
                end
                if is_support(msg.from.id) and not is_owner2(msg.from.id) then
                    local receiver = get_receiver(msg)
                    local user = "user#id" .. msg.from.id
                    savelog(msg.to.id, name_log .. " Support member [" .. msg.from.id .. "] joined the SuperGroup")
                    channel_set_mod(receiver, user, ok_cb, false)
                end
            end
            if action == 'chat_add_user' then
                if is_owner2(msg.action.user.id) then
                    local receiver = get_receiver(msg)
                    local user = "user#id" .. msg.action.user.id
                    savelog(msg.to.id, name_log .. " Admin [" .. msg.action.user.id .. "] added to the SuperGroup by [ " .. msg.from.id .. " ]")
                    channel_set_admin(receiver, user, ok_cb, false)
                end
                if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
                    local receiver = get_receiver(msg)
                    local user = "user#id" .. msg.action.user.id
                    savelog(msg.to.id, name_log .. " Support member [" .. msg.action.user.id .. "] added to the SuperGroup by [ " .. msg.from.id .. " ]")
                    channel_set_mod(receiver, user, ok_cb, false)
                end
            end
        end
        if matches[1]:lower() == 'msg.to.peer_id' then
            post_large_msg(receiver, msg.to.peer_id)
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
    description = "SUPERGROUP",
    usage =
    {
        "/add: Sasha aggiunge il supergruppo.",
        "/rem: Sasha rimuove il supergruppo.",
        "/info: Sasha manda le informazioni del supergruppo.",
        "/admins: Sasha manda la lista degli amministratori.",
        "/owner: Sasha manda il proprietario.",
        "/modlist: Sasha manda la lista dei moderatori.",
        "/bots: Sasha manda la lista dei bot.",
        "/who: Sasha manda un file contenente la lista degli utenti.",
        "/kicked: Sasha manda la lista degli utenti rimossi.",
        "/block <user_id>|<username>|<reply_user>: Sasha rimuove l'utente specificato dal supergruppo e lo blocca.",
        "/tosuper: Sasha aggiorna il gruppo a supergruppo.",
        "/id [<reply_user>]: Sasha manda l'id del gruppo o dell'utente specificato.",
        "/id from: Sasha manda l'id del mittente originale.",
        "/kickme: Sasha rimuove l'utente.",
        "/newlink: Sasha crea un nuovo link d'invito.",
        "/setlink: Sasha imposta il link d'invito con quello che le verrà inviato.",
        "/link: Sasha manda il link d'invito.",
        "/res <username>: Sasha manda l'id di <username>.",
        "/setadmin <user_id>|<username>|<reply_user>: Sasha promuove l'utente specificato ad amministratore (telegram).",
        "/demoteadmin <user_id>|<username>|<reply_user>: Sasha degrada l'utente specificato (telegram).",
        "/setowner <user_id>|<username>|<reply_user>: Sasha imposta l'utente specificato come proprietario.",
        "/promote <user_id>|<username>|<reply_user>: Sasha promuove l'utente specificato a moderatore.",
        "/demote <user_id>|<username>|<reply_user>: Sasha declassa l'utente specificato.",
        "/setname <text>: Sasha cambia il nome del gruppo con <text>.",
        "/setphoto: Sasha cambia la foto del gruppo.",
        "/setrules <text>: Sasha cambia le regole del gruppo con <text>.",
        "/setabout <text>: Sasha cambia la descrizione del gruppo con <text>.",
        "/setusername <text>: Sasha cambia l'username del gruppo con <text>.",
        "/del <reply>: Sasha elimina il messaggio specificato.",
        "/lock links|spam|flood|arabic|member|rtl|sticker|contacts|strict: Sasha blocca l'opzione specificata.",
        "/unlock links|spam|flood|arabic|member|rtl|sticker|contacts|strict: Sasha sblocca l'opzione specificata.",
        "/mute all|text|documents|gifs|video|photo|audio: Sasha imposta il muto sulla variabile specificata.",
        "/unmute all|text|documents|gifs|video|photo|audio: Sasha rimuove il muto sulla variabile specificata.",
        "/muteuser <user_id>|<username>|<reply_user>: Sasha imposta|toglie il muto sull'utente.",
        "/public yes|no: Sasha imposta il gruppo come pubblico|privato.",
        "/settings: Sasha manda le impostazioni del gruppo.",
        "/rules: Sasha manda le regole del gruppo.",
        "/setflood <value>: Sasha imposta il flood massimo a <value> che deve essere compreso tra 5 e 20.",
        "/clean rules|about|modlist|mutelist: Sasha azzera la variabile specificata.",
        "/muteslist: Sasha manda la lista delle variabili mute della chat.",
        "/mutelist: Sasha manda la lista degli utenti muti della chat.",
    },
    patterns =
    {
        "^[#!/]([aA][dD][dD])$",
        "^[#!/]([rR][eE][mM])$",
        "^[#!/]([mM][oO][vV][eE]) (.*)$",
        "^[#!/]([iI][nN][fF][oO])$",
        "^[#!/]([aA][dD][mM][iI][nN][sS])$",
        "^[#!/]([oO][wW][nN][eE][rR])$",
        "^[#!/]([mM][oO][dD][lL][iI][sS][tT])$",
        "^[#!/]([bB][oO][tT][sS])$",
        "^[#!/]([wW][hH][oO])$",
        "^[#!/]([kK][iI][cC][kK][eE][dD])$",
        "^[#!/]([bB][lL][oO][cC][kK]) (.*)",
        "^[#!/]([bB][lL][oO][cC][kK])",
        "^[#!/]([tT][oO][sS][uU][pP][eE][rR])$",
        "^[#!/]([iI][dD])$",
        "^[#!/]([iI][dD]) (.*)$",
        "^[#!/]([kK][iI][cC][kK][mM][eE])$",
        "^[#!/]([kK][iI][cC][kK]) (.*)$",
        "^[#!/]([nN][eE][wW][lL][iI][nN][kK])$",
        "^[#!/]([sS][eE][tT][lL][iI][nN][kK])$",
        "^[#!/]([lL][iI][nN][kK])$",
        "^[#!/]([rR][eE][sS]) (.*)$",
        "^[#!/]([sS][eE][tT][aA][dD][mM][iI][nN]) (.*)$",
        "^[#!/]([sS][eE][tT][aA][dD][mM][iI][nN])",
        "^[#!/]([dD][eE][mM][oO][tT][eE][aA][dD][mM][iI][nN]) (.*)$",
        "^[#!/]([dD][eE][mM][oO][tT][eE][aA][dD][mM][iI][nN])",
        "^[#!/]([sS][eE][tT][oO][wW][nN][eE][rR]) (%d+)$",
        "^[#!/]([sS][eE][tT][oO][wW][nN][eE][rR])",
        "^[#!/]([pP][rR][oO][mM][oO][tT][eE]) (.*)$",
        "^[#!/]([pP][rR][oO][mM][oO][tT][eE])",
        "^[#!/]([dD][eE][mM][oO][tT][eE]) (.*)$",
        "^[#!/]([dD][eE][mM][oO][tT][eE])",
        "^[#!/]([sS][eE][tT][nN][aA][mM][eE]) (.*)$",
        "^[#!/]([sS][eE][tT][pP][hH][oO][tT][oO])$",
        "^[#!/]([sS][eE][tT][aA][bB][oO][uU][tT]) (.*)$",
        "^[#!/]([sS][eE][tT][rR][uU][lL][eE][sS]) (.*)$",
        "^[#!/]([sS][eE][tT][uU][sS][eE][rR][nN][aA][mM][eE]) (.*)$",
        "^[#!/]([dD][eE][lL])$",
        "^[#!/]([lL][oO][cC][kK]) (.*)$",
        "^[#!/]([uU][nN][lL][oO][cC][kK]) (.*)$",
        "^[#!/]([mM][uU][tT][eE]) ([^%s]+)$",
        "^[#!/]([uU][nN][mM][uU][tT][eE]) ([^%s]+)$",
        "^[#!/]([mM][uU][tT][eE][uU][sS][eE][rR])$",
        "^[#!/]([mM][uU][tT][eE][uU][sS][eE][rR]) (.*)$",
        "^[#!/]([pP][uU][bB][lL][iI][cC]) (.*)$",
        "^[#!/]([sS][eE][tT][tT][iI][nN][gG][sS])$",
        "^[#!/]([rR][uU][lL][eE][sS])$",
        "^[#!/]([sS][eE][tT][fF][lL][oO][oO][dD]) (%d+)$",
        "^[#!/]([cC][lL][eE][aA][nN]) (.*)$",
        "^[#!/]([mM][uU][tT][eE][sS][lL][iI][sS][tT])$",
        "^[#!/]([mM][uU][tT][eE][lL][iI][sS][tT])$",
        "^[#!/]([mM][pP]) (.*)$",
        "^[#!/]([mM][dD]) (.*)$",
        "^(https://telegram.me/joinchat/%S+)$",
        "msg.to.peer_id",
        "%[(document)%]",
        "%[(photo)%]",
        "%[(video)%]",
        "%[(audio)%]",
        "%[(contact)%]",
        "^!!tgservice (.+)$",
    },
    run = run,
    pre_process = pre_process
}
-- End supergrpup.lua
-- By @Rondoozle
