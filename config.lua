Config = {}

-- Idioma dos textos: 'pt-br' ou 'en' (arquivos em locales/). As dicas, as teclas e as novidades
-- da tela também ficam em locales/: edite lá.
Config.Locale = 'pt-br'

-- Framework do servidor: 'auto' descobre sozinho. Para forçar: 'qbcore' ou 'standalone'.
Config.Framework = 'auto'

-- Avisa no console do servidor quando sair versão nova. Só lê um arquivo público; não envia nada.
Config.VersionCheck = true

-- Nome do servidor, no canto superior esquerdo e no centro quando não há logo ('' esconde)
Config.ServerName = 'Minha Cidade'

-- Imagens: arquivo dentro de html/img (ex.: 'img/logo.png') ou endereço https. '' deixa sem.
-- Use só imagem sua ou de licença livre. Prefira arquivo local: endereço https é baixado pelo
-- computador de cada jogador, e o dono daquele site vê o IP de quem entra.
Config.Logo = ''
Config.Background = '' -- sem imagem, o fundo é um degradê nas cores do tema

-- Liga e desliga cada parte da tela
Config.Show = {
    clock = true,  -- hora e data do computador do jogador
    keys = true,   -- cartão de teclas
    news = true,   -- cartão de novidades
    tips = true,   -- dica que troca no rodapé
    music = true,  -- player de música
    sparks = true, -- brilhos subindo pela tela
}

-- Segundos entre uma dica e outra
Config.TipSeconds = 7

-- Músicas, na ordem em que tocam. Coloque os arquivos (.ogg ou .mp3) em html/music
-- (endereço https também funciona, com o mesmo cuidado das imagens).
-- Lista vazia: toca um som ambiente gerado pela própria tela.
-- Só use música sua ou com licença para isso: a licença da Cfx proíbe música licenciada.
-- Exemplo: { title = 'Abertura', artist = 'Minha Banda', file = 'music/abertura.ogg' },
-- Caminho errado é ignorado, com aviso no console do servidor ao iniciar.
Config.Music = {}

-- Volume inicial, de 0 a 100. O jogador pode mudar, e a escolha fica salva no computador dele.
Config.Volume = 25

-- Se nada fechar a tela (framework parado, erro em outro script), ela fecha sozinha depois
-- deste tempo, em segundos, contado de quando o jogador entra na sessão.
Config.MaxSeconds = 90

-- Cores da tela, no formato '#rrggbb'
Config.Theme = {
    accent = '#ff7a1a',     -- destaque: barra, botões, brilhos
    background = '#0c0e12', -- fundo e sombras
    surface = '#1b1f27',    -- cartões e player
    line = '#2e3542',       -- contornos
    text = '#f1f3f6',
    muted = '#9aa3b2',      -- rótulos e textos de apoio
}
