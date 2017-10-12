#!/bin/bash
set -eu
set -o pipefail

project_root=$(git rev-parse --show-toplevel)

echo "Fetching all project YAML file names from git."
project_yamls=$(git ls-files | grep  -E ".*\.ya?ml$")
echo "Test all project YAML files."
yamllint -f parsable -c $project_root/.yamllint.yml $project_yamls
