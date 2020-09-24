# Arch Linux Bootstrap script 00
#
# To install when you are on chroot (after partionning and configuring with iso)
#

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


if [ "$1" == "" ]
then
	echo_red "Il faut renseigner un nom d'utilisateur."
	echo "Usage: $0 <nouveau_utilisateur>"
	exit
fi


./scripts/05-install-grub.sh
./scripts/10-conf-locales-timezones-hostname.sh
./scripts/15-install-xorg.sh
./scripts/20-install-config-xfce.sh
./scripts/25-install-dependencies.sh
./scripts/30-create-config-new-user.sh $1
./scripts/35-install-yay-moreniceties-with-yay.sh $1

echo "SCRIPT FINI"
exit