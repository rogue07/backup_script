################################
# ram 24mar2015                #
# backup some folders,         #
# compress and copy to Desktop #
################################


#!/bin/bash

LOG=/tmp/backup.log
tee='tee -a'
HOST=192.168.1.1      # your ftp server ip here
USER=abcde            # ftp username
PASS=12345            # ftp password
ME='5555555555'       # replace variable name "ME" & the phone number


cd /tmp
echo -e "You are running the Me Backup." | $tee $LOG
echo
echo -e "Creating backup directory in /tmp/backup" | $tee $LOG
mkdir /tmp/backup | $tee $LOG
echo
echo
echo -e "Copying files: " | $tee $LOG
cp -vrf ~/Desktop /tmp/backup | $tee $LOG
cp -vrf ~/Downloads /tmp/backup | $tee $LOG
cp -vrf ~/Videos /tmp/backup | $tee $LOG
cp -vrf ~/Music /tmp/backup | $tee $LOG
cp -vrf ~/Pictures /tmp/backup | $tee $LOG
cp -vrf ~/Public /tmp/backup | $tee $LOG
echo
echo
echo
echo
echo -e "Compressing the backup folder." | $tee $LOG
tar -vcf backup_`date +%H%M%F`.tar ~/backup | $tee $LOG
ftp -inv $HOST << EOF
user $USER $PASS
cd me
hash
put *.tar
bye
EOF


rm -rf /tmp/backup      # cleaning up stuff
rmdir /tmp/backup       # cleaning up stuff
echo
echo
echo
echo
echo -e "Backup is complete sir."
echo
echo
curl http://textbelt.com/text -d "number=$ME" -d "message=Backup is completed sir." |$tee $LOG
