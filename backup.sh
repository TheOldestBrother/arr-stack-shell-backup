#!/bin/bash
set -Eeo pipefail

source ./env.sh

#IMPROVEMENT Implement validation to check for errors before beginning the program.
#IMPROVEMENT Add console prints to show user what's happening.

# Validating rsync exists in system.
if ! command -v rsync  >/dev/null 2>&1
then
    echo "Rsync not found in this device"
    exit 1
fi

mkdir -p $TMP_DIR/backup/config

# Stopping all containers before backing up.
(cd $SOURCE_PATH && docker compose stop)

# Sync everything in one go.
rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/. $TMP_DIR/backup/config

#TODO Restart all containers
#FIXME Error while trying to start containers that are exited.
# (cd $SOURCE_PATH && docker compose start)

source ./dir_manager.sh