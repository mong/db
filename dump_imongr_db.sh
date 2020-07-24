#!/bin/bash

docker exec -it mariadb sh -c 'exec mysqldump -add-drop-database --skip-comments --compact --single-transaction -u$MYSQL_USER -p"$MYSQL_PASSWORD" --databases "$MYSQL_DATABASE"' > imongr_db_dump.sql

tar czf imongr_db_dump.sql.tar.gz imongr_db_dump.sql

