#_# test
#_#   Run integration tests
#_#
.PHONY: test
test:
	@rm -f tests/output
	@sh tests/run 2>&1 > tests/output
	@diff tests/output tests/expected
