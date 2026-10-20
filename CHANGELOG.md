# Mudanças

## 1.0.1 - 20/10/2026
- Corrigido: no cliente do FiveM do canal beta, a tela abria sem textos, nome, logo, fundo, cores e músicas (só relógio, brilhos e barra). Uma mudança do FiveM faz os dados enviados na conexão chegarem vazios ou tarde à página.
- A página agora espera esses dados por alguns segundos e, de reserva, o script do cliente manda os mesmos dados de novo assim que começa. Vale o primeiro que chegar, uma vez só. Até lá a tela mostra só o fundo, o relógio e a barra.
- `Config.Music` aceita uma música só, escrita sem a lista em volta (`Config.Music = { title = ..., file = 'music/abertura.ogg' }`) ou só o caminho do arquivo.
- Música, logo ou fundo com caminho inválido (fora de `html/music` ou `html/img`, ou sem `https://`) gera um aviso no console do servidor, ao iniciar, dizendo o valor ignorado e o formato certo.

## 1.0.0
- Primeira versão: nome e logo do servidor, relógio, cartões de teclas e de novidades, dicas, etapa e porcentagem do carregamento.
- Player de música com volume salvo; sem músicas, som ambiente gerado pela própria tela.
- Fundo com imagem sua ou degradê nas cores do tema.
- No QBCore, quem fecha a tela é o próprio QBCore; sem framework, fecha quando o jogador aparece no mapa. Tempo-limite de segurança nos dois casos.
- Aviso de versão nova no console do servidor.
- Textos em português e inglês.

---

# Changes (English)

## 1.0.1 - 2026-10-20
- Fixed: on the FiveM beta client, the screen opened without texts, name, logo, background, colors and music (only the clock, sparks and bar). A FiveM change makes the data sent on connect reach the page empty or late.
- The page now waits a few seconds for that data and, as a fallback, the client script sends the same data again as soon as it starts. The first one to arrive is used, once. Until then the screen shows only the background, the clock and the bar.
- `Config.Music` accepts a single track written without the surrounding list (`Config.Music = { title = ..., file = 'music/intro.ogg' }`) or just the file path.
- A track, logo or background with an invalid path (outside `html/music` or `html/img`, or without `https://`) prints a warning in the server console on start, with the ignored value and the expected format.

## 1.0.0
- First version: server name and logo, clock, keys and news cards, tips, loading stage and percentage.
- Music player with saved volume; with no tracks, an ambient sound made by the screen itself.
- Background with your own image or a gradient in the theme colors.
- On QBCore, QBCore itself closes the screen; without a framework, it closes when the player appears on the map. Safety time limit in both cases.
- New version notice in the server console.
- Texts in Portuguese and English.
