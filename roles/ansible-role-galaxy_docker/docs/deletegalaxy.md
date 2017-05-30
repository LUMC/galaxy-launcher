# Deletegalaxy role

## Function
This role deletes the galaxy instance created using the settings from galaxydocker.config

## Tasks
1. Removes the docker container
2. Removes the docker export folder when delete_files = True
3. Removes the firewall port exception
4. Removes the firewall profile

## Variables
Same as the rundockergalaxy and galaxyfirewall role.
