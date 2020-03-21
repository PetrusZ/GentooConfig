#!/bin/bash
conf='/home/petrus/.aria2/aria2.conf'
tracer_list_uri='https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt'
list=`wget -qO- $tracer_list_uri | awk NF |sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" $conf`" ]; then
    #echo 'add bt-tracker'
    sed -i '$a bt-tracker='${list} $conf
else
    #echo 'update bt-tracker'
    sed -i "s@bt-tracker=.*@bt-tracker=$list@g" $conf
fi
