#!/bin/bash
#
# BATTERY ALERT!
# Requires: play,... and a not muted sound device
#
# Pferor: <pferor [AT] gmail [DOT] com>

## initial vars.
BAT_ID=1         ## Battery identificator (BAT0, BAT1, etc.)

CRITICAL_LEVEL_LOWER=7  ##  7% is the lower critical level of battery
			## to activate this script

CRITICAL_LEVEL_UPPER=90 ## 90% is the upper critical level of battery
			## to activate this script

DELAY_TIME="10"  ## Delay seconds

ALERT_BAT_LOW="${HOME}/.sounds/alarm.wav"  # What to play if low battery
ALERT_BAT_FULL="${HOME}/.sounds/alarm.wav" # What to play if full and charging

KILLALL_OPTS="--quiet"

## if there is no play, cannot do anything
if [[ ! -x "/usr/bin/play" ]]
then
    echo "${0}: Cannot locate 'play'" >&2
    exit 1
fi


## functions
## display cute help
function show_help
{
    echo "Usage ${0} [-h] [-k] [-b <bat_id>]"
    echo "           [-l <level>] [-u <level>] [-L <file>] [-U <file>] [-d <secs>]"
    echo ""
    echo "Options:"
    echo "  -h          Displays this help"
    echo "  -k          Kills this script (and also kills play)"
    echo "  -b <bat_id> Battery identificator (default: ${BAT_ID})"
    echo "  -l <level>  Battery percentage of lower critical level (default: ${CRITICAL_LEVEL_LOWER})"
    echo "  -u <level>  Battery percentage of upper critical level (default: ${CRITICAL_LEVEL_UPPER})"
    echo "  -L <file>   File to play when low battery (default: '${ALERT_BAT_LOW}')"
    echo "  -U <file>   File to play when battery is full and charging (default: '${ALERT_BAT_FULL}')"
    echo "  -d <secs>   Seconds between checks (default: ${DELAY_TIME})"
    echo ""
    echo " * This script will be running in background. '${0} -k' to stop it"
    echo " * Battery identificator can be found in '/proc/acpi/battery/'"
    echo " * The critical level indicates when this script starts"
    echo ""
}

## what to do -- if there is no instance of play, invoke it
function alert_action
{
    if [[ $(ps -ae | grep "play" | wc -l) -lt 1 ]]
    then
        play -q ${ALERT_BAT_LOW} &
    fi
}


## get options
while getopts "hkb:l:u:L:U:d:" OPTION
do
    case ${OPTION} in
        h)
            show_help
            exit 0
            ;;
        k)
            if [[ $(ps -ae | grep "play" | wc -l) -ge 1 ]]
            then
                killall play
            fi
            killall $(basename ${0})
            ;;
        b)
            BAT_ID=${OPTARG}
            ;;
        l)
            CRITICAL_LEVEL_LOWER=${OPTARG}
            ;;
        u)
            CRITICAL_LEVEL_UPPER=${OPTARG}
            ;;
        L)
            ALERT_BAT_LOW=${OPTARG}
            ;;
	U)
	    ALERT_BAT_FULL=${OPTARG}
	    ;;
        d)
            DELAY_TIME=${OPTARG}
            ;;
        ?)
            show_help
            exit 1
            ;;
    esac
done


## check for errors -- validation
## if there is no battery file, cannot do anything
if [[ ! -d "/proc/acpi/battery/BAT${BAT_ID}" ]]
then
    echo "${0}: Cannot locate '/proc/acpi/battery/BAT${BAT_ID}'" >&2
    exit 1
fi

## if there is no file, cannot do anything
if [[ ! -e "${ALERT_BAT_LOW}" ]]
then
    echo "${0}: Cannot locate '${ALERT_BAT_LOW}'" >&2
    exit 1
fi

## Set critical level in between [1, 100]
if [[ ${CRITICAL_LEVEL_LOWER} -gt 100 ]]
then
    CRITICAL_LEVEL_LOWER=100
elif [[ ${CRITICAL_LEVEL_LOWER} -lt 1 ]]
then
    CRITICAL_LEVEL_LOWER=1
fi

## Set critical level in between [1, 100]
if [[ ${CRITICAL_LEVEL_UPPER} -gt 100 ]]
then
    CRITICAL_LEVEL_UPPER=100
elif [[ ${CRITICAL_LEVEL_UPPER} -lt 1 ]]
then
    CRITICAL_LEVEL_UPPER=${CRITICAL_LEVEL_LOWER}
fi


## Do it
while (true)
do
    present=`grep present /proc/acpi/battery/BAT${BAT_ID}/info | awk -F' ' '{print$2}'`
    if [[ ${present} != 'no' ]]
    then
        full=`grep full /proc/acpi/battery/BAT${BAT_ID}/info | awk -F' ' '{print $4}'`
        remaining=`grep remaining /proc/acpi/battery/BAT${BAT_ID}/state | awk -F' ' '{print $3}'`
        state=`grep 'charging state' /proc/acpi/battery/BAT${BAT_ID}/state | awk -F' ' '{print $3}'`
        percentage=$((${remaining} * 100 / ${full}))
        
        if [[ ${percentage} -le ${CRITICAL_LEVEL_LOWER} ]]
        then
            ## if battery is charging, do not alert
            if [[ ${state} = "charging" ]]
            then
                ## if the alert was on, then kill it
                if [[ $(ps -ae | grep "play" | wc -l) -ge 1 ]]
                then
		    killall ${KILLALL_OPTS} play
                fi
            else
		alert_action
	    fi
	elif [[ ${percentage} -ge ${CRITICAL_LEVEL_UPPER} ]]
	then
            ## if battery is not charging, do not alert
            if [[ ${state} = "charging" ]]
            then
		alert_action
            else
                ## if the alert was on, then kill it
                if [[ $(ps -ae | grep "play" | wc -l) -ge 1 ]]
                then
		    killall ${KILLALL_OPTS} play
                fi
	    fi
	fi
    else
        echo -e "No Battery"
    fi

    ## Pause between checks
    sleep ${DELAY_TIME}
done & ## Do it in background... forever!


## optional -- successfully exit
exit 0

