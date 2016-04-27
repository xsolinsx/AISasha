local rank_table = { ["USER"] = 0, ["MOD"] = 1, ["OWNER"] = 2, ["SUPPORT"] = 3, ["ADMIN"] = 4, ["SUDO"] = 5 }

local reverse_rank_table = { "USER", "MOD", "OWNER", "SUPPORT", "ADMIN", "SUDO" }

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
    if not plugin or plugin == "" then return nil end
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
                if not rank_table[usage] then
                    if help_permission then
                        text = text .. usage .. '\n'
                    end
                elseif rank_table[usage] > rank then
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
        if _config.disabled_plugin_on_chat[receiver] then
            if not _config.disabled_plugin_on_chat[receiver][name] or _config.disabled_plugin_on_chat[receiver][name] == false then
                i = i + 1
                text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
            end
        else
            i = i + 1
            text = text .. '🅿️ ' .. i .. '. ' .. name .. '\n'
        end
    end

    text = text .. '\n' .. lang_text('helpInfo')
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

local function get_rank(user_id, chat_id)
    if not is_sudo( { from = { id = user_id } }) then
        if not is_admin1( { from = { id = user_id } }) then
            if not is_support(user_id) then
                if not is_owner2(user_id, chat_id) then
                    if not is_momod2(user_id, chat_id) then
                        -- user
                        return rank_table["USER"]
                    else
                        -- mod
                        return rank_table["MOD"]
                    end
                else
                    -- owner
                    return rank_table["OWNER"]
                end
            else
                -- support
                return rank_table["SUPPORT"]
            end
        else
            -- admin
            return rank_table["ADMIN"]
        end
    else
        -- sudo
        return rank_table["SUDO"]
    end
end

local function get_rank_by_reply(extra, success, result)
    local chat = 'chat#id' .. result.to.peer_id
    local channel = 'channel#id' .. result.to.peer_id
    local rank = get_rank(result.from.peer_id, result.to.peer_id)
    send_large_msg(chat, reverse_rank_table[rank + 1])
    send_large_msg(channel, reverse_rank_table[rank + 1])
end

local function get_rank_by_username(extra, success, result)
    local rank = get_rank(result.peer_id, extra.chat_id)
    send_large_msg('chat#id' .. extra.chat_id, reverse_rank_table[rank + 1])
    send_large_msg('channel#id' .. extra.chat_id, reverse_rank_table[rank + 1])
end

local function get_sudo_info(cb_extra, success, result)
    local text = 'SUDO INFO'
    if result.first_name then
        text = text .. '\nNome: ' .. result.first_name
    end
    if result.real_first_name then
        text = text .. '\nNome: ' .. result.real_first_name
    end
    if result.last_name then
        text = text .. '\nCognome: ' .. result.last_name
    end
    if result.real_last_name then
        text = text .. '\nCognome: ' .. result.real_last_name
    end
    if result.username then
        text = text .. '\nUsername: @' .. result.username
    end
    text = text .. '\nId: ' .. result.peer_id
    send_large_msg('chat#id' .. cb_extra.msg.to.id, text)
    send_large_msg('channel#id' .. cb_extra.msg.to.id, text)
end

local function run(msg, matches)
    -- if msg.to.peer_type == 'user' and not is_admin1(msg) then
    --    return lang_text('doYourBusiness')
    -- end

    if matches[1]:lower() == "getrank" or matches[1]:lower() == "rango" then
        if type(msg.reply_id) ~= "nil" then
            return get_message(msg.reply_id, get_rank_by_reply, false)
        elseif string.match(matches[2], '^%d+$') then
            return reverse_rank_table[get_rank(matches[2], msg.to.id) + 1]
        else
            return resolve_username(string.gsub(matches[2], '@', ''), get_rank_by_username, { chat_id = msg.to.id })
        end
    end

    if matches[1]:lower() == "sudolist" or matches[1]:lower() == "sasha lista sudo" then
        for v, user in pairs(_config.sudo_users) do
            if user ~= our_id then
                user_info('user#id' .. user, get_sudo_info, { msg = msg })
            end
        end
        return
    end

    local rank = get_rank(msg.from.id, msg.to.id)

    local text = lang_text('helpIntro')
    table.sort(plugins)
    if not matches[2] then
        if matches[1]:lower() == "help" or matches[1]:lower() == "commands" or matches[1]:lower() == "sasha aiuto" then
            text = text .. telegram_help(get_receiver(msg))
        end
        if matches[1]:lower() == "helpall" or matches[1]:lower() == "allcommands" or matches[1]:lower() == "sasha aiuto tutto" then
            text = text .. help_all(get_receiver(msg), rank)
        end
    else
        text = text .. plugin_help(matches[2], get_receiver(msg), rank)
        if not text then
            text = text .. telegram_help()
        end
    end

    if text == lang_text('helpIntro') then
        return lang_text('require_higher')
    else
        send_large_msg(get_receiver(msg), text)
    end
end

return {
    description = "HELP",
    usage =
    {
        "#help|sasha aiuto: Sasha mostra una lista dei plugin disponibili.",
        "#help|commands|sasha aiuto <plugin_name>|<plugin_number>: Sasha mostra l'aiuto per il plugin specificato.",
        "#helpall|allcommands|sasha aiuto tutto: Sasha mostra tutti i comandi di tutti i plugin.",
        "#getrank: Sasha manda il rank dell'utente.",
        "#sudolist|sasha lista sudo: Sasha manda la lista dei sudo.",
    },
    patterns =
    {
        "^[#!/]([Hh][Ee][Ll][Pp])$",
        "^[#!/]([Hh][Ee][Ll][Pp][Aa][Ll][Ll])$",
        "^[#!/]([Hh][Ee][Ll][Pp]) (.+)",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk])$",
        "^[#!/]([Gg][Ee][Tt][Rr][Aa][Nn][Kk]) (.*)$",
        "^[#!/]([Ss][Uu][Dd][Oo][Ll][Ii][Ss][Tt])$",
        -- help
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo])$",
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss])",
        -- helpall
        "^[#!/]([Aa][Ll][Ll][Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo] [Tt][Uu][Tt][Tt][Oo])$",
        -- help <plugin_name>|<plugin_number>
        "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][Ss]) (.+)",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Ii][Uu][Tt][Oo]) (.+)",
        -- getrank
        "^([Rr][Aa][Nn][Gg][Oo])$",
        "^([Rr][Aa][Nn][Gg][Oo]) (.*)$",
        -- sudolist
        "^([Ss][Aa][Ss][Hh][Aa] [Ll][Ii][Ss][Tt][Aa] [Ss][Uu][Dd][Oo])$",
    },
    run = run,
    min_rank = 0
}