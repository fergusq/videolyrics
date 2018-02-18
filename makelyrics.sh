#!/bin/bash

TITLE=$1
MIDI=$2
MUSIC=$3
OUTPUT=$4
TEMP=`mktemp -d`

röda -D -s videolyrics.röd "$MIDI" "$TITLE" 14 "$TEMP/frame#" 2>/dev/null
ffmpeg -f concat -safe 0 -i "$TEMP/frame.txt" -i "$MUSIC" "$OUTPUT"
rm -r "$TEMP"
