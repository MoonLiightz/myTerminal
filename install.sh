#!/bin/sh

check_if_package_is_installed()
{
	if (dpkg-query -s $1 2> /dev/null | grep -q installed ); then
		echo "$1 is already installed"
	else
		echo "$1 isn't installed"
		echo "Use: ${0} install-packages"
		exit 5
	fi
}

case "$1" in
	install-packages)
		echo "Install tmux and zsh now"
		apt-get install -y tmux zsh
	;;
	*)
		echo "Check if tmux is installed"
		check_if_package_is_installed tmux
		
		echo "Check if zsh is installed"
		check_if_package_is_installed zsh
		
		echo "Set tmux symbolic links to configuration files"
		ln -s -f ~/myTerminal/tmux/.tmux.conf ~/.tmux.conf
		ln -s -f ~/myTerminal/tmux/.tmux.conf.local ~/.tmux.conf.local
		
		chsh $USER -s $(which zsh)
		echo "Install oh-my-zsh"
		exit | sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
		
		echo "Set zsh symbolic links to configuration files"
		ln -s -f ~/myTerminal/zsh/.zshrc ~/.zshrc
		
		echo "Add old PATH to .zshrc"
		echo "export PATH=$PATH:\$PATH" >> ~/.zshrc
		
		echo "Install oh-my-zsh theme powerlevel9k"
		git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	;;
esac

exit 0
