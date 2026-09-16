#!/bin/bash
set -euo pipefail

source ./env.sh

# Validating rsync exists in system.
if ! command -v rsync  >/dev/null 2>&1
then
    echo "Rsync not found in this device"
    exit 1
fi

# Validating sudo permissions.
sudo -k # Revokes current cached sudo credentials to make sure the user understands it needs sudo.
if [ "$EUID" = 0 ]; then
    echo "Already sudo, proceeding as expected"
else
    if sudo true; then
        echo "Correct password, proceeding as expected" 
    else
        echo "Wrong password, exiting program"
    fi
fi

# Create final destination with correct permission so the programe can write to it.
sudo mkdir -p $FINAL_DESTINATION
CURRENT_USER=$(whoami)
sudo chown $CURRENT_USER:$CURRENT_USER $FINAL_DESTINATION

mkdir -p $TMP_DIR/backup/config

# Stopping all containers before backing up.
(cd $SOURCE_PATH && docker compose stop)

# Sync everything in one go.
rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/. $TMP_DIR/backup/config

#TODO Restart all containers
#FIXME Error while trying to start containers that are exited.
# (cd $SOURCE_PATH && docker compose start)

source ./dir_manager.sh