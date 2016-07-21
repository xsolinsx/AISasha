-- Get commands for that plugin
local function plugin_help(var, chat, rank)
    local lang = get_lang(string.match(chat, '%d+'))
    local plugin = ''
    if tonumber(var) then
        local i = 0
        for name in pairsByKeys(plugins) do
            if _config.disabled_plugin_on_chat[chat] then
                if not _config.disabled_plugin_on_chat[chat][name] or _config.disabled_plugin_on_chat[chat][name] == false then
                    i = i + 1
                    if i == tonumber(var) then
                        plugin = plugins[name]
                    end
                end
            else
                i = i + 1
                if i == tonumber(var) then
                    plugin = plugins[name]
                end
            end
        end
    else
        if _config.disabled_plugin_on_chat[chat] then
            if not _config.disabled_plugin_on_chat[chat][var] or _config.disabled_plugin_on_chat[chat][var] == false then
                plugin = plugins[var]
            end
        else
            plugin = plugins[var]
        end
    end
    if not plugin or plugin == "" then
        return nil
    end
    if plugin.min_rank <= tonumber(rank) then
        local help_permission = true
        -- '=========================\n'
        local text = ''
        -- = '=======================\n'
        local textHash = plugin.description:lower()
        if langs[lang][textHash] then
            for i = 1, #langs[lang][plugin.description:lower()], 1 do
                if rank_table[langs[lang][plugin.description:lower()][i]] then
                    if rank_table[langs[lang][plugin.description:lower()][i]] > rank then
                        help_permission = false
                    end
                end
                if help_permission then
                    text = text .. langs[lang][plugin.description:lower()][i] .. '\n'
                end
            end
        end
        return text .. '\n'
    else
        -- return text .. langs[lang].require_higher .. '\n'
        return ''
    end
end

-- !help command
local function telegram_help(receiver, rank)
    local lang = get_lang(string.match(receiver, '%d+'))
    local i = 0
    local text = langs[lang].pluginListStart
    -- Plugins names
    for name in pairsByKeys(plugins) do
        if _config.disabled_plugin_on_chat[receiver] then
            if not _config.disabled_plugin_on_chat[receiver][name] or _config.disabled_plugin_on_chat[receiver][name] == false then
                i = i + 1
                if plugins[name].min_rank <= tonumber(rank) then
                    text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
                end
            end
        else
            i = i + 1
            if plugins[name].min_rank <= tonumber(rank) then
                text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
            end
        end
    end

    text = text .. '\n' .. langs[lang].helpInfo
    return text
end

-- !helpall command
local function help_all(chat, rank)
    local ret = ""
    local i = 0
    local temp
    for name in pairsByKeys(plugins) do
        temp = plugin_help(name, chat, rank)
        if temp ~= nil then
            ret = ret .. temp
            i = i + 1
        end
    end
    return ret
end

local function get_sudo_info(extra, success, result)
    local lang = get_lang(extra.chat_id)
    local text = 'SUDO INFO'
    if result.first_name then
        text = text .. langs[lang].name .. result.first_name
    end
    if result.real_first_name then
        text = text .. langs[lang].name .. result.real_first_name
    end
    if result.last_name then
        text = text .. langs[lang].surname .. result.last_name
    end
    if result.real_last_name then
        text = text .. langs[lang].surname .. result.real_last_name
    end
    if result.username then
        text = text .. langs[lang].username .. '@' .. result.username
    end
    --[[
    if result.phone then
        text = text .. langs[lang].phone .. '+' .. string.sub(result.phone, 1, 6) .. '******'
    end
    ]]
    local msgs = tonumber(redis:get('msgs:' .. result.peer_id .. ':' .. extra.chat_id) or 0)
    text = text .. langs[lang].date .. os.date('%c') ..
    langs[lang].totalMessages .. msgs
    text = text .. '\n🆔: ' .. result.peer_id
    send_large_msg(extra.receiver, text)
end

