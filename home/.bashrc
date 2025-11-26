#!/bin/bash

# ============================================
# .bashrc - Configuração do Bash
# ============================================
# Autor: vdonoladev
# ~/.bashrc: executado pelo bash(1) para shells não-login
# ============================================

# Se não estiver rodando interativamente, não fazer nada
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================
# HISTÓRICO DO BASH
# ============================================

# Tamanho do histórico na memória (número de comandos)
HISTSIZE=10000

# Tamanho do arquivo de histórico no disco
HISTFILESIZE=20000

# Adiciona timestamp aos comandos no histórico (formato: YYYY-MM-DD HH:MM:SS)
HISTTIMEFORMAT="%F %T "

# Controle do histórico:
# - ignoredups: não salva comandos duplicados consecutivos
# - ignorespace: não salva comandos que começam com espaço
# - erasedups: remove duplicatas antigas ao adicionar novo comando
HISTCONTROL=ignoredups:erasedups:ignorespace

# Comandos que NÃO devem ser salvos no histórico
HISTIGNORE="ls:ll:cd:pwd:exit:clear:history"

# Anexa ao histórico ao invés de sobrescrever (importante para múltiplas sessões)
shopt -s histappend

# Salva comandos multi-linha como uma única entrada no histórico
shopt -s cmdhist

# ============================================
# COMPORTAMENTO DO SHELL
# ============================================

# Atualiza LINES e COLUMNS após cada comando (útil para redimensionamento de janela)
shopt -s checkwinsize

# Permite usar ** para busca recursiva de arquivos (ex: ls **/*.txt)
shopt -s globstar

# Corrige erros menores de digitação em nomes de diretórios ao usar cd
shopt -s cdspell

# Corrige erros menores em nomes de diretórios durante a conclusão
shopt -s dirspell

# Expande aliases em comandos não-interativos
shopt -s expand_aliases

# ============================================
# LESSPIPE (Torna o less mais amigável)
# ============================================
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ============================================
# CHROOT (para ambientes enjaulados)
# ============================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ============================================
# CORES PARA PROMPT E SCRIPTS
# ============================================

# Habilita suporte a cores no terminal
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Cores para uso no PROMPT (com escape)
export PROMPT_RED='\[\033[0;31m\]'
export PROMPT_GREEN='\[\033[0;32m\]'
export PROMPT_YELLOW='\[\033[0;33m\]'
export PROMPT_BLUE='\[\033[0;34m\]'
export PROMPT_PURPLE='\[\033[0;35m\]'
export PROMPT_CYAN='\[\033[0;36m\]'
export PROMPT_WHITE='\[\033[0;37m\]'
export PROMPT_BOLD='\[\033[1m\]'
export PROMPT_RESET='\[\033[0m\]'

# Cores para uso em ECHO e SCRIPTS (sem escape)
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export BOLD='\033[1m'
export RESET='\033[0m'

# ============================================
# FUNÇÕES PARA GIT NO PROMPT
# ============================================

# Função para obter a branch atual do Git
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Função para obter o status do Git (limpo ou com alterações)
parse_git_dirty() {
    [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}

# ============================================
# PROMPT CUSTOMIZADO (PS1)
# ============================================

# Prompt customizado com cores e informações do Git
# Linha 1: ┌──[usuário@host]─[diretório] (branch_git)
# Linha 2: └─$
PS1='${debian_chroot:+($debian_chroot)}'
PS1+="${PROMPT_BOLD}${PROMPT_GREEN}┌──[${PROMPT_CYAN}\u${PROMPT_GREEN}@${PROMPT_CYAN}\h${PROMPT_GREEN}]─[${PROMPT_YELLOW}\w${PROMPT_GREEN}]"
PS1+="${PROMPT_YELLOW}\$(parse_git_branch)\$(parse_git_dirty)${PROMPT_RESET}"
PS1+="\n${PROMPT_GREEN}└─${PROMPT_BLUE}\$ ${PROMPT_RESET}"

# Prompt para comandos de continuação (quando comando quebra em múltiplas linhas)
PS2="${PROMPT_BLUE}> ${PROMPT_RESET}"

# Define o título da janela do terminal (user@host:dir)
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ============================================
# SUPORTE A CORES EM COMANDOS
# ============================================

# Habilita suporte a cores para ls, grep, etc
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ============================================
# ALIASES PADRÃO DO SISTEMA
# ============================================

# Aliases básicos de ls (podem ser sobrescritos no .bash_aliases)
alias ll='ls -alF'      # Lista detalhada incluindo arquivos ocultos
alias la='ls -A'        # Lista todos exceto . e ..
alias l='ls -CF'        # Lista em colunas com indicadores de tipo

# Alias para notificação de comandos longos
# Uso: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ============================================
# AUTOCOMPLETE MELHORADO
# ============================================

# Habilita autocomplete programável se disponível
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Autocomplete ignora maiúsculas/minúsculas
bind "set completion-ignore-case on" 2>/dev/null

# Mostra opções de autocomplete imediatamente
bind "set show-all-if-ambiguous on" 2>/dev/null

# Completa automaticamente após um TAB ao invés de mostrar opções
bind "set menu-complete-display-prefix on" 2>/dev/null

# Adiciona "/" automaticamente ao completar diretórios
bind "set mark-directories on" 2>/dev/null
bind "set mark-symlinked-directories on" 2>/dev/null

# Completa nomes de hosts ao usar @
bind "set mark-modified-lines on" 2>/dev/null

# Mostra estatísticas de arquivos ao completar
bind "set visible-stats on" 2>/dev/null

# Usa cores no autocomplete
bind "set colored-stats on" 2>/dev/null

# ============================================
# VARIÁVEIS DE AMBIENTE
# ============================================

# Define o editor padrão (usado por Git, cron, etc)
export EDITOR='code --wait'
export VISUAL='code --wait'

# Define o pager padrão (usado por man, less, etc)
export PAGER='less'

# Opções do less:
# -R: interpreta cores ANSI
# -X: não limpa a tela ao sair
# -F: sai automaticamente se conteúdo couber na tela
export LESS='-R -X -F'

# Define idioma padrão (importante para ordenação e formatação)
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

# ============================================
# PATH - CAMINHOS PERSONALIZADOS
# ============================================

# Adiciona ~/.local/bin ao PATH se existir (seus scripts pessoais)
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Adiciona ~/bin ao PATH se existir
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Adiciona composer bin ao PATH (PHP)
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Adiciona Herd Lite ao PATH (PHP)
export PATH="/home/vdonoladev/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/vdonoladev/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# ============================================
# FUNÇÕES ÚTEIS PERSONALIZADAS
# ============================================

# Cria um diretório e entra nele automaticamente
# Uso: mkcd nome_do_diretorio
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extrai qualquer tipo de arquivo compactado
# Uso: extract arquivo.zip
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.deb)       ar x "$1"        ;;
            *.tar.xz)    tar xf "$1"      ;;
            *.tar.zst)   unzstd "$1"      ;;
            *)           echo "'$1' não pode ser extraído via extract()" ;;
        esac
    else
        echo "'$1' não é um arquivo válido"
    fi
}

