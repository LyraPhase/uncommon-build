PKGS     = $(or $(PKG),$(shell env GO111MODULE=on $(GO) list ./...))
TESTPKGS = $(shell env GO111MODULE=on $(GO) list -f \
            '{{ if or .TestGoFiles .XTestGoFiles }}{{ .ImportPath }}{{ end }}' \
            $(PKGS))

TEST_TARGETS := test-default test-bench test-short test-verbose test-race
test-bench:   ARGS=-run=__absolutelynothing__ -bench=. ## Run all go test benchmarks without tests
test-short:   ARGS=-short ## Run go test with '-short'. Tells long-running tests to shorten their run time.
test-verbose: ARGS=-v ## Run go test with '-v' verbose mode
test-race:    ARGS=-race ## Run go test with '-race' to enable data race detection.
$(TEST_TARGETS): test
check test tests: fmt lint
	go test -timeout $(TEST_TIMEOUT)s $(ARGS) $(TESTPKGS)
