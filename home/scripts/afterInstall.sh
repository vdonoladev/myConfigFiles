#!/bin/bash

# ============================================
# SCRIPT DE PÓS-INSTALAÇÃO PARA LINUX
# ============================================
# Autor: vdonoladev
# Descrição: Instala programas essenciais via APT, Flatpak e Snap
#
# COMO USAR:
#   sudo chmod +x afterInstall.sh
#   ./afterInstall.sh
#
# PARA ADICIONAR NOVOS PROGRAMAS, edite apenas as seções marcadas com
# ">>> ADICIONE AQUI <<<" abaixo.
# ============================================

set -euo pipefail

# ============================================
# CORES PARA OUTPUT NO TERMINAL
# ============================================

VERMELHO="\e[1;91m"
VERDE="\e[1;92m"
AMARELO="\e[1;93m"
CIANO="\e[1;96m"
BRANCO="\e[1;97m"
SEM_COR="\e[0m"

# ============================================
# VARIÁVEIS GLOBAIS
# ============================================

DIRECTORY_DOWNLOADS="$HOME/Programs"
LOG_FILE="$HOME/afterInstall_$(date +%Y%m%d_%H%M%S).log"
ERROS=()

# ============================================
# URLS DE PACOTES .DEB EXTERNOS
# >>> ADICIONE AQUI novas URLs de .deb <<<
# Formato: URL_NOME="https://..."
# ============================================

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_ENTE_AUTH="https://github.com/ente-io/ente/releases/download/auth-v4.3.2/ente-auth-v4.3.2-x86_64.deb"

# Coloque as URLs acima neste array para que sejam baixadas automaticamente:
DEB_URLS=(
    "$URL_GOOGLE_CHROME"
    "$URL_ENTE_AUTH"
    # >>> ADICIONE AQUI mais URLs de .deb <<<
    # Exemplo: "https://exemplo.com/programa.deb"
)

# ============================================
# PROGRAMAS APT
# >>> ADICIONE AQUI novos pacotes APT <<<
# Formato: "nome_do_pacote"
# ============================================

PROGRAMS_APT=(
    wget
    flatpak
    snapd
    curl
    ubuntu-restricted-extras
    fastfetch
    code
    git
    # >>> ADICIONE AQUI mais pacotes APT <<<
    # Exemplo: "htop"
    # Exemplo: "vlc"
)

# ============================================
# PROGRAMAS SNAP
# >>> ADICIONE AQUI novos pacotes Snap <<<
# Formato: "nome_do_snap|--flag|Descrição amigável"
# Flags comuns: --classic, --beta, --edge (ou deixe vazio)
# ============================================

PROGRAMS_SNAP=(
    "phpstorm|--classic|PHPStorm - IDE para PHP"
    "rider|--classic|Rider - IDE para .NET"
    # >>> ADICIONE AQUI mais pacotes Snap <<<
    # Exemplo: "spotify||Spotify"
    # Exemplo: "vlc||VLC Media Player"
)

# ============================================
# PROGRAMAS FLATPAK
# >>> ADICIONE AQUI novos pacotes Flatpak <<<
# Formato: "id.do.app|Nome Amigável"
# ============================================

PROGRAMS_FLATPAK=(
    "com.bitwarden.desktop|Bitwarden"
    "org.telegram.desktop|Telegram"
    "org.localsend.localsend_app|LocalSend"
    "io.github.flattool.Warehouse|Warehouse"
    "com.discordapp.Discord|Discord"
    "com.spotify.Client|Spotify"
    "org.videolan.VLC|VLC"
    # >>> ADICIONE AQUI mais pacotes Flatpak <<<
    # Exemplo: "org.gimp.GIMP|GIMP"
    # Exemplo: "com.obsproject.Studio|OBS Studio"
)

# ============================================
# FUNÇÕES AUXILIARES
# ============================================

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

info()    { log "${VERDE}[INFO]  $*${SEM_COR}"; }
aviso()   { log "${AMARELO}[AVISO] $*${SEM_COR}"; }
erro()    { log "${VERMELHO}[ERRO]  $*${SEM_COR}"; }
titulo()  { log "\n${CIANO}${BRANCO}>>> $* <<<${SEM_COR}"; }

registrar_erro() {
    ERROS+=("$1")
    erro "$1"
}

comando_existe() {
    command -v "$1" &>/dev/null
}

# ============================================
# VERIFICAÇÕES INICIAIS
# ============================================

verificar_root() {
    if [[ "$EUID" -eq 0 ]]; then
        erro "Não execute este script como root/sudo diretamente."
        erro "Execute como usuário normal: ./afterInstall.sh"
        exit 1
    fi
}

testar_internet() {
    titulo "Testando conexão com a internet"
    if ! ping -c 1 8.8.8.8 &>/dev/null; then
        erro "Sem conexão com a internet. Verifique sua rede e tente novamente."
        exit 1
    fi
    info "Conexão OK."
}

# ============================================
# APT
# ============================================

remover_locks_apt() {
    info "Removendo locks do APT..."
    sudo rm -f /var/lib/dpkg/lock-frontend
    sudo rm -f /var/cache/apt/archives/lock
}

