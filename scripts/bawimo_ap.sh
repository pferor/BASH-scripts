#!/bin/bash
#
# Bash wireless monitor
#
# Dependencies:
#   - bash
#   - ifconfig
#   - wireless-tools (iwconfig, iwlist,...)
#   - dhclient
#
# Author... Praeter Feror < praeterferor AT gmail DOT com >
# Date..... Thu Jul  2 15:50:22 UTC 2009
#


## Some commands require "sudo power" #################################
if [[ `whoami` != "root" ]]
then
    SU_PREFIX="sudo"
else
    SU_PREFIX=""
fi
#######################################################################


## Configure this lines for your system ###############################
INTERFACE="wlan0"
IFCONFIG="${SU_PREFIX} /sbin/ifconfig"
IWCONFIG="${SU_PREFIX} /usr/sbin/iwconfig"
IWLIST="${SU_PREFIX} /usr/sbin/iwlist"
#DHCPC="${SU_PREFIX} /sbin/dhclient -q"
DHCPC="${SU_PREFIX} /sbin/dhcpcd -q"
SCAN_RESULTS_FILE=${HOME}"/.bawimo.tmp"
#######################################################################


## Set interface up ###################################################
if [[ `${IFCONFIG} | grep ${INTERFACE} | wc -l` -eq 0 ]]
then
#	echo " :: Activating interface..."
	${IFCONFIG} ${INTERFACE} up
fi
#######################################################################


## Make a scan ########################################################
#echo " :: Scanning..."
${IWLIST} ${INTERFACE} scan > ${SCAN_RESULTS_FILE}
#######################################################################


## Check if there are no cells ########################################
if [[ `cat ${SCAN_RESULTS_FILE} | wc -l` -le 2 ]]
then
    echo "ERROR. Neither access points nor ad-hoc cells are in range" >> /dev/stderr
    exit 1
fi
#######################################################################


## Retreiving ESSID ###################################################
#echo " :: Retreiving ESSID list..."
let count=0
for essid in `cat ${SCAN_RESULTS_FILE} | grep "ESSID" | cut -c28- | sed -e 's/.$//g'`
do
  essid_arr[${count}]=${essid}
  ((count++))
done
unset essid
#######################################################################


## Retreiving encryption ##############################################
#echo " :: Retreiving encription list..."
let count=0
for enc in `cat ${SCAN_RESULTS_FILE} | grep "Encryption" | cut -c36-`
do
  enc_arr[${count}]=${enc}
  ((count++))
done
unset enc
#######################################################################


## Retreiving quality #################################################
#echo " :: Retreiving quality list..."
let count=0
for quality in `cat ${SCAN_RESULTS_FILE} | grep "Quality" | cut -c29-34`
do
  quality_arr[${count}]=${quality}
  ((count++))
done
unset quality
#######################################################################


## Retreiving channel #################################################
#echo " :: Retreiving channel list..."
let count=0
for channel in `cat ${SCAN_RESULTS_FILE} | grep "Channel:" | cut -c29-`
do
  channel_arr[${count}]=${channel}
  ((count++))
done
unset channel
#######################################################################


## Retreiving access point ############################################
#echo " :: Retreiving channel list..."
let count=0
for ap in `cat ${SCAN_RESULTS_FILE} | grep "Address" | cut -c30-`
do
  ap_arr[${count}]=${ap}
  ((count++))
done
unset ap
#######################################################################

unset count


## Print table results ################################################
#echo " :: Printing ESSID list..."
echo -e "----------------------------------------------------------------------------"
echo -e " CELL\tQLTY\tKEY\tCH\tACCESS POINT\t\tESSID"
echo -e "----------------------------------------------------------------------------"
for (( i=0; i<${#essid_arr[@]}; i++))
do
    echo -e " $((${i}+1))\t${quality_arr[${i}]}\t${enc_arr[${i}]}\t${channel_arr[${i}]}\t\
${ap_arr[${i}]}\t${essid_arr[${i}]}"
done
#######################################################################


## Set net parameters #################################################
echo ""
read -p " > Enter cell ID: " net_id

## Check ID limits
if [[ ${net_id} -lt 1 ]] || [[ ${net_id} -gt ${#essid_arr[@]} ]]
then
    echo "ERROR. Bad cell ID" >> /dev/stderr
    exit 1
fi

## Make index correction
net_id=$((${net_id}-1))

## It has encryption? -- gets key and stores it in hexadecimal
if [[ ${enc_arr[${net_id}]} = "on" ]]
then
    echo -n " > Password: "
    stty -echo
    net_password=""
    while read -s -n 1 ASCIICHAR
    do
        [ "${ASCIICHAR}" = "" ] && break
        net_password=${net_password}`printf "%X" $(printf "%d" \'"${ASCIICHAR}"\')`
    done
    echo ""
    stty echo
else
    net_password="off"
fi


## Connect!
${IWCONFIG} ${INTERFACE} essid   "${essid_arr[${net_id}]}"
${IWCONFIG} ${INTERFACE} key     ${net_password}
${IWCONFIG} ${INTERFACE} channel ${channel_arr[${net_id}]}
${IWCONFIG} ${INTERFACE} ap      ${ap_arr[${net_id}]}
#######################################################################


## Makes connection and exit ##########################################
sleep 1

echo " :: Conecting to ${essid_arr[${net_id}]}..."
${DHCPC} ${INTERFACE}
CURIP=`${IFCONFIG} ${INTERFACE} | grep "inet addr" | cut -c21-33`

## Deletes temporal file
rm --force ${SCAN_RESULTS_FILE}

## Unset all
unset SU_PREFIX
unset INTERFACE
unset IFCONFIG
unset IWCONFIG
unset IWLIST
unset DHCPC
unset SCAN_RESULTS_FILE
unset enc_arr
unset essid_arr
unset quality_arr
unset ap_arr
unset channel_arr
unset net_id
unset net_password


## Exit script
if [[ ${CURIP} == "" ]]
then
    echo "ERROR. Could not entablish connection" >> /dev/stderr
    unset CURIP
    exit 1
else
    echo " :: Connected as: ${CURIP}"
    unset CURIP
    exit 0
fi
#######################################################################

