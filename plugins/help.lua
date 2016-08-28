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
    local text = ""
    local i = 0
    local temp
    for name in pairsByKeys(plugins) do
        temp = plugin_help(name, chat, rank)
        if temp ~= nil then
            text = text .. temp
            i = i + 1
        end
    end
    return text
end

-- Get command syntax for that plugin
local function plugin_syntax(var, chat, rank)
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
        if plugin.syntax then
            for i = 1, #plugin.syntax, 1 do
                if rank_table[plugin.syntax[i]] then
                    if rank_table[plugin.syntax[i]] > rank then
                        help_permission = false
                    end
                end
                if help_permission then
                    text = text .. plugin.syntax[i] .. '\n'
                end
            end
        end
        return text .. '\n'
    else
        return ''
    end
end

-- !syntaxall command
local function syntax_all(chat, rank, filter)
    local text = ""
    local i = 0
    local temp
    for name in pairsByKeys(plugins) do
        temp = plugin_syntax(name, chat, rank, filter)
        if temp ~= nil then
            text = text .. temp
            i = i + 1
        end
    end
    return text
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
    if matches[1]:lower() == "sudolist" or matches[1]:lower() == "sasha lista sudo" then
        for v, user in pairs(_config.sudo_users) do
            if user ~= our_id then
                user_info('user#id' .. user, get_sudo_info, { chat_id = msg.to.id, receiver = get_receiver(msg) })
            end
        end
        return
    end

    table.sort(plugins)
    if matches[1]:lower() == "helpall" or matches[1]:lower() == "sasha aiuto tutto" then
        send_large_msg(get_receiver(msg), langs[msg.lang].helpIntro .. help_all(get_receiver(msg), get_rank(msg.from.id, msg.to.id)))
    end
    if matches[1]:lower() == "help" or matches[1]:lower() == "sasha aiuto" then
        if not matches[2] then
            send_large_msg(get_receiver(msg), langs[msg.lang].helpIntro .. telegram_help(get_receiver(msg), get_rank(msg.from.id, msg.to.id)))
        else
            local temp = plugin_help(matches[2]:lower(), get_receiver(msg), get_rank(msg.from.id, msg.to.id))
            if temp ~= nil then
                if temp ~= '' then
                    send_large_msg(get_receiver(msg), langs[msg.lang].helpIntro .. temp)
                else
                    return langs[msg.lang].require_higher
                end
            else
                return matches[2]:lower() .. langs[msg.lang].notExists
            end
        end
    end

    if matches[1]:lower() == "syntaxall" or matches[1]:lower() == "sasha sintassi tutto" then
        send_large_msg(get_receiver(msg), langs[msg.lang].helpIntro .. syntax_all(get_receiver(msg), get_rank(msg.from.id, msg.to.id)))
    end
    if matches[1]:lower() == "syntax" or matches[1]:lower() == "sasha sintassi" and matches[2] then
        local cmd_find = false
        for name, plugin in pairsByKeys(plugins) do
            if plugin.syntax then
                for k, v in pairsByKeys(plugin.syntax) do
                    if string.find(v, matches[2]:lower()) then
                        cmd_find = true
                        send_large_msg(get_receiver(msg), v)
                    end
                end
            end
        end
        if not cmd_find then
            send_large_msg(get_receiver(msg), langs[msg.lang].commandNotFound)
        end
    end
end

return {
    description = "HELP",
    patterns =
    {
        "^[#!/]([Hh][Ee][Ll][Pp][Aa][Ll][Ll])$",
        "^[#!/]([Hh][Ee][Ll][Pp])$",
        "^[#!/]([Hh][Ee][Ll][Pp]) ([^%s]+)$",
        "^[#!/]([Aa][Ll][Ll][Ss][Yy][Nn][Tt][Aa][Xx])$",
        "^[#!/]([Ss][Yy][Nn][Tt][Aa][Xx]) (.*)$",
        "^[#!/]([Ss][Uu][Dd][Oo][Ll][Ii][Ss][Tt])$",
        -- helpall
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo] [Tt][Uu][Tt][Tt][Oo])$",
        -- help
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo])$",
        -- help <plugin_name>|<plugin_number>
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo]) ([^%s]+)$",
        -- allsyntax
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ii][Nn][Tt][Aa][Ss][Ss][Ii] [Tt][Uu][Tt][Tt][Oo])$",
        -- syntax <filter>
        "^([Ss][Aa][Ss][Hh][Aa] [Ss][Ii][Nn][Tt][Aa][Ss][Ss][Ii]) (.*)$",
        -- sudolist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Dd][Oo])$",
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "(#sudolist|sasha lista sudo)",
        "(#help|sasha aiuto)",
        "(#help|sasha aiuto) <plugin_name>|<plugin_number>",
        "(#helpall|sasha aiuto tutto)",
        "(#syntax|sasha sintassi) <filter>",
        "(#syntaxall|sasha sintassi tutto)",
    },
}