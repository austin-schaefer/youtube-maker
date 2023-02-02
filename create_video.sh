#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

ffmpeg -f concat -i input.txt -i input.m4a -c:v libx264 -r 1 -pix_fmt yuv420p output.mp4
ffmpeg -i output.mp4 -t $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.m4a) output_trimmed.mp4