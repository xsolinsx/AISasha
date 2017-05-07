local function test_text(text, group_link)
    text = text:gsub(group_link:lower(), '')
    local is_now_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
    text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or text:match("[Tt]%.[Mm][Ee]/")
    or text:match("[Cc][Hh][Aa][Tt]%.[Ww][Hh][Aa][Tt][Ss][Aa][Pp][Pp]%.[Cc][Oo][Mm]/")
    return is_now_link
end

local function test_bot(text)
    text = text:gsub("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    local is_now_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
    text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or text:match("[Tt]%.[Mm][Ee]/")
    or text:match("[Cc][Hh][Aa][Tt]%.[Ww][Hh][Aa][Tt][Ss][Aa][Pp][Pp]%.[Cc][Oo][Mm]/")
    return is_now_link
end

local function check_if_link(text, group_link)
    local is_text_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
    text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or text:match("[Tt]%.[Mm][Ee]/")
    or text:match("[Cc][Hh][Aa][Tt]%.[Ww][Hh][Aa][Tt][Ss][Aa][Pp][Pp]%.[Cc][Oo][Mm]/")
    -- or text:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or text:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or text:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
    if is_text_link then
        local test_more = false
        local is_bot = text:match("?[Ss][Tt][Aa][Rr][Tt]=")
        if is_bot then
            -- if bot link test if removing that there are other links
            test_more = test_bot(text:lower())
        else
            -- if not bot link then test if there are links
            test_more = true
        end
        if test_more then
            -- if there could be other links check
            if group_link then
                if not string.find(text:lower(), group_link:lower()) then
                    -- if group link but not in text then link
                    return true
                else
                    -- test if removing group link there are other links
                    return test_text(text:lower(), group_link:lower())
                end
            else
                -- if no group_link then link
                return true
            end
        end
    end
    return false
end

local function clean_msg(msg)
    -- clean msg but returns it
    if msg.text then
        msg.text = ''
    end
    if msg.media then
        if msg.media.title then
            msg.media.title = ''
        end
        if msg.media.description then
            msg.media.description = ''
        end
        if msg.media.caption then
            msg.media.caption = ''
        end
    end
    if msg.fwd_from then
        if msg.fwd_from.title then
            msg.fwd_from.title = ''
        end
    end
    return msg
end

-- Begin pre_process function
local function pre_process(msg)
    -- Begin 'RondoMsgChecks' text checks by @rondoozle
    if msg then
        if is_group(msg) or is_super_group(msg) then
            if not is_whitelisted(msg.to.id, msg.from.id) then
                local continue = false
                if not msg.api_patch then
                    continue = true
                elseif msg.from.username then
                    if string.sub(msg.from.username:lower(), -3) == 'bot' then
                        continue = true
                    end
                end
                if continue then
                    -- if regular user
                    local print_name = user_print_name(msg.from):gsub("‮", "")
                    -- get rid of rtl in names
                    local name_log = print_name:gsub("_", " ")
                    -- name for log
                    local settings = nil
                    if data[tostring(msg.to.id)] then
                        if data[tostring(msg.to.id)]['settings'] then
                            settings = data[tostring(msg.to.id)]['settings']
                        end
                    end
                    if settings then
                        local lock_arabic = settings.lock_arabic
                        local lock_bots = settings.lock_bots
                        local lock_leave = settings.lock_leave
                        local lock_link = settings.lock_link
                        local group_link = nil
                        if settings.set_link then
                            group_link = settings.set_link
                        end
                        local lock_member = settings.lock_member
                        local lock_rtl = settings.lock_rtl
                        local lock_spam = settings.lock_spam
                        local strict = settings.strict

                        local mute_all = is_muted(msg.to.id, 'all')
                        local mute_audio = is_muted(msg.to.id, 'audio')
                        local mute_contact = is_muted(msg.to.id, 'contact')
                        local mute_document = is_muted(msg.to.id, 'document')
                        local mute_gif = is_muted(msg.to.id, 'gif')
                        local mute_location = is_muted(msg.to.id, 'location')
                        local mute_photo = is_muted(msg.to.id, 'photo')
                        local mute_sticker = is_muted(msg.to.id, 'sticker')
                        local mute_text = is_muted(msg.to.id, 'text')
                        local mute_tgservice = is_muted(msg.to.id, 'tgservice')
                        local mute_video = is_muted(msg.to.id, 'video')
                        local mute_voice = is_muted(msg.to.id, 'voice')
                        if is_muted_user(msg.to.id, msg.from.id) and not msg.service then
                            delete_msg(msg.id, ok_cb, false)
                            if msg.to.type == 'chat' then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            msg = clean_msg(msg)
                            return nil
                        end
                        if not is_momod(msg) then
                            if msg and not msg.service and mute_all then
                                delete_msg(msg.id, ok_cb, false)
                                if msg.to.type == 'chat' then
                                    kick_user(msg.from.id, msg.to.id)
                                end
                                msg = clean_msg(msg)
                                return nil
                            end
                            if msg.text then
                                -- msg.text checks
                                if lock_spam then
                                    local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
                                    local _nl, real_digits = string.gsub(msg.text, '%d', '')
                                    if string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
                                        delete_msg(msg.id, ok_cb, false)
                                        if strict then
                                            kick_user(msg.from.id, msg.to.id)
                                        end
                                        if msg.to.type == 'chat' then
                                            ban_user(msg.from.id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if lock_link then
                                    if check_if_link(msg.text, group_link) then
                                        delete_msg(msg.id, ok_cb, false)
                                        if strict then
                                            kick_user(msg.from.id, msg.to.id)
                                        end
                                        if msg.to.type == 'chat' then
                                            ban_user(msg.from.id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if msg.service then
                                    if mute_tgservice then
                                        delete_msg(msg.id, ok_cb, false)
                                        return nil
                                    end
                                end
                                if lock_arabic then
                                    local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
                                    if is_squig_msg then
                                        delete_msg(msg.id, ok_cb, false)
                                        if strict then
                                            kick_user(msg.from.id, msg.to.id)
                                        end
                                        if msg.to.type == 'chat' then
                                            ban_user(msg.from.id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if lock_rtl then
                                    local is_rtl = msg.from.print_name:match("‮") or msg.text:match("‮")
                                    if is_rtl then
                                        delete_msg(msg.id, ok_cb, false)
                                        if strict then
                                            kick_user(msg.from.id, msg.to.id)
                                        end
                                        if msg.to.type == 'chat' then
                                            ban_user(msg.from.id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if mute_text and msg.text and not msg.media and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                            end
                            if msg.media then
                                -- msg.media checks
                                if msg.media.title then
                                    if lock_link then
                                        if check_if_link(msg.media.title, group_link) then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_arabic then
                                        local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
                                        if is_squig_title then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                end
                                if msg.media.description then
                                    if lock_link then
                                        if check_if_link(msg.media.description, group_link) then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_arabic then
                                        local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
                                        if is_squig_desc then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                end
                                if msg.media.caption then
                                    if lock_link then
                                        if check_if_link(msg.media.caption, group_link) then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_arabic then
                                        local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
                                        if is_squig_caption then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if mute_sticker and msg.media.caption:match("sticker.webp") then
                                        delete_msg(msg.id, ok_cb, false)
                                        if strict then
                                            kick_user(msg.from.id, msg.to.id)
                                        end
                                        if msg.to.type == 'chat' then
                                            ban_user(msg.from.id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if msg.media.type:match("contact") and mute_contact then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                                local is_photo_caption = msg.media.caption and msg.media.caption:match("photo")
                                -- ".jpg",
                                if mute_photo and msg.media.type:match("photo") or is_photo_caption and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                                local is_gif_caption = msg.media.caption and msg.media.caption:match(".mp4")
                                if mute_gif and is_gif_caption and msg.media.type:match("document") and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                                if (mute_audio or mute_voice) and msg.media.type:match("audio") and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                                local is_video_caption = msg.media.caption and msg.media.caption:lower(".mp4", "video")
                                if mute_video and msg.media.type:match("video") and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                                if mute_document and msg.media.type:match("document") and not msg.service then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return nil
                                end
                            end
                            if msg.fwd_from then
                                if msg.fwd_from.title then
                                    if lock_link then
                                        if check_if_link(msg.fwd_from.title, group_link) then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_arabic then
                                        local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
                                        if is_squig_title then
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                end
                                if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
                                    delete_msg(msg.id, ok_cb, false)
                                    return nil
                                end
                            end
                            if msg.service then
                                -- msg.service checks
                                local action = msg.action.type
                                if action == 'chat_add_user_link' then
                                    local user_id = msg.from.id
                                    if lock_spam then
                                        local _nl, ctrl_chars = string.gsub(msg.from.print_name, '%c', '')
                                        if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 then
                                            savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] joined and Service Msg deleted (#spam name)")
                                            delete_msg(msg.id, ok_cb, false)
                                            if strict then
                                                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] joined and kicked (#spam name)")
                                                kick_user(msg.from.id, msg.to.id)
                                            end
                                            if msg.to.type == 'chat' then
                                                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] joined and banned (#spam name)")
                                                ban_user(msg.from.id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_rtl then
                                        local is_rtl_name = msg.from.print_name:match("‮")
                                        if is_rtl_name then
                                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] joined and kicked (#RTL char in name)")
                                            delete_msg(msg.id, ok_cb, false)
                                            kick_user(user_id, msg.to.id)
                                            if msg.to.type == 'chat' then
                                                ban_user(user_id, msg.to.id)
                                            end
                                            return nil
                                        end
                                    end
                                    if lock_member then
                                        savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] joined and kicked (#lockmember)")
                                        delete_msg(msg.id, ok_cb, false)
                                        kick_user(user_id, msg.to.id)
                                        if msg.to.type == 'chat' then
                                            ban_user(user_id, msg.to.id)
                                        end
                                        return nil
                                    end
                                end
                                if action == 'chat_add_user' then
                                    if not is_momod2(msg.from.id, msg.to.id) then
                                        local user_id = msg.action.user.id
                                        if lock_spam then
                                            local _nl, ctrl_chars = string.gsub(msg.action.user.print_name, '%c', '')
                                            if string.len(msg.action.user.print_name) > 70 or ctrl_chars > 40 then
                                                savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. user_id .. "]: Service Msg deleted (#spam name)")
                                                delete_msg(msg.id, ok_cb, false)
                                                if strict then
                                                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. user_id .. "]: added user kicked (#spam name) ")
                                                    kick_user(msg.from.id, msg.to.id)
                                                end
                                                if msg.to.type == 'chat' then
                                                    savelog(msg.to.id, name_log .. " [" .. msg.from.id .. "] added [" .. user_id .. "]: added user banned (#spam name) ")
                                                    ban_user(msg.from.id, msg.to.id)
                                                end
                                                return nil
                                            end
                                        end
                                        if lock_rtl then
                                            local is_rtl_name = msg.action.user.print_name:match("‮")
                                            if is_rtl_name then
                                                savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] added [" .. user_id .. "]: added user kicked (#RTL char in name)")
                                                delete_msg(msg.id, ok_cb, false)
                                                kick_user(user_id, msg.to.id)
                                                if msg.to.type == 'chat' then
                                                    ban_user(user_id, msg.to.id)
                                                end
                                                return nil
                                            end
                                        end
                                        if lock_member then
                                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] added [" .. user_id .. "]: added user kicked  (#lockmember)")
                                            delete_msg(msg.id, ok_cb, false)
                                            kick_user(user_id, msg.to.id)
                                            if msg.to.type == 'chat' then
                                                ban_user(user_id, msg.to.id)
                                            end
                                            return nil
                                        end
                                        if lock_bots then
                                            if msg.action.user.username ~= nil then
                                                if string.sub(msg.action.user.username:lower(), -3) == 'bot' and bots_protection then
                                                    --- Will kick bots added by normal users
                                                    local print_name = user_print_name(msg.from):gsub("‮", "")
                                                    local name = print_name:gsub("_", "")
                                                    savelog(msg.to.id, name .. " [" .. msg.from.id .. "] added a bot > @" .. msg.action.user.username)
                                                    -- Save to logs
                                                    kick_user(msg.action.user.id, msg.to.id)
                                                end
                                            end
                                        end
                                    end
                                end
                                if action == 'chat_del_user' then
                                    if lock_leave then
                                        if not is_momod2(msg.action.user.id, msg.to.id) then
                                            ban_user(msg.action.user.id, msg.to.id)
                                            return nil
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        -- End 'RondoMsgChecks' text checks by @Rondoozle
        return msg
    end
end
-- End pre_process function

return {
    description = "MSG_CHECKS",
    patterns = { },
    pre_process = pre_process,
    min_rank = 5
}
-- End msg_checks.lua
-- By @Rondoozle