#!/bin/bash

notmuch=$(command -v notmuch)

printf "\n Sit tight ...it might take some time .....\n"

# Dumping the existing databse as back

$notmuch dump --output=$HOME/database_dump.nm

# Take backup of the existing folder as precaution

mv -v ~/gmail-backup/.notmuch{,_$(date +'%F')}

# Running it for initializing the entire mailbox

$notmuch new

# Tagging it

$notmuch tag -inbox -unread '*'

# Restore back the previous state including tags

$notmuch restore --accumulate --input=$HOME/database_dump.nm

printf "\n Done..now check the database and delete the backup.\n"