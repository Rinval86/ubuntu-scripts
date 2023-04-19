#!/bin/bash

#######################################################################
##                                                                   ##
##     Written by: Rinval86                                          ##
##     Created = March 23, 2023                                      ##
##     Modified = April 7, 2023                                      ##
##     Version 1.1                                                   ##
##     https://github.com/Rinval86/ubuntu-scripts                    ##
##     Creative Commons Zero License                                 ##
##                                                                   ##
#######################################################################

##     This script was written to perform a Tar or squash.fs backup of Ubuntu. 
##     This script was written on Ubuntu 20.04 but may be compatible with other versions.

#The default is squash.fs which can be both mounted as a sqhs file or extracted.
#This file must be run as root or sudo
#This file can be stored anywhere but needs execute permissions

### Example permissions changes and execution

### set read write and execute for owner, group, and everyone
### sudo chmod 777 /path/to/file/<backup.sh file>

### Execute the script
### sudo ./<backup.sh file> or sudo /path/to/file/<backup.sh file>

##### How to make this script a crontab job
##### **WARNING DO NOT DELETE ANYTHING FROM CRON OR CRONTAB UNLESS YOU KNOW WHAT YOUR DOING**

##### open crontab on ubuntu and select your favorite editor if you have not already
##### sudo crontab -e
####### nano is a notepad like editor. you can execute functions at the bottom by pressing ctrl + command character
####### VIM is the classic Linux and Unix text editor. For details on how to use vim check "man vi" or "man vim"
 
##### Crontab syntax "[minute] [hour] [day of month] [month] [day of week] [command]"
##### For example add the following line at the end of the file to backup every day at 3 AM server time.
##### 0 3 * * * /path/to/file/<backup.sh file>

##** DISCLAIMER: THIS SCRIPT WAS NOT TESTED WITH LOCATIONS WITH SPACES. **##

## Configurable Variables
#Backup Directory and File. Aka folder where you want the backups stored
BACKUP_DIR='/media/backup'

#Target location to be backed up.
TARGET_DIR='/'

#Log file details. Aka folder and file where you want the log file.
LOG_DIR='/var/log/backup'

#sub root Directories to exclude in squashfs seperated by a space and no slashes
SQFS_EXCLUDE='media dev run mnt proc sys tmp lost+found var/log swap.img'

#Directories to exclude in in tar file seperated by a space and be sure to use format "--exclude=<dir with slashes> 
#Be sure to 
TAR_EXCLUDE='--exclude=/media --exclude=/dev --exclude=/run --exclude=/mnt --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/lost+found --exclude=/var/log --exclude=/swap.img'

#Number of days to retain log files
RETAIN=30

#Use Squashfs or Tar. comment the one you dont want and comment the one you want to use. technically you could do both but be aware you are doubling the storage required for the backup.
BACK_TYPE1="sqfs"
#BACK_TYPE2="tar"

#numer of processors to use on creating the Squashfs. (there is a known bug that makes this not work on older versions)
PROCS=1


##** DO NOT CHANGE THESE VARIABLES UNLESS YOU KNOW WHAT YOUR DOING**
TODAY=`date +%m-%d-%y-%T`
HOST=`hostname`
BACKUP_FILE="$BACKUP_DIR/$HOST-$TODAY"
APT_LIST_FILE="$BACKUP_DIR/$HOST-apt_$TODAY.txt"
LOG_FILE="$LOG_DIR/backup_$HOST-$TODAY.log"
TAR_EXCLUDE_BAK="--exclude=$BACKUP_FILE.tar.gz"

## Functions
log() {
	OUTTEXT=$(date +"%D %H:%M:%S")" $1"
	echo -e "$OUTTEXT"
}

##Require sudo
executioner=$(whoami)

if [ "$executioner" != "root" ]; then
	log "This scriipt must be executed with sudo or root."
	exit 1
fi

## Make Log directory and file
#detect and build the log if missing and set permissions.

log "## PRESTART - Creating log file"
if [ ! -d $LOG_DIR ]
then
	mkdir -p $LOG_DIR
	chmod 770 $LOG_DIR
else
	chmod 770 $LOG_DIR
fi

if [ ! -e $LOG_FILE ]
then
	touch $LOG_FILE
	chmod 664 $LOG_FILE
else
	chmod 664 $LOG_FILE
fi

## Co-write Console and log file
exec > >(tee -a $LOG_FILE)
exec 2> >(tee -a $LOG_FILE >&2)
log "## PRESTART - log file created"

## Cleaning up old backup files
log "## Cleaning up files older than $RETAIN days in $BACKUP_DIR and $LOG_DIR"
find "$BACKUP_DIR" -type f -mtime +$RETAIN -delete -print
find "$LOG_DIR" -type f -mtime +$RETAIN -delete -print


## Output the list of currently installed apt packages
log "## Outputing installed apt packages to $APT_LIST_FILE"
apt list --installed > $APT_LIST_FILE

## Create system backup of root as a squash file and exclude home media dev run mnt proc sys tmp
if [ $BACK_TYPE1 = "sqfs" ]
then
	log "## Creating Squashfile backup at $BACKUP_FILE.sqfs."
	log "## This could take some time. Please wait..."
	sudo mksquashfs $TARGET_DIR $BACKUP_FILE.sqfs -e $SQFS_EXCLUDE -percentage -processors $PROCS
else
	log "Skipping Squahsfs backup"
fi

## Create system backup of root as a tar file and exclude home media dev run mnt proc sys tmp
if [ $BACK_TYPE2 = "tar" ]
then
	log "## Creating tar backup at $BACKUP_FILE.tar.gz."
	log "## This could take some time. Please wait..."
	tar cpjf $BACKUP_FILE.tar.gz --totals $TAR_EXCLUDE_BAK $TAR_EXCLUDE $TARGET_DIR
else
	log "Skipping tar backup"
fi

##close out script.
log "## Backup complete. browse to $BACKUP_DIR to view the files."

exit 0