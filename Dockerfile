FROM alpine:latest
RUN apk add --update mysql-client && rm -rf /var/cache/apk/* 

VOLUME /mysql_backups

COPY Shanghai /etc/localtime
COPY mysql_backup.sh /
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ash"]