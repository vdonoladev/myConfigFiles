# CONFIGURAÇÕES
alias aliasconf='cursor .bash_aliases' # Abre o arquivo .bash_aliases no editor Cursor para edição rápida

# COMANDOS
alias cat='batcat' # Substitui o comando cat pelo batcat, que exibe arquivos com syntax highlighting
alias update='sudo apt update && sudo apt upgrade -y' # Atualiza a lista de pacotes e instala atualizações do sistema
alias ips='ip -c -br a' # Mostra os endereços IP de todas as interfaces de rede de forma colorida e resumida
alias ls='exa' # Substitui o comando ls pelo exa, que lista arquivos com cores e ícones
alias gh='history|grep' # Busca um comando específico no histórico do terminal
alias lt='tree -L 2' # Mostra a estrutura de diretórios em árvore com até 2 níveis de profundidade

# Git
alias gadd='git add' # Atalho para adicionar arquivos ao staging do Git
alias gaddall='git add .' # Adiciona todos os arquivos modificados ao staging
alias gcom='git commit -m' # Atalho para fazer commit com mensagem (uso: gcom "mensagem")
alias gstatus='git status' # Mostra o status do repositório Git
alias glog='git log --oneline' # Mostra o histórico de commits de forma resumida
alias gpull='git pull' # Atalho para puxar alterações do repositório remoto
alias gpush='git push' # Atalho para enviar commits para o repositório remoto
alias gbranch='git branch' # Lista todas as branches locais
alias gcheckout='git checkout' # Muda de branch ou restaura arquivos

# MISC
alias please='sudo' # Permite usar "please" em vez de "sudo" para executar comandos como administrador
alias nf='neofetch' # Exibe informações do sistema (distro, kernel, CPU, etc.) de forma estilizada
