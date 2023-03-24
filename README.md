# ubuntu-scripts
All scripts created from scratch by Rinval86.
These scripts were written on Ubuntu 20.04 but may be compatible with other versions.
Check out additional things I have created at https://github.com/Rinval86?tab=repositories

This repository contains various bash or shell scripts I made to perform various tasks in ubuntu or automate processes.
All of the included scripts are covered under the Creative Commons license. 
In short you can download, modify and use for personal or business use without any warrenty or guarantee it will work. Also you will not hold any liability to me. However you should give credit where credit is due and not steal any code provided in this repository to claim as your own.

***I highly recommend you review the code and notes in the script you choose to use to understand what it is doing and how it is doing it before executing any scripts included in this repository.***
 
Included Scripts

CLI

	1. backup.sh
	
		This script was created to automate backing up of root on a ubuntu server. This would allow you to recover configuration and data of a ubuntu system if there is a catastrophic failure and the OS is unrecoverable. 
		
		backup.sh is a bash script that uses Squashfs or Tar (or both) to create a backup of root (default) or if modified any source folder. It also creates a log file for review. This script also checks for backups and logs that are X number of days old and removes them. 
		
		Backup.sh can be added to crontab -e to execute automatically at a set interval. 
		
		**Be sure to modify the sript variables** for your desired system and locations.
		
	

