package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
.. ';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

local f = assert(io.popen('/usr/bin/git describe --tags', 'r'))
VERSION = assert(f:read('*a'))
f:close()

-- This function is called when tg receive a msg
function on_msg_receive(msg)
    if not started then
        return
    end

    msg = backward_msg_format(msg)

    -- Group language
    msg.lang = redis:get('lang:' .. msg.to.id)
    if not msg.lang then
        redis:set('lang:' .. msg.to.id, 'it')
        msg.lang = 'it'
    end

    local receiver = get_receiver(msg)
    print(receiver)
    -- reaction writing
    if redis:get('writing') then
        send_typing(receiver, ok_cb, false)
    else
        send_typing_abort(receiver, ok_cb, false)
    end
    -- vardump(msg)
    msg = pre_process_service_msg(msg)
    if msg_valid(msg) then
        msg = pre_process_msg(msg)
        if msg then
            match_plugins(msg)
            if redis:get("bot:markread") then
                if redis:get("bot:markread") == "on" then
                    mark_read(receiver, ok_cb, false)
                end
            end
        end
    end
    -- check sudo tag
    check_tag(msg)
end

local function callback_sudo_ids(extra, success, result)
    -- check if username is in message
    local tagged = false
    if result.username then
        if extra.msg.text then
            if string.find(extra.msg.text:lower(), '@' .. result.username:lower()) or string.find(extra.msg.text, result.first_name) then
                tagged = true
            end
        end
        if extra.msg.media then
            if extra.msg.media.title then
                if string.find(extra.msg.media.title:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.title, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.description then
                if string.find(extra.msg.media.description:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.description, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.caption then
                if string.find(extra.msg.media.caption:lower(), '@' .. result.username:lower()) or string.find(extra.msg.media.caption, result.first_name) then
                    tagged = true
                end
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                if string.find(extra.msg.fwd_from.title:lower(), '@' .. result.username:lower()) or string.find(extra.msg.fwd_from.title, result.first_name) then
                    tagged = true
                end
            end
        end
    else
        if extra.msg.text then
            if string.find(extra.msg.text, result.first_name) then
                tagged = true
            end
        end
        if extra.msg.media then
            if extra.msg.media.title then
                if string.find(extra.msg.media.title, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.description then
                if string.find(extra.msg.media.description, result.first_name) then
                    tagged = true
                end
            end
            if extra.msg.media.caption then
                if string.find(extra.msg.media.caption, result.first_name) then
                    tagged = true
                end
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                if string.find(extra.msg.fwd_from.title, result.first_name) then
                    tagged = true
                end
            end
        end
    end
    if tagged then
        local text = langs.receiver .. extra.msg.to.print_name:gsub("_", " ") .. ' [' .. extra.msg.to.id .. ']\n' .. langs.sender
        if extra.msg.from.username then
            text = text .. '@' .. extra.msg.from.username .. ' [' .. extra.msg.from.id .. ']\n'
        else
            text = text .. extra.msg.from.print_name:gsub("_", " ") .. ' [' .. extra.msg.from.id .. ']\n'
        end
        text = text .. langs.msgText

        if extra.msg.text then
            text = text .. extra.msg.text .. ' '
        end
        if extra.msg.media then
            if extra.msg.media.title then
                text = text .. extra.msg.media.title
            end
            if extra.msg.media.description then
                text = text .. extra.msg.media.description
            end
            if extra.msg.media.caption then
                text = text .. extra.msg.media.caption
            end
        end
        if extra.msg.fwd_from then
            if extra.msg.fwd_from.title then
                text = text .. extra.msg.fwd_from.title
            end
        end
        send_large_msg('user#id' .. extra.user, text)
    end
end

-- send message to sudoers when tagged
function check_tag(msg)
    if msg then
        -- exclude private chats with bot
        if (msg.to.type == 'chat' or msg.to.type == 'channel') then
            -- exclude bot tags and autotags
            for v, user in pairs(_config.sudo_users) do
                if tonumber(msg.from.id) ~= tonumber(our_id) and tonumber(msg.from.id) ~= tonumber(user) then
                    user_info('user#id' .. user, callback_sudo_ids, { msg = msg, user = user })
                end
            end
        end
    end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
    started = true
    postpone(cron_plugins, false, 60 * 5.0)
    -- See plugins/isup.lua as an example for cron

    _config = load_config()

    -- load plugins
    plugins = { }
    load_plugins()
end

function msg_valid(msg)
    local valid = false

    -- Don't process outgoing messages
    if msg.out then
        if not msg.fwd_from then
            if msg.text then
                if string.match(msg.text, '^[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc] (.*)$') then
                    valid = true
                end
            end
        end
        if not valid then
            print('\27[36mNot valid: msg from us\27[39m')
            return false
        end
    end

    -- Before bot was started
    if msg.date < os.time() -5 then
        print('\27[36mNot valid: old msg\27[39m')
        return false
    end

    if msg.unread == 0 then
        print('\27[36mNot valid: readed\27[39m')
        return false
    end

    if not msg.to.id then
        print('\27[36mNot valid: to id not provided\27[39m')
        return false
    end

    if not msg.from.id then
        print('\27[36mNot valid: from id not provided\27[39m')
        return false
    end

    if msg.from.id == our_id then
        if valid then
            msg.text = string.gsub(msg.text, '[Aa][Uu][Tt][Oo][Ee][Xx][Ee][Cc] ', '')
        else
            print('\27[36mNot valid: msg from our id\27[39m')
            return false
        end
    end

    if msg.to.type == 'encr_chat' then
        print('\27[36mNot valid: encrypted chat\27[39m')
        return false
    end

    -- if message from telegram it will be sent to REALM
    if msg.from.id == 777000 then
        send_large_msg('chat#id117401051', msg.text)
        return false
    end

    if is_channel_disabled(receiver) and not is_momod(msg) then
        print('\27[36mNot valid: channel disabled\27[39m')
        return false
    end

    return true
end

function pre_process_service_msg(msg)
    if msg.service then
        local action = msg.action or { type = "" }
        -- Double ! to discriminate of normal actions
        msg.text = "!!tgservice " .. action.type

        -- wipe the data to allow the bot to read service messages
        if msg.out then
            msg.out = false
        end
        if msg.from.id == our_id then
            msg.from.id = 0
        end
    end
    return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
    for name, plugin in pairs(plugins) do
        if plugin.pre_process and msg then
            print('Preprocess', name)
            msg = plugin.pre_process(msg)
        end
    end
    return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
    for name, plugin in pairs(plugins) do
        match_plugin(plugin, name, msg)
    end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
    local disabled_chats = _config.disabled_plugin_on_chat
    -- Table exists and chat has disabled plugins
    if disabled_chats and disabled_chats[receiver] then
        -- Checks if plugin is disabled on this chat
        for disabled_plugin, disabled in pairs(disabled_chats[receiver]) do
            if disabled_plugin == plugin_name and disabled then
                local warning = 'Plugin ' .. disabled_plugin .. ' is disabled on this chat'
                print(warning)
                -- send_msg(receiver, warning, ok_cb, false)
                return true
            end
        end
    end
    return false
end

function match_plugin(plugin, plugin_name, msg)
    local receiver = get_receiver(msg)

    -- Go over patterns. If one matches it's enough.
    for k, pattern in pairs(plugin.patterns) do
        local matches = match_pattern(pattern, msg.text)
        if matches then
            print("msg matches: ", plugin_name, " => ", pattern)

            local disabled = is_plugin_disabled_on_chat(plugin_name, receiver)

            if pattern ~= "([\216-\219][\128-\191])" and pattern ~= "!!tgservice (.*)" and pattern ~= "(%[(document)%])" and pattern ~= "(%[(photo)%])" and pattern ~= "(%[(video)%])" and pattern ~= "(%[(audio)%])" and pattern ~= "(%[(contact)%])" and pattern ~= "(%[(geo)%])" then
                if msg.to.type == 'user' then
                    if disabled then
                        savelog(msg.from.id .. ' PM', msg.from.print_name:gsub('_', ' ') .. ' ID: ' .. '[' .. msg.from.id .. ']' .. '\nCommand "' .. msg.text .. '" received but plugin is disabled on chat.')
                    else
                        savelog(msg.from.id .. ' PM', msg.from.print_name:gsub('_', ' ') .. ' ID: ' .. '[' .. msg.from.id .. ']' .. '\nCommand "' .. msg.text .. '" executed.')
                    end
                else
                    if disabled then
                        savelog(msg.to.id, msg.to.print_name:gsub('_', ' ') .. ' ID: ' .. '[' .. msg.to.id .. ']' .. ' Sender: ' .. msg.from.print_name:gsub('_', ' ') .. ' [' .. msg.from.id .. ']' .. '\nCommand "' .. msg.text .. '" received but plugin is disabled on chat.')
                    else
                        savelog(msg.to.id, msg.to.print_name:gsub('_', ' ') .. ' ID: ' .. '[' .. msg.to.id .. ']' .. ' Sender: ' .. msg.from.print_name:gsub('_', ' ') .. ' [' .. msg.from.id .. ']' .. '\nCommand "' .. msg.text .. '" executed.')
                    end
                end
            end

            if disabled then
                return nil
            end
            -- Function exists
            if plugin.run then
                local result = plugin.run(msg, matches)
                if result then
                    send_large_msg(receiver, result)
                end
            end
            -- One patterns matches
            return
        end
    end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
    send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config()
    serialize_to_file(_config, './data/config.lua', false)
    print('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config()
    local f = io.open('./data/config.lua', "r")
    -- If config.lua doesn't exist
    if not f then
        print("Created new config file: data/config.lua")
        create_config()
    else
        f:close()
    end
    local config = loadfile("./data/config.lua")()
    for v, user in pairs(config.sudo_users) do
        print("Sudo user: " .. user)
    end
    return config
end

-- Create a basic config.json file and saves it.
function create_config()
    -- A simple config with basic plugins and ourselves as privileged user
    config = {
        enabled_plugins =
        {
            "anti_spam",
            "msg_checks",
            "onservice",
            "strings_it",
            "strings_en",
            "preprocess_media",
            "administrator",
            "bot",
            "inrealm",
            "ingroup",
            "inpm",
            "banhammer",
            "stats",
            "plugins",
            "owners",
            "arabic_lock",
            "set",
            "unset",
            "help",
            "get",
            "broadcast",
            "invite",
            "info",
            "leave_ban",
            "supergroup",
            "whitelist",
            "feedback",
            "tagall",
            "duckduckgo",
            "goodbyewelcome",
        },
        sudo_users =
        {
            41400331,
            149998353-- bot id for autoexec command
        },
        -- Sudo users
        moderation = { data = 'data/moderation.json' },
        ruleta = { db = 'data/ruletadb.json' },
        knife = { db = 'data/knifedb.json' },
        clicktap = { db = 'data/clicktapdb.json' },
        likecounter = { db = 'data/likecounterdb.json' },
        about_text = "AISashaSuper by @EricSolinas based on TeleSeed supergroup branch and something of DBTeam.\nThanks guys.",
    }
    serialize_to_file(config, './data/config.lua', false)
    print('saved config into ./data/config.lua')
end

function on_our_id(id)
    our_id = id
end

function on_user_update(user, what)
    -- vardump (user)
end

function on_chat_update(chat, what)
    -- vardump (chat)
end

function on_secret_chat_update(schat, what)
    -- vardump (schat)
end

function on_get_difference_end()
end

-- Enable plugins in config.json
function load_plugins()
    print('Loading languages.lua...')
    langs = dofile('languages.lua')
    -- All the languages available

    for k, v in pairs(_config.enabled_plugins) do
        print("Loading plugin", v)

        local ok, err = pcall( function()
            local t = loadfile("plugins/" .. v .. '.lua')()
            plugins[v] = t
        end )

        if not ok then
            print('\27[31mError loading plugin ' .. v .. '\27[39m')
            print(tostring(io.popen("lua plugins/" .. v .. ".lua"):read('*all')))
            print('\27[31m' .. err .. '\27[39m')
        end

    end
end

-- custom add
function load_data(filename)
    local f = io.open(filename)
    if not f then
        return { }
    end
    local s = f:read('*all')
    f:close()
    local data = JSON.decode(s)

    return data
end

function save_data(filename, data)
    local s = JSON.encode(data)
    local f = io.open(filename, 'w')
    f:write(s)
    f:close()
end


-- Call and postpone execution for cron plugins
function cron_plugins()
    for name, plugin in pairs(plugins) do
        -- Only plugins with cron function
        if plugin.cron ~= nil then
            plugin.cron()
        end
    end

    -- Called again in 2 mins
    postpone(cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false