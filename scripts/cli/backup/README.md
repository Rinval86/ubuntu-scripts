# ubuntu-scripts
All scripts created from scratch by Rinval86.
Various sources were used in obtaining the knowledge to create these scripts. Thanks to all contributers of the sources utilized.
These scripts were written on Ubuntu 20.04 but may be compatible with other versions.
Check out additional things I have created at https://github.com/Rinval86?tab=repositories

The backup.sh script was created to automate backing up of root on a ubuntu server. This would allow you to recover configuration and data of a ubuntu system if there is a catastrophic failure and the OS is unrecoverable. 
		
backup.sh is a bash script that uses Squashfs or Tar (or both) to create a backup of root (default) or if modified any source folder. It also creates a log file for review. This script also checks for backups and logs that are X number of days old and removes them. 
		
Backup.sh can be added to crontab -e to execute automatically at a set interval. 
		
**Be sure to modify the sript variables for your desired system and locations.**

The default is squash.fs which can be both mounted as a sqhs file or extracted.
This file must be run as root or sudo
This file can be stored anywhere but needs execute permissions

	Example permissions changes and execution
	
	Modify the variables inside the script to your desired settings.
		sudo nano /path/to/file/<backup.sh file> or sudo vim /path/to/file/<backup.sh file>

	set read write and execute for owner, group, and everyone
		sudo chmod 777 /path/to/file/<backup.sh file>
		
	Execute the script
		sudo ./<backup.sh file> or sudo /path/to/file/<backup.sh file>

	How to make this script an automated crontab job 
		**WARNING DO NOT DELETE ANYTHING FROM CRON OR CRONTAB UNLESS YOU KNOW WHAT YOUR DOING**

		open crontab on ubuntu and select your favorite editor if you have not already done so.
			sudo crontab -e
				nano is a notepad like editor. you can execute functions at the bottom by pressing ctrl + command character
				VIM is the classic Linux and Unix text editor. For details on how to use vim check "man vi" or "man vim"
 
			Crontab syntax "[minute] [hour] [day of month] [month] [day of week] [command]"
			For example add the following line at the end of the file to backup every day at 3 AM server time. 
				0 3 * * * /path/to/file/<backup.sh file>
			
			**NOTE: You may want to set your timezone if you have not already done so.
				List available time zones: sudo timedatectl list-timezones
				set time zone: sudo timedatectl set-timezone <your_time_zone>

** DISCLAIMER: THIS SCRIPT WAS NOT TESTED WITH LOCATIONS CONTAINING SPACES.**