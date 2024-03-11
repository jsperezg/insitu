#!/bin/bash

#
# Collect all database names except for
# mysql, information_schema, and performance_schema
#
SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('mysql','information_schema','performance_schema')"

DBLISTFILE=/tmp/DatabasesToDump.txt
$(brew --prefix mysql-client@8.0)/bin/mysql -u $DATABASE_USER -p -ANe"${SQL}" > ${DBLISTFILE}

DBLIST=""
for DB in `cat ${DBLISTFILE}` ; do DBLIST="${DBLIST} ${DB}" ; done

BACKUP_FILE=~/backups/mysql_`date +%Y%m%d`.sql.gz

$(brew --prefix mysql-client@8.0)/bin/mysqldump -u $DATABASE_USER -p -c -a --opt -e --replace -R --databases ${DBLIST} | gzip -9 -c > $BACKUP_FILE
