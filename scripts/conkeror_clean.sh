#!/bin/bash
#
# Clears Conkeror history
#
# Note. Due Conkeror uses SQLite for storing the data, you should run
#       this script only while conkeror is not running. Otherwise, the
#       database could be locked
#

## USED FILES --------------------------------------------------------
## Here profile used
VERBOSE=1
#PROFILE="*default"
PROFILE="00000000.default"

## Default dir. and files
DIR_CONKEROR="${HOME}/.conkeror.mozdev.org/conkeror/${PROFILE}/"
FILE_BOOKMARKS="${DIR_CONKEROR}places.sqlite"
FILE_COOKIES="${DIR_CONKEROR}cookies.sqlite"
FILE_DOWNLOADS_HISTORY="${DIR_CONKEROR}downloads.sqlite"
FILE_FORMS_HISTORY="${DIR_CONKEROR}formhistory.sqlite"
DIR_CACHE="${DIR_CONKEROR}Cache"

## Default actions
ACTION_OVER_BOOKMARKS=0
ACTION_OVER_COOKIES=0
ACTION_OVER_DOWNLOADS_HISTORY=0
ACTION_OVER_FORMS_HISTORY=0
ACTION_OVER_CACHE=0

## This aplication name
APP_NAME="$(basename ${0})"


## FUNCTIONS ---------------------------------------------------------
## Show usage, nothing more.
function show_usage
{
    echo " Usage: ${APP_NAME} [-h] [-q|-v] [-P <profile>] [-b|-C|-c|-d|-f|-A|-a]"
    echo "    -h            Displays this help"
    echo "    -q            Quiet mode; not verbose"
    echo "    -v            Verbose mode (set by default)"
    echo "    -P <profile>  Sets profile directory (default: '${PROFILE}')"
    echo "    -b            Cleans bookmarks"
    echo "    -C            Cleans cache"
    echo "    -c            Cleans cookies"
    echo "    -d            Cleans downloads history"
    echo "    -f            Cleans forms history"
    echo "    -A            Cleans all"
    echo "    -a            Cleans all except bookmarks"
    echo ""
}

## Clears file specified as argument
##  ${1}  file to clear
##  ${2}  new content
function clear_file
{
    if [[ -z "${2}" ]]
    then
        echo  "" > "${1}"
    else
        echo "${2}" > "${1}"
    fi
}

## Takes the cleaning action
##  ${1} File to where to operate to
##  ${2} Verbose action (bool)
##  ${3} New content for file
function action_over_file
{
    if [[ ! -z "${1}" ]]
    then
        #action
        clear_file "${1}" "${3}"

        ## if verbose, 
        if [[ ${2} -ne 0 ]]
        then
            echo "Cleaned: ${1}"
        fi
    fi
}

## Cleans folder contents
##  ${1} Folder to clean
##  ${2} Verbose action (bool)
function action_over_dir
{
    if [[ ! -z "${1}" ]]
    then
        ## action
        rm -f "${1}"/*

        ## if verbose, 
        if [[ ${2} -ne 0 ]]
        then
            echo "Cleaned: ${1}/*"
        fi
    fi
}


## OPTIONS -----------------------------------------------------------
## Get options
while getopts "hqvP:bcCdfaA" OPTION
do
    case ${OPTION} in
        h)
            show_usage
            exit 0
            ;;
        q)
            VERBOSE=0
            ;;
        v)
            VERBOSE=1
            ;;
        P)
            PROFILE=${OPTARG}

            # vars. reset
            DIR_CONKEROR="${HOME}/.conkeror.mozdev.org/conkeror/${PROFILE}/"
            FILE_BOOKMARKS="${DIR_CONKEROR}places.sqlite"
            FILE_COOKIES="${DIR_CONKEROR}cookies.sqlite"
            FILE_DOWNLOADS_HISTORY="${DIR_CONKEROR}downloads.sqlite"
            FILE_FORMS_HISTORY="${DIR_CONKEROR}formhistory.sqlite"
            DIR_CACHE="${DIR_CONKEROR}/Cache"
            ;;
        b)
            ACTION_OVER_BOOKMARKS=1
            ;;
        C)
            ACTION_OVER_CACHE=1
            ;;
        c)
            ACTION_OVER_COOKIES=1
            ;;
        d)
            ACTION_OVER_DOWNLOADS_HISTORY=1
            ;;
        f)
            ACTION_OVER_FORMS_HISTORY=1
            ;;
        a)
            ACTION_OVER_COOKIES=1
            ACTION_OVER_DOWNLOADS_HISTORY=1
            ACTION_OVER_FORMS_HISTORY=1
            ACTION_OVER_CACHE=1
            ;;
        A)
            ACTION_OVER_BOOKMARKS=1
            ACTION_OVER_COOKIES=1
            ACTION_OVER_DOWNLOADS_HISTORY=1
            ACTION_OVER_FORMS_HISTORY=1
            ACTION_OVER_CACHE=1
            ;;
        ?)
            show_usage
            exit 1;
          ;;
    esac
done

## If no arguments, then error
if [[ ${#} -eq 0 ]]
then
    show_usage
    exit 1
fi


## If directory does not exist
if [[ ! -e ${DIR_CONKEROR} ]]
then
    echo "${APP_NAME}: '${DIR_CONKEROR} does not exit'" >&2
    exit 1
fi


## Do actions
if [[ ${ACTION_OVER_CACHE} -eq 1 ]]
then
    action_over_dir "${DIR_CACHE}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_BOOKMARKS} -eq 1 ]]
then
    action_over_file "${FILE_BOOKMARKS}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_COOKIES} -eq 1 ]]
then
    action_over_file "${FILE_COOKIES}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_DOWNLOADS_HISTORY} -eq 1 ]]
then
    action_over_file "${FILE_DOWNLOADS_HISTORY}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_FORMS_HISTORY} -eq 1 ]]
then
    action_over_file "${FILE_FORMS_HISTORY}" ${VERBOSE}
fi


## Exits successfully
exit 0

