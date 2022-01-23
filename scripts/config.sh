#!/bin/bash

config() {
	# select fastest mirror
	# https://askubuntu.com/a/719551
	curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I {} sh -c 'echo `curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz` {}' | sort -g -r | head -1 | awk '{ print $2  }'

	sudo apt update && sudo apt upgrade -y

	# disable window grouping
	xfconf-query --channel 'xfce4-panel' --property '/plugins/plugin-3/grouping' --set 0

	# increase maximum volumn
	pactl set-sink-volume 0 150%

	# enable firewall
	sudo ufw enable

	# disable hibernate & hybrid-sleep
	sudo systemctl mask hibernate.target hybrid-sleep.target

	# disable middle mouse button click to paste
	# https://askubuntu.com/a/1144039
	sudo apt install xbindkeys xsel xdotool
	echo "\"echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys\"\nb:2" >~/.xbindkeysrc
	xbindkeys -p
	echo "[Desktop Entry]\nType=Application\nName=Disable middle click\nComment=Disable middle mouse button click to paste\nExec=xbindkeys -p\nOnlyShowIn=XFCE\nRunHook=0\nHidden=false" >~/.config/autostart/disable-middle-click.desktop

	# enable SSD TRIM
	sudo systemctl enable fstrim.timer
	sudo systemctl start fstrim.timer

	# disable bluetooth
	sudo systemctl stop bluetooth
	sudo systemctl disable bluetooth

	# TODO: turn off some startup apps in /etc/xdg/autostart/
	# set property Hidden=true

	# git & github
	git config --global core.editor "vim"
	# TODO: setup ssh key for github
}

config
