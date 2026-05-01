#!/usr/bin/env bash
# ============================================================
#  Instalador do JetBrains Toolbox App — Linux (x86_64)
#  Segue o passo a passo oficial da JetBrains
#
#  COMO USAR:
#    1. Baixe o .tar.gz em: https://www.jetbrains.com/toolbox-app/
#    2. Coloque o arquivo na mesma pasta deste script
#    3. Execute:  bash installJetbrainsToolbox.sh
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[ OK ]${NC} $*"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $*"; }
error() { echo -e "${RED}[ERRO]${NC} $*"; exit 1; }

INSTALL_DIR="/opt/jetbrains-toolbox"

# ============================================================
# PASSO 1 — Encontrar o tarball na pasta atual
# ============================================================
echo ""
info "PASSO 1 — Procurando o arquivo .tar.gz do Toolbox..."

TARBALL=$(ls jetbrains-toolbox-*.tar.gz 2>/dev/null | head -1)

if [[ -z "$TARBALL" ]]; then
  error "Nenhum arquivo jetbrains-toolbox-*.tar.gz encontrado nesta pasta.
       Baixe em: https://www.jetbrains.com/toolbox-app/
       Coloque o arquivo aqui e rode o script novamente."
fi

ok "Encontrado: $TARBALL"

# ============================================================
# PASSO 2 — Verificar FUSE2 (necessário no Ubuntu 22.04+)
# ============================================================
echo ""
info "PASSO 2 — Verificando dependências..."

if ! ldconfig -p 2>/dev/null | grep -q libfuse2; then
  warn "libfuse2 não encontrada. Tentando instalar..."
  sudo apt-get install -y libfuse2 2>/dev/null \
    || warn "Não instalou automaticamente. Se o Toolbox não abrir, rode: sudo apt install libfuse2"
else
  ok "libfuse2 OK"
fi

# ============================================================
# PASSO 3 — Extrair para pasta temporária e localizar o binário
# ============================================================
echo ""
info "PASSO 3 — Extraindo o tarball..."

TMP_EXTRACT="/tmp/jb-toolbox-$$"
mkdir -p "$TMP_EXTRACT"

tar -xvf "$TARBALL" -C "$TMP_EXTRACT"

# Localiza o binário independente da profundidade de pastas do tarball
BINARY=$(find "$TMP_EXTRACT" -type f -name "jetbrains-toolbox" | head -1)

if [[ -z "$BINARY" ]]; then
  rm -rf "$TMP_EXTRACT"
  error "Binário 'jetbrains-toolbox' não encontrado dentro do tarball."
fi

ok "Binário encontrado em: $BINARY"

# ============================================================
# PASSO 4 — Copiar para o diretório de instalação
# ============================================================
echo ""
info "PASSO 4 — Instalando em ${INSTALL_DIR}..."

sudo mkdir -p "$INSTALL_DIR"

# Copia o conteúdo da pasta onde está o binário
BINARY_DIR=$(dirname "$BINARY")
sudo cp -r "$BINARY_DIR"/. "$INSTALL_DIR/"

sudo chmod +x "${INSTALL_DIR}/jetbrains-toolbox"

ok "Arquivos copiados para ${INSTALL_DIR}"

# ============================================================
# PASSO 5 — Criar link simbólico global
# ============================================================
echo ""
info "PASSO 5 — Criando link simbólico em /usr/local/bin..."

sudo ln -sf "${INSTALL_DIR}/jetbrains-toolbox" /usr/local/bin/jetbrains-toolbox

ok "Agora você pode rodar 'jetbrains-toolbox' de qualquer terminal"

# ============================================================
# PASSO 6 — Limpeza dos arquivos temporários
# ============================================================
rm -rf "$TMP_EXTRACT"
ok "Arquivos temporários removidos"

# ============================================================
# PASSO 7 — Primeiro lançamento
#           Inicializa ~/.local/share/JetBrains/Toolbox
#           e cria ~/.local/share/applications/jetbrains-toolbox.desktop
# ============================================================
echo ""
info "PASSO 6 — Iniciando o Toolbox pela primeira vez..."
info "  Serão criados automaticamente:"
info "  • ~/.local/share/JetBrains/Toolbox         (configurações)"
info "  • ~/.local/share/applications/*.desktop    (atalho no menu)"
echo ""

nohup "${INSTALL_DIR}/jetbrains-toolbox" &>/dev/null &
sleep 2

ok "Toolbox iniciado em background."

# ============================================================
# RESUMO
# ============================================================
echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  JetBrains Toolbox instalado com sucesso!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "  Binário:         ${CYAN}${INSTALL_DIR}/jetbrains-toolbox${NC}"
echo -e "  Comando global:  ${CYAN}jetbrains-toolbox${NC}"
echo -e "  Configurações:   ${CYAN}~/.local/share/JetBrains/Toolbox${NC}"
echo -e "  Atalho menu:     ${CYAN}~/.local/share/applications/${NC}"
echo ""
echo -e "  ${YELLOW}Próximos passos:${NC}"
echo -e "  1. Faça login na sua conta JetBrains no Toolbox que abriu"
echo -e "  2. Escolha o IDE que deseja instalar (IntelliJ, PyCharm, etc.)"
echo -e "  3. Para versão específica: clique em '...' no produto → 'Available versions'"
echo ""
