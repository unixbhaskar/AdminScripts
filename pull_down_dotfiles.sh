#!/bin/bash -
#===============================================================================
#
#          FILE: pull_down_dotfiles.sh
#
#         USAGE: ./pull_down_dotfiles.sh
#
#   DESCRIPTION: Get my settings from GITHUB on a fresh installed Linux.
#
#       OPTIONS: ---
#  REQUIREMENTS:  git,working internet
#          BUGS: ---
#         NOTES: Should be run on HOME directory
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 07/16/2022 18:15
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error


pull_down_my_settings_from_github() {

	             echo Getting the dotfiles from GitHub

	                git clone --recurse-submodules --remote-submodules git@github.com:unixbhaskar/dotfiles.git
			cp -v dotfiles/* $HOME
}
pull_down_my_settings_from_github
