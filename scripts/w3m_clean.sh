#!/bin/bash
#
# Clears w3m history files
#
#

## USED FILES --------------------------------------------------------
VERBOSE=1

## Default dir. and files
DIR_W3M="${HOME}/.w3m/"
FILE_BOOKMARKS="${DIR_W3M}bookmark.html"
FILE_COOKIES="${DIR_W3M}cookie"
FILE_DEFAULT_HISTORY="${DIR_W3M}history"
FILE_ARRIVED_HISTORY="${DIR_W3M}.arrived"

## Default actions
ACTION_OVER_BOOKMARKS=0
ACTION_OVER_COOKIES=0
ACTION_OVER_DEFAULT_HISTORY=0
ACTION_OVER_ARRIVED_HISTORY=0

## Some empty contents
##  It can be set to an empty file, but then, emacs-w3m won't be able
##  to add new bookmarks
BOOKMARKS_EMPTY_CONTENT="\
<html><head><title>Bookmarks</title></head>
<body>
<h1>Bookmarks</h1>
<h2>Search</h2>
<ul>
<!--End of section (do not delete this comment)-->
</ul>
</body>
</html>
"


## FUNCTIONS ---------------------------------------------------------
## Show usage, nothing more.
function show_usage
{
    echo "Usage: $(basename ${0}) [-h] [-q|-v] [-b|-c|-d|-r|-A|-a]"
    echo "    -h            Displays this help"
    echo "    -q            Quiet mode; not verbose"
    echo "    -v            Verbose mode (set by default)"
    echo "    -b            Cleans bookmarks"
    echo "    -c            Cleans cookies"
    echo "    -d            Cleans default history"
    echo "    -r            Cleans arrived history"
    echo "    -A            Cleans all"
    echo "    -a            Cleans all except bookmarks"
    echo ""
}

## Clears file specified as argument
##  ${1}  file to cleara
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
function action_over
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


## OPTIONS -----------------------------------------------------------
## Get options
while getopts "hqvbcdraA" OPTION
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
        b)
            ACTION_OVER_BOOKMARKS=1
            ;;
        c)
            ACTION_OVER_COOKIES=1
            ;;
        d)
            ACTION_OVER_DEFAULT_HISTORY=1
            ;;
        r)
            ACTION_OVER_ARRIVED_HISTORY=1
            ;;
        a)
            ACTION_OVER_COOKIES=1
            ACTION_OVER_DEFAULT_HISTORY=1
            ACTION_OVER_ARRIVED_HISTORY=1
            ;;
        A)
            ACTION_OVER_BOOKMARKS=1
            ACTION_OVER_COOKIES=1
            ACTION_OVER_DEFAULT_HISTORY=1
            ACTION_OVER_ARRIVED_HISTORY=1
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


## Check if directory exists
if [[ ! -e ${DIR_W3M} ]]
then
    echo "$(basename ${0}): '${DIR_W3M}' not found" >&2
fi

## Do actions
if [[ ${ACTION_OVER_BOOKMARKS} -eq 1 ]]
then
    ## Bookmarks should not be an empty file, it has a template
    ## (emacs-w3m warning)
    action_over "${FILE_BOOKMARKS}" ${VERBOSE} "${BOOKMARKS_EMPTY_CONTENT}"
fi

if [[ ${ACTION_OVER_COOKIES} -eq 1 ]]
then
    action_over "${FILE_COOKIES}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_DEFAULT_HISTORY} -eq 1 ]]
then
    action_over "${FILE_DEFAULT_HISTORY}" ${VERBOSE}
fi

if [[ ${ACTION_OVER_ARRIVED_HISTORY} -eq 1 ]]
then
#    action_over "${FILE_ARRIVED_HISTORY}" ${VERBOSE}

    ## Arrived must be deleted instead of empty (emacs-w3m warning)
    rm -f "${FILE_ARRIVED_HISTORY}" 2> /dev/null

    if [[ ${VERBOSE} -eq 1 ]]
    then
	echo "Deleted: ${FILE_ARRIVED_HISTORY}"
    fi
fi


## Exits successfully
exit 0


