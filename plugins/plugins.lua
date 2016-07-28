-- Returns the key (index) in the config.enabled_plugins table
local function plugin_enabled(name)
    for k, v in pairs(_config.enabled_plugins) do
        if name == v then
            return k
        end
    end
    -- If not found
    return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists(name)
    for k, v in pairs(plugins_names()) do
        if name .. '.lua' == v then
            return true
        end
    end
    return false
end

local function list_plugins(only_enabled)
    local text = ''
    for k, v in pairs(plugins_names()) do
        --  ✅ enabled, ❌ disabled
        local status = '❌'
        -- Check if is enabled
        for k2, v2 in pairs(_config.enabled_plugins) do
            if v == v2 .. '.lua' then
                status = '✅'
            end
        end
        if not only_enabled or status == '✅' then
            -- get the name
            v = string.match(v, "(.*)%.lua")
            text = text .. status .. ' ' .. v .. '\n'
        end
    end
    return text
end

local function reload_plugins()
    plugins = { }
    load_plugins()
    return list_plugins(true)
end

local function enable_plugin(plugin_name, lang)
    print('checking if ' .. plugin_name .. ' exists')
    -- Check if plugin is enabled
    if plugin_enabled(plugin_name) then
        return '✔️ ' .. plugin_name .. langs[lang].alreadyEnabled
    end
    -- Checks if plugin exists
    if plugin_exists(plugin_name) then
        -- Add to the config table
        table.insert(_config.enabled_plugins, plugin_name)
        print(plugin_name .. ' added to _config table')
        save_config()
        -- Reload the plugins
        reload_plugins()
        return '✅ ' .. plugin_name .. langs[lang].enabled
    else
        return '❔ ' .. plugin_name .. langs[lang].notExists
    end
end

local function disable_plugin(name, lang)
    -- Check if plugins exists
    if not plugin_exists(name) then
        return '❔ ' .. name .. langs[lang].notExists
    end
    local k = plugin_enabled(name)
    -- Check if plugin is enabled
    if not k then
        return '✖️ ' .. name .. langs[lang].alreadyDisabled
    end
    -- Disable and reload
    table.remove(_config.enabled_plugins, k)
    save_config()
    reload_plugins(true)
    return '❌ ' .. name .. langs[lang].disabled
end

local function disable_plugin_on_chat(receiver, plugin)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not plugin_exists(plugin) then
        return '❔ ' .. plugin .. langs[lang].notExists
    end

    if not _config.disabled_plugin_on_chat then
        _config.disabled_plugin_on_chat = { }
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        _config.disabled_plugin_on_chat[receiver] = { }
    end

    _config.disabled_plugin_on_chat[receiver][plugin] = true

    save_config()
    return '❌ ' .. plugin .. langs[lang].disabledOnChat
end

local function reenable_plugin_on_chat(receiver, plugin)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not _config.disabled_plugin_on_chat then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver][plugin] then
        return langs[lang].pluginNotDisabled
    end

    _config.disabled_plugin_on_chat[receiver][plugin] = false
    save_config()
    return '✅ ' .. plugin .. langs[lang].pluginEnabledAgain
end

local function list_disabled_plugin_on_chat(receiver)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not _config.disabled_plugin_on_chat then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        return langs[lang].noDisabledPlugin
    end

    local status = '❌'
    local text = ''
    for k in pairs(_config.disabled_plugin_on_chat[receiver]) do
        if _config.disabled_plugin_on_chat[receiver][k] == true then
            text = text .. status .. ' ' .. k .. '\n'
        end
    end
    return text
end

local function check_plugin(plugin)
    if plugin == 'administrator' or plugin == 'anti_spam' or plugin == 'banhammer' or plugin == 'bot' or plugin == 'broadcast' or plugin == 'feedback' or plugin == 'goodbyewelcome' or plugin == 'ingroup' or plugin == 'inpm' or plugin == 'inrealm' or plugin == 'leave_ban' or plugin == 'msg_checks' or plugin == 'onservice' or plugin == 'permissions' or plugin == 'plugins' or plugin == 'preprocess_media' or plugin == 'strings' or plugin == 'supergroup' or plugin == 'whitelist' then
        return true
    end
    return false
end

