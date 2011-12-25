#!/bin/bash
#
# flv2mp4.sh
#
# OVERVIEW
#  Converts FLV video to MP4 using ffmpeg
#
# DEPENDENCIES
#  ffmpeg, file, basename
#

## Binaries
CONVERTER_BIN="/usr/bin/ffmpeg"
FILE_BIN="/usr/bin/file"

VERBOSITY_LEVEL=1


function show_help
{
    echo "Usage: $(basename ${0}) -i <input_file.flv> [-o <output_file.mp4>] [-v] [-h]"
    echo "   -i <input_file>     Sets the input file (FLV)"
    echo "   -o <output_file>    Sets output file (MP4)"
    echo "   -v <number>         Sets verbosity level (see 'man $(basename $CONVERTER_BIN)')"
    echo "   -h                  Displays this help"
    echo ""
    echo "If there is no output file, it will be created with the same name"
    echo "of the input file and extension MP4"
    echo ""
}


while getopts "hv:i:o:" OPTION
do
    case ${OPTION} in
        h)
        show_help
        exit 0
        ;;
        v)
        VERBOSITY_LEVEL=${OPTARG}
        ;;
        i)
        IN_FILE=${OPTARG}
        ;;
        o)
        OUT_FILE=${OPTARG}
        ;;
        *)
        show_help
        exit 1
    esac
done


## Check for input file
if [[ -z ${IN_FILE} ]]
then
    echo "ERROR. Need an input file" >&2
    show_help
    exit 1
fi

## Set output file if wasn't specified
if [[ -z ${OUT_FILE} ]]
then
    OUT_FILE="$(basename ${IN_FILE} .flv).mp4"
fi


## Check if file is really FLV
if [[ ! $(${FILE_BIN} ${IN_FILE} | grep -i "Flash Video") ]]
then
    echo "'${IN_FILE}' is not in FLV format" >&2
    exit 1
fi


## Converting FLV to MP4
${CONVERTER_BIN} -i ${IN_FILE} -v ${VERBOSITY_LEVEL} -vcodec mpeg4 ${OUT_FILE}


## Optional, but nice
exit 0

