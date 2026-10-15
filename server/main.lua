-- A tela de carregamento abre antes de qualquer script do cliente. O que ela mostra (textos,
-- cores, músicas) vai junto com a conexão, por deferrals.handover, e a página lê em
-- window.nuiHandoverData.almLoadscreen. Nada aqui depende do jogador: a tabela é montada uma vez.
-- A página confere tudo de novo; aqui o config já sai limpo.

local THEME_KEYS = { 'accent', 'background', 'surface', 'line', 'text', 'muted' }
local SHOW_KEYS = { 'clock', 'keys', 'news', 'tips', 'music', 'sparks' }

local function list(value)
    return type(value) == 'table' and value or {}
end

local function clamp(value, low, high, default)
    value = tonumber(value)
    if not value then return default end
    return math.max(low, math.min(high, value))
end

local function short(value, size)
    return tostring(value or ''):sub(1, size)
end

---Arquivo da pasta indicada (img ou music) ou endereço https, sem caractere que quebre a página
local function url(value, folder)
    if type(value) ~= 'string' or #value > 300 or value:find('..', 1, true) then return '' end
    if value:match('^' .. folder .. '/[%w_%-%./ ]+$') then return value end
    if value:match('^https://[^%s"\'()\\<>]+$') then return value end
    return ''
end

local function theme()
    local out = {}
    for _, key in ipairs(THEME_KEYS) do
        local value = list(Config.Theme)[key]
        if type(value) == 'string' and value:match('^#%x%x%x%x%x%x$') then out[key] = value end
    end
    return out
end

local function show()
    local out = {}
    for _, key in ipairs(SHOW_KEYS) do out[key] = list(Config.Show)[key] ~= false end
    return out
end

local function music()
    local out = {}
    for _, track in ipairs(list(Config.Music)) do
        local file = type(track) == 'table' and url(track.file, 'music') or ''
        if file ~= '' then
            out[#out + 1] = { title = short(track.title, 80), artist = short(track.artist, 80), file = file }
        end
    end
    return out
end

local payload = {
    locale = LocaleUi(),
    theme = theme(),
    show = show(),
    serverName = short(Config.ServerName, 60),
    logo = url(Config.Logo, 'img'),
    background = url(Config.Background, 'img'),
    music = music(),
    volume = clamp(Config.Volume, 0, 100, 25),
    tipSeconds = clamp(Config.TipSeconds, 3, 600, 7),
}

AddEventHandler('playerConnecting', function(_, _, deferrals)
    deferrals.handover({ almLoadscreen = payload })
end)