# Busca texto em arquivos recursivamente
# Uso: search "texto"
search() {
    grep -rnw . -e "$1" --color=auto
}

# Mostra os 10 comandos mais usados
# Uso: topcommands
topcommands() {
    history | awk '{CMD[$4]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

# Cria backup de um arquivo adicionando timestamp
# Uso: backup arquivo.txt (cria arquivo.txt.2024-11-25.bak)
backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.$(date +%Y-%m-%d).bak"
        echo "Backup criado: $1.$(date +%Y-%m-%d).bak"
    else
        echo "Arquivo '$1' não encontrado"
    fi
}

# Mostra o tamanho dos diretórios no diretório atual
# Uso: dirsize
dirsize() {
    du -sh */ 2>/dev/null | sort -hr
}

# Cria um servidor HTTP simples na porta especificada (padrão: 8000)
# Uso: serve [porta]
serve() {
    local port="${1:-8000}"
    echo "Servidor rodando em http://localhost:$port"
    python3 -m http.server "$port"
}

# Mostra uso de memória dos 10 processos que mais consomem
# Uso: memtop
memtop() {
    ps aux | sort -rnk 4 | head -10
}

# Mostra uso de CPU dos 10 processos que mais consomem
# Uso: cputop
cputop() {
    ps aux | sort -rnk 3 | head -10
}

# Mostra informações do sistema de forma resumida
# Uso: sysinfo
sysinfo() {
    echo -e "${BOLD}${CYAN}=== INFORMAÇÕES DO SISTEMA ===${RESET}"
    echo -e "${GREEN}Sistema Operacional:${RESET} $(lsb_release -d | cut -f2)"
    echo -e "${GREEN}Kernel:${RESET} $(uname -r)"
    echo -e "${GREEN}Hostname:${RESET} $(hostname)"
    echo -e "${GREEN}Uptime:${RESET} $(uptime -p)"
    echo -e "${GREEN}Uso de Memória:${RESET}"
    free -h | grep Mem | awk '{print "  Total: "$2" | Usado: "$3" | Livre: "$4}'
    echo -e "${GREEN}Uso de Disco:${RESET}"
    df -h / | tail -1 | awk '{print "  Total: "$2" | Usado: "$3" | Livre: "$4" | Uso: "$5}'
}

# Encontra arquivos grandes no diretório atual
# Uso: bigfiles [tamanho_em_MB] (padrão: 100MB)
bigfiles() {
    local size="${1:-100}"
    find . -type f -size +"${size}M" -exec ls -lh {} \; 2>/dev/null | awk '{ print $9 ": " $5 }'
}

# Mostra portas abertas e processos associados
# Uso: ports
ports() {
    sudo netstat -tulpn | grep LISTEN
}

# ============================================
# NVM (Node Version Manager)
# ============================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega o NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega autocomplete do NVM

# ============================================
# HOMEBREW (Linuxbrew)
# ============================================
# Configura o ambiente do Homebrew (carrega apenas uma vez)
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ============================================
# PYTHON VIRTUAL ENVIRONMENT
# ============================================
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh

# ============================================
# RUST (Cargo)
# ============================================
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ============================================
# ANGULAR CLI
# ============================================
# Carrega autocomplete do Angular CLI (se instalado)
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

# ============================================
# CARREGA ALIASES PERSONALIZADOS
# ============================================

# Carrega o arquivo .bash_aliases se existir
# IMPORTANTE: Seus aliases ficam separados em .bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ============================================
# MENSAGEM DE BOAS-VINDAS
# ============================================

# Mostra informações ao abrir o terminal
echo -e "${BOLD}${GREEN}Bem-vindo, $(whoami)!${RESET}"
echo -e "Hoje é $(date '+%A, %d de %B de %Y - %H:%M:%S')"
echo ""

# Ou use neofetch se estiver instalado (descomente se preferir)
# if command -v neofetch &> /dev/null; then
#     neofetch
# fi

# ============================================
# CONFIGURAÇÕES LOCAIS ESPECÍFICAS
# ============================================

# Carrega configurações locais se existirem
# Use este arquivo para configs específicas desta máquina
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# ============================================
# FIM DA CONFIGURAÇÃO
# ============================================