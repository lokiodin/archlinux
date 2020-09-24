# Arch Linux Bootstrap script 00
#
# To install directly on iso
#
# Do :
#	 Partitioning
#	 Mounting
#	 genfstab

set -e

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
	echo_green 'Partitioning of /dev/sda to sda1 (efi), sda2 (swap) and sda3 (ext4)'
	bash -c "cat ressources/parted.instruction | parted"
}

function format_part(){
	mkfs.fat -F 32 /dev/sda1
	mkfs.ext4 /dev/sda3
	mkswap /dev/sda2
	swapon /dev/sda2
}

function mounting(){
	echo_green "Mounting some partition (sda1 will be mounted in /boot/efi of sda3)"
	mount /dev/sda3 /mnt
	mkdir /mnt/boot
	mkdir /mnt/boot/efi
	mount /dev/sda1 /mnt/boot/efi
}

function install_soft(){
	echo_green "Installing with pacstrap and genfstab by UUID"
	pacstrap /mnt base linux linux-firmware
	genfstab -U /mnt >> /mnt/etc/fstab
}

####################################


echo_yellow "###############################"
echo_yellow " INSTALLATION OF THE BEGINNING"
echo_yellow "###############################"


parted
format_part
mounting
install_soft

cp -r $(pwd)/../archlinux /mnt/root/
chmod 777 /mnt/root/archlinux
chmod 777 /mnt/root/archlinux/*
chmod 777 /mnt/root/archlinux/*/*


echo_red "############################ FOR THE NEXT #########################"
echo_red "																	"
echo_red " Run ./root/archlinux/install.sh <user> to finish the installation"
echo_red "																	"
echo_red "############################ ############ #########################"


arch-chroot /mnt

echo_yellow "###############################"
echo_yellow "     END OF THE BEGINNING"
echo_yellow "###############################"

umount /mnt/boot/efi
umount /mnt