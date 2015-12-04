###========================================================================
### Author(s): Leandro Ostera       <leandro@ostera.io>
###========================================================================
.PHONY: all build publish cluster cluster-build cluster-up master-shell \
				node-shell stats build-latest publish-latest

##=========================================================================
## Settings
##=========================================================================

REGISTRY   := local 
PROJECT    := riak-node

COMPOSE_CMD = docker-compose
COMPOSE     = $(shell docker-compose version >/dev/null 2>&1 && echo "${COMPOSE_CMD}" || echo "sudo ${COMPOSE_CMD}")

DOCKER_CMD  = docker
DOCKER      = $(shell docker info >/dev/null 2>&1 && echo "${DOCKER_CMD}" || echo "sudo ${DOCKER_CMD}")


GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null)
GIT_COMMIT := $(shell git rev-parse --short HEAD 2> /dev/null)

VERSION     := $(GIT_BRANCH)-git$(GIT_COMMIT)
TAG         := $(REGISTRY)/$(PROJECT):$(VERSION)
LATEST_TAG  := $(REGISTRY)/$(PROJECT):latest

# Riak command defaults
NODE ?= riak_master
CMD  ?= /bin/bash

##=========================================================================
## Targets
##=========================================================================

all:
	$(COMPOSE) kill
	$(COMPOSE) rm -f
	$(COMPOSE) build --no-cache
	$(COMPOSE) up

stats:
	$(DOCKER) stats --no-stream `$(DOCKER) ps | grep ago | awk '{ print $$NF }' | xargs`

exec:
	$(DOCKER) exec -t -i $(NODE) /bin/sh -c "$(CMD)"

cluster: cluster-down cluster-build cluster-up

cluster-up:
	$(COMPOSE) scale master=1 node=3

logs:
	$(COMPOSE) logs

cluster-down:
	$(COMPOSE) kill
	$(COMPOSE) rm -f

cluster-build:
	$(COMPOSE_CMD) build

build:
	$(DOCKER) build -t $(TAG) .

build-latest:
	$(DOCKER) build -t $(LATEST_TAG) .

publish:
	$(DOCKER) push $(TAG)

publish-latest:
	$(DOCKER) push $(LATEST_TAG)
