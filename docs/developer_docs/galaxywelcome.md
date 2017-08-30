Role Name
=========

This role copies the welcome.* files in the docker export folder

Requirements
------------

Role Variables
--------------

variable | description | default
---|---|---
docker_export_location | The location where all galaxy files and the database is stored |
welcome_dir | the directory containing the welcome files. | {{playbook_dir}}/ files/{{inventory_hostname}}/welcome.html

Dependencies
------------

galaxy_docker_export location is used. This variable is used in allmost all roles in galaxy-docker-ansible

Example Playbook
----------------

License
-------
Copyright 2017 Sequence Analysis Support Core - Leiden University Medical Center

Author Information
------------------
Contact us at: sasc@lumc.nl
