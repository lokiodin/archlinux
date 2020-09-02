# Arch Linux Install script
#
# Romain
#
# Pour installer Arch Linux plus facilement et rapidement
# Créé à l'aide de plus bootstrap trouvé



NEW_USER=$1

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
SUDO_DEPENDENCIES="sudo"
AUDIO_DEPENDENCES="pulseaudio pavucontrol"
GIT_DEPENDENCIES="git"
VIM_DEPENDENCIES="vim"
TMUX_DEPENDENCIES="tmux"
X_DEPENDENCIES="xorg-xinit xorg-server xorg-xrandr"
YAY_DEPENDENCINES="base-devel"
I3_DEPENDENCIES="i3-gaps gnu-free-fonts"
TERMINATOR_DEPENDENCIES="terminator"
DMENU_DEPENDENCIES="dmenu"
FIREFOX_DEPENDENCIES="firefox"
OTHER_DEPENDENCIES="networkmanager tree"

DEPENDENCIES="\
 $SUDO_DEPENDENCIES \
 $AUDIO_DEPENDENCIES \
 $GIT_DEPENDENCIES \
 $VIM_DEPENDENCIES \
 $TMUX_DEPENDENCIES \
 $X_DEPENDENCIES \
 $YAY_DEPENDENCIES \
 $I3_DEPENDENCIES \
 $TERMINATOR_DEPENDENCIES \
 $DMENU_DEPENDENCIES \
 $FIREFOX_DEPENDENCES \
 $OTHER_DEPENDENCIES \
"


#############################################################

POLYBAR_DEPENDENCIES="polybar"

YAY_INSTALL="\
 $POLYBAR_DEPENDENCIES \
"

##############################################################

function install_grub(){
	echo_green "Installation de Grub"

	pacman -Sy $GRUB_DEPENDENCIES --noconfirm --color=always
	grub-install /dev/sda
	if ! [[ $? ]]; then
		echo_red "ERROR in Grub installation ... A bit problematic"
		echo_red "END OF THE PROGRAMM"
	else
		echo_green "Ecriture de grub-mkconfig"
		grub-mkconfig -o /boot/grub/grub.cfg
	fi
}



##############################################################

function create_new_user(){
	pacman -Sy sudo --noconfirm
	id -u $NEW_USER > /dev/null

	if [ $? -eq 1 ]
	then
		echo_green "Creation d'un nouvel utilisateur $COLOR_BLUE$NEW_USER"

		mkdir /home/$NEW_USER
		useradd $NEW_USER
		echo_yellow "Mot de passe de $COLOR_BLUE$NEW_USER:"
		passwd $NEW_USER
	else
		echo_green "Utilisateur déjà existant !"
	fi

	groupadd sudo
	usermod -aG sudo $NEW_USER
	sed -i 's/# %sudo/%sudo/g' /etc/sudoers
	echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

	chown $NEW_USER:$NEW_USER /home/$NEW_USER
	chown -R $NEW_USER:$NEW_USER $(pwd)
	mv $(pwd) /home/$NEW_USER/archlinux
	cd /home/$NEW_USER/archlinux
}

function cleanup(){
	sed -i "s/$NEW_USER ALL=(ALL) NOPASSWD: ALL//g" /etc/sudoers
}

###############################################################


function configure_x(){
	echo_green "Configuration de X"
	sudo -u $NEW_USER bash -c 'echo "exec i3" > ~/.xinitrc'
	sudo -u $NEW_USER bash -c 'cp Xresources ~/.Xresources'


	cp /etc/X11/xinit/.xinitrc
	echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config
}

function configure_terminator(){
	echo_green "Configuration de Terminator"
	sudo -u $NEW_USER bash -c 'mkdir -p ~/.config/terminator'
	sudo -u $NEW_USER bash -c 'cp terminator_config ~/.config/terminator/config'
}

function configure_bashrc(){
	echo_green "Obtention du fichier default .bashrc"

	sudo -u $NEW_USER bash -c 'cp bashrc ~/.bashrc'
	sudo -u $NEW_USER bash -c '. ~/.bashrc'
	cp bashrc /etc/bash.bashrc
}

function configure_tmux(){
	sudo -u $NEW_USER bash -c "echo 'source \"\$HOME/.bashrc\"' > ~/.bash_profile"
	sudo -u $NEW_USER bash -c 'cp tmux.conf ~/.tmux.conf'
}

function configure_vim(){
	echo_green "Configuration de vim..."
	sudo -u $NEW_USER bash -c 'curl -sfLo ~/.vim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'

	sudo -u $NEW_USER bash -c 'cp vimrc ~/.vimrc'
	echo "Problem THERE"
	sudo -u $NEW_USER bash -c 'vim ~/.vimrc +PlugInstall +q +q'
	sudo -u $NEW_USER bash -c 'rm ~/.vimrc'

	# Mais aussi pour le root user !!
	curl -sfLo ~/.vim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	cp vimrc /etc/vimrc
	vim /etc/vimrc +PlugInstall +q +q
}

function configure_git(){
	sudo -u $NEW_USER bash -c 'git config --global core.editor "vim"'
	sudo -u $NEW_USER bash -c 'git config --global user.email "lokiodin3@yahoo.fr"'
	sudo -u $NEW_USER bash -c 'git config --global user.name "lokiodin"'
}

function configure_pacman(){
	cp mirrorlist /etc/pacman.d/mirrorlist
}

##############################################################

function prepare_opt(){
	chown $NEW_USER:$NEW_USER /opt
}

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

	echo arch > /etc/hostname
	cat <<EOF >/etc/hosts
127.0.0.1 localhost
::1	      localhost
127.0.1.1 arch.localdomain arch
EOF

}

function pre_install(){
	set_timezone
	set_locale
	set_hostname
}


function install_niceties(){
	pacman -Sy $DEPENDENCIES --noconfirm --color=always
}

function install_more_niceties(){
	sudo -u $NEW_USER bash -c 'yay -Sy $YAY_INSTALL --noconfirm'
}

if [ "$1" == "" ]
then
	echo_red "Il faut renseigner un nom d'utilisateur."
	echo "Usage: $0 <nouveau_utilisateur>"
	exit
fi

install_grub
pre_install
create_new_user
configure_pacman
install_niceties
configure_x
configure_terminator
configure_bashrc
configure_tmux
configure_vim
configure_git
prepare_opt

install_yay
install_more_niceties


cleanup
