#!/bin/sh
set -o nounset
set -o errexit
set -o pipefail

if [ $# -ne 3 ]; then
   echo "Usage: $0 <package_category> <package_name> <ebuild>"
   exit
fi

mkdir -p /usr/local/portage/$1/$2
cp $3 /usr/local/portage/$1/$2/
chown -R portage:portage /usr/local/portage
pushd /usr/local/portage/$1/$2
repoman manifest
popd
