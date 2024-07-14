## Place this file in your code repo,
## then include it in your main Makefile and run:
##     make stylish
## to install .uncommon-build as a submodule
.PHONY: stylish
stylish: ## no-help
ifeq (,$(wildcard .uncommon-build))
	@echo -e "\033[44m🔍\033[0m \033[0;36m... Looking for .uncommon-build ... \033[0m" >&2
	@echo -e "\033[0;101m👀\033[0;31m .uncommon-build is curiously missing... 🧐 installing submodule\033[0m" >&2
	@git submodule add https://github.com/LyraPhase/uncommon-build.git .uncommon-build >&2
	@echo -e "\033[0;101m✍️ \033[0;\033[0;31m Committing '.uncommon-build' and '.gitmodules'\033[0m" >&2
	git add .uncommon-build .gitmodules && \
	  git commit -m 'uncommon-build install: Installing .uncommon-build as a submodule'
else
	@# Ensure `.uncommon-build` is updated and committed in .gitmodules
	@echo -e "\033[46m✨\033[0;\033[0;96m Updating '.uncommon-build' and '.gitmodules'\033[0m" >&2
	git submodule update --init .uncommon-build >&2
endif
	@[ -d .uncommon-build ] && echo -e "\033[47m🤵‍♂️\033[0m \033[1;92m.uncommon-build is now installed!\033[0m" \
	  || echo -e "\033[41m🤦\033[0m\033[1;91m .uncommon-build installation had issues!\033[0m" >&2
	@echo -e "\033[44m🔍\033[0m \033[0;36m... Looking for single-colon clean target in Makefile ... \033[0m" >&2
	@clean_rules="$$(grep -c "clean::" Makefile)";                                                               \
	  if [ "$${clean_rules}" -eq 0 ];                                                                            \
	    then                                                                                                     \
	      echo -e "\033[40m🫧\033[0;\033[0;96m 'clean:' your colon! 👉 'clean::'\033[0m" >&2;                    \
	      sed -i '' -e "s/^clean:\([^:]*.*\)/clean::\1/" Makefile;                                               \
	      echo -e "\033[0;101m✍️ \033[0;\033[0;31m Committing 'Makefile' with double-colon clean:: \033[0m" >&2; \
	      git add Makefile;                                                                                      \
	      git commit -m "uncommon-build install: Convert single-colon clean: to double-colon clean:: rule";      \
	    fi;

ifneq ("$(wildcard .uncommon-build/main.mk)","")
include .uncommon-build/main.mk
endif
