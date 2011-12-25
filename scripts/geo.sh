#!/bin/sh
#
# For assistance, please visit forum.ipinfodb.com
#
# Created by Eric Gamache on 2009-05-26
# Version 1.0 by Eric Gamache -- 2009-06-04
# Version 1.1 updated by Marc-Andre Caron -- 2009-06-08 .. Added timezone
# Version 1.2 updated by Eric Gamache -- 2009-06-08 .. fix minors bugs.
# Version 1.3 updated by Marc-Andre Caron -- 2010-02-11 .. new
#             timezone support, reduced complexity of the script.
#
# Updated and improved by Pferor <pferor [AT] gmail [DOT] com>
#


## Check dependencies
## Wget
TST_wget=`wget > /dev/null 2>&1`
ErrorLevel=$?

## Check for dependencie
if [ "${ErrorLevel}" != 1 ] ; then
    echo " ----"
    echo " wget not found; please install it for proper operation."
    echo " ----"

    exit 1
fi


## Default values
DEFAULT_TYPE="json"
DEFAULT_TIMEZONE="false"

### Functions
## Displays help
function show_help
{
    echo " Usage : ${0} [<IP>] [<TYPE>] [<TIMEZONE>]"
    echo "   <IP>       is the IP to check"
    echo "   <TYPE>     is the output type (xml|json) (default: '${DEFAULT_TYPE}')"
    echo "   <TIMEZONE> is to show timezone data or not (false|true) (default: '${DEFAULT_TIMEZONE}')"
    echo ""
    echo " If no IP is specified, current IP is used"
    echo " If more that one option is used, it has to be in the right order"
    echo ""
}

### Main variables
URI="http://ipinfodb.com/ip_query.php?ip="
WGET_OPTION="=-b -q --wait=3 --waitretry=2 --random-wait --limit-rate=9578 "
WGET_AGENT="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"

### Validation
##  First argument
if [[ "${1}" = "h" ]] || [[ "${1}" = "-h" ]] || [[ "${1}" = "-help" ]] || [[ "${1}" = "--help" ]]
then
    show_help
    exit 0
fi

## If first argument is timezone,... then use it
if [[ "${1}" = "true" ]] || [[ "{1}" = "false" ]]
then
    TIMEZONE="${1}"
## If first argument is type, then use it for current IP
elif [[ "${1}" = "json" ]] || [[ "${1}" = "xml" ]]
then
    TYPE="${1}"

    ## Same with timezone after the output type
    if [[ "${2}" = "true" ]] || [[ "{2}" = "false" ]]
    then
	TIMEZONE="${2}"
    fi
else
    IP="${1}"
fi

## First argument derived values
HTTP_LINK_XML="$URI""${IP}""&output=xml&timezone="
HTTP_LINK_JSON="$URI""${IP}""&output=json&timezone="
HTTP_LINK_PLAIN="$URI""${IP}""&output=text&timezone="


##  Second argument
if [[ -z ${TYPE} ]]
then
    if [ "${2}" != "" ]; then
        if [ "${2}" != "json" ] && [ "${2}" != "xml" ]; then
            TYPE="${DEFAULT_TYPE}"
        else
            TYPE="${2}"
        fi
    else
        TYPE="${DEFAULT_TYPE}"
    fi
fi

##  Third argument
if [[ -z ${TIMEZONE} ]]
then
    if [ "${3}" != "" ]; then
        if [ "${3}" != "true" ] && [ "${3}" != "false" ] ; then
            TIMEZONE="${DEFAULT_TIMEZONE}"
        else
            TIMEZONE="${3}"
        fi
    else
        TIMEZONE="${DEFAULT_TIMEZONE}"
    fi
fi


## Print output
if [ "${TYPE}" = "json" ]; then
    JSON_Info=$(wget -qO- --user-agent="$WGET_AGENT" $HTTP_LINK_JSON"$TIMEZONE" 2>&1)
    echo "$JSON_Info"
else
    XML_Info=$(wget -qO- --user-agent="$WGET_AGENT" $HTTP_LINK_XML"$TIMEZONE" 2>&1)
    echo "$XML_Info"
fi


## Exit successfully... as usual
exit 0

