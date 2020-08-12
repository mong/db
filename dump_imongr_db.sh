#!/bin/bash

docker exec -t mariadb sh -c 'exec mysqldump --add-drop-database --skip-comments --single-transaction -u$MYSQL_USER -p"$MYSQL_PASSWORD" --databases "$MYSQL_DATABASE"' > imongr_db_dump.sql

gzip --force imongr_db_dump.sql

