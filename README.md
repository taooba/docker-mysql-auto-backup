# docker-mysql-auto-backup
[![Docker Hub](http://dockeri.co/image/taooba/mysql-auto-backup)](https://hub.docker.com/r/taooba/mysql-auto-backup/)

一个专门用来做 MySQL 数据库自动备份的自定义 Docker 镜像，适合个人项目或微笑项目，因为功能简单没有做 Tag 区分只有 `latest` 版本。基础镜像采用的是 `alpine:latest`。内部使用 `crontab` 命令按一定的时间间隔来调用备份脚本，使用 `mysqldump` 来备份数据库。备份的内容在匿名数据卷 `VOLUME /mysql_backups` 中。



# 使用示例

```shell
docker run -it -v /mysql_backups/:/mysql_backups/:rw 
-e MYSQL_DB_HOST=xxx.xxx.xxx.xxx 
-e MYSQL_DB_USER=root 
-e MYSQL_DB_PWD=xxxxx 
-e MYSQL_DB_NAME=xxx 
taooba/mysql-auto-backup
```



# 启动环境变量

| 变量名                        |                    作用                    | 必选/可选 |
| :------------------------- | :--------------------------------------: | :---: |
| MYSQL_DB_HOST              |              备份数据库服务器的主机地址               |  必选   |
| MYSQL_DB_USER              |               访问备份数据库的用户名                |  必选   |
| MYSQL_DB_PWD               |                访问备份数据库的密码                |  必选   |
| MYSQL_DB_NAME              |            要备份的数据库（多个使用空格分割）             |  必选   |
| MYSQL_BACKUP_CUSTOM_OPTION |      作用 `mysqldump` 命令的自定义选项，默认为 -q      |  可选   |
| CRONTAB_TIME               | `crontab` 命令的间隔时间, 需要符合 `crontab` 命令的时间格式，例："* * * * *"。若为空则默认每天凌晨 5 点 |  可选   |
| BACKUP_DAYS                |          备份数据保留时间（天），若为空默认为 7 天          |  可选   |



# Tips

可以在传递环境变量时传递一个变量，只需在变量名前加上 `$` 符号即可。例如启动一个 `mysql_backup` 容器，它连接一个 `mysql` 容器: `docker run …  --link mysql:mysql` 。此时在 `mysql_backup `  的容器中会生成一个名为 `MYSQL_PORT_3306_TCP_ADDR` 的环境变量保存着 `mysql` 容器的地址。可以通过 `MYSQL_DB_HOST=$MYSQL_PORT_3306_TCP_ADDR` 的形式把数据库地址赋值给 `MYSQL_DB_HOST` 。