#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# NOTE: RUN AS USER!

function mkdir_ifnot_exist() {
    if [[ $# != 1 ]]; then
        echo "mkdir_ifnot_exist(): don't have enough arguments!"
        exit 1
    fi

    local dir=$1

    if [ ! -d $dir ]; then
        mkdir -p $dir
        echo "mkdir -p $dir"
    fi
}

if [[ $# == 1 ]]; then
    if [[ $1 == 'system' ]]; then
        if [ `id -u` -ne 0 ];then
            echo "THIS COMMANDC NEED RUN AS ROOT!"
            exit 1
        fi

        mkdir -p /etc/portage/postsync.d
        cp /usr/bin/eix-update /etc/portage/postsync.d

        # Enable systemd services
        systemctl enable bluetooth
        systemctl enable NetworkManager
        systemctl enable syslog-ng@default
        systemctl enable cronie
        systemctl enable lightdm
        systemctl enable sshd
        systemctl enable postfix
        systemctl enable docker
        systemctl enable privoxy
        systemctl enable betterlockscreen@$USER
        systemctl enable xow.service
        systemctl enable ratbagd.service

        ln -s /home/petrus/.zshrc /root/.zshrc
    fi

    if [[ $1 == 'user' ]]; then
        if [ `id -u` -eq 0 ];then
            echo "THIS COMMAND NEED RUN AS USER!"
            exit 1
        fi

        # aria2
        touch ~/.aria2/aria2.session

        # pip
        mkdir -p ~/.local/bin
        ln -s ~/Scripts/pip-user.sh ~/.local/bin/pip-user
        ln -s ~/Scripts/pip-upgrade.sh ~/.local/bin/pip-upgrade
        pip install --user -r ~/.local/local-python-world

        # yarn
        bash ~/Scripts/yarn-local-install.sh

        # install vim plugin
        mkdir_ifnot_exist ~/.vim/.backup
        mkdir_ifnot_exist ~/.vim/.swp
        mkdir_ifnot_exist ~/.vim/.undo
        mkdir_ifnot_exist ~/.vim/.info

        # Open vim and type `:PlugInstall`

        # Open tmux and press prefix + I (capital i, as in Install) to fetch the plugin.

        # # Enable systemd user services
        # systemctl enable --user mpd
        # systemctl enable --user aria2

        betterlockscreen -u  ~/Pictures/gentoo/lock.jpg
    fi
else
    echo "Usage:"
    echo "      $0 system"
    echo "      $0 user"
fi
