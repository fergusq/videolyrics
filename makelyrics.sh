#!/bin/bash

MIDI=$1
MUSIC=$2
OUTPUT=$3
TEMP=`mktemp -d`

röda videolyrics.röd "$MIDI" 24 "$TEMP/frame#" 2>/dev/null
ffmpeg -framerate 24 -start_number 1 -i "$TEMP/frame%d.png" -i "$MUSIC" "$OUTPUT"
rm -r "$TEMP"
