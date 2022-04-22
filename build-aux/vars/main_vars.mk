SHELL := /bin/bash

# CI sets GIT_BRANCH for us, so use this as default if not in CI
GIT_BRANCH   ?= $(shell git symbolic-ref --short HEAD)


mkfile_path  := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir  := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
# Autoconf-style vars
top_builddir := $(basename $(patsubst %/,%,$(dir $(mkfile_path))))
top_srcdir   ?= $(top_builddir)/src # Override this if your project differs

build_stamps_dir ?= $(top_builddir)/.uncommon-build-stamps

# Default targets. Override to change "uncommon named" targets (e.g. what `push`, `package`, `save-image`, etc... points to).
PACKAGE_TARGET      ?= $(build_stamps_dir)/packaged
SAVE_IMAGE_TARGET   ?= $(build_stamps_dir)/$(REPO_NAME).tar
PUSH_TARGET         ?= $(build_stamps_dir)/pushed

# Default dependencies. If your project needs to modify the dependencies for a default target, replace these values in your project's `Makefile`
PACKAGE_DEPENDENCIES              ?= Dockerfile  | $(DOCKER_CONFIG)/config.json $(build_stamps_dir)


# Docker and project vars
REGISTRY     ?= docker.io
PROJECT_NAME ?= $(project_dir)
GIT_REPOHOST ?= github.com
GIT_REPOUSER ?= $(USERNAME) # Override if it's an Org or local username doesn't match GitHub
REPO_NAME    ?= $(PROJECT_NAME)
IMAGE        ?= $(REGISTRY)/$(REPO_NAME)
GIT_COMMIT   = $(shell git rev-parse HEAD)
IMAGE_TAG    ?= :$(shell echo $(GIT_COMMIT) | cut -c1-12 | tr -d '\n \t')
# TODO: Update this image & migrate build from TravisCI to GitHub Actions
BUILD_IMAGE  ?= $(REGISTRY)/trinitronx/build-tools:alpine-3.6-b78ed5e # Build tools image for container-build target

DOCKER_CONFIG ?= $(build_stamps_dir)/docker
# Delete old docker config tout de suite. (modification time > 720 min expiry)
$(shell find $(DOCKER_CONFIG) -type f -mmin +720 -exec rm -f '{}' \; 2>/dev/null )

docker ?= docker --config $(DOCKER_CONFIG)

# DOCKER_FLAGS = args to pass to `docker run` for any `container-%` target execution.
# For example, any extra environment variables to pass along: -e FOO=bar
DOCKER_FLAGS ?=

CONTAINER_NAME         ?= $(REPO_NAME)-$(DEPLOY_TAG)
CONTAINER_SOURCE_PATH  ?= /opt/app
UNIQUE_DEPLOY_TAG      ?= $(shell TZ=UTC date +'%Y%m%dT%H%M%S')-$(shell git rev-parse --short HEAD)
PUSH_LATEST            ?= true # Tag Docker image with :latest if variable is 'true'. Default: true
CONTAINER_SOURCE_FLAGS ?= -v $(CURDIR)/:$(CONTAINER_SOURCE_PATH) -w $(CONTAINER_SOURCE_PATH)

# Commands to run before `container-%` target recipes run (executes inside the container).
CONTAINER_PRE_BUILD_COMMAND ?=

# User vars
UID        ?= $(shell id -u)
GID        ?= $(shell id -g)
USERNAME   ?= $(shell id -u -n)

# Truthiness as per GNU Make
_UNCOMMON_BUILD_TRUE := 1
_UNCOMMON_BUILD_FALSE :=
__uncommon_build_bool = $(if $(filter Y y YES yes TRUE true 1,$(1)),$(_UNCOMMON_BUILD_TRUE),$(_UNCOMMON_BUILD_FALSE))

# Normalize PUSH_LATEST to truthy value
__PUSH_LATEST_ENABLED := $(call __uncommon_build_bool,$(or $(PUSH_LATEST),$(_UNCOMMON_BUILD_FALSE)))


# Utilities in Docker images
jq  ?= $(docker) run --rm -i -u $(UID):$(GID) -e HOME -v $(HOME):$(HOME) -v $(CURDIR):/wd -w /wd stedolan/jq
yq  ?= $(docker) run --rm -i -u $(UID):$(GID) -e HOME -v $(HOME):$(HOME) -v $(CURDIR):/wd -w /wd trinitronx/y2j yq
y2j ?= $(docker) run --rm -i -u $(UID):$(GID) -e HOME -v $(HOME):$(HOME) -v $(CURDIR):/wd -w /wd trinitronx/y2j y2j
j2y ?= $(docker) run --rm -i -u $(UID):$(GID) -e HOME -v $(HOME):$(HOME) -v $(CURDIR):/wd -w /wd trinitronx/y2j j2y

# The git ref (e.g. branch, commit SHA, tag, etc..) to use when running `make update-uncommon-build`
UNCOMMON_BUILD_REF ?= origin/main
