# Installation


## Prerequisites
- Ansible. ([installation manual]((http://docs.ansible.com/ansible/intro_installation.html))
  * Ansible version 2.4.0.0 is tested and required.
  * The easiest way to obtain ansible is by `pip install ansible==2.4.0.0`. `libssl-dev` needs to be installed on your system before you run this.

## Setting up galaxy-launcher
1. Clone the git repository. `git clone --recursive https://github.com/LUMC/galaxy-launcher.git`
2. Checkout the version of galaxy-launcher you want to use. For example `git checkout v1.0.0` or `git checkout develop`.
3. Make sure all submodules are up to date with `git submodule update --init --recursive`