local function run(msg, matches)
    -- if msg.to.peer_type == 'user' and not is_admin1(msg) then
    --    return langs[msg.lang].doYourBusiness
    -- end

    if matches[1]:lower() == "sudolist" or matches[1]:lower() == "sasha lista sudo" then
        for v, user in pairs(_config.sudo_users) do
            if user ~= our_id then
                user_info('user#id' .. user, get_sudo_info, { chat_id = msg.to.id, receiver = get_receiver(msg) })
            end
        end
        return
    end

    local text = langs[msg.lang].helpIntro
    local rank = get_rank(msg.from.id, msg.to.id)

    if matches[1]:lower() == "help" or matches[1]:lower() == "commands" or matches[1]:lower() == "sasha aiuto" or matches[1]:lower() == "helpall" or matches[1]:lower() == "allcommands" or matches[1]:lower() == "sasha aiuto tutto" then
        if matches[2] and(matches[2]:lower() == "user" or matches[2]:lower() == "mod" or matches[2]:lower() == "owner" or matches[2]:lower() == "support" or matches[2]:lower() == "admin" or matches[2]:lower() == "sudo") then
            local fakerank = rank_table[matches[2]:upper()]
            print(rank, fakerank)
            if fakerank <= rank then
                -- ok
                rank = fakerank
            else
                -- no
                return langs[msg.lang].youTried
            end
            text = text .. 'FAKE HELP\n'
        elseif matches[3] and(matches[3]:lower() == "user" or matches[3]:lower() == "mod" or matches[3]:lower() == "owner" or matches[3]:lower() == "support" or matches[3]:lower() == "admin" or matches[3]:lower() == "sudo") then
            local fakerank = rank_table[matches[3]:upper()]
            print(rank, fakerank)
            if fakerank <= rank then
                -- ok
                rank = fakerank
            else
                -- no
                return langs[msg.lang].youTried
            end
            text = text .. 'FAKE HELP\n'
        end
    end

    local flag = false
    if not matches[2] then
        flag = true
    elseif matches[2]:lower() == "user" or matches[2]:lower() == "mod" or matches[2]:lower() == "owner" or matches[2]:lower() == "support" or matches[2]:lower() == "admin" or matches[2]:lower() == "sudo" then
        flag = true
    end

    table.sort(plugins)
    if flag then
        if matches[1]:lower() == "helpall" or matches[1]:lower() == "allcommands" or matches[1]:lower() == "sasha aiuto tutto" then
            text = text .. help_all(get_receiver(msg), rank)
        end
        if matches[1]:lower() == "help" or matches[1]:lower() == "commands" or matches[1]:lower() == "sasha aiuto" then
            text = text .. telegram_help(get_receiver(msg), rank)
        end
    else
        local temp = plugin_help(matches[2]:lower(), get_receiver(msg), rank)
        if temp ~= nil then
            text = text .. temp
        else
            return matches[2]:lower() .. langs[msg.lang].notExists
        end
    end

    if text == langs[msg.lang].helpIntro then
        return langs[msg.lang].require_higher
    else
        send_large_msg(get_receiver(msg), text)
    end
end

return {
    description = "HELP",
    patterns =
    {
        "^[#!/]([Hh][Ee][Ll][Pp][Aa][Ll][Ll])$",
        "^[#!/]([Hh][Ee][Ll][Pp])$",
        "^[#!/]([Hh][Ee][Ll][Pp]) ([^%s]+)$",
        "^[#!/]([Ss][Uu][Dd][Oo][Ll][Ii][Ss][Tt])$",
        -- helpall
        "^[#!/]([Hh][Ee][Ll][Pp][Aa][Ll][Ll]) ([^%s]+)$",
        "^[#!/]([Aa][Ll][Ll][Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss]) ([^%s]+)$",
        "^[#!/]([Aa][Ll][Ll][Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo] [Tt][Uu][Tt][Tt][Oo]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo] [Tt][Uu][Tt][Tt][Oo])$",
        -- help
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss]) ([^%s]+)$",
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo])$",
        -- help <plugin_name>|<plugin_number>
        "^[#!/]([Hh][Ee][Ll][Pp]) ([^%s]+) ([^%s]+)$",
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss]) ([^%s]+) ([^%s]+)$",
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss]) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo]) ([^%s]+) ([^%s]+)$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo]) ([^%s]+)$",
        -- sudolist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Dd][Oo])$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- (#sudolist|sasha lista sudo)
    -- (#help|sasha aiuto)
    -- (#help|commands|sasha aiuto) <plugin_name>|<plugin_number> [<fake_rank>]
    -- (#helpall|allcommands|sasha aiuto tutto) [<fake_rank>]
}