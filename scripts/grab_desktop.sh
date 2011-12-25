#!/bin/sh
#
# Capture video of a linux desktop
#
# Requirements: ffmpeg
#
# Here is what the options mean:
#
#     * -f x11grab makes ffmpeg to set the input video format as
#       x11grab. The X11 framebuffer has a specific format it
#       presents data in and it makes ffmpeg to #decode it correctly.
#
#     * -s wxga makes ffmpeg to set the size of the video to wxga
#       which is shortcut for 1366x768. This is a strange resolution
#       to use, I'd just write -s 800x600.
#
#     * -r 25 sets the framerate of the video to 25fps.
#
#     * -i :0.0 sets the video input file to X11 display 0.0 at
#       localhost.
#
#     * -sameq preserves the quality of input stream. It's best to
#       preserve the quality and post-process it later.
#

if [[ ${#} -eq 1 ]]
then
    OUTPUT="${1}"
else
    OUTPUT="/tmp/out.mpg"
fi

ffmpeg -f x11grab -wxga -r 25 -i :0.0 -sameq ${OUTPUT}

