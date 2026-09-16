Backup the Arr suite spawned from a singular `docker-compose` file with all the configs stored in the same `config/<individual-arr-app>`. It is rather specific but it will get better with time.


# Usage 

First you need to rename the `example.env.sh`

```bash
mv example.env.sh env.sh
```

Then you need to set the environment variables to best suit your case, knowing that `SOURCE_PATH` is required for the program to work.

Ensure you make the main script file executable :
```bash
# Might need `sudo` for this command to work
chmod +x ./backup.sh ./init/sh
```

Finally you just need to execute the program like so :
```bash
./init.sh
```

You'll be prompted for your sudo password as it is needed to ensure the read and write permissions for the destination of the backups.

### How the backups folder works ?

You can read more about it in [Pau RE/prodrigestivill](https://github.com/prodrigestivill)'s repo : [docker-postgres-backup-local](https://github.com/prodrigestivill/docker-postgres-backup-locals#how-the-backups-folder-work)


### How to restore ? 

I'll get to it when I need it.

# Acknowledgments

* This shell script is heavily based on [prodrigestivill/docker-postgres-backup-local](https://github.com/prodrigestivill/docker-postgres-backup-local) for it's brilliant periodic rotating backup.