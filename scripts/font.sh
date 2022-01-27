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

	sudo fc-cache -f -v
}

font
