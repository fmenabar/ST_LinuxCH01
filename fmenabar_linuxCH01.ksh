#!/bin/ksh


##########################################################
# Name: fmenabar_linuxCH01
# Desc: Escript developed to solve the chanlleng 01 of skill
#       transfomration for linux.
# Author: Francisco javier Mena Barraza
# date: 07052025_1030
# Versión: 1.0
###########################################################

# Global variables

#Secure file path
sPath=""

#Number of session opened by root user
nRootS=0

#Target Server
tServer=""


# Function: connectServer
# Description: Function to connect specific server and get
#              "/var/log/secure" log.
# Param $1: targetServer

connectServer(){
	tServer=$1
	echo "Trying to connect to server: $1"
	scp root@"$1:/var/log/secure" .
	echo "Connection done!"

	sPath=$(pwd)
	echo "The file was stored in: $sPath"
}


# Function: checkRootCon
# Description: Function to count the number of root conection
#              in secure log file.
# Param $1: Path of secure file
checkRootCon(){
	echo "Counting root sessions"
	nRootS=$(grep "session opened for user root" $1 | wc -l)
	echo "Root session count done!"
}

# Function: summary
# Description: Function to generate a resume about the activies.
# Param None

summary(){
	echo "====================================="
	echo " Summary about the activities"
	echo "====================================="
	echo " Target Server:  $tServer"
	echo " Secure local path: $sPath/secure" 
	echo " Number of root sessions: $nRootS"
	echo " ===================================="
	
}


# Function: main
# Description: Function to do full execution script
# Param None

main(){
	connectServer "10.89.1.58"
	checkRootCon "$sPath/secure"
	summary
}



#Script start point"
main

