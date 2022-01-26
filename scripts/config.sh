#!/bin/bash

config() {
	# select fastest mirror
	# https://askubuntu.com/a/719551
	curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I {} sh -c 'echo `curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz` {}' | sort -g -r | head -1 | awk '{ print $2  }'

	# enable natuarl touchpad scrolling
	touchpadId=$(xinput --list | grep -Poi 'touchpad.*id=\K[0-9]+')
	xinput --set-prop $touchpadId 'libinput Natural Scrolling Enabled' 1

	# touch to click
	xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Tap Action" 0

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
	sudo cp ./assets/config.desktop  ~/.config/autostart/
	sudo cp ./assets/mintreport.desktop ~/.config/autostart/
	sudo cp ./assets/mintupdate.desktop ~/.config/autostart/
	sudo cp ./assets/mintwelcome.desktop ~/.config/autostart/
	sudo cp ./assets/blueberry-obex-agent.desktop ~/.config/autostart/
	sudo cp ./assets/blueberry-tray.desktop ~/.config/autostart/
	sudo cp ./assets/nvidia-prime.desktop ~/.config/autostart/
	sudo cp ./assets/print-applet.desktop ~/.config/autostart/
	sudo cp ./assets/sticky.desktop ~/.config/autostart/

	# git & github
	git config --global core.editor "vim"
	# TODO: setup ssh key for github
}

config
