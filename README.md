*This project has been created as part of the 42 curriculum by mkokorev*

## Description

Inception is a 42 school project that consists of setting up a small
infrastructure composed of different services using Docker and Docker Compose,
all running inside a Virtual Machine.

The infrastructure includes:
- **NGINX** — reverse proxy with TLSv1.2/TLSv1.3 only, sole entry point on port 443
- **WordPress + php-fpm** — CMS running without nginx
- **MariaDB** — database for WordPress

## Instructions

### Requirements
- Docker & Docker Compose installed
- Domain `mkokorev.42.fr` pointing to `127.0.0.1` in `/etc/hosts`
- A `.env` file inside `srcs/` with the required environment variables

### Setup

Add to `/etc/hosts`:
```
127.0.0.1 mkokorev.42.fr
```

Create `srcs/.env` with:
```
DOMAIN_NAME=mkokorev.42.fr
LOGIN=mkokorev
DB_NAME=wordpress
DB_USER=wp_user
DB_PASS=yourpassword
DB_HOST=mariadb
WP_ADMIN_USER=mkokorev
WP_ADMIN_PASS=yourpassword
WP_ADMIN_EMAIL=mkokorev@student.42.fr
WP_USER=editor
WP_USER_PASS=yourpassword
WP_USER_EMAIL=editor@student.42.fr
MARIADB_DATABASE=wordpress
MARIADB_USER=wp_user
MARIADB_PASSWORD=yourpassword
MARIADB_ROOT_PASSWORD=yourrootpassword
```

### Run
```bash
make build   # build and start all containers
make logs    # follow logs
make down    # stop containers
make re      # rebuild everything
make fclean  # remove all docker resources
```

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)

### AI Usage
GitHub Copilot was used to assist with:
- Debugging Git submodule and permission issues
- Writing and reviewing shell entrypoint scripts
- Reviewing project requirements compliance

## Project Description

### Virtual Machines vs Docker
VMs emulate full hardware with their own OS kernel — heavy but fully isolated.
Docker containers share the host kernel — lightweight, fast, but less isolated.

### Secrets vs Environment Variables
Environment variables are convenient but visible in `docker inspect`.
Docker secrets are mounted as files inside containers, never exposed in env or logs — more secure for production.

### Docker Network vs Host Network
Docker network (`bridge`) isolates containers in their own virtual network.
Host network shares the host's network stack — faster but no isolation, forbidden in this project.

### Docker Volumes vs Bind Mounts
Named volumes are managed by Docker, portable and recommended for databases.
Bind mounts link a host directory directly — useful for development but less portable.
This project uses named volumes with bind-mount device paths to `/home/mkokorev/data`.
