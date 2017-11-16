#!/bin/sh
set -e

MYSQL_BACKUP_HOST=$(eval echo ${MYSQL_BACKUP_HOST})
MYSQL_BACKUP_USER=$(eval echo ${MYSQL_BACKUP_USER})
MYSQL_BACKUP_PWD=$(eval echo ${MYSQL_BACKUP_PWD})
MYSQL_BACKUP_DATABASES=$(eval echo ${MYSQL_BACKUP_DATABASES})

DATESTR=$(date +%Y-%m-%d_%T)

# 如果没有设置过期天数 则默认7天
if [ ! ${BACKUP_DAYS} ];  then 
  BACKUP_DAYS="7"
fi

cd /mysql_backups

# 删除过期备份
find . -type f -mtime +${BACKUP_DAYS} -exec rm -f {} \;

# 备份并压缩指定数据库
mysqldump -h "${MYSQL_BACKUP_HOST}" -u "${MYSQL_BACKUP_USER}" -p"${MYSQL_BACKUP_PWD}" --databases "${MYSQL_BACKUP_DATABASES}" > backup.sql
tar -czf ${DATESTR}_backup.tar.gz backup.sql
rm backup.sql
