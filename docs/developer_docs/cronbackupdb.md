cronbackupdb
=========

This role creates the following things on the host:
- a backup user
- a backup location
- backup scripts
- crontab entries for the backup user that call the backup scripts.

Requirements
------------

This role depends on the galaxy instance properly set up using the galaxy-docker-ansible
scripts.

Role Variables
--------------

###Defaults

Variable | Function | Default
---|---|---
container_postgres_user | The uid of the postgres user used in the container | 1550
container_database_name | The name of the database in the container | galaxy
db_export_location | the folder within the /export/ location where the db is dumped to | postgresql
backup_db_file | The name of the dump file. This is a temporary file | "galaxydb_backup-$(TZ='UTC' date + '%Z%Y%m%dT%H%M%S')"
cronbackupdb_log_timestamp | This is a date command for the timestamp. | "TZ='UTC' date + '%Z %F %T >'"
backup_rsync_remote_host| Whether the backups should be synced to a remote host| False

###Variables that should be fed into the role

Variable | Function
---|---
galaxy_docker_backup_location | The location where the backups and the logs will be stored
backupdb_cron_jobs | dictionary with al the settings for the cron jobs


#### backupdb_cron_jobs example

```YAML
backupdb_cron_jobs:  
  daily: # The key is the "name" of the cron job  
    description: "Description of the cron job"  
    timestamp: "-%Z%Y%m%dT%H%M%S" # Timestamp uses the "date" function. Check date --help on how to use the timestamp  
    filename: "galaxy-hourly-backup" # Archives are stored as filename.timestamp.gz  
    files_to_keep: 7 # How many backups of this job should be kept. Since this jobs runs daily, one week of backups is kept  
    compression_level: 6 # Compression uses gzip. 6 is the default level.Level should be 1-9  
    cron: # This is a dictionary that uses the same values as the ansible cron module(http://docs.ansible.com/ansible/cron_module.html)   
      special_time: "daily"  
  two_weekly_example:  
    description: "Two-weekly backup of the galaxy database"  
    timestamp: "-%Z%Y%m%dT%H%M"  
    filename: "galaxy-fortnight-backup"  
    files_to_keep: 6  
    compression_level: 6  
    cron:
      month: *
      day: 1,15
      hour: 3
```
```YAML
rsync_settings:  
  dest: "/destination/path/on/remote/host"   
  host: "example.host.org"
  user: "user" # The user that is connected to. This key can be ommited
  delete: True # Remove backups on the remote server if they are removed on the galaxy server. True is recommended.
  compression_level: 0 # Can range from 0-9. Rsync compresses the data before transmission to save bandwith*
  cron:  How often the rsync to the remote host should be performed. Hourly is recommended.
    special_time: hourly

 #* 0 is recommended because the archives are already compressed

```

#### Common galaxy-docker-ansible variables
Variable | Function
---|---
docker_container_name | The name of the docker container
docker_export_location | The export location for the galaxy container




Author Information
------------------

Copyright 2017 Sequencing Analysis Support Core - Leiden University Medical Center
Contact us at: sasc@lumc.nl
