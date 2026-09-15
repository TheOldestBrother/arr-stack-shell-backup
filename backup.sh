#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SOURCE_PATH="/mnt/big-disk/local-media-streaming-master"

TMP_DIR=$(mktemp -d)
BACKUP_DIR_NAME="$(date +"%Y-%m-%d--%H:%M:%S")_arr-backup"
BACKUP_DIR="$TMP_DIR/$BACKUP_DIR_NAME"
FINAL_DESTINATION="/srv/arr-suite/backups"

if ! command -v rsync  >/dev/null 2>&1
then
    echo "Rsync not found in this device"
    exit 1
fi

mkdir -p $FINAL_DESTINATION
mkdir -p $BACKUP_DIR/config

echo $TMP_DIR
tree $TMP_DIR

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

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

#TODO Compress the backup directory.
tar -czf "$FINAL_DESTINATION/$BACKUP_DIR_NAME.tar.gz" -C "$TMP_DIR" "$BACKUP_DIR_NAME"
BACKUP_SIZE=$(du -sh "$FINAL_DESTINATION/$BACKUP_DIR_NAME.tar.gz" | cut -f1)
echo -e "${GREEN}OK${NC}   Created $BACKUP_DIR_NAME.tar.gz ($BACKUP_SIZE)"
echo ""
