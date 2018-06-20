#! 
source $HOME/colors.sh
NOCOLOR="\033[0m"

printf "\n\n\t\t\b\b ${Reverse}${Bright}${Yellow}Check Linux kernel version in repo ...wait ...press CTRL-C to end ${NOCOLOR}....\n\n"

(nix-env -qaP linux)&

$HOME/spinner2.sh

trap "CTRL-C" EXIT
