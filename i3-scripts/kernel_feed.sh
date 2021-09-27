#!/bin/bash
~/.config/i3/feed.sh | tr -d "< />" | sed 's/title//g' | grep -v "^Latest" | dmenu -l 10
