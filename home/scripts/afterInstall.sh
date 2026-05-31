#!/usr/bin/env bash

# ============================================================
# SCRIPT DE PÓS-INSTALAÇÃO PARA LINUX
# ============================================================
# Autor     : vdonoladev
# Versão    : 2.0.0
# Descrição : Instala e configura programas essenciais após
#             uma instalação limpa do sistema Linux.
#
# USO:
#   chmod +x afterInstall.sh && ./afterInstall.sh [opções]
#
# OPÇÕES:
#   -h, --help         Exibe esta ajuda
#   -V, --version      Exibe a versão do script
#   --dry-run          Simula sem instalar nada
#   --skip-apt         Ignora instalações via APT
#   --skip-flatpak     Ignora instalações via Flatpak
#   --skip-snap        Ignora instalações via Snap
#   --skip-debs        Ignora pacotes .deb externos
#   --skip-extras      Ignora extras (Tailscale, Zed, NVM)
# ============================================================

set -euo pipefail

# ============================================================
# CORES E ESTILOS
# ============================================================

readonly RESET="\e[0m"
readonly NEGRITO="\e[1m"
readonly VERMELHO="\e[1;91m"
readonly VERDE="\e[1;92m"
readonly AMARELO="\e[1;93m"
readonly MAGENTA="\e[1;95m"
readonly CIANO="\e[1;96m"
readonly BRANCO="\e[1;97m"

# ============================================================
# CONFIGURAÇÃO DO SCRIPT
# ============================================================

readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly START_TIME="$(date +%s)"
readonly LOG_DIR="$HOME/.logs/afterinstall"
readonly LOG_FILE="${LOG_DIR}/afterInstall_$(date +%Y%m%d_%H%M%S).log"
readonly DIRECTORY_DOWNLOADS="$HOME/Programs"
readonly LOCK_FILE="/tmp/afterInstall_$(id -u).lock"

# Versão do NVM — verifique a mais recente em https://github.com/nvm-sh/nvm
readonly NVM_VERSION="v0.40.3"

# Flags de execução (modificadas por parse_args)
DRY_RUN=false
SKIP_APT=false
SKIP_FLATPAK=false
SKIP_SNAP=false
SKIP_DEBS=false
SKIP_EXTRAS=false

# Contadores
COUNT_INSTALLED=0
COUNT_SKIPPED=0
COUNT_FAILED=0

# Lista de erros acumulados
ERROS=()

# PID do processo keepalive do sudo
SUDO_KEEPALIVE_PID=""

# ============================================================
# PACOTES .DEB EXTERNOS
# Formato: "nome_arquivo.deb|URL_DE_DOWNLOAD|Nome Exibido"
# ============================================================

DEB_PACKAGES=(
    "dbeaver-ce.deb|https://dbeaver.io/files/dbeaver-ce-latest-linux-x86_64.deb|DBeaver CE"
    "ente-auth.deb|https://github.com/ente-io/ente/releases/download/auth-v4.4.17/ente-auth-v4.4.17-x86_64.deb|Ente Auth"
    "veracrypt.deb|https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.24/veracrypt-1.26.24-Debian-11-amd64.deb|VeraCrypt"
    "vscode.deb|https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64|Visual Studio Code"
)

# ============================================================
# PROGRAMAS APT
# Formato: "pacote|Nome Exibido"
# ============================================================

PROGRAMS_APT=(
    "curl|cURL"
    "fastfetch|Fastfetch"
    "flatpak|Flatpak"
    "git|Git"
    "snapd|Snapd"
    "ubuntu-restricted-extras|Ubuntu Restricted Extras"
    "wget|Wget"
)

# ============================================================
# PROGRAMAS SNAP
# Formato: "id|Nome Exibido" ou "id|Nome Exibido|--flag1 --flag2"
# Exemplo com flag: "code|VS Code|--classic"
# ============================================================

PROGRAMS_SNAP=(
    "vlc|VLC Media Player"
)

