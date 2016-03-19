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
--           Translated by: @baconnn            --
--                                              --
--------------------------------------------------

local LANG = 'it'

local function run(msg, matches)
    if is_sudo(msg) then
        update_lang()
        if matches[1]:lower() == 'install' then
            return lang_text('langInstall')
        elseif matches[1]:lower() == 'update' then
            return lang_text('langUpdate')
        end
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "SHOUT",
    usage = "/install|/update it|italian_lang: Sasha installa|aggiorna le stringhe di testp.",
    patterns =
    {
        '[#!/]([iI][nN][sS][tT][aA][lL][lL]) (italian_lang)$',
        '[#!/]([uU][pP][dD][aA][tT][eE]) (italian_lang)$',
        '[#!/]([iI][nN][sS][tT][aA][lL][lL]) ([Ii][Tt])$',
        '[#!/]([uU][pP][dD][aA][tT][eE]) ([Ii][Tt])$',
    },
    run = run
}