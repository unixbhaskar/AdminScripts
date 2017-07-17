#!/bin/bash

youtube_url=$1

youtube-dl --extract-audio --audio-format mp3 -l $youtube_url 

#function youtube_url {
# If no arguments, print usage statement & exit from function
# [[ -n "$1" ]] || ( echo "Usage: youtube_video_to_mp3_conv.sh youtube_url "; exit 0 ; )
# Else, continue and print the arguments
# echo "youtube_url=$1"
#}
