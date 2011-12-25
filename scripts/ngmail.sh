#!/bin/bash
#
# nGmail
# Version 0.2
# Gets number of unreaded emails on a Gmail account
# Under GPLv3 terms
#
# Requirements: bash, wget
#
# Praeter Feror <praeterferor@gmail.com>
# 2009-01-27


VERSION="0.1"

## Vars
GMAILHDR="https://"                                        # gmail header
GMAILURL="mail.google.com/mail/feed/atom"                  # gmail URL
GMAILOUTDIR="/tmp/"                                        # gmail output directory
GMAILOUT=${GMAILOUTDIR}"atom"                              # gmail output
USEPROXY=1                                                 # uses proxy by default
WGETOPTS="--no-check-certificate --quiet -O ${GMAILOUT}"   # wget options

## Display usage
function showUsage {
    echo -e "Usage: ${0} <options>"
    echo -e "  -u <user> -p <pass> Access account with username 'user' and password 'pass'"
    echo -e "  -v                  Verbose mode"
    echo -e "  -c                  Colored output"
    echo -e "  -P                  Do not use proxy"
    echo -e "  -V                  Displays version"
    echo -e "  -h                  Displays this help"
}

## Display version
function showVersion {
    echo -e "${0}"
    echo -e "version: $VERSION"
}

## Default or initial values
USERNAME=""
PASSWORD=""
COLOR=0
VERBOSE=0

## Get options
while getopts "hu:p:PcvV" OPTION
do
    case $OPTION in
        h)
        showUsage
        exit 0
        ;;
        u)
        USERNAME=$OPTARG
        ;;
        p)
        PASSWORD=$OPTARG
        ;;
        c)
        COLOR=1
        ;;
        P)
        USEPROXY=0
        ;;
        v)
        VERBOSE=1
        ;;
        V)
        showVersion
        exit 0
        ;;
        ?)
        showUsage
        exit 1
    esac
done

## set color if enabled
if [[ $COLOR -eq 1 ]]; then
    COLORED='\e[1;31m'  # red
    UNCOLORED='\e[0m'   # no color
else
    COLORED=""
    UNCOLORED=""
fi


## checks for proxy
if [[ $USEPROXY -eq 0 ]]; then
    WGETOPTS="${WGETOPTS} --no-proxy"
fi


## username and password must be entered together
if [[ -z $USERNAME ]] || [[ -z $PASSWORD ]]; then
    showUsage
    exit 1
fi


## Count mails
if [[ $VERBOSE = 1 ]]; then
    echo -e "${GMAILHDR}${USERNAME}:${COLORED}${PASSWORD}${UNCOLORED}@${GMAILURL}"
fi
wget ${GMAILHDR}${USERNAME}:${PASSWORD}@${GMAILURL} $WGETOPTS
if [[ -f $GMAILOUT ]]; then
    COUNT=$(cat $GMAILOUT | grep "fullcount" | cut -c12)    #get unread emails number
    echo -e "${COLORED}$COUNT${UNCOLORED}"
    rm $GMAILOUT                                            #delete Gmail file (atom)
    exit 0;
else
    if [[ $VERBOSE = 1 ]]; then
        echo -e "Could not access account. Check data." >&2
    fi
    exit 1
fi


## exits successfully
exit 0
