#!/bin/bash
#
# Pferor <pferor [AT] gmail [DOT] com>
# Wed Apr  8 10:12:43 UTC 2009
#
# PURPOSE
#  Download tracks from QuestStudios.com using wget
#
# REQUIREMENTS
#  * wget
#
# USAGE
#  A soundtrack URI is like this:
#    http://queststudios.com/2010/digital/Hoyle3/*.ogg
#
#  To download the soundtrack formed by:
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_0.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_1.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_2.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_3.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_4.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_5.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_6.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_7.ogg
#    http://queststudios.com/2010/digital/Hoyle3/hoyle3_8.ogg
#
#  You must form the URI using the options, i.e.:
#    $ qsdown.sh \
#      -u "http://queststudios.com/2010/digital/" \
#      -F Hoyle3      # remote folder
#      -T "hoyle3_" \ # track basename
#      -p "" \        # track prefix
#      -s "" \        # track suffix 1
#      -S "" \        # track suffix 2
#      -f 0           # track from
#      -t 8           # track to
#      -m ogg         # format
#
#   Fortunately, the Quest Studios URI is set by default, as well as
#   other options. In this example it's enough with:
#    $ qsdown.sh -F Hoyle3 -T "hoyle3_" -f 0 -t 8
#
# EXAMPLES
#   * Downloads Space Quest I soundtrack
#       $ qsdown -F sq1cd -p SQ1 -t 24 -z
#
#   * Downloads Police Quest 1 soundtrack
#       $ qsdown -F pq1digital -m mp3 -T pq1\( -S\) -t 26
#

VERSION="0.2" # current version
WGETOPTS=""   # wget extra options


# check needed files
if [[ -x /bin/wget ]]
then
    echo "Error: /bin/wget not found" >&2
    exit 1
fi


# Initial values
PREFIX=""
SUFFIX=""
POST_SUFFIX=""
FOLDER=""
ITEM_FROM=1
ITEM_TO=30
ZEROS_FILL=0
EXTENSION="ogg"
TRACK_NAME="Track"
#BASE_URI="http://66.49.226.244/digital/"   # old URI
BASE_URI="http://queststudios.com/2010/digital/"


## FUNCTIONS #########################################################
## Show usage
function show_usage
{
    echo "Usage $(basename ${0}) <options>"
    echo "  Range:"
    echo "   -f <from>        Sets start track (default: ${ITEM_FROM})"
    echo "   -t <to>          Sets end track (default: ${ITEM_TO})"
    echo ""
    echo "  Files:"
    echo "   -F <folder>      Sets folder name"
    echo "   -p <prefix>      Uses a prefix to filename"
    echo "   -s <suffix>      Uses a suffix to filename before track number"
    echo "   -S <post suffix> Uses a suffix to filename after track number"
    echo "   -T <track name>  Track name (default: '${TRACK_NAME}')"
    echo ""
    echo "  Misc.:"
    echo "   -u <base URI>    Sets base URI (default: '${BASE_URI}')"
    echo "   -m <format>      Sets media format (default: '${EXTENSION}')"
    echo "   -z               Preppends 0 to track number if it's less than 10"
    echo ""
    echo "  About:"
    echo "   -v               Displays version"
    echo "   -h               Displays this help"
}

## Show version
function show_version
{
    echo -e "$(basename ${0}) - version: ${VERSION}"
}


## OPTIONS ###########################################################
while getopts "hzp:s:S:F:T:f:t:m:u:v" OPTION
do
    case $OPTION in
        h)
            show_usage
            exit 0
            ;;
        z)
            ZEROS_FILL=1
            ;;
        p)
            PREFIX=$OPTARG
            ;;
        s)
            SUFFIX=$OPTARG
            ;;
        S)
            POST_SUFFIX=$OPTARG
            ;;
        F)
            FOLDER=$OPTARG
            ;;
        T)
            TRACK_NAME=$OPTARG
            ;;
        f)
            ITEM_FROM=$OPTARG
            ;;
        t)
            ITEM_TO=$OPTARG
            ;;
        m)
            EXTENSION=$OPTARG
            ;;
        u)
            BASE_URI=$OPTARG
            ;;
        v)
            show_version
            exit 0
            ;;
        ?)
            show_usage
            exit 1
            ;;
    esac
done


## VALIDATION ########################################################
## Folder must be entered
if [[ -z ${FOLDER} ]]
then
    show_usage
    exit 1
fi


## DOWNLOAD ##########################################################
for ((i=${ITEM_FROM}; i<=${ITEM_TO}; i++))
do
    if [[ ${ZEROS_FILL} -eq 1 ]]
    then
        if [[ ${i} -lt 10 ]]
        then
            PRE="0"
        else
            PRE=""
        fi
    fi

    wget ${WGETOPTS} ${BASE_URI}${FOLDER}/${PREFIX}${TRACK_NAME}${PRE}${SUFFIX}${i}${POST_SUFFIX}.${EXTENSION};
done


## Exit successfully
exit 0

