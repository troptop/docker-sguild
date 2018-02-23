#!/bin/bash

if [ "$INSTALL" != "false" ]; then
   if [ -n "$MYSQL_ADMIN" ] && [ -n "$MYSQL_ADMINPASS" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DBNAME" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_USER" ]; then
	mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "create database $MYSQL_DBNAME;"
	mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "GRANT ALL PRIVILEGES ON $MYSQL_DBNAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
	mysql -u$MYSQL_ADMIN -p$MYSQL_ADMINPASS -h $MYSQL_HOST -e "FLUSH PRIVILEGES;"
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST $MYSQL_DBNAME < /opt/sguil/server/sql_scripts/create_sguildb.sql
   else
	echo "ENV VARIABLE MISSING :
	Please check if you have the following ENV setup : 
	- --env INSTALL 
	- --env MYSQL_ADMIM 
	- --env MYSQL_ADMINPASS 
	- --env MYSQL_HOST 
	- --env MYSQL_DBNAME 
	- --env MYSQL_PASSWORD 
	- --env MYSQL_USER"

   fi
fi
openssl req -newkey rsa:2048 -nodes -keyout /etc/sguild/certs/sguild.key -x509 -days 365 -out /etc/sguild/certs/sguild.pem -subj "$CERT_INFO"
/usr/bin/python /opt/jinja-sguild-conf.py > /etc/sguild/sguild.conf
/opt/sguil/server/sguild $@
