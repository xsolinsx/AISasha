-- REFACTORING OF INPM.LUA INREALM.LUA INGROUP.LUA AND SUPERGROUP.LUA

group_type = ''

-- INPM
local function all_chats(msg)
    i = 1
    local groups = 'groups'
    if not data[tostring(groups)] then
        return langs[msg.lang].noGroups
    end
    local message = langs[msg.lang].groupsJoin
    for k, v in pairsByKeys(data[tostring(groups)]) do
        local group_id = v
        if data[tostring(group_id)] then
            settings = data[tostring(group_id)]['settings']
        end
        for m, n in pairsByKeys(settings) do
            if m == 'set_name' then
                name = n:gsub("", "")
                chat_name = name:gsub("?", "")
                group_name_id = name .. '\n(ID: ' .. group_id .. ')\n'
                if name:match("[\216-\219][\128-\191]") then
                    group_info = i .. '. \n' .. group_name_id
                else
                    group_info = i .. '. ' .. group_name_id
                end
                i = i + 1
            end
        end
        message = message .. group_info
    end

    i = 1
    local realms = 'realms'
    if not data[tostring(realms)] then
        return langs[msg.lang].noRealms
    end
    message = message .. '\n\n' .. langs[msg.lang].realmsJoin
    for k, v in pairsByKeys(data[tostring(realms)]) do
        local realm_id = v
        if data[tostring(realm_id)] then
            settings = data[tostring(realm_id)]['settings']
        end
        for m, n in pairsByKeys(settings) do
            if m == 'set_name' then
                name = n:gsub("", "")
                chat_name = name:gsub("?", "")
                realm_name_id = name .. '\n(ID: ' .. realm_id .. ')\n'
                if name:match("[\216-\219][\128-\191]") then
                    realm_info = i .. '. \n' .. realm_name_id
                else
                    realm_info = i .. '. ' .. realm_name_id
                end
                i = i + 1
            end
        end
        message = message .. realm_info
    end
    local file = io.open("./groups/lists/all_listed_groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

local function set_alias(msg, alias, groupid)
    local hash = 'groupalias'
    redis:hset(hash, alias, groupid)
    return langs[msg.lang].aliasSaved
end

local function unset_alias(msg, alias)
    local hash = 'groupalias'
    redis:hdel(hash, alias)
    return langs[msg.lang].aliasDeleted
end

-- INREALM
local function create_group(group_creator, group_name, lang)
    create_group_chat(group_creator, group_name, ok_cb, false)
    if group_type == 'group' then
        return langs[msg.lang].realm .. string.gsub(group_name, '_', ' ') .. langs[msg.lang].created
        -- elseif group_type == 'supergroup' then
        -- return langs[lang].supergroup .. string.gsub(group_name, '_', ' ') .. langs[lang].created
    elseif group_type == 'realm' then
        return langs[lang].group .. string.gsub(group_name, '_', ' ') .. langs[lang].created
    end
end

local function killchat(extra, success, result)
    for k, v in pairs(result.members) do
        if v.peer_id ~= our_id then
            local function post_kick()
                kick_user_any(v.peer_id, result.peer_id)
            end
            postpone(post_kick, false, 1)
            sleep(1)
        end
    end
    chat_del_user('chat#id' .. result.peer_id, 'user#id' .. our_id, ok_cb, true)
end

local function killchannel(extra, success, result)
    --[[for k, v in pairsByKeys(result) do
        if v.peer_id ~= our_id then
            local function post_kick()
                kick_user_any(v.peer_id, extra.chat_id)
            end
            postpone(post_kick, false, 1)
            sleep(1)
        end
    end]]
    leave_channel('channel#id' .. extra.chat_id, ok_cb, false)
end

local function admin_promote(user, user_id, lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    if data.admins[tostring(user_id)] then
        if string.match(user, '^%d+$') then
            return user_id .. langs[lang].alreadyAdmin
        else
            return '@' .. user .. langs[lang].alreadyAdmin
        end
    end
    data.admins[tostring(user_id)] = user
    save_data(_config.moderation.data, data)
    if string.match(user, '^%d+$') then
        return user_id .. langs[lang].promoteAdmin
    else
        return '@' .. user .. langs[lang].promoteAdmin
    end
end

local function admin_demote(user, user_id, lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    if not data.admins[tostring(user_id)] then
        if string.match(user, '^%d+$') then
            return user_id .. langs[lang].notAdmin
        else
            return '@' .. user .. langs[lang].notAdmin
        end
    end
    data.admins[tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
    if string.match(user, '^%d+$') then
        return user_id .. langs[lang].demoteAdmin
    else
        return '@' .. user .. langs[lang].demoteAdmin
    end
end

local function promote_admin_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    send_large_msg(extra.receiver, admin_promote(result.username, result.peer_id, lang))
end

local function demote_admin_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    send_large_msg(extra.receiver, admin_demote(result.username, result.peer_id, lang))
end

local function admin_list(lang)
    if not data.admins then
        data.admins = { }
        save_data(_config.moderation.data, data)
    end
    local message = langs[lang].adminListStart
    for k, v in pairs(data.admins) do
        message = message .. '@' .. v .. ' - ' .. k .. '\n'
    end
    return message
end

local function groups_list(msg)
    if not data.groups then
        return langs[msg.lang].noGroups
    end
    local message = langs[msg.lang].groupListStart
    for k, v in pairs(data.groups) do
        if data[tostring(v)] then
            if data[tostring(v)]['settings'] then
                local settings = data[tostring(v)]['settings']
                for m, n in pairs(settings) do
                    if m == 'set_name' then
                        name = n
                    end
                end
                local group_owner = "No owner"
                if data[tostring(v)]['set_owner'] then
                    group_owner = tostring(data[tostring(v)]['set_owner'])
                end
                local group_link = "No link"
                if data[tostring(v)]['settings']['set_link'] then
                    group_link = data[tostring(v)]['settings']['set_link']
                end
                message = message .. name .. ' ' .. v .. ' - ' .. group_owner .. '\n{' .. group_link .. "}\n"
            end
        end
    end
    local file = io.open("./groups/lists/groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

-- locks/unlocks from realm
-- lock/unlock group name. bot automatically change group name when locked
local function realm_lock_group_name(data, target, lang)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'yes' then
        return langs[lang].nameAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'yes'
        save_data(_config.moderation.data, data)
        rename_chat('chat#id' .. target, group_name_set, ok_cb, false)
        return langs[lang].nameLocked
    end
end

local function realm_unlock_group_name(data, target, lang)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'no' then
        return langs[lang].nameAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].nameUnlocked
    end
end
-- lock/unlock group member. bot automatically kick new added user when locked
local function realm_lock_group_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'yes' then
        return langs[lang].membersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].membersLocked
    end
end

local function realm_unlock_group_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'no' then
        return langs[lang].membersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].membersUnlocked
    end
end

-- lock/unlock group photo. bot automatically keep group photo when locked
local function realm_lock_group_photo(data, target, lang)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'yes' then
        return langs[lang].photoAlreadyLocked
    else
        data[tostring(target)]['settings']['set_photo'] = 'waiting'
        save_data(_config.moderation.data, data)
        return langs[lang].sendNewGroupPic
    end
end

local function realm_unlock_group_photo(data, target, lang)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'no' then
        return langs[lang].photoAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_photo'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].photoUnlocked
    end
end

local function realm_lock_group_flood(data, target, lang)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'yes' then
        return langs[lang].floodAlreadyLocked
    else
        data[tostring(target)]['settings']['flood'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].floodLocked
    end
end

local function realm_unlock_group_flood(data, target, lang)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'no' then
        return langs[lang].floodAlreadyUnlocked
    else
        data[tostring(target)]['settings']['flood'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].floodUnlocked
    end
end

local function realm_lock_group_arabic(data, target, lang)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'yes' then
        return langs[lang].arabicAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].arabicLocked
    end
end

local function realm_unlock_group_arabic(data, target, lang)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'no' then
        return langs[lang].arabicAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].arabicUnlocked
    end
end

local function realm_lock_group_rtl(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'yes' then
        return langs[lang].rtlAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].rtlLocked
    end
end

local function realm_unlock_group_rtl(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'no' then
        return langs[lang].rtlAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].rtlUnlocked
    end
end

local function realm_lock_group_links(data, target, lang)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'yes' then
        return langs[lang].linksAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].linksLocked
    end
end

local function realm_unlock_group_links(data, target, lang)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'no' then
        return langs[lang].linksAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].linksUnlocked
    end
end

local function realm_lock_group_spam(data, target, lang)
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'yes' then
        return langs[lang].spamAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].spamLocked
    end
end

local function realm_unlock_group_spam(data, target, lang)
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'no' then
        return langs[lang].spamAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].spamUnlocked
    end
end

local function realm_lock_group_sticker(data, target, lang)
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'yes' then
        return langs[lang].stickersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].stickersLocked
    end
end

local function realm_unlock_group_sticker(data, target, lang)
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'no' then
        return langs[lang].stickersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].stickersUnlocked
    end
end

-- show group settings
local function realm_group_settings(target, lang)
    local settings = data[tostring(target)]['settings']
    local text = langs[lang].groupSettings .. target .. ":" ..
    langs[lang].nameLock .. settings.lock_name ..
    langs[lang].photoLock .. settings.lock_photo ..
    langs[lang].membersLock .. settings.lock_member
    return text
end

-- show SuperGroup settings
local function realm_supergroup_settings(target, lang)
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
    local text = langs[lang].supergroupSettings .. target .. ":" ..
    langs[lang].linksLock .. settings.lock_link ..
    langs[lang].floodLock .. settings.flood ..
    langs[lang].spamLock .. settings.lock_spam ..
    langs[lang].arabic_lock .. settings.lock_arabic ..
    langs[lang].membersLock .. settings.lock_member ..
    langs[lang].rtlLock .. settings.lock_rtl ..
    langs[lang].stickersLock .. settings.lock_sticker ..
    langs[lang].strictrules .. settings.strict
    return text
end

local function realms_list(msg)
    if not data.realms then
        return langs[msg.lang].noRealms
    end
    local message = langs[msg.lang].realmListStart
    for k, v in pairs(data.realms) do
        local settings = data[tostring(v)]['settings']
        for m, n in pairs(settings) do
            if m == 'set_name' then
                name = n
            end
        end
        local group_owner = "No owner"
        if data[tostring(v)]['admins_in'] then
            group_owner = tostring(data[tostring(v)]['admins_in'])
        end
        local group_link = "No link"
        if data[tostring(v)]['settings']['set_link'] then
            group_link = data[tostring(v)]['settings']['set_link']
        end
        message = message .. name .. ' ' .. v .. ' - ' .. group_owner .. '\n{' .. group_link .. "}\n"
    end
    local file = io.open("./groups/lists/realms.txt", "w")
    file:write(message)
    file:flush()
    file:close()
    return message
end

-- INGROUP
local function set_group_photo(msg, success, result)
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

local function check_member_autorealm(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].welcomeNewRealm)
        end
    end
end

local function check_member_realm_add(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].realmAdded)
        end
    end
end

function check_member_group(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].promotedOwner)
        end
    end
end

local function check_member_modadd(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].groupAddedOwner)
        end
    end
end

local function check_member_realmrem(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].realmRemoved)
        end
    end
end

local function check_member_modrem(extra, success, result)
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
            return send_large_msg(extra.receiver, langs[msg.lang].groupRemoved)
        end
    end
end

local function modadd(msg)
    if is_group(msg) then
        return langs[msg.lang].groupAlreadyAdded
    end
    chat_info(get_receiver(msg), check_member_modadd, { receiver = get_receiver(msg), msg = msg })
end

local function realmadd(msg)
    if is_realm(msg) then
        return langs[msg.lang].realmAlreadyAdded
    end
    chat_info(get_receiver(msg), check_member_realm_add, { receiver = get_receiver(msg), msg = msg })
end

local function modrem(msg)
    if not is_group(msg) then
        return langs[msg.lang].groupNotAdded
    end
    chat_info(get_receiver(msg), check_member_modrem, { receiver = get_receiver(msg), msg = msg })
end

local function realmrem(msg)
    if not is_realm(msg) then
        return langs[msg.lang].realmNotAdded
    end
    chat_info(get_receiver(msg), check_member_realmrem, { receiver = get_receiver(msg), msg = msg })
end

