# variables for coloring output.
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'


TMP_DIR=$(mktemp -d)
SOURCE_PATH="<EDIT-THIS-SOURCE-PATH>" # Path to the docker-file where all your files are located.
FINAL_DESTINATION="/srv/arr-suite/backups" # Final destination where backups while reside.

BACKUP_SUFFIX=".tar.gz" # Suffix of the compressed result of the backup.
BACKUP_LATEST_TYPE="symlink" # 'symlink' | 'none'

BACKUP_KEEP_MINUTES=1440
BACKUP_KEEP_DAYS=7
BACKUP_KEEP_WEEKS=4
BACKUP_KEEP_MONTHS=6

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT