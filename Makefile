# Makefile for WezTerm Configuration Tests

.PHONY: test test-unit test-integration test-coverage test-verbose help install-deps clean

# Default target
test:
	@cd tests && ./run_busted.sh

# Run only unit tests
test-unit:
	@cd tests && ./run_busted.sh --unit

# Run only integration tests
test-integration:
	@cd tests && ./run_busted.sh --integration

# Run tests with coverage
test-coverage:
	@cd tests && ./run_busted.sh --coverage

# Run tests with verbose output
test-verbose:
	@cd tests && ./run_busted.sh --verbose

# Run specific test pattern
test-pattern:
	@cd tests && ./run_busted.sh --pattern $(PATTERN)

# Install test dependencies
install-deps:
	@echo "Installing Busted and dependencies..."
	@if command -v luarocks >/dev/null 2>&1; then \
		luarocks install busted; \
		luarocks install luacov; \
	else \
		echo "❌ LuaRocks not found. Please install LuaRocks first."; \
		echo "   https://luarocks.org/"; \
		exit 1; \
	fi

# Clean test artifacts
clean:
	@echo "Cleaning test artifacts..."
	@rm -f luacov.*.out
	@rm -f luacov.report.out
	@rm -f luacov.stats.out

# Show help
help:
	@echo "WezTerm Configuration Test Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  test               Run all tests (default)"
	@echo "  test-unit          Run only unit tests"
	@echo "  test-integration   Run only integration tests"
	@echo "  test-coverage      Run tests with coverage reporting"
	@echo "  test-verbose       Run tests with verbose output"
	@echo "  test-pattern       Run tests matching PATTERN variable"
	@echo "  install-deps       Install Busted and test dependencies"
	@echo "  clean              Clean test artifacts"
	@echo "  help               Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make test-unit"
	@echo "  make test-pattern PATTERN=fn"
	@echo "  make test-coverage"
