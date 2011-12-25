#!/bin/bash
#
# sysclockupdt.sh
#
# Updates system clock (date and time) using an external server.
# Requires internet connection, ntpdate [, hwclock]
# Only executable by root (or with su/sudo)
#
#       sysclockupdt [-vVhH] [-s server] 
#
# Praeter Feror <pferor@gmail.com>
# Version 1.1final
#
# Creation date: 2008-11-09
# Last modification: 2008-12-20
#
#

## version
VERSION="1.1final"

## binaries and info
BIN_SWCLOCK="/usr/bin/ntpdate"
BIN_HWCLOCK="/sbin/hwclock --utc --systohc"
DEFAULTSERVER="time.nist.gov"


NET_DEVICE_1="eth0"
NET_DEVICE_2="wlan0"
FILE_NET_ROUTE="/proc/net/route"

## initial values
VERBOSE=0               # verbose ?
HWCLOCK=1               # update hardware clock too?


## displays help
function show_usage
{
    echo "Usage ${0} [<options>]"
    echo "  -s <server>  Uses <server> instead default server"
    echo ""
    echo "  -H           Updates hardware clock too (actived by default)"
    echo "  -S           Update only system clock (not hardware)"
    echo ""
    echo "  -v           Verbose mode"
    echo "  -q           Quiet mode (not verbose - actived by default)"
    echo ""
    echo "  -V           Displays version"
    echo "  -h           Shows this message"
    echo ""
    echo "  Specifying no server, ${DEFAULTSERVER} will be used"
}

## displays version
function show_version
{
    echo "Current version: ${0} v${VERSION}"
}


## get options
while getopts "hs:HSvqV" OPTION
do
    case $OPTION in
        h)
        show_usage
        exit 0
        ;;
        s)
        USERSERVER=$OPTARG
        ;;
        H)
        HWCLOCK=1
        ;;
        S)
        HWCLOCK=0
        ;;
        v)
        VERBOSE=1
        ;;
        1)
        VERBOSE=0
        ;;
        V)
        show_version
        exit 0
        ;;
        ?)
        show_usage
        exit 1
        ;;
    esac
done


## server must be specified with a valid value
if [ -z $USERSERVER ]; then
    SERVER=$DEFAULTSERVER
else
    SERVER=$USERSERVER
fi


## only root can!
if [ `whoami` != root ]; then
    echo "${0}: You must be root in order to run this script" >&2
    exit 1
else
    ## only if there are inet connection
    if [[ -f ${FILE_NET_ROUTE} ]]
    then
        if [[ $(cat "${FILE_NET_ROUTE}" | grep "${NET_DEVICE_1}" | wc -l) -gt 0 ]] || [[ $(cat "${FILE_NET_ROUTE}" | grep "${NET_DEVICE_2}" | wc -l) -gt 0 ]]
        then
            if [ $VERBOSE = 1 ]; then
                echo "${0}: Connecting to ${SERVER}..."
            fi
            $BIN_SWCLOCK $SERVER

            if [ $HWCLOCK = 1 ]; then
                if [ $VERBOSE = 1 ]; then
                    echo "${0}: Updating hardware clock..."
                fi
                $BIN_HWCLOCK
            fi
        else
            echo "${0}: There are no Internet connection" >&2
            exit 1
        fi
    else
        echo "${0}: File '${FILE_NET_ROUTE}' does not exist" >&2
        exit 1
    fi
fi


exit 0

