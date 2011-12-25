#!/bin/bash
#
# #####################################################################
# bawescan.sh (BAsh Wireless Extended SCAN)
# #####################################################################
#
#
# Dependencies
# ------------
#   - bash
#   - ifconfig
#   - iwlist
#
# Description
# -----------
#   Displays a table with access points in range. A `iwlist` summary
#
# Configure
# ---------
#   Just change lines from 97 to 99 if you need
#
# Installation?
# -------------
#   $ sudo cp bawescan.sh /usr/local/bin
# Optional:
#   $ sudo mv /usr/local/bin/bawescan.sh /usr/local/bin/bawescan
#
# Usage
# -----
#   $ bawescan.sh [< wireless interface >]
#   wlan0 will be scanned if no interface is specified as parameter
#
# Notes
# -----
#   1. This script uses 'iwlist' and must be executed as 'root'.
#   2. This script is adapted to produce a >80 columns output!
#
# Author
# ------
#   Pferor < pferor [AT] gmail [DOT] com >
#
# Date
# ----
#   Thu Jul  2 15:50:22 UTC 2009
#

function draw_bar
{
    QLTY_FRAC=${1}

    echo -n "${QLTY_FRAC}"

    unset QLTY_FRAC
}


## Some commands require "sudo power" #################################
SU_PREFIX=""
if [[ `whoami` != "root" ]]
then
#    SU_PREFIX="sudo"
    echo " You need to be root in order to execute this script"
    echo " iwlist requires super administrator privileges"
    echo ""
    echo " Try:"
    echo "    sudo /usr/local/bin/bawescan"
    echo ""
    echo " You can add a new alias in your ~/.bashrc file:"
    echo "   alias bawescan='sudo /usr/local/bin/bawescan'"
    echo ""

    exit 1
fi
#######################################################################


## Configure this lines for your system ###############################
if [[ ${1} = "" ]]
then
    INTERFACE="wlan0"
else
    INTERFACE="${1}"
fi
IFCONFIG="${SU_PREFIX} /sbin/ifconfig"
IWLIST="${SU_PREFIX} /usr/sbin/iwlist"
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
echo -ne " :: Scanning...\r"
${IWLIST} ${INTERFACE} scan > ${SCAN_RESULTS_FILE} 2> /dev/null
#######################################################################


## Check if there are no cells ########################################
SCAN_RESULTS_NO=`cat ${SCAN_RESULTS_FILE} | grep "Cell" | wc -l` 
if [[ ${SCAN_RESULTS_NO} -le 1 ]]
then
    echo "ERROR. Neither access points nor ad-hoc cells are in range" \
    >> /dev/stderr
    exit 1
fi
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


## Retreiving encryption type #########################################
#echo " :: Retreiving encription type list..."
for ((i=0; i<${SCAN_RESULTS_NO}; i++))
do
    if [[ ${i} -lt 10 ]]
    then
        enc_type=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell 0$((${i}+1))/,/Cell 0$((${i}+2))/p" | grep -m1 "WPA"`
    else
        enc_type=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell $((${i}+1))/,/Cell $((${i}+2))/p" | grep -m1 "WPA"`
    fi

    if [[ `echo ${enc_type} | grep "WPA2" | wc -l` -ge 1 ]]
    then
        enc_type=`echo ${enc_type} | cut -c18-`
    else
        enc_type=`echo ${enc_type} | cut -c5-`
    fi 

    enc_type=`echo ${enc_type} | sed -e "s/ Version .//g"`

    if [[ ${enc_type} = "" ]]
    then
        if [[ ${enc_arr[${i}]} = "on" ]]
        then
            enc_type="WEP"
        else
            enc_type="OPN"
        fi
    fi
    enc_type_arr[${i}]=${enc_type}
done
unset enc_type
unset i
#######################################################################


