#!/usr/bin/env bash

mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

echo "Mem:$mem"
