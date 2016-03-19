--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--       Developers: @Josepdal & @MaSkAoS       --
--     Support: @Skneos,  @iicc1 & @serx666     --
--                                              --
--------------------------------------------------

-- Checks if bot was disabled on specific chat
local function is_channel_disabled(receiver)
    if not _config.disabled_channels then
        return false
    end

    if _config.disabled_channels[receiver] == nil then
        return false
    end

    return _config.disabled_channels[receiver]
end

local function enable_channel(receiver, to_id)
    if not _config.disabled_channels then
        _config.disabled_channels = { }
    end

    if _config.disabled_channels[receiver] == nil then
        return lang_text('botOn') .. ' 😏'
    end

    _config.disabled_channels[receiver] = false

    save_config()
    return lang_text('botOn') .. ' 😏'
end

local function disable_channel(receiver, to_id)
    if not _config.disabled_channels then
        _config.disabled_channels = { }
    end

    _config.disabled_channels[receiver] = true

    save_config()
    return lang_text('botOff') .. ' 🚀'
end

local function pre_process(msg)
    local receiver = get_receiver(msg)

    -- If sender is sudo then re-enable the channel
    if is_sudo(msg) then
        if msg.text:lower() == "#bot on" or msg.text:lower() == "!bot on" or msg.text:lower() == "/bot on" or msg.text:lower() == "sasha on" then
            enable_channel(receiver, msg.to.id)
        end
    end

    if is_channel_disabled(receiver) then
        msg.text = ""
    end

    return msg
end

local function run(msg, matches)
    if is_sudo(msg) then
        local receiver = get_receiver(msg)
        -- Enable a channel
        if matches[1]:lower() == 'on' then
            return enable_channel(receiver, msg.to.id)
        end
        -- Disable a channel
        if matches[1]:lower() == 'off' then
            return disable_channel(receiver, msg.to.id)
        end
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "BOT",
    usage =
    {
        "/bot|sasha on|off: Sasha si attiva|disattiva.",
    },
    patterns =
    {
        "^[#!/][Bb][Oo][Tt] ([Oo][Nn])",
        "^[#!/][Bb][Oo][Tt] ([Oo][Ff][Ff])",
        -- bot
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Nn])",
        "^[Ss][Aa][Ss][Hh][Aa] ([Oo][Ff][Ff])"
    },
    run = run,
    pre_process = pre_process
}
