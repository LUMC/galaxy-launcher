# Installation


## Prerequisites
- git [installation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- ansible [installation]((http://docs.ansible.com/ansible/intro_installation.html))
  * Ansible version 2.3.0.0 is tested and required. (2.3.1.0 contains a bug that does not allow host_vars to be used)
  * The easiest way to obtain ansible is by `pip install ansible==2.3.0.0`. `libssl-dev` needs to be installed on your system before you run this.

## Setting up galaxy docker ansible
1. Clone the repository to your local computer. `git clone https://github.com/LUMC/galaxy-docker-ansible.git`
2. Install ansible requirements
  * Go to the cloned repository `cd galaxy-docker-ansible`  
  * and run `ansible-galaxy install -r requirements.yml`