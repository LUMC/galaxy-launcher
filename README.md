Role Name
=========

A role that installs a galaxy instance using a container.

Requirements
------------

The jdauphant.nginx role is required. Please use `ansible-galaxy install jdauphant.nginx` to install this role.


Role Variables
--------------

### Defaults

Variable | Function | Default
---|---|---
container_postgres_user | The uid of the postgres user used in the container | 1550
container_database_name | The name of the database in the container | galaxy
docker_image |The docker image that is used | bgruening/galaxy-stable.
docker_user | The user without sudo rights that runs the container. | galaxy
db_export_location | the folder within the /export/ location where the db is dumped to | postgresql 
docker_environment_file_location | where the environment file is stored on the host
docker_container_name | The name of the running container | galaxy
backup_db_file | The name of the dump file. This is a temporary file | "galaxydb_backup-$(TZ='UTC' date + '%Z%Y%m%dT%H%M%S')"
cronbackupdb_log_timestamp | This is a date command for the timestamp. | "TZ='UTC' date + '%Z %F %T >'"
backup_user | Name of the backup user | galaxy_backup
backup_rsync_remote_host| Whether the backups should be synced to a remote host| False
galaxy_user_in_container | the UID of the galaxy user in the container | 1450
welcome_dir | the directory containing the welcome files. | {{playbook_dir}}/ files/{{inventory_hostname}}/welcome.html
docker_default_location | Where the docker images are stored and run | /var/lib/docker
galaxy_web_port | The port on which galaxy will be exposed to localhost. |8080
public_galaxy_web_port | The port on which galaxy will be hosted. |80

### Role vars

Variable | Function | Default
---|---|---
zip_command | The command used to zip files. | "pigz -{{compression_level}} -p {{compression_threads}}"

### User defined vars
These variables should be defined by the user.

Variable | Function
---|---
docker_container_name | The name of the docker container
docker_export_location | The export location for the galaxy container
backup_location | The location where the backups and the logs will be stored 
backupdb_cron_jobs | dictionary with al the settings for the cron jobs
galaxy_web_urls | Nginx reroutes traffic coming from these urls to the galaxy server. You should put the registered domain name here.
max_upload_size | The maximum sizes of files that can be uploaded.
public_galaxy_web_port | default 80. The web port for the nginx server.
galaxy_web_port | default 8080. This port is only exposed to localhost and not accessible from the web.
galaxy_ftp_port | By default this variable is not set and port is unaccessible. This port is only exposed to localhost and not accessible from the web.
galaxy_sftp_port | By default this variable is not set and port is unaccessible. This port is only exposed to localhost and not accessible from the web.
galaxy_admin_user | e-mail address of the admin user. This variable is obligatory
galaxy_master_api_key | The master api key. Always set this value to something unique.
galaxy_brand | The galaxy brand name
galaxy_report_user | The user to access the reports section.
galaxy_report_password | The password to access the reports section. 
optional_environment_settings | This is a YAML dictionary that takes any docker environment values. See the documentation of [bjgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) which options are available.

### Examples for dictionary variables
```YAML
backupdb_cron_jobs:  
  daily: # The key is the "name" of the cron job  
    description: "Description of the cron job"  
    timestamp: "-%Z%Y%m%dT%H%M%S" # Timestamp uses the "date" function. Check date --help on how to use the timestamp  
    filename: "galaxy-hourly-backup" # Archives are stored as filename.timestamp.gz  
    files_to_keep: 7 # How many backups of this job should be kept. Since this jobs runs daily, one week of backups is kept  
    compression_level: 6 # Compression uses pigz. 6 is the default level.Level should be 1-9  
    compression_threads: 4 # The number of threads pigz should use to compress the data  
    cron: # This is a dictionary that uses the same values as the ansible cron module(http://docs.ansible.com/ansible/cron_module.html)   
      special_time: "daily"  
  two_weekly_example:  
    description: "Two-weekly backup of the galaxy database"  
    timestamp: "-%Z%Y%m%dT%H%M"  
    filename: "galaxy-fortnight-backup"  
    files_to_keep: 6  
    compression_level: 6  
    compression_threads: 4  
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

```YAML
ldap_settings:
  server: "ldap://dc1.example.com"
  search_base: "dc=dc1,dc=example,dc=com"
  search_user: "ldapsearch"
  search_password: "supersecret" #ldapsearch's password
  login_use_username: False
  email_suffix: "@example.com"
```

Dependencies
------------

jdauphant.nginx should be installed before running this role. It is not a role dependency, since this galaxy_docker feeds information into the nginx role.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```YAML
- hosts: servers
   vars:
   	galaxy_brand: "my awesome galaxy brand"
   	 
   roles:
         - { role: galaxydocker, installdocker: True,  nginxsettings: True, ansible_role_nginx: True, galaxyfirewall: True, rundockergalaxy: True, installtools: True}
```
License
-------

Copyright 2017 Sequence Analysis Support Core - Leiden University Medical Center


Author Information
------------------
Contact us at: sasc@lumc.nl
