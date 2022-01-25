#!/bin/bash

config() {
	# select fastest mirror
	# https://askubuntu.com/a/719551
	curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I {} sh -c 'echo `curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz` {}' | sort -g -r | head -1 | awk '{ print $2  }'

	# disable window grouping
	xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-3/grouping' --set 0

	# enable natuarl touchpad scrolling
	touchpadId=$(xinput --list | grep -Poi 'touchpad.*id=\K[0-9]+')
	xinput --set-prop $touchpadId 'libinput Natural Scrolling Enabled' 1

	# increase maximum volumn
	pactl set-sink-volume 0 150%

	# enable firewall
	sudo ufw enable

	# disable hibernate & hybrid-sleep
	sudo systemctl mask hibernate.target hybrid-sleep.target

	# disable middle mouse button click to paste
	# https://askubuntu.com/a/1144039
	sudo apt update && sudo apt install xbindkeys xsel xdotool
	echo "\"echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys\"\nb:2" >~/.xbindkeysrc
	xbindkeys -p
	sudo cp ./assets/disable-middle-click-paste.desktop /usr/share/applications

	# enable SSD TRIM
	sudo systemctl enable fstrim.timer
	sudo systemctl start fstrim.timer

	# disable bluetooth
	sudo systemctl stop bluetooth
	sudo systemctl disable bluetooth

	# disable some startup apps
	sudo cp ./assets/mintreport.desktop /usr/share/applications
	sudo cp ./assets/mintupdate.desktop /usr/share/applications
	sudo cp ./assets/mintwelcome.desktop /usr/share/applications

	# git & github
	git config --global core.editor "vim"
	# TODO: setup ssh key for github
}

config
