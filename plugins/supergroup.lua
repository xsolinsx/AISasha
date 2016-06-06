-- Begin supergroup.lua
-- Check members #Add supergroup
local function check_member_super(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
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
                    lock_tgservice = 'yes',
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
local function check_member_superrem(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
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
local function callback(extra, success, result)
    local i = 1
    local chat_name = string.gsub(extra.msg.to.print_name, "_", " ")
    local member_type = extra.member_type
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
    send_large_msg(extra.receiver, text)
end

local function callback_clean_bots(extra, success, result)
    local msg = extra.msg
    local receiver = 'channel#id' .. msg.to.id
    local channel_id = msg.to.id
    for k, v in pairs(result) do
        local bot_id = v.peer_id
        kick_user(bot_id, channel_id)
    end
end
-- Get and output members of supergroup
local function callback_who(extra, success, result)
    local text = lang_text('membersOf') .. extra.receiver
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
    local file = io.open("./groups/lists/supergroups/" .. extra.receiver .. ".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(extra.receiver, "./groups/lists/supergroups/" .. extra.receiver .. ".txt", ok_cb, false)
    post_msg(extra.receiver, text, ok_cb, false)
end

-- Get and output list of kicked users for supergroup
local function callback_kicked(extra, success, result)
    -- vardump(result)
    local text = lang_text('membersKickedFrom') .. extra.receiver .. "\n\n"
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
    local file = io.open("./groups/lists/supergroups/kicked/" .. extra.receiver .. ".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(extra.receiver, "./groups/lists/supergroups/kicked/" .. extra.receiver .. ".txt", ok_cb, false)
    -- send_large_msg(extra.receiver, text)
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

local function lock_group_tgservice(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
    if group_tgservice_lock == 'yes' then
        return lang_text('tgserviceAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('tgserviceLocked')
    end
end

local function unlock_group_tgservice(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
    if group_tgservice_lock == 'no' then
        return lang_text('tgserviceAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_tgservice'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('tgserviceUnlocked')
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
    local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
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
    return lang_text('newRules') .. rules
end

-- 'Get supergroup rules' function
local function get_rules(msg, data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noRules')
    end
    local rules = data[tostring(msg.to.id)][data_cat]
    local group_name = data[tostring(msg.to.id)]['settings']['set_name']
    local rules = group_name .. ' ' .. lang_text('rules') .. '\n\n' .. rules:gsub("/n", " ")
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
        if not data[tostring(target)]['settings']['lock_tgservice'] then
            data[tostring(target)]['settings']['lock_tgservice'] = 'no'
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
    lang_text('floodLock') .. settings.flood ..
    lang_text('floodSensibility') .. NUM_MSG_MAX ..
    lang_text('spamLock') .. settings.lock_spam ..
    lang_text('arabicLock') .. settings.lock_arabic ..
    lang_text('membersLock') .. settings.lock_member ..
    lang_text('rtlLock') .. settings.lock_rtl ..
    lang_text('tgserviceLock') .. settings.lock_tgservice ..
    lang_text('stickersLock') .. settings.lock_sticker ..
    lang_text('public') .. settings.public ..
    lang_text('strictrules') .. settings.strict
    return text
end

local function promote_admin(receiver, member_username, user_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'channel#id', '')
    local member_tag_username = member_username
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
    local member_tag_username = member_username
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
    if get_cmd == "del" then
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
        else
            mute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
        end
    end
end
-- End by reply actions

local function muteuser_from(extra, success, result)
    if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
        unmute_user(result.to.peer_id, result.fwd_from.peer_id)
        send_large_msg('channel#id' .. result.to.peer_id, result.fwd_from.peer_id .. lang_text('muteUserRemove'))
    else
        mute_user(result.to.peer_id, result.fwd_from.peer_id)
        send_large_msg('channel#id' .. result.to.peer_id, result.fwd_from.peer_id .. lang_text('muteUserAdd'))
    end
end

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
    if get_cmd == "promote" then
        if result.username then
            member_username = "@" .. result.username
        else
            member_username = string.gsub(result.print_name, '_', ' ')
        end
        promote2(receiver, member_username, user_id)
    end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
    local member_id = result.peer_id
    local member_username = "@" .. result.username
    local get_cmd = extra.get_cmd
    --[[elseif get_cmd == "setowner" then
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
    if get_cmd == "promote" then
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
        else
            mute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
        end
    end
end
-- End resolve username actions

-- Begin non-channel_invite username actions
local function in_channel_cb(extra, success, result)
    local get_cmd = extra.get_cmd
    local receiver = extra.receiver
    local msg = extra.msg
    local data = load_data(_config.moderation.data)
    local print_name = user_print_name(extra.msg.from):gsub("‮", "")
    local name_log = print_name:gsub("_", " ")
    local member = extra.username
    local memberid = extra.user_id
    if member then
        text = lang_text('none') .. '@' .. member .. lang_text('inThisSupergroup')
    else
        text = lang_text('none') .. memberid .. lang_text('inThisSupergroup')
    end
    if get_cmd == "setadmin" then
        for k, v in pairs(result) do
            vusername = v.username
            vpeer_id = tostring(v.peer_id)
            if vusername == member or vpeer_id == memberid then
                local user_id = "user#id" .. v.peer_id
                local channel_id = "channel#id" .. extra.msg.to.id
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
                local from_id = extra.msg.from.id
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
                local from_id = extra.msg.from.id
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
    if not data[tostring(msg.to.id)] then
        return
    end
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

local function killchannel(extra, success, result)
    for k, v in pairsByKeys(result) do
        local function post_kick()
            kick_user_any(v.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 1)
    end
    channel_kick('channel#id' .. extra.chat_id, 'user#id' .. our_id, ok_cb, false)
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

        if not data[tostring(msg.to.id)] then
            return
        end

        if matches[1]:lower() == "admins" or matches[1]:lower() == "sasha lista admin" or matches[1]:lower() == "lista admin" then
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

        if matches[1]:lower() == "modlist" or matches[1]:lower() == "sasha lista mod" or matches[1]:lower() == "lista mod" then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group modlist")
            return modlist(msg)
            -- channel_get_admins(receiver,callback, {receiver = receiver})
        end

        if (matches[1]:lower() == "bots" or matches[1]:lower() == "sasha lista bot" or matches[1]:lower() == "lista bot") and is_momod(msg) then
            member_type = 'Bots'
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup bots list")
            channel_get_bots(receiver, callback, { receiver = receiver, msg = msg, member_type = member_type })
        end

        if (matches[1]:lower() == "wholist" or matches[1]:lower() == "memberslist") and not matches[2] and is_momod(msg) then
            local user_id = msg.from.peer_id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup users list")
            channel_get_users(receiver, callback_who, { receiver = receiver })
        end

        if matches[1]:lower() == "kickedlist" and is_momod(msg) then
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

        if (matches[1]:lower() == 'newlink' or matches[1]:lower() == "sasha crea link" or matches[1]:lower() == "crea link") and is_momod(msg) then
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

        if (matches[1]:lower() == 'setlink' or matches[1]:lower() == "sasha imposta link") and matches[2] then
            if is_owner(msg) then
                data[tostring(msg.to.id)]['settings']['set_link'] = matches[2]
                save_data(_config.moderation.data, data)
                return lang_text('linkSaved')
            else
                return lang_text('require_owner')
            end
        end

        if matches[1]:lower() == 'link' or matches[1]:lower() == "sasha link" then
            if not is_momod(msg) then
                return
            end
            local group_link = data[tostring(msg.to.id)]['settings']['set_link']
            if not group_link then
                return lang_text('errorCreateSuperLink')
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
            return msg.to.title .. '\n' .. group_link
        end

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
            elseif string.match(matches[2], '^%d+$') then
                --[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
                local get_cmd = 'setadmin'
                local msg = msg
                local user_id = matches[2]
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, user_id = user_id })
            else
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
            elseif string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'demoteadmin'
                if is_admin2(matches[2]) then
                    return send_large_msg(receiver, lang_text('cantDemoteOtherAdmin'))
                end
                channel_demote(receiver, user_id, ok_cb, false)
                local text = result.peer_id .. lang_text('demoteSupergroupMod')
                send_large_msg(receiver, text)
            else
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
            elseif string.match(matches[2], '^%d+$') then
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
            else
                local get_cmd = 'setowner'
                local msg = msg
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                channel_get_users(receiver, in_channel_cb, { get_cmd = get_cmd, receiver = receiver, msg = msg, username = username })
            end
        end

        if matches[1]:lower() == 'promote' or matches[1]:lower() == "sasha promuovi" or matches[1]:lower() == "promuovi" then
            if not is_owner(msg) then
                return lang_text('require_owner')
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'promote',
                    msg = msg
                }
                promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'promote'
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted user#id" .. matches[2])
                user_info(user_id, cb_user_info, { receiver = receiver, get_cmd = get_cmd })
            else
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

        if matches[1]:lower() == 'demote' or matches[1]:lower() == "sasha degrada" or matches[1]:lower() == "degrada" then
            if not is_owner(msg) then
                return lang_text('require_owner')
            end
            if type(msg.reply_id) ~= "nil" then
                local cbreply_extra = {
                    get_cmd = 'demote',
                    msg = msg
                }
                demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
            elseif string.match(matches[2], '^%d+$') then
                local receiver = get_receiver(msg)
                local user_id = "user#id" .. matches[2]
                local get_cmd = 'demote'
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted user#id" .. matches[2])
                demote2(receiver, matches[2], matches[2])
            else
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

        if (matches[1]:lower() == "setname" or matches[1]:lower() == "setgpname") and is_momod(msg) then
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

        if (matches[1]:lower() == "setabout" or matches[1]:lower() == "sasha imposta descrizione") and is_momod(msg) then
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

        if (matches[1]:lower() == 'setrules' or matches[1]:lower() == "sasha imposta regole") and is_momod(msg) then
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
        if (matches[1]:lower() == 'setphoto' or matches[1]:lower() == "setgpphoto") and is_momod(msg) then
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
            if matches[2] == "bots" and is_momod(msg) then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] kicked all SuperGroup bots")
                channel_get_bots(receiver, callback_clean_bots, { msg = msg })
            end
        end

        if (matches[1]:lower() == 'lock' or matches[1]:lower() == "sasha blocca" or matches[1]:lower() == "blocca") and is_momod(msg) then
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
            if matches[2]:lower() == 'tgservice' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked Tgservice Actions")
                return lock_group_tgservice(msg, data, target)
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

        if (matches[1]:lower() == 'unlock' or matches[1]:lower() == "sasha sblocca" or matches[1]:lower() == "sblocca") and is_momod(msg) then
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
            if matches[2]:lower() == 'tgservice' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked tgservice actions")
                return unlock_group_tgservice(msg, data, target)
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
            if tonumber(matches[2]) < 3 or tonumber(matches[2]) > 200 then
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

        if (matches[1]:lower() == 'mute' or matches[1]:lower() == "silenzia") and is_owner(msg) then
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
        if (matches[1]:lower() == 'unmute' or matches[1]:lower() == "ripristina") and is_owner(msg) then
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

        if (matches[1]:lower() == "muteuser" or matches[1]:lower() == "voce") and is_momod(msg) then
            local chat_id = msg.to.id
            local hash = "mute_user" .. chat_id
            local user_id = ""
            if type(msg.reply_id) ~= "nil" then
                if matches[2] then
                    if matches[2]:lower() == 'from' then
                        get_message(msg.reply_id, muteuser_from, false)
                        return
                    else
                        local receiver = get_receiver(msg)
                        local get_cmd = "mute_user"
                        muteuser = get_message(msg.reply_id, get_message_callback, { receiver = receiver, get_cmd = get_cmd, msg = msg })
                        return
                    end
                else
                    local receiver = get_receiver(msg)
                    local get_cmd = "mute_user"
                    muteuser = get_message(msg.reply_id, get_message_callback, { receiver = receiver, get_cmd = get_cmd, msg = msg })
                    return
                end
            elseif string.match(matches[2], '^%d+$') then
                local user_id = matches[2]
                if is_muted_user(chat_id, user_id) then
                    unmute_user(chat_id, user_id)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed [" .. user_id .. "] from the muted users list")
                    return user_id .. lang_text('muteUserRemove')
                else
                    mute_user(chat_id, user_id)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. user_id .. "] to the muted users list")
                    return user_id .. lang_text('muteUserAdd')
                end
            else
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                local username = string.gsub(matches[2], '@', '')
                resolve_username(username, callbackres, { receiver = receiver, get_cmd = get_cmd, msg = msg })
            end
        end

        if (matches[1]:lower() == "muteslist" or matches[1]:lower() == "lista muti") and is_momod(msg) then
            local chat_id = msg.to.id
            if not has_mutes(chat_id) then
                set_mutes(chat_id)
                return mutes_list(chat_id)
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup muteslist")
            return mutes_list(chat_id)
        end
        if (matches[1]:lower() == "mutelist" or matches[1]:lower() == "lista utenti muti") and is_momod(msg) then
            local chat_id = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
            return muted_user_list(chat_id)
        end

        if matches[1]:lower() == 'settings' and is_momod(msg) then
            local target = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup settings ")
            return show_supergroup_settingsmod(msg, target)
        end

        if matches[1]:lower() == 'rules' or matches[1]:lower() == "sasha regole" then
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group rules")
            print('peerid' .. msg.to.id)
            if tonumber(msg.to.id) == 1026492373 then
                print('right group')
                if is_momod(msg) then
                    print('mod')
                    -- moderatore del canile abusivo usa rules allora ok altrimenti return
                    return get_rules(msg, data)
                else
                    print('not mod')
                    return
                end
            else
                print('wrong group')
                return get_rules(msg, data)
            end
        end
        if matches[1]:lower() == 'kill' and matches[2]:lower() == 'supergroup' then
            if not is_admin1(msg) then
                return
            end
            if not is_realm(msg) then
                local receiver = 'channel#id' .. msg.to.id
                print("Closing Group: " .. receiver)
                channel_get_users(receiver, killchannel, { chat_id = msg.to.id })
                return modrem(msg)
            else
                return lang_text('realmIs')
            end
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
    patterns =
    {
        "^[#!/]([Aa][Dd][Dd])$",
        "^[#!/]([Rr][Ee][Mm])$",
        "^[#!/]([Aa][Dd][Mm][Ii][Nn][Ss])$",
        "^[#!/]([Oo][Ww][Nn][Ee][Rr])$",
        "^[#!/]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Bb][Oo][Tt][Ss])$",
        "^[#!/]([Ww][Hh][Oo][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Kk][Ii][Cc][Kk][Ee][Dd][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Tt][Oo][Ss][Uu][Pp][Ee][Rr])$",
        "^[#!/]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn])",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn])",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee])",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee])",
        "^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$",
        "^[#!/]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Uu][Ss][Ee][Rr][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Dd][Ee][Ll])$",
        "^[#!/]([Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$",
        "^[#!/]([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Ss])$",
        "^[#!/]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn]) (.*)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Mm][Pp]) (.*)$",
        "^[#!/]([Mm][Dd]) (.*)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Ss][Uu][Pp][Ee][Rr][Gg][Rr][Oo][Uu][Pp])$",
        "[Pp][Ee][Ee][Rr]_[Ii][Dd]",
        "[Mm][Ss][Gg].[Tt][Oo].[Ii][Dd]",
        "[Mm][Ss][Gg].[Tt][Oo].[Pp][Ee][Ee][Rr]_[Ii][Dd]",
        "%[(document)%]",
        "%[(photo)%]",
        "%[(video)%]",
        "%[(audio)%]",
        "%[(contact)%]",
        "^!!tgservice (.+)$",
        -- admins
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Aa][Dd][Mm][Ii][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Aa][Dd][Mm][Ii][Nn])$",
        -- modlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Mm][Oo][Dd])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Oo][Dd])$",
        -- bots
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Oo][Tt])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Oo][Tt])$",
        -- wholist
        "^[#!/]([Mm][Ee][Mm][Bb][Ee][Rr][Ss][Ll][Ii][Ss][Tt])$",
        -- newlink
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Ll][Ii][Nn][Kk])$",
        -- setlink
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        -- link
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Nn][Kk])$",
        -- promote
        "^([Ss][Aa][Ss][Hh][Aa] [Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii])",
        "^([Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii]) (.*)$",
        "^([Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii])",
        -- demote
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Gg][Rr][Aa][Dd][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Gg][Rr][Aa][Dd][Aa])",
        "^([Dd][Ee][Gg][Rr][Aa][Dd][Aa]) (.*)$",
        "^([Dd][Ee][Gg][Rr][Aa][Dd][Aa])",
        -- setname
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Nn][Aa][Mm][Ee]) (.*)$",
        -- setphoto
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Pp][Hh][Oo][Tt][Oo])$",
        -- setrules
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Rr][Ee][Gg][Oo][Ll][Ee]) (.*)$",
        -- setabout
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Dd][Ee][Ss][Cc][Rr][Ii][Zz][Ii][Oo][Nn][Ee]) (.*)$",
        -- lock
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Ll][Oo][Cc][Cc][Aa]) (.*)$",
        "^([Bb][Ll][Oo][Cc][Cc][Aa]) (.*)$",
        -- unlock
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (.*)$",
        "^([Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (.*)$",
        -- mute
        "^([Ss][Ii][Ll][Ee][Nn][Zz][Ii][Aa]) ([^%s]+)$",
        -- unmute
        "^([Rr][Ii][Pp][Rr][Ii][Ss][Tt][Ii][Nn][Aa]) ([^%s]+)$",
        -- muteuser
        "^([Vv][Oo][Cc][Ee])$",
        "^([Vv][Oo][Cc][Ee]) (.*)$",
        -- rules
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ee][Gg][Oo][Ll][Ee])$",
        -- about
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Ss][Cc][Rr][Ii][Zz][Ii][Oo][Nn][Ee])$",
        -- muteslist
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Uu][Tt][Ii])$",
        -- mutelist
        "^([Ll][Ii][Ss][Tt][Aa] [Uu][Tt][Ee][Nn][Tt][Ii] [Mm][Uu][Tt][Ii])$",
    },
    run = run,
    pre_process = pre_process,
    min_rank = 0
    -- usage
    -- #owner
    -- (#modlist|[sasha] lista mod)
    -- (#rules|sasha regole)
    -- MOD
    -- (#bots|[sasha] lista bot)
    -- #wholist|#memberslist
    -- #kickedlist
    -- #del <reply>
    -- (#newlink|[sasha] crea link)
    -- (#link|sasha link)
    -- #setname|setgpname <text>
    -- #setphoto|setgpphoto
    -- (#setrules|sasha imposta regole) <text>
    -- (#setabout|sasha imposta descrizione) <text>
    -- (#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict
    -- (#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict
    -- #setflood <value>
    -- #public yes|no
    -- #muteuser|voce <id>|<username>|<reply>
    -- (#muteslist|lista muti)
    -- (#mutelist|lista utenti muti)
    -- #settings
    -- OWNER
    -- (#admins|[sasha] lista admin)
    -- (#setlink|sasha imposta link) <link>
    -- #setadmin <id>|<username>|<reply>
    -- #demoteadmin <id>|<username>|<reply>
    -- #setowner <id>|<username>|<reply>
    -- (#promote|[sasha] promuovi) <id>|<username>|<reply>
    -- (#demote|[sasha] degrada) <id>|<username>|<reply>
    -- #clean rules|about|modlist|mutelist
    -- #mute|silenzia all|text|documents|gifs|video|photo|audio
    -- #unmute|ripristina all|text|documents|gifs|video|photo|audio
    -- SUPPORT
    -- #add
    -- #rem
    -- ADMIN
    -- #tosuper
    -- #setusername <text>
    -- #kill supergroup
    -- peer_id
    -- msg.to.id
    -- msg.to.peer_id
    -- SUDO
    -- #mp <id>
    -- #md <id>
}
-- End supergroup.lua
-- By @Rondoozle
