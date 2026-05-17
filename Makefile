.PHONY: up down \
	portainer portainer-down \
	nginx nginx-down nginx-reload \
	mariadb mariadb-down \
	postgres postgres-down \
	redis redis-down \
	ftp-server ftp-server-down \
	nextcloud nextcloud-down

SERVICES = portainer nginx mariadb postgres redis ftp-server nextcloud

$(SERVICES):
	docker compose -f $@/docker-compose.yml up -d

$(SERVICES:%=%-down):
	docker compose -f $(patsubst %-down,%,$@)/docker-compose.yml down

up:
	for s in $(SERVICES); do docker compose -f $$s/docker-compose.yml up -d; done

down:
	for s in $(SERVICES); do docker compose -f $$s/docker-compose.yml down; done

# Special commands

nginx-reload:
	docker exec -d nginx nginx -s reload
