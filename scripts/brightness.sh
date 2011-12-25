#!/bin/bash
#
# vaio_progressivebright.sh
#
# Changes bright state progresively in Sony Vaio
#
# Praeter Feror <praeterferor@gmail.com>
# Version 2.0
#
# 2008-07-11

#MaxBright=100
#MinBright=0
#StepBright=10
MaxBright=8
MinBright=0
StepBright=1
#FILE="/sys/class/backlight/acpi_video0/brightness"
FILE="/sys/class/backlight/acpi_video0/brightness"
Current=`cat $FILE`

function show_usage {
echo "Usage: $(basename ${0}) <option>"
	echo "  up:   Increases bright"
	echo "  down: Decreases bright"
	echo "  cur:  Tells about current bright"
}

function bright_up {
	if [ $Current -lt $MaxBright ]; then
		Current=$(($Current+$StepBright))
		if [[ ${Current} -ge ${MaxBright} ]]; then
			Current=${MaxBright}
		fi
		echo "${Current}" > ${FILE}
		echo "Bright increased to: $Current"
	else
		Current=${MaxBright}
		echo "Bright is already to $MaxBright (max)"
	fi
}

function bright_down {
	if [ $Current -gt $MinBright ]; then
		Current=$(($Current-$StepBright))
		if [[ ${Current} -le ${MinBright} ]]; then
			Current=${MinBright}
		fi
		echo "${Current}" > ${FILE}
		echo "Bright decreased to: $Current"
	else
		Current=${MinBright}
		echo "Bright is already at $MinBright (min)"
	fi
}

#if [[ `whoami` != "root" ]] && [[ "${1}" != "cur" ]]
if [[ `whoami` != "root" ]] && ([[ "${1}" = "up" ]] || [[ "${1}" = "down" ]])
then
	echo "You must be root in order to run this script"
	exit 1
fi

if [ ${#} -ne 1 ]; then
	show_usage
	exit
else
	if [ ${1} == "up" ]; then
		bright_up
	elif [ ${1} == "down" ]; then
		bright_down
	elif [ ${1} == "cur" ]; then
		echo "Current bright: $Current"
	else
		show_usage
		exit 1
	fi
fi

exit 0

