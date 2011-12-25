#!/bin/bash
#
# vaio_progressivebright.sh
#
# Changes bright state progressively in Sony Vaio
# Requires spicctrl
#
# Pferor <pferor [AT] gmail [DOT] com>
# Version 2.0
#
# 2008-07-11

MaxBright=224
MinBright=0

if [ -e "/dev/sonypi" ]
then
    Current=`spicctrl -B`
else
    echo "/dev/sonypi: No such file or directory" >&2
    exit 1
fi

function ShowUsage {
    echo "Usage: vaio_progressivebright.sh <option>"
    echo "  up:   increases bright"
    echo "  down: decreases bright"
    echo "  cur:  tells about current bright"
}

function BrightUp {
    if [ $Current -lt $MaxBright ]; then
        Current=$(($Current+32))
        spicctrl -b $Current
        echo "Bright increased to: $Current"
    else
        echo "Bright is alreadt to $MaxBright (max)"
    fi
}

function BrightDown {
    if [ $Current -gt $MinBright ]; then
        Current=$(($Current-32))
        spicctrl -b $Current
        echo "Bright decreased to: $Current"
    else
        echo "Bright is already at $MinBright (min)"
    fi
}

if [ ${#} != 1 ]; then
    ShowUsage
    exit
else
    if [ ${1} == "up" ]; then
        BrightUp
    elif [ ${1} == "down" ]; then
        BrightDown
    elif [ ${1} == "cur" ]; then
        echo "Current bright: $Current"
    else
        ShowUsage
        exit
    fi
fi

