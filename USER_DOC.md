# User Documentation

## Overview

This project sets up a small web infrastructure using **Docker** and **Docker Compose**, running inside a Virtual Machine. It provides the following services:

| Service | Description |
|---|---|
| **NGINX** | Reverse proxy — the sole entry point on port 443 (HTTPS only, TLSv1.2/TLSv1.3) |
| **WordPress + php-fpm** | Content Management System (CMS) accessible via the browser |
| **MariaDB** | Database backend for WordPress |

---

## Starting and Stopping the Project

All operations are managed via `make` commands run from the root of the repository.

### Start the project
```bash
make build
```
This builds all Docker images and starts all containers.

### Stop the project
```bash
make down
```
This stops and removes all running containers.

### Rebuild everything from scratch
```bash
make re
```
This stops containers, removes resources, and rebuilds everything.

### Remove all Docker resources
```bash
make fclean
```
This removes all containers, images, volumes, and networks created by the project.

### Follow live logs
```bash
make logs
```

---

## Accessing the Website and Administration Panel

### Prerequisites

Make sure the following line is present in your `/etc/hosts` file:
```
127.0.0.1 mkokorev.42.fr
```

### Website
Open your browser and navigate to:
```
https://mkokorev.42.fr
```

> **Note:** Your browser may show a security warning because the SSL certificate is self-signed. You can safely proceed past this warning.

### WordPress Administration Panel
```
https://mkokorev.42.fr/wp-admin
```

---

## Credentials

All credentials are configured via the `srcs/.env` file. Below are the relevant variables:

| Variable | Description |
|---|---|
| `WP_ADMIN_USER` | WordPress admin username |
| `WP_ADMIN_PASS` | WordPress admin password |
| `WP_ADMIN_EMAIL` | WordPress admin email |
| `WP_USER` | WordPress editor username |
| `WP_USER_PASS` | WordPress editor password |
| `DB_USER` | MariaDB user for WordPress |
| `DB_PASS` | MariaDB password for WordPress user |
| `MARIADB_ROOT_PASSWORD` | MariaDB root password |

---

## Checking That Services Are Running Correctly

### Check container status
```bash
docker ps
```
All three containers (`ngnix`, `wordpress`, `mariadb`) should show a status of `Up`.

### Check logs for a specific service
```bash
docker logs ngnix
docker logs wordpress
docker logs mariadb
```

### Test NGINX (HTTPS entry point)
```bash
curl -k https://mkokorev.42.fr
```
You should receive an HTML response from the WordPress site.

### Test MariaDB connectivity
```bash
docker exec -it mariadb mysqladmin ping -h localhost -uroot -p
```
Expected output: `mysqld is alive`

### Test WordPress PHP-FPM
```bash
docker exec -it wordpress nc -z localhost 9000 && echo "PHP-FPM OK"
```