atualizar_sistema() {
    titulo "Atualizando repositórios e sistema"
    remover_locks_apt
    sudo apt update -y
    sudo apt dist-upgrade -y
}

instalar_apt() {
    titulo "Instalando programas via APT"
    for programa in "${PROGRAMS_APT[@]}"; do
        if dpkg -l | grep -q "^ii  $programa "; then
            aviso "Já instalado: $programa"
        else
            info "Instalando: $programa"
            if sudo apt install "$programa" -y; then
                info "Instalado com sucesso: $programa"
            else
                registrar_erro "Falha ao instalar via APT: $programa"
            fi
        fi
    done
}

# ============================================
# PACOTES .DEB EXTERNOS
# ============================================

instalar_debs() {
    titulo "Baixando e instalando pacotes .deb externos"
    mkdir -p "$DIRECTORY_DOWNLOADS"

    for url in "${DEB_URLS[@]}"; do
        nome_arquivo=$(basename "$url")
        destino="$DIRECTORY_DOWNLOADS/$nome_arquivo"

        info "Baixando: $nome_arquivo"
        if wget -c "$url" -O "$destino" 2>>"$LOG_FILE"; then
            info "Download concluído: $nome_arquivo"
        else
            registrar_erro "Falha no download: $url"
        fi
    done

    info "Instalando pacotes .deb baixados..."
    if sudo dpkg -i "$DIRECTORY_DOWNLOADS"/*.deb 2>>"$LOG_FILE"; then
        info "Pacotes .deb instalados."
    else
        aviso "Alguns .debs falharam. Tentando corrigir dependências..."
    fi

    sudo apt --fix-broken install -y
}

# ============================================
# SNAPD
# ============================================

instalar_snapd() {
    titulo "Verificando Snapd"
    if ! comando_existe snap; then
        info "Instalando Snapd..."
        sudo apt install snapd -y
        sudo systemctl enable --now snapd.socket
        sudo ln -sf /var/lib/snapd/snap /snap
        info "Snapd instalado."
    else
        aviso "Snapd já está instalado."
    fi
}

instalar_snaps() {
    titulo "Instalando programas via Snap"
    for entrada in "${PROGRAMS_SNAP[@]}"; do
        IFS='|' read -r nome flags descricao <<< "$entrada"

        if snap list 2>/dev/null | grep -q "^$nome "; then
            aviso "Já instalado: $descricao"
        else
            info "Instalando: $descricao"
            # shellcheck disable=SC2086
            if sudo snap install "$nome" $flags; then
                info "Instalado com sucesso: $descricao"
            else
                registrar_erro "Falha ao instalar via Snap: $descricao ($nome)"
            fi
        fi
    done
}

# ============================================
# FLATPAK
# ============================================

instalar_flatpaks() {
    titulo "Instalando programas via Flatpak"

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    for entrada in "${PROGRAMS_FLATPAK[@]}"; do
        IFS='|' read -r id nome <<< "$entrada"

        if flatpak list 2>/dev/null | grep -q "$id"; then
            aviso "Já instalado: $nome"
        else
            info "Instalando: $nome"
            if flatpak install flathub "$id" -y; then
                info "Instalado com sucesso: $nome"
            else
                registrar_erro "Falha ao instalar via Flatpak: $nome ($id)"
            fi
        fi
    done
}

# ============================================
# LIMPEZA FINAL
# ============================================

limpeza_final() {
    titulo "Limpeza e atualização final"
    sudo apt update && sudo apt dist-upgrade -y
    flatpak update -y
    sudo snap refresh
    sudo apt autoclean -y
    sudo apt autoremove -y
    info "Limpeza concluída."
}

# ============================================
# RESUMO FINAL
# ============================================

exibir_resumo() {
    echo ""
    log "${VERDE}========================================${SEM_COR}"
    log "${VERDE}           INSTALAÇÃO CONCLUÍDA         ${SEM_COR}"
    log "${VERDE}========================================${SEM_COR}"

    if [[ ${#ERROS[@]} -eq 0 ]]; then
        log "${VERDE}✓ Tudo instalado sem erros!${SEM_COR}"
    else
        log "${AMARELO}⚠ Instalação concluída com ${#ERROS[@]} erro(s):${SEM_COR}"
        for err in "${ERROS[@]}"; do
            log "  ${VERMELHO}• $err${SEM_COR}"
        done
    fi

    echo ""
    log "${AMARELO}OBSERVAÇÕES:${SEM_COR}"
    log "  • Snaps podem precisar de logout/login para funcionar"
    log "  • Flatpaks estarão disponíveis no menu de aplicativos"
    log "  • Recomenda-se reiniciar o sistema"
    log "  • Log completo salvo em: ${LOG_FILE}"
    echo ""
}

# ============================================
# EXECUÇÃO PRINCIPAL
# ============================================

main() {
    # Cabeçalho
    clear
    log "${VERDE}========================================"
    log "     SCRIPT DE PÓS-INSTALAÇÃO LINUX     "
    log "========================================${SEM_COR}"
    log "Log: ${LOG_FILE}"
    echo ""

    verificar_root
    testar_internet
    atualizar_sistema
    instalar_snapd
    instalar_debs
    instalar_apt
    instalar_flatpaks
    instalar_snaps
    limpeza_final
    exibir_resumo
}

main "$@"
