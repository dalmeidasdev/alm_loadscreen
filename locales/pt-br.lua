Locales['pt-br'] = {
    update_available = 'Versão nova disponível: %s (instalada: %s).',
    -- avisos de valor do config.lua que a tela ignorou
    ignored_image = "%s ignorado: %s. Use um arquivo de html/img (ex.: 'img/logo.png') ou um endereço https://, ou '' para deixar sem.",
    ignored_music = "Config.Music, música %s ignorada: arquivo %s. Use um arquivo de html/music (ex.: file = 'music/abertura.ogg') ou um endereço https://.",
    ignored_music_list = "Config.Music ignorado (%s). Use uma lista: Config.Music = { { title = 'Abertura', artist = 'Minha Banda', file = 'music/abertura.ogg' } }.",

    ui = {
        lang = 'pt-BR',        -- formato da hora e da data
        subtitle = 'Roleplay', -- embaixo do nome do servidor
        tagline = 'Bem-vindo à cidade',
        keys_title = 'Teclas',
        news_title = 'Novidades',
        loading = 'Carregando',
        now_playing = 'Tocando agora',
        ambient_title = 'Som ambiente',
        previous = 'Anterior',
        play = 'Tocar ou pausar',
        next = 'Próxima',
        -- etapas do carregamento, na ordem em que o jogo passa por elas
        stages = {
            INIT_BEFORE_MAP_LOADED = 'Preparando a cidade',
            MAP = 'Carregando o mapa',
            INIT_AFTER_MAP_LOADED = 'Organizando as ruas',
            INIT_SESSION = 'Entrando na sessão',
        },

        -- Conteúdo do seu servidor: troque à vontade. Lista vazia esconde o cartão.
        keys = {
            { 'T', 'Chat' },
            { 'F1', 'Menu' },
            { 'M', 'Mapa' },
            { 'Z', 'Alcance da voz' },
        },
        news = {
            'Escreva aqui as novidades do seu servidor.',
            'Cada linha vira um item do cartão.',
        },
        tips = {
            'Leia as regras do servidor antes de começar.',
            'Dúvidas? Chame a equipe no Discord.',
            'Respeite a história dos outros jogadores.',
        },
    },
}
