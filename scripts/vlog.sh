#!/bin/bash
#######################################################################
# PURPOSE:
#   Record video logs with the webcam (MPG format)
#
#
# USAGE:
#  Usage: vlog.sh [<options>]
#    -a <adev>   Sets audio device (default: '/dev/dsp')
#    -d <vdev>   Sets video device (default: '/dev/video0')
#    -A <afmt>   Audio format (default: 'oss')
#    -V <vfmt>   Video format (default: 'video4linux2')
#    -W <width>  Video width (default: '640')
#    -H <height> Video height (default: '480')
#    -x <opts>   Extra ffmpeg options
#    -O <dir>    Outputs to the given dir (default: '~/.vlog/')
#    -o <file>   Outputs to the given filename (default: '%Y%m%d%H%M%S.mpg')
#    -v <level>  Verbosity level (default: 0)
#    -m          Set mixer capture devices propertly
#    -r          Reset mixer capture device at the end of the record
#    -h          Displays this extremely useful help"
#
#    When recording press 'q' to stop
#
#
# EXAMPLES:
#  - Start by default
#    $ vlog.sh
#
#  - Setting capture device in mixer (-m)
#    $ vlog.sh -m
#
#  - Changing video device
#    $ vlog.sh -d /dev/video1
#
#
# DEPENDENCIES:
#   - ffmpeg : to do the stuff! B-)
#
#   - amixer : in order to use -m | -r options (set/unset mic. in
#              mixer)
#
#   - coreutils (date): ;-D
#
#   
# NOTES:
#  - You can change default devices in this file or specify another
#    options in the "*_mixer" functions such as your default capture
#    device.
#
#  - The default video size (WxH) is set to 640x480, it depends on
#    the device and it can be changed too.
#
#  - By default, a folder called '~/.vlog/' will be created
#    and every video will be stored there.
#
#
# BUGS:
#  - Does not work if there is a browser with a Flash video loaded
#    like youtube (damn Flash!). In this case the audio device is
#    busy, but instead of returning an error, ffmpeg says nothing and
#    records nothing too --this happens with some soundcards (like
#    mine)-- B'-(
#
#
# TODO:
#  - Extra options addition (-x <options>) was not tested... yet
#
#  - Restore mic. option (-r) values actually does not work. Just
#    mutes it.
#
#
# SCRIPT INFO.:
#   - Author.......... Pferor <pferor [AT] gmail [DOT] com>
#
#   - Last update..... Sat Dec  5 23:05:13 UTC 2009
#
#   - Last revision... Sun Mar 28 18:57:45 UTC 2010
#
#   - Version......... 0.2
#######################################################################


## Script info ########################################################
SELF_APPNAME="VLOG"
SELF_VERSION="0.2"


## Binary files #######################################################
APP_BIN="/usr/bin/ffmpeg" # Needed for recording using the webcam
APP_MIX="/usr/bin/amixer" # Needed for -m and -r options only


## Default options ####################################################
AUDIO_DEVICE="/dev/dsp"
VIDEO_DEVICE="/dev/video0"
VIDEO_WIDTH=640
VIDEO_HEIGHT=480
AUDIO_FORMAT="oss"
VIDEO_FORMAT="video4linux2"
OUTPUT_DIR="${HOME}/.vlog/"
OUTPUT_FILE=$(date +"%Y%m%d%H%M%S")".mpg"
MIXER_SET=0
MIXER_RESET=0
VERBOSITY_LEVEL=0
EXTRA_OPTS=""


