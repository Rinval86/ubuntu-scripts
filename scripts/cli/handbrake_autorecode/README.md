# ubuntu-scripts
All scripts created from scratch by Rinval86.
Various sources were used in obtaining the knowledge to create these scripts. Thanks to all contributers of the sources utilized.
These scripts were written on Ubuntu 20.04 but may be compatible with other versions.
Check out additional things I have created at https://github.com/Rinval86?tab=repositories

**DISCLAIMER: I am in no way related to the handbrake project. By installing handbrake you agree to all their terms and conditions.**

recode.sh was created to automate handbrake recode of video files using handbrake CLI and one of its presets.

This script was sourced from various forums and gethubs, unfortunately that was two years ago and I did not mark down the sources. Thanks to whoever's sources were used in formulating this script. 
		
This script uses a combination of Handbrake CLI and Crontab to search a directory for supported video files then transcodes them to a handbrake preset.

You must install the handbrake-cli package for this script to work. 
	**sudo apt install -y handbrake-cli**

recode.sh out of the box requires the following four folders in the same directory as script. If missing these folders will be created. However you can adjust the variables inside the recode.sh script to target any folders with appropriate permissions. also the script can be adjusted to use your own transcoding parameters if you so wish.
	REQUIRED OUT OF BOX FOLDERS:
	complete
	log
	original
	recode
		
	The complete folder will contain the completed recoded video files in whatever preset and format you chose.
	The log folder will contain logs of the recode.sh execution.
	The original folder with contain the original source video files that have completed the transcode process. You can either manually remove them if no longer needed or they will auto delete if they are older than 10 days (this value is configurable in the recode.sh script).  
	The recode folder will contain video files you wish to recode to the configured preset. These files will remain in place until the recode is complete then they are moved to the original folder for safe keeping while you confirm the recoded file in the complete folder is acceptable.
	
This script will check to see if handbrake is already running and ignore starting a new process if handbrake is already running. This may result in script failure if handbrake hangs or does not close after completing a transcode. 
	
**Be sure to modify the sript variables for your desired preset and locations if you do not want out of box functionality.**

The default handbrake-cli preset is "Roku 1080p30 Surround" and uses these four folders in the same directory as the script: complete, log, original, recode.
This file must be run as root or sudo
This script and folders can be stored anywhere but needs appropriate permissions

	Example permissions changes and execution
	
	Modify the variables inside the script to your desired settings.
		sudo nano /path/to/file/<recode.sh file> or sudo vim /path/to/file/<recode.sh file>

	set read write and execute for owner, group, and everyone
		sudo chmod 777 /path/to/file/<recode.sh file>
		
		you can set permissions recursivly to everything in the directory with the following command.
		sudo chmod -R 777 /path/to/file/
		
	Execute the script
		sudo ./<recide.sh file> or sudo /path/to/file/<recode.sh file>

	How to make this script an automated crontab job 
		**WARNING DO NOT DELETE ANYTHING FROM CRON OR CRONTAB UNLESS YOU KNOW WHAT YOUR DOING**

		open crontab on ubuntu and select your favorite editor if you have not already done so.
			sudo crontab -e
				nano is a notepad like editor. you can execute functions at the bottom by pressing ctrl + command character
				VIM is the classic Linux and Unix text editor. For details on how to use vim check "man vi" or "man vim"
 
			Crontab syntax "[minute] [hour] [day of month] [month] [day of week] [command]"
			For example add the following line at the end of the file to lauch the recode process every 15 minutes. 
				0,15,30,45 * * * * /path/to/file/<recode.sh file>
			
			**NOTE: You may want to set your timezone if you have not already done so.
				List available time zones: sudo timedatectl list-timezones
				set time zone: sudo timedatectl set-timezone <your_time_zone>
				
You can get an up to date list of HandBrakeCLI presets using this command. 
	HandBrakeCLI -z
	
For additional options for handbrakecli run this command to see what is available.
	HandBrakeCLI -help
