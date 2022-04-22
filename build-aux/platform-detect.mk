## Platform Detection Variables
ifeq ($(OS),Windows_NT)
  PLATFORM ?= windows
else
  UNAME_S ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
  UNAME_M ?= $(shell uname -m | tr '[:upper:]' '[:lower:]')
  ifeq ($(UNAME_S),linux)
    PLATFORM ?= linux
  endif
  ifeq ($(UNAME_S),darwin)
    PLATFORM_VERSION=$(shell sw_vers | awk '/^ProductVersion:/ { print $2 }')
    PLATFORM_MAJOR_VERSION=$(shell echo "$(PLATFORM_VERSION)" | cut -d. -f1,2)
    # x86_64 Apple hardware often runs 32-bit kernels (see OHAI-63)
    # macOS Monterey + Apple M1 Silicon (arm64) gives empty string for this x86_64 check
    x86_64 := $(shell sysctl -n hw.optional.x86_64)
    arm64 := $(shell sysctl -n hw.optional.arm64)
    ifeq ($(x86_64),1)
      MACHINE := x86_64
      ARCH := amd64
    endif
    ifeq ($(arm64),1)
      MACHINE := arm64
      ARCH := arm64
    endif
    PLATFORM ?= darwin
  endif
  TARGET_ARCH ?= $(ARCH)
endif
