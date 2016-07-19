local function create_group(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if is_sudo(msg) or is_realm(msg) and is_admin1(msg) then
        local group_creator = msg.from.print_name
        create_group_chat(group_creator, group_name, ok_cb, false)
        return langs[msg.lang].group .. string.gsub(group_name, '_', ' ') .. langs[msg.lang].created
    end
end

local function create_realm(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if is_sudo(msg) or is_realm(msg) and is_admin1(msg) then
        local group_creator = msg.from.print_name
        create_group_chat(group_creator, group_name, ok_cb, false)
        return langs[msg.lang].realm .. string.gsub(group_name, '_', ' ') .. langs[msg.lang].created
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

local function killchannel(extra, success, result)
    for k, v in pairsByKeys(result) do
        local function post_kick()
            kick_user_any(v.peer_id, extra.chat_id)
        end
        postpone(post_kick, false, 1)
    end
    channel_kick('channel#id' .. extra.chat_id, 'user#id' .. our_id, ok_cb, false)
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

-- Support Team
local function support_add(support_id)
    -- Save to redis
    local hash = 'support'
    redis:sadd(hash, support_id)
end

local function support_remove(support_id)
    -- Save on redis
    local hash = 'support'
    redis:srem(hash, support_id)
end

local function get_group_type(msg)
    local data = load_data(_config.moderation.data)
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
        local group_type = data[tostring(msg.to.id)]['group_type']
        return group_type
    else
        return langs[msg.lang].chatTypeNotFound
    end
end

local function callbackres(extra, success, result)
    -- vardump(result)
    local user = result.peer_id
    local name = string.gsub(result.print_name, "_", " ")
    local chat = 'chat#id' .. extra.chatid
    local channel = 'channel#id' .. extra.chatid
    send_large_msg(chat, user .. '\n' .. name)
    send_large_msg(channel, user .. '\n' .. name)
    return user
end

local function set_description(msg, data, target, about)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data_cat = 'description'
    data[tostring(target)][data_cat] = about
    save_data(_config.moderation.data, data)
    return langs[msg.lang].newDescription .. about
end

local function set_rules(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local data_cat = 'rules'
    data[tostring(target)][data_cat] = rules
    save_data(_config.moderation.data, data)
    return langs[msg.lang].newRules .. rules
end
-- lock/unlock group name. bot automatically change group name when locked
local function lock_group_name(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function unlock_group_name(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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
-- lock/unlock group member. bot automatically kick new added user when locked
local function lock_group_member(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function unlock_group_member(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

-- lock/unlock group photo. bot automatically keep group photo when locked
local function lock_group_photo(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
    if group_photo_lock == 'yes' then
        return langs[msg.lang].photoAlreadyLocked
    else
        data[tostring(target)]['settings']['set_photo'] = 'waiting'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].sendNewGroupPic
    end
end

local function unlock_group_photo(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function lock_group_flood(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function unlock_group_flood(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function lock_group_arabic(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function lock_group_rtl(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function lock_group_links(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function lock_group_spam(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'yes' then
        return langs[msg.lang].spamAlreadyLocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].spamLocked
    end
end

local function unlock_group_spam(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
    if group_spam_lock == 'no' then
        return langs[msg.lang].spamAlreadyUnlocked
    else
        data[tostring(target)]['settings']['lock_spam'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].spamUnlocked
    end
end

local function lock_group_sticker(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
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

local function set_public_membermod(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local group_public_lock = data[tostring(target)]['settings']['public']
    if group_public_lock == 'yes' then
        return langs[msg.lang].publicAlreadyYes
    else
        data[tostring(target)]['settings']['public'] = 'yes'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].publicYes
    end
end

local function unset_public_membermod(msg, data, target)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    local group_public_lock = data[tostring(target)]['settings']['public']
    if group_public_lock == 'no' then
        return langs[msg.lang].publicAlreadyNo
    else
        data[tostring(target)]['settings']['public'] = 'no'
        save_data(_config.moderation.data, data)
        return langs[msg.lang].publicNo
    end
end

-- show group settings
local function show_group_settings(msg, data, target)
    local data = load_data(_config.moderation.data, data)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    if data[tostring(target)]['settings'] then
        if not data[tostring(target)]['settings']['public'] then
            data[tostring(target)]['settings']['public'] = 'no'
        end
    end
    local settings = data[tostring(target)]['settings']
    local text = langs[msg.lang].groupSettings .. target .. ":" ..
    langs[msg.lang].nameLock .. settings.lock_name ..
    langs[msg.lang].photoLock .. settings.lock_photo ..
    langs[msg.lang].membersLock .. settings.lock_member ..
    langs[msg.lang].public .. settings.public
    return text
end

-- show SuperGroup settings
local function show_super_group_settings(msg, data, target)
    local data = load_data(_config.moderation.data, data)
    if not is_admin1(msg) then
        return langs[msg.lang].require_admin
    end
    if data[tostring(msg.to.id)]['settings'] then
        if not data[tostring(msg.to.id)]['settings']['public'] then
            data[tostring(msg.to.id)]['settings']['public'] = 'no'
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
    local text = langs[msg.lang].supergroupSettings .. target .. ":" ..
    langs[msg.lang].linksLock .. settings.lock_link ..
    langs[msg.lang].floodLock .. settings.flood ..
    langs[msg.lang].spamLock .. settings.lock_spam ..
    langs[msg.lang].arabic_lock .. settings.lock_arabic ..
    langs[msg.lang].membersLock .. settings.lock_member ..
    langs[msg.lang].rtlLock .. settings.lock_rtl ..
    langs[msg.lang].stickersLock .. settings.lock_sticker ..
    langs[msg.lang].public .. settings.public ..
    langs[msg.lang].strictrules .. settings.strict
    return text
end

local function returnids(extra, success, result)
    local lang = get_lang(result.peer_id)
    local i = 1
    local receiver = extra.receiver
    local chat_id = "chat#id" .. result.peer_id
    local chatname = result.print_name
    local text = langs[lang].usersIn .. string.gsub(chatname, "_", " ") .. ' ID: ' .. result.peer_id .. '\n\n'
    for k, v in pairs(result.members) do
        if v.print_name then
            local username = ""
            text = text .. i .. '. ' .. string.gsub(v.print_name, "_", " ") .. " - " .. v.peer_id .. " \n\n"
            i = i + 1
        end
    end
    local file = io.open("./groups/lists/" .. result.peer_id .. "memberlist.txt", "w")
    file:write(text)
    file:flush()
    file:close()
end

local function admin_promote(msg, admin_id)
    if not is_sudo(msg) then
        return langs[msg.lang].require_sudo
    end
    local admins = 'admins'
    if not data[tostring(admins)] then
        data[tostring(admins)] = { }
        save_data(_config.moderation.data, data)
    end
    if data[tostring(admins)][tostring(admin_id)] then
        return admin_id .. langs[msg.lang].alreadyAdmin
    end
    data[tostring(admins)][tostring(admin_id)] = admin_id
    save_data(_config.moderation.data, data)
    return admin_id .. langs[msg.lang].promoteAdmin
end

local function admin_demote(msg, admin_id)
    if not is_sudo(msg) then
        return langs[msg.lang].require_sudo
    end
    local data = load_data(_config.moderation.data)
    local admins = 'admins'
    if not data[tostring(admins)] then
        data[tostring(admins)] = { }
        save_data(_config.moderation.data, data)
    end
    if not data[tostring(admins)][tostring(admin_id)] then
        return admin_id .. langs[msg.lang].notAdmin
    end
    data[tostring(admins)][tostring(admin_id)] = nil
    save_data(_config.moderation.data, data)
    return admin_id .. langs[msg.lang].demoteAdmin
end

local function admin_list(msg)
    local data = load_data(_config.moderation.data)
    local admins = 'admins'
    if not data[tostring(admins)] then
        data[tostring(admins)] = { }
        save_data(_config.moderation.data, data)
    end
    local message = langs[msg.lang].adminListStart
    for k, v in pairs(data[tostring(admins)]) do
        message = message .. '@' .. v .. ' - ' .. k .. '\n'
    end
    return message
end

local function groups_list(msg)
    local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return langs[msg.lang].noGroups
    end
    local message = langs[msg.lang].groupListStart
    for k, v in pairs(data[tostring(groups)]) do
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
local function realms_list(msg)
    local data = load_data(_config.moderation.data)
    local realms = 'realms'
    if not data[tostring(realms)] then
        return langs[msg.lang].noRealms
    end
    local message = langs[msg.lang].realmListStart
    for k, v in pairs(data[tostring(realms)]) do
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

local function admin_user_promote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local data = load_data(_config.moderation.data)
    if not data['admins'] then
        data['admins'] = { }
        save_data(_config.moderation.data, data)
    end
    if data['admins'][tostring(member_id)] then
        return send_large_msg(receiver, '@' .. member_username .. langs[lang].alreadyAdmin)
    end
    data['admins'][tostring(member_id)] = member_username
    save_data(_config.moderation.data, data)
    return send_large_msg(receiver, '@' .. member_username .. langs[lang].promoteAdmin)
end

local function admin_user_demote(receiver, member_username, member_id)
    local lang = get_lang(string.match(receiver, '%d+'))
    local data = load_data(_config.moderation.data)
    if not data['admins'] then
        data['admins'] = { }
        save_data(_config.moderation.data, data)
    end
    if not data['admins'][tostring(member_id)] then
        send_large_msg(receiver, "@" .. member_username .. langs[lang].notAdmin)
        return
    end
    data['admins'][tostring(member_id)] = nil
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, '@' .. member_username .. langs[lang].demoteAdmin)
end

local function username_id(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local mod_cmd = extra.mod_cmd
    local receiver = extra.receiver
    local member = extra.member
    local text = langs[lang].none .. '@' .. member .. langs[lang].inThisGroup
    for k, v in pairs(result.members) do
        vusername = v.username
        if vusername == member then
            member_username = member
            member_id = v.peer_id
            if mod_cmd == 'addadmin' then
                return admin_user_promote(receiver, member_username, member_id)
            elseif mod_cmd == 'removeadmin' then
                return admin_user_demote(receiver, member_username, member_id)
            end
        end
    end
    send_large_msg(receiver, text)
end

local function res_user_support(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    local receiver = extra.receiver
    local get_cmd = extra.get_cmd
    local support_id = result.peer_id
    if get_cmd == 'addsupport' then
        support_add(support_id)
        send_large_msg(receiver, support_id .. langs[lang].supportAdded)
    elseif get_cmd == 'removesupport' then
        support_remove(support_id)
        send_large_msg(receiver, support_id .. langs[lang].supportRemoved)
    end
end

function run(msg, matches)
    local name_log = user_print_name(msg.from)
    if matches[1]:lower() == 'log' and is_owner(msg) then
        local receiver = get_receiver(msg)
        savelog(msg.to.id, "log file created by owner/support/admin")
        send_document(receiver, "./groups/logs/" .. msg.to.id .. "log.txt", ok_cb, false)
    end

    if matches[1]:lower() == 'wholist' and is_momod(msg) then
        local name = user_print_name(msg.from)
        savelog(msg.to.id, name .. " [" .. msg.from.id .. "] requested member list in a file")
        local receiver = get_receiver(msg)
        chat_info(receiver, returnids, { receiver = receiver })
        send_document("chat#id" .. msg.to.id, "./groups/lists/" .. msg.to.id .. "memberlist.txt", ok_cb, false)
    end

    if not is_sudo(msg) then
        if is_realm(msg) and is_admin1(msg) then
            print("Admin detected")
        else
            return
        end
    end

    if (matches[1]:lower() == 'creategroup' or matches[1]:lower() == 'sasha crea gruppo') and matches[2] then
        group_name = matches[2]
        group_type = 'group'
        return create_group(msg)
    end

    --[[ Experimental
	if matches[1]:lower() == 'createsuper' or matches[1]:lower() == 'sasha crea supergruppo' and matches[2] then
	if not is_sudo(msg) then
        return langs[msg.lang].require_sudo
	end
        group_name = matches[2]
        group_type = 'super_group'
        return create_group(msg)
    end]]

    if (matches[1]:lower() == 'createrealm' or matches[1]:lower() == 'sasha crea regno') and matches[2] then
        if not is_sudo(msg) then
            return langs[msg.lang].require_sudo
        end
        group_name = matches[2]
        group_type = 'realm'
        return create_realm(msg)
    end

    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    if (matches[1]:lower() == 'setabout' or matches[1]:lower() == 'sasha imposta descrizione') and matches[2]:lower() == 'group' and is_realm(msg) then
        local target = matches[3]
        local about = matches[4]
        return set_description(msg, data, target, about)
    end
    if (matches[1]:lower() == 'setabout' or matches[1]:lower() == 'sasha imposta descrizione') and matches[2]:lower() == 'sgroup' and is_realm(msg) then
        local channel = 'channel#id' .. matches[3]
        local about_text = matches[4]
        local data_cat = 'description'
        local target = matches[3]
        channel_set_about(channel, about_text, ok_cb, false)
        data[tostring(target)][data_cat] = about_text
        save_data(_config.moderation.data, data)
        return langs[msg.lang].descriptionSet .. matches[2]
    end
    if matches[1]:lower() == 'setrules' or matches[1]:lower() == 'sasha imposta regole' then
        rules = matches[3]
        local target = matches[2]
        return set_rules(msg, data, target)
    end
    if matches[1]:lower() == 'lock' or matches[1]:lower() == 'sasha blocca' or matches[1]:lower() == 'blocca' then
        local target = matches[2]
        if matches[3]:lower() == 'name' then
            return lock_group_name(msg, data, target)
        end
        if matches[3]:lower() == 'member' then
            return lock_group_member(msg, data, target)
        end
        if matches[3]:lower() == 'photo' then
            return lock_group_photo(msg, data, target)
        end
        if matches[3]:lower() == 'flood' then
            return lock_group_flood(msg, data, target)
        end
        if matches[3]:lower() == 'arabic' then
            return lock_group_arabic(msg, data, target)
        end
        if matches[3]:lower() == 'links' then
            return lock_group_links(msg, data, target)
        end
        if matches[3]:lower() == 'spam' then
            return lock_group_spam(msg, data, target)
        end
        if matches[3]:lower() == 'rtl' then
            return unlock_group_rtl(msg, data, target)
        end
        if matches[3]:lower() == 'sticker' then
            return lock_group_sticker(msg, data, target)
        end
    end
    if matches[1]:lower() == 'unlock' or matches[1]:lower() == 'sasha sblocca' or matches[1]:lower() == 'sblocca' then
        local target = matches[2]
        if matches[3]:lower() == 'name' then
            return unlock_group_name(msg, data, target)
        end
        if matches[3]:lower() == 'member' then
            return unlock_group_member(msg, data, target)
        end
        if matches[3]:lower() == 'photo' then
            return unlock_group_photo(msg, data, target)
        end
        if matches[3]:lower() == 'flood' then
            return unlock_group_flood(msg, data, target)
        end
        if matches[3]:lower() == 'arabic' then
            return unlock_group_arabic(msg, data, target)
        end
        if matches[3]:lower() == 'links' then
            return unlock_group_links(msg, data, target)
        end
        if matches[3]:lower() == 'spam' then
            return unlock_group_spam(msg, data, target)
        end
        if matches[3]:lower() == 'rtl' then
            return unlock_group_rtl(msg, data, target)
        end
        if matches[3]:lower() == 'sticker' then
            return unlock_group_sticker(msg, data, target)
        end
    end

    if matches[1]:lower() == 'settings' and data[tostring(matches[2])]['settings'] then
        local target = matches[2]
        text = show_group_settingsmod(msg, target)
        return text .. "\nID: " .. target .. "\n"
    end
    if matches[1]:lower() == 'supersettings' and data[tostring(matches[2])]['settings'] then
        local target = matches[2]
        text = show_supergroup_settingsmod(msg, target)
        return text .. "\nID: " .. target .. "\n"
    end

    if matches[1]:lower() == 'setname' and is_realm(msg) then
        local settings = data[tostring(matches[2])]['settings']
        local new_name = string.gsub(matches[2], '_', ' ')
        data[tostring(msg.to.id)]['settings']['set_name'] = new_name
        save_data(_config.moderation.data, data)
        local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
        local to_rename = 'chat#id' .. msg.to.id
        rename_chat(to_rename, group_name_set, ok_cb, false)
        savelog(msg.to.id, "Realm { " .. msg.to.print_name .. " }  name changed to [ " .. new_name .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
    end

    if matches[1]:lower() == 'setgpname' and is_admin(msg) then
        local new_name = string.gsub(matches[3], '_', ' ')
        data[tostring(matches[2])]['settings']['set_name'] = new_name
        save_data(_config.moderation.data, data)
        local group_name_set = data[tostring(matches[2])]['settings']['set_name']
        local chat_to_rename = 'chat#id' .. matches[2]
        local channel_to_rename = 'channel#id' .. matches[2]
        rename_chat(to_rename, group_name_set, ok_cb, false)
        rename_channel(channel_to_rename, group_name_set, ok_cb, false)
        savelog(matches[3], "Group { " .. group_name_set .. " }  name changed to [ " .. new_name .. " ] by " .. name_log .. " [" .. msg.from.id .. "]")
    end

    if matches[1]:lower() == 'kill' and matches[2]:lower() == 'group' and matches[3] then
        if not is_admin1(msg) then
            return
        end
        if is_realm(msg) then
            local receiver = 'chat#id' .. matches[3]
            print("Closing Group: " .. receiver)
            chat_info(receiver, killchat, false)
            return modrem(msg)
        else
            return langs[msg.lang].errorGroup .. matches[3] .. langs[msg.lang].notFound
        end
    end
    if matches[1]:lower() == 'kill' and matches[2]:lower() == 'supergroup' and matches[3] then
        if not is_admin1(msg) then
            return
        end
        if is_realm(msg) then
            local receiver = 'channel#id' .. matches[3]
            print("Closing Group: " .. receiver)
            channel_get_users(receiver, killchannel, { chat_id = matches[3] })
            return modrem(msg)
        else
            return langs[msg.lang].errorGroup .. matches[3] .. langs[msg.lang].notFound
        end
    end
    if matches[1]:lower() == 'kill' and matches[2]:lower() == 'realm' and matches[3] then
        if not is_admin1(msg) then
            return
        end
        if is_realm(msg) then
            local receiver = 'chat#id' .. matches[3]
            print("Closing realm: " .. receiver)
            chat_info(receiver, killrealm, false)
            return realmrem(msg)
        else
            return langs[msg.lang].errorRealm .. matches[3] .. langs[msg.lang].notFound
        end
    end
    if matches[1]:lower() == 'rem' and matches[2] then
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
        send_large_msg(receiver, langs[msg.lang].chat .. matches[2] .. langs[msg.lang].removed)
    end

    if matches[1] == 'chat_add_user' then
        if not msg.service or msg.action.user.id == 202256859 then
            return
        end
        local user = 'user#id' .. msg.action.user.id
        local chat = 'chat#id' .. msg.to.id
        if not is_admin1(msg) and is_realm(msg) then
            chat_del_user(chat, user, ok_cb, true)
        end
    end
    if matches[1]:lower() == 'addadmin' then
        if not is_sudo(msg) then
            -- Sudo only
            return
        end
        if string.match(matches[2], '^%d+$') then
            local admin_id = matches[2]
            print("user " .. admin_id .. " has been promoted as admin")
            return admin_promote(msg, admin_id)
        else
            local member = string.gsub(matches[2], "@", "")
            local mod_cmd = "addadmin"
            chat_info(receiver, username_id, { mod_cmd = mod_cmd, receiver = receiver, member = member })
        end
    end
    if matches[1]:lower() == 'removeadmin' then
        if not is_sudo(msg) then
            -- Sudo only
            return
        end
        if string.match(matches[2], '^%d+$') then
            local admin_id = matches[2]
            print("user " .. admin_id .. " has been demoted")
            return admin_demote(msg, admin_id)
        else
            local member = string.gsub(matches[2], "@", "")
            local mod_cmd = "removeadmin"
            chat_info(receiver, username_id, { mod_cmd = mod_cmd, receiver = receiver, member = member })
        end
    end
    if matches[1]:lower() == 'support' and matches[2] then
        if string.match(matches[2], '^%d+$') then
            local support_id = matches[2]
            print("User " .. support_id .. " has been added to the support team")
            support_add(support_id)
            return support_id .. langs[msg.lang].supportAdded
        else
            local member = string.gsub(matches[2], "@", "")
            local receiver = get_receiver(msg)
            local get_cmd = "addsupport"
            resolve_username(member, res_user_support, { get_cmd = get_cmd, receiver = receiver })
        end
    end
    if matches[1]:lower() == '-support' then
        if string.match(matches[2], '^%d+$') then
            local support_id = matches[2]
            print("User " .. support_id .. " has been removed from the support team")
            support_remove(support_id)
            return support_id .. langs[msg.lang].supportRemoved
        else
            local member = string.gsub(matches[2], "@", "")
            local receiver = get_receiver(msg)
            local get_cmd = "removesupport"
            resolve_username(member, res_user_support, { get_cmd = get_cmd, receiver = receiver })
        end
    end
    if matches[1]:lower() == 'type' then
        local group_type = get_group_type(msg)
        return group_type
    end
    if matches[1]:lower() == 'list' then
        if matches[2]:lower() == 'admins' then
            return admin_list(msg)
        end
        -- if matches[2] == 'support' and not matches[2] then
        -- return support_list()
        -- end
    end

    if matches[1]:lower() == 'list' and matches[2]:lower() == 'groups' then
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            groups_list(msg)
            send_document("chat#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
            send_document("channel#id" .. msg.to.id, "./groups/lists/groups.txt", ok_cb, false)
            -- group_list(msg)
        elseif msg.to.type == 'user' then
            groups_list(msg)
            send_document("user#id" .. msg.from.id, "./groups/lists/groups.txt", ok_cb, false)
            -- group_list(msg)
        end
        return langs[msg.lang].groupListCreated
    end
    if matches[1]:lower() == 'list' and matches[2]:lower() == 'realms' then
        if msg.to.type == 'chat' or msg.to.type == 'channel' then
            realms_list(msg)
            send_document("chat#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
            send_document("channel#id" .. msg.to.id, "./groups/lists/realms.txt", ok_cb, false)
            -- realms_list(msg)
        elseif msg.to.type == 'user' then
            realms_list(msg)
            send_document("user#id" .. msg.from.id, "./groups/lists/realms.txt", ok_cb, false)
            -- realms_list(msg)
        end
        return langs[msg.lang].realmListCreated
    end
end

return {
    description = "INREALM",
    patterns =
    {
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Gg][Rr][Oo][Uu][Pp]) (.*)$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Ss][Uu][Pp][Ee][Rr]) (.*)$",
        "^[#!/]([Cc][Rr][Ee][Aa][Tt][Ee][Rr][Ee][Aa][Ll][Mm]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Gg][Pp][Nn][Aa][Mm][Ee]) (%d+) (.*)$",
        "^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (%d+) (.*)$",
        "^[#!/]([Ll][Oo][Cc][Kk]) (%d+) (.*)$",
        "^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (%d+) (.*)$",
        -- "^[#!/]([Mm][Uu][Tt][Ee]) (%d+)$",
        -- "^[#!/]([Uu][Nn][Mm][Uu][Tt][Ee]) (%d+)$",
        "^[#!/]([Ss][Uu][Pp][Ee][Rr][Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss]) (%d+)$",
        "^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss]) (%d+)$",
        "^[#!/]([Ww][Hh][Oo][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ww][Hh][Oo])$",
        "^[#!/]([Tt][Yy][Pp][Ee])$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Ss][Uu][Pp][Ee][Rr][Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Kk][Ii][Ll][Ll]) ([Rr][Ee][Aa][Ll][Mm]) (%d+)$",
        "^[#!/]([Aa][Dd][Dd][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Rr][Ee][Mm][Oo][Vv][Ee][Aa][Dd][Mm][Ii][Nn]) (.*)$",
        "^[#!/]([Rr][Ee][Mm]) (%d+)$",
        "^[#!/]([Ss][Uu][Pp][Pp][Oo][Rr][Tt])$",
        "^[#!/]([Ss][Uu][Pp][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/](-[Ss][Uu][Pp][Pp][Oo][Rr][Tt]) (.*)$",
        "^[#!/]([Ll][Ii][Ss][Tt]) (.*)$",
        "^[#!/]([Ll][Oo][Gg])$",
        "^!!tgservice (.+)$",
        -- creategroup
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Gg][Rr][Uu][Pp][Pp][Oo]) (.*)$",
        -- createsuper
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Ss][Uu][Pp][Ee][Rr][Gg][Rr][Uu][Pp][Pp][Oo]) (.*)$",
        -- createrealm
        "^([Ss][Aa][Ss][Hh][Aa] [Cc][Rr][Ee][Aa] [Rr][Ee][Gg][Nn][Oo]) (.*)$",
        -- setabout
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Dd][Ee][Ss][Cc][Rr][Ii][Zz][Ii][Oo][Nn][Ee]) (%d+) (.*)$",
        -- setrules
        "^([Ss][Aa][Ss][Hh][Aa] [Ii][Mm][Pp][Oo][Ss][Tt][Aa] [Rr][Ee][Gg][Oo][Ll][Ee]) (%d+) (.*)$",
        -- lock
        "^([Ss][Aa][Ss][Hh][Aa] [Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        "^([Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        -- unlock
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
        "^([Ss][Bb][Ll][Oo][Cc][Cc][Aa]) (%d+) (.*)$",
    },
    run = run,
    min_rank = 1
    -- usage
    -- MOD
    -- #who
    -- #wholist
    -- OWNER
    -- #log
    -- ADMIN
    -- (#creategroup|sasha crea gruppo) <group_name>
    -- (#createsuper|sasha crea supergruppo) <group_name>
    -- (#createrealm|sasha crea regno) <realm_name>
    -- (#setabout|sasha imposta descrizione) <group_id> <text>
    -- (#setrules|sasha imposta regole) <group_id> <text>
    -- #setname <realm_name>
    -- #setname|#setgpname <group_id> <group_name>
    -- (#lock|[sasha] blocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker
    -- (#unlock|[sasha] sblocca) <group_id> name|member|photo|flood|arabic|links|spam|rtl|sticker
    -- #settings <group_id>
    -- #type
    -- #kill group|supergroup|realm <group_id>
    -- #rem <group_id>
    -- #support <user_id>|<username>
    -- #-support <user_id>|<username>
    -- #list admins|groups|realms
    -- SUDO
    -- #addadmin <user_id>|<username>
    -- #removeadmin <user_id>|<username>
}