-- Base folder
local BASE_FOLDER = "/"

local function callback(extra, success, result)
    local lang = get_lang(string.match(extra.receiver, '%d+'))
    if success then
        send_large_msg(extra.receiver, langs[lang].fileDownloadedTo .. result)
    else
        send_large_msg(extra.receiver, langs[lang].errorDownloading)
    end
end

function run(msg, matches)
    if is_sudo(msg) then
        if not msg.api_patch then
            local folder = redis:get('user:folder')
            if folder then
                local receiver = get_receiver(msg)
                if matches[1]:lower() == 'folder' then
                    return langs[msg.lang].youAreHere .. BASE_FOLDER .. folder
                end
                if matches[1]:lower() == 'cd' then
                    if not matches[2] then
                        redis:set('user:folder', '')
                        return langs[msg.lang].backHomeFolder .. BASE_FOLDER
                    else
                        redis:set('user:folder', matches[2])
                        return langs[msg.lang].youAreHere .. BASE_FOLDER .. matches[2]
                    end
                end
                local action = ''
                if matches[1]:lower() == 'ls' then
                    action = io.popen('ls "' .. BASE_FOLDER .. folder .. '"'):read("*all")
                end
                if matches[1]:lower() == 'mkdir' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && mkdir \'' .. matches[2] .. '\''):read("*all")
                    return langs[msg.lang].folderCreated:gsub("X", matches[2])
                end
                if matches[1]:lower() == 'rm' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && rm -f \'' .. matches[2] .. '\''):read("*all")
                    return matches[2] .. langs[msg.lang].deleted
                end
                if matches[1]:lower() == 'cat' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && cat \'' .. matches[2] .. '\''):read("*all")
                end
                if matches[1]:lower() == 'rmdir' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && rmdir \'' .. matches[2] .. '\''):read("*all")
                    return langs[msg.lang].folderDeleted:gsub("X", matches[2])
                end
                if matches[1]:lower() == 'touch' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && touch \'' .. matches[2] .. '\''):read("*all")
                    return matches[2] .. langs[msg.lang].created
                end
                if matches[1]:lower() == 'tofile' and matches[2] and matches[3] then
                    file = io.open(BASE_FOLDER .. folder .. matches[2], "w")
                    file:write(matches[3])
                    file:flush()
                    file:close()
                    send_large_msg(receiver, langs[msg.lang].fileCreatedWithContent:gsub("X", matches[3]))
                end
                if matches[1]:lower() == 'shell' and matches[2] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && ' .. matches[2]:gsub('—', '--')):read('*all')
                end
                if matches[1]:lower() == 'cp' and matches[2] and matches[3] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && cp -r \'' .. matches[2] .. '\' \'' .. matches[3] .. '\''):read("*all")
                    return matches[2] .. langs[msg.lang].copiedTo .. matches[3]
                end
                if matches[1]:lower() == 'mv' and matches[2] and matches[3] then
                    action = io.popen('cd "' .. BASE_FOLDER .. folder .. '" && mv \'' .. matches[2] .. '\' \'' .. matches[3] .. '\''):read("*all")
                    return matches[2] .. langs[msg.lang].movedTo .. matches[3]
                end
                if matches[1]:lower() == 'upload' and matches[2] then
                    if io.popen('find ' .. BASE_FOLDER .. folder .. matches[2]):read("*all") == '' then
                        return matches[2] .. langs[msg.lang].noSuchFile
                    else
                        send_document(receiver, BASE_FOLDER .. folder .. matches[2], ok_cb, false)
                        return langs[msg.lang].sendingYou .. matches[2]
                    end
                end
                if matches[1]:lower() == 'download' then
                    if type(msg.reply_id) == "nil" then
                        return langs[msg.lang].useQuoteOnFile
                    else
                        load_document(msg.reply_id, callback, { receiver = get_receiver(msg) })
                    end
                end
                send_large_msg(receiver, action)
            else
                redis:set('user:folder', '')
                return langs[msg.lang].youAreHere .. BASE_FOLDER
            end
        end
    else
        return langs[msg.lang].require_sudo
    end
end

return {
    description = "FILEMANAGER",
    patterns =
    {
        "^[#!/]([Ff][Oo][Ll][Dd][Ee][Rr])$",
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
        "^[#!/]([Dd][Oo][Ww][Nn][Ll][Oo][Aa][Dd])"
    },
    run = run,
    min_rank = 4,
    syntax =
    {
        "SUDO",
        "#folder",
        "#cd [<directory>]",
        "#ls",
        "#mkdir <directory>",
        "#rmdir <directory>",
        "#rm <file>",
        "#touch <file>",
        "#cat <file>",
        "#tofile <file> <text>",
        "#shell <command>",
        "#cp <file> <directory>",
        "#mv <file> <directory>",
        "#upload <file>",
        "#download <reply>",
    },
}
-- Thanks to @imandaneshi