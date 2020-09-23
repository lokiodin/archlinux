# Arch Linux Install script
#
# Romain
#
# Pour installer Arch Linux plus facilement et rapidement
# Créé à l'aide de plus bootstrap trouvé

set -e

# Set up de couleur à utiliser
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
COLOR_MAGENTA=$(tput setaf 5)
COLOR_CYAN=$(tput setaf 6)
COLOR_WHITE=$(tput setaf 7)
BOLD=$(tput bold)
COLOR_RESET=$(tput sgr0)

function echo_red(){
	echo "${COLOR_RED}${BOLD}$1${COLOR_RESET}"
}

function echo_green(){
	echo "${COLOR_GREEN}${BOLD}$1${COLOR_RESET}"
}

function echo_yellow(){
	echo "${COLOR_YELLOW}${BOLD}$1${COLOR_RESET}"
}

###############################################################


###############################################################

function set_timezone(){
	echo_green "Changement de la timezone pour Europe/Paris"

	ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
	hwclock --systohc
}

function set_locale(){
	echo_green "Configuration des locales (langue en EN)"
	locale-gen
	# sed -i 's/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/g' /etc/locale.gen
	echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
	echo "KEYMAP=fr-latin1" > /etc/vconsole.conf
	# locale-gen
}

function set_hostname(){
	echo_green "Configuration de l'hostname"

	echo "arch" > /etc/hostname
	cat <<EOF >/etc/hosts
127.0.0.1 localhost
::1	      localhost
127.0.1.1 arch.localdomain arch
EOF

}

function configure_pacman(){
	cp ./ressources/mirrorlist /etc/pacman.d/mirrorlist
}



function pre_install(){
	set_timezone
	set_locale
	set_hostname
	configure_pacman
	echo_green "#######"
	echo_green "Timezone, locales, hostname configured"
	echo_green "#######"
	echo_green "Installation de networkmanager et son activation"
	pacman -Sy networkmanager --no-confirm --color=always
	systemctl enable NetworkManager
}

pre_install