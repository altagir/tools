#!/bin/bash

################################################################################
### SCRIPT_DIR is the location the script
SCRIPT_DIR="`dirname \"$0\"`"                 # relative
SCRIPT_DIR="`( cd \"$SCRIPT_DIR\" && pwd )`"  # absolutized and normalized
if [ -z "$SCRIPT_DIR" ] ; then
	# error; for some reason, the path is not accessible
	# to the script (e.g. permissions re-evaled after suid)
	exit 1  # fail
fi

source $SCRIPT_DIR/FUNCTIONS


################################################################################

usage()
{
cat << EOF
usage: $0 COIN [0|1:reboot] 

This script change current money and restart
EOF
}


################################################################################

cd $MINER_PATH

settings_load

CURRENTLY_MINING=$LAST_COIN_MINED
printf "Currently mining : ${BOLD}$CURRENTLY_MINING${NC}\n"

################################################################################
# Parse parameters

COIN_TO_MINE=""

if [ "$1" = "" ]; then
	COIN_TO_MINE=$1
fi


 
if [ "$COIN_TO_MINE" = "" ]; then
	display_coins
	read ans
	
	if [ "$ans" = "" ]; then
		COIN_TO_MINE=$LAST_COIN_MINED
		printf "$LAST_COIN_MINED\n\n"
	else
		COIN_TO_MINE=${!MINERS[$ans]:0:1}
		echo ""
	fi
    
    LAST_COIN_MINED=$COIN_TO_MINE
fi



saveCoin $COIN_TO_MINE

if [ "$2" = "1" ]; then
	sudo reboot
	exit 0
fi

systemctl is-active --quiet mining && sudo service mining restart && exit 0
$SCRIPT_DIR/mine -l

