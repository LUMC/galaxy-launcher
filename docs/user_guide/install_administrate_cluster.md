# Install and administer a galaxy instance connected to a cluster

This is the same as managing it on a vm that is not connected to a cluster. Except that some cluster settings need to be templated out to galaxy and you may not want to run the playbook as a sudo user on the remote host.

Check out the `cluster.settings` example for cluster settings examples.

## Root required parts
### Install docker and required packages on the remote machine
This does not create the users. As it assumes that the users are already present on the cluster.
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_cluster_prerequisites"   
```
If you want to create the users, and want to create the ssh_key_pairs so you do not need to run as a sudo user:
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_prerequisites galaxy_docker_create_user_ssh_keys=True"   
```

## Root not required
All the management steps that are described in the administration of a vm run without root rights.
To install galaxy on a cluster without using a sudo user:
```bash
ansible-playbook main.yml -e "host=HOSTNAME run=install_galaxy_cluster galaxy_docker_run_privileged=False"   
```
