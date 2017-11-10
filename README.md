# ![Galaxy-launcher logo](docs/logo/galaxy-launcher-transparant-small.png "Launch your Galaxy!")galaxy-launcher

Please read our documentation at: http://galaxy-launcher.readthedocs.io/

## What is galaxy-launcher?
galaxy-launcher is an ansible playbook directory containing all the roles to install the
 [bgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable)
image on a server running docker.

It also contains a installdocker role to install docker on a Ubuntu or CentOS server.

## Why galaxy-launcher?
Using the docker-galaxy-stable image simplifies running a galaxy server.
However the container must be set-up using the exact settings you want.
Doing this from the command line is cumbersome, and using a script is not scalable.

galaxy-launcher uses the power of ansible to set up a galaxy instance using
the docker-galaxy-stable image. It allows you to set all the necessary variables
and start the galaxy instance with just two commands.

## Features
* Complete deployment of a galaxy instance with just two commands.
* Configuration in easy to understand yaml files.
* Use the example host files to quickly get started
* Use the cluster example host to get the image running on your cluster
* Install prerequisites including docker on a Ubuntu or CentOS server
* Automatic provisioning
* The galaxy docker container is restarted on reboot of the system
* Running the deployment script as a non-privileged user (root required for prerequisites script)

## Report issues
Issues can be reported to our [github issue tracker](https://github.com/LUMC/galaxy-launcher/issues).
Please check our known issues page first.

## License
galaxy-launcher is free software available under the MIT License (Expat License).
Check the license chapter in our documentation for more details.
