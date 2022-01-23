#!/bin/bash

postInstall() {
	sudo apt autoremove
	sudo apt-get clean
	sudo apt-get autoclean
}

postInstall
