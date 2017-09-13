# Install and administer a galaxy instance.

This page contains the commands needed to run and administrate a galaxy instance.

## Set up the docker container with one command

To install docker, fetch the image, run it, add the database install all the tools, and set automatic backup of the database run:

```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_complete"   
```
If you also want to activate ldap:
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=['install_complete','enable_ldap']"  
```
Alternatively you can set up your machine step by step.

## Set up the docker container step by step

### Install docker and required packages on the remote machine
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_prerequisites"   
```

### Provision galaxy and template all settings files
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_galaxy"   
```
### (Re)start your galaxy instance
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=start_container"   
```
With ldap:
ansible-playbook main.yml -e "host=HOSTNAME run=['start_container','enable_ldap']

### Install tool lists on the galaxy instance
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_tools"   
```

### Install genomes on the galaxy instance
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_genomes galaxy_admin_api_key=YOURADMINAPIKEY" #This is not equal to the master api key   
```

### Install LDAP
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=enable_ldap"   
```
!WARNING! This will restart the galaxy instance within the container

## Testing a new version of the image.

If bgruening updates the docker image to a newer version than this can be tested as follows:
1. Open the `host_vars/HOSTNAME/upgrade.settings` file
2. Set the settings for the test instance in the galaxy_docker_upgrade_test_settings dictionary. Make sure the port mappings don't overlap with the running instance. Additional settings can be added to the dictionary.
3. Run `ansible-playbook main.yml -e "host=HOSTNAME run=['install_prerequisites','upgrade_test']"` (install prerequisites opens the firewall for the test upgrade instance)
4. Check if the galaxy instance is running properly and if history is kept.
(Tools won't run and data will not be included)
5. Settings are stored in `/export/galaxy-central/config`, any new config files are automatically copied to this directory if these do not yet exist.
Existing files are not replaced. To check for any new features you can diff `/export/.distribution_config` and `/export/galaxy-central/config`

To remove the upgrade test instance run:
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=delete_upgrade_test"
```

## Upgrade the running instance to a new image

1. Make sure there are no jobs running on your instance. As an admin you can hold all new jobs so they will wait until the image is upgraded.
2. Update the version tag of galaxy_docker_docker_image in `host_vars\HOSTNAME\docker.settings`
3. run `ansible-playbook main.yml -e "host=HOSTNAME run=upgrade"`

There is a setting galaxy_docker_upgrade_overwrite_config_files in migrate.settings. Default is False.
If set to True this will overwrite all your config files with the .distribution_config files.

## Backing up the database

This extracts the database of the running instance to `files/HOSTNAME/backupdb`.
This path can be changed in `files.settings`. If you want to change the filename of the backup you can add
`galaxy_docker_extracted_db_filename: yourprefferedfilename` to `files.settings`

To backup the database run:

```
ansible-playbook main.yml -e "host=HOSTNAME run=extract_database"
```

## Removing the galaxy docker instance.

`ansible-playbook main.yml -e "host=HOSTNAME run=delete_galaxy` does the following things:
+ deletes the container
+ removes the firewall exception and removes the profile
+ removes the cron jobs

If `galaxy_docker_delete_files=True` is added then it will also delete the export folder
If `galaxy_docker_delete_backup_files=True` is added then it will also delete the backup folder.
