# 'all' is the default target, runs when you just type 'make'
all:
	# @echo suppresses printing the command itself, only shows the message
	@echo "Setting up Docker data root..."

	# mkdir -p: creates directory and all parent directories if they don't exist
	# $(USER): Makefile variable that expands to the current Linux username
	@sudo mkdir -p /home/$(USER)/data

	# Sets Docker's data root to /home/$(USER)/data instead of default /var/lib/docker
	# 'tee' writes to the file AND stdout; '> /dev/null' suppresses stdout output
	@echo '{"data-root": "/home/$(USER)/data"}' | sudo tee /etc/docker/daemon.json > /dev/null

	# Restarts Docker daemon to apply the new data-root configuration from daemon.json
	@sudo systemctl restart docker

	@echo "Starting containers..."

	# docker compose: runs Docker Compose (V2 syntax, no hyphen)
	# -f srcs/docker-compose.yml: specifies the compose file path (not default location)
	# up: creates and starts all containers defined in the compose file
	# -d: detached mode — runs containers in the background (daemon)
	# --build: forces rebuild of images before starting containers
	@docker compose -f srcs/docker-compose.yml up -d --build

# 'down' stops and removes containers, networks created by 'up'
down:
	# down: stops and removes containers and networks (but NOT volumes or images)
	docker compose -f srcs/docker-compose.yml down

# 're' restarts everything: first runs 'down', then 'all'
re: down all

# 'clean' stops containers then removes unused Docker resources
clean: down
	# system prune: removes all unused containers, networks, dangling images, build cache
	# -f: force — skips the confirmation prompt (no "Are you sure?" question)
	docker system prune -f

# 'fclean' is a full reset — removes everything including persistent data
fclean: clean
	# rm -rf: remove recursively and forcefully (no errors if files don't exist)
	# Deletes all persistent volume data (MariaDB + WordPress files)
	sudo rm -rf /home/$(USER)/data

	# system prune -a: removes ALL unused images (not just dangling ones)
	# -f: force — skips the confirmation prompt
	docker system prune -af

# .PHONY: tells Make these are not real files/folders but command names
# Prevents conflict if a file named 'all', 'down', etc. exists in the directory
.PHONY: all down re clean fclean
