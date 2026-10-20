fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Almeida Scripts'
description 'Tela de carregamento com dicas, teclas, novidades, relógio e player de música'
version '1.0.1'

-- Sem `dependencies` de framework: a ponte (bridge/) descobre sozinha o que está no servidor.

loadscreen 'html/index.html'
-- A tela fica aberta até o personagem entrar (veja client/main.lua)
loadscreen_manual_shutdown 'yes'
-- Cursor ligado para o jogador usar o player de música
loadscreen_cursor 'yes'

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'locales/*.lua',
    'bridge/shared.lua',
    'shared/payload.lua',
}

client_scripts {
    'bridge/client/*.lua',
    'client/main.lua',
}

server_scripts {
    'server/version.lua',
    'server/main.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/img/*',
    'html/music/*',
}
