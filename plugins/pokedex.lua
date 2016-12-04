local images_enabled = true;

local function get_sprite(path)
    local url = "http://pokeapi.co/" .. path
    print(url)
    local b, c = http.request(url)
    local data = json:decode(b)
    local image = data.image
    return image
end

local function callback(extra)
    send_msg(extra.receiver, extra.text, ok_cb, false)
end

local function run(msg, matches)
    if not msg.api_patch then
        local receiver = get_receiver(msg)
        local query = URL.escape(matches[1])

        local url = "http://pokeapi.co/api/v2/pokemon/" .. query .. "/"
        local b, c = http.request(url)
        local pokemon = json:decode(b)

        if pokemon == nil then
            return langs[msg.lang].noPoke
        end

        -- api returns height and weight x10
        local height = tonumber(pokemon.height) / 10
        local weight = tonumber(pokemon.weight) / 10

        local text = 'ID Pokédex: ' .. pokemon.id
        .. '\n' .. langs[msg.lang].pokeName .. pokemon.name
        .. '\n' .. langs[msg.lang].pokeWeight .. weight .. " kg"
        .. '\n' .. langs[msg.lang].pokeHeight .. height .. " m"

        local image = nil

        if images_enabled and pokemon.sprites and pokemon.sprites[1] then
            local sprite = pokemon.sprites['front_default'].resource_uri
            image = get_sprite(sprite)
        end

        if image then
            image = "http://pokeapi.co" .. image
            local extra = {
                receiver = receiver,
                text = text
            }
            send_photo_from_url(receiver, image, callback, extra)
        end
        return text
    end
end

return {
    description = "POKEDEX",
    patterns =
    {
        "^[#!/][Pp][Oo][Kk][Ee][Dd][Ee][Xx] (.*)$",
        "^[#!/][Pp][Oo][Kk][Ee][Mm][Oo][Nn] (.+)$"
    },
    run = run,
    min_rank = 0,
    syntax =
    {
        "USER",
        "#pokedex|#pokemon <name>|<id>",
    },
}