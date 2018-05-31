# Changelog
<this file should be updated with newest changes on top>

## Current development branch
* Fixed bug where galaxy_ext library could not be found when using SGE cluster
* Fixed bug in the cron backup scripts.
Now the userID is used to identify the backup user in the container.
* Ephemeris default version upgraded to 0.8
* Update virtual environment when using a cluster virtual environment and upgrading to
a new version of galaxy.
* Allow_password_change is enabled by default on ldap-authenticated galaxies. This only affects the
ability to login to the sftp server.
* Updated default bgruening/galaxy-stable image to 18.05

## Release 1.0.0
The first release of galaxy-launcher. Features include:

* Complete deployment of a galaxy instance with just two commands.
* Configuration in easy to understand yaml files.
* Use the example host files to quickly get started
* Use the cluster example host to get the image running on your cluster
* Install prerequisites including docker on a Ubuntu or CentOS server
* Automatic provisioning
* The galaxy docker container is restarted on reboot of the system
* Running the deployment script as a non-privileged user (root required for prerequisites script)

Important changes during development up to first release:
* Changed name from galaxy-docker-ansible to galaxy-launcher
* Changed license from a custom license to MIT (expat) License
* Restructured galaxy-docker-role to concentrate all tasks requiring
root in one part of the role.
* Enabled the use of galaxy-docker-ansible for a VM connected to a cluster.
