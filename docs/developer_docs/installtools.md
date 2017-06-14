# installtools role

## Function

Installs tools into a galaxy instance using the web api.

## How it works

You specify the api key and the tool lists. The script is assumed to be run on the server that runs galaxy so Localhost is assumed to be the galaxy instance.
The role:
1. Makes sure the ephemeris pip package is installed.
2. Creates the working directory that you specified (default = /tmp/galaxy_tool_lists)
4. Moves the tool lists to the working directory
5. Makes a list of the files to be installed.
7. Uses ephemeris shed installer to install tools from the list.
8. Removes yaml files from the directory

## Variables

variable | function | default
--|--|--
galaxy_web_port | the port to connect to on localhost | 8080
galaxy_docker_tool_dir | Location where yaml files are temporarily stored | /tmp/galaxy_tool_lists
tool_list_dir | The tool lists directory on the ansible control host | "{{playbook_dir}}/files/{{inventory_hostname}}/tools"
galaxy_docker_ephemeris_package | The pip package name of ephemeris | ephemeris
galaxy_docker_ephemeris_version | ephemeris version | 0.6.2
galaxy_master_api_key | the api key used to install tools | user-defined
