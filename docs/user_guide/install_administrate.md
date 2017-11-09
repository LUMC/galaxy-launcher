# Install and administer a galaxy instance.

## Installation

### Install docker and required packages on the remote machine
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_prerequisites"   
```

### Provision galaxy, template all settings files and start the instance
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_galaxy"   
```

To start with ldap support:
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=['install_galaxy','enable_ldap']"   
```
## Administration

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
1. Open the `host_vars/HOSTNAME/upgrade_settings.yml` file
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
2. Update the version tag of galaxy_docker_docker_image in `host_vars\HOSTNAME\docker_settings.yml`
3. run `ansible-playbook main.yml -e "host=HOSTNAME run=upgrade"`

If you are running a custom image you should run `upgrade_custom_image.`

There is a setting galaxy_docker_upgrade_overwrite_config_files in migrate_settings.yml. Default is False.
If set to True this will overwrite all your config files with the .distribution_config files.

## The latest galaxy security patches
Make sure you are subscribed to the [galaxy public server mailing list](https://galaxyproject.org/public-galaxy-servers/)
to receive information on the latest security patches.

When you received a notice on a security patch take the following steps to patch your galaxy instance:
1. Check the [galaxy branches page](https://github.com/galaxyproject/galaxy/branches)
to see if the version of galaxy you are using has been updated with the patch.
2. Check the [build page](https://hub.docker.com/r/bgruening/galaxy-stable/builds/)
of the galaxy docker image to check if your version has been built after the latest patch.
3.
  * run `ansible-playbook main.yml -e "host=HOSTNAME run=patch_image"` to patch.
  * run `ansible-playbook main.yml -e "host=HOSTNAME run=patch_custom_image"` if you are running a custom image. If you change the UUIDs as well you can skip step 2 since you are building the image yourself.

## Backing up the database

This extracts the database of the running instance to `files/HOSTNAME/backupdb`.
This path can be changed in `files_settings.yml`. If you want to change the filename of the backup you can add
`galaxy_docker_extracted_db_filename: yourprefferedfilename` to `files_settings.yml`

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
