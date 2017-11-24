#!/bin/sh
set -e


BACKUP_DAYS=$(eval echo ${BACKUP_DAYS})
MYSQL_DB_HOST=$(eval echo ${MYSQL_DB_HOST})
MYSQL_DB_USER=$(eval echo ${MYSQL_DB_USER})
MYSQL_DB_PWD=$(eval echo ${MYSQL_DB_PWD})
MYSQL_DB_NAME=$(eval echo ${MYSQL_DB_NAME})
MYSQL_BACKUP_CUSTOM_OPTION=$(eval echo ${MYSQL_BACKUP_CUSTOM_OPTION})

DATESTR=$(date +%Y-%m-%d_%T)


# 如果没有设置过期天数 则默认7天
if [ ! ${BACKUP_DAYS} ];  then 
  BACKUP_DAYS="7"
fi

# 如果没有设置自定义选项，默认使用 -q 选项
if [ ! ${MYSQL_BACKUP_CUSTOM_OPTION} ]; then 
  MYSQL_BACKUP_CUSTOM_OPTION="-q"
fi


cd /mysql_backups

# 删除过期备份
find . -type f -mtime +${BACKUP_DAYS} -exec rm -f {} \;

# 备份并压缩指定数据库
mysqldump -h "${MYSQL_DB_HOST}" -u "${MYSQL_DB_USER}" -p"${MYSQL_DB_PWD}" ${MYSQL_BACKUP_CUSTOM_OPTION} --databases "${MYSQL_DB_NAME}" > backup.sql
tar -czf ${DATESTR}_backup.tar.gz backup.sql
rm backup.sql
