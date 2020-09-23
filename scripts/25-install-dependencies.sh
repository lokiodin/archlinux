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

SUDO_DEPENDENCIES="sudo"
AUDIO_DEPENDENCES="pulseaudio pavucontrol"
GIT_DEPENDENCIES="git"
VIM_DEPENDENCIES="vim"
TMUX_DEPENDENCIES="tmux"
YAY_DEPENDENCINES="base-devel"
TERMINATOR_DEPENDENCIES="terminator"
DMENU_DEPENDENCIES="dmenu"
FIREFOX_DEPENDENCIES="firefox"
OTHER_DEPENDENCIES="tree"

DEPENDENCIES="\
 $SUDO_DEPENDENCIES \
 $AUDIO_DEPENDENCIES \
 $GIT_DEPENDENCIES \
 $VIM_DEPENDENCIES \
 $TMUX_DEPENDENCIES \
 $YAY_DEPENDENCIES \
 $TERMINATOR_DEPENDENCIES \
 $DMENU_DEPENDENCIES \
 $FIREFOX_DEPENDENCES \
 $OTHER_DEPENDENCIES \
"

###############################################################



function install_niceties(){
	pacman -Syq $DEPENDENCIES --noconfirm --color=always
}


install_niceties
# echo_green "Enabling NetworkManager.service"
# systemctl enable NetworkManager.service