#!/bin/bash

# ============================================
# SCRIPT DE PÓS-INSTALAÇÃO PARA LINUX
# ============================================
# Autor: vdonoladev
# Descrição: Instala programas essenciais via APT, Flatpak e Snap
# 
# COMO USAR:
# sudo chmod +x afterInstall.sh
# ./afterInstall.sh
# ============================================

# Para a execução do script se qualquer comando retornar erro
set -e

# ============================================
# VARIÁVEIS DE URL PARA DOWNLOAD
# ============================================

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_ENTE_AUTH="https://github.com/ente-io/ente/releases/download/auth-v4.3.2/ente-auth-v4.3.2-x86_64.deb"

# ============================================
# DIRETÓRIOS E ARQUIVOS
# ============================================

# Diretório onde os .deb baixados serão salvos
DIRECTORY_DOWNLOADS="$HOME/Programs"

# ============================================
# CORES PARA OUTPUT NO TERMINAL
# ============================================

VERMELHO="\e[1;91m"     # Vermelho para erros
VERDE="\e[1;92m"        # Verde para informações
AMARELO="\e[1;93m"      # Amarelo para avisos
WITHOUT_COLOR="\e[0m"   # Reseta a cor

# ============================================
# LISTA DE PROGRAMAS APT PARA INSTALAR
# ============================================

# Programas disponíveis nos repositórios oficiais do Ubuntu/Debian
PROGRAMS_TO_INSTALL=(
	wget                        # Ferramenta para download de arquivos
	flatpak                     # Sistema de empacotamento de aplicativos
	snapd                       # Daemon do Snap (gerenciador de pacotes)
	curl                        # Ferramenta para transferência de dados
	ubuntu-restricted-extras    # Codecs multimídia e fontes
	neofetch                    # Ferramenta que exibe informações do sistema
	code                        # Visual Studio Code
	git                         # Sistema de controle de versão
)

# ============================================
# LISTA DE PROGRAMAS SNAP PARA INSTALAR
# ============================================

# Array associativo: "nome_do_pacote:flags:descrição"
declare -A SNAP_PROGRAMS=(
	["phpstorm"]="--classic:IDE para PHP da JetBrains"
	["rider"]="--classic:IDE para .NET da JetBrains"
)

# ============================================
# LISTA DE PROGRAMAS FLATPAK PARA INSTALAR
# ============================================

# Array associativo: "id_do_app:nome_amigável"
declare -A FLATPAK_PROGRAMS=(
	["com.bitwarden.desktop"]="Bitwarden"
	["org.telegram.desktop"]="Telegram"
	["org.localsend.localsend_app"]="LocalSend"
	["io.github.flattool.Warehouse"]="Warehouse"
	["com.discordapp.Discord"]="Discord"
	["com.spotify.Client"]="Spotify"
	["org.videolan.VLC"]="VLC"
)

# ============================================
# FUNÇÕES DO SCRIPT
# ============================================

# Atualiza repositórios e realiza atualização completa do sistema
apt_update() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Atualizando repositórios e sistema...${WITHOUT_COLOR}"
	sudo apt update && sudo apt dist-upgrade -y
}

# Testa conexão com a internet antes de continuar
testing_internet() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Testando conexão com a internet...${WITHOUT_COLOR}"
	if ! ping -c 1 8.8.8.8 &>/dev/null; then
		echo -e "${VERMELHO}[ERRO!] - O computador não tem conexão com a Internet. Verifique sua rede.${WITHOUT_COLOR}"
		exit 1
	else
		echo -e "${VERDE}[INFORMAÇÃO!] - Conexão com a internet está funcionando normalmente.${WITHOUT_COLOR}"
	fi
}

# Remove locks do APT que podem estar travando o gerenciador de pacotes
lock_apt() {
	echo -e "${AMARELO}[INFORMAÇÃO!] - Removendo locks do APT...${WITHOUT_COLOR}"
	sudo rm -f /var/lib/dpkg/lock-frontend
	sudo rm -f /var/cache/apt/archives/lock
}

# Adiciona suporte para arquitetura de 32 bits (necessário para alguns programas)
add_archi386() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Adicionando arquitetura i386 (32 bits)...${WITHOUT_COLOR}"
	sudo dpkg --add-architecture i386
}

# Atualiza apenas a lista de pacotes (mais rápido que dist-upgrade)
just_apt_update() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Atualizando lista de pacotes...${WITHOUT_COLOR}"
	sudo apt update -y
}

# ============================================
# INSTALAÇÃO DO SNAPD
# ============================================

install_snapd() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Verificando instalação do Snapd...${WITHOUT_COLOR}"
	
	# Verifica se o snap já está instalado
	if ! command -v snap &> /dev/null; then
		echo -e "${VERDE}[INFORMAÇÃO!] - Instalando Snapd...${WITHOUT_COLOR}"
		sudo apt install snapd -y
		
		# Habilita e inicia o serviço do Snap
		sudo systemctl enable --now snapd.socket
		
		# Cria link simbólico para suporte clássico do snap
		sudo ln -sf /var/lib/snapd/snap /snap
		
		echo -e "${VERDE}[INFORMAÇÃO!] - Snapd instalado com sucesso!${WITHOUT_COLOR}"
	else
		echo -e "${VERDE}[INFORMAÇÃO!] - Snapd já está instalado.${WITHOUT_COLOR}"
	fi
}

# ============================================
# DOWNLOAD E INSTALAÇÃO DE PACOTES .DEB
# ============================================

