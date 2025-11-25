#!/bin/bash

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

# Corrige erros menores de digitação em nomes de diretórios ao usar cd
shopt -s cdspell

# Corrige erros menores em nomes de diretórios durante a conclusão
shopt -s dirspell

# Atualiza LINES e COLUMNS após cada comando (útil para redimensionamento de janela)
shopt -s checkwinsize

# Permite usar ** para busca recursiva de arquivos (ex: ls **/*.txt)
shopt -s globstar

# Expande aliases em comandos não-interativos
shopt -s expand_aliases

# ============================================
# CORES E VISUAL
# ============================================

# Habilita suporte a cores no terminal
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Cores para uso em scripts e prompts
export RED='\[\033[0;31m\]'
export GREEN='\[\033[0;32m\]'
export YELLOW='\[\033[0;33m\]'
export BLUE='\[\033[0;34m\]'
export PURPLE='\[\033[0;35m\]'
export CYAN='\[\033[0;36m\]'
export WHITE='\[\033[0;37m\]'
export BOLD='\[\033[1m\]'
export RESET='\[\033[0m\]'

# ============================================
# PROMPT CUSTOMIZADO (PS1)
# ============================================

# Função para obter a branch atual do Git
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Função para obter o status do Git (limpo ou com alterações)
parse_git_dirty() {
    [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}

# Prompt customizado com cores e informações do Git
# Formato: [usuário@host diretório] (branch_git*) $
PS1="${BOLD}${GREEN}┌──[${CYAN}\u${GREEN}@${CYAN}\h${GREEN}]─[${YELLOW}\w${GREEN}]"
PS1+="\$(git_prompt)"
PS1+="\n${GREEN}└─${BLUE}\$ ${RESET}"

# Função auxiliar para mostrar informações do Git no prompt
git_prompt() {
    local branch=$(parse_git_branch)
    if [ -n "$branch" ]; then
        local dirty=$(parse_git_dirty)
        if [ -n "$dirty" ]; then
            echo -e "${RED}─[${YELLOW}$branch${RED}$dirty${RED}]${RESET}"
        else
            echo -e "${GREEN}─[${YELLOW}$branch${GREEN}]${RESET}"
        fi
    fi
}

# Prompt para comandos de continuação (quando comando quebra em múltiplas linhas)
PS2="${BLUE}> ${RESET}"

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
bind "set completion-ignore-case on"

# Mostra opções de autocomplete imediatamente
bind "set show-all-if-ambiguous on"

# Completa automaticamente após um TAB ao invés de mostrar opções
bind "set menu-complete-display-prefix on"

# Adiciona "/" automaticamente ao completar diretórios
bind "set mark-directories on"
bind "set mark-symlinked-directories on"

# Completa nomes de hosts ao usar @
bind "set mark-modified-lines on"

# Mostra estatísticas de arquivos ao completar
bind "set visible-stats on"

# Usa cores no autocomplete
bind "set colored-stats on"

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

# Adiciona diretórios ao PATH se existirem
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Define idioma padrão (importante para ordenação e formatação)
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

# ============================================
# FUNÇÕES ÚTEIS
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
    history | awk '{print $4}' | sort | uniq -c | sort -rn | head -10
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

# Cria um servidor HTTP simples na porta 8000
# Uso: serve (abre o diretório atual no navegador)
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Mostra uso de memória dos processos
# Uso: memtop
memtop() {
    ps aux | sort -rnk 4 | head -10
}

# Mostra uso de CPU dos processos
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

# ============================================
# INTEGRAÇÕES COM FERRAMENTAS
# ============================================

# NVM (Node Version Manager) - Se instalado
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Python Virtual Environment
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh

# Rust (Cargo)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

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

# Mostra informações ao abrir o terminal (descomente se quiser)
echo -e "${BOLD}${GREEN}Bem-vindo, $(whoami)!${RESET}"
echo -e "Hoje é $(date '+%A, %d de %B de %Y - %H:%M:%S')"
echo ""

# Ou use neofetch se estiver instalado (descomente se quiser)
# if command -v neofetch &> /dev/null; then
#     neofetch
# fi

# ============================================
# CONFIGURAÇÕES ESPECÍFICAS POR MÁQUINA
# ============================================

# Carrega configurações locais se existirem
# Use este arquivo para configs específicas desta máquina
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi