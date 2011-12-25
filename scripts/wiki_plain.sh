#!/bin/sh
#
# Dependencies: elinks, wget
#
# Retrieve a Wikipedia page and format it as plain text

### ERRORS
EXIT_SUCCESS=0
EXIT_BAD_OPTION=1
EXIT_NO_APP=2
EXIT_NO_LIST=3
EXIT_NO_ARGS=4


## DEFAULT VALUES
DOC_CHARSET="utf8"
DOC_WIDTH=75
B_REFERENCES=0
B_NUMBERS=0
VERBOSE=1

LANG_CODE="en"
URI_SKEL="http://${LANG_CODE}.wikipedia.org/w/index.php?printable=yes&title="

APPLICATION="/usr/bin/elinks"
OPTS_REFS=""


### PRE-VALIDATION
## Check for application
if [[ ! -x ${APPLICATION} ]]
then
    echo "${0}: '${APPLICATION}' not found" >&2
    exit ${EXIT_NO_APP}
fi


### FUNCTIONS
function show_help
{
    echo "Usage: ${0} [<options>] -L <list_of_titles>"
    echo "       ${0} [<options>] <document_title>"
    echo ""
    echo "Options:"
    echo "   -l <language> Language code used (default: '${LANG_CODE}')"
    echo "   -c <charset>  Document charset (default: '${DOC_CHARSET}')"
    echo "   -w <width>    Document width (default: ${DOC_WIDTH})"
    echo "   -n            Display numbers in links"
    echo "   -r            Display references in document"
    echo "   -q            Quiet mode, i.e. not verbose (not recommended)"
    echo "   -h            Show this wonderful help B^)"
    echo ""
    echo "Requirements:"
    echo "   ${APPLICATION}"
    echo ""
}


### GET OPTIONS
while getopts "hqc:w:l:rnL:" OPTION
do
    case ${OPTION} in
        h)
            show_help
            exit 0
            ;;
        q)
            VERBOSE=0
            ;;
        c)
            DOC_CHARSET="${OPTARG}"
            ;;
        w)
            DOC_WIDTH=${OPTARG}
            ;;
        r)
            B_REFERENCES=1
            ;;
        n)
            B_NUMBERS=1
            ;;
        l)
            LANG_CODE="${OPTARG}"
            ;;
        L)
            LIST="${OPTARG}"
            ;;
        ?)
            show_help
            exit ${EXIT_BAD_OPTION}
            ;;
    esac
done

## Get the non-option argument
shift $((${OPTIND} -1))
DOC="${*}"


### POST-VALIDATION
## Check for list existence
if [[ ! -z "${LIST}" ]] && [[ ! -e "${LIST}" ]]
then
    echo "${0}: Cannot find '${LIST}'" >&2
    exit ${EXIT_NO_LIST}
fi

## If no list, there must be a title
if [[ -z "${LIST}" ]] && [[ -z "${DOC}" ]]
then
    echo "${0}: You must provida either a document title or a list" >&2
    exit ${EXIT_NO_ARGS}
fi


### OPTIONS
##  Dump options
OPTS_DUMP="-dump 1 -dump-charset ${DOC_CHARSET} -dump-width ${DOC_WIDTH}"

##  Refereneces and numbers
if [[ ${B_REFERENCES} -eq 0 ]]
then
    OPTS_REFS="${OPTS_REFS} -no-references"
fi
if [[ ${B_NUMBERS} -eq 0 ]]
then
    OPTS_REFS="${OPTS_REFS} -no-numbering"
fi


### DO THE STUFF
## If there is list, use it, else use last argument
if [[ -z ${LIST} ]]
then
    if [[ ${VERBOSE} -ne 0 ]]; then
        echo -n " :: Retrieving ${DOC}..."
    fi

    ${APPLICATION} ${OPTS_DUMP} ${OPTS_REFS} "${URI_SKEL}${DOC}" > "${DOC}"

    if [[ ${VERBOSE} -ne 0 ]]; then
        echo -e "\r :: Retrieved ${DOC}    "
	echo "  Done"
    fi
else
    unset DOC
    for DOC in $(cat ${LIST})
    do
        if [[ ${VERBOSE} -ne 0 ]]; then
            echo -n " :: Retrieving ${DOC}..."
        fi

        ${APPLICATION} ${OPTS_DUMP} ${OPTS_REFS} "${URI_SKEL}${DOC}" > "${DOC}"

        if [[ ${VERBOSE} -ne 0 ]]; then
            echo -e "\r :: Retrieved ${DOC}    "
        fi
    done

    if [[ ${VERBOSE} -ne 0 ]]; then
        echo "  Done"
    fi
fi

## Optional, but nice (pure formalism)
exit ${EXIT_SUCCESS}