local function automodadd(msg)
    if msg.action.type == 'chat_created' then
        chat_info(get_receiver(msg), check_member_group, { receiver = get_receiver(msg), msg = msg })
    end
end

local function autorealmadd(msg)
    if msg.action.type == 'chat_created' then
        chat_info(get_receiver(msg), check_member_autorealm, { receiver = get_receiver(msg), msg = msg })
    end
end

local function promote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
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

local function demote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
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

local function promote2(receiver, member_username, user_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local group = string.gsub(receiver, 'channel#id', '')
    local member_tag_username = member_username
    if not data[group] then
        return send_large_msg(receiver, langs[lang].supergroupNotAdded)
    end
    if data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. langs[lang].alreadyMod)
    end
    data[group]['moderators'][tostring(user_id)] = member_tag_username
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, member_username .. langs[lang].promoteMod)
end

local function demote2(receiver, member_username, user_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local group = string.gsub(receiver, 'channel#id', '')
    if not data[group] then
        return send_large_msg(receiver, langs[lang].supergroupNotAdded)
    end
    if not data[group]['moderators'][tostring(user_id)] then
        return send_large_msg(receiver, member_username .. langs[lang].notMod)
    end
    data[group]['moderators'][tostring(user_id)] = nil
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, member_username .. langs[lang].demoteMod)
end

local function chat_promote_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    return promote(extra.receiver, '@' .. result.username, result.peer_id)
end

local function chat_demote_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    return demote(extra.receiver, '@' .. result.username, result.peer_id)
end

local function promote_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
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
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function demote_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
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
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function modlist(msg)
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

local function muteuser_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local user_id = -1
        if result.service then
            if result.action.type == 'chat_add_user' or result.action.type == 'chat_del_user' or result.action.type == 'chat_rename' or result.action.type == 'chat_change_photo' then
                if result.action.user then
                    user_id = result.action.user.peer_id
                end
            end
        else
            user_id = result.from.peer_id
        end
        if user_id ~= -1 then
            if compare_ranks(extra.executer, result.from.peer_id, string.match(extra.receiver, '%d+')) then
                if is_muted_user(string.match(extra.receiver, '%d+'), user_id) then
                    mute_user(string.match(extra.receiver, '%d+'), user_id)
                    send_large_msg(extra.receiver, user_id .. langs[lang].muteUserRemove)
                else
                    unmute_user(string.match(extra.receiver, '%d+'), user_id)
                    send_large_msg(extra.receiver, user_id .. langs[lang].muteUserAdd)
                end
            else
                send_large_msg(extra.receiver, langs[lang].require_rank)
            end
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function muteuser_from(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        if compare_ranks(extra.executer, result.fwd_from.peer_id, result.to.peer_id) then
            if is_muted_user(result.to.peer_id, result.fwd_from.peer_id) then
                unmute_user(result.to.peer_id, result.fwd_from.peer_id)
                send_large_msg(extra.receiver, result.fwd_from.peer_id .. langs[lang].muteUserRemove)
            else
                mute_user(result.to.peer_id, result.fwd_from.peer_id)
                send_large_msg(extra.receiver, result.fwd_from.peer_id .. langs[lang].muteUserAdd)
            end
        else
            send_large_msg(extra.receiver, langs[lang].require_rank)
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function muteuser_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    -- ignore higher or same rank
    if compare_ranks(extra.executer, result.peer_id, string.match(extra.receiver, '%d+')) then
        if is_muted_user(string.match(extra.receiver, '%d+'), result.peer_id) then
            unmute_user(string.match(extra.receiver, '%d+'), result.peer_id)
            send_large_msg(extra.receiver, result.peer_id .. langs[lang].muteUserRemove)
        else
            mute_user(string.match(extra.receiver, '%d+'), result.peer_id)
            send_large_msg(extra.receiver, result.peer_id .. langs[lang].muteUserAdd)
        end
    else
        send_large_msg(extra.receiver, langs[lang].require_rank)
    end
end

local function show_group_settingsmod(target, lang)
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
    local text = langs[lang].groupSettings ..
    langs[lang].nameLock .. settings.lock_name ..
    langs[lang].photoLock .. settings.lock_photo ..
    langs[lang].membersLock .. settings.lock_member ..
    langs[lang].leaveLock .. leave_ban ..
    langs[lang].floodSensibility .. NUM_MSG_MAX ..
    langs[lang].botsLock .. bots_protection ..
    langs[lang].linksLock .. settings.lock_link ..
    langs[lang].rtlLock .. settings.lock_rtl ..
    langs[lang].stickersLock .. settings.lock_sticker ..
    langs[lang].public .. settings.public
    return text
end

local function setowner_by_reply(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == extra.receiver then
        local msg = result
        local lang = get_lang(msg.to.id)
        local name_log = msg.from.print_name:gsub("_", " ")
        data[tostring(msg.to.id)]['set_owner'] = tostring(msg.from.id)
        save_data(_config.moderation.data, data)
        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. msg.from.id .. "] as owner")
        send_large_msg(get_receiver(msg), msg.from.print_name:gsub("_", " ") .. langs[lang].setOwner)
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end

local function chat_setowner_by_username(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    data[tostring(string.match(extra.receiver, '%d+'))]['set_owner'] = tostring(result.peer_id)
    save_data(_config.moderation.data, data)
    send_large_msg(extra.receiver, result.peer_id .. langs[lang].setOwner)
end

local function cleanmember(extra, success, result)
    for k, v in pairs(result.members) do
        kick_user(v.id, result.peer_id)
    end
end

-- SUPERGROUP
-- Check members #Add supergroup
local function check_member_super(extra, success, result)
    local receiver = extra.receiver
    local msg = extra.msg
    if success == 0 then
        send_large_msg(receiver, langs[msg.lang].promoteBotAdmin)
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
            local text = langs[msg.lang].supergroupAdded
            return reply_msg(msg.id, text, ok_cb, false)
        end
    end
end

-- Check Members #rem supergroup
local function check_member_superrem(extra, success, result)
    local receiver = extra.receiver
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
            local text = langs[msg.lang].supergroupRemoved
            return reply_msg(msg.id, text, ok_cb, false)
        end
    end
end

-- Function to Add supergroup
local function superadd(msg)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super, { receiver = receiver, msg = msg })
end

-- Function to remove supergroup
local function superrem(msg)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem, { receiver = receiver, msg = msg })
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
            vname = v.first_name:gsub("?", "")
            name = vname:gsub("_", " ")
        end
        text = text .. "\n" .. i .. ". " .. name .. " " .. v.peer_id
        i = i + 1
    end
    send_large_msg(extra.receiver, text)
end

-- Start by reply actions
function get_message_callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if get_reply_receiver(result) == get_receiver(extra.msg) then
        local get_cmd = extra.get_cmd
        local msg = extra.msg
        local print_name = user_print_name(msg.from):gsub("?", "")
        local name_log = print_name:gsub("_", " ")
        if get_cmd == "promoteadmin" then
            local user_id = result.from.peer_id
            local channel_id = "channel#id" .. result.to.peer_id
            channel_set_admin(channel_id, "user#id" .. user_id, ok_cb, false)
            if result.from.username then
                text = "@" .. result.from.username .. langs[msg.lang].promoteSupergroupMod
            else
                text = user_id .. langs[msg.lang].promoteSupergroupMod
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted: [" .. user_id .. "] as admin by reply")
            send_large_msg(channel_id, text)
        elseif get_cmd == "demoteadmin" then
            local user_id = result.from.peer_id
            local channel_id = "channel#id" .. result.to.peer_id
            if is_admin2(result.from.peer_id) then
                return send_large_msg(channel_id, langs[msg.lang].cantDemoteOtherAdmin)
            end
            channel_demote(channel_id, "user#id" .. user_id, ok_cb, false)
            if result.from.username then
                text = "@" .. result.from.username .. langs[msg.lang].demoteSupergroupMod
            else
                text = user_id .. langs[msg.lang].demoteSupergroupMod
            end
            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted: [" .. user_id .. "] as admin by reply")
            send_large_msg(channel_id, text)
        elseif get_cmd == "setowner" then
            local group_owner = data[tostring(result.to.peer_id)]['set_owner']
            if group_owner then
                local channel_id = 'channel#id' .. result.to.peer_id
                if not is_admin2(tonumber(group_owner)) then
                    local user = "user#id" .. group_owner
                    channel_demote(channel_id, user, ok_cb, false)
                end
                local user_id = "user#id" .. result.from.peer_id
                channel_set_admin(channel_id, user_id, ok_cb, false)
                data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
                save_data(_config.moderation.data, data)
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set: [" .. result.from.peer_id .. "] as owner by reply")
                if result.from.username then
                    text = "@" .. result.from.username .. " " .. result.from.peer_id .. langs[msg.lang].setOwner
                else
                    text = result.from.peer_id .. langs[msg.lang].setOwner
                end
                send_large_msg(channel_id, text)
            end
        elseif get_cmd == "promote" then
            local receiver = result.to.peer_id
            local full_name =(result.from.first_name or '') .. ' ' ..(result.from.last_name or '')
            local member_name = full_name:gsub("?", "")
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
            local member_name = full_name:gsub("?", "")
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
                if result.action.type == 'chat_add_user' or result.action.type == 'chat_del_user' or result.action.type == 'chat_rename' or result.action.type == 'chat_change_photo' then
                    if result.action.user then
                        user_id = result.action.user.peer_id
                    end
                end
                if result.action.type == 'chat_add_user_link' then
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

            -- ignore higher or same rank
            if compare_ranks(msg.from.id, user_id, chat_id) then
                if is_muted_user(chat_id, user_id) then
                    unmute_user(chat_id, user_id)
                    send_large_msg(receiver, user_id .. langs[msg.lang].muteUserRemove)
                else
                    mute_user(chat_id, user_id)
                    send_large_msg(receiver, user_id .. langs[msg.lang].muteUserAdd)
                end
            else
                send_large_msg(receiver, langs[msg.lang].require_rank)
            end
        end
    else
        send_large_msg(extra.receiver, langs[lang].oldMessage)
    end
end
-- End by reply actions

-- Begin non-channel_invite username actions
local function in_channel_cb(extra, success, result)
    local get_cmd = extra.get_cmd
    local receiver = extra.receiver
    local msg = extra.msg
    local print_name = user_print_name(extra.msg.from):gsub("?", "")
    local name_log = print_name:gsub("_", " ")
    local member = extra.username
    local memberid = extra.user_id
    if member then
        text = langs[msg.lang].none .. '@' .. member .. langs[msg.lang].inThisSupergroup
    else
        text = langs[msg.lang].none .. memberid .. langs[msg.lang].inThisSupergroup
    end
    if get_cmd == "promoteadmin" then
        for k, v in pairs(result) do
            vusername = v.username
            vpeer_id = tostring(v.peer_id)
            if vusername == member or vpeer_id == memberid then
                local user_id = "user#id" .. v.peer_id
                local channel_id = "channel#id" .. extra.msg.to.id
                channel_set_admin(channel_id, user_id, ok_cb, false)
                if v.username then
                    text = "@" .. v.username .. " " .. v.peer_id .. langs[msg.lang].promoteSupergroupMod
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set admin @" .. v.username .. " [" .. v.peer_id .. "]")
                else
                    text = v.peer_id .. langs[msg.lang].promoteSupergroupMod
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set admin " .. v.peer_id)
                end
            end
            send_large_msg(channel_id, text)
        end
    end
    send_large_msg(receiver, text)
end
-- End non-channel_invite username actions

-- Begin resolve username actions
local function callbackres(extra, success, result)
    local lang
    if extra.receiver then
        lang = get_lang(string.match(extra.receiver, '%d+'))
    end
    if extra.channel then
        lang = get_lang(string.match(extra.channel, '%d+'))
    end
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
			if not is_admin2(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.." "..result.peer_id..langs[lang].setOwner
		else
			text = result.peer_id..langs[lang].setOwner
		end
		send_large_msg(receiver, text)
  end]]
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
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
            return send_large_msg(channel_id, langs[lang].cantDemoteOtherAdmin)
        end
        channel_demote(channel_id, user_id, ok_cb, false)
        if result.username then
            text = "@" .. result.username .. langs[lang].demoteSupergroupMod
        else
            text = result.peer_id .. langs[lang].demoteSupergroupMod
        end
        send_large_msg(channel_id, text)
    elseif get_cmd == 'mute_user' then
        local user_id = result.peer_id
        local receiver = extra.receiver
        local chat_id = string.gsub(receiver, 'channel#id', '')

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
end

