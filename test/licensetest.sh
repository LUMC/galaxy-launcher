#!/bin/bash
set -eu -o pipefail

project_root=$(git rev-parse --show-toplevel)

echo "install modified ansible"
git clone \
--recursive \
https://github.com/rhpvorderman/ansible-role-license-changer.git \
$project_root/roles/license-changer

pip install -e $project_root/roles/license-changer/ansible
ansible --version

echo "check if licenses are "
ansible-playbook $project_root/licenses/license_change.yml \
-e "license_changer_check_mode=true"
