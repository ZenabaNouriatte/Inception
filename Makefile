NAME=inception

all: build up

build:
	sudo mkdir -p /home/zmogne/data/mariadb
	sudo mkdir -p /home/zmogne/data/wordpress
	sudo chmod 777 /home/zmogne/data/mariadb
	sudo chmod 777 /home/zmogne/data/wordpress
	sudo docker compose -f srcs/docker-compose.yml --env-file srcs/.env build

up:
	sudo docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d

down:
	sudo docker compose -f srcs/docker-compose.yml --env-file srcs/.env down

clean: down
	sudo docker system prune -af --volumes

fclean: clean
	sudo rm -rf /home/zmogne/data/mariadb
	sudo rm -rf /home/zmogne/data/wordpress
	sudo docker volume rm mariadb wordpress || true
	sudo docker network rm inception || true

re: down build up

