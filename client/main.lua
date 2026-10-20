-- Fecha a tela de carregamento. Com framework que fecha sozinho (Bridge.ClosesLoadscreen()), só
-- vale o limite de segurança; sem ele, fecha quando o jogador aparece no mapa.

-- Reserva: em algumas versões do FiveM os dados do handover chegam vazios à página. O cliente
-- manda os mesmos dados (shared/payload.lua) por mensagem; se a página já tem os dela, ignora.
local function sendPayload()
    SendLoadingScreenMessage(json.encode({ eventName = 'almLoadscreen', data = LoadscreenPayload() }))
end

sendPayload()

local closed = false

local function close()
    if closed then return end
    closed = true
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end

AddEventHandler('playerSpawned', function()
    if not Bridge.ClosesLoadscreen() then close() end
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(500) end
    -- de novo, caso a página ainda não estivesse ouvindo na primeira vez
    if not closed then sendPayload() end
    -- o spawnmanager pode ter feito o jogador aparecer antes de este script começar
    if not Bridge.ClosesLoadscreen() then
        Wait(2000)
        if IsPlayerPlaying(PlayerId()) and not IsScreenFadedOut() then close() end
    end
    Wait(math.max(10, tonumber(Config.MaxSeconds) or 90) * 1000)
    close()
end)
