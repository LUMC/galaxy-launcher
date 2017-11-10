# structure

This role follows the default [role directory structure](http://docs.ansible.com/ansible/latest/playbooks_reuse_roles.html#role-directory-structure).

# Tasks and subtasks.
The tasks folder has several subfolders, which in turn have subfolders. This is to separate every task into subtasks.

In `tasks/main.yml` all the tasks are listed. Each task has an `import_task:`
statement which points to the task yaml.

## Determining which tasks are run
Each task has  a `when:` statement. This `when:`
statement is used to run certain tasks. By default all tasks are not run. The
`run/` directory in galaxy-launcher's root contains yaml files that
specify which tasks should be run for a certain 'command.'

## Selecting the user that runs a task
Each task has the following block of code:
```yaml
- name: The task
  import_tasks: the_task/main.yml
  when: galaxy_docker_the_task
  become: "{{galaxy_docker_become}}"
  become_user: "{{galaxy_docker_USER_user}}"
  vars:
    ansible_user: "{{galaxy_docker_USER_ssh_user}}"
    ansible_ssh_private_key_file: "{{galaxy_docker_USER_user_private_key}}"
```
Where 'USER' is the user that should run the specific task. This is a verbose
way of determining the user. But that has to do with user privileges.

### User privileges
By default the playbook is run by a user that has root access. A simple
`become_user:` statement should be sufficient to run a task as a user.
However, galaxy-launcher can be run in two modes:
* Privileged mode (default). Connecting user is a sudo user and can do everything.
* Non-privileged mode. For each task ansible connects as a different user. Each user has only the privileges needed to execute the tasks it does.

There are three users in non-privileged mode.
* A docker user, that has docker rights and starts the container.
* A database user, that runs the database in the container, and therefore also creates files in the export folder.
* A web user, that runs the galaxy instance, and is also the user to submit jobs on the cluster).

Non-privileged mode was required for operating galaxy-launcher on our
cluster. Our Galaxy VM had our cluster filesystem mounted and was integrated
with the cluster LDAP. This meant that a root user on the VM could potentially
destroy the cluster filesystem when a typo was made. Therefore ssh key pairs
where set up for each of the three users so the playbook could be run without
connecting as a sudo user.

NOTE: The prerequisites is always run as root even in non-privileged mode.
If all prerequisites are already present, the rest of galaxy-launcher
can be run without root privileges.

NOTE2: All non-prerequisites are run as non-privileged users. Even in
privileged mode. In privileged mode the connecting user becomes the user
that runs the task using sudo. In non-privileged mode ansible connects as
the non-privileged user directly.

## The tasks

### prerequisites
This task installs all the required packages, sets up users, sets up nginx, and sets up a firewall.

### Prepare docker
Run by the docker user. This contains tasks to build a custom docker image and
to populate the export folder.

### Template galaxy settings.
Run by the galaxy web user. This contains tasks to template settings in to the export folder.

### Provision
Uses the ephemeris installer to install tools and genomes.

The provision tasks may start up a provision container when a production
container is not yet running. This container populates the export folder with
tools and genomes but makes sure that galaxy is not exposed to the web or
intranet during this stage.

There is also a task to import a database into galaxy. Useful for restoring
database backups.

### Start container.
Yamls needed to start the container. Also contains task to install missing
python dependencies in the container.

### Upgrade
Tasks for upgrading the database.

### backup
Tasks for extracting the database and a task that creates a cron job to
regularly backup the database.

### delete
Tasks files for deleting the galaxy docker container and the export folder.
