local help_text_pm = "Welcome to TeleSeed!\n\n" ..
"To get a list of TeleSeed groups use /chats or /chatlist for a document list of chats.\n\n" ..
"To get a new TeleSeed group, contact a support group:\n\n" ..
"For English support, use: /join English support\n\n" ..
"For Persian support, use: /join Persian support\n\n" ..
"For more information, check out our channels:\n\n" ..
"@TeleseedCH [English]\n@Iranseed [Persian]\n\n" ..
"Thanks for using @TeleSeed!"

local help_text_group = "Commands list :\n\n" ..
"!kick [username|id]\n" ..
"You can also do it by reply\n\n" ..
"!ban [ username|id]\n" ..
"You can also do it by reply\n\n" ..
"!unban [id]\n" ..
"You can also do it by reply\n\n" ..
"!who\n" ..
"Members list\n\n" ..
"!modlist\n" ..
"Moderators list\n\n" ..
"!promote [username]\n" ..
"Promote someone\n\n" ..
"!demote [username]\n" ..
"Demote someone\n\n" ..
"!kickme\n" ..
"Will kick user\n\n" ..
"!about\n" ..
"Group description\n\n" ..
"!setphoto\n" ..
"Set and locks group photo\n\n" ..
"!setname [name]\n" ..
"Set group name\n\n" ..
"!rules\n" ..
"Group rules\n\n" ..
"!id\n" ..
"return group id or user id\n\n" ..
"!help\n" ..
"Returns help text\n\n" ..
"!lock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]\n" ..
"Lock group settings\n" ..
"*rtl: Kick user if Right To Left Char. is in name*\n\n" ..
"!unlock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]\n" ..
"Unlock group settings\n" ..
"*rtl: Kick user if Right To Left Char. is in name*\n\n" ..
"!mute [all|audio|gifs|photo|video]\n" ..
"mute group message types\n" ..
"*If \"muted\" message type: user is kicked if message type is posted\n\n" ..
"!unmute [all|audio|gifs|photo|video]\n" ..
"Unmute group message types\n" ..
"*If \"unmuted\" message type: user is not kicked if message type is posted\n\n" ..
"!set rules <text>\n" ..
"Set <text> as rules\n\n" ..
"!set about <text>\n" ..
"Set <text> as about\n\n" ..
"!settings\n" ..
"Returns group settings\n\n" ..
"!muteslist\n" ..
"Returns mutes for chat\n\n" ..
"!muteuser [username]\n" ..
"Mute a user in chat\n" ..
"*user is kicked if they talk\n" ..
"*only owners can mute | mods and owners can unmute\n\n" ..
"!mutelist\n" ..
"Returns list of muted users in chat\n\n" ..
"!newlink\n" ..
"create/revoke your group link\n\n" ..
"!link\n" ..
"returns group link\n\n" ..
"!owner\n" ..
"returns group owner id\n\n" ..
"!setowner [id]\n" ..
"Will set id as owner\n\n" ..
"!setflood [value]\n" ..
"Set [value] as flood sensitivity\n\n" ..
"!stats\n" ..
"Simple message statistics\n\n" ..
"!save [value] <text>\n" ..
"Save <text> as [value]\n\n" ..
"!get [value]\n" ..
"Returns text of [value]\n\n" ..
"!clean [modlist|rules|about]\n" ..
"Will clear [modlist|rules|about] and set it to nil\n\n" ..
"!res [username]\n" ..
"returns user id\n" ..
"\"!res @username\"\n\n" ..
"!log\n" ..
"Returns group logs\n\n" ..
"!banlist\n" ..
"will return group ban list\n\n" ..
"**You can use \"#\", \"!\", or \"/\" to begin all commands\n\n\n" ..
"*Only owner and mods can add bots in group\n\n\n" ..
"*Only moderators and owner can use kick,ban,unban,newlink,link,setphoto,setname,lock,unlock,set rules,set about and settings commands\n\n\n" ..
"*Only owner can use res,setowner,promote,demote and log commands"

