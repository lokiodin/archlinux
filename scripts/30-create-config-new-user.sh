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

###############################################################

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

###############################################################

function configure_terminator(){
	echo_green "Configuration de Terminator"
	sudo -u $NEW_USER bash -c 'mkdir -p ~/.config/terminator'
	sudo -u $NEW_USER bash -c 'cp ./ressources/terminator_config ~/.config/terminator/config'
}

function configure_xinit_user(){
	echo_green "Obtention du fichier default .bashrc"
	sudo -u $NEW_USER bash -c 'cp ./ressources/xinitrc ~/.xinitrc'
}

function configure_bashrc(){
	echo_green "Obtention du fichier default .bashrc"

	sudo -u $NEW_USER bash -c 'cp ./ressources/bashrc ~/.bashrc'
	sudo -u $NEW_USER bash -c '. ~/.bashrc'
	cp bashrc /etc/bash.bashrc
}

function configure_tmux(){
	sudo -u $NEW_USER bash -c "echo 'source \"\$HOME/.bashrc\"' > ~/.bash_profile"
	sudo -u $NEW_USER bash -c 'cp ./ressources/tmux.conf ~/.tmux.conf'
}

function configure_vim(){
	echo_green "Configuration de vim..."
	sudo -u $NEW_USER bash -c 'curl -sfLo ~/.vim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'

	sudo -u $NEW_USER bash -c 'cp ./ressources/vimrc ~/.vimrc'
	echo "Problem THERE"
	# sudo -u $NEW_USER bash -c 'vim ~/.vimrc +PlugInstall +q +q'
	# sudo -u $NEW_USER bash -c 'rm ~/.vimrc'

	# # Mais aussi pour le root user !!
	# curl -sfLo ~/.vim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	# cp vimrc /etc/vimrc
	# vim /etc/vimrc +PlugInstall +q +q
}

function configure_git(){
	sudo -u $NEW_USER bash -c 'git config --global core.editor "vim"'
	sudo -u $NEW_USER bash -c 'git config --global user.email "lokiodin3@yahoo.fr"'
	sudo -u $NEW_USER bash -c 'git config --global user.name "lokiodin"'
}

function configure_pacman(){
	cp mirrorlist /etc/pacman.d/mirrorlist
}

function prepare_opt(){
	chown $NEW_USER:$NEW_USER /opt
}

if [ "$1" == "" ]
then
	echo_red "Il faut renseigner un nom d'utilisateur."
	echo "Usage: $0 <nouveau_utilisateur>"
	exit
fi



create_new_user
configure_terminator
configure_bashrc
configure_xinit_user
configure_tmux
configure_vim
configure_git
configure_pacman
prepare_opt