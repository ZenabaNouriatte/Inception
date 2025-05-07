NAME=inception

all: build up

build:
	sudo docker compose -f docker-compose.yml --env-file .env build

up:
	sudo docker compose -f docker-compose.yml --env-file .env up -d

down:
	sudo docker compose -f docker-compose.yml --env-file .env down

clean: down
	sudo docker system prune -af --volumes

fclean: clean
	sudo docker volume rm $(NAME)_wordpress $(NAME)_mariadb || true
	sudo docker network rm $(NAME) || true

re: fclean all

