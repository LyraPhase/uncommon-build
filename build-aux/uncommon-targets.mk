# Internal GNU Make targets for uncommon-build
$(build_stamps_dir): ## no-help
	@mkdir -p $(build_stamps_dir)

.PHONY: update-uncommon-build
update-uncommon-build: ## Update to latest $(COMMON_BUILD_REF). Default: origin/master
	@echo "$(c_red)Updating '.uncommon-build' and '.gitmodules'$(c_reset)" >&2
	@# Ensure `.uncommon-build` is updated and committed in .gitmodules
	cd .uncommon-build && git fetch origin && git checkout $(UNCOMMON_BUILD_REF) && git pull
	git add .uncommon-build .gitmodules && \
	  echo git commit -m 'Updating .uncommon-build submodule to $(shell git rev-parse $(UNCOMMON_BUILD_REF))'

clean::
	rm -rf $(build_stamps_dir)
