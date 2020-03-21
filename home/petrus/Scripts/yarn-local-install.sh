#!/usr/bin/env bash

package_file=~/.local/package.json
packages=`jq .dependencies $package_file | jq values | jq keys | jq '.|join("|")'`
packages=${packages:1:-1}

packages=$(echo $packages | awk -F '|' '{for(i=1;i<=NF;i++){print $i;}}')

for package in $packages; do
    yarn add --cwd ~/.local $package
    # echo "yarn add --cwd ~/.local $package"
done
