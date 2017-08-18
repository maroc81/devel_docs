#!/bin/bash

BORG=/usr/local/bin/borg

REPOSITORY=/path/to/borg_backup_repo

# check free space
SPACE=$(df $REPOSITORY | tail -n 1 | tr -s ' ' | cut -f5 -d' ' | tr -d '%')
if [ $SPACE -gt 90 ]
then
	echo "Not enough free space"
	exit 1
fi

# TODO, check free space while borg is running and kill it if it gets too low

# backup
$BORG create -v --stats --progress --compression zlib,6		\
	$REPOSITORY::`hostname`-`date +%Y-%m-%d`		\
	$HOME						\
	--exclude $HOME/*/.cache			\
	--exclude $HOME/.cache			\
	--exclude-caches


# prune to keep 7 daily, 4 weekly and 6 monthly
$BORG prune -v $REPOSITORY --prefix `hostname`- \
	--keep-daily=7 --keep-weekly=4 --keep-monthly=6
