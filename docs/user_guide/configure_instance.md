# Configuring galaxy instance for a vm

On this page you can find all information on configuring the galaxy instance.

## Setting up the galaxy host
1. Set up a (virtual) server running one of the supported distributions. galaxy-launcher is tested on the following distributions:
  * Ubuntu 16.04 LTS
  * CentOS 7.2
2. Set up a passwordless sudo user on the remote host and set up an ssh key pair.
  * NOTE: a passwordless sudo user is required on the remote host to perform rsync synchronization between the ansible-control host and the remote host.
3. Make a new hosts file by copying `hosts.sample` to `hosts` and setup your galaxy host.
4. Create a new configuration directory by copying `host_vars/example_host` to `host_vars/HOSTNAME`. Hostname should be equal to that specified in `hosts`
5. Create a new files directory by copying `files/example_host` to `files/HOSTNAME`

## Configuration locations
In `hosts` the ip address, hostname and remote user of the host can be defined.
Settings files are located in `host_vars/HOSTNAME`. These files are all read by ansible for use as variables. In `files/HOSTNAME` all the files that are transferred to the host are stored.

## Configuring your installation.

Settings files are located in `host_vars/HOSTNAME`. `docker_settings.yml`, `galaxy_settings.yml` and `port_settings.yml` should be checked and if necessary changed.
Also tool lists can be added to install a set of tools.

### docker_settings.yml

Variable | Function
---|---
installdocker_default_location | Where docker stores the images and containers. Use a volume with ample disk space.
galaxy_docker_docker_image | The docker image. Defaults to "bgruening/galaxy-stable:latest" but it's better to tag it with a version number. (i.e. 17.09)
docker_user | a user that will be created without sudo rights on the remote machine.
galaxy_docker_container_name | What name the container gets for easy access using docker commands. Default is "galaxy".

### galaxy_settings.yml

Variable | Function
---|---
galaxy_admin_user | e-mail address of the admin user. This variable is obligatory
galaxy_master_api_key | The master api key. Always set this value to something unique.
galaxy_brand | The galaxy brand name
galaxy_report_user | The user to access the reports section.
galaxy_report_password | The password to access the reports section.
galaxy_docker_optional_environment_settings | This is a YAML dictionary that takes any docker environment values. See the documentation of [bgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) which options are available.

### web_settings.yml

Variable | Function
---|---
galaxy_docker_web_urls | Nginx reroutes traffic coming from these urls to the galaxy server. You should put the registered domain name here.
max_upload_size | The maximum sizes of files that can be uploaded.
galaxy_docker_web_port_public | default 80. The web port for the nginx server.
galaxy_docker_web_port | default 8080. This port is only exposed to localhost and not accessible from the web.
galaxy_docker_ftp_port | By default this variable is not set and port is unaccessible. This port is only exposed to localhost and not accessible from the web.
galaxy_docker_sftp_port | By default this variable is not set and port is unaccessible. This port is only exposed to localhost and not accessible from the web.

It is not recommended to touch the nginx settings unless you are familiar with configuring [ansible-role-nginx](https://github.com/jdauphant/ansible-role-nginx).

### backup_settings.yml

galaxy_docker_backup_location: "backup/location/path"

galaxy_docker_backup_rsync_remote_host: True          # Enables or disables rsyncing all the backups to a remote host.

```YAML

galaxy_docker_backup_database_cron_jobs:  
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
galaxy_docker_backup_database_rsync_settings:  
  dest: "/destination/path/on/remote/host"   
  host: "example.host.org"
  user: "user" # The user that is connected to. This key can be ommited
  delete: True # Remove backups on the remote server if they are removed on the galaxy server. True is recommended.
  compression_level: 0 # Can range from 0-9. Rsync compresses the data before transmission to save bandwith*
  cron:  How often the rsync to the remote host should be performed. Hourly is recommended.
    special_time: hourly #

 #* 0 is recommended because the archives are already compressed
```
### Personalization (optional)

See [bgruening/docker-galaxy-stable documentation](https://github.com/bgruening/docker-galaxy-stable#Personalize-your-Galaxy).

Welcome files can be placed in `files\HOSTNAME\welcome`. This path can be changed in `files_settings.yml`.

### Extra tools (optional)

Tool lists can be added to `files/HOSTNAME/tools`. To change this directory change `galaxy_docker_tool_list_dir` in `files_settings.yml`
An example tool list can be found in `files/example_host/tools`.
If no tool lists are present, this step will be automatically skipped. Only .yml and .yaml files are copied to the server.

### Adding reference genomes (optional)

1. Add reference genomes to be copied to the server (see below)
2. Specify which data managers to run (see below)
3. Make sure data managers specified are installed (see [Extra tools](#extra-tools-optional) section)
4. Create an admin api key by logging in as the admin user and creating an API key.
Because an admin api key is needed, this task cannot be completed during the `run=install` step.
5. [Run the installgenomes task](#install-genomes-on-the-galaxy-instance).
Reference genomes can be added to `files/HOSTNAME/genomes`. To change this directory change `genome_dir` in `files_settings.yml`.  
The genomes are copied to the server using rsync. Ownership information will not be kept and genomes will be world-readable.

In order to install the genomes a YAML file specifying the data managers that
should be run should be placed in `files/HOSTNAME/dbkeys`. An example is included
as `run-data-managers.yaml.sample`. Only .yml and .yaml files are copied to the server.

### Configuring LDAP (optional)

Add a  GALAXY_CONFIG_AUTH_CONFIG_FILE key to `galaxy_docker_optional_environment_settings` in `host_vars/HOSTNAME/galaxy_settings.yml` :
```
galaxy_docker_optional_environment_settings:
  GALAXY_CONFIG_AUTH_CONFIG_FILE: "config/auth_conf.xml"
```

In `host_vars/HOSTNAME/ldap_settings.yml`
set the following keys in galaxy_docker_ldap_settings:
#### Keys required

Key | Function
---|---
server | The ldap server. (ldap://ad.example.com)
search_base | example: dc=ad,dc=example,dc=com
search_user | example: ldapsearch
search_password | ldapsearch's password

#### Default keys (can optionally be changed)

Key | Function | Default
---|---|---
login_use_username | Whether username is used. If `False` e-mail is used | True
allow_password_change | Whether users can change their password | False
allow_register | Whether users can register their own accounts. This bypasses ldap authentication. | False
auto_register | Users are automatically registered at first succesfull authentication to the LDAP server | True
continue_on_failure |  login despite authentication module failures | False
email_suffix | The e-mail - suffix  (@example.com). All users with such an address will be passed to the ldap server. If "" all users will be passed to the ldap server | ""

#### Example
```YAML
galaxy_docker_ldap_settings:
  server: "ldap://dc1.example.com"
  search_base: "dc=dc1,dc=example,dc=com"
  search_user: "ldapsearch"
  search_password: "supersecret" #ldapsearch's password
  login_use_username: False
  email_suffix: "@example.com"
```

### Database (optional)

If you wish to use a postgresql database of another galaxy instance, make a dump of the instance.
Put the dump file in `files/HOSTNAME/database_import`. Alternatively you can specify the location by changing `galaxy_docker_import_db_dir` in `files_settings.yml`
If no database is added, a new empty DB will be created.
