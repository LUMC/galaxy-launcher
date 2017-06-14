# galaxy-docker-ansible

## What is galaxy-docker-ansible?
Galaxy-docker-ansible is an ansible playbook directory containing all the roles to install the
 [bgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable)
image on an ubuntu server.

## Why galaxy-docker-ansible?
Using the docker-galaxy-stable image simplifies running a galaxy server. However the container must be set-up using the exact settings you want. Doing this from the command line is cumbersome, and using a script is not scalable.

Galaxy-docker-ansible uses the power of ansible to set up a galaxy instance using the docker-galaxy-stable image. It allows you to set all the necessary variables and start the galaxy instance with just one command.
