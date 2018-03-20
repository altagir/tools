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

cd $MINER_PATH

settings_load

if [ "$1" = "-nofancy" ]; then
	BOLD=""
	BLUE=""
	RED=""
	NB=""
	NC=""
fi

CURRENTLY_MINING=$LAST_COIN_MINED

PID=$(ps -ef | awk '/[m]iner/{print $2}')

if [ "$PID" = "" ]; then
	UPTIME="-1"
else
	UPTIME=$(echo $(ps -o etime= -p $PID) | xargs)
fi

printf "Currently mining : ${BOLD}$CURRENTLY_MINING${NC}\ton ${BOLD}$NB_GPUS${NC} GPUs\n"
printf "Mining uptime    : ${BOLD}$UPTIME${NC}\n"
printf "System uptime    :${BOLD}$(uptime)${NC}\n\n"


printf "#\tStatut\tUsage\tTemp\t Power / Power limit\tFan\t Name\n"
echo "---------------------------------------------------------------------------------------"

for GPU in $(seq 0 $((NB_GPUS-1))); do
	GPUINFO=`nvidia-smi -i $GPU --query-gpu=utilization.gpu,temperature.gpu,power.draw,power.limit,fan.speed,name --format=csv,noheader`
	UTIL=`nvidia-smi -i $GPU --query-gpu=utilization.gpu --format=csv,noheader | cut -f1 -d" "`  

	UTIL=$(echo $GPUINFO | cut -f1 -d " ")
	TEMP=$(echo $GPUINFO | cut -f2 -d ",")
	POWER=$(echo $GPUINFO | cut -f3 -d "," | cut -f2 -d " ")
	POWER_SET=$(echo $GPUINFO | cut -f4 -d ",")
	FAN=$(echo $GPUINFO | cut -f8 -d " ")
	NAME=$(echo $GPUINFO | cut -f6 -d ",")


	if (($UTIL < $IDLE_GPU)); then
		printf "$GPU\t${RED}IDLE${NC}"
	else
		printf "$GPU\t${BOLD}OK${NC}"
	fi

	printf "\t$UTIL%%\t$TEMP C\t$POWER /$POWER_SET\t$FAN%%\t$NAME\n"

done
