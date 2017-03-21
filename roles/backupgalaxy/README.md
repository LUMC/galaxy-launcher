# Readme for backupgalaxy role

## Function
This is a very simple role that copies the docker export location to a location 
elsewhere using rsync.
Archiving is possible but only using ansible>=2.3. The latest stable release is 2.2

## Tasks
1. Installs the rsync program
2. Creates the specified backup location
3a. Synchronizes the export folder to the backup location or
3b. Compresses the export folder. This functionality is available from ansible 2.3

## Variables
"Variable" | "Function"
---|---
method | 'rsync' copies the files to a remote folder. 'archive' compresses the files into an archive
backup_location | location to store backup
backup_name | The name of the archive or rsync folder
prefix | a prefix can be added to the name
postfix | a postfix can be added to the name (i.e. daily, weekly)
compression_format | only for "archive" data is archived using this compression format. (available formats: gz, bzip2, zip)
rsync_compression_level | this compresses the data to minimize traffic over a remote connection. Since the folder is copied to localhost there is no need to set it other than 0

