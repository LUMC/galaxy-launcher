# galaxy-docker-ansible

This project contains the roles needed to install bjgruening/galaxy-docker-stable image on an 
ubuntu server.

## Getting started
1. Clone the repository to your local computer.
2. [Set up ansible](http://docs.ansible.com/ansible/intro_installation.html)
3. Configure your galaxy host in /etc/ansible/hosts
4. Set up a passwordless sudo user on the remote host and set up an ssh key pair.
5. Document 3 and 4 in hosts.config.

## Configuring your installation.
There are numerous settings in galaxydocker.config that need to be set in order to get a working installation:

Variable | Function
---|---
docker_default_location | Where docker stores the images and containers. Use a volume with ample disk space.
docker_image | The docker image. Defaults to "bgruening/galaxy-stable:latest" but it's better to tag it with a version number. (i.e. 17.01)
docker_user | a user that will be created without sudo rights on the remote machine.
docker_container_name | What name the container gets for easy access using docker commands. Default is "galaxy".
ufw_profile | Firewall access is managed by a ufw profile to prevent the firewall to clog up with orphaned rules. Default ufw_profile name is "galaxy"
galaxy_web_port | default 80
galaxy_ftp_port | default 8021
galaxy_sftp_port | default 8022
tool_list_dir | A directory containing YAML tool lists to be used by the ephemeris installer
galaxy_admin_user | e-mail address of the admin user. This variable is obligatory
galaxy_master_api_key | The master api key. Always set this valueto something unique.
galaxy_brand | The galaxy brand name
optional_environment_settings | This is a YAML dictionary that takes any docker environment values. See the documentation of [bjgruening/galaxy-stable](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md) which options are available.

## Starting a galaxy instance on a remote machine.

To install docker, fetch the image, run it and install all the tools run:

'''bash
ansible-playbook main.yml
'''

If you did not set up passwordless sudo you can add the -K parameter and type in the sudo password.


Alternatively you can set up your machine step by step.

### Install docker on the remote machine
'''bash
ansible-playbook installdocker.yml
'''

### Run the galaxy docker image
'''bash 
ansible-playbook rundockergalaxy.yml
'''

### Install tool lists on the galaxy instance
'''bash
ansible-playbook installtools.yml
'''

The tool lists need to be in the directory specified in tool_list_dir in galaxydocker.config.
Example tool lists can be found at [the galaxy project's github](https://github.com/galaxyproject/ansible-galaxy-tools/blob/master/files/tool_list.yaml.sample)

## Testing a new version of the image.

If bjgruening updates the docker image to a newer version than this can be tested as follows:
1. Update testmigrate.config to the newest image version.
2. Make sure the port mappings don't overlap with the running instance.
3. Run 'ansible-playbook testmigrate.yml'
4. Check if the galaxy instance is running properly and if history is kept.
(Tools won't run and data will not be included)
5. Settings are stored in /export/galaxy-central/config, any new config files are automatically copied to this directory if these do not yet exist.
Existing files are not replaced. To check for any new features you can diff /export/.distribution_config and /export/galaxy-central/config

## Migrating the running instance to a new image
1. Make sure there are no jobs running on your instance. As an admin you can hold all new jobs so they will wait until the image is upgraded.
2. Update the version tag of docker_image in galaxydocker.config
3. run 'ansible-playbook migrate.yml'
4. If there are changes in the distribution config that you like incorporate them and restart the image by running 'ansible-playbook rundockergalaxy.yml'

There is a setting overwrite_config_files in galaxydocker.config. Default is False. 
If set to True this will overwrite all your config files with the .distribution_config files.

## Backing up your export folder
For backing up your export folder use 'ansible-playbook backupgalaxy.yml'
This role is not very extensive and may need extension based upon your needs.

Settings are in the galaxydocker.config file
Variable | Function
---|---
method | Can be set to rsync or archive. Rsync is useful for hourly or daily backups. Archive stores an archive but does not allow incremental backups
backup_location | Absolute path to the location. If a remote location is chosen use the following syntax user@host::dest. Remote locations can only be chosen when the method is rsync
prefix, backup_name, postfix | set the filename
remote_backup | set to True if a remote location is chosen
rsync_compression_level | Compression level to limit the bandwith used when a backup is made on a remote location
compression_format| Can be 'gz,' 'zip' or 'bz2'. Only when method=archive

The archive method is only functional as of ansible 2.3. Therefore the archive function is still commented out in the tasks/main.yml file.
It can be enabled when ansible 2.3 is released as stable.

## Removing the galaxy docker instance.
'ansible-playbook deletegalaxy.yml' deletes your galaxy instance. It can also be used
to delete the testmigration instance. To do so, edit 'deletegalaxy.yml' and change
galaxydocker.config in testmigrate.config.


