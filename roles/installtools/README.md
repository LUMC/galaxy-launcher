# installtools role

## Function

Installs tools into a galaxy instance using the web api.

## How it works

You specify the api key and the tool lists. The script is assumed to be run on the server that runs galaxy so Localhost is assumed to be the galaxy instance.
The role:
1. Makes sure the bioblend pip package is installed.
2. Creates the working directory that you specified (default = /tmp/galaxy_tool_lists)
3. Checks whether this directory does not contain other yaml files
4. Moves the tool lists to the working directory
5. Makes a list of the files to be installed (all yaml files in the directory)
6. Copies shed_install.py, the ephemeris shed installer, to the working directory
7. Uses ephemeris shed installer to install tools from the list.
8. Removes yaml files and shed_install.py from the directory

## Variables
galaxy_web_port, the port on which the http server is hosted. Defaults to 80
work_dir, the directory on the server where the tool lists will be temporarily stored. Defaults to /tmp/galaxy_tool_lists
tool_list_dir, the directory that contains the tool lists. Subdirectories will not be scanned.

