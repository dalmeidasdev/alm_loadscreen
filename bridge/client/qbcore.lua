if Bridge.name ~= 'qbcore' then return end

-- O QBCore fecha a tela sozinho: o qb-multicharacter ao abrir a escolha de personagem e o
-- qb-core em QBCore:Client:OnPlayerLoaded. Este resource só fecha se passar de Config.MaxSeconds.
function Bridge.ClosesLoadscreen()
    return true
end
