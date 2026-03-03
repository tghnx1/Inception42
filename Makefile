all:
	@echo "Setting up Docker data root..."
	@sudo mkdir -p /home/$(USER)/data
	@echo '{"data-root": "/home/$(USER)/data"}' | sudo tee /etc/docker/daemon.json > /dev/null
	@sudo systemctl restart docker
	@echo "Starting containers..."
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

re: down all

clean: down
	docker system prune -f

fclean: clean
	sudo rm -rf /home/$(USER)/data
	docker system prune -af

.PHONY: all down re clean fclean
