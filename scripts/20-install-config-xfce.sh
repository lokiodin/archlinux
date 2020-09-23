# Arch Linux Install script
#
# Romain
#
# Pour installer Arch Linux plus facilement et rapidement
# Créé à l'aide de plus bootstrap trouvé


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

XFCE_DEPENDENCIES="xfce4 xfce4-goodies"

###############################################################

# function install_gdm(){
# 	echo_green "Install GDM"
# 	pacman -Sy gdm --noconfirm --color=always

# 	echo_green "#######"
# 	echo_green "GDM installed"
# 	echo_green "#######"

# }

function install_xfce(){
	echo_green "Installing Xfce ..."
	pacman -Sy $XFCE_DEPENDENCIES --noconfirm --color=always

	echo_green "#######"
	echo_green "Xfce4 installed"
	echo_green "#######"

}

# install_gdm
install_xfce
# echo_green "Enabling gdm.service"
# systemctl enable gdm.service