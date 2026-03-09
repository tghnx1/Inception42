name = Inception

all:
	@printf "Launch configuration ${name}...\n"
	@if ! grep -q "mkokorev.42.fr" /etc/hosts; then \
		echo "127.0.0.1 mkokorev.42.fr www.mkokorev.42.fr" | tee -a /etc/hosts; \
	fi
	@if ! grep -q "data-root" /etc/docker/daemon.json 2>/dev/null; then \
		echo '{"data-root": "/home/mkokorev/data"}' | sudo tee /etc/docker/daemon.json; \
		sudo systemctl restart docker; \
	fi
	@docker compose -f srcs/docker-compose.yml up -d

build:
	@printf "Building configuration ${name}...\n"
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker compose -f srcs/docker-compose.yml down

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker compose -f srcs/docker-compose.yml up -d --build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune --force

fclean:
	@printf "Total clean of all docker resources\n"
	@docker ps -qa | xargs -r docker stop
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force

logs:
	@docker compose -f srcs/docker-compose.yml logs -f

ps:
	@docker compose -f srcs/docker-compose.yml ps

.PHONY: all build down re clean fclean logs ps

