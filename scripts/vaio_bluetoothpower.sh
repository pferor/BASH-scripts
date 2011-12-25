#!/bin/bash
#
# vaio_bluetoothpower.sh
#
# Changes bluetooth state in Sony Vaio
# Requires module sony_laptop
# Only executable by root (or with su/sudo)
#
# Pferor <pferor [AT] gmail [DOT] com>
# Version 2.0
#
# 2008-07-11

FILE="/sys/devices/platform/sony-laptop/bluetoothpower"
Current=`cat $FILE`

function ShowUsage {
    echo "Usage: vaio_bluetoothpower.sh <option>"
    echo "  on:  turns bluetooth power on"
    echo "  off: turns bluetooth power off"
    echo "  cur: tells about current state"
}

if [ `whoami` != root ]; then
    echo "You must be root in order to use this script"
    exit
fi

if [ ${#} != 1 ]; then
    ShowUsage
    exit
else
    if [ ${1} == "on" ]; then
        if [ $Current == 0 ]; then
            echo "255" > $FILE
            echo "Bluetooth device is now on"
        fi
    elif [ ${1} == "off" ]; then
        if [ $Current != 0 ]; then
            echo "0" > $FILE
            echo "Bluetooth device is now off"
        fi
    elif [ ${1} == "cur" ]; then
        if [ $Current == 1 ]; then
            echo "Current bluetooth state is on: $Current"
        else
            echo "Current bluetooth state is off: $Current"
        fi
    else
        ShowUsage
        exit
    fi
fi

