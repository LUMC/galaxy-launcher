#!/bin/bash

ansible_playbook_extra_settings="\
galaxy_docker_container_name: galaxy_${hostname}
galaxy_docker_extract_database_dir: ${export_volume}/import_db/
galaxy_docker_import_db_dir: ${export_volume}/import_db/
galaxy_docker_export_location: ${export_folder}
galaxy_docker_web_port_public: 8081
galaxy_docker_web_port: 8080
galaxy_docker_ansible_generated_vars_dir: ${export_volume}
galaxy_docker_empty_database_script: ${export_volume}/new_empty_db
galaxy_docker_imported_db_location: ${export_volume}/database/
galaxy_docker_upgrade_test_settings:
  galaxy_docker_docker_image: 'bgruening/galaxy-stable:18.05'
  galaxy_docker_container_name: test_upgrade_galaxy
  galaxy_docker_export_location: ${export_volume}/test_upgrade
  galaxy_docker_ufw_profile: test_upgrade_galaxy
  galaxy_docker_web_port: 8888
  galaxy_docker_web_port_public: 8880
  galaxy_docker_sftp_port: 8823
  galaxy_brand: Test upgrade of Galaxy to 18.05
"
ansible_playbook_run_commands="\
install_galaxy \
enable_ldap \
extract_database \
import_database \
upgrade_test \
delete_upgrade_test \
upgrade \
cron_database_backup \
['install_tools','install_genomes'] \
patch_image \
delete_galaxy_complete \
"
