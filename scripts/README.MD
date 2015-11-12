Wordpress static generator bash scripts

Scripts that are handling rewrites and uploads of the static code generated in Wordpress using really-static


## Make www-data run bash scripts - if needed, as root

### C wrapped bash scripts that will be ran as root by www-data

1. modify script path / parameter in wrapper.c
2. compile with gcc - gcc wrapper.c -o wrap-static-static-update
3. set permissions chmod u=rwx,go=xr,+s

### Allow the user www-data to have the same permissions as root

--