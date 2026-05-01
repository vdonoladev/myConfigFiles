# myConfigFiles

Dotfiles e scripts utilitários para Linux — testado no Pop!_OS e Ubuntu.

A pasta `home/` espelha a estrutura do diretório pessoal (`~`), então cada arquivo deve ser copiado para o mesmo caminho relativo na sua máquina.

---

## Índice

- [Estrutura do Repositório](#estrutura-do-repositório)
- [Começando](#começando)
- [Dotfiles](#dotfiles)
  - [.bashrc](#bashrc)
  - [.bash\_aliases](#bash_aliases)
  - [.gitconfig](#gitconfig)
- [Editores](#editores)
  - [VS Code](#vs-code)
  - [Zed](#zed)
- [Scripts](#scripts)
  - [afterInstall.sh](#afterinstallsh)
  - [cacar-duplicatas.sh](#cacar-duplicatassh)
  - [installJetbrainsToolbox.sh](#installjetbrainistoolboxsh)
  - [organizar-downloads.sh](#organizar-downloadssh)
  - [scanner-espaco.sh](#scanner-espacosh)
  - [scanner-wifi.sh](#scanner-wifsh)
  - [setup-workspace.sh](#setup-workspacesh)
- [Aplicações Instaladas](#aplicações-instaladas)
- [Extensões do Navegador](#extensões-do-navegador)
- [Licença](#licença)

---

## Estrutura do Repositório

```text
myConfigFiles/
└── home/
    ├── .bash_aliases
    ├── .bashrc
    ├── .bashrc.md
    ├── .gitconfig
    ├── .config/
    │   ├── Code/
    │   │   └── User/
    │   │       └── settings.json
    │   └── zed/
    │       └── settings.json
    └── scripts/
        ├── afterInstall.sh
        ├── cacar-duplicatas.sh
        ├── installJetbrainsToolbox.sh
        ├── organizar-downloads.sh
        ├── scanner-espaco.sh
        ├── scanner-wifi.sh
        └── setup-workspace.sh
```

---

## Começando

```bash
git clone https://github.com/vdonoladev/myConfigFiles.git
cd myConfigFiles
```

> Faça backup dos seus arquivos originais antes de substituir qualquer configuração.

---

## Dotfiles

### `.bashrc`

Arquivo de configuração principal do Bash. É executado automaticamente em todo shell interativo e é responsável por carregar o `.bash_aliases`, configurar o ambiente e definir funções personalizadas.

**Para usar:**

```bash
cp home/.bashrc ~/.bashrc
source ~/.bashrc
```

#### Histórico

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `HISTSIZE` | 10.000 | Entradas mantidas em memória |
| `HISTFILESIZE` | 20.000 | Entradas salvas no arquivo de histórico |
| `HISTTIMEFORMAT` | `%F %T` | Timestamp em cada entrada (`YYYY-MM-DD HH:MM:SS`) |
| `HISTCONTROL` | `ignoredups:erasedups:ignorespace` | Ignora duplicatas e comandos com espaço à frente |
| `HISTIGNORE` | `ls:ll:cd:pwd:exit:clear:history` | Comandos que não são salvos |
| `histappend` | ativo | Anexa ao histórico em vez de sobrescrever |
| `cmdhist` | ativo | Salva comandos multi-linha como uma entrada única |

#### Comportamento do Shell

| Opção | Descrição |
| --- | --- |
| `checkwinsize` | Atualiza `LINES` e `COLUMNS` após cada comando |
| `globstar` | Permite `**` para busca recursiva de arquivos |
| `cdspell` | Corrige erros de digitação em nomes de diretório no `cd` |
| `dirspell` | Corrige erros em nomes de diretório no autocomplete |
| `expand_aliases` | Expande aliases em comandos não interativos |

#### Prompt Customizado

O prompt é exibido em duas linhas com cor e informações do Git:

```
┌──[usuario@host]─[~/diretorio] (branch*)
└─$
```

- Verde: delimitadores e borda
- Ciano: usuário e host
- Amarelo: diretório atual e branch Git
- `*` indica alterações não commitadas no repositório

#### Autocomplete

| Configuração | Descrição |
| --- | --- |
| Case-insensitive | Completa sem diferenciar maiúsculas e minúsculas |
| `show-all-if-ambiguous` | Exibe todas as opções imediatamente |
| `colored-stats` | Cores nos itens do autocomplete |
| `mark-directories` | Adiciona `/` ao completar diretórios |
| `visible-stats` | Exibe estatísticas dos arquivos ao completar |

#### Variáveis de Ambiente

| Variável | Valor | Descrição |
| --- | --- | --- |
| `EDITOR` | `code --wait` | Editor padrão para Git, cron, etc. |
| `VISUAL` | `code --wait` | Editor visual padrão |
| `PAGER` | `less` | Pager padrão |
| `LESS` | `-R -X -F` | Interpreta cores, não limpa a tela, sai se couber |
| `LANG` / `LC_ALL` | `en_US.UTF-8` | Locale do sistema |

#### Integrações Carregadas Automaticamente

| Ferramenta | Condição |
| --- | --- |
| **NVM** | Carregado se `~/.nvm/nvm.sh` existir |
| **Homebrew** | Carregado se `/home/linuxbrew/.linuxbrew/bin/brew` existir |
| **Cargo (Rust)** | Carregado se `~/.cargo/env` existir |
| **Angular CLI** | Autocomplete carregado se `ng` estiver no PATH |
| **Virtualenvwrapper** | Carregado se o script existir em `/usr/local/bin/` |
| **Configurações locais** | Carrega `~/.bashrc.local` se o arquivo existir |

#### PATH Adicionado Automaticamente

| Caminho | Descrição |
| --- | --- |
| `~/.local/bin` | Scripts e binários pessoais |
| `~/bin` | Scripts locais adicionados pelo usuário |
| `~/.config/composer/vendor/bin` | Binários do Composer (PHP) |
| `~/.config/herd-lite/bin` | Herd Lite (PHP) |

#### Funções Personalizadas

| Função | Uso | Descrição |
| --- | --- | --- |
| `mkcd` | `mkcd minha-pasta` | Cria um diretório e entra nele em seguida |
| `extract` | `extract arquivo.tar.gz` | Extrai qualquer formato compactado (zip, rar, 7z, bz2, deb, tar.xz, zst...) |
| `backup` | `backup config.php` | Cria cópia do arquivo com timestamp (ex: `config.php.2025-06-01.bak`) |
| `search` | `search "TODO"` | Busca um texto recursivamente em todos os arquivos do diretório atual |
| `topcommands` | `topcommands` | Lista os 10 comandos mais usados no histórico do shell |
| `dirsize` | `dirsize` | Exibe o tamanho de cada pasta no diretório atual, ordenado por tamanho |
| `bigfiles` | `bigfiles 50` | Encontra arquivos maiores que N MB no diretório atual (padrão: 100 MB) |
| `sysinfo` | `sysinfo` | Exibe OS, kernel, hostname, uptime, uso de memória e uso de disco |
| `memtop` | `memtop` | Lista os 10 processos que mais consomem memória RAM |
| `cputop` | `cputop` | Lista os 10 processos que mais consomem CPU |
| `ports` | `ports` | Lista todas as portas em `LISTEN` com o processo associado |
| `serve` | `serve 3000` | Sobe um servidor HTTP local com Python (padrão: porta 8000) |

---

### `.bash_aliases`

Arquivo de aliases carregado automaticamente pelo `.bashrc`. Organiza atalhos por categoria para agilizar o uso do terminal.

**Para usar:**

```bash
cp home/.bash_aliases ~/.bash_aliases
source ~/.bashrc
```

#### Configuração

| Alias | Comando | Descrição |
| --- | --- | --- |
| `aliasconf` | `code .bash_aliases` | Abre o arquivo de aliases no VS Code |
| `reload` | `source ~/.bashrc` | Recarrega o bashrc sem fechar o terminal |

#### Atualizações do Sistema

| Alias | Comando | Descrição |
| --- | --- | --- |
| `update` | `sudo apt update && sudo apt upgrade -y` | Atualiza repositórios e pacotes APT |
| `update-snap` | `sudo snap refresh` | Atualiza todos os apps instalados via Snap |
| `update-flatpak` | `flatpak update -y` | Atualiza todos os apps instalados via Flatpak |
| `update-all` | APT + Snap + Flatpak | Atualiza tudo de uma vez |

#### Sistema

| Alias | Comando | Descrição |
| --- | --- | --- |
| `df` | `df -h` | Espaço em disco em formato legível |
| `du` | `du -sh *` | Tamanho de cada item no diretório atual |
| `free` | `free -h` | Uso de memória RAM em formato legível |
| `top` | `htop` | Substitui `top` pelo `htop` |
| `cpu` | `lscpu` | Informações detalhadas da CPU |
| `nf` | `fastfetch` | Exibe informações do sistema de forma estilizada |

#### Rede

| Alias | Comando | Descrição |
| --- | --- | --- |
| `ips` | `ip -c -br a` | Endereços IP de todas as interfaces, colorido e resumido |
| `myip` | `curl -s ifconfig.me` | Exibe o IP público da máquina |
| `ping` | `ping -c 5` | Ping com limite de 5 pacotes |
| `ports` | `ss -tuln` | Lista todas as portas abertas |
| `speedtest` | `curl ... speedtest.py \| python3` | Teste de velocidade da internet no terminal |

#### Comandos Aprimorados

| Alias | Substitui | Descrição |
| --- | --- | --- |
| `cat` | `batcat` | Exibe arquivos com syntax highlighting |
| `ls` | `exa` | Listagem com cores e ícones |
| `ll` | `ls -lah` | Listagem detalhada com arquivos ocultos |
| `lt` | `tree -L 2` | Estrutura de diretórios em árvore (2 níveis) |
| `find` | `fd` | Busca de arquivos mais rápida |
| `cp` | `cp -iv` | Copia com confirmação e progresso |
| `mv` | `mv -iv` | Move com confirmação (evita acidentes) |
| `rm` | `rm -iv` | Remove com confirmação (evita acidentes) |
| `mkdir` | `mkdir -pv` | Cria diretórios aninhados sem erro |

#### Navegação e Histórico

| Alias | Comando | Descrição |
| --- | --- | --- |
| `..` | `cd ..` | Sobe um nível de diretório |
| `...` | `cd ../..` | Sobe dois níveis de diretório |
| `c` | `clear` | Limpa o terminal |
| `h` | `history` | Exibe o histórico completo |
| `gh` | `history\|grep` | Busca um comando específico no histórico |
| `path` | `echo $PATH \| tr ":" "\n"` | Exibe o PATH, uma entrada por linha |
| `timer` | `time ` | Mede o tempo de execução de qualquer comando |
| `please` | `sudo` | Alias para `sudo` |

#### Git

| Alias | Comando Git | Descrição |
| --- | --- | --- |
| `gadd` | `git add` | Adiciona arquivos ao staging |
| `gaddall` | `git add .` | Adiciona todos os arquivos modificados ao staging |
| `gcom` | `git commit -m` | Commit com mensagem |
| `gstatus` | `git status` | Exibe o status do repositório |
| `glog` | `git log --oneline` | Histórico de commits resumido |
| `gpull` | `git pull` | Puxa alterações do repositório remoto |
| `gpush` | `git push` | Envia commits para o repositório remoto |
| `gbranch` | `git branch` | Lista todas as branches locais |
| `gcheckout` | `git checkout` | Muda de branch ou restaura arquivos |

#### Docker

| Alias | Comando | Descrição |
| --- | --- | --- |
| `dps` | `docker ps` | Lista containers em execução |
| `dpa` | `docker ps -a` | Lista todos os containers |
| `di` | `docker images` | Lista imagens locais do Docker |
| `dstop` | `docker stop $(docker ps -q)` | Para todos os containers em execução |

---

### `.gitconfig`

Configuração global do Git com otimizações para fluxo de trabalho moderno.

**Para usar:**

```bash
cp home/.gitconfig ~/.gitconfig
```

> O `delta` precisa estar instalado para os diffs coloridos funcionarem: `sudo apt install git-delta`

#### Configurações por Seção

**`[core]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `editor` | `code --wait` | VS Code como editor padrão para commits e merges |
| `autocrlf` | `input` | Converte CRLF para LF ao fazer commit |
| `whitespace` | `trailing-space,space-before-tab` | Remove espaços em branco indesejados |
| `pager` | `delta` | Diffs com syntax highlighting |
| `excludesFile` | `~/.gitignore_global` | Gitignore global para todos os projetos |

**`[push]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `default` | `current` | Push somente da branch atual |
| `autoSetupRemote` | `true` | Cria a branch remota automaticamente se não existir |

**`[pull]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `rebase` | `true` | Usa rebase no pull para manter histórico linear |

**`[fetch]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `prune` | `true` | Remove branches remotas deletadas automaticamente |
| `pruneTags` | `true` | Remove tags remotas deletadas automaticamente |

**`[diff]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `algorithm` | `histogram` | Algoritmo mais inteligente para gerar diffs |
| `renames` | `copies` | Detecta arquivos renomeados e copiados |
| `colorMoved` | `default` | Colore blocos de código movidos diferente de adicionados |

**`[merge]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `ff` | `false` | Sempre cria commit de merge |
| `tool` | `vscode` | VS Code para resolver conflitos |
| `conflictstyle` | `zdiff3` | Exibe o ancestral comum nos conflitos |

**`[rebase]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `autoStash` | `true` | Salva alterações automaticamente antes do rebase |
| `autoSquash` | `true` | Aplica fixup/squash automaticamente |

**`[credential]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `helper` | `cache --timeout=900` | Credenciais em cache por 15 minutos |

**`[feature]`**

| Opção | Valor | Descrição |
| --- | --- | --- |
| `manyFiles` | `true` | Otimiza Git para repositórios com muitos arquivos |

#### Aliases Git

| Alias | Comando completo | Descrição |
| --- | --- | --- |
| `git st` | `status -sb` | Status resumido com a branch atual |
| `git cm` | `commit -m` | Commit rápido com mensagem |
| `git lg` | `log --oneline --graph --decorate --all` | Log visual com gráfico de branches |
| `git undo` | `reset HEAD~1 --soft` | Desfaz o último commit mantendo as alterações |
| `git last` | `log -1 HEAD --stat` | Detalhes e arquivos do último commit |
| `git br` | `branch --sort=-committerdate` | Branches ordenadas pela data do último commit |
| `git up` | `pull --rebase --autostash` | Pull com rebase e stash automático |
| `git wip` | `commit -am "wip"` | Salva tudo rapidamente como work-in-progress |
| `git unstage` | `restore --staged .` | Remove todos os arquivos do staging |
| `git discard` | `restore .` | Descarta todas as alterações não commitadas |
| `git stsh` | `stash --include-untracked` | Stash incluindo arquivos não rastreados |
| `git contributors` | `shortlog -sn --no-merges` | Ranking de commits por autor |
| `git aliases` | `config --get-regexp alias` | Lista todos os aliases configurados |

---

## Editores

### VS Code

**Para usar:**

```bash
cp home/.config/Code/User/settings.json ~/.config/Code/User/settings.json
```

#### Aparência e Interface

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `workbench.colorTheme` | `Hack The Box` | Tema de cores |
| `workbench.iconTheme` | `symbols` | Tema de ícones |
| `window.titleBarStyle` | `native` | Barra de título nativa do sistema |
| `window.menuBarVisibility` | `toggle` | Menu visível apenas com Alt |
| `window.commandCenter` | `false` | Oculta a barra de comando central |
| `workbench.statusBar.visible` | `false` | Oculta a status bar |
| `workbench.layoutControl.enabled` | `false` | Oculta os controles de layout |
| `breadcrumbs.enabled` | `false` | Desativa os breadcrumbs |
| `workbench.startupEditor` | `newUntitledFile` | Abre arquivo em branco ao iniciar |
| `workbench.editor.labelFormat` | `short` | Exibe apenas o nome do arquivo na aba |
| `workbench.editor.empty.hint` | `hidden` | Oculta a dica em editores vazios |

#### Fonte e Editor

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `editor.fontFamily` | `JetBrains Mono` | Fonte do editor |
| `editor.fontLigatures` | `true` | Ativa ligaduras tipográficas |
| `editor.fontSize` | `13` | Tamanho da fonte |
| `editor.lineHeight` | `1.4` | Altura da linha |
| `editor.tabSize` | `2` | Tamanho do tab em espaços |
| `editor.rulers` | `[80, 120]` | Réguas verticais em 80 e 120 colunas |
| `editor.wordWrap` | `on` | Quebra de linha automática |
| `editor.minimap.enabled` | `false` | Desativa o minimapa |
| `editor.scrollbar.vertical` | `hidden` | Oculta a scrollbar vertical |
| `editor.scrollbar.horizontal` | `hidden` | Oculta a scrollbar horizontal |
| `editor.stickyScroll.enabled` | `false` | Desativa o sticky scroll |
| `editor.renderLineHighlight` | `gutter` | Destaca apenas a calha da linha atual |
| `editor.semanticHighlighting.enabled` | `false` | Desativa highlight semântico |
| `editor.parameterHints.enabled` | `false` | Desativa dicas de parâmetros |

#### Formatação e Salvamento

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `editor.formatOnSave` | `true` | Formata o arquivo ao salvar |
| `editor.formatOnPaste` | `true` | Formata ao colar |
| `editor.defaultFormatter` | `esbenp.prettier-vscode` | Prettier como formatador padrão |
| `prettier.tabWidth` | `2` | Largura do tab no Prettier |
| `editor.acceptSuggestionOnCommitCharacter` | `false` | Não aceita sugestão ao digitar `;`, `,`, etc. |
| `editor.suggestSelection` | `first` | Seleciona a primeira sugestão automaticamente |
| `editor.snippetSuggestions` | `top` | Snippets aparecem no topo das sugestões |

#### Formatadores por Linguagem

| Linguagem | Formatador |
| --- | --- |
| JavaScript / JSX | Prettier |
| TypeScript | TypeScript Language Features (built-in) |
| TypeScript React | Prettier |
| HTML | HTML Language Features (built-in) |
| CSS | Prettier |
| JSON / JSONC | JSON Language Features (built-in) |
| PHP | Intelephense + Laravel Pint |

#### JavaScript e TypeScript

| Configuração | Descrição |
| --- | --- |
| `javascript.suggest.autoImports` | Sugestões de auto-import ativas |
| `javascript.updateImportsOnFileMove.enabled` | Atualiza imports ao mover arquivos |
| `typescript.suggest.autoImports` | Sugestões de auto-import ativas |
| `typescript.updateImportsOnFileMove.enabled` | Atualiza imports ao mover arquivos |
| `typescript.preferences.preferTypeOnlyAutoImports` | Prefere `import type` quando possível |
| `emmet.includeLanguages` | Emmet ativo em arquivos JSX |

#### ESLint

| Configuração | Descrição |
| --- | --- |
| `eslint.validate` | Valida JavaScript, JSX e GraphQL |
| `editor.codeActionsOnSave` | Aplica `eslint --fix` automaticamente ao salvar |

#### PHP

| Configuração | Descrição |
| --- | --- |
| `php.validate.run` | Valida ao digitar |
| `phpcs.standard` | Padrão PSR2 |
| `phpcs.executablePath` | Binário do PHPCS via Composer |
| `laravel-pint.enable` | Laravel Pint como formatador de PHP |
| `php.suggest.basic` | Sugestões básicas nativas desativadas (usa Intelephense) |

#### Explorer e File Nesting

| Configuração | Descrição |
| --- | --- |
| `explorer.confirmDelete` | Desativa confirmação ao deletar |
| `explorer.confirmDragAndDrop` | Desativa confirmação ao mover via drag |
| `explorer.compactFolders` | Desativa compactação de pastas com único filho |
| `explorer.sortOrder` | Pastas e seus arquivos aninhados primeiro |
| `explorer.fileNesting.enabled` | Agrupamento de arquivos relacionados ativo |

**Regras de file nesting:**

| Arquivo pai | Arquivos agrupados |
| --- | --- |
| `package.json` | `.eslintrc`, `prettier`, `tsconfig`, `vite.config`, `nest-cli.json`, `package-lock.json`, `pnpm-lock.yaml`, `bun.lockb` |
| `tailwind.config.*` | `tailwind.config.*`, `postcss.config.*` |
| `.env` | `.env.*` |
| `.env.local` | `.env.*` |

#### Terminal Integrado

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `terminal.integrated.fontSize` | `13` | Tamanho da fonte no terminal |
| `terminal.integrated.gpuAcceleration` | `on` | Aceleração de GPU ativa |
| `terminal.integrated.showExitAlert` | `false` | Não exibe alerta ao fechar terminal |

#### Git e GitLens

| Configuração | Descrição |
| --- | --- |
| `git.autofetch` | Fetch automático ativo |
| `git.confirmSync` | Desativa confirmação no sync |
| `git.enableSmartCommit` | Commit direto quando não há arquivos staged |
| `git.openRepositoryInParentFolders` | Abre repos em pastas pai automaticamente |
| `gitlens.codeLens.recentChange.enabled` | Code lens de última alteração desativado |
| `gitlens.codeLens.authors.enabled` | Code lens de autores desativado |
| `gitlens.ai.model` | Modelo de IA do GitLens: `copilot:gpt-4.1` |

#### Extensões e Outros

| Configuração | Descrição |
| --- | --- |
| `extensions.ignoreRecommendations` | Ignora recomendações automáticas de extensões |
| `github.copilot.nextEditSuggestions.enabled` | Next Edit Suggestions do Copilot ativo |
| `chat.mcp.gallery.enabled` | Galeria de MCP ativa |

---

### Zed

**Para usar:**

```bash
cp home/.config/zed/settings.json ~/.config/zed/settings.json
```

| Configuração | Valor | Descrição |
| --- | --- | --- |
| `telemetry.diagnostics` | `false` | Desativa envio de diagnósticos |
| `telemetry.metrics` | `false` | Desativa envio de métricas |
| `session.trust_all_worktrees` | `true` | Confia em todos os worktrees automaticamente |
| `ui_font_size` | `16` | Tamanho da fonte da interface |
| `buffer_font_size` | `14` | Tamanho da fonte do editor |
| `theme.mode` | `system` | Tema segue o modo claro/escuro do sistema |
| `theme.light` | `One Light` | Tema usado no modo claro |
| `theme.dark` | `Dracula Solid` | Tema usado no modo escuro |

---

## Scripts

**Torne os scripts executáveis:**

```bash
chmod +x home/scripts/*.sh
```

**Para acessar de qualquer lugar no terminal:**

```bash
mkdir -p ~/bin
for s in home/scripts/*.sh; do
  ln -sf "$PWD/$s" ~/bin/"$(basename "${s%.sh}")"
done
source ~/.bashrc
```

---

### `afterInstall.sh`

Script de pós-instalação para sistemas baseados em Debian/Ubuntu. Automatiza toda a configuração inicial após uma instalação limpa: atualiza o sistema, instala programas por diferentes métodos e gera um log completo da execução.

> Não execute com `sudo`. O script solicita permissões quando necessário.

```bash
./afterInstall.sh
```

#### Fluxo de Execução

1. Verifica que não está rodando como root
2. Testa conexão com a internet (`ping 8.8.8.8`)
3. Remove locks do APT e atualiza o sistema (`apt update && apt dist-upgrade`)
4. Instala e configura o **Snapd**
5. Baixa e instala os pacotes `.deb` externos
6. Instala pacotes via **APT**
7. Instala apps via **Flatpak** (adiciona o repositório Flathub automaticamente)
8. Instala apps via **Snap**
9. Executa limpeza final (`autoclean`, `autoremove`, atualiza Flatpak e Snap)
10. Exibe resumo com status de cada instalação

#### O que Instala

| Método | Pacotes |
| --- | --- |
| `.deb` | Google Chrome, Ente Auth |
| APT | wget, curl, git, flatpak, snapd, VS Code, fastfetch, ubuntu-restricted-extras |
| Flatpak | Bitwarden, Telegram, Discord, Spotify, VLC, LocalSend, Warehouse |
| Snap | PHPStorm (`--classic`), Rider (`--classic`) |

#### Como Adicionar Novos Programas

Edite os arrays no topo do script:

```bash
# Pacote .deb externo
DEB_URLS+=("https://exemplo.com/programa.deb")

# Pacote APT
PROGRAMS_APT+=("nome-do-pacote")

# App Flatpak
PROGRAMS_FLATPAK+=("com.exemplo.App|Nome Amigável")

# App Snap (flags: --classic, --beta, --edge ou vazio)
PROGRAMS_SNAP+=("nome-do-snap|--classic|Nome Amigável")
```

#### Log

Um arquivo de log completo é salvo automaticamente em:

```
~/afterInstall_YYYYMMDD_HHMMSS.log
```

---

### `cacar-duplicatas.sh`

Encontra arquivos com conteúdo idêntico usando hash SHA-256. Nenhum arquivo é deletado — tudo é apenas listado para revisão manual.

```bash
./cacar-duplicatas.sh                  # Pasta atual, tamanho mínimo de 1 KB
./cacar-duplicatas.sh ~/Fotos          # Pasta específica
./cacar-duplicatas.sh ~/Fotos 4096     # Define tamanho mínimo em bytes
```

#### Como Funciona

1. Lista todos os arquivos acima do tamanho mínimo definido
2. Agrupa por tamanho (pré-filtro rápido, sem calcular hashes)
3. Calcula SHA-256 apenas dos candidatos com mesmo tamanho
4. Identifica grupos com hash idêntico
5. Exibe os grupos com caminhos, tamanho individual e espaço total recuperável

#### Pastas Ignoradas

`node_modules/`, `.git/`, `.venv/`, `venv/`, `__pycache__/` e dotfiles (arquivos cujo nome começa com `.`).

#### Informações Exibidas por Grupo

- Número do grupo e quantidade de cópias encontradas
- Espaço em disco recuperável (em B, KB, MB ou GB)
- Primeiros 16 caracteres do hash SHA-256
- Caminho completo de cada arquivo duplicado

---

### `installJetbrainsToolbox.sh`

Instala o JetBrains Toolbox App no Linux (x86_64) seguindo o processo oficial da JetBrains.

**Antes de executar:** baixe o arquivo `.tar.gz` em [jetbrains.com/toolbox-app](https://www.jetbrains.com/toolbox-app/) e coloque-o na mesma pasta do script.

```bash
bash installJetbrainsToolbox.sh
```

#### Fluxo de Instalação

1. Localiza o arquivo `jetbrains-toolbox-*.tar.gz` na pasta atual
2. Verifica se `libfuse2` está instalada (necessária no Ubuntu 22.04+) e instala se não estiver
3. Extrai o tarball em pasta temporária (`/tmp/jb-toolbox-$$`)
4. Localiza o binário dentro do tarball (independente da profundidade de pastas)
5. Copia os arquivos para `/opt/jetbrains-toolbox/`
6. Cria link simbólico em `/usr/local/bin/jetbrains-toolbox`
7. Remove os arquivos temporários
8. Inicia o Toolbox em background para criar os arquivos de configuração e o atalho no menu

#### Resultado

| Item | Caminho |
| --- | --- |
| Binário | `/opt/jetbrains-toolbox/jetbrains-toolbox` |
| Comando global | `jetbrains-toolbox` |
| Configurações | `~/.local/share/JetBrains/Toolbox/` |
| Atalho no menu | `~/.local/share/applications/` |

---

### `organizar-downloads.sh`

Move os arquivos de uma pasta para subpastas organizadas por tipo de extensão. Arquivos com o mesmo nome no destino recebem sufixo numérico automático (`(1)`, `(2)`...). Dotfiles e subpastas são ignorados.

```bash
./organizar-downloads.sh               # Organiza a pasta atual
./organizar-downloads.sh ~/Downloads   # Organiza uma pasta específica
```

#### Categorias e Extensões

| Pasta destino | Extensões reconhecidas |
| --- | --- |
| `Imagens/` | jpg, jpeg, png, gif, bmp, svg, webp, ico, tiff, heic, heif, raw, cr2, nef, avif |
| `Documentos/` | pdf, doc, docx, xls, xlsx, ppt, pptx, odt, ods, odp, rtf, tex, pages, numbers, key, epub |
| `Videos/` | mp4, mov, avi, mkv, wmv, flv, webm, m4v, mpg, mpeg, ts |
| `Audio/` | mp3, wav, flac, aac, ogg, wma, m4a, opus, aiff, alac |
| `Instaladores/` | dmg, pkg, exe, msi, deb, rpm, appimage, snap, flatpak |
| `Compactados/` | zip, rar, 7z, tar, gz, bz2, xz, tgz, zst |
| `Codigo/` | py, js, html, css, sh, json, xml, yaml, yml, md, csv, sql, rb, go, rs, java, c, cpp, h, swift, kt, lua, r |
| `Outros/` | Qualquer extensão não listada acima |

---

### `scanner-espaco.sh`

Analisa o uso de espaço em disco de um diretório, exibindo as maiores pastas e os maiores arquivos com tamanhos coloridos e um resumo geral do disco.

```bash
./scanner-espaco.sh                    # Escaneia ~, exibe top 20
./scanner-espaco.sh /var/log           # Pasta específica
./scanner-espaco.sh ~ 30               # Define quantos itens exibir
```

#### O que Exibe

- **Maiores pastas:** profundidade 1 a partir do diretório alvo, ordenadas por tamanho
- **Maiores arquivos:** busca até 4 níveis de profundidade, ignora dotfiles
- **Resumo do disco:** espaço usado, total e percentual de uso da partição

#### Cores nos Tamanhos

| Cor | Faixa |
| --- | --- |
| Normal | Abaixo de 1 GB |
| Amarelo | Entre 1 GB e 5 GB |
| Vermelho | Acima de 5 GB |

---

### `scanner-wifi.sh`

Escaneia as redes Wi-Fi próximas e recomenda o canal menos congestionado para o roteador, tanto para 2.4 GHz quanto para 5 GHz.

```bash
./scanner-wifi.sh
```

#### Compatibilidade

| Método | Ferramenta | Condição |
| --- | --- | --- |
| Principal | `nmcli` (NetworkManager) | Usado automaticamente se disponível |
| Fallback | `iwlist` (wireless-tools) | Usado se `nmcli` não estiver instalado |

#### O que Exibe

**Tabela 2.4 GHz (canais 1–13):**
- Canal, número de redes detectadas, barra visual de congestionamento e nomes das redes
- Canais 1, 6 e 11 (os não sobrepostos) sempre aparecem, mesmo se vazios

**Tabela 5 GHz (canais 36–165):**
- Mesmo formato da tabela 2.4 GHz
- Só é exibida se houver ao menos uma rede detectada nessa faixa

**Diagnóstico:**
- Nome da sua rede atual (SSID)
- Canal atual com avaliação: BOM (< 3 redes), MODERADO (3–4), CONGESTIONADO (5+)
- Canal ideal recomendado para 2.4 GHz (entre 1, 6 e 11)
- Canal ideal recomendado para 5 GHz

#### Cores na Tabela

| Cor | Significado |
| --- | --- |
| Verde | Canal com poucas redes (até 2) |
| Amarelo | Canal moderadamente ocupado (3–4 redes) |
| Vermelho | Canal congestionado (5 ou mais redes) |

---

### `setup-workspace.sh`

Gerenciador de layout multi-monitor para Linux. Posiciona janelas automaticamente em monitores específicos usando perfis salvos em arquivo de configuração.

**Dependências:**

```bash
sudo apt install wmctrl xdotool x11-xserver-utils
```

```bash
./setup-workspace.sh                   # Abre o menu interativo
./setup-workspace.sh <perfil>          # Carrega um perfil diretamente
./setup-workspace.sh --save <nome>     # Salva o layout atual como perfil
./setup-workspace.sh --detect          # Lista os monitores conectados
./setup-workspace.sh --init            # Cria o arquivo de configuração padrão
```

#### Arquivo de Configuração

**Localização:** `~/.config/workspace-profiles.conf`

> Use `--detect` para descobrir os nomes exatos dos seus monitores antes de configurar.

```ini
# Mapeamento de monitores
monitor.1=HDMI-1
monitor.2=DP-1

# Formato: perfil|Nome da Janela|número do monitor|posição
trabalho|Google Chrome|1|left
trabalho|Zed|1|right
trabalho|Discord|2|full
trabalho|Spotify|2|bottom-right
```

#### Posições Disponíveis

| Posição | Descrição |
| --- | --- |
| `full` | Tela cheia no monitor |
| `left` | Metade esquerda |
| `right` | Metade direita |
| `top` | Metade superior |
| `bottom` | Metade inferior |
| `top-left` | Quadrante superior esquerdo |
| `top-right` | Quadrante superior direito |
| `bottom-left` | Quadrante inferior esquerdo |
| `bottom-right` | Quadrante inferior direito |
| `x%,y%,w%,h%` | Posição e tamanho customizados em porcentagem da área do monitor |

#### Menu Interativo

Ao executar sem argumentos, o script exibe um menu com duas opções:

1. **Carregar perfil** — lista os perfis disponíveis no arquivo de configuração e aplica o escolhido
2. **Capturar layout atual** — detecta em qual monitor cada janela está e calcula as posições automaticamente em porcentagem, salvando como um novo perfil

---

## Aplicações Instaladas

Lista completa dos programas instalados pelo `afterInstall.sh`.

### Via `.deb` (download direto)

| Aplicativo | Descrição |
| --- | --- |
| [Google Chrome](https://www.google.com/chrome/) | Navegador |
| [Ente Auth](https://ente.io/auth/) | Autenticador 2FA de código aberto |

### Via APT

| Pacote | Descrição |
| --- | --- |
| `wget` | Download de arquivos via terminal |
| `curl` | Transferência de dados via URL |
| `git` | Controle de versão |
| `flatpak` | Gerenciador de pacotes Flatpak |
| `snapd` | Gerenciador de pacotes Snap |
| `ubuntu-restricted-extras` | Codecs multimídia e fontes proprietárias |
| `fastfetch` | Exibição de informações do sistema |
| `code` | Visual Studio Code |

### Via Flatpak

| Aplicativo | Descrição |
| --- | --- |
| [Bitwarden](https://bitwarden.com/) | Gerenciador de senhas |
| [Telegram](https://telegram.org/) | Mensageiro |
| [LocalSend](https://localsend.org/) | Transferência de arquivos na rede local |
| [Warehouse](https://github.com/flattool/warehouse) | Gerenciador visual de apps Flatpak |
| [Discord](https://discord.com/) | Comunicação por voz, vídeo e texto |
| [Spotify](https://www.spotify.com/) | Streaming de música |
| [VLC](https://www.videolan.org/) | Player de mídia universal |

### Via Snap

| Aplicativo | Flag | Descrição |
| --- | --- | --- |
| [PHPStorm](https://www.jetbrains.com/phpstorm/) | `--classic` | IDE para PHP da JetBrains |
| [Rider](https://www.jetbrains.com/rider/) | `--classic` | IDE para .NET da JetBrains |

---

## Extensões do Navegador

Extensões utilizadas no Google Chrome:

| Extensão | Descrição |
| --- | --- |
| [1Password](https://chromewebstore.google.com/detail/1password-%E2%80%93-password-mana/aeblfdkhhhdcdjpifhhbdiojplfjncoa) | Gerenciador de senhas |
| [Chrome Remote Desktop](https://chromewebstore.google.com/detail/chrome-remote-desktop/inomeogfingihgjfjlpeplalcfajhgai) | Acesso remoto ao computador |
| [Integração com GNOME Shell](https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep) | Instala extensões do GNOME direto pelo navegador |
| [Documentos Google off-line](https://chromewebstore.google.com/detail/documentos-google-off-lin/ghbmnnjooekpmoecnnnilnnbdlolhkhi) | Acesso offline ao Google Docs, Sheets e Slides |
| [Inoreader](https://chromewebstore.google.com/detail/inoreader-read-later-and/kfimphpokifbjgmjflanmfeppcjimgah) | Leitor RSS e salvamento de artigos |
| [Notion Web Clipper](https://chromewebstore.google.com/detail/notion-web-clipper/knheggckgoiihginacbkhaalnibhilkk) | Salva páginas web direto no Notion |

---

## Licença

MIT — veja o arquivo [LICENSE](LICENSE).
