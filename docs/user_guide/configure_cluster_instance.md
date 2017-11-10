# Configuring galaxy instance on a vm connected to a cluster

Configuring a cluster instance is similar to installing galaxy on a vm in the cloud, but requires some tricks to make it work.

## Setting the cluster type
In `host_vars/cluster_example_host/cluster.settings` set your cluster type with `galaxy_docker_cluster_type`. Currently only `sge` is supported, but the ansible role can be very easily expanded to other clusters. Open an issue or create a pull request on

## Integrating with the user management system on the cluster.
Docker containers can be run by root and users in the docker group. Docker has root rights by default and this manifests to the mounted filesystems. The UIDs in the docker container are used to create the files on the mounted filesystem and these probably do not match with users on the cluster.

Also, the job is submitted with the name and uid of the main galaxy user. Your cluster may not accept jobs from unknown user. And the user needs access to the files on the cluster.

In `host_vars/cluster_example_host/cluster_settings.yml` there is a section on how to set UIDs and names to already existing users on your cluster. In this way you can use service accounts on your cluster to run galaxy.

In order to do this galaxy-launcher has to build a custom image with the right UIDs. You can set the base version of this image by using the `bgruening_galaxy_stable_version` variable.

## Setting up ssh key pairs for galaxy users
galaxy-launcher uses three users to run the playbook
* `galaxy_docker_docker_user` which runs the docker container.
* `galaxy_docker_web_user` which runs the web application and submits jobs to the cluster
* `galaxy_docker_database_user` which manipulates the database

When the playbook is run on the vm with a user that has sudo rights, the playbook will use sudo to switch users.

There is also an option to run without sudo. To do this ssh key pairs need to be set up for all three users. The path to the private keys can be set by `galaxy_docker_web_user_private_key`, `galaxy_docker_docker_user_private_key` and `galaxy_docker_database_user_private_key`.

## Integrating with the filesystem
There are certain quirks to using the galaxy-stable image on a cluster. Internally most paths route to either `/export` and `/galaxy-central` these paths do not exist on the cluster.

In `host_vars/cluster_example_host/cluster_settings.yml` you can see the `galaxy_docker_shared_cluster_directory` variable. This one is automatically mounted to the galaxy docker container if it is set.
In `host_vars/cluster_example_host/galaxy_settings.yml` you can see that paths are set relative to this directory or to `galaxy_docker_export_location` which is itself set relative to `galaxy_docker_shared_cluster_directory` in `docker_settings.yml`.

By using this configuration the galaxy main process will look for its files on the cluster file system instead of using `/export`. This is essential for running jobs on a cluster.

## Further integration
The `galaxy_docker_extra_volumes` variable allows you to mount extra volumes to your container.

The `galaxy_docker_extra_ports` variable allows you to open extra ports on your container.

The `galaxy_docker_custom_image_lines` variable allows you to add extra lines to the docker file before the custom image for your cluster is build. You can add lines such as `RUN apt get install sssd` or `ADD sssd.conf /etc/sssd/sssd.conf`. You can add files to
`files/HOSTNAME/docker_custom_image` if you want to use this functionality.
