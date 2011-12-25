#!/bin/bash
#
# sngmail.sh
#
# snGmail (password-'s'haded and 'n'umber of mails of 'Gmail')
# Version 0.2
# Gets number of unreaded emails on a Gmail account
# Under GPLv3 terms
#
# Based on ngmail.sh, this script makes the same work, but the
# password is asked interactively without echo for security
# reasons.
#
# Requirements: bash, wget
#
# Praeter Feror <praeterferor@gmail.com>
# 2009-07-06


VERSION="0.1"

## Vars ###############################################################
GMAILHDR="https://"                                        # gmail header
GMAILURL="mail.google.com/mail/feed/atom"                  # gmail URL
GMAILOUTDIR="/tmp/"                                        # gmail output directory
GMAILOUT=${GMAILOUTDIR}"atom"                              # gmail output
USEPROXY=1                                                 # uses proxy by default
WGETOPTS="--no-check-certificate --quiet -O ${GMAILOUT}"   # wget options

## Display usage ######################################################
function show_usage {
    echo -e "Usage: ${0} <options>"
    echo -e "  -u <user> Access account with username 'user'"
    echo -e "  -v        Verbose mode"
    echo -e "  -P        Do not use proxy"
    echo -e "  -V        Displays version"
    echo -e "  -h        Displays this help"
}

## Display version ####################################################
function show_version {
    echo -e "${0}"
    echo -e "version: ${VERSION}"
}

## Default or initial values ##########################################
USERNAME=""
VERBOSE=0

## Get options ########################################################
while getopts "hu:PcvV" OPTION
do
    case ${OPTION} in
        h)
        show_usage
        exit 0
        ;;
        u)
        USERNAME=${OPTARG}
        ;;
        P)
        USEPROXY=0
        ;;
        v)
        VERBOSE=1
        ;;
        V)
        show_version
        exit 0
        ;;
        ?)
        show_usage
        exit 1
    esac
done


## Username must be entered ###########################################
if [[ -z ${USERNAME} ]]
then
    show_usage
    exit 1
fi


## Checks for proxy ###################################################
if [[ ${USEPROXY} -eq 0 ]]
then
    WGETOPTS="${WGETOPTS} --no-proxy"
fi


## Ask for password and check #########################################
PASSWORD=""
echo -n "Gmail password: "
stty -echo
read PASSWORD
stty echo
echo ""


## Should I make a length validation too? actual Gmail passwords are
## at least 8 characters length, but a few years ago 6-lengthed
## password were (and still now are) valids... for those accounts
if [[ -z ${PASSWORD} ]]
then
    echo "Error. Password cannot be an empty string" >&2
    exit 1
fi


## Count mails ########################################################
SHADED_PASS="*******"   # always shows 8 characters (masked password... XD)

if [ ${VERBOSE} = 1 ]; then
    echo -e "${GMAILHDR}${USERNAME}:${SHADED_PASS}@${GMAILURL}"
fi

wget ${GMAILHDR}${USERNAME}:${PASSWORD}@${GMAILURL} ${WGETOPTS}

if [ -f ${GMAILOUT} ]
then
    # Get number of unread emails
    COUNT=`cat ${GMAILOUT} | grep "fullcount" | cut -c12`
    echo -e "${COUNT} new"

    # Delete Gmail file (atom)
    rm ${GMAILOUT}
    exit 0;
else
    if [ ${VERBOSE} = 1 ]
    then
        echo -e "Could not access account. Check data." >&2
    fi
    exit 1
fi

