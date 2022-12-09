#!/bin/bash

function Mainmenu(){
	clear
	printf "\n Mainmenu \n"
	printf "Press b to create a backup\n"
	printf "Press r to restore a backup\n"
	printf "Press l to list all backups\n"
	printf "Press d to delete backups\n"
	printf "Enter \"Exit\" to exit the script\n"
	read -p "Input: " USERINPUT
}

function backupbackup(){
	clear
	printf "\n BACKUP \n"
	printf "Please insert the paths/files you want to backup:\n"
	read -p "Backup inputs: " BACKUPINPUT
	printf "\nPlease insert the target folder for your backup file:\n"
	read -p "Backuppath: " BACKUPPATH
	printf "Press z  to use zip compression\n"
	printf "Press j to use bzip compression\n"
	printf "Press x to use tgxz compression\n"
	printf "Press m for Mainmenu\n"
	printf "Enter \"Exit\" to exit the script\n"
	read -p "Compression selection: " COMPRESSIONMETHOD
	case $COMPRESSIONMETHOD in
		z|Z)
			tar cfzv $BACKUPPATH/Backup_$(date +%y-%m-%d_%H_%M_%S).tgz $BACKUPINPUT
			;;
		j|J)
			tar cfjv $BACKUPPATH/Backup_$(date +%y-%m-%d_%H_%M_%S).tgbzip2 $BACKUPINPUT
			;;
		x|X)
			tar cfxv $BACKUPPATH/Backup_$(date +%y-%m-%d_%H_%M_%S).tgxz $BACKUPINPUT
			;;
		m|M)
			Mainmenu
			;;
		exit|Exit)
			exit 0
			;;
		*)
			printf "default case ... byebye"
			sleep 2
		esac
	
	sleep 10	
}

function backuprestore(){
	clear
	printf "\n BACKUP RESTORE \n"
	sleep 5
}


function backuplist(){
	clear
	printf "\n BACKUP LIST \n"
	printf "(Only showing entrys in /root/backup/\n)"
	cd /root/backup
	ls -l | egrep ".+\.(tgz|tgbzip2|tgxz)"
	sleep 5
}

function backupdelete(){
	clear
	printf "\n BACKUP DELETE \n"
	printf "Press l to list all current backups in the default Path(/root/backup/)\n"
	printf "Press k to input the number of backups you want to keep\n"
	printf "Press d to input the number of backups you want to delete\n"
	printf "Press m for Mainmenu\n"
	printf "Enter \"Exit\" to exit the script\n"
	read -p "Input: " BACKUPDELETE
	case $BACKUPDELETE in
		l|L)
			backuplist
			backupdelete
			;;
		k|K)
			printf "\n Please input the number of backups you want to keep: \n"
			read -p "Input: " BACKUPKEEPNR
			printf "\nYou are about to delete all backups but keep $BACKUPKEEPNR!\n Are you sure about that?! (Y/N)\n"
			read -p "YES / NO: " YESNO
			if [ "$YESNO" = "Yes" ] || [ "$YESNO" = "yes" ] || [ "$YESNO" = "y" ] || [ "$YESNO" = "Y}" ]
			then
				cd /root/backup/
				rm $(ls /root/backup/ | head -n $(expr $(ls /root/backup/ | wc -l) - $BACKUPKEEPNR))
				YESNO="NO"	
			else
				backupdelete
				printf "\nABORTED GOING BACK TO DELETE MENU\n"
			fi
			;;
		d|D)
			printf "\n Please input the number of backups you want to delete: \n"
			read -p "Input: " BACKUPDELETENR
			printf "\nYou are about to delete $BACKUPDELETENR Backups!\n Are you sure about that?! (Y/N)\n"
			read -p "YES / NO: " YESNO
			if [ "$YESNO" = "Yes" ] || [ "$YESNO" = "yes" ] || [ "$YESNO" = "y" ] || [ "$YESNO" = "Y}" ]
			then
				BACKUPSTODELETE= expr $(ls /root/backup/ | wc -l) - $BACKUPDELETENR
				printf "\n$BACKUPSTODELETE"
				sleep 5
				cd /root/backup/
				rm $(ls /root/backup/ | head -n $(expr $(ls /root/backup/ | wc -l) - $BACKUPSTODELETE))
				YESNO="NO"
				sleep 10
					
			else
				printf "\nABORTED GOING BACK TO DELETE MENU\n"
				sleep 2
				backupdelete
			fi
			;;
		m|M)
			Mainmenu
			;;
		exit|Exit)
			exit 0
			;;
		*)
			printf "\n default case ... byebye"
			;;
	esac

}


while :
do
	Mainmenu

case $USERINPUT in
	b|B)
		backupbackup
		;;
	r|R)
		backuprestore
		;;
	l|L)
		backuplist
		;;
	d|D)
		backupdelete
		;;
	exit|Exit)
		exit 0
		;;
	*)
		echo "default case - byebye"
		sleep 2
	esac
done
exit 0

