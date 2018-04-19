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

PID=$(ps -ef | awk '/[m]iner/{print $2}' | tail -n1 )
if [ "$PID" = "" ]; then
	printf "${BOLD}NO mining detected !!${NC}\n"
else
	printf "Mining ${BOLD}$LAST_COIN_MINED${NC}\t${BOLD}$(ps -o etime= -p $PID)${NC}\ttotal: ${BOLD}$time${NC},\t(${BOLD}$LAST_COIN_NB${NC} restarts, ${BOLD}$NB_GPUS${NC} GPUs)\n"
fi
