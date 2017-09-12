addldap
=========

This role does the following things.
- Add an auth_conf.xml file in the config folder
- installs the ldap module in the galaxy virtual environment
- restarts galaxy services in the container.

The template used currently only works for active directory.
Requirements
------------

This role depends on the galaxy instance properly set up using the galaxy-docker-ansible
scripts. 

Role Variables
--------------

galaxy_docker_ldap_settings is a variable that is set by the user. galaxy_docker_ldap_defaults is in the role. These are merged (with defaults overwritten)
in ldap. ldap is a dictionary with the following keys:

###Default keys

Key | Function | Default
---|---|---
login_use_username | Whether username is used. If `False` e-mail is used | True
allow_password_change | Whether users can change their password | False
allow_register | Whether users can register their own accounts. This bypasses ldap authentication. | False
auto_register | Users are automatically registered at first succesfull authentication to the LDAP server | True
continue_on_failure |  login despite authentication module failures | False
email_suffix | The e-mail - suffix  (@example.com). All users with such an address will be passed to the ldap server. If "" all users will be passed to the ldap server | ""

### Keys required by the user
Key | Function 
---|---|---
server | The ldap server. (ldap://ad.example.com)
search_base | example: dc=ad,dc=example,dc=com
search_user | example: ldapsearch
search_password | ldapsearch's password

#### Common galaxy-docker-ansible variables
Variable | Function
---|---
galaxy_docker_container_name | The name of the docker container
galaxy_docker_export_location | The export location for the galaxy container


Author Information
------------------

Copyright 2017 Sequencing Analysis Support Core - Leiden University Medical Center
Contact us at: sasc@lumc.nl 
****
