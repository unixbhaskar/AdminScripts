#!/bin/bash

DOMAIN=slightlysauced.com
USERNAME=contact

sa-learn --spam /home/vmail/${DOMAIN}/${USERNAME}/Maildir/.spam/cur/* && rm -f /home/vmail/${DOMAIN}/${USERNAME}/Maildir/.spam/cur/*
