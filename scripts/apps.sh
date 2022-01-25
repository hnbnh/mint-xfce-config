#!/bin/bash

apps() {
	# enable i386 multiarch
	sudo dpkg --add-architecture i386
	sudo add-apt-repository multiverse

	# zsh, pure prompt
	sudo apt install zsh -y
	chsh -s $(which zsh)
	mkdir -p "$HOME/.zsh"
	git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
	echo "fpath+=$HOME/.zsh/pure" >~/.zshrc

	# docker
	sudo apt install ca-certificates curl gnupg lsb-release -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

	# nvm
	sudo -u $USERNAME curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

	# ungoogled-chromium
	echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/ /' | sudo tee /etc/apt/sources.list.d/home-ungoogled_chromium.list >/dev/null
	curl -s 'https://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/Release.key' | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home-ungoogled_chromium.gpg >/dev/null
	sudo apt update && sudo apt install ungoogled-chromium -y

	# various apps
	sudo apt update
	sudo apt install -y redshift redshift-gtk obs-studio mpv neovim steam

	# firejail
	sudo add-apt-repository ppa:deki/firejail -y
	sudo apt update && sudo apt install firejail firejail-profiles

	# ibus-bamboo
	sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y && sudo apt update
	sudo apt install ibus ibus-bamboo --install-recommends && ibus restart
	env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

	# battery
	sudo add-apt-repository ppa:linrunner/tlp -y && sudo apt update
	sudo apt install tlp
	sudo tlp start

	# wine
	wget -nc https://dl.winehq.org/wine-builds/winehq.key
	sudo apt-key add winehq.key
	sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
	sudo apt update && sudo apt install --install-recommends winehq-stable -y
	winecfg

	# =====================================
	cwd=$(pwd)
	cd ~/Downloads

	# insomnia
	curl -L https://updates.insomnia.rest/downloads/ubuntu/latest -o insomnia.deb
	sudo dpkg -i insomnia.deb && rm insomnia.deb

	# vscode
	curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o vscode.deb
	sudo dpkg -i vscode.deb && rm vscode.deb

	cd $cwd

	# =====================================
	cwd=$(pwd)
	mkdir ~/Apps && cd ~/Apps

	# anki
	# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
	TAG=$(curl --silent "https://api.github.com/repos/ankitects/anki/releases/latest" |
		grep '"tag_name":' |
		sed -E 's/.*"([^"]+)".*/\1/')
	# TODO: create a function to deduplicate these blocks
	curl -L "https://github.com/ankitects/anki/releases/download/$TAG/anki-$TAG-linux.tar.bz2" -o anki.tar.bz2
	mkdir anki && tar xvjf anki.tar.bz2 -C anki --strip-components 1
	sudo ln -s ./anki/bin/Anki /usr/local/bin/anki

	# datagrip
	VERSION=2021.3.4
	curl -L "https://download.jetbrains.com/datagrip/datagrip-$VERSION.tar.gz" -o datagrip.tar.gz
	mkdir datagrip && tar -xvzf datagrip.tar.gz -C datagrip --strip-components 1
	sudo ln -s ./datagrip/bin/datagrip.sh /usr/local/bin/datagrip

	cd $cwd
	sudo cp ./assets/Anki.desktop /usr/share/applications
	sudo cp ./assets/DataGrip.desktop /usr/share/applications
}

apps
