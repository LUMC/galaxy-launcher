#!/bin/bash

echo "Create directory for cluster config script"
script_dir=${project_root}/test/CI/files/$hostname/setup
mkdir -p $script_dir

echo "create config script"
galaxy_hostname=galaxy-docker
galaxy_ip=172.17.0.3 #Very ugly. But the container IP needs to be guessed.
echo "
#!/bin/bash
echo $galaxy_ip $galaxy_hostname >> /etc/hosts
su sgeadmin
qconf -as $galaxy_hostname
" > $script_dir/setup.sh
chmod 775  $script_dir/setup.sh

echo "start cluster container"
cluster_image_name=cluster
docker build -t $cluster_image_name $project_root/test/docker/gridengine-cluster
CLUSTER_ID=`docker run -d -v ${script_dir}:/scripts --volumes-from $CONTAINER_NAME $cluster_image_name`
CLUSTER_IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $CLUSTER_ID`
CLUSTER_NAME=`docker exec $CLUSTER_ID cat /etc/hostname`
sleep 15
docker exec $CLUSTER_ID bash /scripts/setup.sh

ansible_playbook_extra_settings="\
galaxy_docker_container_name: galaxy_${hostname}
galaxy_docker_extract_database_dir: ${export_volume}/import_db/
galaxy_docker_import_db_dir: ${export_volume}/import_db/
galaxy_docker_shared_cluster_directory: ${export_folder}
galaxy_docker_web_port_public: 8081
galaxy_docker_web_port: 8080
galaxy_docker_ansible_generated_vars_dir: ${export_volume}
galaxy_docker_empty_database_script: ${export_volume}/new_empty_db
galaxy_docker_imported_db_location: ${export_volume}/database/
galaxy_docker_container_hostname: $galaxy_hostname
galaxy_docker_upgrade_test_settings:
  galaxy_docker_docker_image: 'cluster-galaxy-stable:18.05'
  galaxy_docker_container_name: test_upgrade_galaxy
  galaxy_docker_shared_cluster_directory: ${export_volume}/test_upgrade
  galaxy_docker_ufw_profile: test_upgrade_galaxy
  galaxy_docker_web_port: 8888
  galaxy_docker_web_port_public: 8880
  galaxy_docker_sftp_port: 8823
  galaxy_brand: Test upgrade of Galaxy to 18.05

galaxy_docker_cluster_sge_parallel_environment: batch
galaxy_docker_gridengine_master_host: $CLUSTER_NAME
galaxy_docker_custom_image_lines:
  - run sed -i '3iecho \"$CLUSTER_IP $CLUSTER_NAME\" >> /etc/hosts' /usr/bin/startup
bgruening_galaxy_stable_version: 18.05
"
ansible_playbook_run_commands="\
install_galaxy_cluster \
upgrade_cluster \
patch_custom_image \
"
