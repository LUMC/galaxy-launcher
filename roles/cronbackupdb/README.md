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
backup_user | Name of the backup user | galaxy_backup

###Role vars

Variable | Function | Default
---|---|---
zip_command | The command used to zip files. | "pigz -{{compression_level}} -p {{compression_threads}}"


###Variables that should be fed into the role

Variable | Function
---|---
backup_location | The location where the backups and the logs will be stored 
backupdb_cron_jobs | dictionary with al the settings for the cron jobs

#### backupdb_cron_jobs example

```yaml
backupdb_cron_jobs
  key_with_job_name:
    description: "A single line description of the job"
    timestamp: "-%Y%m%dT%T" # a string that is fed into the date command and that gives the timestamp 
    filename: "backup-filename" # the timestamp and the .gz extension are added to this name"
    files_to_keep: 7 # The number of backups to keep in this job. 
    compression_level: 6 # gzip compression level used. Default is 6
    compression_threads: 4 # Number of threads used for compression. default is 4.
    cron: # Dictionary with settings when cron should run. See ansible's cron module documentation for parameters. Non-specified values are omitted 
      special_time: "daily" 
      weekday: "2"
      hour: 0,12
      minute: 30,45
      day: 1,8,14
      month: *
      
Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
