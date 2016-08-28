local function check_time(not_hour)
    if tonumber(not_hour) < 0 or tonumber(not_hour) >= 60 then
        return false
    end
    return true
end

local function run(msg, matches)
    if msg.to.type == 'channel' then
        if matches[1]:lower() == 'tempmsg' or matches[1]:lower() == 'sasha temporizza' or matches[1]:lower() == 'temporizza' then
            if is_momod(msg) then
                local hours, minutes, seconds = false
                local vhours, vminutes, vseconds = -1
                if matches[6] then
                    -- X hour Y minutes OR X hour Y seconds OR X minutes Y seconds
                    if matches[3]:lower() == 'h' then
                        hours = true
                        vhours = tonumber(matches[2])
                    elseif matches[3]:lower() == 'm' then
                        if check_time(matches[2]) then
                            minutes = true
                            vminutes = tonumber(matches[2])
                        else
                            return langs[msg.lang].wrongTimeFormat
                        end
                    end
                    if matches[5]:lower() == 'm' then
                        if not minutes then
                            if check_time(matches[4]) then
                                minutes = true
                                vminutes = tonumber(matches[4])
                            else
                                return langs[msg.lang].wrongTimeFormat
                            end
                        else
                            -- X minutes Y minutes (ERROR)
                            return langs[msg.lang].wrongTimeFormat
                        end
                    elseif matches[5]:lower() == 's' then
                        if check_time(matches[4]) then
                            seconds = true
                            vseconds = tonumber(matches[4])
                        else
                            return langs[msg.lang].wrongTimeFormat
                        end
                    end
                elseif matches[5] then
                    -- X hour Y minutes Z seconds
                    hours = true
                    vhours = tonumber(matches[3])
                    if check_time(matches[4]) and check_time(matches[5]) then
                        minutes = true
                        vminutes = tonumber(matches[4])
                        seconds = true
                        vseconds = tonumber(matches[5])
                    else
                        return langs[msg.lang].wrongTimeFormat
                    end
                elseif matches[4] then
                    -- X hour OR X minutes OR X seconds
                    if matches[3]:lower() == 'h' then
                        hours = true
                        vhours = tonumber(matches[2])
                    elseif matches[3]:lower() == 'm' then
                        if check_time(matches[2]) then
                            minutes = true
                            vminutes = tonumber(matches[2])
                        else
                            return langs[msg.lang].wrongTimeFormat
                        end
                    elseif matches[3]:lower() == 's' then
                        if check_time(matches[2]) then
                            seconds = true
                            vseconds = tonumber(matches[2])
                        else
                            return langs[msg.lang].wrongTimeFormat
                        end
                    end
                end
                local tot_seconds = 0
                if hours and vhours ~= -1 then
                    tot_seconds = tot_seconds +(vhours * 60 * 60)
                end
                if minutes and vminutes ~= -1 then
                    tot_seconds = tot_seconds +(vminutes * 60)
                end
                if seconds and vseconds ~= -1 then
                    tot_seconds = tot_seconds + vseconds
                end
                redis:set('temp:' .. msg.to.id, msg.id)
                redis:setex(msg.to.id, tot_seconds, msg.id)
            else
                return langs[msg.lang].require_mod
            end
        end
    end
end

local function pre_process(msg)
    if redis:get('temp:' .. msg.to.id) then
        -- if there was a tempmsg
        if not redis:get(msg.to.id) then
            -- if the time is finished
            delete_msg(redis:get('temp:' .. msg.to.id), ok_cb, false)
            redis:del('temp:' .. msg.to.id)
        end
    end
    return msg
end

return {
    description = "TEMPMESSAGE",
    patterns =
    {
        -- X hour Y minutes OR X hour Y seconds OR X minutes Y seconds
        -- X minutes Y minutes (ERROR)
        "^[#!/]([Tt][Ee][Mm][Pp][Mm][Ss][Gg]) (%d+)([HhMm]) (%d+)([MmSs]) (.*)$",
        -- X hour Y minutes Z seconds
        "^[#!/]([Tt][Ee][Mm][Pp][Mm][Ss][Gg]) (%d+) (%d+) (%d+) (.*)$",
        -- X hour OR X minutes OR X seconds
        "^[#!/]([Tt][Ee][Mm][Pp][Mm][Ss][Gg]) (%d+)([HhMmSs]) (.*)$",
        -- tempmsg
        "^[#!/]([Ss][Aa][Ss][Hh][Aa] [Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+)([HhMm]) (%d+)([MmSs]) (.*)$",
        "^[#!/]([Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+)([HhMm]) (%d+)([MmSs]) (.*)$",
        "^[#!/]([Ss][Aa][Ss][Hh][Aa] [Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+) (%d+) (%d+) (.*)$",
        "^[#!/]([Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+) (%d+) (%d+) (.*)$",
        "^[#!/]([Ss][Aa][Ss][Hh][Aa] [Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+)([HhMmSs]) (.*)$",
        "^[#!/]([Tt][Ee][Mm][Pp][Oo][Rr][Ii][Zz][Aa]) (%d+)([HhMmSs]) (.*)$",
    },
    pre_process = pre_process,
    run = run,
    min_rank = 0,
    syntax =
    {
        "MOD",
        "(#tempmsg|[sasha] temporizza) <hour>|<minutes>(h|m) <minutes>|<seconds>(m|s) <text>",
        "(#tempmsg|[sasha] temporizza) <hour> <minutes> <seconds> <text>",
        "(#tempmsg|[sasha] temporizza) <hour>|<minutes>|<seconds>(h|m|s) <text>",
    },
}