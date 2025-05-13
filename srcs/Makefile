NAME=inception

all: build up

build:
	sudo docker compose -f docker-compose.yml --env-file .env build

up:
	sudo docker compose -f docker-compose.yml --env-file .env up -d

down:
	sudo docker compose -f docker-compose.yml --env-file .env down

clean: down
	sudo docker compose down -v
	sudo docker system prune -af --volumes

fclean: clean
	sudo rm -rf /home/zmogne/data/mariadb/*
	sudo rm -rf /home/zmogne/data/wordpress/*
	sudo docker volume rm mariadb wordpress || true
	sudo docker network rm inception || true

re: fclean all

