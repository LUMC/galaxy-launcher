# Developer documentation

## galaxy-launcher structure
galaxy-launcher consists of multiple files and directories. Each with
their own function.

* A `docs/` folder which contains the documentation. The documentation is automatically created using mkdocs. The structure is defined in `mkdocs.yml`.
* A `main.yml` that is the main playbook for running galaxy-launcher.
* A `files/` folder that contains the files to customize the galaxy instances
* A `host_vars/` and a `group_vars` folder to contain the variables for each galaxy instance.
* A `licenses/` folder that contains the project's licenses
* A `run/` folder that contains the yaml files needed for running galaxy-launcher
* A `test/` folder containing the tests.
* A `roles/` folder containing the roles where the action happens.

It contains some other files such as:

* `.git*` files for git functionality
* `.yamllint.yml` specifies the yamllint settings.
* `.travis.yml` and `tox.ini` for the tests.
* `ansible.cfg` configuration for ansible.
* `hosts.sample` example hosts file.
* `requirements.yml` with ansible role dependencies.
