#!/bin/bash
for i in *.mp4
do
ffmpeg -i "$i" -ab 128k "${i%mp4}mp3"
done
