#!/bin/bash
set -eu -o pipefail

project_root=$(git rev-parse --show-toplevel)

vagrant_ubuntu=$project_root/test/vagrant/ubuntu-16.04
vagrant_centos=$project_root/test/vagrant/centos-7
vagrant_cluster_galaxy=$project_root/test/vagrant/cluster-test
vagrant_cluster=$project_root/test/vagrant/virtual-clusters/ogs-for-galaxy
vagrant_machines="$vagrant_ubuntu $vagrant_centos $vagrant_cluster $vagrant_cluster_galaxy"

privileged=$1

function exit_on_failure {
  if [ $? -ne 0 ]
  then
    echo "Error when executing playbook"
    echo "Privileged was $privileged"
    exit 1
  fi
}
echo "Destroy machines if already present"
for vagrant_machine in $vagrant_machines
do
  VAGRANT_CWD=$vagrant_machine vagrant destroy -f
done

echo "Update boxes"
for vagrant_machine in $vagrant_machines
do
  VAGRANT_CWD=$vagrant_machine vagrant box update
done

echo "Start machines"
for vagrant_machine in $vagrant_machines
do
  VAGRANT_CWD=$vagrant_machine vagrant up
done

cd $project_root

echo "Run playbook to install prerequisites"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=install_prerequisites \
galaxy_docker_create_user_ssh_keys=true \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to install galaxy on standalone VM\'s"
ansible-playbook -i test/hosts main.yml \
-e "host=test \
run=install_galaxy \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to install galaxy on cluster VM"
ansible-playbook -i test/hosts main.yml \
-e "host=cluster-test \
run=install_galaxy_cluster \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

# This step has already run with a provision container.
# Run again on the production container.
echo "Run playbook to install tools and genomes"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=['install_tools','install_genomes'] \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to install LDAP"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=enable_ldap \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to set up database backup cron jobs"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=cron_database_backup \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "create directories for database operations"
for host in ('ubuntu-16.04' 'centos-7' 'cluster-test')
do
  mkdir -p $project_root/test/CI/files/$host
done

echo "Run playbook to extract database"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=database_extract \
galaxy_docker_extract_database_dir=$project_root/test/CI/files/{{inventory_hostname}} \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook to import database"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=database_import \
galaxy_docker_import_db_dir=$project_root/test/CI/files/{{inventory_hostname}} \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Remove database directories"
rm -f $project_root/test/CI/files/$host

echo "Run playbook for the test upgrade"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=upgrade_test \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the deletion of test upgrade"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=delete_upgrade_test \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the upgrade"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=upgrade \
galaxy_docker_run_privileged=$privileged"
exit_on_failure

echo "Run playbook for the deletion of galaxy"
ansible-playbook -i test/hosts main.yml \
-e "host=['test','cluster-test'] \
run=delete_galaxy_complete \
galaxy_docker_run_privileged=$privileged"
exit_on_failure
