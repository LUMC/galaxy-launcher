# installdocker role

## Function
Installs docker on an Ubuntu machine. Prerequisites are recorded in the vars section.

## Tasks

1. Installs docker prerequisites using the package manager
2. Installs required pip packages using pip
3. Installs the docker repository and adds the key
4. Symlinks /var/lib/docker to docker_default_location. 
5. Installs docker packages
## Variables
docker_default_location is the location where the images are stored and run. By default this is /var/lib/docker. But you can specify another path if this is required (if another partition or disk is needed)
