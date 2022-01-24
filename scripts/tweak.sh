#!/bin/bash

tweak() {
	# icon
	sudo add-apt-repository ppa:papirus/papirus -y
	sudo apt update && sudo apt install papirus-icon-theme

	# theme
	git clone https://github.com/vinceliuice/Orchis-theme.git ~/Downloads
	sudo -u $USERNAME bash ~/Downloads/Orchis-theme/install.sh -t green
	rm -rf ~/Downloads/Orchis-theme

	# TODO: disable fx
}

tweak
