#!/bin/bash
#
# Moves renaming the files on the fly to an numeric ordered pattern
#

VERSION=0.1
EXTENSION=""
PREFIX=""
SUFFIX=""
START_NO=""
ADDITOR=""
INTERACTIVE=0
VERBOSE=0
TEST=0


## Functions
function show_help
{
    echo "$(basename ${0}) [-h]"
    echo "$(basename ${0}) [-V]"
    echo "$(basename ${0}) [-t] [-i] [-V] [-p <prefix>] [-s <suffix>] -n <start number> -a <addition>"
    echo ""
    echo "  -p <prefix>        String before numbers"
    echo "  -s <suffix>        String after the numbers (including extension)"
    echo "  -n <start number>  Number from which the renaming process begins"
    echo "  -a <addition>      Additor (can be negative)"
    echo "  -i                 Interactive mode (see 'man mv')"
    echo "  -v                 Verbose mode"
    echo "  -t                 Test mode (verbose will be activated)"
    echo "  -V                 Displays version"
    echo "  -h                 Displays this help"
    echo ""
}


function show_version
{
    echo "$(basename ${0}) -- version: ${VERSION}"
}


## Get options
while getopts "hVvtis:p:n:e:a:" OPTION
do
    case ${OPTION} in
        h)
        show_help
        exit 0
        ;;
        V)
        show_version
        exit 0
        ;;
        v)
        VERBOSE=1
        ;;
        t)
        TEST=1
        VERBOSE=1
        ;;
        a)
        ADDITOR=${OPTARG}
        ;;
        n)
        START_NO=${OPTARG}
        ;;
        p)
        PREFIX=${OPTARG}
        ;;
        s)
        SUFFIX=${OPTARG}
        ;;
        i)
        INTERACTIVE=1
        ;;
        ?)
        show_help
        exit 1
        ;;
    esac
done


## Makes sure the start number argument has been entered
if [[ -z ${START_NO} ]] || [[ -z ${ADDITOR} ]]
then
    show_help
    exit 1
fi



## Set interactive flag
if [[ ${INTERACTIVE} -eq 1 ]]
then
    MV_OPTS="--interactive"
fi


## Do the stuff
COUNTER=${START_NO}
for FILE in $(ls ${PREFIX}*${SUFFIX})
do
    OLD_FILENAME=${PREFIX}${COUNTER}${SUFFIX}
    NEW_NUMBER=$(printf %03d $((COUNTER+ADDITOR)))
    NEW_FILENAME=${PREFIX}${NEW_NUMBER}${SUFFIX}

    if [[ ${VERBOSE} -eq 1 ]]
    then
        if [[ -f ${OLD_FILENAME} ]]
        then
            echo "${OLD_FILENAME} -> ${NEW_FILENAME}"
        fi
    fi


    ## rename
    if [[ ${TEST} -ne 1 ]]
    then
        if [[ -f ${OLD_FILENAME} ]]
        then
            mv ${MV_OPTS} ${OLD_FILENAME} ${NEW_FILENAME}
        else
            echo "Error: ${OLD_FILENAME} not found!" >&2
        fi
    fi

    COUNTER=$((COUNTER+1))
done


## Optional but nice
exit 0

