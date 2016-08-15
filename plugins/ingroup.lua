-- Check Member
local function check_member_autorealm(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.peer_id
        if member_id ~= our_id then
            -- Group configuration
            data[tostring(msg.to.id)] = {
                group_type = 'Realm',
                settings =
                {
                    set_name = string.gsub(msg.to.print_name,'_',' '),
                    lock_name = 'yes',
                    lock_photo = 'no',
                    lock_member = 'no',
                    flood = 'yes'
                }
            }
            save_data(_config.moderation.data, data)
            local realms = 'realms'
            if not data[tostring(realms)] then
                data[tostring(realms)] = { }
                save_data(_config.moderation.data, data)
            end
            data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
            save_data(_config.moderation.data, data)
            return send_large_msg(receiver, langs[msg.lang].welcomeNewRealm)
        end
    end
end
local function check_member_realm_add(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.peer_id
        if member_id ~= our_id then
            -- Group configuration
            data[tostring(msg.to.id)] = {
                group_type = 'Realm',
                settings =
                {
                    set_name = string.gsub(msg.to.print_name,'_',' '),
                    lock_name = 'yes',
                    lock_photo = 'no',
                    lock_member = 'no',
                    flood = 'yes'
                }
            }
            save_data(_config.moderation.data, data)
            local realms = 'realms'
            if not data[tostring(realms)] then
                data[tostring(realms)] = { }
                save_data(_config.moderation.data, data)
            end
            data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
            save_data(_config.moderation.data, data)
            return send_large_msg(receiver, langs[msg.lang].realmAdded)
        end
    end
end
function check_member_group(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.peer_id
        if member_id ~= our_id then
            -- Group configuration
            data[tostring(msg.to.id)] = {
                group_type = 'Group',
                moderators = { },
                set_owner = member_id,
                settings =
                {
                    set_name = string.gsub(msg.to.print_name,'_',' '),
                    lock_name = 'yes',
                    lock_photo = 'no',
                    lock_member = 'no',
                    flood = 'yes',
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
            return send_large_msg(receiver, langs[msg.lang].promotedOwner)
        end
    end
end
local function check_member_modadd(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.peer_id
        if member_id ~= our_id then
            -- Group configuration
            data[tostring(msg.to.id)] = {
                group_type = 'Group',
                long_id = msg.to.peer_id,
                moderators = { },
                set_owner = member_id,
                settings =
                {
                    set_name = string.gsub(msg.to.print_name,'_',' '),
                    lock_name = 'yes',
                    lock_photo = 'no',
                    lock_member = 'no',
                    flood = 'yes',
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
            return send_large_msg(receiver, langs[msg.lang].groupAddedOwner)
        end
    end
end
local function automodadd(msg)
    local data = load_data(_config.moderation.data)
    if msg.action.type == 'chat_created' then
        receiver = get_receiver(msg)
        chat_info(receiver, check_member_group, { receiver = receiver, data = data, msg = msg })
    end
end
local function autorealmadd(msg)
    local data = load_data(_config.moderation.data)
    if msg.action.type == 'chat_created' then
        receiver = get_receiver(msg)
        chat_info(receiver, check_member_autorealm, { receiver = receiver, data = data, msg = msg })
    end
end
local function check_member_realmrem(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.id
        if member_id ~= our_id then
            -- Realm configuration removal
            data[tostring(msg.to.id)] = nil
            save_data(_config.moderation.data, data)
            local realms = 'realms'
            if not data[tostring(realms)] then
                data[tostring(realms)] = nil
                save_data(_config.moderation.data, data)
            end
            data[tostring(realms)][tostring(msg.to.id)] = nil
            save_data(_config.moderation.data, data)
            return send_large_msg(receiver, langs[msg.lang].realmRemoved)
        end
    end
end
local function check_member_modrem(extra, success, result)
    local receiver = extra.receiver
    local data = extra.data
    local msg = extra.msg
    for k, v in pairs(result.members) do
        local member_id = v.peer_id
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
            return send_large_msg(receiver, langs[msg.lang].groupRemoved)
        end
    end
end
-- End Check Member
function show_group_settingsmod(msg, target)
    if not is_momod(msg) then
        return langs[msg.lang].require_mod
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
    local bots_protection = "yes"
    if data[tostring(target)]['settings']['lock_bots'] then
        bots_protection = data[tostring(target)]['settings']['lock_bots']
    end
    local leave_ban = "no"
    if data[tostring(target)]['settings']['leave_ban'] then
        leave_ban = data[tostring(target)]['settings']['leave_ban']
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['lock_link'] then
            data[tostring(target)]['settings']['lock_link'] = 'no'
        end
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['lock_sticker'] then
            data[tostring(target)]['settings']['lock_sticker'] = 'no'
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
    local settings = data[tostring(target)]['settings']
    local text = langs[msg.lang].groupSettings ..
    langs[msg.lang].nameLock .. settings.lock_name ..
    langs[msg.lang].photoLock .. settings.lock_photo ..
    langs[msg.lang].membersLock .. settings.lock_member ..
    langs[msg.lang].leaveLock .. leave_ban ..
    langs[msg.lang].floodSensibility .. NUM_MSG_MAX ..
    langs[msg.lang].botsLock .. bots_protection ..
    langs[msg.lang].linksLock .. settings.lock_link ..
    langs[msg.lang].rtlLock .. settings.lock_rtl ..
    langs[msg.lang].stickersLock .. settings.lock_sticker ..
    langs[msg.lang].public .. settings.public
    return text
end

local function set_descriptionmod(msg, data, target, about)
    if not is_momod(msg) then
        return
    end
    local data_cat = 'description'
    data[tostring(target)][data_cat] = about
    save_data(_config.moderation.data, data)
    return langs[msg.lang].newDescription .. about
end
local function get_description(msg, data)
    local data_cat = 'description'
    if not data[tostring(msg.to.id)][data_cat] then
        return langs[msg.lang].noDescription
    end
    local about = data[tostring(msg.to.id)][data_cat]
    local about = string.gsub(msg.to.print_name, "_", " ") .. ':\n\n' .. about
    return langs[msg.lang].description .. about
end
local function lock_group_arabic(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'yes' then
        return langs[msg.lang].arabicAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].arabicLocked
    end
end

local function unlock_group_arabic(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'no' then
        return langs[msg.lang].arabicAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].arabicUnlocked
    end
end

local function lock_group_bots(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'yes' then
        return langs[msg.lang].botsAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_bots'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].botsLocked
    end
end

local function unlock_group_bots(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'no' then
        return langs[msg.lang].botsAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_bots'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].botsUnlocked
    end
end

local function lock_group_namemod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'yes' then
        return langs[msg.lang].nameAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'yes'
        save_data(_config.moderation.data, data)
        rename_chat('chat#id' .. target, group_name_set, ok_cb, false)
        return langs[msg.lang].nameLocked
    end
end
local function unlock_group_namemod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'no' then
        return langs[msg.lang].nameAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].nameUnlocked
    end
end
local function lock_group_floodmod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'yes' then
        return langs[msg.lang].floodAlreadyLocked
    else
        data[tostring(target)]['settings']['flood'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].floodLocked
    end
end

local function unlock_group_floodmod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    if not is_owner(msg) then
        return langs[msg.lang].floodUnlockOwners
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'no' then
        return langs[msg.lang].floodAlreadyUnlocked
    else
        data[tostring(target)]['settings']['flood'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].floodUnlocked
    end
end

local function lock_group_membermod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'yes' then
        return langs[msg.lang].membersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].membersLocked
    end
end

local function unlock_group_membermod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'no' then
        return langs[msg.lang].membersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].membersUnlocked
    end
end

local function set_public_membermod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_member_lock = data[tostring(target)]['settings']['public']
    local long_id = data[tostring(target)]['long_id']
    if not long_id then
        data[tostring(target)]['long_id'] = msg.to.peer_id
        save_data(_config.moderation.data, data)
    end
    if group_member_lock == 'yes' then
        return langs[msg.lang].publicAlreadyYes
    else
        data[tostring(target)]['settings']['public'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].publicYes
    end
end

local function unset_public_membermod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_member_lock = data[tostring(target)]['settings']['public']
    local long_id = data[tostring(target)]['long_id']
    if not long_id then
        data[tostring(target)]['long_id'] = msg.to.peer_id
        save_data(_config.moderation.data, data)
    end
    if group_member_lock == 'no' then
        return langs[msg.lang].publicAlreadyNo
    else
        data[tostring(target)]['settings']['public'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].publicNo
    end
end

local function lock_group_leave(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local leave_ban = data[tostring(target)]['settings']['leave_ban']
    if leave_ban == 'yes' then
        return langs[msg.lang].leaveAlreadyLocked
    else
        data[tostring(target)]['settings']['leave_ban'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].leaveLocked
    end
end

local function unlock_group_leave(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
    if leave_ban == 'no' then
        return langs[msg.lang].leaveAlreadyUnlocked
    else
        data[tostring(target)]['settings']['leave_ban'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].leaveUnlocked
    end
end

local function lock_group_photomod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'yes' then
        return langs[msg.lang].photoAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_photo'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].photoLocked
    end
end

local function unlock_group_photomod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'no' then
        return langs[msg.lang].photoAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_photo'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].photoUnlocked
    end
end

local function lock_group_links(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'yes' then
        return langs[msg.lang].linksAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].linksLocked
    end
end

local function unlock_group_links(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'no' then
        return langs[msg.lang].linksAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].linksUnlocked
    end
end

local function lock_group_rtl(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'yes' then
        return langs[msg.lang].rtlAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].rtlLocked
    end
end

local function unlock_group_rtl(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'no' then
        return langs[msg.lang].rtlAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].rtlUnlocked
    end
end

local function lock_group_sticker(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'yes' then
        return langs[msg.lang].stickersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].stickersLocked
    end
end

local function unlock_group_sticker(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'no' then
        return langs[msg.lang].stickersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].stickersUnlocked
    end
end

local function lock_group_contacts(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'yes' then
        return langs[msg.lang].contactsAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].contactsLocked
    end
end

local function unlock_group_contacts(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'no' then
        return langs[msg.lang].contactsAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].contactsUnlocked
    end
end

local function enable_strict_rules(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_rtl_lock = data[tostring(target)]['settings']['strict']
    if strict == 'yes' then
        return langs[msg.lang].strictrulesAlreadyLocked
    else
        data[tostring(target)]['settings']['strict'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].strictrulesLocked
    end
end

local function disable_strict_rules(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_contacts_lock = data[tostring(target)]['settings']['strict']
    if strict == 'no' then
        return langs[msg.lang].strictrulesAlreadyUnlocked
    else
        data[tostring(target)]['settings']['strict'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].strictrulesUnlocked
    end
end

local function set_rulesmod(msg, data, target)
    if not is_momod(msg) then
        return langs[msg.lang].require_mod
    end
    local data_cat = 'rules'
    data[tostring(target)][data_cat] = rules
    save_data(_config.moderation.data, data)
    return langs[msg.lang].newRules .. rules
end
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_momod(msg) then
        return
    end
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data = load_data(_config.moderation.data)
    if is_group(msg) then
        return langs[msg.lang].groupAlreadyAdded
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modadd, { receiver = receiver, data = data, msg = msg })
end
local function realmadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_momod(msg) then
        return
    end
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data = load_data(_config.moderation.data)
    if is_realm(msg) then
        return langs[msg.lang].realmAlreadyAdded
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realm_add, { receiver = receiver, data = data, msg = msg })
end
-- Global functions
function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data = load_data(_config.moderation.data)
    if not is_group(msg) then
        return langs[msg.lang].groupNotAdded
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modrem, { receiver = receiver, data = data, msg = msg })
end

function realmrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data = load_data(_config.moderation.data)
    if not is_realm(msg) then
        return langs[msg.lang].realmNotAdded
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realmrem, { receiver = receiver, data = data, msg = msg })
end
local function get_rules(msg, data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
        return langs[msg.lang].noRules
    end
    local rules = data[tostring(msg.to.id)][data_cat]
    local rules = langs[msg.lang].rules .. rules
    return rules
end

local function set_group_photo(msg, success, result)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/chat_photo_' .. msg.to.id .. '.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        chat_set_photo(receiver, file, ok_cb, false)
        data[tostring(msg.to.id)]['settings']['set_photo'] = file
        save_data(_config.moderation.data, data)
        data[tostring(msg.to.id)]['settings']['lock_photo'] = 'yes'
        save_data(_config.moderation.data, data)
        send_large_msg(receiver, langs[msg.lang].photoSaved, ok_cb, false)
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, langs[msg.lang].errorTryAgain, ok_cb, false)
    end
end

local function promote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'chat#id', '')
    if not data[group] then
        return send_large_msg(receiver, langs[lang].groupNotAdded)
    end
    if data[group]['moderators'][tostring(member_id)] then
        return send_large_msg(receiver, member_username .. langs[lang].alreadyMod)
    end
    data[group]['moderators'][tostring(member_id)] = member_username
    save_data(_config.moderation.data, data)
    return send_large_msg(receiver, member_username .. langs[lang].promoteMod)
end

local function promote_by_reply(extra, success, result)
    local msg = result
    local full_name =(msg.from.first_name or '') .. ' ' ..(msg.from.last_name or '')
    if msg.from.username then
        member_username = '@' .. msg.from.username
    else
        member_username = full_name
    end
    local member_id = msg.from.peer_id
    if msg.to.peer_type == 'chat' then
        return promote('chat#id' .. result.to.peer_id, member_username, member_id)
    end
end

local function demote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'chat#id', '')
    if not data[group] then
        return send_large_msg(receiver, langs[lang].groupNotAdded)
    end
    if not data[group]['moderators'][tostring(member_id)] then
        return send_large_msg(receiver, member_username .. langs[lang].notMod)
    end
    data[group]['moderators'][tostring(member_id)] = nil
    save_data(_config.moderation.data, data)
    return send_large_msg(receiver, member_username .. langs[lang].demoteMod)
end

local function demote_by_reply(extra, success, result)
    local msg = result
    local full_name =(msg.from.first_name or '') .. ' ' ..(msg.from.last_name or '')
    if msg.from.username then
        member_username = '@' .. msg.from.username
    else
        member_username = full_name
    end
    local member_id = msg.from.peer_id
    if msg.to.peer_type == 'chat' then
        return demote('chat#id' .. result.to.peer_id, member_username, member_id)
    end
end

local function setowner_by_reply(extra, success, result)
    local msg = result
    local lang = get_lang(msg.to.id)
    local receiver = get_receiver(msg)
    local data = load_data(_config.moderation.data)
    local name_log = msg.from.print_name:gsub("_", " ")
    data[tostring(msg.to.id)]['set_owner'] = tostring(msg.from.id)
    save_data(_config.moderation.data, data)
    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. msg.from.id .. "] as owner")
    local text = msg.from.print_name:gsub("_", " ") .. langs[lang].setOwner
    return send_large_msg(receiver, text)
end

local function promote_demote_res(extra, success, result)
    -- vardump(result)
    -- vardump(extra)
    local member_id = result.peer_id
    local member_username = "@" .. result.username
    local chat_id = extra.chat_id
    local mod_cmd = extra.mod_cmd
    local receiver = "chat#id" .. chat_id
    if mod_cmd == 'promote' then
        return promote(receiver, member_username, member_id)
    elseif mod_cmd == 'demote' then
        return demote(receiver, member_username, member_id)
    end
end

local function mute_user_callback(extra, success, result)
    local lang = get_lang(string.match(receiver, '%d+'))
    if result.service then
        if result.action.type == 'chat_add_user' or result.action.type == 'chat_del_user' or result.action.type == 'chat_rename' or result.action.type == 'chat_change_photo' then
            if result.action.user then
                user_id = result.action.user.peer_id
            end
        end
    else
        user_id = result.from.peer_id
    end
    local receiver = extra.receiver
    local chat_id = string.gsub(receiver, 'chat#id', '')
    if is_muted_user(chat_id, user_id) then
        mute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. langs[lang].muteUserRemove)
    else
        unmute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. langs[lang].muteUserAdd)
    end
end

local function muteuser_from(extra, success, result)
    local lang = get_lang(result.to.peer_id)
    if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
        unmute_user(result.to.peer_id, result.fwd_from.peer_id)
        send_large_msg('chat#id' .. result.to.peer_id, result.fwd_from.peer_id .. langs[lang].muteUserRemove)
    else
        mute_user(result.to.peer_id, result.fwd_from.peer_id)
        send_large_msg('chat#id' .. result.to.peer_id, result.fwd_from.peer_id .. langs[lang].muteUserAdd)
    end
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local groups = "groups"
    if not data[tostring(groups)][tostring(msg.to.id)] then
        return langs[msg.lang].groupNotAdded
    end
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['moderators']) == nil then
        -- fix way
        return langs[msg.lang].noGroupMods
    end
    local i = 1
    local message = langs[msg.lang].modListStart .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
    for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
        message = message .. i .. '. ' .. v .. ' - ' .. k .. '\n'
        i = i + 1
    end
    return message
end

local function callback_mute_res(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local user_id = result.peer_id
    local receiver = extra.receiver
    local chat_id = string.gsub(receiver, 'chat#id', '')
    -- ignore higher or same rank
    if compare_ranks(extra.executer, user_id, chat_id) then
        if is_muted_user(chat_id, user_id) then
            unmute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. langs[lang].muteUserRemove)
        else
            mute_user(chat_id, user_id)
            send_large_msg(receiver, user_id .. langs[lang].muteUserAdd)
        end
    else
        send_large_msg(receiver, langs[lang].require_rank)
    end
end

local function cleanmember(extra, success, result)
    local receiver = extra.receiver
    local chat_id = "chat#id" .. result.id
    local chatname = result.print_name
    for k, v in pairs(result.members) do
        kick_user(v.id, result.peer_id)
    end
end

local function killchat(extra, success, result)
    for k, v in pairs(result.members) do
        local function post_kick()
            kick_user_any(v.peer_id, result.peer_id)
        end
        postpone(post_kick, false, 1)
    end
    chat_del_user('chat#id' .. result.peer_id, 'user#id' .. our_id, ok_cb, true)
end

local function killrealm(extra, success, result)
    for k, v in pairs(result.members) do
        local function post_kick()
            kick_user_any(v.peer_id, result.peer_id)
        end
        postpone(post_kick, false, 1)
    end
    chat_del_user('chat#id' .. result.peer_id, 'user#id' .. our_id, ok_cb, true)
end

local function run(msg, matches)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    local name_log = user_print_name(msg.from)
    local group = msg.to.id
    if msg.media then
        if msg.media.type == 'photo' and data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_chat_msg(msg) and is_momod(msg) then
            load_photo(msg.id, set_group_photo, msg)
        end
    end
    if msg.to.type == 'chat' then
        if is_admin1(msg) or not is_support(msg.from.id) then
            -- Admin only
            if matches[1]:lower() == 'add' and not matches[2] then
                if not is_admin1(msg) and not is_support(msg.from.id) then
                    -- Admin only
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to add group [ " .. msg.to.id .. " ]")
                    return
                end
                if is_realm(msg) then
                    return langs[msg.lang].errorAlreadyRealm
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added group [ " .. msg.to.id .. " ]")
                print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") added")
                return modadd(msg)
            end
            if matches[1]:lower() == 'add' and matches[2]:lower() == 'realm' then
                if not is_sudo(msg) then
                    -- Admin only
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to add realm [ " .. msg.to.id .. " ]")
                    return
                end
                if is_group(msg) then
                    return langs[msg.lang].errorAlreadyGroup
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added realm [ " .. msg.to.id .. " ]")
                print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") added as a realm")
                return realmadd(msg)
            end
            if matches[1]:lower() == 'rem' and not matches[2] then
                if not is_admin1(msg) and not is_support(msg.from.id) then
                    -- Admin only
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to remove group [ " .. msg.to.id .. " ]")
                    return
                end
                if not is_group(msg) then
                    return langs[msg.lang].errorNotGroup
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed group [ " .. msg.to.id .. " ]")
                print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed")
                return modrem(msg)
            end
            if matches[1]:lower() == 'rem' and matches[2]:lower() == 'realm' then
                if not is_sudo(msg) then
                    -- Sudo only
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to remove realm [ " .. msg.to.id .. " ]")
                    return
                end
                if not is_realm(msg) then
                    return langs[msg.lang].errorNotRealm
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed realm [ " .. msg.to.id .. " ]")
                print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed as a realm")
                return realmrem(msg)
            end
        end
        if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "group" then
            return automodadd(msg)
        end
        --[[Experimental
  if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "super_group" then
	local chat_id = get_receiver(msg)
	users = {[1]="user#id167472799",[2]="user#id170131770"}
		for k,v in pairs(users) do
			chat_add_user(chat_id, v, ok_cb, false)
		end
	--chat_upgrade(chat_id, ok_cb, false)
  end ]]
        if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "realm" then
            return autorealmadd(msg)
        end
        if msg.to.id and data[tostring(msg.to.id)] then
            local settings = data[tostring(msg.to.id)]['settings']
            if matches[1] == 'chat_add_user' then
                if not msg.service then
                    return
                end
                local group_member_lock = settings.lock_member
                local user = 'user#id' .. msg.action.user.id
                local chat = 'chat#id' .. msg.to.id
                if group_member_lock == 'yes' and not is_owner2(msg.action.user.id, msg.to.id) then
                    chat_del_user(chat, user, ok_cb, true)
                elseif group_member_lock == 'yes' and tonumber(msg.from.id) == tonumber(our_id) then
                    return nil
                elseif group_member_lock == 'no' then
                    return nil
                end
            end
            if matches[1] == 'chat_del_user' then
                if not msg.service then
                    return
                end
                local user = 'user#id' .. msg.action.user.id
                local chat = 'chat#id' .. msg.to.id
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] deleted user  " .. user)
            end
            if matches[1] == 'chat_delete_photo' then
                if not msg.service then
                    return
                end
                local group_photo_lock = settings.lock_photo
                if group_photo_lock == 'yes' then
                    local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                    redis:incr(picturehash)
                    -- -
                    local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                    local picprotectionredis = redis:get(picturehash)
                    if picprotectionredis then
                        if tonumber(picprotectionredis) == 4 and not is_owner(msg) then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if tonumber(picprotectionredis) == 8 and not is_owner(msg) then
                            ban_user(msg.from.id, msg.to.id)
                            local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                            redis:set(picturehash, 0)
                        end
                    end

                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] tried to deleted picture but failed  ")
                    chat_set_photo(receiver, settings.set_photo, ok_cb, false)
                elseif group_photo_lock == 'no' then
                    return nil
                end
            end
            if matches[1] == 'chat_change_photo' and msg.from.id ~= 0 then
                if not msg.service then
                    return
                end
                local group_photo_lock = settings.lock_photo
                if group_photo_lock == 'yes' then
                    local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                    redis:incr(picturehash)
                    -- -
                    local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                    local picprotectionredis = redis:get(picturehash)
                    if picprotectionredis then
                        if tonumber(picprotectionredis) == 4 and not is_owner(msg) then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if tonumber(picprotectionredis) == 8 and not is_owner(msg) then
                            ban_user(msg.from.id, msg.to.id)
                            local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                            redis:set(picturehash, 0)
                        end
                    end

                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] tried to change picture but failed  ")
                    chat_set_photo(receiver, settings.set_photo, ok_cb, false)
                elseif group_photo_lock == 'no' then
                    return nil
                end
            end
            if matches[1] == 'chat_rename' then
                if not msg.service then
                    return
                end
                local group_name_set = settings.set_name
                local group_name_lock = settings.lock_name
                local to_rename = 'chat#id' .. msg.to.id
                if group_name_lock == 'yes' then
                    if group_name_set ~= tostring(msg.to.print_name) then
                        local namehash = 'name:changed:' .. msg.to.id .. ':' .. msg.from.id
                        redis:incr(namehash)
                        local namehash = 'name:changed:' .. msg.to.id .. ':' .. msg.from.id
                        local nameprotectionredis = redis:get(namehash)
                        if nameprotectionredis then
                            if tonumber(nameprotectionredis) == 4 and not is_owner(msg) then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if tonumber(nameprotectionredis) == 8 and not is_owner(msg) then
                                ban_user(msg.from.id, msg.to.id)
                                local namehash = 'name:changed:' .. msg.to.id .. ':' .. msg.from.id
                                redis:set(namehash, 0)
                            end
                        end
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] tried to change name but failed  ")
                        rename_chat(to_rename, group_name_set, ok_cb, false)
                    end
                elseif group_name_lock == 'no' then
                    return nil
                end
            end
            if (matches[1]:lower() == 'setname' or matches[1]:lower() == 'setgpname') and is_momod(msg) then
                local new_name = string.gsub(matches[2], '_', ' ')
                data[tostring(msg.to.id)]['settings']['set_name'] = new_name
                save_data(_config.moderation.data, data)
                local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
                local to_rename = 'chat#id' .. msg.to.id
                rename_chat(to_rename, group_name_set, ok_cb, false)

                savelog(msg.to.id, "Group { " .. msg.to.print_name .. " }  name changed to [ " .. new_name .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
            end
            if (matches[1]:lower() == 'setphoto' or matches[1]:lower() == 'setgpphoto') and is_momod(msg) then
                data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
                save_data(_config.moderation.data, data)
                return langs[msg.lang].sendNewGroupPic
            end
            if matches[1]:lower() == 'promote' or matches[1]:lower() == 'sasha promuovi' or matches[1]:lower() == 'promuovi' then
                if not is_owner(msg) then
                    return langs[msg.lang].require_owner
                end
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, promote_by_reply, false)
                elseif matches[2] then
                    local member = matches[2]
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted @" .. member)
                    local cbres_extra = {
                        chat_id = msg.to.id,
                        mod_cmd = 'promote',
                        from_id = msg.from.id
                    }
                    local username = matches[2]
                    local username = string.gsub(matches[2], '@', '')
                    return resolve_username(username, promote_demote_res, cbres_extra)
                end
            end
            if matches[1]:lower() == 'demote' or matches[1]:lower() == 'sasha degrada' or matches[1]:lower() == 'degrada' then
                if not is_owner(msg) then
                    return langs[msg.lang].require_owner
                end
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, demote_by_reply, false)
                elseif matches[2] then
                    if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
                        return langs[msg.lang].noAutoDemote
                    end
                    local member = matches[2]
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted @" .. member)
                    local cbres_extra = {
                        chat_id = msg.to.id,
                        mod_cmd = 'demote',
                        from_id = msg.from.id
                    }
                    local username = matches[2]
                    local username = string.gsub(matches[2], '@', '')
                    return resolve_username(username, promote_demote_res, cbres_extra)
                end
            end
            if matches[1]:lower() == 'modlist' or matches[1]:lower() == 'sasha lista mod' or matches[1]:lower() == 'lista mod' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group modlist")
                return modlist(msg)
            end
            if matches[1]:lower() == 'about' or matches[1]:lower() == 'sasha descrizione' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group description")
                return get_description(msg, data)
            end
            if matches[1]:lower() == 'rules' or matches[1]:lower() == 'sasha regole' then
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
            if matches[1]:lower() == 'setrules' or matches[1]:lower() == 'sasha imposta regole' then
                rules = matches[2]
                local target = msg.to.id
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group rules to [" .. matches[2] .. "]")
                return set_rulesmod(msg, data, target)
            end
            if matches[1]:lower() == 'setabout' or matches[1]:lower() == 'sasha imposta descrizione' then
                local data = load_data(_config.moderation.data)
                local target = msg.to.id
                local about = matches[2]
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group description to [" .. matches[2] .. "]")
                return set_descriptionmod(msg, data, target, about)
            end
        end
        -- Begin chat settings
        if matches[1]:lower() == 'lock' or matches[1]:lower() == 'sasha blocca' or matches[1]:lower() == 'blocca' then
            local target = msg.to.id
            if matches[2]:lower() == 'name' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked name ")
                return lock_group_namemod(msg, data, target)
            end
            if matches[2]:lower() == 'member' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked member ")
                return lock_group_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'photo' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked photo ")
                return lock_group_photomod(msg, data, target)
            end
            if matches[2]:lower() == 'flood' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked flood ")
                return lock_group_floodmod(msg, data, target)
            end
            if matches[2]:lower() == 'arabic' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked arabic ")
                return lock_group_arabic(msg, data, target)
            end
            if matches[2]:lower() == 'bots' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked bots ")
                return lock_group_bots(msg, data, target)
            end
            if matches[2]:lower() == 'leave' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked leaving ")
                return lock_group_leave(msg, data, target)
            end
            if matches[2]:lower() == 'links' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked link posting ")
                return lock_group_links(msg, data, target)
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
        end
        if matches[1]:lower() == 'unlock' or matches[1]:lower() == 'sasha sblocca' or matches[1]:lower() == 'sblocca' then
            local target = msg.to.id
            if matches[2]:lower() == 'name' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked name ")
                return unlock_group_namemod(msg, data, target)
            end
            if matches[2]:lower() == 'member' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked member ")
                return unlock_group_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'photo' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked photo ")
                return unlock_group_photomod(msg, data, target)
            end
            if matches[2]:lower() == 'flood' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked flood ")
                return unlock_group_floodmod(msg, data, target)
            end
            if matches[2]:lower() == 'arabic' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked arabic ")
                return unlock_group_arabic(msg, data, target)
            end
            if matches[2]:lower() == 'bots' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked bots ")
                return unlock_group_bots(msg, data, target)
            end
            if matches[2]:lower() == 'leave' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked leaving ")
                return unlock_group_leave(msg, data, target)
            end
            if matches[2]:lower() == 'links' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked link posting")
                return unlock_group_links(msg, data, target)
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
        end
        -- End chat settings

        -- Begin Chat mutes

        if (matches[1]:lower() == 'mute' or matches[1]:lower() == 'silenzia') and is_owner(msg) then
            local chat_id = msg.to.id
            if matches[2]:lower() == 'audio' then
                local msg_type = 'Audio'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                end
            end
        end
        if (matches[1]:lower() == 'unmute' or matches[1]:lower() == 'ripristina') and is_owner(msg) then
            local chat_id = msg.to.id
            if matches[2]:lower() == 'audio' then
                local msg_type = 'Audio'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute message")
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                else
                    return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                end
            end
        end

        -- Begin chat muteuser
        if (matches[1]:lower() == "muteuser" or matches[1]:lower() == 'voce') and is_momod(msg) then
            local chat_id = msg.to.id
            local hash = "mute_user" .. chat_id
            local user_id = ""
            if type(msg.reply_id) ~= "nil" then
                if matches[2] then
                    if matches[2]:lower() == 'from' then
                        get_message(msg.reply_id, muteuser_from, { receiver = receiver, executer = msg.from.id })
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
                -- ignore higher or same rank
                if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                    if is_muted_user(msg.to.id, matches[2]) then
                        unmute_user(msg.to.id, matches[2])
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed [" .. matches[2] .. "] from the muted users list")
                        return matches[2] .. langs[msg.lang].muteUserRemove
                    else
                        mute_user(msg.to.id, matches[2])
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. matches[2] .. "] to the muted users list")
                        return matches[2] .. langs[msg.lang].muteUserAdd
                    end
                else
                    return langs[msg.lang].require_rank
                end
            else
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                resolve_username(username, callback_mute_res, { receiver = receiver, get_cmd = get_cmd, executer = msg.from.id })
            end
        end

        -- End Chat muteuser
        if (matches[1]:lower() == "muteslist" or matches[1]:lower() == "lista muti") and is_momod(msg) then
            local chat_id = msg.to.id
            if not has_mutes(chat_id) then
                set_mutes(chat_id)
                return mutes_list(chat_id, msg.to.print_name)
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup muteslist")
            return mutes_list(chat_id, msg.to.print_name)
        end
        if (matches[1]:lower() == "mutelist" or matches[1]:lower() == "lista utenti muti") and is_momod(msg) then
            local chat_id = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
            return muted_user_list(chat_id, msg.to.print_name)
        end

        if matches[1]:lower() == 'settings' and is_momod(msg) then
            local target = msg.to.id
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group settings ")
            return show_group_settingsmod(msg, target)
        end

        if matches[1]:lower() == 'public' and is_momod(msg) then
            local target = msg.to.id
            if matches[2]:lower() == 'yes' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: public")
                return set_public_membermod(msg, data, target)
            end
            if matches[2]:lower() == 'no' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: not public")
                return unset_public_membermod(msg, data, target)
            end
        end

        if msg.to.type == 'chat' then
            if matches[1]:lower() == 'newlink' and not is_realm(msg) then
                if not is_momod(msg) then
                    return langs[msg.lang].require_mod
                end
                local function callback(extra, success, result)
                    local receiver = 'chat#' .. msg.to.id
                    if success == 0 then
                        return send_large_msg(receiver, langs[msg.lang].errorCreateLink)
                    end
                    send_large_msg(receiver, langs[msg.lang].linkCreated)
                    data[tostring(msg.to.id)]['settings']['set_link'] = result
                    save_data(_config.moderation.data, data)
                end
                local receiver = 'chat#' .. msg.to.id
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] revoked group link ")
                return export_chat_link(receiver, callback, true)
            end

            if (matches[1]:lower() == 'setlink' or matches[1]:lower() == "sasha imposta link") and matches[2] then
                if is_owner(msg) then
                    data[tostring(msg.to.id)]['settings']['set_link'] = matches[2]
                    save_data(_config.moderation.data, data)
                    return langs[msg.lang].linkSaved
                else
                    return langs[msg.lang].require_owner
                end
            end

            if matches[1]:lower() == 'unsetlink' or matches[1]:lower() == "sasha elimina link" then
                if is_owner(msg) then
                    data[tostring(msg.to.id)]['settings']['set_link'] = nil
                    save_data(_config.moderation.data, data)
                    return langs[msg.lang].linkDeleted
                else
                    return langs[msg.lang].require_owner
                end
            end

            if matches[1]:lower() == 'link' or matches[1]:lower() == 'sasha link' then
                if not is_momod(msg) then
                    return langs[msg.lang].require_mod
                end
                local group_link = data[tostring(msg.to.id)]['settings']['set_link']
                if not group_link then
                    return langs[msg.lang].createLinkInfo
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
                return msg.to.title .. '\n' .. group_link
            end
            if matches[1]:lower() == 'setowner' then
                if not is_owner(msg) then
                    return langs[msg.lang].require_owner
                end
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, setowner_by_reply, false)
                elseif matches[2] then
                    data[tostring(msg.to.id)]['set_owner'] = matches[2]
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. matches[2] .. "] as owner")
                    local text = matches[2] .. langs[msg.lang].setOwner
                    return text
                end
            end
        end
        if matches[1]:lower() == 'owner' then
            local group_owner = data[tostring(msg.to.id)]['set_owner']
            if not group_owner then
                return langs[msg.lang].noOwnerCallAdmin
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] used /owner")
            return langs[msg.lang].ownerIs .. group_owner
        end
        if matches[1]:lower() == 'setflood' then
            if not is_momod(msg) then
                return langs[msg.lang].require_mod
            end
            if tonumber(matches[2]) < 3 or tonumber(matches[2]) > 200 then
                return langs[msg.lang].errorFloodRange
            end
            local flood_max = matches[2]
            data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
            save_data(_config.moderation.data, data)
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set flood to [" .. matches[2] .. "]")
            return langs[msg.lang].floodSet .. matches[2]
        end

        if msg.to.type == 'chat' then
            if matches[1]:lower() == 'clean' then
                if not is_owner(msg) then
                    return langs[msg.lang].require_owner
                end
                if matches[2]:lower() == 'member' then
                    local receiver = get_receiver(msg)
                    chat_info(receiver, cleanmember, { receiver = receiver })
                end
                if matches[2]:lower() == 'modlist' then
                    if next(data[tostring(msg.to.id)]['moderators']) == nil then
                        -- fix way
                        return langs[msg.lang].noGroupMods
                    end
                    local message = langs[msg.lang].modListStart .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
                    for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
                        data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
                        save_data(_config.moderation.data, data)
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned modlist")
                end
                if matches[2]:lower() == 'rules' then
                    local data_cat = 'rules'
                    data[tostring(msg.to.id)][data_cat] = nil
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned rules")
                end
                if matches[2]:lower() == 'about' then
                    local data_cat = 'description'
                    data[tostring(msg.to.id)][data_cat] = nil
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned about")
                end
            end
        end
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            if matches[1]:lower() == 'kill' and matches[2]:lower() == 'group' then
                if not is_admin1(msg) then
                    return
                end
                if not is_realm(msg) then
                    local receiver = 'chat#id' .. msg.to.id
                    print("Closing Group: " .. receiver)
                    chat_info(receiver, killchat, false)
                    return modrem(msg)
                else
                    return langs[msg.lang].realmIs
                end
            end
            if matches[1]:lower() == 'kill' and matches[2]:lower() == 'realm' then
                if not is_admin1(msg) then
                    return
                end
                if is_realm(msg) then
                    local receiver = 'chat#id' .. msg.to.id
                    print("Closing realm: " .. receiver)
                    chat_info(receiver, killrealm, false)
                    return realmrem(msg)
                else
                    return langs[msg.lang].groupIs
                end
            end
        end
    end