local function setowner_by_username(extra, success, result)
    local lang = get_lang(extra.chat_id)
    if success == 0 then
        return send_large_msg(extra.receiver, langs[lang].noUsernameFound)
    end
    data[tostring(extra.chat_id)]['set_owner'] = tostring(result.peer_id)
    save_data(_config.moderation.data, data)
    savelog(extra.chat_id, result.print_name .. " [" .. result.peer_id .. "] set as owner")
    send_large_msg(extra.receiver, result.peer_id .. langs[lang].setOwner)
end
-- End resolve username actions

-- 'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
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
        send_large_msg(receiver, langs[msg.lang].photoSaved, ok_cb, false)
    else
        print('Error downloading: ' .. msg.id)
        send_large_msg(receiver, langs[msg.lang].errorTryAgain, ok_cb, false)
    end
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

-- Show supergroup settings; function
local function show_supergroup_settings(target, lang)
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
    local text = langs[lang].supergroupSettings ..
    langs[lang].linksLock .. settings.lock_link ..
    langs[lang].floodLock .. settings.flood ..
    langs[lang].floodSensibility .. NUM_MSG_MAX ..
    langs[lang].spamLock .. settings.lock_spam ..
    langs[lang].arabicLock .. settings.lock_arabic ..
    langs[lang].membersLock .. settings.lock_member ..
    langs[lang].rtlLock .. settings.lock_rtl ..
    langs[lang].tgserviceLock .. settings.lock_tgservice ..
    langs[lang].stickersLock .. settings.lock_sticker ..
    langs[lang].public .. settings.public ..
    langs[lang].strictrules .. settings.strict
    return text
end

-- LOCKS UNLOCKS FUNCTIONS
local function lock_group_arabic(data, target, lang)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'yes' then
        return langs[lang].arabicAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].arabicLocked
    end
end

local function unlock_group_arabic(data, target, lang)
    local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
    if group_arabic_lock == 'no' then
        return langs[lang].arabicAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_arabic'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].arabicUnlocked
    end
end

local function lock_group_bots(data, target, lang)
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'yes' then
        return langs[lang].botsAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_bots'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].botsLocked
    end
end

local function unlock_group_bots(data, target, lang)
    local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
    if group_bots_lock == 'no' then
        return langs[lang].botsAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_bots'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].botsUnlocked
    end
end

local function lock_group_name(data, target, lang)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'yes' then
        return langs[lang].nameAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'yes'
        save_data(_config.moderation.data, data)
        rename_chat('chat#id' .. target, group_name_set, ok_cb, false)
        return langs[lang].nameLocked
    end
end

local function unlock_group_name(data, target, lang)
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
    if group_name_lock == 'no' then
        return langs[lang].nameAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_name'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].nameUnlocked
    end
end

local function lock_group_flood(data, target, lang)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'yes' then
        return langs[lang].floodAlreadyLocked
    else
        data[tostring(target)]['settings']['flood'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].floodLocked
    end
end

local function unlock_group_flood(data, target, lang)
    local group_flood_lock = data[tostring(target)]['settings']['flood']
    if group_flood_lock == 'no' then
        return langs[lang].floodAlreadyUnlocked
    else
        data[tostring(target)]['settings']['flood'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].floodUnlocked
    end
end

local function lock_group_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'yes' then
        return langs[lang].membersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].membersLocked
    end
end

local function unlock_group_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
    if group_member_lock == 'no' then
        return langs[lang].membersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_member'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].membersUnlocked
    end
end

local function set_public_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['public']
    if group_member_lock == 'yes' then
        return langs[lang].publicAlreadyYes
    else
        data[tostring(target)]['settings']['public'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].publicYes
    end
end

local function unset_public_member(data, target, lang)
    local group_member_lock = data[tostring(target)]['settings']['public']
    if group_member_lock == 'no' then
        return langs[lang].publicAlreadyNo
    else
        data[tostring(target)]['settings']['public'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].publicNo
    end
end

local function lock_group_leave(data, target, lang)
    local leave_ban = data[tostring(target)]['settings']['leave_ban']
    if leave_ban == 'yes' then
        return langs[lang].leaveAlreadyLocked
    else
        data[tostring(target)]['settings']['leave_ban'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].leaveLocked
    end
end

local function unlock_group_leave(data, target, lang)
    local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
    if leave_ban == 'no' then
        return langs[lang].leaveAlreadyUnlocked
    else
        data[tostring(target)]['settings']['leave_ban'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].leaveUnlocked
    end
end

local function lock_group_photo(data, target, lang)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'yes' then
        return langs[lang].photoAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_photo'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].photoLocked
    end
end

local function unlock_group_photo(data, target, lang)
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'no' then
        return langs[lang].photoAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_photo'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].photoUnlocked
    end
end

local function lock_group_links(data, target, lang)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'yes' then
        return langs[lang].linksAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].linksLocked
    end
end

local function unlock_group_links(data, target, lang)
    local group_link_lock = data[tostring(target)]['settings']['lock_link']
    if group_link_lock == 'no' then
        return langs[lang].linksAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_link'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].linksUnlocked
    end
end

local function lock_group_spam(data, target, lang)
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'yes' then
        return langs[lang].spamAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].spamLocked
    end
end

local function unlock_group_spam(data, target, lang)
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'no' then
        return langs[lang].spamAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].spamUnlocked
    end
end

local function lock_group_rtl(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'yes' then
        return langs[lang].rtlAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].rtlLocked
    end
end

local function unlock_group_rtl(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
    if group_rtl_lock == 'no' then
        return langs[lang].rtlAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_rtl'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].rtlUnlocked
    end
end

local function lock_group_tgservice(data, target, lang)
    local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
    if group_tgservice_lock == 'yes' then
        return langs[lang].tgserviceAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].tgserviceLocked
    end
end

local function unlock_group_tgservice(data, target, lang)
    local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
    if group_tgservice_lock == 'no' then
        return langs[lang].tgserviceAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_tgservice'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].tgserviceUnlocked
    end
end

local function lock_group_sticker(data, target, lang)
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'yes' then
        return langs[lang].stickersAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].stickersLocked
    end
end

local function unlock_group_sticker(data, target, lang)
    local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
    if group_sticker_lock == 'no' then
        return langs[lang].stickersAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_sticker'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].stickersUnlocked
    end
end

local function lock_group_contacts(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'yes' then
        return langs[lang].contactsAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].contactsLocked
    end
end

local function unlock_group_contacts(data, target, lang)
    local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
    if group_contacts_lock == 'no' then
        return langs[lang].contactsAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_contacts'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].contactsUnlocked
    end
end