# ============================================================
# PROGRAMAS FLATPAK
# Formato: "app.id|Nome Exibido"
# ============================================================

PROGRAMS_FLATPAK=(
    "io.github.kolunmi.Bazaar|Bazaar"
    "io.github.shonebinu.Brief|Brief"
    "io.gitlab.adhami3310.Converter|Switcheroo Converter"
    "com.discordapp.Discord|Discord"
    "com.mattjakeman.ExtensionManager|Extension Manager"
    "it.mijorus.gearlever|Gear Lever"
    "be.alexandervanhee.gradia|Gradia"
    "org.localsend.localsend_app|LocalSend"
    "io.missioncenter.MissionCenter|Mission Center"
    "com.getpostman.Postman|Postman"
    "best.ellie.StartupConfiguration|Startup Configuration"
    "org.telegram.desktop|Telegram"
    "io.github.flattool.Warehouse|Warehouse"
    "com.rtosta.zapzap|ZapZap"
)

# ============================================================
# FUNÇÕES DE LOG
# ============================================================

# Exibe no terminal (com cores) e grava no arquivo (sem cores)
_log() {
    local msg="$1"
    echo -e "$msg"
    echo -e "$msg" | sed 's/\x1b\[[0-9;]*[mGKHF]//g' >> "$LOG_FILE"
}

log_info()  { _log "${VERDE}  ✓  $*${RESET}"; }
log_warn()  { _log "${AMARELO}  ⚠  $*${RESET}"; }
log_erro()  { _log "${VERMELHO}  ✗  $*${RESET}"; }
log_passo() { _log "\n${CIANO}${NEGRITO}▶ $*${RESET}"; }
log_sub()   { _log "${BRANCO}     →  $*${RESET}"; }
log_dry()   { _log "${MAGENTA}  ⬡  [DRY-RUN] $*${RESET}"; }

registrar_erro() {
    ERROS+=("$1")
    log_erro "$1"
    COUNT_FAILED=$(( COUNT_FAILED + 1 ))
}

# ============================================================
# UTILITÁRIOS
# ============================================================

comando_existe() {
    command -v "$1" &>/dev/null
}

pacote_apt_instalado() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

# Tenta baixar um arquivo com até N tentativas
baixar_com_retry() {
    local url="$1"
    local destino="$2"
    local nome="${3:-$(basename "$destino")}"
    local max=3
    local espera=5
    local tentativa

    for tentativa in $(seq 1 "$max"); do
        if wget -q --timeout=30 --tries=1 -c "$url" -O "$destino" >> "$LOG_FILE" 2>&1; then
            return 0
        fi
        if [[ "$tentativa" -lt "$max" ]]; then
            log_warn "Tentativa $tentativa/$max falhou para '$nome'. Aguardando ${espera}s..."
            sleep "$espera"
        fi
    done
    return 1
}

# Mantém o token sudo renovado em background durante toda a execução
manter_sudo_ativo() {
    while true; do
        sudo -n true 2>/dev/null
        sleep 50
    done &
    SUDO_KEEPALIVE_PID=$!
}

# ============================================================
# AJUDA E ARGUMENTOS
# ============================================================

