#!/bin/bash
set -eu
set -o pipefail

project_root=$(git rev-parse --show-toplevel)


# Excluded files contain !unsafe tag which causes ansible-lint to crash.
# Issue has been filed https://github.com/willthames/ansible-lint/issues/291
excluded_files="
--exclude=$project_root/roles/galaxy-docker/tasks/delete/delete_export_folder.yml
--exclude=$project_root/roles/galaxy-docker/tasks/prepare_docker/create_export_directory_folders.yml
--exclude=$project_root/roles/galaxy-docker/tasks/start_container/install_python_dependencies.yml
--exclude=$project_root/roles/galaxy-docker/tasks/prepare_docker/change_uids.yml
"

echo "Check for ansible best practices using ansible-lint"
for lint_files in $project_root/roles/galaxy-docker $project_root/roles/installdocker $project_root/main.yml $project_root/test/dynamic_includes.yml
do
  ansible-lint -p $excluded_files $lint_files
done
