#!/bin/bash

echo "Syncing local db backups with AWS S3"

aws s3 sync ~/backup s3://backup-imongr-db --delete