local help_text_realm = "Realm Commands:\n\n" ..
"!creategroup [Name]\n" ..
"Create a group\n\n" ..
"!createrealm [Name]\n" ..
"Create a realm\n\n" ..
"!setname [Name]\n" ..
"Set realm name\n\n" ..
"!setabout [group|sgroup] [GroupID] [Text]\n" ..
"Set a group's about text\n\n" ..
"!setrules [GroupID] [Text]\n" ..
"Set a group's rules\n\n" ..
"!lock [GroupID] [setting]\n" ..
"Lock a group's setting\n\n" ..
"!unlock [GroupID] [setting]\n" ..
"Unlock a group's setting\n\n" ..
"!settings [group|sgroup] [GroupID]\n" ..
"Set settings for GroupID\n\n" ..
"!wholist\n" ..
"Get a list of members in group/realm\n\n" ..
"!who\n" ..
"Get a file of members in group/realm\n\n" ..
"!type\n" ..
"Get group type\n\n" ..
"!kill chat [GroupID]\n" ..
"Kick all memebers and delete group\n\n" ..
"!kill realm [RealmID]\n" ..
"Kick all members and delete realm\n\n" ..
"!addadmin [id|username]\n" ..
"Promote an admin by id OR username *Sudo only\n\n" ..
"!removeadmin [id|username]\n" ..
"Demote an admin by id OR username *Sudo only\n\n" ..
"!list groups\n" ..
"Get a list of all groups\n\n" ..
"!list realms\n" ..
"Get a list of all realms\n\n" ..
"!support\n" ..
"Promote user to support\n\n" ..
"!-support\n" ..
"Demote user from support\n\n" ..
"!log\n" ..
"Get a logfile of current group or realm\n\n" ..
"!broadcast [text]\n" ..
"!broadcast Hello !\n" ..
"Send text to all groups\n" ..
"Only sudo users can run this command\n\n" ..
"!bc [group_id] [text]\n" ..
"!bc 123456789 Hello !\n" ..
"This command will send text to [group_id]\n\n\n" ..
"**You can use \"#\", \"!\", or \"/\" to begin all commands\n\n\n" ..
"*Only admins and sudo can add bots in group\n\n\n" ..
"*Only admins and sudo can use kick,ban,unban,newlink,setphoto,setname,lock,unlock,set rules,set about and settings commands\n\n" ..
"*Only admins and sudo can use res, setowner, commands"

local help_text_super = "SuperGroup Commands:\n\n" ..
"!info\n" ..
"Displays general info about the SuperGroup\n\n" ..
"!admins\n" ..
"Returns SuperGroup admins list\n\n" ..
"!owner\n" ..
"Returns group owner\n\n" ..
"!modlist\n" ..
"Returns Moderators list\n\n" ..
"!bots\n" ..
"Lists bots in SuperGroup\n\n" ..
"!who\n" ..
"Lists all users in SuperGroup\n\n" ..
"!block\n" ..
"Kicks a user from SuperGroup\n" ..
"*Adds user to blocked list*\n\n" ..
"!ban\n" ..
"Bans user from the SuperGroup\n\n" ..
"!unban\n" ..
"Unbans user from the SuperGroup\n\n" ..
"!id\n" ..
"Return SuperGroup ID or user id\n\n" ..
"*For userID's: !id @username or reply !id*\n\n" ..
"!id from\n" ..
"Get ID of user message is forwarded from\n\n" ..
"!kickme\n" ..
"Kicks user from SuperGroup\n" ..
"*Must be unblocked by owner or use join by pm to return*\n\n" ..
"!setowner\n" ..
"Sets the SuperGroup owner\n\n" ..
"!promote [username|id]\n" ..
"Promote a SuperGroup moderator\n\n" ..
"!demote [username|id]\n" ..
"Demote a SuperGroup moderator\n\n" ..
"!setname\n" ..
"Sets the chat name\n\n" ..
"!setphoto\n" ..
"Sets the chat photo\n\n" ..
"!setrules\n" ..
"Sets the chat rules\n\n" ..
"!setabout\n" ..
"Sets the about section in chat info(members list)\n\n" ..
"!save [value] <text>\n" ..
"Sets extra info for chat\n\n" ..
"!get [value]\n" ..
"Retrieves extra info for chat by value\n\n" ..
"!newlink\n" ..
"Generates a new group link\n\n" ..
"!link\n" ..
"Retireives the group link\n\n" ..
"!rules\n" ..
"Retrieves the chat rules\n\n" ..
"!lock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]\n" ..
"Lock group settings\n" ..
"*rtl: Delete msg if Right To Left Char. is in name*\n" ..
"*strict: enable strict settings enforcement (violating user will be kicked)*\n\n" ..
"!unlock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]\n" ..
"Unlock group settings\n" ..
"*rtl: Delete msg if Right To Left Char. is in name*\n" ..
"*strict: disable strict settings enforcement (violating user will not be kicked)*\n\n" ..
"!mute [all|audio|gifs|photo|video|service]\n" ..
"mute group message types\n" ..
"*A \"muted\" message type is auto-deleted if posted\n\n" ..
"!unmute [all|audio|gifs|photo|video|service]\n" ..
"Unmute group message types\n" ..
"*A \"unmuted\" message type is not auto-deleted if posted\n\n" ..
"!setflood [value]\n" ..
"Set [value] as flood sensitivity\n\n" ..
"!settings\n" ..
"Returns chat settings\n" ..
"!muteslist\n" ..
"Returns mutes for chat\n\n" ..
"!muteuser [username]\n" ..
"Mute a user in chat\n" ..
"*If a muted user posts a message, the message is deleted automaically\n" ..
"*only owners can mute | mods and owners can unmute\n\n" ..
"!mutelist\n" ..
"Returns list of muted users in chat\n\n" ..
"!banlist\n" ..
"Returns SuperGroup ban list\n\n" ..
"!clean [rules|about|modlist|mutelist]\n\n" ..
"!del\n" ..
"Deletes a message by reply\n\n" ..
"!public [yes|no]\n" ..
"Set chat visibility in pm !chats or !chatlist commands\n\n" ..
"!res [username]\n" ..
"Returns users name and id by username\n\n\n" ..
"!log\n" ..
"Returns group logs\n" ..
"*Search for kick reasons using [#RTL|#spam|#lockmember]\n\n" ..
"**You can use \"#\", \"!\", or \"/\" to begin all commands\n\n" ..
"*Only owner can add members to SuperGroup\n" ..
"(use invite link to invite)\n\n" ..
"*Only moderators and owner can use block, ban, unban, newlink, link, setphoto, setname, lock, unlock, setrules, setabout and settings commands\n\n" ..
"*Only owner can use res, setowner, promote, demote, and log commands"

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

