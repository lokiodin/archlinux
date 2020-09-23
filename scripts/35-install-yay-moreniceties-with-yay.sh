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

NEW_USER=$1

YAY_INSTALL="\
 $POLYBAR_DEPENDENCIES \
"

###############################################################

function install_yay(){
	pacman -Sy --needed base-devel --noconfirm
	pushd /opt/
	git clone https://aur.archlinux.org/yay.git

	chown $NEW_USER:$NEW_USER /opt/yay
	cd yay
	sudo -u $NEW_USER bash -c 'cd /opt/yay/ && yes|makepkg -si'
	popd
	sudo -u $NEW_USER bash -c 'yes|yay'
}

function install_more_niceties(){
	sudo -u $NEW_USER bash -c 'yay -Sy $YAY_INSTALL --noconfirm'
}

if [ "$1" == "" ]
then
	echo_red "Il faut renseigner un nom d'utilisateur ${BOLD}EXISTANT${COLOR_RESET}."
	echo "Usage: $0 <nouveau_utilisateur>"
	exit
fi

install_yay
install_more_niceties