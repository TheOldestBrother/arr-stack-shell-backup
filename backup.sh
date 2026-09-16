#!/bin/bash
set -Eeo pipefail

source ./env.sh

#IMPROVEMENT Implement validation to check for errors before beginning the program.

# Validating rsync exists in system.
if ! command -v rsync  >/dev/null 2>&1
then
    echo "Rsync not found in this device"
    exit 1
fi

mkdir -p $TMP_DIR/backup/config

# Stopping all containers before backing up.
(cd $SOURCE_PATH && docker compose stop)
echo -e "${GREEN}OK${NC} -- Arr containers stopped"
echo ""

# Sync everything in one go.
rsync -ax --exclude "**/asp/*" --exclude "**/qBittorrent/logs/*" $SOURCE_PATH/config/. $TMP_DIR/backup/config
echo -e "${GREEN}OK${NC} -- All configs copied to temp directory"
echo ""

#FIXME Error while trying to start containers that are exited.
(cd $SOURCE_PATH && docker compose start)
echo -e "${GREEN}OK${NC} -- Arr containers started again"
echo ""

source ./dir_manager.sh