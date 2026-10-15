-- Ponte de frameworks. Este arquivo escolhe o adaptador; cada arquivo de bridge/client e
-- bridge/server começa com `if Bridge.name ~= '<nome>' then return end`, então só um deles vale.
-- Para ligar o script a um framework que não está na lista, copie o adaptador standalone,
-- troque o nome e acrescente uma linha em KNOWN.

Bridge = {}

-- Ordem importa: o primeiro que estiver no servidor é usado.
local KNOWN = {
    { name = 'qbcore', resource = 'qb-core' },
}

local function detect()
    local wanted = Config.Framework
    if type(wanted) == 'string' and wanted ~= 'auto' then return wanted end
    for _, framework in ipairs(KNOWN) do
        local state = GetResourceState(framework.resource)
        if state == 'started' or state == 'starting' then return framework.name end
    end
    return 'standalone'
end

Bridge.name = detect()

---Detecta de novo: no cliente o framework pode ainda não ter subido quando este arquivo carrega
Bridge.Detect = detect

-- O que cada adaptador de bridge/client define:
--   Bridge.ClosesLoadscreen()  true se o framework fecha a tela sozinho quando o personagem entra
--                              (o QBCore fecha). false: este resource fecha quando o jogador aparece.
