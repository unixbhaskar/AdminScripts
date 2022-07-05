#!/bin/bash -
#===============================================================================
#
#          FILE: mail_compose_send_by_emacs.sh
#
#         USAGE: ./mail_compose_send_by_emacs.sh
#
#   DESCRIPTION: opens new Emacs window with empty message and attaches files mentioned as script arguments
#
#       OPTIONS: Need to pass an argument if you want to attach a file.
#  REQUIREMENTS: The server/daemon should be in running condition/active
#          BUGS: ---
#         NOTES: Stolen from this web page: https://notmuchmail.org/notmuch-emacs/
#        AUTHOR: Bhaskar Chowdhury
#  ORGANIZATION:
#       CREATED: 06/01/2021 03:55
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

    attach_cmds=""
    while [ $# -gt 0 ]; do
        fullpath=$(readlink --canonicalize "$1")
        attach_cmds="$attach_cmds (mml-attach-file \"$fullpath\")"
        shift
    done
    emacsclient -a '' -c -e "(progn (compose-mail) $attach_cmds)"
