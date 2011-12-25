#!/bin/bash
#
# vaio_cdpower.sh
#
# Changes cdrom state in Sony Vaio
# Requires module sony_laptop
# Only executable by root (or with su/sudo)
#
# Pferor <pferor [AT] gmail [DOT] com>
# Version 2.0
#
# 2008-07-11

FILE="/sys/devices/platform/sony-laptop/cdpower"
Current=`cat $FILE`

function ShowUsage {
    echo -e "Usage: vaio_cdpower.sh <option>"
    echo -e "  on:  turns cd power on"
    echo -e "  off: turns cd power off"
    echo -e "  cur: tells about current state"
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
            echo "1" > $FILE
            echo "CDROM device is now on"
        fi
    elif [ ${1} == "off" ]; then
        if [ $Current == 1 ]; then
            echo "0" > $FILE
            echo "CDROM device is now off"
        fi
    elif [ ${1} == "cur" ]; then
        if [ $Current == 1 ]; then
            echo "Current CDROM state is on"
        else
            echo "Current CDROM state is off"
        fi
    else
        ShowUsage
        exit
    fi
fi

