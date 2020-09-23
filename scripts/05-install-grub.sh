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

GRUB_DEPENDENCIES="os-prober efibootmgr grub"

###############################################################


function install_grub(){
	echo_green "Installation de Grub"

	pacman -Syq $GRUB_DEPENDENCIES --noconfirm --color=always
	grub-install /dev/sda
	if ! [[ $? ]]; then
		echo_red "ERROR in Grub installation ... A bit problematic"
		echo_red "END OF THE PROGRAMM"
	else
		echo_green "Ecriture de grub-mkconfig"
		grub-mkconfig -o /boot/grub/grub.cfg
	fi

	echo_green "#######"
	echo_green "Grub Installed and configured"
	echo_green "#######"
}


install_grub
