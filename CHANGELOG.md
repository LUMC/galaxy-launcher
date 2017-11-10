# Changelog

<this file should be updated with newest changes on top>

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
