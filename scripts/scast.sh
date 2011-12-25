#!/bin/bash
#
# Dependencies: recordmydesktop
#
# Selects a window and records it
#

echo "Select window"
WINDOW_ID=$(xwininfo | grep "Window id:" | cut -c22-30)

recordmydesktop --windowid ${WINDOW_ID} \
--channels 1 \
--freq 22050 \
--v_bitrate 2000000 \
--v_quality 63 \
--s_quality 10 \
--delay 5 \
--fps 20 \
--device plughw:0,0 \
--no-wm-check \
--buffer-size 65538 \
--quick-subsampling \
-o screencast.ogv

