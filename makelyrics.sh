#!/bin/bash

TITLE=$1
MIDI=$2
MUSIC=$3
OUTPUT=$4
TEMP=`mktemp -d`

röda videolyrics.röd "$MIDI" "$TITLE" 24 "$TEMP/frame#" 2>/dev/null
ffmpeg -framerate 24 -start_number 1 -i "$TEMP/frame%d.png" -i "$MUSIC" "$OUTPUT"
rm -r "$TEMP"
