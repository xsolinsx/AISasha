local function test_text(text, group_link)
    text = text:gsub(group_link:lower(), '')
    local is_now_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
    text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
    or text:match("[Tt]%.[Mm][Ee]/")
    if is_now_link then
        return true
    end
    return false
end

local function test_bot(text)
    text = text:gsub("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    text = text:gsub("[Tt]%.[Mm][Ee]/[%w_]+?[Ss][Tt][Aa][Rr][Tt]=", '')
    local is_now_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
    text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or text:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
    or text:match("[Tt]%.[Mm][Ee]/")
    if is_now_link then
        return true
    end
    return false
end

-- Begin pre_process function
local function pre_process(msg)
    -- Begin 'RondoMsgChecks' text checks by @rondoozle
    if is_chat_msg(msg) or is_super_group(msg) then
        if msg and not is_whitelisted(msg.from.id) then
            -- if regular user
            local print_name = user_print_name(msg.from):gsub("‮", "")
            -- get rid of rtl in names
            local name_log = print_name:gsub("_", " ")
            -- name for log
            if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
                settings = data[tostring(msg.to.id)]['settings']
            else
                return msg
            end
            local lock_arabic = settings.lock_arabic
            local lock_link = settings.lock_link
            local group_link = nil
            if settings.set_link then
                group_link = settings.set_link
            end
            local lock_member = settings.lock_member
            local lock_rtl = settings.lock_rtl
            local lock_spam = settings.lock_spam
            local strict = settings.strict

            local mute_all = isMuted(msg.to.id, 'all')
            local mute_audio = isMuted(msg.to.id, 'audio')
            local mute_contact = isMuted(msg.to.id, 'contact')
            local mute_document = isMuted(msg.to.id, 'document')
            local mute_gif = isMuted(msg.to.id, 'gif')
            local mute_location = isMuted(msg.to.id, 'location')
            local mute_photo = isMuted(msg.to.id, 'photo')
            local mute_sticker = isMuted(msg.to.id, 'sticker')
            local mute_text = isMuted(msg.to.id, 'text')
            local mute_tgservice = isMuted(msg.to.id, 'tgservice')
            local mute_video = isMuted(msg.to.id, 'video')
            local mute_voice = isMuted(msg.to.id, 'voice')
            if is_muted_user(msg.to.id, msg.from.id) and not msg.service then
                delete_msg(msg.id, ok_cb, false)
                if msg.to.type == 'chat' then
                    kick_user(msg.from.id, msg.to.id)
                end
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
            if not is_momod(msg) then
                if msg and not msg.service and mute_all then
                    delete_msg(msg.id, ok_cb, false)
                    if msg.to.type == 'chat' then
                        kick_user(msg.from.id, msg.to.id)
                    end
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
                if msg.text then
                    -- msg.text checks
                    local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
                    local _nl, real_digits = string.gsub(msg.text, '%d', '')
                    if lock_spam and(string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000) then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
                    end
                    local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                    msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
                    or msg.text:match("[Tt]%.[Mm][Ee]/")
                    -- or msg.text:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.text:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.text:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                    if is_link_msg and lock_link then
                        local link_found = false
                        local is_bot = msg.text:match("?[Ss][Tt][Aa][Rr][Tt]=")
                        if is_bot then
                            if test_bot(msg.text:lower()) then
                                link_found = true
                            end
                        end
                        if group_link then
                            if not string.find(msg.text:lower(), group_link:lower()) then
                                link_found = true
                            else
                                if test_text(msg.text:lower(), group_link:lower()) then
                                    link_found = true
                                end
                            end
                        else
                            link_found = true
                        end
                        if link_found then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                    end
                    if msg.service then
                        if mute_tgservice then
                            delete_msg(msg.id, ok_cb, false)
                            return
                        end
                    end
                    local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
                    if is_squig_msg and lock_arabic then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
                    end
                    local print_name = msg.from.print_name
                    local is_rtl = print_name:match("‮") or msg.text:match("‮")
                    if is_rtl and lock_rtl then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
                    end
                    if mute_text and msg.text and not msg.media and not msg.service then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
                    end
                end
                if msg.media then
                    -- msg.media checks
                    if msg.media.title then
                        local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                        msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
                        or msg.media.title:match("[Tt]%.[Mm][Ee]/")
                        -- or msg.media.title:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.media.title:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.media.title:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                        if is_link_title and lock_link then
                            local link_found = false
                            local is_bot = msg.media.title:match("?[Ss][Tt][Aa][Rr][Tt]=")
                            if is_bot then
                                if test_bot(msg.media.title:lower()) then
                                    link_found = true
                                end
                            end
                            if group_link then
                                if not string.find(msg.media.title:lower(), group_link:lower()) then
                                    link_found = true
                                else
                                    if test_text(msg.media.title:lower(), group_link:lower()) then
                                        link_found = true
                                    end
                                end
                            else
                                link_found = true
                            end
                            if link_found then
                                delete_msg(msg.id, ok_cb, false)
                                if strict then
                                    kick_user(msg.from.id, msg.to.id)
                                end
                                if msg.to.type == 'chat' then
                                    ban_user(msg.from.id, msg.to.id)
                                end
                                return
                            end
                        end
                        local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
                        if is_squig_title and lock_arabic then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                    end
                    if msg.media.description then
                        local is_link_description = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                        msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
                        or msg.media.description:match("[Tt]%.[Mm][Ee]/")
                        -- or msg.media.description:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.media.description:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.media.description:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                        if is_link_description and lock_link then
                            local link_found = false
                            local is_bot = msg.media.description:match("?[Ss][Tt][Aa][Rr][Tt]=")
                            if is_bot then
                                if test_bot(msg.media.description:lower()) then
                                    link_found = true
                                end
                            end
                            if group_link then
                                if not string.find(msg.media.description:lower(), group_link:lower()) then
                                    link_found = true
                                else
                                    if test_text(msg.media.description:lower(), group_link:lower()) then
                                        link_found = true
                                    end
                                end
                            else
                                link_found = true
                            end
                            if link_found then
                                delete_msg(msg.id, ok_cb, false)
                                if strict then
                                    kick_user(msg.from.id, msg.to.id)
                                end
                                if msg.to.type == 'chat' then
                                    ban_user(msg.from.id, msg.to.id)
                                end
                                return
                            end
                        end
                        local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
                        if is_squig_desc and lock_arabic then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                    end
                    if msg.media.caption then
                        -- msg.media.caption checks
                        local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                        msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
                        or msg.media.caption:match("[Tt]%.[Mm][Ee]/")
                        -- or msg.media.caption:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.media.caption:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.media.caption:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                        if is_link_caption and lock_link then
                            local link_found = false
                            local is_bot = msg.media.caption:match("?[Ss][Tt][Aa][Rr][Tt]=")
                            if is_bot then
                                if test_bot(msg.media.caption:lower()) then
                                    link_found = true
                                end
                            end
                            if group_link then
                                if not string.find(msg.media.caption:lower(), group_link:lower()) then
                                    link_found = true
                                else
                                    if test_text(msg.media.caption:lower(), group_link:lower()) then
                                        link_found = true
                                    end
                                end
                            else
                                link_found = true
                            end
                            if link_found then
                                delete_msg(msg.id, ok_cb, false)
                                if strict then
                                    kick_user(msg.from.id, msg.to.id)
                                end
                                if msg.to.type == 'chat' then
                                    ban_user(msg.from.id, msg.to.id)
                                end
                                return
                            end
                        end
                        local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
                        if is_squig_caption and lock_arabic then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                        local is_username_caption = msg.media.caption:match("^@[%a%d]")
                        if is_username_caption and lock_link then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                        if mute_sticker and msg.media.caption:match("sticker.webp") then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
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
                        return
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
                        return
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
                        return
                    end
                    if (mute_audio or mute_voice) and msg.media.type:match("audio") and not msg.service then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
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
                        return
                    end
                    if mute_document and msg.media.type:match("document") and not msg.service then
                        delete_msg(msg.id, ok_cb, false)
                        if strict then
                            kick_user(msg.from.id, msg.to.id)
                        end
                        if msg.to.type == 'chat' then
                            ban_user(msg.from.id, msg.to.id)
                        end
                        return
                    end
                end
                if msg.fwd_from then
                    if msg.fwd_from.title then
                        local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                        msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Dd][Oo][Gg]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm]%.[Dd][Oo][Gg]/")
                        or msg.fwd_from.title:match("[Tt]%.[Mm][Ee]/")
                        -- or msg.fwd_from.title:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.fwd_from.title:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.fwd_from.title:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                        if is_link_title and lock_link then
                            local link_found = false
                            local is_bot = msg.fwd_from.title:match("?[Ss][Tt][Aa][Rr][Tt]=")
                            if is_bot then
                                if test_bot(msg.fwd_from.title:lower()) then
                                    link_found = true
                                end
                            end
                            if group_link then
                                if not string.find(msg.fwd_from.title:lower(), group_link:lower()) then
                                    link_found = true
                                else
                                    if test_text(msg.fwd_from.title:lower(), group_link:lower()) then
                                        link_found = true
                                    end
                                end
                            else
                                link_found = true
                            end
                            if link_found then
                                delete_msg(msg.id, ok_cb, false)
                                if strict then
                                    kick_user(msg.from.id, msg.to.id)
                                end
                                if msg.to.type == 'chat' then
                                    ban_user(msg.from.id, msg.to.id)
                                end
                                return
                            end
                        end
                        local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]/") or
                        msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Dd][Oo][Gg]/")
                        or msg.fwd_from.title:match("[Tt].[Mm][Ee]/")
                        -- or msg.fwd_from.title:match("[Aa][Dd][Ff]%.[Ll][Yy]/") or msg.fwd_from.title:match("[Bb][Ii][Tt]%.[Ll][Yy]/") or msg.fwd_from.title:match("[Gg][Oo][Oo]%.[Gg][Ll]/")
                        if is_link_title and lock_link then
                            if group_link then
                                if not string.find(msg.fwd_from.title, group_link) then
                                    delete_msg(msg.id, ok_cb, false)
                                    if strict then
                                        kick_user(msg.from.id, msg.to.id)
                                    end
                                    if msg.to.type == 'chat' then
                                        ban_user(msg.from.id, msg.to.id)
                                    end
                                    return
                                end
                            end
                        end
                        local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
                        if is_squig_title and lock_arabic then
                            delete_msg(msg.id, ok_cb, false)
                            if strict then
                                kick_user(msg.from.id, msg.to.id)
                            end
                            if msg.to.type == 'chat' then
                                ban_user(msg.from.id, msg.to.id)
                            end
                            return
                        end
                    end
                    if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
                        delete_msg(msg.id, ok_cb, false)
                        return
                    end
                end
                if msg.service then
                    -- msg.service checks
                    local action = msg.action.type
                    if action == 'chat_add_user_link' then
                        local user_id = msg.from.id
                        local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
                        if (string.len(msg.from.print_name) > 70 or ctrl_chars > 40) and lock_spam then
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
                        end
                        local print_name = msg.from.print_name
                        local is_rtl_name = print_name:match("‮")
                        if is_rtl_name and lock_rtl then
                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] joined and kicked (#RTL char in name)")
                            delete_msg(msg.id, ok_cb, false)
                            kick_user(user_id, msg.to.id)
                            if msg.to.type == 'chat' then
                                ban_user(user_id, msg.to.id)
                            end
                        end
                        if lock_member then
                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] joined and kicked (#lockmember)")
                            delete_msg(msg.id, ok_cb, false)
                            kick_user(user_id, msg.to.id)
                            if msg.to.type == 'chat' then
                                ban_user(user_id, msg.to.id)
                            end
                        end
                    end
                    if action == 'chat_add_user' and not is_momod2(msg.from.id, msg.to.id) then
                        local user_id = msg.action.user.id
                        if (string.len(msg.action.user.print_name) > 70 or ctrl_chars > 40) and lock_spam then
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
                        end
                        local print_name = msg.action.user.print_name
                        local is_rtl_name = print_name:match("‮")
                        if is_rtl_name and lock_rtl then
                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] added [" .. user_id .. "]: added user kicked (#RTL char in name)")
                            delete_msg(msg.id, ok_cb, false)
                            kick_user(user_id, msg.to.id)
                            if msg.to.type == 'chat' then
                                ban_user(user_id, msg.to.id)
                            end
                        end
                        if msg.to.type == 'channel' and lock_member then
                            savelog(msg.to.id, name_log .. " User [" .. msg.from.id .. "] added [" .. user_id .. "]: added user kicked  (#lockmember)")
                            delete_msg(msg.id, ok_cb, false)
                            kick_user(user_id, msg.to.id)
                            if msg.to.type == 'chat' then
                                ban_user(user_id, msg.to.id)
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
-- End pre_process function
return {
    description = "MSG_CHECKS",
    patterns = { },
    pre_process = pre_process,
    min_rank = 5
}
-- End msg_checks.lua
-- By @Rondoozle