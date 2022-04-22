# Internal GNU Make targets for uncommon-build
$(build_stamps_dir): ## no-help
	@mkdir -p $(build_stamps_dir)

.PHONY: update-uncommon-build
update-uncommon-build: ## Update to latest $(COMMON_BUILD_REF). Default: origin/master
	@echo -e "$(c_bg_black)⚙️  🔧🫲 (🌀_🔍)🫴  $(c_reset)$(c_b_cyan) Updating '.uncommon-build' and '.gitmodules'$(c_reset)" >&2
	@# Ensure `.uncommon-build` is updated and committed in .gitmodules
	cd .uncommon-build && git fetch origin && git checkout $(UNCOMMON_BUILD_REF) && git pull
	git add .uncommon-build .gitmodules && \
	  git commit -m 'Updating .uncommon-build submodule to $(shell git rev-parse $(UNCOMMON_BUILD_REF))'

.PHONY: update-uncommon-build
uninstall-uncommon-build: ## Uninstall .uncommon-build submodule
	@echo -e "$(c_bg_black)🗑️  📃🫲 (🌀_🔍)🫴  $(c_reset)$(c_b_hi_red) Uninstalling '.uncommon-build' and '.gitmodules'$(c_reset)" >&2
	git submodule deinit -f .uncommon-build
	git rm .gitmodules && \
	  git commit -m 'Uninstalling .uncommon-build submodule'
	rm -rf .git/modules/.uncommon-build/
	@echo -e "$(c_bg_black)🧙🪄💥🫠$(c_reset) $(c_hi_green)Oh... what a world, what a world$(c_reset)"

clean::
	rm -rf $(build_stamps_dir)
