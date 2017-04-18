# galaxy-docker-ansible

This project contains the roles needed to install bjgruening/galaxy-docker-stable image on an 
ubuntu server.

## Getting started
1. Clone the repository to your local computer.
2. [Set up ansible](http://docs.ansible.com/ansible/intro_installation.html)
  * Ansible version 2.2 is tested and required.
3. Set up a passwordless sudo user on the remote host and set up an ssh key pair.
  * NOTE: a passwordless sudo user is required on the remote host to perform the database operations with ansible
4. Make a new hosts file by copying `hosts.sample` to `hosts` and setup your galaxy host.
5. Create a new configuration directory by copying `host_vars/example_host` to `host_vars/HOSTNAME`. Hostname should be equal to that specified in `hosts`
6. Create a new files directory by copying `files/example_host` to `files/HOSTNAME`
 
## Configuring your installation.
Settings files are located in `host_vars/HOSTNAME`. `docker.settings`, `galaxy.settings` and `port.settings` should be checked and if necessary changed.
Also tool lists can be added to install a set of tools.

### docker.settings
Variable | Function
---|---
docker_default_location | Where docker stores the images and containers. Use a volume with ample disk space.
docker_image | The docker image. Defaults to "bgruening/galaxy-stable:latest" but it's better to tag it with a version number. (i.e. 17.01)
docker_user | a user that will be created without sudo rights on the remote machine.
docker_container_name | What name the container gets for easy access using docker commands. Default is "galaxy".

### galaxy.settings
Variable | Function
---|---
galaxy_admin_user | e-mail address of the admin user. This variable is obligatory
galaxy_master_api_key | The master api key. Always set this value to something unique.
galaxy_brand | The galaxy brand name
optional_environment_settings | This is a YAML dictionary that takes any docker environment values. See the documentation of [bjgruening/galaxy-stable](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) which options are available.

### port.settings
Variable | Function
---|---
galaxy_web_port | default 80
galaxy_ftp_port | default 8021
galaxy_sftp_port | default 8022
ufw_profile | Firewall access is managed by a ufw profile to prevent the firewall to clog up with orphaned rules. Default ufw_profile name is "galaxy"

### backup.settings
backup_location: "backup/location/path"
backup_user: "galaxy_backup_user"
backup_rsync_remote_host: True          # Enables or disables rsyncing all the backups to a remote host.

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
    special_time: hourly #

 #* 0 is recommended because the archives are already compressed

```
### Tools
Tool lists can be added to `files/HOSTNAME/tools`. To change this directory change `tool_list_dir` in `files.settings`
An example tool list can be found in `files/example_host/tools`.
If no tool lists are present, this step will be automatically skipped.

### Database
If you wish to use a postgresql database of another galaxy instance, make a dump of the instance.
Put the dump file in `files/HOSTNAME/insert_db`. Alternatively you can specify the location by changing `insert_db_dir` in `files.settings`
If no database is added, a new empty DB will be created.

## Starting a galaxy instance on a remote machine.

To install docker, fetch the image, run it, add the database and install all the tools run:

```bash
ansible-playbook main.yml -e "hosts=HOSTNAME run=install"   
```

Alternatively you can set up your machine step by step.

### Install docker on the remote machine
```bash
ansible-playbook main.yml -e "hosts=HOSTNAME run=installdocker"   
```

### Run the galaxy docker image
```bash 
ansible-playbook main.yml -e "hosts=HOSTNAME run=rundockergalaxy"   
```

### Install tool lists on the galaxy instance
```bash
ansible-playbook main.yml -e "hosts=HOSTNAME run=installtools"   
```

## Testing a new version of the image.

If bjgruening updates the docker image to a newer version than this can be tested as follows:
1. Open the `host_vars/HOSTNAME/upgrade.settings` file
2. Set the settings for the test instance in the test_upgrade dictionary. Make sure the port mappings don't overlap with the running instance. Additional settings can be added to the dictionary.
3. Run `ansible-playbook main.yml -e "hosts=HOSTNAME run=testupgrade"`
4. Check if the galaxy instance is running properly and if history is kept.
(Tools won't run and data will not be included)
5. Settings are stored in `/export/galaxy-central/config`, any new config files are automatically copied to this directory if these do not yet exist.
Existing files are not replaced. To check for any new features you can diff `/export/.distribution_config` and `/export/galaxy-central/config`

To remove the upgrade test instance run:
```bash
ansible-playbook main.yml -e "hosts=HOSTNAME run=deletetestupgrade"
```

## Upgrade the running instance to a new image
1. Make sure there are no jobs running on your instance. As an admin you can hold all new jobs so they will wait until the image is upgraded.
2. Update the version tag of docker_image in `host_vars\HOSTNAME\docker.settings`
3. run `ansible-playbook main.yml -e "hosts=HOSTNAME run=upgrade"`

There is a setting overwrite_config_files in migrate.settings. Default is False. 
If set to True this will overwrite all your config files with the .distribution_config files.

## Backing up the database
This extracts the database of the running instance to `files/HOSTNAME/backupdb`. 
This path can be changed in `files.settings`. If you want to change the filename of the backup you can add 
`backup_db_filename: yourprefferedfilename` to `files.settings`

To backup the database run:

```
ansible-playbook main.yml -e "hosts=HOSTNAME run=extractdb"
```

## Backing up your export folder
For backing up your export folder use `ansible-playbook main.yml -e "hosts=HOSTNAME run=backupgalaxy`
This role is not very extensive and may need extension based upon your needs.

Settings are in the `host_vars/HOSTNAME/backup.settings` file

Variable | Function
---|---
method | Can be set to rsync or archive. Rsync is useful for hourly or daily backups. Archive stores an archive but does not allow incremental backups
backup_location | Absolute path to the location. If a remote location is chosen use the following syntax user@host::dest. Remote locations can only be chosen when the method is rsync
prefix, backup_name, postfix | set the filename
remote_backup | set to True if a remote location is chosen
rsync_compression_level | Compression level to limit the bandwith used when a backup is made on a remote location
compression_format | Can be 'gz,' 'zip' or 'bz2'. Only when method=archive

The archive method is only functional as of ansible 2.3. Therefore the archive function is still commented out in the tasks/main.yml file.
It can be enabled when ansible 2.3 is released as stable.

## Removing the galaxy docker instance.
`ansible-playbook main.yml -e "hosts=HOSTNAME run=deletegalaxy` does the following things:
+ deletes the container
+ removes the firewall exception and removes the profile
+ removes the cron jobs 

If `delete_files=True` is added then it will also delete the export folder 
If `delete_backup_files=True` is added then it will also delete the backup folder.

