#!/usr/bin/env bash
set -euxo pipefail

input=$1
output="${input%%.*}_transcode.mp4"
bitrate=5

ffmpeg \
    -hwaccel cuda \
    -hwaccel_output_format cuda \
    -preset medium \
    -bufsize "$(expr $bitrate \* 2)" \
    -bf 3 \
    -b_ref_mode 2 \
    -temporal-aq 1 \
    -rc-lookahead 20 \
    -vsync 0 \
    -i "$input" "${@:2}" \
    -b:v "$bitrate" \
    -profile:v high \
    -c:v h264_nvenc \
    -c:a copy \
    "$output"
