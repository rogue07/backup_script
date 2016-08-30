
# ram 
# 24 mar 2015                
# backup some folders

# 26 Feb, 2016 - added timestamp variable
#              - added hostname if else, to send data to the correct place


#!/bin/bash

VER="v2.01"
LOG="/tmp/backup.log"
RAM="3523969626"
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y%m%d_%H%M)

### Check for old log file ###
if [ -f $LOG ]; then
	echo
	echo "$LOG is exists. Moving it with a time & date stamp"
	mv -v $LOG $LOG-$TIMESTAMP
	touch $LOG
else
	echo
	echo "$LOG now exists."
	touch $LOG
fi

### Backup version ###
echo
echo -e "You are running the Ram Backup, Ver: $VER. `date +"%T"`" | tee -a $LOG

### Tar the backup folder and check it's size ###
echo
echo -e "Tar'ing specific files in the home folder." | tee -a $LOG
tar -vcf ~/$HOSTNAME-backup-`date +%Y-%m-%d_%H%M`.tar ~/Desktop ~/Documents ~/Music ~/Pictures ~/Public ~/Templates ~/Videos ~/lana ~/ram ~/scripts ~/beagle ~/kali ~/kinect ~/rx30 | tee -a $LOG

### Check the size of the tar file ###
SIZE=`ls -la ~/*.tar | awk '{print $5}'`
echo "$SIZE MB" | tee -a $LOG
date | tee -a $LOG

### If pbody scp the file. If shimmer delete files older than 14 days ###
if [[ "$HOSTNAME" == "pbody" ]]; then
	echo
	echo "This is pbody, scp'ing the backup" | tee -a $LOG
	scp -v ~/*.tar shimmernshine@192.168.10.201:/run/media/shimmernshine/Tarantula/backups/ | tee -a $LOG
		if [ "$?" = "0" ]; then
			echo
			echo -e "Scp of file successful" | tee -a $LOG
		else
			echo
			echo -e "Scp failure, it's broke." | tee -a $LOG
curl http://textbelt.com/text -d "number=$CELL" -d "message=$HOSTNAME scp failed. Backup failed." |tee -a $LOG
			exit 1
		fi
else
	echo
	echo "This is shimmer, copying to external." | tee -a $LOG
	mv -v ~/*.tar /run/media/shimmernshine/Tarantula/backups/ | tee -a $LOG
	find /run/media/shimmernshine/Tarantula/backups/*backup*.tar -mtime +14 -exec rm {} \; | tee -a $LOG
fi

### Remove backup files that were created ###
echo
echo "Removing tar file from home directory." | tee -a $LOG
#rm -rfv ~/backup* | tee -a $LOG
rm -rfv ~/*backup*.tar | tee -a $LOG

### All is well, send a verification text. ###
echo
echo "Everything went well, sending text." | tee -a $LOG
curl http://textbelt.com/text -d "number=$RAM" -d "message=$HOSTNAME backup is complete. $SIZE MB" | tee -a $LOG
