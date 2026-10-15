if Bridge.name ~= 'standalone' then return end

-- Sem framework ninguém fecha a tela: este resource fecha quando o jogador aparece no mapa.
-- Se um framework da lista subir depois deste script, quem fecha é ele.
-- Se a sua base fecha a tela por conta própria (chama ShutdownLoadingScreenNui), troque para `return true`.
function Bridge.ClosesLoadscreen()
    return Bridge.Detect() ~= 'standalone'
end
