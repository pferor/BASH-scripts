#!/bin/bash
#
# vaio_tooglewwanpower.sh
#
# Toggles WWAN power state in Sony Vaio
# Requires module sony_laptop
# Only executable by root (or with su/sudo)
#
# Pferor <pferor [AT] gmail [DOT] com>
# Version 2.0
#
# 2008-07-11

FILE="/sys/devices/platform/sony-laptop/wwanpower"
Current=`cat $FILE`

if [ `whoami` != root ]; then
    echo "You must be root in order to use this script"
    exit
fi

if [ $Current == 0 ]; then
    echo "WWAN on"
    echo "1" > $FILE
else
    echo "WWAN off"
    echo "0" > $FILE
fi

