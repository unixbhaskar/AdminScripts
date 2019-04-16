#!/usr/bin/env bash

pid=$(ps aux | sort -k 4 -r | head -n2 | gawk '{ print  $2 , $11 }' | tr -d "PID" | tr -d "COMMAND")

echo "MemHog:" $pid 