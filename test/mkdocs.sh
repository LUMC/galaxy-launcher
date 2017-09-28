#!/bin/bash
set -eu
set -o pipefail

echo "Test if mkdocs documentation can be build."
mkdocs build -s --clean
