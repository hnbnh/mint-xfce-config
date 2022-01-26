#!/bin/bash

tweak() {
	# icon
	sudo add-apt-repository ppa:papirus/papirus -y
	sudo apt update && sudo apt install papirus-icon-theme
	xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus

	# theme
	git clone https://github.com/vinceliuice/Orchis-theme.git ~/Downloads/Orchis-theme
	sudo -u $USERNAME bash ~/Downloads/Orchis-theme/install.sh -t green
	rm -rf ~/Downloads/Orchis-theme
	xfconf-query -c xsettings -p /Net/ThemeName -s Orchis-green-dark-compact
	xfconf-query -c xfwm4 -p /general/theme -s Orchis-green-dark-compact

	# TODO: disable fx
}

tweak
