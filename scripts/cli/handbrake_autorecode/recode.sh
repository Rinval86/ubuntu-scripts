#!/bin/bash

#######################################################################
##                                                                   ##
##     Written by: Rinval86                                          ##
##     Created = April 7, 2023                                       ##
##     Modified = April 7, 2023                                      ##
##     Version 1.0                                                   ##
##     https://github.com/Rinval86/ubuntu-scripts                    ##
##     Creative Commons Zero License                                 ##
##                                                                   ##
#######################################################################

##     This script was written to perform auto recodeing of video files to a handbrake preset.
##     This script was written on Ubuntu 20.04 but may be compatible with other versions.
##     WARNING: If this script is interupted, the owner of the files will be left as root:root.

## Variables that can be edited.
##**Warning directories listed below will be checked and if missing they will be created.**
SOURCE_DIR="./recode"
OUTPUT_DIR="./complete"
ORIGINAL_DIR="./original"
LOG_DIR="./log"
PRESET="Roku 1080p30 Surround"
RETAIN=10
SHARE_GROUP="debian-transmission"
FORCE_X265=true
## Warning: auto cleanup works on last modified date. If you have not modified the video file, it would use the creation date which could prematurely delete the file.
AUTO_CLEANUP_ORIGINAL=false

##**DO NOT EDIT THESE**
TODAY=`date +%m-%d-%y-%T`
HOST=`hostname`
LOG_FILE="$LOG_DIR/recode_$HOST-$TODAY.log"

## Functions
log() {
	OUTTEXT=$(date +"%D %H:%M:%S")" $1"
	echo -e "$OUTTEXT"
}

## Execution Code

##Require sudo
executioner=$(whoami)

if [ "$executioner" != "root" ]; then
	log "This scriipt must be executed with sudo or root."
	exit 1
fi

## Make Log directory and file
## Detect and build the log if missing and set permissions.

log "PRESTART - Creating log file"
if [ ! -d "$LOG_DIR" ]
then
	mkdir -p "$LOG_DIR"
	chmod 770 "$LOG_DIR"
else
	chmod 770 "$LOG_DIR"
fi

if [ ! -e "$LOG_FILE" ]
then
	touch "$LOG_FILE"
	chmod 664 "$LOG_FILE"
else
	chmod 664 "$LOG_FILE"
fi

## Co-write Console and log file
exec > >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)
log "PRESTART - log file created"

## Checking for missing directories and adding with permissions.
if [ ! -d "$SOURCE_DIR" ]
then
	mkdir -p "$SOURCE_DIR"
	chmod 770 "$SOURCE_DIR"
else
	chmod 770 "$SOURCE_DIR"
fi

if [ ! -d "$OUTPUT_DIR" ]
then
	mkdir -p "$OUTPUT_DIR"
	chmod 770 "$OUTPUT_DIR"
else
	chmod 770 "$OUTPUT_DIR"
fi

if [ ! -d "$ORIGINAL_DIR" ]
then
	mkdir -p "$ORIGINAL_DIR"
	chmod 770 "$ORIGINAL_DIR"
else
	chmod 770 "$ORIGINAL_DIR"
fi

chown -R root:"$SHARE_GROUP" .

## Setting directory and files
SOURCE_FILES=$(ls "$SOURCE_DIR")
SOURCE_FILE_NAME=$(ls  "$SOURCE_DIR" | sort -n | head -1)
SOURCE_FILE_NAME_SHORT="${SOURCE_FILE_NAME%.*}"

## checking for HandBrakeCLI
if dpkg-query -l handbrake-cli > /dev/null
then
	log "HandBrakeCLI is installed."
else
	log "HandBrakeCLI is not installed. Attempting to install handbrake-cli."
	apt update
	apt install -y handbrake-cli
	log "install attempt complete rechecking."
	if dpkg-query -l handbrake-cli > /dev/null
	then
		log "HandBrakeCLI was successfully installed."
	fi
		log "Failed to install handbrake-cli. Please check and manually install."
		exit 1
fi

## Cleaning up old backup files
log "Cleaning up log files oder than $RETAIN days in $LOG_DIR"
find "$LOG_DIR" -type f -mtime +$RETAIN -delete -print
if [ $AUTO_CLEANUP_ORIGINAL = true ]
then
	log "Cleaning up original video files older than $RETAIN days in $ORIGINAL_DIR"
	find "$ORIGINAL_DIR" -type f -mtime +$RETAIN -delete -print
fi

## Check processes and execute recode
if pgrep -x "HandBrakeCLI" > /dev/null
then
    log 'Handbrake is already running.'
	log 'If this is unexpected please check processes and end HandbrakeCLI if it is hung.'
	log 'You can use the "top" command to see if HandBrakeCLI is doing anything.'
	log 'If handbrake is hung you can use "ps -ef | grep HandBrakeCLI" to get the HandBrakeCLI process id to kill.'
	log "Exiting Script"
	exit 0
else
    log "Handbrake is not running. Starting checks for files to recode."
	if [ "$SOURCE_FILES" > /dev/null ]
	then
		log "Found file to recode, recoding $SOURCE_FILE_NAME using handbrake preset $PRESET"
		if [ $FORCE_X265 = true ]
		then
			nice HandBrakeCLI -i "$SOURCE_DIR"/"$SOURCE_FILE_NAME" -o "$OUTPUT_DIR"/"$SOURCE_FILE_NAME_SHORT".mp4 --markers --preset "$PRESET" --encoder x265 --native-language eng
		else
			nice HandBrakeCLI -i "$SOURCE_DIR"/"$SOURCE_FILE_NAME" -o "$OUTPUT_DIR"/"$SOURCE_FILE_NAME_SHORT".mp4 --markers --preset "$PRESET" --native-language eng
		fi
		log "Recode complete for file $SOURCE_FILE_NAME."
		log "Completed recode file can be found at $OUTPUT_DIR/$SOURCE_FILE_NAME_SHORT.mp4"
		log "Moving original source file to $ORIGINAL_DIR"
		mv "$SOURCE_DIR"/"$SOURCE_FILE_NAME" "$ORIGINAL_DIR"/"$SOURCE_FILE_NAME"
		chown -R root:"$SHARE_GROUP" .
		log "Exiting Script"
		exit 0
	else
		log "No Files Found. Nothing to do."
		log "Exiting Script"
		exit 0
	fi
fi
