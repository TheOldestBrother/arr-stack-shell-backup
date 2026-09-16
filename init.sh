#!/bin/bash
set -Eeo pipefail

source ./env.sh

# Validating sudo permissions.
sudo -k # Revokes current cached sudo credentials to make sure the user understands that the programme needs sudo.
if [ "$EUID" = 0 ]; then
    echo "Already sudo, proceeding as expected"
else
    if sudo true; then
        echo "Correct password, proceeding as expected"
    else
        echo "Wrong password, exiting program"
    fi
fi

#IMPROVEMENT Add catch for potential errors while creating the directory.
# Create final destination with correct permission so the main programme
# can write to it without using sudo.
sudo mkdir -p $FINAL_DESTINATION
CURRENT_USER=$(whoami)
sudo chown $CURRENT_USER:$CURRENT_USER $FINAL_DESTINATION
echo -e "${GREEN}OK${NC} -- Destination files created at :"
echo "           ${FINAL_DESTINATION}"
echo ""

# Creating cron job for the backup.

# Check if a crontab exist for the user, if not create the tmp_file manually.
if [[ "$(crontab -l > $TMP_DIR/tmp_cron)" != "0" ]]; then
    touch $TMP_DIR/tmp_cron
fi

echo "# Backup script for the Arr suite." >> $TMP_DIR/tmp_cron
echo "@daily (cd $(pwd); ./backup.sh) >> $(pwd)/script.log 2>&1 " >> $TMP_DIR/tmp_cron
crontab $TMP_DIR/tmp_cron

echo -e "${GREEN}OK${NC} -- Cron job successfully setup"