end

return {
    description = "INGROUP",
    patterns =
    {
        "^[#!/]([Aa][Dd][Dd])$",
        "^[#!/]([Aa][Dd][Dd]) ([Rr][Ee][Aa][Ll][Mm])$",
        "^[#!/]([Rr][Ee][Mm])$",
        "^[#!/]([Rr][Ee][Mm]) ([Rr][Ee][Aa][Ll][Mm])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Ss])$",
        "^[#!/]([Aa][Bb][Oo][Uu][Tt])$",
        "^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee])$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn]) (.*)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Gg][Rr][Oo][Uu][Pp])$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Rr][Ee][Aa][Ll][Mm])$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee])$",
        "^[#!/]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
        "^[#!/]([Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$",
        "^[#!/]([Oo][Ww][Nn][Ee][Rr])$",
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
        "^[#!/]([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
        "^[#!/]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ll][Ii][Nn][Kk])$",
        "^[#!/]([Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "%[(photo)%]",
        "^!!tgservice (.+)$",
        -- rules
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ee][Gg][Oo][Ll][Ee])$",
        -- about
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Ss][Cc][Rr][Ii][Zz][Ii][Oo][Nn][Ee])$",
        -- setname
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Nn][Aa][Mm][Ee]) (.*)$",
        -- setphoto
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Pp][Hh][Oo][Tt][Oo])$",
        -- promote
        "^([Ss][Aa][Ss][Hh][Aa] [Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii])$",
        "^([Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii]) (.*)$",
        "^([Pp][Rr][Oo][Mm][Uu][Oo][Vv][Ii])$",
        -- demote
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Gg][Rr][Aa][Dd][Aa]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Gg][Rr][Aa][Dd][Aa])$",
        "^([Dd][Ee][Gg][Rr][Aa][Dd][Aa]) (.*)$",
        "^([Dd][Ee][Gg][Rr][Aa][Dd][Aa])$",
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
        -- modlist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Mm][Oo][Dd])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Oo][Dd])$",
        -- newlink
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Ll][Ii][Nn][Kk])$",
        -- link
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Nn][Kk])$",
        -- setlink
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        -- unsetlink
        "^([Ss][Aa][Ss][Hh][Aa] [Ee][Ll][Ii][Mm][Ii][Nn][Aa] [Ll][Ii][Nn][Kk])$",
        -- mute
        "^([Ss][Ii][Ll][Ee][Nn][Zz][Ii][Aa]) ([^%s]+)$",
        -- unmute
        "^([Rr][Ii][Pp][Rr][Ii][Ss][Tt][Ii][Nn][Aa]) ([^%s]+)$",
        -- muteuser
        "^([Vv][Oo][Cc][Ee])$",
        "^([Vv][Oo][Cc][Ee]) (.*)$",
        -- muteslist
        "^([Ll][Ii][Ss][Tt][Aa] [Mm][Uu][Tt][Ii])$",
        -- mutelist
        "^([Ll][Ii][Ss][Tt][Aa] [Uu][Tt][Ee][Nn][Tt][Ii] [Mm][Uu][Tt][Ii])$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- (#rules|sasha regole)
    -- (#about|sasha descrizione)
    -- (#modlist|[sasha] lista mod)
    -- #owner
    -- MOD
    -- #setname|#setgpname <group_name>
    -- #setphoto|#setgpphoto
    -- (#setrules|sasha imposta regole) <text>
    -- (#setabout|sasha imposta descrizione) <text>
    -- (#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts
    -- (#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts
    -- #muteuser|voce <id>|<username>|<reply>
    -- (#muteslist|lista muti)
    -- (#mutelist|lista utenti muti)
    -- #settings
    -- #public yes|no
    -- (#newlink|sasha crea link)
    -- (#link|sasha link)
    -- #setflood <value>
    -- OWNER
    -- (#setlink|sasha imposta link) <link>
    -- (#unsetlink|sasha elimina link)
    -- (#promote|[sasha] promuovi) <username>|<reply>
    -- (#demote|[sasha] degrada) <username>|<reply>
    -- #mute|silenzia all|text|documents|gifs|video|photo|audio
    -- #unmute|ripristina all|text|documents|gifs|video|photo|audio
    -- #setowner <id>|<reply>
    -- #clean modlist|rules|about
    -- ADMIN
    -- #add [realm]
    -- #rem [realm]
    -- #kill group|realm
}