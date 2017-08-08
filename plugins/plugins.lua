-- Returns the key (index) in the config.enabled_plugins table
local function plugin_enabled(plugin_name)
    for k, v in pairs(_config.enabled_plugins) do
        if plugin_name == v then
            return k
        end
    end
    -- If not found
    return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists(plugin_name)
    for k, v in pairs(plugins_names()) do
        if plugin_name .. '.lua' == v then
            return true
        end
    end
    return false
end

-- Returns true if it is a system plugin
local function system_plugin(p)
    if p == 'administrator' or
        p == 'anti_spam' or
        p == 'banhammer' or
        p == 'bot' or
        p == 'check_tag' or
        p == 'database' or
        p == 'feedback' or
        p == 'filemanager' or
        p == 'goodbyewelcome' or
        p == 'group_management' or
        p == 'info' or
        p == 'lua_exec' or
        p == 'msg_checks' or
        p == 'plugins' or
        p == 'strings' or
        p == 'whitelist' then
        return true
    end
    return false
end

local function plugin_disabled_on_chat(plugin_name, chat_id)
    if not _config.disabled_plugin_on_chat then
        return false
    end
    if not _config.disabled_plugin_on_chat[chat_id] then
        return false
    end
    return _config.disabled_plugin_on_chat[chat_id][plugin_name]
end

local function list_plugins_sudo()
    local text = ''
    for k, v in pairs(plugins_names()) do
        --  ✅ enabled, ☑️ disabled
        local status = '☑️'
        -- get the name
        v = string.match(v, "(.*)%.lua")
        -- Check if enabled
        if plugin_enabled(v) then
            status = '✅'
        end
        -- Check if system plugin
        if system_plugin(v) then
            status = '💻'
        end
        text = text .. k .. '. ' .. status .. ' ' .. v .. '\n'
    end
    return text
end

local function list_plugins(chat_id)
    local text = ''
    for k, v in pairs(plugins_names()) do
        --  ✅ enabled, ☑️ disabled
        local status = '☑️'
        -- get the name
        v = string.match(v, "(.*)%.lua")
        -- Check if is enabled
        if plugin_enabled(v) then
            status = '✅'
        end
        -- Check if system plugin, if not check if disabled on chat
        if system_plugin(v) then
            status = '💻'
        elseif plugin_disabled_on_chat(v, chat_id) then
            status = '🚫'
        end
        text = text .. k .. '. ' .. status .. ' ' .. v .. '\n'
    end
    return text
end

local function reload_plugins()
    plugins = { }
    load_plugins()
    return list_plugins_sudo()
end

local function enable_plugin(plugin_name, chat_id)
    local lang = get_lang(chat_id)
    -- Check if plugin is enabled
    if plugin_enabled(plugin_name) then
        return '✔️ ' .. plugin_name .. langs[lang].alreadyEnabled
    end
    -- Checks if plugin exists
    if plugin_exists(plugin_name) then
        -- Add to the config table
        table.insert(_config.enabled_plugins, plugin_name)
        print(plugin_name .. ' added to config table')
        save_config()
        -- Reload the plugins
        reload_plugins()
        return '✅ ' .. plugin_name .. langs[lang].enabled
    else
        return '❔ ' .. plugin_name .. langs[lang].notExists
    end
end

local function disable_plugin(plugin_name, chat_id)
    local lang = get_lang(chat_id)
    -- Check if plugins exists
    if not plugin_exists(plugin_name) then
        return '❔ ' .. plugin_name .. langs[lang].notExists
    end
    local k = plugin_enabled(plugin_name)
    -- Check if plugin is enabled
    if not k then
        return '✖️ ' .. plugin_name .. langs[lang].alreadyDisabled
    end
    -- Disable and reload
    table.remove(_config.enabled_plugins, k)
    save_config()
    reload_plugins()
    return '☑️ ' .. plugin_name .. langs[lang].disabled
end

local function disable_plugin_on_chat(plugin_name, receiver)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not plugin_exists(plugin_name) then
        return '❔ ' .. plugin_name .. langs[lang].notExists
    end

    if not _config.disabled_plugin_on_chat then
        _config.disabled_plugin_on_chat = { }
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        _config.disabled_plugin_on_chat[receiver] = { }
    end

    _config.disabled_plugin_on_chat[receiver][plugin_name] = true

    save_config()
    return '🚫 ' .. plugin_name .. langs[lang].disabledOnChat
end

local function reenable_plugin_on_chat(plugin_name, receiver)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not _config.disabled_plugin_on_chat then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver][plugin_name] then
        return langs[lang].pluginNotDisabled
    end

    _config.disabled_plugin_on_chat[receiver][plugin_name] = false
    save_config()
    return '✅ ' .. plugin_name .. langs[lang].pluginEnabledAgain
end

local function list_disabled_plugin_on_chat(receiver)
    local lang = get_lang(string.match(receiver, '%d+'))
    if not _config.disabled_plugin_on_chat then
        return langs[lang].noDisabledPlugin
    end

    if not _config.disabled_plugin_on_chat[receiver] then
        return langs[lang].noDisabledPlugin
    end

    local status = '🚫'
    local text = ''
    for k in pairs(_config.disabled_plugin_on_chat[receiver]) do
        if _config.disabled_plugin_on_chat[receiver][k] == true then
            text = text .. status .. ' ' .. k .. '\n'
        end
    end
    return text
