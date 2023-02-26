THIS_FILE := $(lastword $(MAKEFILE_LIST))
# ENVFILE := .env
SHELL := /bin/bash

DATETIME := $(shell date +%s)

.PHONY: help
help:
	make -pRrq -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
## build all images using the docker-compose.yml file and BUILDKit
## uses cache
.PHONY: build-deepfacelab-nvidia-dev build-deepfacelab-nvidia-prod
build-deepfacelab-nvidia-dev:
	docker build -t slayerus/deepfacelab:nvidia-1.0 --target deepfacelab-nvidia --build-arg CACHEBUST=${DATETIME} -f ./context/Dockerfile ./context/.
build-deepfacelab-nvidia-prod:
	docker build -t slayerus/deepfacelab:nvidia-1.0 --target deepfacelab-nvidia -f ./context/Dockerfile ./context/.
#	docker push slayerus/deepfacelab:nvidia-1.0

.PHONY: clean
clean:
	docker-compose -f docker-compose.yml down --volumes --rmi all --remove-orphans
	docker-compose -f docker-compose.yml rm -v --force
## removes everything created by docker-compose and prunes everything in docker
## (!!) this includes all your work with docker, not just stuff (--remove-orphans Remove containers for services not defined in the Compose file)
.PHONY: purge-deepfacelab-nvidia
purge-deepfacelab-nvidia:
	docker-compose -f docker-compose.yml down --volumes --rmi all --remove-orphans
	docker-compose -f docker-compose.yml rm -v --force
	yes | docker system prune --all --volumes --force
#Operate
# .PHONY: up-deepfacelab-nvidia
# up-deepfacelab-nvidia:
# 	docker-compose -f docker-compose.yml up -d $(c)

# .PHONY: start-deepfacelab-nvidia
# start-deepfacelab-nvidia:
# 	docker-compose -f docker-compose.yml start $(c)

# .PHONY: stop-deepfacelab-nvidia
# stop-deepfacelab-nvidia:
# 	docker-compose -f docker-compose.yml stop $(c)

.PHONY: run-deepfacelab-nvidia
run-deepfacelab-nvidia:
	docker-compose run deepfacelab

# .PHONY: down-deepfacelab-nvidia
# down-deepfacelab-nvidia:
# 	docker-compose -f docker-compose.yml down $(c)

.PHONY: destroy
destroy:
	docker-compose -f docker-compose.yml -f docker-compose.yml down -v $(c)


# .PHONY:
# restart:
# 	docker-compose -f docker-compose.yml stop $(c)
# 	docker-compose -f docker-compose.yml up -d $(c)

.PHONY: ps
ps:
	docker ps --format \
	"table {{.ID}}\t{{.Status}}\t{{.Names}}"
# #Logs
# .PHONY: logs-dev logs-dev-slave logs-prod logs-prod-slave logs-ws logs-db-master logs-db-slave
# logs-dev:
# 	docker-compose -f docker-compose.yml logs --tail=100 -f $(c)
# logs-dev-slave:
# 	docker-compose -f docker-compose.slave.dev.yml logs --tail=100 -f $(c)
# logs-prod:
# 	docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs --tail=100 -f $(c)
# logs-prod-slave:
# 	docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.slave.prod.yml logs --tail=100 -f $(c)
# logs-ws:
# 	docker-compose -f docker-compose.yml logs --tail=100 -f server1c-ws
# logs-db-master:
# 	docker-compose -f docker-compose.yml logs --tail=100 -f server1c-db
# logs-db-slave:
# 	docker-compose -f docker-compose.slave.dev.yml logs --tail=100 -f $(c)
# logs-backup:
# 	docker-compose -f docker-compose.backup.yml logs --tail=100 -f server1c-db-backup
# #Login to containers
# .PHONY: login-server1c login-ws login-db-master login-dev-db-slave login-prod-db-slave db-master-shell
# login-server1c:
# 	docker-compose -f docker-compose.yml exec server1c /bin/bash
# login-ws:
# 	docker-compose -f docker-compose.yml exec server1c-ws /bin/bash
# login-db-master:
# 	docker-compose -f docker-compose.yml exec server1c-db /bin/bash
# login-dev-db-slave:
# 	docker-compose -f docker-compose.slave.dev.yml exec dev-db-slave /bin/bash
# login-prod-db-slave:
# 	docker-compose -f docker-compose.slave.prod.yml exec prod-db-slave /bin/bash
# db-master-shell:
# 	docker-compose -f docker-compose.yml exec server1c-db psql -U postgres

