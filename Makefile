NAME=inception

all: build up

build:
	sudo mkdir -p $(HOME)/data/mariadb
	sudo mkdir -p $(HOME)/data/wordpress
	sudo chmod 777 $(HOME)/data/mariadb
	sudo chmod 777 $(HOME)/data/wordpress
	sudo docker compose -f srcs/docker-compose.yml --env-file .env build

up:
	sudo docker compose -f srcs/docker-compose.yml --env-file .env up -d

down:
	sudo docker compose -f srcs/docker-compose.yml --env-file .env down

clean: down
	sudo docker system prune -af --volumes

fclean: clean
	sudo rm -rf $(HOME)/data/mariadb
	sudo rm -rf $(HOME)/data/wordpress
	- sudo docker volume rm mariadb wordpress

re: down build up

