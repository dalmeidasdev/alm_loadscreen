# Instalação do alm_loadscreen

1. Baixe o `alm_loadscreen-<versão>.zip` na página de Releases do GitHub (`github.com/dalmeidasdev/alm_loadscreen/releases`).
   Não use o "Source code (zip)" nem o botão "Download ZIP" do GitHub: eles entregam a pasta com outro nome. Se já baixou assim, renomeie a pasta para `alm_loadscreen`.
2. Extraia a pasta `alm_loadscreen` dentro de `resources/`.
3. Desligue a tela de carregamento que você usava antes: duas ao mesmo tempo não funcionam. No QBCore o `qb-loading` sobe junto com a pasta `[qb]`, então **não tire o `ensure [qb]`**. Faça uma destas:
   - apague ou mova a pasta `resources/[qb]/qb-loading`; ou
   - acrescente `stop qb-loading` no `server.cfg`, logo depois da linha `ensure [qb]`.
4. No `server.cfg`, depois da linha do seu framework:
   ```
   ensure alm_loadscreen
   ```
5. Abra o `config.lua` e ajuste o nome do servidor e as cores. As teclas, as novidades e as dicas ficam em `locales/pt-br.lua` (ou `locales/en.lua`, se `Config.Locale = 'en'`).
6. Opcional: logo e fundo em `html/img`, músicas em `html/music`, apontados no `config.lua`.
7. Reinicie o servidor.

## Conferindo
- Ao conectar, a tela aparece com o nome do servidor, a barra de carregamento e a porcentagem.
- As dicas trocam sozinhas e o botão de tocar e pausar responde.
- No QBCore, a tela some quando a escolha de personagem abre. Sem framework, some quando o jogador aparece no mapa.
- No console do servidor e no F8 não pode aparecer erro com `alm_loadscreen`.

## Problemas comuns
| O que acontece | Causa | Solução |
|---|---|---|
| Aparece a tela antiga | A outra tela de carregamento continua ligada | Veja o passo 3: apague a pasta dela ou use `stop <nome>` no `server.cfg`. Nunca tire o `ensure` da pasta inteira |
| A tela aparece sem textos e sem cores (só a barra) | O lado do servidor do resource não rodou, ou ele foi ligado depois de o jogador conectar | Confira erros no console do servidor; reinicie o resource e reconecte |
| A tela fica parada até o tempo-limite | Nada fechou a tela | No QBCore, confira se o `qb-multicharacter` está ligado. Em outra base, veja "Funciona com" no README |
| A tela some cedo demais, com o mapa ainda carregando | A sua base faz o jogador aparecer antes de terminar | Faça `Bridge.ClosesLoadscreen` devolver `true` em `bridge/client/standalone.lua` e deixe a base fechar a tela |
| A música não toca | Arquivo fora de `html/music`, nome diferente do listado, ou formato que o jogo não abre | Use `.ogg` ou `.mp3`, confira o nome em `Config.Music` (começando por `music/`) |
| A logo ou o fundo não aparecem | Caminho errado | Use `'img/arquivo.png'` com o arquivo dentro de `html/img`, ou um endereço `https://` |
| As cores não mudam | Cor fora do formato | Use sempre `'#rrggbb'`, com seis dígitos |
| Mudei o config e nada mudou | A tela lê os dados na conexão | Reinicie o resource e reconecte |
