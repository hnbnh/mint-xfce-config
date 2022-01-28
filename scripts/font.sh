#!/bin/bash

font() {
	# ttf-ms-fonts
	sudo add-apt-repository multiverse
	sudo apt update
	# https://askubuntu.com/a/25614
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
	sudo apt install ttf-mscorefonts-installer -y

	# fira code
	sudo apt install fonts-firacode
	# TODO: create a utility to get latest tag name from github
	TAG=$(curl --silent "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" |
		grep '"tag_name":' |
		sed -E 's/.*"([^"]+)".*/\1/')
	curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/$TAG/FiraCode.zip" -o ~/Downloads/FiraCode.zip
	unzip ~/Downloads/FiraCode.zip -d ~/.fonts
	rm ~/Downloads/FiraCode.zip && rm ~/.fonts/*Windows*

	sudo fc-cache -f -v
}

font
