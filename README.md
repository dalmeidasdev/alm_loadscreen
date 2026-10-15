# alm_loadscreen

Tela de carregamento para servidores de RP, por Almeida Scripts. Gratuita.

## O que mostra
- **Topo**: nome do servidor (com a sua logo, se quiser) e, do outro lado, a hora e a data do computador do jogador.
- **Centro**: a logo do servidor ou, sem logo, o nome em letras grandes, com uma frase de boas-vindas.
- **Coluna da direita**: cartão de teclas e cartão de novidades, com o conteúdo que você escrever.
- **Rodapé**: dica que troca sozinha, a etapa do carregamento, a porcentagem e a barra.
- **Player de música**: tocar, pausar (também pela barra de espaço), avançar, voltar e volume (o volume escolhido fica salvo no computador do jogador). Sem músicas na lista, toca um som ambiente gerado pela própria tela.

Fundo com imagem sua ou um degradê nas cores do tema, com brilhos subindo. Cada parte liga e desliga no `config.lua`, e as cores são suas.

## Baixar
Pegue o `alm_loadscreen-<versão>.zip` na página de [Releases](https://github.com/dalmeidasdev/alm_loadscreen/releases). O botão "Download ZIP" do GitHub entrega a pasta com outro nome; se usar esse caminho, renomeie a pasta para `alm_loadscreen`. O passo a passo está no `INSTALL.md`.

## Requisitos
- Nenhum outro resource é obrigatório.
- Só pode haver **uma** tela de carregamento ligada no servidor: tire a que você usa hoje (no QBCore, `qb-loading`).

## Funciona com
| Base | Quem fecha a tela | Situação |
|---|---|---|
| QBCore | o próprio QBCore, ao abrir a escolha de personagem | aguardando teste |
| Sem framework (`standalone`) | este resource, quando o jogador aparece no mapa | aguardando teste |

Nos dois casos, se nada fechar a tela, ela fecha sozinha depois de `Config.MaxSeconds`. Se a sua base fecha a tela por conta própria, faça `Bridge.ClosesLoadscreen` devolver `true` em `bridge/client/standalone.lua`.

## Configuração
- `config.lua`: nome do servidor, logo, fundo, partes ligadas, tempo das dicas, músicas, volume inicial, tempo-limite e cores.
- `locales/pt-br.lua` e `locales/en.lua`: todos os textos da tela, **inclusive as teclas, as novidades e as dicas**. Escolha o idioma em `Config.Locale` e edite o arquivo dele.
- Imagens vão em `html/img` e músicas em `html/music`; cada pasta tem um `LEIAME.txt` explicando.

Só use imagem e música suas ou com licença para isso. A licença da Cfx proíbe música licenciada em servidores de FiveM.

Prefira arquivo local a endereço `https`: um endereço de fora é baixado pelo computador de cada jogador, e o dono daquele site vê o IP de quem entra.

## Como funciona
A tela abre antes de qualquer script do jogador. Por isso o servidor manda os textos, as cores e a lista de músicas junto com a conexão (`deferrals.handover`), e a página lê esses dados ao abrir. Mudou o `config.lua` ou um locale? Reinicie o resource (`ensure alm_loadscreen`): quem entrar depois já vê a mudança.

## Código aberto
Todo o código deste repositório é aberto para leitura. Para ajustar a tela ao seu servidor você só precisa mexer em `config.lua`, `locales/` e `bridge/`.

O script não coleta nem envia dados do seu servidor. Com `Config.VersionCheck` ligado, ele só lê um arquivo público (`https://raw.githubusercontent.com/dalmeidasdev/versions/main/versions.json`) para avisar no console quando sai versão nova.

## Licença
Uso livre em qualquer servidor e modificação para uso próprio. Não é permitido vender nem republicar; fork no GitHub para estudar ou propor mudanças é permitido. O texto completo está no arquivo `LICENSE`.

## Suporte
Pelo Discord da Almeida Scripts: https://discord.gg/dfuF2gz8NQ
