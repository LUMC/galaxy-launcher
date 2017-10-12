# Known issues

## Deprecation warnings

The following warning is caused by the [jdauphant.nginx](https://github.com/jdauphant/ansible-role-nginx) role.
```
[DEPRECATION WARNING]: The use of 'include' for tasks has been deprecated.
```
The change from `include:` to `include_tasks` and `import_tasks` has been made in 2.4. As soon as [jdauphant.nginx](https://github.com/jdauphant/ansible-role-nginx) is updated to reflect this change the dependency in galaxy-docker-ansible will be changed as well.

## host_vars and group_vars are ignored.
If you have been using an older version of galaxy-docker-ansible these variables would be stored as .settings files. By default ansible only reads YAML and JSON-type files. The fact that it would read files with other extensions as well was a bug that was fixed in ansible >= 2.3.1.

The solution is to rename \*.settings files to \*.yml files.
