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

settings_load
source /etc/mining.conf
time=$(totalMiningTime)

PID=$(ps -ef | awk '/[m]iner/{print $2}')
if [ "$PID" = "" ]; then
	printf "${BOLD}NO mining detected !!${NC}\n"
else
	printf "Mining ${BOLD}$LAST_COIN_MINED${NC}\tlast run:${BOLD}$(ps -o etime= -p $PID)${NC}\tTotal: ${BOLD}$time${NC}\tRestart: ${BOLD}$LAST_COIN_NB${NC}\n"
fi
