#!/bin/bash


## Lines where to display
if [[ ${#} -eq 0 ]]
then
    LINES=11
else
    LINES=${1}
fi


## Check for terminal
if [[ $(tput colors) -ne "256" ]]
then
    echo "This is not a 256 terminal!" 2> /dev/stderr
    exit 1
fi


## Show colors
for ((x=0; x<=255; x++))
do
    echo -ne "\033[38;5;${x}m${x}\033[000m\t"
    if [[ $((${x} % ${LINES})) -eq 0 ]]
    then
        echo ""
    fi
done


## Done and exit
echo ""
exit 0

