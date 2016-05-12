-- Check Member
local function check_member_autorealm(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('welcomeNewRealm'))
        end
    end
end
local function check_member_realm_add(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('realmAdded'))
        end
    end
end
function check_member_group(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('promotedOwner'))
        end
    end
end
local function check_member_modadd(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('groupAddedOwner'))
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
local function check_member_realmrem(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('realmRemoved'))
        end
    end
end
local function check_member_modrem(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local data = cb_extra.data
    local msg = cb_extra.msg
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
            return send_large_msg(receiver, lang_text('groupRemoved'))
        end
    end
end
-- End Check Member
function show_group_settingsmod(msg, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
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
    local text = lang_text('groupSettings') ..
    lang_text('nameLock') .. settings.lock_name ..
    lang_text('photoLock') .. settings.lock_photo ..
    lang_text('membersLock') .. settings.lock_member ..
    lang_text('leaveLock') .. leave_ban ..
    lang_text('floodSensibility') .. NUM_MSG_MAX ..
    lang_text('botsLock') .. bots_protection ..
    lang_text('linksLock') .. settings.lock_link ..
    lang_text('rtlLock') .. settings.lock_rtl ..
    lang_text('stickersLock') .. settings.lock_sticker ..
    lang_text('public') .. settings.public
    return text
end

local function set_descriptionmod(msg, data, target, about)
    if not is_momod(msg) then
        return
    end
    local data_cat = 'description'
    data[tostring(target)][data_cat] = about
    save_data(_config.moderation.data, data)
    return lang_text('newDescription') .. about
end
local function get_description(msg, data)
    local data_cat = 'description'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noDescription')
    end
    local about = data[tostring(msg.to.id)][data_cat]
    local about = string.gsub(msg.to.print_name, "_", " ") .. ':\n\n' .. about
    return lang_text('description') .. about
end
local function lock_group_arabic(msg, data, target)
    if not is_momod(msg) then
        return
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
        return
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

local function lock_group_bots(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'yes' then
        return lang_text('botsAlreadyLocked')
    else
        data[tostring(target)]['settings']['lock_bots'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('botsLocked')
    end
end

local function unlock_group_bots(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'no' then
        return lang_text('botsAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_bots'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('botsUnlocked')
    end
end

local function lock_group_namemod(msg, data, target)
    if not is_momod(msg) then
        return
    end
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
    if not is_momod(msg) then
        return
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'no' then
        return lang_text('nameAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_name'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('nameUnlocked')
    end
end
local function lock_group_floodmod(msg, data, target)
    if not is_momod(msg) then
        return
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

local function unlock_group_floodmod(msg, data, target)
    if not is_momod(msg) then
        return
    end
    if not is_owner(msg) then
        return lang_text('floodUnlockOwners')
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

local function lock_group_membermod(msg, data, target)
    if not is_momod(msg) then
        return
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
        return
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
    local group_member_lock = data[tostring(target)]['settings']['public']
    local long_id = data[tostring(target)]['long_id']
    if not long_id then
        data[tostring(target)]['long_id'] = msg.to.peer_id
        save_data(_config.moderation.data, data)
    end
    if group_member_lock == 'no' then
        return lang_text('publicAlreadyNo')
    else
        data[tostring(target)]['settings']['public'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('publicNo')
    end
end

local function lock_group_leave(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local leave_ban = data[tostring(target)]['settings']['leave_ban']
    if leave_ban == 'yes' then
        return lang_text('leaveAlreadyLocked')
    else
        data[tostring(target)]['settings']['leave_ban'] = 'yes'
        save_data(_config.moderation.data, data)
        return lang_text('leaveLocked')
    end
end

local function unlock_group_leave(msg, data, target)
    if not is_momod(msg) then
        return
    end
    local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
    if leave_ban == 'no' then
        return lang_text('leaveAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['leave_ban'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('leaveUnlocked')
    end
end

local function lock_group_photomod(msg, data, target)
    if not is_momod(msg) then
        return
    end
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
    if not is_momod(msg) then
        return
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'no' then
        return lang_text('photoAlreadyUnlocked')
    else
        data[tostring(target)]['settings']['lock_photo'] = 'no'
        save_data(_config.moderation.data, data)
        return lang_text('photoUnlocked')
    end
end

local function lock_group_links(msg, data, target)
    if not is_momod(msg) then
        return
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
        return
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

local function lock_group_rtl(msg, data, target)
    if not is_momod(msg) then
        return
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
        return
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
        return
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
        return
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

local function set_rulesmod(msg, data, target)
    if not is_momod(msg) then
        return lang_text('require_mod')
    end
    local data_cat = 'rules'
    data[tostring(target)][data_cat] = rules
    save_data(_config.moderation.data, data)
    return lang_text('newRules') .. rules
end
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_momod(msg) then
        return
    end
    if not is_admin1(msg) then
        return lang_text('require_admin')
    end
    local data = load_data(_config.moderation.data)
    if is_group(msg) then
        return lang_text('groupAlreadyAdded')
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
        return lang_text('require_admin')
    end
    local data = load_data(_config.moderation.data)
    if is_realm(msg) then
        return lang_text('realmAlreadyAdded')
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realm_add, { receiver = receiver, data = data, msg = msg })
end
-- Global functions
function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin1(msg) then
        return lang_text('require_admin')
    end
    local data = load_data(_config.moderation.data)
    if not is_group(msg) then
        return lang_text('groupNotAdded')
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modrem, { receiver = receiver, data = data, msg = msg })
end

function realmrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin1(msg) then
        return lang_text('require_admin')
    end
    local data = load_data(_config.moderation.data)
    if not is_realm(msg) then
        return lang_text('realmNotAdded')
    end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realmrem, { receiver = receiver, data = data, msg = msg })
end
local function get_rules(msg, data)
    local data_cat = 'rules'
    if not data[tostring(msg.to.id)][data_cat] then
        return lang_text('noRules')
    end
    local rules = data[tostring(msg.to.id)][data_cat]
    local rules = lang_text('rules') .. rules
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
        send_large_msg(receiver, lang_text('photoSaved'), ok_cb, false)
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, lang_text('errorTryAgain'), ok_cb, false)
    end
end

local function promote(receiver, member_username, member_id)
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'chat#id', '')
    if not data[group] then
        return send_large_msg(receiver, lang_text('groupNotAdded'))
    end
    if data[group]['moderators'][tostring(member_id)] then
        return send_large_msg(receiver, member_username .. lang_text('alreadyMod'))
    end
    data[group]['moderators'][tostring(member_id)] = member_username
    save_data(_config.moderation.data, data)
    return send_large_msg(receiver, member_username .. lang_text('promoteMod'))
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
    local data = load_data(_config.moderation.data)
    local group = string.gsub(receiver, 'chat#id', '')
    if not data[group] then
        return send_large_msg(receiver, lang_text('groupNotAdded'))
    end
    if not data[group]['moderators'][tostring(member_id)] then
        return send_large_msg(receiver, member_username .. lang_text('notMod'))
    end
    data[group]['moderators'][tostring(member_id)] = nil
    save_data(_config.moderation.data, data)
    return send_large_msg(receiver, member_username .. lang_text('demoteMod'))
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
    local receiver = get_receiver(msg)
    local data = load_data(_config.moderation.data)
    local name_log = msg.from.print_name:gsub("_", " ")
    data[tostring(msg.to.id)]['set_owner'] = tostring(msg.from.id)
    save_data(_config.moderation.data, data)
    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. msg.from.id .. "] as owner")
    local text = msg.from.print_name:gsub("_", " ") .. lang_text('setOwner')
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
    if result.service then
        local action = result.action.type
        if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
            if result.action.user then
                user_id = result.action.user.peer_id
            end
        end
    else
        user_id = result.from.peer_id
    end
    local receiver = extra.receiver
    local chat_id = string.gsub(receiver, 'channel#id', '')
    if is_muted_user(chat_id, user_id) then
        mute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. lang_text('muteUserRemove'))
    else
        unmute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
    end
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local groups = "groups"
    if not data[tostring(groups)][tostring(msg.to.id)] then
        return lang_text('groupNotAdded')
    end
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['moderators']) == nil then
        -- fix way
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

local function callback_mute_res(extra, success, result)
    local user_id = result.peer_id
    local receiver = extra.receiver
    local chat_id = string.gsub(receiver, 'chat#id', '')
    if is_muted_user(chat_id, user_id) then
        unmute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. lang_text('muteUserRemove'))
    else
        mute_user(chat_id, user_id)
        send_large_msg(receiver, user_id .. lang_text('muteUserAdd'))
    end
end

local function cleanmember(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local chat_id = "chat#id" .. result.id
    local chatname = result.print_name
    for k, v in pairs(result.members) do
        kick_user(v.id, result.peer_id)
    end
end

local function killchat(cb_extra, success, result)
    for k, v in pairs(result.members) do
        kick_user_any(v.peer_id, result.peer_id)
    end
    chat_del_user('chat#id' .. result.peer_id, 'user#id' .. our_id, ok_cb, true)
end

local function killrealm(cb_extra, success, result)
    for k, v in pairs(result.members) do
        kick_user_any(v.peer_id, result.peer_id)
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
                    return lang_text('errorAlreadyRealm')
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
                    return lang_text('errorAlreadyGroup')
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
                    return lang_text('errorNotGroup')
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
                    return lang_text('errorNotRealm')
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
                    -- return "Are you trying to troll me?"
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
                return lang_text('sendNewGroupPic')
            end
            if matches[1]:lower() == 'promote' or matches[1]:lower() == 'sasha promuovi' or matches[1]:lower() == 'promuovi' then
                if not is_owner(msg) then
                    return lang_text('require_owner')
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
                    return lang_text('require_owner')
                end
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, demote_by_reply, false)
                elseif matches[2] then
                    if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
                        return lang_text('noAutoDemote')
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
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if not is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: mute " .. msg_type)
                    mute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('enabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyEnabled')
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
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'photo' then
                local msg_type = 'Photo'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'video' then
                local msg_type = 'Video'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'gifs' then
                local msg_type = 'Gifs'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'documents' then
                local msg_type = 'Documents'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'text' then
                local msg_type = 'Text'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute message")
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
            if matches[2]:lower() == 'all' then
                local msg_type = 'All'
                if is_muted(chat_id, msg_type .. ': yes') then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: unmute " .. msg_type)
                    unmute(chat_id, msg_type)
                    return lang_text('mute') .. msg_type .. lang_text('disabled')
                else
                    return lang_text('mute') .. msg_type .. lang_text('alreadyDisabled')
                end
            end
        end

        -- Begin chat muteuser
        if (matches[1]:lower() == "muteuser" or matches[1]:lower() == 'voce') and is_momod(msg) then
            local chat_id = msg.to.id
            local hash = "mute_user" .. chat_id
            local user_id = ""
            if type(msg.reply_id) ~= "nil" then
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                get_message(msg.reply_id, mute_user_callback, { receiver = receiver, get_cmd = get_cmd })
            elseif string.match(matches[2], '^%d+$') then
                local user_id = matches[2]
                if is_muted_user(chat_id, user_id) then
                    mute_user(chat_id, user_id)
                    return user_id .. lang_text('muteUserRemove')
                else
                    unmute_user(chat_id, user_id)
                    return user_id .. lang_text('muteUserAdd')
                end
            else
                local receiver = get_receiver(msg)
                local get_cmd = "mute_user"
                local username = matches[2]
                local username = string.gsub(matches[2], '@', '')
                resolve_username(username, callback_mute_res, { receiver = receiver, get_cmd = get_cmd })
            end
        end

        -- End Chat muteuser
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
                    return lang_text('require_mod')
                end
                local function callback(extra, success, result)
                    local receiver = 'chat#' .. msg.to.id
                    if success == 0 then
                        return send_large_msg(receiver, lang_text('errorCreateLink'))
                    end
                    send_large_msg(receiver, lang_text('linkCreated'))
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
                    return lang_text('linkSaved')
                else
                    return lang_text('require_owner')
                end
            end

            if matches[1]:lower() == 'link' or matches[1]:lower() == 'sasha link' then
                if not is_momod(msg) then
                    return lang_text('require_mod')
                end
                local group_link = data[tostring(msg.to.id)]['settings']['set_link']
                if not group_link then
                    return lang_text('createLinkInfo')
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
                return msg.to.title .. '\n' .. group_link
            end
            if matches[1]:lower() == 'setowner' and matches[2] then
                if not is_owner(msg) then
                    return lang_text('require_owner')
                end
                if type(msg.reply_id) ~= "nil" then
                    msgr = get_message(msg.reply_id, setowner_by_reply, false)
                elseif matches[2] then
                    data[tostring(msg.to.id)]['set_owner'] = matches[2]
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. matches[2] .. "] as owner")
                    local text = matches[2] .. lang_text('setOwner')
                    return text
                end
            end
        end
        if matches[1]:lower() == 'owner' then
            local group_owner = data[tostring(msg.to.id)]['set_owner']
            if not group_owner then
                return lang_text('noOwnerCallAdmin')
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] used /owner")
            return lang_text('ownerIs') .. group_owner
        end
        if matches[1]:lower() == 'setgpowner' then
            local chat = "chat#id" .. matches[2]
            local channel = "channel#id" .. matches[2]
            if not is_admin1(msg) then
                return lang_text('require_admin')
            end
            data[tostring(matches[2])]['set_owner'] = matches[3]
            save_data(_config.moderation.data, data)
            local text = matches[3] .. lang_text('setOwner')
            send_large_msg(chat, text)
            send_large_msg(channel, text)
            return
        end
        if matches[1]:lower() == 'setflood' then
            if not is_momod(msg) then
                return lang_text('require_mod')
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

        if msg.to.type == 'chat' then
            if matches[1]:lower() == 'clean' then
                if not is_owner(msg) then
                    return lang_text('require_owner')
                end
                if matches[2]:lower() == 'member' then
                    local receiver = get_receiver(msg)
                    chat_info(receiver, cleanmember, { receiver = receiver })
                end
                if matches[2]:lower() == 'modlist' then
                    if next(data[tostring(msg.to.id)]['moderators']) == nil then
                        -- fix way
                        return lang_text('noGroupMods')
                    end
                    local message = lang_text('modListStart') .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
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
                    return lang_text('realmIs')
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
                    return lang_text('groupIs')
                end
            end
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
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Oo][Ww][Nn][Ee][Rr]) (%d+) (%d+)$",-- (group id) (owner id)
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
        "^[#!/]([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
        "^[#!/]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ll][Ii][Nn][Kk])$",
        "^[#!/]([Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Uu][Nn][Mm][Uu][Tt][Ee]) ([^%s]+)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])$",
        "^(https://telegram.me/joinchat/%S+)$",
        "%[(document)%]",
        "%[(photo)%]",
        "%[(video)%]",
        "%[(audio)%]",
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
    pre_process = pre_process,
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
    -- (#setlink|[sasha] imposta link) <link>
    -- (#promote|[sasha] promuovi) <username>|<reply>
    -- (#demote|[sasha] degrada) <username>|<reply>
    -- #mute|silenzia all|text|documents|gifs|video|photo|audio
    -- #unmute|ripristina all|text|documents|gifs|video|photo|audio
    -- #setowner <id>
    -- #clean modlist|rules|about
    -- ADMIN
    -- #add [realm]
    -- #rem [realm]
    -- #kill group|realm
    -- #setgpowner <group_id> <user_id>
}