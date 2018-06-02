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
	#read ans
	
	if [ "$ans" = "" ]; then
		exit 0
		#COIN_TO_MINE=$LAST_COIN_MINED
		#printf "$LAST_COIN_MINED\n\n"
	else
		COIN_TO_MINE=$ans	
		#COIN_TO_MINE=${!MINERS[$ans]:0:1}
		echo ""
	fi
    
    LAST_COIN_MINED=$COIN_TO_MINE
fi

VOID=$(sudo ls)

saveCoin $COIN_TO_MINE

if [ "$1" = "-r" ] || [ "$2" = "-r" ]; then
	sudo reboot
	exit 0
fi


# remove overclock

overclockLow() {
	if [ "$(readlink $SCRIPT_DIR/overclock)" = "overclockHigh" ]; then
		echo "UNDERCLOCKING"
		cd $SCRIPT_DIR; rm overclock; ln -s overclockLow overclock; overclock -m > /dev/null
	fi
}

overclockHigh() {
	if [ "$(readlink $SCRIPT_DIR/overclock)" != "overclockHigh" ]; then
		echo "..."
		cd $SCRIPT_DIR; rm overclock; ln -s overclockHigh overclock && sleep 15 && echo "OVERCLOCKING" && overclock -m > /dev/null
	fi
}



overclockLow

systemctl is-active --quiet mining && echo "restarting mining service..." && sudo service mining restart && overclockHigh; exit 0

echo "starting mining standalone..."
$SCRIPT_DIR/mine -l

overclockHigh


