#!/bin/bash
set -eu -o pipefail

project_root=$(git rev-parse --show-toplevel)
hostname=$1
privileged=$2
hosts_file=$project_root/test/ci_hosts
image_name="image"
ssh_user="galaxy_ssh"
verbosity=""

export_volume="$project_root/test/CI/files/$hostname"
export_folder="$export_volume/export"
vars_file=$export_volume/vars_file.yml

source $project_root/test/variables/${hostname}.sh

echo "Build docker image with ssh access"
docker build -t $image_name $project_root/test/docker/$hostname

echo "create empty test directory"

docker run -v $project_root/test/CI/files:$project_root/test/CI/files alpine \
rm -rf $export_volume
docker run -v $project_root/test/CI/files:$project_root/test/CI/files alpine \
mkdir -p $export_volume
docker run -v $project_root/test/CI/files:$project_root/test/CI/files alpine \
chmod 777 $export_volume
echo "create database operations folder."
mkdir ${export_volume}/import_db

echo "start docker container"
CONTAINER_NAME=`docker run -d \
--cap-add=NET_ADMIN \
--network=host \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${export_volume}:${export_volume} $image_name`
#CONTAINER_IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $CONTAINER_NAME`
CONTAINER_IP=127.0.0.1
sleep 15
echo "Make sure private key has right permissions"
chmod 600 $project_root/test/docker/$hostname/files/$ssh_user

echo "Create ansible hosts file"
echo "[test]" > $hosts_file
echo "$hostname \
ansible_host=$CONTAINER_IP \
ansible_user=$ssh_user \
ansible_port=8822 \
ansible_ssh_private_key_file=$project_root/test/docker/$hostname/files/$ssh_user" >> $hosts_file
echo "[all:vars]" >> $hosts_file
echo 'ansible_ssh_extra_args="-o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"' >> $hosts_file

echo "create vars file"
echo "$ansible_playbook_extra_settings" > $vars_file

if [[ -v TRAVIS ]]
then
  echo "Changing ansible temp directories for travis"
  echo $'remote_tmp     = /tmp/$USER/.ansible \nlocal_tmp     = /tmp/$USER/.ansible' >> $project_root/ansible.cfg
fi

echo "Run playbook to install prerequisites"
ansible-playbook -i $hosts_file main.yml \
-e "host=$hostname \
run=install_prerequisites \
galaxy_docker_create_user_ssh_keys=true \
galaxy_docker_prerequisites_startup_service=false" \
--extra-vars @$vars_file $verbosity

echo "Run playbook run commands"
for run_command in $ansible_playbook_run_commands
do
  echo "Running: ${run_command}"
  ansible-playbook -i $hosts_file main.yml \
  -e "host=$hostname \
  run=${run_command} \
  galaxy_docker_run_privileged=$privileged" \
  --extra-vars @$vars_file $verbosity
done

echo "Remove directories"
docker run -v $project_root/test/CI/files:$project_root/test/CI/files alpine \
rm -rf $export_volume
