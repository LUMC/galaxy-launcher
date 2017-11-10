# Installation


## Prerequisites
- Ansible. ([installation manual]((http://docs.ansible.com/ansible/intro_installation.html))
  * Ansible version 2.4.0.0 is tested and required.
  * The easiest way to obtain ansible is by `pip install ansible==2.4.0.0`. `libssl-dev` needs to be installed on your system before you run this.

## Setting up galaxy-launcher
1. Obtain galaxy-launcher from the [releases page](https://github.com/LUMC/galaxy-launcher/releases).
  - If you want to use the development version you can clone the git repository. `git clone --recursive https://github.com/LUMC/galaxy-launcher.git`
2. Unpack the release archive.
3. Install ansible requirements
  * Go to the galaxy-launcher directory `cd galaxy-launcher`  
  * and run `ansible-galaxy install -r requirements.yml`
