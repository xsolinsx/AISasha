local permissions_table = {
    ["MOD"] = 1,
    ["OWNER"] = 2,
    ["SUPPORT"] = 3,
    ["ADMIN"] = 4,
    ["SUDO"] = 5
}

-- Returns true if is not empty
local function has_usage_data(dict)
    if (dict.usage == nil or dict.usage == '') then
        return false
    end
    return true
end

-- Get commands for that plugin
local function plugin_help(var, chat, rank)
    local plugin = ''
    if tonumber(var) then
        local i = 0
        for name in pairsByKeys(plugins) do
            if not _config.disabled_plugin_on_chat[receiver][name] or _config.disabled_plugin_on_chat[receiver][name] == false then
                i = i + 1
                if i == tonumber(var) then
                    plugin = plugins[name]
                end
            end
        end
    else
        plugin = plugins[var]
        if not plugin then return nil end
    end
    if plugin.min_rank <= rank then
        local help_permission = true
        -- '=========================\n'
        local text = ''
        -- = '=======================\n'
        if (type(plugin.description) == "string") then
            text = text .. '🅿️ ' .. plugin.description .. '\n'
        end
        if (type(plugin.usage) == "table") then
            for ku, usage in pairs(plugin.usage) do
                if not permissions_table[usage] then
                    if help_permission then
                        text = text .. usage .. '\n'
                    end
                elseif permissions_table[usage] > rank then
                    help_permission = false
                end
            end
        elseif has_usage_data(plugin) then
            -- Is not empty
            text = text .. plugin.usage .. '\n'
        end
        return text .. '\n'
    else
        -- return text .. lang_text('require_higher') .. '\n'
        return ''
    end
end

-- !help command
local function telegram_help(receiver)
    local i = 0
    local text = lang_text('pluginListStart')
    -- Plugins names
    for name in pairsByKeys(plugins) do
        if not _config.disabled_plugin_on_chat[receiver][name] or _config.disabled_plugin_on_chat[receiver][name] == false then
            i = i + 1
            text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
        end
    end
    text = text .. '\n' .. lang_text('helpInfo')
    return text
end

--[[
local function list_disabled_plugin_on_chat(receiver)
    if not _config.disabled_plugin_on_chat then
        return lang_text('noDisabledPlugin')
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        return lang_text('noDisabledPlugin')
    end

    local status = '❌'
    local text = ''
    for k in pairs(_config.disabled_plugin_on_chat[receiver]) do
        if _config.disabled_plugin_on_chat[receiver][k] == true then
            text = text .. status .. ' ' .. k .. '\n'
        end
    end
    return text
end]]

-- !helpall command
local function help_all(chat, rank)
    local ret = ""
    local i = 0
    for name in pairsByKeys(plugins) do
        ret = ret .. plugin_help(name, chat, rank)
        i = i + 1
    end
    return ret
end

local function run(msg, matches)
    if msg.to.peer_type == 'user' and not is_admin1(msg) then
        return lang_text('doYourBusiness')
    end

    local rank
    if not is_sudo(msg) then
        if not is_admin1(msg) then
            if not is_support(msg.from.peer_id) then
                if not is_owner(msg) then
                    if not is_momod(msg) then
                        -- user
                        rank = 0
                    else
                        -- mod
                        rank = 1
                    end
                else
                    -- owner
                    rank = 2
                end
            else
                -- support
                rank = 3
            end
        else
            -- admin
            rank = 4
        end
    else
        -- sudo
        rank = 5
    end

    local text = lang_text('helpIntro')
    table.sort(plugins)
    if not matches[2] then
        if matches[1]:lower() == "help" or matches[1]:lower() == "sasha aiuto" then
            text = text .. telegram_help(get_receiver(msg))
        end
        if matches[1]:lower() == "helpall" or matches[1]:lower() == "allcommands" or matches[1]:lower() == "sasha aiuto tutto" then
            text = text .. help_all(get_receiver(msg), rank)
        end
    else
        text = plugin_help(matches[2], get_receiver(msg), rank)
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
        "#help|sasha aiuto: Sasha mostra una lista dei plugin disponibili.",
        "#help|commands|sasha aiuto <plugin_name>|<plugin_number>: Sasha mostra l'aiuto per il plugin specificato.",
        "#helpall|allcommands|sasha aiuto tutto: Sasha mostra tutti i comandi di tutti i plugin.",
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
    run = run,
    min_rank = 0
}