end

local function run(msg, matches)
    if not msg.api_patch then
        -- Show the available plugins
        if matches[1]:lower() == 'plugins' or matches[1]:lower() == 'lista plugins' then
            local chat_plugins = false
            if matches[2] then
                chat_plugins = true
            elseif not is_sudo(msg) then
                chat_plugins = true
            end
            if chat_plugins then
                if is_owner(msg) then
                    if data[tostring(msg.to.id)] then
                        return langs[msg.lang].pluginsIntro .. '\n\n' .. list_plugins(msg.to.id)
                    else
                        return langs[msg.lang].useYourGroups
                    end
                else
                    return langs[msg.lang].require_owner
                end
            else
                return langs[msg.lang].pluginsIntro .. '\n\n' .. list_plugins_sudo()
            end
        end

        if matches[1]:lower() == 'enable' or matches[1]:lower() == 'abilita' or matches[1]:lower() == 'attiva' then
            if matches[3] then
                -- Re-enable a plugin for this chat
                if is_owner(msg) then
                    print("enable " .. matches[2] .. ' on this chat')
                    return reenable_plugin_on_chat(matches[2], get_receiver(msg))
                else
                    return langs[msg.lang].require_owner
                end
            else
                -- Enable a plugin
                if is_sudo(msg) then
                    print("enable: " .. matches[2])
                    return enable_plugin(matches[2], msg.to.id)
                else
                    return langs[msg.lang].require_sudo
                end
            end
        end

        if matches[1]:lower() == 'disable' or matches[1]:lower() == 'disabilita' or matches[1]:lower() == 'disattiva' then
            if matches[3] then
                -- Disable a plugin for this chat
                if is_owner(msg) then
                    if system_plugin(matches[2]) then
                        return langs[msg.lang].systemPlugin
                    end
                    print("disable " .. matches[2] .. ' on this chat')
                    return disable_plugin_on_chat(matches[2], get_receiver(msg))
                else
                    return langs[msg.lang].require_owner
                end
            else
                -- Disable a plugin
                if is_sudo(msg) then
                    if system_plugin(matches[2]) then
                        return langs[msg.lang].systemPlugin
                    end
                    print("disable: " .. matches[2])
                    return disable_plugin(matches[2], msg.to.id)
                else
                    return langs[msg.lang].require_sudo
                end
            end
        end

        -- Show on chat disabled plugin
        if matches[1]:lower() == 'disabledlist' or matches[1]:lower() == 'lista disabilitati' or matches[1]:lower() == 'lista disattivati' then
            if is_owner(msg) then
                return list_disabled_plugin_on_chat(get_receiver(msg))
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
    end
end

return {
    description = "PLUGINS",
    patterns =
    {
        "^[#!/]([Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
        "^[#!/]([Pp][Ll][Uu][Gg][Ii][Nn][Ss]) ([Cc][Hh][Aa][Tt])$",
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+)$",
        "^[#!/]([Ee][Nn][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[#!/]([Rr][Ee][Ll][Oo][Aa][Dd])$",
        "^[#!/]([Dd][Ii][Ss][Aa][Bb][Ll][Ee][Dd][Ll][Ii][Ss][Tt])",
        -- plugins
        "^[Ss][Aa][Ss][Hh][Aa] ([Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss]) ([Cc][Hh][Aa][Tt])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Pp][Ll][Uu][Gg][Ii][Nn][Ss]) ([Cc][Hh][Aa][Tt])$",
        -- enable
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        -- disable
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        "^([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+)$",
        "^([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+)$",
        -- enable chat
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        -- disable chat
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        "^([Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa]) ([%w_%.%-]+) ([Cc][Hh][Aa][Tt])",
        -- reload
        "^[Ss][Aa][Ss][Hh][Aa] ([Rr][Ii][Cc][Aa][Rr][Ii][Cc][Aa])$",
        "^([Rr][Ii][Cc][Aa][Rr][Ii][Cc][Aa])$",
        -- disabledlist
        "^[Ss][Aa][Ss][Hh][Aa] ([Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa][Tt][Ii])$",
        "^[Ss][Aa][Ss][Hh][Aa] ([Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa][Tt][Ii])$",
        "^[(Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Bb][Ii][Ll][Ii][Tt][Aa][Tt][Ii])$",
        "^([Ll][Ii][Ss][Tt][Aa] [Dd][Ii][Ss][Aa][Tt][Tt][Ii][Vv][Aa][Tt][Ii])$",
    },
    run = run,
    min_rank = 2,
    syntax =
    {
        "OWNER",
        "(#plugins|[sasha] lista plugins)",
        "(#disabledlist|([sasha] lista disabilitati|disattivati))",
        "(#enable|[sasha] abilita|[sasha] attiva) <plugin> chat",
        "(#disable|[sasha] disabilita|[sasha] disattiva) <plugin> chat",
        "SUDO",
        "(#plugins|[sasha] lista plugins) [chat]",
        "(#enable|[sasha] abilita|[sasha] attiva) <plugin> [chat]",
        "(#disable|[sasha] disabilita|[sasha] disattiva) <plugin> [chat]",
        "(#reload|[sasha] ricarica)",
    },
}