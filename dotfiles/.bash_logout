#!/bin/bash

# Check how many sessions are still logged in
if [[ "$(who | grep "$USER" | wc -l)" -le "1" ]]; then
    #echo "$(date +%F@%T) - SSH-AGENT: Agent will be stopped"
    # Remove all keys from the ssh-agent
    ssh-add -D >/dev/null
    # Kill the ssh-agent
    eval $(ssh-agent -k)
    # remove the file with the ssh-agent environment variables
    rm -f ~/.ssh/ssh-agent
else
    #echo "$(date +%F@%T) - SSH-AGENT: Still sessions logged in"
fi