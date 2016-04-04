-- Returns true if is not empty
local function has_usage_data(dict)
    if (dict.usage == nil or dict.usage == '') then
        return false
    end
    return true
end

-- Get commands for that plugin
local function plugin_help(var, chat)
    local plugin = ''
    if tonumber(var) then
        local i = 0
        for name in pairsByKeys(plugins) do
            i = i + 1
            if i == tonumber(var) then
                plugin = plugins[name]
            end
        end
    else
        plugin = plugins[var]
        if not plugin then return nil end
    end
    -- '=========================\n'
    local text = '=======================\n'
    if (type(plugin.description) == "string") then
        text = text .. '🅿️' .. plugin.description .. '\n\n'
    end
    if (type(plugin.usage) == "table") then
        for ku, usage in pairs(plugin.usage) do
            text = text .. usage .. '\n'
        end
    elseif has_usage_data(plugin) then
        -- Is not empty
        text = text .. plugin.usage .. '\n'
    end
    return text
end

-- !help command
local function telegram_help()
    local i = 0
    local text = lang_text('pluginListStart')
    -- Plugins names
    for name in pairsByKeys(plugins) do
        i = i + 1
        text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
    end
    text = text .. '\n' .. lang_text('helpInfo')
    return text
end

-- !helpall command
local function help_all(chat)
    local ret = ""
    local i = 0
    for name in pairsByKeys(plugins) do
        ret = ret .. plugin_help(name, chat)
        i = i + 1
    end
    return ret
end

local function run(msg, matches)
    if msg.to.peer_type == 'user' and not is_sudo(msg) then
        return lang_text('doYourBusiness')
    end

    local text = lang_text('helpIntro')
    table.sort(plugins)
    if not matches[2] then
        if matches[1]:lower() == "help" or matches[1]:lower() == "sasha aiuto" then
            text = text .. telegram_help()
        end
        if matches[1]:lower() == "helpall" or matches[1]:lower() == "allcommands" or matches[1]:lower() == "sasha aiuto tutto" then
            text = text .. help_all(get_receiver(msg))
        end
    else
        text = plugin_help(matches[2], get_receiver(msg))
        if not text then
            text = text .. telegram_help()
        end
    end
    send_large_msg(get_receiver(msg), text)
end

return {
    description = "HELP",
    usage =
    {
        "/help|allcommands|sasha aiuto: Sasha mostra una lista dei plugin disponibili.",
        "/help|commands|sasha aiuto <plugin_name>|<plugin_number>: Sasha mostra l'aiuto per il plugin specificato.",
        "/helpall|allcommands|sasha aiuto tutto: Sasha mostra tutti i comandi di tutti i plugin.",
    },
    patterns =
    {
        "^[#!/]([hH][eE][lL][pP])$",
        "^[#!/]([hH][eE][lL][pP][aA][lL][lL])$",
        "^[#!/]([hH][eE][lL][pP]) (.+)",
        "^[#!/]([Aa][Ll][Ll][Cc][Oo][Mm][Mm][Aa][Nn][Dd][sS])$",
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][sS]) (.+)",
        -- help
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO])$",
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO] [tT][uU][tT][tT][oO])$",
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO]) (.+)",
    },
    run = run
}