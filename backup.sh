#!/bin/bash
routers=( 192.168.1.1 192.168.2.1 192.168.3.1 )
backupdir="/home/backup/mikrotik"
privatekey="/root/.ssh/id_dsa"
login="user"
passwd="pa$Sw0rd"
fulldir="${backupdir}/`date +%Y`/`date +%m`/`date +%d`"

for r in ${routers[@]}; do
    cmd_backup="/system backup save name=${r}.backup"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    cmd_backup="/export file=${r}"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    sleep 5
    mkdir -p $fulldir
    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.backup
    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.rsc
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.backup\""
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.rsc\""
done