## Displays help ######################################################
function show_usage
{
    echo "${SELF_APPNAME} -- Version ${SELF_VERSION}"
    echo "Usage: ${0} [<options>]"
    echo "  -a <adev>   Sets audio device (default: '${AUDIO_DEVICE}')"
    echo "  -d <vdev>   Sets video device (default: '${VIDEO_DEVICE}')"
    echo "  -A <afmt>   Audio format (default: '${AUDIO_FORMAT}')"
    echo "  -V <vfmt>   Video format (default: '${VIDEO_FORMAT}')"
    echo "  -W <width>  Video width (default: ${VIDEO_WIDTH})"
    echo "  -H <height> Video height (default: ${VIDEO_HEIGHT})"
    echo "  -x <opts>   Extra '${APP_BIN}' options"
    echo "  -O <dir>    Outputs to the given dir (default: '${OUTPUT_DIR}')"
    echo "  -o <file>   Outputs to the given filename (default: '%Y%m%d%H%M%S.mpg')"
    echo "  -v <level>  Verbosity level (default: ${VERBOSITY_LEVEL})"
    echo "  -m          Set mixer capture devices propertly"
    echo "  -r          Reset mixer capture device at the end of the record"
    echo "  -h          Displays this extremely useful help"
    echo ""
    echo " When recording press 'q' to stop"
    echo ""
}


## Set mixer settings #################################################

## Store mixer
##  ${1}: verbosity level (0: quiet, 1: verbose)
function mixer_set
{
    ## STORE ------------------------------------
    ## Sets the capture
    if [[ -x ${APP_MIX} ]]
    then
        ${APP_MIX} -c 0 sset "Capture" 100% unmute cap
        ${APP_MIX} set "Input Source" "Front Mic"
    else
        ## Gives info if verbosity level != 0
        if [[ ${1} -ne 0 ]]
        then
            echo "${0}: '${APP_MIX}' not found. Cannot modify mixer settings" >&2
        fi
    fi
}

## Restore mixer
##  ${1}: verbosity level (0: quiet, 1: verbose)
function mixer_reset
{
    ## RESTORE ----------------------------------
    ## Mute again the mic (USB mic)
    if [[ -x ${APP_MIX} ]]
    then
        ${APP_MIX} -c 0 sset "Capture" 0% mute cap
    else
        ## Gives info if verbosity level != 0
        if [[ ${1} -ne 0 ]]
        then
            echo "${0}: '${APP_MIX}' not found. Cannot modify mixer settings" >&2
        fi
    fi
}



## Get options ########################################################
while getopts "ha:d:A:V:W:H:n:x:o:O:v:mr" OPTION
do
    case ${OPTION} in
        h)
            show_usage
            exit 0
            ;;
        a)
            AUDIO_DEVICE=${OPTARG}
            ;;
        d)
            VIDEO_DEVICE=${OPTARG}
            ;;
        W)
            VIDEO_WIDTH=${OPTARG}
            ;;
        H)
            VIDEO_HEIGHT=${OPTARG}
            ;;
        A)
            AUDIO_FORMAT=${OPTARG}
            ;;
        V)
            VIDEO_FORMAT=${OPTARG}
            ;;
        x)
            EXTRA_OPTS=${OPTARG}
            ;;
        o)
            OUTPUT_FILE=${OPTARG}
            ;;
        O)
            OUTPUT_DIR=${OPTARG}
            ;;
        v)
            VERBOSITY_LEVEL=${OPTARG}
            ;;
        m)
            MIXER_SET=1
            ;;
        r)
            MIXER_RESET=1
            ;;
        ?)
            show_usage
            exit 1
    esac
done


## Do the stuff #######################################################

## Create the output directory if does not exist
if [[ ! -d ${OUTPUT_DIR} ]]
then
    mkdir ${OUTPUT_DIR}
fi

## Set mixer capture devices
if [[ ${MIXER_SET} -ne 0 ]]
then
    mixer_set ${VERBOSITY_LEVEL}
fi

## Begin recording
${APP_BIN} -f ${AUDIO_FORMAT} -i ${AUDIO_DEVICE} \
    -f ${VIDEO_FORMAT} -s ${VIDEO_WIDTH}x${VIDEO_HEIGHT} -i ${VIDEO_DEVICE} \
    ${EXTRA_OPTS} -v ${VERBOSITY_LEVEL} ${OUTPUT_DIR}/${OUTPUT_FILE}


## Reset mixer capture devices (just mute it)
if [[ ${MIXER_RESET} -ne 0 ]]
then
    mixer_reset ${VERBOSITY_LEVEL}
fi


## Optional, but nice (pure formalism) ################################
exit 0

