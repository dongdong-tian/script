#!/bin/bash
#Script fuction description
#The scripts  can  automatic  backup  system  file  every day .
#Set the environment parameter
tar_cmd=`which tar`
year=`date +%Y`
month=`date +%m`
day=`date +%d`
week=`date +%u`
backup_dir=/backup
backup_file_list=/backup/file
current_backup_dir=${backup_dir}/${year}/${month}/${day}
source_dir=(`cat ${backup_file_list}`)
snapshot_file=${backup_dir}/snapshot.init
full_backup_file=${current_backup_dir}/full_backup.tar.gz
addition_backup_file=${current_backup_dir}/addtion_backup.tar.gz

#Parameters of the judgment
[ -z ${tar_cmd} ] && echo " The tar command is not found,pleases check..." &&exit 1 
[ ! -d ${backup_dir} ] && echo "The backup directory is not exsit, pleases check..." && exit 1
[ ! -f ${backup_file_list} ] && echo "The backup file list is not exsit, pleases check..." && exit  1
if [ ! -d ${current_backup_dir} ];then
	mkdir -p ${current_backup_dir}
	if [ $? -eq 0 ];then
		echo "Today backup directory Create  Successfully."
	else
		echo "Today backup directory Create Faild."
		exit 1 
	fi
fi

#Function definition
function Full_backup {
	echo "Starting Full backup program,pleases wait...."
	sleep 5
	[ -e ${snapshot_file} ] && mv ${snapshot_file} ${backup_dir}/snapshot_`date +%Y%m%d`.init && rm -rf ${${snapshot_file}}
	${tar_cmd} -g  ${snapshot_file}  -czvf ${full_backup_file} -P ${source_dir[@]} &>>/dev/null

	if [ $? -eq 0 ] && [ -e ${snapshot_file} ] && [ -e ${full_backup_file} ];then
		echo "Create snapshot file and full backup file Successfully"
	else
		echo "Create snapshot file and full backup file Faild"
	fi
	

}

function Addition_backup {
	if [ ! -e ${snapshot_file} ];then
		echo "First Full backup system file."
		Full_backup
		return 0
	fi

	echo "Starting Addition backup program,pleases wait...."
	sleep 5

	${tar_cmd} -g  ${snapshot_file}  -cvzf ${addition_backup_file} -P ${source_dir[@]}  &>>/dev/null
	if [ $? -eq 0 ] && [ -e ${addition_backup_file} ];then
        	echo "Create addition file Successfully."
	else
        	echo "Create addition file Faild."
	fi
}

#Statement judge
case   ${week}  in
7)
	Full_backup
;;
*)
	Addition_backup
esac

#End
