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

local function send_pokemon(query, receiver)
    local url = "http://pokeapi.co/api/v1/pokemon/" .. query .. "/"
    local b, c = http.request(url)
    local pokemon = json:decode(b)

    if pokemon == nil then
        return lang_text('noPoke')
    end

    -- api returns height and weight x10
    local height = tonumber(pokemon.height) / 10
    local weight = tonumber(pokemon.weight) / 10

    local text = 'ID Pokédex: ' .. pokemon.pkdx_id
    .. '\n' .. lang_text('pokeName') .. pokemon.name
    .. '\n' .. lang_text('pokeWeight') .. weight .. " kg"
    .. '\n' .. lang_text('pokeHeight') .. height .. " m"
    .. '\n' .. lang_text('pokeSpeed') .. pokemon.speed

    local image = nil

    if images_enabled and pokemon.sprites and pokemon.sprites[1] then
        local sprite = pokemon.sprites[1].resource_uri
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

local function run(msg, matches)
    local receiver = get_receiver(msg)
    local query = URL.escape(matches[1])
    return send_pokemon(query, receiver)
end

return {
    description = "POKEDEX",
    usage = "#(pokedex|pokemon) <name>|<id>: Sasha cerca il pokémon specificato e ne invia le informazioni.",
    patterns =
    {
        "^[#!/][Pp][Oo][Kk][ÈèÉéEe][Dd][Ee][Xx] (.*)$",
        "^[#!/][Pp][Oo][Kk][ÈèÉéEe][Mm][Oo][Nn] (.+)$"
    },
    run = run,
    min_rank = 0
}