## Retreiving enctryption cipher ######################################
#echo " :: Retreiving encription cipher..."
for ((i=0; i<${SCAN_RESULTS_NO}; i++))
do
    if [[ ${i} -lt 10 ]]
    then
        enc_cipher=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell 0$((${i}+1))/,/Cell 0$((${i}+2))/p" | \
        grep -m1 "Pairwise Ciphers" | \
        cut -c48-`
    else
        enc_cipher=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell $((${i}+1))/,/Cell $((${i}+2))/p" | \
        grep -m1 "Pairwise Ciphers" | \
        cut -c48-`
    fi
    if [[ ${enc_type_arr[${i}]} = "WEP" ]]
    then
        enc_cipher="WEP"
    fi

    if [[ `echo ${enc_cipher} | grep "TKIP" | wc -l` -gt 0 ]] && \
       [[ `echo ${enc_cipher} | wc -w` -gt 1 ]]
    then
        enc_cipher=`echo ${enc_cipher} | sed -e "s/TKIP//g"`
    fi
    enc_cipher_arr[${i}]=${enc_cipher}
done
unset enc_cipher
unset i
#######################################################################


## Retreiving auth. type ##############################################
#echo " :: Retreiving auth. type list..."
for ((i=0; i<${SCAN_RESULTS_NO}; i++))
do
    if [[ ${i} -lt 10 ]]
    then
        enc_auth=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell 0$((${i}+1))/,/Cell 0$((${i}+2))/p" | \
        grep -m1 "Authentication Suites" | \
        cut -c53-`
    else
        enc_auth=`cat ${SCAN_RESULTS_FILE} | \
        sed -n "/Cell $((${i}+1))/,/Cell $((${i}+2))/p" | \
        grep -m1 "Authentication Suites" | \
        cut -c53-`
    fi
    
    if [[ `echo ${enc_auth} | grep "802" | wc -l` -ge 1 ]]
    then
        enc_auth="MGT"
    fi
    enc_auth_arr[${i}]=${enc_auth}
done
unset enc_auth
unset i
#######################################################################


## Retreiving ESSID ###################################################
#echo " :: Retreiving ESSID list..."
let count=0
for essid in `cat ${SCAN_RESULTS_FILE} | grep "ESSID" | cut -c28- | \
    sed -e 's/.$//g'`
do
  essid_arr[${count}]=${essid}
  ((count++))
done
unset essid
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


## Retreiving signal ##################################################
#echo " :: Retreiving signal list..."
let count=0
for signal in `cat ${SCAN_RESULTS_FILE} | grep "Signal level" | cut -c49-52`
do
  signal_arr[${count}]=${signal}
  ((count++))
done
unset signal
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
#echo " :: Retreiving access point list..."
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
#echo " :: Printing networking list..."
echo  "----------------------------------------------------------------------------"
echo -n " "
printf '%-17s  %-2s  %-4s' "BSSID" "CH" "QLTY"
printf '  '
printf '%-8s' "SIGNAL"
printf '  '
printf '%-4s  %-4s  %-4s' "ENC" "CIPH" "AUTH"
printf '  '
printf '%s' "ESSID" 
echo " "
echo  "----------------------------------------------------------------------------"
for (( i=0; i<${#essid_arr[@]}; i++))
do
    printf '%18s  %2d  %3d%%' ${ap_arr[${i}]} ${channel_arr[${i}]} $((100*${quality_arr[${i}]}))
    printf '  '
    printf '%4s dBm' ${signal_arr[${i}]}
    printf '  '
    printf '%-4s  %-4s  %-4s' ${enc_type_arr[${i}]} ${enc_cipher_arr[${i}]} ${enc_auth_arr[${i}]}
    printf '  '
    printf '%s' ${essid_arr[${i}]} 
#    echo -ne " $((${i}+1))"
    echo ""
#   echo "----------------------------------------------------------------------------"
done
#######################################################################


## Finish script ######################################################
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
unset SCAN_RESULTS_NO
unset enc_arr
unset essid_arr
unset quality_arr
unset ap_arr
unset channel_arr
unset net_id
unset net_password

## Exit script
exit 0
#######################################################################