exibir_ajuda() {
    cat << EOF

${NEGRITO}${CIANO}Script de Pós-Instalação Linux v${SCRIPT_VERSION}${RESET}

${NEGRITO}USO:${RESET}
  ./${SCRIPT_NAME} [opções]

${NEGRITO}OPÇÕES:${RESET}
  -h, --help         Exibe esta mensagem de ajuda
  -V, --version      Exibe a versão do script
  --dry-run          Simula sem instalar nada
  --skip-apt         Ignora instalações via APT
  --skip-flatpak     Ignora instalações via Flatpak
  --skip-snap        Ignora instalações via Snap
  --skip-debs        Ignora pacotes .deb externos
  --skip-extras      Ignora extras (Tailscale, Zed, NVM)

${NEGRITO}EXEMPLOS:${RESET}
  ./${SCRIPT_NAME}                             # Execução completa
  ./${SCRIPT_NAME} --dry-run                   # Apenas simulação
  ./${SCRIPT_NAME} --skip-snap --skip-flatpak  # Somente APT e .deb

EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)       exibir_ajuda; exit 0 ;;
            -V|--version)    echo "${SCRIPT_NAME} v${SCRIPT_VERSION}"; exit 0 ;;
            --dry-run)       DRY_RUN=true ;;
            --skip-apt)      SKIP_APT=true ;;
            --skip-flatpak)  SKIP_FLATPAK=true ;;
            --skip-snap)     SKIP_SNAP=true ;;
            --skip-debs)     SKIP_DEBS=true ;;
            --skip-extras)   SKIP_EXTRAS=true ;;
            *)
                echo -e "${VERMELHO}  ✗  Opção inválida: '$1'${RESET}" >&2
                echo "     Use --help para ver as opções disponíveis." >&2
                exit 1
                ;;
        esac
        shift
    done
}

# ============================================================
# VERIFICAÇÕES INICIAIS
# ============================================================

verificar_nao_root() {
    if [[ "$EUID" -eq 0 ]]; then
        log_erro "Não execute este script como root ou via sudo."
        log_erro "Execute como usuário normal: ./${SCRIPT_NAME}"
        exit 1
    fi
}

verificar_lock() {
    if [[ -f "$LOCK_FILE" ]]; then
        local pid
        pid=$(cat "$LOCK_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            log_erro "O script já está em execução (PID: $pid). Abortando."
            exit 1
        fi
        rm -f "$LOCK_FILE"
    fi
    echo "$$" > "$LOCK_FILE"
}

detectar_sistema() {
    log_passo "Detectando sistema operacional"

    if [[ ! -f /etc/os-release ]]; then
        log_erro "Não foi possível identificar o sistema (/etc/os-release não encontrado)."
        exit 1
    fi

    # shellcheck source=/dev/null
    source /etc/os-release

    log_info "Sistema:      ${PRETTY_NAME:-Desconhecido}"
    log_info "Kernel:       $(uname -r)"
    log_info "Arquitetura:  $(uname -m)"
    log_info "Usuário:      $USER"

    if ! comando_existe apt; then
        log_erro "Este script requer um sistema baseado em Debian/Ubuntu (apt não encontrado)."
        exit 1
    fi

    case "${ID:-}" in
        ubuntu|debian|linuxmint|pop|elementary|zorin|kali|neon) ;;
        *)
            if [[ "${ID_LIKE:-}" != *"ubuntu"* && "${ID_LIKE:-}" != *"debian"* ]]; then
                log_warn "Distribuição '${ID:-desconhecida}' pode não ser totalmente suportada."
            fi
            ;;
    esac
}

verificar_espaco_disco() {
    log_passo "Verificando espaço em disco"

    local kb_disponivel
    kb_disponivel=$(df -k "$HOME" | awk 'NR==2 {print $4}')
    local gb_disponivel=$(( kb_disponivel / 1024 / 1024 ))
    local gb_minimo=5

    log_info "Disponível em $HOME: ~${gb_disponivel} GB"

    if [[ "$gb_disponivel" -lt "$gb_minimo" ]]; then
        log_warn "Espaço baixo (~${gb_disponivel} GB). Mínimo recomendado: ${gb_minimo} GB."
        read -r -p "     Deseja continuar mesmo assim? [s/N] " resp
        [[ "${resp,,}" == "s" ]] || { log_warn "Operação cancelada pelo usuário."; exit 0; }
    fi
}

testar_internet() {
    log_passo "Verificando conexão com a internet"

    local hosts=("8.8.8.8" "1.1.1.1" "9.9.9.9")
    local host

    for host in "${hosts[@]}"; do
        if ping -c 1 -W 3 "$host" &>/dev/null; then
            log_info "Conexão ativa (${host})."
            return 0
        fi
    done

    log_erro "Sem conexão com a internet. Verifique sua rede e tente novamente."
    exit 1
}

