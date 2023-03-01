SHELL := /bin/bash

DATETIME := $(shell date +%s)

## build image
.PHONY: build
build:
	docker build -t deepfacelab -f ./context/Dockerfile ./context/.
.PHONY: run
run:
	xhost +
	docker run --rm -it \
			   --ipc=host \
			   --net=host \
			   --gpus=all \
			   -e DISPLAY=$(shell echo ${DISPLAY}) \
			   -v /tmp/.X11-unix:/tmp/.X11-unix \
			   -v $(shell pwd)/workspace:/usr/local/deepfacelab/workspace  deepfacelab /bin/bash
.PHONY: ps
ps:
	docker ps --format \
	"table {{.ID}}\t{{.Status}}\t{{.Names}}"