install_debs() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Baixando pacotes .deb externos...${WITHOUT_COLOR}"

	# Cria o diretório de downloads se não existir
	mkdir -p "$DIRECTORY_DOWNLOADS"
	
	# Baixa os pacotes .deb das URLs definidas
	wget -c "$URL_GOOGLE_CHROME" -P "$DIRECTORY_DOWNLOADS"
	wget -c "$URL_ENTE_AUTH" -P "$DIRECTORY_DOWNLOADS"

	# Instala todos os pacotes .deb baixados
	echo -e "${VERDE}[INFORMAÇÃO!] - Instalando pacotes .deb baixados...${WITHOUT_COLOR}"
	sudo dpkg -i "$DIRECTORY_DOWNLOADS"/*.deb
	
	# Corrige possíveis dependências quebradas
	sudo apt --fix-broken install -y
}

# ============================================
# INSTALAÇÃO DE PROGRAMAS VIA APT
# ============================================

install_apt_programs() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Instalando programas do repositório APT...${WITHOUT_COLOR}"

	# Loop que percorre cada programa da lista
	for program_name in "${PROGRAMS_TO_INSTALL[@]}"; do
		# Verifica se o programa já está instalado
		if ! dpkg -l | grep -q "^ii  $program_name"; then
			echo -e "${VERDE}[INSTALANDO] - $program_name${WITHOUT_COLOR}"
			sudo apt install "$program_name" -y
		else
			echo -e "${AMARELO}[JÁ INSTALADO!] - $program_name${WITHOUT_COLOR}"
		fi
	done
}

# ============================================
# INSTALAÇÃO DE PROGRAMAS VIA SNAP
# ============================================

install_snaps() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Instalando programas via Snap...${WITHOUT_COLOR}"

	# Loop que percorre cada programa Snap
	for snap_name in "${!SNAP_PROGRAMS[@]}"; do
		# Separa as flags e descrição
		IFS=':' read -r flags description <<< "${SNAP_PROGRAMS[$snap_name]}"
		
		# Verifica se o snap já está instalado
		if snap list | grep -q "^$snap_name"; then
			echo -e "${AMARELO}[JÁ INSTALADO!] - $description${WITHOUT_COLOR}"
		else
			echo -e "${VERDE}[INSTALANDO] - $description${WITHOUT_COLOR}"
			# Instala o snap com as flags apropriadas
			sudo snap install "$snap_name" $flags
		fi
	done
}

# ============================================
# INSTALAÇÃO DE PROGRAMAS VIA FLATPAK
# ============================================

install_flatpaks() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Instalando programas via Flatpak...${WITHOUT_COLOR}"

	# Adiciona o repositório Flathub se não existir
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	# Loop que percorre cada programa Flatpak
	for flatpak_id in "${!FLATPAK_PROGRAMS[@]}"; do
		flatpak_name="${FLATPAK_PROGRAMS[$flatpak_id]}"
		
		# Verifica se o flatpak já está instalado
		if flatpak list | grep -q "$flatpak_id"; then
			echo -e "${AMARELO}[JÁ INSTALADO!] - $flatpak_name${WITHOUT_COLOR}"
		else
			echo -e "${VERDE}[INSTALANDO] - $flatpak_name${WITHOUT_COLOR}"
			# Instala o flatpak do Flathub (-y confirma automaticamente)
			flatpak install flathub "$flatpak_id" -y
		fi
	done
}

# ============================================
# LIMPEZA E FINALIZAÇÃO DO SISTEMA
# ============================================

system_clean() {
	echo -e "${VERDE}[INFORMAÇÃO!] - Executando limpeza do sistema...${WITHOUT_COLOR}"
	
	# Atualiza todos os sistemas de pacotes
	apt_update
	flatpak update -y
	sudo snap refresh
	
	# Remove pacotes desnecessários e limpa cache
	sudo apt autoclean -y
	sudo apt autoremove -y
	
	echo -e "${VERDE}[INFORMAÇÃO!] - Limpeza concluída!${WITHOUT_COLOR}"
}

# ============================================
# EXECUÇÃO DO SCRIPT
# ============================================

echo -e "${VERDE}========================================${WITHOUT_COLOR}"
echo -e "${VERDE}  SCRIPT DE PÓS-INSTALAÇÃO${WITHOUT_COLOR}"
echo -e "${VERDE}========================================${WITHOUT_COLOR}"
echo ""

# Sequência de execução das funções
lock_apt                  # Remove locks do APT
testing_internet          # Testa conexão com internet
lock_apt                  # Remove locks novamente por segurança
apt_update                # Atualiza sistema
lock_apt                  # Remove locks após atualização
add_archi386              # Adiciona suporte 32 bits
just_apt_update           # Atualiza lista de pacotes
install_snapd             # Instala o Snapd
install_debs              # Baixa e instala .debs externos
install_apt_programs      # Instala programas APT
install_flatpaks          # Instala programas Flatpak
install_snaps             # Instala programas Snap
apt_update                # Atualização final
system_clean              # Limpeza final do sistema

# ============================================
# MENSAGEM FINAL
# ============================================

echo ""
echo -e "${VERDE}========================================${WITHOUT_COLOR}"
echo -e "${VERDE}[SUCESSO!] - Script finalizado!${WITHOUT_COLOR}"
echo -e "${VERDE}========================================${WITHOUT_COLOR}"
echo ""
echo -e "${AMARELO}OBSERVAÇÕES IMPORTANTES:${WITHOUT_COLOR}"
echo -e "  • Alguns aplicativos Snap podem precisar de logout/login"
echo -e "  • Aplicativos Flatpak estarão disponíveis no menu de aplicativos"
echo -e "  • Recomenda-se reiniciar o sistema após a instalação"
echo ""
echo -e "${VERDE}Instalação concluída com sucesso! :)${WITHOUT_COLOR}"