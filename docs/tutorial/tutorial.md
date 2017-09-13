# Tutorial

## Prerequisites

* A computer running GNU/Linux
* install [Vagrant](https://www.vagrantup.com/)
* install [VirtualBox](https://www.virtualbox.org/)
* Set up the prerequisites as described in the [installation chapter](../user_guide/installation.md).

## Create a host to test on
1. go to the galaxy-docker-ansible repository
2. go to `test/vagrant/ubuntu-16.04`
3. Type `vagrant up`
4. go to the galaxy-docker-ansible repository
5. copy the `hosts.sample` file to host

Exercise: Set up your own hosts file. Use `test/hosts` as an example.

6. Check if you can reach the host by `ansible -m ping HOSTNAME` (insert your own hostname here)

## Create the settings files for your host.
1. copy `files/example_host` to `files/HOSTNAME`
2. copy `host_vars/example_host` to `host_vars/HOSTNAME`
3. Uncomment the commented out variables in `host_vars/HOSTNAME/galaxy.settings` and change them to your preferred settings.
4. Use the guide on [Björn Grünings page](https://github.com/bgruening/docker-galaxy-stable#Galaxys-config-settings) to add some settings to your galaxy that you like in `galaxy_docker_optional_environment_settings`.
5. Change the version of the docker image to 17.05 or whatever version you like in `host_vars/HOSTNAME/docker.settings`
6. Install the prerequisites on your test vm by running `ansible-playbook main.yml -e "host=HOSTNAME run=install_prerequisites"`.
7. Install galaxy on your test VM by running `ansible-playbook main.yml -e "host=HOSTNAME run=install_galaxy"`.
8. Galaxy should now be accessible on [localhost:8081](http://localhost:8081)

## Provision your galaxy

### Tools