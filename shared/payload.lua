-- O que a tela mostra (textos, cores, músicas), montado do config.lua e do locale.
-- Usado pelos dois lados: o servidor manda por deferrals.handover na conexão (server/main.lua) e o
-- cliente manda de novo por SendLoadingScreenMessage (client/main.lua), de reserva para quando o
-- handover não chega à página. A página confere tudo de novo; aqui o config já sai limpo.
-- Valor descartado é avisado uma vez no console do servidor (o cliente não imprime nada).

local THEME_KEYS = { 'accent', 'background', 'surface', 'line', 'text', 'muted' }
local SHOW_KEYS = { 'clock', 'keys', 'news', 'tips', 'music', 'sparks' }
local IS_SERVER = IsDuplicityVersion()

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

---Aviso no console do servidor sobre um valor do config que foi ignorado
local function warn(key, ...)
    if not IS_SERVER then return end
    print(('^3[%s] %s^0'):format(GetCurrentResourceName(), L(key, ...)))
end

---Valor do config como aparece no aviso: curto e numa linha só
local function shown(value)
    if type(value) == 'string' then
        return ("'%s'"):format(value:gsub('[%c]', ' '):sub(1, 120))
    end
    return ('(%s)'):format(type(value))
end

---Arquivo da pasta indicada (img ou music) ou endereço https, sem caractere que quebre a página
local function url(value, folder)
    if type(value) ~= 'string' or #value > 300 or value:find('..', 1, true) then return '' end
    if value:match('^' .. folder .. '/[%w_%-%./ ]+$') then return value end
    if value:match('^https://[^%s"\'()\\<>]+$') then return value end
    return ''
end

---Imagem do config (Config.Logo, Config.Background); '' é "sem imagem" e não gera aviso
local function image(value, name)
    if value == nil or value == false or value == '' then return '' end
    local out = url(value, 'img')
    if out == '' then warn('ignored_image', name, shown(value)) end
    return out
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

---Config.Music como lista. Aceita também uma música só, escrita sem a lista em volta
---({ title = ..., file = ... }) ou só o caminho do arquivo ('music/abertura.ogg').
local function tracks()
    local value = Config.Music
    if value == nil then return {} end
    if type(value) == 'string' then return { value } end
    if type(value) ~= 'table' then
        warn('ignored_music_list', shown(value))
        return {}
    end
    if value.file ~= nil then return { value } end
    return value
end

local function music()
    local out = {}
    for index, track in ipairs(tracks()) do
        if type(track) == 'string' then track = { file = track } end
        local file = type(track) == 'table' and url(track.file, 'music') or ''
        if file ~= '' then
            out[#out + 1] = { title = short(track.title, 80), artist = short(track.artist, 80), file = file }
        else
            warn('ignored_music', index, shown(type(track) == 'table' and track.file or track))
        end
    end
    return out
end

local payload

---Tabela que a página recebe. Montada na primeira chamada; as seguintes devolvem a mesma.
function LoadscreenPayload()
    if not payload then
        payload = {
            locale = LocaleUi(),
            theme = theme(),
            show = show(),
            serverName = short(Config.ServerName, 60),
            logo = image(Config.Logo, 'Config.Logo'),
            background = image(Config.Background, 'Config.Background'),
            music = music(),
            volume = clamp(Config.Volume, 0, 100, 25),
            tipSeconds = clamp(Config.TipSeconds, 3, 600, 7),
        }
    end
    return payload
end
