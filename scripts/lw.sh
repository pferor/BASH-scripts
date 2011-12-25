#!/bin/bash
#
# Bookmarks list
# Unified shell bookmarks storage.
#

TMP_FILE="/tmp/linkenwagen"
FILE="${HOME}/.linkenwagen"
BROWSER="/usr/bin/conkeror"
ACT_SHOW=0
ACT_SHOW_ALONE=0
ACT_ADD=0
ACT_RUN=0
ACT_REM=0


## Show help
function show_help
{
    APP_NAME="$(basename ${0})"

    echo "Usage: ${APP_NAME} [[-f <filename>] | [-b <browser>] | [-a <link>] | [-R <num>]]"
    echo "       ${APP_NAME} [[-n <num>] | [-g <num>]"
    echo "       ${APP_NAME} -h"
    echo "Options:"
    echo "   -f <filename> Filename to use (default: '${FILE}')"
    echo "   -b <browser>  Path to the browser (default: '${BROWSER}')"
    echo "   -a <link>     Link to add to the list"
    echo "   -R <num>      Link to remove from list"
    echo "   -g <num>      Go to this link from list"
    echo "   -n <num>      Link to display from list"
    echo "   -l            Display complete link list (action by default)"
    echo "   -h            Display this help"
    echo ""
}

## Get options
while getopts "hla:g:f:n:b:R:" OPTION
do
    case ${OPTION} in
	h)
	    show_help
	    exit 0
	    ;;
	l)
	    ACT_SHOW=1
	    ;;
	n)
	    ACT_SHOW=0
	    ACT_SHOW_ALONE=1
	    LNK_NUMBER=${OPTARG}
	    ;;
	a)
	    ACT_ADD=1
	    NEW_LINK="${OPTARG}"
	    ;;
	g)
	    ACT_RUN=1
	    RUN_NUMBER=${OPTARG}
	    ;;
	R)
	    ACT_REM=1
	    REM_NUMBER=${OPTARG}
	    ;;
	f)
	    FILE="${OPTARG}"
	    ;;
	b)
	    BROWSER="${OPTARG}"
	    ;;
	?)
	    show_help
	    exit 1
	    ;;
    esac
done


## Show action by default
if [[ ${#} -eq 0 ]]; then
    ACT_SHOW=1
fi

## Validate
## Browser does not exist
if [[ ! -x "${BROWSER}" ]]
then
    echo "${0}: '${BROWSER}' not found" >&2
    exit 1
fi

## Bad URI
if [[ ${ACT_ADD} -eq 1 ]]
then
    if [[ "${NEW_LINK:0:4}" != "http" ]] && [[ "${NEW_LINK:0:3}" != "ftp" ]]
    then
	echo "${0}: Not a URI" >&2
	exit 2
    fi
fi


## Do the stuff
if [[ ${ACT_SHOW} -eq 1 ]]; then
    nl "${FILE}"
fi

if [[ ${ACT_SHOW_ALONE} -eq 1 ]]; then
    SHOW_LINK=$(sed -n "${LNK_NUMBER}p" ${FILE})
    grep -x --color=none "${SHOW_LINK}" ${FILE}
fi

if [[ ${ACT_ADD} -eq 1 ]]; then
    echo "${NEW_LINK}" >> "${FILE}"
fi

if [[ ${ACT_REM} -eq 1 ]]; then
    REM_LINK=$(sed -n "${REM_NUMBER}p" ${FILE})
    grep -vx "${REM_LINK}" ${FILE} > "${TMP_FILE}"
    mv "${TMP_FILE}" "${FILE}"
    rm "${TMP_FILE}" 2>/dev/null
fi

if [[ ${ACT_RUN} -eq 1 ]]; then
    RUN_LINK=$(sed -n "${RUN_NUMBER}p" ${FILE})
    if [[ ! -z "${RUN_LINK}" ]]; then
	${BROWSER} "${RUN_LINK}" &
    fi
fi

