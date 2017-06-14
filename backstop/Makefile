.PHONY: backstop

# Node module variables
BACKSTOP_JS=./node_modules/.bin/backstop

# Runs visual regression testing
backstop:
	@$(BACKSTOP_JS) reference
	@$(BACKSTOP_JS) test
