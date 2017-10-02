#!/bin/bash
set -eu -o pipefail

project_root=$(git rev-parse --show-toplevel)
image_name="image"
ssh_user="galaxy_ssh"
hosts_file=$project_root/test/ci_hosts
hostname=$1

docker build -t $image_name $project_root/test/docker/$hostname
CONTAINER_NAME=`docker run -d -v /var/run/docker.sock:/var/run/docker.sock $image_name`
CONTAINER_IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $CONTAINER_NAME`

echo "[test]" > $hosts_file
echo "$hostname ansible_host=$CONTAINER_IP ansible_user=$ssh_user \
ansible_ssh_private_key_file=$project_root/test/docker/$hostname/files/$ssh_user" >> $hosts_file
echo "[all:vars]" >> $hosts_file
echo "ansible_connection=ssh" >> $hosts_file
echo 'ansible_ssh_extra_args="-o IdentitiesOnly=yes -o StrictHostKeyChecking=no UserKnownHostsFile=/dev/null"' >> $hosts_file
