mkfile_path  := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir  := $(notdir $(patsubst %/,%,$(dir $(realpath $(mkfile_path)/../))))
# Autoconf-style vars
top_builddir := $(basename $(patsubst %/,%,$(dir $(mkfile_path))))
top_srcdir   ?= $(top_builddir)/src # Override this if your project differs
build_aux    := $(top_builddir)/.uncommon-build/build-aux

# Include platform detection & main vars
include $(build_aux)/platform-detect.mk
include $(build_aux)/vars/main_vars.mk
include $(build_aux)/vars/ansicolor_vars.mk
include $(build_aux)/vars/emoji_vars.mk

# Language Specific includes
ifeq (go,$(PROJECT_LANG))
include $(build_aux)/vars/go_vars.mk
include $(build_aux)/go/multi-platform.mk
include $(build_aux)/go/lint.mk
include $(build_aux)/go/test.mk
endif

# Commonly uncommon targets
include $(build_aux)/uncommon-targets.mk
include $(build_aux)/help.mk