verificar_sudo() {
    log_passo "Verificando privilégios sudo"

    if ! sudo -v 2>/dev/null; then
        log_erro "Não foi possível obter privilégios sudo. Configure o sudoers."
        exit 1
    fi

    manter_sudo_ativo
    log_info "Privilégios sudo OK."
}

confirmacao_inicio() {
    echo ""
    _log "${NEGRITO}  Etapas que serão executadas:${RESET}"
    [[ "$SKIP_APT" == "false" ]]     && _log "    ${VERDE}•${RESET} APT             → ${#PROGRAMS_APT[@]} pacotes"
    [[ "$SKIP_DEBS" == "false" ]]    && _log "    ${VERDE}•${RESET} .deb externos   → ${#DEB_PACKAGES[@]} pacotes"
    [[ "$SKIP_SNAP" == "false" ]]    && _log "    ${VERDE}•${RESET} Snap            → ${#PROGRAMS_SNAP[@]} aplicativos"
    [[ "$SKIP_FLATPAK" == "false" ]] && _log "    ${VERDE}•${RESET} Flatpak         → ${#PROGRAMS_FLATPAK[@]} aplicativos"
    [[ "$SKIP_EXTRAS" == "false" ]]  && _log "    ${VERDE}•${RESET} Extras          → Tailscale, Zed Editor, NVM ${NVM_VERSION}"

    if [[ "$DRY_RUN" == "true" ]]; then
        echo ""
        _log "  ${MAGENTA}${NEGRITO}  ★ MODO DRY-RUN ATIVO — nenhum pacote será instalado${RESET}"
    fi

    echo ""
    read -r -p "  Deseja continuar? [S/n] " resp
    resp="${resp:-S}"

    if [[ ! "${resp,,}" =~ ^(s|sim|y|yes)$ ]]; then
        _log "\n${AMARELO}  Operação cancelada pelo usuário.${RESET}"
        exit 0
    fi
    echo ""
}

# ============================================================
# TRAP E CLEANUP
# ============================================================

cleanup() {
    local code=$?

    [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    rm -f "$LOCK_FILE"

    case "$code" in
        0)   ;; # Sucesso — resumo já foi exibido por exibir_resumo
        130) echo -e "\n${AMARELO}  Interrompido pelo usuário (Ctrl+C).${RESET}" ;;
        143) echo -e "\n${VERMELHO}  Script terminado por sinal externo (SIGTERM).${RESET}" ;;
        *)
            echo -e "${VERMELHO}  Script encerrado com erro (código: ${code}).${RESET}"
            echo -e "${VERMELHO}  Verifique o log em: ${LOG_FILE}${RESET}"
            ;;
    esac
}

trap 'cleanup'  EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# ============================================================
# APT
# ============================================================

remover_locks_apt() {
    log_sub "Removendo locks do APT..."
    sudo rm -f \
        /var/lib/dpkg/lock \
        /var/lib/dpkg/lock-frontend \
        /var/cache/apt/archives/lock
    sudo dpkg --configure -a >> "$LOG_FILE" 2>&1 || true
}

atualizar_sistema() {
    log_passo "Atualizando repositórios e sistema"
    remover_locks_apt

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "apt update && apt dist-upgrade -y"
        return
    fi

    if sudo apt update -y >> "$LOG_FILE" 2>&1; then
        log_info "Repositórios atualizados."
    else
        registrar_erro "Falha ao atualizar repositórios APT."
    fi

    if sudo apt dist-upgrade -y >> "$LOG_FILE" 2>&1; then
        log_info "Sistema atualizado."
    else
        registrar_erro "Falha ao executar dist-upgrade."
    fi
}

