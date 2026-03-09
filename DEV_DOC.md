# Developer Documentation

## Setting Up the Environment from Scratch

### Prerequisites
- A Linux machine or VM (Debian/Ubuntu recommended)
- Docker Engine installed: https://docs.docker.com/engine/install/
- Docker Compose v2 (included with Docker Desktop or installable via `apt`)
- `make` installed (`apt install make`)

### 1. Clone the repository
```bash
git clone https://github.com/tghnx1/Inception42.git
cd Inception42
```

### 2. Configure `/etc/hosts`
```bash
echo "127.0.0.1 mkokorev.42.fr" | sudo tee -a /etc/hosts
```

### 3. Create the `.env` file
Create `srcs/.env` with the following variables:
```env
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

### 4. Create data directories
```bash
mkdir -p /home/mkokorev/data/wordpress
mkdir -p /home/mkokorev/data/mariadb
```

---

## Building and Launching the Project

```bash
make build    # Build images and start all containers
make down     # Stop and remove containers
make re       # Full rebuild: down + fclean + build
make fclean   # Remove all containers, images, volumes, networks
make logs     # Tail logs from all services
```

Internally, `make build` runs:
```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

---

## Managing Containers and Volumes

### Useful container commands

| Command | Description |
|---|---|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers including stopped |
| `docker exec -it <name> bash` | Open shell in a container |
| `docker logs <name>` | View logs |
| `docker logs -f <name>` | Follow live logs |
| `docker restart <name>` | Restart a container |
| `docker stop <name>` | Stop a container |
| `docker rm <name>` | Remove a stopped container |

### Useful volume commands

| Command | Description |
|---|---|
| `docker volume ls` | List all volumes |
| `docker volume inspect wp-volume` | Inspect WordPress volume |
| `docker volume inspect db-volume` | Inspect MariaDB volume |
| `docker volume rm wp-volume db-volume` | Remove volumes (data will be lost!) |

### Useful compose commands
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml restart wordpress
docker compose -f srcs/docker-compose.yml down -v   # also removes volumes
```

---

## Data Persistence

### Where data is stored

Data is stored in named Docker volumes with bind-mount device paths on the host:

| Volume | Host Path | Description |
|---|---|---|
| `wp-volume` | `/home/mkokorev/data/wordpress` | WordPress web files |
| `db-volume` | `/home/mkokorev/data/mariadb` | MariaDB database files |

### How it persists

Docker named volumes persist data across container restarts and full rebuilds (`make re`). Data is only lost when volumes are explicitly removed:
```bash
make fclean           # removes volumes via docker compose down -v
docker volume rm ...  # manual removal
```

### Inspecting stored data
```bash
ls /home/mkokorev/data/wordpress   # WordPress web files
ls /home/mkokorev/data/mariadb     # MariaDB data files
```