#!/bin/bash

# --- INFORMATIONS ---

# To use the tool, simply run the following commands

# sudo chmod +x afterInstall.sh
# ./afterInstall.sh

# --- VARIABLES --- #

set -e

# --- URL's --- #

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_ENTE_AUTH="https://github.com/ente-io/ente/releases/download/auth-v4.3.2/ente-auth-v4.3.2-x86_64.deb"

# --- DIRECTORIES AND FILES --- #

DIRECTORY_DOWNLOADS="$HOME/Programs"

# --- COLORS --- #

VERMELHO="\e[1;91m"
VERDE="\e[1;92m"
WITHOUT_COLOR="\e[0m"

# --- FUNCTIONS --- #

# Updating repositories and performing system updates
apt_update() {
	sudo apt update && sudo apt dist-upgrade -y
}

# --- TESTS AND REQUIREMENTS --- #

# Internet connection test
testing_internet() {
	if ! ping -c 1 8.8.8.8 &>/dev/null; then
		echo "${VERMELHO}[ERROR!] - The computer has no Internet connection. Check your network.${WITHOUT_COLOR}"
		exit 1
	else
		echo "${VERDE}[INFORMATION!] - Internet connection is working normally.${WITHOUT_COLOR}"
	fi
}

# Removing occasional apt locks
lock_apt() {
	sudo rm -f /var/lib/dpkg/lock-frontend
	sudo rm -f /var/cache/apt/archives/lock
}

# Adding/Confirming 32-bit Architecture
add_archi386() {
	sudo dpkg --add-architecture i386
}

# Updating the repository
just_apt_update() {
	sudo apt update -y
}

# --- .DEB SOFTWARE TO INSTALL --- #

PROGRAMS_TO_INSTALL="
	wget
	flatpak
	curl
	ubuntu-restricted-extras
	neofetch
 	code
"

# --- DOWNLOADING AND INSTALLING EXTERNAL PROGRAMS --- #

install_debs() {
	echo -e "${VERDE}[INFORMATION!] - Downloading .deb packages${WITHOUT_COLOR}"

	mkdir -p "$DIRECTORY_DOWNLOADS"
	wget -c "$URL_GOOGLE_CHROME" -P "$DIRECTORY_DOWNLOADS"
	wget -c "$URL_ENTE_AUTH" -P "$DIRECTORY_DOWNLOADS"

	# Installing .deb packages downloaded in the previous session
	echo -e "${VERDE}[INFORMATION!] - Installing downloaded .deb packages.${WITHOUT_COLOR}"
	sudo dpkg -i "$DIRECTORY_DOWNLOADS"/*.deb

	# --- INSTALL PROGRAMS IN APT --- #
	echo -e "${VERDE}[INFORMATION!] - Installing apt packages from repository.${WITHOUT_COLOR}"

	for program_name in "${PROGRAMS_TO_INSTALL[@]}"; do
		if ! dpkg -l | grep -q "$program_name"; then # Only install if not already installed
			sudo apt install "$program_name" -y
		else
			echo "[INSTALLED!] - $program_name"
		fi
	done
}

# --- INSTALLING FLATPAK PACKAGES --- #

install_flatpaks() {
	echo -e "${VERDE}[INFORMATION!] - Installing flatpak packages.${WITHOUT_COLOR}"

	flatpak install flathub io.github.vikdevelop.SaveDesktop # SaveDesktop
	flatpak install flathub com.github.tchx84.Flatseal # FlatSeal
	flatpak install flathub com.bitwarden.desktop # BitWarden
	flatpak install flathub org.telegram.desktop # Telegram
	flatpak install flathub org.localsend.localsend_app # LocalSend
	flatpak install flathub org.libreoffice.LibreOffice # LibreOffice
	flatpak install flathub org.gnome.Boxes # Boxes
	flatpak install flathub me.iepure.Ticketbooth # Ticket Booth
	flatpak install flathub dev.bragefuglseth.Keypunch # KeyPunch
	flatpak install flathub it.mijorus.gearlever # Gear Lever
	flatpak install flathub org.upscayl.Upscayl # Upscayl
	flatpak install flathub org.keepassxc.KeePassXC # KeePassXC
	flatpak install flathub io.github.flattool.Warehouse # WareHouse
}

# --- POST INSTALLATION --- #

# Finalization, update and cleanup
system_clean() {
	apt_update
	flatpak update -y
	sudo apt autoclean -y
	sudo apt autoremove -y
}

# --- EXECUTION --- #

lock_apt
testing_internet
lock_apt
apt_update
lock_apt
add_archi386
just_apt_update
install_debs
install_flatpaks
apt_update
system_clean

# --- FINALIZATION --- #

echo -e "${VERDE}[INFORMATION!] - Script finished, installation complete! :)${WITHOUT_COLOR}"