local function enable_strict_rules(data, target, lang)
    local group_rtl_lock = data[tostring(target)]['settings']['strict']
    if strict == 'yes' then
        return langs[lang].strictrulesAlreadyLocked
    else
        data[tostring(target)]['settings']['strict'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[lang].strictrulesLocked
    end
end

local function disable_strict_rules(data, target, lang)
    local group_contacts_lock = data[tostring(target)]['settings']['strict']
    if strict == 'no' then
        return langs[lang].strictrulesAlreadyUnlocked
    else
        data[tostring(target)]['settings']['strict'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[lang].strictrulesUnlocked
    end
end

local function contact_mods_callback(extra, success, result)
    local already_contacted = { }
    local msg = extra.msg

    local text = langs[msg.lang].receiver .. msg.to.print_name:gsub("_", " ") .. ' [' .. msg.to.id .. ']\n' .. langs[msg.lang].sender
    if msg.from.username then
        text = text .. '@' .. msg.from.username .. ' [' .. msg.from.id .. ']\n'
    else
        text = text .. msg.from.print_name:gsub("_", " ") .. ' [' .. msg.from.id .. ']\n'
    end
    text = text .. langs[msg.lang].msgText .. msg.text

    -- telegram admins
    for k, v in pairsByKeys(result) do
        local rnd = math.random(1000)
        if tonumber(v.peer_id) ~= tonumber(our_id) then
            if v.print_name then
                if not already_contacted[tonumber(v.peer_id)] then
                    already_contacted[tonumber(v.peer_id)] = v.peer_id
                    local tmpmsgs = tonumber(redis:get('msgs:' .. v.peer_id .. ':' .. our_id) or 0)
                    if tmpmsgs ~= 0 then
                        if msg.reply_id then
                            local function post_fwd()
                                fwd_msg('user#id' .. v.peer_id, msg.reply_id, ok_cb, false)
                            end
                            postpone(post_fwd, false, math.fmod(rnd, 10) + 1)
                        end
                        local function post_msg()
                            send_large_msg('user#id' .. v.peer_id, text)
                        end
                        postpone(post_msg, false, math.fmod(rnd, 10) + 1)
                    else
                        local function post_msg()
                            send_large_msg(get_receiver(msg), langs[msg.lang].cantContact .. v.peer_id)
                        end
                        postpone(post_msg, false, math.fmod(rnd, 10) + 1)
                    end
                end
            end
        end
    end

    -- owner
    local owner = data[tostring(msg.to.id)]['set_owner']
    if owner then
        local rnd = math.random(1000)
        if not already_contacted[tonumber(owner)] then
            already_contacted[tonumber(owner)] = owner
            local tmpmsgs = tonumber(redis:get('msgs:' .. owner .. ':' .. our_id) or 0)
            if tmpmsgs ~= 0 then
                if msg.reply_id then
                    local function post_fwd()
                        fwd_msg('user#id' .. owner, msg.reply_id, ok_cb, false)
                    end
                    postpone(post_fwd, false, math.fmod(rnd, 10) + 1)
                end
                local function post_msg()
                    send_large_msg('user#id' .. owner, text)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            else
                local function post_msg()
                    send_large_msg(get_receiver(msg), langs[msg.lang].cantContact .. owner)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            end
        end
    end

    local groups = "groups"
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['moderators']) == nil then
        -- fix way
        return langs[msg.lang].noGroupMods
    end
    for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
        local rnd = math.random(1000)
        if not already_contacted[tonumber(k)] then
            already_contacted[tonumber(k)] = k
            local tmpmsgs = tonumber(redis:get('msgs:' .. k .. ':' .. our_id) or 0)
            if tmpmsgs ~= 0 then
                if msg.reply_id then
                    local function post_fwd()
                        fwd_msg('user#id' .. k, msg.reply_id, ok_cb, false)
                    end
                    postpone(post_fwd, false, math.fmod(rnd, 10) + 1)
                end
                local function post_msg()
                    send_large_msg('user#id' .. k, text)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            else
                local function post_msg()
                    send_large_msg(get_receiver(msg), langs[msg.lang].cantContact .. v)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            end
        end
    end
end

local function contact_mods(msg)
    local already_contacted = { }

    local text = langs[msg.lang].receiver .. msg.to.print_name:gsub("_", " ") .. ' [' .. msg.to.id .. ']\n' .. langs[msg.lang].sender
    if msg.from.username then
        text = text .. '@' .. msg.from.username .. ' [' .. msg.from.id .. ']\n'
    else
        text = text .. msg.from.print_name:gsub("_", " ") .. ' [' .. msg.from.id .. ']\n'
    end
    text = text .. langs[msg.lang].msgText .. msg.text

    -- owner
    local owner = data[tostring(msg.to.id)]['set_owner']
    if owner then
        local rnd = math.random(1000)
        if not already_contacted[tonumber(owner)] then
            already_contacted[tonumber(owner)] = owner
            local tmpmsgs = tonumber(redis:get('msgs:' .. owner .. ':' .. our_id) or 0)
            if tmpmsgs ~= 0 then
                if msg.reply_id then
                    local function post_fwd()
                        fwd_msg('user#id' .. owner, msg.reply_id, ok_cb, false)
                    end
                    postpone(post_fwd, false, math.fmod(rnd, 10) + 1)
                end
                local function post_msg()
                    send_large_msg('user#id' .. owner, text)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            else
                local function post_msg()
                    send_large_msg(get_receiver(msg), langs[msg.lang].cantContact .. owner)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            end
        end
    end

    local groups = "groups"
    -- determine if table is empty
    if next(data[tostring(msg.to.id)]['moderators']) == nil then
        -- fix way
        return langs[msg.lang].noGroupMods
    end
    for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
        local rnd = math.random(1000)
        if not already_contacted[tonumber(k)] then
            already_contacted[tonumber(k)] = k
            local tmpmsgs = tonumber(redis:get('msgs:' .. k .. ':' .. our_id) or 0)
            if tmpmsgs ~= 0 then
                if msg.reply_id then
                    local function post_fwd()
                        fwd_msg('user#id' .. k, msg.reply_id, ok_cb, false)
                    end
                    postpone(post_fwd, false, math.fmod(rnd, 10) + 1)
                end
                local function post_msg()
                    send_large_msg('user#id' .. k, text)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            else
                local function post_msg()
                    send_large_msg(get_receiver(msg), langs[msg.lang].cantContact .. v)
                end
                postpone(post_msg, false, math.fmod(rnd, 10) + 1)
            end
        end
    end
end

local function run(msg, matches)
    local name_log = user_print_name(msg.from)
    if not msg.api_patch then
        if matches[1]:lower() == 'type' then
            if is_momod(msg) then
                if data[tostring(msg.to.id)] then
                    if not data[tostring(msg.to.id)]['group_type'] then
                        if msg.to.type == 'chat' and not is_realm(msg) then
                            data[tostring(msg.to.id)]['group_type'] = 'Group'
                            save_data(_config.moderation.data, data)
                        elseif msg.to.type == 'channel' then
                            data[tostring(msg.to.id)]['group_type'] = 'SuperGroup'
                            save_data(_config.moderation.data, data)
                        end
                    end
                    return data[tostring(msg.to.id)]['group_type']
                else
                    return langs[msg.lang].chatTypeNotFound
                end
            else
                return langs[msg.lang].require_mod
            end
        end
        if matches[1]:lower() == 'log' then
            if is_owner(msg) then
                savelog(msg.to.id, "log file created by owner/admin")
                return send_document(get_receiver(msg), "./groups/logs/" .. msg.to.id .. "log.txt", ok_cb, false)
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'admins' then
            if msg.to.type == 'channel' then
                return channel_get_admins(get_receiver(msg), contact_mods_callback, { msg = msg })
            elseif msg.to.type == 'chat' then
                return contact_mods(msg)
            end
        end
    end

    -- INPM
    -- TODO: add lock and unlock join
    if is_sudo(msg) or msg.to.type == 'user' then
        if matches[1]:lower() == 'join' or matches[1]:lower() == 'inviteme' or matches[1]:lower() == 'sasha invitami' or matches[1]:lower() == 'invitami' then
            if is_admin1(msg) then
                if string.match(matches[2], '^%d+$') then
                    if not data[tostring(matches[2])] then
                        return langs[msg.lang].chatNotFound
                    end
                    chat_add_user('chat#id' .. matches[2], 'user#id' .. msg.from.id, ok_cb, false)
                    return channel_invite('channel#id' .. matches[2], 'user#id' .. msg.from.id, ok_cb, false)
                else
                    local hash = 'groupalias'
                    local value = redis:hget(hash, matches[2]:lower())
                    if value then
                        chat_add_user('chat#id' .. value, 'user#id' .. msg.from.id, ok_cb, false)
                        return channel_invite('channel#id' .. value, 'user#id' .. msg.from.id, ok_cb, false)
                    else
                        return langs[msg.lang].noAliasFound
                    end
                end
            else
                return langs[msg.lang].require_admin
            end
        end

        if not msg.api_patch then
            if matches[1]:lower() == 'allchats' then
                if is_admin1(msg) then
                    return all_chats(msg)
                else
                    return langs[msg.lang].require_admin
                end
            end

            if matches[1]:lower() == 'allchatslist' then
                if is_admin1(msg) then
                    all_chats(msg)
                    send_document("chat#id" .. msg.to.id, "./groups/lists/all_listed_groups.txt", ok_cb, false)
                    send_document("channel#id" .. msg.to.id, "./groups/lists/all_listed_groups.txt", ok_cb, false)
                else
                    return langs[msg.lang].require_admin
                end
            end
        end

        if matches[1]:lower() == 'setalias' then
            if is_sudo(msg) then
                return set_alias(msg, matches[2]:gsub('_', ' '), matches[3])
            else
                return langs[msg.lang].require_sudo
            end
        end

        if matches[1]:lower() == 'unsetalias' then
            if is_sudo(msg) then
                return unset_alias(msg, matches[2])
            else
                return langs[msg.lang].require_sudo
            end
        end

        if matches[1]:lower() == 'getaliaslist' then
            if is_admin1(msg) then
                local hash = 'groupalias'
                local names = redis:hkeys(hash)
                local ids = redis:hvals(hash)
                local text = ''
                for i = 1, #names do
                    text = text .. names[i] .. ' - ' .. ids[i] .. '\n'
                end
                return text
            else
                return langs[msg.lang].require_admin
            end
        end
    end

    -- INREALM
    if is_realm(msg) then
        if (matches[1]:lower() == 'creategroup' or matches[1]:lower() == 'sasha crea gruppo') and matches[2] then
            if is_admin1(msg) then
                group_type = 'group'
                return create_group(msg.from.print_name, matches[2], msg.lang)
            else
                return langs[msg.lang].require_admin
            end
        end
        if (matches[1]:lower() == 'createsuper' or matches[1]:lower() == 'sasha crea supergruppo') and matches[2] then
            if is_admin1(msg) then
                group_type = 'supergroup'
                return create_group(msg.from.print_name, matches[2], msg.lang)
            else
                return langs[msg.lang].require_admin
            end
        end
        if (matches[1]:lower() == 'createrealm' or matches[1]:lower() == 'sasha crea regno') and matches[2] then
            if is_sudo(msg) then
                group_type = 'realm'
                return create_group(msg.from.print_name, matches[2], msg.lang)
            else
                return langs[msg.lang].require_sudo
            end
        end
        if matches[1]:lower() == 'kill' then
            if is_admin1(msg) then
                if matches[2]:lower() == 'group' and matches[3] then
                    print("Closing Group: " .. 'chat#id' .. matches[3])
                    chat_info('chat#id' .. matches[3], killchat, false)
                    return modrem(msg)
                end
                if matches[2]:lower() == 'supergroup' and matches[3] then
                    print("Closing Supergroup: " .. 'channel#id' .. matches[3])
                    channel_get_users('channel#id' .. matches[3], killchannel, { chat_id = matches[3] })
                    return modrem(msg)
                end
                if matches[2]:lower() == 'realm' and matches[3] then
                    print("Closing Realm: " .. 'chat#id' .. matches[3])
                    chat_info('chat#id' .. matches[3], killchat, false)
                    return realmrem(msg)
                end
            else
                return langs[msg.lang].require_admin
            end
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'rem' and matches[2] then
                if is_admin1(msg) then
                    -- Group configuration removal
                    data[tostring(matches[2])] = nil
                    save_data(_config.moderation.data, data)
                    local groups = 'groups'
                    if not data[tostring(groups)] then
                        data[tostring(groups)] = nil
                        save_data(_config.moderation.data, data)
                    end
                    data[tostring(groups)][tostring(matches[2])] = nil
                    save_data(_config.moderation.data, data)
                    return send_large_msg(get_receiver(msg), langs[msg.lang].chat .. matches[2] .. langs[msg.lang].removed)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'addadmin' then
                if is_sudo(msg) then
                    if string.match(matches[2], '^%d+$') then
                        print("user " .. matches[2] .. " has been promoted as admin")
                        return admin_promote(matches[2], matches[2], msg.lang)
                    else
                        return resolve_username(string.gsub(matches[2], '@', ''), promote_admin_by_username, { receiver = get_receiver(msg) })
                    end
                else
                    return langs[msg.lang].require_sudo
                end
            end
            if matches[1]:lower() == 'removeadmin' then
                if is_sudo(msg) then
                    if string.match(matches[2], '^%d+$') then
                        print("user " .. matches[2] .. " has been demoted")
                        return admin_demote(matches[2], matches[2], msg.lang)
                    else
                        return resolve_username(string.gsub(matches[2], '@', ''), promote_admin_by_username, { receiver = get_receiver(msg) })
                    end
                else
                    return langs[msg.lang].require_sudo
                end
            end
            if matches[1]:lower() == 'setgpowner' and matches[2] and matches[3] then
                if is_admin1(msg) then
                    data[tostring(matches[2])]['set_owner'] = matches[3]
                    save_data(_config.moderation.data, data)
                    local lang = get_lang(matches[2])
                    local text = matches[3] .. langs[msg.lang].setOwner
                    send_large_msg("chat#id" .. matches[2], text)
                    return send_large_msg("channel#id" .. matches[2], text)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'list' then
                if is_admin1(msg) then
                    if matches[2]:lower() == 'admins' then
                        return admin_list(msg.lang)
                    elseif matches[2]:lower() == 'groups' then
                        if msg.to.type == 'chat' or msg.to.type == 'channel' then
                            groups_list(msg)
                            send_document("chat#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
                            send_document("channel#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
                            -- return group_list(msg)
                        elseif msg.to.type == 'user' then
                            groups_list(msg)
                            send_document("user#id" .. msg.from.id, "./groups/lists/groups.txt", ok_cb, false)
                            -- return group_list(msg)
                        end
                        return langs[msg.lang].groupListCreated
                    elseif matches[2]:lower() == 'realms' then
                        if msg.to.type == 'chat' or msg.to.type == 'channel' then
                            realms_list(msg)
                            send_document("chat#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
                            send_document("channel#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
                            -- return realms_list(msg)
                        elseif msg.to.type == 'user' then
                            realms_list(msg)
                            send_document("user#id" .. msg.from.id, "./groups/lists/realms.txt", ok_cb, false)
                            -- return realms_list(msg)
                        end
                        return langs[msg.lang].realmListCreated
                    end
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1] == 'chat_add_user' then
                if msg.service and msg.action then
                    if msg.action.user then
                        if msg.action.user.id ~= 283058260 then
                            -- if not admin and not bot then
                            if not is_admin1(msg) and not msg.from.id == our_id then
                                return chat_del_user('chat#id' .. msg.to.id, 'user#id' .. msg.action.user.id, ok_cb, true)
                            end
                        end
                    end
                end
            end
            if (matches[1]:lower() == 'lock' or matches[1]:lower() == 'sasha blocca' or matches[1]:lower() == 'blocca') and matches[2] and matches[3] then
                if is_admin1(msg) then
                    if matches[3]:lower() == 'name' then
                        return realm_lock_group_name(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'member' then
                        return realm_lock_group_member(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'photo' then
                        return realm_lock_group_photo(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'flood' then
                        return realm_lock_group_flood(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'arabic' then
                        return realm_lock_group_arabic(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'links' then
                        return realm_lock_group_links(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'spam' then
                        return realm_lock_group_spam(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'rtl' then
                        return realm_lock_group_rtl(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'sticker' then
                        return realm_lock_group_sticker(data, matches[2], msg.lang)
                    end
                else
                    return langs[msg.lang].require_admin
                end
            end
            if (matches[1]:lower() == 'unlock' or matches[1]:lower() == 'sasha sblocca' or matches[1]:lower() == 'sblocca') and matches[2] and matches[3] then
                if is_admin1(msg) then
                    if matches[3]:lower() == 'name' then
                        return realm_unlock_group_name(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'member' then
                        return realm_unlock_group_member(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'photo' then
                        return realm_unlock_group_photo(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'flood' then
                        return realm_unlock_group_flood(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'arabic' then
                        return realm_unlock_group_arabic(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'links' then
                        return realm_unlock_group_links(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'spam' then
                        return realm_unlock_group_spam(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'rtl' then
                        return realm_unlock_group_rtl(data, matches[2], msg.lang)
                    end
                    if matches[3]:lower() == 'sticker' then
                        return realm_unlock_group_sticker(data, matches[2], msg.lang)
                    end
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'settings' and data[tostring(matches[2])]['settings'] then
                if is_admin1(msg) then
                    return realm_group_settings(matches[2], msg.lang)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'supersettings' and data[tostring(matches[2])]['settings'] then
                if is_admin1(msg) then
                    return realm_supergroup_settings(matches[2], msg.lang)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'setgprules' then
                if is_admin1(msg) then
                    data[tostring(matches[2])]['rules'] = matches[3]
                    save_data(_config.moderation.data, data)
                    return langs[msg.lang].newRules .. matches[3]
                else
                    return langs[msg.lang].require_admin
                end
            end
        end
        if matches[1]:lower() == 'setgroupabout' and matches[2] and matches[3] then
            if is_admin1(msg) then
                data[tostring(matches[2])]['description'] = matches[3]
                save_data(_config.moderation.data, data)
                return langs[msg.lang].newDescription .. matches[3]
            else
                return langs[msg.lang].require_admin
            end
        end
        if matches[1]:lower() == 'setsupergroupabout' and matches[2] and matches[3] then
            if is_admin1(msg) then
                channel_set_about('channel#id' .. matches[2], matches[3], ok_cb, false)
                data[tostring(target)]['description'] = matches[3]
                save_data(_config.moderation.data, data)
                return langs[msg.lang].descriptionSet .. matches[2]
            else
                return langs[msg.lang].require_admin
            end
        end
        if matches[1]:lower() == 'setgpname' then
            if is_admin1(msg) then
                data[tostring(matches[2])]['settings']['set_name'] = string.gsub(matches[3], '_', ' ')
                save_data(_config.moderation.data, data)
                rename_chat('chat#id' .. matches[2], data[tostring(matches[2])]['settings']['set_name'], ok_cb, false)
                rename_channel('channel#id' .. matches[2], data[tostring(matches[2])]['settings']['set_name'], ok_cb, false)
                return savelog(matches[3], "Group { " .. data[tostring(matches[2])]['settings']['set_name'] .. " }  name changed to [ " .. string.gsub(matches[3], '_', ' ') .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
            else
                return langs[msg.lang].require_admin
            end
        end
        if matches[1]:lower() == 'setname' then
            if is_admin1(msg) then
                data[tostring(msg.to.id)]['settings']['set_name'] = string.gsub(matches[2], '_', ' ')
                save_data(_config.moderation.data, data)
                rename_chat('chat#id' .. msg.to.id, data[tostring(msg.to.id)]['settings']['set_name'], ok_cb, false)
                return savelog(msg.to.id, "Realm { " .. msg.to.print_name .. " }  name changed to [ " .. string.gsub(matches[3], '_', ' ') .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
            else
                return langs[msg.lang].require_admin
            end
        end
    end

    -- INGROUP
    if msg.to.type == 'chat' then
        if matches[1]:lower() == 'tosuper' then
            if is_admin1(msg) then
                return chat_upgrade(get_receiver(msg), ok_cb, false)
            else
                return langs[msg.lang].require_admin
            end
        end
        if msg.media then
            if msg.media.type == 'photo' and data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_chat_msg(msg) and is_momod(msg) then
                return load_photo(msg.id, set_group_photo, msg)
            end
        end
        if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "group" then
            return automodadd(msg)
        end
        if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "realm" then
            return autorealmadd(msg)
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'add' and not matches[2] then
                if is_admin1(msg) then
                    if is_realm(msg) then
                        return langs[msg.lang].errorAlreadyRealm
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added group [ " .. msg.to.id .. " ]")
                    print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") added")
                    return modadd(msg)
                else
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to add group [ " .. msg.to.id .. " ]")
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'add' and matches[2]:lower() == 'realm' then
                if is_sudo(msg) then
                    if is_group(msg) then
                        return langs[msg.lang].errorAlreadyGroup
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added realm [ " .. msg.to.id .. " ]")
                    print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") added as a realm")
                    return realmadd(msg)
                else
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to add realm [ " .. msg.to.id .. " ]")
                    return langs[msg.lang].require_sudo
                end
            end
            if matches[1]:lower() == 'rem' and not matches[2] then
                if is_admin1(msg) then
                    if not is_group(msg) then
                        return langs[msg.lang].errorNotGroup
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed group [ " .. msg.to.id .. " ]")
                    print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed")
                    return modrem(msg)
                else
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to remove group [ " .. msg.to.id .. " ]")
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'rem' and matches[2]:lower() == 'realm' then
                if is_sudo(msg) then
                    if not is_realm(msg) then
                        return langs[msg.lang].errorNotRealm
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] removed realm [ " .. msg.to.id .. " ]")
                    print("group " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed as a realm")
                    return realmrem(msg)
                else
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to remove realm [ " .. msg.to.id .. " ]")
                    return langs[msg.lang].require_sudo
                end
            end
        end
        if data[tostring(msg.to.id)] then
            local settings = data[tostring(msg.to.id)]['settings']
            if matches[1] == 'chat_add_user' then
                if not msg.service then
                    return
                end
                if settings.lock_member == 'yes' and not is_owner2(msg.action.user.id, msg.to.id) then
                    return chat_del_user('chat#id' .. msg.to.id, 'user#id' .. msg.action.user.id, ok_cb, true)
                elseif settings.lock_member == 'yes' and tonumber(msg.from.id) == tonumber(our_id) then
                    return
                elseif settings.lock_member == 'no' then
                    return
                end
            end
            if matches[1] == 'chat_del_user' then
                if not msg.service then
                    return
                end
                return savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] deleted user  " .. 'user#id' .. msg.action.user.id)
            end
            if matches[1] == 'chat_delete_photo' then
                if not msg.service then
                    return
                end
                if settings.lock_photo == 'yes' then
                    local picturehash = 'picture:changed:' .. msg.to.id .. ':' .. msg.from.id
                    redis:incr(picturehash)
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

                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] tried to delete picture but failed  ")
                    return chat_set_photo(get_receiver(msg), settings.set_photo, ok_cb, false)
                elseif settings.lock_photo == 'no' then
                    return
                end
            end
            if matches[1] == 'chat_change_photo' and msg.from.id ~= 0 then
                if not msg.service then
                    return
                end
                if settings.lock_photo == 'yes' then
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
                    return chat_set_photo(get_receiver(msg), settings.set_photo, ok_cb, false)
                elseif settings.lock_photo == 'no' then
                    return
                end
            end
            if matches[1] == 'chat_rename' then
                if not msg.service then
                    return
                end
                if settings.lock_name == 'yes' then
                    if settings.set_name ~= tostring(msg.to.print_name) then
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
                        return rename_chat('chat#id' .. msg.to.id, settings.set_name, ok_cb, false)
                    end
                elseif settings.lock_name == 'no' then
                    return
                end
            end
            if matches[1]:lower() == 'setname' and is_group(msg) then
                if is_momod(msg) then
                    data[tostring(msg.to.id)]['settings']['set_name'] = string.gsub(matches[2], '_', ' ')
                    save_data(_config.moderation.data, data)
                    rename_chat('chat#id' .. msg.to.id, data[tostring(msg.to.id)]['settings']['set_name'], ok_cb, false)
                    return savelog(msg.to.id, "Group { " .. msg.to.print_name .. " }  name changed to [ " .. string.gsub(matches[2], '_', ' ') .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'setphoto' then
                if is_momod(msg) then
                    data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
                    save_data(_config.moderation.data, data)
                    return langs[msg.lang].sendNewGroupPic
                else
                    return langs[msg.lang].require_mod
                end
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'promote' or matches[1]:lower() == 'sasha promuovi' or matches[1]:lower() == 'promuovi' then
                    if is_owner(msg) then
                        if type(msg.reply_id) ~= "nil" then
                            msgr = get_message(msg.reply_id, promote_by_reply, { receiver = get_receiver(msg) })
                        elseif string.match(matches[2], '^%d+$') then
                            return promote(get_receiver(msg), 'NONAME', matches[2])
                        else
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted @" .. string.gsub(matches[2], '@', ''))
                            return resolve_username(string.gsub(matches[2], '@', ''), chat_promote_by_username, { receiver = get_receiver(msg) })
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                end
                if matches[1]:lower() == 'demote' or matches[1]:lower() == 'sasha degrada' or matches[1]:lower() == 'degrada' then
                    if is_owner(msg) then
                        if type(msg.reply_id) ~= "nil" then
                            msgr = get_message(msg.reply_id, demote_by_reply, { receiver = get_receiver(msg) })
                        elseif string.match(matches[2], '^%d+$') then
                            return demote(get_receiver(msg), 'NONAME', matches[2])
                        else
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted @" .. string.gsub(matches[2], '@', ''))
                            return resolve_username(string.gsub(matches[2], '@', ''), chat_demote_by_username, { receiver = get_receiver(msg) })
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                end
                if matches[1]:lower() == 'modlist' or matches[1]:lower() == 'sasha lista mod' or matches[1]:lower() == 'lista mod' then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group modlist")
                    return modlist(msg)
                end
            end
            if matches[1]:lower() == 'about' or matches[1]:lower() == 'sasha descrizione' then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group description")
                if not data[tostring(msg.to.id)]['description'] then
                    return langs[msg.lang].noDescription
                end
                return langs[msg.lang].description .. string.gsub(msg.to.print_name, "_", " ") .. ':\n\n' .. about
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'rules' or matches[1]:lower() == 'sasha regole' then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group rules")
                    if not data[tostring(msg.to.id)]['rules'] then
                        return langs[msg.lang].noRules
                    end
                    return langs[msg.lang].rules .. data[tostring(msg.to.id)]['rules']
                end
                if matches[1]:lower() == 'setrules' or matches[1]:lower() == 'sasha imposta regole' then
                    if is_momod(msg) then
                        data[tostring(msg.to.id)]['rules'] = matches[2]
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group rules to [" .. matches[2] .. "]")
                        return langs[msg.lang].newRules .. matches[2]
                    else
                        return langs[msg.lang].require_mod
                    end
                end
            end
            if matches[1]:lower() == 'setabout' or matches[1]:lower() == 'sasha imposta descrizione' then
                if is_momod(msg) then
                    data[tostring(msg.to.id)]['description'] = matches[2]
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group description to [" .. matches[2] .. "]")
                    return langs[msg.lang].newDescription .. matches[2]
                else
                    return langs[msg.lang].require_mod
                end
            end
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'lock' or matches[1]:lower() == 'sasha blocca' or matches[1]:lower() == 'blocca' then
                if is_momod(msg) then
                    if matches[2]:lower() == 'name' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked name ")
                        return lock_group_name(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'member' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked member ")
                        return lock_group_member(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'photo' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked photo ")
                        return lock_group_photo(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'flood' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked flood ")
                        return lock_group_flood(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'arabic' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked arabic ")
                        return lock_group_arabic(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'bots' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked bots ")
                        return lock_group_bots(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'leave' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked leaving ")
                        return lock_group_leave(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'links' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked link posting ")
                        return lock_group_links(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'rtl' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked rtl chars. in names")
                        return lock_group_rtl(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'sticker' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked sticker posting")
                        return lock_group_sticker(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'contacts' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked contact posting")
                        return lock_group_contacts(data, msg.to.id, msg.lang)
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'unlock' or matches[1]:lower() == 'sasha sblocca' or matches[1]:lower() == 'sblocca' then
                if is_momod(msg) then
                    if matches[2]:lower() == 'name' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked name ")
                        return unlock_group_name(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'member' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked member ")
                        return unlock_group_member(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'photo' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked photo ")
                        return unlock_group_photo(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'flood' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked flood ")
                        return unlock_group_flood(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'arabic' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked arabic ")
                        return unlock_group_arabic(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'bots' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked bots ")
                        return unlock_group_bots(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'leave' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked leaving ")
                        return unlock_group_leave(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'links' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked link posting")
                        return unlock_group_links(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'rtl' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked RTL chars. in names")
                        return unlock_group_rtl(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'sticker' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked sticker posting")
                        return unlock_group_sticker(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'contacts' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked contact posting")
                        return unlock_group_contacts(data, msg.to.id, msg.lang)
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
        end
        -- Begin Chat mutes
        if matches[1]:lower() == 'mute' or matches[1]:lower() == 'silenzia' then
            if is_owner(msg) then
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
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'unmute' or matches[1]:lower() == 'ripristina' then
            if is_owner(msg) then
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
            else
                return langs[msg.lang].require_owner
            end
        end
        -- End Chat mutes
        -- Begin Chat muteuser
        if (matches[1]:lower() == "muteuser" or matches[1]:lower() == 'voce') then
            if is_momod(msg) then
                local chat_id = msg.to.id
                local hash = "mute_user" .. chat_id
                local user_id = ""
                if type(msg.reply_id) ~= "nil" then
                    if matches[2] then
                        if matches[2]:lower() == 'from' then
                            get_message(msg.reply_id, muteuser_from, { receiver = get_receiver(msg), executer = msg.from.id })
                        else
                            muteuser = get_message(msg.reply_id, muteuser_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                        end
                    else
                        muteuser = get_message(msg.reply_id, muteuser_by_reply, { receiver = get_receiver(msg), executer = msg.from.id })
                    end
                    return
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
                    return resolve_username(string.gsub(matches[2], '@', ''), muteuser_by_username, { receiver = get_receiver(msg), executer = msg.from.id })
                end
            else
                return langs[msg.lang].require_mod
            end
        end
        -- End Chat muteuser
        if (matches[1]:lower() == "muteslist" or matches[1]:lower() == "lista muti") then
            if is_momod(msg) then
                if not has_mutes(msg.to.id) then
                    set_mutes(msg.to.id)
                end
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup muteslist")
                return mutes_list(msg.to.id, msg.to.print_name)
            else
                return langs[msg.lang].require_mod
            end
        end
        if (matches[1]:lower() == "mutelist" or matches[1]:lower() == "lista utenti muti") then
            if is_momod(msg) then
                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
                return muted_user_list(msg.to.id, msg.to.print_name)
            else
                return langs[msg.lang].require_mod
            end
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'settings' then
                if is_momod(msg) then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group settings ")
                    return show_group_settingsmod(msg.to.id, msg.lang)
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'public' then
                if is_momod(msg) then
                    if matches[2]:lower() == 'yes' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: public")
                        return set_public_member(data, msg.to.id, msg.lang)
                    end
                    if matches[2]:lower() == 'no' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: not public")
                        return unset_public_member(data, msg.to.id, msg.lang)
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
        end
        if matches[1]:lower() == 'newlink' and not is_realm(msg) then
            if is_momod(msg) then
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
            else
                return langs[msg.lang].require_mod
            end
        end
        if not msg.api_patch then
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
                if is_momod(msg) then
                    local group_link = data[tostring(msg.to.id)]['settings']['set_link']
                    if not group_link then
                        return langs[msg.lang].createLinkInfo
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
                    return msg.to.title .. '\n' .. group_link
                else
                    return langs[msg.lang].require_mod
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
            if matches[1]:lower() == 'setowner' then
                if is_owner(msg) then
                    if type(msg.reply_id) ~= "nil" then
                        msgr = get_message(msg.reply_id, setowner_by_reply, { receiver = get_receiver(msg) })
                    elseif string.match(matches[2], '^%d+$') then
                        data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. matches[2] .. "] as owner")
                        return matches[2] .. langs[msg.lang].setOwner
                    else
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set @" .. string.gsub(matches[2], '@', '') .. " as owner")
                        return resolve_username(string.gsub(matches[2], '@', ''), chat_setowner_by_username, { receiver = get_receiver(msg) })
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if matches[1]:lower() == 'setflood' then
                if is_momod(msg) then
                    if tonumber(matches[2]) < 3 or tonumber(matches[2]) > 200 then
                        return langs[msg.lang].errorFloodRange
                    end
                    data[tostring(msg.to.id)]['settings']['flood_msg_max'] = matches[2]
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set flood to [" .. matches[2] .. "]")
                    return langs[msg.lang].floodSet .. matches[2]
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'setwarn' and matches[2] then
                if is_momod(msg) then
                    print('im here')
                    local txt = set_warn(msg.from.id, msg.to.id, matches[2])
                    if matches[2] == '0' then
                        return langs[msg.lang].neverWarn
                    else
                        return txt
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'getwarn' then
                if is_momod(msg) then
                    return get_warn(msg.to.id)
                else
                    return langs[msg.lang].require_mod
                end
            end
        end
        if matches[1]:lower() == 'clean' then
            if is_owner(msg) then
                if matches[2]:lower() == 'member' then
                    chat_info(get_receiver(msg), cleanmember, false)
                end
                if not msg.api_patch then
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
                        data[tostring(msg.to.id)]['rules'] = nil
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned rules")
                    end
                end
                if matches[2]:lower() == 'about' then
                    data[tostring(msg.to.id)]['description'] = nil
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned about")
                end
            else
                return langs[msg.lang].require_owner
            end
        end
        if matches[1]:lower() == 'kill' then
            if matches[2]:lower() == 'group' then
                if is_admin1(msg) then
                    if is_group(msg) then
                        print("Closing Group: " .. get_receiver(msg))
                        chat_info(get_receiver(msg), killchat, false)
                        return modrem(msg)
                    else
                        return langs[msg.lang].realmIs
                    end
                else
                    return langs[msg.lang].require_admin
                end
            elseif matches[2]:lower() == 'realm' then
                if is_sudo(msg) then
                    if is_realm(msg) then
                        print("Closing realm: " .. get_receiver(msg))
                        chat_info(get_receiver(msg), killchat, false)
                        return realmrem(msg)
                    else
                        return langs[msg.lang].groupIs
                    end
                else
                    return langs[msg.lang].require_sudo
                end
            end
        end
    end

    -- SUPERGROUP
    if msg.to.type == 'channel' then
        if matches[1]:lower() == 'tosuper' then
            if is_admin1(msg) then
                return langs[msg.lang].errorAlreadySupergroup
            else
                return langs[msg.lang].require_admin
            end
        end
        if not msg.api_patch then
            if matches[1]:lower() == 'add' and not matches[2] then
                if is_admin1(msg) then
                    if is_super_group(msg) then
                        return reply_msg(msg.id, langs[msg.lang].supergroupAlreadyAdded, ok_cb, false)
                    end
                    print("SuperGroup " .. msg.to.print_name .. "(" .. msg.to.id .. ") added")
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added SuperGroup")
                    superadd(msg)
                    set_mutes(msg.to.id)
                    channel_set_admin(get_receiver(msg), 'user#id' .. msg.from.id, ok_cb, false)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'rem' and is_admin1(msg) and not matches[2] then
                if is_admin1(msg) then
                    if not is_super_group(msg) then
                        return reply_msg(msg.id, langs[msg.lang].supergroupRemoved, ok_cb, false)
                    end
                    print("SuperGroup " .. msg.to.print_name .. "(" .. msg.to.id .. ") removed")
                    superrem(msg)
                    rem_mutes(msg.to.id)
                else
                    return langs[msg.lang].require_admin
                end
            end
        end
        if data[tostring(msg.to.id)] then
            if not msg.api_patch then
                if matches[1]:lower() == "getadmins" or matches[1]:lower() == "sasha lista admin" or matches[1]:lower() == "lista admin" then
                    if is_owner(msg) then
                        member_type = 'Admins'
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup Admins list")
                        channel_get_admins(get_receiver(msg), callback, { receiver = get_receiver(msg), msg = msg, member_type = member_type })
                    else
                        return langs[msg.lang].require_owner
                    end
                end
                if matches[1]:lower() == "owner" then
                    if not data[tostring(msg.to.id)]['set_owner'] then
                        return langs[msg.lang].noOwnerCallAdmin
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] used /owner")
                    return langs[msg.lang].ownerIs .. data[tostring(msg.to.id)]['set_owner']
                end
                if matches[1]:lower() == "modlist" or matches[1]:lower() == "sasha lista mod" or matches[1]:lower() == "lista mod" then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group modlist")
                    return modlist(msg)
                end
            end
            if matches[1]:lower() == "bots" or matches[1]:lower() == "sasha lista bot" or matches[1]:lower() == "lista bot" then
                if is_momod(msg) then
                    member_type = 'Bots'
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup bots list")
                    channel_get_bots(get_receiver(msg), callback, { receiver = get_receiver(msg), msg = msg, member_type = member_type })
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'del' then
                if is_momod(msg) or tostring(msg.from.id) == '283058260' then
                    if type(msg.reply_id) ~= "nil" then
                        delete_msg(msg.id, ok_cb, false)
                        delete_msg(msg.reply_id, ok_cb, false)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] deleted a message by reply")
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'newlink' or matches[1]:lower() == "sasha crea link" or matches[1]:lower() == "crea link" then
                if is_momod(msg) then
                    local function callback_link(extra, success, result)
                        local receiver = get_receiver(msg)
                        if success == 0 then
                            send_large_msg(get_receiver(msg), langs[msg.lang].errorCreateLink)
                            data[tostring(msg.to.id)]['settings']['set_link'] = nil
                            save_data(_config.moderation.data, data)
                        else
                            send_large_msg(get_receiver(msg), langs[msg.lang].linkCreated)
                            data[tostring(msg.to.id)]['settings']['set_link'] = result
                            save_data(_config.moderation.data, data)
                        end
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] attempted to create a new SuperGroup link")
                    export_channel_link(get_receiver(msg), callback_link, false)
                else
                    return langs[msg.lang].require_mod
                end
            end
            if not msg.api_patch then
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
                if matches[1]:lower() == 'link' or matches[1]:lower() == "sasha link" then
                    if is_momod(msg) then
                        local group_link = data[tostring(msg.to.id)]['settings']['set_link']
                        if not group_link then
                            return langs[msg.lang].createLinkInfo
                        end
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group link [" .. group_link .. "]")
                        return msg.to.title .. '\n' .. group_link
                    else
                        return langs[msg.lang].require_mod
                    end
                end
            end
            if matches[1]:lower() == 'promoteadmin' then
                if is_owner(msg) then
                    if type(msg.reply_id) ~= "nil" then
                        local cbreply_extra = {
                            get_cmd = 'promoteadmin',
                            msg = msg
                        }
                        get_message(msg.reply_id, get_message_callback, cbreply_extra)
                    elseif string.match(matches[2], '^%d+$') then
                        local get_cmd = 'promoteadmin'
                        local msg = msg
                        channel_get_users(get_receiver(msg), in_channel_cb, { get_cmd = get_cmd, receiver = get_receiver(msg), msg = msg, user_id = matches[2] })
                    else
                        local get_cmd = 'promoteadmin'
                        local msg = msg
                        channel_get_users(get_receiver(msg), in_channel_cb, { get_cmd = get_cmd, receiver = get_receiver(msg), msg = msg, username = string.gsub(matches[2], '@', '') })
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if matches[1]:lower() == 'demoteadmin' then
                if is_owner(msg) then
                    if type(msg.reply_id) ~= "nil" then
                        local cbreply_extra = {
                            get_cmd = 'demoteadmin',
                            msg = msg
                        }
                        get_message(msg.reply_id, get_message_callback, cbreply_extra)
                    elseif string.match(matches[2], '^%d+$') then
                        local receiver = get_receiver(msg)
                        local user_id = "user#id" .. matches[2]
                        local get_cmd = 'demoteadmin'
                        if compare_ranks(msg.from.id, matches[2], msg.to.id) then
                            channel_demote(get_receiver(msg), user_id, ok_cb, false)
                            send_large_msg(get_receiver(msg), result.peer_id .. langs[msg.lang].demoteSupergroupMod)
                        else
                            return send_large_msg(get_receiver(msg), langs[msg.lang].cantDemoteOtherAdmin)
                        end
                    else
                        local cbres_extra = {
                            channel = get_receiver(msg),
                            get_cmd = 'demoteadmin'
                        }
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted admin @" .. string.gsub(matches[2], '@', ''))
                        resolve_username(string.gsub(matches[2], '@', ''), callbackres, cbres_extra)
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'setowner' then
                    if is_owner(msg) then
                        if type(msg.reply_id) ~= "nil" then
                            local cbreply_extra = {
                                get_cmd = 'setowner',
                                msg = msg
                            }
                            get_message(msg.reply_id, get_message_callback, cbreply_extra)
                        elseif string.match(matches[2], '^%d+$') then
                            data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
                            save_data(_config.moderation.data, data)
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set [" .. matches[2] .. "] as owner")
                            return matches[2] .. langs[msg.lang].setOwner
                        else
                            return resolve_username(string.gsub(matches[2], '@', ''), setowner_by_username, { receiver = get_receiver(msg), chat_id = msg.to.id })
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                end
                if matches[1]:lower() == 'promote' or matches[1]:lower() == "sasha promuovi" or matches[1]:lower() == "promuovi" then
                    if is_owner(msg) then
                        if type(msg.reply_id) ~= "nil" then
                            local cbreply_extra = {
                                get_cmd = 'promote',
                                msg = msg
                            }
                            get_message(msg.reply_id, get_message_callback, cbreply_extra)
                        elseif string.match(matches[2], '^%d+$') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted user#id" .. matches[2])
                            promote2(get_receiver(msg), 'NONAME', user_id)
                        else
                            local cbres_extra = {
                                channel = get_receiver(msg),
                                get_cmd = 'promote',
                            }
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] promoted @" .. string.gsub(matches[2], '@', ''))
                            return resolve_username(string.gsub(matches[2], '@', ''), callbackres, cbres_extra)
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                end
                if matches[1]:lower() == 'demote' or matches[1]:lower() == "sasha degrada" or matches[1]:lower() == "degrada" then
                    if is_owner(msg) then
                        if type(msg.reply_id) ~= "nil" then
                            local cbreply_extra = {
                                get_cmd = 'demote',
                                msg = msg
                            }
                            get_message(msg.reply_id, get_message_callback, cbreply_extra)
                        elseif string.match(matches[2], '^%d+$') then
                            local get_cmd = 'demote'
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted user#id" .. matches[2])
                            demote2(get_receiver(msg), matches[2], matches[2])
                        else
                            local cbres_extra = {
                                channel = get_receiver(msg),
                                get_cmd = 'demote'
                            }
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] demoted @" .. string.gsub(matches[2], '@', ''))
                            return resolve_username(string.gsub(matches[2], '@', ''), callbackres, cbres_extra)
                        end
                    else
                        return langs[msg.lang].require_owner
                    end
                end
            end
            if matches[1]:lower() == "setname" then
                if is_momod(msg) then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] renamed SuperGroup to: " .. string.gsub(matches[2], '_', ''))
                    rename_channel(get_receiver(msg), string.gsub(matches[2], '_', ''), ok_cb, false)
                else
                    return langs[msg.lang].require_mod
                end
            end
            if msg.service then
                if msg.action then
                    if msg.action.type == 'chat_rename' then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] renamed SuperGroup to: " .. msg.to.title)
                        data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
                        save_data(_config.moderation.data, data)
                    end
                end
            end
            if matches[1]:lower() == "setabout" or matches[1]:lower() == "sasha imposta descrizione" then
                if is_momod(msg) then
                    data[tostring(msg.to.id)]['description'] = matches[2]
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup description to: " .. matches[2])
                    channel_set_about(get_receiver(msg), matches[2], ok_cb, false)
                    return langs[msg.lang].newDescription .. matches[2]
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == "setusername" then
                if is_admin1(msg) then
                    local function ok_username_cb(extra, success, result)
                        if success == 1 then
                            send_large_msg(extra.receiver, langs[msg.lang].supergroupUsernameChanged)
                        elseif success == 0 then
                            send_large_msg(extra.receiver, langs[msg.lang].errorChangeUsername)
                        end
                    end
                    channel_set_username(get_receiver(msg), string.gsub(matches[2], '@', ''), ok_username_cb, { receiver = get_receiver(msg) })
                else
                    return langs[msg.lang].require_admin
                end
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'setrules' or matches[1]:lower() == "sasha imposta regole" then
                    if is_momod(msg) then
                        data[tostring(msg.to.id)]['rules'] = matches[2]
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] has changed group rules to [" .. matches[2] .. "]")
                        return langs[msg.lang].newRules .. matches[2]
                    else
                        return langs[msg.lang].require_mod
                    end
                end
            end
            if msg.media then
                if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set new SuperGroup photo")
                    load_photo(msg.id, set_supergroup_photo, msg)
                    return
                end
            end
            if matches[1]:lower() == 'setphoto' then
                if is_momod(msg) then
                    data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
                    save_data(_config.moderation.data, data)
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] started setting new SuperGroup photo")
                    return langs[msg.lang].sendNewGroupPic
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == 'clean' then
                if is_owner(msg) then
                    if not msg.api_patch then
                        if matches[2]:lower() == 'modlist' then
                            if next(data[tostring(msg.to.id)]['moderators']) == nil then
                                return langs[msg.lang].noGroupMods
                            end
                            for k, v in pairs(data[tostring(msg.to.id)]['moderators']) do
                                data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
                                save_data(_config.moderation.data, data)
                            end
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned modlist")
                            return langs[msg.lang].modlistCleaned
                        end
                        if matches[2]:lower() == 'rules' then
                            local data_cat = 'rules'
                            if data[tostring(msg.to.id)][data_cat] == nil then
                                return langs[msg.lang].noRules
                            end
                            data[tostring(msg.to.id)][data_cat] = nil
                            save_data(_config.moderation.data, data)
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned rules")
                            return langs[msg.lang].rulesCleaned
                        end
                    end
                    if matches[2]:lower() == 'about' then
                        local receiver = get_receiver(msg)
                        local about_text = ' '
                        local data_cat = 'description'
                        if data[tostring(msg.to.id)][data_cat] == nil then
                            return langs[msg.lang].noDescription
                        end
                        data[tostring(msg.to.id)][data_cat] = nil
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] cleaned about")
                        channel_set_about(get_receiver(msg), about_text, ok_cb, false)
                        return langs[msg.lang].descriptionCleaned
                    end
                    if not msg.api_patch then
                        if matches[2]:lower() == 'mutelist' then
                            chat_id = msg.to.id
                            local hash = 'mute_user:' .. chat_id
                            redis:del(hash)
                            return langs[msg.lang].mutelistCleaned
                        end
                    end
                    if matches[2]:lower() == 'username' then
                        if is_admin1(msg) then
                            local function ok_username_cb(extra, success, result)
                                if success == 1 then
                                    send_large_msg(extra.receiver, langs[msg.lang].usernameCleaned)
                                elseif success == 0 then
                                    send_large_msg(extra.receiver, langs[msg.lang].errorCleanUsername)
                                end
                            end
                            local username = ""
                            channel_set_username(get_receiver(msg), username, ok_username_cb, { receiver = get_receiver(msg) })
                        else
                            return langs[msg.lang].require_admin
                        end
                    end
                    if matches[2] == "bots" then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] kicked all SuperGroup bots")
                        channel_get_bots(get_receiver(msg), callback_clean_bots, { msg = msg })
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'lock' or matches[1]:lower() == "sasha blocca" or matches[1]:lower() == "blocca" then
                    if is_momod(msg) then
                        local target = msg.to.id
                        if matches[2]:lower() == 'links' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked link posting ")
                            return lock_group_links(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'spam' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked spam ")
                            return lock_group_spam(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'flood' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked flood ")
                            return lock_group_flood(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'arabic' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked arabic ")
                            return lock_group_arabic(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'member' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked member ")
                            return lock_group_member(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'rtl' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked rtl chars. in names")
                            return lock_group_rtl(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'tgservice' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked Tgservice Actions")
                            return lock_group_tgservice(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'sticker' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked sticker posting")
                            return lock_group_sticker(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'contacts' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked contact posting")
                            return lock_group_contacts(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'strict' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked enabled strict settings")
                            return enable_strict_rules(data, msg.to.id, msg.lang)
                        end
                    else
                        return langs[msg.lang].require_mod
                    end
                end
                if matches[1]:lower() == 'unlock' or matches[1]:lower() == "sasha sblocca" or matches[1]:lower() == "sblocca" then
                    if is_momod(msg) then
                        local target = msg.to.id
                        if matches[2]:lower() == 'links' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked link posting")
                            return unlock_group_links(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'spam' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked spam")
                            return unlock_group_spam(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'flood' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked flood")
                            return unlock_group_flood(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'arabic' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked Arabic")
                            return unlock_group_arabic(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'member' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked member ")
                            return unlock_group_member(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'rtl' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked RTL chars. in names")
                            return unlock_group_rtl(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'tgservice' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked tgservice actions")
                            return unlock_group_tgservice(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'sticker' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked sticker posting")
                            return unlock_group_sticker(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'contacts' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] unlocked contact posting")
                            return unlock_group_contacts(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'strict' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] locked disabled strict settings")
                            return disable_strict_rules(data, msg.to.id, msg.lang)
                        end
                    else
                        return langs[msg.lang].require_mod
                    end
                end
                if matches[1]:lower() == 'setflood' then
                    if is_momod(msg) then
                        if tonumber(matches[2]) < 3 or tonumber(matches[2]) > 200 then
                            return langs[msg.lang].errorFloodRange
                        end
                        data[tostring(msg.to.id)]['settings']['flood_msg_max'] = matches[2]
                        save_data(_config.moderation.data, data)
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set flood to [" .. matches[2] .. "]")
                        return langs[msg.lang].floodSet .. matches[2]
                    else
                        return langs[msg.lang].require_mod
                    end
                end
                if matches[1]:lower() == 'public' then
                    if is_momod(msg) then
                        if matches[2]:lower() == 'yes' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set group to: public")
                            return set_public_member(data, msg.to.id, msg.lang)
                        end
                        if matches[2]:lower() == 'no' then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: not public")
                            return unset_public_member(data, msg.to.id, msg.lang)
                        end
                    else
                        return langs[msg.lang].require_mod
                    end
                end
            end
            if matches[1]:lower() == 'mute' or matches[1]:lower() == 'silenzia' then
                if is_owner(msg) then
                    local chat_id = msg.to.id
                    if matches[2]:lower() == 'audio' then
                        local msg_type = 'Audio'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'photo' then
                        local msg_type = 'Photo'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'video' then
                        local msg_type = 'Video'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'gifs' then
                        local msg_type = 'Gifs'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'documents' then
                        local msg_type = 'Documents'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'text' then
                        local msg_type = 'Text'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                    if matches[2]:lower() == 'all' then
                        local msg_type = 'All'
                        if not is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: mute " .. msg_type)
                            mute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].enabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyEnabled
                        end
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if matches[1]:lower() == 'unmute' or matches[1]:lower() == 'ripristina' then
                if is_owner(msg) then
                    local chat_id = msg.to.id
                    if matches[2]:lower() == 'audio' then
                        local msg_type = 'Audio'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'photo' then
                        local msg_type = 'Photo'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'video' then
                        local msg_type = 'Video'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'gifs' then
                        local msg_type = 'Gifs'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'documents' then
                        local msg_type = 'Documents'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'text' then
                        local msg_type = 'Text'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute message")
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                    if matches[2]:lower() == 'all' then
                        local msg_type = 'All'
                        if is_muted(chat_id, msg_type .. ': yes') then
                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] set SuperGroup to: unmute " .. msg_type)
                            unmute(chat_id, msg_type)
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].disabled
                        else
                            return langs[msg.lang].mute .. msg_type .. langs[msg.lang].alreadyDisabled
                        end
                    end
                else
                    return langs[msg.lang].require_owner
                end
            end
            if matches[1]:lower() == "muteuser" or matches[1]:lower() == 'voce' then
                if is_momod(msg) then
                    local hash = "mute_user" .. msg.to.id
                    if type(msg.reply_id) ~= "nil" then
                        if matches[2] then
                            if matches[2]:lower() == 'from' then
                                get_message(msg.reply_id, muteuser_from, { receiver = get_receiver(msg), executer = msg.from.id })
                                return
                            else
                                local get_cmd = "mute_user"
                                get_message(msg.reply_id, get_message_callback, { receiver = get_receiver(msg), get_cmd = get_cmd, msg = msg })
                                return
                            end
                        else
                            local get_cmd = "mute_user"
                            get_message(msg.reply_id, get_message_callback, { receiver = get_receiver(msg), get_cmd = get_cmd, msg = msg })
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
                        local get_cmd = "mute_user"
                        resolve_username(string.gsub(matches[2], '@', ''), callbackres, { receiver = get_receiver(msg), get_cmd = get_cmd, executer = msg.from.id })
                    end
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == "muteslist" or matches[1]:lower() == "lista muti" then
                if is_momod(msg) then
                    if not has_mutes(msg.to.id) then
                        set_mutes(msg.to.id)
                    end
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup muteslist")
                    return mutes_list(msg.to.id, msg.to.print_name)
                else
                    return langs[msg.lang].require_mod
                end
            end
            if matches[1]:lower() == "mutelist" or matches[1]:lower() == "lista utenti muti" then
                if is_momod(msg) then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup mutelist")
                    return muted_user_list(msg.to.id, msg.to.print_name)
                else
                    return langs[msg.lang].require_mod
                end
            end
            if not msg.api_patch then
                if matches[1]:lower() == 'settings' then
                    if is_momod(msg) then
                        savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested SuperGroup settings ")
                        return show_supergroup_settings(msg.to.id, msg.lang)
                    else
                        return langs[msg.lang].require_mod
                    end
                end
                if matches[1]:lower() == 'rules' or matches[1]:lower() == "sasha regole" then
                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] requested group rules")
                    if not data[tostring(msg.to.id)]['rules'] then
                        return langs[msg.lang].noRules
                    end
                    return data[tostring(msg.to.id)]['settings']['set_name'] .. ' ' .. langs[msg.lang].rules .. '\n\n' .. data[tostring(msg.to.id)]['rules']
                end
            end
            if matches[1]:lower() == 'kill' and matches[2]:lower() == 'supergroup' then
                if is_admin1(msg) then
                    print("Closing Group: " .. get_receiver(msg))
                    channel_get_users(get_receiver(msg), killchannel, { chat_id = msg.to.id })
                    return modrem(msg)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'peer_id' then
                if is_admin1(msg) then
                    text = msg.to.peer_id
                    reply_msg(msg.id, text, ok_cb, false)
                    post_large_msg(get_receiver(msg), text)
                else
                    return langs[msg.lang].require_admin
                end
            end
            if matches[1]:lower() == 'msg.to.id' then
                if is_admin1(msg) then
                    text = msg.to.id
                    reply_msg(msg.id, text, ok_cb, false)
                    post_large_msg(get_receiver(msg), text)
                else
                    return langs[msg.lang].require_admin
                end
            end
            -- Admin Join Service Message
            if msg.service then
                if msg.action then
                    if msg.action.type == 'chat_add_user_link' then
                        if is_owner2(msg.from.id) then
                            local receiver = get_receiver(msg)
                            local user = "user#id" .. msg.from.id
                            savelog(msg.to.id, name_log .. " Admin [" .. msg.from.id .. "] joined the SuperGroup via link")
                            channel_set_admin(get_receiver(msg), user, ok_cb, false)
                        end
                    end
                    if msg.action.type == 'chat_add_user' then
                        if is_owner2(msg.action.user.id) then
                            local receiver = get_receiver(msg)
                            local user = "user#id" .. msg.action.user.id
                            savelog(msg.to.id, name_log .. " Admin [" .. msg.action.user.id .. "] added to the SuperGroup by [ " .. msg.from.id .. " ]")
                            channel_set_admin(get_receiver(msg), user, ok_cb, false)
                        end
                    end
                end
            end
            if matches[1]:lower() == 'msg.to.peer_id' then
                post_large_msg(get_receiver(msg), msg.to.peer_id)
            end
        end
    end
end

return {
    description = "GROUP_MANAGEMENT",
    patterns =
    {
        -- INPM
        "^[#!/]([Cc][Hh][Aa][Tt][Ss])$",
        "^[#!/]([Cc][Hh][Aa][Tt][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Jj][Oo][Ii][Nn]) (%d+)$",
        "^[#!/]([Aa][Ll][Ll][Cc][Hh][Aa][Tt][Ss])$",
        "^[#!/]([Aa][Ll][Ll][Cc][Hh][Aa][Tt][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ss][Ee][Tt][Aa][Ll][Ii][Aa][Ss]) ([^%s]+) (%d+)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Aa][Ll][Ii][Aa][Ss]) ([^%s]+)$",
        "^[#!/]([Gg][Ee][Tt][Aa][Ll][Ii][Aa][Ss][Ll][Ii][Ss][Tt])$",
        -- join
        "^[#!/]([Jj][Oo][Ii][Nn]) (.*)$",
        "^[#!/]([Ii][Nn][Vv][Ii][Tt][Ee][Mm][Ee]) (%d+)$",
        "^[#!/]([Ii][Nn][Vv][Ii][Tt][Ee][Mm][Ee]) (.*)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Vv][Ii][Tt][Aa][Mm][Ii]) (%d+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Nn][Vv][Ii][Tt][Aa][Mm][Ii]) (.*)$",
        "^([Ii][Nn][Vv][Ii][Tt][Aa][Mm][Ii]) (%d+)$",
        "^([Ii][Nn][Vv][Ii][Tt][Aa][Mm][Ii]) (.*)$",

        -- INREALM
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Gg][Rr][Oo][Uu][Pp]) (.*)$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Ss][Uu][Pp][Ee][Rr]) (.*)$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Rr][Ee][Aa][Ll][Mm]) (.*)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Ss][Uu][Pp][Ee][Rr][Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Rr][Ee][Aa][Ll][Mm]) (%d+)$",
        "^[#!/]([Rr][Ee][Mm]) (%d+)$",
        "^[#!/]([Aa][Dd][Dd][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Rr][Ee][Mm][Oo][Vv][Ee][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee][Ss][Uu][Pp][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee][Ss][Uu][Pp][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Oo][Ww][Nn][Ee][Rr]) (%d+) (%d+)$",-- (group id) (owner id)
        "^[#!/]([Ll][Ii][Ss][Tt]) (.*)$",
        "^[#!/]([Ll][Oo][Cc][Kk]) (%d+) (.*)$",
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss]) (%d+)$",
        "^[#!/]([Ss][Uu][Pp][Ee][Rr][Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Rr][Uu][Ll][Ee][Ss]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Ss][Uu][Pp][Ee][Rr][Gg][Rr][Oo][Uu][Pp][Aa][Bb][Oo][Uu][Tt]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Rr][Oo][Uu][Pp][Aa][Bb][Oo][Uu][Tt]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Nn][Aa][Mm][Ee]) (%d+) (.*)$",
        -- creategroup
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Gg][Rr][Uu][Pp][Pp][Oo]) (.*)$",
        -- createsuper
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Ss][Uu][Pp][Ee][Rr][Gg][Rr][Uu][Pp][Pp][Oo]) (.*)$",
        -- createrealm
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Rr][Ee][Gg][Nn][Oo]) (.*)$",
        -- lock
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        "^([Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        -- unlock
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        "^([Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",

        -- INGROUP
        "^[#!/]([Aa][Dd][Dd]) ([Rr][Ee][Aa][Ll][Mm])$",
        "^[#!/]([Rr][Ee][Mm]) ([Rr][Ee][Aa][Ll][Mm])$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Gg][Rr][Oo][Uu][Pp])$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Rr][Ee][Aa][Ll][Mm])$",

        -- SUPERGROUP
        "^[#!/]([Gg][Ee][Tt][Aa][Dd][Mm][Ii][Nn][Ss])$",
        "^[#!/]([Bb][Oo][Tt][Ss])$",
        "^[#!/]([Tt][Oo][Ss][Uu][Pp][Ee][Rr])$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn])",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee][Aa][Dd][Mm][Ii][Nn])",
        "^[#!/]([Ss][Ee][Tt][Uu][Ss][Ee][Rr][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Dd][Ee][Ll])$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Ss][Uu][Pp][Ee][Rr][Gg][Rr][Oo][Uu][Pp])$",
        "^([Pp][Ee][Ee][Rr]_[Ii][Dd])$",
        "^([Mm][Ss][Gg].[Tt][Oo].[Ii][Dd])$",
        "^([Mm][Ss][Gg].[Tt][Oo].[Pp][Ee][Ee][Rr]_[Ii][Dd])$",
        -- getadmins
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Aa][Dd][Mm][Ii][Nn])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Aa][Dd][Mm][Ii][Nn])$",
        -- bots
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Bb][Oo][Tt])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Bb][Oo][Tt])$",

        -- COMMON
        "^[#!/]([Tt][Yy][Pp][Ee])$",
        "^[#!/]([Ll][Oo][Gg])$",
        "^[#!/]([Aa][Dd][Mm][Ii][Nn][Ss])",
        "^[#!/]([Aa][Dd][Dd])$",
        "^[#!/]([Rr][Ee][Mm])$",
        "^[#!/]([Rr][Uu][Ll][Ee][Ss])$",
        "^[#!/]([Aa][Bb][Oo][Uu][Tt])$",
        "^[#!/]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Ww][Aa][Rr][Nn]) (%d+)$",
        "^[#!/]([Gg][Ee][Tt][Ww][Aa][Rr][Nn])$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee])",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
        "^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee])",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$",
        "^[#!/]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])",
        "^[#!/]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])",
        "^[#!/]([Mm][Uu][Tt][Ee][Ss][Ll][Ii][Ss][Tt])",
        "^[#!/]([Uu][Nn][Mm][Uu][Tt][Ee]) (.*)",
        "^[#!/]([Mm][Uu][Tt][Ee]) (.*)",
        "^[#!/]([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^[#!/]([Uu][Nn][Ss][Ee][Tt][Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ll][Ii][Nn][Kk])$",
        "^[#!/]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
        "^[#!/]([Oo][Ww][Nn][Ee][Rr])$",
        "^[#!/]([Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
        "^[#!/]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Cc][Ll][Ee][Aa][Nn]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$",
        "^[#!/]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$",
        "%[(photo)%]",
        "^!!tgservice (.+)$",
        -- rules
        "^([Ss][Aa][Ss][Hh][Aa] [Rr][Ee][Gg][Oo][Ll][Ee])$",
        -- about
        "^([Ss][Aa][Ss][Hh][Aa] [Dd][Ee][Ss][Cc][Rr][Ii][Zz][Ii][Oo][Nn][Ee])$",
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
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt]%.[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$",
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
    min_rank = 0,
    syntax =
    {
        "USER",
        "(#rules|sasha regole)",
        "(#about|sasha descrizione)",
        "(#modlist|[sasha] lista mod)",
        "#owner",
        "#admins [<reply>|<text>]",
        "MOD",
        "#type",
        "#setname <group_name>",
        "#setphoto",
        "(#setrules|sasha imposta regole) <text>",
        "(#setabout|sasha imposta descrizione) <text>",
        "#muteuser|voce <id>|<username>|<reply>|from",
        "(#muteslist|lista muti)",
        "(#mutelist|lista utenti muti)",
        "#settings",
        "#public yes|no",
        "(#newlink|sasha crea link)",
        "(#link|sasha link)",
        "#setflood <value>",
        "#setwarn <value>",
        "#getwarn",
        "GROUPS",
        "(#lock|[sasha] blocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts",
        "(#unlock|[sasha] sblocca) name|member|photo|flood|arabic|bots|leave|links|rtl|sticker|contacts",
        "SUPERGROUPS",
        "(#bots|[sasha] lista bot)",
        "#del <reply>",
        "(#lock|[sasha] blocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict",
        "(#unlock|[sasha] sblocca) links|spam|flood|arabic|member|rtl|tgservice|sticker|contacts|strict",
        "OWNER",
        "#log",
        "(#setlink|sasha imposta link) <link>",
        "(#unsetlink|sasha elimina link)",
        "(#promote|[sasha] promuovi) <username>|<reply>",
        "(#demote|[sasha] degrada) <username>|<reply>",
        "#mute|silenzia all|text|documents|gifs|video|photo|audio",
        "#unmute|ripristina all|text|documents|gifs|video|photo|audio",
        "#setowner <id>|<username>|<reply>",
        "GROUPS",
        "#clean modlist|rules|about",
        "SUPERGROUPS",
        "(#getadmins|[sasha] lista admin)",
        "#promoteadmin <id>|<username>|<reply>",
        "#demoteadmin <id>|<username>|<reply>",
        "#clean rules|about|modlist|mutelist",
        "ADMIN",
        "#add",
        "#rem",
        "ex INGROUP.LUA",
        "#add realm",
        "#rem realm",
        "#kill group|realm",
        "ex INPM.LUA",
        "(#join|#inviteme|[sasha] invitami) <chat_id>|<alias>",
        "#getaliaslist",
        "#allchats",
        "#allchatlist",
        "#setalias <alias> <group_id>",
        "#unsetalias <alias>",
        "SUPERGROUPS",
        "#tosuper",
        "#setusername <text>",
        "#kill supergroup",
        "peer_id",
        "msg.to.id",
        "msg.to.peer_id",
        "REALMS",
        "#setgpowner <group_id> <user_id>",
        "(#creategroup|sasha crea gruppo) <group_name>",
        "(#createsuper|sasha crea supergruppo) <group_name>",
        "(#createrealm|sasha crea regno) <realm_name>",
        "(#setabout|sasha imposta descrizione) <group_id> <text>",
        "(#setrules|sasha imposta regole) <group_id> <text>",
        "#setname <realm_name>",
        "#setname|#setgpname <group_id> <group_name>",
        "(#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker",
        "(#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker",
        "#settings <group_id>",
        "#type",
        "#kill group|supergroup|realm <group_id>",
        "#rem <group_id>",
        "#list admins|groups|realms",
        "SUDO",
        "#addadmin <user_id>|<username>",
        "#removeadmin <user_id>|<username>",
    },
}