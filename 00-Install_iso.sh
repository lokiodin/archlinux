# Arch Linux Bootstrap script 00
#
# To install directly on iso
#
# Do :
#	 Partitioning
#	 Mounting
#	 genfstab


# Define some colors for quick use...
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



fonction parted(){
	echo_green "Partitioning of /dev/sda"
	parted /dev/sda mklabel gpt
	parted mkpart part_efi fat32 0 1GiB

}


echo_yellow "##############################"
echo_yellow " INSTALLATION OF THE BEGINING"
echo_yellow "##############################"

parted()

