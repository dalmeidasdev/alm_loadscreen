-- A tela de carregamento abre antes de qualquer script do cliente. O que ela mostra (textos,
-- cores, músicas) vai junto com a conexão, por deferrals.handover, e a página lê em
-- window.nuiHandoverData.almLoadscreen. Nada aqui depende do jogador: a tabela é montada uma vez
-- (shared/payload.lua), e os avisos de valor ignorado no config saem agora, ao iniciar.

local payload = LoadscreenPayload()

AddEventHandler('playerConnecting', function(_, _, deferrals)
    deferrals.handover({ almLoadscreen = payload })
end)
