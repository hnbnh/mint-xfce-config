#!/bin/bash

config() {
	# switch to local mirror
	sudo mint-switch-to-local-mirror

	# enable natuarl touchpad scrolling
	# w/ tap to click
	touchpadId=$(xinput --list | grep -Poi 'touchpad.*id=\K[0-9]+')
	echo "xinput --set-prop $touchpadId 'libinput Natural Scrolling Enabled' 1\nxinput --set-prop $touchpadId 'libinput Tapping Enabled' 1" >>.xsessionrc

	# increase maximum volumn
	pactl set-sink-volume 0 150%

	# enable firewall
	sudo ufw enable

	# disable hibernate & hybrid-sleep
	sudo systemctl mask hibernate.target hybrid-sleep.target

	# disable middle mouse button click to paste
	# https://askubuntu.com/a/1144039
	sudo apt update && sudo apt install xbindkeys xsel xdotool -y
	echo "\"echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys\"\nb:2" >~/.xbindkeysrc
	xbindkeys -p

	# enable SSD TRIM
	sudo systemctl enable fstrim.timer
	sudo systemctl start fstrim.timer

	# disable bluetooth
	sudo systemctl stop bluetooth
	sudo systemctl disable bluetooth

	# update autostart folder
	sudo cp ./assets/autostart/* ~/.config/autostart

	# git & github
	git config --global core.editor "vim"
	# TODO: setup ssh key for github
}

config
