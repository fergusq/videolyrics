#!/bin/bash

MIDI=$1
MUSIC=$2
OUTPUT=$3

rm /tmp/video/*
röda videolyrics.röd "$MIDI" 24 /tmp/video/frame# 2>/dev/null
ffmpeg -framerate 24 -start_number 1 -i /tmp/video/frame%d.png -i "$MUSIC" "$OUTPUT"