-- !help all command
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
    if matches[1] == 'seedpmhelp' then
        return help_text_pm
    end

    if matches[1] == 'seedgrouphelp' then
        return help_text_group
    end

    if matches[1]:lower() == 'seedrealmhelp' then
        return help_text_realm
    end

    if matches[1] == 'seedsupergrouphelp' then
        return help_text_super
    end

    local text = 'Ogni \'/\' può essere sostituito con i simboli \'!\' o \'#\'.\n' ..
    'Tutti i comandi sono Case Insensitive.\n' ..
    'Le parentesi quadre significano opzionale.\n' ..
    'Le parentesi tonde indicano una scelta evidenziata da \'|\' che significa "oppure".\n'
    table.sort(plugins)
    if (matches[1]:lower() == "help" and not matches[2]) or(matches[1]:lower() == "sasha aiuto" and not matches[2]) then
        text = telegram_help()
    elseif matches[1]:lower() == "helpall" or(matches[1]:lower() == "sasha aiuto tutto" and not matches[2]) then
        text = help_all(get_receiver(msg))
    else
        text = plugin_help(matches[2], get_receiver(msg))
        if not text then
            text = telegram_help()
        end
    end
    send_large_msg(get_receiver(msg), text)
end

return {
    description = "HELP",
    usage = "/help|sasha aiuto [all|tutto|<plugin_name>|<plugin_number>]: Sasha mostra una lista dei plugin disponibili o tutti gli aiuti di tutti i plugin o l'aiuto del plugin specificato. Per ottenere gli help originali scrivere \"[#!/]seed<type>help\".",
    patterns =
    {
        "^[#!/]([hH][eE][lL][pP])$",
        "^[#!/]([hH][eE][lL][pP] [aA][lL][lL])$",
        "^[#!/]([hH][eE][lL][pP]) (.+)",
        -- help
        -- "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][sS])$",
        -- "^[#!/]([Cc][Oo][Mm][Mm][Aa][Nn][Dd][sS]) (.+)",
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO])$",
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO] [tT][uU][tT][tT][oO])$",
        "^([sS][aA][sS][hH][aA] [aA][iI][uU][tT][oO]) (.+)",
        -- original helps
        "^[#!/]?([sS][eE][eE][dD][pP][mM][hH][eE][lL][pP])$",
        "^[#!/]?([sS][eE][eE][dD][gG][rR][oO][uU][pP][hH][eE][lL][pP])$",
        "^[#!/]?([sS][eE][eE][dD][rR][eE][aA][lL][mM][hH][eE][lL][pP])$",
        "^[#!/]?([sS][eE][eE][dD][sS][uU][pP][eE][rR][gG][rR][oO][uU][pP][hH][eE][lL][pP])$",
    },
    run = run
}