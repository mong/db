#!/bin/bash

docker exec -it mariadb sh -c 'exec mysqldump -u$MYSQL_USER -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' > imongr_db_dump.sql
