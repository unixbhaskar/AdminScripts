#!/bin/bash

export MOZ_LOG=timestamp,rotate:200,nsHttp:5,nsSocketTransport:5,nsStreamPump:5,nsHostResolver:5
export MOZ_LOG_FILE=/tmp/log.txt-$(date)
cd /path/to/firefox
./firefox
