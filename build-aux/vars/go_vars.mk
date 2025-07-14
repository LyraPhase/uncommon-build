# If your GoLang project uses go.mod,
#   set BINARY_NAME to the last module path component
# Else, set it to PROJECT_NAME from main_vars.mk or your overridden value
ifeq (,$(wildcard $(top_builddir)/go.mod))
BINARY_NAME ?= $(shell grep module go.mod | sed -e 's/module \(.*\)\/\(.*\)$$/\2/')
else
BINARY_NAME ?= $(PROJECT_NAME)
endif

# Default targets. Override to change "uncommon named" targets (e.g. what `build` etc... points to).
BUILD_TARGET ?= $(build_stamps_dir)/built

# Default dependencies. If your project needs to modify the dependencies for a default target, replace these values in your project's `Makefile`
PACKAGE_DEPENDENCIES ?= $(BIN) Dockerfile | $(DOCKER_CONFIG)/config.json

TEST_GO    ?= $(build_stamps_dir)/test-report.txt
TEST_XUNIT ?= $(build_stamps_dir)/test-report.xml

BUILD_IMAGE ?= $(REGISTRY)/golang:alpine3.15


GOLANG_REPO           ?= $(GIT_REPOHOST)/$(GIT_REPOUSER)/$(REPO_NAME)
CONTAINER_SOURCE_PATH ?= /go/src/$(GOLANG_REPO)

all_src_dirs = $(shell find $(top_srcdir)/ -type d)

MOCK_DIRS  ?= $(shell find $(top_srcdir) -iname '*.go' -exec grep -l 'package mock' '{}'  \; | xargs -0 -n1 -I{} bash -c 'basename "$$(dirname "{}")"')
TEST_DATA  ?= testdata
TEST_FILES ?= $(foreach d,$(all_src_dirs),$(wildcard $(d)/*_test.go))
TEST_DEPENDENCIES ?= $(shell find . -type f -name '*.go') $(MOCK_DIRS) | $(build_stamps_dir)

GO_DEPENDENCIES ?= go.sum

TEST_TIMEOUT ?= 30s

## Explicitly export GoLang vars down to go commands
# General-purpose variables
export GO111MODULE GCCGO GOARCH GOBIN GOCACHE GOMODCACHE GODEBUG GOENV GOFLAGS \
       GOINSECURE GOOS GOPATH GOPROXY GOPRIVATE GONOPROXY GONOSUMDB GOROOT \
       GOSUMDB GOTMPDIR GOVCS GOWORK
# Cgo variables
export AR CC CGO_ENABLED CGO_CFLAGS CGO_CFLAGS_ALLOW CGO_CFLAGS_DISALLOW \
       CGO_CPPFLAGS CGO_CPPFLAGS_ALLOW CGO_CPPFLAGS_DISALLOW CGO_CXXFLAGS \
       CGO_CXXFLAGS_ALLOW CGO_CXXFLAGS_DISALLOW CGO_FFLAGS CGO_FFLAGS_ALLOW \
       CGO_FFLAGS_DISALLOW CGO_LDFLAGS CGO_LDFLAGS_ALLOW CGO_LDFLAGS_DISALLOW \
       CXX FC PKG_CONFIG
# Architecture-specific variables
export GOARM GO386 GOAMD64 GOMIPS GOMIPS64 GOPPC64 GOWASM

# Special-purpose variables
export GCCGOTOOLDIR GOEXPERIMENT GOROOT_FINAL GO_EXTLINK_ENABLED \
       GIT_ALLOW_PROTOCOL