instalar_apt() {
    [[ "$SKIP_APT" == "true" ]] && { log_warn "APT ignorado (--skip-apt)."; return; }
    log_passo "Instalando pacotes via APT"

    local pacote nome
    for entrada in "${PROGRAMS_APT[@]}"; do
        IFS='|' read -r pacote nome <<< "$entrada" || true

        if pacote_apt_instalado "$pacote"; then
            log_warn "Já instalado: $nome"
            COUNT_SKIPPED=$(( COUNT_SKIPPED + 1 ))
        elif [[ "$DRY_RUN" == "true" ]]; then
            log_dry "apt install $pacote  [$nome]"
        else
            log_sub "Instalando: $nome..."
            if sudo apt install "$pacote" -y >> "$LOG_FILE" 2>&1; then
                log_info "Instalado: $nome"
                COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
            else
                registrar_erro "Falha via APT: $nome ($pacote)"
            fi
        fi
    done
}

# ============================================================
# PACOTES .DEB EXTERNOS
# ============================================================

instalar_debs() {
    [[ "$SKIP_DEBS" == "true" ]] && { log_warn ".deb externos ignorados (--skip-debs)."; return; }
    log_passo "Baixando e instalando pacotes .deb externos"

    mkdir -p "$DIRECTORY_DOWNLOADS"

    local arquivo url nome destino
    local -a debs_baixados=()

    for entrada in "${DEB_PACKAGES[@]}"; do
        IFS='|' read -r arquivo url nome <<< "$entrada" || true
        destino="${DIRECTORY_DOWNLOADS}/${arquivo}"

        if [[ "$DRY_RUN" == "true" ]]; then
            log_dry "wget '$url' → '$destino'  [$nome]"
            continue
        fi

        log_sub "Baixando: $nome..."
        if baixar_com_retry "$url" "$destino" "$nome"; then
            log_info "Download concluído: $nome"
            debs_baixados+=("$destino")
        else
            registrar_erro "Falha no download: $nome"
        fi
    done

    if [[ "${#debs_baixados[@]}" -gt 0 ]]; then
        log_sub "Instalando ${#debs_baixados[@]} pacote(s) .deb..."
        if sudo dpkg -i "${debs_baixados[@]}" >> "$LOG_FILE" 2>&1; then
            log_info "Todos os .deb instalados com sucesso."
            COUNT_INSTALLED=$(( COUNT_INSTALLED + ${#debs_baixados[@]} ))
        else
            log_warn "Alguns .deb falharam. Corrigindo dependências..."
            sudo apt --fix-broken install -y >> "$LOG_FILE" 2>&1 || true
        fi
    fi
}

# ============================================================
# SNAPD + SNAP
# ============================================================

instalar_snapd() {
    [[ "$SKIP_SNAP" == "true" ]] && return
    log_passo "Verificando Snapd"

    if comando_existe snap; then
        log_warn "Snapd já instalado."
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "apt install snapd && systemctl enable --now snapd.socket"
        return
    fi

    log_sub "Instalando Snapd..."
    if sudo apt install snapd -y >> "$LOG_FILE" 2>&1; then
        sudo systemctl enable --now snapd.socket >> "$LOG_FILE" 2>&1 || true
        [[ -e /snap ]] || sudo ln -sf /var/lib/snapd/snap /snap
        log_info "Snapd instalado."
    else
        registrar_erro "Falha ao instalar Snapd."
    fi
}

instalar_snaps() {
    [[ "$SKIP_SNAP" == "true" ]] && { log_warn "Snap ignorado (--skip-snap)."; return; }
    log_passo "Instalando aplicativos via Snap"

    if ! comando_existe snap; then
        registrar_erro "Snap não disponível. O Snapd não foi instalado corretamente."
        return
    fi

    # Formato: "id|Nome Exibido" ou "id|Nome Exibido|--flags"
    local id nome flags
    for entrada in "${PROGRAMS_SNAP[@]}"; do
        IFS='|' read -r id nome flags <<< "$entrada" || true
        flags="${flags:-}"

        if snap list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$id"; then
            log_warn "Já instalado: $nome"
            COUNT_SKIPPED=$(( COUNT_SKIPPED + 1 ))
        elif [[ "$DRY_RUN" == "true" ]]; then
            log_dry "snap install $id${flags:+ $flags}  [$nome]"
        else
            log_sub "Instalando: $nome..."
            # shellcheck disable=SC2086
            if sudo snap install "$id" $flags >> "$LOG_FILE" 2>&1; then
                log_info "Instalado: $nome"
                COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
            else
                registrar_erro "Falha via Snap: $nome ($id)"
            fi
        fi
    done
}

# ============================================================
# FLATPAK
# ============================================================

instalar_flatpaks() {
    [[ "$SKIP_FLATPAK" == "true" ]] && { log_warn "Flatpak ignorado (--skip-flatpak)."; return; }
    log_passo "Instalando aplicativos via Flatpak"

    if ! comando_existe flatpak; then
        registrar_erro "Flatpak não encontrado. Instale o flatpak via APT primeiro."
        return
    fi

    log_sub "Adicionando repositório Flathub..."
    flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1 || true

    local id nome
    for entrada in "${PROGRAMS_FLATPAK[@]}"; do
        IFS='|' read -r id nome <<< "$entrada" || true

        if flatpak info "$id" &>/dev/null; then
            log_warn "Já instalado: $nome"
            COUNT_SKIPPED=$(( COUNT_SKIPPED + 1 ))
        elif [[ "$DRY_RUN" == "true" ]]; then
            log_dry "flatpak install flathub $id  [$nome]"
        else
            log_sub "Instalando: $nome..."
            if flatpak install flathub "$id" -y --noninteractive >> "$LOG_FILE" 2>&1; then
                log_info "Instalado: $nome"
                COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
            else
                registrar_erro "Falha via Flatpak: $nome ($id)"
            fi
        fi
    done
}

# ============================================================
# TAILSCALE
# ============================================================

instalar_tailscale() {
    [[ "$SKIP_EXTRAS" == "true" ]] && return
    log_passo "Instalando Tailscale"

    if comando_existe tailscale; then
        log_warn "Tailscale já instalado."
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "curl -fsSL https://tailscale.com/install.sh | sh"
        return
    fi

    log_sub "Instalando via script oficial..."
    if curl -fsSL https://tailscale.com/install.sh | sh >> "$LOG_FILE" 2>&1; then
        log_info "Tailscale instalado."
        COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
    else
        registrar_erro "Falha ao instalar Tailscale."
    fi
}

# ============================================================
# ZED EDITOR
# ============================================================

instalar_zed() {
    [[ "$SKIP_EXTRAS" == "true" ]] && return
    log_passo "Instalando Zed Editor"

    if comando_existe zed; then
        log_warn "Zed Editor já instalado."
        return
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "curl -f https://zed.dev/install.sh | sh"
        return
    fi

    log_sub "Instalando via script oficial..."
    if curl -f https://zed.dev/install.sh | sh >> "$LOG_FILE" 2>&1; then
        log_info "Zed Editor instalado."
        COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
    else
        registrar_erro "Falha ao instalar Zed Editor."
    fi
}

# ============================================================
# NVM (Node Version Manager)
# ============================================================

instalar_nvm() {
    [[ "$SKIP_EXTRAS" == "true" ]] && return
    log_passo "Instalando NVM ${NVM_VERSION}"

    if [[ -d "$HOME/.nvm" ]]; then
        log_warn "NVM já instalado em ~/.nvm"
        return
    fi

    local nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "curl -o- $nvm_url | bash"
        return
    fi

    log_sub "Instalando NVM ${NVM_VERSION}..."
    if curl -o- "$nvm_url" | bash >> "$LOG_FILE" 2>&1; then
        log_info "NVM instalado. Execute 'source ~/.bashrc' para ativar."
        COUNT_INSTALLED=$(( COUNT_INSTALLED + 1 ))
    else
        registrar_erro "Falha ao instalar NVM."
    fi
}

# ============================================================
# LIMPEZA FINAL
# ============================================================

limpeza_final() {
    log_passo "Limpeza e atualização final do sistema"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "apt autoclean + autoremove + flatpak update + snap refresh"
        return
    fi

    sudo apt autoclean -y >> "$LOG_FILE" 2>&1 || true
    sudo apt autoremove -y >> "$LOG_FILE" 2>&1 || true

    if comando_existe flatpak; then
        flatpak update -y >> "$LOG_FILE" 2>&1 || true
        log_info "Flatpaks atualizados."
    fi

    if comando_existe snap; then
        sudo snap refresh >> "$LOG_FILE" 2>&1 || true
        log_info "Snaps atualizados."
    fi

    log_info "Limpeza concluída."
}

# ============================================================
# RESUMO FINAL
# ============================================================

exibir_resumo() {
    local fim
    fim="$(date +%s)"
    local duracao=$(( fim - START_TIME ))
    local min=$(( duracao / 60 ))
    local seg=$(( duracao % 60 ))

    echo ""
    _log "${CIANO}${NEGRITO}  ─────────────────────────────────────────────${RESET}"
    _log "${VERDE}${NEGRITO}  INSTALAÇÃO CONCLUÍDA${RESET}"
    _log "${CIANO}${NEGRITO}  ─────────────────────────────────────────────${RESET}"
    echo ""
    _log "  ${VERDE}✓  Instalados:        ${COUNT_INSTALLED}${RESET}"
    _log "  ${AMARELO}⊘  Já instalados:     ${COUNT_SKIPPED}${RESET}"
    _log "  ${VERMELHO}✗  Falhas:            ${COUNT_FAILED}${RESET}"
    _log "  ${CIANO}⏱  Tempo de execução: ${min}m ${seg}s${RESET}"
    echo ""

    if [[ "${#ERROS[@]}" -gt 0 ]]; then
        _log "  ${VERMELHO}${NEGRITO}Erros encontrados:${RESET}"
        local err
        for err in "${ERROS[@]}"; do
            _log "    ${VERMELHO}• $err${RESET}"
        done
        echo ""
    fi

    _log "  ${AMARELO}${NEGRITO}Próximos passos:${RESET}"
    _log "  • Execute 'source ~/.bashrc' para ativar o NVM"
    _log "  • Snaps podem exigir logout/login para funcionar corretamente"
    _log "  • Flatpaks estarão disponíveis no menu de aplicativos"
    _log "  • Reinicie o sistema para aplicar todas as mudanças"
    echo ""
    _log "  ${CIANO}Log completo salvo em: ${LOG_FILE}${RESET}"
    echo ""
}

# ============================================================
# PRINCIPAL
# ============================================================

main() {
    # Garantir que os diretórios necessários existam antes de qualquer log
    mkdir -p "$LOG_DIR" "$DIRECTORY_DOWNLOADS"

    parse_args "$@"

    # Cabeçalho
    clear
    _log ""
    _log "${VERDE}${NEGRITO}  ╔═════════════════════════════════════════════════╗${RESET}"
    _log "${VERDE}${NEGRITO}  ║    SCRIPT DE PÓS-INSTALAÇÃO LINUX v${SCRIPT_VERSION}          ║${RESET}"
    _log "${VERDE}${NEGRITO}  ║    Autor: vdonoladev                             ║${RESET}"
    _log "${VERDE}${NEGRITO}  ╚═════════════════════════════════════════════════╝${RESET}"
    _log ""
    _log "  ${CIANO}Iniciado:  $(date '+%d/%m/%Y às %H:%M:%S')${RESET}"
    _log "  ${CIANO}Log:       ${LOG_FILE}${RESET}"
    echo ""

    verificar_nao_root
    verificar_lock
    detectar_sistema
    verificar_espaco_disco
    testar_internet
    verificar_sudo
    confirmacao_inicio

    atualizar_sistema
    instalar_snapd
    instalar_debs
    instalar_apt
    instalar_flatpaks
    instalar_snaps
    instalar_tailscale
    instalar_zed
    instalar_nvm
    limpeza_final
    exibir_resumo
}

main "$@"
