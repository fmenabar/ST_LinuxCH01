#!/bin/ksh


##########################################################
# Name: fmenabar_linuxCH01
# Desc: Escript developed to solve the chanlleng 01 of skill
#       transfomration for linux.
# Author: Francisco javier Mena Barraza
# date: 07052025_1030
#       09052025_0956
# Versión: 1.1
###########################################################

# Global variables

#Secure file path
sPath=""

#Number of session opened by root user
nRootS=0

#Target Server
tServer=""

#Global labels
info="[INFO] $(date +%F_%H-%M-%S) =>"
err="[ERROR] $(date +%F_%H-%M-%S) =>"
com="[COMMAND] $(date +%F_%H-%M-%S) =>"

# Function: connectServer
# Description: Function to connect specific server and get
#              "/var/log/secure" log.
# Param $1: targetServer

connectServer(){
	tServer=$1
	echo "$info Trying to connect to server: $1"
	scp root@"$1:/var/log/secure" .
	if [ $? -eq 1 ];
	then
		echo "$err File transfer failed"
		break
	else
		echo "$info Connection done!"
        	if [ ! -f $1 ];
		then
			sPath=$(pwd)
			echo "$info The file was stored in: $sPath"
			return 1
		else
			echo "$info Something went wrong, file unsuccess"
			return 0
		fi
	fi
}


# Function: checkRootCon
# Description: Function to count the number of root conection
#              in secure log file.
# Param $1: Path of secure file
checkRootCon(){
	echo "$info Counting root sessions"
	nRootS=($(awk -F"T" 'BEGIN{ITER=""; count=0} /session opened for.*.user root/{if( $1~/^[0-9]{4}-/){if( ITER == $1){count++}else{print ITER ":" count ; ITER=$1; count=1 }}} END{print ITER ":" count}' $1))
	echo "$info Root session count done!"
}

# Function: summary
# Description: Function to generate a resume about the activies.
# Param None

summary(){
	echo "$com summary"
	echo "====================================="
	echo " Summary about the activities"
	echo "====================================="
	echo " Target Server:  $tServer"
	echo " Secure local path: $sPath/secure" 
	echo " History of root sessions:" 
	for data in ${nRootS[@]};
	do
		echo "$data"
	done
	echo " ===================================="
	
}


# Function: main
# Description: Function to do full execution script
# Param None

main(){
	connectServer "10.89.1.58"
	if [ $? == 1 ];
	then
		checkRootCon "$sPath/secure"
		summary
	else
		echo "$err Exiting with errors"
	fi
}



#Script start point"
main

