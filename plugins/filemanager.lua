-- Base folder
local BASE_FOLDER = "/"

local function callback(extra, success, result)
    vardump(result)
    vardump(extra)
    if success then
        print('File downloaded to:', result)
    else
        print('Error downloading: ' .. extra)
    end
end

local function callback_reply_file(extra, success, result)
    vardump(result)
    if result.media then
        if result.media.type == 'document' then
            load_document(result.id, callback, result.id)
        elseif result.media.type == 'photo' then
            load_photo(result.id, callback, result.id)
        elseif result.media.type == 'video' then
            load_video(result.id, callback, result.id)
        elseif result.media.type == 'audio' then
            load_audio(result.id, callback, result.id)
        else
            print('sendingmsg2')
            send_large_msg(result.to.id, lang_text('mediaNotRecognized'))
        end
    else
        print('sendingmsg1')
        send_large_msg(result.to.id, lang_text('needMedia'))
    end
end

function run(msg, matches)
    if is_sudo(msg) then
        if redis:get('folder') then
            local folder = redis:get('folder')
            receiver = get_receiver(msg)
            if matches[1]:lower() == 'cd' then
                if not matches[2] then
                    redis:set('folder', '')
                    return lang_text('backHomeFolder') .. BASE_FOLDER
                else
                    redis:set('folder', matches[2])
                    return lang_text('youAreHere') .. BASE_FOLDER .. matches[2]
                end
            end
            if matches[1]:lower() == 'ls' then
                local action = io.popen('ls "' .. BASE_FOLDER .. folder .. '"'):read("*all")
                send_large_msg(receiver, action)
            end
            if matches[1]:lower() == 'mkdir' and matches[2] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && mkdir \'' .. matches[2] .. '\''):read("*all")
                return lang_text('folderCreated'):gsub("X", matches[2])
            end
            if matches[1]:lower() == 'rm' and matches[2] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && rm -f \'' .. matches[2] .. '\''):read("*all")
                return matches[2] .. lang_text('deleted')
            end
            if matches[1]:lower() == 'cat' and matches[2] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && cat \'' .. matches[2] .. '\''):read("*all")
                send_large_msg(receiver, action)
            end
            if matches[1]:lower() == 'rmdir' and matches[2] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && rmdir \'' .. matches[2] .. '\''):read("*all")
                return lang_text('folderDeleted'):gsub("X", matches[2])
            end
            if matches[1]:lower() == 'touch' and matches[2] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && touch \'' .. matches[2] .. '\''):read("*all")
                return matches[2] .. lang_text('created')
            end
            if matches[1]:lower() == 'tofile' and matches[2] and matches[3] then
                local file = io.open(BASE_FOLDER .. folder .. matches[2], "w")
                file:write(matches[3])
                file:flush()
                file:close()
                send_large_msg(receiver, lang_text('fileCreatedWithContent'):gsub("X", matches[3]))
            end
            if matches[1]:lower() == 'shell' and matches[2] then
                local text = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && ' .. matches[2]:gsub('—', '--')):read('*all')
                send_large_msg(receiver, text)
            end
            if matches[1]:lower() == 'cp' and matches[2] and matches[3] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && cp -r \'' .. matches[2] .. '\' \'' .. matches[3] .. '\''):read("*all")
                return matches[2] .. lang_text('copiedTo') .. matches[3]
            end
            if matches[1]:lower() == 'mv' and matches[2] and matches[3] then
                local action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && mv \'' .. matches[2] .. '\' \'' .. matches[3] .. '\''):read("*all")
                return matches[2] .. lang_text('movedTo') .. matches[3]
            end
            if matches[1]:lower() == 'upload' and matches[2] then
                if io.popen('find ' .. BASE_FOLDER .. folder .. matches[2]):read("*all") == '' then
                    return matches[2] .. lang_text('notExist')
                else
                    send_document(receiver, BASE_FOLDER .. folder .. matches[2], ok_cb, false)
                    return lang_text('sendingYou') .. matches[2]
                end
            end
            if matches[1]:lower() == 'download' then
                if type(msg.reply_id) == "nil" then
                    return lang_text('useQuoteOnFile')
                else
                    get_message(msg.reply_id, callback_reply_file, false)
                    return lang_text('downloaded')
                end
            end
        else
            redis:set('folder', '')
        end
    else
        return lang_text('require_sudo')
    end
end

return {
    description = "FILEMANAGER",
    usage =
    {
        "SUDO",
        "#cd [<directory>]: Sasha entra in <directory>, se non è specificata torna alla cartella base.",
        "#ls: Sasha manda la lista di file e cartelle della directory corrente.",
        "#mkdir <directory>: Sasha crea <directory>.",
        "#rmdir <directory>: Sasha elimina <directory>.",
        "#rm <file>: Sasha elimina <file>.",
        "#touch <file>: Sasha crea <file>.",
        "#cat <file>: Sasha manda il contenuto di <file>.",
        "#tofile <file> <text>: Sasha crea <file> con <text> come contenuto.",
        "#shell <command>: Sasha esegue <command>.",
        "#cp <file> <directory>: Sasha copia <file> in <directory>.",
        "#mv <file> <directory>: Sasha sposta <file> in <directory>.",
        "#upload <file>: Sasha manda <file> nella chat.",
        "#download <reply> [<file>]: Sasha scarica il file contenuto in <reply>, se specificato viene rinominato in <file>."
    },
    patterns =
    {
        "^[#!/]([Cc][Dd])$",
        "^[#!/]([Cc][Dd]) (.*)$",
        "^[#!/]([Ll][Ss])$",
        "^[#!/]([Mm][Kk][Dd][Ii][Rr]) (.*)$",
        "^[#!/]([Rr][Mm][Dd][Ii][Rr]) (.*)$",
        "^[#!/]([Rr][Mm]) (.*)$",
        "^[#!/]([Tt][Oo][Uu][Cc][Hh]) (.*)$",
        "^[#!/]([Cc][Aa][Tt]) (.*)$",
        "^[#!/]([Tt][Oo][Ff][Ii][Ll][Ee]) ([^%s]+) (.*)$",
        "^[#!/]([Ss][Hh][Ee][Ll][Ll]) (.*)$",
        "^[#!/]([Cc][Pp]) (.*) (.*)$",
        "^[#!/]([Mm][Vv]) (.*) (.*)$",
        "^[#!/]([Uu][Pp][Ll][Oo][Aa][Dd]) (.*)$",
        "^[#!/]([Dd][Oo][Ww][Nn][Ll][Oo][Aa][Dd]) (.*)",
        "^[#!/]([Dd][Oo][Ww][Nn][Ll][Oo][Aa][Dd])"
    },
    run = run,
    min_rank = 5
}
-- Thanks to @imandaneshi