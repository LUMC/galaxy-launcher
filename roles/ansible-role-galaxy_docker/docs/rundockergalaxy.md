# Readme for rundockergalaxy role

## Function
Creates a running docker container

## Tasks
The rundockergalaxy role does the following.

1. Creates a seperate user with no sudo rights to run the docker container.
2. Copies a docker environment file based on jinja2 template to a location on the host
3. (Re)starts the container

## Variables
"" | ""
---|---
docker_user | The user without sudo rights that runs the container. (Default = Galaxy)
docker_image |The docker image that is used. The default is bgruening/galaxy-stable. This should be tagged as a best practice, for example bgruening/galaxy-stable:17.01.
docker_environment_file_location | where the environment file is stored on the host.
docker_export_location | Where the galaxy database will be exported to (Default = /home/docker_user)
docker_container_name | The name of the running container (default = galaxy)
galaxy_web_port | The port on which galaxy will be hosted. (Default 8080)
galaxy_ftp_port | (Default = 8021)
galaxy_sftp_port | (Default = 8022)
