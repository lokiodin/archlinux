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


function parted(){
	# echo_green 'Partitioning of /dev/sda to sda1 (efi), sda2 (swap) and sda3 (ext4)'
	parted -s /dev/sda '\
		mklabel gpt \
		mkpart part_efi fat32 1MiB 1GiB \
		mkpart part_efi linux-swap 1GiB 2GiB \
		mkpart part_efi ext4 2GiB 100%'
	# echo "LALALALALLALA"
}

function format_part(){
	mkfs.fat -F 32 /dev/sda1
	mkfs.ext4 /dev/sda3
	mkswap /dev/sda2
	swapon /dev/sda2
}


####################################


echo_yellow "##############################"
echo_yellow " INSTALLATION OF THE BEGINING"
echo_yellow "##############################"

# echo "avant"
parted
echo "FINININ"