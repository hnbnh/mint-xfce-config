#!/bin/bash

add() {
  # enable i386 multiarch
  sudo dpkg --add-architecture i386
  sudo add-apt-repository multiverse

  # zsh
  sudo apt install zsh -y
  chsh -s $(which zsh)
  mkdir -p "$HOME/.zsh"

  # miniconda
  curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/Downloads/miniconda3.sh
  sudo -u $USERNAME zsh ~/Downloads/miniconda3.sh -b -p $HOME/miniconda
  sudo ln -s ~/miniconda/bin/conda /usr/bin/conda
  conda init zsh

  # zsh fw & prompt
  sudo -u $USERNAME sh -c "$(curl -fsSL https://starship.rs/install.sh)"
  sudo -u $USERNAME curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

  # docker
  sudo apt install ca-certificates curl gnupg lsb-release -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(grep -Po 'UBUNTU_CODENAME=\K(\w+)' /etc/os-release) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

  # fnm
  curl -fsSL https://fnm.vercel.app/install | zsh
  echo -e "#fnm\nexport PATH=/$HOME/.fnm:\$PATH\neval \"\`fnm env\`\"" >>~/.zshrc
  mkdir $HOME/.zfunc
  echo "fpath+=~/.zfunc\ncompinit" >> $HOME/.zshrc
  fnm completions --shell zsh > $HOME/.zfunc/_fnm

  # ungoogled-chromium
  # TODO: use unportable version
  echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/ /' | sudo tee /etc/apt/sources.list.d/home-ungoogled_chromium.list >/dev/null
  curl -s 'https://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/Release.key' | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home-ungoogled_chromium.gpg >/dev/null
  sudo apt update && sudo apt install ungoogled-chromium -y

  # various apps
  sudo apt update
  sudo apt install -y obs-studio mpv steam cheese

  # obs
  sudo apt install ffmpeg v4l2loopback-dkms
  sudo add-apt-repository ppa:obsproject/obs-studio -y
  sudo apt update && sudo apt install obs-studio -y

  # youtube-dl
  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl

  # neovim
  sudo add-apt-repository ppa:neovim-ppa/stable -y
  sudo apt update
  sudo apt install neovim -y
  NVIM_CONFIG_FOLDER=/root/.config/nvim
  sudo mkdir -p $NVIM_CONFIG_FOLDER
  echo -e "inoremap jk <esc>\ncnoremap jk <C-C>" | sudo tee -a "$NVIM_CONFIG_FOLDER/init.vim"

  # firejail
  sudo add-apt-repository ppa:deki/firejail -y
  sudo apt update && sudo apt install firejail firejail-profiles -y

  # ibus-bamboo
  sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y && sudo apt update
  sudo apt install ibus ibus-bamboo -y --install-recommends && ibus restart
  env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
  im-config -n ibus
  gsettings set org.freedesktop.ibus.general.hotkey triggers "['<Control><Shift>space']"

  # battery
  sudo add-apt-repository ppa:linrunner/tlp -y && sudo apt update
  sudo apt install tlp -y
  sudo tlp start

  # wine
  wget -nc https://dl.winehq.org/wine-builds/winehq.key
  sudo apt-key add winehq.key
  # TODO: update codename
  sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
  sudo apt update && sudo apt install --install-recommends winehq-stable -y
  rm winehq.key

  # =====================================
  # insomnia
  echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" |
    sudo tee -a /etc/apt/sources.list.d/insomnia.list
  sudo apt update && sudo apt install insomnia

  # vscode
  curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o vscode.deb
  sudo apt install ./vscode.deb && rm vscode.deb

  # =====================================
  cwd=$(pwd)
  mkdir ~/Apps && cd ~/Apps

  # anki
  # https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
  TAG=$(curl --silent "https://api.github.com/repos/ankitects/anki/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')
  # TODO: create a function to deduplicate these blocks
  curl -L "https://github.com/ankitects/anki/releases/download/$TAG/anki-$TAG-linux.tar.bz2" -o anki.tar.bz2
  mkdir anki && tar xjf anki.tar.bz2 -C anki --strip-components 1
  sudo ln -s ~/Apps/anki/bin/Anki /usr/local/bin/anki

  # datagrip
  VERSION=2021.3.4
  curl -L "https://download.jetbrains.com/datagrip/datagrip-$VERSION.tar.gz" -o datagrip.tar.gz
  mkdir datagrip && tar -xzf datagrip.tar.gz -C datagrip --strip-components 1
  sudo ln -s ~/Apps/datagrip/bin/datagrip.sh /usr/local/bin/datagrip

  cd $cwd
  sudo cp ./assets/applications/* /usr/share/applications
}

remove() {
  sudo apt purge warpinator webapp-manager transmission-gtk thunderbird hexchat -y
}

add
remove
