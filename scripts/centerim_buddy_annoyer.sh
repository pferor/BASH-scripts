#!/bin/bash
#
# CenterIM Buddy Annoyer
#
# OVERVIEW:
#  Annoys anyone on messenger changing
#  from on state to another
#
# REQUIREMENTS:
#  centerim
#
# AUTHOR
#  Pferor <pferor [AT] gmail [DOT] com>
#
# LAST REVISION
#  Sun Jan  3 21:29:29 UTC 2010
#

## Version
VERSION="0.1"


## Default values
PROTOCOL="msn"  # M$ messenger
STATUS_1="i"    # invisible
STATUS_2="o"    # on-line
INTERVAL=5      # seconds


## Functions
## Displays help
function show_help
{
    echo "Usage: $(basename ${0}) [-p <protocol>] [-t <interval>] [-1 <status>] [-2 <status] [-h] [-v] [-s]"
    echo "   -t <interval>  Seconds between changes (default: ${INTERVAL})"
    echo "   -p <protocol>  Protocol (default: ${PROTOCOL})"
    echo "   -1 <status>    Status #1 (default: ${STATUS_1})"
    echo "   -2 <status>    Status #2 (default: ${STATUS_2})"
    echo "   -k             Kills this annoying annoyer"
    echo "   -v             Show version"
    echo "   -h             Displays this wonderful help"
    echo ""
}

## Displays version
function show_version
{
    echo "$(basename ${0}) -- Version: ${VERSION}"
}

## Kill process
function stop_app
{
    PROCESS_NAME=$(basename ${0})

    ## If it's running... kill it!
    killall ${PROCESS_NAME}
}


## Get options
while getopts "1:2:p:t:khv" OPTION
do
    case ${OPTION} in
        1)
            STATUS_1=${OPTARG}
            ;;
        2)
            STATUS_2=${OPTARG}
            ;;
        p)
            PROTOCOL=${OPTARG}
            ;;
        t)
            INTERVAL=${OPTARG}
            ;;
        h)
            show_help
            exit 0
            ;;
        v)
            show_version
            exit 0
            ;;
        k)
        stop_app
        exit 0
        ;;
        ?)
        show_help
        exit 1
        ;;
    esac
done


## Do the stuff in background
while true
do
    centerim -S ${STATUS_1} -p ${PROTOCOL}
    sleep ${INTERVAL}s
    centerim -S ${STATUS_2} -p ${PROTOCOL}
done &


exit 0

