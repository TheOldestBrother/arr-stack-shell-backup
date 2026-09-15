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

sudo mkdir -p $FINAL_DESTINATION
CURRENT_USER=$(whoami)
sudo chown $CURRENT_USER:$CURRENT_USER $FINAL_DESTINATION

mkdir -p $TMP_DIR/backup/config

#TODO Stop all containers
(cd $SOURCE_PATH && docker compose stop)

# Sync everything in one go.
rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/. $TMP_DIR/backup/config


# #JELLYFIN
# cp -a $SOURCE_PATH/config/jellyfin/. $BACKUP_DIR/config/jellyfin

# #QBITTORRENT
# cp -a $SOURCE_PATH/config/qbittorrent/. $BACKUP_DIR/config/qbittorrent

# #RADARR
# # sudo cp -a $SOURCE_PATH/config/radarr/. $BACKUP_DIR/config/radarr
# rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/radarr/. $BACKUP_DIR/config/radarr

# #SEERR
# cp -a $SOURCE_PATH/config/jellyseerr/. $BACKUP_DIR/config/seerr

# #PROWLARR
# # sudo cp -a $SOURCE_PATH/config/prowlarr/. $BACKUP_DIR/config/prowlarr
# rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/prowlarr/. $BACKUP_DIR/config/prowlarr

# #SONARR
# # cp -a $SOURCE_PATH/config/sonarr/. $BACKUP_DIR/config/sonarr
# rsync -ax --exclude "**/asp/*" $SOURCE_PATH/config/sonarr/. $BACKUP_DIR/config/sonarr

# #BAZARR
# cp -a $SOURCE_PATH/config/bazarr/. $BACKUP_DIR/config/bazarr


#TODO Restart all containers
# (cd $SOURCE_PATH && docker compose start)

source ./dir_manager.sh