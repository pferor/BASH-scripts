#!/bin/sh
#
#
# Pings all 192.168.1.0/24 and show who's up
#
# Requirements: fping


## set net interface
DEFAULT_IFACE="wlan0"
if [[ ${#} -ne 0 ]]
then
    IFACE="${1}"
else
    IFACE="${DEFAULT_IFACE}"
fi

FPING_APP="/usr/sbin/fping"
FPING_OPTS="-t100 -p100 -c1"
FPING_RANGE="-g 192.168.1.0/24"

TMP_FILE="/tmp/fping_output"

AP_IP="192.168.1.1 " # last space required
#OWN_IP="$(ifconfig ${IFACE} | grep "inet addr" | cut -c21-33)"
OWN_IP="$(ifconfig ${IFACE} | grep "inet " | cut -c14-26)"

## Validation...
if [[ ! -x "${FPING_APP}" ]]
then
    echo "${0}: '${FPING_APP}' not found" >&2
    exit 1
fi


## Do it
echo -ne "Searching...\r"
${FPING_APP} ${FPING_OPTS} ${FPING_RANGE} 2>/dev/null | cut -c-14 > ${TMP_FILE}
grep -ve "${OWN_IP}\|${AP_IP}" ${TMP_FILE}

USERS_ONLINE=$(grep -ve "${OWN_IP}\|${AP_IP}" ${TMP_FILE} | wc -l)

## Echo number of users online
if [[ ${USERS_ONLINE} -eq 0 ]]
then
    echo "You are the only one in this subnet ;-D (${OWN_IP})"
elif [[ ${USERS_ONLINE} -eq 1 ]]
then
    echo "${USERS_ONLINE} user in this subnet (besides you: ${OWN_IP})"
else
    echo "${USERS_ONLINE} users in this subnet (besides you ${OWN_IP})"
fi


## Delete temporal files
rm ${TMP_FILE}

