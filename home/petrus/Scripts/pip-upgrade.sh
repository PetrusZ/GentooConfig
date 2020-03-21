#!/bin/bash

# 维护一个列表
mypkgs="/home/petrus/.local/local-python-world"

version=$(python -V | cut -d " " -f 2 | cut -d "." -f 1-2)

for line in $(cat $mypkgs)
do
    pip install --user --upgrade $line
done
