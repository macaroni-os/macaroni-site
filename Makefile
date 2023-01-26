export HUGO_VERSION?=0.110.0
export HUGO_PLATFORM?=Linux-64bit

export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := all

.PHONY: build
build:
	scripts/build.sh

.PHONY: serve
serve:
	scripts/serve.sh

.PHONY: publish
publish:
	scripts/publish.sh

.PHONY: all
all:
	@echo "Available commands:"
	@echo "build       Build site"
	@echo "publish     Publush site on gh-pages"
	@echo "serve       Test site locally"
