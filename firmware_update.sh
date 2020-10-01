#!/usr/bin/env bash

printf "Updating firmware of the system ...wait ... \n\n"

 fwupdmgr get-devices

#This will display all devices detected by fwupd.

 fwupdmgr refresh

#This will download the latest metadata from LVFS.

 fwupdmgr get-updates

#If updates are available for any devices on the system, they'll be displayed.

 fwupdmgr update

#To report the status of an update run:

  fwupdmgr report-history

# To clear the local history of updates:

# fwupdmgr clear-history
