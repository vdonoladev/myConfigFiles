# CONFIGURAÇÕES
alias aliasconf='code .bash_aliases'                                                                            # Abre o arquivo .bash_aliases no editor VSCode para edição rápida
alias reload='source ~/.bashrc'                                                                                 # Recarrega o bashrc sem fechar o terminal

# ATUALIZAÇÕES
alias update='sudo apt update && sudo apt upgrade -y'                                                           # Atualiza a lista de pacotes e instala atualizações do sistema
alias update-snap='sudo snap refresh'                                                                           # Atualiza todos os apps instalados via Snap
alias update-flatpak='flatpak update -y'                                                                        # Atualiza todos os apps instalados via Flatpak
alias update-all='sudo apt update && sudo apt upgrade -y && sudo snap refresh && flatpak update -y'             # Atualiza apt, snap e flatpak de uma vez

# SISTEMA
alias df='df -h'                                                                                                # Espaço em disco em formato legível
alias du='du -sh *'                                                                                             # Tamanho de cada item no diretório atual
alias free='free -h'                                                                                            # Uso de memória RAM em formato legível
alias top='htop'                                                                                                # Substitui top pelo htop (mais visual)
alias cpu='lscpu'                                                                                               # Informações detalhadas da CPU
alias nf='fastfetch'                                                                                            # Exibe informações do sistema (distro, kernel, CPU, etc.) de forma estilizada

# REDE
alias ips='ip -c -br a'                                                                                         # Mostra os endereços IP de todas as interfaces de rede de forma colorida e resumida
alias myip='curl -s ifconfig.me'                                                                                # Mostra seu IP público
alias ping='ping -c 5'                                                                                          # Ping com limite de 5 pacotes
alias ports='ss -tuln'                                                                                          # Lista todas as portas abertas

# COMANDOS
alias cat='batcat'                                                                                              # Substitui o comando cat pelo batcat, que exibe arquivos com syntax highlighting
alias ls='exa'                                                                                                  # Substitui o comando ls pelo exa, que lista arquivos com cores e ícones
alias ll='ls -lah'                                                                                              # Lista detalhada com arquivos ocultos
alias lt='tree -L 2'                                                                                            # Mostra a estrutura de diretórios em árvore com até 2 níveis de profundidade
alias cp='cp -iv'                                                                                               # Copia com confirmação e progresso
alias mv='mv -iv'                                                                                               # Move com confirmação (evita acidentes)
alias rm='rm -iv'                                                                                               # Remove com confirmação (evita acidentes)
alias mkdir='mkdir -pv'                                                                                         # Cria diretórios aninhados sem erro
alias find='fd'                                                                                                 # Substitui find pelo fd (mais rápido) — requer fd-find
alias gh='history|grep'                                                                                         # Busca um comando específico no histórico do terminal
alias h='history'                                                                                               # Histórico sem filtro
alias path='echo $PATH | tr ":" "\n"'                                                                           # Mostra o PATH linha por linha
alias c='clear'                                                                                                 # Limpa o terminal rapidinho
alias ..='cd ..'                                                                                                # Volta um diretório
alias ...='cd ../..'                                                                                            # Volta dois diretórios
alias timer='time '                                                                                             # Mede o tempo de execução de qualquer comando

# GIT
alias gadd='git add'                                                                                            # Atalho para adicionar arquivos ao staging do Git
alias gaddall='git add .'                                                                                       # Adiciona todos os arquivos modificados ao staging
alias gcom='git commit -m'                                                                                      # Atalho para fazer commit com mensagem (uso: gcom "mensagem")
alias gstatus='git status'                                                                                      # Mostra o status do repositório Git
alias glog='git log --oneline'                                                                                  # Mostra o histórico de commits de forma resumida
alias gpull='git pull'                                                                                          # Atalho para puxar alterações do repositório remoto
alias gpush='git push'                                                                                          # Atalho para enviar commits para o repositório remoto
alias gbranch='git branch'                                                                                      # Lista todas as branches locais
alias gcheckout='git checkout'                                                                                  # Muda de branch ou restaura arquivos

# DOCKER
alias dps='docker ps'                                                                                           # Lista containers rodando
alias dpa='docker ps -a'                                                                                        # Lista todos os containers
alias di='docker images'                                                                                        # Lista imagens locais do Docker
alias dstop='docker stop $(docker ps -q)'                                                                       # Para todos os containers em execução

# MISC
alias please='sudo'                                                                                             # Permite usar "please" em vez de "sudo" para executar comandos como administrador
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -' # Teste de velocidade da internet no terminal