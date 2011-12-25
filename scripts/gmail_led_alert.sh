#!/bin/sh
#
# Description
#  Scroll Lock blinks when new mail arrives to a Gmail account
#
# Features
#  This script runs as a daemon
#  Password is asked by non-echoed prompt or given by option
#
# Dependencies
#  setleds (to turn the led on/off on tty)
#  xset (to turn the led on/off on X)
#  wget (to retrieve gmail file)
#
#
# Return values
#  0  exits succesfully
#  1  error in option
#  2  blank username
#  3  blank password
#  4  cannot read 'atom' file
#
# Author
#  pferor <pferor@gmail.com>
#


## Validation
if [[ ! -x "/usr/bin/xset" ]]
then
    echo "$(basename ${0}): '/usr/bin/xset' not found" >&2
    exit 1
fi
if [[ ! -x "/usr/bin/setleds" ]]
then
    echo "$(basename ${0}): '/usr/bin/setleds' not found" >&2
    exit 1
fi


## Initial values
USEPROXY=1              # to retrieve the gmail file
DELAY_BLINK="1"         # seconds
DELAY_MAIL_CHECK="60"   # seconds
GMAIL_USERNAME=""
GMAIL_PASSWORD=""


## Functions
## Turns on a led (Uses 'setleds' on a tty and 'xset' on X)
function led_on
{
    if [[ "${TERM}" = "linux" ]] || [[ "${TERM}" = "screen" ]]
    then
        setleds +scroll
    else
        xset led 3
    fi
}

## Turns off a led (Uses 'setleds' on a tty and 'xset' on X)
function led_off
{
    if [[ "${TERM}" = "linux" ]] || [[ "${TERM}" = "screen" ]]
    then
        setleds -scroll
    else
        xset -led 3
    fi
}

## Makes a led to blink
##  ${1} time in seconds between blinks
function led_blink
{
    led_on
    sleep ${1}
    led_off
    sleep ${1}
}

## Checks mail with a given password
##  ${1} Gmail username
##  ${2} Gmail password
function check_mail
{
    GMAILHDR="https://"
    GMAILURL="mail.google.com/mail/feed/atom"
    GMAILOUTDIR="/tmp/"
    GMAILOUT=${GMAILOUTDIR}"atom"
    WGETOPTS="--no-check-certificate --quiet -O ${GMAILOUT}"

    if [[ ${USEPROXY} -eq 0 ]]
    then
        WGETOPTS="${WGETOPTS} --no-proxy"
    fi

    wget ${GMAILHDR}${1}:${2}@${GMAILURL} ${WGETOPTS}

    ## Get wget return value (TODO -- revise this lines)
    WGET_RETURN=${?}
    if [[ ${WGET_RETURN} -ne 0 ]]
    then
        exit 4
    fi

    ## Double check on wget
    if [[ ! -f ${GMAILOUT} ]]
    then
        echo "$(basename ${0}): Could not accesss acount. May be the password you've typed is incorrect or there are many instances of this script runing at the same time." >&2
        exit 4
    fi

    COUNT=$(grep "fullcount" ${GMAILOUT} | cut -c12)
    rm --force ${GMAILOUT}

    return ${COUNT}
}


## Show usage
function show_help
{
    echo " Usage: $(basename ${0}) -u <username> [-p <password>] [-t <delay_time>]"
    echo "        $(basename ${0}) -h"
    echo "        $(basename ${0}) -k"
    echo ""
    echo " Options:"
    echo "    -h              Displays this help"
    echo "    -k              Kills this script while running"
    echo "    -u <username>   Gmail username"
    echo "    -p <password>   Gmail password"
    echo "    -t <time_delay> Time between checks (default: ${DELAY_MAIL_CHECK} s.)"
    echo "    -N              Do not allow wget to use proxy"
    echo "    -P              Use system proxy through wget (default)"
    echo ""
    echo " If no password is given, a prompt will ask for it (no echoed)."
    echo " This script runs as a daemon. To stop it run '$(basename ${0}) -k'."
    echo ""
}


## Get options
while getopts "hku:t:p:PN" OPTION
do
    case ${OPTION} in
        h)
            show_help
            exit 0
            ;;
        k)
            led_off
            killall $(basename ${0})
            ;;
        u)
            GMAIL_USERNAME="${OPTARG}"
            ;;
        p)
            GMAIL_PASSWORD="${OPTARG}"
            ;;
        t)
            DELAY_MAIL_CHECK=${OPTARG}
            ;;
        P)
            USEPROXY=1
            ;;
        N)
            USEPROXY=0
            ;;
        ?)
            show_help
            exit 1
            ;;
    esac
done


## Username or password cannot be void
if [[ -z $GMAIL_USERNAME ]]
then
    echo "$(basename ${0}): Username cannot be blank" >&2
    echo ""
    show_help
    exit 2
fi
if [[ -z ${GMAIL_PASSWORD} ]]
then
    echo -n "GMail Password: "
    stty -echo
    read GMAIL_PASSWORD
    stty echo
    echo ""
fi
if [[ -z ${GMAIL_PASSWORD} ]]
then
    echo "$(basename ${0}): Password cannot be blank" >&2
    exit 3
fi


MAILS_NUM=0
## Do the stuff
while :
do
    check_mail ${GMAIL_USERNAME} ${GMAIL_PASSWORD}
    MAILS_NUM=${?}

    if [[ ${MAILS_NUM} -eq 0 ]]
    then
	led_off
    else
	led_blink ${DELAY_BLINK} ## one blink each $DELAY_MAIL_CHECK seconds
	led_on                   ## keep the led on
    fi

    sleep ${DELAY_MAIL_CHECK}
done &


## Exits successfully
exit 0

