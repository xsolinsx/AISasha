local function pre_process(msg)
    if not msg.text and msg.media then
        msg.text = '[' .. msg.media.type .. ']'
    end
    return msg
end

return {
    description = "PREPROCESS_MEDIA",
    pre_process = pre_process,
    min_rank = 5
}