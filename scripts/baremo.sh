#!/bin/bash
#
# DESCRIPTION:
#  baremo.sh (BAttery REmaining MOnitor)
#
# DEPENDENCIES:
#  'grep' and 'awk' -> there is no problem, both are in coreutils
#
# FILES:
#  These files are defined on lines 55 and 56
#   /proc/acpi/battery/BAT{#}/state
#   /proc/acpi/battery/BAT{#}/info
#
# NOTES:
#  May be your battery directory is not BAT1. You can specify your
#  battery number by argument.
#  Subsequent arguments will be ignored. If no argument is specified,
#  default value of line 45 will be taken.
#
#  Examples:
#    Assuming default battery directory is BAT0
#    baremo.sh 0
#
#    Assuming default battery directory is BAT2
#    baremo.sh 2
#
#  This will be useful if your laptop is two-batteries capable.
#  If you have only one battery and is not BAT1 your default battery
#  feel free to change line 45 and set it to your default battery
#  number.
#
# RETURN VALUE:
#  If info and state files do not exist, this script will exit
#  with signal 1. Otherwise will exit successfully with value 0.
#
#
#
# AUTHOR:
#  Praeter Feror <praeterferor@gmail.com>
#  Last update: Thu Sep  3 22:58:24 UTC 2009
#

## Initial values
VERSION=0.2
DEFAULT_BATNO=1

## Sets battery number by argument
if [[ ${#} = 0 ]]; then
	BATNO=$DEFAULT_BATNO;
else
	BATNO=${1};
fi

## Used files
PREVDIR="/sys/class/power_supply/BAT${BATNO}/";
FILE_STATUS="${PREVDIR}/status"
FILE_MAXCAP="${PREVDIR}/energy_full";
FILE_CURCAP="${PREVDIR}/energy_now";
#FILE_MAXCAP="${PREVDIR}/charge_full";
#FILE_CURCAP="${PREVDIR}/charge_now";
FILE_PRESENT="${PREVDIR}/present";


## Check for files
if [[ ! -f ${FILE_STATUS} ]] || [[ ! -f ${FILE_MAXCAP} ]] || [[ ! -f ${FILE_CURCAP} ]]
then
    echo "ERROR. Cannot find needed files! B-("
    exit 1
fi

IS_PRESENT=$(cat ${FILE_PRESENT})

## Echo status
if [[ ${IS_PRESENT} -eq 1 ]]; then
    BAT_CURCAP=$(cat ${FILE_CURCAP})
    BAT_MAXCAP=$(cat ${FILE_MAXCAP})
    BAT_STATUS=$(cat ${FILE_STATUS})
    BAT_PERCENTAGE=$((100 * ${BAT_CURCAP} / ${BAT_MAXCAP}))

    if [[ "${BAT_STATUS}" == "Charged" ]]; then
        # if we are fully charged, say so
        echo "${BAT_STATUS}"
    elif [[ "${BAT_STATUS}" == "Charging" ]]; then
        # if we are charging up, show the state and
        # what percentage it's at
        echo "AC ${BAT_PERCENTAGE}%"
    else
        # otherwise
        echo "${BAT_PERCENTAGE}%"
    fi
else
    echo "No Battery"
fi


## Optional, but recommended
exit 0;

