KEEP_MINS=$BACKUP_KEEP_MINUTES
KEEP_DAYS=$BACKUP_KEEP_DAYS
KEEP_WEEKS=`expr $(((${BACKUP_KEEP_WEEKS} * 7) + 1))`
KEEP_MONTHS=`expr $(((${BACKUP_KEEP_MONTHS} * 31) + 1))`

LAST_FILENAME="`date +%Y%m%d-%H%M%S`--arr_stack_backup${BACKUP_SUFFIX}"
DAILY_FILENAME="`date +%Y%m%d`--arr_stack_backup${BACKUP_SUFFIX}"
WEEKLY_FILENAME="`date +%G-%V`--arr_stack_backup${BACKUP_SUFFIX}"
MONTHY_FILENAME="`date +%Y%m`--arr_stack_backup${BACKUP_SUFFIX}"

FILE="${FINAL_DESTINATION}/last/${LAST_FILENAME}"
DFILE="${FINAL_DESTINATION}/daily/${DAILY_FILENAME}"
WFILE="${FINAL_DESTINATION}/weekly/${WEEKLY_FILENAME}"
MFILE="${FINAL_DESTINATION}/monthly/${MONTHY_FILENAME}"

# Initialize backup dirs.
mkdir -p "$FINAL_DESTINATION/last/" "$FINAL_DESTINATION/daily/" "$FINAL_DESTINATION/weekly/" "$FINAL_DESTINATION/monthly/"

tar -czf "$FILE" -C "$TMP_DIR" "backup"
BACKUP_SIZE=$(du -sh "$FILE" | cut -f1)
echo -e "${GREEN}OK${NC}   Created ${CYAN}'$FILE'${NC} ($BACKUP_SIZE)"
echo ""

echo "Replacing daily backup ${DFILE} file this last backup..."
ln -vf "${FILE}" "${DFILE}"
echo "Replacing weekly backup ${WFILE} file this last backup..."
ln -vf "${FILE}" "${WFILE}"
echo "Replacing monthly backup ${MFILE} file this last backup..."
ln -vf "${FILE}" "${MFILE}"

# Update latest symlinks
LATEST_LN_ARG=""
if [ "${BACKUP_LATEST_TYPE}" = "symlink" ]; then
    LATEST_LN_ARG="-s"
fi
if [ "${BACKUP_LATEST_TYPE}" = "symlink" -o "${BACKUP_LATEST_TYPE}" = "hardlink"  ]; then
    echo "Point last backup file to this last backup..."
    ln "${LATEST_LN_ARG}" -vf "${LAST_FILENAME}" "${FINAL_DESTINATION}/last/arr_stack_backup-latest${BACKUP_SUFFIX}"
    echo "Point latest daily backup to this last backup..."
    ln "${LATEST_LN_ARG}" -vf "${DAILY_FILENAME}" "${FINAL_DESTINATION}/daily/arr_stack_backup-latest${BACKUP_SUFFIX}"
    echo "Point latest weekly backup to this last backup..."
    ln "${LATEST_LN_ARG}" -vf "${WEEKLY_FILENAME}" "${FINAL_DESTINATION}/weekly/arr_stack_backup-latest${BACKUP_SUFFIX}"
    echo "Point latest monthly backup to this last backup..."
    ln "${LATEST_LN_ARG}" -vf "${MONTHY_FILENAME}" "${FINAL_DESTINATION}/monthly/arr_stack_backup-latest${BACKUP_SUFFIX}"
else # [ "${BACKUP_LATEST_TYPE}" = "none"  ]
    echo "Not updating lastest backup."
fi

#Clean old files
echo "Cleaning older backups for the Arr_Stack_Suite"
find "${FINAL_DESTINATION}/last" -maxdepth 1 -mmin "+${KEEP_MINS}" -name "*--arr_stack_backup${BACKUP_SUFFIX}" -exec rm -rvf '{}' ';'
find "${FINAL_DESTINATION}/daily" -maxdepth 1 -mtime "+${KEEP_DAYS}" -name "*--arr_stack_backup${BACKUP_SUFFIX}" -exec rm -rvf '{}' ';'
find "${FINAL_DESTINATION}/weekly" -maxdepth 1 -mtime "+${KEEP_WEEKS}" -name "*--arr_stack_backup${BACKUP_SUFFIX}" -exec rm -rvf '{}' ';'
find "${FINAL_DESTINATION}/monthly" -maxdepth 1 -mtime "+${KEEP_MONTHS}" -name "*--arr_stack_backup${BACKUP_SUFFIX}" -exec rm -rvf '{}' ';'