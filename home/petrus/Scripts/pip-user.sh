#!/bin/bash

# 维护一个列表
mypkgs="/home/petrus/.local/local-python-world"

version=$(python -V | cut -d " " -f 2 | cut -d "." -f 1-2)

if [[ $# == 2 ]] ; then
    if [[ $1 == 'install' ]]; then
        pip install --user $2
        if [ $? -eq 0 ]; then
            echo $2 >> $mypkgs
        else
            echo "pip install $2 failed"
        fi
    elif [[ $1 == 'uninstall' ]]; then
        pip uninstall $2
        if [ $? -eq 0 ]; then
            sed -i "/^$2$/d" $mypkgs
        else
            echo "pip uninstall $2 failed"
        fi
    fi
else
    echo "Usage: "
    echo "      pip_user install <packege>"
    echo "      pip_user uninstall <packege>"
fi
