#!/bin/bash
set -eu -o pipefail

project_root=$(git rev-parse --show-toplevel)
hostname=$1
privileged=$2
hosts_file=$project_root/test/ci_hosts
image_name="image"
ssh_user="galaxy_ssh"


function exit_on_failure {
  if [ $? -ne 0 ]
  then
    echo "Error when executing playbook"
    exit 1
  fi
}

echo "Build docker image with ssh access"
docker build -t $image_name $project_root/test/docker/$hostname
CONTAINER_NAME=`docker run --cap-add=NET_ADMIN -d -v /var/run/docker.sock:/var/run/docker.sock $image_name`
CONTAINER_IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $CONTAINER_NAME`

echo "Make sure private key has right permissions"
chmod 600 $project_root/test/docker/$hostname/files/$ssh_user

echo "Create ansible hosts file"
echo "[test]" > $hosts_file
echo "$hostname ansible_host=$CONTAINER_IP ansible_user=$ssh_user \
ansible_ssh_private_key_file=$project_root/test/docker/$hostname/files/$ssh_user" >> $hosts_file
echo "[all:vars]" >> $hosts_file
echo "ansible_connection=ssh" >> $hosts_file
echo 'ansible_ssh_extra_args="-o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"' >> $hosts_file

echo "Run playbook to install prerequisites"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=install_prerequisites \
galaxy_docker_create_user_ssh_keys=true"
exit_on_failure

echo "Run playbook to install galaxy on standalone VM\'s"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=install_galaxy \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

# This step has already run with a provision container.
# Run again on the production container.
echo "Run playbook to install tools and genomes"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=['install_tools','install_genomes'] \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to install LDAP"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=enable_ldap \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to set up database backup cron jobs"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=cron_database_backup \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "create directories for database operations"
for host in ('ubuntu-16.04' 'centos-7' 'cluster-test')
do
  mkdir -p $project_root/test/CI/files/$host
done

echo "Run playbook to extract database"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=database_extract \
galaxy_docker_extract_database_dir=$project_root/test/CI/files/{{inventory_hostname}} \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to import database"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=database_import \
galaxy_docker_import_db_dir=$project_root/test/CI/files/{{inventory_hostname}} \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Remove database directories"
rm -f $project_root/test/CI/files/$host

echo "Run playbook for the test upgrade"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=upgrade_test \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the deletion of test upgrade"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=delete_upgrade_test \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the upgrade"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=upgrade \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the deletion of galaxy"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
galaxy_docker_container_name=galaxy_$hostname \
run=delete_galaxy_complete \
galaxy_docker_run_privileged=$privileged"
exit_on_failure
