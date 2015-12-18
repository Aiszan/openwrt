#!/bin/bash
BACKUP_DIR=mtd_backup
USER==root
ROUTER=extwnr

mkdir -p $BACKUP_DIR
ssh $USER@$ROUTER 'for i in 'seq 0 6'; do
mtdname='cat /proc/mtd | grep mtdf$i | cut -d" " -f4 | sed s/\"//g'
echo "Backing up ${mtdname}"
dd if=/dev/mtd${i}ro of=/tmp/mtd${i}_${mtdname}.backup
done'

scp $USER@$ROUTER:/tmp/mtd*.backup $BACKUP_DIR

echo 'Removing remote backup files'
ssh $USER@$ROUTER 'rm /tmp/mtd*.backup'

printf '\nZipping backup folder to mtd_backup.zip\n'
zip -9mrv mtd_backup.zip mtd_backup
printf '\n\nmtd backup complete. \nDont forget to unzip mtd_backup.zip before restoring.\n unzip -v btd_backup.zip\n'
