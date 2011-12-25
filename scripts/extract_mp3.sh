#!/bin/bash
#
# Extracts mp3 audio from mp4 or flv


## ffmpeg extra options
ENCODER_OPTS="-v 0"


# Display help on screen
function show_help
{
    echo "Usage: ${0} <input_file>"
    echo "<input_file> *must* be .mp4 or .flv"
    echo ""
}


## If no arguments, no script
if [[ ${#} -eq 0 ]]
then
    show_help
    exit 1
fi


## Just formalism 
INPUT=${1}


## Set output filename and extacts audio
## using ffmpeg
if [[ ${1##*.} = "mp4" ]]
then
    OUTPUT="$(basename ${1} .mp4).mp3"
    ffmpeg ${ENCODER_OPTS} -i ${INPUT} -ab 128000 -ar 44100 -f mp3 ${OUTPUT}
elif [[ ${1##*.} = "flv" ]]
then
    OUTPUT="$(basename ${1} .flv).mp3"
    ffmpeg ${ENCODER_OPTS} -i ${INPUT} -vn -acodec copy ${OUTPUT}
else
    show_help
    exit 1
fi


## Exits successfully
exit 0

