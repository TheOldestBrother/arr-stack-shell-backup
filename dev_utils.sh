RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

case $1 in
    clean) (cd /srv/arr-suite/backups; find . | xargs rm -rf);;
    test-sudo)
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

        echo $(whoami)
        echo $(sudo whoami)
        ;;
    test-colors)
        # The key is to use the `-e` option for the `echo` command
        echo -e "Test; ${GREEN}Test in green;${NC} Test with no colour"
        echo -e " -- ${RED}ERR${NC}: The red test"
        ;;
esac
