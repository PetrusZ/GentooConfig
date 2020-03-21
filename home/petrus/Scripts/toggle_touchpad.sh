#!/bin/bash

id=$(xinput list | grep TouchPad | awk '{print $6}' | sed 's/^id=//g')
is_enable=$(xinput list-props $id | grep 'Device Enabled' | awk '{print $4}')

if [ $is_enable -eq '0' ]; then
	xinput enable $id
else
	xinput disable $id
fi
