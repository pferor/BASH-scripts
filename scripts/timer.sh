#!/bin/sh
#
# Timer
# Sleep and play a sound
#
# Dependencies:
#  * sleep
#  * play

## Global
SLEEP_TIME=""
SOUND_FILE="${HOME}/.sounds/alarm.wav"


## Functions
function show_usage
{
    echo "Usage: $(basename ${0}) -n <NUMBER[SUFFIX]> [-f <filename>]"
    echo ""
    echo "  -n <NUMBER[SUFFIX]"
    echo "    Pause  for NUMBER seconds.   SUFFIX may  be 's'  for seconds"
    echo "    (the default),  'm' for  minutes, 'h' for  hours or  'd' for"
    echo "    days.  Unlike most implementations that require NUMBER be an"
    echo "    integer,  here NUMBER  may  be an  arbitrary floating  point"
    echo "    number.  Given  two or more arguments, pause  for the amount"
    echo "    of time specified by the sum of their values."
    echo ""
    echo "  -f <filename>"
    echo "    After the  pause, a sound  will  be played.  By default, the"
    echo "    filename is '${SOUND_FILE}'."
    echo ""
    echo "  -k"
    echo "    Kills this script if running."
    echo ""
}


## Get options
while getopts "n:f:kh" OPTION
do
    case ${OPTION} in
	h)
	    show_usage
	    exit 0
	    ;;
	n)
	    SLEEP_TIME="${OPTARG}"
	    ;;
	f)
	    SOUND_FILE="${OPTARG}"
	    ;;
	k)
	    killall $(basename ${0})
	    killall play
	    ;;
	?)
	    show_usage
	    exit 1
	    ;;
    esac
done


## Validation
if [[ ! -e ${SOUND_FILE} ]]
then
    echo "$(basename ${0}): sound file '$SOUND_FILE' does not exist" >&2
    exit 2
fi
if [[ -z ${SLEEP_TIME} ]]
then
    echo "$(basename ${0}): time must be positive "
    exit 3
fi


## Do the stuff
while :
do
    sleep ${SLEEP_TIME}
    play -q ${SOUND_FILE}
done &

