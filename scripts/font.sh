#!/bin/bash

font() {
	# ttf-ms-fonts
	sudo add-apt-repository multiverse
	sudo apt update
	sudo apt install ttf-mscorefonts-installer -y
	sudo fc-cache -f -v
}

font
