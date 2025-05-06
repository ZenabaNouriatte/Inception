NAME=inception

all: build up

build:
	docker-compose -f docker-compose.yml --env-file .env build

up:
	docker-compose -f docker-compose.yml --env-file .env up -d

down:
	docker-compose -f docker-compose.yml --env-file .env down

clean: down
	docker system prune -af --volumes

fclean: clean
	docker volume rm $(NAME)_wordpress $(NAME)_mariadb || true
	docker network rm $(NAME) || true

re: fclean all

