# Makefile for Agent-Notify

.PHONY: test install clean lint help

# Run the test suite
test:
	@echo "Running tests..."
	@./scripts/run_tests.sh

# Install locally for development
install:
	@echo "Installing agent-notify locally..."
	@chmod +x bin/agent-notify
	@mkdir -p $(HOME)/.local/bin
	@ln -sf $(PWD)/bin/agent-notify $(HOME)/.local/bin/agent-notify
	@ln -sf $(PWD)/bin/agent-notify $(HOME)/.local/bin/an
	@ln -sf $(PWD)/bin/agent-notify $(HOME)/.local/bin/anp
	@echo "Installed. Make sure $(HOME)/.local/bin is in your PATH"

# Uninstall local installation
uninstall:
	@echo "Removing local installation..."
	@rm -f $(HOME)/.local/bin/agent-notify
	@rm -f $(HOME)/.local/bin/an
	@rm -f $(HOME)/.local/bin/anp
	@echo "Uninstalled."

# Clean up backup files and caches
clean:
	@echo "Cleaning up..."
	@rm -rf $(HOME)/.config/agent-notify/backups/*
	@echo "Cleaned."

# Basic shell script linting (requires shellcheck)
lint:
	@echo "Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck bin/agent-notify lib/agent-notify/**/*.sh; \
	else \
		echo "shellcheck not installed. Install with: brew install shellcheck"; \
		exit 1; \
	fi

# Show help
help:
	@echo "Agent-Notify Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  test      - Run the test suite"
	@echo "  install   - Install locally for development"
	@echo "  uninstall - Remove local installation"
	@echo "  clean     - Clean up backup files"
	@echo "  lint      - Run shellcheck on scripts"
	@echo "  help      - Show this help message"
