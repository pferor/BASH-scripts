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
#  Pferor <pferor [AT] gmail [DOT] com>
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
B_STATE="/proc/acpi/battery/BAT${BATNO}/state";
B_INFO="/proc/acpi/battery/BAT${BATNO}/info";


## Check for files
if [[ ! -f ${B_STATE} ]] || [[ ! -f ${B_INFO} ]]; then
    echo "ERROR. Cannot find needed files! B-("
    exit 1
fi

## Print results
IS_PRESENT=`grep 'present' ${B_STATE} | awk -F' ' '{print$2}'`
if [[ ${IS_PRESENT} != 'no' ]]; then
    BAT_MAX_CAP=`grep 'full' ${B_INFO} | awk -F' ' '{print $4}'`
    BAT_CUR_CAP=`grep 'remaining' ${B_STATE} | awk -F' ' '{print $3}'`
    BAT_STATE=`grep 'charging state' ${B_STATE} | awk -F' ' '{print $3}'`
    BAT_PERCENTAGE=$(($BAT_CUR_CAP*100/$BAT_MAX_CAP))

    if [[ ${BAT_STATE} == 'charged' ]]; then
        # if we are fully charged, say so
        echo "${BAT_STATE}"
    elif [[ ${BAT_STATE} == 'charging' ]]; then
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