local function run(msg, matches)
    if matches[3] then
        -- Re-enable a plugin for this chat
        if (matches[1]:lower() == 'enable' or matches[1]:lower() == 'sasha abilita' or matches[1]:lower() == 'sasha attiva' or matches[1]:lower() == 'abilita' or matches[1]:lower() == 'attiva') and matches[3]:lower() == 'chat' then
            if is_owner(msg) then
                local receiver = get_receiver(msg)
                local plugin = matches[2]
                print("enable " .. plugin .. ' on this chat')
                return reenable_plugin_on_chat(receiver, plugin)
            else
                return langs[msg.lang].require_owner
            end
        end

        -- Disable a plugin on a chat
        if (matches[1]:lower() == 'disable' or matches[1]:lower() == 'sasha disabilita' or matches[1]:lower() == 'sasha disattiva' or matches[1]:lower() == 'disabilita' or matches[1]:lower() == 'disattiva') and matches[3]:lower() == 'chat' then
            if is_owner(msg) then
                local plugin = matches[2]
                local receiver = get_receiver(msg)
                if check_plugin(plugin) then
                    return langs[msg.lang].systemPlugin
                end
                print("disable " .. plugin .. ' on this chat')
                return disable_plugin_on_chat(receiver, plugin)
            else
                return langs[msg.lang].require_owner
            end
        end
    end

    -- Show the available plugins
    if matches[1]:lower() == '#plugins' or matches[1]:lower() == '!plugins' or matches[1]:lower() == '/plugins' or matches[1]:lower() == 'sasha lista plugins' or matches[1]:lower() == 'lista plugins' then
        if is_owner(msg) then
            return list_plugins()
        else
            return langs[msg.lang].require_owner
        end
    end

    -- Show on chat disabled plugin
    if matches[1]:lower() == 'disabledlist' or matches[1]:lower() == 'sasha lista disabilitati' or matches[1]:lower() == 'sasha lista disattivati' or matches[1]:lower() == 'lista disabilitati' or matches[1]:lower() == 'lista disattivati' then
        if is_owner(msg) then
            local receiver = get_receiver(msg)
            return list_disabled_plugin_on_chat(receiver)
        else
            return langs[msg.lang].require_owner
        end
    end

    -- Reload all the plugins and strings!
    if matches[1]:lower() == 'reload' or matches[1]:lower() == 'sasha ricarica' or matches[1]:lower() == 'ricarica' then
        if is_sudo(msg) then
            print(reload_plugins())
            return langs[msg.lang].pluginsReloaded
        else
            return langs[msg.lang].require_sudo
        end
    end

    -- Enable a plugin
    if matches[1]:lower() == 'enable' or matches[1]:lower() == 'sasha abilita' or matches[1]:lower() == 'sasha attiva' or matches[1]:lower() == 'abilita' or matches[1]:lower() == 'attiva' then
        if is_sudo(msg) then
            local plugin_name = matches[2]
            print("enable: " .. matches[2])
            return enable_plugin(plugin_name, msg.lang)
        else
            return langs[msg.lang].require_sudo
        end
    end

    -- Disable a plugin
    if matches[1]:lower() == 'disable' or matches[1]:lower() == 'sasha disabilita' or matches[1]:lower() == 'sasha disattiva' or matches[1]:lower() == 'disabilita' or matches[1]:lower() == 'disattiva' then
        if is_sudo(msg) then
            if check_plugin(matches[2]) then
                return langs[msg.lang].systemPlugin
            end
            print("disable: " .. matches[2])
            return disable_plugin(matches[2], msg.lang)
        else
            return langs[msg.lang].require_sudo
        end
    end
end

return {
    description = "PLUGINS",
    patterns =
    {
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]$",
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]? ([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]? ([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]? ([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]? ([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/][Pp][Ll][Uu][Gg][Ii][Nn][Ss]? ([Rr][Ee][Ll][Oo][Aa][Dd])$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee][Dd][Ll][Ii][Ss][Tt])",
        -- plugins
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd])$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss]$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Rr][Ii][Cc][Aa][Rr][Ii][Cc][Aa])$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa][Tt][Ii]$",
        "^[Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa][Tt][Ii]$",
        "^[Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss]$",
        "^([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Rr][Ii][Cc][Aa][Rr][Ii][Cc][Aa])$",
        "^[Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa][Tt][Ii]$",
        "^[Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa][Tt][Ii]$",
    },
    run = run,
    min_rank = 2
    -- usage
    -- OWNER
    -- (#plugins|[sasha] lista plugins)
    -- (#disabledlist|([sasha] lista disabilitati|disattivati))
    -- (#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> chat
    -- (#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat
    -- SUDO
    -- (#[plugin[s]] enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]
    -- (#[plugin[s]] disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]
    -- (#[plugin[s]] reload|[sasha] ricarica)
}